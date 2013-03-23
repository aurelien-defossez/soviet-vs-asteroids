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
        cooldown = 0.3, -- in seconds
        deleteDistance = 1080, -- in pixels
    },

    asteroid = {
        life = 50,
        numberPoint = 100
    },

    station = {
        maxLife = 100,
        shieldRegeneration = .5
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
        dpsExp = 0.75
    },

    music = {
        music_path="assets/audio/intro_music.ogg",
        music_volume=1
    },

    asteroidBeltDistance = 1080,

    -- an asteroid will spanwn every X seconds
    asteroidSpawnPeriod = 2
}
