menu = {} -- previously: Gamestate.new()
function menu:init() -- run only once
    self.background = love.graphics.newImage('/assets/art/menubg.png')
    Buttons.initialize()
end

function menu:enter(previous) -- run every time the state is entered
end

function menu:update(dt)
end

function menu:draw()
    love.graphics.draw(self.background, 0, 0)
end

function menu:keyreleased(key)
    if key == 'enter' then
        print('gotoplay')
    end
end

return menu