require 'gameobject.unit'
Doodad = Unit:subclass'Doodad'
function Doodad:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt,info)
	self.info = info
	self.layer = info.layer
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
	--[[	local w2 = math.min(screen.width,neartwo(w*1))
		local c = canvasmanager.requireCanvas(w2,h)
		c.canvas:clear()
		stroke.prevc = love.graphics.getCanvas()
		love.graphics.setCanvas(c.canvas)
		stroke.c = c
		love.graphics.push()
		love.graphics.translate(-obj:getX()+scale*self.info.width+(w2-w)/1,-obj:getY()+scale*self.info.height)
		love.graphics.rotate(-r)]]
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		love.graphics.setPixelEffect(stroke.pe)
	end
	love.graphics.setColor(255,255,255)
	love.graphics.draw(requireImage("doodad/"..i.image),x,y,r,i.sx,i.sy,i.ox,i.oy)

	if self.drawSelection then
		local obj = self
		local stroke = filters.selection

	--[[	local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		love.graphics.pop()
		love.graphics.setCanvas(stroke.prevc)
		love.graphics.setPixelEffect(stroke.pe)
		love.graphics.setColor(0,255,0)
		love.graphics.draw(stroke.c.canvas,obj:getX()-scale*self.info.width-(w2-w)/1,obj:getY()-scale*self.info.height)
		canvasmanager.releaseCanvas(stroke.c)]]
		love.graphics.setPixelEffect()
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
	for i=1,30 do -- use random sampling to determine the obstacled areas
		local rx,ry = math.random(r)-r/2+x,math.random(r)-r/2+y
		if DEBUG then
			self.sample = self.sample or {}
			table.insert(self.sample,{rx,ry})
		end
		if self.mover.fixture:testPoint(rx,ry) then
			result[self.map:getArea(rx,ry)] = true
		end
	end
	return result
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
	love.graphics.setColor(0,0,0)
	for i,v in ipairs(self.sample) do
		love.graphics.point(v[1],v[2])
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