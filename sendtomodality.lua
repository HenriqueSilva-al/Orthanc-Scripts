function OnStoredInstance(instanceID, tags, metadata, origin)
	PrintRecursive(instanceID)
	if origin['RequestedOrigin'] ~= 'Lua' then
	local modifiedId
		if tags['Modality'] == 'CR' or tags['Modality'] == 'DX'then
			if tags['ReferringPhysicianName'] == '' then
				local replace = {}
				replace['ReferringPhysicianName'] = 'MEDICO SOLICITANTE NAO INFORMADO'
				replace['PerformingPhysicianName'] = 'MEDICO SOLICITANTE NAO INFORMADO'
				local remove = {}
				
				local command = {}
				command['Replace'] = replace
				command['Remove'] = remove
				
				--PrintRecursive(replace)
				
				local modifiedFile = RestApiPost('/instances/' .. instanceID .. '/modify', DumpJson(command, true))
				
				--PrintRecursive(DumpJson(command, true))
				
				modifiedId = ParseJson(RestApiPost('/instances/', modifiedFile)) ['ID']
				RestApiDelete('/instances/' .. instanceID)
				
				if tags['InstitutionalDepartmentName'] == 'MAMOGRAFIA' then
				
					--PrintRecursive(modifiedId)
					local replace = {}
					replace['StudyDescription'] = 'MAMOGRAFIA BILATERAL'
					local remove = {}
					
					command = {}
					command['Replace'] = replace
					command['Remove'] = remove
					
					--PrintRecursive(modifiedId)
					
					local modifiedFile = RestApiPost('/instances/' .. modifiedId .. '/modify', DumpJson(command, true))
					RestApiDelete('/instances/' .. modifiedId)
					modifiedId = ParseJson(RestApiPost('/instances/', modifiedFile)) ['ID']
					--PrintRecursive(modifiedId)
				end
			else
				modifiedId = instanceID
			end
			RestApiPost('/modalities/PRORADIS/store', modifiedId)
		end
	end
end
