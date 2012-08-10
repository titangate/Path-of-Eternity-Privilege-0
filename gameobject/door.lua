require 'gameobject.unit'
Door = Unit:subclass'Door'
function Door:initialize(movertype,x,y,r,bt,block,bx,by)
	r = r or 0
	Unit.initialize(self,movertype,x,y,r,bt,block)
	self.info = {interact = 'opendoor',root = {bx,by},bodytype = bt}
	self.r = r
end

function Door:_draw(x,y,r)
	love.graphics.setColor(255,255,0)
	love.graphics.draw(requireImage'dot.png',x,y,r,100,32,0,0.5)
end

function Door:pre_open(state,direction)
	execute(function()
		wait(0.1)
		self:open(state,direction)
	end)
end

function Door:open(state,direction)
	if state then
		self.mover:setOpen(state,direction)
	else
		self.mover:setOpen(state,0)
	end
	self.info.open = state
	self.info.direction = direction
end

function Door:draw_LLI()
	local x,y = self:getPosition()
	local r = self:getAngle()

	local scale = 0.5
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		love.graphics.setPixelEffect(stroke.pe)
	end

	self:_draw(x,y,r)

	if self.drawSelection then
		local obj = self
		local stroke = filters.selection
		love.graphics.setPixelEffect()
		stroke.c = nil
	end
	filters.lli_unit.conf(self)
	filters.lli_unit.predraw(self)
	self:_draw(x,y,r)
	filters.lli_unit.postdraw(self)
end

function Door:draw()
	local i = self.info
	local x,y = self:getPosition()
	local r = self:getAngle()
	local scale = 0.5
	if self.drawSelection then
		filters.selection.conf(self)
		local stroke = filters.selection
		-- customized shader predraw
		local obj = self
		local w = obj:getWidth()
		local h = obj:getHeight()
		stroke.pe:send('rf_h',h)
		stroke.pe:send('rf_w',w)
		love.graphics.setPixelEffect(stroke.pe)
	end

	self:_draw(x,y,r)
	if self.drawSelection then
		local obj = self
		local stroke = filters.selection
		love.graphics.setPixelEffect()
		stroke.c = nil
	end
end

function Door:getWidth()
	return 128
end

function Door:getHeight()
	return 32
end

function Door:encode()
	local x,y = self.mover:getPosition()
--	local r = self.mover:getAngle()

	return {info = self.info,x=x,y=y,self.r,name='Door'}
end


function CreateDoor(t)
	local bx,by = unpack(t.info.root)
	assert(bx)
	assert(by)
	local door = Door(DoorMover,t.x,t.y,t.r,t.info.bodytype,global.map:getBlockBody(bx,by),bx,by)
	if t.info.open then
		door:pre_open(t.info.open,t.info.direction)
	end
	return door
end