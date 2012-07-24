Item = Doodad:subclass'Item'
function Item:equip(unit)
end

function Item:unequip(unit)
end

function Item:drawInHand(unit)
end

function Item:use(target)
end

ImproviseWeapon = Item:subclass'ImproviseWeapon'
function ImproviseWeapon:interact(host,target)
	
end

function ImproviseWeapon:active(host,target)
	if not instanceOf(River,target) then
		return false,'INVALID TARGET'
	end
	local l = (Vector(host:getPosition())-Vector(target:getPosition())):length()
	print (l)
	if l<125 then
		if true then -- behind back
			execute(function()
			local r = target:getAngle()
			local v = Vector(math.cos(r),math.sin(r))
			host:setPosition(Vector(target:getPosition())-v*40)
			host:setAngle(r-0.3)
			local sound = require 'library.sound'
			sound.play("sound/interface/drum3.ogg","interface")
			host.actor.animation = 'synringe'
			wait(0.5)
			target.actor.animation = 'held'
			
				wait(5)
				target:kill()				
			end)
		end
	else
		return false,'OUT OF RANGE'
	end
end

local item = {}
local itemdef
function item.load()
	itemdef = require 'item.definition'
end

function item.decode(t)
	return item.create(t.info,t.x,t.y,t.r)
end

function item.create(def,x,y,r)
	if type(def) == 'string' then
		def = itemdef[def]
	end
	local d = def.class(doodadMover,x,y,r,def.bodytype,def)
	return d
end

return item