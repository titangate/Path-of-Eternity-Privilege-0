Human = Unit:subclass'Human'

function Human:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt)
	self.headtilt = 0
	self.walkdt = 0
	self.feetshift = 0
	self.headstrain = 1
	if info then self:setStyle(info) end
	self.lli_color = {255,255,255,50}
end

function Human:setStyle(info)
	self.head = requireImage('unit/'..info.head)
	self.shoulder = requireImage('unit/'..info.shoulder)
	self.feet = requireImage('unit/'..info.feet)
	self.info = info
end

function Human:encode()
	local t = Unit.encode(self)
	t.info = self.info
	return t
end

function Human:decode(t)
	self:setStyle(t.info)
end

function Human:update(dt)
	Unit.update(self,dt)
	local vx,vy = self:getVelocity()
	if vx ~= 0 or vy ~= 0 then
		self.walkdt = self.walkdt + dt
		self.feetshift = math.sin(self.walkdt*6)
	else
		self.walkdt = 0
		self.feetshift = 0
	end
end

function Human:setHeadAngle(angle)
	angle = angle - self:getAngle()
	angle = math.max(math.min(angle,1),-1)
	self.headtilt = angle
end

function Human:getHeadAngle()
	return self:getAngle() + self.headtilt
end

local scale = 1.5
function Human:draw(x,y,r)
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		local c = canvasmanager.requireCanvas(w2,h)
		c.canvas:clear()
		stroke.prevc = gra.getCanvas()
		gra.setCanvas(c.canvas)
		stroke.c = c
		gra.push()
		gra.translate(-obj:getX()+scale*32+(w2-w)/1,-obj:getY()+scale*32)
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w2)
	end
	local g = gra
	if not x then
		x,y = self:getPosition()
		r = self:getAngle()
	end
	g.setColor(255,255,255)
	g.draw(self.feet,x,y,r,scale,scale,30+self.feetshift*7,22)
	g.draw(self.feet,x,y,r,scale,scale,30-self.feetshift*7,42)
	g.draw(self.shoulder,x,y,r,scale,scale,32,32)
	g.draw(self.head,x,y,r+self.headtilt,scale,scale,32,32)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection

		local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		gra.pop()
		gra.setCanvas(stroke.prevc)
		gra.setPixelEffect(stroke.pe)
		gra.setColor(0,255,0)
		gra.draw(stroke.c.canvas,obj:getX()-scale*32-(w2-w)/1,obj:getY()-scale*32)
		canvasmanager.releaseCanvas(stroke.c)
		gra.setPixelEffect()
		stroke.c = nil
	end
end


function Human:draw_LLI(x,y,r)
	local i = self.info
	if not x then
		x,y = self:getPosition()
		r = self:getAngle()
	end
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		local c = canvasmanager.requireCanvas(w2,h)
		c.canvas:clear()
		stroke.prevc = gra.getCanvas()
		gra.setCanvas(c.canvas)
		stroke.c = c
		gra.push()
		gra.translate(-obj:getX()+scale*32+(w2-w)/1,-obj:getY()+scale*32)
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w2)
	end
	local g = gra
	g.setColor(255,255,255)
	g.draw(self.feet,x,y,r,scale,scale,30+self.feetshift*7,22)
	g.draw(self.feet,x,y,r,scale,scale,30-self.feetshift*7,42)
	g.draw(self.shoulder,x,y,r,scale,scale,32,32)
	g.draw(self.head,x,y,r+self.headtilt,scale,scale,32,32)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection

		local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		gra.pop()
		gra.setCanvas(stroke.prevc)
		gra.setPixelEffect(stroke.pe)
		gra.setColor(0,255,0)
		gra.draw(stroke.c.canvas,obj:getX()-scale*32-(w2-w)/1,obj:getY()-scale*32)
		canvasmanager.releaseCanvas(stroke.c)
		gra.setPixelEffect()
		stroke.c = nil
	end
	filters.lli_unit.conf(self)
	filters.lli_unit.predraw(self)
	gra.setColor(self.lli_color[1],self.lli_color[2],self.lli_color[3],50)
	
	g.draw(self.feet,x,y,r,scale,scale,30+self.feetshift*7,22)
	g.draw(self.feet,x,y,r,scale,scale,30-self.feetshift*7,42)
	g.draw(self.shoulder,x,y,r,scale,scale,32,32)
	g.draw(self.head,x,y,r+self.headtilt,scale,scale,32,32)
	filters.lli_unit.postdraw(self)
	if self.lli_flare then
		gra.setColor(self.lli_color[1],self.lli_color[2],self.lli_color[3],math.random()*127+127)
	end
	g.draw(requireImage'asset/effect/flare.png',x,y,0,1,1,64,32)


end



function Human:getWidth()
	return scale*64
end

function Human:getHeight()
	return scale*64
end

local human = {}
local humandef
function human.load()
	humandef = require 'unit.definition'
end
function human.decode(t)
	local u = River()
	u.mover = serial.decode(t.mover)
	u:decode(t)
	return u
end
function human.create(def,x,y,r,bodytype)
	if type(def) == 'string' then
		def = humandef[def]
	end
	local d = River(Box2DMover,x,y,r,bodytype or 'kinematic',def)
	return d
end
return human