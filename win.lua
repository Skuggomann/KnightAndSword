Gamestate.win = {}
local win = Gamestate.win
local selected = 1
function win:enter(from, time)
    self.from = from -- record previous state
    self.fadeTime = 4
    self.fadeTimedx = 0
    --ti, tf = math.modf(time*10)
    --tmp = math.ceil(time*10)
    self.time = math.floor(time*10)/10
    self.curlevel = curlevel
    self.islastlevel = Gamestate.levelselect:isLastLevel()
    if islastlevel then 
        selected = 3
    end
end

function win:update(dt)
    if self.fadeTimedx < self.fadeTime then
        self.fadeTimedx = self.fadeTimedx+dt
        if self.fadeTimedx >= self.fadeTime then
            self.fadeTimedx = self.fadeTime
        end
    end

    if controls:isDown("up") then
        if not controls.bup then
            --once
            selected = (selected-1)
            if self.islastlevel and selected == 1 then
                selected = 3
            end
            if selected == 0 then
                selected = 3
            end
            controls.bup = true
        end
    else
        controls.bup = false
    end
    if controls:isDown("down") then
        if not controls.bdown then
            --once
            selected = (selected+1)
            if selected == 4 then
                if self.islastlevel then
                    selected = 2
                else
                    selected = 1
                end
            end
            controls.bdown = true
        end
    else
        controls.bdown = false
    end
    if controls:isDown("enter") then
        if not controls.benter then
            --once
            if selected == 1 then 
                --nextelevel
            Gamestate.levelselect:switchToNextLevel()
            elseif selected == 2 then
                --retry
                self.from:reset()
                Gamestate.pop()
            elseif selected == 3 then
                --quit to main menu
                Gamestate.switch(Gamestate.menu)
            end
            controls.benter = true
        end
    else
        controls.benter = false
    end
end

function win:draw()
    -- draw previous screen
    --self.from:draw()
    -- overlay with pause message
    fade = self.fadeTimedx/self.fadeTime
    love.graphics.setFont(Font36p)
    love.graphics.setColor(255,255,255,255*fade)
    love.graphics.printf('YOU ARE WINNAR\nYou finished the level in: '.. self.time ..' seconds', 0, H/2-200, W, 'center')
    love.graphics.setFont(Font18p)

    if not self.islastlevel then
        if selected == 1 then
            love.graphics.setColor(255,255,255,255*self.fadeTimedx/self.fadeTime)
            love.graphics.printf('Next level', 0, H/2-32, W, 'center')
        else
            love.graphics.setColor(255,255,255,128*self.fadeTimedx/self.fadeTime)
            love.graphics.printf('Next level', 0, H/2-32, W, 'center')
        end
    end
    if selected == 2 then
        love.graphics.setColor(255,255,255,255*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('retry', 0, H/2, W, 'center')
    else
        love.graphics.setColor(255,255,255,128*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('retry', 0, H/2, W, 'center')
    end
    if selected == 3 then
        love.graphics.setColor(255,255,255,255*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('quit to main menu', 0, H/2+32, W, 'center')
    else
        love.graphics.setColor(255,255,255,128*self.fadeTimedx/self.fadeTime)
        love.graphics.printf('quit to main menu', 0, H/2+32, W, 'center')
    end
    love.graphics.setColor(255,255,255,255)

end
