local cc = {
	normal = 1,
}
local mask = {
	normal = {},
}
return {
desk2 = {
	image = 'desk2.png',
	collision = cc.normal,
	mask = mask.normal,
	width = 116,
	height = 48,
	sx = 1,
	shape = 'rectangle',
	bodytype = 'static',
	selectable = true,
	interaction = nil,
	ox = 116/2,
	oy = 48/2,
	obstacle = true,
}
}