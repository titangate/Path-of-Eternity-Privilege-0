
local editor = {}
function editor:load()
	local inspector = loveframes.Create'frame'
	inspector:setName(LocalizedString"INSPECTOR")
	inspector:setSize(300,500)
	inspector:setPos(100,10)
	self.inspector = inspector

	local list = loveframes.Create('list',inspector)
	list:setPos(5,30)
	list:setSize(280,450)

	local te = loveframes.Create('text',list)
	te:setText('OBJECT SELECTED')
	te:SetFont(font.imagebuttonfont)
	self.namefield = te
	self.atts = {}
	local at = {'x','y','angle','identifier'}
	for i,v in ipairs(at) do
		local te = loveframes.Create('text',list)
		te:setText(v)
		te:SetFont(font.imagebuttonfont)
		te:SetWidth(450)
		local ti = loveframes.Create('textinput',list)
		self.atts[v]={text = te,box = ti}
	end

	self.atts.identifier.box.OnEnter = function(object,text)
		self.sel:setIdentifier(text)
	end

	local deletebutton = loveframes.Create('button',list)
	deletebutton:setText(LocalizedString'DELETE OBJECT')
	deletebutton:setSize(100,20)
	deletebutton.OnClick = function(object)
		if self.sel then
			assert(self.map)
			self.map:removeUnit(self.sel)
		end
	end

	function list:Draw()
	end
--	inspector:MakeTop()

	local toolboxframe = loveframes.Create("frame")
	toolboxframe:setSize(600,80)
	toolboxframe:setPos(screen.halfwidth-300,screen.height-220)
	toolboxframe:setName(LocalizedString"TOOLBOX")
	local toolbox = loveframes.Create("list",toolboxframe)
	toolbox:setSize(600,64)
	toolbox:setPos(5,20)
	function toolbox:Draw() end

	toolbox:SetDisplayType'horizontal'

	local tools = {}


	local sel = loveframes.Create("selectionTool")
	function sel.Update(object,dt)
		if self.sel then
			if object.state == 'translate' then
				self.sel:setPosition(self.map:screenToMap(object:getCenter()))
			elseif object.state == 'rotate' then
				self.sel:setAngle(object.Spinvalue)
			end
		end
		if love.mouse.isDown'l' and self.sel and self.sel.setPatrolPath then
			
			if self.hover then
				if instanceOf(PatrolPath,self.hover) then
					print 'hovered'
					self.sel:setPatrolPath(self.hover)
					return true
				end
			end
		end
	end
	function sel.GetHoverPath()

	end
	sel:SetAlwaysUpdate(true)
	self.seltool = sel
	self.currenttool = self.seltool


	local b = loveframes.Create("circlebutton",toolbox)
	b:setText(k)
	b.active = true
	self.currentbutton = b
	b:setImage('asset/difficulty/brutal.png')
	b:setText(LocalizedString'SELECTION')
	b.OnClick = function(object)
		self.currenttool:SetVisible(false)
		self.currentbutton.active = nil
		self.currenttool = sel
		self.currentbutton = b
		b.active = true
		sel:SetVisible(true)
	end
	toolbox:AddItem(b)

	local walltool = loveframes.Create("wallTool")
	function walltool.OnLeftDown()
		local x,y = self.map:screenToMap(love.mouse.getPosition())
		self.map:setObstacleEditor(x,y,'wall')
	end
	function walltool.OnRightDown()
		local x,y = self.map:screenToMap(love.mouse.getPosition())
		self.map:setObstacleEditor(x,y,nil)
	end
	walltool:SetVisible(false)
	local b = loveframes.Create("circlebutton",toolbox)
	b:setText(k)
	b.active = false
	b:setImage('asset/difficulty/hard.png')
	b:setText(LocalizedString'WALL')
	b.OnClick = function(object)
		self.currenttool:SetVisible(false)
		self.currentbutton.active = nil
		self.currenttool = walltool
		self.currentbutton = b
		b.active = true
		walltool:SetVisible(true)
	end
	toolbox:AddItem(b)

	local pathtool = loveframes.Create("pathTool")
	pathtool:SetVisible(false)
	pathtool:setPos(love.mouse.getPosition())
	self.pathtool = pathtool
	local b = loveframes.Create("circlebutton",toolbox)
	b:setText(k)
	b.active = false
	b:setImage('asset/difficulty/hard.png')
	b:setText(LocalizedString'PATH')
	b.OnClick = function(object)
		self.currenttool:SetVisible(false)
		self.currentbutton.active = nil
		self.currenttool = pathtool
		self.currentbutton = b
		b.active = true
		pathtool:SetVisible(true)
	end
	toolbox:AddItem(b)


	local doortool = loveframes.Create("doorTool")
	function doortool.OnLeftDown(object,x,y,button)
		local x,y = self.map:pixelToData(self.map:screenToMap(x,y))
		local obs = self.map:hasObstacle(x,y)
		if obs == 'wall' then
			-- horizontal
			if self.map:hasObstacle(x+1,y)==nil and
				self.map:hasObstacle(x+2,y)==nil and
				self.map:hasObstacle(x+3,y)=='wall' then
				local door = Door(DoorMover,x*self.map.scale,(y-0.5)*self.map.scale,0,'dynamic',m._data[x][y].mover.body,x,y)
				self.map:addUnit(door)
			end
		end
	end
	function doortool.OnRightDown()
	end
	doortool:SetVisible(false)
	local b = loveframes.Create("circlebutton",toolbox)
	b:setText(k)
	b.active = false
	b:setImage('asset/difficulty/normal.png')
	b:setText(LocalizedString'DOOR')
	b.OnClick = function(object)
		self.currenttool:SetVisible(false)
		self.currentbutton.active = nil
		self.currenttool = doortool
		self.currentbutton = b
		b.active = true
		doortool:SetVisible(true)
	end
	toolbox:AddItem(b)

	table.insert(tools,{sel,b})
	local t = require 'doodad.definition'
	for k,v in pairs(t) do
		local dt = loveframes.Create("doodadTool")
		dt:setDoodad(v)
		dt:setDelegate(self)
		dt:setPos(love.mouse.getPosition())
		dt:SetVisible(false)
		local b = loveframes.Create("circlebutton",toolbox)
		b:setText(k)

--		b:setSize(180,180)
		b:setImage('doodad/'..v.image)
		b.OnClick = function(object)
			self.currenttool:SetVisible(false)
			self.currentbutton.active = nil
			self.currenttool = dt
			self.currentbutton = b
			b.active = true
			dt:SetVisible(true)
		end
		toolbox:AddItem(b)

		table.insert(tools,{dt,b})
	end

	local t = require 'unit.definition'
	for k,v in pairs(t) do
		local dt = loveframes.Create("humanTool")
		dt:setHuman(v)
		dt:setDelegate(self)
		dt:setPos(love.mouse.getPosition())
		dt:SetVisible(false)
		local b = loveframes.Create("circlebutton",toolbox)
		b:setText(k)

--		b:setSize(180,180)
		b:setImage('unit/'..v.head)
		b.OnClick = function(object)
			self.currenttool:SetVisible(false)
			self.currentbutton.active = nil
			self.currenttool = dt
			self.currentbutton = b
			b.active = true
			dt:SetVisible(true)
		end
		toolbox:AddItem(b)

		table.insert(tools,{dt,b})
	end

	inspector:SetAlwaysUpdate(true)
	inspector.Update = function(object,dt)
		if self.sel then
			self.atts.x.box:setText(self.sel:getX())
			self.atts.y.box:setText(self.sel:getY())
			self.atts.angle.box:setText(self.sel:getAngle())
			self.namefield:setText("OBJECT SELECTED: "..self.sel.class.name)
		end
	end
	self.seltool:SetVisible(false)
	self.inspector:SetVisible(false)
	self.tools = tools
end

function editor:setMap(m)
	self.map = m

	self.pathtool:setMap(self.map)
end

function editor:setDelegate(del)
	self.del = del
end

function editor:releaseSelection()
	self.hover = nil
end

function editor:setSelection(sel)
	self.hover = sel
end

local doodad = require 'gameobject.doodad'
function editor:spawnDoodad(x,y,def)
	x,y = self.map:screenToMap(x,y)
	local d = doodad.create(def,x,y,0)
	self.map:addUnit(d)
end

local unit = require 'gameobject.human'
function editor:spawnUnit(x,y,def)
	x,y = self.map:screenToMap(x,y)
	local u = unit.create(def,x,y,0)
	self.map:addUnit(u)
end

function editor:interact(obj)
	if self.currenttool ~= self.seltool then return end
	self.sel = obj
	if not obj then return end
	local x,y = self.map:mapToScreen(obj:getPosition())
	self.seltool:setPos(x-self.seltool:getWidth()/2,y-self.seltool:getHeight()/2)
	self.seltool.Spinvalue = obj:getAngle()
	if self.currenttool == self.seltool then
		self.seltool:SetVisible(true)
		self.inspector:SetVisible(true)
		self.atts.identifier.box:setText(self.sel:getIdentifier())
	end
end

function editor:removeUnit(u)
	if self.currenttool == self.seltool then
		if u==self.sel then
			self.sel = nil
			self.seltool:SetVisible(false)
			self.inspector:SetVisible(false)
		end
	end
end

return editor