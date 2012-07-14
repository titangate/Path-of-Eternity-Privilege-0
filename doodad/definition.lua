local cc = {
	normal = 1,
}
local mask = {
	normal = {},
}

local t = {}
local function easydoodad(name,shape,bodytype,scale,height,obstacle,c,m,selectable)
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
	obstacle = true,
	ox = img:getWidth()/2,
	oy = img:getHeight()/2,
	sx = scale,
	sy = scale,
	layer = height,
	bodytype = bodytype,
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

easydoodad('keyboard','rectangle','kinematic',1,2)
easydoodad('monitor','rectangle','kinematic',1,2)
easydoodad('desk2','rectangle','kinematic',2)
easydoodad('safe')
easydoodad('table','circle')
easydoodad('bed')
easydoodad('desk')
easydoodad('chair')
easydoodad('sinkwithwater')
easydoodad('sink')
easydoodad('toilet')
return t