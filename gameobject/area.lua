Area = Object:subclass'Area'
function Area:getCenterVector()
	self._cv = self._cv or Vector(self:getCenter())
	return self._cv
end

function Area:getCarriedUnit()
	if self.unitcount and self.unitcount~=0 then
		return self.unit
	else
		return {}
	end
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
	if self.carryfunc then
		self:carryfunc(u,state)
	end
end

function Area:DebugDraw()
	love.graphics.setColor(0,0,0)
	if self.unitcount then
		local x,y = self:getCenter()
		pfn(string.format("unit: %d",self.unitcount),x,y,30,'center')
	end
end

CircleArea = Area:subclass'CircleArea'
function CircleArea:initialize(x,y,r)
	self.x,self.y,self.r=x,y,r
end

function CircleArea:contain(u)
	local ux,uy = u:getPosition()
	return ((ux-self.x)^2+(uy-self.y)^2)<=self.r*self.r
end


function CircleArea:getAABB()
	return self.x-self.r/2,self.y-self.r/2,self.x+self.r/2,self.y+self.r/2
end

function CircleArea:getCenter()
	return self.x,self.y
end
	function CircleArea:getPosition()
		return self.x,self.y
	end

function CircleArea:random()
	local r,d = math.random()*7,math.random()*self.r
	return math.cos(r)*d,math.sin(r)*d
end

function CircleArea:encode()
	return {
		name = 'CircleArea',
		x = self.x,
		y = self.y,
		r = self.r,
	}
end

function CircleArea:decode(t)
	self.x,self.y,self.r = t.x,t.y,t.r
end

RectangleArea = Area:subclass'RectangleArea'

function RectangleArea:initialize(x,y,w,h)
	self.x,self.y,self.w,self.h = x,y,w,h
end

function RectangleArea:contain(u)
	local x,y = u:getPosition()
	local dx,dy = x-self.x,y-self.y
	return dx>=0 and dx<=self.w and dy>=0 and dy<=self.h
end


function RectangleArea:getCenter()
	return self.x+self.w/2,self.y+self.h/2
end

function RectangleArea:random()
	return self.x+math.random()*self.w,self.y+math.random()*self.h
end

function RectangleArea:getAABB()
	return self.x,self.y,self.x+self.w,self.y+self.h
end


function RectangleArea:encode()
	return {
		name = 'RectangleArea',
		x = self.x,
		y = self.y,
		w = self.w,
		h = self.h,
	}
end

function RectangleArea:decode(t)
	self.x,self.y,self.w,self.h = t.x,t.y,t.w,t.h
end