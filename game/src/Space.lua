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
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:addMissile(missile)
    table.insert(self.missiles, missile)
end

function Class:addAsteroid()
    table.insert( self.asteroids, Asteroid.create() )
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

    -- kill asteroids once they're offscreen
    for i, asteroid in pairs(self.asteroids) do
        if asteroid:isOffscreen(dt) then
            table.remove( self.asteroids, i )
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
