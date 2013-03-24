-----------------------------------------------------------------------------------------
--
-- Drone.lua
--
-- A big fly shooting small lasers
--
-----------------------------------------------------------------------------------------

module("Drone", package.seeall)
local Class = Drone
Class.__index = Class

local Sprite = require("lib.Sprite")

local hoboSat = love.graphics.newImage("assets/graphics/hobosat.png")
local laserSpriteSheet = love.graphics.newImage("assets/graphics/laser_boule.png")
local laserBeamSpriteSheet = love.graphics.newImage("assets/graphics/laser_jet.png")




-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.range = circle(vec2(0, 0), gameConfig.drone.range)
    self.displayAngle = 0
    self:setAngle(options.angle)
    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

    self.sprite = Sprite.create{
        pos = self.pos,
        angle = self.angle,
        spriteSheet = hoboSat,
        frameCount = 1,
        frameRate = 10,
        scale = 0.3
    }

    self.laserOriginSprite = Sprite.create{
        pos = self.pos,
        angle = self.displayAngle,
        spriteSheet = laserSpriteSheet,
        frameCount = 2,
        frameRate = 0.1,
        scale = 0.125
    }

    self.laserImpactSprite = Sprite.create{
        pos = self.pos,
        angle = self.displayAngle,
        spriteSheet = laserSpriteSheet,
        frameCount = 2,
        frameRate = 0.1,
        scale = 0.125
    }

    self.laserBeamSprite = Sprite.create{
        pos = self.pos,
        angle = self.displayAngle,
        spriteSheet = laserBeamSpriteSheet,
        frameCount = 2,
        frameRate = 0.1,
        scale = 0.125
    }

    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:setAngle(angle)
    self.angle = angle
    self.displayAngle = angle

    self.pos = gameConfig.station.shieldOffset
        + vec2(math.cos(self.angle), math.sin(-self.angle))
        * gameConfig.station.radius * gameConfig.drone.offOrbitRatio

    self.range.center = self.pos
end

function Class:collideAsteroid(asteroid)
    return self.range:collideCircle(asteroid.boundingCircle)
end

function Class:distanceTo(asteroid)
    return self.range.center:distance(asteroid.boundingCircle.center)
end

function Class:hit(asteroid)
    asteroid:hit(1, gameConfig.drone.damageModifier)
    self.targetAsteroid = asteroid
end

-- Update the missile
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self:setAngle(self.angle + dt * gameConfig.drone.speed)
end

-- Draw the game
function Class:draw()
    if self.targetAsteroid then

        love.graphics.setColor(0,60,255)

        norm = math.sqrt(math.pow( self.targetAsteroid.pos.x - self.pos.x, 2 ) + math.pow( self.targetAsteroid.pos.y - self.pos.y, 2 ))
        self.laserBeamSprite.scaleX = (norm - self.targetAsteroid.radius * 0.7 - 32) / 256
        self.laserBeamSprite.angle = self.displayAngle
        self.laserBeamSprite.pos = self.pos + vec2( 16, -8):rotateRad(-self.displayAngle)
        self.laserBeamSprite:draw()

        self.laserOriginSprite.angle = self.displayAngle
        self.laserOriginSprite.pos = self.pos + vec2( 16, -8):rotateRad(-self.displayAngle)
        self.laserOriginSprite:draw()

        self.laserImpactSprite.angle = self.displayAngle
        self.laserImpactSprite.pos = self.targetAsteroid.pos + vec2( -8, -8):rotateRad(-self.displayAngle)
        self.laserImpactSprite.pos = self.laserImpactSprite.pos + vec2( self.targetAsteroid.radius * 0.7, self.targetAsteroid.radius * 0.7 ):rotateRad(-self.displayAngle + 0.75* math.pi)
        self.laserImpactSprite:draw()
       -- love.graphics.setColor(255, 255, 0)
       -- love.graphics.line(self.pos.x, self.pos.y, self.targetAsteroid.pos.x, self.targetAsteroid.pos.y)
    end

    love.graphics.setColor(255, 255, 255)
    self.sprite.angle = self.displayAngle
    self.sprite.pos = self.pos + vec2(-18, -18):rotateRad(-self.displayAngle)
    self.sprite:draw()

    --self.pos:draw()

    --love.graphics.setColor(255, 255, 0)
    --love.graphics.circle('line', self.pos.x, self.pos.y, self.range.radius, 32)

    self.targetAsteroid = nil
end
