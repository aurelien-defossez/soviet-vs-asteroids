module("SoundManager", package.seeall)
local Class = SoundManager
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function SoundManager.setup()
	self={}
   

	self.soundLaser1=love.audio.newSource("assets/audio/lasershot2.ogg", "static")
	self.soundLaser1:setLooping(true)


	self.soundUpgrade=love.audio.newSource("assets/audio/upgrade.ogg", "static")
	self.soundLaserPlace=love.audio.newSource("assets/audio/laser_place.ogg", "static")
	self.soundDronePlace=love.audio.newSource("assets/audio/drone_place.ogg", "static")

	self.soundMissiles={
		love.audio.newSource("assets/audio/missileshot1.ogg", "static"),
		love.audio.newSource("assets/audio/missileshot2.ogg", "static"),
		love.audio.newSource("assets/audio/missileshot1.ogg", "static"),
		love.audio.newSource("assets/audio/missileshot2.ogg", "static")
	}	
	self.soundMissileItter=1
	for _,a in pairs(self.soundMissiles) do
		a:setVolume(0.4)
	end 

	self.soundExplosions={
		love.audio.newSource("assets/audio/explosion1.ogg", "static"),
		love.audio.newSource("assets/audio/explosion3.ogg", "static"),
		love.audio.newSource("assets/audio/explosion4.ogg", "static"),
		love.audio.newSource("assets/audio/explosion1.ogg", "static"),
		love.audio.newSource("assets/audio/explosion2.ogg", "static"),
		love.audio.newSource("assets/audio/explosion3.ogg", "static"),
		love.audio.newSource("assets/audio/explosion4.ogg", "static"),
		love.audio.newSource("assets/audio/explosion2.ogg", "static")
	}
	for _,a in pairs(self.soundExplosions) do
		a:setVolume(0.4)
	end

	self.soundVoices={
		love.audio.newSource("assets/audio/shit.ogg", "static"),
		love.audio.newSource("assets/audio/fuckyou.ogg", "static"),
		love.audio.newSource("assets/audio/formotherrussia.ogg", "static"),
		love.audio.newSource("assets/audio/shit.ogg", "static"),
		love.audio.newSource("assets/audio/fuckyou.ogg", "static"),
		love.audio.newSource("assets/audio/formotherrussia.ogg", "static")
	}

	self.voiceFusRoDov=love.audio.newSource("assets/audio/fusrodov.ogg", "static")
	self.voiceAnneRoumanov=love.audio.newSource("assets/audio/anneroumanov.ogg", "static")

	self.musicAmbiance=love.audio.newSource("assets/audio/music.ogg", "stream")
	self.musicAmbiance:setLooping(true)
	self.musicPause=love.audio.newSource("assets/audio/shop.ogg", "stream")
	self.musicPause:setLooping(true)

	self.noMusic=false
	self.noSound=false
end

function SoundManager.startMusic()
	if not self.noMusic then
		self.musicAmbiance:play()
	end
end

function SoundManager.stopMusic()
	if not self.noMusic then
		self.musicAmbiance:stop()
	end
end

function SoundManager.startShopMusic()
	if not self.noMusic then
		self.musicAmbiance:pause()
		self.musicPause:play()
	end
end

function SoundManager.stopShopMusic()
	if not self.noMusic then
		self.musicPause:stop()
		self.musicAmbiance:resume()
	end
end

function SoundManager.explosion()
	if not self.noSound then
		rd=math.floor(math.random(1,8))
		self.soundExplosions[rd]:play()
	end
end

function SoundManager.missile()
	if not self.noSound then
		self.soundMissiles[self.soundMissileItter]:play()
		self.soundMissileItter=self.soundMissileItter+1
		if(self.soundMissileItter>4)then
			self.soundMissileItter=1
		end
	end
end

function SoundManager.laserStart()
	if not self.noSound then
		self.soundLaser1:play()
	end
end

function SoundManager.laserStop()
	if not self.noSound then
		self.soundLaser1:stop()
	end
end

function SoundManager.upgrade()
	if not self.noSound then
		self.soundUpgrade:play()
	end
end

function SoundManager.laserPlace()
	if not self.noSound then
		self.soundLaserPlace:play()
	end
end

function SoundManager.dronePlace()
	if not self.noSound then
		self.soundDronePlace:play()
	end
end

function SoundManager.voice()
	if not self.noSound then
		rd=math.floor(math.random(1,6))
		self.soundVoices[rd]:play()
	end
end

function SoundManager.voiceBomb()
	if not self.noSound then
		self.voiceFusRoDov:play()
	end
end

function SoundManager.voiceDeath()
	if not self.noSound then
		self.voiceAnneRoumanov:play()
	end
end

function SoundManager.setNoMusic(noMusic)	
	if (self.noMusic~=noMusic) then
		if noMusic then
			self.musicPause:stop()
			self.musicAmbiance:stop()
		else
			self.musicPause:play()
			self.musicAmbiance:play()
		end
		self.noMusic=noMusic
	end
end

function SoundManager.setNoSound(noSound)	
	self.noSound=noSound
end
