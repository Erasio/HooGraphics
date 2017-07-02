local folderPath = (...):match("(.-)[^%.]+$")

local Class = require(folderPath .. "Dependencies.class")
local Event = require(folderPath .. "Dependencies.signal")

utils = require(folderPath .. "Dependencies.utils")

HooGraphics = {
	ObjectType = "HooGraphics";

	DrawQueue = require(folderPath .. "drawQueue");

	Drawable = require(folderPath .. "Drawables.drawable");
	Image = require(folderPath .. "Drawables.image");
	Animation = require(folderPath .. "Drawables.animation");
	Canvas = require(folderPath .. "Drawables.canvas");
	Mesh = require(folderPath .. "Drawables.mesh");
	ParticleSystem = require(folderPath .. "Drawables.particleSystem");
	SpriteBatch = require(folderPath .. "Drawables.spriteBatch");

	images = {};
}

originalDraw = love.graphics.draw
love.graphics.draw = function(drawable, xOrQuad, yOrX, rOrY, sxOrR, syOrSx, oxOrSy, oyOrOx, kxOrOy, kyOrKx, ky)
	if drawable.drawable then
		if drawable.updateValues then
			if drawable:updateValues() then
				if drawable.quad then
					originalDraw(drawable.drawable, drawable.quad, drawable.x, drawable.y, drawable.r, drawable.sx, drawable.sy, drawable.ox, drawable.oy, drawable.kx, drawable.ky)
				else
					originalDraw(drawable.drawable, drawable.x, drawable.y, drawable.r, drawable.sx, drawable.sy, drawable.ox, drawable.oy, drawable.kx, drawable.ky)
				end
			else
				drawable:destroy()
			end
		end
	elseif drawable.draw then
		drawable:draw()
	else
		originalDraw(drawable, xOrQuad, yOrX, rOrY, sxOrR, syOrSx, oxOrSy, oyOrOx, kxOrOy, kyOrKx, ky)
	end
end

return HooGraphics
