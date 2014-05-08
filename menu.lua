Gamestate.menu = {}
local menu = Gamestate.menu

function menu:init() -- run only once
    self.background = love.graphics.newImage('/assets/art/menubg.png')
end

function menu:enter(previous) -- run every time the state is entered
end

function menu:update(dt)
    if controls:isDown("enter") then
    	if not controls.benter then
    		--once
        	Gamestate.switch(Gamestate.levelselect)
    		controls.benter = true
    	end
    else
    	controls.benter = false
    end
end

function menu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.print(string.format("press enter(x) to play"),10,10)
end
