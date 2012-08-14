Animation = Object:subclass'Animation'
function Animation:initialize(def,sprites)
	self.sprites = sprites
	self.info = def
	self.step = 1
	self.speed = self.info.seq[1][4]
	self.dt = 0
	self.frame = 1
	self.critframe = def.critframe
end

function Animation:update(dt)
	assert(self.info)
	local framerate = self.info.framerate
	local start,finish,step,speed = unpack(self.info.seq[self.step])
	self.dt = self.dt + dt * speed
	if self.dt > 1/framerate then
		self.dt = self.dt - 1/framerate
		self.frame = self.frame + step
		if self.frame == finish then
			self.step = (self.step % #self.info.seq) + 1
			self.frame = self.info.seq[self.step][1]
		end
		if self.critframe then
			for k,v in pairs(self.critframe) do
				if v==self.frame then
					if self.OnCrit then
						self.OnCrit(k,v)
					end
				end
			end
		end
	end
end

function Animation:halt()
	if self.info.halt then
		self.frame = self.info.halt
	end
end

function Animation:draw(x,y,r)
	gra.draw(self.sprites[self.frame],x,y,r,2,2,64,64)
end

local animation = {}
local animdef = require 'animation.definition'
function animation.create(def)
	if type(def)=='string' then
		def = animdef[def]
	end
	local folder = def.folder
	local sprites = {}
	for i=0,def.maxframe do
		sprites[i] = requireImage('animation/'..folder..'/'..folder..'_'..tostring(i)..'.png')
	end
	print (def.framerate)
	return Animation(def,sprites)
end
return animation