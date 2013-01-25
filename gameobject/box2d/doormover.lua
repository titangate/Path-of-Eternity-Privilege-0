DoorMover = Object:subclass'DoorMover'
function DoorMover:initialize(x,y,r,bt,block)
	x = x or 0
	y = y or 0
	r = r or 0
	self.bodytype = bt
	self.x,self.y = x,y
	self.r = r
	self.block = block
end

local lp = love.physics
local shape = lp.newRectangleShape(64,0,100,32)
function DoorMover:createBody(world)
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	self.body = lp.newBody(world,self.x,self.y,self.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
	self.body:setAngle(self.r)

	self.doorjoint = love.physics.newRevoluteJoint(self.block,self.body,self.x,self.y)
	self.currentOpening = self.r
	self.doorjoint:enableLimit(true)
end

function DoorMover:setOpen(state,direction)
	if state then

		self.currentOpening = self.r + direction*math.pi/2
		local a,b = math.max(self.currentOpening,self.r),math.min(self.currentOpening,self.r)
		self.doorjoint:setLimits(b,a)
		self.doorjoint:enableMotor(true)
		self.doorjoint:setMotorSpeed(direction)
		self.doorjoint:setMaxMotorTorque(100000)
	else
		self.doorjoint:setMotorSpeed(-self.doorjoint:getMotorSpeed())
	end
end

function DoorMover:setUserData(data)
	table.insert(self.world.f_update,{self.fixture,data})
--	self.fixture:setUserData(data)
end

function DoorMover:update(dt)
--	self.body:setPosition(self.x,self.y)
end

function DoorMover:getPosition()
	
	return self.body:getPosition()
end

function DoorMover:getX()
	return self.body:getX()
end

function DoorMover:getY()
	return self.body:getY()
end

function DoorMover:getAngle()
	return self.body:getAngle()
end

function DoorMover:getVelocity()
	return self.body:getLinearVelocity()
end

function DoorMover:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.body:setLinearVelocity(x,y)
end

function DoorMover:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.body:setPosition(x,y)
end

function DoorMover:setX(x)
	return self.body:setX(x)
end

function DoorMover:setY(x)
	return self.body:setY(x)
end

function DoorMover:setAngle(x)
	return self.body:setAngle(x)
end

function DoorMover:destroyBody(world)
	self.fixture:setMask(unpack(collisoninfo.all))
	world:destroyNext(self.fixture,self.body)
	self.doorjoint:destroy()
	self.fixture = nil
	self.body = nil
end


function DoorMover:valid()
	return self.fixture and self.fixture:getUserData()~=nil
end


function DoorMover:encode()
	local x,y = self.body:getPosition()
	local r = self.body:getAngle()
	local vx,vy = self.body:getLinearVelocity()
	local va = self.body:getAngularVelocity()
	local bt = self.bodytype
	return {x = x,y=y,r=r,vx=vx,vy=vy,va=va,bt=bt,name='DoorMover'}
end

function DoorMover:load(t)
	for k,v in pairs(t) do
		self[k] = v
	end
end

function DecodeDoorMover(t)
	local m = DoorMover(t.x,t.y,t.r,t.bt)
	m:load(t)
	return m
end
