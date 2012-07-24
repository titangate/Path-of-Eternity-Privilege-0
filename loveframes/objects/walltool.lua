--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
wallTool = class("wallTool", base)
wallTool:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function wallTool:initialize()

	self.type			= "wallTool"
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
function wallTool:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate

	local x, y = love.mouse.getPosition()
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	-- dragging check
	self:CheckHover()


	if self.Update then
		self.Update(self, dt)
	end
	
	if not self.visible then return end
	if love.mouse.isDown'l' then
		if self.OnLeftDown then
			self.OnLeftDown(self)
		end
	end

	if love.mouse.isDown'r' then
		if self.OnRightDown then
			self.OnRightDown(self)
		end
	end
end

function wallTool:setPos(x,y)
	self.clickx,self.clicky = -10,-10
	base.setPos(self,x,y)
end

function wallTool:getCenter()
	return self.x+self.width/2,self.y+self.height/2
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function wallTool:draw()
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

	--	skin.DrawDoodad(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function wallTool:mousepressed(x, y, button)
	if not self.visible then return end
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function wallTool:mousereleased(x, y, button)
	
end
