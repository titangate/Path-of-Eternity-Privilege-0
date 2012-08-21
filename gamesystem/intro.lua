ImageUnit = Object:subclass'ImageUnit'
function ImageUnit:initialize(image,x,y)
	self.image = image
	self.x,self.y = x,y
end

function ImageUnit:getWidth()
	return self.image:getWidth()
end

function ImageUnit:getHeight()
	return self.image:getHeight()
end

function ImageUnit:getX()
	return self.x
end

function ImageUnit:getY()
	return self.y
end

local background = {}
function background:load()
	self.c = Camera(0,0,0)
	self.z = 0
	self.images = {}

	
end

function background:draw()
	local gaussianblur = filters.gaussianblur
	if gaussianblur then
	for i,image in ipairs(self.images) do
		self.c.z = 3-3/10*i+self.z
		image.gaussianblur_intensity = math.max(0,math.abs(self.c.z-2)-0.1)
		filters.gaussianblur.conf(image)
		filters.gaussianblur.predraw(image)
		gra.draw(image.image,image.x,image.y)
		gra.pop()
		gra.push()
		
		self.c:draw()
		gra.setCanvas(gaussianblur.prevc)
		gra.setPixelEffect(gaussianblur.horz)
		gra.setColor(255,255,255)
	gra.setColor(210, 152, 65)
		gra.draw(image.c.canvas,image.x,image.y)
		canvasmanager.releaseCanvas(image.c)
		gra.setPixelEffect()
		image.c = nil
		gra.pop()
	end
else
end
	--camerap.zNear,camerap.zFar = shift + 1,shift+3
end

local chem = love.filesystem.enumerate'asset/chemical/'
local chems = {}
for i,v in ipairs(chem) do
	if string.sub(v,#v-3)=='.png' then
		table.insert(chems,'asset/chemical/'..v)
	end
end
function background:update(dt)
	self.z = self.z + dt
	if self.z > 0.3 then
		local randomimage = chems[math.random(#chems)]
		table.remove(self.images,1)
		table.insert(self.images,ImageUnit(requireImage(randomimage),math.random(screen.width),math.random(screen.height)))
		if #self.images<15 then
			table.insert(self.images,ImageUnit(requireImage(randomimage),math.random(screen.width),math.random(screen.height)))
		end
		self.z = self.z - 0.3
	end
end

local intro = {}
local sound = require 'library.sound'
require 'gameobject.camera'
function intro:load()
	-- music
	------------------------------------
	-- button example
	------------------------------------
	background:load()
	--loveframes.anim:easy(background,'z',0,-10,100)
	--self:contract()
	execute(function()self:lli()end)
end

function intro:lli()
	local f = loveframes.Create'frame'
	f:setSize(1024,600)
	local t = loveframes.Create('text',f)
	t:SetFont(font.bigfont)
	t:setText(LocalizedString'LOW LATENCY INHIBITION')
	--t.h = 80
	f.filter = filters.vibrate
	loveframes.anim:easy(f,'vibrate_ref',3,0,1,loveframes.style.linear)

	f:ShowCloseButton(false)
	f:Center()
	f.Draw = function()end
	--f:setPos(screen.halfwidth-f:getWidth()/2,screen.halfheight-f:getHeight()/2)
	wait(1)
	f.filter = nil
	local info = {
		--function()return LocalizedString'DATE: JUL 11, 2012' end,
		LocalizedString'MOST PEOPLE ARE ABLE TO IGNORE THE CONSTANT STREAM OF INCOMING STIMULI,',
		LocalizedString'BUT THIS CAPABILITY IS REDUCED IN THOSE WITH LOW LATENT INHIBITION. ',
		LocalizedString'THOSE OF ABOVE AVERAGE INTELLIGENCE ARE THOUGHT TO BE CAPABLE OF PROCESSING THIS STREAM EFFECTIVELY,',
		LocalizedString'ENABLING THEIR CREATIVITY AND INCREASING THEIR AWARENESS OF THEIR SURROUNDINGS.',
		LocalizedString'REGARDLESS, THIS DISEASE BRINGS IMMENSE PAIN UPON ITS HOST.',
	}

	local text = {}
	for i,v in ipairs(info) do
		local t = loveframes.Create('text',f)
		t:SetY(50+i*40)
		t:setText(v)
		table.insert(text,t)
		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
		wait(1)
		t.filter = nil
	end
	wait(5)


	local color = {255,0,0,0}
	local t = loveframes.Create('text',f)
	t:SetFont(font.bigfont)
	t:setText{color,LocalizedString'LOW LATENCY INHIBITION - E'}
	
	loveframes.anim:easy(color,4,0,255,1)
	local sound = require 'library.sound'
	sound.play("sound/interface/drum3.ogg","interface")
	wait(3)

	local t = loveframes.Create('text',f)
	t:SetY(300)
	t:setText{{255,0,0},LocalizedString'AN EXTREMELY RARE AND DEADLY VARIATION OF THIS DISEASE. UNCONTROLLABLE STREAM CONTINUOUSLY PRESSURES BRAIN CELLS, '}
	table.insert(text,t)
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
	wait(1)
	t.filter = nil

	local t = loveframes.Create('text',f)
	t:SetY(340)
	t:setText{{255,0,0},LocalizedString'LIKELY TO INDUCE BRAIN INTERNAL BLEEDING AND ULTIMATELY ORGAN FAILURES.'}
	table.insert(text,t)
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
	wait(1)
	t.filter = nil

	wait(5)
	f:dismiss()
end

function intro:contract()
	local contract = loveframes.Create('image')
	contract:setImage"asset/interface/compasscontract.png"
	contract:transmitEffect(true)
	
	contract.staticx = (screen.halfwidth-contract:getWidth()/2)
	loveframes.anim:easy(contract,'staticy',screen.height,0,15)
end

function intro:compass()
end

function intro:update(dt)
	background:update(dt)
end
function intro:draw()
	background:draw()
end

function intro:keypressed(k)
end
function intro:keyreleased(k)
end

function intro:mousepressed()
end
function intro:mousereleased()
end

return intro