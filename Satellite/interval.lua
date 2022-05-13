local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

interval = {}

function interval.init()
	labelImage = gfx.image.new("images/interval")
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

function interval.show(data)
	label:add()
	interval.update(data)
	bar:add()
	barBackground:add()
end

function interval.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function interval.getText(data)
	return data.interval / 1000 .. "s"
end

function interval.update(data)
	bar:setScale(1, data.interval / 100)
end

function interval.up(channel, data)
	if not channel.mute or data.interval >= 20000 then
		return
	end
	data.interval += 100
	interval.update(data)
end

function interval.down(channel, data)
	if not channel.mute or data.interval <= 100 then
		return
	end
	data.interval -= 100
	interval.update(data)
end
