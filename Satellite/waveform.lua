local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

local labelImage
local label

waveform = {}

function waveform.init()
	labelImage = gfx.image.new("images/waveform")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(3, 237)
end

function waveform.show(data)
	label:add()
end

function waveform.hide()
	label:remove()
end

function waveform.getText(data)
	if data.waveform == snd.kWaveSine then
		return "Sine"
	elseif data.waveform == snd.kWaveSquare then
		return "Square"
	elseif data.waveform == snd.kWaveSawtooth then
		return "Saw"
	elseif data.waveform == snd.kWaveTriangle then
		return "Triangle"
	else
		return "Noise"
	end
end

function waveform.update(data)
end

function waveform.up(channel, data)
	if data.waveform == snd.kWaveSine then
		data.waveform = snd.kWaveNoise
	elseif data.waveform == snd.kWaveSquare then
		data.waveform = snd.kWaveSine
	elseif data.waveform == snd.kWaveSawtooth then
		data.waveform = snd.kWaveSquare
	elseif data.waveform == snd.kWaveTriangle then
		data.waveform = snd.kWaveSawtooth
	else
		data.waveform = snd.kWaveTriangle
	end
	channel.synth:setWaveform(data.waveform)
end

function waveform.down(channel, data)
	if data.waveform == snd.kWaveSine then
		data.waveform = snd.kWaveSquare
	elseif data.waveform == snd.kWaveSquare then
		data.waveform = snd.kWaveSawtooth
	elseif data.waveform == snd.kWaveSawtooth then
		data.waveform = snd.kWaveTriangle
	elseif data.waveform == snd.kWaveTriangle then
		data.waveform = snd.kWaveNoise
	else
		data.waveform = snd.kWaveSine
	end
	channel.synth:setWaveform(data.waveform)
end