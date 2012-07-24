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
					print (v[#v].next,'next')
					if v[#v].next.reset then
						v[#v].next:reset()
					end

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
	local function unitalert(unit)

		if self.ai[unit] and self.ai[unit][#self.ai[unit]].soundAlert then
			local unitp = Vector(unit:getPosition())
			local dis = (s.pos-unitp):length()
			print ((dis-s.reach)/s.reach)
			local alert = s.alert * math.max(0,math.min(1,2+(dis-s.reach)/s.reach))
			self.ai[unit][#self.ai[unit]]:soundAlert(s.pos,alert)
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
end

function AIHost:popAI(unit)
	table.remove(self.ai[unit])
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