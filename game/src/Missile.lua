-----------------------------------------------------------------------------------------
--
-- Missile.lua
--
-- A free-hug missile going through space, waiting to mate with asteroids.
--
-----------------------------------------------------------------------------------------

module("Missile", package.seeall)
local Class = Missile
Class.__index = Class

local Sprite = require("lib.Sprite")

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local cos = math.cos
local sin = math.sin
local ctId = 0
local missile = love.graphics.newImage("assets/graphics/missile.png")
local explosion = love.graphics.newImage("assets/graphics/explosion2.png")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.id = ctId
    self.pos = options.pos
    self.angle = options.angle
    self.speed = options.speed
    self.exploded = false
    self.radius = 12
    self.color = {42, 42, 255}
    self.boundingCircle = circle(self.pos, self.radius)

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

    self.sprite = Sprite.create{
        pos = self.pos,
        angle = self.angle,
        spriteSheet = missile,
        frameCount = 2,
        frameRate = 0.1,
        scale = 0.35
    }

    ctId = ctId + 1

    return self
end

-- Destroy the station
function Class:destroy()
    self.sprite:destroy()
    self.sprite = nil
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:collideAsteroid(asteroid)
    return self.boundingCircle:collideCircle(asteroid.boundingCircle)
end

function Class:explode()
    self.exploded = true

    self.sprite = Sprite.create{
        pos = self.pos + vec2( -64, -64 ):rotateRad( -self.angle ),
        angle = self.angle,
        spriteSheet = explosion,
        frameCount = 10,
        frameRate = 0.01
    }

    self.timeSinceExplosion = 0
end

-- Update the missile
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    if not self.exploded then
        self.pos = self.pos + vec2(self.speed * cos(self.angle), self.speed * -sin(self.angle))
        self.boundingCircle = circle(self.pos, self.radius)
    else
        self.timeSinceExplosion = self.timeSinceExplosion + dt
    end

    self.sprite:update(dt)
end

-- Draw the game
function Class:draw()
    -- Reset color
    love.graphics.setColor(255, 255, 255)

    -- Position sprite
    if not self.exploded then
        self.sprite.pos = self.pos + vec2(-30, -10):rotateRad(-self.angle)
    end
    self.sprite:draw()

    if self.debug then
        self.boundingCircle:draw()
    end
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
