local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

sustain = {}

function sustain.init()
	labelImage = gfx.image.new("images/sustain")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(5, 235)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function sustain.show(data)
	label:add()
	sustain.update(data)
	bar:add()
end

function sustain.hide()
	label:remove()
	bar:remove()
end

function sustain.getText(data)
	return data.sustain .. "%"
end

function sustain.update(data)
	bar:setScale(1, data.sustain * 2)
	bar:setCenter(0, data.sustain)
	bar:moveTo(34, 206)
end

function sustain.up(channel, data)
	if data.sustain >= 100 then
		return
	end
	data.sustain += 1
	channel.synth:setSustain(data.sustain / 100)
	sustain.update(data)
end

function sustain.down(channel, data)
	if data.sustain <= 0 then
		return
	end
	data.sustain -= 1
	channel.synth:setSustain(data.sustain / 100)
	sustain.update(data)
end