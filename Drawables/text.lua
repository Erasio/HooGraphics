local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Text = Class{
	ObjectType = "Text";
	__includes = Drawable;

	init = function(self, font, textstring, drawData)
		Drawable.init(self, originalNewText(font, textstring), drawData)

		return self
	end;
}

originalNewText = love.graphics.newText
love.graphics.newText = function(font, textstring, drawData)
	return Text(font, textstring, drawData)
end

return Text