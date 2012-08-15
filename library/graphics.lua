local graphics = {}
local namefield ={width=1, height=2, fullscreen=3, vsync=4, fsaa=5}
local vfield
function graphics.load(t)
	if not t then
		vfield = {love.graphics.getMode()}
		if not graphics.canvas or (vfield[1] ~= graphics.canvas.w and vfield[2]~=graphics.canvas.h) then
			graphics.canvas = {w=vfield[1],h=vfield[2],c=love.graphics.newCanvas(vfield[1],vfield[2])}
		end
	else
		vfield = t
		graphics.apply()
	end

	if not screen then
	if option.retina then

		screen = {
			width = love.graphics.getWidth()/option.retina,
			height = love.graphics.getHeight()/option.retina,
			halfwidth = love.graphics.getWidth()/2/option.retina,
			halfheight = love.graphics.getHeight()/2/option.retina,
		}
	
		else

			screen = {
				width = love.graphics.getWidth(),
				height = love.graphics.getHeight(),
				halfwidth = love.graphics.getWidth()/2,
				halfheight = love.graphics.getHeight()/2,
			}
		end
	end
end

function graphics.setArgument(field,value)
	vfield[namefield[field]] = value
end

function graphics.apply()
	local loaded = true
	local tfield = {love.graphics.getMode()}
	for i,v in ipairs(vfield) do
		if v~=tfield[i] then
			loaded = false
		end
	end
	if loaded then return end
	--if option.retina then
	----	love.graphics.setMode(vfield[1]*option.retina,vfield[2]*option.retina,vfield[3],vfield[4],vfield[5])
	--else
	execute(function()
		wait(0.5)
		love.graphics.setMode(unpack(vfield))
		end)
	--end
	if not graphics.canvas or (vfield[1] ~= graphics.canvas.w and vfield[2]~=graphics.canvas.h) then
		graphics.canvas = {w=vfield[1],h=vfield[2],c=love.graphics.newCanvas(vfield[1],vfield[2])}
	end
	
	if option.retina then

	screen = {
		width = vfield[1]/option.retina,
		height = vfield[2]/option.retina,
		halfwidth = vfield[1]/2/option.retina,
		halfheight = vfield[2]/2/option.retina,
	}
	
	else

	screen = {
		width = vfield[1],
		height = vfield[2],
		halfwidth = vfield[1]/2,
		halfheight = vfield[2]/2,
	}
	
	end

	graphics.save()
	
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

function graphics.save()
	local s = json.encode(vfield)
	love.filesystem.write('graphics',s)
end


return graphics