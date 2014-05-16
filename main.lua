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

sprites = {}
debug = false

function love.load()
	--Loading fonts
	Font12p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 12)
	Font18p = love.graphics.setNewFont("/assets/fonts/visitor1.ttf", 18)
	Font24p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 24)
	Font36p = love.graphics.newFont("/assets/fonts/visitor1.ttf", 36)
	--load sprites
	sprites.bat2down = love.graphics.newImage('/assets/art/bat2down.png')
	sprites.bat2up = love.graphics.newImage('/assets/art/bat2up.png')
	sprites.brick_breakable1 = love.graphics.newImage('/assets/art/tiles/Brick-breakable1.png')
	sprites.brick_breakable2 = love.graphics.newImage('/assets/art/tiles/Brick-breakable2.png')
	sprites.rip_small_animation = love.graphics.newImage('assets/art/rip-small-animation.png')
	sprites.gateOpen = love.graphics.newImage('/assets/art/tiles/gateOpen.png')
	sprites.gateClosed = love.graphics.newImage('/assets/art/tiles/gateClosed.png')
	sprites.gateButtonUp = love.graphics.newImage('/assets/art/tiles/gateButtonUp.png')
	sprites.gateButtonDown = love.graphics.newImage('/assets/art/tiles/gateButtonDown.png')
	sprites.red = love.graphics.newImage('/assets/art/red.png')
	sprites.green = love.graphics.newImage('/assets/art/green.png')
	sprites.frostboltHand = love.graphics.newImage('assets/art/FrostboltHand.png')
	sprites.frostbolt_animation = love.graphics.newImage('assets/art/Frostbolt-animation.png')
	sprites.largeHealthVial = love.graphics.newImage('/assets/art/largeHealthVial.png')
	sprites.blackMaceA = love.graphics.newImage("assets/art/blackMaceA.png")
	sprites.menubg = love.graphics.newImage('/assets/art/menubg.png')
	sprites.box = love.graphics.newImage('/assets/art/tiles/box.png')
	sprites.player2 = love.graphics.newImage('/assets/art/player2.png')
	sprites.player2jumping = love.graphics.newImage('/assets/art/player2jumping.png')
	sprites.player2short = love.graphics.newImage('/assets/art/player2short.png')
	sprites.player2Dmg = love.graphics.newImage('/assets/art/player2DMG.png')
	sprites.player2jumpingDmg = love.graphics.newImage('/assets/art/player2jumpingDMG.png')
	sprites.player2shortDmg = love.graphics.newImage('/assets/art/player2shortDMG.png')
	sprites.rip_small = love.graphics.newImage("assets/art/rip-small.png")
	sprites.skeleton = love.graphics.newImage('/assets/art/skeleton.png')
	sprites.skeletonDmg = love.graphics.newImage('/assets/art/skeletonDMG.png')
	sprites.icecube = love.graphics.newImage('/assets/art/icecube.png')
	sprites.sword2 = love.graphics.newImage("assets/art/sword2.png")
	sprites.levitateHand = love.graphics.newImage('assets/art/LevitateHand.png')
	sprites.veilOfSouls = love.graphics.newImage('/assets/art/VeilOfSOUUUUUULS.png')
    sprites.veilOfSouls:setWrap("clamp","repeat")
	sprites.veilOfSouls2 = love.graphics.newImage('/assets/art/VeilOfSOUUUUUULS2.png')
    sprites.veilOfSouls2:setWrap("clamp","repeat")
	sprites.veilOfSouls3 = love.graphics.newImage('/assets/art/VeilOfSOUUUUUULS3.png')
    sprites.veilOfSouls3:setWrap("clamp","repeat")
	sprites.veilOfSouls4 = love.graphics.newImage('/assets/art/VeilOfSOUUUUUULS4.png')
    sprites.veilOfSouls4:setWrap("clamp","repeat")
	sprites.veilOfSouls5 = love.graphics.newImage('/assets/art/VeilOfSOUUUUUULS5.png')
    sprites.veilOfSouls5:setWrap("clamp","repeat")
    sprites.livingHeart2 = love.graphics.newImage("assets/art/LivingHeart2.png")
    sprites.deadHeart2 = love.graphics.newImage("assets/art/DeadHeart2.png")
    sprites.sword = love.graphics.newImage("assets/art/sword.png")
    sprites.frostbolt1 = love.graphics.newImage("assets/art/Frostbolt1.png")
    sprites.playerhed = love.graphics.newImage("assets/art/playerhed.png")
    sprites.blackMaceAthumbnail = love.graphics.newImage("assets/art/blackMaceAthumbnail.png")
    sprites.levitate = love.graphics.newImage("assets/art/levitate.png")

	-- audio
	AudioController = AudioController()
	love.graphics.setDefaultFilter("nearest","nearest")

	math.randomseed( os.time())
	
    Gamestate.registerEvents()
	Gamestate.switch(Gamestate.menu)
end