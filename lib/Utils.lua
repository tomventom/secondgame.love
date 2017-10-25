local U = {}

function U.color(r, g, b, a)
	return {r, g or r, b or r, a or 255}
end

function U.grey(level, a)
	return {level, level, level, a or 255}
end

function U.pointInRect(point, rect)
	return not (point.x > rect.x + rect.w or
		point.x < rect.x or
		point.y > rect.y + rect.h or
	point.y < rect.y)
end

function U.mouseInBounds(self, mouseX, mouseY)
	return mouseX >= self.pos.x - self.w / 2 and
	mouseX <= self.pos.x + self.w / 2 and
	mouseY >= self.pos.y - self.h / 2 and
	mouseY <= self.pos.y + self.h / 2
end

return U
