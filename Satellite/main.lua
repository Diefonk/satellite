import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound
local tmr <const> = playdate.timer

local channelSelection
local channelImages = {}
local currentChannel
local channels = {}
local channelImage
local channelMuteImage
local activeChannels = 0
local font
local barImage
local intervalBar
local intervalImage
local intervalSprite
local buttonTimer

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
		channels[index].synth = snd.synth.new()
		channels[index].synth:setADSR(0.1, 0.1, 1, 0.1)
		channels[index].synth:setLegato(true)
		channels[index].pitch = 261.63
		channels[index].volume = 1
		channels[index].length = 0.1
		channels[index].interval = 1000
	end
	channels[1].sprite:moveTo(280, 32)
	channels[2].sprite:moveTo(342, 58)
	channels[3].sprite:moveTo(368, 120)
	channels[4].sprite:moveTo(342, 182)
	channels[5].sprite:moveTo(280, 208)
	channels[6].sprite:moveTo(218, 182)
	channels[7].sprite:moveTo(192, 120)
	channels[8].sprite:moveTo(218, 58)
	
	font = gfx.font.new("Asheville-Rounded-24-px")
	gfx.setFont(font)
	
	barImage = gfx.image.new("images/bar")
	intervalBar = gfx.sprite.new()
	intervalBar:setImage(barImage)
	intervalBar:setScale(1, channels[currentChannel].interval / 100)
	intervalBar:setCenter(0, channels[currentChannel].interval / 200)
	intervalBar:moveTo(30, 210)
	intervalBar:add()
	
	intervalImage = gfx.image.new("images/interval")
	intervalSprite = gfx.sprite.new()
	intervalSprite:setImage(intervalImage)
	intervalSprite:setCenter(0, 1)
	intervalSprite:moveTo(3, 237)
	intervalSprite:add()
end

function playdate.update()
	gfx.sprite.update()
	tmr.updateTimers()
	gfx.drawTextAligned(channels[currentChannel].interval / 1000 .. "s", 150, 213, kTextAlignment.right)
end

function playdate.cranked()
	local newChannel = getCurrentChannel()
	if newChannel ~= currentChannel then
		currentChannel = newChannel
		channelSelection:setImage(channelImages[currentChannel])
		intervalBar:setScale(1, channels[currentChannel].interval / 100)
		intervalBar:setCenter(0, channels[currentChannel].interval / 200)
		intervalBar:moveTo(30, 210)
	end
end

function play(channel)
	channel.synth:playNote(channel.pitch, channel.volume, channel.length)
end

function playdate.AButtonDown()
	channels[currentChannel].mute = not channels[currentChannel].mute
	if channels[currentChannel].mute then
		channels[currentChannel].sprite:setImage(channelMuteImage)
		activeChannels -= 1
		channels[currentChannel].timer:remove()
		--channels[currentChannel].synth:stop()
	else
		channels[currentChannel].sprite:setImage(channelImage)
		activeChannels += 1
		channels[currentChannel].timer = tmr.keyRepeatTimerWithDelay(channels[currentChannel].interval, channels[currentChannel].interval, play, channels[currentChannel])
	end
end

function playdate.BButtonDown()
	if activeChannels > 0 then
		for index = 1, 8 do
			channels[index].mute = true
			channels[index].sprite:setImage(channelMuteImage)
			if channels[index].timer then
				channels[index].timer:remove()
			end
			--channels[currentChannel].synth:stop()
		end
		activeChannels = 0
	else
		for index = 1, 8 do
			channels[index].mute = false
			channels[index].sprite:setImage(channelImage)
			channels[index].timer = tmr.keyRepeatTimerWithDelay(channels[index].interval, channels[index].interval, play, channels[index])
		end
		activeChannels = 8
	end
end

function intervalUp()
	if not channels[currentChannel].mute or channels[currentChannel].interval >= 20000 then
		return
	end
	channels[currentChannel].interval += 100
	intervalBar:setScale(1, channels[currentChannel].interval / 100)
	intervalBar:setCenter(0, channels[currentChannel].interval / 200)
	intervalBar:moveTo(30, 210)
end

function intervalDown()
	if not channels[currentChannel].mute or channels[currentChannel].interval <= 100 then
		return
	end
	channels[currentChannel].interval -= 100
	intervalBar:setScale(1, channels[currentChannel].interval / 100)
	intervalBar:setCenter(0, channels[currentChannel].interval / 200)
	intervalBar:moveTo(30, 210)
end

function playdate.upButtonDown()
	if buttonTimer then
		buttonTimer:remove()
	end
	buttonTimer = tmr.keyRepeatTimer(intervalUp)
end

function playdate.downButtonDown()
	if buttonTimer then
		buttonTimer:remove()
	end
	buttonTimer = tmr.keyRepeatTimer(intervalDown)
end

function playdate.upButtonUp()
	buttonTimer:remove()
end

function playdate.downButtonUp()
	buttonTimer:remove()
end

init()