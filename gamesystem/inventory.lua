Inventory = Object:subclass'Inventory'

function Inventory:initialize(unit)
	self.unit = unit
	self.baseitem = {}
	self.items = {{},{},{},{}}
end

function Inventory:interact(target)
end

function Inventory:setBaseItem(slot,item)
	self.baseitem[slot] = item
end

function Inventory:addItem(slot,item)
	table.insert(self.items[slot],item)
	item.owner = self.unit
end

function Inventory:removeItem(slot,item)
	local i = 1
	while self.items[slot][i]~=item do
		i = i + 1
	end
	table.remove(self.items[slot],i)
end

function Inventory:getFirstLayout()
	local t = {}
	for i,v in ipairs(self.baseitem) do
		assert(v.info.title)
		t[i] = {
			image = v.info.icon,
			text = LocalizedString(v.info.title),
		}
		assert(t[i].text)
	end
	return t
end

function Inventory:update(dt)
	select(1,self:getActiveItem()):update(dt)
end

function Inventory:draw()
	select(1,self:getActiveItem()):draw()
end

function Inventory:draw_lli()
	select(1,self:getActiveItem()):draw_lli()
end

function Inventory:getSecondLayout(n)
	local t = {}
	for i,v in ipairs(self.items[n]) do
		assert(v.info.title)
		t[i] = {
			image = v.info.icon,
			text = LocalizedString(v.info.title),
		}
		assert(t[i].text)
	end
	return t
end

function Inventory:setActiveItem()
end

function Inventory:getActiveItem()
	return self.items[2][1],1,1
end