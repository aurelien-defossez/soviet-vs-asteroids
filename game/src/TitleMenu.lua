-----------------------------------------------------------------------------------------
--
-- TitleMenu.lua
--
-- The main TitleMenu class.
--
-----------------------------------------------------------------------------------------
module("TitleMenu", package.seeall)
local Class = TitleMenu
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

-- Create the TitleMenu
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.selected = "start"
    self.scale = gameConfig.screen.scale - 0.09

    self.background = love.graphics.newImage("assets/graphics/intro_screen.png")

    self.buttons = {
        start = Button.create{
            x = (gameConfig.screen.width - 444 * gameConfig.screen.scale) / 2, -- center
            y = gameConfig.screen.height / 2 + 300 * gameConfig.screen.scale,
            width = 444,
            height = 66,
            scale = gameConfig.screen.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Start Game",
            callback = self.playGame,
            navigation = {
                up = "quit",
                down = "quit"
            }
        },
        quit = Button.create{
            x = (gameConfig.screen.width - 444 * gameConfig.screen.scale) / 2, -- center
            y = gameConfig.screen.height / 2 + 400 * gameConfig.screen.scale,
            width = 444,
            height = 66,
            scale = gameConfig.screen.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Quit",
            callback = self.quitGame,
            navigation = {
                up = "start",
                down = "start"
            }
        }
    }

    return self
end

-- Destroy the TitleMenu
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the TitleMenu
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
end

-- Draw the TitleMenu
function Class:draw()
    -- display the background
    love.graphics.draw(
        self.background,
        (gameConfig.screen.width - 1920 * self.scale) / 2,
        (gameConfig.screen.height - 1080 * self.scale) / 2,
        0,
        self.scale
    )

    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function playGame()
    self.game:setMode("game")
end

function quitGame()
    love.event.quit()
end

-----------------------------------------------------------------------------------------

return Class
