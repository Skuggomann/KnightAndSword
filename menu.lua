Gamestate.menu = {}
local menu = Gamestate.menu

function menu:init() -- run only once
end

function menu:enter(previous) -- run every time the state is entered
	Signal.register('enter', function()
    	Gamestate.switch(Gamestate.levelselect)
	end)
end

function menu:update(dt)
end

function menu:draw()
    love.graphics.draw(sprites.menubg, 0, 0)
    love.graphics.print(string.format("press enter(x) to play"),10,10)
end

function menu:leave()
	controls:clear()
end
