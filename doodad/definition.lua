local cc = {
	normal = 1,
}
local mask = {
	normal = {},
}

local t = {}
local function easydoodad(p)
	local name = name or p.name
	local shape = shape or p.shape
	local bodytype = bodytype or p.bodytype
	local scale = scale or p.scale
	local height = height or p.height
	local obstacle = p.obstacle
	if obstacle == nil then
		obstacle = true
	end
	local c = c or p.c
	m = m or p.m
	selectable = selectable or p.selectable
	bodytype = bodytype or 'kinematic'
	height = height or 1
	scale = scale or 1
	c = c or cc.normal
	m = m or mask.normal
	shape = shape or 'rectangle'
	local img = requireImage('doodad/'..name..'.png')
	t[name] = {
		image = name..'.png',
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
		name = p.title or name,
		description = p.description
	}
end

t.desk2small = {
	image = 'desk2.png',
	collision = cc.normal,
	mask = mask.normal,
	width = 100,
	height = 40,
	sx = 1,
	shape = 'rectangle',
	bodytype = 'kinematic',
	selectable = true,
	interaction = nil,
	ox = 116/2,
	oy = 48/2,
	obstacle = true,
}

easydoodad{name='keyboard',height=2}
easydoodad{name='monitor',height=2}
easydoodad{name='desk2',scale=2}
easydoodad{name='safe',
title = "RIVER'S SAFE",
description = "STORES RIVER'S ARTIFICIAL MUTATION CONTROL KIT"
}
easydoodad{name='chair'}
easydoodad{name='bed'}
easydoodad{name='desk'}
easydoodad{name='sinkwithwater'}
easydoodad{name='sink'}
easydoodad{name='table',shape='circle'}

return t