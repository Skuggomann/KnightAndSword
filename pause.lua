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
	love.audio.pause()
	AudioController.music["pause"]:play()
	self:registerSignals()
end

function pause:registerSignals()
	Signal.register('enter', function()
		if menuOptions[selected] == "Resume" then
			love.audio.resume()
    		Gamestate.pop()
    		Gamestate:registerSignals()
    	elseif menuOptions[selected] == "Retry level" then
    		for k,v in pairs(AudioController.sounds) do
    			v:stop()
    		end
    		love.audio.rewind()
    		love.audio.resume()
    		self.from:reset()
    		Gamestate.pop()
    		Gamestate:registerSignals()
		elseif menuOptions[selected] == "Exit to main menu" then
			love.audio.stop()
    		Gamestate.switch(Gamestate.menu)
		elseif menuOptions[selected] == "Settings" then
			controls:clear()
			Gamestate.push(Gamestate.optionsmenu, self.from)
		end
	end)
	Signal.register('up', function()
    	selected = (selected-1)
    	if selected == 0 then
    		selected = #menuOptions
    	end
	end)
	Signal.register('down', function()
    	selected = (selected+1)
    	if selected == (#menuOptions+1) then
    		selected = 1
    	end
	end)
end
function pause:leave()
	AudioController.music["pause"]:stop()
	controls:clear()
end
function pause:update(dt)
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