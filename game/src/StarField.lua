-----------------------------------------------------------------------------------------
--
-- StarField.lua
--
-- Beautiful circles.
--
-----------------------------------------------------------------------------------------

module("StarField", package.seeall)
local Class = StarField
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.leds = {}
    self.center = options.boundaries.min + (options.boundaries.max - options.boundaries.min) / 2

    self.stars = love.graphics.newParticleSystem(
        love.graphics.newImage("assets/graphics/star.png"), 40
    )
    self.stars:setEmissionRate(3)
    self.stars:setSpread( 2 * math.pi )
    self.stars:setLifetime(-1)
    self.stars:setParticleLife(7)
    self.stars:setSizes(0,0,.1,.3,.45,.6)
    self.stars:setSpeed(100, 300)
    self.stars:start()

    -- spawn background stars
    for i = 1, options.starCount or 30 do
        self.leds[i] = Star.create{
            pos = vec2(
                math.random(options.boundaries.min.x, options.boundaries.max.x),
                math.random(options.boundaries.min.y, options.boundaries.max.y)
            )
        }
    end

    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:update(dt)
    for _, led in pairs(self.leds) do
        led:update(dt)
    end

    self.stars:update(dt)
end

function Class:draw()
    love.graphics.setColor({64, 64, 64, 128})
    love.graphics.draw(
        self.stars,
        self.center.x,
        self.center.y
    )

    for _, led in pairs(self.leds) do
        led:draw(dt)
    end
end
