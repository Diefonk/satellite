local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar

attack = {}

function attack.init()
	labelImage = gfx.image.new("images/attack")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(3, 237)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
end

function attack.show(data)
	label:add()
	attack.update(data)
	bar:add()
end

function attack.hide()
	label:remove()
	bar:remove()
end

function attack.getText(data)
	return data.attack / 1000 .. "s"
end

function attack.update(data)
	bar:setScale(1, data.attack / 100)
	bar:setCenter(0, data.attack / 200)
	bar:moveTo(30, 210)
end

function attack.up(channel, data)
	if data.attack >= 20000 then
		return
	end
	data.attack += 100
	channel.synth:setAttack(data.attack / 1000)
	attack.update(data)
end

function attack.down(channel, data)
	if data.attack <= 100 then
		return
	end
	data.attack -= 100
	channel.synth:setAttack(data.attack / 1000)
	attack.update(data)
end