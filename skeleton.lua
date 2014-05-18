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

    local blink = false
    if self.invuln <= 0.1 then
        blink = false
    elseif self.invuln <= 0.2 then
        blink = true
    elseif self.invuln <= 0.3 then
        blink = false
    elseif self.invuln <= 0.4 then
        blink = true
    elseif self.invuln <= 0.5 then
        blink = false
    elseif self.invuln <= 0.6 then
        blink = true
    elseif self.invuln <= 0.7 then
        blink = false
    elseif self.invuln <= 0.8 then
        blink = true
    elseif self.invuln <= 0.9 then
        blink = false
    elseif self.invuln <= 1 then
        blink = true
    end 

    local x,y = self.bbox:center()
    if not blink then
        if self.facingRight then
            love.graphics.draw(sprites.skeleton, x - 16, y - 32)
        else
            love.graphics.draw(sprites.skeleton, x + 16, y - 32, 0, -1, 1)
        end
    else
        if self.facingRight then
            love.graphics.draw(sprites.skeletonDmg, x - 16, y - 32)
        else
            love.graphics.draw(sprites.skeletonDmg, x + 16, y - 32, 0, -1, 1)
        end
    end
    if self:isFrozen() then
        love.graphics.draw(sprites.icecube, x - 16, y - 32)
    end
	
end

function Skeleton:takeDamage(damage)
    if damage > 0 then
        AudioController:playAndRewindSoundPitchy("skeletonhit")
        --[[
        AudioController.sounds["skeletonhit"]:rewind()
        AudioController.sounds["skeletonhit"]:play()
        ]]
        self.hp = self.hp - damage
        self.invuln = self.MAXINVULN
    end
end


function Skeleton:isDead()
    if self.hp <=0 then
        return true
    end
    return false
end

function Skeleton:move(x,y)
    self.bbox:move(x,y)
end
function Skeleton:collisionWithSolid(mtv_x,mtv_y)
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
        if self.facingRight then
            self.facingRight = false
        else
            self.facingRight = true
        end
        if self.velocity.y >0 then
            self.velocity.y = 0
        end
    elseif fromup then
        self.velocity.y = 0
        if self.velocity.y >= 0 then
            self.jumping = false
        end
    elseif fromdown then
        self.velocity.y = 0
    elseif mtv_y == 0 then
        self.velocity.x = 0
    end
end

function Skeleton:knockback(mtv_x,mtv_y)
    local fromleft = false
    local fromright = false
    local fromup = false
    local fromdown = false
    if mtv_x < 0 then fromleft = true end
    if mtv_x > 0 then fromright = true end
    if mtv_y < 0 then fromup = true end
    if mtv_y > 0 then fromdown = true end

    if fromleft then
        self.velocity.x = -self.speed
        self:move(mtv_x-5,0)
    elseif fromright then
        self.velocity.x = self.speed
        self:move(mtv_x+5, 0)
    else
        if self.velocity.x > 0 then
            self.velocity.x = -self.speed
        elseif self.velocity.x < 0 then
            self.velocity.x = self.speed
        end
    end
    self.velocity.y = -self.speed*2
    if fromup then
        self:move(0,mtv_y-5)
    elseif fromdown then
        self:move(0,mtv_y+5)
    end
end
function Skeleton:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" or other.type == "spike" or other.type == "breakable" or other.type == "movable" then
        self:collisionWithSolid(mtv_x,mtv_y)
    elseif other.type == "door" then
        if not other.ref.isOpen then
            self:collisionWithSolid(mtv_x,mtv_y)
        end
    elseif other.type == "frostbolt" then
        self.thaw = self.MAXTHAW
    elseif other.type == "sword" or other.type == "mace" then
        if not self:isInvuln() and not self:isFrozen() then
            -- ekki frosinn
            self:knockback(mtv_x,mtv_y)
            self:takeDamage(other.ref.damage)
        elseif not self:isInvuln() and self:isFrozen() then
            --frosinn
            self:takeDamage(other.ref.bluntDamage)
        end
    end
end