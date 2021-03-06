
local sound = require 'library.sound'
local doodad = require 'gameobject.doodad'
local mission = require 'gameobject.mission'
mission.load()

local demogame = {}
global = {}
local modalfunc
local editor =  require 'gamesystem.editor'
function demogame:load()


	self.timescale = 1
	-- Game Init --
	
	m = PathMap(100,100)
	host = AIHost(m)

	global = {
		map = m,
		aihost = host,
	}
	m.aihost = host
	m:setWallbatch(requireImage'asset/terrain/yellowwall.png',{
		width = 64,
		height = 64,
		ox = 32,
		oy = 32,
		lurd = gra.newQuad(0,0,64,64,256,64),
		lr = gra.newQuad(64,0,64,64,256,64),
		lur = gra.newQuad(128,0,64,64,256,64),
		ur = gra.newQuad(192,0,64,64,256,64),
		})
	
	if love.filesystem.isFile'demosave' then

		local save = love.filesystem.read'demosave'
		save = json.decode(save)
		m:load(save)
	end
	if love.filesystem.isFile'aidemo' then
		local s = love.filesystem.read'aidemo'
		s = json.decode(s)
		host:decode(s)
	end
	--host:decode(json.decode(love.filesystem.read'aidemo'))
--	m:addUnit(u)
	m:setBackground'map/hospitalfloor.png'
	c = Crowd(RectangleArea(100,100,1000,600),20)
--	m:addUnit(c)
	--[[

--	
	
	area = CircleArea(300,300,100)
	--host:findPath(Vector(50,50),Vector(100,100))
	
	-- Debugs.
	

	a = Vector(1,1)
	
	
	e = Exposure(u,host,m.world)
	
	doodad:load()
	d = doodad.create('desk2',500,280,0)
	m:addUnit(d)]]

	sel = Selection(m)
	loveframes.anim:easy(self,'scale',0,1,0.5)
	self.scale = 0

	local i = loveframes.Create('frame')

	function i.Draw(object)
		gra.setColor(0,0,0,120)
		gra.rectangle('fill',object.x,object.y,object.width,object.height)
	--	print (object.x/2,object.y,object.width,object.height)
		gra.setColor(255,255,255)
	end
--	i:setName(LocalizedString'LLI INFORMATION')
	i:setSize(300,50)
	i:CenterX()
	i.x = i.x
	i.y=(100)
	i:ShowCloseButton(false)
	i:setName''
	--i:setPos(screen.halfwidth-150,20)
--	i:SetVisible(false)
	self.llipanel = i
	i.description = loveframes.Create('text',i)
	i.description:setPos(5,30)

	self.llipanel:SetVisible(false)

	self.llipanel = i
	i.namefield = loveframes.Create('text',i)
	i.namefield:setPos(5,5)
	i.namefield:SetFont(font.imagebuttonfont)
	sel.onSelect = function(obj)
		if obj==self.lli_object then return end
		self:lliSelect(obj)
		self.llipanel.filter = filters.vibrate
		loveframes.anim:easy(self.llipanel,'vibrate_ref',3,0,0.3,loveframes.style.linear)
		self.llipanel:SetVisible(true)
		if controller then
			controller.sel = obj
		end
		editor:setSelection(obj)
	end

	sel.onDeselect = function()
		if nil==self.lli_object then return end
		self.lli_object = nil
		self.llipanel.namefield:setText''
		self.llipanel.description:setText''
		self.llipanel:SetVisible(false)

		if controller then
			controller.sel = nil
		end
		editor:releaseSelection()
	end

	i = loveframes.Create('frame')

	function i:Draw()
		gra.setColor(0,0,0,120)
		gra.rectangle('fill',i.x,i.y,i.width,i.height)
		gra.setColor(255,255,255)
	end
--	i:setName(LocalizedString'LLI INFORMATION')
	i:setSize(300,50)
	i:CenterX()
	i.y=screen.height - 200
	i:ShowCloseButton(false)
	i:setName''

	i.field = loveframes.Create('text',i)
	i.closetime = 0
	function i.Update(object,dt)
		i.closetime = i.closetime - dt
		if i.closetime <= 0.3 then
			i.filter = filters.vibrate
			i.vibrate_ref = 1-i.closetime/0.3
			if i.closetime <= 0 then
				i:SetVisible(false)
			end
		else
			--i.filter = nil
		end
	end
	i:SetAlwaysUpdate(true)


	self.hintpanel = i


	local item = require 'gameobject.item'
	item:load()
	local inv = Inventory(m.obj.river)
	for i = 1,3 do
		inv:setBaseItem(i,item.create('improvisation',0,0,0))
	end
	inv:setBaseItem(4,item.create('needle',0,0,0))

	inv:addItem(1,item.create('kitchenknife',0,0,0))
	local g = item.create('gun',0,0,0)
	g.world = m.world
	inv:addItem(2,g)

	self.inv = inv
	if m.obj.river then
		m.obj.river.inv = inv
	end

	m.obj.boss.onKill = function(unit,killer)
		self.mission:setTargetInfo('cai','status','DEAD')
		if killer.info and killer.info.method then
			self.mission:setTargetInfo('cai','statusdescription',killer.info.method('Cai Zhong Zheng'))
		else
			self.mission:setTargetInfo('cai','statusdescription','Cai Zhong Zheng is dead.')
		end
		self:hint("TARGET ELIMINATED")
		sound.playMusic('sound/music/secretunvailed.ogg',true)
	end
	sound.playMusic('sound/music/danger.ogg')

	self:loadUI()

	-- mission
	self.mission = mission.create('hospital')
	global.mission = self.mission
end

function demogame:hint(text,clue)
	self.hintpanel.field:setText(text)
	self.hintpanel.filter = filters.vibrate
	loveframes.anim:easy(self.hintpanel,'vibrate_ref',3,0,0.3,loveframes.style.linear)
	self.hintpanel:SetVisible(true)
	self.hintpanel.field:CenterX()
	self.hintpanel.closetime = 5
end

function demogame:lliSelect(obj)
	self.lli_object = obj
	local color = obj.lli_color or {255,255,255}
	color[4] = 255
	if obj.info then
		if  obj.info.description then
			self.llipanel.description:setText({color,obj.info.description})
			self.llipanel.description:CenterX()
		end
		if obj.info.name then
			self.llipanel.namefield:setText({color,obj.info.name})

			self.llipanel.namefield:CenterX()
--			self.llipanel:setName(obj.info.name)
		end
	end
end

function demogame:loadresume()
	loveframes.anim:easy(self,'scale',0,1,0.25)
	self.scale = 0
end

function demogame:dismiss()
	loveframes.anim:easy(self,'scale',1,0,0.5)
	local mm = require'gamesystem.mainmenu'
	wait(0.25)
	mm:loadpause()
	self.host.push(mm,1)
end

function demogame:setCellphoneState(state)
	self.phone = require 'gamesystem.phone'
	if state == self.phonestate then
		return
	end
	if state then
		self.phone:load()
	else
		self.phone:dismiss()
	end
	self.phonestate = state
end

local pause = false

function demogame:update(dt)
	dt = self.timescale * dt
	if not pause then

		host:process(dt)
		m:update(dt)
		sound.setCenter(m.obj.river:getPosition())
	end
	sel:update(dt)
end

function demogame:draw()
	local prev,canvas
	if self.scale ~=1 then
		gra.push()
		gra.translate(screen.halfwidth,screen.halfheight)
		gra.scale(self.scale)
		gra.translate(-screen.halfwidth*self.scale,-self.scale*screen.halfheight)
		canvas = canvasmanager.requireCanvas(screen.width,screen.height)
		canvas.canvas:clear()
		prev = gra.getCanvas()
		gra.setCanvas(canvas.canvas)
	end
	gra.setColor(255,255,255)
	gra.push()
	m:draw()
	gra.pop()

	
	
	if DEBUG and loveframes.config["DEBUG"] then
		m:DebugDraw()
--		u:DebugDraw()
		host:DebugDraw()
	--	e:DebugDraw()
	end
--	d:DebugDraw()
	if self.scale ~=1 then
		gra.pop()
		gra.setColor(255,255,255,255*self.scale)
		gra.setCanvas(prev)
		gra.draw(canvas.canvas)
		canvasmanager.releaseCanvas(canvas)
	end
end

function demogame:playConversation(unit,text,duration)
	local i = loveframes.Create("frame")
	i.description = loveframes.Create('text',i)
	i.description:setPos(5,30)
	i.description:setText(text)
	i.description:setSize(200,10)
	i.namefield = loveframes.Create('text',i)
	i.namefield:setPos(5,5)
	i.namefield:SetFont(font.imagebuttonfont)
	i.namefield:setText(LocalizedString(unit.info.name))
	i:setName''
	local tobedismiss = true
	i:setSize(200,30+i.description:getHeight())
	i.Update = function(object,dt)
		local x,y = unit:getPosition()
		object:setPos(x+10,y+10)
		duration = duration - dt
	end
	i.OnClose = function()
		duration = 0
		tobedismiss = false
	end
	i:SetAlwaysUpdate(true)

		i.filter = filters.vibrate
		loveframes.anim:easy(i,'vibrate_ref',3,0,0.3,loveframes.style.linear)

	waitUntil(function() return duration <=0 end)
	if tobedismiss then
		i:dismiss()
	end
end

function demogame:keypressed(k)
	if k=='i' then

	ProFi = require 'ProFi'
	ProFi:start()
	execute(function()wait(0.5);
		ProFi:stop()
		ProFi:writeReport'report.txt'
	end)
end
	if k=='q' then
		local processor = require 'gamesystem.imageprocessthread'

		loveframes.Create('fileselection')
		fileselection:setCallbacks(
			function(file)
				processor.encodeTableToImageData(m:encode().wall,file,1,1,100,100,1)
				processor.start(function()end)
			end,
			function()
			end)
		
	end
	if k=='escape' then

		coroutinemsg(coroutine.resume(coroutine.create(function()self:dismiss()end)))
	end
	if k=='c' then
		self:setCellphoneState(not self.phonestate)
		
		print(coroutine.resume(coroutine.create(function()
		loveframes.dialogue(LocalizedString'TEST',LocalizedString"I'M DRUNK. IGNORE THIS MESSAGE.",{"OK"},function()end) end)))
	end
	if k=='a' then
		coroutinemsg(coroutine.resume(coroutine.create(function()self:loadSelectionWheel()end)))
	end
	if k=='m' then
		editor:load()
		editor:setMap(m)
--		sel:setDelegate(editor)
		sel.onInteract = function(obj)
			editor:interact(obj)
		end
		m:setDelegate(editor)
		editor:setDelegate(self)
	end
	if k=='b' then
		local brief = require 'gamesystem.brief'
		brief:setMission(self.mission)
		brief:load()

		brief.OnSetTimescale = function(t)self.timescale = t end
	end
	if k==' ' then
		pause = not pause
	end
	if k=='s' then
		local t= m:encode()
		local a = json.encode(host:encode())
		local l=json.encode(t)
		love.filesystem.write('demosave',l)
		love.filesystem.write('aidemo',a)
	end
	if k=='q' then
		m:createWallMap()
	end
	if k=='l' then
		local x,y = m.obj.boss:getPosition()
		--host:addAI(AIFindPath(m.obj.boss,Vector(500,400,0,3)))
		if m.obj.boss then
			--self.s = Sound('sound/effect/machine1.ogg',Vector(m.obj.boss:getPosition()),100,'effect',host,3)
			--self.s:play()
			--host:terminate(m.obj.boss,false,5)
		end
		loveframes.anim:easy(m,"lli_radius",0,screen.halfwidth,0.3)
		m.drawlli = not m.drawlli
		sound.play('sound/effect/lliactive.ogg','effect')
		local loop = sound.loadsound'sound/effect/lli.ogg'
		loop:setLooping(true)
		--sound.play(loop,'effect')
		loop:setVolume(0.5)
		local loop2 = sound.loadsound'sound/effect/heartbeat.ogg'
		loop2:setLooping(true)
		--sound.play(loop2,'effect')

		m.obj.river.lli_color = {255,0,0,50}
		m.obj.river.lli_flare = true
		m.obj.river.info.name = 'WUNG KING'
		m.obj.river.info.description = 'TARGET. HAS TO BE ELIMINATED.'

		controller = KMController(m,m.obj.river,host,self)
		function modalfunc(object,bool)
			controller:setEnabled(not bool)
		end
		
	loveframes.OnModal = modalfunc
	end

	if controller then
		controller:keypressed(k)
	end

	if k=='up' then
		m.camerashift.y = m.camerashift.y + 100
	elseif k=='down' then
		m.camerashift.y = m.camerashift.y - 100
	elseif k=='left' then
		m.camerashift.x = m.camerashift.x + 100
	elseif k=='right' then
		m.camerashift.x = m.camerashift.x - 100
	end

	m:setFollower(m.obj.river)
end

function demogame:keyreleased(k)
	if controller then
		controller:keyreleased(k)
	end
end

function demogame:mousepressed(x,y,b)
--	self.s = Sound('sound/effect/machine1.ogg',Vector(x,y),100,'effect',host,3)
--	self.s:play()

	if controller then
		controller:mousepressed(x,y,b)
	end
	if u2in then
		u2:setPosition(x,y)
		u:face(u2,true)
	end
	sel:mousepressed(x,y,b)
end
function demogame:mousereleased()
end

function demogame:loadSelectionWheel()
	local wheel = require 'gamesystem.selectionwheel'
	wheel:setInventory(self.inv)
	wheel.OnSetTimescale = function(t)self.timescale = t end
	wheel:load()
	--require 'gamesystem.selectionwheel':loadFirstLayout(self.inv:getFirstLayout())
end
--demogame:load()

function demogame:loadUI()
	local panel = loveframes.Create('frame')
	panel:setSize(300,100)
	panel:setPos(50,50)
	function panel:Draw()end
	panel:ShowCloseButton(false)
	panel:SetDraggable(false)
	local p = loveframes.Create("progressbar",panel)
	p:setPos(120,45)
	p:setSize(220,15)
	p:SetMinMax(0,100)
	p:SetValue(80)
	p.bar_color = {0,255,0,200}
	p.EKG_image = requireImage'asset/interface/ekg_signal.png'
	p.EKG_center = 0.2
	p.EKG_range = 0.1
	p.EKG_image:setWrap('repeat','repeat')
	p.EKG_quad = gra.newQuad(0,0,p:getWidth(),p.EKG_image:getHeight(),p.EKG_image:getWidth(),p.EKG_image:getHeight())

	local p = loveframes.Create("progressbar",panel)
	p:setPos(120,62)
	p:setSize(200,15)
	p:SetMinMax(0,100)
	p:SetValue(80)
	p.bar_color = {255,0,0,200}
	
	local compass = loveframes.Create("compass",panel)
	compass:setPos(0,0)
	compass:setSize(128,128)
	local centerButton = loveframes.Create('circlebutton',panel)
	centerButton:setSize(64,64)
	centerButton:setPos(32,32)
	centerButton.Update = function()
	local i = select(1,self.inv:getActiveItem())
	centerButton:setImage(i.info.icon)
	centerButton:setText(i.info.title)
end
	centerButton:SetAlwaysUpdate(true)
	centerButton.active = true
end

return demogame