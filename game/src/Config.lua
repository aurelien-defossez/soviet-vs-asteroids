require("lib.math.vec2")

gameConfig = {
    virtualScreenHeight = 1080,
    fullScreen = false,

    screen = {
        virtual = {
            width = 1024,
            height = 700
        },
        -- These values are set programatically in main.lua
        real = {},
        scale = 1
    },

    -- Camera
    camera = {
        -- defined around 1080px
        minVirtualHeight = 1080,
        maxVirtualHeight = 4000,
    },

    zoom = {
        origin = 4.5,
        target = 1,
        duration = 3,
        delay = 2
    },

    difficulty = {
        baseDifficulty = 1,
        sinInfluence = .25,
        sinPeriod = 60,
        difficultyModifier = .5,

        demo = {
            baseDifficulty = 1,
            sinInfluence = .25,
            sinPeriod = 60,
            difficultyModifier = .5,
        }
    },

    missiles = {
        cooldown = 1.0, -- in seconds
        cooldownUpgradeRate = 0.8, -- -20% per upgrade
        deleteDistance = 1080, -- in pixels
        speed = 400
    },

    asteroid = {
        speed = 50,
    	spawnPeriod = 2,
    	baseRadius = 64,
        minRadius = 16,
        baseLife = 300,
        numberPoint = 300,
        beltDistance = 1200,
    },

    station = {
        radius = 90,
        maxLife = 100,
        shieldRegeneration = .5,
        shieldOffset = vec2(0, 15),
        scoreMaxRange = 800,
    },

    laserSat = {
        offOrbitRatio = 1.0,
    },

    drone = {
        offOrbitRatio = 1.4,
        range = 80,
        speed = 0.3,
        damageModifier = 2,
    },

    controls = {
        default = "joystick", -- joystick, keyboard, mouse
        force = nil, -- joystick, keyboard, mouse

        mouse = {
            controls = "missiles", -- lasers, missiles
        },

        keyboard = {
            delta = math.pi, -- in radian
        },
    },

    upgrades = {
        missiles = {
            cost = 300,
            upgradeRate = 1.5, -- +50%
        },
        lasers = {
            cost = 200,
            upgradeRate = 1.5, -- +50%
        },
        drones = {
            cost = 400,
            upgradeRate = 1.5, -- +50%
        },
        fusrodov = {
            cost = 600,
            upgradeRate = 1.25, -- +25%
        },
    },

    -- Debug options
    debug = {
        all = false,
        shapes = false,
    },

    laser = {
        laserWidth = 70,
        dpsExp = 0.75,
        baseDmg = 0.1,
        maxRange = 500,
        beamSpeed = 4,
    },
}
