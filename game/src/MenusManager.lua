-----------------------------------------------------------------------------------------
--
-- MenusManager.lua
--
-- The main MenusManager class.
--
-----------------------------------------------------------------------------------------
module("MenusManager", package.seeall)
local Class = MenusManager
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")
require("src.PauseMenu")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the MenusManager
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.menu = nil

    return self
end

-- Destroy the MenusManager
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the MenusManager
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.menu:update(dt)
end

-- Draw the MenusManager
function Class:draw()
    self.menu:draw()
end

-- Change the current menu
function Class:setMenu(menu)
    if self.menu ~= nil then
        self.menu:destroy()
    end

    if menu == "pause" then
        Menu = PauseMenu
    end
    if menu == "upgrade" then
        Menu = UpgradeMenu
    end

    self.menu = Menu.create{
        game = self.game
    }
end

function Class:selectButtonIn(x, y)
    self.menu:selectButtonIn(x, y)
end

function Class:enterSelected()
    self.menu:enterSelected()
end

-----------------------------------------------------------------------------------------

return Class
