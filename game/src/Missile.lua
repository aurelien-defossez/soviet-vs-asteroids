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

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local cos = math.cos
local sin = math.sin
local ctId = 0

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
    self.radius = 10

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
end

-- Draw the game
function Class:draw()
    if self.exploded then
        love.graphics.setColor(255, 42, 42)
    else
        love.graphics.setColor(42, 42, 255)
    end

    love.graphics.rectangle('fill', self.pos.x, self.pos.y, 12, 12)
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
