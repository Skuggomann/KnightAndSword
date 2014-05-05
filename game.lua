Gamestate.game = {}
local game = Gamestate.game
local collider
local map
require 'player'
function game:init() -- run only once
end

function game:enter(previous) -- run every time the state is entered
	collider = HC(100, on_collide, stop_collide)
	knight = Player(128,415,collider)
	map = loader.load("assets/maps/level3.tmx")
	map:setDrawRange(-10,-10,5400,620)
	mapSetup(map)
	cam = Camera(456, 256,1.40)
end

function game:update(dt)
	-- update player object
	knight:update(dt)

	-- Collision detection
	collider:update(dt)

	-- camera update
	local tempx,tempy = knight.bbox:center()
    local dx,dy = tempx - cam.x, tempy - cam.y
    if cam.x+dx > 456 then
	    cam:move(dx/2, 0)
	end
end

function game:draw()
	cam:draw(drawWorld)
end



function game:keyreleased(key)
    if key == 'p' then
        Gamestate.push(Gamestate.pause)
    end
end

function game:leave()
end


function drawWorld()
	map:draw()
	knight:draw()
    love.graphics.print(string.format("You are now playing"),40,40)
end

function mapSetup(map)
    for x, y, tile in map("ground"):iterate() do
		local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
        ctile.type = "tile"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
	end
end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    collidePlayerWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)
end

function stop_collide(dt, shape_a, shape_b)
	knight.jumping = true
end

function collidePlayerWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- sort out which one our hero shape is
    local hero_shape, tileshape
    if shape_a == knight.bbox and shape_b.type == "tile" then
        hero_shape = shape_a
    elseif shape_b == knight.bbox and shape_a.type == "tile" then
        hero_shape = shape_b
    else
        -- none of the two shapes is a tile, return to upper function
        return
    end

    hero_shape:move(mtv_x, 0)
    hero_shape:move(0, mtv_y)

    if mtv_y < 0 and knight.jumping then
    	knight.jumping = false
    	knight.velocity.y = 0
	else
		knight.velocity.y = 0
	end

end