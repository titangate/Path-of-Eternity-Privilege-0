local mainmenu = {}
function mainmenu:load()
	------------------------------------
	-- button example
	------------------------------------
	
	local exampleslist = loveframes.Create("list")
	exampleslist:SetSize(450, exampleslist:GetParent():GetHeight() - 25)
	exampleslist:SetPos(screen.halfwidth,screen.halfheight)
	exampleslist:SetPadding(5)
	exampleslist:SetSpacing(0)
	exampleslist:SetDisplayType("vertical")
	
	local collapsiblecategory1 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory1:SetPos(5, 30)
	collapsiblecategory1:SetSize(490, 265)
	collapsiblecategory1:SetText(LocalizedString"RESUME GAME")
	collapsiblecategory1:SetDescription(LocalizedString'RESTART FROM LAST CHECKPOINT')
	
	local collapsiblecategory2 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory2:SetPos(5, 60)
	collapsiblecategory2:SetSize(490, 265)
	collapsiblecategory2:SetText(LocalizedString"START GAME")
	collapsiblecategory2:SetDescription(LocalizedString'START HOSPTIAL GAMEPLAY DEMO')
	local collapsiblecategory3 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory3:SetPos(5, 60)
	collapsiblecategory3:SetSize(490, 265)
	collapsiblecategory3:SetText(LocalizedString"QUIT GAME")
	collapsiblecategory3:SetDescription(LocalizedString'EXIT TO OPERATION SYSTEM')
	
	function exampleslist:Draw()
	end
	
	self.base = exampleslist
	assert(self.base)
	
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
		local t = loveframes.Create'text'
		t:SetFont(font.smallfont)
		t:SetPos(screen.halfwidth - 300,screen.halfheight+200)
		loveframes.anim:easy(t,'y',screen.halfheight+200,screen.halfheight-150,10)

		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
		t:SetText(text)
		return t
	end
	
	local i = 0
	coroutinemsg(coroutine.resume(coroutine.create(function()
		while true do
			local t = createlabel(info[i%#info+1])
			i = i + 1
			wait(1)
			t.filter = nil
--			self.text.heartrate = t
			table.insert(self.text,t)
			if #self.text > 10 then
				table.remove(self.text,1):Remove()
				t = self.text[1]
				t.filter = filters.vibrate
				loveframes.anim:easy(t,'vibrate_ref',0,3,1,loveframes.style.linear)
			end
			
			if self.dismissing then 
				self.dismissing = nil
				return end
		end
		
	end)))
	
	-- map related argument
	self.mapopacity = 255
	self.mapscale = 1
	self.focus = Vector(0,0)
	
end
function mainmenu:update(dt)
--	assert(self.base)
end


function mainmenu:draw()
	local img = requireImage'worldmap.png'
	local dx,dy = img:getWidth()/2-screen.halfwidth,img:getHeight()/2-screen.halfheight
--	local s = math.min(img:getWidth()/screen.width,img:getHeight()/screen.height)
	love.graphics.setColor(210, 152, 65, 100*self.mapopacity)
	love.graphics.draw(img,-dx+self.focus.x,-dy+self.focus.y,0,self.mapscale,self.mapscale,self.focus.x,self.focus.y)
--	love.graphics.set
end

function mainmenu:keypressed(k)
	if k=='c' then
		coroutine.resume(coroutine.create(function ()self:dismiss()end))
	elseif k=='m' then
		self:zoomin(500,200,10)
	elseif k=='n' then
		self:zoomout(500,200,10)
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
		loveframes.anim:easy(t,'vibrate_ref',0,10,1,loveframes.style.linear)
	end
	local t = self.base
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',0,10,1,loveframes.style.linear)
	wait(1)
	
	for i,t in ipairs(self.text) do
		t:Remove()
	end
	self.base:Remove()
end

function mainmenu:zoomin(x,y,t)
	self.focus = Vector(x,y)
	loveframes.anim:easy(self,'mapscale',1,10,t)
	loveframes.anim:easy(self,'mapopacity',1,0,t)
end

function mainmenu:zoomout(x,y,t)
	self.focus = Vector(x,y)
	loveframes.anim:easy(self,'mapscale',10,1,t)
	loveframes.anim:easy(self,'mapopacity',0,1,t)
end

mainmenu:load()

return mainmenu