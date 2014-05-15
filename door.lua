Door = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "door"
        self.bbox.ref = self
        self.collider = collider
        self.sprite = love.graphics.newImage('/assets/art/tiles/door.png')
    end
}

function Door:update(dt)
end

function Door:draw()
    local x,y = self.bbox:center()
    love.graphics.draw(self.sprite, x-16, y-16)
    love.graphics.setColor(0,255,0, 120)
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
end

function Door:isDead()
    return false --never dies
end
function Door:collide(dt, me, other, mtv_x, mtv_y)
end