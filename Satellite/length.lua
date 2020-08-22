local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

length = {}

function length.init()
	labelImage = gfx.image.new("images/length")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(3, 237)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function length.show(data)
	label:add()
	length.update(data)
	bar:add()
end

function length.hide()
	label:remove()
	bar:remove()
end

function length.getText(data)
	return data.length / 1000 .. "s"
end

function length.update(data)
	bar:setScale(1, data.length / 100)
	bar:setCenter(0, data.length / 200)
	bar:moveTo(30, 210)
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