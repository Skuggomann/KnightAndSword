RIP = Class{
    init = function(self)
        self.rips = {}
    end,
    img = love.graphics.newImage("assets/art/rip-small.png")
}

function RIP:update(dt)
    print("Enemy update not implemented")
end

function RIP:draw()
    for i = 1,#self.rips-1, 2 do
        love.graphics.draw(self.img,self.rips[i],self.rips[i+1])
    end
end
function RIP:addRip(x,y)
    table.insert(self.rips,x)
    table.insert(self.rips,y)
end
