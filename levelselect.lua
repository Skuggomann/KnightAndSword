Gamestate.levelselect = {}
local levelselect = Gamestate.levelselect
local levels = {}
local selected = 1
local levelnr = 1
function levelselect:init() -- run only once
	local file = io.open("assets/maps/levels.txt")
	if file then
		for line in file:lines() do
			local attr = 1
			table.insert(levels,{})
			for i in string.gmatch(line, '([^,]+)') do
				if attr == 1 then
					levels[levelnr].name = i
				elseif attr == 2 then
					levels[levelnr].filename = i
				end
				attr = attr+1
			end
			levelnr = levelnr+1
		end
	end
	levelnr = levelnr-1
end

function levelselect:enter(previous) -- run every time the state is entered
	--AudioController:playMusic("levelselect")
	--AudioController.music["levelselect"]:rewind()
	--AudioController.music["levelselect"]:play()
	Signal.register('enter', function()
    	local filename = levels[selected].filename
        Gamestate.switch(Gamestate.game,filename)
	end)
	Signal.register('up', function()
    	selected = (selected-1)
    	if selected == 0 then
    		selected = levelnr
    	end
	end)
	Signal.register('down', function()
    	selected = (selected+1)
    	if selected == (levelnr+1) then
    		selected = 1
    	end
	end)
end

function levelselect:leave()
	love.audio.stop()
	controls:clear()
end

function levelselect:update(dt)
end

function levelselect:draw()
    love.graphics.print(string.format("Select a level and press enter (x)"),10,10)
    --love.graphics.print(string.format("levels:"..levelnr),50,50)
    for k, v in pairs(levels) do
    	if k ~= selected then
			love.graphics.setColor(255,255,255, 100)
			elseif k == selected then
			love.graphics.setColor(255,255,255, 255)
		end
    	love.graphics.printf(v.name, 0, H/4+30*(k-1), W, 'center')
		love.graphics.setColor(255,255,255, 255)
    end
end

function levelselect:isLastLevel()
	return selected == levelnr
end

function levelselect:getCurrentLevel()
	return selected
end


function levelselect:switchToNextLevel()
	if not self.isLastLevel() then
		selected = selected+1
		local filename = levels[selected].filename
        Gamestate.switch(Gamestate.game,filename)
	end
end
--[[
function levelselect:keyreleased(key)
	--todo select a level and send it with the game state switch.
    if key == 'return' or key == 'kpenter' then
    	local filename = levels[selected].filename
        Gamestate.switch(Gamestate.game,filename)
    elseif key == 'up' then
    	selected = (selected-1)
    	if selected == 0 then
    		selected = levelnr
    	end
	elseif key == 'down' then
    	selected = (selected+1)
    	if selected == (levelnr+1) then
    		selected = 1
    	end
    end
end
]]




