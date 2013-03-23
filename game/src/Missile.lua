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
local spriteSheet = love.graphics.newImage("assets/graphics/missile.png")


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
    self.radius = 32
    self.color = {42, 42, 255}
    self.boundingCircle = circle(self.pos, self.radius)

    self.sprite = Sprite.create{
        pos = self.pos,
        angle = self.angle,
        spriteSheet = spriteSheet,
        frameCount = 2,
        frameRate = 0.1
    }

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
    self.sprite:udpate(dt)

end

-- Draw the game
function Class:draw()
    love.graphics.setColor(255 ,255 ,255 )
    -- Position sprite
    self.sprite.pos = self.pos + vec2(-96, -32):rotateRad(-self.angle)
    self.sprite:draw()

    self.pos:draw()
    self.boundingCircle:draw()
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
