local gfx <const> = playdate.graphics

local file
local yes

function deleteEnter(fileName)
	file = fileName
	yes = false
end

function deleteUpdate()
	gfx.drawTextInRect("Delete " .. file .. "?", 5, 5, 390, 230, nil, nil, kTextAlignment.center, gfx.getFont())
	if yes then
		gfx.fillRect(100, 196, 80, 34)
		gfx.setImageDrawMode(gfx.kDrawModeInverted)
		gfx.drawTextAligned("Yes", 140, 201, kTextAlignment.center)
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
		gfx.drawRect(220, 196, 80, 34)
		gfx.drawTextAligned("No", 260, 201, kTextAlignment.center)
	else
		gfx.drawRect(100, 196, 80, 34)
		gfx.drawTextAligned("Yes", 140, 201, kTextAlignment.center)
		gfx.fillRect(220, 196, 80, 34)
		gfx.setImageDrawMode(gfx.kDrawModeInverted)
		gfx.drawTextAligned("No", 260, 201, kTextAlignment.center)
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
end

function deleteDelete()
	if yes then
		playdate.datastore.delete(file)
	end
end

function deleteLeft()
	yes = true
end

function deleteRight()
	yes = false
end
