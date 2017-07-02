local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Canvas = Class{
	ObjectType = "Canvas";
	__includes = Drawable;

	init = function(self, drawData, ...)
		Drawable.init(self, originalNewCanvas(...), drawData)

		return self
	end;
}

originalNewCanvas = love.graphics.newCanvas
love.graphics.newCanvas = function(data, drawData)
	return Canvas(data, drawData)
end

return Canvas