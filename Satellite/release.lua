local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

release = {}

function release.init()
	labelImage = gfx.image.new("images/release")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(5, 235)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function release.show(data)
	label:add()
	release.update(data)
	bar:add()
end

function release.hide()
	label:remove()
	bar:remove()
end

function release.getText(data)
	return data.release / 1000 .. "s"
end

function release.update(data)
	bar:setScale(1, data.release / 100)
	bar:setCenter(0, data.release / 200)
	bar:moveTo(34, 206)
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