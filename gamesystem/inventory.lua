Inventory = Object:subclass'Inventory'

function Inventory:initialize(unit)
	self.unit = unit
	self.baseitem = {}
end

function Inventory:interact(target)
end

function Inventory:setBaseItem(slot,item)
	self.baseitem[slot] = item
end

function Inventory:getFirstLayout()
	local t = {}
	for i,v in ipairs(self.baseitem) do
		print (i,v.info.title)
		assert(v.info.title)
		t[i] = {
			image = v.info.icon,
			text = v.info.title,
		}
		assert(t[i].text)
	end
	return t
end

function Inventory:getActiveItem()
	return self.baseitem[1]
end