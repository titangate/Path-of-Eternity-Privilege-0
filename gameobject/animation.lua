AnimatedFrame = Object:subclass'AnimatedFrame'

function AnimatedFrame:initialize(img)
	self.pos = Vector(0,0)
	self.circlecenter = Vector(0,0)
	self.r = 0
	self.img = img
end

function AnimatedFrame:getPosition()
	return unpack(self.pos)
end

function AnimatedFrame:draw()
	if self.selected then
		love.graphics.setColor(255,0,0,100)
		love.graphics.circle('fill',self.pos.x+self.circlecenter.x,self.pos.y+self.circlecenter.y,10)
		love.graphics.setColor(255,255,255,100)
		love.graphics.circle('fill',self.pos.x+self.circlecenter.x,self.pos.y+self.circlecenter.y,100)
		love.graphics.setColor(255,255,255,100)
		love.graphics.circle('fill',self.pos.x,self.pos.y,50)
	end
	love.graphics.draw(self.img,self.pos.x,self.pos.y,self.r,1,1,self.img:getWidth()/2,self.img:getHeight()/2)
end

function AnimatedFrame:update(dt)
	if self.selected then
		if self.down then
			local p
			if self.getMousePosition then
				p = self.getMousePosition()
			else
				p = Vector(love.mouse.getPosition())
			end
			if self.down == 'pos' then
				
				self.pos = self.mousepos + p
			elseif self.down == 'circlecenter' then
				self.circlecenter = self.mousepos + p
			elseif self.down == 'rotate' then
				local x,y = unpack(p - self.circlecenter - self.pos)
				self.r = math.atan2(y,x)
			end
		end
	end
end

function AnimatedFrame:mousepressed(x,y,b)
	local pressed = Vector(x,y)
	local dis = (pressed - self.circlecenter - self.pos):length()
	if dis < 10 then
		self.down = 'circlecenter'
		self.mousepos =  self.circlecenter - pressed
	elseif (pressed - self.pos):length() < 50 then
		self.down = 'pos'
		self.mousepos = self.pos - pressed
	elseif dis < 100 then
		self.down = 'rotate'
		self.rotater = self.r
	end
end

function AnimatedFrame:mousereleased()
	self.down = nil
end


AnimatedPart = Object:subclass'AnimatedFrame'
function AnimatedPart:initialize( frame,img )
	assert(frame>0)
	self.frames = {}
	for i=1,frame do
		table.insert(self.frames,AnimatedFrame(img))

	end
	self.f = 1
end

function AnimatedPart:jumpToFrame(f)
	self.f = f
end

function AnimatedPart:setSelection(state)
	for i,v in ipairs(self.frames) do
		v.selected = state
	end
end
function AnimatedPart:setMouseP(mp)
	for i,v in ipairs(self.frames) do
		v.getMousePosition = mp
	end
end
function AnimatedPart:mousepressed(...)
	self.frames[self.f]:mousepressed(...)
end

function AnimatedPart:mousereleased(...)
	self.frames[self.f]:mousereleased(...)
end
function AnimatedPart:update(...)
	self.frames[self.f]:update(...)
end
function AnimatedPart:draw(...)
	self.frames[self.f]:draw(...)
end