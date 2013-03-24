-----------------------------------------------------------------------------------------
--
-- UpgradeMenu.lua
--
-- The main UpgradeMenu class.
--
-----------------------------------------------------------------------------------------
module("UpgradeMenu", package.seeall)
local Class = UpgradeMenu
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("src.Config")
require("src.gui.Button")
require("src.gui.Colors")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the UpgradeMenu
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    self.game = options.game
    self.station = self.game.station
    self.selected = 1
    self.scale = gameConfig.screen.scale

    self.background = love.graphics.newImage("assets/graphics/gui/shop_bg.png")

    self.offsetX = (gameConfig.screen.width - 1280 * self.scale) / 2
    self.offsetY = (gameConfig.screen.height - 720 * self.scale) / 2

    self.buttons = {}
    table.insert(
        self.buttons,
        Button.create{
            x = (gameConfig.screen.width - 444 * self.scale) / 2, -- center
            y = gameConfig.screen.height / 2 + 250 * self.scale,
            width = 444,
            height = 66,
            scale = gameConfig.screen.scale,
            background = "btn_off",
            border = "btn_on",
            text = "Resume",
            callback = self.resumeGame,
        }
    )

    self.btns = {}
    self.btns["missiles"] = Button.create{
        x = self.offsetX + (52 * self.scale),
        y = self.offsetY + (399 * self.scale),
        width = 294,
        height = 196,
        scale = gameConfig.screen.scale,
        background = "shop_upgrade_1",
        border = "shop_highlight",
        text = self.station.costs["missiles"],
        callback = self.upgradeMissiles,
        valign = "down",
        color = "red",
    }
    table.insert(self.buttons, self.btns["missiles"])

    self.btns["lasers"] = Button.create{
        x = self.offsetX + (346 * self.scale),
        y = self.offsetY + (399 * self.scale),
        width = 294,
        height = 196,
        scale = gameConfig.screen.scale,
        background = "shop_upgrade_2",
        border = "shop_highlight",
        text = self.station.costs["lasers"],
        callback = self.upgradeLaser,
        valign = "down",
        color = "red",
    }
    table.insert(self.buttons, self.btns["lasers"])

    self.btns["drones"] = Button.create{
        x = self.offsetX + (640 * self.scale),
        y = self.offsetY + (399 * self.scale),
        width = 294,
        height = 196,
        scale = gameConfig.screen.scale,
        background = "shop_upgrade_3",
        border = "shop_highlight",
        text = self.station.costs["drones"],
        callback = self.upgradeDrone,
        valign = "down",
        color = "red",
    }
    table.insert(self.buttons, self.btns["drones"])

    self.btns["fusrodov"] = Button.create{
        x = self.offsetX + (934 * self.scale),
        y = self.offsetY + (399 * self.scale),
        width = 294,
        height = 196,
        scale = gameConfig.screen.scale,
        background = "shop_upgrade_4",
        border = "shop_highlight",
        text = self.station.costs["fusrodov"],
        callback = self.upgradeFusrodov,
        valign = "down",
        color = "red",
    }
    table.insert(self.buttons, self.btns["fusrodov"])

    return self
end

-- Destroy the UpgradeMenu
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the UpgradeMenu
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self:updateButtons()
end

-- Draw the UpgradeMenu
function Class:draw()
    -- display the background
    love.graphics.draw(
        self.background,
        self.offsetX,
        self.offsetY,
        0,
        self.scale
    )

    for key, val in pairs(self.buttons) do
        val:draw()
    end
end

function resumeGame()
    self.game:setMode("game")
end

-- Upgrade the missiles by reducing the cooldown between two missiles
function upgradeMissiles()
    if not self.station:hasEnoughCoins("missiles") then
        return
    end

    self.station:buyUpgrade("missiles")

    -- Upgrade the cooldown
    cooldown = self.station.missileCoolDownTime * gameConfig.missiles.cooldownUpgradeRate
    self.station:setMissileCooldown(cooldown)
    SoundManager:upgrade()

    self:updateButtons()
end

function upgradeLaser()
    if not self.station:hasEnoughCoins("lasers") then
        return
    end

    -- Upgrade the cooldown
    self.game:setUpgrade("satellite")
end

function upgradeDrone()
    if not self.station:hasEnoughCoins("drones") then
        return
    end

    -- Upgrade the cooldown
    self.game:setUpgrade("drone")
end

function upgradeFusrodov()
    if not self.station:hasEnoughCoins("fusrodov") then
        return
    end

    self:updateButtons()
end

function updateButtons()
    for key, val in pairs(self.btns) do
        val.text = self.station.costs[key]
        if self.station:hasEnoughCoins(key) then
            val.color = "white"
        else
            val.color = "red"
        end
    end
end

-----------------------------------------------------------------------------------------

return Class
