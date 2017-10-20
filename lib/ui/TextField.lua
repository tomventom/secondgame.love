local Label = require("lib.ui.Label")
local U = require("lib.Utils")
local utf8 = require("utf8")

local TextField = Label:derive("TextField")


function TextField:new(x, y, w, h, text, color, align)
    TextField.super.new(self, x, y, w, h, text, color, align)
    self.focus = false

    self.keyPressed = function(key) if key == "backspace" then self:onTextInput(key) end end
    self.textInput = function(text) self:onTextInput(text) end

    _G.events:hook("keyPressed", self.keyPressed)
    _G.events:hook("textInput", self.textInput)
end

function TextField:setFocus(focused)
    assert(type(focused) == "boolean", "parameter focused should be of type boolean")
    self.focus = focused
end

function TextField:onTextInput(text)
    -- if not self.focus or not self.enabled then return end
    if text == "backspace" then 
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(self.text, -1)
    
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, 
            -- so we couldn't do string.sub(text, 1, -2).
            self.text = string.sub(self.text, 1, byteoffset - 1)
        end
    else
        self.text = self.text .. text
    end
end

function TextField:draw()
    love.graphics.setColor(U.grey(32))
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2, self.w, self.h)
    TextField.super.draw(self)
end

return TextField