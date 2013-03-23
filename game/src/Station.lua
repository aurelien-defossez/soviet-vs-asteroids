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

    self.radius = 100
    self.laserSats = {}
    self.missileArmLength = 100
    self.laserStationOrbit = 100
    self.missileAngle = 0
    self.laserAngle = 0
    self.laserAlreadyFiring = false
    self.score = 0
    self.coins = 0
    self.life = gameConfig.station.maxLife
    self.shieldRotation = 0
    self.boundingCircle = circle(vec2(0, 0), self.radius)

    self.platform = love.graphics.newImage("assets/graphics/cosmonaute_plateforme.png")
    self.body = love.graphics.newImage("assets/graphics/cosmonaute_corps.png")
    self.missileArmFront = love.graphics.newImage("assets/graphics/cosmonaute_missile_front.png")
    self.missileArmBack = love.graphics.newImage("assets/graphics/cosmonaute_missile_back.png")
    self.laserArmFront = love.graphics.newImage("assets/graphics/cosmonaute_laser_front.png")
    self.laserArmBack = love.graphics.newImage("assets/graphics/cosmonaute_laser_back.png")
    self.shield = love.graphics.newImage("assets/graphics/shield.png")

    -- Missiles cooldown
    self.lastSentMissileTime = - gameConfig.missiles.cooldown -- so we can shoot right away
    self.missileCoolDownTime = gameConfig.missiles.cooldown

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

    self.debugText = ""


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
    if self.mode == "upgrade" then
        return
    end

    local numberLaserFiring = 0
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
        local offset = vec2(-2, -19):rotateRad(-self.laserAngle) + vec2(16, 0)
        love.graphics.draw(self.laserArmFront, offset.x, offset.y, -self.laserAngle, .35, .35)
    else
        local offset = vec2(42, 19):rotateRad(-self.laserAngle) + vec2(16, 0)
        love.graphics.draw(self.laserArmBack, offset.x, offset.y, -self.laserAngle - math.pi, .35, .35)
    end

    -- Draw cosmonaut
    love.graphics.draw(self.body, -3, -26, 0, .35, .35)

    -- Draw missile arm
    if math.abs(self.missileAngle) < halfPi then
        local offset = vec2(-3, -15):rotateRad(-self.missileAngle)
        love.graphics.draw(self.missileArmFront, offset.x, offset.y, -self.missileAngle, .35, .35)
    else
        local offset = vec2(73, 15):rotateRad(-self.missileAngle)
        love.graphics.draw(self.missileArmBack, offset.x, offset.y, -self.missileAngle - math.pi, .35, .35)
    end

    -- Compute shield color
    local lifePercentage = (self.life / gameConfig.station.maxLife)
    local shieldColor = interpolateColorScheme(lifePercentage)

    love.graphics.setColor(shieldColor[1], shieldColor[2], shieldColor[3])

    -- Draw shield
    local shieldOffset = vec2(-102, -102):rotateRad(self.shieldRotation)
    love.graphics.draw(self.shield, shieldOffset.x, shieldOffset.y, self.shieldRotation, .4, .4)

    -- Draw laser sats
    for _, laserSat in pairs(self.laserSats) do
        laserSat:draw()
    end

    if not self.debug then
        return
    end

    -- Draw scene
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('line', 0, 0, self.radius, 32)

    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', self.radius * math.cos( -self.missileAngle), self.radius * math.sin( -self.missileAngle), 10, 32)
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle('fill', self.radius * math.cos( -self.laserAngle ), self.radius * math.sin( -self.laserAngle ), 10, 32)
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
    for _, asteroid in pairs( self.space.asteroids ) do
        minDistchecker = math.abs( asteroid:distanceWithLine( angle ))
        norm = math.sqrt(math.pow( asteroid.pos.x, 2 ) + math.pow( asteroid.pos.y, 2 ))
        if ((minDistchecker < minDist or minDist == -1)  and minDistchecker < width and not asteroid.exploded and norm < gameConfig.laser.maxRange ) then
            minDist = minDistchecker
            closestAsteroid = asteroid
        end
    end

    return closestAsteroid
end


-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end

function Class:asteroidKilled(size, distance)
    maxRange = gameConfig.laser.maxRange
    self.score = self.score + math.ceil(gameConfig.asteroid.numberPoint * (distance / ( 2 * maxRange )) + 0.5)
    self.coins = self.coins + math.ceil(gameConfig.asteroid.numberPoint * (distance / ( 2 * maxRange )) + 0.5)
end

