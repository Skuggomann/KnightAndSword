AudioController = Class{
    init = function(self, master, music, sounds)
	    self.music = {}
	    self.sounds = {}
	    self.all = {}

	    self.masterVolume = master
	    self.musicVolume = music
	    self.soundsVolume = sounds

	    if self.masterVolume == nil then
	    	self.masterVolume = 1.0
	    end
	    if self.musicVolume == nil then
	    	self.musicVolume = 1.0
	    end
	    if self.soundsVolume == nil then
	    	self.soundsVolume = 1.0
	    end

	    love.audio.setVolume(self.masterVolume)

        for i,v in ipairs(self.music) do 
           	v:setVolume(self.musicVolume*self.masterVolume) --TODO find out how mastervolume works
        end
        for i,v in ipairs(self.sounds) do 
           	v:setVolume(self.soundsVolume*self.masterVolume) --TODO find out how mastervolume works
        end


	end

}