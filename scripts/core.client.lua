local screen_width, screen_height = GuiElement.getScreenSize();
local is_cursor_over_gui = false;
local action;
local settings = {};
GuiElement.setInputMode("no_binds_when_editing");

addEvent("business.client.showCreateBusinessWindow", true);
addEventHandler("business.client.showCreateBusinessWindow", root,
	function()
		gui.cb.window.visible = true;
		showCursor(true);
	end
);

function outputMessage(message, r, g, b)
	triggerServerEvent("server:outputMessage", localPlayer, message, r, g, b);
end

-- addEventHandler("onClientMouseEnter", root, function() is_cursor_over_gui = true end);
-- addEventHandler('onClientMouseLeave', root, function() is_cursor_over_gui = false end);

-- addEventHandler("onClientRender", root,
-- 	function()
-- 		if not isCursorShowing() then return; end
-- 		if is_cursor_over_gui then return; end
-- 		if not gui.cb.window.visible then return; end
-- 		if gui.cbc.window.visible then return; end
-- 		local csX, csY = getCursorPosition();
-- 		if csX and csY then
-- 			dxDrawFramedText("RMB to show/hide cursor", screen_width  * csX + 10, screen_height  * csY - 5, 100, 50, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, true);
-- 		end
-- 	end
-- );

-- bindKey("mouse2", "up",
-- 	function()
-- 		if not gui.cb.window.visible then return; end
-- 		if gui.cbc.window.visible then return; end
-- 		if isCursorShowing() then
-- 			if is_cursor_over_gui then return; end
-- 			gui.cb.window.alpha = 0.1;
-- 			_showCursor(false);
-- 		else
-- 			gui.cb.window.alpha = 1;
-- 			_showCursor(true);
-- 		end
-- 	end
-- );

addEventHandler("onClientRender", root,
	function()
		for index, bMarker in ipairs(Element.getAllByType("marker", resourceRoot)) do
			local bData = bMarker:getData("bData");
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
			local posX, posY, posZ = bMarker.position.x, bMarker.position.y, bMarker.position.z;
			local camX, camY, camZ = getCameraMatrix();
			if getDistanceBetweenPoints3D(camX, camY, camZ, posX, posY, posZ) < 15 then
				local scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 1.6);
				if scX then
					local scale = 1920 / screen_width;
					local width = 80 / scale;
					dxDrawImage(scX - width / 2, scY - screen_height / 10, width, 80, "files/business.png");
				end
				if settings["business.showBusinessInfoOnMarker"] then
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 1.4);
					if scX then
						if #tostring(id) == 1 then id = "0"..tostring(id) end
						dxDrawFramedText("ID: #"..id, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 1.2);
					if scX then
						dxDrawFramedText("Name: "..name, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 1.0);
					if scX then
						dxDrawFramedText("Owner: "..owner, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 0.8);
					if scX then
						dxDrawFramedText("Cost: $"..cost, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 0.6);
					if scX then
						dxDrawFramedText("Payout: $"..payout, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 0.4);
					if scX then
						dxDrawFramedText("Payout Time: "..payoutOTime.." "..payoutUnit, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					scX, scY = getScreenFromWorldPosition(posX, posY, posZ + 0.2);
					if scX then
						dxDrawFramedText("Bank: $"..bank, scX, scY, scX, scY, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
				end
			end
		end
	end
);

addEvent("client:showInstructions", true);
addEventHandler("client:showInstructions", root,
	function()
		addEventHandler("onClientRender", root, showInstructions);
	end
);

function showInstructions()
	if settings["business.key"] then
		dxDrawText("Press",(screen_width / 1440) * 550,(screen_height / 900) * 450,(screen_width / 1440) * 100,(screen_height / 900) * 100, tocolor(255, 255, 255, 255),(screen_width / 1440) * 2.0);
		dxDrawText(settings["business.key"]:upper(),(screen_width / 1440) * 615,(screen_height / 900) * 450,(screen_width / 1440) * 100,(screen_height / 900) * 100, tocolor(255, 0, 0, 255),(screen_width / 1440) * 2.0);
		dxDrawText(" To Open The Business",(screen_width / 1440) * 630,(screen_height / 900) * 450,(screen_width / 1440) * 100,(screen_height / 900) * 100, tocolor(255, 255, 255, 255),(screen_width / 1440) * 2.0);
	end
end

addEvent("client:hideInstructions", true);
addEventHandler("client:hideInstructions", root,
	function()
		removeEventHandler("onClientRender", root, showInstructions);
	end
);

-- function on_bBuyB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.bb.window.text = "Buy Business";
-- 	gui.bb.info.text = "Buy This Business?";
-- 	gui.bb.window.visible = true;
-- 	action = "Buy";
-- end

-- function on_bSellB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.bb.window.text = "Sell Business";
-- 	gui.bb.info.text = "Sell This Business?";
-- 	gui.bb.window.visible = true;
-- 	action = "Sell";
-- end

-- function on_bDepositB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Deposit:";
-- 	action = "Deposit";
-- end

-- function on_bWithdrawB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Withdraw:";
-- 	action = "Withdraw";
-- end

-- function on_bNameB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Set Name:";
-- 	action = "SName";
-- end

-- function on_bOwnerB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Set Owner:";
-- 	action = "SOwner";
-- end

-- function on_bCostB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Set Cost:";
-- 	action = "SCost";
-- end

-- function on_bBankB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.label.action.text = "Set Bank:";
-- 	action = "SBank";
-- end

-- function on_bAcceptB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	if action == "Deposit" then
-- 		local text = gui.b.edit.action.text;
-- 		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		gui.bb.window.text = "Deposit";
-- 		gui.bb.info.text = "Deposit $"..tostring(tonumber(text)).." ?";
-- 		gui.bb.window.visible = true;
-- 	elseif action == "Withdraw" then
-- 		local text = gui.b.edit.action.text;
-- 		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		gui.bb.window.text = "Withdraw";
-- 		gui.bb.info.text = "Withdraw $"..tostring(tonumber(text)).." ?";
-- 		gui.bb.window.visible = true;
-- 	elseif action == "SName" then
-- 		local text = gui.b.edit.action.text;
-- 		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		if #text > 30 then return outputMessage("BUSINESS: Business Name Must Be Lower Than 31 Character", 255, 0, 0) end
-- 		gui.bb.window.text = "Set Name";
-- 		gui.bb.info.text = "Set This Business Name To "..text.." ?";
-- 		gui.bb.window.visible = true;
-- 	elseif action == "SOwner" then
-- 		local text = gui.b.edit.action.text;
-- 		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		gui.bb.window.text = "Set Owner";
-- 		gui.bb.info.text = "Set This Business Owner To "..text.." ?";
-- 		gui.bb.window.visible = true;
-- 	elseif action == "SCost" then
-- 		local text = gui.b.edit.action.text;
-- 		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		gui.bb.window.text = "Set Cost";
-- 		gui.bb.info.text = "Set This Business Cost To "..tostring(tonumber(text)).." ?";
-- 		gui.bb.window.visible = true;
-- 	elseif action == "SBank" then
-- 		local text = gui.b.edit.action.text;
-- 		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
-- 		gui.bb.window.text = "Set Bank";
-- 		gui.bb.info.text = "Set This Business Bank To "..tostring(tonumber(text)).." ?";
-- 		gui.bb.window.visible = true;
-- 	end
-- end

-- function on_bXB_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.b.window.visible = false;
-- 	showCursor(false);
-- 	localPlayer:setFrozen(false);
-- end

-- function on_bDestroyB_clicked(button, state)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.bb.window.text = "Destroy Business";
-- 	gui.bb.info.text = "Destroy This Business?";
-- 	gui.bb.window.visible = true;
-- 	action = "Destroy";
-- end

addEvent("business.client.showBusinessWindow", true);
addEventHandler("business.client.showBusinessWindow", root,
	function(bMarker, isOwner, isAdmin)
		local bData = bMarker:getData("bData");
		local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(bData);
		local posX, posY, posZ = bMarker.position;
		if #tostring(id) == 1 then id = "0"..tostring(id) end
		gui.b.window.text = name;
		gui.b.label.id.text = "ID: #"..id;
		gui.b.label.name.text = "Name: "..name;
		gui.b.label.owner.text = "Owner: "..owner;
		gui.b.label.cost.text = "Cost: $"..cost;
		gui.b.label.payout.text = "Payout: $"..payout;
		gui.b.label.payout_time.text = "Payout Time: "..payout_otime.." "..payout_unit;
		gui.b.label.location.text = "Location: "..getZoneName(posX, posY, posZ, false).."("..getZoneName(posX, posY, posZ, true)..")";
		gui.b.label.bank.text = "Bank: $"..bank;

		if isAdmin and isOwner then
			gui.b.tab.action.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.edit.action.enabled = true;
			gui.b.button.deposit.enabled = true;
			gui.b.button.withdraw.enabled = true;
			gui.b.button.accept.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.buy.enabled = false;
		elseif isAdmin and not isOwner and owner ~= "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.accept.enabled = true;
			gui.b.edit.action.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.button.buy.enabled = false;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif isAdmin and not isOwner and owner == "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.accept.enabled = true;
			gui.b.edit.action.enabled = true;
			gui.b.button.sell.enabled = false;
			gui.b.button.buy.enabled = true;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif not isAdmin and isOwner then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = false;
			gui.b.button.set_owner.enabled = false;
			gui.b.button.cost.enabled = false;
			gui.b.button.set_bank.enabled = false;
			gui.b.button.accept.enabled = true;
			gui.b.edit.action.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.button.deposit.enabled = true;
			gui.b.button.withdraw.enabled = true;
			gui.b.button.buy.enabled = false;
		elseif not isAdmin and not isOwner and owner ~= "For Sale" then
			gui.b.tab.action.enabled = false;
			gui.b.tab_panel:setSelectedTab(gui.b.tab.info);
		elseif not isAdmin and not isOwner and owner == "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = false;
			gui.b.button.set_owner.enabled = false;
			gui.b.button.cost.enabled = false;
			gui.b.button.set_bank.enabled = false;
			gui.b.button.accept.enabled = false;
			gui.b.edit.action.enabled = false;
			gui.b.button.sell.enabled = false;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
			gui.b.button.buy.enabled = true;
		end

		gui.b.window.visible = true;
		showCursor(true);
		removeEventHandler("onClientRender", root, showInstructions)
	end
);

-- function on_bacAcceptI_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	local text = gui.b.edit.action.text;
-- 	triggerServerEvent("server:onActionAttempt", localPlayer, action, text);
-- 	gui.bb.window.visible = false;
-- end

-- function on_bacCancelI_clicked(button, state, absoluteX, absoluteY)
-- 	if(button ~= "left") or(state ~= "up") then
-- 		return;
-- 	end
-- 	gui.bb.window.visible = false;
-- end

-- function on_bacAcceptI_entered()
-- 	source.alpha = 0.5;
-- end

-- function on_bacCancelI_entered()
-- 	source.alpha = 0.5;
-- end

-- function on_bacAcceptI_left()
-- 	source.alpha = 1;
-- end

-- function on_bacCancelI_left()
-- 	source.alpha = 1;
-- end

-- addEvent("client:onAction", true);
-- addEventHandler("client:onAction", root,
-- 	function(close, playCash)
-- 		if close then
-- 			gui.b.window.visible = false;
-- 			showCursor(false);
-- 		end
-- 		if playCash then
-- 			Sound("files/cash.mp3", false);
-- 		end
-- 		gui.b.label.action.text = "Action:";
-- 		gui.b.edit.action.text = "";
-- 	end
-- );

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		triggerServerEvent("onClientCallSettings", localPlayer);
	end
);

addEvent("onClientCallSettings", true);
addEventHandler("onClientCallSettings", root,
	function(settings2)
		settings = settings2;
	end
);

_showCursor = showCursor;
function showCursor(bool)
	if bool then
		_showCursor(true);
	else
		_showCursor(false);
		Timer(
			function()
				for index, window in ipairs(Element.getAllByType("gui-window", resourceRoot)) do
					if window.visible then
						_showCursor(true);
					end
				end
			end
		, 300, 1);
	end
end