Skeleton = Class{__includes = Enemy,
    init = function(self, x, y, collider)
        Enemy.init(self, x,y)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "skeleton"
        self.bbox.ref = self
    end
}


function Skeleton:update(dt)
    print("Skeleton update not implemented")
end

function Skeleton:draw()
    love.graphics.setColor(255,0,0, 255)
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
end