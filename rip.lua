RIP = Class{
    init = function(self)
        self.rips = {}
    end,
}

function RIP:update(dt)
    print("RIP update not implemented")
end

function RIP:draw()
    for i = 1,#self.rips-1, 2 do
        love.graphics.draw(sprites.rip_small,self.rips[i],self.rips[i+1])
    end
end
function RIP:addRip(x,y)
    table.insert(self.rips,x)
    table.insert(self.rips,y)
end
