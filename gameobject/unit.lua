
Unit = Object:subclass'Unit'
function Unit:initialize(movertype,...)
	if movertype then
		self.mover = movertype(...)
	end
	self.destr_body = nil
	self.destr_head = nil
end

function Unit:getIdentifier()
	return self.identifier
end

function Unit:setIdentifier(d)
	self.identifier = d
	if self.map then
		self.map:setUnitIdentifier(d,self)
	end
end

function Unit:save()
	local mover = self.mover:save()
	return {
		mover = mover,
		initiation = {self.mover.class.name},
		name = self.class.name,
	}
end

function Unit:load(t)
	self.mover:load(t.mover)
end

function Unit:getRepelField()
	local x,y = self:getPosition()
	self.rf = self.rf or CircleArea(x,y,100)
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
			self.area = nil
		end
		if not self.area then
			self.area = area
			area:carryUnit(self,true)
		end
	end
	if self.facing then
		local target,headonly = unpack(self.facing)
		local x1,y1 = self:getPosition()
		local x2,y2 = target:getPosition()
		self:setAngle(math.atan2(y2-y1,x2-x1))
		--[[if headonly then
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
		end]]
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

function Unit:kill(killer)
	local u = self:spawnBody()
	self.map:addUnit(u)
	u.info.dead = true
	if self.onKill then
		self.onKill(self,killer)
	end
	
	self.map:removeUnit(self)
end

function Unit:knockOut()

	local u = self:spawnBody()
	self.map:removeUnit(self)
	self.map:addUnit(u)
	u.info.dead = false
	if self.onKnockOut then
		self.onKnockOut(self)
	end
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

function Unit:getObstacle()
end

function Unit:getLegacyObstacle()
end

function Unit:isObstacle()
	return true
end

function Unit:spawnBody()
	local u = Body(BodyMover,self:getX(),self:getY(),self:getAngle(),nil,self.info)
	self.map:addUnit(u)
	return u
end

function Unit:encode()
	return {
		mover = self.mover:encode(),
		name = self.class.name,
	}
end

if DEBUG then

function Unit:DebugDraw()
--	gra.setColor(0,0,0)
--	gra.circle('fill',self.x,self.y,16)
end
end