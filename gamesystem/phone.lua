local phone = {}
local essential = require 'library.essential'
function phone:distract()
	local f = loveframes.Create("list",self.phoneframe)
	self.buttons.distract.active = true
	f:setSize(220,310)
	f:setPos(40,70)
	f:SetPadding(50)
	f:SetSpacing(20)
	f.name = LocalizedString'DISTRACT'


	function f.Draw(object)
		local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		skin.DrawFrame(object)
	end

	local distractnumber = {5,10,15}
	for i=1,3 do
		local b = loveframes.Create("button",f)
		b.OnClick = function(object)
			self.buttons.distract.active = false
			f:Remove()
			-- initiate distraction
		end
		b:setText(string.format(LocalizedString"DISTRACT IN %d SECONDS",distractnumber[i]))
		f:AddItem(b)
	end

	local close = loveframes.Create("button",f)
	close.OnClick = function(object)
		self.buttons.distract.active = false
		f:Remove()
	end



	close:setText(LocalizedString"CLOSE")
	f:AddItem(close)
	assert(filters.gaussianblur)
	f.filter = filters.gaussianblur
	f.gaussianblur_intensity = 5
	loveframes.anim:easy(f,"gaussianblur_intensity",5,0,0.3)
	wait(0.3)
	--f.filter = nil
end


function phone:dial()
	local f = loveframes.Create("list",self.phoneframe)
	self.buttons.dial.active = true
	f:setSize(220,310)
	f:setPos(40,70)
	f:SetPadding(50)
	f:SetSpacing(20)
	f.name = LocalizedString'DIAL'


	function f.Draw(object)
		local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		skin.DrawFrame(object)
	end

	local dials = {'KEVIN','HOSPITAL'}
	for i=1,2 do
		local b = loveframes.Create("button",f)
		b.OnClick = function(object)
			self.buttons.dial.active = false
			f:Remove()
			-- to dial
		end
		b:setText(LocalizedString(dials[i]))
		f:AddItem(b)
	end

	local close = loveframes.Create("button",f)
	close.OnClick = function(object)
		self.buttons.dial.active = false
		f:Remove()
	end

	close:setText(LocalizedString"CLOSE")
	f:AddItem(close)
	assert(filters.gaussianblur)
	f.filter = filters.gaussianblur
	f.gaussianblur_intensity = 5
	loveframes.anim:easy(f,"gaussianblur_intensity",5,0,0.3)
	wait(0.3)
	--f.filter = nil
end

function phone:load()
	local frame1 = loveframes.Create("frame")
	frame1:setName(LocalizedString"OPTIONS")
	frame1:setSize(300, 450)
	frame1:setPos(screen.width - 400,screen.height - 400)
	local img = requireImage'asset/interface/phone.png'
	frame1.Draw = function(object)
		love.graphics.draw(img,object.x,object.y)
	end
	
	frame1:ShowCloseButton(false)
	frame1:SetAlwaysUpdate(true)
	frame1.Update = function(object,dt)
--		object:MakeTop()
	end

	local distractbutton = loveframes.Create("circlebutton",frame1)
	distractbutton:setPos(40,70)
	distractbutton:setSize(64,64)
	distractbutton:setImage'asset/icon/distract.png'
	distractbutton:setText''
	distractbutton.OnClick = function(object)
		self:distract()
	end
	local t = loveframes.Create("text",frame1)
	t:setText(LocalizedString"DISTRACT")
	t:SetFont(font.imagebuttonfont)
	t:setPos(110,92)
	local callbutton = loveframes.Create("circlebutton",frame1)
	callbutton:setPos(40,150)
	callbutton:setSize(64,64)
	callbutton:setImage'asset/icon/call.png'
	callbutton:setText''
	callbutton.OnClick = function(object)
		self:dial()
	end
	t = loveframes.Create("text",frame1)
	t:setText(LocalizedString"DIAL")
	t:SetFont(font.imagebuttonfont)
	t:setPos(110,170)
	local hackbutton = loveframes.Create("circlebutton",frame1)
	hackbutton:setPos(40,230)
	hackbutton:setSize(64,64)
	hackbutton:setImage'asset/icon/hack.png'
	hackbutton:setText''
	t = loveframes.Create("text",frame1)
	t:setText(LocalizedString"HACK")
	t:SetFont(font.imagebuttonfont)
	t:setPos(110,250)

	self.buttons = {
		distract = distractbutton,
		dial = callbutton,
		hack = hackbutton,
	}

	self.phoneframe = frame1
	loveframes.anim:easy(self.phoneframe,'y',screen.height,self.phoneframe.y,0.3,loveframes.style.quadInOut)
end

function phone:dismiss()
	loveframes.anim:easy(self.phoneframe,'y',self.phoneframe.y,screen.height,0.3,loveframes.style.quadInOut)
end

return phone