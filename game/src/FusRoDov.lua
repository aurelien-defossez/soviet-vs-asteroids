module("FusRoDov", package.seeall)
local Class = FusRoDov
Class.__index = Class

require("lib.math.circle")

local wave = love.graphics.newImage("assets/graphics/shield.png")

function Class.create( options )
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.imageRadius = wave:getWidth()
    self.range = circle(vec2(0, 0), 0)
    self.elapsedTime = 0
    self.ended = false

    return self
end

function Class:destroy()
end

function Class:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.range.radius = 50 * (1 + self.elapsedTime) ^ 4

    if self.range.radius > gameConfig.screen.width then
        self.ended = true
    end
end

function Class:draw()
    local scale = self.range.radius / self.imageRadius * 2
    love.graphics.draw(wave, -self.range.radius, -self.range.radius, 0, scale, scale)
end
