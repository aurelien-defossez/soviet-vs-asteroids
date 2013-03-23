gameConfig = {
    virtualScreenHeight = 1080,

    -- Camera
    camera = {
        -- defined around 1080px
        minVirtualHeight = 1080,
        maxVirtualHeight = 4000
    },

    missiles = {
        cooldown = 0.3, -- in seconds
        deleteDistance = 1080, -- in pixels
    },

    -- Debug options
    debug = {
        all = false,
        shapes = true
    },

    laser = {
        laserWidth =100
    },

    asteroidBeltDistance = 1080,

    asteroidSpawnProbability = 0.04
}
