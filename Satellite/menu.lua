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

function drawMenu()
	gfx.clear()
	gfx.fillRect(0, 103, 400, 34)
	for index = 1, #files do
		if index == selectedFile then
			gfx.setImageDrawMode(gfx.kDrawModeInverted)
		end
		gfx.drawText(files[index], 5, 108 + 34 * (index - selectedFile))
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
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
