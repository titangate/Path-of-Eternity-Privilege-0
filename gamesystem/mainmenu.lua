local mainmenu = {}
local sound = require 'library.sound'
function mainmenu:load()
	-- music
	------------------------------------
	-- button example
	------------------------------------
	
	local map = loveframes.Create("image")
	map:setImage"worldmap.png"
--	map:SetColor{82, 60, 25,255}
	
	local img = requireImage'worldmap.png'
	function map.Draw(m)
		gra.setColor(82, 60, 25,self.mapopacity^0.3*255)
		gra.push()
--		gra.translate(screen.halfwidth,screen.halfheight)
		local x,y = self.focus.x,self.focus.y
		local ox,oy = 0,0
		local s = screen.width/(img:getWidth()*option.retina)*self.mapscale
--		gra.translate(-screen.halfwidth*s,-screen.halfheight*s)self.mapopacity
		gra.translate(-x*s*(1-self.mapopacity)^0.3,-y*s*(1-self.mapopacity)^0.3)
		gra.scale(s)
		gra.translate((ox+screen.halfwidth)/s,(oy+screen.halfheight)/s)
		gra.draw(img,0,0,0,1,1,img:getWidth()/2,img:getHeight()/2)
		gra.setColor(255,0,0,self.mapopacity^0.3*255)
		gra.circle('fill',x,y,15)
		gra.pop()
		gra.setColor(255,255,255)
		gra.draw(requireImage'asset/banner.png',screen.halfwidth,100,0,0.5,0.5,936/2,288/2)
	end
	map:transmitEffect(true)
	self.focus = Vector(0,0)
	local exampleslist = loveframes.Create("list")
	exampleslist:setSize(450, exampleslist:GetParent():getHeight() - 25)
	exampleslist:setPos(screen.halfwidth,screen.halfheight)
	exampleslist:SetPadding(5)
	exampleslist:SetSpacing(5)
	exampleslist:SetDisplayType("vertical")
	
	
	function exampleslist:Draw()
	end
	
	self.base = exampleslist
	assert(self.base)
	self.map = map
	
	
	local textframe = loveframes.Create("frame")
	textframe:setPos(-100,-100)
	textframe:setSize(50,50)
	function textframe.Draw()end
	self.textframe = textframe
	self.text = {}
	
	
	local info = {
		function()return LocalizedString'DATE: JUL 11, 2012' end,
		LocalizedString'NAME: LILY ROSEMARIE HAMILTON',
		LocalizedString'GENDER: FEMALE',
		LocalizedString'DATE OF BIRTH: DEC/16/1993',
		LocalizedString'RACE: CAUCASIAN',
		LocalizedString'HEIGHT: 1.60 M',
		LocalizedString'STATUS: COMA',
		function()return string.format(LocalizedString'BLOOD PRESSURE: %d/%d mmHg',math.random(88,96),math.random(59,66)) end,
		function()return LocalizedString'HEARTRATE: '..tostring(math.random(75,85)) end,
		function()return LocalizedString'HOSPITALIZED SINCE: JUL 1, 2012' end,
	}
	
	local function createlabel(text)
		if type(text)=='function' then
			text = text()
		end
		local t = loveframes.Create('text',self.textframe)
--		t:SetFont(font.smallfont)
		t:setPos(screen.halfwidth - 300,screen.halfheight + 200)
		t.y = screen.halfheight + 200
		loveframes.anim:easy(t,'y',screen.halfheight+200,screen.halfheight-150,10)
		t:SetWidth(300)
		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
		t:setText(text)
		return t
	end
	
	local i = 0
	self.co = coroutine.create(function()
		while true do
			if self.dismissing then
				self.dismissing = nil
				return 
			end
			local t = createlabel(info[i%#info+1])
			i = i + 1
			table.insert(self.text,t)
			wait(1)
			t.filter = nil
--			self.text.heartrate = t
			if #self.text > 9 then
				table.remove(self.text,1):Remove()
				t = self.text[1]
				t.filter = filters.vibrate
				loveframes.anim:easy(t,'vibrate_ref',0,3,1,loveframes.style.linear)
			end
		end
		
	end)
	coroutinemsg(coroutine.resume(self.co))
	
	-- map related argument
	self.mapopacity = 1
	self.mapscale = 1
	
end

function mainmenu:loadpostmenu()
	
	local exampleslist = self.base
	local collapsiblecategory1 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory1:setPos(5, 30)
	collapsiblecategory1:setSize(490, 265)
	collapsiblecategory1:setText(LocalizedString"RESUME GAME")
	collapsiblecategory1:SetDescription(LocalizedString'RESTART FROM LAST CHECKPOINT')
	
	local collapsiblecategory2 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory2:setPos(5, 60)
	collapsiblecategory2:setSize(490, 265)
	collapsiblecategory2:setText(LocalizedString"START GAME")
	collapsiblecategory2:SetDescription(LocalizedString'START HOSPTIAL GAMEPLAY DEMO')
	
	collapsiblecategory2.OnClick = function(object)
		--love.event.push'quit'
		assert(self.host)
		
		coroutine.resume(coroutine.create(function()
		self:zoomin(500,121,1)
		self:dismiss()end))
		wait(0.5)
		local gs = require 'gamesystem.game'
		local f = 'userdata/hospital/m'
		--if string.sub(file,#file-5)=='.quest' then
		gs:load()
		local f1 = love.filesystem.read(f..'_mapdata.json')
		local f2 = love.filesystem.read(f..'_aidata.json')
		local f3 = love.filesystem.read(f..'.quest')
		
		gs:loadFromSave(
			json.decode(f1),
			json.decode(f2),
			json.decode(f3)
		)
		--end
		self.host.push(gs,1)
	end
	
	local collapsiblecategory4 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory4:setPos(5, 60)
	collapsiblecategory4:setSize(490, 265)
	collapsiblecategory4:setText(LocalizedString"OPTIONS")
	collapsiblecategory4:SetDescription(LocalizedString'CHANGE GAMEPLAY, GRAPHICS, AUDIO SETTINGS')
	
	collapsiblecategory4.OnClick = function(object)
		
		require 'gamesystem.optionmenu'.OnReset = function()self:reset()end
		require 'gamesystem.optionmenu':load()
	end


	local selectionwheelbutton = loveframes.Create("menubutton", exampleslist)
	selectionwheelbutton:setPos(5, 60)
	selectionwheelbutton:setSize(490, 265)
	selectionwheelbutton:setText(LocalizedString"DIALOGUE")
	selectionwheelbutton:SetDescription(LocalizedString'CALL OUT DIALOGUE PANEL')
	
	selectionwheelbutton.OnClick = function(object)
		
		print(coroutine.resume(coroutine.create(function()
		loveframes.dialogue(LocalizedString'TEST',LocalizedString"I'M DRUNK. IGNORE THIS MESSAGE.",{"OK"},function()end) end)))
	end
	
	local collapsiblecategory3 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory3:setPos(5, 60)
	collapsiblecategory3:setSize(490, 265)
	collapsiblecategory3:setText(LocalizedString"QUIT GAME")
	collapsiblecategory3:SetDescription(LocalizedString'EXIT TO OPERATION SYSTEM')
	collapsiblecategory3.OnClick = function(object)
		love.event.push'quit'
	end
	self.lastload = self.loadmain
	
end

function mainmenu:loadmain()
	self:load()
	local exampleslist = self.base
	self:loadpostmenu()
	local t=self.map
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',10,0,1,loveframes.style.linear)
	
--	sound.applyToChannel('music',function(s)s:stop()end)
	sound.playMusic('sound/music/adagio.ogg')
end

function mainmenu:loadpause()
	self:load()
	local exampleslist = self.base
	
	local collapsiblecategory0 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory0:setPos(5, 30)
	collapsiblecategory0:setSize(490, 265)
	collapsiblecategory0:setText(LocalizedString"CONTINUE")
	collapsiblecategory0:SetDescription(LocalizedString'DISMISS THIS MENU AND CONTINUE THE GAME')
	
	collapsiblecategory0.OnClick = function(object)
		assert(self.host)
		
		coroutine.resume(coroutine.create(function()
			self:zoomin(500,121,1)
			self:dismiss()
		end))
		wait(0.25)
		self.host.pop()
		self.host.top():loadresume()
	end
	self:loadpostmenu()
	self.lastload = self.loadpause
	self:zoomout(500,121,0.5)
end

function mainmenu:reset()
	
	for i,t in ipairs(self.text) do
		t:Remove()
	end
	self.textframe:Remove()
	self.map:Remove()
	self.base:Remove()
	self.dismissing = true
	self:lastload()
end

function mainmenu:update(dt)
--	assert(self.base)
end


function mainmenu:draw()
end

function mainmenu:keypressed(k)
	if k=='c' then
		coroutine.resume(coroutine.create(function ()self:dismiss()end))
	elseif k=='m' then
		coroutine.resume(coroutine.create(function ()self:zoomin(500,121,1)end))
	elseif k=='n' then
		coroutine.resume(coroutine.create(function ()self:zoomout(500,121,10)end))
	elseif k=='o' then
		require 'gamesystem.optionmenu'.OnReset = function()self:reset()end
		require 'gamesystem.optionmenu':load()
		
	end
end

function mainmenu:keyreleased(k)
end

function mainmenu:mousepressed()
end
function mainmenu:mousereleased()
end

function mainmenu:dismiss()
	self.dismissing = true
	for i,t in ipairs(self.text) do
		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',0,10,0.5,loveframes.style.linear)
	end
	local t = self.base
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',0,10,0.5,loveframes.style.linear)
	wait(0.5)
	
	for i,t in ipairs(self.text) do
		t:Remove()
	end
	self.map:Remove()
	self.base:Remove()
end

function mainmenu:zoomin(x,y,time)
	self.focus = Vector(x,y)
	loveframes.anim:easy(self,'mapscale',1,10,time)
	loveframes.anim:easy(self,'mapopacity',1,0,time)
	
	local t = self.map
	t.filter = filters.zoomblur
	t.zoomblur_center = Vector(self.focus.x,self.focus.y)
	t.zoomblur_intensity = 1
	loveframes.anim:easy(t,'zoomblur_intensity',0,5,time,loveframes.style.linear)
	loveframes.anim:easy(t.zoomblur_center,'x',self.focus.x,0.5,time,loveframes.style.linear)
	loveframes.anim:easy(t.zoomblur_center,'y',self.focus.y,0.5,time,loveframes.style.linear)
	wait(time)
	t.filter = nil
end

function mainmenu:zoomout(x,y,time)
	
	self.focus = Vector(x,y)
	loveframes.anim:easy(self,'mapscale',10,1,time)
	loveframes.anim:easy(self,'mapopacity',0,1,time)
	
	local t = self.map
	t.filter = filters.zoomblur
	t.zoomblur_center = Vector(self.focus.x,self.focus.y)
	t.zoomblur_intensity = 1
	loveframes.anim:easy(t,'zoomblur_intensity',5,0,time,loveframes.style.linear)
	loveframes.anim:easy(t.zoomblur_center,'x',0.5,self.focus.x,time,loveframes.style.linear)
	loveframes.anim:easy(t.zoomblur_center,'y',0.5,self.focus.y,time,loveframes.style.linear)
	wait(time)
	t.filter = nil
end


return mainmenu