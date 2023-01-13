function init()
	knownPoint = {0, 5, 1}
	s = {1, 0, 0}
	v = {0, 1, 0}
	size = 15
	quality = 2
	points = 0
end

function update(dt)
	if InputDown("y") then
		quality = quality + 0.1
	end
	if InputDown("u") then
		quality = quality - 0.1
	end
	if InputDown("z") then
		size = size + 1
	end
	if InputDown("x") then
		size = size - 1
	end
end

function tick(dt)
	points = 0
	DebugCross(knownPoint, 1, 0, 0)

	for i = 0, size * quality do
		for j = 0, size * quality do
			point = VecAdd(VecScale(VecNormalize(s), i), VecScale(VecNormalize(v), j))
			point = VecScale(point, 1/quality)
			DebugCross(VecAdd(point, knownPoint), 0, 1, 0)
			points = points + 1
		end
	end

	DebugWatch("dt", dt)
	DebugWatch("points", points)
	DebugWatch("size", size)
	DebugWatch("quality", quality)
end