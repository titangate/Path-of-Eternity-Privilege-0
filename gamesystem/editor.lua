
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
				self.sel:setPosition(object:getCenter())
			elseif object.state == 'rotate' then
				self.sel:setAngle(object.Spinvalue)
			end
		end
	end
	sel:SetAlwaysUpdate(true)
	self.seltool = sel
	self.currenttool = self.seltool


	local b = loveframes.Create("circlebutton",toolbox)
	b:setText(k)
	b.active = true
	self.currentbutton = b
--		b:setSize(180,180)
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
end

function editor:setDelegate(del)
	self.del = del
end

function editor:releaseSelection()
end

function editor:setSelection()
end

local doodad = require 'gameobject.doodad'
function editor:spawnDoodad(x,y,def)
	local d = doodad.create(def,x,y,0)
	self.map:addUnit(d)
end

local unit = require 'gameobject.human'
function editor:spawnUnit(x,y,def)
	local u = unit.create(def,x,y,0)
	self.map:addUnit(u)
end

function editor:interact(obj)
	if self.currenttool ~= self.seltool then return end
	self.sel = obj
	if not obj then return end
	local x,y = obj:getPosition()
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