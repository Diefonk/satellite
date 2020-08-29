local gfx <const> = playdate.graphics

local labelImage
local label
local barImage
local bar
local backgroundImage
local barBackground

bitcrusher = {}

function bitcrusher.init()
	labelImage = gfx.image.new("images/volume")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 0)
	label:moveTo(5, 6)
	barImage = gfx.image.new("images/bar")
	bar = gfx.sprite.new()
	bar:setImage(barImage)
	backgroundImage = gfx.image.new("images/barBackground")
	barBackground = gfx.sprite.new()
	barBackground:setImage(backgroundImage)
	barBackground:setCenter(0, 1)
	barBackground:moveTo(34, 206)
	barBackground:setZIndex(-1)
end

function bitcrusher.show(data)
	--label:add()
	bitcrusher.update(data)
	bar:add()
	barBackground:add()
end

function bitcrusher.hide()
	--label:remove()
	bar:remove()
	barBackground:remove()
end

function bitcrusher.getText(data)
	return data.bitcrusher .. "%"
end

function bitcrusher.update(data)
	bar:setScale(1, data.bitcrusher * 2)
	bar:setCenter(0, data.bitcrusher)
	bar:moveTo(34, 206)
end

function bitcrusher.up(channel, data)
	if data.bitcrusher >= 100 then
		return
	end
	data.bitcrusher += 1
	channel.bitcrusher:setAmount(data.bitcrusher / 100)
	bitcrusher.update(data)
end

function bitcrusher.down(channel, data)
	if data.bitcrusher <= 0 then
		return
	end
	data.bitcrusher -= 1
	channel.bitcrusher:setAmount(data.bitcrusher / 100)
	bitcrusher.update(data)
end