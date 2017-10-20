local Keyboard = {}
local keyStates = {}

function Keyboard:update(dt)
	for k, v in pairs(keyStates) do
		keyStates[k] = nil
	end
end

-- returns the current state of the given key
function Keyboard:key(key)
	return love.keyboard.isDown(key)
end

-- returns if the key has been pressed this frame
function Keyboard:keyDown(key)
	return keyStates[key]
end
-- returns if the key has been released this frame
function Keyboard:keyUp(key)
	return keyStates[key] == false
end

function Keyboard:hookLoveEvents()
	function love.keypressed(key, scancode, isrepeat)
		keyStates[key] = true
		_G.events:invoke("keyPressed", key)
	end
	function love.keyreleased(key, scancode)
		keyStates[key] = false
		_G.events:invoke("keyReleased", key)		
	end

	function love.textinput(text)
		_G.events:invoke("textInput", text)				
    end
end

return Keyboard