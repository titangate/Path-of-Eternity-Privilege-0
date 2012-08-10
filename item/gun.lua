
Gun = Item:subclass'Gun'
function Gun:interact(host,target)
	
end

function Gun:active(host,target)
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
			
			--sound.play("sound/interface/drum3.ogg","interface")
			host.actor.animation = 'synringe'
			target.aihost:terminate(target,true,360000)
			wait(0.5)
			local s = Sound('sound/interface/drum3.ogg',Vector(target:getPosition()),1000,'effect',global.aihost,3)
			s:play()
			target.actor.animation = 'held'
				wait(5)
				target:kill()				
			end)
		end
	else
		return false,'OUT OF RANGE'
	end
end