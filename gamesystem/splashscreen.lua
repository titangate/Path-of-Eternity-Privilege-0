local splashscreen = {}
local sound = require 'library.sound'
function splashscreen:load()
	-- music
	------------------------------------
	-- button example
	------------------------------------
	local con = loveframes.Create('frame')
	con:setSize(screen.width,screen.height)
	con:ShowCloseButton(false)
	function con:Draw()end
	self.logo = loveframes.Create('image',con)
	self.logo:setImage'asset/love.png'
	self.logo:Center()
	self.logo:SetColor({255,255,255,255})
	loveframes.anim:easy(self.logo.imagecolor,4,255,0,1.5)
	loveframes.anim:easy(self,'scale',2,0.5,3)
	self.scale = 2
	execute(function()
		wait(1)
		self.ring0dev = loveframes.Create('image',con)
		self.ring0dev:setImage'asset/ring0dev.png'
		self.ring0dev:Center()
		self.ring0dev:SetColor({255,255,255,255})
		loveframes.anim:easy(self.ring0dev.imagecolor,4,255,0,1.5)

		local compass = loveframes.Create("compass",con)
		compass:setPos(580,180)
		compass:setSize(300,300)
		compass.color = {255,255,255,255}
		loveframes.anim:easy(compass.color,4,255,0,1.5)
		wait(2)
		con:Remove()
		gamesys.pop()
		self.OnFinish()
	end)
end

function splashscreen:update()
end
function splashscreen:draw()
	love.graphics.translate(screen.halfwidth,screen.halfheight)
	love.graphics.scale(self.scale)
	love.graphics.translate(-screen.halfwidth,-screen.halfheight)
end




function splashscreen:keypressed(k)
end
function splashscreen:keyreleased(k)
end

function splashscreen:mousepressed()
end
function splashscreen:mousereleased()
end

return splashscreen