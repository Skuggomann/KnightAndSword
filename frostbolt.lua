Frostbolt = Class{
    init = function(self,collider, player)
        --self.bbox = collider:addRectangle(x,y,32,32, facing)
        --self.bbox.type = "frostbolt"
        --self.bbox.ref = self
        self.player = player
        self.collider = collider

        self.manacost = 50
        self.MAXCOOLDOWN = 1
        self.cooldown = 0

        self.g = anim8.newGrid(30, 30, 68, 34, -2,-2,4)
        --self.animation = anim8.newAnimation(self.g('1-2',1), 0.2)
        self.activeFrostbolts = {}
    end,
    
}

function Frostbolt:use()
    x, y = self.player.bbox:center()
    if not self.player.facingRight then
        x = x - 8
    end
    local bbbox = self.collider:addRectangle(x,y-12,16,16)
    bbbox.type = "frostbolt"
    bbbox.ref = self
    bbbox.speed = 350
    bbbox.animation = anim8.newAnimation(self.g('1-2',1), 0.2)
    bbbox.facingRight =self.player.facingRight
    bbbox.ttl = 5

    table.insert(self.activeFrostbolts, bbbox)
    AudioController:playAndRewindSound("frostboltcast")
    --[[
    AudioController.sounds["frostboltcast"]:rewind()
    AudioController.sounds["frostboltcast"]:play()
    ]]
end

function Frostbolt:update(dt)
    --[[
    if self.jumping then
        self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    -- update movement
    self.bbox:move(self.velocity.x,self.velocity.y)

    ]]--
    --self.bbox:move(self.velocity.x/dt,self.velocity.y/dt)
    --self.animation:update(dt)
    if self.cooldown ~= 0 then
        self.cooldown = self.cooldown - dt
        if self.cooldown <= 0 then 
            self.cooldown = 0
        end
    end

    local i = 1
    while i <= #self.activeFrostbolts do
        self.activeFrostbolts[i].ttl = self.activeFrostbolts[i].ttl - dt
        if self.activeFrostbolts[i].ttl <= 0 then   --TTL is over
            self.collider:remove(self.activeFrostbolts[i])
            table.remove(self.activeFrostbolts,i)
        else

            if self.activeFrostbolts[i].facingRight then
                self.activeFrostbolts[i]:move(self.activeFrostbolts[i].speed*dt,0)
            else
                self.activeFrostbolts[i]:move(self.activeFrostbolts[i].speed*-dt,0)
            end
            self.activeFrostbolts[i].animation:update(dt)
            i = i+1
        end
    end
end

function Frostbolt:removeAllBolts()
    local i = 1
    while i <= #self.activeFrostbolts do
        self.collider:remove(self.activeFrostbolts[i])
        table.remove(self.activeFrostbolts,i)
    end
end


function Frostbolt:draw()
    --x,y = self.bbox:center()
    --x,y = x-16,y-16
    --self.animation:draw(self.fimage,x, y)
    x, y = self.player.bbox:center()
    if not self.player.facingRight then
        x = x - 16
    end
    love.graphics.draw(sprites.frostboltHand,x,y-10)

    for i = 1, #self.activeFrostbolts do
        -- do not draw bounding box
        --love.graphics.setColor(0,0,255, 255)
        --self.activeFrostbolts[i]:draw("fill")
        --love.graphics.setColor(255,255,255, 255)

        x,y = self.activeFrostbolts[i]:center()
        if self.activeFrostbolts[i].facingRight then
            self.activeFrostbolts[i].animation:draw(sprites.frostbolt_animation,x-22, y-15)
        else
            self.activeFrostbolts[i].animation:draw(sprites.frostbolt_animation,x+22, y-15,0,-1,1)
        end
        --x,y = x-16,y-16
        --self.animation:draw(self.fimage,x, y)

    end
end
function Frostbolt:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" or other.type == "skeleton" or other.type == "bat" then
        if other.type=="tile" then
            AudioController:playAndRewindSound("frostbolthitwalls")
            --[[ 
            AudioController.sounds["frostbolthitwalls"]:rewind()
            AudioController.sounds["frostbolthitwalls"]:play()
            ]]
        else
            AudioController:playAndRewindSound("frostbolthitenemy")
            --[[
            AudioController.sounds["frostbolthitenemy"]:rewind()
            AudioController.sounds["frostbolthitenemy"]:play()
            ]]
        end
        me.ttl = 0
    end
end