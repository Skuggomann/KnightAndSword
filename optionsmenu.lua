Gamestate.optionsmenu = {}
local optionsmenu = Gamestate.optionsmenu
local selected = 1
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
end

function optionsmenu:update(dt)
    if controls:isDown("up") then
    	if not controls.bup then
    		--once
	    	selected = (selected-1)
	    	if selected == 0 then
	    		selected = levelnr
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
	    	if selected == (levelnr+1) then
	    		selected = 1
	    	end
    		controls.bdown = true
    	end
    else
    	controls.bdown = false
    end
    if controls:isDown("enter") then
    	if not controls.benter then
    		--once
	    	local filename = levels[selected].filename
	        Gamestate.switch(Gamestate.game,filename)
    		controls.benter = true
    	end
    else
    	controls.benter = false
    end
end

function optionsmenu:draw()
    love.graphics.print(string.format("Allan pls add options"),10,10)
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 200)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    --todo larger font
    love.graphics.setFont(Font36p)
    love.graphics.printf('OPTIONS', 0, H/2-200, W, 'center')
    love.graphics.setFont(Font18p)
end