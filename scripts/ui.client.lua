gui = {};
local screen_width, screen_height = GuiElement.getScreenSize();

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create Business Window
	gui.cb = {label = {}, edit = {}, button = {}};

	local width, height = 511, 530;
	local x, y = math.floor((screen_width / 2) - (width / 2)), math.floor(screen_height/2 - height/2);

	gui.cb.window = GuiWindow(x, y, width, height, "Create Business", false);
		gui.cb.window.sizable = false;
		gui.cb.window.movable = false;
		gui.cb.window.visible = false;
		gui.cb.window.alpha = 1;


	gui.cb.label.info = GuiLabel(0, 25, 511, 51, "Pickup the coordinates and enter the data to create the business", false, gui.cb.window);
	gui.cb.label.posx = GuiLabel(10, 75, 101, 20, "Position X", false, gui.cb.window);
	gui.cb.label.posy = GuiLabel(140, 75, 101, 20, "Position Y", false, gui.cb.window);
	gui.cb.label.posz = GuiLabel(270, 75, 101, 20, "Position Z", false, gui.cb.window);
	gui.cb.label.intdim = GuiLabel(400, 75, 101, 20, "Interior,Dimension", false, gui.cb.window);
		gui.cb.label.info:setHorizontalAlign("center", false);
		gui.cb.label.info:setVerticalAlign("center");
		gui.cb.label.info:setColor(0, 173, 0);
		gui.cb.label.posx:setHorizontalAlign("center", false);
		gui.cb.label.posx:setVerticalAlign("center");
		gui.cb.label.posy:setHorizontalAlign("center", false);
		gui.cb.label.posy:setVerticalAlign("center");
		gui.cb.label.posz:setHorizontalAlign("center", false);
		gui.cb.label.posz:setVerticalAlign("center");
		gui.cb.label.intdim:setHorizontalAlign("center", false);
		gui.cb.label.intdim:setVerticalAlign("center");
		
	gui.cb.edit.intdim = GuiEdit(400, 105, 101, 21, "", false, gui.cb.window);
	gui.cb.edit.posx = GuiEdit(10, 105, 101, 21, "", false, gui.cb.window);
	gui.cb.edit.posy = GuiEdit(140, 105, 101, 21, "", false, gui.cb.window);
	gui.cb.edit.posz = GuiEdit(270, 105, 101, 21, "", false, gui.cb.window);
		gui.cb.edit.intdim:setReadOnly(true);
		gui.cb.edit.posx:setReadOnly(true);
		gui.cb.edit.posy:setReadOnly(true);
		gui.cb.edit.posz:setReadOnly(true);
		gui.cb.edit.intdim:setMaxLength(32767);
		gui.cb.edit.posx:setMaxLength(32767);
		gui.cb.edit.posy:setMaxLength(32767);
		gui.cb.edit.posz:setMaxLength(32767);

	gui.cb.button.pickup = GuiButton(60, 145, 391, 41, "Pickup Coordinates", false, gui.cb.window);

	gui.cb.label.name = GuiLabel(0, 225, 141, 31, "Business Name:", false, gui.cb.window);
	gui.cb.label.cost = GuiLabel(0, 265, 141, 31, "Business Cost:", false, gui.cb.window);
	gui.cb.label.payout = GuiLabel(0, 305, 141, 31, "Business Payout:", false, gui.cb.window);
	gui.cb.label.payout_time = GuiLabel(0, 345, 141, 31, "Business Payout Time:", false, gui.cb.window);
		gui.cb.label.name:setHorizontalAlign("center", false);
		gui.cb.label.name:setVerticalAlign("center");
		gui.cb.label.cost:setHorizontalAlign("center", false);
		gui.cb.label.cost:setVerticalAlign("center");
		gui.cb.label.payout:setHorizontalAlign("center", false);
		gui.cb.label.payout:setVerticalAlign("center");
		gui.cb.label.payout_time:setHorizontalAlign("center", false);
		gui.cb.label.payout_time:setVerticalAlign("center");

	gui.cb.edit.name = GuiEdit(160, 225, 281, 31, "", false, gui.cb.window);
	gui.cb.edit.cost = GuiEdit(160, 265, 281, 31, "", false, gui.cb.window);
	gui.cb.edit.payout = GuiEdit(160, 305, 281, 31, "", false, gui.cb.window);
	gui.cb.edit.payout_time = GuiEdit(160, 345, 191, 31, "", false, gui.cb.window);

	gui.cb.unit = GuiComboBox(360, 345, 141, 96, "Unit", false, gui.cb.window);
		gui.cb.unit:addItem("Seconds");
		gui.cb.unit:addItem("Minutes");
		gui.cb.unit:addItem("Hours");
		gui.cb.unit:addItem("Days");
		gui.cb.unit:setSelected(1);

	gui.cb.button.clear = GuiButton(10, 490, 111, 31, "Clear", false, gui.cb.window);
	gui.cb.button.cancel = GuiButton(390, 490, 111, 31, "Cancel", false, gui.cb.window);
	gui.cb.button.create = GuiButton(140, 490, 231, 31, "Create Business", false, gui.cb.window);

	addEventHandler("onClientGUIClick", gui.cb.button.pickup, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		local pos = localPlayer.position;
		local int = localPlayer.interior;
		local dim = localPlayer.dimension;
		local x, y, z = string.format("%.2f", pos.x), string.format("%.2f", pos.y), string.format("%.2f", pos.z);
		gui.cb.edit.posx.text = x;
		gui.cb.edit.posy.text = y;
		gui.cb.edit.posz.text = z;
		gui.cb.edit.intdim.text = int..","..dim;
	end, false);

	addEventHandler("onClientGUIClick", gui.cb.button.clear, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		gui.cb.edit.posx.text = "";
		gui.cb.edit.posy.text = "";
		gui.cb.edit.posz.text = "";
		gui.cb.edit.intdim.text = "";
		gui.cb.edit.name.text = "";
		gui.cb.edit.cost.text = "";
		gui.cb.edit.payout.text = "";
		gui.cb.edit.payout_time.text = "";
		gui.cb.unit:setSelected(1);
	end, false);

	addEventHandler("onClientGUIClick", gui.cb.button.cancel, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		gui.cb.window.visible = false;
		showCursor(false);
	end, false);

	addEventHandler("onClientGUIClick", gui.cb.button.create, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		local x, y, z, intdim = gui.cb.edit.posx.text, gui.cb.edit.posy.text, gui.cb.edit.posz.text, gui.cb.edit.intdim.text;
		local name = gui.cb.edit.name.text;
		local cost = gui.cb.edit.cost.text;
		local payout = gui.cb.edit.payout.text;
		local payout_time, payout_unit = gui.cb.edit.payout_time.text, gui.cb.unit:getItemText(gui.cb.unit:getSelected());
		if (x ~= "" and name ~= "" and cost ~= ""  and tonumber(cost) ~= nil and payout ~= "" and tonumber(payout) ~= nil and payout_time ~= "" and tonumber(payout_time) ~= nil and tonumber(payout_time) > 0 and tonumber(cost) > 0 and tonumber(payout) > 0) then
			if #name > 30 then outputMessage("BUSINESS: Business name must not be more than 30 characters", 255, 0, 0); return; end
			local zone = getZoneName(tonumber(x), tonumber(y), tonumber(z), false);
			if zone == "Unknown" then zone = "the middle of no where" end;
			local interior = tonumber(gettok(intdim, 1, ","));
			local dimension = tonumber(gettok(intdim, 2, ","));
			GuiPrompt("Are you sure you want to create business '"..name.."' in "..zone, function()
				Sound("files/cash.mp3", false);
				showCursor(false);
				triggerServerEvent("business.createBusiness", root, x, y, z, interior, dimension, name, cost, payout, payout_time, payout_unit);
				gui.cb.edit.posx.text = "";
				gui.cb.edit.posy.text = "";
				gui.cb.edit.posz.text = "";
				gui.cb.edit.intdim.text = "";
				gui.cb.edit.name.text = "";
				gui.cb.edit.cost.text = "";
				gui.cb.edit.payout.text = "";
				gui.cb.edit.payout_time.text = "";
				gui.cb.unit:setSelected(1);				
				gui.cb.window.visible = false;
			end);
		else
			outputMessage("BUSINESS: The data isn't correct, please correct it", 255, 0, 0);
		end
	end, false);

	-- Business Window
	gui.b = {label = {}, tab = {}, edit = {}, button = {}};

	local width, height = 524, 300;
	local x = screen_width/2 - width/2;
	local y = screen_height/2 - height/2;

	gui.b.window = GuiWindow(x, y, width, height, "", false);
		gui.b.window.visible = false
		gui.b.window.movable = false;
		gui.b.window.alpha = 1;
		gui.b.window.visible = false;

	gui.b.tab_panel = GuiTabPanel(5, 50, 511, 231, false, gui.b.window);

	gui.b.tab.info = GuiTab("Information", gui.b.tab_panel);

	gui.b.label.id = GuiLabel(10, 20, 81, 16, "ID: #", false, gui.b.tab.info);
	gui.b.label.name = GuiLabel(10, 70, 241, 16, "Name:", false, gui.b.tab.info);
	gui.b.label.owner = GuiLabel(10, 120, 231, 16, "Owner: ", false, gui.b.tab.info);
	gui.b.label.cost = GuiLabel(10, 170, 191, 16, "Cost: ", false, gui.b.tab.info);
	gui.b.label.payout = GuiLabel(290, 20, 211, 16, "Payout: ", false, gui.b.tab.info);
	gui.b.label.payout_time = GuiLabel(290, 70, 211, 16, "Payout Time:", false, gui.b.tab.info);
	gui.b.label.location = GuiLabel(290, 120, 211, 16, "Location:", false, gui.b.tab.info);
	gui.b.label.bank = GuiLabel(290, 170, 211, 16, "Bank:", false, gui.b.tab.info);
		gui.b.label.id:setHorizontalAlign("left", false);
		gui.b.label.id:setVerticalAlign("center");
		gui.b.label.name:setHorizontalAlign("left", false);
		gui.b.label.name:setVerticalAlign("center");
		gui.b.label.owner:setHorizontalAlign("left", false);
		gui.b.label.owner:setVerticalAlign("center");
		gui.b.label.cost:setHorizontalAlign("left", false);
		gui.b.label.cost:setVerticalAlign("center");
		gui.b.label.payout:setHorizontalAlign("left", false);
		gui.b.label.payout:setVerticalAlign("center");
		gui.b.label.payout_time:setHorizontalAlign("left", false);
		gui.b.label.payout_time:setVerticalAlign("center");
		gui.b.label.location:setHorizontalAlign("left", false);
		gui.b.label.location:setVerticalAlign("center");
		gui.b.label.bank:setHorizontalAlign("left", false);
		gui.b.label.bank:setVerticalAlign("center");

	gui.b.tab.action = GuiTab("Actions", gui.b.tab_panel);

	gui.b.button.buy = GuiButton(10, 10, 101, 31, "Buy", false, gui.b.tab.action);
	gui.b.button.sell = GuiButton(10, 60, 101, 31, "Sell", false, gui.b.tab.action);
	gui.b.button.deposit = GuiButton(10, 110, 101, 31, "Deposit", false, gui.b.tab.action);
	gui.b.button.withdraw = GuiButton(10, 160, 101, 31, "Withdraw", false, gui.b.tab.action);
	gui.b.button.set_name = GuiButton(390, 10, 101, 31, "Set Name", false, gui.b.tab.action);
	gui.b.button.set_owner = GuiButton(390, 60, 101, 31, "Set Owner", false, gui.b.tab.action);
	gui.b.button.set_cost = GuiButton(390, 110, 101, 31, "Set Cost", false, gui.b.tab.action);
	gui.b.button.set_bank = GuiButton(390, 160, 101, 31, "Set Bank", false, gui.b.tab.action);

	gui.b.button.destroy = GuiButton(130, 155, 241, 41, "Destroy", false, gui.b.tab.action);
	gui.b.button.x = GuiButton(480, 25, 31, 31, "X", false, gui.b.window);
	
	addEventHandler("onClientGUIClick", gui.b.button.x, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		gui.b.window.visible = false;
		showCursor(false);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.buy, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Are you sure you want to buy this business?", function()
			triggerServerEvent("business.buy", root);
			gui.b.window.visible = false;
			showCursor(false);
		end);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.sell, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Are you sure you want to sell this business?", function()
			triggerServerEvent("business.sell", root);
			gui.b.window.visible = false;
			showCursor(false);
		end);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.deposit, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the amount to deposit", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.deposit", root, amount);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.withdraw, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the amount to withdraw", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.withdraw", root, amount);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.set_name, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the new name", function(name)
			if (name == "" or name:len() < 4) then outputMessage("Name must be at least 4 characters long", 255, 0, 0); return; end
			triggerServerEvent("business.setName", root, name);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.set_owner, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the new owner's account name", function(owner)
			if (owner == "") then outputMessage("Owner's account name must be at least 1 character long", 255, 0, 0); return; end
			triggerServerEvent("business.setOwner", root, owner);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.set_cost, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the amount to set the cost", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.setCost", root, amount);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.set_bank, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Enter the amount to set the bank", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.setBank", root, amount);
			gui.b.window.visible = false;
			showCursor(false);
		end, nil, true);
	end, false);
	addEventHandler("onClientGUIClick", gui.b.button.destroy, function(button, state)
		if (button ~= "left" or state ~= "up") then return; end
		GuiPrompt("Are you sure you want to destroy the business", function()
			triggerServerEvent("business.destroy", root);
			gui.b.window.visible = false;
			showCursor(false);
		end);
	end, false);
end);

function GuiPrompt(message, ycallback, ncallback, include_edit)
    if not (message and type(ycallback) == "function") then return; end
    local screen_width, screen_height = GuiElement.getScreenSize();
    local width, height = 300, 200;
    local button_y = 160;
    local x, y = (screen_width - width) / 2, (screen_height - height) / 2;
    local window = GuiWindow(x, y, width, height, "Confirmation", false);
    	window.alpha = 1;
    local label = GuiLabel(10, 20, 280, 115, message, false, window);
        label:setHorizontalAlign("center", true);
        label:setVerticalAlign("center");
    local edit;
    if (include_edit) then edit = GuiEdit(10, 120, 280, 30, "", false, window); end
    local y = GuiButton(5, button_y, 137.5, 30, "Yes", false, window);
    local n = GuiButton(152.5, button_y, 140, 30, "No", false, window);
    addEventHandler("onClientGUIClick", y, function(button, state)
    	if (button ~= "left" or state ~= "up") then return; end
        ycallback(include_edit and edit.text or nil);
        window:destroy();
    end, false);
    addEventHandler("onClientGUIClick", n, function(button, state)
    	if (button ~= "left" or state ~= "up") then return; end
        if (ncallback) then ncallback(); end
        window:destroy();
    end, false);
    return window;
end