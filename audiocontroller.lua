local MUSICVOLMULTIPLYER = 0.5

AudioController = Class{
    init = function(self)
	    self.music = {
		    ["pause"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["mainmenu"] = love.audio.newSource("assets/sounds/8bit Dungeon Level.mp3"),
			["levelselect"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
			["game"] = love.audio.newSource("assets/sounds/8bit Dungeon Boss.mp3"),
			["death"] = love.audio.newSource("assets/sounds/HIT.mp3", "static")  --ekki static í music þegar actualy music er komin ef hún er stór
		}

	    self.sounds = {	
		    ["swordhit"] = love.audio.newSource("assets/sounds/hitwhoosh.mp3", "static"),
		    ["macehit"] = love.audio.newSource("assets/sounds/hitwhoosh.mp3", "static"),
		    ["batshit"] = love.audio.newSource("assets/sounds/batscreech.mp3", "static"),
		    ["skeletonhit"] = love.audio.newSource("assets/sounds/skeltonhit.mp3", "static"),
		    ["skeletondeath"] = love.audio.newSource("assets/sounds/skeletonhit2.mp3", "static"),
		    ["skeletondeath2"] = love.audio.newSource("assets/sounds/skelly death 0.mp3", "static"),
		    ["frostboltcast"] = love.audio.newSource("assets/sounds/frostbolt1.mp3", "static"),
		    ["frostbolthitwalls"] = love.audio.newSource("assets/sounds/frostboltwalls.mp3", "static"),
		    ["frostbolthitenemy"] = love.audio.newSource("assets/sounds/frostbolthitenemy.mp3", "static"),
		    ["jump"] = love.audio.newSource("assets/sounds/jump2.mp3", "static"),
		    ["damage"] = love.audio.newSource("assets/sounds/PHIT.mp3", "static"),
		    ["death"] = love.audio.newSource("assets/sounds/death3.mp3", "static"),
		    ["levitatepickup"] = love.audio.newSource("assets/sounds/meow.mp3", "static"),
		    ["levitatedrop"] = love.audio.newSource("assets/sounds/levitatedrop.mp3", "static"),
		    ["levitatepassive"] = love.audio.newSource("assets/sounds/levitatepassive2.mp3", "static"),
		    ["footsteps"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["healthvial"] = love.audio.newSource("assets/sounds/vial.mp3", "static"),
		    ["swapweapons"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["swapabilities"] = love.audio.newSource("assets/sounds/HIT.mp3", "static"),
		    ["victory"] = love.audio.newSource("assets/sounds/victorystutt.mp3", "static")
			--add speech?
		}

	    self.masterVolume = 1.0
	    self.musicVolume = 1.0
	    self.soundsVolume = 1.0
		self.sounds["levitatepassive"]:setLooping(true)
		--local file = love.filesystem.newFile("settings.txt")
		--if file then
			--print(file)
		for line in love.filesystem.lines("settings.txt") do
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
		--else
		--end
		--file:close()

	    love.audio.setVolume(self.masterVolume)

        for i,v in pairs(self.music) do 
           	v:setVolume(self.musicVolume*MUSICVOLMULTIPLYER) 
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
           	v:setVolume(self.musicVolume*MUSICVOLMULTIPLYER) 
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

function AudioController:playSound(sound)
	self.sounds[sound]:play()
end
function AudioController:playAndRewindSound(sound)
	self.sounds[sound]:rewind()
	self.sounds[sound]:play()
end
function AudioController:playAndRewindSoundPitchy(sound)
	pitch = math.random(95,105)/100
	self.sounds[sound]:rewind()
	self.sounds[sound]:setPitch(pitch)
	self.sounds[sound]:play()
end
function AudioController:playMusic(music)
	self.music[music]:setLooping(true)
	self.music[music]:rewind()
	self.music[music]:play()
end

function AudioController:stopSound(sound)
	self.sounds[sound]:stop()
end