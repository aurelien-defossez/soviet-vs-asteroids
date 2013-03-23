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

    -- I’M A’ FIRIN’ MAH LAZER!!
    if (love.keyboard.isDown("rctrl")) then
        self.station:fireLaser()
    end

    -- Control the missiles launcher
    if (love.keyboard.isDown("a", "q")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle - deltaRad)
    end

    if (love.keyboard.isDown("d")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle + deltaRad)
    end

    -- SHOOP DA WHOOP!!!!
    if (love.keyboard.isDown(" ")) then
        self.station:launchMissile()
    end
end

-- Draw the game
function Class:draw()
end
