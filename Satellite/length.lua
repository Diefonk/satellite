local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

length = {}

function length.init()
	labelImage = gfx.image.new("images/length")
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

function length.show(data)
	label:add()
	length.update(data)
	bar:add()
	barBackground:add()
end

function length.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function length.getText(data)
	return data.length / 1000 .. "s"
end

function length.update(data)
	bar:setScale(1, data.length / 100)
end

function length.up(channel, data)
	if data.length >= 20000 then
		return
	end
	data.length += 100
	channel.length = data.length / 1000
	length.update(data)
end

function length.down(channel, data)
	if data.length <= 100 then
		return
	end
	data.length -= 100
	channel.length = data.length / 1000
	length.update(data)
end
