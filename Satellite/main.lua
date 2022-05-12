import "edit"

local gfx <const> = playdate.graphics
local tmr <const> = playdate.timer

local MENU <const> = 1
local EDIT <const> = 2
local state = EDIT

function init()
	gfx.clear()
	playdate.display.setRefreshRate(40)
	gfx.setFont(gfx.font.new("Asheville-Rounded-24-px"))

	editInit()
end

function playdate.update()
	gfx.sprite.update()
	tmr.updateTimers()
	--playdate.drawFPS(0, 0)
	if state == EDIT then
		editUpdate()
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
	end
end

function playdate.downButtonDown()
	if state == EDIT then
		editDownButtonDown()
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

function playdate.gameWillTerminate()
	save()
end

function playdate.gameWillPause()
	save()
end

init()
