--[[------------------------------------------------
	-- L�VE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- columnlist object
columnlist = class("columnlist", base)
columnlist:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: intializes the element
--]]---------------------------------------------------------
function columnlist:initialize()
	
	self.type 			= "columnlist"
	self.width 			= 300
	self.height 		= 100
	self.autoscroll		= false
	self.internal		= false
	self.children		= {}
	self.internals 		= {}
	self.OnRowClicked 	= nil
	self.OnScroll		= nil

	local list = columnlistarea:new(self)
	table.insert(self.internals, list)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function columnlist:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local children = self.children
	local internals = self.internals
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	for k, v in ipairs(children) do
		v:update(dt)
	end
	
	for k, v in ipairs(internals) do
		v:update(dt)
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function columnlist:draw()

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
	
	local children = self.children
	local internals = self.internals
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
	
	if self.Draw ~= nil then
		self.Draw(self)
	else
		skin.DrawColumnList(self)
	end
	
	for k, v in ipairs(internals) do
		v:draw()
	end
	
	for k, v in ipairs(children) do
		v:draw()
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function columnlist:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local children = self.children
	local internals = self.internals
	
	if hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
	end
		
	for k, v in ipairs(internals) do
		v:mousepressed(x, y, button)
	end
	
	for k, v in ipairs(children) do
		v:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function columnlist:mousereleased(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local children = self.children
	local internals = self.internals
	
	for k, v in ipairs(internals) do
		v:mousereleased(x, y, button)
	end
	
	for k, v in ipairs(children) do
		v:mousereleased(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: Adjustchildren()
	- desc: adjusts the width of the object's children
--]]---------------------------------------------------------
function columnlist:AdjustColumns()

	local width = self.width
	local bar = self.internals[1].bar
	
	if bar == true then
		width = width - 16
	end
	
	local children = self.children
	local numchildren = #children
	local columnwidth = width/numchildren
	local x = 0
	
	for k, v in ipairs(children) do
		if bar == true then
			v:SetWidth(columnwidth)
		else
			v:SetWidth(columnwidth)
		end
		v:setPos(x, 0)
		x = x + columnwidth
	end
	
end

--[[---------------------------------------------------------
	- func: AddColumn(name)
	- desc: gives the object a new column with the specified
			name
--]]---------------------------------------------------------
function columnlist:AddColumn(name)

	local internals = self.internals
	local list = internals[1]
	
	columnlistheader:new(name, self)
	self:AdjustColumns()
	
	list:setSize(self.width, self.height)
	list:setPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: AddRow(...)
	- desc: adds a row of data to the object's list
--]]---------------------------------------------------------
function columnlist:AddRow(...)

	local internals = self.internals
	local list = internals[1]
	
	list:AddRow(arg)
	
end

--[[---------------------------------------------------------
	- func: Getchildrenize()
	- desc: gets the size of the object's children
--]]---------------------------------------------------------
function columnlist:GetColumnSize()

	local children = self.children
	local numchildren = #self.children
	local column = self.children[1]
	local colwidth = column.width
	local colheight = column.height
	
	if numchildren > 0 then
		return colwidth, colheight
	else
		return 0, 0
	end
	
end

--[[---------------------------------------------------------
	- func: setSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function columnlist:setSize(width, height)
	
	local internals = self.internals
	local list = internals[1]
	
	self.width = width
	self.height = height
	
	list:setSize(width, height)
	list:setPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function columnlist:SetWidth(width)
	
	local internals = self.internals
	local list = internals[1]
	
	self.width = width
	
	list:setSize(width)
	list:setPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function columnlist:SetHeight(height)
	
	local internals = self.internals
	local list = internals[1]
	
	self.height = height
	
	list:setSize(height)
	list:setPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetMaxColorIndex(num)
	- desc: sets the object's max color index for
			alternating row colors
--]]---------------------------------------------------------
function columnlist:SetMaxColorIndex(num)

	local internals = self.internals
	local list = internals[1]
	
	list.colorindexmax = num
	
end

--[[---------------------------------------------------------
	- func: Clear()
	- desc: removes all items from the object's list
--]]---------------------------------------------------------
function columnlist:Clear()

	local internals = self.internals
	local list = internals[1]
	
	list:Clear()
	
end

--[[---------------------------------------------------------
	- func: SetAutoScroll(bool)
	- desc: sets whether or not the list's scrollbar should
			auto scroll to the bottom when a new object is
			added to the list
--]]---------------------------------------------------------
function columnlist:SetAutoScroll(bool)

	local internals = self.internals
	local list = internals[1]
	
	self.autoscroll = bool
	
	if list then
		if list:GetScrollBar() ~= false then
			list:GetScrollBar().autoscroll = bool
		end
	end
	
end