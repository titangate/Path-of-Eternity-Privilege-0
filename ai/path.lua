AIPath = AIBase:subclass'AIPath'
function AIPath:initialize(unit,path)
--	super.initialize(unit)
	AIBase.initialize(self,unit)
	if path then
		local b1,b2 = AIMoveTo(unit,path[#path])
	--	self.subai = {b1}
		self.p = b1
	--	self.next = b1
		for i=#path-1,1,-1 do
			b2 = AIMoveTo(unit,path[i])
			b1.next = b2
			b1=b2
		end
		self.path = path
		self.current = #path
		b1.next = AIStop(unit)
		self.initial = self.p
	end
end

function AIPath:process(dt)
	if #self.path == 0 then
		return 0,'success'
	end
	if not self.p then
		print (self.path)
	end
	assert(self.p,'subai missing')
	local v = self.p
	local ndt,state = v:process(dt)
	if state == 'failed' then
		return ndt,state
	elseif state == 'success' then
		if v.next then
			self.p = v.next
			self.p:process(dt-ndt)
			self.current = self.current - 1
			return
		else
			return 0,'success'
		end
	end
end

function AIPath:reset()
	self.current = #self.path
	self.p = self.initial
end



function AIPath:encode()
	assert(self.host)
	local subai = {}
	local p = self.initial
	while p~=nil do
		p.host = self.host
		table.insert(subai,p:encode())
		p = p.next
	end
	local path = {}
	for i,v in ipairs(self.path) do
		path[i] = v:encode()
	end
	return {
		name = 'AIPath',
		current = self.current,
		subai = subai,
		path = path,
	}
end

function AIPath:decode(t)
	print 'path decoded'
	self.current = t.current
	self.path = {}
	local b1,b2

	for i,v in ipairs(t.subai) do
		b2 = serial.decode(v,self.unit)
		if b1 then
			b1.next = b2
		end
		if i==1 then

			self.initial = b2
		end
		if i==#t.subai-self.current then
			self.p = b2
		end
		b1 = b2
	end
	assert(self.p)
	for i,v in ipairs(t.path) do
		self.path[i] = serial.decode(v)
	end
end

if DEBUG then
function AIPath:DebugDraw()
	gra.setColor(0,0,0)
	local x1,y1,x2,y2
	for i=self.current-1,1,-1 do
		x1,y1 = self.path[i]:getCenter()
		x2,y2 = self.path[i+1]:getCenter()
		gra.line(x2,y2,x1,y1)
		
	end
	if self.current > 0 then
		x1,y1 = self.path[self.current]:getCenter()
		gra.line(x1,y1,self.unit:getPosition())
	end
end
end