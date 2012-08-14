

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
		sound.music[#sound.music]:stop()
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
	
	if type(s)=='string' then
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
	self.source = name--sound.loadsound(name)
	self.pos = pos
	self.reach = reach
	self.channel = channel or 'effect'
	self.host = host
	self.alert = alert
	--if not self.source then return end
	if pos then
	--	self.source:setPosition(pos.x,0,pos.y)
	end
	if reach then
	--	self.source:setDistance(reach,reach*2)
	end
end

function Sound:setReach(reach)
	self.reach = reach
	--self.source:setDistance(reach,reach*2)
end

function Sound:setPosition(pos)
	self.pos = pos
	if pos then
		--self.source:setPosition(pos.x,0,pos.y)
	end
end

function Sound:play()
	if self.host then
		assert(self.alert)
		self.host:playsound(self)
	end
	--if not self.source then return end
	if (self.pos-sound.center):length()>self.reach*2 then
		return
	end
	local s = sound.loadsound(self.source)
	if not s then return end
	if self.pos then s:setPosition(self.pos.x,0,self.pos.y) end
	if self.reach then s:setDistance(self.reach,self.reach*2) end
	sound.play(s,self.channel)
	self.s = s
end

function Sound:draw_LLI()
	if not self.s then return end
	if self.s:isStopped() then return end
	local tell = (love.timer.getTime()*10)%1
	local x,y = unpack(self.pos)
	gra.setColor(255,255,255)
	gra.setLineWidth(2)
	gra.circle('line',x,y,tell*self.reach*2)
end

local c = {
	{0,255,0},
	{255,255,0},
	{255,0,0},
}
function Sound:drawCircle()
	gra.setColor(c[self.alert])
	local x,y = self.pos.x,self.pos.y
	if self.reach and self.reach > 0 then
		self.soundwave_intensity = math.random()*0.1
		self.soundwave_ref = self.reach*2
		filters.soundwave.conf(self)
		filters.soundwave.predraw()
		local img = requireImage'asset/shader/haze.png'
		local s = self.reach*4/img:getWidth()
		gra.draw(img,x,y,love.timer.getTime()*100,s,s,img:getWidth()/2,img:getHeight()/2)
		filters.soundwave.postdraw()
	end
end

function Sound:update(dt)
end

if DEBUG then
function Sound:DebugDraw()
	gra.setColor(0,0,255,100)
	gra.circle('fill',self.pos.x,self.pos.y,self.reach)
	gra.setColor(0,0,255,100)
	gra.circle('fill',self.pos.x,self.pos.y,self.reach*2)
end
end

return sound