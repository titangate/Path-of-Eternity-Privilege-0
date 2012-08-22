
local background = require 'gamesystem.chembg'
local intro = {}
local sound = require 'library.sound'
require 'gameobject.camera'
function intro:load()
	-- music
	------------------------------------
	-- button example
	------------------------------------
	--loveframes.anim:easy(background,'z',0,-10,100)
	--self:contract()
	execute(function()
		wait(8)
		self:lli()
		self:compass()
		self:contract()
		self:news()
	end)
	execute(function()
		wait(5)
		local conversation = require 'gamesystem.conversation'
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'LIFE IS A PRIVILEGE. TOO MANY PEOPLE TOOK IT FOR GRANTED.','sound/conversation/lifeisaprivilege.ogg')
		wait(4)
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'I DO NOT HAVE SUCH LUXURY TO SPARE.','sound/conversation/luxury.ogg')
		wait(3)
		conversation.playConversation(LocalizedString'DOCTOR',LocalizedString'THE RESULT OF THE DIAGNOSIS HAS COME OUT.. ITS BAD NEWS.',nil,5)
		wait(2)
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'TORMENTED BY MY DISEASE, I HAVE LONG THIRST FOR A REASON TO LIVE FOR.','sound/conversation/reason.ogg')
		wait(2)
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'JUST TELL ME DOC, HOW MUCH TIME DO I HAVE LEFT?','sound/conversation/time_chinese.ogg')

		conversation.playConversation(LocalizedString'DOCTOR',LocalizedString'WE DO HAVE TREATMENT. BUT IT WILL COST YOU CLOSE TO FOUR MILLION DOLLARS A YEAR.',nil,5)
		wait(3)
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'THIS IS MY ONLY WAY OUT.','sound/conversation/wayout.ogg')
		wait(5)
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'IN SOME SENSE, I TAKE UNWORTHY PEOPLES LIFE TO EXTEND MY OWN.','sound/conversation/unworthy.ogg')
		conversation.playConversation(LocalizedString'RIVER',LocalizedString'BUT I KNOW ONE DAY, I WILL HAVE TO PAY MY DEBT.','sound/conversation/debt.ogg')
		self.OnFinish()
	end)
end

function intro:lli()
	local f = loveframes.Create'frame'
	f:setSize(1024,600)
	local title = loveframes.Create('text',f)
	title:SetFont(font.bigfont)
	title:setText(LocalizedString'LOW LATENCY INHIBITION')
	title:CenterX()
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
	local t2 = loveframes.Create('text',f)
	t2:SetFont(font.bigfont)
	t2:setText{color,LocalizedString'LOW LATENCY INHIBITION - E'}
	t2:setPos(title.staticx,title.staticy)
	loveframes.anim:easy(color,4,0,255,1)
	local sound = require 'library.sound'
	sound.play("sound/interface/drum3.ogg","interface")
	wait(3)

	local t = loveframes.Create('text',f)
	t:SetY(300)
	t:setText{{255,0,0},LocalizedString'AN EXTREMELY RARE AND DEADLY VARIATION OF THIS DISEASE. UNCONTROLLABLE STREAM PRESSURES BRAIN CELLS, '}
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
	loveframes.anim:easy(contract,'staticy',screen.height,0,4)
	wait(7)
	contract:setImage("asset/interface/compasscontract_zoom.png")
	contract:setPos(0,0)
	contract:setWidth(screen.width)

	local sound = require 'library.sound'
	sound.play("sound/interface/drum3.ogg","interface")
	wait(3)

	contract:setImage("asset/interface/compasscontract_signed.png")
	wait(3)
	contract:Remove()
end

function intro:compass()
	local color = {255,255,255}
	local f = loveframes.Create'frame'
	f:setSize(1024,600)
	local t = loveframes.Create('text',f)
	t:SetFont(font.bigfont)
	t:setText{color,LocalizedString'COMPASS'}
	t:CenterX()
	--t.h = 80
	f.filter = filters.vibrate
	loveframes.anim:easy(f,'vibrate_ref',3,0,1,loveframes.style.linear)

	
	f:ShowCloseButton(false)
	f:Center()
	f.Draw = function()end
	local compass = loveframes.Create('compass',f)
	compass:setSize(256,256)
	compass:CenterX()


	--f:setPos(screen.halfwidth-f:getWidth()/2,screen.halfheight-f:getHeight()/2)
	wait(5)
	f.filter = nil
	local info = {
		--function()return LocalizedString'DATE: JUL 11, 2012' end,
		LocalizedString'PROBABLY THE MOST NOTORIOUS CRIME ORGANIZATION EXISITING.',
		LocalizedString'JUST FINISH YOUR BARGAIN, AND THEY WILL SEND AN AGENT TO TAKE CARE OF THINGS.',
		LocalizedString'YOU WILL ASSUME FBI, CIA WILL DO ANYTHING ABOUT IT BUT THEY WILL NOT.',
	}

	local text = {}
	for i,v in ipairs(info) do
		local t = loveframes.Create('text',f)
		t:SetY(240+i*40)
		t:setText(v)
		table.insert(text,t)
		t.filter = filters.vibrate
		loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
		wait(1)
		t.filter = nil
	end
	wait(3)
	loveframes.anim:easy(color,2,255,0,1)
	loveframes.anim:easy(color,3,255,0,1)
	local sound = require 'library.sound'
	sound.play("sound/interface/drum3.ogg","interface")
	wait(3)

	local t = loveframes.Create('text',f)
	t:SetY(400)
	t:setText{{255,0,0},LocalizedString"THEY ARE PROBABLY COMPASS'S MOST VALUABLE CUSTOMER."}
	table.insert(text,t)
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',3,0,1,loveframes.style.linear)
	wait(1)
	t.filter = nil
	wait(5)

	f:dismiss()

end

function intro:news()
	for i=1,5 do
		background:spawnImage(string.format('asset/newspaper/news%d.png',i))
		wait(1)
	end
end

function intro:update(dt)
	background:update(dt)
end
function intro:draw()
	background:draw()
end

function intro:keypressed(k)
	if k=='escape' then
		local waits = require 'library.trigger'
		waits.reset()
		loveframes.base = base:new()
		self.OnFinish()
	end
end
function intro:keyreleased(k)
end

function intro:mousepressed()
end
function intro:mousereleased()
end

return intro