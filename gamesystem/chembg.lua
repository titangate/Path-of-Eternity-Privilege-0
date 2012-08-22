require 'gameobject.camera'
ImageUnit = Object:subclass'ImageUnit'
function ImageUnit:initialize(image,x,y)
	self.image = image
	self.x,self.y = x,y
end

function ImageUnit:getWidth()
	return self.image:getWidth()
end

function ImageUnit:getHeight()
	return self.image:getHeight()
end

function ImageUnit:getX()
	return self.x
end

function ImageUnit:getY()
	return self.y
end

local background = {}
function background:load()
	self.c = Camera(0,0,0)
	self.z = 0
	self.images = {}
end

function background:spawnImage(image)
	table.insert(self.images,ImageUnit(requireImage(image),math.random(screen.width),math.random(screen.height)))
		
end

function background:draw()
	gra.setColor(255,255,255)
	local gaussianblur = filters.gaussianblur
	if gaussianblur then
	for i,image in ipairs(self.images) do
		self.c.z = 3-3/10*i+self.z
		image.gaussianblur_intensity = math.max(0,math.abs(self.c.z-2)-0.1)
		filters.gaussianblur.conf(image)
		filters.gaussianblur.predraw(image)
		gra.draw(image.image,image.x,image.y)
		gra.pop()
		gra.push()
		
		self.c:draw()
		gra.setCanvas(gaussianblur.prevc)
		gra.setPixelEffect(gaussianblur.horz)
		gra.draw(image.c.canvas,image.x,image.y)
		canvasmanager.releaseCanvas(image.c)
		gra.setPixelEffect()
		image.c = nil
		gra.pop()
	end
else
end
	--camerap.zNear,camerap.zFar = shift + 1,shift+3
end

local chem = love.filesystem.enumerate'asset/chemical/'
local chems = {}
for i,v in ipairs(chem) do
	if string.sub(v,#v-3)=='.png' then
		table.insert(chems,'asset/chemical/'..v)
	end
end
function background:update(dt)
	self.z = self.z + dt
	if self.z > 0.3 then
		local randomimage = chems[math.random(#chems)]
		table.remove(self.images,1)
		table.insert(self.images,ImageUnit(requireImage(randomimage),math.random(screen.width),math.random(screen.height)))
		if #self.images<15 then
			table.insert(self.images,ImageUnit(requireImage(randomimage),math.random(screen.width),math.random(screen.height)))
		end
		self.z = self.z - 0.3
	end
end

background:load()
return background