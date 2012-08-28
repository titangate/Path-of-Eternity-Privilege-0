
SyringeAngexetine = Item:subclass'SyringeAngexetine'
function SyringeAngexetine:initialize(...)
	Item.initialize(self,...)
	self.s = Sound('sound/effect/syringe.ogg',nil,100,'effect',global.aihost,3)
end
function SyringeAngexetine:interact(host,target)
	
end

function SyringeAngexetine:update_i(dt)
	if self.owner and not self.acting then
		local x,y = self.owner.map:screenToMap(love.mouse.getPosition())
		self.s:setPosition(Vector(x,y))
	end
end

function SyringeAngexetine:active(host,target)
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
			target.aihost:terminate(target,false,360000)
			wait(1)
			
			self.s:play()
			host.map:addUnit(self.s)
			target.actor.animation = 'held'
			wait(5)
			target:kill(self)
			self.acting = nil			
			end)
		end
	else
		return false,'OUT OF RANGE'
	end
end

function SyringeAngexetine:draw_lli()
	self.s:drawCircle()
end