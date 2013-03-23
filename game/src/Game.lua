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

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

require("lib.math.vec2")
require("lib.math.aabb")
require("lib.json.json")
require("src.Config")
require("src.Station")
require("src.PadController")
require("src.KeyboardControler")
require("src.SoundManager")
require("src.Asteroid")
require("src.Space")

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the game
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Set virtual viewport
    self.virtualScreenHeight = gameConfig.camera.minVirtualHeight
    self.virtualScaleFactor = love.graphics.getHeight() / self.virtualScreenHeight
    self.screenRatio = love.graphics.getWidth() / love.graphics.getHeight()
    self.camera = vec2(0, 0)
    self.zoom = 1.0

    -- Set font
    love.graphics.setFont(love.graphics.newFont(20))

    -- Initialize attributes
    self.station = Station.create()
    self.space = Space.create{
        station = self.station
    }
    if (love.joystick.isOpen(1)) then
        self.controller = PadController.create{
            station = self.station
        }
    else
        self.controller = KeyboardControler.create{
            station = self.station
        }
    end

    SoundManager.setup()
    SoundManager.startMusic()

    return self
end

-- Destroy the game
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the game
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
    self.station:update(dt)
    self.space:update(dt)
    self.controller:update(dt)
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
        (self.virtualScreenHeight * 0.5 / self.zoom) * self.screenRatio - self.camera.x,
        (self.virtualScreenHeight * 0.5 / self.zoom) - self.camera.y
    )

    -- Draw background
    local screenExtent = vec2(self.virtualScreenHeight * self.screenRatio, self.virtualScreenHeight)
    local cameraBounds = aabb(self.camera - screenExtent, self.camera + screenExtent)

    self.station:draw()
    self.space:draw()
    self.controller:draw()

    -- Reset camera transform before hud drawing
    love.graphics.pop()

    -- Draw HUD
    --love.graphics.setColor(255, 0, 255)
    --love.graphics.print(self.axis1, 0, 0)

end

-----------------------------------------------------------------------------------------

return Class
