AIPatrol = AIBase:subclass'AIPatrol'
function AIPatrol:initialize(unit,waypoint)
	-- waypoint follows format:
	-- [1]:x [2]:y [3]:angle [4]:time
	assert(#waypoint>1,'has to be more than 1 way point.')
	AIBase.initialize(self,unit)
	self.waypoint = waypoint
end

function AIPatrol:process(dt)
	local waypoint = self.waypoint
	local prev = AIPath(self.unit,self.host:findPath(Vector(self.unit:getPosition()),waypoint[1]))
--	print (prev[1]:getCenterVector())
	local initial = prev
	local new
	for i=1,#waypoint-1 do
		local a,b = waypoint[i],waypoint[i+1]
		local path = self.host:findPath(a,b)
		new = AIPath(self.unit,path)
		prev.next = new
		if b[3] then
			new.next = AITurn(self.unit,b[3])
			new = new.next
		end
		if b[4] then
			new.next = AIWait(self.unit,b[4])
			new = new.next
		end
		prev = new
	end
	self.next = initial
	new.next = initial
	return 0,'success'
end