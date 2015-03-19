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
		for index, b_marker in ipairs(Element.getAllByType("marker", resourceRoot)) do
			local b_data = b_marker:getData("b_data");
			local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
			local x, y, z = b_marker.position.x, b_marker.position.y, b_marker.position.z;
			local cam_x, cam_y, cam_z = getCameraMatrix();
			if getDistanceBetweenPoints3D(cam_x, cam_y, cam_z, x, y, z) < 15 then
				local screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 1.6);
				if screen_x then
					local scale = 1920 / screen_width;
					local width = 80 / scale;
					dxDrawImage(screen_x - width / 2, screen_y - screen_height / 10, width, 80, "files/business.png");
				end
				if settings["business.showBusinessInfoOnMarker"] then
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 1.4);
					if screen_x then
						if #tostring(id) == 1 then id = "0"..tostring(id) end
						dxDrawFramedText("ID: #"..id, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 1.2);
					if screen_x then
						dxDrawFramedText("Name: "..name, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 1.0);
					if screen_x then
						dxDrawFramedText("Owner: "..owner, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 0.8);
					if screen_x then
						dxDrawFramedText("Cost: $"..cost, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 0.6);
					if screen_x then
						dxDrawFramedText("Payout: $"..payout, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 0.4);
					if screen_x then
						dxDrawFramedText("Payout Time: "..payout_otime.." "..payout_unit, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
					end
					screen_x, screen_y = getScreenFromWorldPosition(x, y, z + 0.2);
					if screen_x then
						dxDrawFramedText("Bank: $"..bank, screen_x, screen_y, screen_x, screen_y, tocolor(255, 255, 255, 255), 1.0, "default-bold", "center", "center", false, false, false);
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
	function(b_marker, is_owner, is_admin)
		local b_data = b_marker:getData("b_data");
		local id, name, owner, cost, payout, payout_time, payout_otime, payout_unit, bank, timer = unpack(b_data);
		local x, y, z = b_marker.position;
		if #tostring(id) == 1 then id = "0"..tostring(id) end
		gui.b.window.text = name;
		gui.b.label.id.text = "ID: #"..id;
		gui.b.label.name.text = "Name: "..name;
		gui.b.label.owner.text = "Owner: "..owner;
		gui.b.label.cost.text = "Cost: $"..cost;
		gui.b.label.payout.text = "Payout: $"..payout;
		gui.b.label.payout_time.text = "Payout Time: "..payout_otime.." "..payout_unit;
		gui.b.label.location.text = "Location: "..getZoneName(x, y, z, false).."("..getZoneName(x, y, z, true)..")";
		gui.b.label.bank.text = "Bank: $"..bank;

		if is_admin and is_owner then
			gui.b.tab.action.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.button.deposit.enabled = true;
			gui.b.button.withdraw.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.buy.enabled = false;
		elseif is_admin and not is_owner and owner ~= "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.sell.enabled = true;
			gui.b.button.buy.enabled = false;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif is_admin and not is_owner and owner == "For Sale" then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = true;
			gui.b.button.set_owner.enabled = true;
			gui.b.button.set_cost.enabled = true;
			gui.b.button.set_bank.enabled = true;
			gui.b.button.sell.enabled = false;
			gui.b.button.buy.enabled = true;
			gui.b.button.deposit.enabled = false;
			gui.b.button.withdraw.enabled = false;
		elseif not is_admin and is_owner then
			gui.b.tab.action.enabled = true;
			gui.b.button.set_name.enabled = false;
			gui.b.button.set_owner.enabled = false;
			gui.b.button.set_cost.enabled = false;
			gui.b.button.set_bank.enabled = false;
			gui.b.button.sell.enabled = true;
			gui.b.button.deposit.enabled = true;
			gui.b.button.withdraw.enabled = true;
			gui.b.button.buy.enabled = false;
		elseif not is_admin and not is_owner and owner ~= "For Sale" then
			gui.b.tab.action.enabled = false;
			gui.b.tab_panel:setSelectedTab(gui.b.tab.info);
		elseif not is_admin and not is_owner and owner == "For Sale" then
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