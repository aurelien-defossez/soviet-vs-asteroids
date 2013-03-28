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
    self.selected = options.gameover and "restart" or "resume"
    self.scale = gameConfig.screen.scale

    self.background = love.graphics.newImage("assets/graphics/gui/menu_bg.png")

    self.buttons = {}

    if not options.gameover then
        self.buttons.resume = Button.create{
            x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
            y = gameConfig.screen.height / 2 - 100 * self.scale,
            width = 444,
            height = 66,
            scale = self.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Resume",
            callback = self.resumeGame,
            navigation = {
                up = "quit",
                down = "restart"
            }
        }
    end

    self.buttons.restart = Button.create{
        x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
        y = gameConfig.screen.height / 2 - 20 * self.scale,
        width = 444,
        height = 66,
        scale = self.scale,
        background = "btn_off",
        border = "btn_on",
        text = "Restart",
        callback = self.restartGame,
        navigation = {
            up = options.gameover and "quit" or "resume",
            down = "quit"
        }
    }

    self.buttons.quit = Button.create{
        x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
        y = gameConfig.screen.height / 2 + 60 * self.scale,
        width = 444,
        height = 66,
        scale = self.scale,
        background = "btn_off",
        border = "btn_on",
        text = "Quit",
        callback = self.quitGame,
        navigation = {
            up = "restart",
            down = options.gameover and "restart" or "resume"
        }
    }

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
