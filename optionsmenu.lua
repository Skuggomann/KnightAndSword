Gamestate.optionsmenu = {}
local optionsmenu = Gamestate.optionsmenu
local selected = 1
local options = {}
local optionsNames = {}
table.insert(optionsNames, "Master volume: ")
table.insert(optionsNames, "Sound volume: ")
table.insert(optionsNames, "Music volume: ")

local noOptions = 3 --Change this if you add more options
function optionsmenu:init() -- run only once
	local file = io.open("settings.txt")
	if file then
		for line in file:lines() do
			i = line:find("=")

			toMatch = line:sub(1,i-1)
			if toMatch == "MasterVolume" then
				AudioController:setMasterVolume(tonumber(line:sub(i+1)))
			elseif toMatch == "SoundsVolume" then
				AudioController:setSoundsVolume(tonumber(line:sub(i+1)))
			elseif toMatch == "MusicVolume" then
				AudioController:setMusicVolume(tonumber(line:sub(i+1)))
			end

		end

	else
		local file = io.open("settings.txt", "w")
		file:write("MasterVolume=1.0\nSoundsVolume=1.0\nMusicVolume=1.0")
		file:close()
	end
	--levelnr = levelnr-1
end

function optionsmenu:enter(from) -- run every time the state is entered
	self.from = from
	options = {
	--["Master volume: "] = AudioController.masterVolume*10,
	--["Sound volume: "] = AudioController.soundsVolume*10,
	--["Music volume: "] = AudioController.musicVolume*10
}
	table.insert(options,AudioController.masterVolume*10)
	table.insert(options,AudioController.soundsVolume*10)
	table.insert(options,AudioController.musicVolume*10)
end

function optionsmenu:update(dt)
    if controls:isDown("up") then
    	if not controls.bup then
    		--once
	    	selected = (selected-1)
	    	if selected == 0 then
	    		selected = #options
	    	end
    		controls.bup = true
    	end
    else
    	controls.bup = false
    end
    if controls:isDown("down") then
    	if not controls.bdown then
    		--once
	    	selected = (selected+1)
	    	if selected == (#options+1) then
	    		selected = 1
	    	end
    		controls.bdown = true
    	end
    else
    	controls.bdown = false
    end
    if controls:isDown("left") then
    	if not controls.bleft then
    		--once
    		if options[selected] ~= 0 then
    			options[selected] = options[selected]-1   --change if you add more options
    		end
    		controls.bleft = true
    	end
    else
    	controls.bleft = false
    end
    if controls:isDown("right") then
    	if not controls.bright then
    		--once
	    	if options[selected] ~= 10 then
    			options[selected] = options[selected]+1   --change if you add more options
    		end
    		controls.bright = true
    	end
    else
    	controls.bright = false
    end
    if controls:isDown("enter") then
    	if not controls.benter then
    		--once
    		AudioController:setMasterVolume(options[1]/10)
       		AudioController:setSoundsVolume(options[2]/10)
    		AudioController:setMusicVolume(options[3]/10)

			local file = io.open("settings.txt", "w")
			file:write("MasterVolume="..AudioController.masterVolume.."\nSoundsVolume="..AudioController.soundsVolume.."\nMusicVolume="..AudioController.musicVolume)
			file:close()

	        Gamestate.pop()
    		controls.benter = true
    	end
    else
    	controls.benter = false
    end
end

function optionsmenu:draw()
    --self.from:draw()
    -- overlay
    love.graphics.setColor(0,0,0, 200)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    --todo larger font
    love.graphics.setFont(Font36p)
    love.graphics.printf('OPTIONS', 0, H/2-200, W, 'center')
    love.graphics.setFont(Font18p)

    for k, v in pairs(options) do
    	if k ~= selected then
			love.graphics.setColor(255,255,255, 100)
		else
			love.graphics.setColor(255,255,255, 255)
		end
    	love.graphics.printf(optionsNames[k], -50, H/2+30*(k-1), W, 'center')
    	love.graphics.printf(v, 50, H/2+30*(k-1), W, 'center')
		love.graphics.setColor(255,255,255, 255)
    end

end