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
	collapsiblecategory1:SetText("RESUME GAME")
	collapsiblecategory1:SetDescription'RESTART FROM LAST CHECKPOINT'
	
	local collapsiblecategory2 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory2:SetPos(5, 60)
	collapsiblecategory2:SetSize(490, 265)
	collapsiblecategory2:SetText("START GAME")
	collapsiblecategory2:SetDescription'START HOSPTIAL GAMEPLAY DEMO'
	local collapsiblecategory3 = loveframes.Create("menubutton", exampleslist)
	collapsiblecategory3:SetPos(5, 60)
	collapsiblecategory3:SetSize(490, 265)
	collapsiblecategory3:SetText("QUIT GAME")
	collapsiblecategory3:SetDescription'EXIT TO OPERATION SYSTEM'
	
	function exampleslist:Draw()
	end
	
	self.base = exampleslist
	assert(self.base)
	
	self.text = {}
	
	local info = {
		function()return 'DATE: JUL 11, 2012' end,
		'NAME: LILY ROSEMARIE HAMILTON',
		'GENDER: FEMALE',
		'DATE OF BIRTH: DEC/16/1993',
		'RACE: CAUCASIAN',
		'HEIGHT: 1.60 M',
		'STATUS: COMA',
		function()return string.format('BLOOD PRESSURE: %d/%d mmHg',math.random(88,96),math.random(59,66)) end,
		function()return 'HEARTRATE: '..tostring(math.random(75,85)) end,
		function()return 'HOSPITALIZED IN SINCE: JUL 1, 2012' end,
	}
	
	local function createlabel(text)
		if type(text)=='function' then
			text = text()
		end
		local t = loveframes.Create'text'
		t:SetFont(font.imagebuttonfont)
		t:SetPos(100,screen.halfheight+200)
		loveframes.anim:easy(t,'y',screen.halfheight+200,screen.halfheight-150,10)

		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',10,0,1,loveframes.style.linear)
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
				loveframes.anim:easy(t,'vibrate_ref',0,10,1,loveframes.style.linear)
			end
		end
		
	end)))
	
end
function mainmenu:update(dt)
	assert(self.base)
end


function mainmenu:draw()
	local img = requireImage'worldmap.png'
	love.graphics.setColor(210, 152, 65, 100)
	love.graphics.draw(img,screen.halfwidth,screen.halfheight,0,0.8,0.8,img:getWidth()/2,img:getHeight()/2)
--	love.graphics.set
end

function mainmenu:keypressed(k)
	if k=='c' then
		self.base:Remove()
		print 'removal'
	end
end

function mainmenu:keyreleased(k)
end

function mainmenu:mousepressed()
end
	function mainmenu:mousereleased()
	end


mainmenu:load()

return mainmenu