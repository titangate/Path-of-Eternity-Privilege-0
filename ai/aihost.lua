local const = {
	hard = {
		sound_low_time = 5,
		sound_high_time = 15,
	},
}

AIHost = Object:subclass'AIHost'
function AIHost:initialize(map)
	assert(map,'map not given')
	self.ai = {}
	self.map = map
	self.info = const.hard
end

function AIHost:addAI(ai)
	self.ai[ai.unit] = self.ai[ai.unit] or {ai}
	self.ai[ai.unit][#self.ai[ai.unit]]=ai
	ai.host = self
end

function AIHost:terminate(unit,...)
	self.ai[unit][#self.ai[unit]]:terminate(...)
end

function AIHost:getNearbyArea(target,distance)
	return self.map:getNearbyArea(target,distance)
end

function AIHost:process(dt)
	for u,v in pairs(self.ai) do
		if v[#v] then
			local ndt,state = v[#v]:process(dt)
			if state == 'failed' then
				v[#v] = nil

			elseif state == 'success' then
				if v[#v].next then
					if v[#v].next.reset then
						v[#v].next:reset()
					end
					v[#v].next.host = self
					v[#v] = v[#v].next
				else
					self.ai[u][#self.ai[u]] = nil
				end
			end
		end
	end
end

function AIHost:alert(unit)
end

function AIHost:findPath(start,finish,errorrange)
	return self.map:findPath(start,finish,errorrange)
end

function AIHost:raycast()
end

function AIHost:playsound(s)
	local area = CircleArea(s.pos.x,s.pos.y,s.reach*2)
	local singleout
	if alert == 2 then
		singleout = true
	end
	local function unitalert(unit)
		if self.ai[unit] and self.ai[unit][#self.ai[unit]] and self.ai[unit][#self.ai[unit]].soundAlert then
			local unitp = Vector(unit:getPosition())
			local dis = (s.pos-unitp):length()
			local alert = s.alert * math.max(0,math.min(1,2+(dis-s.reach)/s.reach))
			
			if singleout then
--				if math.random()>0.5 then
					self.ai[unit][#self.ai[unit]]:soundAlert(s.pos,3)
					singleout = false
--				end
			else
				self.ai[unit][#self.ai[unit]]:soundAlert(s.pos,alert)
			end
		end
		return true
	end
	self.map:queryUnits(area,unitalert)
end

function AIHost:getConstant(k)
	return self.info[k]
end

function AIHost:pushAI(ai)
	self.ai[ai.unit] = self.ai[ai.unit] or {}
	table.insert(self.ai[ai.unit],ai)
	ai.host = self
	ai.unit.aihost = self
end

function AIHost:popAI(unit)
	table.remove(self.ai[unit])
end

function AIHost:getIdentifier(unit)
	return unit:getIdentifier()
end
function AIHost:getUnit(identifier)
	return self.map.obj[identifier]
end

function AIHost:encode()
	local t = {}
	for unit,ai in pairs(self.ai) do
		local a = {}
		for i,v in ipairs(ai) do
			local p = v
			while p ~= nil do
				table.insert(a,p:encode())
				p = p.next
			end
		end
		t[unit:getIdentifier()] = a
	end
	return t
end

function AIHost:decode(t)
	for unit,ai in pairs(t) do
		for i,v in ipairs(ai) do
			--self:pushAI()
			local u = self:getUnit(unit)
			local a = serial.decode(v,u)
			self:pushAI(a)
		end

	end
end

if DEBUG then
function AIHost:DebugDraw()
	for u,v in pairs(self.ai) do
		if v.DebugDraw then
			v:DebugDraw()
		end
	end
end
end