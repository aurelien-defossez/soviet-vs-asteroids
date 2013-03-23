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
    self.isFiring = false
    self.targetAsteroid = nil
    self.debug = gameConfig.debug.all or gameConfig.debug.shapes 

    self.debugText = ""

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
    if not self.debug then
        return
    end

    love.graphics.setColor(255, 255, 0)
    love.graphics.circle('fill', self.pos.x , self.pos.y , 10, 32)
    love.graphics.setLineWidth(3);
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x + 20 * math.cos( -self.angle), self.pos.y + 20 * math.sin( -self.angle) )

    --love.graphics.print("Debug : " ..self.debugText, 200, 200)

   
    if(self.isFiring and not( self.targetAsteroid == nil)) then
        love.graphics.setColor(255, 127, 0)
        love.graphics.line(self.pos.x, self.pos.y, self.targetAsteroid.pos.x, self.targetAsteroid.pos.y )
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

        else
            self.targetAsteroid = nil
            self.isFiring = false
        end
    else
        self.isFiring = false
    end

    return self.isFiring
end

function Class:stopFire()
    self.isFiring = false
    self.targetAsteroid = nil
end
