local OFFSET = 58
TheVeil = Class{
    init = function(self, x, collider)
        self.bbox = collider:addRectangle(x-75,0,75,H)
        self.bbox.type = "TheVeil"
        self.bbox.ref = self
        self.velocityX = 60
        self.collider = collider

    end
}


function TheVeil:update(dt)
    self.bbox:move(self.velocityX*dt,0)

end

function TheVeil:draw()
    local x1,y1, x2,y2 = self.bbox:bbox()
    print(x2 .. " " .. y2)
    local quad = love.graphics.newQuad(0,0,75,H,75,128)
    love.graphics.draw(sprites.veilOfSouls, quad,x1+OFFSET,y1)
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