Gamestate.death = {}
local death = Gamestate.death
function death:enter(from,x, y)
    self.from = from -- record previous state
    self.selected = 1
    self.fimage = love.graphics.newImage('assets/art/rip-small-animation.png')
    self.g = anim8.newGrid(32, 32, 204, 34, -1,-1,2)
    self.animTime = 0.6
    self.fadeTime = 4
    self.fadeTimedx = 0
    self.x = x
    self.y = y
end

function death:update(dt)
    if self.fadeTimedx < self.fadeTime then
        self.fadeTimedx = self.fadeTimedx+dt
        if self.fadeTimedx >= self.fadeTime then
            self.fadeTimedx = self.fadeTime
        end
    end
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
end

function death:keyreleased(key)
    if key == 'up' then
        self.selected = 1
    end
    if key == 'down' then
        self.selected = 2
    end
    if controls.enter then
        --self.from:leave()
    	Gamestate.switch(Gamestate.menu)    	
    end
end