UI = Class{
    init = function(self, Player)
        self.player = Player
        self.textTable = {}   --1 = who, 2 = text, 3 = ttl, 
    end,
    heart = love.graphics.newImage("assets/art/LivingHeart2.png"),
    deadHeart = love.graphics.newImage("assets/art/DeadHeart2.png")
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
    if next(self.textTable) ~= nil then
        --Draw guy, and text

        --love.graphics.print(self.textTable[1], )
    end

    for i = 1, self.player.maxhp, 1 do
        if self.player.hp >= i then
            love.graphics.draw(self.heart, i*self.heart:getWidth(), 20)
        else
            love.graphics.draw(self.deadHeart, i*self.deadHeart:getWidth(), 20)
        end
    end
end

function UI:addToTable(NewTextTable)
    for i, v in ipairs(NewTextTable) do 
        table.insert(self.textTable, v)
    end
end