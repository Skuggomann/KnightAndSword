HealthVial = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,32)
        self.bbox.type = "healthvial"
        self.bbox.ref = self
        self.collider = collider
        --self.collider:setGhost(self.bbox)
        self.sprite = love.graphics.newImage('/assets/art/largeHealthVial.png')
        self.pickedUp = false
    end
}

function HealthVial:update(dt)
end

function HealthVial:draw()
    local x,y = self.bbox:center()
    love.graphics.draw(self.sprite, x-16, y-16)
    if debug then
        love.graphics.setColor(255,255,255, 120)
        self.bbox:draw("fill")
        love.graphics.setColor(255,255,255, 255)
    end
end

function HealthVial:isDead()
    return self.pickedUp --never dead
end
function HealthVial:move(x,y)
    self.bbox:move(x,y)
end
function HealthVial:collisionWithSolid(mtv_x,mtv_y)
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
function HealthVial:collide(dt, me, other, mtv_x, mtv_y)
    --[[
    if other.type == "tile" or other.type == "breakable" or other.type == "spike" then
        self:collisionWithSolid(mtv_x,mtv_y)
    end
    ]]
end