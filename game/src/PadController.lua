-----------------------------------------------------------------------------------------
--
-- Station.lua
--
-- The padController class.
--
-----------------------------------------------------------------------------------------
module("PadController", package.seeall)
local Class = PadController
Class.__index = Class
local sin = math.sin
local cos = math.cos

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("src.Config")
require("src.Station")

-- Create the padController
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes
    self.station = options.station
    self.game = options.game

    self.axis1 = 0
    self.axis2 = 0
    self.axis4 = 0
    self.axis5 = 0

    self.joy1Angle = 0
    self.joy2Angle = 0
    self.buttonPressed = ""

    self.axis1Released = true
    self.axis2Released = true

    return self
end

-- Destroy the padController
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the padController
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)


    if (not love.joystick.isOpen(1)) then
        return
    end

    -- Joystick
    -- 1 X et 2 Y, left
    -- 3  L2, R2
    -- 4 Y et 5 X
    self.axis1, self.axis2, self.axis3, self.axis4, self.axis5  = love.joystick.getAxes( 1 )

    if love.joystick.getName(1) == "Mega World Thrustmaster dual analog 3.2" then
        self.axis5 = self.axis3
        self.axis4 = self.axis4
    end

    norm =  math.sqrt( self.axis1 * self.axis1 + self.axis2 * self.axis2 )
    norm2 =  math.sqrt( self.axis4 * self.axis4 + self.axis5 * self.axis5 )
    self.joy1Angle = math.atan2(self.axis2, self.axis1)
    self.joy2Angle = math.atan2(self.axis4, self.axis5)

    if self.mode == "game" then
        if (norm > 0.5) then
            self.station:setMissileLauncherAngle( -self.joy1Angle)
        end

        if (norm2 > 0.5) then
            self.station:setLaserSatAngle( -self.joy2Angle)
        end

        if ( love.joystick.isDown( 1, 5 ) ) then
            self.station:launchMissile()
        end

        if ( love.joystick.isDown( 1, 6 ) or love.joystick.isDown( 1, 7 ) ) then
            self.station:fireLaser()
        else
            self.station:stopLaser()
        end
    elseif self.mode == "menu" then
        -- Navigate in menus
        if ((self.axis1 > 0.5 and self.axis1Released) or (self.axis2 > 0.5 and self.axis2Released)) then
            if self.mode == "menu" then
                self.axis1Released = false
                self.axis2Released = false
                self.game.menus:nextButton()
            end
        end
        if ((self.axis1 < -0.5 and self.axis1Released) or (self.axis2 < -0.5 and self.axis2Released)) then
            if self.mode == "menu" then
                self.axis1Released = false
                self.axis2Released = false
                self.game.menus:previousButton()
            end
        end

        if ( (self.axis1 > -0.5 and self.axis1 < 0.5)) then
            self.axis1Released = true
        end

        if ( (self.axis2 > -0.5 and self.axis2 <= 0 ) or (self.axis2 < 0.5 and self.axis2 >= 0) ) then
            self.axis2Released = true
        end
    elseif self.mode == "upgrade" then
        if norm > 0.5 then
            if self.game.upgrade == "satellite" then
                self.station.newSatellite:setAngle( -self.joy1Angle)
            elseif self.game.upgrade == "drone" then
                self.station.newDrone:setAngle( -self.joy1Angle)
            end
        elseif norm2 > 0.5 then
            if self.game.upgrade == "satellite" then
                self.station.newSatellite:setAngle( -self.joy2Angle)
            elseif self.game.upgrade == "drone" then
                self.station.newDrone:setAngle( -self.joy2Angle)
            end
        end
    end

end

-- Draw the game
function Class:draw()

    if (not love.joystick.isOpen(1) or not self.debug) then
        return
    end

    -- Draw scene

    --love.graphics.print(self.buttonPressed, 0, 0)
   -- love.graphics.line(0 , 0, 100*math.cos(self.joy1Angle), 100*math.sin(self.joy1Angle))
    --love.graphics.setColor(0, 255, 0)
    --love.graphics.print(self.joy2Angle, 0, 30)
   -- love.graphics.line(0 , 0, 100*math.cos(self.joy2Angle), 100*math.sin(self.joy2Angle))



end

-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end


function love.joystickpressed( joystick, button )
    -- X = 3
    -- Y = 4
    -- A = 1
    -- B = 2
    -- Start = 8
    --self.buttonPressed = button
    if button == 4 then
        if self.mode == "game" then
            self.game:setMenu("upgrade")
        elseif self.mode == "upgrade" then
            self.game:setMenu("upgrade")
        elseif self.mode == "menu" and self.game.menu == "upgrade" then
            self.game:setMode("game")
        end
    end

    -- Go to pause menu and generic escape from menus and modes
    if button == 8 then
        if self.mode == "menu" and self.game.menu == "pause" then
            self.game:setMode("game")
        elseif self.mode == "game" then
            self.game:setMenu("pause")
        elseif self.mode == "upgrade" then
            self.game:setMenu("upgrade")
        elseif self.mode == "menu" then
            self.game:setMode("game")
        elseif self.mode == "game" then
            self.game:setMenu("pause")
        end


        return
    end

    -- Navigate in menus
    if button == 1 then
        if self.mode == "menu" then
            self.game.menus:enterSelected()
        elseif self.mode == "upgrade" then
            self.game:putUpgrade()
        end
    end

    return self
    
end
