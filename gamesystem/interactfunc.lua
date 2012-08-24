
interactfunc = {
	store = function(host,object)
		local store = require 'gamesystem.store'
		store:setInventory(host.inv)
		store:load()
	end,

	dragbody = function(host,object)
		local body1,body2 = object.mover.body.arm1,host.mover.body
		local x1,y1 = body1:getPosition()
		local x2,y2 = body2:getPosition()
		host.dragjoint = love.physics.newDistanceJoint(body1,body2,x1,y1,x2,y2)
		host.dragjoint:setLength(10)
	end,

	opendoor = function(host,object)
		if object.info.open then
			object:open(false,object.info.direction)
			return
		end
		local dif = Vector(object:getPosition())-Vector(host:getPosition())
		if dif.y > 0 and object.r == 0 then
			object:open(true,1)
		elseif dif.y < 0 and object.r == 0 then
			object:open(true,-1)
		elseif dif.x > 0 and object.r == math.pi then
			object:open(true,1)
		else
			object:open(true,-1)
		end
	end,

	
}
