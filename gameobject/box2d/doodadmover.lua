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
	self.body = lp.newBody(world,self.x,self.y,self.bodytype or 'dynamic')
	self.fixture = lp.newFixture(self.body,shape)
end

local maxImpulse = 5
function doodadMover:update(dt)
	Box2DMover.update(self,dt)
	local v = Vector(self.body:getLinearVelocity())*-self.body:getMass()
	if v:length() > maxImpulse then
		v = v*maxImpulse/v:length()
	end
	self.body:applyLinearImpulse(v.x,v.y)

	self.body:applyAngularImpulse(0.1*self.body:getInertia()*-self.body:getAngularVelocity())
end

function doodadMover:valid()
	return self.fixture and self.fixture:getUserData()~=nil
end