require("src.Config")
require("src.Game")

function love.load()
	love.graphics.setMode(gameConfig.screen.width, gameConfig.screen.height, false)
    game = Game.create()
    game:setDemoMode(false)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
