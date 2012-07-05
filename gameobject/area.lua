Area = Object:subclass'Area'
function Area:getCenterVector()
	self._cv = self._cv or Vector(self:getCenter())
	return self._cv
end

function Area:carryUnit(u,state)
	self.unitcount = self.unitcount or 0
	self.unit = self.unit or {}
	if state then
		if self.unit[u] then return end
		self.unitcount = self.unitcount + 1
	else
		if not self.unit[u] then return end
		self.unitcount = self.unitcount - 1
	end
	self.unit[u] = state
end

function Area:DebugDraw()
	love.graphics.setColor(0,0,0)
	if self.unitcount then
		local x,y = self:getCenter()
		love.graphics.printf(string.format("unit: %d",self.unitcount),x,y,30,'center')
	end
end

CircleArea = Area:subclass'CircleArea'
function CircleArea:initialize(x,y,r)
	self.x,self.y,self.r=x,y,r
end

function CircleArea:contain(u)
	local ux,uy = u:getPosition()
	return (ux-self.x)^2+(uy-self.y)^2<self.r*self.r
end

function CircleArea:getCenter()
	return self.x,self.y
end

function CircleArea:random()
	local r,d = math.random()*7,math.random()*self.r
	return math.cos(r)*d,math.sin(r)*d
end

RectangleArea = Area:subclass'RectangleArea'

function RectangleArea:initialize(x,y,w,h)
	self.x,self.y,self.w,self.h = x,y,w,h
end

function RectangleArea:contain(u)
	local x,y = u:getPosition()
	local dx,dy = x-self.x,y-self.y
	return dx>0 and dx<self.w and dy>0 and dy<self.h
end


function RectangleArea:getCenter()
	return self.x+self.w/2,self.y+self.h/2
end

function RectangleArea:random()
	return self.x+math.random()*self.w,self.y+math.random()*self.h
end