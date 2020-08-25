import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/graphics"
import "CoreLibs/animation"
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
local channelsData
local channelImage
local channelMuteImage
local activeChannels = 0
local font
local buttonTimer
local valueEditors
local currentValue = 1
local beatTable
local testAnimation

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

function setChannelPosition(channel, x, y)
	channel.sprite:moveTo(x, y)
	channel.ax = x - 32
	channel.ay = y - 32
end

function init()
	gfx.clear()
	playdate.display.setRefreshRate(40)
	
	currentChannel = getCurrentChannel()
	for index = 1, 8 do
		channelImages[index] = gfx.image.new("images/channel" .. index)
	end
	channelSelection = gfx.sprite.new()
	channelSelection:setImage(channelImages[currentChannel])
	channelSelection:moveTo(280, 120)
	channelSelection:add()
	
	channelsData = playdate.datastore.read()
	if not channelsData then
		channelsData = {}
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
		end
	end
	
	beatTable = gfx.imagetable.new("images/beat/beat")	
	channelImage = gfx.image.new("images/channel")
	channelMuteImage = gfx.image.new("images/channelMute")
	for index = 1, 8 do
		local data = channelsData[index]
		channels[index] = {}
		local channel = channels[index]
		channel.sprite = gfx.sprite.new()
		channel.sprite:setImage(channelMuteImage)
		channel.sprite:add()
		channel.mute = true
		channel.synth = snd.synth.new(data.waveform)
		channel.synth:setADSR(data.attack / 1000, data.decay / 100, data.sustain / 100, data.release / 1000)
		channel.synth:setLegato(true)
		channel.pitch = data.pitch
		channel.volume = data.volume / 100
		channel.length = data.length / 1000
		channel.animations = {}
		for index2 = 1, 6 do
			channel.animations[index2] = gfx.animation.loop.new(25, beatTable, false)
			local animation = channel.animations[index2]
			animation.frame = animation.endFrame
		end
		channel.nextAnimation = 1
	end
	setChannelPosition(channels[1], 280, 32)
	setChannelPosition(channels[2], 342, 58)
	setChannelPosition(channels[3], 368, 120)
	setChannelPosition(channels[4], 342, 182)
	setChannelPosition(channels[5], 280, 208)
	setChannelPosition(channels[6], 218, 182)
	setChannelPosition(channels[7], 192, 120)
	setChannelPosition(channels[8], 218, 58)
	
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
	gfx.drawTextAligned(valueEditors[currentValue].getText(channelsData[currentChannel]), 154, 211, kTextAlignment.right)
	--playdate.drawFPS(0, 0)
	for index = 1, 8 do
		local channel = channels[index]
		for index2 = 1, 6 do
			local animation = channel.animations[index2]
			if animation.frame < animation.endFrame then
				animation:draw(channel.ax, channel.ay)
			end
		end
	end
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
	channel.animations[channel.nextAnimation].frame = 1
	channel.nextAnimation += 1
	if channel.nextAnimation > 6 then
		channel.nextAnimation = 1
	end
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

function save()
	playdate.datastore.write(channelsData)
end

function playdate.gameWillTerminate()
	save()
end

function playdate.gameWillPause()
	save()
end

init()