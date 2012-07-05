
Unit = Object:subclass'Unit'
function Unit:initialize(movertype,...)
	self.mover = movertype(...)
end

function Unit:getRepelField()
	local x,y = self:getPosition()
	self.rf = self.rf or CircleArea(x,y,50)
	return self.rf
end

function Unit:update(dt)
	if self.mover.update then
		self.mover:update(dt)
	end
	if self.rf then
		self.rf.x,self.rf.y = self:getPosition()
		self.rf._cv = Vector(self.rf:getCenter())
	end
	if self.map then
	local area = self.map:getArea(self:getPosition())
	if self.area and not self.area:contain(self) then
		self.area:carryUnit(self)
	end
	self.area = area
	self.area:carryUnit(self,true)
end
end


function Unit:getPosition()
	return self.mover:getPosition()
end

function Unit:getX()
	return self.mover:getX()
end

function Unit:getY()
	return self.mover:getY()
end

function Unit:getAngle()
	return self.mover:getAngle()
end

function Unit:getVelocity()
	return self.mover:getVelocity()
end

function Unit:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.mover:setLinearVelocity(x,y)
end


function Unit:setMovingDirection(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.mover:setMovingDirection(x,y)
end

function Unit:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.mover:setPosition(x,y)
end

function Unit:setX(x)
	return self.mover:setX(x)
end

function Unit:setY(x)
	return self.mover:setY(x)
end

function Unit:setAngle(x)
	return self.mover:setAngle(x)
end


function Unit:createBody(x)
	if self.mover.createBody then self.mover:createBody(x) end
	if self.mover.setUserData then self.mover:setUserData(self) end
end

function Unit:destroyBody(x)
	if self.area then
		self.area:carryUnit(self)
	end
	if self.mover.destroyBody then self.mover:destroyBody(x) end
end

function Unit:getHeadAngle()
	return self:getAngle()
end

function Unit:getExposure()
	return 10
end

if DEBUG then

function Unit:DebugDraw()
--	love.graphics.setColor(0,0,0)
--	love.graphics.circle('fill',self.x,self.y,16)
end
end