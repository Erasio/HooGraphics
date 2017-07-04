local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Image = Class{
	ObjectType = "Image";
	__includes = Drawable;

	init = function(self, data, drawData)
		if type(data) == "string" then
			if not HooGraphics.images[data] then
				if drawData then
					flags = {}
					if drawData["flags"] then
						flags = drawData["flags"]
					else
						if drawData["mipmaps"] then
							flags["mipmaps"] = drawData["mipmaps"]
							drawData["mipmaps"] = nil
						end
						if drawData["linear"] then
							flags["linear"] = drawData["linear"]
							drawData["linear"] = nil
						end
					end
				end

				HooGraphics.images[data] = originalNewImage(data, flags)
			end
			Drawable.init(self, HooGraphics.images[data], drawData)
		else
			Drawable.init(self, originalNewImage(data), drawData)
		end

		return self
	end;
}

originalNewImage = love.graphics.newImage
love.graphics.newImage = function(data, drawData)
	return Image(data, drawData)
end

return Image