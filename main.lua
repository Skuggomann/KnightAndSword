loader = require "libs.Advanced-Tiled-Loader.Loader"
Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
Camera = require "libs.hump.camera"
Signal = require "libs.hump.signal"
HC = require 'libs.HardonCollider'
inspect = require 'libs.inspect.inspect'
anim8 = require 'libs.anim8.anim8'

require 'menu'
require 'game'
require 'pause'
require 'levelselect'
require 'controls'
require 'death'
require 'win'
require 'optionsmenu'
require 'audiocontroller'
require 'speechstate'

debug = false

function love.load()
	--Loading fonts
	Font12p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 12)
	Font18p = love.graphics.setNewFont("/assets/fonts/visitor1.ttf", 18)
	Font24p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 24)
	Font36p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 36)

	AudioController = AudioController()
	love.graphics.setDefaultFilter("nearest","nearest")
	math.randomseed( os.time())
	
    Gamestate.registerEvents()
	Gamestate.switch(Gamestate.menu)
end