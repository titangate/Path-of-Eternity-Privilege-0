
SyringeKetamine = Item:subclass'SyringeKetamine'
function SyringeKetamine:initialize(...)
	Item.initialize(self,...)
	self.s = Sound('sound/effect/syringe.ogg',nil,100,'effect',global.aihost,3)
	self.sedating_time = 20
end
function SyringeKetamine:interact(host,target)
	
end

function SyringeKetamine:update_i(dt)
	if self.owner and not self.acting then
		local x,y = self.owner.map:screenToMap(love.mouse.getPosition())
		self.s:setPosition(Vector(x,y))
	end
end

function SyringeKetamine:active(host,target)
	if not instanceOf(River,target) then
		return false,'INVALID TARGET'
	end
	local l = (Vector(host:getPosition())-Vector(target:getPosition())):length()
	if l<125 then
		if true then -- behind back
			execute(function()
			local r = target:getAngle()
			local v = Vector(math.cos(r),math.sin(r))
			host:setPosition(Vector(target:getPosition())-v*40)
			host:setAngle(r-0.3)
			--local sound = require 'library.sound'
			self.acting = true
			sound.play("sound/interface/drum3.ogg","interface")
			host.actor.animation = 'syringe'
			target.aihost:suspendAI(target,self.sedating_time)
			--target.aihost:terminate(target,false,10)
			wait(1)
			self.s:play()
			host.map:addUnit(self.s)
			--target.aihost:terminate(target,false,10)
			target.actor.animation = 'held'
			wait(5)
			target.actor.animation = nil
			host.actor.animation = nil
			local u = target:kill(self)
			u.live = target
			self.acting = nil
			wait(self.sedating_time-7)
			u:revive()
			end)
		end
	else
		return false,'OUT OF RANGE'
	end
end

function SyringeKetamine:draw_lli()
	self.s:drawCircle()
end