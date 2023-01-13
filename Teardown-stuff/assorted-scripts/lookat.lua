cams = {}
i = 1
camSearch = true
while camSearch do
    local temp = FindLocation("cam"..i.."")
    if temp == 0 then
        camSearch = false
    else
        table.insert(cams, temp)
        i = i + 1
    end
end
--DebugPrint("cams: "..#cams)
cam = cams[1]

camIndex = 1

camsTrans = {}
for i=1, #cams do
	camsTrans[i] = GetLocationTransform(cams[i])
end


--DebugWatch("transes", #camsTrans)

target = FindBody("lookat")
targetTrans = GetBodyTransform(target)

offsets = {}
for i=1, #cams do
	offsets[i] = VecSub(camsTrans[i].pos, targetTrans.pos)
end

followtype = 2 --1 for stationary, 2 for follow
rotateTrack = false --needs to be on to rotate with the target
looking = false --can be toggled to enable or disable the script

function tick()
	--SetBodyVelocity(target, Vec(0, 0, -30))
	--SetBodyAngularVelocity(target, Vec(5, 5, 5))

	if InputPressed("q") then --can be changed for something else
		camIndex = camIndex + 1
		if camIndex > #cams then
			camIndex = 1
		end
		--DebugPrint(camIndex)
	end

	if camIndex == 1 then --example
		followtype = 2
		rotateTrack = true
	elseif camIndex == 2 then
		followtype = 1
		rotateTrack = false
	end

	cam = cams[camIndex]
	camTrans = camsTrans[camIndex]
	followOffset = offsets[camIndex]

	targetTrans = GetBodyTransform(target)
	targetPos = targetTrans.pos

	if follow then
		if followtype == 1 then
			camPos = camTrans.pos
		elseif followtype == 2 then
			if rotateTrack then
				camPos = TransformToParentPoint(targetTrans, followOffset)
			else 
				camPos = VecAdd(targetPos, followOffset)
			end
		end

		direction = QuatLookAt(camPos, targetPos)

		newCamTrans = Transform(camPos, direction)
		SetCameraTransform(newCamTrans)
	end
end