-----------------------------------------------------------------------------------------
--
-- MouseController.lua
--
-- The MouseController class.
--
-----------------------------------------------------------------------------------------
module("MouseController", package.seeall)
local Class = MouseController
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("lib.math.vec2")
require("src.Config")
require("src.KeyboardController")

-- Create the MouseController
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.station = options.station
    self.game = options.game

    self.keyboardController = KeyboardController.create{
        station = self.station
    }

    function love.mousereleased(x, y, button)
        if button == "l" or button == "r" then
            if self.mode == "menu" then
                self.game.menus:enterSelected()
            elseif self.mode == "upgrade" then
                self.game:putUpgrade()
            end
        end
    end

    return self
end

-- Destroy the MouseController
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the MouseController
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    mouse = vec2(love.mouse.getPosition())

    if self.mode == "menu" then
        self.game.menus:selectButtonIn(mouse.x, mouse.y)
    elseif self.mode == "game" then
        mouse = mouse / self.game.virtualScaleFactor / self.game.zoom
        mouse = mouse - self.game.translateVector

        deltaRad = - math.atan2(mouse.y, mouse.x)

        if gameConfig.controls.mouse.controls == "lasers" then
            self.station:setLaserSatAngle(deltaRad)

            if self.mode == "game" then
                if love.mouse.isDown("l", "r") then
                    self.station:fireLaser()
                end
            end
        elseif gameConfig.controls.mouse.controls == "missiles" then
            self.station:setMissileLauncherAngle(deltaRad)

            if self.mode == "game" then
                if love.mouse.isDown("l", "r") then
                    self.station:launchMissile()
                end
            end
        else
            print("MouseController says: I don't know what a " .. gameConfig.controls.mouse.controls .. " is")
        end
    elseif self.mode == "upgrade" then
        mouse = mouse / self.game.virtualScaleFactor / self.game.zoom
        mouse = mouse - self.game.translateVector

        deltaRad = - math.atan2(mouse.y, mouse.x)

        if self.game.upgrade == "satellite" then
            self.station.newSatellite:setAngle(deltaRad)
        elseif self.game.upgrade == "drone" then
            self.station.newDrone:setAngle(deltaRad)
        end
    end

    -- we can't control both lasers and missiles with a single mouse,
    -- so we depend on the keyboard to control the missing one
    self.keyboardController:update(dt)
end

-- Draw the game
function Class:draw()
end
-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
    self.keyboardController:setMode(mode)
end

-----------------------------------------------------------------------------------------

return Class
