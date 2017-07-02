local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local ParticleSystem = Class{
	ObjectType = "ParticleSystem";
	__includes = Drawable;

	init = function(self, image, buffer, drawData)
		if image.drawable then
			image = image.drawable
		end
		Drawable.init(self, originalNewParticleSystem(image, buffer))

		return self
	end;
}

originalNewParticleSystem = love.graphics.newParticleSystem
love.graphics.newParticleSystem = function(image, buffer, drawData)
	return ParticleSystem(image, buffer, drawData)
end

return ParticleSystem