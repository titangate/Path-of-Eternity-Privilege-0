Selection = Object:subclass'Selection'
function Selection:initialize(map)
	self.map = map
	self.queryCallback = function(fixture)
		if not fixture then return false end
		local b = fixture:getUserData()
		if b then
			if not self.onSel then
				self.onSel = b
			else
				local prev_layer = self.onSel.layer or 1
				local post_layer = b.layer or 1
				if prev_layer <= post_layer then
					self.onSel = b
				end
			end
		end
		return true
	end
end

function Selection:setSelection(obj)

	self:releaseSelection()
	if not obj then

	if self.onDeselect then
		self.onDeselect()
	end
	return end
	self.object = obj
	self.object.drawSelection = true
	self.object.selection_intensity = 1
	if self.onSelect then
		self.onSelect(obj)
	end
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
	self.onSel = nil
	self:releaseSelection()
	local x,y = self.map:screenToMap(love.mouse.getPosition())
	self.map.world:queryBoundingBox(x-2,y-2,x+2,y+2,self.queryCallback)
	self:setSelection(self.onSel)
end

function Selection:mousepressed(x,y,b)
	if self.object and b=='r' then
		self:interact(self.object)
	end
end

function Selection:interact(obj)
	if self.onInteract and obj and obj.mover:valid() then
		self.onInteract(obj)
	end
end

function Selection:setDelegate(del)
	self.del = del
end