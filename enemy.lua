Enemy = Class{
    init = function(self, x, y)
        self.speed = 50
        self.hp = 2
        self.mana = 0
        self.canAttack = true
        self.canMove = true
        self.canJump = true
        self.jumping = false
        self.velocity = {["x"] = 0, ["y"] = 0}
        self.status = nil  --frozen/whatevs
        self.damage = 1
    end
}

function Enemy:update(dt)
    print("Enemy update not implemented")
end

function Enemy:draw()
    print("Enemy draw not implemented")
end