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
local gametime = nil
local gravity = 2000

function game:init() -- run only once
	rip = RIP()
end

function game:enter(previous,filename) -- run every time the state is entered
	enemies = {}
	gametime = 0
	local filepath = "assets/maps/"..filename
	collider = HC(100, on_collide, stop_collide)
	map = loader.load(filepath)
	map:setDrawRange(-10,-10,5400,620)
	map.drawObjects = false
	mapSetup(map)
	ui = UI(knight)
	if Gamestate.levelselect:getCurrentLevel() == 1 then
		ui:addToTable({"sword", "Hello Ser Loin, I'm terribly sorry for this but I'm afraid\nI need your help getting out of this cursed castle.\n", 5, "player", "why can't i use my arm...or jump?",3, "sword", "I'm afraid only the true king can wield me, but I can wield you\nI gave you the ability to cast frostbolts though, so no hard feelings?", 5})
	end
	cam = Camera(456, 256,1.40)
end

function game:update(dt)
	--update gametime
	gametime = gametime+dt
	-- update input

    if controls:isDown("start") then
    	if not controls.bstart then
    		--once
        	Gamestate.push(Gamestate.pause)
    		controls.bstart = true
    	end
    else
    	controls.bstart = false
    end

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
    -- kill player if he is out of frame
    local x,y = cam:cameraCoords(knight.bbox:center())
    if y > 752 then
    	print(knight.bbox:center())
    	knight:takeDamage(500) --he ded
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
		x,y = knight.bbox:center()
		x = x-16
		y = y
		Gamestate.push(Gamestate.death)
		rip:addRip(x,y)
		self:reset()
	end
end
function game:reset()
	gametime = 0 --change if we add checkpoints pls
	knight.frostbolt:removeAllBolts()
	collider:remove(knight.bbox)	
	collider:remove(knight.sword.bbox)
	knight = Player(spawnPoint.x, spawnPoint.y, collider, gravity)
	ui = UI(knight)
	resetEnemies(map)
end
function game:draw()
	cam:draw(drawWorld)
	ui:draw()
end



function game:leave()
end

function winGame()
	Gamestate.push(Gamestate.win, gametime)
end
function drawWorld()
	map:draw()
  	-- do not draw goal
    --love.graphics.setColor(0,0,255, 255)
 	--goal:draw("fill")
    --love.graphics.setColor(255,255,255, 255)
    -- draw the rest
    rip:draw()
	knight:draw()
    for i = 1,#enemies do
    	enemies[#enemies - (i-1)]:draw()
    end
	love.graphics.setColor(255,255,255, 80)
	for shape in pairs(collider:shapesInRange(0,0, W,H)) do
	    shape:draw('fill')
	end
    love.graphics.setColor(255,255,255, 255)
end
function resetEnemies(map)
	for i = 1,#enemies do
		collider:remove(enemies[#enemies - (i-1)].bbox)
	end
	enemies = {}
	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider, gravity)
		end
	end

end
function mapSetup(map)
	rip = RIP()
	local groundTiles = {}
	local nonXTiles = {}

	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'player' then
			spawnPoint.x = obj.x
			spawnPoint.y = obj.y-32
			knight = Player(spawnPoint.x,spawnPoint.y,collider, gravity)
		elseif obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider, gravity)
		elseif obj.name == 'end' then
			goal = collider:addRectangle(obj.x,obj.y-32,32,32)
			goal.type = "end"
		end
	end

    for x, y, tile in map("ground"):iterate() do
    	groundTiles[#groundTiles+1] = {x,y}
		--[[
		local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
        ctile.type = "tile"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
        ]]--
	end
    
    local i = 1
    while i <= #groundTiles do
    	tile = groundTiles[i]
    	table.remove(groundTiles,i)
    	
    	tile, posX, negX = checkGroundX(groundTiles, nonXTiles, tile, 1, 1)

    	if tile ~= nil then
			local ctile = collider:addRectangle(tile[1]*32-negX*32,tile[2]*32,32+(posX+negX)*32,32)
	        ctile.type = "tile"
	        collider:addToGroup("tiles", ctile)
	        collider:setPassive(ctile)
    	end
    end
    while i <= #nonXTiles do
    	tile = nonXTiles[i]
    	table.remove(nonXTiles,i)
    	
    	posY, negY = checkGroundY(nonXTiles, tile, 1, 1)

		local ctile = collider:addRectangle(tile[1]*32,tile[2]*32+negY*32,32,32+(posY+negY)*32)
        ctile.type = "tile"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
    end
end

function checkGroundX(groundTiles, nonXTiles, tile, posX, negX)
	for a,b in ipairs(groundTiles) do
		if tile[2] == b[2] then
			if tile[1]+posX == b[1] then
				table.remove(groundTiles,a)
				return checkGroundX(groundTiles,nonXTiles,tile,posX+1,negX)
			elseif tile[1]-negX == b[1] then
				table.remove(groundTiles,a)
				return checkGroundX(groundTiles,nonXTiles,tile,posX,negX+1)
			end
		end
	end
	if posX ~= 1 or negX ~= 1 then
		return tile, posX-1, negX-1
	else
		nonXTiles[#nonXTiles+1] = tile
		return nil, nil, nil
	end

end

function checkGroundY(nonXTiles, tile, posY, negY)
	for a,b in ipairs(nonXTiles) do
		if tile[1] == b[1] then
			if tile[2]+posY == b[2] then
				table.remove(nonXTiles,a)
				return checkGroundY(nonXTiles,tile,posY+1,negY)
			elseif tile[2]-negY == b[2] then
				table.remove(nonXTiles,a)
				return checkGroundY(nonXTiles,tile,posY,negY+1)
			end
		end
	end
	return posY-1, negY-1
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