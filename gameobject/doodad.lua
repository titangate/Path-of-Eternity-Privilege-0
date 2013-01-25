require 'gameobject.unit'
Doodad = Unit:subclass'Doodad'
function Doodad:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt,info)
	self.info = info
	self.layer = info.layer
end

function Doodad:draw_LLI()

	local i = self.info
	local x,y = self:getPosition()
	local r = self:getAngle()
	local scale = 0.5
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		gra.setPixelEffect(stroke.pe)
	end

	gra.setColor(255,255,255)
	gra.draw(requireImage("doodad/"..i.image),x,y,r,i.sx,i.sy,i.ox,i.oy)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection
		gra.setPixelEffect()
		stroke.c = nil
	end
end

function Doodad:draw()
	local i = self.info
	local x,y = self:getPosition()
	local r = self:getAngle()
	local scale = 0.5
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		gra.setPixelEffect(stroke.pe)
	end

	gra.setColor(255,255,255)
	gra.draw(requireImage("doodad/"..i.image),x,y,r,i.sx,i.sy,i.ox,i.oy)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection
		gra.setPixelEffect()
		stroke.c = nil
	end
end

function Doodad:getObstacle()
	assert(self.map)
	if not self.info.obstacle then
		return 
	end
	local x,y = self:getPosition()
	local r = self.info.width
	if self.info.height then
		r = math.max(r,self.info.height)
	end
	local result = {}
	self.sample = {}
	for i=1,math.ceil(self.info.width*self.info.height/100) do -- use random sampling to determine the obstacled areas
		local rx,ry = math.random(r)-r/2+x,math.random(r)-r/2+y
		if DEBUG then
			table.insert(self.sample,{rx,ry})
		end
		if self.mover.fixture:testPoint(rx,ry) then
			result[self.map:getArea(rx,ry)] = true
		end
	end
	return result
end

function Doodad:isObstacle()
	return self.info.obstacle
end

function Doodad:getWidth()
	return self.info.width
end

function Doodad:getHeight()
	return self.info.height
end

function Doodad:encode()
	local x,y = self.mover:getPosition()
	local r = self.mover:getAngle()

	return {info = self.info,x=x,y=y,r=r,name='Doodad'}
end

if DEBUG then
function Doodad:DebugDraw()
	if not self.sample then return end
	gra.setColor(255,0,255)
	for i,v in ipairs(self.sample) do
		gra.point(v[1],v[2])
	end
end
end

local doodad = {}
local doodaddef
function doodad.load()
	doodaddef = require 'doodad.definition'
end

function doodad.decode(t)
	return doodad.create(t.info,t.x,t.y,t.r)
end

function doodad.create(def,x,y,r)
	if type(def) == 'string' then
		def = doodaddef[def]
	end
	local d = Doodad(doodadMover,x,y,r,def.bodytype,def)

	return d
end

return doodad