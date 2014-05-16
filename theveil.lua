local OFFSET = 58
TheVeil = Class{
    init = function(self, x, collider)
        self.bbox = collider:addRectangle(x-75,0,75,H)
        self.bbox.type = "TheVeil"
        self.bbox.ref = self
        self.velocityXCUR = 60
        self.velocityXMIN = 40
        self.velocityXMAX = 80
        self.increasing = false
        self.collider = collider
        self.tentacleTimer = 0
        self.TENTACLEMAX = 0.5
    end
}


function TheVeil:update(dt)
    if self.increasing then
        self.velocityXCUR = self.velocityXCUR+1
        if self.velocityXCUR >= self.velocityXMAX then
            self.increasing = false
        end 
    else
        self.velocityXCUR = self.velocityXCUR-1
        if self.velocityXCUR <= self.velocityXMIN then
            self.increasing = true
        end 
    end
    self.bbox:move(self.velocityXCUR*dt,0)
    if self.tentacleTimer >= 0 then
        self.tentacleTimer = self.tentacleTimer-dt
        if self.tentacleTimer <= 0 then
            self.tentacleTimer = self.TENTACLEMAX
        end
    end

end

function TheVeil:draw()
    local x1,y1, x2,y2 = self.bbox:bbox()
    local sprite = nil

    if self.tentacleTimer <= 0.1 then
        sprite = sprites.veilOfSouls
    elseif self.tentacleTimer <= 0.2 then
        sprite = sprites.veilOfSouls2
    elseif self.tentacleTimer <= 0.3 then
        sprite = sprites.veilOfSouls3
    elseif self.tentacleTimer <= 0.4 then
        sprite = sprites.veilOfSouls2
    elseif self.tentacleTimer <= 0.5 then
        sprite = sprites.veilOfSouls
    end
    local quad = love.graphics.newQuad(0,0,75,H,75,128)
    love.graphics.draw(sprite, quad,x1+OFFSET,y1)

    if debug then
        love.graphics.setColor(255,0,0, 192)
        self.bbox:draw("fill")
        love.graphics.setColor(255,255,255, 255)
    end
    love.graphics.setColor(0,0,0, 255)
    love.graphics.rectangle("fill",x1+OFFSET,y1,-W,H)

    --self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)


    --local x,y = self.bbox:center()
    --love.graphics.draw(self.sprite, x - 16, y - 32)


	
end
function TheVeil:destroy()
    self.collider:remove(self.bbox)
end

function TheVeil:collide(dt, me, other, mtv_x, mtv_y)

end