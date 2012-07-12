require 'gameobject.unit'
Doodad = Unit:subclass'Doodad'
function Doodad:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt,info)
	self.info = info
end

function Doodad:draw()
	local i = self.info
	local x,y = self:getPosition()
	local r = self:getAngle()
	love.graphics.draw(requireImage("doodad/"..i.image),x,y,r,i.sx,i.sy,i.ox,i.oy)
end

function Doodad:getObstacle()
	assert(self.map)
	if not self.info.obstacle then
		return 
	end
	local x,y = self:getPosition()
	local r = self.info.width
	if self.info.height then
		r = math.max(r,self.info.height)
	end
	local result = {}
	for i=1,30 do -- use random sampling to determine the obstacled areas
		local rx,ry = math.random(r*2)-r+x,math.random(r*2)-r+y
		if self.mover.fixture:testPoint(rx,ry) then
			result[self.map:getArea(rx,ry)] = true
		end
	end
	return result
end

local doodad = {}
local doodaddef

function doodad.load()
	doodaddef = require 'doodad.definition'
end

function doodad.create(name,x,y,r)
	local d = Doodad(doodadMover,x,y,r,doodaddef[name].bodytype,doodaddef[name])
	return d
end

return doodad