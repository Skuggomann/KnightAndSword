Gamestate.pause = {}
local menuOptions = {}

table.insert(menuOptions,"Resume")
table.insert(menuOptions,"Retry level")
table.insert(menuOptions,"Settings")
table.insert(menuOptions,"Exit to main menu")
local selected = 1
local pause = Gamestate.pause
function pause:enter(from)
    self.from = from -- record previous state
	selected = 1
end

function pause:update(dt)
	-- update input
    if controls:isDown("up") then
    	if not controls.bup then
    		--once
	    	selected = (selected-1)
	    	if selected == 0 then
	    		selected = #menuOptions
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
	    	if selected == (#menuOptions+1) then
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
    		if menuOptions[selected] == "Resume" then
        		Gamestate.pop()
        	elseif menuOptions[selected] == "Retry level" then
        		self.from:reset()
        		Gamestate.pop()
    		elseif menuOptions[selected] == "Exit to main menu" then
        		Gamestate.switch(Gamestate.menu)
    		elseif menuOptions[selected] == "Settings" then
    			Gamestate.push(Gamestate.optionsmenu, self.from)
    		end
    		controls.benter = true
    	end
    else
    	controls.benter = false
    end
    if controls:isDown("start") then
    	if not controls.bstart then
    		--once
        	Gamestate.pop()
    		controls.bstart = true
    	end
    else
    	controls.bstart = false
    end

end

function pause:draw()
    -- draw previous screen
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 200)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    --todo larger font
    love.graphics.setFont(Font36p)
    love.graphics.printf('PAUSE', 0, H/2-200, W, 'center')
    love.graphics.setFont(Font18p)
    for k, v in pairs(menuOptions) do
    	if k ~= selected then
			love.graphics.setColor(255,255,255, 100)
			elseif k == selected then
			love.graphics.setColor(255,255,255, 255)
		end
    	love.graphics.printf(v, 0, H/2+30*(k-1), W, 'center')
		love.graphics.setColor(255,255,255, 255)
    end

end

function pause:keyreleased(key)
    if key == 'escape' then
        --self.from:leave()
    	Gamestate.switch(Gamestate.menu)    	
    end
end