local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")

local Drawable = Class{
	ObjectType = "Drawable";

	MetaIndex = {
		__index = function(table, key)
			if type(table.drawable[key]) == "function" then
				return function() return table.drawable[key](table.drawable) end
			end
			return table.drawable[key]
		end;
	};

	init = function(self, drawable, drawData)
		if type(drawable) == "userdata" then
			if drawable:typeOf("Drawable") then
				self.drawable = drawable
				self:setDrawData(drawData)
				self.boundValues = {}
				--setmetatable(self, self.MetaIndex)

				return self
			end
		end
	end;

	--[[ Even though any variable will be accepted and stored. Only the following entries will have an effect internally.
		quad
		x 	-> X position on the screen (starting from the left)
		y 	-> Y position on the screen (starting from the top)
		r 	-> Rotation (in radians)
		sx 	-> ScaleX. How much to scale the image on x axis
		sy 	-> ScaleY. How much to scale the image on y axis
		ox 	-> OffsetX. Origin offset on x axis
		oy 	-> OffsetY. Origin offset on y axis
		kx 	-> Shearing factor on x axis
		ky 	-> Shearing factor on y axis
	]]
	setDrawData = function(self, drawData)
		if drawData then
			for variable, value in pairs(drawData) do
				self[variable] = value
			end
		end
	end;

	updateValues = function(self)
		for k, binding in pairs(self.boundValues) do
			if binding.table then
				if binding.table[binding.valueIndex] then
					self[k] = binding.table[binding.valueIndex]
				else
					return false
				end
			else
				return false
			end
		end
		return true
	end;

	-- Variable is the variable within self that should be overwritten.
	-- Table is the table containing the bound value
	-- valueIndex is the index at which the desired value is stored within "table"
	bindValue = function(self, variable, table, valueIndex)
		if table then
			valueIndex = valueIndex or variable
			if table[valueIndex] then
				self.boundValues[variable] = {table=table; valueIndex=valueIndex}
				return true
			end
		end
	end;

	unbindValue = function(self, variable)
		if self.boundValues[variable] then
			self.boundValues[variable] = nil
			return true
		end
	end;

	destroy = function(self)
		for k, v in pairs(self) do
			self[k] = nil
		end
	end;
}

return Drawable