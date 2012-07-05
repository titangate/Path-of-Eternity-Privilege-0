
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
require 'essential'
require 'ai'
require 'gameobject'
local waits = require 'trigger'
require 'shader'

screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),
	halfwidth = love.graphics.getWidth()/2,
	halfheight = love.graphics.getHeight()/2,
	w = love.graphics.getWidth(),
	h = love.graphics.getHeight(),
}

function initFont()
end


function love.load()
	
	-- UI init --
	setLocalization'chr'
--	initFont()
	
	require 'loveframes'
	-- load the examples menu
--	loveframes.debug.ExamplesMenu()
	
	-- load the sin selector menu
	
	demogame = require 'gamesystem.mainmenu'
	
	loveframes.debug.SkinSelector()
end

function love.mousepressed(x, y, button)
	
	demogame:mousepressed(x,y,button)
	loveframes.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)

	demogame:mousereleased(x,y,button)
	loveframes.mousereleased(x, y, button)

end


function love.keypressed(key, unicode)

	demogame:keypressed(key,unicode)
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

	demogame:keyreleased(key)
	loveframes.keyreleased(key)
	
end

function love.update(dt)
	
	waits.update()
	loveframes.update(dt)
	demogame:update(dt)
end

function love.draw()
	demogame:draw()
	loveframes.draw()
	
	love.graphics.setColor(0, 0, 0, 255)
	pn("Press \"`\" to toggle debug mode.", 210, 7)
	love.graphics.setColor(255, 255, 255, 255)
	pn("Press \"`\" to toggle debug mode.", 210, 5)

	local fps = love.timer.getFPS()
	love.graphics.setCaption(string.format(LocalizedString"Path of Eternity Priviledge Zero // frame time: %.2fms (%d fps).", 1000/fps, fps))
end