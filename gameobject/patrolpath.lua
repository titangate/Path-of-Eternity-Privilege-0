PatrolPath = Object:subclass'PatrolPath'

function PatrolPath:initialize(p)
	self.waypoint = p or {}
	self.mover = PatrolPathMover(p)

end

function PatrolPath:encode(t)
	return {waypoint = self.waypoint,
	name = 'PatrolPath'}
end

function PatrolPath:decode(t)
	self.waypoint = t.waypoint
end

function PatrolPath:draw()
	love.graphics.setColor(0,255,0)
	love.graphics.setLineWidth(3)
	for i=1,#self.waypoint do
		local j = (i%#self.waypoint)+1
		local a,b = self.waypoint[i],self.waypoint[j]
		love.graphics.line(a.x,a.y,b.x,b.y)
		love.graphics.circle('line',a.x,a.y,5)
	end
end

function PatrolPath:update(dt)
end

function PatrolPath:setPoints(p)
	self.waypoint = p
	self.mover:setPoints(p)
	if self.world then
		self:destroyBody(self.world)
		self:createBody(self.world)
	end
end

function PatrolPath:addPoint(p)
	table.insert(self.waypoint,p)
	self.mover:setPoints(self.waypoint)
	if self.world then
		self:destroyBody(self.world)
		self:createBody(self.world)
	end
end

function PatrolPath:getPosition()return 0,0 end

function PatrolPath:getAngle() return 0 end

function PatrolPath:getX() return 0 end

function PatrolPath:getY() return 0 end

function PatrolPath:getIdentifier() return nil end

function PatrolPath:setPosition()return 0,0 end

function PatrolPath:setAngle() return 0 end

function PatrolPath:setX() return 0 end

function PatrolPath:setY() return 0 end

function PatrolPath:setIdentifier() return nil end

function PatrolPath:createBody(x)
	self.world = x
	if self.mover.createBody then self.mover:createBody(x) end
	if self.mover.setUserData then self.mover:setUserData(self) end
end

function PatrolPath:destroyBody(x)
	if self.mover.destroyBody then self.mover:destroyBody(x) end
end