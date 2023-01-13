--VERY COOL HEALTH SCRIPT MADE BY MALARIO

function init()
	health = 1
	oldHealth = 1

	healthPacks = FindShapes("health")
end

function tick(dt)
	health = GetPlayerHealth()
	shape = GetPlayerInteractShape()

	if shape ~= 0 and InputPressed("interact") then
		if isInTable(healthPacks, shape) then
			local healthToGet = tonumber(GetTagValue(shape, "health"))
			health = health + (healthToGet / 100)
			oldHealth = health
			SetPlayerHealth(health)

			RemoveTag(shape, "interact")
			table.remove(healthPacks, shape)
		end
	end

	if health ~= 0 then --if alive
		
		if health > oldHealth then --if regen
			SetPlayerHealth(oldHealth)
		end

		oldHealth = GetPlayerHealth()
	else --if dead
		oldHealth = 1
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