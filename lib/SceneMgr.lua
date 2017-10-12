local Class = require("lib.Class")

local SM = Class:derive("SceneMgr")

function SM:new(sceneDir, scenes)
	self.scenes = {}
	if not sceneDir then sceneDir = "" end
	self.sceneDir = sceneDir

	if scenes ~= nil then
		assert(type(scenes) == "table", "scenes parameter must be a table")
		for i = 1, #scenes do
			local M = require(sceneDir .. "." .. scenes[i])
			assert(M:isType("Scene"), "file: " .. sceneDir .. "/" .. scenes[i] .. ".lua is not of type Scene!")
			self.scenes[scenes[i]] = M(self)
		end
	end

	-- these are strings that are keys into the self.scenes table
	self.prevSceneName = nil
	self.currentSceneName = nil

	-- this contains the actual scene object
	self.current = nil
end

-- adds a scene to the list where scene is an instance of a subclass of Scene
function SM:add(scene, sceneName)
	if scene then
		assert(sceneName ~= nil, "sceneName parameter must be specified!")
		assert(type(sceneName) == "string", "sceneName parameter must be a string")
		assert(type(scene) == "table", "scene parameter must be a table")
		assert(scene:isType("Scene"), "cannot add non-scene objects to the scene manager!")

		-- assuming the scene is already constructed
		self.scenes[sceneName] = scene
	end
end

function SM:remove(sceneName)
	if sceneName then
		for k,_ in pairs(self.scenes) do
			if k == sceneName then
				self.scenes[k]:destroy()
				self.scenes[k] = nil
				if sceneName == self.currentSceneName then
					self.current = nil
				end
				break
			end
		end
	end
end

-- switches from the current scene to the provided nextScene
function SM:switch(nextScene)
	if self.current then
		self.current:exit()
	end

	if nextScene then
		assert(self.scenes[nextScene] ~= nil, "unable to find scene " .. nextScene)
		self.prevSceneName = currentSceneName
		self.currentSceneName = nextScene
		self.current = self.scenes[nextScene]
		self.current:enter()
	end
end

-- returns to the previous scene if there is one
function SM:pop()
	if self.prevSceneName then
		self:switch(self.prevSceneName)
		self.prevSceneName = nil
	end
end

-- returns a list of all the scene names that the scene manager knows about
function SM:getAvailableScenes()
	local sceneNames = {}
	for k,_ in pairs(self.scenes) do
		sceneNames[#sceneNames + 1] = k
	end
	return sceneNames
end

function SM:update(dt)
	if self.current then
		self.current:update(dt)
	end
end

function SM:draw()
	if self.current then
		self.current:draw()
	end
end

return SM