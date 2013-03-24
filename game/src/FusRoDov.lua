module("FusRoDov", package.seeall)
local Class = FusRoDov
Class.__index = Class

require("lib.math.circle")

local wave = love.graphics.newImage("assets/graphics/shield.png")

function Class.create( options )
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.radius = 0
    self.elapsedTime = 0
    self.imageRadius = wave:getWidth()
    self.ended = false

    return self
end

function Class:destroy()
end

function Class:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.radius = 400 * self.elapsedTime ^ 3

    if self.radius > gameConfig.screen.width then
        self.ended = true
    end
end

function Class:draw()
    local scale = self.radius / self.imageRadius * 2
    love.graphics.draw(wave, -self.radius, -self.radius, 0, scale, scale)
end
