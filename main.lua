local loader = require 'loader'


DEBUG = true
PROFILING = false

if DEBUG and PROFILING then
	ProFi = require 'ProFi'
	ProFi:start()
end


screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),
	halfwidth = love.graphics.getWidth()/2,
	halfheight = love.graphics.getHeight()/2,
}

option = {
	uifps = 30,
	uidt = 1/30,
	seperateUI = true,
	shaderquality = 'HIGH',
	texturequality = 'HIGH',
	language = 'English',
}

local gamesys = {}
function gamesys.push(sys,transtime)
	table.insert(gamesys,sys)
	loveframes.anim:easy(gamesys,'transtime',1,0,transtime)
	sys.host = gamesys
end


function gamesys.pop(transtime)
	
--	loveframes.anim:easy(gamesys,'transtime',1,0,transtime)
--	sys.host = nil
	return table.remove(gamesys,sys)
end

function gamesys.top()
	return gamesys[#gamesys]
end


function gamesys.update(dt)
	if gamesys.transtime > 0 and gamesys[#gamesys-1] then
		gamesys[#gamesys-1]:update(dt)
	end
	gamesys[#gamesys]:update(dt)
end

function gamesys.draw()
	if gamesys.transtime > 0 and gamesys[#gamesys-1] then
		gamesys[#gamesys-1]:draw()
	end
	gamesys[#gamesys]:draw()
end


require 'middleclass'
local waits = require 'library.trigger'
local shader = require 'shader'
local graphics = require 'library.graphics'
sound = require 'library.sound'
Stateful = require"stateful"
local localization = require 'library.localization'
local essential = require 'library.essential'

local img = essential.getImageTable()
local lfs = love.filesystem
local function _iterateAsset(f)
	if lfs.isFile(f) then
		if string.sub(f,#f-3) == '.png' then
			--loader.newImage(img,f,f)
			loader.newImage(img,f,f)
			return
		end
	elseif lfs.isDirectory(f) then
		for i,v in ipairs(lfs.enumerate(f)) do
			_iterateAsset(f..'/'..v)
		end
	end
end

local function enumerateAssets()
	local assetfolder = {'asset','animation','doodad','item','unit','dot.png','worldmap.png'}
	while #assetfolder>0 do
		local f = table.remove(assetfolder)
		_iterateAsset(f)
	end
end

local retina = false

local finishedLoading
function love.load()
	
	
	graphics.load()
	assert(graphics.canvas)
	-- UI init --
	
	if love.filesystem.isFile'option' then
		local f = love.filesystem.read('option')
		f = json.decode(f)
	--	assert(f)
		if f then essential.load(f) end
	end
	
	if love.filesystem.isFile'graphics' then
		local f = love.filesystem.read('graphics')
		f = json.decode(f)
--		assert(f)
		if f then graphics.load(f) end
	end
	localization.setLocalization(option.language)
	require 'library.mathematic'
	require 'ai'
	require 'gameobject'
	serial = require 'gamesystem.serial'
	require 'gamesystem.controller'
	require 'gamesystem.inventory'
	require 'gamesystem.interactfunc'
	essential.setTextureQuality()
	shader.setQuality()
--	initFont()

	sound.load()
	
	require 'loveframes'

	-- preload all files

	enumerateAssets()
	loader.start(function()
		finishedLoading = true
	end)

	-- load the examples menu
	
	-- load the sin selector menu
	
	local mainmenu = require 'gamesystem.mainmenu'
	
	mainmenu:loadmain()
	
	gamesys.push(mainmenu)
	
	if DEBUG then
		loveframes.config["DEBUG"] = true
	else
		loveframes.config["DEBUG"] = false
	end
	loveframes.config["DEBUG"] = false
--	loveframes.debug.SkinSelector()
--	loveframes.debug.ExamplesMenu()
	
--	love.graphics.setBackgroundColor(255,255,255,0)

end

function love.mousepressed(x, y, button)
	
	gamesys[#gamesys]:mousepressed(x,y,button)
	loveframes.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)

	gamesys[#gamesys]:mousereleased(x,y,button)
	loveframes.mousereleased(x, y, button)

end


function love.keypressed(key, unicode)

	gamesys[#gamesys]:keypressed(key,unicode)
	loveframes.keypressed(key, unicode)
	
	if key == "`" then
	
		local debug = loveframes.config["DEBUG"]
		
		if debug == true then
			loveframes.config["DEBUG"] = false
		else
			loveframes.config["DEBUG"] = true
		end
		
	end
	if key == 'p' then
		ProFi:stop()
		ProFi:writeReport'report.txt'
	end
	
end

function love.keyreleased(key)

	gamesys[#gamesys]:keyreleased(key)
	loveframes.keyreleased(key)
	
end

local ui_elapse = 0
local refreshUI = true
function love.update(dt)
	if not finishedLoading then
		loader.update() -- You must do this on each iteration until all resources are loaded
	end
	if option.seperateUI then
		ui_elapse = ui_elapse + dt
		if ui_elapse > option.uidt then
			loveframes.update(ui_elapse)
			ui_elapse = ui_elapse - option.uidt
			refreshUI = true
		end
	else
		loveframes.update(dt)
	end
	waits.update()
	gamesys.update(dt)
	sound.cleanUp()
end

function love.draw()
	--love.graphics.setColor(0,255,255)
	if retina then
		love.graphics.scale(2)
	end
		--love.graphics.rectangle('fill',0,0,10000,10000)
	gamesys.draw()
	if option.seperateUI then
		if refreshUI then
			graphics.canvas.c:clear()
			love.graphics.setColor(255,255,255)
			love.graphics.setCanvas(graphics.canvas.c)
			loveframes.draw()
			love.graphics.setCanvas()
			refreshUI = false
		end
		love.graphics.setColor(255,255,255)
		love.graphics.setBlendMode'premultiplied'
		love.graphics.draw(graphics.canvas.c)
		love.graphics.setBlendMode'alpha'
	else
		
		love.graphics.setColor(255,255,255)
		loveframes.draw()
	end
	love.graphics.setColor(0, 0, 0, 255)
	pn("Press \"`\" to toggle debug mode.", 210, 7)
	love.graphics.setColor(255, 255, 255, 255)
	pn("Press \"`\" to toggle debug mode.", 210, 5)

	if not finishedLoading then
		local percent = 0
		if loader.resourceCount ~= 0 then percent = loader.loadedCount / loader.resourceCount end
		love.graphics.print(("Loading Assets.. %d%%"):format(percent*100), 100, 100)
	end

	local fps = love.timer.getFPS()
	love.graphics.setCaption(string.format(LocalizedString"Path of Eternity Priviledge Zero // frame time: %.2fms (%d fps).", 1000/fps, fps))
end