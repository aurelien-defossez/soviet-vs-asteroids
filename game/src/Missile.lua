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
    self.angle = options.angle
    self.speed = options.speed
    self.pos = options.pos
    self.radius = 32
    self.image = love.graphics.newImage("assets/graphics/missile_1.png")

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
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end

    -- Position sprite
    local spritePos = self.pos + vec2(-96, -32):rotateRad(-self.angle)

    love.graphics.draw(self.image, spritePos.x, spritePos.y, -self.angle)
    
    self.pos:draw()
    self.boundingCircle:draw()
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
