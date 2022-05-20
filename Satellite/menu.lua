local gfx <const> = playdate.graphics

local files
local selectedFile

function loadFiles()
	files = {}
	local allFiles = playdate.file.listFiles()
	for index = 1, #allFiles do
		if allFiles[index]:sub(-#".json") == ".json" then
			table.insert(files, allFiles[index]:sub(1, -1 - #".json"))
		end
	end
	selectedFile = 1
	return #files
end

local buttonsWidth <const> = gfx.getSystemFont():getTextWidth("ⒶOpen ⒷDelete") + 10
local buttonsHeight <const> = gfx.getSystemFont():getHeight()
function drawMenu()
	gfx.clear()
	gfx.fillRect(0, 68, 400, 34)
	local font = gfx.getFont()
	for index = 1, #files do
		if index == selectedFile then
			gfx.setImageDrawMode(gfx.kDrawModeInverted)
		end
		font:drawText(files[index], 5, 73 + 34 * (index - selectedFile))
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
	gfx.fillRect(400 - buttonsWidth, 230 - buttonsHeight, buttonsWidth, buttonsHeight + 10)
	gfx.setImageDrawMode(gfx.kDrawModeInverted)
	gfx.getSystemFont():drawTextAligned("ⒶOpen ⒷDelete", 395, 235 - buttonsHeight, kTextAlignment.right)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

function menuUp()
	if selectedFile > 1 then
		selectedFile -= 1
	else
		selectedFile = #files
	end
end

function menuDown()
	if selectedFile < #files then
		selectedFile += 1
	else
		selectedFile = 1
	end
end

function getSelectedFile()
	return files[selectedFile]
end
