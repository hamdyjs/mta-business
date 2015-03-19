local screen_width, screen_height = GuiElement.getScreenSize();
local relative_width, relative_height = screen_width / 1440, screen_height / 900

local static_left = relative_width * 983;
local cur_left = static_left;
local move_offet = relative_width * 20;
local cur_message = "";
local cur_color = {255, 255, 255};
local message_moving = false;
local message_moving_back = false;
local message_moving_back_timer;

addEventHandler("onClientRender", root, function()
	dxDrawFramedText(cur_message, cur_left, relative_height * 618.0, cur_left + (relative_width * 456), relative_height * 645.0, tocolor(cur_color[1], cur_color[2], cur_color[3], 255), 1.0, "default-bold", "center", "center", false, true, true);
end);

function dxOutputMessage(message, r, g, b)
	if (message_moving) then removeEventHandler("onClientRender", root, moveMessage); end
	if (message_moving_back) then removeEventHandler("onClientRender", root, moveMessageBack); end
	if (message_moving_back_timer and message_moving_back_timer:isValid()) then message_moving_back_timer:destroy(); end
	cur_left, cur_message, cur_color = relative_width * 1440, message or "", {r or 255, g or 255, b or 255};
	message_moving_back_timer = Timer(hideMessage, 5000, 1);
	addEventHandler("onClientRender", root, moveMessage);
	message_moving = true;
end

function moveMessage()
	cur_left = cur_left - move_offet;
	if (cur_left <= static_left) then
		removeEventHandler("onClientRender", root, moveMessage);
		cur_left = relative_width * 983;
		message_moving = false;
	end
end

function hideMessage()
	message_moving_back = true;
	addEventHandler("onClientRender", root, moveMessageBack);
end

function moveMessageBack()
	cur_left = cur_left + move_offet;
	if (cur_left >= relative_width * 1440) then
		removeEventHandler("onClientRender", root, moveMessageBack);
		cur_left = relative_width * 1440;
		message_moving_back = false;
	end
end
	
function dxDrawFramedText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
	dxDrawText(message, left + 1, top + 1, width + 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI);
	dxDrawText(message, left + 1, top - 1, width + 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI);
	dxDrawText(message, left - 1, top + 1, width - 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI);
	dxDrawText(message, left - 1, top - 1, width - 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI);
	dxDrawText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI);
end

addEvent("business.dxOutputMessage", true)
addEventHandler("business.dxOutputMessage", root, function(message, r, g, b)
	dxOutputMessage(message, r, g, b);
end);