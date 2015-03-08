-- Business System v1.2 - updatecheck.server.lua - Checks for any updates for the resource on the community
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

addEventHandler("onResourceStart", resourceRoot, function()
	callRemote("http://community.mtasa.com/mta/resources.php", function(name, version)
		if (name:lower():find("error") or version == 0) then return; end
		checkForUpdate(version);
	end, "version", "business");
end);

function checkForUpdate(version)
	local resource_version = resource:getInfo("version")
	local rv1, rv2, rv3 = unpack(split(version, "."));
	local v1, v2, v3 = unpack(split(resource_version, "."));
	if (not rv3) then rv3 = 0; end
	if (not v3) then v3 = 0; end
	rv1, rv2, rv3, v1, v2, v3 = tonumber(rv1), tonumber(rv2), tonumber(rv3), tonumber(v1), tonumber(v2), tonumber(v3);
	if (rv1 and v1) then
		if ((rv1 > v1) or (rv2 > v2 and rv1 >= v1) or (rv3 > v3 and rv2 >= v2 and rv1 >= v1)) then
			outputDebugString("Business System v"..resource_version.." is outdated, v"..version.." is released. Be sure to download it", 3);
		end
	end
end