CountDown = Object:subclass'CountDown'

function CountDown:initialize(time,callback,heartbeatinterval,heartbeatfunction,x,y)
	self.time = time
	self.dt2 = 0
	self.callback = callback
	self.heartbeatinterval = heartbeatinterval
	self.heartbeatfunction = heartbeatfunction
	self.dt = 0
	self.body_color = {255,255,255,100}
	self.bar_color = {210,152,40}
	self.layer = 4
	self:setWidth(100)
	self:setHeight(10)
	self.mover = Mover(x-50,y,0)
	self:generateBodyVertex()
	self:generateBarVertex()
end

function CountDown:update(dt)
	self.dt = self.dt + dt
	self.dt2 = self.dt2 + dt
	if self.dt2 >= self.time then
		self.callback()
		if self.map then
			self.map:removeUnit(self)
		end
	end
	if self.heartbeatinterval and self.dt > self.heartbeatinterval then
		self.heartbeatfunction()
		self.dt = self.dt - self.heartbeatinterval
	end
	self:generateBarVertex()
end

function CountDown:draw()
	local bodycolor = self.body_color or skin.controls.progressbar_body_color
	local barcolor = self.bar_color or skin.controls.progressbar_bar_color

	local x,y = self.mover:getPosition()
	local w,h = self:getWidth(),self:getHeight()
	local flareimage = requireImage'asset/effect/flare.png'
	gra.push()
	gra.translate(x,y)
	gra.setColor(unpack(bodycolor))
	gra.polygon('fill',unpack(self:GetBodyVertex()))
	gra.polygon('line',unpack(self:GetBodyVertex()))
	--gra.setScissor(x*option.retina,y*option.retina,w*option.retina,h*option.retina)
	gra.setColor(unpack(barcolor))
	gra.polygon('fill',unpack(self:GetBarVertex()))
	gra.setScissor()
	gra.pop()
	gra.setColor(255,255,255,255)
	local x1,y1 = self:GetBarVertex()[3],self:GetBarVertex()[4]
	gra.draw(requireImage'asset/effect/flare.png',x1+x,y1+y,0,0.5,0.2,98,32)
	gra.draw(requireImage'asset/effect/flare.png',-x1+h+w+x,y1+y+h,0,0.5,0.2,98,32)
end


function CountDown:generateBodyVertex()
	local x,y = 0,0--self.x,self.y
	local w,h = self.width,self.height
	--print (w,h)
	self._bodyvertex = {x,y,x+w,y,x+w-h,y+h,x,y+h}
end

function CountDown:generateBarVertex()
	local x,y = 0,0--self.x,self.y
	local w,h = self.dt2*self.width/self.time,self.height
	self._barvertex = {x-h,y,x+w,y,x+w-h,y+h,x-h,y+h}
end


function CountDown:GetBodyVertex()
	return self._bodyvertex
end


function CountDown:GetBarVertex()
	return self._barvertex
end

function CountDown:setSize(width, height)

	self.width = width
	self.height = height
	
end

--[[---------------------------------------------------------
	- func: setWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function CountDown:setWidth(width)

	self.width = width
	
end

--[[---------------------------------------------------------
	- func: setHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function CountDown:setHeight(height)

	self.height = height
	
end

--[[---------------------------------------------------------
	- func: GetSize()
	- desc: gets the object's size
--]]---------------------------------------------------------
function CountDown:GetSize()

	return self.width, self.height
	
end

--[[---------------------------------------------------------
	- func: getWidth()
	- desc: gets the object's width
--]]---------------------------------------------------------
function CountDown:getWidth()

	return self.width
	
end

--[[---------------------------------------------------------
	- func: getHeight()
	- desc: gets the object's height
--]]---------------------------------------------------------
function CountDown:getHeight()

	return self.height
	
end
