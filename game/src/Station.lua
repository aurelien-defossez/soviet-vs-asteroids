-----------------------------------------------------------------------------------------
--
-- Station.lua
--
-- The station class.
--
-----------------------------------------------------------------------------------------
module("Station", package.seeall)
local Class = Station
Class.__index = Class
local sin = math.sin
local cos = math.cos



-- Create the station
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
    self.radius = 100

    self.joy1Angle = 0
    self.joy2Angle = 0

    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the station
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)


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
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('line', self.x, self.y, self.radius, 32)
        
    -- Reset camera transform before hud drawing
    love.graphics.pop()

    -- Draw HUD
    --love.graphics.setColor(255, 0, 255)
    --love.graphics.print(self.axis1, 0, 0)
end
