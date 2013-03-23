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

    -- Draw scene
    love.graphics.setColor(0, 0, 255)
    love.graphics.circle('line', self.x, self.y, self.radius, 32)

end
