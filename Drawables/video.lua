local modulePath = (...):match("(.-)[^%.]+$")
modulePath = modulePath:sub(1, -2)
modulePath = (modulePath):match("(.-)[^%.]+$")
local Class = require(modulePath .. "Dependencies.class")
local Drawable = require(modulePath .. "Drawables.drawable")

local Video = Class{
	ObjectType = "Video";
	__includes = Drawable;

	init = function(self, filename, loadaudio, drawData)
		Drawable.init(self, originalNewVideo(filename, loadaudio), drawData)

		return self
	end;
}

originalNewVideo = love.graphics.newVideo
love.graphics.newCanvas = function(filename, loadaudio, drawData)
	return Video(filename, loadaudio, drawData)
end

return Video