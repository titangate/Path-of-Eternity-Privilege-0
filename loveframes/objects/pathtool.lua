--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
pathTool = class("pathTool", base)
pathTool:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function pathTool:initialize()

	self.type			= "pathTool"
	self.width 			= 30
	self.height 		= 30
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
function pathTool:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate

	local x, y = love.mouse.getPosition()
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	-- dragging check
	if self.dragging == true then
		self.x = x - self.clickx
		self.y = y - self.clicky
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

function pathTool:setPos(x,y)
	self.clickx,self.clicky = -10,-10
	base.setPos(self,x,y)
end

function pathTool:getCenter()
	return self.x+self.width/2,self.y+self.height/2
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function pathTool:draw()
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
		
	if self.Draw ~= nil then
		self.Draw(self)
	else

	end
	
end

function pathTool:setDelegate(del)
	self.del = del
end

function pathTool:setMap(m)
	self.map = m
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function pathTool:mousepressed(x, y, button)
	if not self.visible then return end
	if button == 'l' and global.map then
		if not self.path then
			self.path = PatrolPath({Vector(global.map:screenToMap(x,y))})
			global.map:addUnit(self.path)
		else
			self.path:addPoint(Vector(global.map:screenToMap(x,y)))
		end
	elseif button == 'r' and global.map then
		self.path = nil
	end
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function pathTool:mousereleased(x, y, button)
	
end
