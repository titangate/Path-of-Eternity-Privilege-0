Selection = Object:subclass'Selection'
function Selection:initialize(obj)
	if obj then
		self:setSelection(obj)
	end
end

function Selection:setSelection(obj)
	self:releaseSelection()
	self.object = obj
	self.object.drawSelection = true
	self.object.selection_intensity = 0
	loveframes.anim:easy(self.object,'selection_intensity',0,2,0.9)
end

function Selection:releaseSelection()
	if self.object then
--		self.object.drawSelection = false
		loveframes.anim:easy(self.object,'selection_intensity',2,0,0.9)
		coroutinemsg(coroutine.resume(coroutine.create(function (  )
			wait(1)
			self.object.drawSelection = nil
			self.object.selection_intensity = nil
		end)))
	end
	self.object = nil
end

function Selection:interact(obj)

end