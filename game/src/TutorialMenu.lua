-----------------------------------------------------------------------------------------
--
-- TutorialMenu.lua
--
-- The main TutorialMenu class.
--
-----------------------------------------------------------------------------------------
module("TutorialMenu", package.seeall)
local Class = TutorialMenu
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")
require("src.gui.Button")
require("src.gui.Colors")
require("src.StarField")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the TutorialMenu
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.selected = "start"
    self.scale = gameConfig.screen.scale

    self.background = love.graphics.newImage("assets/graphics/gui/menu_bg.png")
    self.tutorial = love.graphics.newImage("assets/graphics/gui/controller_tutorial.png")
    self.starField = StarField.create{
        starCount = 30,
        boundaries = aabb(
            vec2(0, 0),
            vec2(gameConfig.screen.real.width, gameConfig.screen.real.height)
        )
    }

    self.buttons = {
        start = Button.create{
            x = (gameConfig.screen.real.width - 444 * gameConfig.screen.scale) / 2, -- center
            y = gameConfig.screen.real.height / 2 + 230 * gameConfig.screen.scale,
            width = 444,
            height = 66,
            scale = gameConfig.screen.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Play",
            callback = self.playGame,
            navigation = {
                up = "start",
                down = "start"
            }
        }
    }

    return self
end

-- Destroy the TutorialMenu
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the TutorialMenu
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.starField:update(dt)
end

-- Draw the TutorialMenu
function Class:draw()
    self.starField:draw()

    -- display the background
    colors.black()
    colors.mode("replace")

    love.graphics.draw(
        self.background,
        (gameConfig.screen.real.width - 609 * self.scale) / 2,
        (gameConfig.screen.real.height - 720 * self.scale) / 2,
        0,
        self.scale
    )

    colors.white()
    love.graphics.setFont(self.game.fonts["72"])
    love.graphics.printf(
        "Tutorial",
        0,
        gameConfig.screen.real.height / 2 - 300 * self.scale,
        gameConfig.screen.real.width,
        "center"
    )
    love.graphics.setFont(self.game.fonts["36"])

    if self.game.controller == "joystick" then
        colors.black()
        love.graphics.draw(
            self.tutorial,
            (gameConfig.screen.real.width - 504 * self.scale) / 2,
            (gameConfig.screen.real.height - 371 * self.scale) / 2,
            0,
            self.scale
        )
    else
        textX = (gameConfig.screen.real.width - 609 * self.scale) / 2 + 50 * self.scale
        textY = gameConfig.screen.real.height / 2 + 50 * self.scale
        textW = 609 * self.scale - 100 * self.scale

        colors.mode("modulate")

        colors.white()
        love.graphics.printf(
            "Mouse",
            textX, textY - 200 * self.scale,
            textW, "left"
        )
        colors.black()
        love.graphics.printf(
            "Aim with rocket launcher",
            textX, textY - 200 * self.scale,
            textW, "right"
        )

        colors.white()
        love.graphics.printf(
            "Space, Click",
            textX, textY - 150 * self.scale,
            textW, "left"
        )
        colors.black()
        love.graphics.printf(
            "Fire rocket launcher",
            textX, textY - 150 * self.scale,
            textW, "right"
        )

        colors.white()
        love.graphics.printf(
            "[A,Q], D",
            textX, textY - 100 * self.scale,
            textW, "left"
        )
        colors.black()
        love.graphics.printf(
            "Aim with laser",
            textX, textY - 100 * self.scale,
            textW, "right"
        )

        colors.white()
        love.graphics.printf(
            "Tab, Backspace",
            textX, textY - 50 * self.scale,
            textW, "left"
        )
        colors.black()
        love.graphics.printf(
            "Buy upgrades",
            textX, textY - 50 * self.scale,
            textW, "right"
        )

        colors.white()
        love.graphics.printf(
            "Esc",
            textX, textY,
            textW, "left"
        )
        colors.black()
        love.graphics.printf(
            "Pause",
            textX, textY,
            textW, "right"
        )
    end

    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function playGame()
    self.game:setMode("game")
end

-----------------------------------------------------------------------------------------

return Class
