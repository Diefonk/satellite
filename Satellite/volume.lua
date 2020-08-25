local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

volume = {}

function volume.init()
	labelImage = gfx.image.new("images/volume")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(5, 235)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function volume.show(data)
	label:add()
	volume.update(data)
	bar:add()
end

function volume.hide()
	label:remove()
	bar:remove()
end

function volume.getText(data)
	return data.volume .. "%"
end

function volume.update(data)
	bar:setScale(1, data.volume * 2)
	bar:setCenter(0, data.volume)
	bar:moveTo(34, 206)
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