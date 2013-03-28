module("Star", package.seeall)
local Class = Star
Class.__index = Class

function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.duration = math.random()

    self.pos = options.pos
    self.radius = math.random() * 2 + 2

    self.dtFactor = 3 + math.random() * 3

    return self
end

function Class:update(dt)
    self.duration = self.duration + dt * self.dtFactor
    self.opacity = 32 + 111 * ( math.sin( self.duration ) + 1 )
end

function Class:draw()
    love.graphics.setColor(255, 255, 255, self.opacity )

    love.graphics.circle( 'fill', self.pos.x, self.pos.y, self.radius, 9)
end
