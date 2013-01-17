
	require 'network'
Food = Item:subclass'Food'
function Food:interact(host,target)
	
end

function Food:initialize(...)
	Item.initialize(self,...)
	
end

function Food:active(host,target)
	--if self.hit then
	
end

function Food:equip()
	getFood(self.info.title)
end

function Food:unequip()
	--global.system:setCellFoodState(false)
end

function Food:update_i(dt)
	
end

function Food:setUpgrade(k,v)
	self[k] = v
end

function Food:draw_lli()
end