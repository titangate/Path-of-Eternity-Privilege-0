BodyMover = Object:subclass'BodyMover'
function BodyMover:initialize(x,y,r,bt)
	x = x or 0
	y = y or 0
	r = r or 0
	self.bodytype = bt
	self.x,self.y = x,y
	self.r = r
end

local lp = love.physics
local bodyshape = lp.newCircleShape(24)
local limbshape = lp.newRectangleShape(36,6)
function BodyMover:createBody(world)
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	self.body = {}
	self.fixture = {}
	self.joint = {}
	local x,y = self.x,self.y
	self.body.body = lp.newBody(world,x,y,'dynamic')
	self.fixture.body = lp.newFixture(self.body.body,bodyshape)

	self.body.arm1 = lp.newBody(world,x-6,y-24,'dynamic')
	self.fixture.arm1 = lp.newFixture(self.body.arm1,limbshape)
	self.body.arm1:setAngle(-math.pi/3*2)

	self.body.arm2 = lp.newBody(world,x+6,y-24,'dynamic')
	self.fixture.arm2 = lp.newFixture(self.body.arm2,limbshape)
	self.body.arm2:setAngle(math.pi/3*2)


	self.body.leg1 = lp.newBody(world,x-6,y+24,'dynamic')
	self.fixture.leg1 = lp.newFixture(self.body.leg1,limbshape)
	self.body.leg1:setAngle(math.pi/3*2)

	self.body.leg2 = lp.newBody(world,x+6,y+24,'dynamic')
	self.fixture.leg2 = lp.newFixture(self.body.leg2,limbshape)
	self.body.leg2:setAngle(-math.pi/3*2)

	self.joint.arm1 = lp.newRevoluteJoint(self.body.arm1,self.body.body,x,y)
	self.joint.arm1:setLimits(-math.pi/3*3,-math.pi/3*2)
	self.joint.arm1:enableLimit(true)
	self.joint.arm2 = lp.newRevoluteJoint(self.body.arm2,self.body.body,x,y)

	self.joint.arm2:setLimits(math.pi/3*2,math.pi/3*3)
	self.joint.arm2:enableLimit(true)
	self.joint.leg1 = lp.newRevoluteJoint(self.body.leg1,self.body.body,x,y)
	self.joint.leg1:setLimits(-math.pi/3*3,-math.pi/3*2)
	self.joint.leg1:enableLimit(true)
	self.joint.leg2 = lp.newRevoluteJoint(self.body.leg2,self.body.body,x,y)
	self.joint.leg2:setLimits(math.pi/3*2,math.pi/3*3)
	self.joint.leg2:enableLimit(true)

	for k,v in pairs(self.fixture) do
		v:setMask(1,2) -- TODO: more informatin
		v:setCategory(2)
	end

--	self.body.body:setAngle(self.r)
end

function BodyMover:setUserData(data)
--	if true then return end
	table.insert(self.world.f_update,{self.fixture.arm1,data})
	table.insert(self.world.f_update,{self.fixture.arm2,data})
	table.insert(self.world.f_update,{self.fixture.leg1,data})
	table.insert(self.world.f_update,{self.fixture.leg2,data})
	table.insert(self.world.f_update,{self.fixture.body,data})
--	self.fixture:setUserData(data)
end

function BodyMover:update(dt)
	local vx,vy = self.body.body:getLinearVelocity()
	local mass = -self.body.body:getMass()
	self.body.body:applyLinearImpulse(vx*mass/2,vy*mass/2)
	self.body.body:applyAngularImpulse(-self.body.body:getAngularVelocity()*self.body.body:getInertia()*0.2)
end

function BodyMover:setMovingDirection(x,y)
	assert(type(x)=='number')
	assert(type(y)=='number')
--	print (x*self.speed,y*self.speed)
	self.body:setLinearVelocity(x*self.speed,y*self.speed)
--	local old_x,old_y = self:getVelocity()
--	if x~=old_x or y~=old_y then
--	end
end

function BodyMover:getPosition()
	
	return self.body.body:getPosition()
end

function BodyMover:getX()
	return self.body.body:getX()
end

function BodyMover:getY()
	return self.body.body:getY()
end

function BodyMover:getAngle()
	return self.body.body:getAngle()
end

function BodyMover:getVelocity()
	return self.body.body:getLinearVelocity()
end

function BodyMover:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.body.body:setLinearVelocity(x,y)
end

function BodyMover:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.body.body:setPosition(x,y)
end

function BodyMover:setX(x)
	return self.body.body:setX(x)
end

function BodyMover:setY(x)
	return self.body.body:setY(x)
end

function BodyMover:setAngle(x)
	return self.body.body:setAngle(x)
end

function BodyMover:destroyBody(world)
	-- TODO
end


function BodyMover:valid()
	return true -- TODO
	--return self.fixture and self.fixture:getUserData()~=nil
end


function BodyMover:encode()
	local x,y = self.body:getPosition()
	local r = self.body:getAngle()
	local vx,vy = self.body:getLinearVelocity()
	local va = self.body:getAngularVelocity()
	local bt = self.bodytype
	return {x = x,y=y,r=r,vx=vx,vy=vy,va=va,bt=bt,name='BodyMover'}
end

function BodyMover:load(t)
	for k,v in pairs(t) do
		self[k] = v
	end
end

function DecodeBodyMover(t)
	local m = BodyMover(t.x,t.y,t.r,t.bt)
	m:load(t)
	return m
end
