local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Mesh = Class{
	ObjectType = "Mesh";
	__includes = Drawable;

	init = function(self, data, drawData)			
		Drawable.init(self, originalNewMesh(unpack(data)), drawData)

		return self
	end;
}

originalNewMesh = love.graphics.newMesh
love.graphics.newMesh = function(data, drawData)
	return Mesh(data, drawData)
end

return Mesh