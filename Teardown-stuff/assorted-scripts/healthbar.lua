decimal = 0.1 --amount needed to destroy to kill enemy. range 0-1
width = 500 --width of the boss health bar

body = FindBody("badguy")
startMass = GetBodyMass(body)
startHealth = startMass * decimal

function draw()
	health = (GetBodyMass(body) - (startMass * (1 - decimal))) / startHealth
	
	if health > 0 then
		UiTranslate(UiCenter(), 30)
		UiAlign("center top")
		UiColor(1, 1, 1)
		UiFont("bold.ttf", 50)
		UiText("Boss Health", true)
		UiTranslate(-width/2, 0)

		progressBar(width, 40, health)
	end
end

function progressBar(w, h, t) --copy/pasted cause i couldnt get #include to work
	UiPush()
		UiAlign("left top")
		UiColor(0, 0, 0, 0.5)
		UiImageBox("ui/common/box-solid-10.png", w, h, 6, 6)
		if t > 0 then
			UiTranslate(2, 2)
			w = (w-4)*t
			if w < 12 then w = 12 end
			h = h-4
			UiColor(1,1,1,1)
			UiImageBox("ui/common/box-solid-6.png", w, h, 6, 6)
		end
	UiPop()
end