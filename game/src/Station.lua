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
require("src.SoundManager")

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
<<<<<<< HEAD
=======
    self.buttonPressed = ""
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
    self.radius = 100

    self.laserSats = {}
    self.missileArmLength = 100
    self.laserStationOrbit = 100
    self.missileAngle = 0
    self.laserAngle = 0
    self.laserAlreadyFiring = false

    -- Missiles cooldown
    self.lastSentMissileTime = - gameConfig.missiles.cooldown -- so we can shoot right away
    self.missileCoolDownTime = gameConfig.missiles.cooldown

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes
<<<<<<< HEAD
    self.debugText = ""
=======
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de

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
        pos = vec2(self.missileArmLength * cos(-self.missileAngle), self.missileArmLength * sin(-self.missileAngle)),
        angle = self.missileAngle,
        speed = 10
    })
<<<<<<< HEAD
=======
    self.buttonPressed = "Missile !"
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
end

function Class:fireLaser()


    local closestAsteroid = self:findClosestAsteroid(self.laserAngle, gameConfig.laser.laserWidth)

    if (closestAsteroid == nil) then
        self:stopLaser()
        return
    end

    for _, laserSat in pairs(self.laserSats) do
        laserSat:fire(self.laserAngle, closestAsteroid)
    end
end

function Class:stopLaser()
    for _, laserSat in pairs(self.laserSats) do
        laserSat:stopFire(self.laserAngle, closestAsteroid)
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
<<<<<<< HEAD
    local numberLaserFiring = 0
=======
    if self.mode == "upgrade" then
        return
    end

>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
    for _, laserSat in pairs(self.laserSats) do
        laserSat:update(dt)
        if (laserSat.isFiring) then
            numberLaserFiring = numberLaserFiring + 1
        end
    end

    if (numberLaserFiring > 0) then
        if not (self.isLaserFiring) then
            SoundManager.laserStart()
            self.isLaserFiring = true
        end
    else
        if (self.isLaserFiring) then
            SoundManager.laserStop()
            self.isLaserFiring = false
        end
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

    --love.graphics.print('Laser: ' ..self.debugText, -100, 200)

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

<<<<<<< HEAD
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




=======
-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
