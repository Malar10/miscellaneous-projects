mine = FindTrigger(mine)
body = FindShape(minebody)
click = LoadSound("clickup.ogg")
beep = LoadSound("warning-beep.ogg")
minePos = GetTriggerTransform(mine).pos
exploded = false
beepTimer = 1

a = VecAdd(minePos, Vec(-0.25, -0.15, -0.25))
b = VecAdd(minePos, Vec(0.25, 0.25, 0.25))

function tick(dt)
	--DebugCross(a)
	--DebugCross(b)
	

	if not exploded then
		local playerPos = VecAdd(GetPlayerTransform().pos, Vec(0, 0.1, 0))
		inTrigger = IsPointInTrigger(mine, playerPos)
		local broken = IsShapeBroken(body)
		QueryRequire("dynamic physical")
		list = QueryAabbBodies(a, b)

		if #list ~= 0 or broken then
			Explode()
		elseif inTrigger and not stepped then
			stepped = true
			time = 0
			PlaySound(click, minePos, 1)
		end

		if stepped then
			time = time + dt
			if time >= 0.5 then
				Explode()
			end
		end

		dist = VecLength(VecSub(playerPos, minePos))
		if beepTimer > dist * 0.08 and dist < 15 then
			PlaySound(beep, minePos, 1)
			if not lit and not set then
				scale = 1
				set = true
				lit = true
			end
			if lit and not set then
				scale = 0
				set = true
				lit = false
			end
			beepTimer = 0
			set = false
		end
		beepTimer = beepTimer + dt
		SetShapeEmissiveScale(body, scale)
	end
end

function Explode()
	Explosion(minePos, 2)
	Explosion(minePos, 2) --do it twice to kill the player lol

	exploded = true
end