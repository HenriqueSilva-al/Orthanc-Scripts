function OnStoredInstance(instanceId, tags, metadata, origin)
	if origin['RequestOrigin'] ~= 'LuaScript' then
		PrintRecursive(instanceId)
		SendToModality(instanceId, 'CEDIM')
	end
end