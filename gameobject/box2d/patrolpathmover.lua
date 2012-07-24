PatrolPathMover = Object:subclass'PatrolPathMover'
function PatrolPathMover:initialize(points)
	self.points = points
end

local lp = love.physics
function PatrolPathMover:createBody(world)
	if #self.points < 3 then return end
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	local p = {}
	for i,v in ipairs(self.points) do
		table.insert(p,v.x)
		table.insert(p,v.y)
	end
	local shape = lp.newPolygonShape(unpack(p))
	self.body = lp.newBody(world,0,0,self.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
	self.fixture:setSensor(true)
end

function PatrolPathMover:setPoints(p)
	self.points = p
end

function PatrolPathMover:setUserData(data)
	if not self.fixture then return end
	table.insert(self.world.f_update,{self.fixture,data})
--	self.fixture:setUserData(data)
end

function PatrolPathMover:update(dt)
end

function PatrolPathMover:setMovingDirection(x,y)
	assert(type(x)=='number')
	assert(type(y)=='number')
--	print (x*self.speed,y*self.speed)
	self.body:setLinearVelocity(x*self.speed,y*self.speed)
--	local old_x,old_y = self:getVelocity()
--	if x~=old_x or y~=old_y then
--	end
end

function PatrolPathMover:getPosition()
	
	return self.body:getPosition()
end

function PatrolPathMover:getX()
	return self.body:getX()
end

function PatrolPathMover:getY()
	return self.body:getY()
end

function PatrolPathMover:getAngle()
	return self.body:getAngle()
end

function PatrolPathMover:getVelocity()
	return self.body:getLinearVelocity()
end

function PatrolPathMover:setVelocity(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	self.body:setLinearVelocity(x,y)
end

function PatrolPathMover:setPosition(x,y)
	if type(x)=='table' then
		x,y = unpack(x)
	end
	return self.body:setPosition(x,y)
end

function PatrolPathMover:setX(x)
	return self.body:setX(x)
end

function PatrolPathMover:setY(x)
	return self.body:setY(x)
end

function PatrolPathMover:setAngle(x)
	return self.body:setAngle(x)
end

function PatrolPathMover:destroyBody(world)
	if not self.fixture then return end
	self.fixture:setMask(unpack(collisoninfo.all))
	world:destroyNext(self.fixture,self.body)
	self.fixture = nil
	self.body = nil
end


function PatrolPathMover:valid()
	return self.fixture and self.fixture:getUserData()~=nil
end


function PatrolPathMover:encode()
end

function PatrolPathMover:load(t)
end

