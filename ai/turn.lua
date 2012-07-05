AITurn = AIBase:subclass'AITurn'
function AITurn:initialize(unit,angle)
	AIBase.initialize(self,unit)
	self.angle = angle
end

function AITurn:process(dt)
	self.unit:setAngle(self.angle)
	return 0,'success'
end