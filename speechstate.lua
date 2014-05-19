Gamestate.speechstate = {}
local speechstate = Gamestate.speechstate

function speechstate:init() -- run only once
end

--textTable = array of arrays, latter is [1] = who, [2] = what he says
function speechstate:enter(from,ui,textTable) -- run every time the state is entered
    self.from = from
    self.ui = ui
    self.textTable = textTable
    controls:clear()
    self:registerSignals()
end
function speechstate:registerSignals()
    Signal.register('enter', function()
        table.remove(self.textTable, 1)
    end)
    Signal.register('start', function()
        controls:clear()
        Gamestate.push(Gamestate.pause)
    end)
end

function speechstate:leave()
    controls:clear()
end
function speechstate:update(dt)
    if next(self.textTable) == nil then  --check if table is empty
        Gamestate.pop()
        Gamestate:registerSignals()
    end
end

function speechstate:draw()
    self.from:draw()
    
    love.graphics.setColor(0,0,0, 200)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    --Talkbox if needed
    if next(self.textTable) ~= nil then
        --Draw guy, and text
        
        love.graphics.setColor(0,0,0,128)
        love.graphics.rectangle("fill", 100,H-132, 64,64)
        love.graphics.rectangle("fill", 164,H-132, 512+256,64)
        love.graphics.setColor(128,128,128,255)
        love.graphics.rectangle("line", 100,H-132, 64,64)
        love.graphics.rectangle("line", 164,H-132, 1016,64)
        love.graphics.setColor(255,255,255,255)

        if self.textTable[1][1] == "sword" then 
            love.graphics.draw(sprites.sword, 118, H-68, math.pi * 1.5, 2, 2)

        elseif self.textTable[1][1] == "player" then 
            love.graphics.draw(sprites.playerhed, 100, H-132, 0,2,2)
        else
            love.graphics.print(self.textTable[1][1], 100, H-100) -- Placeholder for image of talker
        end
        love.graphics.print(self.textTable[1][2], 170, H-128) -- Print what he says
    end
end