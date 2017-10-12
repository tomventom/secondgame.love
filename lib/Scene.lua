local Class = require("lib.Class")

local Scene = Class:derive("Scene")

function Scene:new(sceneMgr)
	self.sceneMgr = sceneMgr
end

function Scene:enter()

end

function Scene:update(dt)

end

function Scene:draw()

end

function Scene:destroy()

end

function Scene:exit()

end

return Scene