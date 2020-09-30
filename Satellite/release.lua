local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

release = {}

function release.init()
	labelImage = gfx.image.new("images/release")
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

function release.show(data)
	label:add()
	release.update(data)
	bar:add()
	barBackground:add()
end

function release.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function release.getText(data)
	return data.release / 1000 .. "s"
end

function release.update(data)
	bar:setScale(1, data.release / 100)
end

function release.up(channel, data)
	if data.release >= 20000 then
		return
	end
	data.release += 100
	channel.synth:setRelease(data.release / 1000)
	release.update(data)
end

function release.down(channel, data)
	if data.release <= 100 then
		return
	end
	data.release -= 100
	channel.synth:setRelease(data.release / 1000)
	release.update(data)
end