-----------------------------------------------------------------------------------------
--
-- PauseMenu.lua
--
-- The main PauseMenu class.
--
-----------------------------------------------------------------------------------------
module("PauseMenu", package.seeall)
local Class = PauseMenu
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")
require("src.gui.Button")
require("src.gui.Colors")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the PauseMenu
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.selected = 1
    self.scale = gameConfig.screen.scale

    self.background = love.graphics.newImage("assets/graphics/gui/menu_bg.png")

    self.buttons = {}
    table.insert(
        self.buttons,
        Button.create{
            x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
            y = gameConfig.screen.height / 2 - 100 * self.scale,
            scale = self.scale,
            text = "Resume",
            callback = self.resumeGame,
        }
    )
    table.insert(
        self.buttons,
        Button.create{
            x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
            y = gameConfig.screen.height / 2 - 20 * self.scale,
            scale = self.scale,
            text = "Restart",
            callback = self.restartGame,
        }
    )
    table.insert(
        self.buttons,
        Button.create{
            x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
            y = gameConfig.screen.height / 2 + 60 * self.scale,
            scale = self.scale,
            text = "Quit",
            callback = self.quitGame,
        }
    )

    return self
end

-- Destroy the PauseMenu
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the PauseMenu
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
end

-- Draw the PauseMenu
function Class:draw()
    -- display the background
    love.graphics.draw(
        self.background,
        (gameConfig.screen.width - 609 * self.scale) / 2,
        (gameConfig.screen.height - 720 * self.scale) / 2,
        0,
        self.scale
    )

    colors.white()
    love.graphics.setFont(self.game.fonts["72"])
    love.graphics.printf(
        "Pause menu",
        0,
        gameConfig.screen.height / 2 - 300 * self.scale,
        gameConfig.screen.width,
        "center"
    )
    love.graphics.setFont(self.game.fonts["48"])

    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function resumeGame()
    self.game:setMode("game")
end

function restartGame()
    restart()
end

function quitGame()
    love.event.quit()
end

-----------------------------------------------------------------------------------------

return Class
