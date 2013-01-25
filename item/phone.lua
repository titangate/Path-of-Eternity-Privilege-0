
Phone = Item:subclass'Phone'
function Phone:interact(host,target)
	
end

function Phone:initialize(...)
	Item.initialize(self,...)
	
end

function Phone:active(host,target)
	--if self.hit then
	
end

function Phone:equip()
	global.system:setCellphoneState(true)
end

function Phone:unequip()
	global.system:setCellphoneState(false)
end

function Phone:update_i(dt)
	
end

function Phone:setUpgrade(k,v)
	self[k] = v
end

function Phone:draw_lli()
end