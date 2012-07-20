local cc = {
	normal = 1,
}
local mask = {
	normal = {},
}

local definition = {
	synringe = {
	folder = 'synringe',
	maxframe = 35,
	seq = {
		{0,34,1,1}, -- start,finish = speed
		{35,36,1,1/100},
		{34,0,-1,1}, -- start,finish,step
	},
	framerate = 24,
	},

	run = {
	folder = 'run',
	maxframe = 39,
	seq = {
		{0,39,1,1}, -- start,finish = speed
	},
	framerate = 48,
	},

	stealth = {
	folder = 'stealth',
	maxframe = 1,
	seq = {
		{0,1,0,1}, -- start,finish = speed
	},
	framerate = 1,
	},
	held = {
	folder = 'held',
	maxframe = 1,
	seq = {
		{0,1,0,1}, -- start,finish = speed
	},
	framerate = 1,
	},

	feet = {
	folder = 'feet',
	maxframe = 39,
	seq = {
		{0,39,1,1}, -- start,finish = speed
	},
	framerate = 48,
	},
}

return definition