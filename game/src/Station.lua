-----------------------------------------------------------------------------------------
--
-- Station.lua
--
-- The station class.
--
-----------------------------------------------------------------------------------------

module("Station", package.seeall)
local Class = Station
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Missile")
require("src.LaserSat")

local sin = math.sin
local cos = math.cos

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes 
    self.buttonPressed = ""
    self.radius = 100

    self.laserSats = {}
    self.missileArmLength = 100
    self.laserStationOrbit = 100
    self.missileAngle = 0
    self.laserAngle = 0

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes 

    return self
end

-- Destroy the station
function Class:destroy()
    for _, laserSat in pairs(self.laserSats) do
        laserSat:destroy()
    end
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:launchMissile()
    self.space:addMissile(Missile.create{
        x = self.missileArmLength * math.cos(-self.missileAngle),
        y = self.missileArmLength * math.sin(-self.missileAngle),
        angle = self.missileAngle,
        speed = 10
    })
    print("Missile Launched !")
    self.buttonPressed = "Missile !"
end
    
function Class:fireLaser()
    print("Laser Fired !!")
    self.buttonPressed = "Laser !"
end

function Class:addLaserSat(laserSat)
    table.insert(self.laserSats, laserSat)
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    for _, laserSat in pairs(self.laserSats) do
        laserSat:update(dt)
    end
end

-- Draw the game
function Class:draw()
    if (not self.debug) then
        return
    end

    -- Draw scene
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('line', 0, 0, self.radius, 32)

    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', self.radius * math.cos( -self.missileAngle), self.radius * math.sin( -self.missileAngle), 10, 32)
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle('fill', self.radius * math.cos( -self.laserAngle ), self.radius * math.sin( -self.laserAngle ), 10, 32)

    love.graphics.setColor(255,255,0)
    love.graphics.print("Button :" .. self.buttonPressed, -200, -200)

    for _, laserSat in pairs(self.laserSats) do
        laserSat:draw()
    end
end

function Class:setMissileLauncherAngle(angle)
    self.missileAngle = angle
end

function Class:setLaserSatAngle(angle)
    self.laserAngle = angle
end




