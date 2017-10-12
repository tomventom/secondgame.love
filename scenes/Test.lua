local Scene = require("lib.Scene")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local heroAtlas

local spr
local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local run = Anim(16, 32, 16, 16, 6, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 14, false)
local punchSound


local T = Scene:derive("Test")

function T:new(sceneMgr)
	self.super:new(sceneMgr)

	heroAtlas = love.graphics.newImage("assets/gfx/hero.png")
	spr = Sprite(heroAtlas, 100, 100, 16, 16, 10, 10, 0)
	spr:addAnimations({idle = idle, run = run, swim = swim, punch = punch})
	spr:animate("run")

	punchSound = love.audio.newSource("assets/sfx/punch.ogg", "static")

end

local entered = false
function T:enter()
	if not entered then
		entered = true
		print("entered test")
	end
end

function T:update(dt)

	if Key:keyDown("space") and spr.currentAnim ~= "punch" then
		love.audio.stop(punchSound)
		love.audio.play(punchSound)
		spr:animate("punch")
	elseif Key:keyDown("escape") then
		love.event.quit()
	end

	if spr.currentAnim == "punch" and spr:animationFinished() then
		spr:animate("idle")
	end

	spr:update(dt)

end

function T:draw()
	love.graphics.clear(80, 80, 255)
	spr:draw()
end

return T
