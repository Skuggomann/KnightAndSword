Gamestate.game = {}
local game = Gamestate.game
function game:init() -- run only once
end

function game:enter(previous) -- run every time the state is entered
end

function game:update(dt)
end

function game:draw()
    love.graphics.print(string.format("You are now playing"),10,10)
end

function game:keyreleased(key)
    if key == 'p' then
        Gamestate.push(Gamestate.pause)
    end
end