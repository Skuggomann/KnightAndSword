Gamestate.game = {}
local game = Gamestate.game
local collider
local map
require 'player'
require 'ui'
require 'enemy'
require 'skeleton'
require 'rip'
require 'sword'
require 'frostbolt'
local knight = nil
local enemies = {}
local ui = nil
local spawnPoint = {}
local rip = nil
local goal = nil

function game:init() -- run only once
	rip = RIP()
end

function game:enter(previous,filename) -- run every time the state is entered
	enemies = {}
	local filepath = "assets/maps/"..filename
	collider = HC(100, on_collide, stop_collide)
	map = loader.load(filepath)
	map:setDrawRange(-10,-10,5400,620)
	map.drawObjects = false
	mapSetup(map)
	ui = UI(knight)
	ui:addToTable({"sword", "Hello INSERT PLAYER NAME HERE, welcome to the cursed keep.\nLet's make this text a little longer shall we? \ntest", 3, "Ser John", "uh, hello?",5})
	cam = Camera(456, 256,1.40)
end

function game:update(dt)
	-- update player object
	knight:update(dt)

	-- update enemies
	local i = 1
    while i <= #enemies do

    	if	enemies[i]:isDead() then
    		collider:remove(enemies[i].bbox)
    		table.remove(enemies,i)
    	else
    		enemies[i]:update(dt)
    		i = i + 1
    	end
    end
	-- Collision detection
	collider:update(dt)

	-- camera update
	local tempx,tempy = knight.bbox:center()
    local dx,dy = tempx - cam.x, tempy - cam.y
    if cam.x+dx > 456 then
	    cam:move(dx/2, 0)
    else
		cam.x = 456    	
	end

	--update UI
	ui:update(dt)

	if knight:isDead() then 
		collider:remove(knight.bbox)
		x,y = knight.bbox:center()
		x = x-16
		y = y+5 -- magic 5px
		rip:addRip(x,y)
		knight = Player(spawnPoint.x, spawnPoint.y, collider)
		ui = UI(knight)
		resetEnemies(map)
	end
end

function game:draw()
	cam:draw(drawWorld)
	ui:draw()
end



function game:keyreleased(key)
    if key == 'p' then
        Gamestate.push(Gamestate.pause)
    end
end

function game:leave()
end

function winGame()
	Gamestate.switch(Gamestate.levelselect)
end
function drawWorld()
	map:draw()
  	-- draw goal
    love.graphics.setColor(0,0,255, 255)
 	goal:draw("fill")
    love.graphics.setColor(255,255,255, 255)
    -- draw the rest
    rip:draw()
	knight:draw()
    for i = 1,#enemies do
    	enemies[#enemies - (i-1)]:draw()
    end
    
end
function resetEnemies(map)
	for i = 1,#enemies do
		collider:remove(enemies[#enemies - (i-1)].bbox)
	end
	enemies = {}
	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider)
		end
	end

end
function mapSetup(map)
	rip = RIP()
	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'player' then
			spawnPoint.x = obj.x
			spawnPoint.y = obj.y-32
			knight = Player(spawnPoint.x,spawnPoint.y,collider)
		elseif obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider)
		elseif obj.name == 'end' then
			goal = collider:addRectangle(obj.x,obj.y-32,32,32)
			goal.type = "end"
		end
	end

    for x, y, tile in map("ground"):iterate() do
		local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
        ctile.type = "tile"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
	end
end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	if shape_a.type == "player" or shape_a.type == "skeleton" or shape_a.type == "frostbolt" then
		shape_a.ref:collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	end
	if shape_b.type == "player" or shape_b.type == "skeleton" or shape_b.type == "frostbolt" then
		mtv_x = mtv_x*-1
		mtv_y = mtv_y*-1
		shape_b.ref:collide(dt, shape_b, shape_a, mtv_x, mtv_y)
	end
	--[[if shape_a.type == "skeleton" then
		shape_a.ref:collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	elseif shape_b.type == "skeleton" then
		mtv_x = mtv_x*-1
		mtv_y = mtv_y*-1
		shape_b.ref:collide(dt, shape_b, shape_a, mtv_x, mtv_y)
	end]]--
end

function stop_collide(dt, shape_a, shape_b)
    if shape_a.type == "player" and shape_b.type == "tile" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "tile" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "skeleton" and shape_b.type == "tile" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "skeleton" and shape_a.type == "tile" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "player" and shape_b.type == "skeleton" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "skeleton" then
        shape_b.ref.jumping = true
    end
end

function collideSkeletonWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- find which is a skeleton
    local skeleton_shape, tileshape
    if shape_a.type == "skeleton" and shape_b.type == "tile" then
        skeleton_shape = shape_a
    elseif shape_b == "skeleton" and shape_a.type == "tile" then
        skeleton_shape = shape_b
    else
        -- none of the two shapes is a tile, return to upper function
        return
    end

    skeleton_shape:move(mtv_x, 0)
    skeleton_shape:move(0, mtv_y)

    if mtv_y < 0 and skeleton_shape.ref.jumping then
    	skeleton_shape.ref.jumping = false
    	skeleton_shape.ref.velocity.y = 0
	else
		skeleton_shape.ref.velocity.y = 0
	end
end

--[[function collidePlayerWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- find which is the player
    local player_shape, tileshape
    if shape_a.type == "player" and shape_b.type == "tile" then
        player_shape = shape_a
    elseif shape_b == "player" and shape_a.type == "tile" then
        player_shape = shape_b
    else
        -- none of the two shapes is a tile, return to upper function
        return
    end

    player_shape:move(mtv_x, 0)
    player_shape:move(0, mtv_y)

    if mtv_y < 0 and player_shape.ref.jumping then
    	player_shape.ref.jumping = false
    	player_shape.ref.velocity.y = 0
	else
		player_shape.ref.velocity.y = 0
	end
end]]--