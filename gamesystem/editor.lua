require 'editor.inspector'
local editor = {}
function editor:load()
	self.uiobject = {}
	local function createframe(...)
		local item = loveframes.Create(...)
		table.insert(self.uiobject,item)
		return item
	end 


	local inspector = createframe('frame')
	inspector:setName(LocalizedString"INSPECTOR")
	inspector:setSize(300,500)
	inspector:setPos(100,10)
	self.inspector = inspector

	local list = createframe('list',inspector)
	list:setPos(5,30)
	list:setSize(280,450)
	self.list = list
	
	local cluechoice = createframe('multichoice',list)
	for k,v in pairs(global.clue:getClueList()) do
		cluechoice:AddChoice(k)
	end
	self.cluechoice = cluechoice

	function list:Draw()
	end

	local toolboxframe = createframe("frame")
	toolboxframe:setSize(600,80)
	toolboxframe:setPos(screen.halfwidth-300,screen.height-220)
	toolboxframe:setName(LocalizedString"TOOLBOX")
	local toolbox = createframe("list",toolboxframe)
	toolbox:setSize(600,64)
	toolbox:setPos(5,20)
	function toolbox:Draw() end

	toolbox:SetDisplayType'horizontal'

	local tools = {}


	local sel = createframe("selectionTool")
	function sel.Update(object,dt)
		if self.sel then
			if object.state == 'translate' then
				self.sel:setPosition(global.map:screenToMap(object:getCenter()))
			elseif object.state == 'rotate' then
				self.sel:setAngle(object.Spinvalue)
			end
		end
		if love.mouse.isDown'l' and self.sel and self.sel.setPatrolPath then
			if self.hover then
				if instanceOf(PatrolPath,self.hover) then
					self.sel:setPatrolPath(self.hover)
					if global.aihost then
						global.aihost:addAI(AIGuard(self.sel,self.hover.waypoint))
					end
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


	local b = createframe("circlebutton",toolbox)
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

	local walltool = createframe("wallTool")
	function walltool.OnLeftDown()
		local x,y = global.map:screenToMap(love.mouse.getPosition())
		global.map:setObstacleEditor(x,y,'wall')
	end
	function walltool.OnRightDown()
		local x,y = global.map:screenToMap(love.mouse.getPosition())
		global.map:setObstacleEditor(x,y,nil)
	end
	walltool:SetVisible(false)
	local b = createframe("circlebutton",toolbox)
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

	local pathtool = createframe("pathTool")
	pathtool:SetVisible(false)
	pathtool:setPos(love.mouse.getPosition())
	self.pathtool = pathtool
	local b = createframe("circlebutton",toolbox)
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


	local doortool = createframe("doorTool")
	function doortool.OnLeftDown(object,x,y,button)
		local x,y = global.map:pixelToData(global.map:screenToMap(x,y))
		local obs = global.map:hasObstacle(x,y)
		if obs == 'wall' then
			-- horizontal
			if global.map:hasObstacle(x+1,y)==nil and
				global.map:hasObstacle(x+2,y)==nil and
				global.map:hasObstacle(x+3,y)=='wall' then
				local door = Door(DoorMover,x*global.map.scale,(y-0.5)*global.map.scale,0,'dynamic',m._data[x][y].mover.body,x,y)
				global.map:addUnit(door)
			end
		end
	end
	function doortool.OnRightDown()
	end
	doortool:SetVisible(false)
	local b = createframe("circlebutton",toolbox)
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
		local dt = createframe("doodadTool")
		dt:setDoodad(v)
		dt:setDelegate(self)
		dt:setPos(love.mouse.getPosition())
		dt:SetVisible(false)
		local b = createframe("circlebutton",toolbox)
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
		local dt = createframe("humanTool")
		dt:setHuman(v)
		dt:setDelegate(self)
		dt:setPos(love.mouse.getPosition())
		dt:SetVisible(false)
		local b = createframe("circlebutton",toolbox)
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
			if self.atts then
				self.atts.x.box:setText(self.sel:getX())
				self.atts.y.box:setText(self.sel:getY())
				self.atts.angle.box:setText(self.sel:getAngle())
				self.namefield:setText("OBJECT SELECTED: "..self.sel.class.name)
			end
		end
	end
	self.seltool:SetVisible(false)
	self.inspector:SetVisible(false)
	self.tools = tools

	local menuframe = createframe('frame')
	menuframe:setSize(200,500)
	menuframe:setPos(screen.width-250,50)

	menuframe:setName(LocalizedString'MENU')

	local menu = createframe('list',menuframe)
	menu:setSize(180,470)
	menu:setPos(10,30)

	local processor = require 'gamesystem.imageprocessthread'
	local saveAllTo = createframe('button',menu)
	saveAllTo:setText(LocalizedString"SAVE ALL TO")
	saveAllTo.OnClick = function()

		local fileselection = createframe('fileselection')
		fileselection:setCallbacks(
			function(file)
				processor.encodeTableToImageData(global.map:getWall(),file..'_mapimage.png',1,1,100,100,1)
				processor.start(
				function()end)
				local t= global.map:encode()
				local a= json.encode(global.aihost:encode())
				local l = json.encode(t)
				love.filesystem.write(file..'_mapdata.json',l)
				love.filesystem.write(file..'_aidata.json',a)
				local quest = {
					map = file..'_mapdata.json',
					aidata = file..'_aidata.json',
					mission = global.mission:encode(),
				}

				love.filesystem.write(file..'.quest',json.encode(quest))
			end,
			function()
			end)
	end
	menu:AddItem(saveAllTo)

	local loadMission = createframe('button',menu)
	loadMission:setText(LocalizedString"LOAD QUEST")
	loadMission.OnClick = function()
		if self.del then
			local fileselection = createframe('fileselection')
			fileselection:setCallbacks(
				function(file)
					gs:loadQuest(file)
					
				end,
				function()
				end
			)

		end
	end

	local closeEditor = createframe('button',menu)
	closeEditor:setText(LocalizedString"CLOSE EDITOR")
	closeEditor.OnClick = function()
		if self.del then
			while #self.uiobject>0 do
				table.remove(self.uiobject):Remove()
			end
			self.del:setGameState()
		end
	end
end

function editor:setMap(m)
	--global.map = m
	--self.pathtool:setMap(global.map)
end

function editor:setDelegate(del)
	self.del = del
end

function editor:releaseSelection()
	global.map:update(0.01)
	self.hover = nil
end

function editor:setSelection(sel)
	global.map:update(0.01)
	self.hover = sel
end

local doodad = require 'gameobject.doodad'
function editor:spawnDoodad(x,y,def)
	x,y = global.map:screenToMap(x,y)
	local d = doodad.create(def,x,y,0)
	global.map:addUnit(d)
end

local unit = require 'gameobject.human'
function editor:spawnUnit(x,y,def)
	x,y = global.map:screenToMap(x,y)
	local u = unit.create(def,x,y,0)
	global.map:addUnit(u)
end

function editor:interact(obj)
	self.list:Clear()
	self.atts = nil
	if self.currenttool ~= self.seltool then return end
	self.sel = obj
	if not obj then return end
	if obj.fillInspector then
		obj:fillInspector(self,self.list,obj)
	else
		return
	end
	local x,y = global.map:mapToScreen(obj:getPosition())
	self.seltool:setPos(x-self.seltool:getWidth()/2,y-self.seltool:getHeight()/2)
	self.seltool.Spinvalue = obj:getAngle()
	if self.currenttool == self.seltool then
		self.seltool:SetVisible(true)
		self.inspector:SetVisible(true)
		if self.atts then self.atts.identifier.box:setText(self.sel:getIdentifier()) end
	end
end

function editor:loadPathFile(file)

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