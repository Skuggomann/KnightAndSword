Movable = Class{
    init = function(self, x, y, collider,gravity)
        self.bbox = collider:addRectangle(x,y,32,32)
        self.bbox.type = "movable"
        self.bbox.ref = self
        self.gravity = gravity
        self.beingHeld = false
        self.sprite = love.graphics.newImage('/assets/art/tiles/box.png')
        self.velocity = {["x"] = 0, ["y"] = 0}
        self.falling = true
    end
}

function Movable:update(dt)
    if self.falling then
        self.velocity.y = self.velocity.y + self.gravity*dt
    end


    self:move(self.velocity.x*dt,self.velocity.y*dt)
end

function Movable:draw()
    local x,y = self.bbox:center()
    love.graphics.draw(self.sprite, x-16, y-16)
    if debug then
        love.graphics.setColor(0,255,255, 120)
        self.bbox:draw("fill")
        love.graphics.setColor(255,255,255, 255)
    end
end

function Movable:isDead()
    return false --never dead
end
function Movable:move(x,y)
    self.bbox:move(x,y)
end
function Movable:collisionWithSolid(mtv_x,mtv_y)
        local fromleft = false
        local fromright = false
        local fromup = false
        local fromdown = false
        if mtv_x < 0 then fromleft = true end
        if mtv_x > 0 then fromright = true end
        if mtv_y < 0 then fromup = true end
        if mtv_y > 0 then fromdown = true end
        self:move(mtv_x, mtv_y)
        if fromleft or fromright then
            self.velocity.x = 0
            if self.velocity.y >0 then
                self.velocity.y = 0
            end
        elseif fromup then
            self.velocity.y = 0
            if self.velocity.y >= 0 then
                self.falling = false
            end
        elseif fromdown then
            self.velocity.y = 0
        elseif mtv_y == 0 then
            self.velocity.x = 0
        end
end
function Movable:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" or other.type == "breakable" or other.type == "spike" then
        self:collisionWithSolid(mtv_x,mtv_y)
    end
end