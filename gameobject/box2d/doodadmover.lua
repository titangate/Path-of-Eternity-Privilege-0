require 'gameobject.box2d.mover'
doodadMover = Box2DMover:subclass'doodadMover'
function doodadMover:initialize(x,y,r,bt,info)
	Box2DMover.initialize(self,x,y,r,bt)
	self.info = info
end

local lp = love.physics
function doodadMover:createBody(world)
	local shape 
	local i = self.info
	if i.shape == 'rectangle' then
		shape = lp.newRectangleShape(i.width,i.height)
	elseif i.shape == 'circle' then
		shape = lp.newCircleShape(i.width/2)
	end
	self.world = world
	if type(world)=='table' then
		world = world.world
	end
	self.body = lp.newBody(world,self.x,self.y,self.info.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
	self.body:setAngle(self.r)
end

local maxImpulse = 5
function doodadMover:update(dt)
	if self.info.bodytype == 'static' then return end
	Box2DMover.update(self,dt)
	local vx,vy = self.body:getLinearVelocity()
	if vx~=0 and vy ~=0 then
	local v = Vector(vx,vy)*-self.body:getMass()
	if v:length() > maxImpulse then
		v = v*maxImpulse/v:length()
	end
	self.body:applyLinearImpulse(v.x,v.y)
end
	self.body:applyAngularImpulse(0.1*self.body:getInertia()*-self.body:getAngularVelocity())
end

function doodadMover:valid()
	return self.fixture and self.fixture:getUserData()~=nil
end

function doodadMover:save()
	local x,y = self.body:getPosition()
	local r = self.body:getAngle()
	return {x = x,y=y,r=r,info=self.info}
end

function doodadMover:isObstacle()
	return true
end

function doodadMover:load(t)
	for k,v in pairs(t) do
		self[k] = v
	end
end