Enemy = Class{
    init = function(self, x, y)
        self.speed = 150
        self.hp = 2
        self.mana = 0
        self.canAttack = true
        self.canMove = true
        self.canJump = true
        self.jumping = true
        self.velocity = {["x"] = 0, ["y"] = 0}
        self.damage = 1
        self.MAXTHAW = 3
        self.thaw = 0
    end
}

function Enemy:update(dt)
    print("Enemy update not implemented")
end

function Enemy:draw()
    print("Enemy draw not implemented")
end