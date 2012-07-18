AIFindPath = AIBase:subclass'AIFindPath'
function AIFindPath:initialize(unit,target,errorrange)
	AIBase.initialize(self,unit)
	self.target = target
	self.errorrange = errorrange or 0
end

function AIFindPath:process(dt)
	local path = self.host:findPath(Vector(self.unit:getPosition()),self.target,self.errorrange)
	local n = self.next
	self.next = AIPath(self.unit,path)
	self.next.next = n or self.next.next
	return 0,'success'
end