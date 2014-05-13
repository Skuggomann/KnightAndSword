Mace = Class{
    init = function(self, x, y, collider, player)
        self.bbox = collider:addRectangle(x+25,y-26,45,50)
        self.bbox.type = "mace"
        self.bbox.ref = self
        self.collider = collider
        self.collider:setGhost(self.bbox)
        self.player = player
        self.MAXCOOLDOWN = 1
        self.damage = 1
        self.cooldown = 0
        self.isGhost = true
        self.image = love.graphics.newImage("assets/art/blackMaceA.png")
        --self.bbox:setRotation(math.pi*1.5)
    end
}


function Mace:update(dt)
    -- move weapon
    local x,y = self.player.bbox:center()
    if not self.player.facingRight then
        x = x-45
    else
        x = x+25
    end
    self.bbox:moveTo(x+10,y-26)


    if self.cooldown > 0 then
        self.cooldown = self.cooldown-dt
        if self.cooldown <= 0.8 and not self.isGhost then
            self.collider:setGhost(self.bbox)
            self.isGhost = true
        end
        if self.cooldown <= 0 then
            self.cooldown = 0
        end
    end
    --local x,y = self.bbox:center()
    --self.bbox:rotate(math.pi*dt,0, 0)
end
function Mace:moveTo(x,y)
    self.bbox:moveTo(x+10,y-26)
end

function Mace:draw()
    love.graphics.setColor(255,0,255, 255)
    --self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
    x,y = self.bbox:center()
    if self.player.facingRight then
        love.graphics.draw(self.image, x-26, y+18, math.pi*1.5+math.pi*0.5*self.cooldown/self.MAXCOOLDOWN, 1, 1, 8)
    else
        love.graphics.draw(self.image, x+26, y+18, -math.pi*1.5-math.pi*0.5*self.cooldown/self.MAXCOOLDOWN, -1, 1, 8)
    end


end

function Mace:attack()
    self.collider:setSolid(self.bbox)
    self.cooldown = self.MAXCOOLDOWN
    self.isGhost = false
end

function Mace:canAttack()
    if self.cooldown <= 0 then
        return true
    end
    return false
end
function Mace:collide(dt, me, other, mtv_x, mtv_y)
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