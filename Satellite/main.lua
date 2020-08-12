import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local center
local channelImages = {}
local currentChannel

function getCurrentChannel()
	local crankPosition = playdate.getCrankPosition()
	if crankPosition > 337 or crankPosition < 23 then
		return 1
	elseif crankPosition < 68 then
		return 2
	elseif crankPosition < 113 then
		return 3
	elseif crankPosition < 158 then
		return 4
	elseif crankPosition < 203 then
		return 5
	elseif crankPosition < 248 then
		return 6
	elseif crankPosition < 293 then
		return 7
	else
		return 8
	end
end

function init()
	currentChannel = getCurrentChannel()
	for index = 1, 8 do
		channelImages[index] = gfx.image.new("images/channel" .. index)
	end
	center = gfx.sprite.new()
	center:setImage(channelImages[currentChannel])
	center:moveTo(280, 120)
	center:add()
end

function playdate.update()
	gfx.sprite.update()
end

function playdate.cranked()
	local newChannel = getCurrentChannel()
	if newChannel ~= currentChannel then
		currentChannel = newChannel
		center:setImage(channelImages[currentChannel])
	end
end

init()