local gfx <const> = playdate.graphics

local labelImage
local label
local notes = {
	"A0", "A#0", "B0", "C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1",
	"C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2",
	"C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3",
	"C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4",
	"C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5",
	"C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6", "A6", "A#6", "B6",
	"C7", "C#7", "D7", "D#7", "E7", "F7", "F#7", "G7", "G#7", "A7", "A#7", "B7", "C8"
}

note = {}

function note.init()
	labelImage = gfx.image.new("images/note")
	label = gfx.sprite.new()
	label:setImage(labelImage)
	label:setCenter(0, 1)
	label:moveTo(3, 237)
end

function note.show(data)
	label:add()
end

function note.hide()
	label:remove()
end

function note.getText(data)
	return notes[data.note]
end

function note.update(data)
end

function note.up(channel, data)
	if data.note >= 88 then
		return
	end
	data.note += 1
	data.pitch = 2 ^ ((data.note - 49) / 12) * 440
	channel.pitch = data.pitch
end

function note.down(channel, data)
	if data.note <= 1 then
		return
	end
	data.note -= 1
	data.pitch = 2 ^ ((data.note - 49) / 12) * 440
	channel.pitch = data.pitch
end