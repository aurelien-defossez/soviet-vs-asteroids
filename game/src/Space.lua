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
    self.missiles[missile.id] = missile
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

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    local somethingExploded

    if self.mode == "upgrade" then
        return
    end

    for _, missile in pairs(self.missiles) do
        missile:update(dt)
    end

    for _, asteroid in pairs(self.asteroids) do
        asteroid:update(dt)
    end

    -- Check for collisions
    for _, missile in pairs(self.missiles) do
        -- exclude exploded missiles from collision detection
        if not ( missile.exploded == true ) then
            for i, asteroid in pairs(self.asteroids) do
                -- exclude exploded asteroid from collision detection
                if not ( asteroid.exploded == true ) and missile:collideAsteroid(asteroid) then
                    missile:explode()
                    self:explodeAsteroid( asteroid )

                    -- Stop collision detection for this missile
                    break
                end
            end
        end
    end

    -- spawn asteroids every once in a while
    self.dLastSpawn = self.dLastSpawn + dt
    if self.dLastSpawn > gameConfig.asteroidSpawnPeriod then
        self:addAsteroid()
        self.dLastSpawn = self.dLastSpawn - gameConfig.asteroidSpawnPeriod
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

    if somethingExploded then
        die()
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

function Class:explodeAsteroid( asteroid )

    if type( asteroid ) == number then
        asteroid = self.asteroids[ asteroid ]
    end

    -- only split asteroids that have not been splitted yet
    if asteroid.splitted == 0 then
        self:splitAsteroid( asteroid )
    end

    asteroid:explode()

    return self
end

function Class:splitAsteroid( asteroid )
    if type( asteroid ) == number then
        asteroid = self.asteroids[ asteroid ]
    end

    --print( asteroid, "will split" )

    self:addAsteroid({
        pos = vec2( asteroid.pos.x, asteroid.pos.y ),
        dir = asteroid.dir + math.pi / 16,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2,
        color = {255,255,255},
        splitted = asteroid.splitted + 1
    })

    self:addAsteroid({
        pos = vec2( asteroid.pos.x, asteroid.pos.y ),
        dir = asteroid.dir - math.pi / 16,
        speed1d = asteroid.speed1d,
        radius = asteroid.radius / 2,
        color = {255,255,255},
        splitted = asteroid.splitted + 1
    })
end

-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" mode
function Class:setMode(mode)
    self.mode = mode
end
