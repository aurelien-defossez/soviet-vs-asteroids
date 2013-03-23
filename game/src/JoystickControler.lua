-----------------------------------------------------------------------------------------
--
-- Station.lua
--
-- The joystickControler class.
--
-----------------------------------------------------------------------------------------
module("JoystickControler", package.seeall)
local Class = JoystickControler
Class.__index = Class
local sin = math.sin
local cos = math.cos

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("src.Config")
require("src.Station")

-- Create the joystickControler
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.station = options.station
    self.debugShape = true -- Config.debugShape

    -- Set virtual viewport
    self.virtualScreenHeight = gameConfig.camera.minVirtualHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    self.camera = vec2(0, 0)
    self.zoom = 1.0

    -- Set font
    love.graphics.setFont(love.graphics.newFont(20))

    -- Create debug shape
    self.x = 0
    self.y = 0

    self.axis1 = 0;
    self.axis2 = 0;
    self.axis4 = 0;
    self.axis5 = 0;

    self.joy1Angle = 0

    return self
end

-- Destroy the joystickControler
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the joystickControler
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)


    if (not love.joystick.isOpen(1)) then
        return
    end
    -- Joystick
    -- 1 X et 2 Y, left
    -- 3  L2, R2
    -- 4 Y et 5 X
    self.axis1, self.axis2, self.axis3, self.axis4, self.axis5  = love.joystick.getAxes( 1 )

    if (not self.axis5) then
        self.axis5 = self.axis4
        self.axis4 = self.axis3
    end

    norm =  math.sqrt( self.axis1 * self.axis1 + self.axis2 * self.axis2 )
    self.joy1Angle = math.atan2(self.axis2, self.axis1)
    self.joy2Angle = math.atan2(self.axis4, self.axis5)

end

-- Draw the game
function Class:draw()
    if (not love.joystick.isOpen(1)) then
        return
    end
    
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
    love.graphics.print(self.joy1Angle, 0, 0)
    love.graphics.setColor(0, 255, 0)
    love.graphics.print(self.joy2Angle, 0, 30)
        
    -- Reset camera transform before hud drawing
    love.graphics.pop()

    -- Draw HUD
    --love.graphics.setColor(255, 0, 255)
    --love.graphics.print(self.axis1, 0, 0)
end