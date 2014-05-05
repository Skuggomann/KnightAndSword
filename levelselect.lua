Gamestate.levelselect = {}
local levelselect = Gamestate.levelselect
function levelselect:init() -- run only once
end

function levelselect:enter(previous) -- run every time the state is entered
end

function levelselect:update(dt)
end

function levelselect:draw()
    love.graphics.print(string.format("Select a level and press enter"),10,10)
end

function levelselect:keyreleased(key)
	--todo select a level and send it with the game state switch.
    if key == 'return' then
        Gamestate.switch(Gamestate.game)
    end
end
