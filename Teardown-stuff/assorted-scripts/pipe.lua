pipe = FindShape("pipe")
pipeTrans = GetShapeWorldTransform(pipe)

detectors = FindLights("detector")

offset = GetFloatParam("offset", 0)
onTime = GetFloatParam("ontime", 5)
offtime = GetFloatParam("offtime", 5)

smoking = false
smokeTimer = offset
smokeSpeed = 10

------------------------ change these if you want
damage = 0.2
damageTimerMax = 0.25
----------------------------
damageTimer = damageTimerMax

function tick(dt)

	smokeTimer = smokeTimer + dt
	damageTimer = damageTimer + dt
	inSmoke = false

	if smoking and smokeTimer > onTime then
		smoking = false
		smokeTimer = 0
	elseif not smoking and smokeTimer > offtime then
		smoking = true
		smokeTimer = 0
	end

	if smoking then
		for i=1, #detectors do
			detector = detectors[i]

			steamTrans = GetLightTransform(detector)

			direction = TransformToParentVec(steamTrans, Vec(0, 0, 1))
			--DebugLine(steamTrans.pos, VecAdd(steamTrans.pos, direction))

			ParticleCollide(0, 1)
			ParticleRadius(0.1, 1, "easein")
			SpawnParticle(steamTrans.pos, VecScale(direction, smokeSpeed), 0.6)
	


			playerPos = GetPlayerTransform().pos
			playerEyePos = GetPlayerCameraTransform().pos
			playerBody = VecLerp(playerPos, playerEyePos, 0.5)

			if not inSmoke then
				for i=1, 10 do
					playerBody = VecLerp(playerPos, playerEyePos, i * 0.1)
					if IsPointAffectedByLight(detector, playerBody) then
						--DebugPrint("yea")
						inSmoke = true
					end
				end
			end
		end
	end

	if inSmoke and damageTimer > damageTimerMax then
		SetPlayerHealth(GetPlayerHealth() - damage)
		damageTimer = 0
		--DebugPrint("damage taken: "..damage)
	end
end