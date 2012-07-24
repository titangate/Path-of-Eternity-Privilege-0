AIMoveTo = AIBase:subclass'AIMoveTo'
function AIMoveTo:initialize(unit,target)
--	super.initialize(unit)
	AIBase.initialize(self,unit)
	self.target = target
	self.next = AIStop(unit)
end
function AIMoveTo:process(dt)
	local u = self.unit
	local t = self.target
	if t:contain(u) then
		return 0,'success'
	else
		local x,y = self.target:getCenter()
		local ux,uy = u:getPosition()
		u:setMovingDirection(normalize(x-ux,y-uy))
	end
end

if DEBUG then
function AIMoveTo:DebugDraw()
	local x,y = self.target:getCenter()
	local ux,uy = self.unit:getPosition()
	love.graphics.line(ux,uy,x,y)
end
end