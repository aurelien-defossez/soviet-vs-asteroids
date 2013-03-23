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

    self.axis1 = 0
    self.axis2 = 0
    self.axis4 = 0
    self.axis5 = 0

    self.joy1Angle = 0
    self.joy2Angle = 0
    self.buttonPressed = ""

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

    if (not self.axis5) then
        self.axis5 = self.axis4
        self.axis4 = self.axis3
    end

    norm =  math.sqrt( self.axis1 * self.axis1 + self.axis2 * self.axis2 )
    norm2 =  math.sqrt( self.axis4 * self.axis4 + self.axis5 * self.axis5 )
    if (norm > 0.5) then
        self.joy1Angle = math.atan2(self.axis2, self.axis1)
        self.station:setMissileLauncherAngle(self.joy1Angle)
    end

    if (norm2 > 0.5) then
        self.joy2Angle = math.atan2(self.axis4, self.axis5)
        self.station:setLaserSatAngle(self.joy2Angle)
    end

end

-- Draw the game
function Class:draw()
    if (not love.joystick.isOpen(1) or not self.debug) then
        return
    end

    -- Draw scene
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(self.joy1Angle, 0, 0)
    love.graphics.line(0 , 0, 100*math.cos(self.joy1Angle), 100*math.sin(self.joy1Angle))
    love.graphics.setColor(0, 255, 0)
    love.graphics.print(self.joy2Angle, 0, 30)
    love.graphics.line(0 , 0, 100*math.cos(self.joy2Angle), 100*math.sin(self.joy2Angle))

    love.graphics.setColor(255,255,0)
    love.graphics.print("Button :" .. self.buttonPressed, -200, -200)

end

-----------------------------------------------------------------------------------------
-- Callbacks
-----------------------------------------------------------------------------------------
function love.joystickpressed( joystick, button )

    if (button == 5) then
        self.buttonPressed = "Missile !"
        self.station.launchMissile()
    end

    if (button == 6 or button == 7) then
        self.buttonPressed = "Laser !"
        self.station.fireLaser()
    end
end
