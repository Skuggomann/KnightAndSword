Telekinesis = Class{
    init = function(self,collider, player)
        --self.bbox = collider:addRectangle(x,y,32,32, facing)
        --self.bbox.type = "telekinesis"
        --self.bbox.ref = self
        self.player = player
        self.collider = collider

        self.manacost = 20
        self.MAXCOOLDOWN = 0.5
        self.cooldown = 0

        --self.image = love.graphics.newImage('assets/art/TelekinesisHand.png')
        --self.fimage = love.graphics.newImage('assets/art/Telekinesis-animation.png')
        --self.g = anim8.newGrid(30, 30, 68, 34, -2,-2,4)
        --self.animation = anim8.newAnimation(self.g('1-2',1), 0.2)
        self.activeTelekinesis = nil
    end,
    
}

function Telekinesis:use()
    self.cooldown = self.MAXCOOLDOWN
    
    if self.activeTelekinesis ~= nil then
        self:drop()
        self.player.mana = self.player.mana+self.manacost
        return
    end



    local x, y = self.player.bbox:center()
    y = y+10
    if not self.player.facingRight then
        x = x - 30
    else
        x = x + 30
    end
    for _, shape in ipairs(self.collider:shapesAt(x,y)) do
        if shape.type == "movable" then
            self.activeTelekinesis = shape
            self.activeTelekinesis.ref.beingHeld = true
            self.activeTelekinesis.ref.falling = false
            self.collider:setGhost(self.activeTelekinesis)
            self.player.manaregen = 0
            self.player.canAttack = false

            --self.activeTelekinesis:move(0,-10)
            return
        end
    end
    --[[
    for shape in pairs(self.collider:shapesInRange(x,y, width,height)) do
        if shape.type == "movable" then
            self.activeTelekinesis = shape
            return
        end
    end
]]--

end
function Telekinesis:drop()
    if self.activeTelekinesis ~= nil then
        for other in pairs(self.activeTelekinesis:neighbors()) do
            if other.type ~= "player" and other.type ~= "mace" and other.type ~= "sword" and self.activeTelekinesis:collidesWith(other)   then
                return false
            end
        end

        self.activeTelekinesis.ref.beingHeld = false
        self.activeTelekinesis.ref.falling = true
        self.collider:setSolid(self.activeTelekinesis)
        self.activeTelekinesis = nil
        self.player.canAttack = true
        self.player.manaregen = self.player.MAXMANAREGEN
        return true
    end
    return true
end 

function Telekinesis:update(dt)
    if self.cooldown ~= 0 then
        self.cooldown = self.cooldown - dt
        if self.cooldown <= 0 then 
            self.cooldown = 0
        end
    end

    if self.activeTelekinesis ~= nil then
        local x,y = self.player.bbox:center()
        if not self.player.facingRight then
            x = x-35
        else
            x = x+15
        end
        self.activeTelekinesis:moveTo(x+10,y-26)
        --self.activeTelekinesis:move(0,-1)
    end    
end



function Telekinesis:draw()
    --x,y = self.bbox:center()
    --x,y = x-16,y-16
    --self.animation:draw(self.fimage,x, y)
--    x, y = self.player.bbox:center()
--    if not self.player.facingRight then
--        x = x - 16
--    end

    if debug then
        local x, y = self.player.bbox:center()
        y = y+10
        if not self.player.facingRight then
            x = x - 30
        else
            x = x + 30
        end
        love.graphics.rectangle("fill",x,y,1,1)
    end
    --love.graphics.draw(self.image,x,y-10)

end