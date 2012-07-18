AIInteract = AIBase:subclass'AIInteract'
local c = 0
function AIInteract:initialize(unit,obj)
	AIBase.initialize(self,unit)
	self.obj = obj
end

function AIInteract:process(dt)
	print (self.next)
	assert(c==0)
	c = 1
	if self.obj and self.obj.info.interact then
		interactfunc[self.obj.info.interact](self.obj,self.unit)
	end
	return 0,'success'
end