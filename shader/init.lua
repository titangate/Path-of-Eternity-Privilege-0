local emptyshader = {}
function emptyshader.predraw()end
function emptyshader.conf()end
function emptyshader.postdraw()end

local fil = {
	ULTRA = {
		vibrate = require 'shader.vibrate',
		zoomblur = require 'shader.zoomblur',
		active = require 'shader.haze',
		inactive = require 'shader.satbri',
		EKG = require 'shader.EKG',
		gaussianblur = require 'shader.gaussianblur',
		stroke = require 'shader.stroke',
		selection = require 'shader.stroke',
		lli = require 'shader.lli',
		lli_unit = require 'shader.lli_unit',
		soundwave = require 'shader.soundwave',
	},
	HIGH = {
		vibrate = require 'shader.vibrate',
		zoomblur = require 'shader.zoomblur',
		active = emptyshader,
		inactive = require 'shader.satbri',
		EKG = require 'shader.EKG',
		gaussianblur = require 'shader.gaussianblur',
		stroke = require 'shader.stroke',
		selection = require 'shader.stroke',
		lli = require 'shader.lli',
		lli_unit = require 'shader.lli_unit',
		soundwave = require 'shader.soundwave',
	},
	LOW = {
		vibrate = require 'shader.vibrate',
		zoomblur = emptyshader,
		inactive = require 'shader.satbri',
		EKG = require 'shader.EKG',
		stroke = require 'shader.stroke',
		selection = require 'shader.stroke',
		lli = require 'shader.satbri',
		lli_unit = emptyshader,
		soundwave = require 'shader.soundwave',
	},
	DISABLED = {
		vibrate = emptyshader,
		zoomblur = emptyshader,
		lli = emptyshader,
		lli_unit = emptyshader,
		soundwave = require 'shader.soundwave',
	},
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
	w = math.min(w,screen.width)
	h = math.min(h,screen.height)
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

local shader = {}
function shader.setQuality()
	local q = option.shaderquality
	assert(fil[q])
	filters = fil[q]
end

function shader.getAvailableQuality()
	return {'DISABLED','LOW','HIGH','ULTRA'}
end

return shader