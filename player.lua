Player = Class{
    init = function(self, x, y)
        --self.pos = {["x"] = x, ["y"] = y}
        self.x = x
        self.y = y
    end,
    speed = 50,
    hp = 3,
    mana = 0,
    weapons = {["sword"] = true, ["mace"] = false},
    abilities = {["frostbolt"] = true, ["cape"] = false},
    canAttack = true,
    canMove = true,
    canJump = true,
    jumping = false,
    velocity = {["x"] = 0, ["y"] = 0},
    getX = function(self)
		return self.x
	end,
    getY = function(self)
		return self.y
	end
}
function Player:update(dt)

end

function Player:draw()
	love.graphics.print(string.format("x: "..tostring(self.weapons.sword)),100,100)
end