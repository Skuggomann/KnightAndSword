Player = Class{
    init = function(self, x, y,collider)
        --self.pos = {["x"] = x, ["y"] = y}
        --self.x = x
        --self.y = y
		self.bbox = collider:addRectangle(x,y,32,64)
	    self.speed = 150
	    self.hp = 3
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
    self.velocity.x = 0
end

function Player:draw()
	--love.graphics.print(string.format("x: "..tostring(self.weapons.sword)),100,100)
	self.bbox:draw("fill")
end