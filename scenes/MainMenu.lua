local Scene = require("lib.Scene")

local MM = Scene:derive("MainMenu")

function MM:draw()
	love.graphics.clear(255, 80, 80)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Main Menu", 160, 50, 0 ,3)
end

return MM
