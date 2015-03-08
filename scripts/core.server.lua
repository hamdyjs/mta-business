-- Business System v1.2 - core.server.lua - Core client code of the resource
-- Copyright (C) 2012-2015, JR10
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
			local bMarker = Marker(pos[1], pos[2], pos[3], "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4]);
			bMarker.interior = pos[4];
			bMarker.dimension = pos[5];
			if (settings["business.blip"] ~= false) then
				if (sqlRow["bOwner"] == "For Sale") then
					local bBlip = Blip.createAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
					bBlip.interior = pos[4];
					bBlip.dimension = pos[5];
				else
					local bBlip = Blip.createAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
					bBlip.interior = pos[4];
					bBlip.dimension = pos[5];
				end
			end
			addEventHandler("onMarkerHit", bMarker, onBusinessMarkerHit);
			addEventHandler("onMarkerLeave", bMarker, onBusinessMarkerLeave);
			local timer = Timer(businessPayout, sqlRow["bPayoutCurTime"] , 1, bMarker);
			bMarker:setData("bData", {sqlRow["bID"], sqlRow["bName"], sqlRow["bOwner"], sqlRow["bCost"], sqlRow["bPayout"], sqlRow["bPayoutTime"], sqlRow["bPayoutOTime"], sqlRow["bPayoutUnit"], sqlRow["bBank"], timer});
		end
	end
end

addCommandHandler("business", function(player)
	if (ACL.hasObjectPermissionTo(player, "function.banPlayer")) then
		triggerClientEvent(player, "client:showCreateBusinessGUI", player);
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

addEvent("server:createBusiness", true);
addEventHandler("server:createBusiness", root, function(posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
	database:query(dbCreateBusinessCallback,  {posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit}, "SELECT * FROM business");
end);

function dbCreateBusinessCallback(query_handle, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
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

		local bMarker = Marker(posX, posY, posZ, "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4]);
		bMarker.interior = interior;
		bMarker.dimension = dimension;
		if (settings["business.blip"] ~= false) then
			local bBlip = Blip.createAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0);
			bBlip.interior = interior;
			bBlip.dimension = dimension;
		end
		local timer = Timer(businessPayout, payoutTime * unit , 1, bMarker);
		bMarker:setData("bData", {id, name, "For Sale", cost, payout, payoutTime * unit, payoutTime, payoutUnit, 0, timer});
		addEventHandler("onMarkerHit", bMarker, onBusinessMarkerHit);
		addEventHandler("onMarkerLeave", bMarker, onBusinessMarkerLeave);
		if (#tostring(id) == 1) then id = "0".. tostring(id) end
		source:outputMessage("Business: Business(ID #"..id..") has been created successfully", 0, 255, 0);
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

function businessPayout(bMarker)
	local bData = bMarker:getData("bData");
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
	timer = Timer(businessPayout, payoutTime, 1, bMarker);
	bMarker:setData("bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
end

addEventHandler("onResourceStop", resourceRoot, function()
	for index, bMarker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		local bData = bMarker:getData("bData");
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
	for index, bMarker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		if (player:isInMarker(bMarker)) then
			local bData = bMarker:getData("bData");
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
			triggerClientEvent(player, "client:showBusinessGUI", player, bMarker, getAccountName(getPlayerAccount(player)) == owner, ACL.hasObjectPermissionTo(player, "function.banPlayer"));
			break;
		end
	end
end

function Ped:getMarker()
	for index, bMarker in ipairs(Element.getAllByType("marker", resourceRoot)) do
		if (self:isInMarker(bMarker)) then
			return bMarker;
		end
	end
end

addEvent("server:onActionAttempt", true);
addEventHandler("server:onActionAttempt", root, function(action, text)
	local account = source.account;
	if (not account or account:isGuest()) then return; end
	if (action == "Buy") then
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (owner ~= "For Sale") then
			source:outputMessage("Business: This business is owned", 255, 0, 0);
			return;
		end
		database:query(dbBuyBusinessCallback, {source, bMarker, id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer}, "SELECT * FROM business WHERE bOwner = ?", account.name);
	elseif (action == "Sell") then
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (owner ~= account.name) then
			if (ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
				database:exec("UPDATE business SET bOwner = ? WHERE bID = ?", "For Sale", id);
				triggerClientEvent(source, "client:onAction", source, true, true);
				bMarker:setData("bData", {id, name, "For Sale", cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
				source:outputMessage("Business: You have successfully sold this business", 0, 255, 0);
				return;
			else
				source:outputMessage("Business: You are not the owner of this business", 255, 0, 0);
				return;
			end
		end
		database:exec("UPDATE business SET bOwner = ?, bBank = ? WHERE bID = ?", "For Sale", 0, id);
		source:giveMoney(tonumber(("%.f"):format(cost / 2)));
		source:giveMoney(bank);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, "For Sale", cost, payout, payoutTime, payoutOTime, payoutUnit, 0});
		source:outputMessage("Business: You have successfully sold this business, all the money in the bank have been paid to you.", 0, 255, 0);
	elseif (action == "Deposit") then
		if (tonumber(text) == nil) then
			source:outputMessage("Business: Invalid value", 255, 0, 0);
			return;
		end
		text = tonumber(text);
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (owner ~= account.name) then
			source:outputMessage("Business: You are not the owner of this business", 255, 0, 0);
			return;
		end
		if (source.money < text) then
			source:outputMessage("Business: You don't have enough money", 255, 0, 0);
			return;
		end
		database:exec("UPDATE business SET bBank = ? WHERE bID = ?", bank + text, id);
		source:takeMoney(text);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank + text, timer});
		source:outputMessage("Business: You have successfully deposited $"..text.." to the business", 0, 255, 0);
	elseif (action == "Withdraw") then
		if (tonumber(text) == nil) then
			source:outputMessage("Business: Invalid value", 255, 0, 0);
			return;
		end
		text = tonumber(text);
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (owner ~= account.name) then
			source:outputMessage("Business: You are not the owner of the business", 255, 0, 0);
			return;
		end
		if (bank < text) then
			source:outputMessage("Business: You don't have that much in the business bank", 255, 0, 0);
			return;
		end
		database:exec("UPDATE business SET bBank = ? WHERE bID = ?", bank - text, id);
		source:giveMoney(text);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank - text, timer});
		source:outputMessage("Business: You have successfully withdrew $"..text.." from the business", 0, 255, 0);
	elseif (action == "SName") then
		if (text == "" or #text > 30) then
			source:outputMessage("Business: Invalid value", 255, 0, 0);
			return;
		end
		if (not ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
			source:outputMessage("Business: You don't have access to do that", 255, 0, 0);
			return;
		end
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		database:exec("UPDATE business SET bName = ? WHERE bID = ?", text, id);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, text, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
		source:outputMessage("Business: You have successfully renamed the business", 0, 255, 0);
	elseif (action == "SOwner") then
		if (not ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
			source:outputMessage("Business: You don't have access to do that", 255, 0, 0);
			return;
		end
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		database:exec("UPDATE business SET bOwner = ? WHERE bID = ?", text, id);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, text, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
		source:outputMessage("Business: You have successfully changed the business owner", 0, 255, 0);
	elseif (action == "SCost") then
		if (tonumber(text) == nil) then
			source:outputMessage("Business: Invalid value", 255, 0, 0);
			return;
		end
		text = tonumber(text);
		if (not ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
			source:outputMessage("Business: You don't have access to do that", 255, 0, 0);
			return;
		end
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		database:exec("UPDATE business SET bCost = ? WHERE bID = ?", text, id);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, owner, text, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
		source:outputMessage("Business: You have successfully changed the business cost", 0, 255, 0);
	elseif (action == "SBank") then
		if (tonumber(text) == nil) then
			source:outputMessage("Business: Invalid value", 255, 0, 0);
			return;
		end
		text = tonumber(text);
		if (not ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
			source:outputMessage("Business: You don't have access to do that", 255, 0, 0);
			return;
		end
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		database:exec("UPDATE business SET bBank = ? WHERE bID = ?", text, id);
		triggerClientEvent(source, "client:onAction", source, true, true);
		bMarker:setData("bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, text, timer});
		source:outputMessage("Business: You have successfully changed the business bank amount", 0, 255, 0);
	elseif (action == "Destroy") then
		if (not ACL.hasObjectPermissionTo(source, "function.banPlayer")) then
			source:outputMessage("Business: You don't have access to do that", 255, 0, 0);
			return;
		end
		local bMarker = source:getMarker();
		if (not bMarker) then return; end
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		if (timer and timer:isValid()) then timer:destroy() end
		database:exec("DELETE FROM business WHERE bID = ?", id);
		bMarker:destroyAttachedBlips();
		bMarker:destroy();
		triggerClientEvent(source, "client:onAction", source, true, true);
		source:outputMessage("Business: You have successfully destroyed the business", 0, 255, 0);
		triggerClientEvent(source, "client:hideInstructions", source);
		database:query(dbReOrderBusinessesCallback,  "SELECT * FROM business");
	end
end);

function dbBuyBusinessCallback(query_handle, source, bMarker, id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer)
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
	triggerClientEvent(source, "client:onAction", source, true, true);
	bMarker:setData("bData", {id, name, source.account.name, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
end

function dbReOrderBusinessesCallback(query_handle)
	local sql = query_handle:poll(0);
	if (sql and #sql > 0) then
		for index, sqlRow in ipairs(sql) do
			database:exec("UPDATE business SET bID = ? WHERE bID = ?", index, sqlRow["bID"]);
		end
		for index, bMarker in ipairs(Element.getAllByType("marker", resourceRoot)) do
			database:query(dbUpdateBusinessesIDsCallback, {bMarker, index}, "SELECT bID FROM business WHERE bID = ?", index);
		end
	end
end

function dbUpdateBusinessesIDsCallback(query_handle, bMarker, index)
	local sql = query_handle:poll(0);
	local bData = bMarker:getData("bData");
	local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
	bMarker:setData("bData", {index, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer});
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
