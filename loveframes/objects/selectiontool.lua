--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
selectionTool = class("selectionTool", base)
selectionTool:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function selectionTool:initialize()

	self.type			= "selectionTool"
	self.width 			= 100
	self.height 		= 100
	self.Spinrate		= 1
	self.Spinvalue		= 0
	self.completed		= false
	self.Spin			= false
	self.internal		= false
	self.dragging		= false
	self.draggable		= true
	

end
--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function selectionTool:update(dt)

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
		if self.state == 'translate' then
			self.x = x - self.clickx
			self.y = y - self.clicky
		else
			local ox,oy = self:getCenter()
			local r = math.atan2(y-oy,x-ox)
			self.Spinvalue = r
		end
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

function selectionTool:getCenter()
	return self.x+self.width/2,self.y+self.height/2
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function selectionTool:draw()
	
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
		skin.DrawCompass(self)
	end
	
end
--[[---------------------------------------------------------
	- func: SetMinMax()
	- desc: sets the object's minimum and maximum values
--]]---------------------------------------------------------
function selectionTool:SetMinMax(min, max)

	self.min = min
	self.max = max
	
end

--[[---------------------------------------------------------
	- func: GetMinMax()
	- desc: gets the object's minimum and maximum values
--]]---------------------------------------------------------
function selectionTool:GetMinMax()

	return self.min, self.max
	
end

--[[---------------------------------------------------------
	- func: SetValue(value)
	- desc: sets the object's value
--]]---------------------------------------------------------
function selectionTool:SetValue(value)

	self.Spinvalue = value
	
end

--[[---------------------------------------------------------
	- func: GetValue()
	- desc: gets the object's value
--]]---------------------------------------------------------
function selectionTool:GetValue()

	return self.Spinvalue
	
end

--[[---------------------------------------------------------
	- func: SetSpinRate(rate)
	- desc: sets the object's Spin rate
--]]---------------------------------------------------------
function selectionTool:SetSpinRate(rate)

	self.Spinrate = rate
	
end

--[[---------------------------------------------------------
	- func: GetSpinRate()
	- desc: gets the object's Spin rate
--]]---------------------------------------------------------
function selectionTool:GetSpinRate()

	return self.Spinrate
	
end


function selectionTool:MakeTop()
	
	local x, y = love.mouse.getPosition()
	local key = 0
	local base = loveframes.base
	local basechildren = base.children
	local numbasechildren = #basechildren
	
	if numbasechildren == 1 then
		return
	end
	
	if basechildren[numbasechildren] == self then
		return
	end
	
	-- make this the top object
	for k, v in ipairs(basechildren) do
		if v == self then
			table.remove(basechildren, k)
			table.insert(basechildren, self)
			key = k
			break
		end
	end
	
	basechildren[key]:mousepressed(x, y, "l")
		
end


--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function selectionTool:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local width = self.width
	local height = self.height
	local selfcol = loveframes.util.BoundingBox(x, self.x, y, self.y, 1, self.width, 1, self.height)
	local children = self.children
	local internals = self.internals
	
	if selfcol == true then
	
		local top = self:IsTopCollision()
		-- initiate dragging if not currently dragging
		if self.dragging == false and top == true and button == "l" then
			if self.draggable == true then
				self.clickx = x - self.x
				self.clicky = y - self.y
				self.dragging = true
			end
		end
		
		if top == true and button == "l" then
			self:MakeTop()
		end
		
	end
	
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function selectionTool:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local dragging = self.dragging
	local children = self.children
	local internals = self.internals
	
	-- exit the dragging state
	if dragging == true then
		self.dragging = false
	end
	
end
