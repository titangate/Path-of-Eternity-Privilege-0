

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
--[[love.audio.setOrientation(
      1,
      0,
      0,
      0,1,0)]]
end

function sound.update(dt)
end

function sound.applyToChannel(channel,func)
	assert(func)
	local c = sound.channel[channel]
	if c then
		for i,v in ipairs(c) do
			func(v)
		end
	end
end

function sound.play(s,channel)
	assert(sound.channel)
	if not sound.channel[channel] then
		sound.channel[channel] = {}
	end
	table.insert(sound.channel[channel],s)
	s:play()
end

function sound.cleanUp()
	for k,c in pairs(sound.channel) do
		for i,v in ipairs(c) do
			if v:isStopped() then
				table.remove(c,i)
				i = i - 1
			end
		end
	end
end

function sound.loadsound(name,mode)
	if not sound.source[name] then
		sound.source[name] = love.sound.newSoundData(name)
	end
	return love.audio.newSource(sound.source[name],mode or 'static')
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
function Sound:initialize(name,pos,reach,channel,host,alert)
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
	self.channel = channel or 'effect'
	self.host = host
	self.alert = alert
end

function Sound:play()
	if self.host then
		assert(self.alert)
		self.host:playself(self)
	end
	sound.play(self.source,self.channel)
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