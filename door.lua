Door = Class{
    init = function(self, x, y, collider)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "door"
        self.bbox.ref = self
        self.collider = collider
		self.spriteOpen = love.graphics.newImage('/assets/art/tiles/gateOpen.png')
        self.spriteClosed = love.graphics.newImage('/assets/art/tiles/gateClosed.png')
        self.sensors = {}
        self.isOpen = false
    end
}

function Door:update(dt)
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
    local x,y = self.bbox:center()
	
	
    if self.isOpen then
		love.graphics.draw(self.spriteOpen, x-16, y-32)
	else
        love.graphics.draw(self.spriteClosed, x-16, y-32)
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


    table.insert(self.sensors, bbbox)

end
function Door:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "player" or other.type == "skeleton" or other.type == "movable" then
        me.active = true
    end
end