require("src.Config")
require("src.Game")

function love.load()
	-- Set width and height to zero to retrieve desktop resolution
	love.graphics.setMode(0, 0, false)
	gameConfig.screen.real.width = love.graphics.getWidth()
	gameConfig.screen.real.height = love.graphics.getHeight()
	gameConfig.screen.scale = gameConfig.screen.virtual.width / gameConfig.screen.real.width / .6

	-- Set mode a second time to really apply the resolution (does not work otherwise)
	love.graphics.setMode(gameConfig.screen.real.width, gameConfig.screen.real.height, gameConfig.fullScreen)

    game = Game.create()
    game:setDemoMode(false)
    game:setMenu("title")
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function restart()
    game:destroy()
    game = Game.create()
end
