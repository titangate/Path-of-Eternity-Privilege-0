Box2DMover = Object:subclass'Box2DMover'
function Box2DMover:initialize(x,y,r,bt)
	x = x or 0
	y = y or 0
	r = r or 0
	self.bodytype = bt
	self.x,self.y = x,y
	self.r = r
--	self.vx,self.vy = 0,0
	self.speed = 100
end

local lp = love.physics
local shape = lp.newCircleShape(16)
function Box2DMover:createBody(world)
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	self.body = lp.newBody(world,self.x,self.y,self.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
end

function Box2DMover:setUserData(data)
	table.insert(self.world.f_update,{self.fixture,data})
	self.fixture:setUserData(data)
end

function Box2DMover:update(dt)
	local x,y = self:getVelocity()
	if x~=0 and y~= 0 then
		self:setAngle(math.atan2(y,x))
	end
end

function Box2DMover:setMovingDirection(x,y)
	assert(type(x)=='number')
	assert(type(y)=='number')
--	print (x*self.speed,y*self.speed)
	self.body:setLinearVelocity(x*self.speed,y*self.speed)
	local old_x,old_y = self:getVelocity()
--	if x~=old_x or y~=old_y then
--	end
end

function Box2DMover:getPosition()
	
	return self.body:getPosition()
end

function Box2DMover:getX()
	return self.body:getX()
end

function Box2DMover:getY()
	return self.body:getY()
end

function Box2DMover:getAngle()
	return self.body:getAngle()
end

function Box2DMover:getVelocity()
	return self.body:getLinearVelocity()
end

function Box2DMover:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.body:setLinearVelocity(x,y)
end

function Box2DMover:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.body:setPosition(x,y)
end

function Box2DMover:setX(x)
	return self.body:setX(x)
end

function Box2DMover:setY(x)
	return self.body:setY(x)
end

function Box2DMover:setAngle(x)
	return self.body:setAngle(x)
end

function Box2DMover:destroyBody(world)
	self.fixture:setMask(unpack(collisoninfo.all))
	world:destroyNext(self.fixture,self.body)
	self.fixture = nil
	self.body = nil
end


function Box2DMover:valid()
	return self.fixture and self.fixture:getUserData()~=nil
end
