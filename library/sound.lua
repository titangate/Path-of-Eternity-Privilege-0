

local sound = {}
function sound.load()
	sound.center = Vector(0,0)
--	sound.enable3d = false
	sound.channel = {}
	sound.source = {}
	sound.setDistanceModel'linear'
	sound.setCenter(sound.center)
--	love.audio.setVelocity(300,300,300)
--	love.audio.setVolume(0.5)
love.audio.setOrientation(
      1,
      0,
      0,
      0,1,0)
end

function sound.update(dt)
end

function sound.loadsound(name)
	if not sound.source[name] then
		sound.source[name] = love.sound.newSoundData(name)
	end
	return love.audio.newSource(sound.source[name],'static')
end

function sound.setCenter(x,y)
	if type(x) == 'table' then
		x,y = unpack(x,y)
	end
	sound.center = Vector(x,y)
	love.audio.setPosition(x,0,y)
end

function sound.setDistanceModel(model)
	love.audio.setDistanceModel(model)
end

Sound = Object:subclass'Sound'
function Sound:initialize(name,pos,reach)
	self.source = sound.loadsound(name)
	self.pos = pos
	self.reach = reach
	if pos then
		self.source:setPosition(pos.x,0,pos.y)
	end
	if reach then
		self.source:setDistance(reach,reach*2)
	end
	if DEBUG then
--		self.source:setVelocity(100,100,0)
		self.source:setPitch(1)
	end
end

function Sound:play()
	self.source:play()
end

function Sound:update(dt)
end

if DEBUG then
function Sound:DebugDraw()
	love.graphics.setColor(0,0,255,100)
	love.graphics.circle('fill',self.pos.x,self.pos.y,self.reach)
	love.graphics.setColor(0,0,255,100)
	love.graphics.circle('fill',self.pos.x,self.pos.y,self.reach*2)
end
end
return sound