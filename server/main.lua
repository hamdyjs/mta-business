------------------------------------------------------------------------------------
--	PROJECT:			Business System v1.2
--	RIGHTS:				All rights reserved by developers
-- FILE:						business/server/main.lua
--	PURPOSE:			Main serverside script
--	DEVELOPERS:	JR10
------------------------------------------------------------------------------------

local settings = get("")
if settings["business.key"]:len() < 1 or settings["business.key"]:len() > 1 then
	settings["business.key"] = "N"
end
if not settings["business.blip"] or tonumber(settings["business.blip"]) == nil then
	settings["business.blip"] = false
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		database = dbConnect("sqlite", "files/database/business.db")
		dbExec(database, "CREATE TABLE IF NOT EXISTS business(bID INT, bName TEXT, bOwner TEXT, bCost INT, bPos TEXt, bPayout INT, bPayoutTime INT, bPayoutOTime INT, bPayoutUnit TEXT, bPayoutCurTime INT, bBank INT)")
		dbQuery(dbCreateBusinessesCallback, database, "SELECT * FROM business")
	end
)

function dbCreateBusinessesCallback(queryHandle)
	local sql = dbPoll(queryHandle, 0)
	if sql and #sql > 0 then
		for index, sqlRow in ipairs(sql) do
			local pos = split(sqlRow["bPos"], ",")
			local bMarker = createMarker(pos[1], pos[2], pos[3], "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4])
			setElementInterior(bMarker, pos[4])
			setElementDimension(bMarker, pos[5])
			if settings["business.blip"] ~= false then
				if sqlRow["bOwner"] == "For Sale" then
					local bBlip = createBlipAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0)
					setElementInterior(bBlip, pos[4])
					setElementDimension(bBlip, pos[5])
				else
					local bBlip = createBlipAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0)
					setElementInterior(bBlip, pos[4])
					setElementDimension(bBlip, pos[5])
				end
			end
			addEventHandler("onMarkerHit", bMarker, onBusinessMarkerHit)
			addEventHandler("onMarkerLeave", bMarker, onBusinessMarkerLeave)
			local timer = setTimer(businessPayout, sqlRow["bPayoutCurTime"] , 1, bMarker)
			setElementData(bMarker, "bData", {sqlRow["bID"], sqlRow["bName"], sqlRow["bOwner"], sqlRow["bCost"], sqlRow["bPayout"], sqlRow["bPayoutTime"], sqlRow["bPayoutOTime"], sqlRow["bPayoutUnit"], sqlRow["bBank"], timer})
		end
	end
end

addCommandHandler("business",
	function(player)
		if hasObjectPermissionTo(player, "function.banPlayer") then
			triggerClientEvent(player, "client:showCreateBusinessGUI", player)
		else
			outputMessage("Business: You don't have access to this command.", player, 255, 0, 0)
		end
	end
)

function outputMessage(message, player, r, g, b)
	if settings["business.infoMessagesType"] == "dx" then
		dxOutputMessage(message, player, r, g, b)
	else
		outputChatBox(message, player, r, g, b, true)
	end
end

function dxOutputMessage(message, player, r, g, b)
	triggerClientEvent(player, "client:dxOutputMessage", player, message, r, g, b)
end

addEvent("server:outputMessage", true)
addEventHandler("server:outputMessage", root,
	function(message, r, g, b)
		outputMessage(message, source, r, g, b)
	end
)

addEvent("server:createBusiness", true)
addEventHandler("server:createBusiness", root,
	function(posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
		dbQuery(dbCreateBusinessCallback, {posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit}, database, "SELECT * FROM business")
	end
)

function dbCreateBusinessCallback(queryHandle, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit)
	local sql = dbPoll(queryHandle, 0)
	if sql then
		local id
		if #sql > 0 then
			id = sql[#sql]["bID"] + 1
		else
			id = 1
		end
		local unit
		if payoutUnit == "Seconds" then
			unit = 1000
		elseif payoutUnit == "Minutes" then
			unit = 60000
		elseif payoutUnit == "Hours" then
			unit = 3600000
		elseif payoutUnit == "Days" then
			unit = 86400000
		end
			
		posX = tonumber(posX)
		posY = tonumber(posY)
		posZ = tonumber(posZ)
		interior = tonumber(interior)
		dimension = tonumber(dimension)
		cost = tonumber(cost)
		payout = tonumber(payout)
		payoutTime = tonumber(payoutTime)
			
		posZ = posZ - 1
				
		dbExec(database, "INSERT INTO business(bID,bName,bOwner,bCost,bPos,bPayout,bPayoutTime,bPayoutOTime,bPayoutUnit,bPayoutCurTime,bBank) VALUES(?,?,?,?,?,?,?,?,?,?,?)", id, name, "For Sale", cost, posX..","..posY..","..posZ..","..interior..","..dimension, payout, payoutTime * unit, payoutTime, payoutUnit, payoutTime * unit, 0)
			
		local bMarker = createMarker(posX, posY, posZ, "cylinder", 1.5, settings["business.markerColor"][1], settings["business.markerColor"][2], settings["business.markerColor"][3], settings["business.markerColor"][4])
		setElementInterior(bMarker, interior)
		setElementDimension(bMarker, dimension)
		if settings["business.blip"] ~= false then
			local bBlip = createBlipAttachedTo(bMarker, settings["business.blip"], 2, 255, 0, 0, 255, 0, 100.0)
			setElementInterior(bBlip, interior)
			setElementDimension(bBlip, dimension)
		end
		local timer = setTimer(businessPayout, payoutTime * unit , 1, bMarker)
		setElementData(bMarker, "bData", {id, name, "For Sale", cost, payout, payoutTime * unit, payoutTime, payoutUnit, 0, timer})
		addEventHandler("onMarkerHit", bMarker, onBusinessMarkerHit)
		addEventHandler("onMarkerLeave", bMarker, onBusinessMarkerLeave)
		if #tostring(id) == 1 then id = "0".. tostring(id) end
		outputMessage("Business: Business(ID #"..id..") has been created successfully", source, 0, 255, 0)
	end
end

function onBusinessMarkerHit(hElement, mDim)
	if getElementType(hElement) ~= "player" then return end
	if isPedInVehicle(hElement) then return end
	if not mDim then return end
	triggerClientEvent(hElement, "client:showInstructions", hElement)
end

function onBusinessMarkerLeave(hElement, mDim)
	if getElementType(hElement) ~= "player" then return end
	if isPedInVehicle(hElement) then return end
	if not mDim then return end
	triggerClientEvent(hElement, "client:hideInstructions", hElement)
end

function businessPayout(bMarker)
	local bData = getElementData(bMarker, "bData")
	local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
	if owner ~= "For Sale" then
		bank = bank + payout
		dbExec(database, "UPDATE business SET bBank = ? WHERE bID = ?", bank, id)
		if settings["business.informPlayerForPayout"] then
			local account = getAccount(owner)
			if account then
				local player = getAccountPlayer(account)
				outputMessage("Business: Business \" "..name.." \" has paid out($"..payout..")", player, 0, 255, 0)
			end
		end
	end
	timer = setTimer(businessPayout, payoutTime, 1, bMarker)
	setElementData(bMarker, "bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
end

addEventHandler("onResourceStop", resourceRoot,
	function()
		for index, bMarker in ipairs(getElementsByType("marker", resourceRoot)) do
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if isTimer(timer) then
				local left = getTimerDetails(timer)
				if left >= 50 then
					dbExec(database, "UPDATE business SET bPayoutCurTime = ? WHERE bID = ?", left, id)
				else
					dbExec(database, "UPDATE business SET bPayoutCurTime = ? WHERE bID = ?", payoutTime, id)
				end
			end
		end
	end
)

function isPedInMarker(player, marker)
	local colShape = getElementColShape(marker)
	return isElementWithinColShape(player, colShape)
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for index, player in ipairs(getElementsByType("player")) do
			bindKey(player, settings["business.key"], "up", onPlayerAttemptToOpenBusiness)
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, settings["business.key"], "up", onPlayerAttemptToOpenBusiness)
	end
)

function onPlayerAttemptToOpenBusiness(player)
	for index, bMarker in ipairs(getElementsByType("marker", resourceRoot)) do
		if isPedInMarker(player, bMarker) then
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			triggerClientEvent(player, "client:showBusinessGUI", player, bMarker, getAccountName(getPlayerAccount(player)) == owner, hasObjectPermissionTo(player, "function.banPlayer"))
			break
		end
	end
end

function getPedMarker(ped)
	for index, bMarker in ipairs(getElementsByType("marker", resourceRoot)) do
		if isPedInMarker(ped, bMarker) then
			return bMarker
		end
	end
end

addEvent("server:onActionAttempt", true)
addEventHandler("server:onActionAttempt", root,
	function(action, text)
		if action == "Buy" then
			if isGuestAccount(getPlayerAccount(source)) then
				outputMessage("Business: You are not logged in, you can't buy this business", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if owner ~= "For Sale" then
				outputMessage("Business: This business is owned", source, 255, 0, 0)
				return
			end
			dbQuery(dbBuyBusinessCallback, {source, bMarker, id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer}, database, "SELECT * FROM business WHERE bOwner = ?", getAccountName(getPlayerAccount(source)))
		elseif action == "Sell" then
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if owner ~= getAccountName(getPlayerAccount(source)) then
				if hasObjectPermissionTo(source, "function.banPlayer") then
					dbExec(database, "UPDATE business SET bOwner = ? WHERE bID = ?", "For Sale", id)
					triggerClientEvent(source, "client:onAction", source, true, true)
					setElementData(bMarker, "bData", {id, name, "For Sale", cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
					outputMessage("Business: You have successfully sold this business", source, 0, 255, 0)
					return
				else
					outputMessage("Business: You are not the owner of this business", source, 255, 0, 0)
					return
				end
			end
			dbExec(database, "UPDATE business SET bOwner = ?, bBank = ? WHERE bID = ?", "For Sale", 0, id)
			givePlayerMoney(source,("%.f") : format(cost / 2))
			givePlayerMoney(source, bank)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, "For Sale", cost, payout, payoutTime, payoutOTime, payoutUnit, 0})
			outputMessage("Business: You have successfully sold this business, all the money in the bank have been paid to you.", source, 0, 255, 0)
		elseif action == "Deposit" then
			if tonumber(text) == nil then
				outputMessage("Business: Invalid value", source, 255, 0, 0)
				return
			end
			text = tonumber(text)
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if owner ~= getAccountName(getPlayerAccount(source)) then
				outputMessage("Business: You are not the owner of this business", source, 255, 0, 0)
				return
			end
			if getPlayerMoney(source) < text then
				outputMessage("Business: You don't have enough money", source, 255, 0, 0)
				return
			end
			dbExec(database, "UPDATE business SET bBank = ? WHERE bID = ?", bank + text, id)
			takePlayerMoney(source, text)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank + text, timer})
			outputMessage("Business: You have successfully deposited $"..text.." to the business", source, 0, 255, 0)
		elseif action == "Withdraw" then
			if tonumber(text) == nil then
				outputMessage("Business: Invalid value", source, 255, 0, 0)
				return
			end
			text = tonumber(text)
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if owner ~= getAccountName(getPlayerAccount(source)) then
				outputMessage("Business: You are not the owner of the business", source, 255, 0, 0)
				return
			end
			if bank < text then
				outputMessage("Business: You don't have that much in the business bank", source, 255, 0, 0)
				return
			end
			dbExec(database, "UPDATE business SET bBank = ? WHERE bID = ?", bank - text, id)
			givePlayerMoney(source, text)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank - text, timer})
			outputMessage("Business: You have successfully withdrew $"..text.." from the business", source, 0, 255, 0)
		elseif action == "SName" then
			if text == "" or #text > 30 then
				outputMessage("Business: Invalid value", source, 255, 0, 0)
				return
			end
			if not hasObjectPermissionTo(source, "function.banPlayer") then
				outputMessage("Business: You don't have access to do that", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			dbExec(database, "UPDATE business SET bName = ? WHERE bID = ?", text, id)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, text, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
			outputMessage("Business: You have successfully renamed the business", source, 0, 255, 0)
		elseif action == "SOwner" then
			if not hasObjectPermissionTo(source, "function.banPlayer") then
				outputMessage("Business: You don't have access to do that", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			dbExec(database, "UPDATE business SET bOwner = ? WHERE bID = ?", text, id)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, text, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
			outputMessage("Business: You have successfully changed the business owner", source, 0, 255, 0)
		elseif action == "SCost" then
			if tonumber(text) == nil then
				outputMessage("Business: Invalid value", source, 255, 0, 0)
				return
			end
			text = tonumber(text)
			if not hasObjectPermissionTo(source, "function.banPlayer") then
				outputMessage("Business: You don't have access to do that", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			dbExec(database, "UPDATE business SET bCost = ? WHERE bID = ?", text, id)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, owner, text, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
			outputMessage("Business: You have successfully changed the business cost", source, 0, 255, 0)
		elseif action == "SBank" then
			if tonumber(text) == nil then
				outputMessage("Business: Invalid value", source, 255, 0, 0)
				return
			end
			text = tonumber(text)
			if not hasObjectPermissionTo(source, "function.banPlayer") then
				outputMessage("Business: You don't have access to do that", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			dbExec(database, "UPDATE business SET bBank = ? WHERE bID = ?", text, id)
			triggerClientEvent(source, "client:onAction", source, true, true)
			setElementData(bMarker, "bData", {id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, text, timer})
			outputMessage("Business: You have successfully changed the business bank amount", source, 0, 255, 0)
		elseif action == "Destroy" then
			if not hasObjectPermissionTo(source, "function.banPlayer") then
				outputMessage("Business: You don't have access to do that", source, 255, 0, 0)
				return
			end
			local bMarker = getPedMarker(source)
			if not bMarker then return end
			local bData = getElementData(bMarker, "bData")
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
			if isTimer(timer) then killTimer(timer) end
			dbExec(database, "DELETE FROM business WHERE bID = ?", id)
			destroyBlipsAttachedTo(bMarker)
			destroyElement(bMarker)
			triggerClientEvent(source, "client:onAction", source, true, true)
			outputMessage("Business: You have successfully destroyed the business", source, 0, 255, 0)
			triggerClientEvent(source, "client:hideInstructions", source)
			dbQuery(dbReOrderBusinessesCallback, database, "SELECT * FROM business")
		end
	end
)

function dbBuyBusinessCallback(queryHandle, source, bMarker, id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer)
	local sql = dbPoll(queryHandle, 0)
	if #sql == settings["business.ownedBusinesses"] then
		outputMessage("Business: You already own "..#sql.." businesses which is the maximum amount", source, 255, 0, 0)
		return
	end
	local money = getPlayerMoney(source)
	if money < cost then outputMessage("Business: You don't have enough money", source, 255, 0, 0) return end
	dbExec(database, "UPDATE business SET bOwner = ? WHERE bID = ?", getAccountName(getPlayerAccount(source)), id)
	takePlayerMoney(source, cost)
	outputMessage("Business: You have successfully bought this business", source, 0, 255, 0)
	triggerClientEvent(source, "client:onAction", source, true, true)
	setElementData(bMarker, "bData", {id, name, getAccountName(getPlayerAccount(source)), cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
end

function dbReOrderBusinessesCallback(queryHandle)
	local sql = dbPoll(queryHandle, 0)
	if sql and #sql > 0 then
		for index, sqlRow in ipairs(sql) do
			dbExec(database, "UPDATE business SET bID = ? WHERE bID = ?", index, sqlRow["bID"])
		end
		for index, bMarker in ipairs(getElementsByType("marker", resourceRoot)) do
			dbQuery(dbUpdateBusinessesIDsCallback, {bMarker, index}, database, "SELECT bID FROM business WHERE bID = ?", index)
		end
	end
end

function dbUpdateBusinessesIDsCallback(queryHandle, bMarker, index)
	local sql = dbPoll(queryHandle, 0)
	local bData = getElementData(bMarker, "bData")
	local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData)
	setElementData(bMarker, "bData", {index, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer})
end

function destroyBlipsAttachedTo(element)
	if not element then return end
	for index, attachedElement in pairs(getAttachedElements(element)) do
		if isElement(attachedElement) then
			destroyElement(attachedElement)
		end
	end
end

addEvent("onClientCallSettings", true)
addEventHandler("onClientCallSettings", root,
	function()
		triggerClientEvent(source, "onClientCallSettings", source, settings)
	end
)