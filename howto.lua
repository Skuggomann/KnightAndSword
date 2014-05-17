Gamestate.howto = {}
local howto = Gamestate.howto

function howto:init() -- run only once
    self.howtoimage = love.graphics.newImage('/assets/art/howto.png')
end

function howto:enter(from) -- run every time the state is entered
	self.from = from

    Signal.register('enter', function()
        Gamestate.pop()
        Gamestate:registerSignals()
    end)
end

function howto:leave()
    controls:clear()
end

function howto:update(dt)
end

function howto:draw()
    love.graphics.draw(self.howtoimage,0,0)
end