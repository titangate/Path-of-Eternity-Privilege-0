AIGuard = AIBase:subclass'AIGuard'

function AIGuard:initialize(unit,waypoint)
	AIBase.initialize(self,unit)
	if waypoint then self.ai_patrol = AIPatrol(unit,waypoint) end
	self.ai_suspicous = nil--AIFacing(unit)
	self.ai_investigate = nil 
	self.poptime = 360000
	self.subgoal = {self.ai_patrol}
end

function AIGuard:soundAlert(position,level)
	if level >= 3 then
		self.poptime = self.host:getConstant'sound_high_time'
		self.ai_investigate = AIInvestigate(self.unit,position)
		self.subgoal[2] = self.ai_investigate
	elseif level >= 1 then
		self.poptime = self.host:getConstant'sound_low_time'
		self.ai_suspicous = AIStop(self.unit)
		self.ai_suspicous.next = AIFacing(self.unit,position)
		self.subgoal[2] = self.ai_suspicous
	else
	end
end

function AIGuard:terminate(lethal,time)
	self.poptime = 360000
	if lethal then
		self.subgoal[2] = AIStop(self.unit)
		self.subgoal[3] = AIStop(self.unit)
		--self.host:popAI(self.unit)
	else
		self.subgoal[2] = AIStop(self.unit)
		self.subgoal[3] = AIStop(self.unit)
		-- TODO
		--self.host:popAI(self.unit)
	end
end

function AIGuard:visionAlert(position,level)
end

function AIGuard:process(dt)
	self.poptime = self.poptime - dt
	if self.poptime <= 0 then
		table.remove(self.subgoal)
		self.poptime = 360000
	end
	local v = self.subgoal[#self.subgoal]
	if v then
	v.host = self.host
	local ndt,state = v:process(dt)
	if state == 'failed' then
		return ndt,state
	elseif state == 'success' then
		if v.next then
			if v.next.reset then v.next:reset() end
			self.subgoal[#self.subgoal] = v.next
			self.subgoal[#self.subgoal]:process(dt-ndt)
			return
		else
			return 0,'success'
		end
	end
end
end

function AIGuard:encode()
	assert(self.host)
	local subais = {}
	for i=1,3 do
		local v = self.subgoal[i]
		local subai = {}
		local p = v
		local hashed = {}
		while p~=nil and not hashed[p] do
			p.host = self.host
			print (json.encode(p:encode()))
			table.insert(subai,p:encode())
			hashed[p] = true
			p = p.next
		end
		table.insert(subais,subai)
	end

	return {
		name = 'AIGuard',
		dt = self.dt,
		poptime = self.poptime,
		subai = subais,
	}
end

function AIGuard:decode(t)
	self.dt = t.dt
	self.poptime = t.poptime
	for i=1,3 do
		local v = t.subai[i]
		if v then
			local b1,b2,initial
			for i,v2 in ipairs(v) do
				b2 = serial.decode(v2,self.unit)
				if nil==initial then initial = b2 end
				if b1 then
					b1.next = b2
				end
				if i==1 then
					assert(b2)
					initial = b2
				end
				b1 = b2
			end
			if b2 and initial then
				b2.next = initial
			end
			print ('after',b1,b2)
			--
			self.subgoal[i] = initial
		end
	end
end
