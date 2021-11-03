function Initialize()
	print("Iniciando Script")
	-- local query = '{"Level":"Study", "Query": { "StudyDate":"20210903"}}'
	
	local studydate = {}
	studydate['StudyDate'] = '20201111' --AAAAMMDD
	local queryStudy = {}
	queryStudy['Level'] = 'Study'
	queryStudy['Query'] = studydate
	local file = io.open("study.txt","a+")
	io.output(file)
	
	--PrintRecursive(queryStudy)
	--PrintRecursive(DumpJson(queryStudy,true))
	--[[ 
	--]]
	local enddate = "0"
	
	local study = RestApiPost('/tools/find' , DumpJson(queryStudy, true)) --Queries studies by date and recieves JSON with IDs
	
	--PrintRecursive(study)
	
	--SendToModality(ParseJson(study), "CEDIM")
	--print("Study:")
	--PrintRecursive(ParseJson(study))
	
	local StudyIDTable = ParseJson(study) --Parses studies JSON as Lua table
	PrintRecursive(StudyIDTable)
	
	
	for i,v in ipairs(StudyIDTable) do --Iterates through studies table
		--PrintRecursive(v)
		--PrintRecursive('/studies/'.. v)
		local StudyDump = RestApiGet('/studies/'.. v) --Queries study ID for full data
		local StudyTable = ParseJson(StudyDump) --Parses Study JSON as Lua table
		local SeriesIDTable = StudyTable['Series'] --Retrieves only imaging series IDs table from Study
		--print("SeriesIDTable:")
		--PrintRecursive(SeriesIDTable)
		
		for i,v in ipairs(SeriesIDTable) do --Iterates through Series ID Table
		print("Enviando serie")
		PrintRecursive(v)
		RestApiPost('/modalities/PRORADIS/store', v)
		--[[
			local SerieDump = RestApiGet('/series/'.. v) --Queries series ID for full data
			--print("SeriesDump")
			--PrintRecursive(ParseJson(SerieDump))
			local SeriesDumpTable = ParseJson(SerieDump) --Parses Serie JSON as Lua table
			local InstanceIDTable = SeriesDumpTable['Instances'] --Retrieves only instances IDs table from serie
			--print("InstanceIDTable")
			--PrintRecursive(InstanceIDTable)
			
			for i,v in ipairs(InstanceIDTable) do --Iterates through Instances IDs table
				local InstanceDump = RestApiGet('/instances/'.. v)
				PrintRecursive(v)
				--print(InstanceDump)

				local InstanceString = {}
				InstanceString = DumpJson(v, true)
				PrintRecursive(InstanceString)
				RestApiPost('/modalities/PRORADIS/store', InstanceString)
				--local modality = "PRORADIS"
				--SendToModality(v, modality) --Sends Instance to Modality
			end
			--]]
		end
		--SendToModality(v, 'PRORADIS')
		--PrintRecursive("SendToModality(".. v .."CEDIM")
	end

end