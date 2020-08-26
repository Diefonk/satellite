local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

local labelImage
local label
local sineImage
local squareImage
local sawtoothImage
local triangleImage
local noiseImage
local wave

waveform = {}

function waveform.init()
	labelImage = gfx.image.new("images/waveform")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 0)
	label:moveTo(5, 6)
	sineImage = gfx.image.new("images/sine")
	squareImage = gfx.image.new("images/square")
	sawtoothImage = gfx.image.new("images/sawtooth")
	triangleImage = gfx.image.new("images/triangle")
	noiseImage = gfx.image.new("images/noise")
	wave = gfx.sprite.new()
	wave:setImage(sineImage)
	wave:setCenter(0, 1)
	wave:moveTo(34, 206)
end

function waveform.show(data)
	label:add()
	waveform.update(data)
	wave:add()
end

function waveform.hide()
	label:remove()
	wave:remove()
end

function waveform.getText(data)
	if data.waveform == snd.kWaveSine then
		return "Sine"
	elseif data.waveform == snd.kWaveSquare then
		return "Square"
	elseif data.waveform == snd.kWaveSawtooth then
		return "Sawtooth"
	elseif data.waveform == snd.kWaveTriangle then
		return "Triangle"
	else
		return "Noise"
	end
end

function waveform.update(data)
	if data.waveform == snd.kWaveSine then
		wave:setImage(sineImage)
	elseif data.waveform == snd.kWaveSquare then
		wave:setImage(squareImage)
	elseif data.waveform == snd.kWaveSawtooth then
		wave:setImage(sawtoothImage)
	elseif data.waveform == snd.kWaveTriangle then
		wave:setImage(triangleImage)
	else
		wave:setImage(noiseImage)
	end
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
	waveform.update(data)
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
	waveform.update(data)
end