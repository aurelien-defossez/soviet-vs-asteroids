module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

require("lib.math.circle")

function Class.create()
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Determine random position
    local x = math.random() - 0.5
    local y = math.random() - 0.5
    local deviationX, deviationY

    self.a = math.atan2( y, x )

    self.pos = vec2(
    	gameConfig.asteroidBeltDistance * math.cos( self.a ),
    	gameConfig.asteroidBeltDistance * math.sin( self.a )
    )

    -- direction is toward the center +/- 9 degrees
    local dir = self.a + math.pi + ( ( math.random() - 0.5 ) * math.pi / 10 )

    -- speed in 1 dimension is between 450 and 500
    local speed = math.random() * 50 + 450

    self.speed = vec2(
        speed * math.cos( dir ),
        speed * math.sin( dir )
    )

    self.colideX = 0
    self.colideY = 0

    self.radius = 10

    return self
end

function Class:explode()
    self.exploded = true
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.pos = self.pos + self.speed * dt
    self.boundingCircle = circle(self.pos, self.radius)
end

function Class:draw()
    if self.exploded then
        love.graphics.setColor(255, 0, 128)
    else
        love.graphics.setColor(255, 0, 255)
    end

    love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius, 6)

end

function Class:isOffscreen()
	return self.pos:length() > gameConfig.asteroidBeltDistance + 1
end

function Class:distanceWithLine(shootAngle)
    asteroidAngle = - math.atan2(self.pos.y, self.pos.x)
    collideAngle = shootAngle - asteroidAngle
    norm = math.sqrt(self.pos.x * self.pos.x + self.pos.y * self.pos.y)

    return norm * math.sin(collideAngle)
end
