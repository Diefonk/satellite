import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/graphics"
import "waveform"
import "note"
import "attack"
import "decay"
import "sustain"
import "release"
import "volume"
import "length"
import "interval"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound
local tmr <const> = playdate.timer

local channelSelection
local channelImages = {}
local currentChannel
local channels = {}
local channelsData = {}
local channelImage
local channelMuteImage
local activeChannels = 0
local font
local buttonTimer
local valueEditors
local currentValue = 1

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
		channelsData[index] = {
			waveform = snd.kWaveSine,
			note = 40,
			pitch = 261.63,
			attack = 100,
			decay = 100,
			sustain = 100,
			release = 100,
			volume = 100,
			length = 100,
			interval = 1000
		}
		
		channels[index] = {}
		channels[index].sprite = gfx.sprite.new()
		channels[index].sprite:setImage(channelMuteImage)
		channels[index].sprite:add()
		channels[index].mute = true
		channels[index].synth = snd.synth.new(channelsData[index].waveform)
		channels[index].synth:setADSR(channelsData[index].attack / 1000, channelsData[index].decay / 100, channelsData[index].sustain / 100, channelsData[index].release / 1000)
		channels[index].synth:setLegato(true)
		channels[index].pitch = channelsData[index].pitch
		channels[index].volume = channelsData[index].volume / 100
		channels[index].length = channelsData[index].length / 1000
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
	
	valueEditors = {
		waveform,
		note,
		attack,
		decay,
		sustain,
		release,
		volume,
		length,
		interval
	}
	for index = 1, table.getsize(valueEditors) do
		valueEditors[index].init()
	end
	valueEditors[currentValue].show(channelsData[currentChannel])
end

function playdate.update()
	gfx.sprite.update()
	tmr.updateTimers()
	gfx.drawTextAligned(valueEditors[currentValue].getText(channelsData[currentChannel]), 150, 213, kTextAlignment.right)
end

function playdate.cranked()
	local newChannel = getCurrentChannel()
	if newChannel ~= currentChannel then
		currentChannel = newChannel
		channelSelection:setImage(channelImages[currentChannel])
		valueEditors[currentValue].update(channelsData[currentChannel])
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
		channels[currentChannel].timer = tmr.keyRepeatTimerWithDelay(channelsData[currentChannel].interval, channelsData[currentChannel].interval, play, channels[currentChannel])
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
			channels[index].timer = tmr.keyRepeatTimerWithDelay(channelsData[index].interval, channelsData[index].interval, play, channels[index])
		end
		activeChannels = 8
	end
end

function up()
	valueEditors[currentValue].up(channels[currentChannel], channelsData[currentChannel])
end

function down()
	valueEditors[currentValue].down(channels[currentChannel], channelsData[currentChannel])
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

function playdate.leftButtonDown()
	valueEditors[currentValue].hide()
	currentValue -= 1
	if currentValue < 1 then
		currentValue = table.getsize(valueEditors)
	end
	valueEditors[currentValue].show(channelsData[currentChannel])
end

function playdate.rightButtonDown()
	valueEditors[currentValue].hide()
	currentValue += 1
	if currentValue > table.getsize(valueEditors) then
		currentValue = 1
	end
	valueEditors[currentValue].show(channelsData[currentChannel])
end

init()