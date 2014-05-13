Breakable = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,32)
        self.bbox.type = "breakable"
        self.bbox.ref = self
        self.hp = 3
        self.invuln = 0
        self.MAXINVULN = 0.3
        self.sprite = love.graphics.newImage('/assets/art/tiles/block.png')
    end
}

function Breakable:update(dt)
    -- update invulnerability
    if self.invuln > 0 then
        self.invuln = self.invuln-dt
        if self.invuln <0 then
            self.invuln = 0
        end
    end
end

function Breakable:draw()
    local x,y = self.bbox:center()
    love.graphics.draw(self.sprite, x-16, y-16)
    if self:isInvuln() then
        love.graphics.setColor(255,0,0, 120)
    else
        love.graphics.setColor(0,255,0, 120)
    end
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
end

function Breakable:takeDamage(damage)
    self.hp = self.hp - damage
    self.invuln = self.MAXINVULN
end

function Breakable:isDead()
    if self.hp <=0 then
        return true
    end
    return false
end
function Breakable:isInvuln()
    return self.invuln > 0
end
function Breakable:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "mace" and not self:isInvuln() then
        self:takeDamage(other.ref.bluntDamage)
    end
end