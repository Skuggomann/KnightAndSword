Skeleton = Class{__includes = Enemy,
    init = function(self, x, y, collider, gravity)
        Enemy.init(self, x,y)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "skeleton"
        self.bbox.ref = self
        self.gravity = gravity
        self.velocity.x = 3
        self.facingRight = false
		self.sprite = love.graphics.newImage('/assets/art/skeleton.png')
        self.icecube = love.graphics.newImage('/assets/art/icecube.png')
    end
}


function Skeleton:update(dt)
    --update status effects
    if self.thaw > 0 then
        self.thaw = self.thaw-dt
        if self.thaw < 0 then
            self.thaw = 0
        end
    end

    -- update invulnerability
    if self.invuln > 0 then
        self.invuln = self.invuln-dt
        if self.invuln <0 then
            self.invuln = 0
        end
    end

    if self.jumping and not self:isFrozen() then
        self.velocity.y = self.velocity.y + self.gravity*dt
    end
    if self.facingRight then
        self.velocity.x = self.speed
    else
        self.velocity.x = -self.speed
    end
    -- update movement
    if not self:isFrozen() then
        self.bbox:move(self.velocity.x*dt,self.velocity.y*dt)
    end
end

function Skeleton:isFrozen()
    if self.thaw > 0 then
        return true
    end
    return false
end 

function Skeleton:isInvuln()
    return self.invuln > 0
end
function Skeleton:draw()
    love.graphics.setColor(255,0,0, 255)
    --self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
    local x,y = self.bbox:center()
    if self.facingRight then
        love.graphics.draw(self.sprite, x - 16, y - 32)
    else
        love.graphics.draw(self.sprite, x + 16, y - 32, 0, -1, 1)
    end
    if self:isFrozen() then
        love.graphics.draw(self.icecube, x - 16, y - 32)
    end
	
end

function Skeleton:takeDamage(damage)
    self.hp = self.hp - damage
    self.invuln = self.MAXINVULN
end


function Skeleton:isDead()
    if self.hp <=0 then
        return true
    end
    return false
end

function Skeleton:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" then
        -- collision with tile(ground)
        self.bbox:move(mtv_x, 0)
        self.bbox:move(0, mtv_y)
        if mtv_x ~= 0 then
            self.facingRight = not self.facingRight
        end
        if mtv_y < 0 and self.jumping then
            self.jumping = false
            self.velocity.y = 0
        else
            self.velocity.y = 0
        end
    elseif other.type == "frostbolt" then
        self.thaw = self.MAXTHAW
    elseif other.type == "sword" then
        if not self:isInvuln() and not self:isFrozen() then
            self:takeDamage(other.ref.damage)
            if mtv_x < 0 then
                self.velocity.x = -self.speed
                self.bbox:move(mtv_x-5, 0)
            else
                self.velocity.x = self.speed
                self.bbox:move(mtv_x+5, 0)
            end
            self.velocity.y = -self.speed*2

            -- move
            if mtv_y > 0 then
                self.bbox:move(0, mtv_y+5)
            else
                self.bbox:move(0, mtv_y-5)
            end
        end
    end
end