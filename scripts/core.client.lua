-- Business System v1.2 - core.client.lua - Core client code of the resource
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

local screen_width, screen_height = GuiElement.getScreenSize();
local gui = {};
local is_cursor_over_gui = false;
local action;
local settings = {};
GuiElement.setInputMode("no_binds_when_editing");

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create Business Window
	local window_width, window_height = 511, 461;
	local left = screen_width/2 - window_width/2;
	local top = screen_height/2 - window_height/2;
	gui.cb = {label = {}, edit = {}, button = {}};
	gui.cb.window = GuiWindow(left, top, window_width, window_height, "Create Business", false);
	guiWindowSetSizable(gui.cb.window, false);
	guiWindowSetMovable(gui.cb.window, false);
	guiSetVisible(gui.cb.window, false);
	guiSetAlpha(gui.cb.window, 1);

	gui.cb.label.posz = GuiLabel(270, 75, 101, 20, "Position Z", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.posz, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.posz, "center");
	guiLabelSetColor(gui.cb.label.posz, 0, 100, 255);

	gui.cb.label.posx = GuiLabel(10, 75, 101, 20, "Position X", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.posx, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.posx, "center");
	guiLabelSetColor(gui.cb.label.posx, 0, 100, 255);

	gui.cb.label.posy = GuiLabel(140, 75, 101, 20, "Position Y", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.posy, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.posy, "center");
	guiLabelSetColor(gui.cb.label.posy, 0, 100, 255);

	gui.cb.label.intdim = GuiLabel(400, 75, 101, 20, "Interior, Dim", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.intdim, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.intdim, "center");
	guiLabelSetColor(gui.cb.label.intdim, 0, 100, 255);

	gui.cb.edit.intdim = GuiEdit(400, 105, 101, 21, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.intdim, 32767);
	guiEditSetReadOnly(gui.cb.edit.intdim, true);

	gui.cb.label.info = GuiLabel(0, 25, 511, 51, "Pickup The Coordinates And Enter The Data To Create The Business.", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.info, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.info, "center");
	guiLabelSetColor(gui.cb.label.info, 0, 173, 0);

	gui.cb.edit.posx = GuiEdit(10, 105, 101, 21, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.posx, 32767);
	guiEditSetReadOnly(gui.cb.edit.posx, true);

	gui.cb.edit.posy = GuiEdit(140, 105, 101, 21, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.posy, 32767);
	guiEditSetReadOnly(gui.cb.edit.posy, true);

	gui.cb.edit.posz = GuiEdit(270, 105, 101, 21, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.posz, 32767);
	guiEditSetReadOnly(gui.cb.edit.posz, true);

	gui.cb.button.pickup = GuiButton(60, 145, 391, 41, "Pickup Coordinates", false, gui.cb.window);
	if on_cbPickcB_clicked then
		addEventHandler("onClientGUIClick", gui.cb.button.pickup, on_cbPickcB_clicked, false);
	end

	gui.cb.label.name = GuiLabel(0, 225, 141, 31, "Business Name:", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.name, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.name, "center");
	guiLabelSetColor(gui.cb.label.name, 255, 0, 0);

	gui.cb.label.cost = GuiLabel(0, 265, 141, 31, "Business Cost:", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.cost, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.cost, "center");
	guiLabelSetColor(gui.cb.label.cost, 255, 0, 0);

	gui.cb.label.payout = GuiLabel(0, 305, 141, 31, "Business Payout:", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.payout, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.payout, "center");
	guiLabelSetColor(gui.cb.label.payout, 255, 0, 0);

	gui.cb.label.payout_time = GuiLabel(0, 345, 141, 31, "Business Payout Time:", false, gui.cb.window);
	guiLabelSetHorizontalAlign(gui.cb.label.payout_time, "center", false);
	guiLabelSetVerticalAlign(gui.cb.label.payout_time, "center");
	guiLabelSetColor(gui.cb.label.payout_time, 255, 0, 0);

	gui.cb.edit.name = GuiEdit(160, 225, 281, 31, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.name, 32767);

	gui.cb.edit.cost = GuiEdit(160, 265, 281, 31, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.cost, 32767);

	gui.cb.edit.payout = GuiEdit(160, 305, 281, 31, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.payout, 32767);

	gui.cb.edit.payout_time = GuiEdit(160, 345, 191, 31, "", false, gui.cb.window);
	guiEditSetMaxLength(gui.cb.edit.payout_time, 32767);

	gui.cb.unit = GuiComboBox(360, 345, 141, 96,"Unit", false, gui.cb.window);

	guiComboBoxAddItem(gui.cb.unit, "Seconds");
	guiComboBoxAddItem(gui.cb.unit, "Minutes");
	guiComboBoxAddItem(gui.cb.unit, "Hours");
	guiComboBoxAddItem(gui.cb.unit, "Days");

	guiComboBoxSetSelected(gui.cb.unit, 1);

	gui.cb.button.clear = GuiButton(0, 415, 121, 31, "Clear", false, gui.cb.window);
	if on_cbClearB_clicked then
		addEventHandler("onClientGUIClick", gui.cb.button.clear, on_cbClearB_clicked, false);
	end

	gui.cb.button.cancel = GuiButton(390, 415, 121, 31, "Cancel", false, gui.cb.window);
	if on_cbCancelB_clicked then
		addEventHandler("onClientGUIClick", gui.cb.button.cancel, on_cbCancelB_clicked, false);
	end

	gui.cb.button.create = GuiButton(145, 415, 231, 31, "Create Business", false, gui.cb.window);
	if on_cbCreateB_clicked then
		addEventHandler("onClientGUIClick", gui.cb.button.create, on_cbCreateB_clicked, false);
	end

	-- Create Business Check Window
	local window_width, window_height = 369, 378;
	local left = screen_width/2 - window_width/2;
	local top = screen_height/2 - window_height/2;
	gui.cbc = {label = {}, edit = {}, image = {}};
	gui.cbc.window = GuiWindow(left, top, window_width, window_height, "Create Business Check", false);
	guiWindowSetSizable(gui.cbc.window, false);
	guiWindowSetMovable(gui.cbc.window, false);
	guiSetVisible(gui.cbc.window, false);
	guiSetProperty(gui.cbc.window, "AlwaysOnTop", "true");
	guiSetAlpha(gui.cbc.window, 1);

	gui.cbc.label.info = GuiLabel(0, 15, 371, 41, "Are you sure you want to create the business with these data?", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.info, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.info, "center");
	guiLabelSetColor(gui.cbc.label.info, 0, 173, 0);

	gui.cbc.label.name = GuiLabel(10, 65, 100, 30, "Business Name:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.name, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.name, "center");
	guiLabelSetColor(gui.cbc.label.name, 255, 0, 0);

	gui.cbc.label.pos = GuiLabel(10, 105, 100, 30, "Business Position:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.pos, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.pos, "center");
	guiLabelSetColor(gui.cbc.label.pos, 255, 0, 0);

	gui.cbc.label.location = GuiLabel(10, 145, 100, 30, "Business Location:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.location, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.location, "center");
	guiLabelSetColor(gui.cbc.label.location, 255, 0, 0);

	gui.cbc.label.cost = GuiLabel(10, 185, 100, 30, "Business Cost:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.cost, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.cost, "center");
	guiLabelSetColor(gui.cbc.label.cost, 255, 0, 0);

	gui.cbc.label.payout = GuiLabel(10, 225, 100, 31, "Business Payout:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.payout, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.payout, "center");
	guiLabelSetColor(gui.cbc.label.payout, 255, 0, 0);

	gui.cbc.label.payout_time = GuiLabel(0, 265, 140, 30, "Business Payout Time:", false, gui.cbc.window);
	guiLabelSetHorizontalAlign(gui.cbc.label.payout_time, "center", false);
	guiLabelSetVerticalAlign(gui.cbc.label.payout_time, "center");
	guiLabelSetColor(gui.cbc.label.payout_time, 255, 0, 0);

	gui.cbc.edit.cost = GuiEdit(150, 65, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.cost, 32767);
	guiEditSetReadOnly(gui.cbc.edit.cost, true);

	gui.cbc.edit.position = GuiEdit(150, 105, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.position, 32767);
	guiEditSetReadOnly(gui.cbc.edit.position, true);

	gui.cbc.edit.location = GuiEdit(150, 145, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.location, 32767);
	guiEditSetReadOnly(gui.cbc.edit.location, true);

	gui.cbc.edit.cost = GuiEdit(150, 185, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.cost, 32767);
	guiEditSetReadOnly(gui.cbc.edit.cost, true);

	gui.cbc.edit.payout = GuiEdit(150, 225, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.payout, 32767);
	guiEditSetReadOnly(gui.cbc.edit.payout, true);

	gui.cbc.edit.payout_time = GuiEdit(150, 265, 191, 31, "", false, gui.cbc.window);
	guiEditSetMaxLength(gui.cbc.edit.payout_time, 32767);
	guiEditSetReadOnly(gui.cbc.edit.payout_time, true);

	gui.cbc.image.accept = GuiStaticImage(60, 315, 81, 51, "files/tick.png", false, gui.cbc.window);
	gui.cbc.image.cancel = GuiStaticImage(220, 315, 81, 51, "files/wrong.png", false, gui.cbc.window);
	addEventHandler("onClientMouseEnter", gui.cbc.image.accept, on_cbcAcceptI_entered, false);
	addEventHandler("onClientMouseEnter", gui.cbc.image.cancel, on_cbcCancelI_entered, false);
	addEventHandler("onClientMouseLeave", gui.cbc.image.accept, on_cbcAcceptI_left, false);
	addEventHandler("onClientMouseLeave", gui.cbc.image.cancel, on_cbcCancelI_left, false);
	addEventHandler("onClientGUIClick", gui.cbc.image.accept, on_cbcAcceptI_clicked, false);
	addEventHandler("onClientGUIClick", gui.cbc.image.cancel, on_cbcCancelI_clicked, false);

	-- Business Window
	gui.b = {label = {}, tab = {}, edit = {}, button = {}};
	local window_width, window_height = 524, 398;
	local left = screen_width/2 - window_width/2;
	local top = screen_height/2 - window_height/2;
	gui.b.window = GuiWindow(left, top, window_width, window_height, "", false);
	guiWindowSetSizable(gui.b.window, false);
	guiWindowSetMovable(gui.b.window, false);
	guiSetAlpha(gui.b.window, 1);
	guiSetVisible(gui.b.window, false);

	gui.b.icon = GuiStaticImage(220, 25, 101, 80, "files/business.png", false, gui.b.window);

	gui.b.tab_panel = GuiTabPanel(10, 125, 511, 231, false, gui.b.window);

	gui.b.tab.info = GuiTab("Information", gui.b.tab_panel);

	gui.b.label.id = GuiLabel(10, 20, 81, 16, "ID: #", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.id, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.id, "center");

	gui.b.label.name = GuiLabel(10, 70, 241, 16, "Name:", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.name, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.name, "center");

	gui.b.label.owner = GuiLabel(10, 120, 231, 16, "Owner: ", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.owner, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.owner, "center");

	gui.b.label.cost = GuiLabel(10, 170, 191, 16, "Cost: ", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.cost, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.cost, "center");

	gui.b.label.payout = GuiLabel(290, 20, 211, 16, "Payout: ", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.payout, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.payout, "center");

	gui.b.label.payout_time = GuiLabel(290, 70, 211, 16, "Payout Time:", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.payout_time, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.payout_time, "center");

	gui.b.label.location = GuiLabel(290, 120, 211, 16, "Location:", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.location, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.location, "center");

	gui.b.label.bank = GuiLabel(290, 170, 211, 16, "Bank:", false, gui.b.tab.info);
	guiLabelSetHorizontalAlign(gui.b.label.bank, "left", false);
	guiLabelSetVerticalAlign(gui.b.label.bank, "center");

	gui.b.tab.action = GuiTab("Actions", gui.b.tab_panel);

	gui.b.button.buy = GuiButton(10, 10, 101, 31, "Buy", false, gui.b.tab.action);
	if on_bBuyB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.buy, on_bBuyB_clicked, false);
	end

	gui.b.button.sell = GuiButton(10, 60, 101, 31, "Sell", false, gui.b.tab.action);
	if on_bSellB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.sell, on_bSellB_clicked, false);
	end

	gui.b.button.deposit = GuiButton(10, 110, 101, 31, "Deposit", false, gui.b.tab.action);
	if on_bDepositB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.deposit, on_bDepositB_clicked, false);
	end

	gui.b.button.withdraw = GuiButton(10, 160, 101, 31, "Withdraw", false, gui.b.tab.action);
	if on_bWithdrawB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.withdraw, on_bWithdrawB_clicked, false);
	end

	gui.b.button.set_name = GuiButton(390, 10, 101, 31, "Set Name", false, gui.b.tab.action);
	if on_bNameB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.set_name, on_bNameB_clicked, false);
	end

	gui.b.button.set_owner = GuiButton(390, 60, 101, 31, "Set Owner", false, gui.b.tab.action);
	if on_bOwnerB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.set_owner, on_bOwnerB_clicked, false);
	end

	gui.b.button.cost = GuiButton(390, 110, 101, 31, "Set Cost", false, gui.b.tab.action);
	if on_bCostB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.cost, on_bCostB_clicked, false);
	end

	gui.b.button.set_bank = GuiButton(390, 160, 101, 31, "Set Bank", false, gui.b.tab.action);
	if on_bBankB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.set_bank, on_bBankB_clicked, false);
	end

	gui.b.edit.action = GuiEdit(130, 50, 241, 31, "", false, gui.b.tab.action);
	guiEditSetMaxLength(gui.b.edit.action, 32767);

	gui.b.label.action = GuiLabel(130, 10, 241, 21, "Action:", false, gui.b.tab.action);
	guiLabelSetHorizontalAlign(gui.b.label.action, "center", false);
	guiLabelSetVerticalAlign(gui.b.label.action, "center");
	guiLabelSetColor(gui.b.label.action, 255, 0, 0);

	gui.b.button.accept = GuiButton(130, 100, 241, 41, "Accept", false, gui.b.tab.action);
	if on_bAcceptB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.accept, on_bAcceptB_clicked, false);
	end

	gui.b.button.destroy = GuiButton(130, 155, 241, 41, "Destroy", false, gui.b.tab.action);
	if on_bDestroyB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.destroy, on_bDestroyB_clicked, false);
	end

	gui.b.label.about = GuiLabel(10, 365, 511, 31, "Made By JR10", false, gui.b.window);
	guiLabelSetHorizontalAlign(gui.b.label.about, "center", false);
	guiLabelSetVerticalAlign(gui.b.label.about, "center");
	guiLabelSetColor(gui.b.label.about, 255, 170, 0);

	gui.b.button.x = GuiButton(480, 25, 31, 31, "X", false, gui.b.window);
	if on_bXB_clicked then
		addEventHandler("onClientGUIClick", gui.b.button.x, on_bXB_clicked, false);
	end

	-- Buy Business Window
	gui.bb = {image = {}}
	local window_width, window_height = 332, 193;
	local left = screen_width/2 - window_width/2;
	local top = screen_height/2 - window_height/2;
	gui.bb.window = GuiWindow(left, top, window_width, window_height, "Buy Business", false);
	guiWindowSetSizable(gui.bb.window, false);
	guiWindowSetMovable(gui.bb.window, false);
	guiSetProperty(gui.bb.window, "AlwaysOnTop", "true");
	guiSetAlpha(gui.bb.window, 1);
	guiSetVisible(gui.bb.window, false);

	gui.bb.info = GuiLabel(0, 15, 331, 51, "Are you sure you want to Buy This Business", false, gui.bb.window);
	guiLabelSetHorizontalAlign(gui.bb.info, "center", false);
	guiLabelSetVerticalAlign(gui.bb.info, "center");
	guiLabelSetColor(gui.bb.info, 0, 255, 255);

	gui.bb.image.accept = GuiStaticImage(50, 125, 71, 51, "files/tick.png", false, gui.bb.window);
	if on_bacAcceptI_clicked then
		addEventHandler("onClientGUIClick", gui.bb.image.accept, on_bacAcceptI_clicked, false);
	end

	gui.bb.image.cancel = GuiStaticImage(220, 125, 71, 51, "files/wrong.png", false, gui.bb.window);
	if on_bacCancelI_clicked then
		addEventHandler("onClientGUIClick", gui.bb.image.cancel, on_bacCancelI_clicked, false);
	end
	addEventHandler("onClientMouseEnter", gui.bb.image.accept, on_bacAcceptI_entered, false);
	addEventHandler("onClientMouseEnter", gui.bb.image.cancel, on_bacCancelI_entered, false);
	addEventHandler("onClientMouseLeave", gui.bb.image.accept, on_bacAcceptI_left, false);
	addEventHandler("onClientMouseLeave", gui.bb.image.cancel, on_bacCancelI_left, false);
end);

function on_cbPickcB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or (state ~= "up") then return; end
	local pos = localPlayer.position;
	local int = localPlayer.interior;
	local dim = localPlayer.dimension;
	gui.cb.edit.posx.text = pos.x;
	gui.cb.edit.posy.text = pos.y;
	gui.cb.edit.posz.text = pos.z;
	gui.cb.edit.intdim.text = int..", "..dim;
end

function on_cbClearB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or (state ~= "up") then return; end
	gui.cb.edit.posx.text = "";
	gui.cb.edit.posy.text = "";
	gui.cb.edit.posz.text = "";
	gui.cb.edit.intdim.text = "";
	gui.cb.edit.name.text = "";
	gui.cb.edit.cost.text = "";
	gui.cb.edit.payout.text = "";
	gui.cb.edit.payout_time.text = "";
	gui.cb.unit:setSelected(1);
end

function on_cbCancelB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or (state ~= "up") then return; end
	gui.cb.window.visible = false;
	showCursor(false);
end

function on_cbCreateB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or (state ~= "up") then return; end
	local posX, posY, posZ, intDim = gui.cb.edit.posx.text, gui.cb.edit.posy.text, gui.cb.edit.posz.text, gui.cb.edit.intdim.text;
	local name = gui.cb.edit.name.text;
	local cost = gui.cb.edit.cost.text;
	local payout = gui.cb.edit.payout.text;
	local payoutTime = gui.cb.edit.payout_time.text;
	local payoutUnit = gui.cb.unit:getItemText(gui.cb.unit:getSelected());
	if posX ~= "" and name ~= "" and cost ~= ""  and tonumber(cost) ~= nil and payout ~= "" and tonumber(payout) ~= nil and payoutTime ~= "" and tonumber(payoutTime) ~= nil and tonumber(payoutTime) > 0 and tonumber(cost) > 0 and tonumber(payout) > 0 then
		if #name > 30 then outputMessage("BUSINESS: Business Name Must Be Lower Than 31 Character", 255, 0, 0); return; end
		local zone = getZoneName(tonumber(posX), tonumber(posY), tonumber(posZ), false);
		local zonec = getZoneName(tonumber(posX), tonumber(posY), tonumber(posZ), true);
		if zone == "Unknown" then
			gui.cbc.edit.location.text = "In the middle of no where";
		else
			gui.cbc.edit.location.text = zone.."("..zonec..")";
		end
		gui.cbc.edit.cost.text = name;
		intDim = intDim:gsub(" ", "");
		local interior = tonumber(gettok(intDim, 1, ","));
		local dimension = tonumber(gettok(intDim, 2, ","));
		gui.cbc.edit.position.text = posX..","..posY..","..posZ..","..interior..","..dimension;
		gui.cbc.edit.cost.text = tostring(tonumber(cost));
		gui.cbc.edit.payout.text = tostring(tonumber(payout));
		gui.cbc.edit.payout_time.text = tostring(tonumber(payoutTime)).." "..payoutUnit;
		gui.cbc.window.visible = true;
	else
		outputMessage("BUSINESS: The data isn't correct, please correct it.", 255, 0, 0);
	end
end

addEvent("client:showCreateBusinessGUI", true);
addEventHandler("client:showCreateBusinessGUI", root,
	function()
		gui.cb.window.visible = true;
		showCursor(true);
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

function outputMessage(message, r, g, b)
	triggerServerEvent("server:outputMessage", localPlayer, message, r, g, b);
end

function on_cbcAcceptI_entered()
	guiSetAlpha(source, 0.5);
end

function on_cbcCancelI_entered()
	guiSetAlpha(source, 0.5);
end

function on_cbcAcceptI_left()
	guiSetAlpha(source, 1);
end

function on_cbcCancelI_left()
	guiSetAlpha(source, 1);
end

function on_cbcAcceptI_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return;
	end

	guiSetVisible(gui.cbc.window, false);
	local left, top = screen_width / 2 - 500 / 2, screen_height / 2 - 50 / 2;
	local cbProgressP = GuiProgressBar(left, top, 500, 50, false);
	local cbProgressL = GuiLabel(left, top, 500, 50, "Creating Business 0%", false);
	guiLabelSetHorizontalAlign(cbProgressL, "center");
	guiLabelSetVerticalAlign(cbProgressL, "center");
	local function fillP()
		local progress = tonumber(("%.f") : format(tostring(guiProgressBarGetProgress(cbProgressP) + 4)));
		guiProgressBarSetProgress(cbProgressP, progress);
		guiSetText(cbProgressL, "Creating Business "..tostring(progress).."%");

		if progress < 30 then
			guiLabelSetColor(cbProgressL, 170, 0, 0);
		elseif progress < 70 and progress > 30 then
			guiLabelSetColor(cbProgressL, 180, 100, 0);
		elseif progress < 99 and progress > 70 then
			guiLabelSetColor(cbProgressL, 0, 130, 0);
		elseif progress >= 100 then
			guiSetText(cbProgressL, "Created Business Successfully...Proceeding");
			playSound("files/cash.mp3", false);
			destroyElement(cbProgressP);
			destroyElement(cbProgressL);
			guiSetVisible(gui.cb.window, false);
			showCursor(false);
			on_cbClearB_clicked("left", "up");
			local posX, posY, posZ, interior, dimension = gettok(guiGetText(gui.cbc.edit.position), 1, ","), gettok(guiGetText(gui.cbc.edit.position), 2, ","), gettok(guiGetText(gui.cbc.edit.position), 3, ","), gettok(guiGetText(gui.cbc.edit.position), 4, ","), gettok(guiGetText(gui.cbc.edit.position), 5, ",");
			local name = guiGetText(gui.cbc.edit.cost);
			local cost = guiGetText(gui.cbc.edit.cost);
			local payout = guiGetText(gui.cbc.edit.payout);
			local payoutTime, payoutUnit = gettok(guiGetText(gui.cbc.edit.payout_time), 1, " "), gettok(guiGetText(gui.cbc.edit.payout_time), 2, " ");
			triggerServerEvent("server:createBusiness", localPlayer, posX, posY, posZ, interior, dimension, name, cost, payout, payoutTime, payoutUnit);
			removeEventHandler("onClientRender", root, fillP);
		end
	end
	addEventHandler("onClientRender", root, fillP);
end

function on_cbcCancelI_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetVisible(gui.cbc.window, false);
end

addEventHandler("onClientMouseEnter", root, function() is_cursor_over_gui = true end);
addEventHandler('onClientMouseLeave', root, function() is_cursor_over_gui = false end);

addEventHandler("onClientRender", root,
	function()
		if not isCursorShowing() then return; end
		if is_cursor_over_gui then return; end
		if not guiGetVisible(gui.cb.window) then return; end
		if guiGetVisible(gui.cbc.window) then return; end
		local csX, csY = getCursorPosition();
		if csX and csY then
			dxDrawFramedText("RMB to show/hide cursor", screen_width  * csX + 10, screen_height  * csY - 5, 100, 50, tocolor(255, 255, 255, 255), 1.0, "default-bold", "left", "top", false, false, true);
		end
	end
);

bindKey("mouse2", "up",
	function()
		if not guiGetVisible(gui.cb.window) then return; end
		if guiGetVisible(gui.cbc.window) then return; end
		if isCursorShowing() then
			if is_cursor_over_gui then return; end
			guiSetAlpha(gui.cb.window, 0.1);
			_showCursor(false);
		else
			guiSetAlpha(gui.cb.window, 1);
			_showCursor(true);
		end
	end
);

addEventHandler("onClientRender", root,
	function()
		for index, bMarker in ipairs(getElementsByType("marker", resourceRoot)) do
			local bData = getElementData(bMarker, "bData");
			local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
			local posX, posY, posZ = getElementPosition(bMarker);
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

function on_bBuyB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.bb.window, "Buy Business");
	guiSetText(gui.bb.info, "Buy This Business?");
	guiSetVisible(gui.bb.window, true);
	action = "Buy";
end

function on_bSellB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.bb.window, "Sell Business");
	guiSetText(gui.bb.info, "Sell This Business?");
	guiSetVisible(gui.bb.window, true);
	action = "Sell";
end

function on_bDepositB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Deposit:");
	action = "Deposit";
end

function on_bWithdrawB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Withdraw:");
	action = "Withdraw";
end

function on_bNameB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Set Name:");
	action = "SName";
end

function on_bOwnerB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Set Owner:");
	action = "SOwner";
end

function on_bCostB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Set Cost:");
	action = "SCost";
end

function on_bBankB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.b.label.action, "Set Bank:");
	action = "SBank";
end

function on_bAcceptB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	if action == "Deposit" then
		local text = guiGetText(gui.b.edit.action);
		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(gui.bb.window, "Deposit");
		guiSetText(gui.bb.info, "Deposit $"..tostring(tonumber(text)).." ?");
		guiSetVisible(gui.bb.window, true);
	elseif action == "Withdraw" then
		local text = guiGetText(gui.b.edit.action);
		if tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(gui.bb.window, "Withdraw");
		guiSetText(gui.bb.info, "Withdraw $"..tostring(tonumber(text)).." ?");
		guiSetVisible(gui.bb.window, true);
	elseif action == "SName" then
		local text = guiGetText(gui.b.edit.action);
		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		if #text > 30 then return outputMessage("BUSINESS: Business Name Must Be Lower Than 31 Character", 255, 0, 0) end
		guiSetText(gui.bb.window, "Set Name");
		guiSetText(gui.bb.info, "Set This Business Name To "..text.." ?");
		guiSetVisible(gui.bb.window, true);
	elseif action == "SOwner" then
		local text = guiGetText(gui.b.edit.action);
		if text == "" then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(gui.bb.window, "Set Owner");
		guiSetText(gui.bb.info, "Set This Business Owner To "..text.." ?");
		guiSetVisible(gui.bb.window, true);
	elseif action == "SCost" then
		local text = guiGetText(gui.b.edit.action);
		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(gui.bb.window, "Set Cost");
		guiSetText(gui.bb.info, "Set This Business Cost To "..tostring(tonumber(text)).." ?");
		guiSetVisible(gui.bb.window, true);
	elseif action == "SBank" then
		local text = guiGetText(gui.b.edit.action);
		if text == "" or tonumber(text) == nil or tonumber(text) < 1 then return outputMessage("BUSINESS: Invalid Value", 255, 0, 0) end
		guiSetText(gui.bb.window, "Set Bank");
		guiSetText(gui.bb.info, "Set This Business Bank To "..tostring(tonumber(text)).." ?");
		guiSetVisible(gui.bb.window, true);
	end
end

function on_bXB_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetVisible(gui.b.window, false);
	showCursor(false);
	setElementFrozen(localPlayer, false);
end

function on_bDestroyB_clicked(button, state)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetText(gui.bb.window, "Destroy Business");
	guiSetText(gui.bb.info, "Destroy This Business?");
	guiSetVisible(gui.bb.window, true);
	action = "Destroy";
end

addEvent("client:showBusinessGUI", true);
addEventHandler("client:showBusinessGUI", root,
	function(bMarker, isOwner, isAdmin)
		local bData = getElementData(bMarker, "bData");
		local id, name, owner, cost, payout, payoutTime, payoutOTime, payoutUnit, bank, timer = unpack(bData);
		local posX, posY, posZ = getElementPosition(bMarker);
		if #tostring(id) == 1 then id = "0"..tostring(id) end
		guiSetText(gui.b.window, name);
		guiSetText(gui.b.label.id, "ID: #"..id);
		guiSetText(gui.b.label.name, "Name: "..name);
		guiSetText(gui.b.label.owner, "Owner: "..owner);
		guiSetText(gui.b.label.cost, "Cost: $"..cost);
		guiSetText(gui.b.label.payout, "Payout: $"..payout);
		guiSetText(gui.b.label.payout_time, "Payout Time: "..payoutOTime.." "..payoutUnit);
		guiSetText(gui.b.label.location, "Location: "..getZoneName(posX, posY, posZ, false).."("..getZoneName(posX, posY, posZ, true)..")");
		guiSetText(gui.b.label.bank, "Bank: $"..bank);

		if isAdmin and isOwner then
			guiSetEnabled(gui.b.tab.action, true);
			guiSetEnabled(gui.b.button.sell, true);
			guiSetEnabled(gui.b.edit.action, true);
			guiSetEnabled(gui.b.button.deposit, true);
			guiSetEnabled(gui.b.button.withdraw, true);
			guiSetEnabled(gui.b.button.accept, true);
			guiSetEnabled(gui.b.button.set_name, true);
			guiSetEnabled(gui.b.button.set_owner, true);
			guiSetEnabled(gui.b.button.cost, true);
			guiSetEnabled(gui.b.button.set_bank, true);
			guiSetEnabled(gui.b.button.buy, false);
		elseif isAdmin and not isOwner and owner ~= "For Sale" then
			guiSetEnabled(gui.b.tab.action, true);
			guiSetEnabled(gui.b.button.set_name, true);
			guiSetEnabled(gui.b.button.set_owner, true);
			guiSetEnabled(gui.b.button.cost, true);
			guiSetEnabled(gui.b.button.set_bank, true);
			guiSetEnabled(gui.b.button.accept, true);
			guiSetEnabled(gui.b.edit.action, true);
			guiSetEnabled(gui.b.button.sell, true);
			guiSetEnabled(gui.b.button.buy, false);
			guiSetEnabled(gui.b.button.deposit, false);
			guiSetEnabled(gui.b.button.withdraw, false);
		elseif isAdmin and not isOwner and owner == "For Sale" then
			guiSetEnabled(gui.b.tab.action, true);
			guiSetEnabled(gui.b.button.set_name, true);
			guiSetEnabled(gui.b.button.set_owner, true);
			guiSetEnabled(gui.b.button.cost, true);
			guiSetEnabled(gui.b.button.set_bank, true);
			guiSetEnabled(gui.b.button.accept, true);
			guiSetEnabled(gui.b.edit.action, true);
			guiSetEnabled(gui.b.button.sell, false);
			guiSetEnabled(gui.b.button.buy, true);
			guiSetEnabled(gui.b.button.deposit, false);
			guiSetEnabled(gui.b.button.withdraw, false);
		elseif not isAdmin and isOwner then
			guiSetEnabled(gui.b.tab.action, true);
			guiSetEnabled(gui.b.button.set_name, false);
			guiSetEnabled(gui.b.button.set_owner, false);
			guiSetEnabled(gui.b.button.cost, false);
			guiSetEnabled(gui.b.button.set_bank, false);
			guiSetEnabled(gui.b.button.accept, true);
			guiSetEnabled(gui.b.edit.action, true);
			guiSetEnabled(gui.b.button.sell, true);
			guiSetEnabled(gui.b.button.deposit, true);
			guiSetEnabled(gui.b.button.withdraw, true);
			guiSetEnabled(gui.b.button.buy, false);
		elseif not isAdmin and not isOwner and owner ~= "For Sale" then
			guiSetEnabled(gui.b.tab.action, false);
			guiSetSelectedTab(gui.b.tab_panel, gui.b.tab.info);
		elseif not isAdmin and not isOwner and owner == "For Sale" then
			guiSetEnabled(gui.b.tab.action, true);
			guiSetEnabled(gui.b.button.set_name, false);
			guiSetEnabled(gui.b.button.set_owner, false);
			guiSetEnabled(gui.b.button.cost, false);
			guiSetEnabled(gui.b.button.set_bank, false);
			guiSetEnabled(gui.b.button.accept, false);
			guiSetEnabled(gui.b.edit.action, false);
			guiSetEnabled(gui.b.button.sell, false);
			guiSetEnabled(gui.b.button.deposit, false);
			guiSetEnabled(gui.b.button.withdraw, false);
			guiSetEnabled(gui.b.button.buy, true);
		end

		guiSetVisible(gui.b.window, true);
		showCursor(true);
	end
);

function on_bacAcceptI_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	local text = guiGetText(gui.b.edit.action);
	triggerServerEvent("server:onActionAttempt", localPlayer, action, text);
	guiSetVisible(gui.bb.window, false);
end

function on_bacCancelI_clicked(button, state, absoluteX, absoluteY)
	if(button ~= "left") or(state ~= "up") then
		return;
	end
	guiSetVisible(gui.bb.window, false);
end

function on_bacAcceptI_entered()
	guiSetAlpha(source, 0.5);
end

function on_bacCancelI_entered()
	guiSetAlpha(source, 0.5);
end

function on_bacAcceptI_left()
	guiSetAlpha(source, 1);
end

function on_bacCancelI_left()
	guiSetAlpha(source, 1);
end

addEvent("client:onAction", true);
addEventHandler("client:onAction", root,
	function(close, playCash)
		if close then
			guiSetVisible(gui.b.window, false);
			showCursor(false);
		end
		if playCash then
			playSound("files/cash.mp3", false);
		end
		guiSetText(gui.b.label.action, "Action:");
		guiSetText(gui.b.edit.action, "");
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
