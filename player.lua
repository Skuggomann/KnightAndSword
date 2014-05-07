Player = Class{
    init = function(self, x, y,collider)
		self.bbox = collider:addRectangle(x,y,32,64)
		self.bbox.type = "player"
		self.bbox.ref = self
	    self.speed = 200
	    self.hp = 3
        self.maxhp = 3
	    self.mana = 100
        self.maxmana = 100
        self.manaregen = 10
	    self.weapons = {["sword"] = true, ["mace"] = false}
	    self.abilities = {["frostbolt"] = true, ["cape"] = false}
        self.currentWeapon = "sword"
        self.currentAbility = "frostbolt"
	    self.canAttack = true
	    self.canMove = true
	    self.canJump = true
	    self.jumping = true
	    self.velocity = {["x"] = 0, ["y"] = 0}
	    self.invuln = 0
		self.sprite = love.graphics.newImage('/assets/art/player1.png')
		self.sword = Sword(x,y,collider)
        self.frostbolt = Frostbolt(collider, self)
        self.facingRight = true
    end
}
function Player:update(dt)
	-- update controls
    if love.keyboard.isDown("left") then
        self.velocity.x = -self.speed*dt
        self.facingRight = false
    end
    if love.keyboard.isDown("right") then
        self.velocity.x = self.speed*dt
        self.facingRight = true
    end
    if love.keyboard.isDown("up") and not self.jumping then

        self.velocity.y = -20
    	self.jumping = true
    end
    if love.keyboard.isDown("down") then
        self.velocity.y = self.speed*dt
    end
    if self.jumping then
    	self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    if love.keyboard.isDown("space") and self.sword:canAttack() then
    	self.sword:attack()
    end
    -- update movement
    self.bbox:move(self.velocity.x,self.velocity.y)
    -- update weapon
    local x,y = self.bbox:center()
    if not self.facingRight then
    	x = x-25
    else
    	x = x+25
    end
    self.sword:update(dt,x,y)

    if love.keyboard.isDown("w") then
        if self.currentAbility == "frostbolt" then
            if self.frostbolt.cooldown == 0 and self.mana >= self.frostbolt.manacost then
                self.frostbolt:addBolt()
                self.frostbolt.cooldown = self.frostbolt.MAXCOOLDOWN
                self.mana = self.mana - self.frostbolt.manacost
            end
        end
    end
    -- update invulnerability
    if self.invuln > 0 then
    	self.invuln = self.invuln-dt
    	if self.invuln <0 then
    		self.invuln = 0
    	end
    end

    --update mana
    self.mana = self.mana + self.manaregen*dt
    if self.mana >= self.maxmana then 
        self.mana = self.maxmana
    end

    self.frostbolt:update(dt)
end

function Player:draw()
	if self:isInvuln() then
	    love.graphics.setColor(0,255,0, 255)
	end
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
	
	local x,y = self.bbox:center()
    if self.facingRight then
    	love.graphics.draw(self.sprite, x - 16, y - 32)
    else
        love.graphics.draw(self.sprite, x + 16, y - 32, 0, -1, 1)
    end

	-- draw weapon... (just sword now)
	self.sword:draw()
	self.frostbolt:draw()
end
function Player:takeDamage(damage)
	self.hp = self.hp-damage
	self.invuln = 2
end
function Player:isInvuln()
	return self.invuln > 0
end
function Player:collide(dt, me, other, mtv_x, mtv_y)
	if other.type == "tile" then
		-- collision with tile(ground)
		self.bbox:move(mtv_x, 0)
		self.bbox:move(0, mtv_y)
	    if mtv_y < 0 and self.jumping then
	    	self.jumping = false
	    	self.velocity.y = 0
	    	self.velocity.x = 0
		else
			self.velocity.y = 0
			self.velocity.x = 0
		end
	elseif other.type == "skeleton" then
		-- collision with skeleton
		if not self:isInvuln() then
			self:takeDamage(other.ref.damage)
			if mtv_x < 0 then
				self.velocity.x = -dt*self.speed
				self.bbox:move(mtv_x-5, 0)
			else
				self.velocity.x = dt*self.speed
				self.bbox:move(mtv_x+5, 0)
			end
			self.velocity.y = -dt*self.speed*2

			-- move
			if mtv_y > 0 then
				self.bbox:move(0, mtv_y+5)
			else
				self.bbox:move(0, mtv_y-5)
			end
		end
	elseif other.type == "end" then
		winGame()
	end

    function Player:isDead()
        if self.hp <=0 then
            return true
        end
        return false
    end

end
