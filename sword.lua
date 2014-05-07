Sword = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,16)
        self.bbox.type = "sword"
        self.bbox.ref = self
        self.collider = collider
        self.collider:setGhost(self.bbox)
        self.MAXCOOLDOWN = 2
        self.cooldown = 0
        self.image = love.graphics.newImage("assets/art/sword.png")
        --self.bbox:setRotation(math.pi*1.5)
    end
}


function Sword:update(dt,x,y)
    self.bbox:moveTo(x,y)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown-dt
        if self.cooldown <= 0 then
            self.cooldown = 0
            self.collider:setGhost(self.bbox)
        end
    end
    --local x,y = self.bbox:center()
    --self.bbox:rotate(math.pi*dt,0, 0)
end

function Sword:draw()
    love.graphics.setColor(255,0,255, 255)
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
    --love.graphics.draw(self.image, )
end

function Sword:attack()
    self.collider:setSolid(self.bbox)
    self.cooldown = self.MAXCOOLDOWN
end

function Sword:canAttack()
    if self.cooldown <= 0 then
        return true
    end
    return false
end
function Sword:collide(dt, me, other, mtv_x, mtv_y)
    --[[if other.type == "tile" then
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
    end--]]
end