-----------------------------------------------------------------------------------------
--
-- aabb.lua
--
-- An Axis-Aligned Bounding Box
--
-----------------------------------------------------------------------------------------

local bitwise = require("lib.math.bitwise")

local CS_CODES = {
    INSIDE = 0,
    LEFT   = 1,
    RIGHT  = 2,
    BOTTOM = 4,
    TOP    = 8
}

local mt = {
    __index = {
        -- Merge the AABB with another one, expanding it if necessary
        merge = function(self, box)
            self.min = self.min:min(box.min)
            self.max = self.max:max(box.max)

            return self
        end,
        
        -- expand the AABB enough to include the given vector
        expand = function(self, vector)
            self.min = self.min:min(vector)
            self.max = self.max:max(vector)

            return self
        end,
        
        -- Return true if the AABB contains the vector
        containsPoint = function(self, vector)
            return vector.x >= self.min.x and vector.x <= self.max.x
                and vector.y >= self.min.y and vector.y <= self.max.y
        end,
        
        -- Return true if the AABB collides with another one
        collideAABB = function(self, box)
            return self.min.x <= box.max.x and self.min.y <= box.max.y
                and self.max.x >= box.min.x and self.max.y >= box.min.y
        end,

        -- Return the number of collisions with a line, using Cohen-Sutherland algorithm
        -- -1: No collisions and the line is outside the box
        --  0: No collisions and the line is inside the box
        --  1: 1 collision, meaning on end of the line is inside while the other is outside
        --  2: 2 collisions, meaning the line goes through the box
        collideLine = function(self, a, b, _collisionsCount)
            _collisionsCount = _collisionsCount or 0

            -- Compute point codes
            local aCode = self:_computeCSCode(a)
            local bCode = self:_computeCSCode(b)

            -- Both points are inside the box
            if aCode == CS_CODES.INSIDE and bCode == CS_CODES.INSIDE then
                -- Return the number of intersections with the box (0, 1 or 2)
                return _collisionsCount
            end

            -- Both points are on the same side of the box and cannot intersect with it
            if bitwise.bit_and(aCode, bCode) ~= 0 then
                return -1
            end
            
            -- Choose first point outside the box (~= 0)
            local xCode = (aCode ~= 0) and aCode or bCode
            local x

            -- Find instersection point
            if bitwise.bit_and(xCode, CS_CODES.TOP) ~= 0 then
                x = vec2(a.x + (b.x - a.x) * (self.min.y - a.y) / (b.y - a.y), self.min.y)
            elseif bitwise.bit_and(xCode, CS_CODES.BOTTOM) ~= 0 then
                x = vec2(a.x + (b.x - a.x) * (self.max.y - a.y) / (b.y - a.y), self.max.y)
            elseif bitwise.bit_and(xCode, CS_CODES.LEFT) ~= 0 then
                x = vec2(self.min.x, a.y + (b.y - a.y) * (self.min.x - a.x) / (b.x - a.x))
            elseif bitwise.bit_and(xCode, CS_CODES.RIGHT) ~= 0 then
                x = vec2(self.max.x, a.y + (b.y - a.y) * (self.max.x - a.x) / (b.x - a.x))
            end

            -- Add an collision if intersection point is inside the box
            if self:_computeCSCode(x) == CS_CODES.INSIDE then
                _collisionsCount = _collisionsCount + 1
            end

            -- Move outside point to intersection point and find new intersection
            if xCode == aCode then
                return self:collideLine(x, b, _collisionsCount)
            else
                return self:collideLine(a, x, _collisionsCount)
            end
        end,

        -- Return the Cohen-Sutherland bit code of a point.
        -- Each bit represents a side of the box, top, bottom, left and right
        -- If bit LEFT and RIGHT are 1, it means that the point is in the top-left corner outside the box
        _computeCSCode = function(self, vector)
            local code = CS_CODES.INSIDE

            -- Check left and right
            if vector.x < self.min.x then
                code = bitwise.bit_or(code, CS_CODES.LEFT)
            elseif vector.x > self.max.x then
                code = bitwise.bit_or(code, CS_CODES.RIGHT)
            end

            -- Check top and bottom
            if vector.y < self.min.y then
                code = bitwise.bit_or(code, CS_CODES.TOP)
            elseif vector.y > self.max.y then
                code = bitwise.bit_or(code, CS_CODES.BOTTOM)
            end

            return code
        end,
        
        -- Return the size of the AABB, as a vector
        computeSize = function(self)
            return self.max - self.min
        end,

        -- Return a string with the object attributes
        print = function(self)
            return "[min="..self.min:print().." ; max="..self.max:print().."]"
        end,

        -- Draw shape
        draw = function(self)
            -- TODO
        end
    }
}

-- Build the AABB
function aabb(min, max)
    local self = {
        min = min,
        max = max or min:clone()
    }
    
    setmetatable(self, mt)

    return self
end
