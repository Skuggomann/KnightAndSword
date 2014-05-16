Door = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "door"
        self.bbox.ref = self
        self.collider = collider
        self.sensors = {}
        self.isOpen = false
    end
}

function Door:update(dt)
    for i = 1,#self.sensors do
        if self.sensors[i].delay > 0 then
            self.sensors[i].delay = self.sensors[i].delay-dt
            if self.sensors[i].delay < 0 then
                self.sensors[i].delay = 0
                self.sensors[i].active = false
            end
        end
    end

    for i = 1,#self.sensors do
        if self.sensors[i].active then
            self.isOpen = true
        else
            self.isOpen = false
            break
        end
    end
end

function Door:draw()
    for i = 1, #self.sensors do
        x,y = self.sensors[i]:center()
        if self.sensors[i].active then
            love.graphics.draw(sprites.gateButtonDown, x-16, y-16)
        else
            love.graphics.draw(sprites.gateButtonUp, x-16, y-16)
        end
    end

    local x,y = self.bbox:center()
	
    if self.isOpen then
        love.graphics.draw(sprites.gateOpen, x-16, y-32)
    else
        love.graphics.draw(sprites.gateClosed, x-16, y-32)
    end
	for i = 1,#self.sensors do
        if self.sensors[i].active then
            love.graphics.draw(sprites.green, x-22+(i*8), y-35)
        else
            love.graphics.draw(sprites.red, x-22+(i*8), y-35)
        end
    end


    if debug then
        if self.isOpen then
            love.graphics.setColor(0,255,0, 120)
        else
            love.graphics.setColor(255,0,0, 120)
        end
        self.bbox:draw("fill")
        for i = 1, #self.sensors do
            if self.sensors[i].active then
                love.graphics.setColor(0,255,0, 120)
            else
                love.graphics.setColor(255,0,0, 120)
            end
            self.sensors[i]:draw('fill')
        end
        love.graphics.setColor(255,255,255, 255)
    end
end

function Door:isDead()
    return false --never dies
end

function Door:destructor()
    local i = 1
    while i <= #self.sensors do
        self.collider:remove(self.sensors[i])
        table.remove(self.sensors,i)
    end
    self.collider:remove(self.bbox)
end
function Door:newSensor(x,y)
    local bbbox = self.collider:addRectangle(x,y,32,32)
    bbbox.type = "sensor"
    bbbox.ref = self
    bbbox.active = false
    bbbox.MAXDELAY = 0.1
    bbbox.delay = bbbox.MAXDELAY


    table.insert(self.sensors, bbbox)

end
function Door:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "player" or other.type == "skeleton" or other.type == "movable" then
        me.delay = 0
        me.active = true
    end
end