local Class = require("lib.Class")
local EntityMgr = require("lib.EntityMgr")

local Scene = Class:derive("Scene")

function Scene:new(sceneMgr)
	self.sceneMgr = sceneMgr
	self.em = EntityMgr()
end

function Scene:enter() end

function Scene:update(dt)	self.em:update(dt) end

function Scene:draw()	self.em:draw() end

-- called when the scene is removed from the scene manager
function Scene:destroy() end

function Scene:exit() end

return Scene