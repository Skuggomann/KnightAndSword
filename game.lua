Gamestate.game = {}
local game = Gamestate.game
local collider
local map
require 'player'
function game:init() -- run only once
	knight = Player(20,20)
	collider = HC(100, on_collide, stop_collide)
	map = loader.load("assets/maps/level3.tmx")
	cam = Camera(0, 256)
	cam:zoom(1.17)
end

function game:enter(previous) -- run every time the state is entered
end

function game:update(dt)
end

function game:draw()
	cam:draw(drawWorld)
end

function drawWorld()
	knight:draw()
	map:draw()
    love.graphics.print(string.format("You are now playing"),10,10)
end

function game:keyreleased(key)
    if key == 'p' then
        Gamestate.push(Gamestate.pause)
    end
end