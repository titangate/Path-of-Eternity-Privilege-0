Body = Unit:subclass'Body'

function Body:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt)
	self.headtilt = 0
	self.walkdt = 0
	self.feetshift = 0
	self.headstrain = 1
	if info then self:setStyle(info) end
	self.lli_color = {255,255,255,50}
end

function Body:setStyle(info)
	self.info = info
	self.info.interact = 'dragbody'
end

function Body:encode()
	local t = Unit.encode(self)
	t.info = self.info
	return t
end

function Body:decode(t)
	self:setStyle(t.info)
end

function Body:update(dt)
	Unit.update(self,dt)
end

function Body:setHeadAngle(angle)
	self.headtilt = angle
end

function Body:getHeadAngle()
	return self:getAngle() + self.headtilt
end

local function _getXYR(body)
	assert(body)
	return body:getX(),body:getY(),body:getAngle()
end


local shapewidth,shapeheight = 48,12
local bodyrad = 36

function Body:_draw(x,y,r)
	local g = gra
	local m = self.mover
	local x,y,r
	local dot = requireImage'dot.png'
	g.setColor(255,255,255)
	x,y,r = _getXYR(m.body.body)
	g.circle('fill',x,y,bodyrad)
	g.setColor(255,0,0)
	x,y,r = _getXYR(m.body.arm1)
	g.draw(dot,x,y,r,shapewidth,shapeheight,0.5,0.5)
	g.setColor(255,255,0)
	x,y,r = _getXYR(m.body.arm2)
	g.draw(dot,x,y,r,shapewidth,shapeheight,0.5,0.5)
	g.setColor(0,255,0)
	x,y,r = _getXYR(m.body.leg1)
	g.draw(dot,x,y,r,shapewidth,shapeheight,0.5,0.5)
	g.setColor(255,0,255)
	x,y,r = _getXYR(m.body.leg2)
	g.draw(dot,x,y,r,shapewidth,shapeheight,0.5,0.5)
end

local scale = 1.5
function Body:draw(x,y,r)
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
	self:_draw()
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


function Body:draw_LLI(x,y,r)
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

	self:_draw()
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
	
	self:_draw()
	filters.lli_unit.postdraw(self)
	if self.lli_flare then
		gra.setColor(self.lli_color[1],self.lli_color[2],self.lli_color[3],math.random()*127+127)
	end
	gra.draw(requireImage'asset/effect/flare.png',x,y,0,1,1,64,32)


end

function Body:getWidth()
	return scale*64
end

function Body:getHeight()
	return scale*64
end
