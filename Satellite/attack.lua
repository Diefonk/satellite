local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

attack = {}

function attack.init()
	labelImage = gfx.image.new("images/attack")
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

function attack.show(data)
	label:add()
	attack.update(data)
	bar:add()
	barBackground:add()
end

function attack.hide()
	label:remove()
	bar:remove()
	barBackground:remove()
end

function attack.getText(data)
	return data.attack / 1000 .. "s"
end

function attack.update(data)
	bar:setScale(1, data.attack / 100)
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
