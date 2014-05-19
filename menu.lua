Gamestate.menu = {}
local menu = Gamestate.menu
W, H = love.graphics.getWidth(), love.graphics.getHeight()

function menu:init() -- run only once
end

function menu:enter(previous) -- run every time the state is entered
	AudioController:playMusic("mainmenu")
	Signal.register('enter', function()
    	Gamestate.switch(Gamestate.levelselect)
	end)
end

function menu:update(dt)
end

function menu:draw()
    love.graphics.draw(sprites.menubg, 0, 0)
    love.graphics.printf(string.format("press enter(x) to play"), 0,H/2-100,W,"center")
end

function menu:leave()
	controls:clear()
end
