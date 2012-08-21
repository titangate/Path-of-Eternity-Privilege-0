--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
image = class("image", base)
image:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function image:initialize()

	self.type			= "image"
	self.width 			= 0
	self.height 		= 0
	self.internal		= false
	self.image			= nil
	self.imagecolor		= nil
	self.scale = 1
	self.translate = {0,0}
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function image:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	-- move to parent if there is a parent
	if self.parent ~= nil then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	if self.Update then
		self.Update(self, dt)
	end
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function image:draw()
	if self.filter then 
		self.filter.conf(self)
		self.filter.predraw(self)
	end
	local visible = self.visible
	
	if visible == false then
		return
	end
	love.graphics.push()
	love.graphics.translate(unpack(self.translate))
	love.graphics.scale(self.scale)
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
		skin.DrawImage(self)
	end
	if self.filter then self.filter.postdraw(self) end
	love.graphics.pop()
end

--[[---------------------------------------------------------
	- func: setImage(image)
	- desc: sets the object's image
--]]---------------------------------------------------------
function image:setImage(image)

	if type(image) == "string" then
		self.image = requireImage(image)
	else
		self.image = image
	end
	
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
		
end

function image:transmitEffect(state)
	self.transmit = state
	if not state then return end
	self.co = coroutine.create(function()
		while true do
			if not self.transmit then
				return 
			end
			local effect = math.random(2)
			if effect == 1 then
				self.filter = filters.channelsplit
				assert (self.filter)
				for i=1,4 do
					self.channelsplit_intensity = math.random()*15
					wait(0.25)
				end
			elseif effect ==2 then
				self.filter = filters.vibrate
				self.vibrate_ref = 0
				assert (self.filter)
				for i=1,2 do

					loveframes.anim:easy(self,'vibrate_ref',self.vibrate_ref, math.random()*0.25,0.25)
					wait(0.25)
				end
				elseif effect ==3 then
					for i=1,4 do

					self.scale = math.random(1,4)
					self.translate = {math.random()*self:getWidth()/2,math.random()*self:getHeight()/2}
					wait(0.25)
				end
			else
				wait(1)
			end
			self.scale = 1
			self.translate = {0,0}
			self.filter = nil
			wait(3)
		end
	end)
	coroutinemsg(coroutine.resume(self.co))
end

--[[---------------------------------------------------------
	- func: SetColor(table)
	- desc: sets the object's color 
--]]---------------------------------------------------------
function image:SetColor(data)

	self.imagecolor = data
	
end