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
				if prev_layer < post_layer then
					self.onSel = b
				end
			end
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
	self.onSel = nil
		self:releaseSelection()
	local x,y = love.mouse.getPosition()
	self.map.world:queryBoundingBox(x-2,y-2,x+2,y+2,self.queryCallback)
	self:setSelection(self.onSel)
end

function Selection:mousepressed(x,y,b)
	if self.object and b=='r' then
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