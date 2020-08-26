local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

decay = {}

function decay.init()
	labelImage = gfx.image.new("images/decay")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 0)
	label:moveTo(5, 6)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
	backgroundImage = gfx.image.new("images/barBackground")
	barBackground = gfx.sprite.new()
	barBackground:setImage(backgroundImage)
	barBackground:setCenter(0, 1)
	barBackground:moveTo(34, 206)
	barBackground:setZIndex(-1)
end

function decay.show(data)
	label:add()
	decay.update(data)
	bar:add()
	barBackground:add()
end

function decay.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function decay.getText(data)
	return data.decay / 1000 .. "s"
end

function decay.update(data)
	bar:setScale(1, data.decay / 100)
	bar:setCenter(0, data.decay / 200)
	bar:moveTo(34, 206)
end

function decay.up(channel, data)
	if data.decay >= 20000 then
		return
	end
	data.decay += 100
	channel.synth:setDecay(data.decay / 1000)
	decay.update(data)
end

function decay.down(channel, data)
	if data.decay <= 100 then
		return
	end
	data.decay -= 100
	channel.synth:setDecay(data.decay / 1000)
	decay.update(data)
end