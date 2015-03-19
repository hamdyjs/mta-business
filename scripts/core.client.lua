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
			gui.b.button.deposit.enabled = true;
			gui.b.button.withdraw.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.buy.enabled = false;
		elseif isAdmin and not isOwner and owner ~= "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.button.buy.enabled = false;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif isAdmin and not isOwner and owner == "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.sell.enabled = false;
			gui.b.button.buy.enabled = true;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif not isAdmin and isOwner then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = false;
			gui.b.button.set_owner.enabled = false;
			gui.b.button.set_cost.enabled = false;
			gui.b.button.set_bank.enabled = false;
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
			gui.b.button.set_cost.enabled = false;
			gui.b.button.set_bank.enabled = false;
			gui.b.button.accept.enabled = false;
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