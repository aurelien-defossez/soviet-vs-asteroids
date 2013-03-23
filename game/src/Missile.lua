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
-- Imports
-----------------------------------------------------------------------------------------

local cos = math.cos
local sin = math.sin

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.x = options.x
    self.y = options.y
    self.angle = options.angle
    self.speed = options.speed

    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the missile
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.x = self.x + self.speed * cos(self.angle)
    self.y = self.y + self.speed * -sin(self.angle)
end

-- Draw the game
function Class:draw()
    love.graphics.setColor(42, 42, 255)
    love.graphics.rectangle('fill', self.x, self.y, 12, 12)
end

function Class:isOffscreen()
    return math.sqrt( self.x * self.x + self.y * self.y ) > gameConfig.missiles.deleteDistance + 1
end
