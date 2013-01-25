RiverActor = Object:subclass'RiverActor'

local animation = require 'gameobject.animation'
function RiverActor:initialize(OnCrit)
	self.feet = animation.create'feet'
	self.syringe = animation.create'syringe'
	self.stealth = animation.create'stealth'
	self.action = 'syringe'
	self.held = animation.create'held'
	self.run = animation.create'run'

	self.profile = 'high'

	self.walkingspeed = Vector(0,0)

	self.animation = nil
	self.run.OnCrit = OnCrit
end

function RiverActor:setProfile(p)
	self.profile = p
end

function RiverActor:setWalkingSpeed(vx,vy)
	self.walkingspeed.x,self.walkingspeed.y = vx,vy
end

function RiverActor:update(dt)
	if self.animation then
		if self.animation == 'syringe' then
			self.syringe:update(dt)
		end
	else
		if self.walkingspeed:length()>0 then
			if self.profile == 'high' then
				self.run:update(dt)
			elseif self.profile == 'medium' then
				self.feet:update(dt)
			elseif self.profile == 'low' then
				self.stealth:update(dt)
				self.feet:update(dt)
			end
		else
			self.feet:halt()
		end
	end
end

function RiverActor:draw(u)
	local x,y = u:getPosition()
	local r = u:getAngle()
	--	print (x,y)
	if self.animation then
		if self.animation == 'syringe' then
			self.feet:draw(x,y,r)
			self.syringe:draw(x,y,r)
		elseif self.animation == 'held' then

			self.feet:draw(x,y,r)
			self.held:draw(x,y,r)
		end
	else
		if self.walkingspeed:length()>0 then
			if self.profile == 'high' then
				self.run:draw(x,y,r)
			elseif self.profile == 'medium' then
				self.feet:draw(x,y,r)
			elseif self.profile == 'low' then
				self.feet:draw(x,y,r)
				self.stealth:draw(x,y,r)
			end
		else
			if self.profile == 'low' then
				self.feet:draw(x,y,r)
				self.stealth:draw(x,y,r)
			else
				self.feet:draw(x,y,r)
			end
		end
	end
end