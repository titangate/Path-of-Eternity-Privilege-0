
Gun = Item:subclass'Gun'
function Gun:interact(host,target)
	
end

function Gun:initialize(...)
	Item.initialize(self,...)
	self.gunraycast = function (fixture,x,y,xn,yn,fraction)
		--if not fixture then

		if self.fraction > fraction then
			self.fraction = fraction
			self.hit = fixture
			self.target = Vector(x,y)
		end
		--end
		return 1
	end
	self.s = Sound('sound/effect/gunhit.ogg',nil,100,'effect',global.aihost,3)
end

function Gun:active(host,target)
	if not instanceOf(Vector,target) then
		if target.getPosition then
			target = Vector(target:getPosition())

			self.designatedTarget = target
		else
			return false,'INVALID TARGET'
		end
	end
end

function Gun:update(dt)
	local x,y = self.owner.map:screenToMap(love.mouse.getPosition())
	local w = self.world
	assert(w)
	local r =self.owner:getAngle()
	self.ownerPosition = Vector(self.owner:getPosition())
	self.designatedTarget = Vector(x,y)
	self.designatedTarget = (self.designatedTarget - self.ownerPosition):normalize()*1000+self.ownerPosition
	--print (self.designatedTarget:normalize())
	self.hit = nil
	self.fraction = 1.1
	w:rayCast(self.ownerPosition.x,self.ownerPosition.y,self.designatedTarget.x,self.designatedTarget.y,self.gunraycast)
	if self.hit == nil then
		self.target = self.designatedTarget
	end
	self.s:setPosition(self.target)
end

function Gun:draw_lli()
	local x1,y1 = unpack(self.target)
	local x2,y2 = unpack(self.ownerPosition)
	love.graphics.line(x1,y1,x2,y2)
	self.s:drawCircle()
end