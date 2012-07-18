AIFindPath = AIBase:subclass'AIFindPath'
function AIFindPath:initialize(unit,target)
	AIBase.initialize(self,unit)
	self.target = target
end

function AIFindPath:process(dt)
	local path = self.host:findPath(Vector(self.unit:getPosition()),self.target)
	path.next = self.next or path.next
	self.next = AIPath(self.unit,path)
	return 0,'success'
end