Mover = Object:subclass'Mover'
function Mover:initialize(x,y,r)
	x = x or 0
	y = y or 0
	r = r or 0
	self.x,self.y = x,y
	self.r = r
	self.vx,self.vy = 0,0
	self.speed = 100
end

function Mover:setMovingDirection(x,y)
	assert(type(x)=='number')
	assert(type(y)=='number')
	self.vx,self.vy = x*self.speed,y*self.speed
	if y~=0 or x~=0 then
		self.r = math.atan2(y,x)
	end
end

function Mover:getPosition()
	return self.x,self.y
end

function Mover:update(dt)
	self.x,self.y = self.vx*dt + self.x,self.vy*dt + self.y
end

function Mover:getX()
	return self.x
end

function Mover:getY()
	return self.y
end

function Mover:getAngle()
	return self.r
end

function Mover:getVelocity()
	return self.vx,self.vy
end

function Mover:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.vx,self.vy = x,y
end

function Mover:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.x,self.y = x,y
end

function Mover:setX(x)
	self.x = x
end

function Mover:setY(y)
	self.y = y
end

function Mover:setAngle(r)
	self.r = r
end

function Mover:valid()
	return true
end
