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
    self.scale = options.scale
    self.width = 444 * self.scale
    self.height = 66 * self.scale
    self.text = options.text
    self.callbackFn = options.callback

    self.background = love.graphics.newImage("assets/graphics/gui/btn_off.png")
    self.border = love.graphics.newImage("assets/graphics/gui/btn_on.png")

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
    colors.mode("replace")
    -- display button background
    love.graphics.draw(self.background, self.x, self.y, 0, self.scale)

    -- display button border
    if self.selected then
        love.graphics.draw(self.border, self.x, self.y, 0, self.scale)
    end

    colors.mode("modulate")

    -- display button text
    colors.white()
    love.graphics.printf(self.text, self.x, self.y + ((self.height - 48 * self.scale) / 2), self.width, "center")
end

function Class:contains(x, y)
    return self.rectangle:containsPoint(vec2(x, y))
end

function Class:callback()
    return self.callbackFn()
end

-----------------------------------------------------------------------------------------

return Class
