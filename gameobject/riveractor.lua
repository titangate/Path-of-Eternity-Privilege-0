RiverActor = Object:subclass'RiverActor'

local animation = require 'gameobject.animation'
function RiverActor:initialize()
	self.feet = animation.create'feet'
	self.synringe = animation.create'synringe'
--	self.stand = animation.create'stand'
	self.stealth = animation.create'stealth'
	self.action = 'synringe'
	self.held = animation.create'held'
end

function RiverActor:update(dt)
	if self.action == 'stealth' then
		self.feet:update(dt/2)
		self.stealth:update(dt)
	elseif self.action == 'synringe' then
		self.synringe:update(dt)
		self.feet:update(dt*2)
	end
end

function RiverActor:draw()
	self.feet:draw(320,310,0)
	self.held:draw(320,310,0)
--	self.feet:draw(300,300,0)
	if self.action == 'stealth' then
		self.stealth:draw(300,300,0)
	elseif self.action == 'synringe' then
		self.synringe:draw(300,300,0)
	end
end