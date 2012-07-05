filters={
	vibrate = require 'shader.vibrate',
	zoomblur = require 'shader.zoomblur',
}
function neartwo(n)
	local r=1
	while r<n do
		r = r*2
	end
	return r
end

canvasmanager = {}
function canvasmanager.requireCanvas(w,h)
	w,h = neartwo(w),neartwo(h)
	if not canvasmanager[w*10000+h] then
		canvasmanager[w*10000+h] = {}
	end
	if #canvasmanager[w*10000+h] < 1 then
		table.insert(canvasmanager[w*10000+h],{canvas = love.graphics.newCanvas(w,h),w=w,h=h})
	end
	assert(#canvasmanager[w*10000+h]>0)
	return table.remove(canvasmanager[w*10000+h])
end

function canvasmanager.releaseCanvas(c)
	assert(canvasmanager[c.w*10000+c.h])
	table.insert(canvasmanager[c.w*10000+c.h],c)
end
