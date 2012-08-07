AIWait = AIBase:subclass'AIWait'
function AIWait:initialize(unit,time)
--	super.initialize(unit)
	AIBase.initialize(self,unit)
	self.time = time
	self.dt = time
end
function AIWait:process(dt)
	local u = self.unit
	self.dt = self.dt - dt
	if self.dt <= 0 then
		return -self.dt,'success'
	end
end

function AIWait:reset()
	self.dt = self.time
end


function AIWait:encode()
	return {
		name = 'AIWait',
		dt = self.dt,
		time = self.time,
	}
end

function AIWait:decode(t)
	self.dt = t.dt
	self.time = t.time
end

if DEBUG then
function AIWait:DebugDraw()
	local x,y = self.unit:getPosition()
	pn(string.format("waiting for %.2f",self.dt),x,y)
end
end