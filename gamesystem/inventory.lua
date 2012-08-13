Inventory = Object:subclass'Inventory'
local item = require 'gameobject.item'
function Inventory:initialize(unit)
	self.unit = unit
	self.baseitem = {}
	self.active = {1,1}
	self.items = {{},{},{},{}}
	self.barehand = item.create('barehand',0,0,0)
	self.items[0] = {self.barehand}
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

function Inventory:purchase()
	-- TODO
	return true
end

function Inventory:update(dt)
	select(1,self:getActiveItem()):update_i(dt)
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

function Inventory:setActiveItem(a,b)
	self.active = {a,b}
end

function Inventory:getActiveItem()
	local a,b= unpack(self.active)
	return self.items[a][b],a,b
end