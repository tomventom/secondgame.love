local Label = require("lib.ui.Label")

local TextField = Label:derive("TextField")

function TextField:new(x, y, w, h, text, color, align)
    TextField.super.new(self, x, y, w, h, text, color, align)
    self.focus = false

    self.keyPressed = function(key) self:onTextInput(key) end

    _G.events:hook("keyPressed", self.keyPressed)
end

function TextField:setFocus(focused)
    assert(type(focused) == "boolean", "parameter focused should be of type boolean")
    self.focus = focused
end

function TextField:onTextInput(key)
    print(key)
end

function TextField:draw()
    TextField.super.draw(self)
    love.graphics.rectangle("line", self.pos.x, self.pos.y - self.h / 2, self.w, self.h)
end

return TextField