Gamestate.death = {}
local death = Gamestate.death
function death:enter(from)
    self.from = from -- record previous state
    self.selected = 1
    self.g = anim8.newGrid(30, 30, sprites.rip_small_animation:getWidth(), sprites.rip_small_animation:getHeight(), -2,-2,4)
    self.animation = anim8.newAnimation(self.g('1-11',1), 0.1, function() self.animation:pauseAtEnd() end)
    self.fadeTime = 4
    self.fadeTimedx = 0

    Signal.register('enter', function()
        if self.selected == 1 then
            Gamestate.pop()
            Gamestate:registerSignals()
        elseif self.selected == 2 then
            Gamestate.switch(Gamestate.menu)
        end
    end)
    Signal.register('up', function()
        self.selected = 1
    end)
    Signal.register('down', function()
        self.selected = 2
    end)
end
function death:leave()
    controls:clear()
end
function death:update(dt)
    if self.fadeTimedx < self.fadeTime then
        self.fadeTimedx = self.fadeTimedx+dt
        if self.fadeTimedx >= self.fadeTime then
            self.fadeTimedx = self.fadeTime
        end
    end
    self.animation:update(dt)
end

function death:draw()
    -- draw previous screen
    --self.from:draw()
    -- overlay with pause message
    fade = self.fadeTimedx/self.fadeTime
    love.graphics.setFont(Font36p)
    love.graphics.setColor(255,255,255,255*fade)
    love.graphics.printf('YOU ARE DEAD', 0, H/2-200, W, 'center')
    love.graphics.setFont(Font18p)

    if self.selected == 1 then
        love.graphics.setColor(255,255,255,255*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('retry', 0, H/2-32, W, 'center')
    else
        love.graphics.setColor(255,255,255,128*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('retry', 0, H/2-32, W, 'center')
    end
    if self.selected == 2 then
        love.graphics.setColor(255,255,255,255*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('quit to main menu', 0, H/2, W, 'center')
    else
        love.graphics.setColor(255,255,255,128*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('quit to main menu', 0, H/2, W, 'center')
    end
    love.graphics.setColor(255,255,255,255)

    self.animation:draw(sprites.rip_small_animation, W/2-32,H/2+100,0,2,2 )
end
