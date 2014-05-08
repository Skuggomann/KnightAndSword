Gamestate.death = {}
local death = Gamestate.death
function death:enter(from,x, y)
    self.from = from -- record previous state
    self.selected = 1
    self.fimage = love.graphics.newImage('assets/art/rip-small-animation.png')
    self.g = anim8.newGrid(30, 30, 204, 34, -2,-2,4)
    self.animation = anim8.newAnimation(self.g('1-6',1), {0.25, 0.25, 0.25, 0.25, 0.25, 100})
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

    if controls:isDown("up") then
        self.selected = 1
    end
    if controls:isDown("down") then
        self.selected = 2
    end
    if controls:isDown("enter") then
        if self.selected == 1 then
            Gamestate.pop()
        elseif self.selected == 2 then
            Gamestate.switch(Gamestate.menu)
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

    self.animation:draw(self.fimage, W/2-32,H/2+100,0,2,2 )
end