
require("lib.math.vec2")

config = {

	-----------------------------------------------------------------------------------------
	-- Debug modes
	-----------------------------------------------------------------------------------------

	debug = {
		-- Menu
		showDebugMenu = false,
		showDemoMenu  = false,

		-- Game
		drawBounds   = false,
		noMusic      = false,
		mute         = false,
		noLoading    = false,
		noTutorial   = false,
		spawnAll     = false,
		cannotEscape = false,
		cannotDie    = false,
		noTimeLimit  = false,
		quickLevels  = false,
		slowMode     = false,
		noAnimals    = false,
		oneAnimal    = false,

		-- Print
		drawGestures = false,
		gestureLog   = false,

		-- Values
		slowModeRatio       = 0.25,
		quickLevelsDuration = 5,
		demoModeDuration    = 15
	},

	-----------------------------------------------------------------------------------------
	-- Game configuration
	-----------------------------------------------------------------------------------------

	game = {
		-- First level to load
		firstLevel = "level01",

		-- Timer to change a tap in a longTouch in seconds
		longTouchTimer = 0.2,
		-- Distance to change a tap into a swipe in pixels
		swipeMinLength = 15,
		-- Maximum length of a swipe in pixels
		swipeLength    = 75,
		-- Minimal length needed for a computation of the nearest point to find the swipe offset when killing rabbits
		minLengthForNearestPointComputation = 20,

		-- Player
		player = {
			maxHealth = 100,
			maxCombo  = 9
		},

		damages = {
			uselessGesture = 4,
			animalHidden   = 4
		},

		-- Animals
		animals = {
			apparitionProba = .06,
			apparitionTime  = 1,
			idleTime        = 3,
			cooldownTime    = 1,
			types = {
				dog = {
					weapon = "tap"
				},
				rabbit = {
					weapon = "swipe"
				},
				tortoise = {
					weapon = "longTouch"
				}
			},
			presets = {
				dog1 = {
					type = "dog",
					health = 1,
					points = 10
				},
				dog2 = {
					type = "dog",
					decoration = "flower",
					health = 2,
					points = 20
				},
				rabbit1 = {
					type = "rabbit",
					health = 1,
					points = 15
				},
				rabbit2 = {
					type = "rabbit",
					decoration = "flower",
					health = 2,
					points = 30
				},
				tortoise1 = {
					type = "tortoise",
					health = 0.5,
					points = 50
				},
				tortoise2 = {
					type = "tortoise",
					decoration = "flower",
					health = 1.5,
					points = 100
				}
			},
			decoration = {
				dog = vec2(-5, -19),
				rabbit = vec2(-8, -9),
				tortoise = vec2(-2, 4)
			},
			hitBox = {
				dog = {
					position = vec2(0, 5),
					width = 40,
					height = 50
				},
				rabbit = {
					position = vec2(-4, 5),
					width = 30,
					height = 40
				},
				tortoise = {
					position = vec2(0, 0),
					width = 40,
					height = 50
				}
			},
			rabbitGibs = {
				startVelocity = {
					vec2(25, 25),
					vec2(50, 50)
				},
				acceleration = {
					vec2(0, 100),
					vec2(0, 200)
				},
				rotationSpeed = { 10, 40 }
			}
		},

		-- Combo multiplicators
		multiplicators = {
			0,		-- x1
			10,		-- x2
			25,		-- x3
			45,		-- x4
			70,		-- x5
			100,	-- x6
			135,	-- x7
			175,	-- x8
			220,	-- x9
			270		-- x10
		}
	},

	-----------------------------------------------------------------------------------------
	-- HUD configuration
	-----------------------------------------------------------------------------------------

	hud = {
		fps = 30,

		screen = {
			width      = display.contentWidth,
			halfWidth  = display.contentWidth * .5,
			height     = display.contentHeight,
			halfHeight = display.contentHeight * .5
		},

		loading = {
			fadeIn  = 1,
			idle    = 1,
			fadeOut = 1
		},

		logo = {
			width  = 248,
			height = 50,
			offset = vec2(0, -12),
			backgroundColor = { 210, 210, 210 }
		},

		buttons = {
			width               = 125,
			height              = 30,
			strokeWidth         = 1,
			cornerRadius        = 3,
			fontSize            = 12,
			fillColor           = { 255, 190, 240 },
			selectedFillColor   = { 200,  50, 180 },
			strokeColor         = { 200,  50, 180 },
			selectedStrokeColor = { 255, 180,  40 },
			textColor           = {  40,  40,  40 },
			selectedTextColor   = { 255, 255, 255 }
		},
		
		windows = {
			xpadding     = 5,
			ypadding     = 5,
			strokeWidth  = 2,
			cornerRadius = 5,
			titleHeight  = 8,
			fontSize     = 12,
			fillColor    = { 240,  90, 230 },
			strokeColor  = { 200,  50, 180 },
			textColor    = {  40,  40,  40 }
		},

		menu = {
			welcome = vec2(230, 0),
			gameOver = vec2(4, 110),
			buttonWidth = 75
		},

		pauseButton = vec2(5, -2),

		score = {
			panel = vec2(30, -2),
			text = {
				position = vec2(75, 11.5),
				size = 8,
				color = { 255, 255, 255 }
			}
		},

		multiplicator = {
			text = {
				position = vec2(78, 17),
				size = 8,
				color = {
					x1 = { 196, 196, 196 },	-- Gray
					x2 = { 255, 255, 255 },	-- White
					x3 = { 255, 255,  60 },	-- Yellow
					x4 = { 242, 175,  60 },	-- Orange
					x5 = { 232, 100, 100 },	-- Red
					x6 = { 224, 145, 255 },	-- Purple
					x7 = { 158, 173, 255 },	-- Blue
					x8 = {   0, 255, 255 },	-- Cyan
					x9 = {   0, 255,  90 },	-- Green
					x10= {   0, 255,  90 }	-- Green
				}
			}
		},

		life = {
			panel = vec2(98, -2),
			bar = {
				position = vec2(101, 9.5),
				width = 50,
				chunk = {
					orientation   = -13,
					visibleWidth  = 14,
					startVelocity = vec2(50, -12),
					acceleration  = vec2(0, 200)
				}
			},
			criticalRatio = 0.2
		},

		tutorial = {
			width         = display.contentWidth * .8,
			height        = display.contentHeight * .9,
			startPosition = vec2(display.contentWidth * .1, display.contentHeight * 1.05),
			endPosition   = vec2(display.contentWidth * .1, display.contentHeight * .05),
			animation = {
				inDuration  = 1,
				outDuration = 0.5
			},
			fillColor    = { 255, 255, 189 },
			strokeColor  = {   0,   0,   0 },
			strokeWidth  = 2,
			cornerRadius = 3
		},

		swipeScale = 0.7,

		mistake = {
			animationTime = 1.2,
			offset = vec2(0, -25)
		},

		borders = {
			width = 105,
			color = { 0, 0, 0 }
		},

		gameOverText = {
			position = vec2(100, 40),
			width  = 103,
			height = 54,
			fadeIn = 2
		}
	},

	-----------------------------------------------------------------------------------------
	-- File paths configuration
	-----------------------------------------------------------------------------------------

	paths = {
		-- Backgrounds
		scenes = {
			logo     = "runtimedata/graphics/scenes/logo.png",
			title    = "runtimedata/graphics/scenes/title.png",
			gameOver = "runtimedata/graphics/scenes/gameover.png"
		},
		gameOverText = 'runtimedata/graphics/scenes/gameover_text.png',

		-- Levels
		levels       = "runtimedata/levels/",
		tutorials    = "runtimedata/graphics/tutorials/",
		backgrounds  = "runtimedata/graphics/environment/",

		-- Sprites
		spritesheet = "runtimedata/graphics/sprites/spritesheet.png",

		-- SFX
		sfx = {
			deadRabbit = "runtimedata/graphics/sfx/rabbit_dead.png",
			mask = {
				rabbit     = "runtimedata/graphics/sfx/mask_rabbit.png",
				life       = "runtimedata/graphics/sfx/mask_life.png",
				life_chunk = "runtimedata/graphics/sfx/mask_chunk.png",
			},
			particles  = {
				blood   = "runtimedata/graphics/sfx/particle_blood.png",
				sparkle = "runtimedata/graphics/sfx/particle_sparkle.png",
				leaf    = "runtimedata/graphics/sfx/particle_leaf.png",
			}
		},

		-- Audio
		sounds = "runtimedata/audio/"
	},

	preLoadedImages = {
		"runtimedata/graphics/scenes/title.png",
		"runtimedata/graphics/environment/background-1.png",
		"runtimedata/graphics/environment/foreground-1.png"
	},

	packages = {
		levels = "runtimedata.levels.",
		stages = "runtimedata.stages."
	},

	-----------------------------------------------------------------------------------------
	-- Sprites configuration
	--
	-- Parameters:
	--  frameCount: The number of frames defining the animation (default is 1)
	--				If frameCount > 1, then the source images should be suffixed by _01, _02
	--				and so on
	--				(e.g. zombie_attack_right_blue_01.png and zombie_attack_right_blue_02.png)
	--  period: The period in seconds to play the whole animation.
	--			(Optional if there is only one frame)
	-- loopCount: Tells how many times the animation loops (Default is 0, indefinitely).
	--
	-----------------------------------------------------------------------------------------
	
	sprites = {
		dog = {
			idle = {
				frameCount = 2,
				period = .25
			},
			hit = {
				frameCount = 2,
				period = .25,
				loopCount = 1
			},
			dead = {
				frameCount = 5,
				period = 1,
				loopCount = 1
			}
		},

		rabbit = {
			idle = {
				frameCount = 4,
				period = 1
			},
			hit = {
				frameCount = 2,
				period = .25,
				loopCount = 1
			},
			dead = {}
		},

		tortoise = {
			idle = {
				frameCount = 4,
				period = 1
			},
			hide = {},
			dead = {
				frameCount = 7,
				period = 0.8,
				loopCount = 1
			},
		},

		decoration = {
			flower = {}
		},

		hud = {
			pause = {},
			score = {},
			life_container = {}
		},

		life_bar = {
			normal = {},
			critical = {}
		},

		gesture = {
			slash = {
				frameCount = 5,
				period = 0.1,
				loopCount = 1
			},
			mistake = {}
		}
	},

	-----------------------------------------------------------------------------------------
	-- Sounds configuration
	--
	-- Parameters:
	--  stream: Tells whether to load the sound as a stream or not (Default is false).
	--  variations: The different variations available for the same effect.
	--              The varations are the file name suffixes. When played, one of the
	--              variation will be played randomly (Default is { "" }).
	--  extension: The file extension (Default is "mp3").
	--  loops: The number of times you want the audio to loop (Default is 0).
	--         Notice that 0 means the audio will loop 0 times which means that the sound
	--         will play once and not loop. Continuing that thought, 1 means the audio will
	--         play once and loop once which means you will hear the sound a total of
	--         2 times. Passing -1 will tell the system to infinitely loop the sample.
	--  volume: The volume of this sound, in [0 ; 1] (Default is 1).
	--  duration: The sound duration in seconds
	--            (Default is nil, until the sound is finished).
	--  fadeIn: The fade in time in seconds, this will cause the system to start playing
	--          a sound muted and linearly ramp up to the maximum volume over the specified
	--          number of seconds (Default is nil, no fade in).
	--  fadeOut: The fade out time in seconds, this will cause the system to stop a
	--           sound linearly from its level to no volume over the specified
	--           number of seconds (Default is nil, no fade out).
	--  
	-----------------------------------------------------------------------------------------

	sounds = {
		music_game = {
			stream = true,
			volume = 0.3
		},

		music_menu = {
			stream = true,
			loops = -1,
			volume = 0.5,
			fadeOut = 2
		},

		game_over = {
			volume = 0.5
		},

		hammer_hit = {
			variations = {
				{
					suffix = "_01",
					volume = 0.6
				}, {
					suffix = "_02",
					volume = 0.6
				}
			}
		},

		hammer_miss = {
			volume = 0.8
		},

		katana_hit = {
			volume = 0.5
		},

		katana_miss = {
			volume = 0.8
		},

		chainsaw_hit = {
			fadeOut = 0.6,
			volume = 0.25
		},

		chainsaw_miss = {
			duration = 0.2,
			fadeOut = 0.8,
			volume = 0.35
		},

		dog_spawn = {
			variations = {
				{
					suffix = "_01",
					volume = 0.5
				}, {
					suffix = "_02",
					volume = 0.6
				}
			}
		},

		dog_death = {
			variations = {
				{
					suffix = "_01",
					volume = 0.4
				}, {
					suffix = "_02",
					volume = 1
				}
			}
		},

		rabbit_spawn = {
			variations = {
				{
					suffix = "_01",
					volume = 0.4
				}, {
					suffix = "_02",
					volume = 0.4
				}
			}
		},

		rabbit_death = {
			variations = {
				{
					suffix = "_01",
					volume = 0.5
				}, {
					suffix = "_02",
					volume = 0.6
				}
			}
		},

		tortoise_spawn = {
			variations = {
				{
					suffix = "_01",
					volume = 0.5
				}, {
					suffix = "_02",
					volume = 0.5
				}
			}
		},

		tortoise_death = {
			variations = {
				{
					suffix = "_01",
					volume = 1
				}, {
					suffix = "_02",
					volume = 1
				}, {
					suffix = "_03",
					volume = 1
				}
			}
		},

		sfx_blood = {
			variations = {
				{
					suffix = "_01",
					volume = 0.3
				}, {
					suffix = "_02",
					volume = 0.6
				}
			}
		}
	}
}
