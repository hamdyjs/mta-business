gui = {};
local screen_width, screen_height = GuiElement.getScreenSize();

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create Business Window
	gui.cb = {text = {}, edit = {}, button = {}};

	local width, height = 511, 530;
	local x, y = math.floor((screen_width / 2) - (width / 2)), math.floor(screen_height/2 - height/2);

	gui.cb.window = dxWindow(x, y, width, height, "Create Business");
		gui.cb.window.visible = false;

	gui.cb.text.info = dxText(0, 25, 511, 51, "Pickup the coordinates and enter the data to create the business", gui.cb.window);
	gui.cb.text.posx = dxText(10, 75, 101, 20, "Position X", gui.cb.window);
	gui.cb.text.posy = dxText(140, 75, 101, 20, "Position Y", gui.cb.window);
	gui.cb.text.posz = dxText(270, 75, 101, 20, "Position Z", gui.cb.window);
	gui.cb.text.intdim = dxText(400, 75, 101, 20, "Interior,Dimension", gui.cb.window);
		gui.cb.text.info:setAlignX("center");
		gui.cb.text.info:setAlignY("center");
		gui.cb.text.info:setColor(0, 173, 0);
		gui.cb.text.posx:setAlignX("center");
		gui.cb.text.posx:setAlignY("center");
		gui.cb.text.posy:setAlignX("center");
		gui.cb.text.posy:setAlignY("center");
		gui.cb.text.posz:setAlignX("center");
		gui.cb.text.posz:setAlignY("center");
		gui.cb.text.intdim:setAlignX("center");
		gui.cb.text.intdim:setAlignY("center");
		
	gui.cb.edit.intdim = dxEditField(400, 105, 101, 21, "", gui.cb.window);
	gui.cb.edit.posx = dxEditField(10, 105, 101, 21, "", gui.cb.window);
	gui.cb.edit.posy = dxEditField(140, 105, 101, 21, "", gui.cb.window);
	gui.cb.edit.posz = dxEditField(270, 105, 101, 21, "", gui.cb.window);
		gui.cb.edit.intdim:setReadOnly(true);
		gui.cb.edit.posx:setReadOnly(true);
		gui.cb.edit.posy:setReadOnly(true);
		gui.cb.edit.posz:setReadOnly(true);

	gui.cb.button.pickup = dxButton(60, 145, 391, 41, "Pickup Coordinates", gui.cb.window);
		gui.cb.button.pickup:setColor(125, 0, 0);

	gui.cb.text.name = dxText(0, 225, 141, 31, "Business Name:", gui.cb.window);
	gui.cb.text.cost = dxText(0, 265, 141, 31, "Business Cost:", gui.cb.window);
	gui.cb.text.payout = dxText(0, 305, 141, 31, "Business Payout:", gui.cb.window);
	gui.cb.text.payout_time = dxText(0, 345, 141, 31, "Business Payout Time:", gui.cb.window);
		gui.cb.text.name:setAlignX("center");
		gui.cb.text.name:setAlignY("center");
		gui.cb.text.cost:setAlignX("center");
		gui.cb.text.cost:setAlignY("center");
		gui.cb.text.payout:setAlignX("center");
		gui.cb.text.payout:setAlignY("center");
		gui.cb.text.payout_time:setAlignX("center");
		gui.cb.text.payout_time:setAlignY("center");

	gui.cb.edit.name = dxEditField(160, 225, 281, 31, "", gui.cb.window);
	gui.cb.edit.cost = dxEditField(160, 265, 281, 31, "", gui.cb.window);
	gui.cb.edit.payout = dxEditField(160, 305, 281, 31, "", gui.cb.window);
	gui.cb.edit.payout_time = dxEditField(160, 345, 191, 31, "", gui.cb.window);

	gui.cb.unit = dxComboBox(360, 345, 141, nil, gui.cb.window);
		gui.cb.unit:addItem("Seconds");
		gui.cb.unit:addItem("Minutes");
		gui.cb.unit:addItem("Hours");
		gui.cb.unit:addItem("Days");
		gui.cb.unit:setSelected(2);

	gui.cb.button.clear = dxButton(10, 490, 111, 31, "Clear", gui.cb.window);
	gui.cb.button.cancel = dxButton(390, 490, 111, 31, "Cancel", gui.cb.window);
	gui.cb.button.create = dxButton(140, 490, 231, 31, "Create Business", gui.cb.window);
		gui.cb.button.clear:setColor(125, 0, 0);
		gui.cb.button.cancel:setColor(125, 0, 0);
		gui.cb.button.create:setColor(125, 0, 0);

	gui.cb.button.pickup.func = function(state)
		if (state ~= "up") then return; end
		local pos = localPlayer.position;
		local int = localPlayer.interior;
		local dim = localPlayer.dimension;
		local x, y, z = string.format("%.2f", pos.x), string.format("%.2f", pos.y), string.format("%.2f", pos.z);
		gui.cb.edit.posx.text = x;
		gui.cb.edit.posy.text = y;
		gui.cb.edit.posz.text = z;
		gui.cb.edit.intdim.text = int..","..dim;
	end

	gui.cb.button.clear.func = function(state)
		if (state ~= "up") then return; end
		gui.cb.edit.posx.text = "";
		gui.cb.edit.posy.text = "";
		gui.cb.edit.posz.text = "";
		gui.cb.edit.intdim.text = "";
		gui.cb.edit.name.text = "";
		gui.cb.edit.cost.text = "";
		gui.cb.edit.payout.text = "";
		gui.cb.edit.payout_time.text = "";
		gui.cb.unit:setSelected(2);
	end

	gui.cb.button.cancel.func = function(state)
		if (state ~= "up") then return; end
		gui.cb.window.visible = false;
		showCursor(false);
	end

	gui.cb.button.create.func = function(state)
		if (state ~= "up") then return; end
		local x, y, z, intdim = gui.cb.edit.posx.text, gui.cb.edit.posy.text, gui.cb.edit.posz.text, gui.cb.edit.intdim.text;
		local name = gui.cb.edit.name.text;
		local cost = gui.cb.edit.cost.text;
		local payout = gui.cb.edit.payout.text;
		local payout_time = gui.cb.edit.payout_time.text;
		-- local payout_unit = gui.cb.unit:getItemText(gui.cb.unit:getSelected());
		if x ~= "" and name ~= "" and cost ~= ""  and tonumber(cost) ~= nil and payout ~= "" and tonumber(payout) ~= nil and payout_time ~= "" and tonumber(payout_time) ~= nil and tonumber(payout_time) > 0 and tonumber(cost) > 0 and tonumber(payout) > 0 then
			if #name > 30 then outputMessage("BUSINESS: Business name must not be more than 30 characters", 255, 0, 0); return; end
			local zone = getZoneName(tonumber(x), tonumber(y), tonumber(z), false);
			if zone == "Unknown" then zone = "the middle of no where" end;
			local interior = tonumber(gettok(intdim, 1, ","));
			local dimension = tonumber(gettok(intdim, 2, ","));
			dxPrompt("Are you sure you want to create business '"..name.."' in "..zone, createBusiness);
		else
			outputMessage("BUSINESS: The data isn't correct, please correct it", 255, 0, 0);
		end
	end

	-- Business Window
	gui.b = {label = {}, tab = {}, edit = {}, button = {}};

	local width, height = 524, 300;
	local x = screen_width/2 - width/2;
	local y = screen_height/2 - height/2;

	gui.b.window = dxWindow(x, y, width, height, "Business Name", false);
		gui.b.window.visible = false;
		gui.b.window:setTitleColor(125, 0, 0);

	gui.b.tab_panel = dxTabPanel(5, 50, 511, 231, gui.b.window);

	gui.b.tab.info = dxTab("Information", gui.b.tab_panel);

	gui.b.label.id = dxText(10, 20, 81, 16, "ID: #", gui.b.tab.info);
	gui.b.label.name = dxText(10, 70, 241, 16, "Name:", gui.b.tab.info);
	gui.b.label.owner = dxText(10, 120, 231, 16, "Owner: ", gui.b.tab.info);
	gui.b.label.cost = dxText(10, 170, 191, 16, "Cost: ", gui.b.tab.info);
	gui.b.label.payout = dxText(290, 20, 211, 16, "Payout: ", gui.b.tab.info);
	gui.b.label.payout_time = dxText(290, 70, 211, 16, "Payout Time:", gui.b.tab.info);
	gui.b.label.location = dxText(290, 120, 211, 16, "Location:", gui.b.tab.info);
	gui.b.label.bank = dxText(290, 170, 211, 16, "Bank:", gui.b.tab.info);
		gui.b.label.id:setAlignX("left", false);
		gui.b.label.id:setAlignY("center");
		gui.b.label.name:setAlignX("left", false);
		gui.b.label.name:setAlignY("center");
		gui.b.label.owner:setAlignX("left", false);
		gui.b.label.owner:setAlignY("center");
		gui.b.label.cost:setAlignX("left", false);
		gui.b.label.cost:setAlignY("center");
		gui.b.label.payout:setAlignX("left", false);
		gui.b.label.payout:setAlignY("center");
		gui.b.label.payout_time:setAlignX("left", false);
		gui.b.label.payout_time:setAlignY("center");
		gui.b.label.location:setAlignX("left", false);
		gui.b.label.location:setAlignY("center");
		gui.b.label.bank:setAlignX("left", false);
		gui.b.label.bank:setAlignY("center");

	gui.b.tab.action = dxTab("Actions", gui.b.tab_panel);

	gui.b.button.buy = dxButton(10, 10, 101, 31, "Buy", gui.b.tab.action);
	gui.b.button.sell = dxButton(10, 60, 101, 31, "Sell", gui.b.tab.action);
	gui.b.button.deposit = dxButton(10, 110, 101, 31, "Deposit", gui.b.tab.action);
	gui.b.button.withdraw = dxButton(10, 160, 101, 31, "Withdraw", gui.b.tab.action);
	gui.b.button.set_name = dxButton(390, 10, 101, 31, "Set Name", gui.b.tab.action);
	gui.b.button.set_owner = dxButton(390, 60, 101, 31, "Set Owner", gui.b.tab.action);
	gui.b.button.set_cost = dxButton(390, 110, 101, 31, "Set Cost", gui.b.tab.action);
	gui.b.button.set_bank = dxButton(390, 160, 101, 31, "Set Bank", gui.b.tab.action);

	gui.b.button.destroy = dxButton(130, 155, 241, 41, "Destroy", gui.b.tab.action);
	gui.b.button.x = dxButton(480, 25, 31, 31, "X", gui.b.window);
	

	gui.b.button.x.func = function(state)
		if (state ~= "up") then return; end
		gui.b.window.visible = false;
		showCursor(false);
	end

	gui.b.button.buy.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Are you sure you want to buy this business?", function()
			triggerServerEvent("business.server.buy", root);
			gui.b.window.visible = false;
		end);
	end

	gui.b.button.sell.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Are you sure you want to sell this business?", function()
			triggerServerEvent("business.server.sell", root);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.deposit.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the amount to deposit", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.server.depsoit", root, amount);
			gui.b.window.visible = false;
		end)
	end;

	gui.b.button.withdraw.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the amount to withdraw", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.server.withdraw", root, amount);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.set_name.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the new name", function(name)
			if (name == "" or name:len() < 4) then outputMessage("Name must be at least 4 characters long", 255, 0, 0); return; end
			triggerServerEvent("business.server.setName", root, name);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.set_owner.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the new owner's account name", function(owner)
			if (owner == "") then outputMessage("Owner's account name must be at least 1 character long", 255, 0, 0); return; end
			triggerServerEvent("business.server.setOwner", root, owner);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.set_cost.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the amount to set the cost", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.server.setCost", root, amount);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.set_bank.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Enter the amount to set the bank", function(amount)
			amount = tonumber(amount);
			if (not amount) then outputMessage("You must enter a correct amount", 255, 0, 0); return; end
			triggerServerEvent("business.server.setBank", root, amount);
			gui.b.window.visible = false;
		end);
	end;

	gui.b.button.destroy.func = function(state)
		if (state ~= "up") then return; end
		dxPrompt("Are you sure you want to destroy the business", function()
			triggerServerEvent("business.server.destroy", root);
			gui.b.window.visible = false;
		end);
	end;
end);

function createBusiness()
	Sound("files/cash.mp3", false);
	showCursor(false);
	local x, y, z, intdim = gui.cb.edit.posx.text, gui.cb.edit.posy.text, gui.cb.edit.posz.text, gui.cb.edit.intdim.text;
	local interior, dimension = unpack(split(intdim, ","));
	local name = gui.cb.edit.name.text;
	local cost = gui.cb.edit.cost.text;
	local payout = gui.cb.edit.payout.text;
	local payout_time, payout_unit = gui.cb.edit.payout_time.text, gui.cb.unit:getItemText(gui.cb.unit:getSelected());
	triggerServerEvent("business.server.createBusiness", root, x, y, z, interior, dimension, name, cost, payout, payout_time, payout_unit);
	gui.cb.button.clear.func("up");
	gui.cb.window.visible = false;
end

-- gui.cb.button.pickup.func = function(button, state)
-- 	if (button ~= "left" or state ~= "up") then return; end
	
-- end

-- gui.cb.button.pickup.func = function(button, state)
-- 	if (button ~= "left" or state ~= "up") then return; end
	
-- end

-- gui.cb.button.pickup.func = function(button, state)
-- 	if (button ~= "left" or state ~= "up") then return; end
	
-- end