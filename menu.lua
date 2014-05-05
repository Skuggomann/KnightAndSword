Gamestate.menu = {}
local menu = Gamestate.menu
function menu:init() -- run only once
    self.background = love.graphics.newImage('/assets/art/menubg.png')
end

function menu:enter(previous) -- run every time the state is entered
end

function menu:update(dt)
end

function menu:draw()
    love.graphics.draw(self.background, 0, 0)
    love.graphics.print(string.format("press enter to play"),10,10)
end

function menu:keyreleased(key)
    if key == 'return' then
        Gamestate.switch(Gamestate.levelselect)
    end
end
