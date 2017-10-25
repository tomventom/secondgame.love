local Class = require("lib.Class")
local EntityMgr = require("lib.EntityMgr")

local Scene = Class:derive("Scene")

function Scene:new(sceneMgr)
	self.sceneMgr = sceneMgr
	self.em = EntityMgr()
end

-- called when the scene is being switched to or entered
function Scene:enter()
	self.em:onEnter()
end

-- called when the scene is exited or switched out of
function Scene:exit() 
	self.em:onExit()
end

function Scene:update(dt)	self.em:update(dt) end

function Scene:draw()	self.em:draw() end

-- called when the scene is removed from the scene manager
function Scene:destroy() end

return Scene