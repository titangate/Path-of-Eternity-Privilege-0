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
		filters.selection:conf(self)
		filters.selection:predraw(self)
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
		filters.selection.postdraw()
	end
end