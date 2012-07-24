--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
humanTool = class("humanTool", base)
humanTool:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function humanTool:initialize()

	self.type			= "humanTool"
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
function humanTool:update(dt)

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

	if self.hover then
		local x,y = love.mouse.getPosition()
		local ox,oy = self:getCenter()
		local dis = Vector(x-ox,y-oy):length()
		if dis < self.width/4 then
			self.state = 'translate'
		else
			self.state = 'rotate'
		end
	end
	
	-- move to parent if there is a parent
--	if self.parent ~= nil then
--		self.x = self.parent.x + self.staticx
--		self.y = self.parent.y + self.staticy
--	end
	
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

function humanTool:setPos(x,y)
	self.clickx,self.clicky = -10,-10
	base.setPos(self,x,y)
end

function humanTool:getCenter()
	return self.x+self.width/2,self.y+self.height/2
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function humanTool:draw()
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
		skin.DrawHuman(self)
	end
	
end

function humanTool:setDelegate(del)
	self.del = del
end

function humanTool:setHuman(def)
	self.def = def
	self.head = requireImage('unit/'..def.head)
	self.shoulder = requireImage('unit/'..def.shoulder)
	self.feet = requireImage('unit/'..def.feet)
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function humanTool:mousepressed(x, y, button)
	if not self.visible then return end
	if button == 'r' and self.del then
		self.del:spawnUnit(x,y,self.def)
	end
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function humanTool:mousereleased(x, y, button)
	
end
