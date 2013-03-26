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
    self.width = options.width * self.scale
    self.height = options.height * self.scale
    self.text = options.text
    self.callbackFn = options.callback
    self.valign = options.valign or "middle"
    self.color = options.color or "white"
    self.navigation = options.navigation

    self.background = love.graphics.newImage("assets/graphics/gui/" .. options.background .. ".png")
    self.border = love.graphics.newImage("assets/graphics/gui/" .. options.border .. ".png")

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
    if self.valign == "middle" then
        y = self.y + ((self.height - 48 * self.scale) / 2)
    elseif self.valign == "down" then
        y = self.y + self.height - (68 * self.scale)
    end

    if self.color == "red" then
        colors.red()
    elseif self.color == "white" then
        colors.white()
    end
    love.graphics.printf(self.text, self.x, y, self.width, "center")
end

function Class:contains(x, y)
    return self.rectangle:containsPoint(vec2(x, y))
end

function Class:callback()
    return self.callbackFn()
end

-----------------------------------------------------------------------------------------

return Class
