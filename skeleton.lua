Skeleton = Class{__includes = Enemy,
    init = function(self, x, y, collider)
        Enemy.init(self, x,y)
        self.bbox = collider:addRectangle(x,y,32,64)
        self.bbox.type = "skeleton"
        self.bbox.ref = self
        self.velocity.x = 3
        self.facingRight = false
		self.sprite = love.graphics.newImage('/assets/art/skeleton.png')
    end
}


function Skeleton:update(dt)
    --update status effects
    if self.thaw > 0 then
        self.thaw = self.thaw-dt
        if self.thaw < 0 then
            self.thaw = 0
        end
    end
    if self.jumping then
        self.velocity.y = self.velocity.y + self.speed/4*dt
    end
    if self.facingRight then
        self.velocity.x = self.speed*dt
    else
        self.velocity.x = -self.speed*dt
    end
    -- update movement
    if not self:isFrozen() then
        self.bbox:move(self.velocity.x,self.velocity.y)
    end
end

function Skeleton:isFrozen()
    if self.thaw > 0 then
        return true
    end
    return false
end 

function Skeleton:draw()
    love.graphics.setColor(255,0,0, 255)
    --self.bbox:draw("fill")
    love.graphics.setColor(255,255,255, 255)
	local x,y = self.bbox:center()
	love.graphics.draw(self.sprite, x - 16, y - 32)
	
end
function Skeleton:collide(dt, me, other, mtv_x, mtv_y)
    if other.type == "tile" then
        -- collision with tile(ground)
        self.bbox:move(mtv_x, 0)
        self.bbox:move(0, mtv_y)
        if mtv_x ~= 0 then
            self.facingRight = not self.facingRight
        end
        if mtv_y < 0 and self.jumping then
            self.jumping = false
            self.velocity.y = 0
        else
            self.velocity.y = 0
        end
    elseif other.type == "frostbolt" then
        self.thaw = self.MAXTHAW
    end
end