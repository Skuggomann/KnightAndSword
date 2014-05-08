Controls = Class{
    init = function(self)		
		self.x = {false, false}
		
		self.left = {false, false}
		self.right = {false, false}	
		self.up = {false, false}
		
		self.start = {false, false}	

		self.player1 = 1
		self.player2 = 2
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
	end
	
end

controls = Controls();

function love.joystickpressed(joystick, button)
	local id, trash = joystick:getID()

	if     button == 1 then --print("Triangle") 
    --elseif button == 2 then print("Circle")
    elseif button == 3 then --print("X")
		controls.x[id] = true
    --elseif button == 4 then print("Squere")
    --elseif button == 5 then print("L2")
    --elseif button == 6 then print("R2")
    --elseif button == 7 then print("L1")
    --elseif button == 8 then print("R1")
	
	--elseif button == 9 then print("SELECT")
	elseif button == 10 then --print("START")
		controls.start[id] = true
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
	elseif axis == 1 and value == -1 then --print("Left Down")	
		controls.left[id] = true
	--elseif axis == 2 and value == 1 then print("Down Down")
	elseif axis == 2 and value == -1 then --print("Up Down")	
		controls.up[id] = true	
	elseif axis == 1 and value == -0.0078125 then --print("Right/Left Relesed")
		controls.right[id] = false
		controls.left[id] = false
	elseif axis == 2 and value == -0.0078125 then --print("Up/Down Relesed")
		controls.up[id] = false	
	
    end
end



--[[
if controls:isDown(2, "x") then
		print("X is pressed")
	end
]]--





