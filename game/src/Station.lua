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
require("src.utils")

local sin = math.sin
local cos = math.cos
local halfPi = math.pi / 2

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

    self.radius = gameConfig.station.radius
    self.laserSats = {}
    self.drones = {}
    self.missileArmLength = 100
    self.laserStationOrbit = 100
    self.missileAngle = 0
    self.laserAngle = 0
    self.laserAlreadyFiring = false
    self.score = 0
    self.coins = 0
    self.life = gameConfig.station.maxLife
    self.shieldRotation = 0
    self.boundingCircle = circle(gameConfig.station.shieldOffset, self.radius)

    self.platform = love.graphics.newImage("assets/graphics/cosmonaute_plateforme.png")
    self.body = love.graphics.newImage("assets/graphics/cosmonaute_corps.png")
    self.missileArmFront = love.graphics.newImage("assets/graphics/cosmonaute_missile_front.png")
    self.missileArmBack = love.graphics.newImage("assets/graphics/cosmonaute_missile_back.png")
    self.laserArmFront = love.graphics.newImage("assets/graphics/cosmonaute_laser_front.png")
    self.laserArmBack = love.graphics.newImage("assets/graphics/cosmonaute_laser_back.png")
    self.shield = love.graphics.newImage("assets/graphics/shield.png")

    self.missileArmFrontOffset = vec2(-3, -15)
    self.missileArmBackOffset = vec2(73, 15)
    self.laserArmFrontOffset = vec2(-2, -19)
    self.laserArmBackOffset = vec2(42, 19)
    self.missileLauncherFrontOffset = vec2(90, 0)
    self.missileLauncherBackOffset = vec2(-90, 0)

    -- Missiles cooldown
    self.lastSentMissileTime = - gameConfig.missiles.cooldown -- so we can shoot right away
    self.missileCoolDownTime = gameConfig.missiles.cooldown

    -- Upgrades
    self.newSatellite = nil
    self.newDrone = nil

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

    -- Compute missile-launcher position
    local missileLauncherPosition
    if math.abs(self.missileAngle) < halfPi then
        missileLauncherPosition = self.missileLauncherFrontOffset:rotateRad(-self.missileAngle)
    else
        missileLauncherPosition = self.missileLauncherBackOffset:rotateRad(-self.missileAngle - math.pi)
    end

    -- Send the missile
    self.space:addMissile({
        pos = missileLauncherPosition,
        angle = self.missileAngle,
        speed = gameConfig.missile.speed
    })
    SoundManager.missile()
end

function Class:fireLaser()
    self.closestAsteroid = self:findClosestAsteroid(self.laserAngle, gameConfig.laser.laserWidth)

    if (self.closestAsteroid == nil) then
        self:stopLaser()
        return
    end

    for _, laserSat in pairs(self.laserSats) do
        laserSat:fire(self.laserAngle, self.closestAsteroid)
    end
end

function Class:stopLaser()
    for _, laserSat in pairs(self.laserSats) do
        laserSat:stopFire(self.laserAngle, self.closestAsteroid)
    end
end

function Class:addLaserSat(laserSat)
    table.insert(self.laserSats, laserSat)
end

function Class:addDrone(drone)
    table.insert(self.drones, drone)
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    if self.mode == "upgrade" then
        return
    end

    for _, drone in pairs(self.drones) do
        drone:update(dt)
    end

    -- Check for drone collisions
    for _, drone in pairs(self.drones) do
        local nearestAsteroid
        local smallestDistance

        for i, asteroid in pairs(self.space.asteroids) do
            if not asteroid.exploded
                and drone:collideAsteroid(asteroid) then
                local distance = drone:distanceTo(asteroid)
                if not smallestDistance or distance < smallestDistance then
                    smallestDistance = distance
                    nearestAsteroid = asteroid
                end
            end
        end

        -- Hit asteroid
        if nearestAsteroid then
            drone:hit(nearestAsteroid)
        end
    end

    local numberLaserFiring = 0
    for _, laserSat in pairs(self.laserSats) do
        laserSat:update(dt)
        if (laserSat.isDoingDamage) then
            numberLaserFiring = numberLaserFiring + 1
        end
    end

    if (numberLaserFiring > 0) then
        if not (self.isLaserFiring) then
            SoundManager.laserStart()
            self.isLaserFiring = true
        end

        self.closestAsteroid:hit(numberLaserFiring)
    else
        if (self.isLaserFiring) then
            SoundManager.laserStop()
            self.isLaserFiring = false
        end
    end

    self.shieldRotation = self.shieldRotation + dt * .05

    self.life = math.min(self.life + gameConfig.station.shieldRegeneration * dt, 100)
end

-- Draw the game
function Class:draw()
    -- Reset color
    love.graphics.setColor(255, 255, 255)

    -- Draw platform
    love.graphics.draw(self.platform, -52, 0, 0, .35, .35)

    -- Draw laser arm
    if math.abs(self.laserAngle) < halfPi then
        local offset = self.laserArmFrontOffset:rotateRad(-self.laserAngle) + vec2(16, 0)
        love.graphics.draw(self.laserArmFront, offset.x, offset.y, -self.laserAngle, .35, .35)
    else
        local offset = self.laserArmBackOffset:rotateRad(-self.laserAngle) + vec2(16, 0)
        love.graphics.draw(self.laserArmBack, offset.x, offset.y, -self.laserAngle - math.pi, .35, .35)
    end

    -- Draw cosmonaut
    love.graphics.draw(self.body, -3, -26, 0, .35, .35)

    -- Draw missile arm
    if math.abs(self.missileAngle) < halfPi then
        local offset = self.missileArmFrontOffset:rotateRad(-self.missileAngle)
        love.graphics.draw(self.missileArmFront, offset.x, offset.y, -self.missileAngle, .35, .35)
    else
        local offset = self.missileArmBackOffset:rotateRad(-self.missileAngle)
        love.graphics.draw(self.missileArmBack, offset.x, offset.y, -self.missileAngle - math.pi, .35, .35)
    end

    -- Compute shield color
    local lifePercentage = (self.life / gameConfig.station.maxLife)
    local shieldColor = interpolateColorScheme(lifePercentage)

    love.graphics.setColor(shieldColor[1], shieldColor[2], shieldColor[3])

    -- Draw shield
    local rotationOffset = vec2(-90, -90):rotateRad(self.shieldRotation) + self.boundingCircle.center
    love.graphics.draw(self.shield, rotationOffset.x, rotationOffset.y, self.shieldRotation, .35, .35)

    for _, drone in pairs(self.drones) do
        drone:draw()
    end

    -- Draw laser sats
    for _, laserSat in pairs(self.laserSats) do
        laserSat:draw()
    end

    if self.debug then
        self.boundingCircle:draw()

        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('fill', self.radius * math.cos( -self.missileAngle), self.radius * math.sin( -self.missileAngle), 10, 32)
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle('fill', self.radius * math.cos( -self.laserAngle ), self.radius * math.sin( -self.laserAngle ), 10, 32)
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
    self.closestAsteroid = nil
    local minDist = -1
    local minDistchecker = - 1
    for _, asteroid in pairs( self.space.asteroids ) do
        minDistchecker = math.abs( asteroid:distanceWithLine( angle ))
        norm = math.sqrt(math.pow( asteroid.pos.x, 2 ) + math.pow( asteroid.pos.y, 2 ))
        if ((minDistchecker < minDist or minDist == -1) and minDistchecker < width and not asteroid.exploded and norm < gameConfig.laser.maxRange ) then
            minDist = minDistchecker
            self.closestAsteroid = asteroid
        end
    end

    return self.closestAsteroid
end

-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end

-- Set the cooldown time between 2 missiles
--
-- Parameters
--  cooldown: int
function Class:setMissileCooldown(cooldown)
    self.missileCoolDownTime = cooldown
end

function Class:asteroidKilled(size, distance)
    maxRange = gameConfig.station.scoreMaxRange
    self.score = self.score + math.ceil(gameConfig.asteroid.numberPoint * (distance / ( 2 * maxRange )) + 0.5)
    self.coins = self.coins + math.ceil(gameConfig.asteroid.numberPoint * (distance / ( 2 * maxRange )) + 0.5)
end

