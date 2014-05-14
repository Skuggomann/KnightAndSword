TheVeil = Class{
    init = function(self, x, collider)
        self.bbox = collider:addRectangle(x,0,128,H)
        self.bbox.type = "TheVeil"
        self.bbox.ref = self
        self.velocity.x = 3
		--self.sprite = love.graphics.newImage('/assets/art/.png')

    end
}


function TheVeil:update(dt)
    self.bbox:move(self.velocity,x,0)

end

function TheVeil:draw()
    love.graphics.setColor(255,0,0, 255)
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
    local x,y = self.bbox:center()
    --love.graphics.draw(self.sprite, x - 16, y - 32)


	
end


function TheVeil:collide(dt, me, other, mtv_x, mtv_y)

end