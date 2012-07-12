Human = Unit:subclass'Human'

function Human:initialize(...)
	Unit.initialize(self,...)
	self.head = requireImage'unit/riverhead.png'
	self.shoulder = requireImage'unit/rivershoulder.png'
	self.feet = requireImage'unit/genericfoot.png'
	self.headtilt = 0
	self.walkdt = 0
	self.feetshift = 0
	self.headstrain = 1
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

function Human:draw()
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
		stroke.prevc = love.graphics.getCanvas()
		love.graphics.setCanvas(c.canvas)
		stroke.c = c
		love.graphics.push()
		love.graphics.translate(-obj:getX()+32+(w2-w)/1,-obj:getY()+32)
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w2)
	end
	local g = love.graphics
	local x,y = self:getPosition()
	local r = self:getAngle()
	g.setColor(255,255,255)
	g.draw(self.feet,x,y,r,1,1,30+self.feetshift*7,22)
	g.draw(self.feet,x,y,r,1,1,30-self.feetshift*7,42)
	g.draw(self.shoulder,x,y,r,1,1,32,32)
	g.draw(self.head,x,y,r+self.headtilt,1,1,32,32)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection

		local w = obj:getWidth()
		local h = obj:getHeight()
		local w2 = math.min(screen.width,neartwo(w*1))
		love.graphics.pop()
		love.graphics.setCanvas(stroke.prevc)
		love.graphics.setPixelEffect(stroke.pe)
		love.graphics.setColor(0,255,0)
		love.graphics.draw(stroke.c.canvas,obj:getX()-32-(w2-w)/1,obj:getY()-32)
		canvasmanager.releaseCanvas(stroke.c)
		love.graphics.setPixelEffect()
		stroke.c = nil
	end
end

function Human:getWidth()
	return 64
end

function Human:getHeight()
	return 64
end