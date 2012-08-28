Item = Doodad:subclass'Item'
function Item:equip(unit)
end

function Item:unequip(unit)
end

function Item:drawInHand(unit)
end

function Item:draw()
end

function Item:use(target)
end

function Item:update_i()
end

function Item:draw_lli()
end

function Item:active()
end

function Item:decode()
end

function Item:encode()
	local x,y = 0,0
	local r = 0
	if self.mover:valid() then
		x,y = self.mover:getPosition()
		r = self.mover:getAngle()
	end
	return {itemname = self.info.name,x=x,y=y,r=r,name='Item'}
end
local item = {}
local itemdef
function item.load()
	itemdef = require 'item.definition'
end

function item.decode(t)
	local i = item.create(t.itemname,t.x,t.y,t.r)
	i:decode(t)
	return i
end

function item.create(def,x,y,r)
	if type(def) == 'string' then
		assert(itemdef[def],string.format("%s definition not found.",def))
		def = itemdef[def]
	end
	local d = def.class(doodadMover,x,y,r,def.bodytype,def)
	return d
end

item.load()

return item