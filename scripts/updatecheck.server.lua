addEventHandler("onResourceStart", resourceRoot, function()
	callRemote("http://community.mtasa.com/mta/resources.php", function(name, version)
		if (name:lower():find("error") or version == 0) then return; end
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
	end, "version", "business");
end);