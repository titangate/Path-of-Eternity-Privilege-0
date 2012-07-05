Human = Unit:subclass'Human'

function Human:initialize(...)
	Unit.initialize(self,...)
	self.head = requireImage'unit/generichead.png'
	self.shoulder = requireImage'unit/genericshoulder.png'
	self.feet = requireImage'unit/genericfoot.png'
	self.headtilt = 0
	self.walkdt = 0
	self.feetshift = 0
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

function Human:getHeadAngle()
	return self:getAngle() + self.headtilt
end

function Human:draw()
	local g = love.graphics
	local x,y = self:getPosition()
	local r = self:getAngle()
	g.setColor(255,255,255)
	g.draw(self.feet,x,y,r+self.headtilt,1,1,32+self.feetshift*7,22)
	g.draw(self.feet,x,y,r+self.headtilt,1,1,32-self.feetshift*7,42)
	g.draw(self.shoulder,x,y,r,1,1,32,32)
	g.draw(self.head,x,y,r+self.headtilt,1,1,32,32)
end