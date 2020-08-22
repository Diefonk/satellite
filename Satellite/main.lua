import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/graphics"
import "interval"

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
	
	interval.init()
	interval.show(channels[currentChannel])
end

function playdate.update()
	gfx.sprite.update()
	tmr.updateTimers()
	gfx.drawTextAligned(interval.getText(channels[currentChannel]), 150, 213, kTextAlignment.right)
end

function playdate.cranked()
	local newChannel = getCurrentChannel()
	if newChannel ~= currentChannel then
		currentChannel = newChannel
		channelSelection:setImage(channelImages[currentChannel])
		interval.update(channels[currentChannel])
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

function up()
	interval.up(channels[currentChannel])
end

function down()
	interval.down(channels[currentChannel])
end

function playdate.upButtonDown()
	if buttonTimer then
		buttonTimer:remove()
	end
	buttonTimer = tmr.keyRepeatTimer(up)
end

function playdate.downButtonDown()
	if buttonTimer then
		buttonTimer:remove()
	end
	buttonTimer = tmr.keyRepeatTimer(down)
end

function playdate.upButtonUp()
	if buttonTimer then
		buttonTimer:remove()
	end
end

function playdate.downButtonUp()
	if buttonTimer then
		buttonTimer:remove()
	end
end

init()