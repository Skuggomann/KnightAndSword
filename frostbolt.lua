Frostbolt = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,32, facing)
        self.bbox.type = "frostbolt"
        self.bbox.ref = self
        self.velocity = {}
        self.velocity.x = 3
        self.velocity.y = 0
        self.fimage = love.graphics.newImage('assets/art/Frostbolt-animation.png')
        self.g = anim8.newGrid(32, 32, 68, 34, -1,-1,2)
        self.animation = anim8.newAnimation(self.g('1-2',1), 0.2)
    end,
    
}


function Frostbolt:update(dt)
    --[[
    if self.jumping then
        self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    -- update movement
    self.bbox:move(self.velocity.x,self.velocity.y)

    ]]--
    self.bbox:move(self.velocity.x,self.velocity.y)
    self.animation:update(dt)
end

function Frostbolt:draw()
    x,y = self.bbox:center()
    x,y = x-16,y-16
    self.animation:draw(self.fimage,x, y)
end
function Frostbolt:collide(dt, me, other, mtv_x, mtv_y)
    --[[
    if other.type == "tile" then
        -- collision with tile(ground)
        self.bbox:move(mtv_x, 0)
        self.bbox:move(0, mtv_y)
        if mtv_x ~= 0 then
            self.velocity.x = -self.velocity.x
        end
        if mtv_y < 0 and self.jumping then
            self.jumping = false
            self.velocity.y = 0
        else
            self.velocity.y = 0
        end
    end
    ]]--
end