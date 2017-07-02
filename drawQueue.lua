local modulePath = (...):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")

local DrawQueue = Class{
	ObjectType = "DrawQueue";

	init = function(self)
		self.layers = {}
		return self
	end;

	draw = function(self)
		for k, layer in pairs(self.layers) do
			for l, drawable in pairs(layer) do
				love.graphics.draw(drawable)
			end
		end
	end;

	add = function(self, newDrawable)
		if utils.typeOf(newDrawable, "Drawable") then
			if not newDrawable.layer then
				newDrawable.layer = 1
			end

			if not self.layers[newDrawable.layer] then
				for i=#self.layers + 1, newDrawable.layer do
					self.layers[i] = {}
				end
			end

			table.insert(self.layers[newDrawable.layer], newDrawable)
			return true
		end
		return false
	end;

	remove = function(self, drawable)
		if utils.type(drawable) == "Drawable" then
			for k, layer in pairs(self.layers) do
				for l, v in pairs(layer) do
					if v == drawable then
						table.remove(self.layers[k][l])
						return
					end
				end
			end
		end
	end;
}

love.graphics.newDrawQueue = function()
	return HooGraphics.DrawQueue()
end

return DrawQueue
