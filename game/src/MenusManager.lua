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
require("src.TitleMenu")
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

    if menu == "title" then
        Menu = TitleMenu
    elseif menu == "pause" or menu == "gameover" then
        Menu = PauseMenu
    elseif menu == "upgrade" then
        Menu = UpgradeMenu
    end

    SoundManager.laserStop()
    self.menu = Menu.create{
        game = self.game,
        gameover = (menu == "gameover")
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

function Class:navigate(direction)
    local currentButtonId = self.menu.selected
    local nextButtonId = self:getSelected().navigation[direction]

    if nextButtonId then
        self:deselectButton()
        self.menu.selected = nextButtonId
        self:selectButton(currentButtonId)
    end
end

function Class:getSelected()
    return self.menu.buttons[self.menu.selected]
end

function Class:enterSelected()
    if self.menu.selected ~= nil then
        self:getSelected():callback()
    end
end

function Class:selectButton(previousButtonId)
    local selectedButton = self:getSelected()
    selectedButton.selected = true

    if selectedButton.onSelected then
        selectedButton.onSelected(previousButtonId)
    end
end

function Class:deselectButton()
    if self.menu.selected ~= nil then
        self:getSelected().selected = false
    end
end

-----------------------------------------------------------------------------------------

return Class
