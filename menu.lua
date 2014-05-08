Gamestate.menu = {}
local menu = Gamestate.menu
local enter = false
function menu:init() -- run only once
    self.background = love.graphics.newImage('/assets/art/menubg.png')
end

function menu:enter(previous) -- run every time the state is entered
end

function menu:update(dt)
    if controls:isDown("enter") then
    	if not enter then
    		--once
	    	local filename = levels[selected].filename
	        Gamestate.switch(Gamestate.game,filename)
    		enter = true
    	end
    else
    	enter = false
    end
end

function menu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.print(string.format("press enter to play"),10,10)
end

function menu:keyreleased(key)
    if key == 'return' or key == 'kpenter' then
        Gamestate.switch(Gamestate.levelselect)
    end
end
