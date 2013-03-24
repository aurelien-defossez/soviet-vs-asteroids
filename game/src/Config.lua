require("lib.math.vec2")

gameConfig = {
    virtualScreenHeight = 1080,

    screen = {
        width = 1024,
        height = 700
    },

    -- Camera
    camera = {
        -- defined around 1080px
        minVirtualHeight = 1080,
        maxVirtualHeight = 4000
    },

    missiles = {
        cooldown = 1.0, -- in seconds
        cooldownUpgradeRate = 0.8, -- -20% per upgrade
        deleteDistance = 1080, -- in pixels
    },

    asteroid = {
        spawnPeriod = 2,
        baseRadius = 64,
        minRadius = 16,
        baseLife = 50,
        numberPoint = 100,
        beltDistance = 1000
    },

    station = {
        radius = 90,
        maxLife = 100,
        shieldRegeneration = .5,
        shieldOffset = vec2(0, 15),
        scoreMaxRange = 800
    },

    laserSat = {
        offOrbitRatio = 1.0
    },

    drone = {
        offOrbitRatio = 1.4,
        range = 42,
        speed = 0.3
    },

    missile = {
        speed = 8
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
        shapes = false
    },


    laser = {
        laserWidth =70,
        dpsExp = 0.75,
        baseDmg = 0.015,
        maxRange = 500,
        beamSpeed = 4
    }
}