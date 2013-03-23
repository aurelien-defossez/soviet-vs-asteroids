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

function Class:addMissile(missile)
    table.insert(self.missiles, missile)
end

function Class:addAsteroid( options )
    table.insert( self.asteroids, Asteroid.create( options ) )
end

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    for _, missile in pairs(self.missiles) do
        missile:update(dt)
    end

    for _, asteroid in pairs(self.asteroids) do
        asteroid:update(dt)
    end

    -- spawn asteroids every once in a while
    self.dLastSpawn = self.dLastSpawn + dt
    if self.dLastSpawn > gameConfig.asteroidSpawnEvery then
        self:addAsteroid()
        self.dLastSpawn = 0
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

        -- and split them randomly for debug purpose
        if math.random() > 0.995 then
            self:splitAsteroid( i )
        end
    end
end

-- Draw the game
function Class:draw()
    for _, missile in pairs(self.missiles) do
        missile:draw()
    end

    for _, asteroid in pairs(self.asteroids) do
        asteroid:draw()
    end
end

function Class:splitAsteroid( i )
    local asteroid = self.asteroids[i]

    self:addAsteroid({
        pos = asteroid.pos,
        dir = asteroid.dir + math.pi / 4,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2
    })

    self:addAsteroid({
        pos = asteroid.pos,
        dir = asteroid.dir - math.pi / 4,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2
    })

    table.remove( self.asteroids, i )
end