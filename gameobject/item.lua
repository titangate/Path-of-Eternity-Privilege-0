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
require 'item.improviseweapon'

local item = {}
local itemdef
function item.load()
	itemdef = require 'item.definition'
end

function item.decode(t)
	return item.create(t.info,t.x,t.y,t.r)
end

function item.create(def,x,y,r)
	if type(def) == 'string' then
		def = itemdef[def]
	end
	local d = def.class(doodadMover,x,y,r,def.bodytype,def)
	return d
end

return item