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
    self:setAngle(options.angle)

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

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
        love.graphics.setColor(255, 255, 0)
        love.graphics.line(self.pos.x, self.pos.y, self.targetAsteroid.pos.x, self.targetAsteroid.pos.y)
    end

    self.pos:draw()

    love.graphics.setColor(255, 255, 0)
    love.graphics.circle('line', self.pos.x, self.pos.y, self.range.radius, 32)

    self.targetAsteroid = nil
end
