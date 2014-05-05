loader = require "libs.Advanced-Tiled-Loader.Loader"
Gamestate = require "libs.hump.gamestate"
Class = require "libs.hump.class"
Camera = require "libs.hump.camera"
HC = require 'libs.HardonCollider'
inspect = require 'libs.inspect.inspect'

local menu = require 'menu'
function love.load()
    Gamestate.registerEvents()
	Gamestate.switch(menu)
end