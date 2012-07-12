
Unit = Object:subclass'Unit'
function Unit:initialize(movertype,...)
	self.mover = movertype(...)
	self.destr_body = nil
	self.destr_head = nil
end

function Unit:getRepelField()
	local x,y = self:getPosition()
	self.rf = self.rf or CircleArea(x,y,50)
	self.rf.attract = true
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
	if self.facing then
		local target,headonly = unpack(self.facing)
		local x1,y1 = self:getPosition()
		local x2,y2 = target:getPosition()
		if headonly then
			self.destr_head = math.atan2(y2-y1,x2-x1)
			self.destr_body = nil
		else
			
			self.destr_body = math.atan2(y2-y1,x2-x1)
			self.destr_head = nil
		end
		if self.destr_body then
			
			local dr = dt*3
			if math.abs(self:getAngle()-self.destr_body) <= dr then
				self:setAngle(self.destr_body)
				self.destr_body = nil
			else
				if self:getHeadAngle()>self.destr_body then
					self:setAngle(self:getAngle()-dr)
				else
					self:setAngle(self:getAngle()+dr)
				end
			end
		end
		if self.destr_head then
			
			local dr = dt*3
			if math.abs(self:getHeadAngle()-self.destr_head) <= dr then
				self:setHeadAngle(self.destr_head)
				self.destr_head = nil
			else
				if self:getHeadAngle()>self.destr_head then
					self:setHeadAngle(self:getHeadAngle()-dr)
				else
					self:setHeadAngle(self:getHeadAngle()+dr)
				end
			end
		else
			self:setHeadAngle(self:getAngle())
		end
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
--	self.updatedata = true
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

function Unit:face(target,headonly)
	if not target then self.facing = nil; return end
	self.facing = {target,headonly}
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