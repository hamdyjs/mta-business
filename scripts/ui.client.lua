local gui = {};
local screen_width, screen_height = GuiElement.getScreenSize();

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create Business Window
	gui.cb = {text = {}, edit = {}, button = {}};

	local width, height = 511, 530;
	local x, y = math.floor((screen_width / 2) - (width / 2)), math.floor(screen_height/2 - height/2);

	gui.cb.window = dxWindow(x, y, width, height, "Create Business");
		gui.cb.window:setVisible(false);

	gui.cb.text.info = dxText(0, 25, 511, 51, "Pickup the coordinates and enter the data to create the business", gui.cb.window);
	gui.cb.text.posx = dxText(10, 75, 101, 20, "Position X", gui.cb.window);
	gui.cb.text.posy = dxText(140, 75, 101, 20, "Position Y", gui.cb.window);
	gui.cb.text.posz = dxText(270, 75, 101, 20, "Position Z", gui.cb.window);
	gui.cb.text.intdim = dxText(400, 75, 101, 20, "Interior, Dim", gui.cb.window);
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

	-- Business Window
	gui.b = {label = {}, tab = {}, edit = {}, button = {}};

	local width, height = 524, 300;
	local x = screen_width/2 - width/2;
	local y = screen_height/2 - height/2;

	gui.b.window = dxWindow(x, y, width, height, "Business Name", false);
		gui.b.window:setVisible(false);
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
	gui.b.button.cost = dxButton(390, 110, 101, 31, "Set Cost", gui.b.tab.action);
	gui.b.button.set_bank = dxButton(390, 160, 101, 31, "Set Bank", gui.b.tab.action);

	gui.b.edit.action = dxEditField(130, 50, 241, 31, "", gui.b.tab.action);

	gui.b.label.action = dxText(130, 10, 241, 21, "Action:", gui.b.tab.action);
		gui.b.label.action:setAlignX("center", false);
		gui.b.label.action:setAlignY("center");
		gui.b.label.action:setColor(255, 0, 0);

	gui.b.button.accept = dxButton(130, 100, 241, 41, "Accept", gui.b.tab.action);
	gui.b.button.destroy = dxButton(130, 155, 241, 41, "Destroy", gui.b.tab.action);
	gui.b.button.x = dxButton(480, 25, 31, 31, "X", gui.b.window);
end);