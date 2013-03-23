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
<<<<<<< HEAD
=======
local spriteSheet = love.graphics.newImage("assets/graphics/missile.png")
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de

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
<<<<<<< HEAD
    self.pos = options.pos
    self.angle = options.angle
    self.speed = options.speed
    self.radius = 10
=======
    self.angle = options.angle
    self.speed = options.speed
    self.pos = options.pos
    self.radius = 32
    self.sprite = Sprite.create{
        pos = self.pos,
        angle = self.angle,
        spriteSheet = spriteSheet,
        frameCount = 2,
        frameRate = 0.25
    }
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de

    ctId = ctId + 1

    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:collideAsteroid(asteroid)
    return self.boundingCircle:collideCircle(asteroid.boundingCircle)
end

function Class:explode()
    self.exploded = true
end

-- Update the missile
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.pos = self.pos + vec2(self.speed * cos(self.angle), self.speed * -sin(self.angle))
    self.boundingCircle = circle(self.pos, self.radius)
<<<<<<< HEAD
=======
    self.sprite:udpate(dt)
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
end

-- Draw the game
function Class:draw()
    if self.exploded then
<<<<<<< HEAD
        love.graphics.setColor(255, 42, 42)
    else
        love.graphics.setColor(42, 42, 255)
    end

    love.graphics.rectangle('fill', self.pos.x, self.pos.y, 12, 12)
=======
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end

    -- Position sprite
    self.sprite.pos = self.pos + vec2(-96, -32):rotateRad(-self.angle)
    self.sprite:draw()
    
    self.pos:draw()
    self.boundingCircle:draw()
>>>>>>> 169d5d6809febcb8e4363739e6d26b959da212de
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
