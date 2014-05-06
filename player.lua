Player = Class{
    init = function(self, x, y,collider)
		self.bbox = collider:addRectangle(x,y,32,64)
		self.bbox.type = "player"
		self.bbox.ref = self
	    self.speed = 150
	    self.hp = 2
        self.maxhp = 3
	    self.mana = 0
	    self.weapons = {["sword"] = true, ["mace"] = false}
	    self.abilities = {["frostbolt"] = true, ["cape"] = false}
	    self.canAttack = true
	    self.canMove = true
	    self.canJump = true
	    self.jumping = true
	    self.velocity = {["x"] = 0, ["y"] = 0}
	    self.invuln = 0
    end
}
function Player:update(dt)
    if love.keyboard.isDown("left") then
        self.velocity.x = -self.speed*dt
    end
    if love.keyboard.isDown("right") then
        self.velocity.x = self.speed*dt
    end
    if love.keyboard.isDown("up") and not self.jumping then

        self.velocity.y = -self.speed*5*dt
    	self.jumping = true
    end
    if love.keyboard.isDown("down") then
        self.velocity.y = self.speed*dt
    end
    if self.jumping then
    	self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    -- update movement
    self.bbox:move(self.velocity.x,self.velocity.y)

    -- update invulnerability
    if self.invuln > 0 then
    	self.invuln = self.invuln-dt
    	if self.invuln <0 then
    		self.invuln = 0
    	end
    end
end

function Player:draw()
	if self:isInvuln() then
	    love.graphics.setColor(0,255,0, 255)
	end
    self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
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
				self.velocity.x = -dt*self.speed*2
				self.bbox:move(mtv_x-5, 0)
			else
				self.velocity.x = dt*self.speed*2
				self.bbox:move(mtv_x+5, 0)
			end
			self.velocity.y = -dt*self.speed*3

			-- move
			if mtv_y < 0 then
				self.bbox:move(0, mtv_y-5)
			else
				self.bbox:move(0, mtv_y+5)
			end
		else
		    if mtv_y < 0 and self.jumping then
		    	self.jumping = false
		    	self.velocity.y = 0
		    	self.velocity.x = 0
			else
				self.velocity.y = 0
				self.velocity.x = 0
			end
			self.bbox:move(mtv_x, 0)
			self.bbox:move(0, mtv_y)
		end
	end



end
