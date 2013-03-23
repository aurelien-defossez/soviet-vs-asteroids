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
    self.radius = 100

    self.laserSats = {}
    self.missileArmLength = 100
    self.laserStationOrbit = 100
    self.missileAngle = 0
    self.laserAngle = 0

    -- Missiles cooldown
    self.lastSentMissileTime = - gameConfig.missiles.cooldown -- so we can shoot right away
    self.missileCoolDownTime = gameConfig.missiles.cooldown

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
    -- Verify the cooldown
    if (self.lastSentMissileTime + self.missileCoolDownTime > love.timer.getTime()) then
        -- don't send the missile
        return
    end

    self.lastSentMissileTime = love.timer.getTime()

    -- Send the missile
    self.space:addMissile(Missile.create{
        x = self.missileArmLength * math.cos(-self.missileAngle),
        y = self.missileArmLength * math.sin(-self.missileAngle),
        angle = self.missileAngle,
        speed = 10
    })
end

function Class:fireLaser()


    local closestAsteroid = self:findClosestAsteroid(self.laserAngle, gameConfig.laser.laserWidth)

    if (closestAsteroid == nil) then
        return
    end

    for _, laserSat in pairs(self.laserSats) do
        laserSat:fire(self.laserAngle, closestAsteroid)
    end
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

-- Parameters :
-- angle : the angle of the ray
function Class:findClosestAsteroid(angle, width)

    local closestAsteroid = nil
    local minDist = -1
    local minDistchecker = - 1
    for _, asteroid in pairs(self.space.asteroids) do
        minDistchecker = math.abs(asteroid:distanceWithLine(angle))       
        if ((minDistchecker < minDist or minDist == -1)  and minDistchecker < width ) then
            
            minDist = minDistchecker
            closestAsteroid = asteroid
        end
    end

    return closestAsteroid
end




