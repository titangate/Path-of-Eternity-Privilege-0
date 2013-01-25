local brief = {}


function brief:setMission(m)
	self.mission = m
end

function brief:load()
	local frame1 = loveframes.Create'frame'
	frame1:setName(LocalizedString'MISSION BRIEF')
	frame1:setSize(1024,700)
	frame1:Center()

	self.frame = frame1

	local objectivelist = loveframes.Create('list',self.frame)
	objectivelist.name = ''
	objectivelist:setSize(300,650)
	objectivelist:setPos(15,25)
	objectivelist.spacing = 10
	self.objectivelist = objectivelist
	

	self:loadMission()
	if self.OnSetTimescale then
		self.OnSetTimescale(0.25)
	end

	frame1.OnClose = function()
		if self.OnSetTimescale then
			self.OnSetTimescale(1)
		end
	end
	frame1:SetModal(true)
end

function brief:loadMission()
	assert(self.mission)
	local m = self.mission.def
	local objectivelist = self.objectivelist
	local buttonlist = {}
	for k,v in pairs(m.targets) do
		local b = horzBar(objectivelist,requireImage(v.portrait),{LocalizedString(v.name),LocalizedString(v.status)},300,50)
		objectivelist:AddItem(b)
		b.button.OnClick = function()
			self:loadTarget(v)
			for i,v in ipairs(buttonlist) do
				v.button.active = nil
			end
			b.button.active = true
		end
		if v.status == 'DEAD' then
			b.button.color = {255,0,0}
		end
		table.insert(buttonlist,b)
	end
	for k,v in pairs(m.objectives) do
		local b = horzBar(objectivelist,requireImage(v.portrait),{LocalizedString(v.name),LocalizedString(v.status)},300,50)
		objectivelist:AddItem(b)
		b.button.OnClick = function()
			self:loadObjective(v)
			for i,v in ipairs(buttonlist) do
				v.button.active = nil
			end
			b.button.active = true

			if v.status == 'COMPLETED' then
				b.button.color = {0,255,0}
			end
		end
		table.insert(buttonlist,b)
	end
	--self.frame:SetModal(true)
end

function brief:loadTarget(t)
	if self.detailpanel then
		self.detailpanel:Remove()
	end
	assert(self.frame)
	local f = loveframes.Create('panel',self.frame)
	f:setSize(700,650)
	f:setPos(315,25)
	function f:Draw()end
	self.detailpanel = f
	local img = loveframes.Create('image',f)
	img:setImage(t.picture)
	img:SetX(5)
	img:CenterY()

	local infolist = loveframes.Create('list',f)
	infolist:setSize(350,650)
	infolist:setPos(350,120)
	function infolist:Draw()end
	local name = loveframes.Create('text',f)
	name:SetFont(font.bigfont)
	name:setText{{210,152,65},LocalizedString(t.name)}
	name:setPos(300,35)
	name:CenterX()
	local infos = {'gender','height','weight','age',' ','description',' ','statusdescription'}
	for i,v in ipairs(infos) do
		local field = loveframes.Create('text',infolist)
		local txt = t[v] or ' '
		field:setText(string.upper(v)..' : '..LocalizedString(txt))
		infolist:AddItem(field)
	end

	if t.status == 'DEAD' then
		local blood = loveframes.Create('image',f)
		blood:setImage('mission/bloodstain.png')
		blood:SetX(5)
		blood:CenterY()
		img:SetColor{255,0,0}

	end


end


function brief:loadObjective(t)
	if self.detailpanel then
		self.detailpanel:Remove()
	end
	assert(self.frame)
	local f = loveframes.Create('panel',self.frame)
	f:setSize(700,650)
	f:setPos(315,25)
	function f:Draw()end
	self.detailpanel = f
	local img = loveframes.Create('image',f)
	img:setImage(t.picture)
	img:SetX(5)
	img:CenterY()

	local infolist = loveframes.Create('list',f)
	infolist:setSize(350,650)
	infolist:setPos(350,120)
	function infolist:Draw()end
	local name = loveframes.Create('text',f)
	name:SetFont(font.bigfont)
	name:setText{{210,152,65},LocalizedString(t.name)}
	name:setPos(300,35)
	name:CenterX()
	local infos = {'description','','statusdescription'}
	for i,v in ipairs(infos) do
		local field = loveframes.Create('text',infolist)
		local txt = t[v] or ' '
		field:setText(string.upper(v)..' : '..LocalizedString(txt))
		infolist:AddItem(field)
	end


	if t.status == 'COMPLETED' then
		img:SetColor{0,255,0}

	end

end

return brief