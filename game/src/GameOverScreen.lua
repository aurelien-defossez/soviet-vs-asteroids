-----------------------------------------------------------------------------------------
--
-- GameOverScreen.lua
--
-- I'm blue dabeuhdidabeuhdahh.
--
-----------------------------------------------------------------------------------------

module("GameOverScreen", package.seeall)
local Class = GameOverScreen
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.setup()
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.elapsedTime = 0

    -- Initialize attributes
    self.gameoverimage = love.graphics.newImage("assets/graphics/game_over.png")    
    self.explosionimage = love.graphics.newImage("assets/graphics/game_over_explosion.png")
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class.update(dt)
    self.elapsedTime = self.elapsedTime + dt
end

function Class.draw()
    -- Text size
    local size = math.max(1, 10 - 10 * self.elapsedTime / .5)

    -- Shake screen
    if self.elapsedTime > .5 and self.elapsedTime < .8 then
        game.camera = vec2(math.random(-10, 10), math.random(-10, 10))
    else
        game.camera = vec2(0, 0)
    end

    love.graphics.draw(
        self.explosionimage,
        (gameConfig.screen.width/2)-(self.explosionimage:getWidth()/2),
        (gameConfig.screen.height/2)-(self.explosionimage:getHeight()/2)
    )

    love.graphics.draw(
        self.gameoverimage,
        (gameConfig.screen.width/2)-(self.gameoverimage:getWidth() * size /2),
        (gameConfig.screen.height/2)-(self.gameoverimage:getHeight() * size /2),
        0,
        size,
        size
    )
end
