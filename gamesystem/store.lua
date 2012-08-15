local store = {}
local function horzBar(parent,image,text,width,height)
	local l = loveframes.Create('list',parent)
	function l.Draw() end
	l.spacing = 10
	l:setSize(width,height)
	l.button = loveframes.Create('circlebutton',l)
	l.button:setImage(image)
	l.button:setSize(height,height)
	l.button:setText''
	l.text = loveframes.Create('text',l)
	l.text:setText(text)
	l.text:SetWidth(width-height-10)
	l.text:SetFont(font.smallfont)
	l:SetDisplayType'horizontal'
	return l
end
function store:load()
	local frame1 = loveframes.Create("frame")
	frame1:setName(LocalizedString"STORE")
	frame1:setSize(1024, 700)
	frame1:Center()
	
	local tabs1 = loveframes.Create("tabs", frame1)
	tabs1:setPos(5, 30)
	tabs1:setSize(1010, 650)
	
	self.tabs1 = tabs1

	self:loadsynringe()
	self:loadgun()
	frame1:SetModal(true)
end

function store:setInventory(inv)
	self.inv = inv
	self.gunitem = self.inv.items[2][1]
end

function store:loadsynringe()
	local syringe = loveframes.Create"panel"
	function syringe.Draw(object) 
		filters.active.predraw()
		gra.draw(requireImage'asset/interface/storebg.png',object:GetPos())
		filters.active.postdraw()
	end
	syringe:setSize(1010,650)

	local syringebutton = loveframes.Create('circlebutton',syringe)

	syringebutton:setImage'item/needle.png'
	syringebutton:setSize(128,128)
	syringebutton:setPos(30,5)
	syringebutton.active = true
	syringebutton:setText''

	local synrigetext1 = loveframes.Create('text',syringe)
	synrigetext1:setText{{210,152,65},LocalizedString'SYRINGE'}
	synrigetext1:SetFont(font.bigfont)
	synrigetext1:SetY(30)
	synrigetext1:CenterX()
	
	local synrigetext1 = loveframes.Create('text',syringe)
	synrigetext1:setText(LocalizedString"A subtle equipment. River can use it to inject medication directly into his bloodstream to counter the symptoms of his Low Latency Inhibition. Towards his enemy, he can inject nerve poison to knock unwanted personnel out to save trouble. He can also use it to perform the most deadliest form of assassination: by directly injecting poison into the victim's neck, even the toughest guy will lose their heartbeat in a few seconds.")
	synrigetext1:SetFont(font.smallfont)
	synrigetext1:SetWidth(700)
	synrigetext1:SetY(100)
	synrigetext1:SetX(1000-800)

	local synrigelist = loveframes.Create('list',syringe)
	synrigelist.name = ''
	synrigelist:setSize(300,400)
	synrigelist:setPos(15,200)
	synrigelist.spacing = 10
	local b = horzBar(synrigelist,requireImage'item/Tetrodotoxin.png',LocalizedString'TETRODOTOXIN\n THIS IS \n LEVEL: III\n test',200,64)
	b.button.OnClick = function()self:loadsynrige_tetrodotoxin()end
	synrigelist:AddItem(b)
	b = horzBar(synrigelist,requireImage'item/angexetine.png',LocalizedString'ANGEXETINE\n THIS IS \n LEVEL: III\n test',200,64)
	b.button.OnClick = function()self:loadsynrige_angexetine()end
	synrigelist:AddItem(b)
	
	function synrigelist.Draw(object)
		local index	= loveframes.config["ACTIVESKIN"]
		local defaultskin = loveframes.config["DEFAULTSKIN"]
		local selfskin = object.skin
		local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		skin.DrawFrame(object)
	end

	local medicineicon = loveframes.Create('image',syringe)
	medicineicon:setImage'item/Tetrodotoxin.png'
	medicineicon:setPos(360,140)

	local synrigelist2 = loveframes.Create('list',syringe)
	synrigelist2.name = ''
	synrigelist2:setSize(650,280)
	synrigelist2:setPos(340,320)
	synrigelist2.Draw = synrigelist.Draw
	synrigelist2.spacing = 10
	local medicinetext1 = loveframes.Create('text',syringe)
	medicinetext1:setText{{210,152,65},LocalizedString'TETRODOTOXIN'}
	medicinetext1:SetFont(font.imagebuttonfont)
	medicinetext1:setPos(600,170)

	local medicinetext2 = loveframes.Create('text',syringe)
	medicinetext2:setText{LocalizedString"Tetrodotoxin blocks action potentials in nerves by binding to the voltage-gated, fast sodium channels in nerve cell membranes, essentially preventing any affected nerve cells from firing by blocking the channels used in the process.\n USE IT ON ENEMY TO CAUSE THEIR IMMEDIATE DEATH."}
	medicinetext2:SetFont(font.smallfont)
	medicinetext2:setPos(600,200)
	medicinetext2:SetWidth(380)

	self.medicinetext2 = medicinetext2
	self.medicinetext1 = medicinetext1
	self.medicineicon = medicineicon
	self.medicinelist = synrigelist2
	--self.currentmedicine = 'Tetrodotoxin'
	--self.medicinelist:AddItem(horzBar(synrigelist2,requireImage'item/Tetrodotoxin.png','A RANDOM UPGRADE\n THIS IS SPARTA \n I LIKE SPONGEBOB\n $30,000',650,64))

	self.tabs1:AddTab(LocalizedString'SYRINGE',syringe)
	self:loadsynrige_tetrodotoxin(true)
end

function store:loadsynrige_angexetine(instant)
	if self.currentmedicine == 'angexetine' then return end
	self.currentmedicine = 'angexetine'
	local objs = {self.medicinetext1,self.medicinetext2,self.medicineicon,self.medicinelist}
	for i,v in ipairs(objs) do
		v.filter = filters.vibrate
		loveframes.anim:easy(v,'vibrate_ref',0,3,0.3)
	end
	
	if not instant then
		wait(0.3)
	end
	self.medicinelist:Clear()
	for i,v in ipairs(objs) do
		loveframes.anim:easy(v,'vibrate_ref',3,0,0.3)
	end
	self.medicineicon:setImage'item/angexetine_structure.png'
	self.medicinetext1:setText{{210,152,65},LocalizedString'ANGEXETINE'}
	self.medicinetext2:setText(LocalizedString'N/A')
	
	if not instant then
		wait(0.3)
	end
	for i,v in ipairs(objs) do
		v.filter = nil
	end

end

function store:loadsynrige_tetrodotoxin(instant)
	if self.currentmedicine == 'Tetrodotoxin' then return end
	local objs = {self.medicinetext1,self.medicinetext2,self.medicineicon,self.medicinelist}
	for i,v in ipairs(objs) do
		v.filter = filters.vibrate
		loveframes.anim:easy(v,'vibrate_ref',0,3,0.3)
	end
	if not instant then
		wait(0.3)
	end
	self.medicinelist:Clear()
	for i,v in ipairs(objs) do
		loveframes.anim:easy(v,'vibrate_ref',3,0,0.3)
	end
	self.currentmedicine = 'Tetrodotoxin'
	self.medicineicon:setImage'item/Tetrodotoxin.png'
	self.medicinetext1:setText{{210,152,65},LocalizedString'TETRODOTOXIN'}
	self.medicinetext2:setText(LocalizedString"Tetrodotoxin blocks action potentials in nerves by binding to the voltage-gated, fast sodium channels in nerve cell membranes, essentially preventing any affected nerve cells from firing by blocking the channels used in the process.\n USE IT ON ENEMY TO CAUSE THEIR IMMEDIATE DEATH.")

	self.medicinelist:AddItem(horzBar(synrigelist2,requireImage'item/Tetrodotoxin.png','A RANDOM UPGRADE\n THIS IS SPARTA \n I LIKE SPONGEBOB\n $30,000',650,64))
	
	if not instant then
		wait(0.3)
	end
	for i,v in ipairs(objs) do
		v.filter = nil
	end
end

-- gun

function store:loadgun()
	local gun = loveframes.Create"panel"
	function gun.Draw(object)
		filters.active.predraw()
		gra.draw(requireImage'asset/interface/storebg.png',object:GetPos())
		filters.active.postdraw()
	end
	gun:setSize(1010,650)
	local gunImage = loveframes.Create('image',gun)
	gunImage:setImage(self.gunitem:getIcon())
	gunImage:SetY(60)
	self.gunImage = gunImage

	local guntext1 = loveframes.Create('text',gun)
	guntext1:setText{{210,152,65},LocalizedString'M1911 HANDGUN'}
	guntext1:SetFont(font.bigfont)
	guntext1:SetY(30)
	guntext1:CenterX()
	
	local guntext1 = loveframes.Create('text',gun)
	guntext1:setText(LocalizedString"The M1911 is a single-action, semi-automatic, magazine-fed, recoil-operated handgun chambered for the .45 ACP cartridge, which served as the standard-issue side arm for the United States armed forces from 1911 to 1985. It was widely used in World War I, World War II, the Korean War, and the Vietnam War. The M1911 is still carried by some U.S. forces.")
	guntext1:SetFont(font.smallfont)
	guntext1:SetWidth(550)
	guntext1:SetY(100)
	guntext1:SetX(1000-550)

	gun:setSize(1010,650)


	local gunlist = loveframes.Create('list',gun)
	gunlist.name = ''
	gunlist:setSize(300,300)
	gunlist:setPos(15,300)
	gunlist.spacing = 10
	local classlist = {}
	local b,b2
	b = horzBar(gunlist,requireImage'item/1911/silencer.png',LocalizedString'SILENCER\n THIS IS \n LEVEL: III\n test',200,64)
	b.button.OnClick = function()
		b.button.active = true
		b2.button.active = nil
		self:loadgun_silencer()
	end
	gunlist:AddItem(b)
	b2 = horzBar(gunlist,requireImage'item/1911/scope.png',LocalizedString'SCOPE\n THIS IS \n LEVEL: III\n test',200,64)
	b2.button.OnClick = function()
		b.button.active = nil
		b2.button.active = true
	self:loadgun_scope()end
	gunlist:AddItem(b2)

	function gunlist.Draw(object)
		local index	= loveframes.config["ACTIVESKIN"]
		local defaultskin = loveframes.config["DEFAULTSKIN"]
		local selfskin = object.skin
		local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		skin.DrawFrame(object)
	end
	local gunlist2 = loveframes.Create('list',gun)
	gunlist2.name = ''
	gunlist2:setSize(650,280)
	gunlist2:setPos(340,320)
	gunlist2.Draw = gunlist.Draw
	gunlist2.spacing = 10

	self.gunlist = gunlist
	self.gunlist2 = gunlist2

	local guncomptext = loveframes.Create('text',gun)
	guncomptext:setText{{210,152,65},LocalizedString'SILENCER'}
	guncomptext:SetFont(font.imagebuttonfont)
	guncomptext:setPos(500,170)

	self.guncomptext = guncomptext


	local guncomptext2 = loveframes.Create('text',gun)
	guncomptext2:setText{LocalizedString""}
	guncomptext2:SetFont(font.smallfont)
	guncomptext2:setPos(500,200)
	guncomptext2:SetWidth(380)


	self.guncomptext2 = guncomptext2

	self.tabs1:AddTab(LocalizedString'PISTOL',gun)
	self:loadgun_silencer(true)
end


function store:loadgun_silencer(instant)
	if self.currentguncomp == 'silencer' then return end
	local objs = {self.guncomptext,self.guncomptext2,self.gunlist2}
	for i,v in ipairs(objs) do
		v.filter = filters.vibrate
		loveframes.anim:easy(v,'vibrate_ref',0,3,0.3)
	end
	if not instant then
		wait(0.3)
	end
	self.gunlist2:Clear()
	for i,v in ipairs(objs) do
		loveframes.anim:easy(v,'vibrate_ref',3,0,0.3)
	end
	self.currentguncomp = 'silencer'
	self.guncomptext:setText{{210,152,65},LocalizedString'SILENCER'}
	self.guncomptext2:setText(LocalizedString"ENEMY TO CAUSE THEIR IMMEDIATE DEATH.")

	local silencer1 = horzBar(synrigelist2,requireImage'item/1911/silencer.png','SILENCER LEVEL 1\n SUPRESS SOUND \n \n $30,000',650,64)
	local silencer2 = horzBar(synrigelist2,requireImage'item/1911/silencer.png','SILENCER LEVEL 2\n ELIMINATE SOUND \n \n $100,000',650,64)
	self.gunlist2:AddItem(silencer1)
	self.gunlist2:AddItem(silencer2)

	if self.gunitem.silencer >= 1 then
		silencer1.active = true
	end
	if self.gunitem.silencer >= 2 then
		silencer2.active = true
	end

	silencer1.button.OnClick = function()
		if silencer1.button.active then return end
		if self.inv:purchase(30000) then
			silencer1.button.active = true
			self.gunitem:setUpgrade('silencer',1)
			self.gunImage:setImage(self.gunitem:getIcon())
		end
	end
	
	silencer2.button.OnClick = function()
		if silencer2.button.active then return end
		if self.inv:purchase(30000) then
			silencer2.button.active = true
			self.gunitem:setUpgrade('silencer',2)
			self.gunImage:setImage(self.gunitem:getIcon())
		end
	end
	
	if not instant then
		wait(0.3)
	end
	for i,v in ipairs(objs) do
		v.filter = nil
	end
end


return store