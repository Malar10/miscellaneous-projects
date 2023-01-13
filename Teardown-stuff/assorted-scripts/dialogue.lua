function init()
	lines = 3
	cooldown = 1.5

	number = 1
	timer = 0
	sub = 1
	playing = false
	currentMusic = 0
	musicTimer = 0

	subs = {{"sub1 line1", "sub1 line2", "sub1 line3", "sub1 line4"}, 
			{"sub2 line1", "sub2 line2", "sub2 line3"}, 
			{"sub3 line1"}}

	if #subs ~= lines then
		DebugPrint("ERROR: different amount of subtitles and voice lines")
	end

	triggers = {}

	for i=1, lines do
		local temp = FindTrigger("d"..i.."")
		table.insert(triggers, temp)
		--DebugPrint("added trigger number"..i..", "..temp)
	end
	--DebugPrint("triggers: "..#triggers)


	levels = {"Cyberpunked", "Scraping The Sky", "Crossbones", "Thats What The Mask Is", "Point of Impact", "Aggression"}
	for i=1, #levels do
		--DebugPrint(levels[i])
	end

	musicTriggers = FindTriggers("music")
	
	--DebugPrint("music triggers: "..#musicTriggers)
end

function tick(dt)
	if HasKey("savegame.mod.Subtitles") then
		subtitles = GetBool("savegame.mod.Subtitles")
	else
		subtitles = true
	end

	if HasKey("savegame.mod.Vlvolume") then
		volume = GetFloat("savegame.mod.Vlvolume")
	else
		volume = 50
	end

	if HasKey("savegame.mod.Mvolume") then
		musicVolume = GetFloat("savegame.mod.Mvolume")
	else
		musicVolume = 50
	end

	playerPos = VecAdd(GetPlayerTransform().pos, Vec(0, 0.3, 0))

	if not playing then
		for i=1, lines do
			trigger = triggers[i]
			activated = GetTagValue(trigger, "activated")
			if activated ~= "true" then
				if IsPointInTrigger(trigger, playerPos) then
					SetTag(trigger, "activated", "true")
					timer = 0
					number = i
					sub = 1
					playing = true
				end
			end
		end
	end

	for i=1, #musicTriggers do
		mtrigger = musicTriggers[i]
		activated = GetTagValue(mtrigger, "activated")
		if activated ~= "true" then
			if IsPointInTrigger(mtrigger, playerPos) then
				SetTag(mtrigger, "activated", "true")
				--UiSound("MOD/dialogue/music/stage"..i..".ogg", volume / 40)
				j = tonumber(GetTagValue(mtrigger, "music"))
				currentMusic = LoadLoop("MOD/dialogue/music/stage"..j..".ogg") --gonna cause lag but idk a better way
				musicTimer = 0
			end
		end
	end

	--DebugWatch("j", j)
	--DebugWatch("playing", playing)
	--DebugWatch("timer", timer)
	--DebugWatch("line", number)
	--DebugWatch("sub", sub)
	--DebugWatch("sub amount", subAmount)
end

function draw(dt)
	if playing then
		subAmount = #subs[number]
	
		if timer < cooldown * subAmount then
			if timer > cooldown * sub then
				sub = sub + 1
			end
			PlayDialog(number, timer, sub)
		else
			playing = false
			timer = 0
		end

		timer = timer + dt
		timer = math.min(timer, cooldown * subAmount)
	end

	if currentMusic ~= 0 then
		PlayLoop(currentMusic, playerPos, musicVolume / 40)
		if musicTimer < 3 then
			TitleCard(j)

			musicTimer = musicTimer + dt
		end
	end
end

function PlayDialog(i, time, sub)
	if i ~= 0 then
		if time == 0 then
			UiSound("MOD/dialogue/sound/sound"..i..".ogg", volume)
		end

		if subtitles then
			UiFont("bold.ttf", 24)

			UiTranslate(UiCenter(), UiMiddle() * 1.8)
			UiAlign("center middle")

			UiTextOutline(0, 0, 0, 1, 0.7)
			UiColor(1,1,1)
			UiText(subs[i][sub])
		end
	end
end

function TitleCard(index)

	UiFont("regular.ttf", 80)
	UiAlign("center middle")
	UiTextOutline(0, 0, 0, 1, 0.5)
	UiColor(1,1,1)

	UiPush()
		UiTranslate(UiCenter(), UiMiddle() / 1.5)
		UiText("LEVEL "..index)
	UiPop()

	UiPush()
		UiTranslate(UiCenter(), UiMiddle() + UiMiddle() - (UiMiddle() / 1.5)) --theres definetly a better way to do this lmao
		UiText(levels[index])
	UiPop()
end