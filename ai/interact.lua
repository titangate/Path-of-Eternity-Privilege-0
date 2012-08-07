AIInteract = AIBase:subclass'AIInteract'
function AIInteract:initialize(unit,obj)
	AIBase.initialize(self,unit)
	self.obj = obj
end

function AIInteract:process(dt)
	if self.obj and self.obj.info.interact then
		interactfunc[self.obj.info.interact](self.unit,self.obj)
	end
	return 0,'success'
end