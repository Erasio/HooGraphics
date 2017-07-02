local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Mesh = Class{
	ObjectType = "Mesh";
	__includes = Drawable;

	init = function(self, data, drawData)
		input = {}
		if data["vertexformat"] then
			table.insert(data["vertexformat"])
			table.insert(data["vertexcount"])
			table.insert(data["mode"])
			table.insert(data["usage"])
		elseif data["vertexcount"] then
			if data["mode"] then
				table.insert(data["vertexcount"])
				table.insert(data["mode"])
				table.insert(data["usage"])
			elseif data["vertices"] then
				table.insert(data["vertexcount"])
				table.insert(data["vertices"])
				table.insert(data["mode"])
				table.insert(data["mode"])
			end
		elseif data["vertices"] then
			table.insert(data["vertices"])
			table.insert(data["mode"])
			table.insert(data["usage"])
		else
			return
		end
				

		Drawable.init(self, originalNewMesh(unpack(input)), drawData)

		return self
	end;
}

originalNewMesh = love.graphics.newMesh
love.graphics.newMesh = function(data, drawData)
	return Mesh(data, drawData)
end

return Mesh