AIPath = AIBase:subclass'AIPath'
function AIPath:initialize(unit,path)
--	super.initialize(unit)
	AIBase.initialize(self,unit)
	local b1,b2 = AIMoveTo(unit,path[#path])
	self.p = b1
--	self.next = b1
	for i=#path-1,1,-1 do
		b2 = AIMoveTo(unit,path[i])
		b1.next = b2
		b1=b2
	end
	self.path = path
	self.current = #path
	b1.next = AIStop(unit)
	self.initial = self.p
end

function AIPath:process(dt)
	local v = self.p
	local ndt,state = v:process(dt)
	if state == 'failed' then
		return ndt,state
	elseif state == 'success' then
		if v.next then
			self.p = v.next
			self.p:process(dt-ndt)
			self.current = self.current - 1
			return
		else
			return 0,'success'
		end
	end
end

function AIPath:reset()
	self.current = #self.path
	self.p = self.initial
end


if DEBUG then
function AIPath:DebugDraw()
	love.graphics.setColor(0,0,0)
	local x1,y1,x2,y2
	for i=self.current-1,1,-1 do
		x1,y1 = self.path[i]:getCenter()
		x2,y2 = self.path[i+1]:getCenter()
		love.graphics.line(x2,y2,x1,y1)
		
	end
	if self.current > 0 then
		x1,y1 = self.path[self.current]:getCenter()
		love.graphics.line(x1,y1,self.unit:getPosition())
	end
end
end