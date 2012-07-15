AIHost = Object:subclass'AIHost'
function AIHost:initialize(map)
	assert(map,'map not given')
	self.ai = {}
	self.map = map
end

function AIHost:addAI(ai)
	self.ai[ai.unit] = ai
	ai.host = self
end

function AIHost:getNearbyArea(target,distance)
	return self.map:getNearbyArea(target,distance)
end

function AIHost:process(dt)
	for u,v in pairs(self.ai) do
		local ndt,state = v:process(dt)
		if state == 'failed' then
			self.ai[u] = nil
		elseif state == 'success' then
			if v.next then
				self.ai[u] = v.next
				if v.next.reset then
					v.next:reset()
				end
				self.ai[u]:process(dt-ndt)
			else
				self.ai[u] = nil
			end
		end
	end
end

function AIHost:alert(unit)
end

function AIHost:findPath(start,finish)
	return self.map:findPath(start,finish)
end

function AIHost:raycast()
end

function AIHost:playsound(s)
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