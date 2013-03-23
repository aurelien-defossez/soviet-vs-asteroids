-----------------------------------------------------------------------------------------
--
-- KeyboardControler.lua
--
-- The KeyboardControler class.
--
-----------------------------------------------------------------------------------------
module("KeyboardControler", package.seeall)
local Class = KeyboardControler
Class.__index = Class
local sin = math.sin
local cos = math.cos

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("src.Config")
require("src.Station")

-- Create the KeyboardControler
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.station = options.station

    -- Set virtual viewport
    self.virtualScreenHeight = gameConfig.camera.minVirtualHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    self.camera = vec2(0, 0)
    self.zoom = 1.0

    return self
end

-- Destroy the KeyboardControler
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the KeyboardControler
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    deltaRad = math.pi / 36 -- 10°

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
    if (love.keyboard.isDown("a")) then
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
    love.graphics.push()
    love.graphics.pop()
end
