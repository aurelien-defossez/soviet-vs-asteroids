-----------------------------------------------------------------------------------------
--
-- LaserSat.lua
--
-- A satellite firing lasers.
--
-----------------------------------------------------------------------------------------

module("LaserSat", package.seeall)
local Class = LaserSat
Class.__index = Class

local Sprite = require("lib.Sprite")

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------
local spriteSheet = love.graphics.newImage("assets/graphics/lasersat.png")

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------
require("src.SoundManager")
-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the station
function Class.create(options)
    -- Create object
    self = {}
    setmetatable(self, Class)

    -- Initialize attributes
    self.pos = options.position
    self.angle = options.angle
    self.displayAngle = options.angle
    self.isFiring = false
    self.targetAsteroid = nil
    self.debug = gameConfig.debug.all or gameConfig.debug.shapes 

    self.debugText = ""

    self.sprite = Sprite.create{
        pos = self.pos,
        angle = self.displayAngle,
        spriteSheet = spriteSheet,
        frameCount = 1,
        frameRate = 10000,
        scale = 0.5
    }



    return self
end

-- Destroy the station
function Class:destroy()
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Update the missile
--
-- Parameters:
--  dt: The time in seconds since last frame
function Class:update(dt)
  --  self.isFiring = false
    if (self.targetAsteroid) then
        self.targetAsteroid:hit()
    end
end

-- Draw the game
function Class:draw()
    love.graphics.setColor(255,255,255)
    self.sprite.angle = self.displayAngle
    self.sprite.pos = self.pos + vec2(-48, -32):rotateRad(-self.displayAngle)
    self.sprite:draw()
   
    if(self.isFiring and not( self.targetAsteroid == nil)) then
        love.graphics.setColor(255, 0, 0)
        local offset = vec2(15, 0):rotateRad(-self.displayAngle)
        love.graphics.line(self.pos.x + offset.x , self.pos.y + offset. y, self.targetAsteroid.pos.x, self.targetAsteroid.pos.y )
    end

    if self.debug then
        -- love.graphics.setLineWidth(3);
        -- love.graphics.line(self.pos.x, self.pos.y, self.pos.x + 20 * math.cos( -self.displayAngle), self.pos.y + 20 * math.sin( -self.displayAngle) )
    end
end

function Class:inFrontOf(fireAngle)
    shiftedAngle = fireAngle - self.angle
     if (shiftedAngle < -4.71) then
        shiftedAngle = 1 + shiftedAngle + 4.71
    end

    if (shiftedAngle > 4.71) then
        shiftedAngle =  shiftedAngle - 4.71
    end

    if ( shiftedAngle > -1.57 and shiftedAngle < 1.57 ) then
        return true
    else
        return false
    end
end

function Class:fire(fireAngle, asteroid)

    -- Check if the lasetSat is oriented in the direction of the fireAngle
    if (self:inFrontOf(fireAngle)) then

        local deltaX = asteroid.pos.x - self.pos.x
        local deltaY = asteroid.pos.y - self.pos.y
        asteroidAngle = - math.atan2(deltaY, deltaX)

        -- Check if the lasetSat can shot the target
        if (self:inFrontOf(asteroidAngle)) then      
            self.targetAsteroid = asteroid
            self.isFiring = true
            self.displayAngle = asteroidAngle

        else
            self.targetAsteroid = nil
            self.isFiring = false
            self.displayAngle = self.angle
        end
    else
        self.isFiring = false
        self.displayAngle = self.angle
    end

    return self.isFiring
end

function Class:stopFire()
    self.isFiring = false
    self.targetAsteroid = nil
    self.displayAngle = self.angle
end
