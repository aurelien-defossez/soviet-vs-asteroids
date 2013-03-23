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

require("lib.math.vec2")
require("lib.math.aabb")
require("src.gui.Colors")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the Button
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.x = options.x
    self.y = options.y
    self.width = options.width
    self.height = options.height
    self.text = options.text
    self.callbackFn = options.callback

    self.rectangle = aabb(vec2(self.x, self.y), vec2(self.width + self.x, self.height + self.y))

    self.selected = false

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
    -- display button background
    if self.selected then
        colors.white()
    else
        colors.grey()
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- display button border
    if self.selected then
        colors.grey()
    else
        colors.darkgrey()
    end
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- display button text
    if self.selected then
        colors.black()
    else
        colors.white()
    end
    love.graphics.printf(self.text, self.x, self.y - 12 + self.height / 2, self.width, "center")
end

function Class:contains(x, y)
    return self.rectangle:containsPoint(vec2(x, y))
end

function Class:callback()
    return self.callbackFn()
end

-----------------------------------------------------------------------------------------

return Class
