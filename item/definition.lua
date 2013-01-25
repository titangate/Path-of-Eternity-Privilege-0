
require 'item.improviseweapon'
require 'item.gun'
require 'item.phone'
require 'item.syringe_tetrodotoxin'
require 'item.syringe_angexetine'
require 'item.syringe_ketamine'

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
	local img = requireImage(p.image or 'item/'..name..'.png')

	t[name] = {
		image = p.image or 'item/'..name..'.png',
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
easyitem{name='improvisation',height=2,class = Item,title = LocalizedString'IMPROVISATION'}
easyitem{name='firearm',height=2,class = Item,title = LocalizedString'FIREARM'}
easyitem{name='utility',height=2,class = Item,title = LocalizedString'UTILITY'}
easyitem{name='phone',height=2,class = Phone,title = LocalizedString'CELLPHONE'}
easyitem{name='needle',height=2,class = Item,title = LocalizedString'SYRINGE'}
easyitem{name='gun',height=2,class = Gun,title = LocalizedString'GUN',method = function(n) return string.format("%s was executed with a bullet in the head.",n) end,}
easyitem{name='syringe_tetrodotoxin',height=2,class = SyringeTetrodotoxin,title = LocalizedString'TETRODOTOXIN SYRINGE',method = function(n) return string.format("%s was poisoned with the deadly tetrodotoxin.",n) end,icon = 'item/Tetrodotoxin.png',image ='item/needle.png'}
easyitem{name='syringe_angexetine',height=2,class = SyringeAngexetine,title = LocalizedString'ANGEXETINE SYRINGE',icon = 'item/angexetine.png',image ='item/needle.png'}
easyitem{name='syringe_ketamine',height=2,class = SyringeKetamine,title = LocalizedString'KETAMINE SYRINGE',icon = 'item/ketamine.png',image ='item/needle.png'}
easyitem{name='barehand',height=2,class = Barehand,title = LocalizedString'BAREHAND'}
return t