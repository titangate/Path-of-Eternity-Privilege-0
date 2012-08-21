Camera = Object:subclass'Camera'

function Camera:initialize(x,y,z)
	self.scale = 1
	self.x,self.y,self.z = x,y,z
end
camerap = {}
camerap.zNear,camerap.zFar = 1,3

function Camera:draw()
	local zNear,zFar = camerap.zNear,camerap.zFar
	local s = self.z*(zFar+zNear)/(zNear-zFar) + 2*zNear*zFar/(zNear-zFar)
	s = 1/-s
	--s = 0.5
	--gra.translate(-screen.halfwidth,-screen.halfheight)
	gra.translate(-screen.halfwidth*s,-screen.halfheight*s)
	love.graphics.scale(s)
	gra.translate(screen.halfwidth/s,screen.halfheight/s)
	--love.graphics.translate(-screen.halfwidth/s,-screen.halfheight/s)
	--local s = self.scale*(zNear/self.z)
	
	--s = 0.5
	--love.graphics.translate(screen.halfwidth*s,-screen.halfheight*s)
end