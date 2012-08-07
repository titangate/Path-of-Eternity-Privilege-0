AIFacing = AIBase:subclass'AIFacing'
function AIFacing:initialize(unit,target)
	AIBase.initialize(self,unit)
	self.target = target
end

function AIFacing:process(dt)
	--self.unit:setMovingDirection(0,0)
	if self.target then
		local x1,y1
		if self.target.getPosition then
			x1,y1 = self.target:getPosition()
		else
			x1,y1 = self.target.x,self.target.y
		end
		local x2,y2 = self.unit:getPosition()
		self.unit:setAngle(math.atan2(y1-y2,x1-x2))
	end
	return
end


function AIFacing:setTarget(t)
	self.target = t
end


function AIFacing:encode()
	return {
		name = 'AIFacing',
		target = self.host:getIdentifier(self.target),
		unit = self.host:getIdentifier(self.unit),

	}
end

function AIFacing:decode(t)
	self.target = self.host:getUnit(t.target)
	self.unit = self.host:getUnit(t.unit)
end