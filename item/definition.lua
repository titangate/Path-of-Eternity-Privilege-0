
require 'item.improviseweapon'
require 'item.gun'

local cc = {
	normal = 1,
}
local mask = {
	normal = {},
}

local t = {}
local function easyitem(p)
	local name = p.name
	local shape = p.shape
	local bodytype =  p.bodytype
	local scale =  p.scale
	local height =  p.height
	local obstacle = p.obstacle
	if obstacle == nil then
		obstacle = true
	end
	local c = p.c
	local m = p.m
	local selectable = p.selectable
	local interact = p.interact
	bodytype = bodytype or 'kinematic'
	height = height or 1
	scale = scale or 1
	local c = c or cc.normal
	local m = m or mask.normal
	shape = shape or 'rectangle'
	local img = requireImage('item/'..name..'.png')

	t[name] = {
		image = name..'.png',
		icon = p.icon or 'item/'..name..'.png',
		collision = c,
		mask = m,
		width = img:getWidth()*scale*0.8,
		height = img:getHeight()*scale*0.8,
		shape = shape,
		selectable = selectable,
		obstacle = obstacle,
		ox = img:getWidth()/2,
		oy = img:getHeight()/2,
		sx = scale,
		sy = scale,
		layer = height,
		bodytype = bodytype,
		title = p.title or name,
		description = p.description,
		interact = interact,
		class = p.class or Item,
		method = p.method,
		name = name,
	}
end

easyitem{name='kitchenknife',height=2,class = ImproviseWeapon,title = LocalizedString'KITCHEN KNIFE',method = function(n) return string.format("%s was stabbed in the neck.",n) end,}
easyitem{name='improvisation',height=2,class = ImproviseWeapon,title = LocalizedString'IMPROVISATION'}
easyitem{name='needle',height=2,class = ImproviseWeapon,title = LocalizedString'SYRINGE'}
easyitem{name='gun',height=2,class = Gun,title = LocalizedString'GUN',method = function(n) return string.format("%s was executed with a bullet in the head.",n) end,}
easyitem{name='barehand',height=2,class = Barehand,title = LocalizedString'BAREHAND'}
return t