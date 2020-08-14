import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local channelSelection
local channelImages = {}
local currentChannel
local channels = {}
local channelImage
local channelMuteImage
local activeChannels = 0

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
	gfx.clear()
	currentChannel = getCurrentChannel()
	for index = 1, 8 do
		channelImages[index] = gfx.image.new("images/channel" .. index)
	end
	channelSelection = gfx.sprite.new()
	channelSelection:setImage(channelImages[currentChannel])
	channelSelection:moveTo(280, 120)
	channelSelection:add()
	channelImage = gfx.image.new("images/channel")
	channelMuteImage = gfx.image.new("images/channelMute")
	for index = 1, 8 do
		channels[index] = {}
		channels[index].sprite = gfx.sprite.new()
		channels[index].sprite:setImage(channelMuteImage)
		channels[index].sprite:add()
		channels[index].mute = true
	end
	channels[1].sprite:moveTo(280, 32)
	channels[2].sprite:moveTo(342, 58)
	channels[3].sprite:moveTo(368, 120)
	channels[4].sprite:moveTo(342, 182)
	channels[5].sprite:moveTo(280, 208)
	channels[6].sprite:moveTo(218, 182)
	channels[7].sprite:moveTo(192, 120)
	channels[8].sprite:moveTo(218, 58)
end

function playdate.update()
	gfx.sprite.update()
end

function playdate.cranked()
	local newChannel = getCurrentChannel()
	if newChannel ~= currentChannel then
		currentChannel = newChannel
		channelSelection:setImage(channelImages[currentChannel])
	end
end

function playdate.AButtonDown()
	channels[currentChannel].mute = not channels[currentChannel].mute
	if channels[currentChannel].mute then
		channels[currentChannel].sprite:setImage(channelMuteImage)
		activeChannels -= 1
	else
		channels[currentChannel].sprite:setImage(channelImage)
		activeChannels += 1
	end
end

function playdate.BButtonDown()
	if activeChannels > 0 then
		for index = 1, 8 do
			channels[index].mute = true
			channels[index].sprite:setImage(channelMuteImage)
		end
		activeChannels = 0
	else
		for index = 1, 8 do
			channels[index].mute = false
			channels[index].sprite:setImage(channelImage)
		end
		activeChannels = 8
	end
end

init()