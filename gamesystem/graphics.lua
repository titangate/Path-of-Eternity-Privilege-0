local graphics = {}
local namefield ={width=1, height=2, fullscreen=3, vsync=4, fsaa=5}
local vfield
function graphics.load()
	vfield = {love.graphics.getMode()}
	if not graphics.canvas or (vfield[1] ~= graphics.canvas.w and vfield[2]~=graphics.canvas.h) then
		graphics.canvas = {w=vfield[1],h=vfield[2],c=love.graphics.newCanvas(vfield[1],vfield[2])}
	end
end

function graphics.setArgument(field,value)
	vfield[namefield[field]] = value
end

function graphics.apply()
	
	love.graphics.setMode(unpack(vfield))
	
	if not graphics.canvas or (vfield[1] ~= graphics.canvas.w and vfield[2]~=graphics.canvas.h) then
		graphics.canvas = {w=vfield[1],h=vfield[2],c=love.graphics.newCanvas(vfield[1],vfield[2])}
	end
	
end

function graphics.getArgument(field)
	return vfield[namefield[field]]
end

function graphics.getAvailableResolution()
	local r = {
		{width=800,height=600},
		{width=1024,height=600},
		{width=1280,height=768},
		{width=1280,height=800},
		{width=1366,height=768},
		{width=1280,height=1024},
		{width=1600,height=1200},
		{width=1920,height=1080},
		{width=1920,height=1200},
	}
	local modes = love.graphics.getModes()
	for i,v in ipairs(modes) do
		v.fullscreen = true
		table.insert(r,v)
	end
	return r
end

return graphics