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
	if self.del then
		self.del:setSelection(obj)
	end
end

function Selection:releaseSelection()
	if self.object then
--		self.object.drawSelection = false
			self.object.drawSelection = nil
			self.object.selection_intensity = nil
	end
	self.object = nil
	if self.del then
		self.del:releaseSelection()
	end
end

function Selection:update(dt)
	assert(self.map.world)
	local x,y = love.mouse.getPosition()
	self.map.world:queryBoundingBox(x-2,y-2,x+2,y+2,self.queryCallback)
	if love.mouse.isDown'l' then
		self:interact(self.object)
	end
end

function Selection:interact(obj)
	if self.del and obj and obj.mover:valid() then
		self.del:interact(obj)
	end
end

function Selection:setDelegate(del)
	self.del = del
end