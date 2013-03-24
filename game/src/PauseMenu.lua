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

    self.buttons = {}
    table.insert(
        self.buttons,
        Button.create{
            x = gameConfig.screen.width * 0.2, -- 20%
            y = gameConfig.screen.height * 0.2,
            width = gameConfig.screen.width * 0.6, -- 60%
            height = gameConfig.screen.height * 0.2,
            text = "Resume",
            callback = self.resumeGame,
        }
    )
    table.insert(
        self.buttons,
        Button.create{
            x = gameConfig.screen.width * 0.2, -- 20%
            y = gameConfig.screen.height * 0.45,
            width = gameConfig.screen.width * 0.6, -- 60%
            height = gameConfig.screen.height * 0.2,
            text = "Restart",
            callback = self.restartGame,
        }
    )
    table.insert(
        self.buttons,
        Button.create{
            x = gameConfig.screen.width * 0.2, -- 20%
            y = gameConfig.screen.height * 0.7,
            width = gameConfig.screen.width * 0.6, -- 60%
            height = gameConfig.screen.height * 0.2,
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
    colors.green()
    love.graphics.printf("Pause menu", 0, gameConfig.screen.height * 0.1, gameConfig.screen.width, "center")

    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function resumeGame()
    self.game:setMode("game")
end

function restartGame()
    print("Restart GAME")
end

function quitGame()
    print("Quit GAME")
end

-----------------------------------------------------------------------------------------

return Class
