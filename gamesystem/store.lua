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
	l.text:SetFont(font.smallfont)
	l:SetDisplayType'horizontal'
	return l
end
function store:load()
	local frame1 = loveframes.Create("frame")
	frame1:setName(LocalizedString"STORE")
	frame1:setSize(1024, 650)
	frame1:Center()
	
	local tabs1 = loveframes.Create("tabs", frame1)
	tabs1:setPos(5, 30)
	tabs1:setSize(1010, 650)
	
	self.tabs1 = tabs1

	self:loadsynrige()
end

function store:loadsynrige()
		local syringe = loveframes.Create"panel"
	function syringe.Draw(object) 
		love.graphics.draw(requireImage'asset/interface/storebg.png',object:GetPos())
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
	synrigetext1:SetWidth(800)
	synrigetext1:SetY(100)
	synrigetext1:SetX(1000-800)

	local synrigelist = loveframes.Create('list',syringe)
	synrigelist.name = ''
	synrigelist:setSize(300,400)
	synrigelist:setPos(15,200)
	synrigelist:AddItem(horzBar(synrigelist,requireImage'item/Tetrodotoxin.png','TETRODOTOXIN\n THIS IS \n LEVEL: III\n test',200,64))
	
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
	synrigelist2:AddItem(horzBar(synrigelist2,requireImage'item/Tetrodotoxin.png','A RANDOM UPGRADE\n THIS IS SPARTA \n I LIKE SPONGEBOB\n $30,000',650,64))
	synrigelist2.Draw = synrigelist.Draw

	local medicinetext1 = loveframes.Create('text',syringe)
	medicinetext1:setText{{210,152,65},LocalizedString'TETRODOTOXIN'}
	medicinetext1:SetFont(font.imagebuttonfont)
	medicinetext1:setPos(600,170)

	local medicinetext2 = loveframes.Create('text',syringe)
	medicinetext2:setText{LocalizedString"Tetrodotoxin blocks action potentials in nerves by binding to the voltage-gated, fast sodium channels in nerve cell membranes, essentially preventing any affected nerve cells from firing by blocking the channels used in the process.\n USE IT ON ENEMY TO CAUSE THEIR IMMEDIATE DEATH."}
	medicinetext2:SetFont(font.smallfont)
	medicinetext2:setPos(600,200)
	medicinetext2:SetWidth(380)

	self.tabs1:AddTab(LocalizedString'SYRINGE',syringe)
end

return store