
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

--	inspector:SetAlwaysUpdate(true)
--	inspector.update = function(object,dt)
--		object:MakeTop()
--	end

	local te = loveframes.Create('text',list)
	te:SetText('OBJECT SELECTED')
	te:SetFont(font.imagebuttonfont)
	self.namefield = te
	self.atts = {}
	local at = {'x','y','angle'}
	for i,v in ipairs(at) do
		local te = loveframes.Create('text',list)
		te:SetText(v)
		te:SetFont(font.imagebuttonfont)
		te:SetWidth(450)
		local ti = loveframes.Create('textinput',list)
		self.atts[v]={text = te,box = ti}
	end

	local deletebutton = loveframes.Create('button',list)
	deletebutton:SetText(LocalizedString'DELETE OBJECT')
	deletebutton:setSize(100,20)
	deletebutton.OnClick = function(object)
		if self.sel then
			assert(self.map)
			self.map:removeUnit(self.sel)
		end
	end

	function list:Draw()
	end
	inspector:MakeTop()

	local toolboxframe = loveframes.Create("frame")
	toolboxframe:setSize(600,200)
	toolboxframe:setPos(screen.halfwidth-300,screen.height-220)
	toolboxframe:setName(LocalizedString"TOOLBOX")
	local toolbox = loveframes.Create("list",toolboxframe)
	toolbox:setSize(600,180)
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

	table.insert(tools,sel)

	

	self.seltool:SetVisible(false)
	self.inspector:SetVisible(false)
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


function editor:interact(obj)
	self.sel = obj
	if not obj then return end
	self.atts.x.box:SetText(obj:getX())
	self.atts.y.box:SetText(obj:getY())
	self.atts.angle.box:SetText(obj:getAngle())
	self.namefield:SetText("OBJECT SELECTED: "..obj.class.name)
	local x,y = obj:getPosition()
	self.seltool:setPos(x-self.seltool:getWidth()/2,y-self.seltool:getHeight()/2)
	self.seltool.Spinvalue = obj:getAngle()

	self.seltool:SetVisible(true)
	self.inspector:SetVisible(true)
end

function editor:removeUnit(u)
	if u==self.sel then
		self.sel = nil
		self.seltool:SetVisible(false)
		self.inspector:SetVisible(false)
	end
end

return editor