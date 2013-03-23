-----------------------------------------------------------------------------------------
--
-- vec2.lua
--
-- A 2 dimension vector, with x and y components
--
-----------------------------------------------------------------------------------------

local sqrt = math.sqrt
local min = math.min
local max = math.max
local random = math.random
local cos = math.cos
local sin = math.sin
local PI = math.pi

local mt = {
    -- Override binary operator '+'
    __add = function(a, b)
        return vec2(a.x + b.x, a.y + b.y)
    end,
    
    -- Override binary operator '-'
    __sub = function(a, b)
        return vec2(a.x - b.x, a.y - b.y)
    end,
    
    -- Override binary operator '*'
    __mul = function(a, b)
        if type(b) == "number" then
            return vec2(a.x * b, a.y * b)
        else
            return vec2(a.x * b.x, a.y * b.y)
        end
    end,
    
    -- Override binary operator '/'
    __div = function(a, b)
        if type(b) == "number" then
            return vec2(a.x / b, a.y / b)
        else
            return vec2(a.x / b.x, a.y / b.y)
        end
    end,
    
    -- Override unary operator '-'
    __unm = function(a)
        return vec2(-a.x, -a.y)
    end,
    
    -- Override binary operator '=='
    __eq = function(a, b)
        return a.x == b.x and a.y == b.y
    end,
    
    -- Override binary operator '<'
    __lt = function(a, b)
        return a.x < b.x or a.x == b.x and a.y < b.y
    end,
    
    __index = {
        -- Clone the vector
        clone = function(self)
            return vec2(self.x, self.y)
        end,

        -- Make the dot product between two vectors
        dot = function(self, v)
            return self.x * v.x + self.y * v.y
        end,

        -- Return the perpendicular vector
        perp = function(self)
            return vec2(-self.y, self.x)
        end,
        
        -- Return the length of the vector
        length = function(self)
            return sqrt(self.x * self.x + self.y * self.y)
        end,
        
        -- Return a normalized version of the vector
        norm = function(self)
            local length = self:length()
            return vec2(self.x / length, self.y / length)
        end,
        
        reflect = function(self, normal)
            return normal * 2 * self:dot(normal) - self
        end,

        -- Rotate the vector around a point (by default its origin)
        rotate = function(self, angle, center)
            center = center or vec2(0, 0)

            -- Translate vector to the center of rotation
            local translated = self - center

            -- Rotate
            local radAngle = angle * PI / 180
            local cosAngle = cos(radAngle)
            local sinAngle = sin(radAngle)

            local rotated = vec2(
                translated.x * cosAngle - translated.y * sinAngle,
                translated.x * sinAngle + translated.y * cosAngle
            )

            -- Translate back from the center
            return rotated + center
        end,
        
        -- Return a new vector with the minimal components of the two vectors
        min = function(self, v)
            return vec2(min(self.x, v.x), min(self.y, v.y))
        end,
        
        -- Return a new vector with the maximal components of the two vectors
        max = function(self, v)
            return vec2(max(self.x, v.x), max(self.y, v.y))
        end,

        -- Return the distance between the two vectors
        distance = function(self, v)
            return (v - self):length()
        end,

        -- Return a vector with random values for each component that are between the two vectors
        random = function(self, v)
            return vec2(random(self.x, v.x), random(self.y, v.y))
        end,

        -- Return true if the vector is in the given circle
        isInCircle = function(self, v, radius)
            local dx = self.x - v.x
            local dy = self.y - v.y
            return (dx * dx + dy * dy <= radius * radius)
        end,

        -- Return true if the point is in the given triangle
        isInTriangle = function(self, a, b, c)
            -- Compute vectors
            local v0 = c - a
            local v1 = b - a
            local v2 = self - a

            -- Compute dot products
            local dot00 = v0:dot(v0)
            local dot01 = v0:dot(v1)
            local dot02 = v0:dot(v2)
            local dot11 = v1:dot(v1)
            local dot12 = v1:dot(v2)

            -- Compute barycentric coordinates
            local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
            local u = (dot11 * dot02 - dot01 * dot12) * invDenom
            local v = (dot00 * dot12 - dot01 * dot02) * invDenom

            -- Check if point is in triangle
            return (u >= 0 and v >= 0 and u + v < 1)
        end,

        -- Return true if the point in the given rectangle
        isInRectangle = function(self, x, y, w, h)
            return self.x >= x and self.y >= y and self.x <= x + w and self.y <= y + h
        end,

        -- Return a string with the object attributes
        print = function(self)
            return "[x="..self.x.." ; y="..self.y.."]"
        end,

        -- Draw the vector as a point on the screen
        draw = function(self, options)
            options = options or {}

            -- TODO!
        end
    }
}

-- Build the new vector
function vec2(x, y)
    local self = {
        x = x,
        y = y
    }

    setmetatable(self, mt)

    return self
end
