--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- button clas
menubutton = class("menubutton", base)
menubutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function menubutton:initialize()

	self.type			= "menubutton"
	self.text 			= "Category"
	self.width			= 200
	self.height			= 25
	self.closedheight	= 25
	self.padding		= 2
	self.internal		= false
	self.open			= false
	self.down		 	= false
	self.children		= {}
	self.OnOpenedClosed	= nil
	self.clickable		= true
	self.enabled		= true
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function menubutton:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local open = self.open
	local children = self.children
	local curobject = children[1]
	
	self:CheckHover()
	
	if self.hover then
		if self.open == false then
			self:SetOpen(true)
		end
	else
		if self.open == true then
			self:SetOpen(false)
		end
	end
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base or self.parent.class == list then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if open == true then
		curobject:update(dt)
		curobject:SetWidth(self.width - self.padding*2)
		curobject.y = (curobject.parent.y + curobject.staticy)
		curobject.x = (curobject.parent.x + curobject.staticx)
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function menubutton:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local open = self.open
	local children = self.children
	local curobject = children[1]
	
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
		skin.DrawMenuButton(self)
	end
	
	if open == true then
		curobject:draw()
	end
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function menubutton:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	
	if hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	
		self.down = true
		loveframes.hoverobject = self
		
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function menubutton:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	
	if hover == true and down == true and button == "l" and clickable == true then
		if enabled == true then
			if self.OnClick then
				coroutinemsg(coroutine.resume(coroutine.create(function() self.OnClick(self, x, y) end)))
			end
		end
	end
	
	self.down = false
	

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function menubutton:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function menubutton:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the category's object
--]]---------------------------------------------------------
function menubutton:SetObject(object)
	
	local children = self.children
	local curobject = children[1]
	
	if curobject then
		curobject:Remove()
		self.children = {}
	end
	
	object:Remove()
	object.parent = self
	object:SetWidth(self.width - self.padding*2)
	object:setPos(self.padding, self.closedheight + self.padding)
	
	table.insert(self.children, object)
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the category's object
--]]---------------------------------------------------------
function menubutton:GetObject()

	local children = self.children
	local curobject = children[1]
	
	if curobject then
		return curobject
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: setSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function menubutton:setSize(width, height)

	self.width = width
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function menubutton:SetHeight(height)

	return
	
end

--[[---------------------------------------------------------
	- func: SetClosedHeight(height)
	- desc: sets the object's closed height
--]]---------------------------------------------------------
function menubutton:SetClosedHeight(height)

	self.closedheight = height
	
end

--[[---------------------------------------------------------
	- func: GetClosedHeight()
	- desc: gets the object's closed height
--]]---------------------------------------------------------
function menubutton:GetClosedHeight()

	return self.closedheight
	
end

--[[---------------------------------------------------------
	- func: SetOpen(bool)
	- desc: sets whether the object is opened or closed
--]]---------------------------------------------------------
function menubutton:SetOpen(bool)
	local children = self.children
	local curobject = children[1]
	
	self.open = bool
	
	if bool == false then
--		loveframes.anim:easy(self,'height',self.closedheight + self.padding*2 + curobject.height,self.closedheight,0.3)
		self.height = self.closedheight
		if curobject then
			curobject:SetVisible(false)
		end
	else
		
--		loveframes.anim:easy(self,'height',self.closedheight,self.closedheight + self.padding*2 + curobject.height,0.3)
		self.height = self.closedheight + self.padding*2 + curobject.height
		if curobject then
			curobject:SetVisible(true)
		end
	end
			
	if self.OnOpenedClosed then
		self.OnOpenedClosed(self)
	end
	
end

function menubutton:SetDescription(text)
	
	if text ~= "" then
		
		-- skin variables
		local index	= loveframes.config["ACTIVESKIN"]
		local defaultskin = loveframes.config["DEFAULTSKIN"]
		local selfskin = self.skin
		local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]

		local textobject = loveframes.Create("text")
		textobject:setSize(self.width,50)
		textobject:SetText({skin.controls.menubutton_text_hover_color,text})
--		textobject:SetFont(font.smallfont)
		
--		textobject:SetText(text)
		self:SetObject(textobject)
		
	else
	
		self.width = self.width
		self.height = self.height
		
	end
end

--[[---------------------------------------------------------
	- func: GetOpen()
	- desc: gets whether the object is opened or closed
--]]---------------------------------------------------------
function menubutton:GetOpen()

	return self.open

end