Enemy = Class{
    init = function(self, x, y)
        --self.pos = {["x"] = x, ["y"] = y}
        self.x = x
        self.y = y
    end,
    speed = 50,
    hp = 3,
    mana = 0,
    canAttack = true,
    canMove = true,
    canJump = true,
    jumping = false,
    velocity = {["x"] = 0, ["y"] = 0},
    status = nil,
    getX = function(self)
		return self.x
	end,
    getY = function(self)
		return self.y
	end
}

function Enemy:update(dt)

end

function Enemy:draw()

end