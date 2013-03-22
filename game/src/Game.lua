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

local joystick1Position = 0;
local joystick2Position = 0;

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("lib.math.vec2")
require("lib.math.aabb")
require("src.Config")
require("src.Station")

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

    self.station = Station.create();

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
    self.station:update(dt)

    --love.joystick.open(1)
    local axisDir1, axisDir2, axisDir3, axisDir4, axisDir5  = love.joystick.getAxes( 1 )
    -- Joystick
    -- 1 X et 2 Y, left
    -- 3  L2, R2
    -- 4 Y et 5 X
    self.x = self.x + dt * 10000 * axisDir2 * 100
   -- self.y = self.y + dt * 10000 * axisDir7 * 100
    love.graphics.setColor(255, 0, 255)
    love.graphics.print("Hello world", 200, 100)

    

end

-- Draw the game
function Class:draw()
    self.station:draw()

end

-----------------------------------------------------------------------------------------

return Class
