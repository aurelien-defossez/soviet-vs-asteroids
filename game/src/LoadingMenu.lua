-----------------------------------------------------------------------------------------
--
-- LoadingMenu.lua
--
-- The loading screen.
--
-----------------------------------------------------------------------------------------
module("LoadingMenu", package.seeall)
local Class = LoadingMenu
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

-- Create the TitleMenu
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.selected = "skip"
    self.scale = gameConfig.screen.scale * 1.5
    self.elapsedTime = 0

    self.background = love.graphics.newImage("assets/graphics/gui/menu_bg.png")
    self.controllerGuy = love.graphics.newImage("assets/graphics/cosmonaute_controller.png")

    if game.controller.name == "pad" then
        self.startPos = vec2(
            (-800 / self.scale),
            (gameConfig.screen.real.height - 150 * self.scale) / 2
        )

        self.text = "You have a controller plugged in\nMother-Russia is happy!"
    else
        self.startPos = vec2(
            (-800 / self.scale),
            (gameConfig.screen.real.height - 100 * self.scale) / 2
        )

        self.text = "For Mother-Russia, play with a dual sticks controller.\nIf you have one, plug it in and restart the game"
    end

    self.endPos = vec2(
        (gameConfig.screen.real.width),
        self.startPos.y
    )

    self.starField = StarField.create{
        starCount = 30,
        boundaries = aabb(
            vec2(0, 0),
            vec2(gameConfig.screen.real.width, gameConfig.screen.real.height)
        )
    }

    self.buttons = {
        skip = Button.create{
            x = (gameConfig.screen.real.width - 444 * gameConfig.screen.scale) / 2, -- center
            y = gameConfig.screen.real.height - 100 * gameConfig.screen.scale,
            width = 444,
            height = 66,
            scale = gameConfig.screen.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Skip",
            callback = self.playGame,
            navigation = {}
        }
    }

    self.game:setZoom(1)

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
    self.elapsedTime = self.elapsedTime + dt

    self.starField:update(dt)
end

-- Draw the TitleMenu
function Class:draw()
    self.starField:draw()

    local bgPos = vec2(
        (gameConfig.screen.real.width - 609 * gameConfig.screen.scale) / 2,
        (gameConfig.screen.real.height - 720 * gameConfig.screen.scale) / 2
    )

    local bgWidth = 609 * gameConfig.screen.scale

    colors.white()
    love.graphics.draw(
        self.background,
        bgPos.x,
        bgPos.y,
        0,
        gameConfig.screen.scale
    )

    colors.white()
    love.graphics.setFont(game.fonts["72"])
    love.graphics.printf(
        "Welcome",
        bgPos.x,
        bgPos.y + bgWidth * .05,
        bgWidth,
        "center")

    love.graphics.setFont(game.fonts["Arial36"])
    love.graphics.printf(
        self.text,
        bgPos.x + bgWidth * .075,
        bgPos.y + 130,
        bgWidth * .85,
        "center")

    local rotation = -math.pi / 8 + self.elapsedTime * math.pi / 32
    local pos = self.startPos + (self.endPos - self.startPos) * self.elapsedTime / 12

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(
        self.controllerGuy,
        pos.x,
        pos.y,
        rotation,
        self.scale
    )

    love.graphics.setFont(game.fonts["48"])
    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function playGame()
    game:setMenu("title")
end

-----------------------------------------------------------------------------------------

return Class
