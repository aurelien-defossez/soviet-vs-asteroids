module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

require("lib.math.circle")

function Class.create( options )
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.space = options.space

    -- Determine random position
    local x = math.random() - 0.5
    local y = math.random() - 0.5
    local a = math.atan2( y, x )

    self.pos = options.pos or vec2(
    	gameConfig.asteroidBeltDistance * math.cos( a ),
    	gameConfig.asteroidBeltDistance * math.sin( a )
    )

    -- direction is toward the center +/- 18 degrees
    self.dir = options.dir or a + math.pi + ( ( math.random() - 0.5 ) * math.pi / 5 )

    self.life = gameConfig.asteroid.life
    self.numberSatHit = 0

    -- speed in 1 dimension is between 180 and 260
    self.speed1d = options.speed1d or math.random() * 50 + 100

    self.speed = options.speed or vec2(
        self.speed1d * math.cos( self.dir ),
        self.speed1d * math.sin( self.dir )
    )

    self.radius = options.radius or 10

    self.color = options.color or { 255, 0, 255 }

    self.boundingCircle = circle(self.pos, self.radius)

    self.splitted = options.splitted or 0

    return self
end

function Class:explode()
    self.exploded = true
    dist = math.sqrt(self.pos.x * self.pos.x + self.pos.y * self.pos.y)
    game.station:asteroidKilled(1, dist)
    

    -- darken color for debugging purpose
    self.color = {64, 0, 64}
end

function Class:hit()
    self.numberSatHit = self.numberSatHit + 1
end

-- Update the asteroid
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)

    self.life = self.life - math.pow(self.numberSatHit, gameConfig.laser.dpsExp);

    if self.life <= 0 then
    	print( self, "will explode" )
        self.space:explodeAsteroid( self )
    end

    self.numberSatHit = 0;
    self.pos = self.pos + self.speed * dt
    self.boundingCircle = circle(self.pos, self.radius)
end

function Class:draw()
    love.graphics.setColor( unpack( self.color ) )

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
