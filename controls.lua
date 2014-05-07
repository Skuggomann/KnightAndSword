Controls = Class{
    init = function(self)		
		self.x = {false, false}
		self.left = {false, false}
		self.right = {false, false}		
    end
}
function Controls:isDown(player, key)

	key = string.lower(key)
	if     key == "x" then return self.x[player]	
	elseif key == "left" then return self.left[player] 	
	elseif key == "right" then return self.right[player]
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
	--elseif button == 10 then print("START")
	
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
	--elseif button == 10 then print("START")
	
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
	--elseif axis == 2 and value == -1 then print("Up Down")	
	elseif axis == 1 and value == -0.0078125 then --print("Right/Left Relesed")
		controls.right[id] = false
		controls.left[id] = false
	--elseif axis == 2 and value == -0.0078125 then print("Up/Down Relesed")	
    end
end



--[[
if controls:isDown(2, "x") then
		print("X is pressed")
	end
]]--





