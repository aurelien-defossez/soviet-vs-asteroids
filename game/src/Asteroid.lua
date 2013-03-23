module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

function Class.create()
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Determine random position
    local x = Math.random() - 0.5
    local y = Math.random() - 0.5

    self.a = Math.atan2( x, y )

    self.x = gameConfig.asteroidBeltDistance * Math.cos( a )
    self.y = gameConfig.asteroidBeltDistance * Math.sin( a )

    self.speedX = -x * 10 + ( Math.random() - 0.5 ) * 2
    self.speedY = -y * 10 + ( Math.random() - 0.5 ) * 2

    self.radius = 10

    return self
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
end

function Class:draw()
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('fill', self.x, self.y, self.radius, 6)
end
