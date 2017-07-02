local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")
local SpriteBatch = Class{
	ObjectType = "SpriteBatch";
	__includes = Drawable;

	init = function(self, image, maxsprites, usage, drawData)
		if image.drawable then
			image = image.drawable
		end
		Drawable.init(self, originalNewSpriteBatch(image, maxsprites, usage), drawData)

		return self
	end;
}

originalNewSpriteBatch = love.graphics.newCanvas
love.graphics.newSpriteBatch = function(image, maxsprites, usage, drawData)
	return SpriteBatch(image, maxsprites, usage, drawData)
end

return SpriteBatch