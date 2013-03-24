-----------------------------------------------------------------------------------------
--
-- Space.lua
--
-- In space no one can hear you scream.
--
-----------------------------------------------------------------------------------------

module("Space", package.seeall)
local Class = Space
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.SoundManager")
require("src.FusRoDov")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.station = options.station
    self.missiles = {}
    self.asteroids = {}
    self.dLastSpawn = 0
    self.background = love.graphics.newImage("assets/graphics/background.png")

    self.debug = gameConfig.debug.all or gameConfig.debug.shapes

    self.stars = love.graphics.newParticleSystem(
        love.graphics.newImage("assets/graphics/star.png"), 40
    )
    self.stars:setEmissionRate(2)
    self.stars:setSpread( 2 * math.pi )
    self.stars:setLifetime(-1)
    self.stars:setParticleLife(4)
    self.stars:setSizes(0,0,.1,.2,.3,.4)
    self.stars:setSpeed(100, 300)
    self.stars:start()
    self.fusRoDovInstance = nil

    return self
end

-- Destroy the station
function Class:destroy()
    for _, missile in pairs(self.missiles) do
        missile:destroy()
    end

    for _, asteroid in pairs(self.asteroids) do
        asteroid:destroy()
    end
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:canFusRoDov()
    return self.fusRoDovInstance == nil
end

function Class:fusRoDov()
    if self:canFusRoDov() then
        self.fusRoDovInstance = FusRoDov.create()
    end
end

function Class:addMissile( options )
    table.insert( self.missiles, Missile.create( options ) )
end

function Class:addAsteroid( options )

    if options == nil then
        options = {}
    end

    options.space = self

    local asteroid = Asteroid.create( options )
    table.insert( self.asteroids, asteroid )

    return asteroid
end

function Class:removeAsteroid( i )
    local asteroid = self.asteroids[i]

    asteroid.space = nil;
    table.remove( self.asteroids, i )
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    -- Do not update space when in upgrade mode
    if self.mode == "upgrade" then
        return
    end

    -- Update Fus Ro Dov!
    if self.fusRoDovInstance then
        if self.fusRoDovInstance.ended then
            self.fusRoDovInstance:destroy()
            self.fusRoDovInstance = nil
        else
            self.fusRoDovInstance:update(dt)
        end
    end

    -- Update missiles
    for i, missile in pairs(self.missiles) do
        missile:update(dt)

        if missile.exploded and missile.timeSinceExplosion > 0.2 then
            table.remove( self.missiles, i )
        end
    end

    -- Update asteroids
    for i, asteroid in pairs(self.asteroids) do
        asteroid:update(dt, i)
    end

    -- Check for Fus-Ro-Dov collisions to destroy asteroids and missiles
    if self.fusRoDovInstance then
        for i, asteroid in pairs(self.asteroids) do
            -- exclude exploded asteroid from collision detection
            if not asteroid.exploded and self.fusRoDovInstance.range:collideCircle(asteroid.boundingCircle) then
                asteroid:explode()
            end
        end

        for _, missile in pairs(self.missiles) do
            -- exclude exploded missiles from collision detection
            if not missile.exploded and self.fusRoDovInstance.range:collideCircle(missile.boundingCircle) then
                missile:explode()
            end
        end
    end

    -- Check for missile collisions
    for _, missile in pairs(self.missiles) do
        -- exclude exploded missiles from collision detection
        if not missile.exploded then
            for i, asteroid in pairs(self.asteroids) do
                -- exclude exploded asteroid from collision detection
                if not asteroid.exploded and missile:collideAsteroid(asteroid) then
                    missile:explode()
                    self:splitAsteroid( asteroid )
                    asteroid:explode()
                    --self:removeAsteroid( i )

                    -- Stop collision detection for this missile
                    break
                end
            end
        end
    end

    -- Check for station collisions
    for i, asteroid in pairs(self.asteroids) do
        if not asteroid.exploded and asteroid.boundingCircle:collideCircle(self.station.boundingCircle) then
            self:removeAsteroid( i )

            self.station.life = self.station.life - asteroid.radius
            if(self.station.life>0) then
                SoundManager.voice()
            end
            SoundManager.explosion()
            break
        end
    end

    -- spawn asteroids every once in a while
    self.dLastSpawn = self.dLastSpawn + dt
    if self.dLastSpawn > gameConfig.asteroid.spawnPeriod / game.difficulty then
        local baseSpeed = gameConfig.asteroid.speed * game.pairedDifficulty
        self:addAsteroid{
            speed1d = gameConfig.asteroid.speed * game.pairedDifficulty * (math.random() + .5)
        }
        self.dLastSpawn = self.dLastSpawn - gameConfig.asteroid.spawnPeriod / game.difficulty
    end

    -- kill missiles once they're offscreen
    for i, missile in pairs(self.missiles) do
        if missile:isOffscreen() then
            table.remove( self.missiles, i )
        end
    end

    -- kill asteroids once they're offscreen
    for i, asteroid in pairs(self.asteroids) do
        if asteroid:isOffscreen() then
            table.remove( self.asteroids, i )
        end
    end

    self.stars:update(dt)
end

-- Draw the game
function Class:draw()
    love.graphics.setColor({255, 255, 255})
    love.graphics.draw(
        self.background,
        0, 0,
        0,
        1, 1,
        960, 540
    )
    love.graphics.setColor({64, 64, 64, 128})
    love.graphics.draw(
        self.stars,
        0, 0
    )

    for _, asteroid in pairs(self.asteroids) do
        asteroid:draw()
    end

    for _, missile in pairs(self.missiles) do
        missile:draw()
    end

    if self.fusRoDovInstance then
        self.fusRoDovInstance:draw()
    end
end

function Class:splitAsteroid( asteroid )
    if type( asteroid ) == number then
        asteroid = self.asteroids[ asteroid ]
    end

    -- only split asteroids that have not reached minimal width
    if asteroid.radius <= gameConfig.asteroid.minRadius then
        return false
    end

    self:addAsteroid({
        pos = vec2( asteroid.pos.x, asteroid.pos.y ),
        dir = asteroid.dir + math.pi / 4,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2,
        color = { unpack(asteroid.color) }
    })

    self:addAsteroid({
        pos = vec2( asteroid.pos.x, asteroid.pos.y ),
        dir = asteroid.dir - math.pi / 4,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2,
        color = { unpack(asteroid.color) }
    })
end

-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end
