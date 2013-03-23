-----------------------------------------------------------------------------------------
--
-- circle.lua
--
-- A circle
--
-----------------------------------------------------------------------------------------

local mt = {
    __index = {
        -- Return true if the circle collide with another circle
        collideCircle = function(self, circle)
            return self.center:distance(circle.center) < self.radius + circle.radius
        end,

        -- Return a string with the object attributes
        print = function(self)
            return "[center="..self.center:print().." ; radius="..self.radius.."]"
        end,

        -- Draw shape
        draw = function(self)
            -- TODO
        end
    }
}

-- Build the circle
function circle(center, radius)
    local self = {
        center = center,
        radius = radius
    }
    
    setmetatable(self, mt)

    return self
end
