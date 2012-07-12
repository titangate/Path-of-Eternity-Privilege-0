Selection = Object:subclass'Selection'
function Selection:initialize(map)
	self.map = map
	self.queryCallback = function(fixture)
		if not fixture then return false end
		local b = fixture:getUserData()
		if b then
			self:setSelection(b)
			return false
		end
		return true
	end
end

function Selection:setSelection(obj)

	self:releaseSelection()
	if not obj then return end
	self.object = obj
	self.object.drawSelection = true
	self.object.selection_intensity = 1
end

function Selection:releaseSelection()
	if self.object then
--		self.object.drawSelection = false
			self.object.drawSelection = nil
			self.object.selection_intensity = nil
	end
	self.object = nil
end

function Selection:update(dt)
	assert(self.map.world)
	local x,y = love.mouse.getPosition()
	self.map.world:queryBoundingBox(x-2,y-2,x+2,y+2,self.queryCallback)
end

function Selection:interact(obj)

end