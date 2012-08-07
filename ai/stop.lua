AIStop = AIBase:subclass'AIStop'
function AIStop:initialize(unit)
	AIBase.initialize(self,unit)
end

function AIStop:process(dt)
	self.unit:setMovingDirection(0,0)
	return 0,'success'
end


function AIStop:encode()
	return {
		name = 'AIStop',
	}
end

function AIStop:decode(t)
end