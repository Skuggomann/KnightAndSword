AudioController = Class{
    init = function(self)
	    self.music = {
		    ["pause"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["mainmenu"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["levelselect"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["game"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["death"] = love.audio.newSource("assets/sounds/HIT.mp3", "static")  --ekki static í music þegar actualy music er komin ef hún er stór
		}

	    self.sounds = {	
		    ["swordhit"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["macehit"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["batshit"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["skeletonhit"] = love.audio.newSource("assets/sounds/skeltonhit.mp3", "static"),
		    ["frostboltcast"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["frostbolthitwalls"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["frostbolthitenemy"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["jump"] = love.audio.newSource("assets/sounds/jump2.mp3", "static"),
		    ["damage"] = love.audio.newSource("assets/sounds/PHIT.mp3", "static"),
		    ["death"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["levitatepickup"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["levitatedrop"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["levitatepassive"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["footsteps"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["healthvial"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["swapweapons"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["swapabilities"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["victory"] = love.audio.newSource("assets/sounds/HIT.mp3", "static")
			--add speech?
		}

		local file = io.open("settings.txt")
		if file then
			for line in file:lines() do
				i = line:find("=")

				toMatch = line:sub(1,i-1)
				if toMatch == "MasterVolume" then
					self.masterVolume = tonumber(line:sub(i+1))
				elseif toMatch == "SoundsVolume" then
					self.soundsVolume = tonumber(line:sub(i+1))
				elseif toMatch == "MusicVolume" then
					self.musicVolume = tonumber(line:sub(i+1))
				end
			end
		else
		    self.masterVolume = 1.0
		    self.musicVolume = 1.0
		    self.soundsVolume = 1.0
		end

	    love.audio.setVolume(self.masterVolume)

        for i,v in pairs(self.music) do 
           	v:setVolume(self.musicVolume) 
        end
        for i,v in pairs(self.sounds) do 
           	v:setVolume(self.soundsVolume)
        end


	end

}

function AudioController:setMasterVolume(volume)
	if volume >= 0.0 and volume <= 1.0 then
		self.masterVolume = volume
		love.audio.setVolume(volume)
	end
end

function AudioController:setMusicVolume(volume)
	if volume >= 0.0 and volume <= 1.0 then
		self.musicVolume = volume
		for i,v in pairs(self.music) do 
           	v:setVolume(self.musicVolume) 
        end
	end
end

function AudioController:setSoundsVolume(volume)
	if volume >= 0.0 and volume <= 1.0 then
		self.soundsVolume = volume
		for i,v in pairs(self.sounds) do 
           	v:setVolume(self.soundsVolume)
        end
	end
end