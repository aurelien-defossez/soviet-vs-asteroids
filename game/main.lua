require("src.Game")

function love.load()
	game = Game.create()
end

function love.update(dt)
	game:update(dt * 0.001)
end

function love.draw()
	game:draw()
end
