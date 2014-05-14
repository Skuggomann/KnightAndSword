UI = Class{
    init = function(self, Player)
        self.player = Player
        self.textTable = {}   --1 = who, 2 = text, 3 = ttl, 
    end,
    heart = love.graphics.newImage("assets/art/LivingHeart2.png"),
    deadHeart = love.graphics.newImage("assets/art/DeadHeart2.png"),
    sword = love.graphics.newImage("assets/art/sword.png"),
    frostbolt = love.graphics.newImage("assets/art/Frostbolt1.png"),
    playerhed = love.graphics.newImage("assets/art/playerhed.png"),
    mace = love.graphics.newImage("assets/art/blackMaceA.png")

}

function UI:update(dt)
    if next(self.textTable) ~= nil then  --check if table is empty
        self.textTable[3] = self.textTable[3] - dt  --lower the ttl of the next text
        if self.textTable[3] <= 0 then --remove the next who,text and ttl
            table.remove(self.textTable, 1)
            table.remove(self.textTable, 1)
            table.remove(self.textTable, 1)
        end
    end
end

function UI:draw()
    --Talkbox if needed
    if next(self.textTable) ~= nil then
        --Draw guy, and text
        
        love.graphics.setColor(0,0,0,128)
        love.graphics.rectangle("fill", 100,H-132, 64,64)
        love.graphics.rectangle("fill", 164,H-132, 512+256,64)
        love.graphics.setColor(128,128,128,255)
        love.graphics.rectangle("line", 100,H-132, 64,64)
        love.graphics.rectangle("line", 164,H-132, 1016,64)
        love.graphics.setColor(255,255,255,255)

        if self.textTable[1] == "sword" then 
            love.graphics.draw(self.sword, 118, H-68, math.pi * 1.5, 2, 2)

        elseif self.textTable[1] == "player" then 
            love.graphics.draw(self.playerhed, 100, H-132, 0,2,2)
        else
            love.graphics.print(self.textTable[1], 100, H-100) -- Placeholder for image of talker
        end
        love.graphics.print(self.textTable[2], 170, H-128) -- Print what he says
        

    end

    --Draw Hearts
    for i = 1, self.player.maxhp, 1 do
        if self.player.hp >= i then
            love.graphics.draw(self.heart, i*self.heart:getWidth(), 20)
        else
            love.graphics.draw(self.deadHeart, i*self.deadHeart:getWidth(), 20)
        end
    end
    --Draw Manabar
    --love.graphics.setColor(128,128,128,255)
    --love.graphics.rectangle("fill", 32,50, 100,32)
    love.graphics.setColor(0,0,255,196)
    love.graphics.rectangle("fill", 32,64, 100*self.player.mana/self.player.maxmana,32)

    love.graphics.setColor(255,255,255,196)
    love.graphics.rectangle("line", 32,64, 100,32)


    realweapon, realability = self.player.weapons[self.player.currentWeapon], self.player.abilities[self.player.currentAbility]

    --Draw Abilities/Weapon
    love.graphics.setColor(0,0,0,128)
    love.graphics.rectangle("fill", W-100,20, 66,66)
    love.graphics.rectangle("fill", W-200,20, 66,66)
    love.graphics.setColor(128,128,128,255)
    love.graphics.rectangle("line", W-100,20, 66,66)
    love.graphics.rectangle("line", W-200,20, 66,66)
    love.graphics.setColor(255,255,255,255)

    weapon, ability = self:getWeaponAbility()
    love.graphics.draw(weapon, W-99,39,0,2,2)
    love.graphics.draw(ability, W-199,21,0,2,2)

    love.graphics.setColor(0,64,255,128)
    love.graphics.rectangle("fill", W-100,20, 66*realweapon.cooldown/realweapon.MAXCOOLDOWN,66)
    love.graphics.rectangle("fill", W-200,20, 66*realability.cooldown/realability.MAXCOOLDOWN,66)
    love.graphics.setColor(255,255,255,255)

end

function UI:addToTable(NewTextTable)
    for i, v in ipairs(NewTextTable) do 
        table.insert(self.textTable, v)
    end
end

function UI:getWeaponAbility(Name)
    weapon, ability = nil,nil
    if self.player.currentWeapon == "sword" then
        weapon = self.sword 
    elseif self.player.currentWeapon == "mace" then
        weapon = self.mace
    end
    if self.player.currentAbility == "frostbolt" then
        ability = self.frostbolt
    elseif self.player.currentAbility == "telekinesis" then
        ability = self.mace
    end

    return weapon,ability
end
