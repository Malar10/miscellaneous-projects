--BUGS--
--too much damaag

--made by malario for the Aggression map

loc = FindBody("test")

allBodies = FindBodies(nil, true)

bodies = {}



moving = false
targetHeight = 10
maxDist = 25 --max pickup range
dropDist = maxDist + 20 --floating things will keep floating but no pickup

damageTimer = 20
damaging = false
biggestDamage = 0

idkman = Vec(0, 0, 0)

function tick(dt)
	damaging = false
	biggestDamage = 0

	checkBodies()

	removeBodies()

	for i=1, #bodies do --do stuff with good bodies
		local body = bodies[i]

		bodyTrans = GetBodyTransform(body)
		local com = TransformToParentPoint(bodyTrans, GetBodyCenterOfMass(body))

		playerPos = GetPlayerTransform().pos
		local playerDist = VecLength(VecSub(playerPos, com))
		local mass = GetBodyMass(body)
		local damage = mass * 0.0005
		if damage < 0.15 then
			damage = 0.15
		end

		if playerDist < 2 then
			if damage > biggestDamage then
				biggestDamage = damage
			end
			damaging = true
		end

		DrawBodyOutline(body, 1, 0, 0, 1)

		if not moving then
			hover(body)
		end 
		if shootAll then
			yeet(body)
		end
	end


	if damaging and damageTimer > 0.3 then
		SetPlayerHealth(GetPlayerHealth() - biggestDamage)
		damageTimer = 0
		--DebugPrint("damage taken: "..biggestDamage)
	end
	damageTimer = damageTimer + dt



	------------------------------- inputs for testing
	--put custom code here--
	if InputDown("z") then
		moving = true 
		shootAll = true --yeet all
	else 
		moving = false
		shootAll = false
	end

	if InputPressed("x") and #bodies ~= 0 then --yeet one
		moving = true
		rand = math.random(1, #bodies)
		yeet(bodies[rand])
	else
		moving = false
	end

	if InputDown("c") and #bodies ~= 0 then --rapid yeet
		moving = true
		rand = math.random(1, #bodies)
		yeet(bodies[rand])
	else
		moving = false
	end

	if InputPressed("b") then
		debugThing()
	end
end

function checkBodies()
	--reset table
	for k in pairs (allBodies) do
		allBodies [k] = nil
	end

	--DebugPrint("allbodies cleared: "..#allBodies)

	allBodies = FindBodies(nil, true)

	for i=1, #allBodies do
		local body = allBodies[i]
		local mass = GetBodyMass(body)
		if body ~= loc then

			local trans = GetBodyTransform(body)
			com = TransformToParentPoint(trans, GetBodyCenterOfMass(body))
			local dist = VecLength(VecSub(GetBodyTransform(loc).pos, com))

			--DebugPrint(dist)
			inBodies, index = isInTable(bodies, body)

			if dist <= maxDist and not inBodies and IsBodyDynamic(body) and mass ~= 0 then
				table.insert(bodies, body)
				--DebugPrint("inserted body: "..body)
			end
		end
	end
end

function removeBodies()
	for i=1, #bodies do --remove bad bodies
		local body = bodies[i]
		if body ~= nil then
			local bodyTrans = GetBodyTransform(body)
			local com = TransformToParentPoint(bodyTrans, GetBodyCenterOfMass(body))
			local playerPos = GetPlayerTransform().pos

			local dist = VecLength(VecSub(GetBodyTransform(loc).pos, com))
			local mass = GetBodyMass(body)

			if dist > dropDist then
				remove = true
			elseif not IsBodyDynamic(body) then
				remove = true
			elseif mass == 0 then
				remove = true
			else
				remove = false
			end

			if remove then --will create gap at the end idk how to fix so i just made a nil check
				table.remove(bodies, i)
				--DebugPrint("removed body: "..body)
				i = i - 1
			end
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

function hover(body) --it's a mess
	bodyTrans = GetBodyTransform(body)
	local com = TransformToParentPoint(bodyTrans, GetBodyCenterOfMass(body))
	direction = QuatLookAt(playerPos, com)

	newTrans = Transform(bodyTrans.pos, direction)

	SetBodyTransform(body, newTrans)
	local newCom = TransformToParentPoint(newTrans, GetBodyCenterOfMass(body))
	local comDiff = VecSub(com, newCom) --difference of COM positions
	newnewTrans = Transform(VecAdd(newTrans.pos, comDiff), newTrans.rot) --adjust pos of thing so COM stays in same place
	SetBodyTransform(body, newnewTrans)

	if com[2] > targetHeight then
		velOffset = -0.05
	elseif com[2] < targetHeight then
		velOffset = 0.05
	else
		velOffset = 0
	end

	SetBodyVelocity(body, VecAdd(GetBodyVelocity(body), {0, 1/6 + velOffset, 0}))
end

function yeet(body)
	bodyTrans = GetBodyTransform(body)
	local com = TransformToParentPoint(bodyTrans, GetBodyCenterOfMass(body))

	playerPos = GetPlayerTransform().pos

	direction = QuatLookAt(playerPos, com)
	newTrans = Transform(bodyTrans.pos, direction)
	dir1 = TransformToParentVec(newTrans, Vec(0, 0, -1))
	SetBodyVelocity(body, VecScale(dir1, -50))
end

function debugThing()
	playerCam = GetCameraTransform()
    camDir = TransformToParentVec(playerCam, Vec(0, 0, -1))

	QueryRequire("physical")
    hit, dist, normal, shape = QueryRaycast(playerCam.pos, camDir, 200)
    if hit then
	    local body = GetShapeBody(shape)
		local bodyTrans = GetBodyTransform(body)
		local inAll = isInTable(allBodies, body)
		local inBodies = isInTable(bodies, body)
		local dynamic = IsBodyDynamic(body)
		local mass = GetBodyMass(body)
		com = TransformToParentPoint(bodyTrans, GetBodyCenterOfMass(body))
		local dist = VecLength(VecSub(GetBodyTransform(loc).pos, com))

		DebugPrint("body: "..body)
		DebugPrint("in allBodies: "..tostring(inAll))
		DebugPrint("in bodies: "..tostring(inBodies))
		DebugPrint("distance: "..dist)
		DebugPrint("dynamic: "..tostring(dynamic))
		DebugPrint("mass: "..mass)
		DebugPrint("COM: "..VecStr(GetBodyCenterOfMass(body)))
		DebugPrint("-------------------------")

		DrawBodyOutline(body, 0, 1, 0, 1)
		DebugCross(com)
    end
	DebugPrint("allBodies total: "..#allBodies)
	DebugPrint("bodies total: "..#bodies)
	DebugPrint("-------------------------")
	
	return com
end