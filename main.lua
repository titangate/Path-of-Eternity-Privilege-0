
DEBUG = true
PROFILING = false

if DEBUG and PROFILING then
	ProFi = require 'ProFi'
	ProFi:start()
end

require 'middleclass'
Stateful = require"stateful"
local localization = require 'library.localization'
require 'library.mathematic'
local essential = require 'library.essential'
require 'ai'
require 'gameobject'
local waits = require 'library.trigger'
local shader = require 'shader'
local graphics = require 'library.graphics'
local sound = require 'library.sound'
serial = require 'gamesystem.serial'

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



function love.load()
	
	graphics.load()
	assert(graphics.canvas)
	-- UI init --
	
	if love.filesystem.isFile'option' then
		essential.load(table.load(love.filesystem.read('option')))
	end
	
	if love.filesystem.isFile'graphics' then
		graphics.load(table.load(love.filesystem.read('graphics')))
	end
	localization.setLocalization(option.language)
	essential.setTextureQuality()
	shader.setQuality()
--	initFont()

	sound.load()
	
	require 'loveframes'
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

	local fps = love.timer.getFPS()
	love.graphics.setCaption(string.format(LocalizedString"Path of Eternity Priviledge Zero // frame time: %.2fms (%d fps).", 1000/fps, fps))
end