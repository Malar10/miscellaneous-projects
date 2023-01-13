function init()
	tools = false
	legs = true --not used
	subs = true
	lives = true
	cooldown = true --not used
	opened = false
	vlvolume = 50
	mvolume = 15

	if HasKey("savegame.mod.Tools") then
		tools = GetBool("savegame.mod.Tools")
	end

	if HasKey("savegame.mod.Legs") then
		legs = GetBool("savegame.mod.Legs")
	end

	if HasKey("savegame.mod.Subtitles") then
		subs = GetBool("savegame.mod.Subtitles")
	end

	if HasKey("savegame.mod.Lives") then
		lives = GetBool("savegame.mod.Lives")
	end

	if HasKey("savegame.mod.OpenedMenu") then
		opened = GetBool("savegame.mod.OpenedMenu")
	end

	if HasKey("savegame.mod.Cooldowns") then
		cooldown = GetBool("savegame.mod.Cooldowns")
	end

	if HasKey("savegame.mod.Vlvolume") then
		vlvolume = GetFloat("savegame.mod.Vlvolume")
	end

	if HasKey("savegame.mod.Mvolume") then
		mvolume = GetFloat("savegame.mod.Mvolume")
	end

	open = false

	toolTimer = 0
	

	wantedTools = {"ng-heap", "powergauntlet", "flaregunrevolver", "rifle", "pumpshotgun", "pumpshotgunauto", "uzi"}

	base_tools = {
	"sledge",
	"spraycan",
	"extinguisher",
	"blowtorch",
	"shotgun",
	"plank",
	"pipebomb",
	"gun",
	"bomb",
	"rocket"
	}

	all_tools = ListKeys("game.tool")
	for i=1, #wantedTools do
		tool = wantedTools[i]
		if isInTable(all_tools, wantedTools[i]) then
		end
	end

	YeetTools()
end

function tick(dt)
	if toolTimer < 0.5 then
		YeetTools()
		toolTimer = toolTimer + dt
	end
end

function draw()
	if InputPressed("m") then
		if open then
			open = false
		else
			open = true
		end
	end

	if not opened then
		UiPush()
		UiTranslate(UiCenter() * 1.72, UiMiddle() * 0.3)
		UiTextOutline(0, 0, 0, 1, 0.7)
		UiColor(0, 1, 1, 1)
		UiFont("bold.ttf", 50)
		UiAlign("center")
		UiText("Press 'M'", true)
		UiText("to open Menu", true)
		UiFont("bold.ttf", 25)
		UiText("This text will go away", true)
		UiText("when you open it")
		UiPop()
	end

	if open then
		if not opened then
			opened = true
			SetBool("savegame.mod.OpenedMenu", opened)
		end
		UiMakeInteractive()
		UiButtonHoverColor(0,1,0)
		UiPush()
			UiTranslate(UiCenter(), UiMiddle())
			UiAlign("center middle")
			UiColor(0, 0, 0, 0.9)
			UiRect(2000, 2000)
		UiPop()
		
		UiPush()
			UiTranslate(UiCenter(), 50)
			UiAlign("center top")
			UiColor(1, 1, 1)
			UiFont("bold.ttf", 80)
			UiText("Options", true)
		UiPop()

		UiPush()
			UiTranslate(UiCenter()/2.5, 200)
			UiAlign("left top")
			UiFont("bold.ttf", 60)

			UiColor(1, 1, 1)
			if not tools then
				if UiTextButton("[   ] Tools", 20, 20) then
					tools = true
					SetBool("savegame.mod.Tools", true)
					YeetTools()
				end
				UiTranslate(0, 80)
				UiColor(0, 0.8, 0.8)
				UiFont("bold.ttf", 40)
				UiText("You only have Aggression tools.", true)
			else
				if UiTextButton("[x] Tools", 20, 20) then
					tools = false
					SetBool("savegame.mod.Tools", false)
					YeetTools()
				end
				UiTranslate(0, 80)
				UiColor(0.8, 0.8, 0)
				UiFont("bold.ttf", 40)
				UiText("All tools enabled. Have fun :)", true)
			end

			UiColor(1, 1, 1)
			UiTranslate(0, 50)
			UiFont("bold.ttf", 60)

			UiColor(1, 1, 1)
			if not subs then
				if UiTextButton("[   ] Subtitles", 20, 20) then
					subs = true
					SetBool("savegame.mod.Subtitles", true)
				end
				UiTranslate(0, 80)
				UiColor(0.8, 0.8, 0)
				UiFont("bold.ttf", 40)
				UiText("Subtitles disabled.", true)
			else
				if UiTextButton("[x] Subtitles", 20, 20) then
					subs = false
					SetBool("savegame.mod.Subtitles", false)
				end
				UiTranslate(0, 80)
				UiColor(0, 0.8, 0.8)
				UiFont("bold.ttf", 40)
				UiText("Subtitles enabled.", true)
			end

			UiColor(1, 1, 1)
			UiTranslate(0, 50)
			UiFont("bold.ttf", 60)

			UiColor(1, 1, 1)
			if not lives then
				if UiTextButton("[   ] Lives", 20, 20) then
					lives = true
					SetBool("savegame.mod.Lives", true)
				end
				UiTranslate(0, 80)
				UiColor(0.8, 0.8, 0)
				UiFont("bold.ttf", 40)
				UiText("Infinite lives.", true)
			else
				if UiTextButton("[x] Lives", 20, 20) then
					lives = false
					SetBool("savegame.mod.Lives", false)
				end
				UiTranslate(0, 80)
				UiColor(0, 0.8, 0.8)
				UiFont("bold.ttf", 40)
				UiText("Limited Lives.", true)
			end
		UiPop()

		UiPush()
			UiTranslate(UiCenter() * 1.2, UiMiddle() / 2)
			UiAlign("left top")
			UiColor(1, 1, 1)
			UiFont("bold.ttf", 40)
			UiText("Voice line volume: "..math.floor(vlvolume+0.5), true)
			
			UiTranslate(20, 15)
			UiColor(0.2, 0.2, 0)
			UiImageBox("ui/common/box-solid-6.png", 116, 15, 6, 6)
			UiColor(0, 1, 1)
			vlvolume = UiSlider("ui/common/dot.png","x",vlvolume, 0, 100)
			SetFloat("savegame.mod.Vlvolume", vlvolume)
		UiPop()

		UiPush()
			UiTranslate(UiCenter() * 1.2, UiMiddle() / 1.3)
			UiAlign("left top")
			UiColor(1, 1, 1)
			UiFont("bold.ttf", 40)
			UiText("Music volume: "..math.floor(mvolume+0.5), true)
			
			UiTranslate(20, 15)
			UiColor(0.2, 0.2, 0)
			UiImageBox("ui/common/box-solid-6.png", 116, 15, 6, 6)
			UiColor(0, 1, 1)
			mvolume = UiSlider("ui/common/dot.png","x",mvolume, 0, 100)
			SetFloat("savegame.mod.Mvolume", mvolume)
		UiPop()

		UiPush()
			UiColor(1, 1, 1)
			UiTranslate(UiCenter(), UiMiddle() * 1.6)
			UiAlign("center top")
			UiFont("bold.ttf", 60)
			UiText("Press 'M' to exit menu.")
		UiPop()

		UiPush()
			UiColor(0.8, 0, 0)
			UiTranslate(UiCenter(), UiMiddle() * 1.8)
			UiAlign("center top")
			UiFont("bold.ttf", 80)
			if UiTextButton("return to level select", 20, 20) then
				StartLevel("main","MOD/main.xml")
			end
		UiPop()

		UiPush()
			UiColor(1, 1, 1)
			UiTranslate(UiCenter() * 1.2, UiMiddle() * 1.3)
			UiAlign("left top")
			UiFont("bold.ttf", 60)
			if UiTextButton("Reset to Default", 20, 20) then
				tools = false
				subs = true
				lives = true
				vlvolume = 50
				mvolume = 15

				SetBool("savegame.mod.Tools", tools)
				SetBool("savegame.mod.Subtitles", subs)
				SetBool("savegame.mod.Lives", lives)
				SetFloat("savegame.mod.Vlvolume", vlvolume)
				SetFloat("savegame.mod.Mvolume", mvolume)

				YeetTools()
			end
		UiPop()
	end
end

function YeetTools()
	all_tools = ListKeys("game.tool")
	if not tools then
		for i=1, #all_tools do
			inTable = isInTable(wantedTools, all_tools[i])
			if not inTable then
				SetBool("game.tool."..all_tools[i]..".enabled", false)
				SetString("game.player.tool", "0")
			end
		end
	else
		for i=1, #all_tools do
			inTable = isInTable(wantedTools, all_tools[i])
			if not inTable then
				SetBool("game.tool."..all_tools[i]..".enabled", true)
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