AudioController = Class{
    init = function(self)
	    self.music = {}
	    self.sounds = {	["swordhit"] = love.audio.newSource("assets/sounds/swords_x_2_hit_001.mp3", "static")

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

        for i,v in ipairs(self.music) do 
           	v:setVolume(self.musicVolume) 
        end
        for i,v in ipairs(self.sounds) do 
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
		for i,v in ipairs(self.music) do 
           	v:setVolume(self.musicVolume) 
        end
	end
end

function AudioController:setSoundsVolume(volume)
	if volume >= 0.0 and volume <= 1.0 then
		self.soundsVolume = volume
		for i,v in ipairs(self.sounds) do 
           	v:setVolume(self.soundsVolume)
        end
	end
end