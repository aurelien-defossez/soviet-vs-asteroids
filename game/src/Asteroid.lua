module("Asteroid", package.seeall)
local Class = Asteroid
Class.__index = Class

require("lib.math.circle")
require("SoundManager")
local sprites = {
    love.graphics.newImage("assets/graphics/asteroid_1.png"),
    love.graphics.newImage("assets/graphics/asteroid_2.png"),
    love.graphics.newImage("assets/graphics/asteroid_3.png")
}
local explosion = love.graphics.newImage("assets/graphics/explosion.png")
local baseRadius = gameConfig.asteroid.baseRadius

function Class.create( options )
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.space = options.space
    self.index = options.index
    self.exploded = false

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
    self.speed1d = options.speed1d or math.random() * 50 + 100

    self.speed = options.speed or vec2(
        self.speed1d * math.cos( self.dir ),
        self.speed1d * math.sin( self.dir )
    )

    if options.radius then
        self.radius = options.radius
    else
        local rand = math.random()

        -- 10% chance of big
        if rand < 0.10 then
            self.radius = 64

        -- 60% chance of medium
        elseif rand < 0.70 then
            self.radius = 32

        -- 30% chance of small
        else
            self.radius = 16
        end
    end

    -- life of the asteroid depends of its radius
    self.life = self.radius / baseRadius
    self.numberSatHit = 0

    self.color = options.color or { 255, 255, 255 }

    self.boundingCircle = circle(self.pos, self.radius)

    self.sprite = sprites[ math.floor( math.random() * 3 + 1 ) ]

    return self
end

function Class:explode()
    self.exploded = true
    dist = math.sqrt(self.pos.x * self.pos.x + self.pos.y * self.pos.y)
    game.station:asteroidKilled(1, dist)
    SoundManager.explosion()
end

function Class:hit()
    self.life = self.life - gameConfig.laser.baseDmg
    self.color = { 255, 128 + ( self.life * 128 ), 128 + ( self.life * 128 ) }
end

-- Update the asteroid
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)

    if self.life <= 0 then
        self.space:splitAsteroid( self )
        self:explode()
        self.space:removeAsteroid( self.index )
    end

    self.pos = self.pos + self.speed * dt
    self.boundingCircle = circle(self.pos, self.radius)
end

function Class:draw()
    love.graphics.setColor( unpack(self.color) )
    love.graphics.draw(
        self.sprite,
        self.pos.x, self.pos.y,
        0,
        self.radius / baseRadius, self.radius / baseRadius,
        baseRadius, baseRadius
    )
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
