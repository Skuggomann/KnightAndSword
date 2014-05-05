loader = require "libs.Advanced-Tiled-Loader.Loader"
Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
Camera = require "libs.hump.camera"
HC = require 'libs.HardonCollider'
inspect = require 'libs.inspect.inspect'

require 'menu'
require 'game'
require 'pause'
require 'levelselect'

function love.load()
    Gamestate.registerEvents()
	Gamestate.switch(Gamestate.menu)
	
	--Loading fonts
	Font12p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 12)
	Font18p = love.graphics.setNewFont("/assets/fonts/visitor1.ttf", 18)
	Font24p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 24)
	Font36p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 36)
end