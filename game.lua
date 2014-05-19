Gamestate.game = {}
local game = Gamestate.game
local collider
local map
require 'player'
require 'ui'
require 'enemy'
require 'skeleton'
require 'bat'
require 'rip'
require 'sword'
require 'frostbolt'
require 'telekinesis'
require 'mace'
require 'breakable'
require 'movable'
require 'theveil'
require 'door'
require 'healthvial'
local knight = nil
local enemies = {}
local objects = {} -- breakable objects and movable objects.
local doors = {}
local ui = nil
local spawnPoint = {}
local rip = nil
local goal = nil
local gametime = nil
local gravity = 2000
local levelname = nil
local veil = nil
local veilstart = 0
local weapons = {}
local abilities = {}

function game:init() -- run only once
	--rip = RIP()
	rip = {}
end

function game:enter(previous,filename) -- run every time the state is entered
	AudioController:playMusic("game")
	--[[
	AudioController.music["game"]:rewind()
	AudioController.music["game"]:play()
	]]
	enemies = {}
	objects = {}
	doors = {}
	gametime = 0
	if veil then
		veil:destroy()
		veil = nil
	end
	local filepath = "assets/maps/"..filename
	collider = HC(100, on_collide, stop_collide)
	map = loader.load(filepath)
	map:setDrawRange(-10,-10,5400,H)
	map.drawObjects = false
	mapSetup(map)
	ui = UI(knight)
	levelname = filename
	if rip[levelname] == nil then
		rip[levelname] = RIP()
	end
	self:registerSignals()
	cam = Camera(W/2,H/2,1)--456, 256,1)--1.40)
	readLevelSettings(filepath)
	knight:disallowWeaponsAbilities(weapons,abilities)

end
function readLevelSettings(filepath)
	local settings = filepath.."xx"
	weapons = {}
	abilities = {}

	local file = io.open(settings)
	if file then
		for line in file:lines() do
			local i = line:find("=")



			toMatch = line:sub(1,i-1)
			if toMatch == "VeilOfSouls" then
				local x = tonumber(line:sub(i+1))
				if x then 
					veilstart = x
					veil = TheVeil(veilstart,collider)
				end
			elseif toMatch == "SpeechText" then
				local str = line:sub(i+1)
				local speech = {}
				local j = str:find('"')
				while j ~= nil do
					k = str:find('"',j+1)
					local who = str:sub(j+1,k-1)
					j = str:find('"',k+1)
					k = str:find('"',j+1)
					local what = str:sub(j+1,k-1)
					what = what:gsub("\\n","\n")
					table.insert(speech,{who,what})
					j = str:find('"',k+1)
				end
				if #speech ~= 0 then
					controls:clear()
					Gamestate.push(Gamestate.speechstate,ui,speech)
				end
			elseif toMatch == "BannedWeapons" then
				local str = line:sub(i+1)
				local j = str:find('"')
				while j ~= nil do
					k = str:find('"',j+1)
					local weapon = str:sub(j+1,k-1)
					j = str:find('"',k+1)
					table.insert(weapons,weapon)
				end
			elseif toMatch == "BannedAbilities" then
				local str = line:sub(i+1)
				local j = str:find('"')
				while j ~= nil do
					k = str:find('"',j+1)
					local ability = str:sub(j+1,k-1)
					j = str:find('"',k+1)
					table.insert(abilities,ability)
				end
			end
		end
	end
end
function game:registerSignals()
	Signal.register('cast', function()
    	knight:cast()
	end)
	Signal.register('attack', function()
    	knight:attack()
	end)
	Signal.register('start', function()
		controls:clear()
    	Gamestate.push(Gamestate.pause)
	end)
	Signal.register('weaponsLeft', function()
		knight:swapWeaponsBackwards()
	end)
	Signal.register('weaponsRight', function()
		knight:swapWeaponsForwards()
	end)
	Signal.register('abilitiesLeft', function()
		knight:swapAbilitiesBackwards()
	end)
	Signal.register('abilitiesRight', function()
		knight:swapAbilitiesForwards()
	end)
end

function game:update(dt)
	--update gametime
	gametime = gametime+dt

    if veil then 
    	veil:update(dt) 
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

    -- update objects
	local i = 1
    while i <= #objects do

    	if	objects[i]:isDead() then
    		collider:remove(objects[i].bbox)
    		table.remove(objects,i)
    	else
    		objects[i]:update(dt)
    		i = i + 1
    	end
    end

    -- update doors and sensors
    for key,value in pairs(doors) do
    	value:update(dt)
    end
    -- kill player if he is out of frame
    local x,y = cam:cameraCoords(knight.bbox:center())
    if y > 752 then
    	knight:takeDamage(500) --he ded
    end

	-- Collision detection
	collider:update(dt)

	-- camera update
	local tempx,tempy = knight.bbox:center()
    local dx,dy = tempx - cam.x, tempy - cam.y
    if cam.x+dx > W/2 then
	    cam:move(dx/2, 0)
    else
		cam.x = W/2    	
	end

	--update UI
	ui:update(dt)

	if knight:isDead() then 
		x,y = knight.bbox:center()
		x = x-16
		y = y-3
		controls:clear()
		Gamestate.push(Gamestate.death)
		rip[levelname]:addRip(x,y)
		self:reset()
	end
end
function game:reset()
	gametime = 0 --change if we add checkpoints pls
	knight:destructor()
	if veil then 
		veil:destroy()
		veil = TheVeil(veilstart,collider) 
	end
	knight = Player(spawnPoint.x, spawnPoint.y, collider, gravity)
	knight:disallowWeaponsAbilities(weapons,abilities)
	ui = UI(knight)
	resetEnemies(map)
	resetObjects(map)
end
function game:draw()
	cam:draw(drawWorld)
	ui:draw()
   	--love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end



function game:leave()
	love.audio.stop()
end

function winGame()
	controls:clear()
	Gamestate.push(Gamestate.win, gametime)
end
function drawWorld()
	map:draw()
  	-- do not draw goal
    --love.graphics.setColor(0,0,255, 255)
 	--goal:draw("fill")
    --love.graphics.setColor(255,255,255, 255)
    -- draw the rest
    rip[levelname]:draw()
	knight:draw()
	-- draw enemies
    for i = 1,#enemies do
    	enemies[#enemies - (i-1)]:draw()
    end
    -- draw objects
    for i = 1,#objects do
    	objects[#objects - (i-1)]:draw()
    end
    -- draw doors and sensors
    for key,value in pairs(doors) do
    	value:draw()
    end
    if debug then
		love.graphics.setColor(255,255,255, 80)
		for shape in pairs(collider:shapesInRange(0,0, W,H)) do
		    shape:draw('fill')
		end
	    love.graphics.setColor(255,255,255, 255)
	end
	if veil then veil:draw() end

end
function resetEnemies(map)
	for i = 1,#enemies do
		collider:remove(enemies[#enemies - (i-1)].bbox)
	end
	enemies = {}
	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider, gravity)
		elseif obj.name == 'bat' then
			enemies[#enemies+1] = Bat(obj.x,obj.y-32,collider,knight)
		end
	end

end

function resetObjects(map)
	for i = 1,#objects do
		collider:remove(objects[#objects - (i-1)].bbox)
	end	
	for i = 1,#doors do
		doors[i]:destructor()
	end
	doors = {}
	objects = {}
	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'breakable' then
			objects[#objects+1] = Breakable(obj.x,obj.y-32,collider)
		elseif obj.name == 'movable' then
			objects[#objects+1] = Movable(obj.x,obj.y-32,collider,gravity)
		elseif obj.name == 'healthvial' then
			objects[#objects+1] = HealthVial(obj.x,obj.y-32,collider)
		elseif obj.type == 'door' then
			doors[obj.name] = Door(obj.x,obj.y-32,collider)
		elseif obj.type == 'sensor' then
			doors[obj.name]:newSensor(obj.x,obj.y-32)
		end
	end


end

function mapSetup(map)
	local groundTiles = {}
	local nonXTiles = {}
	local spikes = {}

	for i, obj in pairs( map("spawns").objects ) do
		if obj.name == 'player' then
			spawnPoint.x = obj.x
			spawnPoint.y = obj.y-32
			knight = Player(spawnPoint.x,spawnPoint.y,collider, gravity)
		elseif obj.name == 'skeleton' then
			enemies[#enemies+1] = Skeleton(obj.x,obj.y-32,collider, gravity)
		elseif obj.name == 'bat' then
			enemies[#enemies+1] = Bat(obj.x,obj.y-32,collider,knight)
		elseif obj.name == 'end' then
			goal = collider:addRectangle(obj.x,obj.y-32,32,32)
			goal.type = "end"
		elseif obj.name == 'breakable' then
			objects[#objects+1] = Breakable(obj.x,obj.y-32,collider)
		elseif obj.name == 'movable' then
			objects[#objects+1] = Movable(obj.x,obj.y-32,collider, gravity)
		elseif obj.name == 'healthvial' then
			objects[#objects+1] = HealthVial(obj.x,obj.y-32,collider)
		elseif obj.type == 'door' then
			doors[obj.name] = Door(obj.x,obj.y-32,collider)
		elseif obj.type == 'sensor' then
			doors[obj.name]:newSensor(obj.x,obj.y-32)
		end
	end
    for x, y, tile in map("spikes"):iterate() do
    	spikes[#spikes+1] = {x,y}
    	--[[
		local ctile = collider:addRectangle((x)*32,((y)*32)+16,32,16)
        ctile.type = "spike"
        collider:addToGroup("tiles", ctile)
        collider:setPassive(ctile)
        ]]--
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
    while i <= #spikes do
    	tile = spikes[i]
    	table.remove(spikes,i)
    	
    	posX, negX = checkSpikes(spikes, tile, 1, 1)

		local ctile = collider:addRectangle(tile[1]*32-negX*32,tile[2]*32+16,32+(posX+negX)*32,32-16)
        ctile.type = "spike"
        collider:addToGroup("spikes", ctile)
        collider:setPassive(ctile)
    end

end

function checkSpikes(spikes, tile, posX, negX)
	for a,b in ipairs(spikes) do
		if tile[2] == b[2] then
			if tile[1]+posX == b[1] then
				table.remove(spikes,a)
				return checkSpikes(spikes,tile,posX+1,negX)
			elseif tile[1]-negX == b[1] then
				table.remove(spikes,a)
				return checkSpikes(spikes,tile,posX,negX+1)
			end
		end
	end
	return posX-1, negX-1
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
	if shape_a.type == "player" or shape_a.type == "skeleton" or shape_a.type == "frostbolt" or shape_a.type == "bat" or shape_a.type == "breakable" or shape_a.type == "movable" or shape_a.type == "sensor" then
		shape_a.ref:collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	end
	if shape_b.type == "player" or shape_b.type == "skeleton" or shape_b.type == "frostbolt" or shape_b.type == "bat" or shape_b.type == "breakable" or shape_b.type == "movable" or shape_b.type == "sensor" then
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
    elseif shape_a.type == "skeleton" and shape_b.type == "spike" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "skeleton" and shape_a.type == "spike" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "skeleton" and shape_b.type == "movable" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "skeleton" and shape_a.type == "movable" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "skeleton" and shape_b.type == "breakable" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "skeleton" and shape_a.type == "breakable" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "player" and shape_b.type == "skeleton" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "skeleton" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "player" and shape_b.type == "spike" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "spike" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "player" and shape_b.type == "bat" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "bat" then
        shape_b.ref.jumping = true  
    elseif shape_a.type == "player" and shape_b.type == "movable" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "movable" then
        shape_b.ref.jumping = true  
    elseif shape_a.type == "player" and shape_b.type == "breakable" then
        shape_a.ref.jumping = true
    elseif shape_b.type == "player" and shape_a.type == "breakable" then
        shape_b.ref.jumping = true
    elseif shape_a.type == "sensor" and shape_b.type == "player" then
    	shape_a.delay = shape_a.MAXDELAY
    elseif shape_b.type == "sensor" and shape_a.type == "player" then
    	shape_b.delay = shape_b.MAXDELAY
    elseif shape_a.type == "sensor" and shape_b.type == "skeleton" then
    	shape_a.delay = shape_a.MAXDELAY
    elseif shape_b.type == "sensor" and shape_a.type == "skeleton" then
    	shape_b.delay = shape_b.MAXDELAY
    elseif shape_a.type == "sensor" and shape_b.type == "movable" then
    	shape_a.delay = shape_a.MAXDELAY
    elseif shape_b.type == "sensor" and shape_a.type == "movable" then
    	shape_b.delay = shape_b.MAXDELAY
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
