function love.load()
	HooGraphics = require "init"
	test = love.graphics.newImage("default.png", {x=100;y=100})
	test2 = love.graphics.newImage("default.png", {x=200;y=200})
	test3 = love.graphics.newImage("default.png", {x=500;y=300})
	player = {x=100; y=100; speed=100}
	test:bindValue("x", player)
	test:bindValue("y", player)
	drawQ = love.graphics.newDrawQueue()
	drawQ:add(test)
	drawQ:add(test2)
	drawQ:add(test3)
end

function love.update(dt)
	if love.keyboard.isDown("a") then
		player.x = player.x - player.speed * dt
		test:setDrawData({sx=-1;ox=test.width})
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + player.speed * dt
		test:setDrawData({sx=1;ox=0})
	end
	if love.keyboard.isDown("w") then
		player.y = player.y - player.speed * dt
	end
	if love.keyboard.isDown("s") then
		player.y = player.y + player.speed * dt
	end
end

function love.draw()
	love.graphics.draw(drawQ)
end
