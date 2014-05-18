Player = Class{
    init = function(self, x, y,collider, gravity)
		self.bbox = collider:addRectangle(x,y+10,25,54)
		self.bbox.type = "player"
		self.bbox.ref = self
		self.collider = collider
	    self.speed = 200
        self.jumpHeight = -745
        self.gravity = gravity
	    self.hp = 3
        self.maxhp = 3
	    self.mana = 100
        self.maxmana = 100
        self.MAXMANAREGEN = 10
        self.manaregen = 10
	    self.weapons = {["sword"] = Sword(x,y,collider, self), ["mace"] = Mace(x,y,collider,self)}
	    self.abilities = {["frostbolt"] = Frostbolt(collider, self), ["telekinesis"] = Telekinesis(collider,self)}
        --self.allowedWeapons = {"sword","mace"}
        --self.allowedAbilities = {"frostbolt","telekinesis"}
        self.allowedWeapons = {["sword"] = true,["mace"] = true}
        self.allowedAbilities = {["frostbolt"] = true,["telekinesis"] = true}
        self.currentWeapon = "sword"
        self.currentAbility = "frostbolt"
	    self.canAttack = true
	    self.canJump = true
	    self.jumping = true
	    self.velocity = {["x"] = 0, ["y"] = 0}
	    self.invuln = 0
	    self.MAXINVULN = 1
        local grid = anim8.newGrid(32, 64, sprites.player2short:getWidth(), sprites.player2short:getHeight(), 0, 0, 0)
        self.animationWalkinR = anim8.newAnimation(grid('1-4',1), 0.3)
        self.animationWalkinL = anim8.newAnimation(grid('1-4',1), 0.3):flipH()

		--self.sword = Sword(x,y,collider, self)
        --self.frostbolt = Frostbolt(collider, self)

        self.facingRight = true
    end
}
function Player:update(dt)
	-- update controls
    if controls:isDown("left") and self:canMove() then
        self.velocity.x = -self.speed
        self.facingRight = false
    end
    if controls:isDown("right") and self:canMove() then
        self.velocity.x = self.speed
        self.facingRight = true
    end
    if controls:isDown("up") and not self.jumping and self:canMove() then
        --[[AudioController.sounds["jump"]:rewind()
        AudioController.sounds["jump"]:play()
        ]]
        AudioController:playAndRewindSoundPitchy("jump")
        self.velocity.y = self.jumpHeight
    	self.jumping = true
    end
    
    --[[if love.keyboard.isDown("down") then
        self.velocity.y = self.speed*dt
    end
    --]]

    if self.jumping then
    	self.velocity.y = self.velocity.y + self.gravity*dt
    end
    -- update movement
    self:move(self.velocity.x*dt,self.velocity.y*dt)
    -- update sword/weapon
    self.weapons["sword"]:update(dt)
    self.weapons["mace"]:update(dt)
    --self.weapons[self.currentWeapon]:update(dt)


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

    self.abilities["frostbolt"]:update(dt)
    self.abilities["telekinesis"]:update(dt)

    -- update animations
    self.animationWalkinR:update(dt)
    self.animationWalkinL:update(dt)

end
--[[
function Player:disallowWeaponsAbilities(weapons,abilities)
    for k,v in pairs(weapons) do
        local i = 1
        while i<=#self.allowedWeapons do
            if self.allowedWeapons[i] == v then table.remove(self.allowedWeapons,i)
            else
                i = i+1
            end
        end
    end
    for k,v in pairs(abilities) do
        local i = 1
        while i<=#self.allowedAbilities do
            if self.allowedAbilities[i] == v then table.remove(self.allowedAbilities,i)
            else
                i = i+1
            end
        end
    end
    for k,v in pairs(self.allowedAbilities) do
        print(v)
    end
    
end
]]
function Player:disallowWeaponsAbilities(weapons,abilities)
    for k,v in pairs(weapons) do
        for i,j in pairs(self.allowedWeapons) do
            if i == v then self.allowedWeapons[i] = false
            end
        end
    end
    for k,v in pairs(abilities) do
        for i,j in pairs(self.allowedAbilities) do
            if i == v then self.allowedAbilities[i] = false
            end
        end
    end
    --[[
    for k,v in pairs(self.allowedAbilities) do
        print(k)
        print(v)
    end
    ]]
end

function Player:attack()
	if self.weapons[self.currentWeapon]:canAttack() and self.canAttack then
        AudioController.sounds[self.currentWeapon.."hit"]:rewind()
        AudioController.sounds[self.currentWeapon.."hit"]:play()
    	self.weapons[self.currentWeapon]:attack()
    end
end

function Player:cast()
    if self.abilities[self.currentAbility].cooldown == 0 and self.mana >= self.abilities[self.currentAbility].manacost then
        self.mana = self.mana - self.abilities[self.currentAbility].manacost
        self.abilities[self.currentAbility]:use()
        self.abilities[self.currentAbility].cooldown = self.abilities[self.currentAbility].MAXCOOLDOWN
    end
end
function Player:draw()
	if self:isInvuln() then
	    love.graphics.setColor(0,255,0, 255)
	end
    --self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
	
	local x,y = self.bbox:center()
	local currentSprite

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

	-- Sets the sprite to draw depending on some variables
	if(self.jumping) then
        if not blink then
    		currentSprite = sprites.player2jumping
        else
            currentSprite = sprites.player2jumpingDmg
        end
	elseif (controls:isDown("right") or controls:isDown("left")) and not self.jumping then	
		currentSprite = nil
	else
        if not blink then
            currentSprite = sprites.player2
        else
            currentSprite = sprites.player2Dmg
        end
	end
	
	

    if currentSprite == nil then
        if not blink then
            if self.facingRight then
                self.animationWalkinR:draw(sprites.player2short, x - 16, y - 37)
            else
                self.animationWalkinL:draw(sprites.player2short, x - 16, y - 37)
            end
        else
            if self.facingRight then
                self.animationWalkinR:draw(sprites.player2shortDmg, x - 16, y - 37)
            else
                self.animationWalkinL:draw(sprites.player2shortDmg, x - 16, y - 37)
            end
        end
    else
        if self.facingRight then
            love.graphics.draw(currentSprite, x - 16, y - 37)
        else
            love.graphics.draw(currentSprite, x + 16, y - 37, 0, -1, 1)
        end
    end


	-- draw weapon... (just sword now)
	self.weapons[self.currentWeapon]:draw()
	self.abilities[self.currentAbility]:draw()
end
function Player:takeDamage(damage)
	self.hp = self.hp-damage
	self.invuln = self.MAXINVULN
    AudioController.sounds["damage"]:rewind()
    AudioController.sounds["damage"]:play()
end
function Player:recoverHealth(health)
    self.hp = self.hp+health
    if self.hp > self.maxhp then self.hp = self.maxhp end
    AudioController.sounds["healthvial"]:rewind()
    AudioController.sounds["healthvial"]:play()
end

function Player:isInvuln()
	return self.invuln > 0
end

function Player:canMove()
	return self.invuln < self.MAXINVULN-0.3 or self.invuln == 0
end

function Player:isDead()
    if self.hp <=0 then
        return true
    end
    return false
end

function Player:destructor()
	self.abilities["frostbolt"]:removeAllBolts()
	self.collider:remove(self.bbox)	
	self.collider:remove(self.weapons["sword"].bbox)
	self.collider:remove(self.weapons["mace"].bbox)
    self.collider:remove(self.abilities["telekinesis"].bbox)
end
function Player:swapWeaponsBackwards()

end

function Player:swapWeaponsBackwards()
    local found = false
    local a = next(self.allowedWeapons)
    if a == self.currentWeapon then
        for k,v in pairs(self.allowedWeapons) do
            a = next(self.allowedWeapons,k)
            if a == nil and v == true then
                self.currentWeapon = k
                AudioController.sounds["swapweapons"]:rewind()
                AudioController.sounds["swapweapons"]:play()
                return
            end
        end
    else
        for k,v in pairs(self.allowedWeapons) do
            a = next(self.allowedWeapons,k) 
            if a == self.currentWeapon or found then
                if v == true then
                self.currentWeapon = k
                AudioController.sounds["swapweapons"]:rewind()
                AudioController.sounds["swapweapons"]:play()
                return
                else
                    found = true
                end
            end
        end
    end
end
function Player:swapWeaponsForwards()
    self:swapWeaponsBackwards() --there are only 2 weapons max
    --[[
    a = next(self.allowedWeapons,self.currentWeapon)
    if a == nil then
        for k,v in pairs(self.allowedWeapons) do
            if v == true then
                self.currentWeapon = k
            end
        end
    else
        self.currentWeapon = a
    end
    ]]
end
function Player:swapAbilitiesBackwards()
    if self.currentAbility ~= "telekinesis" or self.abilities["telekinesis"]:drop() then
        local found = false
        a = next(self.allowedAbilities)
        if a == self.currentAbility then
            for k,v in pairs(self.allowedAbilities) do
                a = next(self.allowedAbilities,k)
                if a == nil and v == true then
                    AudioController.sounds["swapabilities"]:rewind()
                    AudioController.sounds["swapabilities"]:play()
                    self.currentAbility = k
                    return
                end
            end
        else
            for k,v in pairs(self.allowedAbilities) do
                a = next(self.allowedAbilities,k) 
                if a == self.currentAbility then
                    if v == true then
                        AudioController.sounds["swapabilities"]:rewind()
                        AudioController.sounds["swapabilities"]:play()
                        self.currentAbility = k
                        return
                    else
                        found = true
                    end
                end
            end
        end
    end
end

function Player:swapAbilitiesForwards()
    self:swapAbilitiesBackwards() --there are only 2 abilities max
    --[[
    if self.currentAbility ~= "telekinesis" or self.abilities["telekinesis"]:drop() then
        a = next(self.abilities,self.currentAbility)
        if a == nil then
            self.currentAbility = next(self.abilities)
        else
            self.currentAbility = a
        end
    end
    ]]
end


function Player:collisionWithSolid(mtv_x,mtv_y)
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
function Player:knockback(mtv_x,mtv_y)
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

function Player:move(x,y)
    self.bbox:move(x,y)
end
function Player:collide(dt, me, other, mtv_x, mtv_y)
	if other.type == "tile" or other.type == "breakable" or other.type == "movable" then
		self:collisionWithSolid(mtv_x,mtv_y)
	elseif other.type == "spike" then
		if not self:isInvuln() then
			self:knockback(mtv_x,mtv_y)
			self:takeDamage(1) --1 damage for hitting spikes
		else
			self:collisionWithSolid(mtv_x,mtv_y)
		end
    elseif other.type == "door" then
        if not other.ref.isOpen then
            self:collisionWithSolid(mtv_x,mtv_y)
        end
	elseif other.type == "skeleton" or other.type == "bat" then
		-- collision with skeleton
		if not self:isInvuln() and not other.ref:isFrozen() then
			self:takeDamage(other.ref.damage)
			self:knockback(mtv_x,mtv_y)
		elseif other.ref:isFrozen() then
			-- collision with frozen skeleton same as tile(ground)
			self:collisionWithSolid(mtv_x,mtv_y)
		end
    elseif other.type == "healthvial" then
        if self.hp < self.maxhp then
            self:recoverHealth(1)
            other.ref.pickedUp = true
        end
    elseif other.type =="TheVeil" then
        self:takeDamage(100)
	elseif other.type == "end" then
		winGame()
	end
end
