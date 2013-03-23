-----------------------------------------------------------------------------------------
--
-- Button.lua
--
-- The main Button class.
--
-----------------------------------------------------------------------------------------
module("Button", package.seeall)
local Class = Button
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the Button
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.selected = nil

    return self
end

-- Destroy the Button
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the Button
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
end

-- Draw the Button
function Class:draw()
    function grey()
        love.graphics.setColor(100, 100, 100, 255)
    end

    function darkgrey()
        love.graphics.setColor(200, 200, 200, 255)
    end

    function black()
        love.graphics.setColor(0, 0, 0, 255)
    end

    function white()
        love.graphics.setColor(255, 255, 255, 255)
    end

    function green()
        love.graphics.setColor(0, 255, 0, 255)
    end

    grey()
    love.graphics.rectangle("fill", -80, -240, 200, 100)
    darkgrey()
    love.graphics.rectangle("line", -80, -240, 200, 100)
    white()
    love.graphics.printf("Quit", -80, -200, 200, "center")
end

-----------------------------------------------------------------------------------------

return Class
