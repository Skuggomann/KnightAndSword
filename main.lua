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
end