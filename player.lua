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
	    self.jumping = false
	    self.velocity = {["x"] = 0, ["y"] = 0}
    end
}
function Player:update(dt)
    if love.keyboard.isDown("left") then
        --hero:move(-hero.speed*dt, 0)
        self.velocity.x = -self.speed*dt
    end
    if love.keyboard.isDown("right") then
        --hero:move(hero.speed*dt, 0)
        self.velocity.x = self.speed*dt
    end
    if love.keyboard.isDown("up") and not self.jumping then

        self.velocity.y = -self.speed*5*dt
    	--hero:move(0,-dt*100)
    	self.jumping = true
    end
    if love.keyboard.isDown("down") then
    	--hero:move(0,dt*50)
        self.velocity.y = self.speed*dt
    end
    if self.jumping then
    	self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    self.bbox:move(self.velocity.x,self.velocity.y)
    --self.velocity.x = 0
end

function Player:draw()
	--love.graphics.print(string.format("x: "..tostring(self.weapons.sword)),100,100)
	self.bbox:draw("fill")
end
function Player:takeDamage(damage)
	self.hp = self.hp-damage
end
function Player:collide(dt, me, other, mtv_x, mtv_y)
	if other.type == "tile" then
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
		self:takeDamage(other.ref.damage)
		self.bbox:move(mtv_x,mtv_y)
		if mtv_x < 0 then
			self.velocity.x = -dt*self.speed*2
		else
			self.velocity.x = dt*self.speed*2
		end
		self.velocity.y = -dt*self.speed*3
	end
end
