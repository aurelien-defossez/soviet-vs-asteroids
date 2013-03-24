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

    -- Initialize attributes
    self.gameoverimage = love.graphics.newImage("assets/graphics/game_over.png")    
    self.explosionimage = love.graphics.newImage("assets/graphics/game_over_explosion.png")
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class.draw()
    love.graphics.draw(
        self.explosionimage,
        (gameConfig.screen.width/2)-(self.explosionimage:getWidth()/2),
        (gameConfig.screen.height/2)-(self.explosionimage:getHeight()/2)
        )

    love.graphics.draw(
        self.gameoverimage,
        (gameConfig.screen.width/2)-(self.gameoverimage:getWidth()/2),
        (gameConfig.screen.height/2)-(self.gameoverimage:getHeight()/2)
        )
end
