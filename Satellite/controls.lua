local gfx <const> = playdate.graphics

local text = "Controls:\n** Crank to select synth\n** Left/right to select value\n** Up/down to edit value\n** A to play/stop synth\n** B to play/stop all synths"

function drawControls()
	gfx.drawText(text, 5, 5)
end
