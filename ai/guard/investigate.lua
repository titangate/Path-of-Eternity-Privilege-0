AIInvestigate = AIBase:subclass'AIInvestigate'
function AIInvestigate:initialize(unit,target)
	-- waypoint follows format:
	-- [1]:x [2]:y [3]:angle [4]:time
	AIBase.initialize(self,unit)
	self.target = target
end

function AIInvestigate:process(dt)
	local path = self.host:findPath(Vector(self.unit:getPosition()),self.target)
	self.next = AIPath(self.unit,path)
	local prev = self.next
	
	local areas = self.host:getNearbyArea(self.target,2)
	local prevarea = self.target
	while #areas > 0 do
		local t = table.remove(areas,math.random(#areas))
		local p = self.host:findPath(prevarea,t)
		prev.next = AIWait(self.unit,2)
		prev = prev.next
		prev.next = AIPath(self.unit,p)
		prev = prev.next
		prevarea = t
	end
	prev.next = self.next.next
	return 0,'success'
end