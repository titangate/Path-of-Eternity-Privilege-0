River = Unit:subclass'River'

function River:initialize(movertype,x,y,r,bt,info)
	Unit.initialize(self,movertype,x,y,r,bt)
	
	if info then self:setStyle(info) end
	self.actor = RiverActor(function()
		self:step()
	end)
	self.lli_color = {255,255,255,50}
	self:setProfile'high'
	self.footsteps = {}
	for i=1,4 do
		table.insert(self.footsteps,Sound(string.format('sound/effect/footstep%d.ogg',i),nil,100,'effect',global.aihost,0))
	end
	self.footstepcount = 1
end

function River:setProfile(p)
	self.actor:setProfile(p)
	self.profile = p
	if p=='high' then
		self.soundwave_range = global.aihost:getConstant'highprofile_foodstep_range'
	elseif p=='medium' then
		self.soundwave_range = global.aihost:getConstant'mediumprofile_foodstep_range'
	elseif p=='low' then
		self.soundwave_range = global.aihost:getConstant'lowprofile_foodstep_range'
	end
end

function River:step()
	local footstepcount = self.footstepcount
	local f = self.footsteps[footstepcount]
	footstepcount = footstepcount%4 + 1
	f:setPosition(Vector(self:getPosition()))
	f:play()
	self.map:addUnit(f)
end

function River:setStyle(info)
	self.info = info
end

function River:encode()
	local t = Unit.encode(self)
	t.info = self.info
	if self.patrolpath then
		local p = {}
		for i,v in ipairs(self.patrolpath.waypoint) do
			table.insert(p,{v.x,v.y})
		end
		t.patrolpath = p
	end
	return t
end

function River:decode(t)
	self:setStyle(t.info)
	if t.patrolpath then

		for i,v in ipairs(t.patrolpath) do
			t.patrolpath[i] = Vector(unpack(v))
		end
		for i,v in ipairs(t.patrolpath) do print(v) end
		self:setPatrolPath(PatrolPath(t.patrolpath))
	end
end



function River:setPatrolPath(p)
	self.patrolpath = p
	if self.aihost then
		self.aihost:addAI(AIGuard(self,p.waypoint))
	end
end


function River:update(dt)
	Unit.update(self,dt)
	local vx,vy = self:getVelocity()
	self.actor:setWalkingSpeed(vx,vy)
	self.actor:update(dt)

	if self.inv then self.inv:update(dt) end
end

function River:setHeadAngle(angle)

end

function River:getHeadAngle()
	return self:getAngle()
end

local scale = 1.5

function River:draw(x,y,r)
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		local obj = self
		local w = 128
		local h = 128
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		gra.setPixelEffect(stroke.pe)
	end

	local g = gra
	if not x then
		x,y = self:getPosition()
		r = self:getAngle()
	end
	
	self.actor:draw(self)

	if self.drawSelection then
		gra.setPixelEffect()
	end

	if self.patrolpath then
		gra.line(self:getX(),self:getY(),self.patrolpath.waypoint[1].x,self.patrolpath.waypoint[1].y)
	end
end


function River:draw_LLI(x,y,r)
	local i = self.info
	if not x then
		x,y = self:getPosition()
		r = self:getAngle()
	end

	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		local obj = self
		local w = 128
		local h = 128
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		gra.setPixelEffect(stroke.pe)
	end

	local g = gra
	
	self.actor:draw(self)
	if self.drawSelection then
		gra.setPixelEffect()
	end
	filters.lli_unit.conf(self)
	filters.lli_unit.predraw(self)
	gra.setColor(self.lli_color[1],self.lli_color[2],self.lli_color[3],50)
	
	
	self.actor:draw(self)
	filters.lli_unit.postdraw(self)
	if self.lli_flare then
		gra.setColor(self.lli_color[1],self.lli_color[2],self.lli_color[3],math.random()*127+127)
	end
	g.draw(requireImage'asset/effect/flare.png',x,y,0,1,1,64,32)

	if self.patrolpath then
		gra.line(self:getX(),self:getY(),self.patrolpath.waypoint[1].x,self.patrolpath.waypoint[1].y)
	end
	-- Draw foodstep sound
	if self.inv then self.inv:draw_lli() end
end


function River:getWidth()
	return scale*64
end

function River:getHeight()
	return scale*64
end
