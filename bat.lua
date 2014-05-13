Bat = Class{__includes = Enemy,
    init = function(self, x, y, collider, player)
        Enemy.init(self, x,y)
        self.pos = {["x"] = x, ["y"] = y}
        --self.bbox = collider:addRectangle(x,y,32,64)
        --self.bbox.type = "bat"
        --self.bbox.ref = self
        self.player = player
        self.collider = collider
		self.sprite = love.graphics.newImage('/assets/art/playerhed.png')
        self.activeBat = nil
        self.MAXCOOLDOWN = 1
        self.cooldown = 0
    end
}

function Bat:spawn()
    self.activeBat = self.collider:addRectangle(self.pos.x,self.pos.y,32,64)
    self.activeBat.type = "bat"
    self.activeBat.ref = self
    local x = self.player.bbox:center()
    if self.pos.x > x then
        self.activeBat.facingRight = false
    else
        self.activeBat.facingRight = true
    end
    self.activeBat.currentTime = math.random(0,4)
    self.activeBat.hp = 1
    self.activeBat.duration = 4 --how long should the sine wave be
    self.activeBat.thaw = 0
    self.activeBat.velocity = {["x"] = 0, ["y"] = 0}
    self.activeBat.speed = math.random(150,200)

end
function Bat:update(dt)
    if self.activeBat ~= nil then
        --update status effects
        if self.activeBat.thaw > 0 then
            self.activeBat.thaw = self.activeBat.thaw-dt
            if self.activeBat.thaw < 0 then
                self.activeBat.thaw = 0
            end
        end

        if self.activeBat.facingRight then
            self.activeBat.velocity.x = self.activeBat.speed
        else
            self.activeBat.velocity.x = -self.activeBat.speed
        end
        self.activeBat.currentTime = self.activeBat.currentTime+dt % self.activeBat.duration
        local pos = math.sin((math.pi *2) * (self.activeBat.currentTime / self.activeBat.duration))/2
        self.activeBat.velocity.y = self.activeBat.speed*pos
        -- update movement
        if not (self.activeBat.thaw > 0) then
            self.activeBat:move(self.activeBat.velocity.x*dt,self.activeBat.velocity.y*dt)
        end

        local playerx = self.player.bbox:center()
        local batx = self.activeBat:center()
        if playerx-1000 > batx or playerx+1000 < batx then
            self.activeBat.hp = 0 -- kill it
            print("playerx:"..playerx.." batx:"..batx)
        end

        -- check if dead
        if self.activeBat.hp <= 0 then
            self.collider:remove(self.activeBat)
            self.activeBat = nil
            self.cooldown = self.MAXCOOLDOWN
        end
    else
        if self.cooldown <= 0 then
            self:spawn()
        else
            self.cooldown = self.cooldown-dt
            if self.cooldown <= 0 then
                self.cooldown = 0
            end
        end
    end
end

function Bat:isInvuln()
    return self.invuln > 0
end
function Bat:draw()
    if self.activeBat ~= nil then
        love.graphics.setColor(255,0,0, 255)
        self.activeBat:draw("fill")
        love.graphics.setColor(255,255,255, 255)
    end
    --[[local x,y = self.bbox:center()
    if self.facingRight then
        love.graphics.draw(self.sprite, x - 16, y - 32)
    else
        love.graphics.draw(self.sprite, x + 16, y - 32, 0, -1, 1)
    end
    if self:isFrozen() then
        love.graphics.draw(self.icecube, x - 16, y - 32)
    end]]
	
end

function Bat:takeDamage(damage)
    self.hp = self.hp - damage
    self.invuln = self.MAXINVULN
end


function Bat:isDead()
    if self.hp <=0 then
        return true
    end
    return false
end

function Bat:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" or other.type == "spike" then
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