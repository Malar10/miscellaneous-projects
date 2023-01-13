--VERY COOL GUN PICKUP SCRIPT MADE BY MALARIO

function init()
	guns = FindShapes("gun")
end

function tick(dt)
	health = GetPlayerHealth()
	shape = GetPlayerInteractShape()

	if shape ~= 0 and InputPressed("interact") then
		if isInTable(guns, shape) then
			whichGun = GetTagValue(shape, "gun")
			SetBool("game.tool."..whichGun..".enabled", true)
			SetString("game.player.tool", whichGun)

			RemoveTag(shape, "interact")
			table.remove(guns, shape)
			Delete(shape)
		end
	end
end

function isInTable(table, thing)
	for i=1, #table do
		if table[i] == thing then
			return true, i
		end
	end
	return false, 0
end