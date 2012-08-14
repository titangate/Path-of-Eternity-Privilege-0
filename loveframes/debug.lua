--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

loveframes.debug = {}

local font = gra.newFont(10)
local loremipsum = 
[[
Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Proin dui enim, porta eget facilisis quis, laoreet sit amet urna. 
Maecenas lobortis venenatis euismod. 
Sed at diam sit amet odio feugiat pretium nec quis libero. 
Quisque auctor semper imperdiet. 
Maecenas risus eros, varius pharetra volutpat in, fermentum scelerisque lacus. 
Proin lectus erat, luctus non facilisis vel, hendrerit vitae nisl. 
Aliquam vulputate scelerisque odio id faucibus. 
]]

function loveframes.debug.draw()

	-- get the current debug setting
	local debug = loveframes.config["DEBUG"]
	
	-- do not draw anthing if debug is off
	if debug == false then
		return
	end
	
	local cols = loveframes.util.GetCollisions()
	local numcols = #cols
	local topcol = cols[numcols] or {type = none, children = {}, x = 0, y = 0, width = 0, height = 0}
	local bchildren = #loveframes.base.children
	local objects = loveframes.util.GetAllObjects()
	
	-- font for debug text
	sfn(font)
	
	gra.setColor(0, 0, 0, 150)
	gra.rectangle("fill", 5, 5, 200, 250)
	
	gra.setColor(0, 0, 0, 50)
	gra.rectangle("fill", 10, 10, 190, 20)
	gra.setColor(255, 0, 0, 255)
	pn("Library Information", 15, 15)
	
	gra.setColor(255, 255, 255, 255)
	pn("Author: " ..loveframes.info.author, 15, 30)
	pn("Version: " ..loveframes.info.version, 15, 40)
	pn("Stage: " ..loveframes.info.stage, 15, 50)
	pn("Base Directory: " ..loveframes.config["DIRECTORY"], 15, 60)
	
	-- object information box
	gra.setColor(0, 0, 0, 50)
	gra.rectangle("fill", 10, 80, 190, 20)
	gra.setColor(255, 0, 0, 255)
	pn("Object Information", 15, 85)
	
	gra.setColor(255, 255, 255, 255)
	
	if numcols > 0 then
		pn("Type: " ..topcol.type, 15, 100)
	else
		pn("Type: none", 10, 100)
	end
	
	if topcol.children then
		pn("# of children: " .. #topcol.children, 15, 110)
	else
		pn("# of children: 0", 15, 110)
	end
	
	pn("X: " ..topcol.x, 15, 120)
	pn("Y: " ..topcol.y, 15, 130)
	pn("Width: " ..topcol.width, 15, 140)
	pn("Height: " ..topcol.height, 15, 150)
	
	-- Miscellaneous box
	gra.setColor(0, 0, 0, 50)
	gra.rectangle("fill", 10, 190, 190, 20)
	gra.setColor(255, 0, 0, 255)
	pn("Miscellaneous", 15, 195)
	
	gra.setColor(255, 255, 255, 255)
	
	pn("LOVE Version: " ..love._version, 15, 210)
	pn("FPS: " ..love.timer.getFPS(), 15, 220)
	pn("Delta Time: " ..love.timer.getDelta(), 15, 230)
	pn("Total Objects: " ..#objects, 15, 240)
	
	-- outline the object that the mouse is hovering over
	gra.setColor(255, 204, 51, 255)
	gra.setLine(2, "smooth")
	gra.rectangle("line", topcol.x - 1, topcol.y - 1, topcol.width + 2, topcol.height + 2)

end

function loveframes.debug.ExamplesMenu()

	------------------------------------
	-- examples frame
	------------------------------------
	local examplesframe = loveframes.Create("frame")
	examplesframe:setName("Examples List")
	examplesframe:setSize(200, screen.height - 330)
	examplesframe:setPos(5, 325)
	
	------------------------------------
	-- examples list
	------------------------------------
	local exampleslist = loveframes.Create("list", examplesframe)
	exampleslist:setSize(200, exampleslist:GetParent():getHeight() - 25)
	exampleslist:setPos(0, 25)
	exampleslist:SetPadding(5)
	exampleslist:SetSpacing(5)
	exampleslist:SetDisplayType("vertical")
	
	------------------------------------
	-- button example
	------------------------------------
	local buttonexample = loveframes.Create("button")
	buttonexample:setText("Button")
	buttonexample.OnClick = function(object1, x, y)
		local frame1 = loveframes.Create("frame")
		frame1:setName("Button")
		frame1:Center()
		
		local button1 = loveframes.Create("button", frame1)
		button1:SetWidth(200)
		button1:setText("Button")
		button1:Center()
		
		button1.OnClick = function(object2, x, y)
			object2:setText("You clicked the button!")
		end
		button1.OnMouseEnter = function(object2)
			object2:setText("The mouse entered the button.")
		end
		button1.OnMouseExit = function(object2)
			object2:setText("The mouse exited the button.")
		end
		
	end
	exampleslist:AddItem(buttonexample)
	
	------------------------------------
	-- checkbox example
	------------------------------------
	local checkboxexample = loveframes.Create("button")
	checkboxexample:setText("Checkbox")
	checkboxexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Checkbox")
		frame1:Center()
		frame1:SetHeight(85)
		
		local checkbox1 = loveframes.Create("checkbox", frame1)
		checkbox1:setText({{255,255,255},"Checkbox 1"})
		checkbox1:setPos(5, 30)
		checkbox1.OnChanged = function(object2)
		end
		
		local checkbox2 = loveframes.Create("checkbox", frame1)
		checkbox2:setText({{255,255,255},"Checkbox 2"})
		checkbox2:setPos(5, 60)
		checkbox2.OnChanged = function(object3)
		end
		
	end
	exampleslist:AddItem(checkboxexample)
	
	------------------------------------
	-- collapsible category example
	------------------------------------
	local collapsiblecategoryexample = loveframes.Create("button")
	collapsiblecategoryexample:setText("Collapsible Category")
	collapsiblecategoryexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Collapsible Category")
		frame1:setSize(500, 300)
		frame1:Center()
		
		local exampleslist = loveframes.Create("list", frame1)
		exampleslist:setSize(200, exampleslist:GetParent():getHeight() - 25)
		exampleslist:setPos(0, 25)
		exampleslist:SetPadding(5)
		exampleslist:SetSpacing(5)
		exampleslist:SetDisplayType("vertical")
		
		local panel1 = loveframes.Create("text")
		panel1:setText'haha'
		panel1:SetHeight(230)
			
		local collapsiblecategory1 = loveframes.Create("collapsiblecategory", exampleslist)
		collapsiblecategory1:setPos(5, 30)
		collapsiblecategory1:setSize(490, 265)
		collapsiblecategory1:setText("Category 1")
		collapsiblecategory1:SetObject(panel1)
		
		
		local panel2 = loveframes.Create("button")
		panel2:setText'ha'
		
		local collapsiblecategory2 = loveframes.Create("collapsiblecategory", exampleslist)
		collapsiblecategory2:setPos(5, 60)
		collapsiblecategory2:setSize(490, 265)
		collapsiblecategory2:setText("Category 2")
		collapsiblecategory2:SetObject(panel2)
		
		
		frame1.filter = filters.vibrate
		loveframes.anim:easy(frame1,'vibrate_ref',10,0,0.3,loveframes.style.linear)
		wait(0.3)
		frame1.filter = nil
		
	end
	exampleslist:AddItem(collapsiblecategoryexample)
	
	local menubuttonexample = loveframes.Create("button")
	menubuttonexample:setText("Menu Button")
	menubuttonexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Menu Button")
		frame1:setSize(500, 300)
		frame1:Center()
		
		local exampleslist = loveframes.Create("list", frame1)
		exampleslist:setSize(450, exampleslist:GetParent():getHeight() - 25)
		exampleslist:setPos(0, 25)
		exampleslist:SetPadding(5)
		exampleslist:SetSpacing(0)
		exampleslist:SetDisplayType("vertical")
		
		local collapsiblecategory1 = loveframes.Create("menubutton", exampleslist)
		collapsiblecategory1:setPos(5, 30)
		collapsiblecategory1:setSize(490, 265)
		collapsiblecategory1:setText("RESUME GAME")
		collapsiblecategory1:SetDescription'RESTART FROM LAST CHECKPOINT'
		
		local collapsiblecategory2 = loveframes.Create("menubutton", exampleslist)
		collapsiblecategory2:setPos(5, 60)
		collapsiblecategory2:setSize(490, 265)
		collapsiblecategory2:setText("START GAME")
		collapsiblecategory2:SetDescription'START HOSPTIAL GAMEPLAY DEMO'
		local collapsiblecategory3 = loveframes.Create("menubutton", exampleslist)
		collapsiblecategory3:setPos(5, 60)
		collapsiblecategory3:setSize(490, 265)
		collapsiblecategory3:setText("QUIT GAME")
		collapsiblecategory3:SetDescription'EXIT TO OPERATION SYSTEM'
		
		function exampleslist:Draw()
		end
		
	end
	exampleslist:AddItem(menubuttonexample)
	------------------------------------
	-- cloumnlist example
	------------------------------------
	local cloumnlistexample = loveframes.Create("button")
	cloumnlistexample:setText("Column List")
	cloumnlistexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Column List")
		frame1:setSize(500, 300)
		frame1:Center()
		
		local list1 = loveframes.Create("columnlist", frame1)
		list1:setPos(5, 30)
		list1:setSize(490, 265)
		list1:AddColumn("Column 1")
		list1:AddColumn("Column 2")
		list1:AddColumn("Column 3")
		list1:AddColumn("Column 4")
		
		for i=1, 20 do
			list1:AddRow("Row " ..i.. ", column 1", "Row " ..i.. ", column 2", "Row " ..i.. ", column 3", "Row " ..i.. ", column 4")
		end
		
	end
	exampleslist:AddItem(cloumnlistexample)
	
	------------------------------------
	-- frame example
	------------------------------------
	local frameexample = loveframes.Create("button")
	frameexample:setText("Frame")
	frameexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Frame")
		frame1:Center()
		
		local text1 = loveframes.Create("text", frame1)
		text1:setText("This is an example frame.")
		text1.Update = function(object2, dt)
			object2:CenterX()
			object2:SetY(40)
		end
		
		local button1 = loveframes.Create("button", frame1)
		button1:setText("Modal")
		button1:SetWidth(100)
		button1:Center()
		button1.Update = function(object2, dt)
			local modal = object2:GetParent():GetModal()
			
			if modal == true then
				object2:setText("Remove Modal")
				object2.OnClick = function()
					object2:GetParent():SetModal(false)
				end
			else
				object2:setText("Set Modal")
				object2.OnClick = function()
					object2:GetParent():SetModal(true)
				end
			end
		end
	end
	exampleslist:AddItem(frameexample)
	
	------------------------------------
	-- image example
	------------------------------------
	local imageexample = loveframes.Create("button")
	imageexample:setText("Image")
	imageexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Image")
		frame1:setSize(138, 163)
		frame1:Center()
		
		local image1 = loveframes.Create("image", frame1)
		image1:setImage("resources/images/carlsagan.png")
		image1:setPos(5, 30)
		
	end
	exampleslist:AddItem(imageexample)
	
	------------------------------------
	-- image button example
	------------------------------------
	local imagebuttonexample = loveframes.Create("button")
	imagebuttonexample:setText("Image Button")
	imagebuttonexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Image Button")
		frame1:setSize(138, 163)
		frame1:Center()
		
		local imagebutton1 = loveframes.Create("imagebutton", frame1)
		imagebutton1:setImage("resources/images/carlsagan.png")
		imagebutton1:setPos(5, 30)
		imagebutton1:SizeToImage()
		
		frame1.filter = filters.vibrate
		loveframes.anim:easy(frame1,'vibrate_ref',10,0,0.3,loveframes.style.linear)
		wait(0.3)
		frame1.filter = nil
	end
	exampleslist:AddItem(imagebuttonexample)
	
	------------------------------------
	-- list example
	------------------------------------
	local listexample = loveframes.Create("button")
	listexample:setText("List")
	listexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("List")
		frame1:setSize(500, 455)
		frame1:Center()
		
		local list1 = loveframes.Create("list", frame1)
		list1:setPos(5, 30)
		list1:setSize(490, 300)
		
		local panel1 = loveframes.Create("panel", frame1)
		panel1:setPos(5, 335)
		panel1:setSize(490, 115)
		
		local slider1 = loveframes.Create("slider", panel1)
		slider1:setPos(5, 20)
		slider1:SetWidth(480)
		slider1:SetMinMax(0, 100)
		slider1:setText("Padding")
		slider1:SetDecimals(0)
		slider1.OnValueChanged = function(object2, value)
			list1:SetPadding(value)
		end
		
		local text1 = loveframes.Create("text", panel1)
		text1:setPos(5, 5)
		text1:SetFont(gra.newFont(10))
		text1:setText(slider1:GetText())
		
		local text2 = loveframes.Create("text", panel1)
		text2:SetFont(gra.newFont(10))
		text2.Update = function(object, dt)
			object:setPos(slider1:getWidth() - object:getWidth(), 5)
			object:setText(slider1:GetValue())
		end
		
		local slider2 = loveframes.Create("slider", panel1)
		slider2:setPos(5, 60)
		slider2:SetWidth(480)
		slider2:SetMinMax(0, 100)
		slider2:setText("Spacing")
		slider2:SetDecimals(0)
		slider2.OnValueChanged = function(object2, value)
			list1:SetSpacing(value)
		end
		
		local text3 = loveframes.Create("text", panel1)
		text3:setPos(5, 45)
		text3:SetFont(gra.newFont(10))
		text3:setText(slider2:GetText())
		
		local text4 = loveframes.Create("text", panel1)
		text4:SetFont(gra.newFont(10))
		text4.Update = function(object, dt)
			object:setPos(slider2:getWidth() - object:getWidth(), 45)
			object:setText(slider2:GetValue())
		end
		
		local button1 = loveframes.Create("button", panel1)
		button1:setPos(5, 85)
		button1:setSize(480, 25)
		button1:setText("Change List Type")
		button1.OnClick = function(object2, x, y)
			if list1:GetDisplayType() == "vertical" then
				list1:SetDisplayType("horizontal")
			else
				list1:SetDisplayType("vertical")
			end
		end
		
		for i=1, 50 do
			local button2 = loveframes.Create("button")
			button2:setText(i)
			list1:AddItem(button2)
		end
		
	end
	exampleslist:AddItem(listexample)
	
	------------------------------------
	-- multichoice example
	------------------------------------
	local multichoiceexample = loveframes.Create("button")
	multichoiceexample:setText("Multichoice")
	multichoiceexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Multichoice")
		frame1:setSize(210, 60)
		frame1:Center()
		
		local multichoice1 = loveframes.Create("multichoice", frame1)
		multichoice1:setPos(5, 30)
		
		for i=1, 20 do
			multichoice1:AddChoice(i)
		end
		
	end
	exampleslist:AddItem(multichoiceexample)
	
	------------------------------------
	-- panel example
	------------------------------------
	local panelexample = loveframes.Create("button")
	panelexample:setText("Panel")
	panelexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Panel")
		frame1:setSize(210, 85)
		frame1:Center()
		
		local panel1 = loveframes.Create("panel", frame1)
		panel1:setPos(5, 30)
		
	end
	exampleslist:AddItem(panelexample)
	
	------------------------------------
	-- progressbar example
	------------------------------------
	local progressbarexample = loveframes.Create("button")
	progressbarexample:setText("Progress Bar")
	progressbarexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Progress Bar")
		frame1:setSize(500, 160)
		frame1:Center()
		
		local progressbar1 = loveframes.Create("progressbar", frame1)
		progressbar1:setPos(5, 30)
		progressbar1:SetWidth(490)
		progressbar1:SetLerpRate(1)
		
		local button1 = loveframes.Create("button", frame1)
		button1:setPos(5, 60)
		button1:SetWidth(490)
		button1:setText("Change bar value")
		button1.OnClick = function(object2, x, y)
			progressbar1:SetValue(math.random(progressbar1:GetMin(), progressbar1:GetMax()))
		end
		
		local button2 = loveframes.Create("button", frame1)
		button2:setPos(5, 90)
		button2:SetWidth(490)
		button2:setText("Toggle bar lerp")
		button2.OnClick = function(object2, x, y)
			if progressbar1:GetLerp() == true then
				progressbar1:SetLerp(false)
			else
				progressbar1:SetLerp(true)
			end
		end
		
		local slider1 = loveframes.Create("slider", frame1)
		slider1:setPos(5, 135)
		slider1:SetWidth(490)
		slider1:setText("Progressbar lerp rate")
		slider1:SetMinMax(1, 50)
		slider1:SetDecimals(0)
		slider1.OnValueChanged = function(object2, value)
			progressbar1:SetLerpRate(value)
		end
		
		local text1 = loveframes.Create("text", frame1)
		text1:setPos(5, 120)
		text1:setText({{255,255,255},"Lerp Rate"})
		
		local text2 = loveframes.Create("text", frame1)
		text2.Update = function(object, dt)
			object:setPos(slider1:getWidth() - object:getWidth(), 120)
			object:setText(slider1:GetValue())
		end
		
	end
	exampleslist:AddItem(progressbarexample)
	
	------------------------------------
	-- slider example
	------------------------------------
	local sliderexample = loveframes.Create("button")
	sliderexample:setText("Slider")
	sliderexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Slider")
		frame1:setSize(300, 275)
		frame1:Center()
		
		local slider1 = loveframes.Create("slider", frame1)
		slider1:setPos(5, 30)
		slider1:SetWidth(290)
		slider1:SetMinMax(0, 100)
		
		local slider2 = loveframes.Create("slider", frame1)
		slider2:setPos(5, 60)
		slider2:SetHeight(200)
		slider2:SetMinMax(0, 100)
		slider2:SetButtonSize(20, 10)
		slider2:SetSlideType("vertical")
		slider2.Update = function(object, dt)
			object:CenterX()
		end
		
	end
	exampleslist:AddItem(sliderexample)
	
	------------------------------------
	-- tabs example
	------------------------------------
	local tabsexample = loveframes.Create("button")
	tabsexample:setText("Tabs")
	tabsexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Tabs")
		frame1:setSize(500, 300)
		frame1:Center()
		
		local tabs1 = loveframes.Create("tabs", frame1)
		tabs1:setPos(5, 30)
		tabs1:setSize(490, 265)
		
		local images = {"accept.png", "add.png", "application.png", "building.png", "bin.png", "database.png", "box.png", "brick.png"}
		
		for i=1, 20 do
		
			local panel1 = loveframes.Create("panel")
			panel1.Draw = function()
			end
			
			local text1 = loveframes.Create("text", panel1)
			text1:setText("Tab " ..i)
			tabs1:AddTab("Tab " ..i, panel1, "Tab " ..i, "resources/images/" ..images[math.random(1, #images)])
			text1:SetAlwaysUpdate(true)
			text1.Update = function(object, dt)
				object:Center()
			end
			
		end
		
	end
	exampleslist:AddItem(tabsexample)
	
	------------------------------------
	-- text example
	------------------------------------
	local textexample = loveframes.Create("button")
	textexample:setText("Text")
	textexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Text")
		frame1:setSize(500, 300)
		frame1:Center()
		
		local list1 = loveframes.Create("list", frame1)
		list1:setPos(5, 30)
		list1:setSize(490, 265)
		list1:SetPadding(5)
		list1:SetSpacing(5)
		
		for i=1, 5 do
			local text1 = loveframes.Create("text")
			text1:setText(loremipsum)
			list1:AddItem(text1)
		end
		
	end
	exampleslist:AddItem(textexample)
	
	------------------------------------
	-- text input example
	------------------------------------
	local textinputexample = loveframes.Create("button")
	textinputexample:setText("Text Input")
	textinputexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:setName("Text Input")
		frame1:setSize(500, 60)
		frame1:Center()
		
		local textinput1 = loveframes.Create("textinput", frame1)
		textinput1:setPos(5, 30)
		textinput1:SetWidth(490)
		
	end
	exampleslist:AddItem(textinputexample)
		
end

function loveframes.debug.SkinSelector()

	local skins = loveframes.skins.available
	
	local frame = loveframes.Create("frame")
	frame:setName("Skin Selector")
	frame:setSize(200, 60)
	frame:setPos(5, 260)
	
	local skinslist = loveframes.Create("multichoice", frame)
	skinslist:setPos(5, 30)
	skinslist:SetWidth(190)
	skinslist:SetChoice("Choose a skin")
	skinslist.OnChoiceSelected = function(object, choice)
		loveframes.util.SetActiveSkin(choice)
	end
	
	for k, v in pairs(skins) do
		skinslist:AddChoice(v.name)
	end
	
end