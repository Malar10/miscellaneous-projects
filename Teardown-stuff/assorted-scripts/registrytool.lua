function init()
	test = {"game", "savegame", "hud", "level", "options"}
	path = ""
	index = 1

	for i=1, #test do
		DebugPrint(test[i])
	end
end

function tick(dt)
	if InputPressed("t") then
		index = index + 1
		if index > #test then
			index = 1
		end
	end

	if InputPressed("r") then
		test = {"game", "savegame", "hud", "level", "options"}
		index = 1
		path = ""
		DebugPrint("-------------------")
		for i=1, #test do
			DebugPrint(test[i])
		end
	end

	if InputPressed("y") then
		if path == "" then
			path = test[index]
		else
			path = path.."."..test[index]
		end
		test = ListKeys(path)
		DebugPrint("-------------------")
		if #test ~= 0 then
			for i=1, #test do
				DebugPrint(test[i])
			end
		else
			value = GetFloat(path)
			if value == 0 then
				value = GetInt(path)
				if value == 0 then
					value = GetBool(path)
					if value == false then
						value = GetString(path)
					end
				end
			end
			DebugPrint(path.." = "..value)
		end
		index = 1
	end

	DebugWatch("path", path)
	DebugWatch("index", index)
	DebugWatch("choice", test[index])
end