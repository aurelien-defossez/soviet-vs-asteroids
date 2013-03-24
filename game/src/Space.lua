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

    for i, missile in pairs(self.missiles) do
        missile:update(dt)

        if missile.exploded and missile.timeSinceExplosion > 0.2 then
            table.remove( self.missiles, i )
        end
    end

    for i, asteroid in pairs(self.asteroids) do
        asteroid:update(dt, i)
    end

    -- Check for collisions
    for _, missile in pairs(self.missiles) do
        -- exclude exploded missiles from collision detection
        if not missile.exploded then
            for i, asteroid in pairs(self.asteroids) do
                -- exclude exploded asteroid from collision detection
                if not asteroid.exploded and missile:collideAsteroid(asteroid) then
                    missile:explode()
                    self:splitAsteroid( asteroid )
                    asteroid:explode()
                    self:removeAsteroid( i )

                    -- Stop collision detection for this missile
                    break
                end
            end
        end
    end

    for i, asteroid in pairs(self.asteroids) do
        -- exclude exploded asteroid from collision detection
        if not asteroid.exploded and asteroid.boundingCircle:collideCircle(self.station.boundingCircle) then
            self:removeAsteroid( i )

            self.station.life = self.station.life - asteroid.radius
            SoundManager.explosion()
            SoundManager.voice()

            break

        end
    end

    -- spawn asteroids every once in a while
    self.dLastSpawn = self.dLastSpawn + dt
    if self.dLastSpawn > gameConfig.asteroid.spawnPeriod then
        self:addAsteroid()
        self.dLastSpawn = self.dLastSpawn - gameConfig.asteroid.spawnPeriod
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

    for _, asteroid in pairs(self.asteroids) do
        asteroid:draw()
    end

    for _, missile in pairs(self.missiles) do
        missile:draw()
    end
end

function Class:splitAsteroid( asteroid )
    if type( asteroid ) == number then
        asteroid = self.asteroids[ asteroid ]
    end

    -- only split asteroids that have not reached minimal width
    if asteroid.radius <= 16 then
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
