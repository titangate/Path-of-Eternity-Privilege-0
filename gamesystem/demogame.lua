
local sound = require 'library.sound'
local doodad = require 'gameobject.doodad'

local demogame = {}

function demogame:load()


	-- Game Init --
	
	m = PathMap(20,20)
	m:setWallbatch(requireImage'asset/terrain/yellowwall.png',{
		width = 64,
		height = 64,
		ox = 32,
		oy = 32,
		lurd = love.graphics.newQuad(0,0,64,64,256,64),
		lr = love.graphics.newQuad(64,0,64,64,256,64),
		lur = love.graphics.newQuad(128,0,64,64,256,64),
		ur = love.graphics.newQuad(192,0,64,64,256,64),
		})
	m:createWallMap()
	host = AIHost(m)
--	u = Human(Box2DMover,100,100,0,'kinematic')
--	u2 = Human(Box2DMover,300,200,0,'kinematic')
	if love.filesystem.isFile'demosave' then

	local save = love.filesystem.read'demosave'
	save = json.decode(save)
		m:load(save)
	end
--	m:addUnit(u)
	m:setBackground'map/riverhideout.png'
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
		love.graphics.setColor(0,0,0,120)
		love.graphics.rectangle('fill',object.x,object.y,object.width,object.height)
	--	print (object.x/2,object.y,object.width,object.height)
		love.graphics.setColor(255,255,255)
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
--	function i:Draw() end


	sel.onSelect = function(obj)
		if obj==self.lli_object then return end
		self:lliSelect(obj)
		self.llipanel.filter = filters.vibrate
		loveframes.anim:easy(self.llipanel,'vibrate_ref',3,0,0.3,loveframes.style.linear)
		self.llipanel:SetVisible(true)
		if controller then
			controller.sel = obj
		end
	end

	sel.onDeselect = function()
		if nil==self.lli_object then return end
		self.lli_object = nil
		self.llipanel.namefield:setText''
		self.llipanel.description:setText''
		self.llipanel:SetVisible(false)
	end

	i = loveframes.Create('frame')

	function i:Draw()
		love.graphics.setColor(0,0,0,120)
		love.graphics.rectangle('fill',i.x,i.y,i.width,i.height)
		love.graphics.setColor(255,255,255)
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
	local inv = Inventory()
	for i = 1,3 do
		inv:setBaseItem(i,item.create('improvisation',0,0,0))
	end
	inv:setBaseItem(4,item.create('needle',0,0,0))
	self.inv = inv

	local a = require 'gameobject.animation'
	aa = RiverActor()
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
--	m:loadpause()
	
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
	if not pause then 
		host:process(dt)
--		u:update(dt)
--		c:update(dt)
		m:update(dt)
--		e:update(dt)
--		d:update(dt)
--		sound.setCenter(u:getPosition())
	end
	sel:update(dt)
	aa:update(dt)
end

function demogame:draw()
	local prev,canvas
	if self.scale ~=1 then
		love.graphics.push()
		love.graphics.translate(screen.halfwidth,screen.halfheight)
		love.graphics.scale(self.scale)
		love.graphics.translate(-screen.halfwidth*self.scale,-self.scale*screen.halfheight)
		canvas = canvasmanager.requireCanvas(screen.width,screen.height)
		canvas.canvas:clear()
		prev = love.graphics.getCanvas()
		love.graphics.setCanvas(canvas.canvas)
	end
	love.graphics.setColor(255,255,255)
	m:draw()

	if DEBUG and loveframes.config["DEBUG"] then
		m:DebugDraw()
--		u:DebugDraw()
		host:DebugDraw()
	--	e:DebugDraw()
		if self.s then
			self.s:DebugDraw()
		end
	end
--	d:DebugDraw()
	if self.scale ~=1 then
		love.graphics.pop()
		love.graphics.setColor(255,255,255,255*self.scale)
		love.graphics.setCanvas(prev)
		love.graphics.draw(canvas.canvas)
		canvasmanager.releaseCanvas(canvas)
	end
--	love.graphics.setColor(0,0,0)
	aa:draw(300,300,0)
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
	if k=='escape' then
		coroutinemsg(coroutine.resume(coroutine.create(function()self:dismiss()end)))
	end
	if k=='c' then
		self:setCellphoneState(not self.phonestate)
	end
	if k=='a' then
		coroutinemsg(coroutine.resume(coroutine.create(function()self:loadSelectionWheel()end)))
	end
	if k=='m' then
		local editor =  require 'gamesystem.editor'
		editor:load()
		editor:setMap(m)
--		sel:setDelegate(editor)
		sel.onInteract = function(obj)
			editor:interact(obj)
		end
		m:setDelegate(editor)
	end
	if k==' ' then
		pause = not pause
	end
	if k=='s' then
		local t= m:encode()
		for k,v in pairs(t.unit[1]) do print (k,v) end
		local l=json.encode(t)
		love.filesystem.write('demosave',l)
	end
	if k=='q' then
		coroutinemsg(coroutine.resume(coroutine.create(function()
			self:playConversation(m.obj.river,LocalizedString'YOU ONLY LIVE ONCE',5)
			self:playConversation(m.obj.river,LocalizedString'WHAT SAY YOU?',5)
		end)))
	end
	if k=='l' then
		loveframes.anim:easy(m,"lli_radius",0,screen.halfwidth,0.3)
		m.drawlli = not m.drawlli
		sound.play('sound/effect/lliactive.ogg','effect')
		local loop = sound.loadsound'sound/effect/lli.ogg'
		loop:setLooping(true)
		sound.play(loop,'effect')
		loop:setVolume(0.5)
		local loop2 = sound.loadsound'sound/effect/heartbeat.ogg'
		loop2:setLooping(true)
		sound.play(loop2,'effect')

		m.obj.river.lli_color = {255,0,0,50}
		m.obj.river.lli_flare = true
		m.obj.river.info.name = 'WUNG KING'
		m.obj.river.info.description = 'TARGET. HAS TO BE ELIMINATED.'

		controller = KMController(m,m.obj.river,host)
	end

	if controller then
		controller:keypressed(k)
	end
end

function demogame:keyreleased(k)
	if controller then
		controller:keyreleased(k)
	end
end

function demogame:mousepressed(x,y,b)
--	self.s = Sound('sound/effect/machine1.ogg',Vector(x,y),100)
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

	require 'gamesystem.selectionwheel':load()
	require 'gamesystem.selectionwheel':loadFirstLayout(self.inv:getFirstLayout())
end
--demogame:load()

return demogame