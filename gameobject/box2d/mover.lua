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
local shape = lp.newCircleShape(24)
function Box2DMover:createBody(world)
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	self.body = lp.newBody(world,self.x,self.y,self.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
	self.body:setAngle(self.r)
	if self.vx and self.vy and self.va then
		self.body:setLinearVelocity(self.vx,self.vy)
		self.body:setAngularVelocity(self.va)
		self.vx,self.vy,self.va = nil,nil,nil
	end
end

function Box2DMover:setUserData(data)
	table.insert(self.world.f_update,{self.fixture,data})
--	self.fixture:setUserData(data)
end

function Box2DMover:update(dt)
	local x,y = self:getVelocity()
	if x~=0 or y~= 0 then
		self:setAngle(math.atan2(y,x))
	end
end

function Box2DMover:setMovingDirection(x,y)
	assert(type(x)=='number')
	assert(type(y)=='number')
--	print (x*self.speed,y*self.speed)
	self.body:setLinearVelocity(x*self.speed,y*self.speed)
--	local old_x,old_y = self:getVelocity()
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


function Box2DMover:encode()
	local x,y = self.body:getPosition()
	local r = self.body:getAngle()
	local vx,vy = self.body:getLinearVelocity()
	local va = self.body:getAngularVelocity()
	local bt = self.bodytype
	return {x = x,y=y,r=r,vx=vx,vy=vy,va=va,bt=bt,name='Box2DMover'}
end

function Box2DMover:load(t)
	for k,v in pairs(t) do
		self[k] = v
	end
end

function DecodeBox2DMover(t)
	local m = Box2DMover(t.x,t.y,t.r,t.bt)
	m:load(t)
	return m
end
