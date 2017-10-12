local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local Anim = Class:derive("Animation")

function Anim:new(offX, offY, w, h, frames, columnSize, fps, loop)
	self.fps = fps
	if type(frames) == "table" then
		self.frames = frames
	else
		self.frames = {}
		for i = 1, frames, 1 do
			self.frames[i] = i
		end
	end
	self.columnSize = columnSize
	self.startOffset = Vector2(offX, offY)
	self.offset = Vector2()
	self.size = Vector2(w, h)
	self.loop = loop == nil or loop
	self:reset()
end

function Anim:reset()
	self.timer = 1 / self.fps
	self.index = 1
	self.done = false

	self.offset.x = self.startOffset.x + (self.size.x * ((self.frames[self.index] - 1) % self.columnSize))
	self.offset.y = self.startOffset.y + (self.size.y * math.floor((self.frames[self.index] -1) / self.columnSize))
end

function Anim:set(quad)
	quad:setViewport(self.offset.x, self.offset.y, self.size.x, self.size.y)
end

function Anim:update(dt, quad)
	if #self.frames <= 1 then return

	elseif self.timer > 0 then
		self.timer = self.timer - dt
		if self.timer <= 0 then
			self.timer = 1 / self.fps
			self.index = self.index + 1
			if self.index > #self.frames then
				if self.loop then
					self.index = 1
				else
					self.index = #self.frames
					self.timer = 0
					self.done = true
				end
			end
			self.offset.x = self.startOffset.x + (self.size.x * ((self.frames[self.index] - 1) % self.columnSize))
			self.offset.y = self.startOffset.y + (self.size.y * math.floor((self.frames[self.index] -1) / self.columnSize))
			self:set(quad)
		end
	end
end

return Anim