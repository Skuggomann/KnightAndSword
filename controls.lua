Controls = Class{
    init = function(self)		
		self.x = {false, false}
		
		self.left = {false, false}
		self.right = {false, false}	
		self.up = {false, false}
		self.down = {false, false}
		
		self.start = {false, false}	

		self.player1 = 1
		self.player2 = 2
		self.bup = false
		self.bdown = false
		self.benter = false
		self.bstart = false
		self.bleft = false
		self.bright = false
    end
}
function Controls:isDown(key, player)
--[[
	key = string.lower(key)
	if     key == "x" then return self.x[player]
	elseif key == "left" then return self.left[player] 	
	elseif key == "right" then return self.right[player]
	elseif key == "up" then return self.up[player]
	end
]]--


	key = string.lower(key)
	if     key == "attack" then return self.x[self.player2] or love.keyboard.isDown(" ")
	elseif key == "cast" then return self.x[self.player1] or love.keyboard.isDown("w")
	elseif key == "left" then return self.left[self.player1] or love.keyboard.isDown("left")
	elseif key == "right" then return self.right[self.player1] or love.keyboard.isDown("right")
	elseif key == "up" then return self.up[self.player2] or love.keyboard.isDown("up")
	elseif key == "down" then return self.down[self.player2] or love.keyboard.isDown("down")
	elseif key == "start" then return self.start[self.player2] or self.start[self.player1] or love.keyboard.isDown("p")
	elseif key == "enter" then return self.x[self.player1] or self.x[self.player2] or love.keyboard.isDown("kpenter") or love.keyboard.isDown("return")
	end
	
end
function Controls:clear()
	Signal.clear('attack')
	Signal.clear('cast')
	Signal.clear('left')
	Signal.clear('right')
	Signal.clear('up')
	Signal.clear('down')
	Signal.clear('start')
	Signal.clear('enter')
	Signal.clear('upReleased')
end

controls = Controls();

function love.joystickpressed(joystick, button)
	local id, trash = joystick:getID()

	if     button == 1 then --print("Triangle") 
    --elseif button == 2 then print("Circle")
    elseif button == 3 then --print("X")
		controls.x[id] = true
		if id == 1 then
			Signal.emit('cast')
		elseif id == 2 then
			Signal.emit('attack')
		end
		Signal.emit('enter')
    --elseif button == 4 then print("Square")
    --elseif button == 5 then print("L2")
    --elseif button == 6 then print("R2")
    --elseif button == 7 then print("L1")
    --elseif button == 8 then print("R1")
	
	--elseif button == 9 then print("SELECT")
	elseif button == 10 then --print("START")
		controls.start[id] = true
		if id == 1 then
			Signal.emit('start')
		end
	--elseif button == 11 then print("L3")
	--elseif button == 12 then print("R3")
	
	--elseif button == 13 then print("PS3")
    --else                 	  print("Error, button was: " .. button)
    end
end


function love.joystickreleased( joystick, button )
	local id, trash = joystick:getID()

	if     button == 1 then --print("Triangle") 
    --elseif button == 2 then print("Circle")
    elseif button == 3 then --print("X")
		controls.x[id] = false
    --elseif button == 4 then print("Squere")
    --elseif button == 5 then print("L2")
    --elseif button == 6 then print("R2")
    --elseif button == 7 then print("L1")
    --elseif button == 8 then print("R1")
	
	--elseif button == 9 then print("SELECT")
	elseif button == 10 then --print("START")
		controls.start[id] = false
	--elseif button == 11 then print("L3")
	--elseif button == 12 then print("R3")
	
	--elseif button == 13 then print("PS3")
    --else                 	  print("Error, button was: " .. button)
    end
end


function love.joystickaxis( joystick, axis, value )

local id, trash = joystick:getID()
--print(axis .. " " .. value)

	if axis == 1 and value == 1 then --print("Right Down")
		controls.right[id] = true
		Signal.emit('right')
	elseif axis == 1 and value == -1 then --print("Left Down")	
		controls.left[id] = true
		Signal.emit('left')
	elseif axis == 2 and value == 1 then --print("Down Down")
		controls.down[id] = true
		Signal.emit('down')
	elseif axis == 2 and value == -1 then --print("Up Down")	
		controls.up[id] = true	
		Signal.emit('up')
	elseif axis == 1 and (value == -0.0078125 or value == 0) then --print("Right/Left Relesed")
		controls.right[id] = false
		controls.left[id] = false
	elseif axis == 2 and (value == -0.0078125 or value == 0) then --print("Up/Down Relesed")
		if id == controls.player2 then
			if controls.up[id] then
				Signal.emit('upReleased')
			end
		end
		controls.up[id] = false
		controls.down[id] = false
    end
end

function love.keypressed( key, isrepeat)
	if key == 'w' then
		--Cast
		Signal.emit('cast')
	elseif key == 'q' then
		--Switch Weapons
		--Signal.emit('switchhhhh')
	elseif key == ' ' then
		--Attack
		Signal.emit('attack')
	elseif key == 'up' then
		Signal.emit('up')
	elseif key == 'down' then
		Signal.emit('down')
	elseif key == 'left' then
		Signal.emit('left')
	elseif key == 'right' then
		Signal.emit('right')
	elseif key == 'p' then
		Signal.emit('start')
	elseif key == 'return' or key == 'kpenter' then
		Signal.emit('enter')
	end
end