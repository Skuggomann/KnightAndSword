Telekinesis = Class{
    init = function(self,collider, player)
        --self.bbox = collider:addRectangle(x,y,32,32, facing)
        --self.bbox.type = "telekinesis"
        --self.bbox.ref = self
        self.player = player
        self.collider = collider
        self.MAXMANACOST = 20
        self.manacost = 20
        self.MAXCOOLDOWN = 0.5
        self.cooldown = 0
        self.bbox = collider:addRectangle(0,0,35,50)
        self.bbox.type = "telekinesis"
        --self.fimage = love.graphics.newImage('assets/art/Telekinesis-animation.png')
        --self.g = anim8.newGrid(30, 30, 68, 34, -2,-2,4)
        --self.animation = anim8.newAnimation(self.g('1-2',1), 0.2)
        self.activeTelekinesis = nil
    end,
    
}

function Telekinesis:use()
    
    if self.activeTelekinesis ~= nil then
        self:drop()
        return
    end



    local x, y = self.player.bbox:center()
   --[[y = y-10
    if not self.player.facingRight then
        x = x - 50
    else
        x = x + 10
    end]]
    --for _, shape in ipairs(self.collider:shapesAt(x,y)) do
    for shape in pairs(self.collider:shapesInRange(self.bbox:bbox())) do
        if shape.type == "movable" and shape:collidesWith(self.bbox) then
            print(x,y)
            print(shape:center())
            self.activeTelekinesis = shape
            self.activeTelekinesis.ref.beingHeld = true
            self.activeTelekinesis.ref.falling = false
            self.collider:setGhost(self.activeTelekinesis)
            self.player.manaregen = 0
            self.player.canAttack = false

            self.manacost = 0
            AudioController:playAndRewindSound("levitatepickup")
            AudioController:playSound("levitatepassive")
            --[[
            AudioController.sounds["levitatepickup"]:rewind()
            AudioController.sounds["levitatepickup"]:play()
            ]]
            --self.activeTelekinesis:move(0,-10)
            return
        end
    end
    --if self.activeTelekinesis == nil then
    self.player.mana = self.player.mana+self.manacost --end
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
            if other.type ~= "player" and other.type ~= "mace" and other.type ~= "sword" and other.type ~= "telekinesis" and self.activeTelekinesis:collidesWith(other)   then
                return false
            end
        end

        self.activeTelekinesis.ref.beingHeld = false
        self.activeTelekinesis.ref.falling = true
        self.collider:setSolid(self.activeTelekinesis)
        self.activeTelekinesis = nil
        self.player.canAttack = true
        self.player.manaregen = self.player.MAXMANAREGEN
        self.manacost = self.MAXMANACOST
        AudioController:stopSound("levitatepassive")
        AudioController:playAndRewindSound("levitatedrop")
        --[[
        AudioController.sounds["levitatedrop"]:rewind()
        AudioController.sounds["levitatedrop"]:play()
        ]]
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

    local x,y = self.player.bbox:center()
    if not self.player.facingRight then
        x = x-45
    else
        x = x+25
    end
    y = y +50
    self.bbox:moveTo(x+10,y-26)
    if self.activeTelekinesis ~= nil then
        --AudioController.sounds["levitatepassive"]:play()
        x,y = self.player.bbox:center()
        if not self.player.facingRight then
            x = x-35
        else
            x = x+15
        end
        self.activeTelekinesis:moveTo(x+10,y-16)
        --self.activeTelekinesis:move(0,-1)
    end    
end



function Telekinesis:draw()
    --x,y = self.bbox:center()
    --x,y = x-16,y-16
    --self.animation:draw(self.fimage,x, y)
    x, y = self.player.bbox:center()
    if not self.player.facingRight then
        x = x - 16
    end
    love.graphics.draw(sprites.levitateHand,x,y-10)




    if debug then
        --[[local x, y = self.player.bbox:center()
        y = y-10
        if not self.player.facingRight then
            x = x - 50
        else
            x = x + 10
        end
        love.graphics.rectangle("fill",x,y,1,1)]]
        --self.bbox:draw('fill')
    end
    --love.graphics.draw(self.image,x,y-10)

end