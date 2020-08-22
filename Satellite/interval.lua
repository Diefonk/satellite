local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

interval = {}

function interval.init()
	labelImage = gfx.image.new("images/interval")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(3, 237)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function interval.show(channel)
	label:add()
	interval.update(channel)
	bar:add()
end

function interval.hide()
	label:remove()
	bar:remove()
end

function interval.getText(channel)
	return channel.interval / 1000 .. "s"
end

function interval.update(channel)
	bar:setScale(1, channel.interval / 100)
	bar:setCenter(0, channel.interval / 200)
	bar:moveTo(30, 210)
end

function interval.up(channel)
	if not channel.mute or channel.interval >= 20000 then
		return
	end
	channel.interval += 100
	interval.update(channel)
end

function interval.down(channel)
	if not channel.mute or channel.interval <= 100 then
		return
	end
	channel.interval -= 100
	interval.update(channel)
end