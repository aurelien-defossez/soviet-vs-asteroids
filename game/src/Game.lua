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

game = nil

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("lib.math.vec2")
require("lib.math.aabb")
require("lib.json.json")
require("src.Config")
require("src.Station")
require("src.PadController")
require("src.KeyboardController")
require("src.MouseController")
require("src.SoundManager")
require("src.Asteroid")
require("src.Space")
require("src.LaserSat")
require("src.MenusManager")
require("src.Drone")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the game
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)
    game=self

    -- Set virtual viewport
    self.virtualScreenHeight = gameConfig.camera.minVirtualHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    self.camera = vec2(0, 0)
    self.zoom = 1.25

    -- Set font
    love.graphics.setFont(love.graphics.newFont(20))

    -- Initialize attributes
    self.station = Station.create()
    self.space = Space.create{
        station = self.station
    }

    self.station.space = self.space
    self.menus = MenusManager.create{
        game = self
    }
    self.menu = nil
    self.upgrade = nil

    self.station:addLaserSat( LaserSat.create{ angle = -math.pi / 2 } )
    self.station:addLaserSat( LaserSat.create{ angle = math.pi / 2 } )
    self.station:addLaserSat( LaserSat.create{ angle = 0 } )
    self.station:addLaserSat( LaserSat.create{ angle = math.pi } )

    self.station:addDrone( Drone.create{ angle = -math.pi / 2 } )
    -- self.station:addDrone( Drone.create{ angle = math.pi / 2 } )
    -- self.station:addDrone( Drone.create{ angle = 0 } )
    -- self.station:addDrone( Drone.create{ angle = math.pi } )

    -- Create the input controller
    if (
        gameConfig.controls.default == "joystick" and
        (
            love.joystick.isOpen(1) or
            gameConfig.controls.force == "joystick"
        )
    ) then
        ControllerClass = PadController
    elseif gameConfig.controls.default == "keyboard" then
        ControllerClass = KeyboardController
    else
        ControllerClass = MouseController
    end

    self.controller = ControllerClass.create{
        station = self.station,
        game = self,
    }

    self:computeTranslateVector()
    self:setMode("game")

    SoundManager.setup()
    SoundManager.startMusic()
    SoundManager.setNoSound()

    function love.focus(f)
        if not f then
            self:setMenu("pause")
        end
    end

    return self
end

-- Destroy the game
function Class:destroy()
end

-- Compute the translate vector for the camera
function Class:computeTranslateVector()
    self.translateVector = vec2(
        (self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x,
        (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y
    )
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the game
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.controller:update(dt)
    if self.mode == "menu" then
        self.menus:update(dt)
    elseif self.mode ~= "upgrade" and self.mode ~= "end" then
        self.station:update(dt)
        self.space:update(dt)
        if self.station.life < 0 then
            self.mode = "end"
            SoundManager.voiceDeath()
        end
    end
end

-- Draw the game
function Class:draw()

    love.graphics.push()

    -- Apply virtual resolution before rendering anything
    love.graphics.scale(self.virtualScaleFactor, self.virtualScaleFactor)

    -- Apply camera zoom
    love.graphics.scale(self.zoom, self.zoom)

    -- Move to camera position
    love.graphics.translate(
        self.translateVector.x,
        self.translateVector.y
    )

    -- Draw background
    local screenExtent = vec2(self.virtualScreenHeight * self.screenRatio, self.virtualScreenHeight)
    local cameraBounds = aabb(self.camera - screenExtent, self.camera + screenExtent)

    self.controller:draw()
    if self.mode ~= "menu" then
        self.space:draw()
        self.station:draw()
    end

    if self.mode == "upgrade" then
        if self.upgrade == "satellite" then
            self.station.newSatellite:draw()
        elseif self.upgrade == "drone" then
            self.station.newDrone:draw()
        end
    end

    -- Reset camera transform before hud drawing
    love.graphics.pop()

    -- Draw HUD

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Score : " ..self.station.score, 10, 10)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Roubles : " ..self.station.coins, 300, 10)

    if self.mode == "menu" then
        self.menus:draw()
    end

end

-- Compute the translate vector for the camera
function Class:computeTranslateVector()
    self.translateVector = vec2(
        (self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x,
        (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y
    )
end

-- Set the current mode of the game
--
-- Parameters
--  mode: "game" or "upgrade" or "menu"
function Class:setMode(mode)
    self.mode = mode
    self.controller:setMode(mode)
    self.station:setMode(mode)
    self.space:setMode(mode)
end

-- Set the current menu
--
-- Parameters
--  menu: the menu to show
function Class:setMenu(menu)
    self.menu = menu
    self.menus:setMenu(menu)
    self:setMode("menu")
end

-- Set the current upgrade
--
-- Parameters
--  upgrade: the item to upgrade, "satellite" or "drone"
function Class:setUpgrade(upgrade)
    self.upgrade = upgrade
    self:setMode("upgrade")

    if upgrade == "satellite" then
        self.station.newSatellite = LaserSat.create{
            position = 0,
            angle = 0,
        }
    elseif upgrade == "drone" then
        self.station.newDrone = Drone.create{
            angle = 0,
        }
    end
end

function Class:putUpgrade()
    if self.upgrade == "satellite" and self.station.newSatellite ~= nil then
        self.station:addLaserSat(self.station.newSatellite)
        self.station.newSatellite = nil
        self:setMenu("upgrade")
    elseif self.upgrade == "drone" and self.station.newDrone ~= nil then
        self.station:addDrone(self.station.newDrone)
        self.station.newDrone = nil
        self:setMenu("upgrade")
    end
end

-----------------------------------------------------------------------------------------

return Class
