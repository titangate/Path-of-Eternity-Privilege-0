
DEBUG = true
PROFILING = false

if DEBUG and PROFILING then
	ProFi = require 'ProFi'
	ProFi:start()
end

require 'middleclass'
Stateful = require"stateful"
require 'localization'
require 'mathematic'
local essential = require 'essential'
require 'ai'
require 'gameobject'
local waits = require 'trigger'
local shader = require 'shader'

screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),
	halfwidth = love.graphics.getWidth()/2,
	halfheight = love.graphics.getHeight()/2,
	w = love.graphics.getWidth(),
	h = love.graphics.getHeight(),
}

option = {
	uifps = 30,
	uidt = 1/30,
	seperateUI = true,
	shaderquality = 'HIGH',
	texturequality = 'HIGH',
}

function initFont()
end

local g = require 'gamesystem.graphics'

function love.load()
	
	g.load()
	assert(g.canvas)
	-- UI init --
	setLocalization'eng'
	
	essential.setTextureQuality()
	shader.setQuality()
--	initFont()
	
	require 'loveframes'
	-- load the examples menu
	
	-- load the sin selector menu
	
	gamesystem = require 'gamesystem.mainmenu'
	
	gamesystem:load()
	
	loveframes.debug.SkinSelector()
	loveframes.debug.ExamplesMenu()
	
--	love.graphics.setBackgroundColor(255,255,255,0)
end

function love.mousepressed(x, y, button)
	
	gamesystem:mousepressed(x,y,button)
	loveframes.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)

	gamesystem:mousereleased(x,y,button)
	loveframes.mousereleased(x, y, button)

end


function love.keypressed(key, unicode)

	gamesystem:keypressed(key,unicode)
	loveframes.keypressed(key, unicode)
	
	if key == "`" then
	
		local debug = loveframes.config["DEBUG"]
		
		if debug == true then
			loveframes.config["DEBUG"] = false
		else
			loveframes.config["DEBUG"] = true
		end
		
	end
	
end

function love.keyreleased(key)

	gamesystem:keyreleased(key)
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
	gamesystem:update(dt)
end

function love.draw()
	--love.graphics.setColor(0,255,255)
	
	--love.graphics.rectangle('fill',0,0,10000,10000)
	gamesystem:draw()
	if option.seperateUI then
		if refreshUI then
			g.canvas.c:clear()
			love.graphics.setColor(255,255,255)
			love.graphics.setCanvas(g.canvas.c)
			loveframes.draw()
			love.graphics.setCanvas()
			refreshUI = false
		end
		love.graphics.setColor(255,255,255)
		love.graphics.setBlendMode'premultiplied'
		love.graphics.draw(g.canvas.c)
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