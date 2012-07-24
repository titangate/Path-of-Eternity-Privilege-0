--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
doorTool = class("doorTool", base)
doorTool:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function doorTool:initialize()

	self.type			= "doorTool"
	self.width 			= 5
	self.height 		= 5
	self.Spinrate		= 1
	self.Spinvalue		= 0
	self.completed		= false
	self.Spin			= false
	self.internal		= false
	self.dragging		= true
	self.draggable		= true

end
--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function doorTool:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate

	local x, y = love.mouse.getPosition()
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	self:CheckHover()

	-- move to parent if there is a parent
--	if self.parent ~= nil then
--		self.x = self.parent.x + self.staticx
--		self.y = self.parent.y + self.staticy
--	end
	
	
	if self.Update then
		self.Update(self, dt)
	end

	
end

function doorTool:setPos(x,y)
	self.clickx,self.clicky = -10,-10
	base.setPos(self,x,y)
end

function doorTool:getCenter()
	return self.x+self.width/2,self.y+self.height/2
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function doorTool:draw()
	local visible = self.visible
	
	if visible == false then
		return
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function doorTool:mousepressed(x, y, button)
	if not self.visible then return end
	if button == 'l' then self.OnLeftDown(self,x,y,button) end
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function doorTool:mousereleased(x, y, button)
	
end
