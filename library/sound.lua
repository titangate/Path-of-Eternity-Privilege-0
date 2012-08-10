

local sound = {}
function sound.load()
	sound.center = Vector(0,0)
	sound.channel = {music = {}}
	sound.source = {}
	sound.setDistanceModel'linear'
	sound.setCenter(sound.center)
	sound.music = {}
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

function sound.playMusic(s,once)

	if type(s)=='string' then
		s = sound.loadsound(s,'stream')
	end

	if not s then return end
	if sound.music[#sound.music] then
		sound.music[#sound.music]:pause()
	end
	s:setLooping(not once)
	if once then
		table.insert(sound.music,s)
	else
		sound.music = {s}
	end
	table.insert(sound.channel.music,s)
	s:play()
end

function sound.play(s,channel,mode)
	
	if type(s)=='string' or type(s)=='table' then
		s = sound.loadsound(s,mode)
	end
	if not s then return end

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
				if v==sound.music[#sound.music] then
					table.remove(sound.music)
					if sound.music[#sound.music] then
						sound.music[#sound.music]:resume()
					end
				end
				i = i - 1
			end
		end
	end
end

function sound.loadsound(name,mode)
	if type(name)=='table' then
		for i,v in ipairs(name) do
			name[i] = sound.loadsound(v,mode)
		end
		return name
	end
	if not love.filesystem.isFile(name) then return end
	if mode == 'static' then
		if not sound.source[name] then
			sound.source[name] = love.sound.newSoundData(name)
		end
		return love.audio.newSource(sound.source[name],mode)
	else
		return love.audio.newSource(name,mode)
	end
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
	self.sources = sound.loadsound(name)
	self.pos = pos
	self.reach = reach
	self.channel = channel or 'effect'
	self.host = host
	self.alert = alert
	if type(self.sources)=='table' then
		self.source = self.sources[math.random(#self.sources)]
	else
		self.source = self.sources
	end
	if not self.source then return end
	if pos then
		self.source:setPosition(pos.x,0,pos.y)
	end
	if reach then
		self.source:setDistance(reach,reach*2)
	end
end

function Sound:setPosition(pos)
	self.pos = pos
	if pos then
		self.source:setPosition(pos.x,0,pos.y)
	end
end

function Sound:play()
	if self.host then
		assert(self.alert)
		self.host:playsound(self)
	end
	if not self.source then return end
	if (self.pos-sound.center):length()>self.reach*2 then
		print 'sound skipped'
		return
	end
	sound.play(self.source,self.channel)
end

function Sound:draw_LLI()
	local tell = (self.source:tell('samples')/4000)%1
	local x,y = unpack(self.pos)
	love.graphics.setColor(255,255,255)
	love.graphics.setLineWidth(2)
	love.graphics.circle('line',x,y,tell*self.reach*2)
end

function Sound:drawCircle()
	local x,y = self.pos.x,self.pos.y
	if self.reach and self.reach > 0 then
		self.soundwave_intensity = math.random()*0.1
		self.soundwave_ref = self.reach*2
		filters.soundwave.conf(self)
		filters.soundwave.predraw()
		local img = requireImage'asset/shader/haze.png'
		local s = self.reach*4/img:getWidth()
		love.graphics.draw(img,x,y,love.timer.getTime()*100,s,s,img:getWidth()/2,img:getHeight()/2)
		filters.soundwave.postdraw()
	end
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