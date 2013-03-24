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
require("src.UpgradeMenu")


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
    self.menu:destroy()
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

    self:selectButton()
end

function Class:selectButtonIn(x, y)
    for key, val in pairs(self.menu.buttons) do
        if val:contains(x, y) then
            self:deselectButton()
            self.menu.selected = key
            val.selected = true
            break
        end
    end
end

function Class:previousButton()
    self:deselectButton()
    self.menu.selected = (self.menu.selected - 1) % table.getn(self.menu.buttons)
    if self.menu.selected == 0 then
        self.menu.selected = 3
    end
    self:selectButton()
end

function Class:nextButton()
    self:deselectButton()
    self.menu.selected = (self.menu.selected + 1) % table.getn(self.menu.buttons)
    if self.menu.selected == 0 then
        self.menu.selected = 3
    end
    self:selectButton()
end

function Class:enterSelected()
    if self.menu.selected ~= nil then
        btn = self.menu.buttons[self.menu.selected]
        btn:callback()
    end
end

function Class:selectButton()
    btn = self.menu.buttons[self.menu.selected]
    btn.selected = true
end

function Class:deselectButton()
    if self.menu.selected ~= nil then
        btn = self.menu.buttons[self.menu.selected]
        btn.selected = false
    end
end

-----------------------------------------------------------------------------------------

return Class
