import "edit"
import "menu"
import "controls"
import "new"

local gfx <const> = playdate.graphics
local tmr <const> = playdate.timer

local MENU <const> = 1
local EDIT <const> = 2
local NEW <const> = 3
local CONTROLS <const> = 4
local state = MENU

function init()
	gfx.setBackgroundColor(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	playdate.display.setRefreshRate(40)
	gfx.setFont(gfx.font.new("Asheville-Rounded-24-px"))

	playdate.getSystemMenu():addMenuItem("satellite files", function()
		if state == EDIT then
			editExit()
		elseif state == NEW then
			newExit()
		end
		state = MENU
		if loadFiles() <= 0 then
			state = NEW
		end
	end)

	playdate.getSystemMenu():addMenuItem("new file", function()
		if state == EDIT then
			editExit()
		end
		state = NEW
	end)

	playdate.getSystemMenu():addMenuItem("controls", function()
		if state == EDIT then
			editExit()
		elseif state == NEW then
			newExit()
		end
		state = CONTROLS
	end)

	editInit()
	if loadFiles() <= 0 then
		state = NEW
	end
end

function playdate.update()
	gfx.sprite.update()
	tmr.updateTimers()
	--playdate.drawFPS(0, 0)
	if state == EDIT then
		editUpdate()
	elseif state == MENU then
		drawMenu()
	elseif state == CONTROLS then
		drawControls()
	elseif state == NEW then
		newUpdate()
	end
end

function playdate.cranked()
	if state == EDIT then
		editCranked()
	end
end

function playdate.AButtonDown()
	if state == EDIT then
		editAButtonDown()
	elseif state == MENU then
		state = EDIT
		editEnter(getSelectedFile())
	end
end

function playdate.BButtonDown()
	if state == EDIT then
		editBButtonDown()
	end
end

function playdate.upButtonDown()
	if state == EDIT then
		editUpButtonDown()
	elseif state == MENU then
		menuUp()
	end
end

function playdate.downButtonDown()
	if state == EDIT then
		editDownButtonDown()
	elseif state == MENU then
		menuDown()
	end
end

function playdate.upButtonUp()
	if state == EDIT then
		editUpButtonUp()
	end
end

function playdate.downButtonUp()
	if state == EDIT then
		editDownButtonUp()
	end
end

function playdate.leftButtonDown()
	if state == EDIT then
		editLeftButtonDown()
	end
end

function playdate.rightButtonDown()
	if state == EDIT then
		editRightButtonDown()
	end
end

function playdate.keyboard.keyboardWillHideCallback(ok)
	if ok then
		state = EDIT
		editEnter(newCreate())
	else
		state = MENU
		if loadFiles() <= 0 then
			state = NEW
		end
	end
end

function playdate.gameWillTerminate()
	if state == EDIT then
		save()
	end
end

function playdate.gameWillPause()
	if state == EDIT then
		save()
	end
end

function playdate.deviceWillSleep()
	if state == EDIT then
		save()
	end
end

function playdate.deviceWillLock()
	if state == EDIT then
		save()
	end
end

init()
