local sound = require 'library.sound'
local doodad = require 'gameobject.doodad'
local mission = require 'gameobject.mission'
mission:load()
local editor =  require 'gamesystem.editor'
local item = require 'gameobject.item'
local cl = require 'gameobject.clue'
local bg = require 'gamesystem.chembg'

global = {}

local game = {}
function game:load()
	loveframes.base = base()
	self.timescale = 1
	self.state = 'game'
	loveframes.anim:easy(self,'scale',0,1,0.5)
	self.scale = 0
	editor:setDelegate(self)
	sound.playMusic('sound/music/danger.ogg')
end

function game:loadFromSave(map,host,mis)
	assert(mis.mission)
	for k,v in pairs(mis.mission) do
		print (k,v)
	end
	local m = PathMap(map.w,map.h)
	local h = AIHost(m)
	global.map = m
	global.aihost = h
	global.mission = serial.decode(mis.mission)
	global.clue = ClueState'hospital'
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
	m:load(map)
	h:decode(host)
	m:createWallMap()
	m:setBackground'map/hospitalfloor.png'
	if global.map.obj.river then
		self.controller = KMController(m,global.map.obj.river,h,self)
		function modalfunc(object,bool)
			self.controller:setEnabled(not bool)
			if bool then
				self.filter = filters.gaussianblur
			else
				self.filter = nil
			end
		end
		loveframes.OnModal = modalfunc
		m:setFollower(global.map.obj.river)
	end
	self.sel = Selection(m)
	self.sel.onSelect = function(obj)
		if obj==self.lli_object then return end
		self:lliSelect(obj)
		self.lli_object = obj
		if self.controller then
			self.controller.sel = obj
		end
		editor:setSelection(obj)
	end

	self.sel.onDeselect = function()
		if nil==self.lli_object then return end
		self:lliDeselect()
		if self.controller then
			self.controller.sel = nil
		end
		editor:releaseSelection()
	end

	self:loadUI()
end

function game:setCountdown(time,callback,heartbeatinterval,heartbeatfunction,x,y)
	self.countdown = CountDown(time,callback,heartbeatinterval,heartbeatfunction,x,y)
	global.map:addUnit(self.countdown)
end

function game:lliSelect(obj)
	if obj~=self.lli_object then
		self:lliDeselect()
	end
	if obj.info and obj.info.clue then
		if global.clue:hasDiscovered(clue) then return end
		self:setCountdown(5,function()self:discoverClue(obj.info.clue)end,
			1,
			function()
				sound.play('sound/effect/heartbeatonce.ogg','interface','static')
				self.bloom_intensity = 3
				self.filter = filters.bloom
				loveframes.anim:easy(self,'bloom_intensity',3,0,0.3)
				execute(function()
					wait(0.3)
					self.filter = nil
				end)
			end,
			obj:getX(),obj:getY())
	end
end


function game:lliDeselect()
	if self.countdown then
		global.map:removeUnit(self.countdown)
		self.countdown = nil
	end
end

function game:setGameState(state)
	-- allowable state: game,editor
	state = state or 'game'
	if state == self.state then return end
	self.state = state
	if state == 'game' then
		--editor:hide()
		self.controller:setEnabled(true)
	elseif state == 'editor' then
		editor:load()
		self.controller:setEnabled(false)
	end
end

function game:update(dt)
	dt = self.timescale * dt
	if self.state == 'game' and not self.pause then
		global.aihost:process(dt)
		global.map:update(dt)
		if global.map.obj.river then
			sound.setCenter(global.map.obj.river:getPosition())
		end
	end
	self.sel:update(dt)
	if self.drawingchem then
		bg:update(dt*10)
	end
end

function game:getX()
	return 0
end

function game:getY()
	return 0
end

function game:getWidth()
	return screen.width
end

function game:getHeight()
	return screen.height
end

function game:draw()
	local prev,canvas
	if self.scale ~=1 then
		gra.push()
		gra.translate(screen.halfwidth,screen.halfheight)
		gra.scale(self.scale)
		gra.translate(-screen.halfwidth*self.scale,-self.scale*screen.halfheight)
	end
	gra.setColor(255,255,255)
	if self.filter then
		self.filter.conf(self)
		self.filter.predraw(self)
	end
	gra.push()

	global.map:draw()
	gra.pop()
	if self.filter then
		self.filter.postdraw(self)
	end
	if self.scale ~=1 then
		gra.pop()
	end
	if self.drawingchem then
		bg:draw()
	end
end

function game:keypressed(k)
	self.controller:keypressed(k)
end

function game:keyreleased(k)
	self.controller:keyreleased(k)
end

function game:mousepressed(x,y,b)
	self.controller:mousepressed(x,y,b)
end

function game:mousereleased(x,y,b)
	self.controller:mousereleased(x,y,b)
end

function game:loadSelectionWheel()
	local wheel = require 'gamesystem.selectionwheel'
	wheel:setInventory(global.map.obj.river.inv)
	wheel.OnSetTimescale = function(t)self.timescale = t end
	wheel:load()
end

function game:setCellphoneState(state)
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


function game:loadresume()
	loveframes.anim:easy(self,'scale',0,1,0.25)
	self.scale = 0
end

function game:dismiss()
	loveframes.anim:easy(self,'scale',1,0,0.5)
	local mm = require'gamesystem.mainmenu'
	wait(0.25)
	mm:loadpause()
	self.host.push(mm,1)
end

function game:hint(message)
	local ml = self.messagelist
	if #ml.children > 10 then
		ml:RemoveItemAtIndex(1)
	end
	local t = loveframes.Create('text',ml)
	t:setText(message)
	ml:AddItem(t)
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',3,0,0.3)
	execute(function()
		wait(0.3)
		t.filter = nil
	end)
end

function game:discoverClue(clue)
	if global.clue:hasDiscovered(clue) then return end
	local c = global.clue:getClue(clue)
	local result = global.clue:discover(clue)
	local ml = self.messagelist
	if #ml.children > 10 then
		ml:RemoveItemAtIndex(1)
	end
	local b = horzBar(objectivelist,requireImage(c:getIcon()),
		c:getText(),280,50)
	ml:AddItem(b)
	b.filter = filters.vibrate
	loveframes.anim:easy(b,'vibrate_ref',1,0,0.3)
	execute(function()
		wait(0.3)
		b.filter = nil
	end)
	sound.play('sound/interface/drum3.ogg','interface','static')
	self.bloom_intensity = 3
	self.filter = filters.bloom
	loveframes.anim:easy(self,'bloom_intensity',3,0,1)
	execute(function()
		wait(1)
		self.filter = nil
	end)
	if #result> 0 then
		execute(function()
		for i,c in ipairs(result) do
			wait(3)
			self:drawChemBG(true)
			self.bloom_intensity = 0
			self.filter = filters.bloom
			loveframes.anim:easy(self,'bloom_intensity',0,3,1)
			wait(1)
			c = global.clue:getClue(c)
			sound.play('sound/effect/inception.ogg','interface','static')
			local b = horzBar(objectivelist,requireImage(c:getIcon()),
			c:getText(),280,50)
			ml:AddItem(b)
			b.filter = filters.vibrate
			loveframes.anim:easy(b,'vibrate_ref',3,0,0.3)
			execute(function()
				wait(0.3)
				b.filter = nil
			end)

			loveframes.anim:easy(self,'bloom_intensity',3,0,1)
			self:drawChemBG(false)
			wait(1)
			self.filter = nil
		end
		end)
	end
end

function game:drawChemBG(state)
	self.drawingchem = state
end

function game:loadUI()
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
		local i = select(1,global.map.obj.river.inv:getActiveItem())
		centerButton:setImage(i.info.icon)
		centerButton:setText(i.info.title)
	end
	centerButton:SetAlwaysUpdate(true)
	centerButton.active = true

	local messages = loveframes.Create('frame')
	messages:setPos(50,screen.height-350)
	messages:setSize(300,200)
	messages:setName''
	messages:ShowCloseButton(false)

	local messagelist = loveframes.Create('list',messages)
	function messagelist.Draw()end
	messagelist:setSize(280,180)
	self.messagelist = messagelist
end


function game:dismiss()
	loveframes.anim:easy(self,'scale',1,0,0.5)
	local mm = require'gamesystem.mainmenu'
	wait(0.25)
	mm:loadpause()
	self.host.push(mm,1)
end
return game