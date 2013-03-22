-----------------------------------------------------------------------------------------
--
-- Game.lua
--
-- The main game class.
--
-----------------------------------------------------------------------------------------

module("Game", package.seeall)
local Class = Game
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("lib.math.vec2")
require("lib.math.aabb")
require("src.Config")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the game
function Class.create(options)
	-- Create object
	self = {}
	setmetatable(self, Class)

    -- Set virtual viewport
	self.virtualScreenHeight = gameConfig.camera.minVirtualHeight
	self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
	self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
	self.camera = vec2(0, 0)
	self.zoom = 1.0

	-- Set font
	love.graphics.setFont(love.graphics.newFont(40))

	-- Create debug shape
	self.x = 0
	self.y = 0
	self.radius = 32

	return self
end

-- Destroy the game
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the game
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
	self.x = self.x + dt * 10000
	self.y = self.y + dt * 10000
end

-- Draw the game
function Class:draw()
	love.graphics.push()
	
    -- Apply virtual resolution before rendering anything
    love.graphics.scale(self.virtualScaleFactor, self.virtualScaleFactor)
	
	-- Apply camera zoom
	love.graphics.scale(self.zoom, self.zoom)
	
    -- Move to camera position
    love.graphics.translate(
		(self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x,
		(self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y
   	)
	
    -- Draw background
	local screenExtent = vec2(self.virtualScreenHeight * self.screenRatio, self.virtualScreenHeight)
	local cameraBounds = aabb(self.camera - screenExtent, self.camera + screenExtent)

	-- Draw scene
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle('fill', self.x, self.y, self.radius, 32)
		
	-- Reset camera transform before hud drawing
	love.graphics.pop()

	-- Draw HUD
	love.graphics.setColor(255, 0, 0)
	love.graphics.print("Hello world", 400, 300)
end

-----------------------------------------------------------------------------------------

return Class
