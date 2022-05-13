local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

sustain = {}

function sustain.init()
	labelImage = gfx.image.new("images/sustain")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 0)
	label:moveTo(5, 5)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
	bar:setCenter(0, 1)
	bar:moveTo(34, 205)
	backgroundImage = gfx.image.new("images/barBackground")
	barBackground = gfx.sprite.new()
	barBackground:setImage(backgroundImage)
	barBackground:setCenter(0, 1)
	barBackground:moveTo(34, 205)
	barBackground:setZIndex(-1)
end

function sustain.show(data)
	label:add()
	sustain.update(data)
	bar:add()
	barBackground:add()
end

function sustain.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function sustain.getText(data)
	return data.sustain .. "%"
end

function sustain.update(data)
	bar:setScale(1, data.sustain * 2)
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
