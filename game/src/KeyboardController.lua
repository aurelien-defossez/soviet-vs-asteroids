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

<<<<<<< HEAD:game/src/KeyboardController.lua
=======
    function love.keypressed(key)
        -- Go to upgrade mode
        if key == "backspace" or key == "tab" then
            if self.mode == "game" then
                self.game:setMode("upgrade")
            elseif self.mode == "upgrade" then
                self.game:setMode("game")
            end
        end
    end

>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de:game/src/KeyboardController.lua
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

<<<<<<< HEAD:game/src/KeyboardController.lua
    -- I’M A’ FIRIN’ MAH LAZER!!
    if (love.keyboard.isDown("rctrl")) then
        self.station:fireLaser()
    else
        self.station:stopLaser()
    end

=======
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de:game/src/KeyboardController.lua
    -- Control the missiles launcher
    if (love.keyboard.isDown("a", "q")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle - deltaRad)
    end

    if (love.keyboard.isDown("d")) then
        self.station:setMissileLauncherAngle(self.station.missileAngle + deltaRad)
    end

    if self.mode == "game" then
        -- I’M A’ FIRIN’ MAH LAZER!!
        if (love.keyboard.isDown("rctrl")) then
            self.station:fireLaser()
        end

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
