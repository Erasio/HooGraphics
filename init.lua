local folderPath = (...):match("(.-)[^%.]+$")

local Class = require(folderPath .. "Dependencies.class")
local Event = require(folderPath .. "Dependencies.signal")

utils = require(folderPath .. "Dependencies.utils")

local HooGraphics = {
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
					local input = {
						drawable.drawable,
						drawable.quad or xOrQuad,
						drawable.x or yOrX,
						drawable.y or rOrY,
						drawable.r or sxOrR, 
						drawable.sx or syOrSx,
						drawable.sy or oxOrSy,
						drawable.ox or oyOrOx,
						drawable.oy or kxOrOy,
						drawable.kx or kyOrKx,
						drawable.ky or ky
					}
					originalDraw(unpack(input))
				else
					originalDraw(drawable.drawable, drawable.x or xOrQuad, drawable.y or yOrX, drawable.r or rOrY, drawable.sx or sxOrR, drawable.sy or syOrSx, drawable.ox or oxOrSy, drawable.oy or oyOrOx, drawable.kx or kxOrOy, drawable.ky or kyOrKx)
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
