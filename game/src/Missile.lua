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
local spriteSheet = love.graphics.newImage("assets/graphics/missile.png")
local width = spriteSheet:getWidth()
local height = spriteSheet:getHeight()
local animation = {
    love.graphics.newQuad(0, 0, 128, 65, width, height),
    love.graphics.newQuad(128, 0, 128, 65, width, height)
}

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
    self.spriteBatch = love.graphics.newSpriteBatch(spriteSheet, 2)

    self.spriteBatch:clear()
    self.spriteBatch:addq(animation[2], 0, 0)

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

    love.graphics.draw(self.spriteBatch, spritePos.x, spritePos.y, -self.angle)
    
    self.pos:draw()
    self.boundingCircle:draw()
end

function Class:isOffscreen()
    return self.pos:length() > gameConfig.missiles.deleteDistance + 1
end
