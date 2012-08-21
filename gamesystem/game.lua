local sound = require 'library.sound'
local doodad = require 'gameobject.doodad'
local mission = require 'gameobject.mission'
mission:load()
local editor =  require 'gamesystem.editor'


global = {}

local game = {}
function game:load()
	self.timescale = 1
	self.state = 'game'
	loveframes.anim:easy(self,'scale',0,1,0.5)
	self.scale = 0
	editor:setDelegate(self)
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
		end
		loveframes.OnModal = modalfunc
		m:setFollower(global.map.obj.river)
	end
	self.sel = Selection(m)
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
	gra.push()
	global.map:draw()
	gra.pop()
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
	wheel:setInventory(self.inv)
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
		local i = select(1,self.inv:getActiveItem())
		centerButton:setImage(i.info.icon)
		centerButton:setText(i.info.title)
	end
	centerButton:SetAlwaysUpdate(true)
	centerButton.active = true
end

return game