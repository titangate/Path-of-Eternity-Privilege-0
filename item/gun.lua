
Gun = Item:subclass'Gun'
function Gun:interact(host,target)
	
end

function Gun:initialize(...)
	Item.initialize(self,...)
	self.gunraycast = function (fixture,x,y,xn,yn,fraction)
		--if not fixture then
		local obs
		local ud = fixture:getUserData()
		if ud and ud.isObstacle then
			obs = ud:isObstacle()
		else
			obs = false
		end
		if obs and self.fraction > fraction then
			self.fraction = fraction
			self.hit = ud
			self.target = Vector(x,y)
		end
		--end
		return 1
	end
	self.s = Sound('sound/effect/gunhit.ogg',nil,150,'effect',global.aihost,2)
	self.s2 = Sound('sound/effect/pistolshot.ogg',nil,400,'effect',global.aihost,3)
	self.shake = 1
	self.prevTarget = Vector(0,0)
	self.silencer = 0
	self.scope = 0
	self:generateIcon()
end

function Gun:active(host,target)
	--if self.hit then
	local t = self.hit
	print (t,'hits')
	if instanceOf(River,t) then
		execute(function()
			self.s:play()
			t.map:addUnit(self.s)
			if self.silencer<=1 then
				self.s2:play()
				t.map:addUnit(self.s2)
			end
			t.aihost:terminate(t,true,360000)		
			wait(0.5)
			t:kill(self)
			end)
		return true
	else
		self.s:play()
		host.map:addUnit(self.s)
		if self.silencer<=1 then
			self.s2:play()
			host.map:addUnit(self.s2)
		end
		return true
	end
end

function Gun:update_i(dt)
	local x,y = self.owner.map:screenToMap(love.mouse.getPosition())
	local w = global.map.world
	assert(w)
	local r =self.owner:getAngle()
	self.ownerPosition = Vector(self.owner:getPosition())
	self.designatedTarget = Vector(x,y)
	local l = (self.designatedTarget - self.prevTarget):length()*0.05
	self.shake = math.min(1,math.max(0,self.shake+l-dt*(0.5-self.scope*0.25)))
	self.prevTarget = self.designatedTarget
	local r = 0--(math.random()-0.5)*self.shake
	local x1,y1 = math.cos(r),math.sin(r)
	local x2,y2 = normalize(unpack(self.designatedTarget - self.ownerPosition))
	self.designatedTarget = (Vector(x1*x2-y1*y2,y1*x2+y2*x1))*1000+self.ownerPosition
	--print (self.designatedTarget:normalize())
	self.hit = nil
	self.fraction = 1.1
	w:rayCast(self.ownerPosition.x,self.ownerPosition.y,self.designatedTarget.x,self.designatedTarget.y,self.gunraycast)
	if self.hit == nil then
		self.target = self.designatedTarget
	end
	self.s:setPosition(self.target)
	self.s2:setPosition(self.ownerPosition)
end

function Gun:setUpgrade(k,v)
	self[k] = v
	self:generateIcon()
	self.info.icon = self.icon
	if self.silencer == 1 then
		self.s2:setReach(100)
	else
		self.s2:setReach(400)
	end

end

function Gun:getIcon()
	if not self.icon then
		self:generateIcon()
	end
	return self.icon
end

function Gun:generateIcon()
	self.icon = gra.newCanvas(445,300)
	gra.setCanvas(self.icon)
	gra.draw(requireImage'item/1911/gun.png')
	--if self.silencer then
	if self.silencer == 1 then
		gra.draw(requireImage'item/1911/silencer1.png')
	elseif self.silencer == 2 then
		gra.draw(requireImage'item/1911/silencer2.png')
	end
	if self.scope == 1 then
		gra.draw(requireImage'item/1911/scope1.png')
	elseif self.scope == 2 then
		gra.draw(requireImage'item/1911/scope2.png')
	end
	if self.slide == 1 then
		gra.draw(requireImage'item/1911/slide1.png')
	elseif self.slide == 2 then
		gra.draw(requireImage'item/1911/slide2.png')
	end
	gra.setCanvas()
end

function Gun:draw_lli()
	local x1,y1 = unpack(self.target)
	local x2,y2 = unpack(self.ownerPosition)
	gra.line(x1,y1,x2,y2)
	self.s:drawCircle()
	if self.silencer ~= 2 then
	self.s2:drawCircle()
end
end