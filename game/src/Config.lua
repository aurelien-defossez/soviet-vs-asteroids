gameConfig = {
    virtualScreenHeight = 1080,

    screen = {
        width = 1024,
        height = 768
    },

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

    controls = {
        default = "joystick", -- joystick, keyboard, mouse
        force = nil, -- joystick, keyboard, mouse

        mouse = {
            controls = "missiles", -- lasers, missiles
        },

        keyboard = {
            delta = math.pi / 36, -- in radian
        },
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

    asteroidSpawnEvery = 1
}
