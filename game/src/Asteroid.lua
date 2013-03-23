module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

function Class.create()
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Determine random position
    local x = math.random() - 0.5
    local y = math.random() - 0.5

    self.a = math.atan2( y, x )

    self.x = gameConfig.asteroidBeltDistance * math.cos( self.a )
    self.y = gameConfig.asteroidBeltDistance * math.sin( self.a )

    self.speedX = ( -x * 10 + ( math.random() - 0.5 ) * 2 ) * 1E2
    self.speedY = ( -y * 10 + ( math.random() - 0.5 ) * 2 ) * 1E2

    self.colideX = 0
    self.colideY = 0

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
    love.graphics.setColor(255, 0, 255)
    love.graphics.circle('fill', self.x, self.y, self.radius, 6)

end

function Class:isOffscreen()
	return math.sqrt( self.x * self.x + self.y * self.y ) > gameConfig.asteroidBeltDistance + 1
end

function Class:distanceWithLine(shootAngle)
    asteroidAngle = - math.atan2(self.y, self.x)
    collideAngle = shootAngle - asteroidAngle
    norm = math.sqrt(self.x * self.x + self.y * self.y)

    return norm * math.sin(collideAngle)
end
