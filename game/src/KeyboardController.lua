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

        -- Navigate in menus
        if key == "down" or key == "right" then
            if self.mode == "menu" then
                self.game.menus:nextButton()
            end
        end
        if key == "up" or key == "left" then
            if self.mode == "menu" then
                self.game.menus:previousButton()
            end
        end
        if key == "return" then
            if self.mode == "menu" then
                self.game.menus:enterSelected()
            elseif self.mode == "upgrade" then
                self.game:putUpgrade()
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
 
    if self.mode == "game" then
        -- Control the laser command
        if love.keyboard.isDown("left") then
            self.station:setLaserSatAngle((self.station.laserAngle - deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
        end

        if love.keyboard.isDown("right") then
            self.station:setLaserSatAngle((self.station.laserAngle + deltaRad + math.pi ) % ( 2 * math.pi) - math.pi )
        end


        -- Control the missiles launcher
        if love.keyboard.isDown("a", "q") then
            self.station:setMissileLauncherAngle((self.station.missileAngle - deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
        end

        if love.keyboard.isDown("d") then
            self.station:setMissileLauncherAngle((self.station.missileAngle + deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
        end

      -- I’M A’ FIRIN’ MAH LAZER!!
        self.station:fireLaser()
       
        -- SHOOP DA WHOOP!!!!
        if love.keyboard.isDown(" ") then
            self.station:launchMissile()
        end
    elseif self.mode == "upgrade" then
        if love.keyboard.isDown("left", "a", "q") then
            if self.game.upgrade == "satellite" then
                self.station.newSatellite:setAngle((self.station.newSatellite.angle - deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
            elseif self.game.upgrade == "drone" then
                self.station.newDrone:setAngle((self.station.newDrone.angle - deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
            end
        end

        if love.keyboard.isDown("right", "d") then
            if self.game.upgrade == "satellite" then
                self.station.newSatellite:setAngle((self.station.newSatellite.angle + deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
            elseif self.game.upgrade == "drone" then
                self.station.newDrone:setAngle((self.station.newDrone.angle + deltaRad + math.pi ) % ( 2 * math.pi ) - math.pi )
            end
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
