-----------------------------------------------------------------------------------------
--
-- Sprite.lua
--
-- A sprite wrapper
--
-----------------------------------------------------------------------------------------

module("Sprite", package.seeall)
local Class = Sprite
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the game
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.frameCount = options.frameCount
    self.pos = options.pos
    self.angle = options.angle
    self.frameRate = options.frameRate
    self.time = 0
    self.currentFrame = options.firstFrame or 1
    self.scale = options.scale

    local width = options.spriteSheet:getWidth()
    local height = options.spriteSheet:getHeight()
    local spriteWidth = width / self.frameCount

    self.frames = {}
    for i = 1, self.frameCount do
        self.frames[i] = love.graphics.newQuad((i - 1) * spriteWidth, 0, spriteWidth, height, width, height)
    end

    self.spriteBatch = love.graphics.newSpriteBatch(options.spriteSheet, self.frameCount)
    self.spriteBatch:clear()
    self.spriteBatch:addq(self.frames[self.currentFrame], 0, 0)

    return self
end

-- Destroy the game
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Draw the game
function Class:udpate(dt)
    self.time = self.time + dt

    if self.time > self.frameRate then
        self.time = self.time - self.frameRate
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.frameCount then
            self.currentFrame = 1
        end

        self.spriteBatch:clear()
        self.spriteBatch:addq(self.frames[self.currentFrame], 0, 0)
    end
end

-- Draw the game
function Class:draw()
    love.graphics.draw(self.spriteBatch, self.pos.x, self.pos.y, -self.angle, self.scale, self.scale)
end

-----------------------------------------------------------------------------------------

return Class
