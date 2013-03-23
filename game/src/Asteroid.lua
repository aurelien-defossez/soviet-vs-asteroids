module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

function Class.create( options )
    -- Create object
    self = {}
    setmetatable(self, Class)

    if options == nil then
        options = {}
    end

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

    -- speed in 1 dimension is between 180 and 260
    self.speed1d = options.speed1d or math.random() * 80 + 180

    self.speed = options.speed or vec2(
        self.speed1d * math.cos( self.dir ),
        self.speed1d * math.sin( self.dir )
    )

    self.radius = options.radius or 10

    self.color = options.color or { 255, 0, 255 }

    return self
end

-- Update the asteroid
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.pos = self.pos + self.speed * dt
end

function Class:draw()
    love.graphics.setColor( unpack( self.color ) )
    love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius, 6)
end

function Class:isOffscreen()
	return math.sqrt( self.pos.x * self.pos.x + self.pos.y * self.pos.y ) > gameConfig.asteroidBeltDistance + 1
end