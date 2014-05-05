Enemy = Class{
    init = function(self, x, y)
        --self.pos = {["x"] = x, ["y"] = y}
        self.x = x
        self.y = y
        self.speed = 50
        self.hp = 3
        self.mana = 0
        self.canAttack = true
        self.canMove = true
        self.canJump = true
        self.jumping = false
        self.velocity = {["x"] = 0, ["y"] = 0}
        self.status = nil  --frozen/whatevs
    end
}

function Enemy:update(dt)

end

function Enemy:draw()

end