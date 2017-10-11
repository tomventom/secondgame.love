local Anim = require("Animation")
local Sprite = require("Sprite")
local Key = require("Keyboard")

local heroAtlas

local spr
local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local run = Anim(16, 32, 16, 16, 6, 6, 10)
local swim = Anim(16, 64, 16, 16, 6, 6, 10)
local punch = Anim(16, 80, 16, 16, 3, 3, 14, false)

local punchSound

function love.load()
	Key:hookLoveEvents()
	love.graphics.setDefaultFilter("nearest", "nearest")
	heroAtlas = love.graphics.newImage("gfx/hero.png")
	spr = Sprite(heroAtlas, 100, 100, 16, 16, 10, 10, 0)
	spr:addAnimation("idle", idle)
	spr:addAnimation("run", run)
	spr:addAnimation("swim", swim)
	spr:addAnimation("punch", punch)
	spr:animate("run")

	punchSound = love.audio.newSource("sfx/punch.ogg", "static")
end

function love.update(dt)
	if dt > 0.04 then return end

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
	Key:update(dt)
	spr:update(dt)
end

function love.draw()
	love.graphics.clear(80, 80, 255)
	spr:draw()

end