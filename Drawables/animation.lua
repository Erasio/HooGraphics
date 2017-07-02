local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")
local Image = require(modulePath .. "Drawables.image")

--[[
Sprite Data contains all relevant sprite information and is included in drawData. The following settings are available:
width 		-> This marks the width of your sprite. The image will be split in chunks of this size.
height 		-> This marks the height of your sprite. Thie image will be split in chunks of this size.
duration	-> The duration of this animation. Frames will be cycled based on this value.
spriteCount	-> The amount of sprites within this animation. Sprites will be loaded from top left to bottom right. Important setting if you have empty "squares" within the frame.
]]

local Animation = Class{
	ObjectType = "Animation";
	__includes = Drawable;

	init = function(self, imagePath, drawData)
		if not HooGraphics.images[imagePath] then
			HooGraphics.images[imagePath] = originalNewImage(imagePath)
		end
		Drawable.init(self, HooGraphics.images[imagePath], drawData)
		self.width = drawData.spriteWidth or 10
		self.height = drawData.spriteHeight or 10
		self.duration = drawData.duration or 1
		if type(drawData.loop) ~= "nil" then
			self.loop = drawData.loop
		else
			self.loop = true
		end
		print(self.loop)
		self.currentTime = 0
		self.paused = drawData.paused or false
		self.quads = {}
		local widthCount = math.floor(self.drawable:getWidth() / self.width) - 1
		local heightCount = math.floor(self.drawable:getHeight() / self.height) - 1
		for j=0, heightCount do
			for i=0, widthCount do
				if drawData.spriteCount then
					if #self.quads == drawData.spriteCount then
						break
					end
				end
				table.insert(self.quads, love.graphics.newQuad(i * self.width + i, j * self.height + j, self.width, self.height, self.drawable:getDimensions()))
			end
			if #self.quads == drawData.spriteCount then
				break
			end
		end
		self.quad = self.quads[1]

		return self
	end;

	pause = function(self)
		self.paused = true
	end;

	play = function(self, restart)
		if restart then
			self:reset()
		end
		self.paused = false
	end;

	togglePaused = function(self)
		self.paused = not self.paused
	end;

	setPaused = function(self, paused)
		self.paused = paused
	end;

	reset = function(self)
		self.currentTime = 0;
	end;

	setProgress = function(self, progress)
		progress = progress or 0
		progress = progress % 1
		self.currentTime = self.duration * progress
	end;

	updateValues = function(self)
		if not self.paused then
			self.currentTime = self.currentTime + love.timer.getDelta()
			if self.currentTime >= self.duration then
				if self.loop then
					self.currentTime = self.currentTime - self.duration
				else
					self.currentTime = self.duration - 0.001
				end
			end
			self.quad = self.quads[math.floor(self.currentTime / (self.duration / #self.quads) + 1)]
		end

		return Drawable.updateValues(self)
	end;
}

love.graphics.newAnimation = function(image, drawData)
	return Animation(image, drawData)
end

return Animation
