local settings = get("");
if (settings["business.key"]:len() < 1 or settings["business.key"]:len() > 1) then
	settings["business.key"] = "N";
end
if (not settings["business.blip"] or tonumber(settings["business.blip"]) == nil) then
	settings["business.blip"] = false;
end

addEventHandler("onResourceStart", resourceRoot, function()
	database = Connection("sqlite", "files/business.db");
	database:exec("CREATE TABLE IF NOT EXISTS business(bID INT, bName TEXT, bOwner TEXT, bCost INT, bPos TEXt, bPayout INT, bPayoutTime INT, bPayoutOTime INT, bPayoutUnit TEXT, bPayoutCurTime INT, bBank INT)");
	database:query(dbCreateBusinessesCallback,  "SELECT * FROM business");
end);

function dbCreateBusinessesCallback(query_handle)
	local sql = query_handle:poll(0);
	if (sql and #sql > 0) then
		for index, sqlRow in ipairs(sql) do
			local pos = split(sqlRow["bPos"], ",");
			local b_marker = Marker(pos[1], pos[2], pos[3], "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4]);
			b_marker.interior = pos[4];
			b_marker.dimension = pos[5];
			if (settings["business.blip"] ~= false) then
				if (sqlRow["bOwner"] == "For Sale") then
					local bBlip = Blip.createAttachedTo(b_marker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
					bBlip.interior = pos[4];
					bBlip.dimension = pos[5];
				else
					local bBlip = Blip.createAttachedTo(b_marker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
					bBlip.interior = pos[4];
					bBlip.dimension = pos[5];
				end
			end
			addEventHandler("onMarkerHit", b_marker, onBusinessMarkerHit);
			addEventHandler("onMarkerLeave", b_marker, onBusinessMarkerLeave);
			local timer = Timer(businessPayout, sqlRow["bPayoutCurTime"] , 1, b_marker);
			b_marker:setData("bData", {sqlRow["bID"], sqlRow["bName"], sqlRow["bOwner"], sqlRow["bCost"], sqlRow["bPayout"], sqlRow["bPayoutTime"], sqlRow["bPayoutOTime"], sqlRow["bPayoutUnit"], sqlRow["bBank"], timer});
		end
	end
end

addCommandHandler("business", function(player)
	if (ACL.hasObjectPermissionTo(player, "function.banPlayer")) then
		triggerClientEvent(player, "business.client.showCreateBusinessWindow", player);
	else
		player:outputMessage("Business: You don't have access to this command.", 255, 0, 0);
	end
end);

function Player:outputMessage(message, r, g, b)
	if (settings["business.infoMessagesType"] == "dx") then
		dxOutputMessage(message, self, r, g, b);
	else
		self:outputChat(message, r, g, b, true);
	end
end

function outputMessage(message, player, r, g, b)
	if (settings["business.infoMessagesType"] == "dx") then
		dxOutputMessage(message, player, r, g, b);
	else
		player:outputChat(message, r, g, b, true);
	end
end

function dxOutputMessage(message, player, r, g, b)
	triggerClientEvent(player, "client:dxOutputMessage", player, message, r, g, b);
end

addEvent("server:outputMessage", true);
addEventHandler("server:outputMessage", root, function(message, r, g, b)
	source:outputMessage(message, r, g, b);
end);

addEvent("business.server.createBusiness", true);
addEventHandler("business.server.createBusiness", root, function(posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
	database:query(dbCreateBusinessCallback,  {client, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit}, "SELECT * FROM business");
end);

function dbCreateBusinessCallback(query_handle, client, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
	local sql = query_handle:poll(0);
	if (sql) then
		local id;
		if (#sql > 0) then
			id = sql[#sql]["bID"] + 1;
		else
			id = 1;
		end
		local unit;
		if (payoutUnit == "Seconds") then
			unit = 1000;
		elseif (payoutUnit == "Minutes") then
			unit = 60000;
		elseif (payoutUnit == "Hours") then
			unit = 3600000;
		elseif (payoutUnit == "Days") then
			unit = 86400000;
		end

		posX = tonumber(posX);
		posY = tonumber(posY);
		posZ = tonumber(posZ);
		interior = tonumber(interior);
		dimension = tonumber(dimension);
		cost = tonumber(cost);
		payout = tonumber(payout);
		payoutTime = tonumber(payoutTime);

		posZ = posZ - 1;

		database:exec("INSERT INTO business(bID,bName,bOwner,bCost,bPos,bPayout,bPayoutTime,bPayoutOTime,bPayoutUnit,bPayoutCurTime,bBank) VALUES(?,?,?,?,?,?,?,?,?,?,?)", id, name, "For Sale", cost, posX..","..posY..","..posZ..","..interior..","..dimension, payout, payoutTime * unit, payoutTime, payoutUnit, payoutTime * unit, 0);

		local b_marker = Marker(posX, posY, posZ, "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4]);
		b_marker.interior = interior;
		b_marker.dimension = dimension;
		if (settings["business.blip"] ~= false) then
			local bBlip = Blip.createAttachedTo(b_marker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
			bBlip.interior = interior;
			bBlip.dimension = dimension;
		end
		local timer = Timer(businessPayout, payoutTime * unit , 1, b_marker);
		b_marker:setData("bData", {id, name, "For Sale", cost, payout, payoutTime * unit, payoutTime, payoutUnit, 0, timer});
		addEventHandler("onMarkerHit", b_marker, onBusinessMarkerHit);
		addEventHandler("onMarkerLeave", b_marker, onBusinessMarkerLeave);
		if (#tostring(id) == 1) then id = "0".. tostring(id) end
		client:outputMessage("Business: Business(ID #"..id..") has been created successfully", 0, 255, 0);
	end
end

function onBusinessMarkerHit(hElement, mDim)
	if (hElement:getType() ~= "player") then return; end
	if (hElement:isInVehicle()) then return; end
	if (not mDim) then return; end
	triggerClientEvent(hElement, "client:showInstructions", hElement);
end

function onBusinessMarkerLeave(hElement, mDim)
	if (hElement:getType() ~= "player") then return; end
	if (hElement:isInVehicle()) then return; end
	if (not mDim) then return; end
	triggerClientEvent(hElement, "client:hideInstructions", hElement);
end

function businessPayout(b_marker)
	local bData = b_marker:getData("bData");
	local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
	if (owner ~= "For Sale") then
		bank = bank + payout;
		database:exec("UPDATE business SET bBank = ? WHERE bID = ?", bank, id);
		if (settings["business.informPlayerForPayout"]) then
			local account = Account(owner);
			if (account) then
				local player = account:getPlayer();
				if (player and player.isElement) then
					player:outputMessage("Business: Business \" "..name.." \" has paid out($"..payout..")", 0, 255, 0);
				end
			end
		end
	end
	timer = Timer(businessPayout, payoutTime, 1, b_marker);
	b_marker:setData("bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
end

addEventHandler("onResourceStop", resourceRoot, function()
	for index, b_marker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		local bData = b_marker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (timer and timer:isValid()) then
			local left = timer:getDetails();
			if (left >= 50) then
				database:exec("UPDATE business SET bPayoutCurTime = ? WHERE bID = ?", left, id);
			else
				database:exec("UPDATE business SET bPayoutCurTime = ? WHERE bID = ?", payoutTime, id);
			end
		end
	end
end);

function Ped:isInMarker(marker)
	local colshape = marker.colShape;
	return self:isWithinColShape(colshape);
end

addEventHandler("onResourceStart", resourceRoot, function()
	for index, player in ipairs(Element.getAllByType("player")) do
		bindKey(player, settings["business.key"], "up", onPlayerAttemptToOpenBusiness);
	end
end);

addEventHandler("onPlayerJoin", root,function()
	bindKey(source, settings["business.key"], "up", onPlayerAttemptToOpenBusiness);
end);

function onPlayerAttemptToOpenBusiness(player)
	for index, b_marker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		if (player:isInMarker(b_marker)) then
			local bData = b_marker:getData("bData");
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
			triggerClientEvent(player, "business.client.showBusinessWindow", player, b_marker, getAccountName(getPlayerAccount(player)) == owner, ACL.hasObjectPermissionTo(player, "function.banPlayer"));
			break;
		end
	end
end

function Ped:getMarker()
	for index, b_marker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		if (self:isInMarker(b_marker)) then
			return b_marker;
		end
	end
end

addEvent("business.server.buy", true);
addEventHandler("business.server.buy", root, function()
	local account = client.account;
	if (not account or account:isGuest()) then return; end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	if (owner ~= "For Sale") then
		client:outputMessage("Business: This business is owned", 255, 0, 0);
		return;
	end
	database:query(dbBuyBusinessCallback, {client, b_marker, id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer}, "SELECT * FROM business WHERE bOwner = ?", account.name);
end);

addEvent("business.server.sell", true);
addEventHandler("business.server.sell", root, function()
	local account = client.account;
	if (not account or account:isGuest()) then return; end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	if (owner ~= account.name) then
		if (ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
			database:exec("UPDATE business SET bOwner = ? WHERE bID = ?", "For Sale", id);
			b_marker:setData("bData", {id, name, "For Sale", cost, payout, payout_time, payout_otime, payout_unit, bank, timer});
			client:outputMessage("Business: You have successfully sold this business", 0, 255, 0);
			return;
		else
			client:outputMessage("Business: You are not the owner of this business", 255, 0, 0);
			return;
		end
	end
	database:exec("UPDATE business SET bOwner = ?, bBank = ? WHERE bID = ?", "For Sale", 0, id);
	client:giveMoney(tonumber(("%.f"):format(cost / 2)));
	client:giveMoney(bank);
	b_marker:setData("bData", {id, name, "For Sale", cost, payout, payout_time, payout_otime, payout_unit, 0});
	client:outputMessage("Business: You have successfully sold this business, all the money in the bank have been paid to you.", 0, 255, 0);
end);

addEvent("business.server.deposit", true);
addEventHandler("business.server.deposit", root, function(amount)
	local account = client.account;
	if (not account or account:isGuest()) then return; end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	if (not tonumber(amount)) then client:outputMessage("Business: Invalid amount", 255, 0, 0); return; end
	if (owner ~= account.name) then
		client:outputMessage("Business: You are not the owner of this business", 255, 0, 0);
		return;
	end
	if (client.money < amount) then
		client:outputMessage("Business: You don't have enough money", 255, 0, 0);
		return;
	end
	database:exec("UPDATE business SET bBank = ? WHERE bID = ?", bank + amount, id);
	client:takeMoney(amount);
	b_marker:setData("bData", {id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank + amount, timer});
	client:outputMessage("Business: You have successfully deposited $"..amount.." to the business", 0, 255, 0);
end);

addEvent("business.server.withdraw", true);
addEventHandler("business.server.withdraw", root, function(amount)
	local account = client.account;
	if (not account or account:isGuest()) then return; end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	if (not tonumber(amount)) then client:outputMessage("Business: Invalid amount", 255, 0, 0); return; end
	if (owner ~= account.name) then
		client:outputMessage("Business: You are not the owner of the business", 255, 0, 0);
		return;
	end
	if (bank < amount) then
		client:outputMessage("Business: You don't have that much in the business bank", 255, 0, 0);
		return;
	end
	database:exec("UPDATE business SET bBank = ? WHERE bID = ?", bank - amount, id);
	client:giveMoney(amount);
	b_marker:setData("bData", {id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank - amount, timer});
	client:outputMessage("Business: You have successfully withdrew $"..amount.." from the business", 0, 255, 0);
end);

addEvent("business.server.setName", true);
addEventHandler("business.server.setName", root, function(new_name)
	if (new_name == "" or #new_name > 30) then
		client:outputMessage("Business: Invalid value", 255, 0, 0);
		return;
	end
	if (not ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
		client:outputMessage("Business: You don't have access to do that", 255, 0, 0);
		return;
	end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	database:exec("UPDATE business SET bName = ? WHERE bID = ?", new_name, id);
	b_marker:setData("bData", {id, new_name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer});
	client:outputMessage("Business: You have successfully renamed the business", 0, 255, 0);
end);

addEvent("business.server.setOwner", true);
addEventHandler("business.server.setOwner", root, function(new_owner)
	if (not ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
		client:outputMessage("Business: You don't have access to do that", 255, 0, 0);
		return;
	end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	database:exec("UPDATE business SET bOwner = ? WHERE bID = ?", new_owner, id);
	b_marker:setData("bData", {id, name, new_owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer});
	client:outputMessage("Business: You have successfully changed the business owner", 0, 255, 0);
end);

addEvent("business.server.setCost", true);
addEventHandler("business.server.setCost", root, function(amount)
	if (tonumber(amount) == nil) then
		client:outputMessage("Business: Invalid value", 255, 0, 0);
		return;
	end
	amount = tonumber(amount);
	if (not ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
		client:outputMessage("Business: You don't have access to do that", 255, 0, 0);
		return;
	end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	database:exec("UPDATE business SET bCost = ? WHERE bID = ?", amount, id);
	b_marker:setData("bData", {id, name, owner, amount, payout, payout_time, payout_otime, payout_unit, bank, timer});
	client:outputMessage("Business: You have successfully changed the business cost", 0, 255, 0);
end);

addEvent("business.server.setBank", true);
addEventHandler("business.server.setBank", root, function(amount)
	if (tonumber(amount) == nil) then
		client:outputMessage("Business: Invalid value", 255, 0, 0);
		return;
	end
	amount = tonumber(amount);
	if (not ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
		client:outputMessage("Business: You don't have access to do that", 255, 0, 0);
		return;
	end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	database:exec("UPDATE business SET bBank = ? WHERE bID = ?", amount, id);
	b_marker:setData("bData", {id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, amount, timer});
	client:outputMessage("Business: You have successfully changed the business bank amount", 0, 255, 0);
end);

addEvent("business.server.destroy", true);
addEventHandler("business.server.destroy", root, function()
	if (not ACL.hasObjectPermissionTo(client, "function.banPlayer")) then
		client:outputMessage("Business: You don't have access to do that", 255, 0, 0);
		return;
	end
	local b_marker = client:getMarker();
	if (not isElement(b_marker)) then return; end
	local b_data = b_marker:getData("bData");
	local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
	if (timer and timer:isValid()) then timer:destroy() end
	database:exec("DELETE FROM business WHERE bID = ?", id);
	b_marker:destroyAttachedBlips();
	b_marker:destroy();
	client:outputMessage("Business: You have successfully destroyed the business", 0, 255, 0);
	triggerClientEvent(client, "client:hideInstructions", client);
	database:query(dbReOrderBusinessesCallback,  "SELECT * FROM business");
end);

function dbBuyBusinessCallback(query_handle, source, b_marker, id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer)
	local sql = query_handle:poll(0);
	if (#sql == settings["business.ownedBusinesses"]) then
		source:outputMessage("Business: You already own "..#sql.." businesses which is the maximum amount", 255, 0, 0);
		return;
	end
	local money = source.money;
	if (money < cost) then source:outputMessage("Business: You don't have enough money", 255, 0, 0) return end
	database:exec("UPDATE business SET bOwner = ? WHERE bID = ?", source.account.name, id);
	source:takeMoney(cost);
	source:outputMessage("Business: You have successfully bought this business", 0, 255, 0);
	b_marker:setData("bData", {id, name, source.account.name, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
end

function dbReOrderBusinessesCallback(query_handle)
	local sql = query_handle:poll(0);
	if (sql and #sql > 0) then
		for index, sqlRow in ipairs(sql) do
			database:exec("UPDATE business SET bID = ? WHERE bID = ?", index, sqlRow["bID"]);
		end
		for index, b_marker in ipairs(Element.getAllByType("marker", resourceRoot)) do
			database:query(dbUpdateBusinessesIDsCallback, {b_marker, index}, "SELECT bID FROM business WHERE bID = ?", index);
		end
	end
end

function dbUpdateBusinessesIDsCallback(query_handle, b_marker, index)
	local sql = query_handle:poll(0);
	local bData = b_marker:getData("bData");
	local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
	b_marker:setData("bData", {index, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
end

function Element:destroyAttachedBlips()
	if (not self) then return; end
	for index, attachedElement in pairs(self:getAttachedElements()) do
		if (attachedElement and attachedElement.isElement) then
			attachedElement:destroy();
		end
	end
end

addEvent("onClientCallSettings", true);
addEventHandler("onClientCallSettings", root, function()
	triggerClientEvent(source, "onClientCallSettings", source, settings);
end);
