-----------------------------------------------------------------------------------------
--
-- KeyboardController.lua
--
-- The KeyboardController class.
--
-----------------------------------------------------------------------------------------
module("KeyboardController", package.seeall)
local Class = KeyboardController
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("src.Config")

-- Create the KeyboardController
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.station = options.station
    self.game = options.game

    function love.keypressed(key)
        -- Go to upgrade mode
        if key == "backspace" or key == "tab" then
            if self.mode == "game" then
                self.game:setMenu("upgrade")
            elseif self.mode == "upgrade" then
                self.game:setMenu("upgrade")
            elseif self.mode == "menu" and self.game.menu == "upgrade" then
                self.game:setMode("game")
            end
        end

        -- Go to pause menu
        if key == "p" then
            if self.mode == "menu" and self.game.menu == "pause" then
                self.game:setMode("game")
            elseif self.mode == "game" then
                self.game:setMenu("pause")
            end
        end

        -- Generic escape from menus and modes
        if key == "escape" then
            if self.mode == "upgrade" then
                self.game:setMenu("upgrade")
            elseif self.mode == "menu" then
                self.game:setMode("game")
            elseif self.mode == "game" then
                self.game:setMenu("pause")
            end
        end

    end

    return self
end

-- Destroy the KeyboardController
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the KeyboardController
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    deltaRad = gameConfig.controls.keyboard.delta

    -- Control the laser command
    if (love.keyboard.isDown("left")) then
        self.station:setLaserSatAngle(self.station.laserAngle - deltaRad)
    end

    if (love.keyboard.isDown("right")) then
        self.station:setLaserSatAngle(self.station.laserAngle + deltaRad)
    end


    -- Control the missiles launcher
    if (love.keyboard.isDown("a", "q")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle - deltaRad)
    end

    if (love.keyboard.isDown("d")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle + deltaRad)
    end

    if self.mode == "game" then
        -- I’M A’ FIRIN’ MAH LAZER!!
        self.station:fireLaser()

        -- SHOOP DA WHOOP!!!!
        if (love.keyboard.isDown(" ")) then
            self.station:launchMissile()
        end
    end
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
end

-----------------------------------------------------------------------------------------

return Class
