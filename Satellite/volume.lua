local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

volume = {}

function volume.init()
	labelImage = gfx.image.new("images/volume")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 0)
	label:moveTo(5, 6)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
	bar:setCenter(0, 1)
	bar:moveTo(34, 206)
	backgroundImage = gfx.image.new("images/barBackground")
	barBackground = gfx.sprite.new()
	barBackground:setImage(backgroundImage)
	barBackground:setCenter(0, 1)
	barBackground:moveTo(34, 206)
	barBackground:setZIndex(-1)
end

function volume.show(data)
	label:add()
	volume.update(data)
	bar:add()
	barBackground:add()
end

function volume.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function volume.getText(data)
	return data.volume .. "%"
end

function volume.update(data)
	bar:setScale(1, data.volume * 2)
end

function volume.up(channel, data)
	if data.volume >= 100 then
		return
	end
	data.volume += 1
	channel.volume = data.volume / 100
	volume.update(data)
end

function volume.down(channel, data)
	if data.volume <= 0 then
		return
	end
	data.volume -= 1
	channel.volume = data.volume / 100
	volume.update(data)
end