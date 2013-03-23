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
        cooldown = 1, -- in seconds
        deleteDistance = 1080, -- in pixels
    },

    asteroid = {
    	spawnPeriod = 2,
    	baseRadius = 64,
        baseLife = 50,
        numberPoint = 100
    },
    asteroidBeltDistance = 1080,

    station = {
        radius = 90,
        maxLife = 100,
        shieldRegeneration = .5,
        shieldOffset = vec2(0, 15)
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
        laserWidth =100,
        dpsExp = 0.75,
        baseDmg = 0.015,
        maxRange = 800
    },

    music = {
        music_path="assets/audio/intro_music.ogg",
        music_volume=1
    }
}
