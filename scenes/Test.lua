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
	T.super.new(self, sceneMgr)
	heroAtlas = love.graphics.newImage("assets/gfx/hero.png")
	punchSound = love.audio.newSource("assets/sfx/punch.ogg", "static")

end

local entered = false
function T:enter()
	T.super.enter(self)
	if not entered then
		entered = true
		spr = Sprite(heroAtlas, 100, 100, 16, 16, 4, 4, 0)
		spr:addAnimations({idle = idle, run = run, swim = swim, punch = punch})
		spr:animate("run")
		self.em:add(spr)
	end
end

function T:update(dt)
	self.super.update(self, dt)

	if Key:keyDown("space") and spr.currentAnim ~= "punch" then
		love.audio.stop(punchSound)
		love.audio.play(punchSound)
		spr:animate("punch")
	end

	if spr.currentAnim == "punch" and spr:animationFinished() then
		spr:animate("idle")
	end
end

function T:draw()
	love.graphics.clear(128, 128, 128)
	self.super.draw(self)
end

return T
