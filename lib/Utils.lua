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

function U.mouseInRect(rx, ry, rw, rh, mouseX, mouseY)
	return mouseX >= rx - rw / 2 and
	mouseX <= rx + rw / 2 and
	mouseY >= ry - rh / 2 and
	mouseY <= ry + rh / 2
end

function U.round(num)
	return math.floor(num + 0.5)
end

return U
