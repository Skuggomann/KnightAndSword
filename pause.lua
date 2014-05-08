Gamestate.pause = {}
local pause = Gamestate.pause
function pause:enter(from)
    self.from = from -- record previous state
end

function pause:draw()
    -- draw previous screen
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('PAUSE', 0, H/2, W, 'center')
end

function pause:keyreleased(key)
    if key == 'p' then
        Gamestate.pop()
    elseif key == 'escape' then
        --self.from:leave()
    	Gamestate.switch(Gamestate.menu)    	
    end
end