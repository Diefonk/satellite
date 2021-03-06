import "CoreLibs/keyboard"

local key <const> = playdate.keyboard
local gfx <const> = playdate.graphics

function newExit()
	key.hide()
end

function newUpdate()
	if not key.isVisible() then
		key.show()
	end
	gfx.drawText("New file", 5, 93)
	local font = gfx.getFont()
	if gfx.getFont():getTextWidth(key.text) > 400 - key.width() - 20 then
		font:drawTextAligned(key.text, 400 - key.width() - 10, 128, kTextAlignment.right)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 120, 10, 40)
		gfx.setColor(gfx.kColorBlack)
	else
		font:drawText(key.text, 10, 128)
	end
	gfx.drawRect(5, 123, 400 - key.width() - 10, 34)
end

function newCreate()
	local channelsData = {}
	for index = 1, 8 do
		channelsData[index] = {
			waveform = playdate.sound.kWaveSine,
			note = 40,
			pitch = 261.63,
			attack = 100,
			decay = 100,
			sustain = 100,
			release = 100,
			bitcrusher = 0,
			volume = 100,
			length = 100,
			interval = 1000
		}
	end
	local fileName = key.text
	fileName = fileName:gsub("%.", "-")
	fileName = fileName:gsub(":", "-")
	fileName = fileName:gsub("<", "-")
	fileName = fileName:gsub(">", "-")
	fileName = fileName:gsub("?", "-")
	fileName = fileName:gsub("\"", "-")
	fileName = fileName:gsub("*", "-")
	fileName = fileName:gsub("/", "-")
	fileName = fileName:gsub("|", "-")
	fileName = fileName:gsub("\\", "-")
	fileName = fileName:gsub(" ", "_")
	playdate.datastore.write(channelsData, fileName)
	return fileName
end
