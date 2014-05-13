Bat = Class{__includes = Enemy,
    init = function(self, x, y, collider, player)
        Enemy.init(self, x,y)
        self.pos = {["x"] = x, ["y"] = y}
        --self.bbox = collider:addRectangle(x,y,32,64)
        --self.bbox.type = "bat"
        --self.bbox.ref = self
        self.player = player
        self.collider = collider
		self.spriteOne = love.graphics.newImage('/assets/art/bat2down.png')
        self.spriteTwo = love.graphics.newImage('/assets/art/bat2up.png')
        self.bbox = nil
        self.MAXCOOLDOWN = 1
        self.cooldown = 0
        self.wings = 0.5
        self.wingTimer = 0
        self.wingsDown = true
    end
}

function Bat:spawn()
    self.bbox = self.collider:addRectangle(self.pos.x,self.pos.y,20,14)
    self.bbox.type = "bat"
    self.bbox.ref = self
    local x = self.player.bbox:center()
    if self.pos.x > x then
        self.bbox.facingRight = false
    else
        self.bbox.facingRight = true
    end
    self.bbox.currentTime = math.random(0,4)
    self.bbox.hp = 1
    self.bbox.duration = 4 --how long should the sine wave be
    self.bbox.thaw = 0
    self.bbox.velocity = {["x"] = 0, ["y"] = 0}
    self.bbox.speed = math.random(150,200)

end
function Bat:update(dt)
    if self.bbox ~= nil then
        --update status effects
        if self:isFrozen() then
            self.bbox.thaw = self.bbox.thaw-dt
            if self.bbox.thaw < 0 then
                self.bbox.thaw = 0
            end
        else
            --update wings
            self.wingTimer = self.wingTimer +dt
            if self.wingTimer > self.wings then
                if self.wingsDown then
                    self.wingsDown = false
                else
                    self.wingsDown = true
                end
                self.wingTimer = 0
            end
        end

        if self.bbox.facingRight then
            self.bbox.velocity.x = self.bbox.speed
        else
            self.bbox.velocity.x = -self.bbox.speed
        end
        self.bbox.currentTime = self.bbox.currentTime+dt % self.bbox.duration
        local pos = math.sin((math.pi *2) * (self.bbox.currentTime / self.bbox.duration))/2
        self.bbox.velocity.y = self.bbox.speed*pos
        -- update movement
        if not self:isFrozen() then
            self.bbox:move(self.bbox.velocity.x*dt,self.bbox.velocity.y*dt)
        end

        local playerx = self.player.bbox:center()
        local batx = self.bbox:center()
        if playerx-1000 > batx or playerx+1000 < batx then
            self.bbox.hp = 0 -- kill it
            print("playerx:"..playerx.." batx:"..batx)
        end

        -- check if dead
        if self.bbox.hp <=0 then
            self.collider:remove(self.bbox)
            self.bbox = nil
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
function Bat:isFrozen()
    if self.bbox ~= nil then
        if self.bbox.thaw > 0 then
            return true
        end
    end
    return false
end

function Bat:draw()
    if self.bbox ~= nil then
        local x,y = self.bbox:center()
        if self.bbox.facingRight then
            if self.wingsDown then
                love.graphics.draw(self.spriteOne, x - 16, y - 10)
            else
                love.graphics.draw(self.spriteTwo, x - 16, y - 22)
            end
        else
            if self.wingsDown then
                love.graphics.draw(self.spriteOne, x + 16, y - 10, 0, -1, 1)
            else
                love.graphics.draw(self.spriteTwo, x + 16, y - 22, 0, -1, 1)
            end
        end
    end


    --[[if self:isFrozen() then
        love.graphics.draw(self.icecube, x - 16, y - 32)
    end]]
	
end

function Bat:takeDamage(damage)
    if self.bbox ~= nil then
        self.bbox.hp = self.bbox.hp - damage
    end
end


function Bat:isDead()
    --[[if self.bbox ~= nil then
        if self.bbox.hp <=0 then
        print(self.bbox.hp)
            return true
        end
    end]]
    return false
end

function Bat:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "frostbolt" then
        self.bbox.thaw = self.MAXTHAW
    elseif other.type == "sword" then
        if not self:isFrozen() then
            self:takeDamage(other.ref.damage)
        end
    end
end