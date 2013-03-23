module("SoundManager", package.seeall)
local Class = SoundManager
Class.__index = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function SoundManager.setup()
	self={}
   	self.soundMissile1=love.audio.newSource("assets/audio/missileshot1.ogg")
	self.soundMissile2=love.audio.newSource("assets/audio/missileshot2.ogg")

	self.soundLaser1=love.audio.newSource("assets/audio/lasershot2.ogg")
	self.soundLaser1:setLooping(true)

	self.soundExplosion1=love.audio.newSource("assets/audio/explosion1.ogg")
	self.soundExplosion2=love.audio.newSource("assets/audio/explosion2.ogg")
	self.soundExplosion3=love.audio.newSource("assets/audio/explosion3.ogg")
	self.soundExplosion4=love.audio.newSource("assets/audio/explosion4.ogg")

	self.voiceShit=love.audio.newSource("assets/audio/shit.ogg")
	self.voiceFuckyou=love.audio.newSource("assets/audio/fuckyou.ogg")
	self.voiceForMotherRussia=love.audio.newSource("assets/audio/formotherrussia.ogg")

	self.musicAmbiance=love.audio.newSource("assets/audio/intro_music.ogg")
	self.musicAmbiance:setLooping(true)
	self.musicPause=love.audio.newSource("assets/audio/shop.ogg")
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
		rd=math.floor(math.random(1,4))
		if rd == 1 then
			self.soundExplosion1:play()
		elseif rd == 2 then
			self.soundExplosion2:play()
		elseif rd == 3 then
			self.soundExplosion3:play()
		elseif rd == 4 then
			self.soundExplosion4:play()
		end
	end
end

function SoundManager.missile()
	if not self.noSound then
		rd=math.floor(math.random(1,2))
		if rd == 1 then
			self.soundMissile1:play()
		elseif rd == 2 then
			self.soundMissile2:play()
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

function SoundManager.voice()
	if not self.noSound then
		rd=math.floor(math.random(1,3))
		if rd == 1 then
			self.voiceShit:play()
		elseif rd == 2 then
			self.voiceFuckyou:play()
		elseif rd == 3 then
			self.voiceForMotherRussia:play()
		end
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