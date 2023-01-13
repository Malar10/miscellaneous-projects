toggle = false
number = GetInt("iterations", 3)
number = 1

function init()
	allX = {}
	for i=1, number do
		allX[i] = 0
	end
	allY = {}
	for i=1, number do
		allY[i] = 0
	end
	allZ = {}
	for i=1, number do
		allZ[i] = 0
	end

	mat = CreateMaterial("wood", 1, 1, 1)
	Vox(0, 0, 0, 0, 0, 0)
	
	
	--Box(0, 0, 0, 10, 10, 10)
	fractal(number, 0, 0)
end

function fractal(layers)
	for i=0, 2 do
		for j=0, 2 do
			for h=0, 2 do
				if not (j==1 and i==1 or j==1 and h==1 or h==1 and i==1) then --remove "not" for another funky fractal

					if layers == 0 then
						x = getSus(allX)
						y = getSus(allY)
						z = getSus(allZ)

						Material(mat)
						Box(x, y, z, x+1, y+1, z+1)

					else
						allX[layers] = i
						allY[layers] = j
						allZ[layers] = h
						fractal(layers - 1)
					end
				end
			end
		end
	end
end

function getSus(list)
	sum = 0

	for i=1, #list do
		sum = sum + (list[i] * (3 ^ (i-1)))
	end

	return sum
end