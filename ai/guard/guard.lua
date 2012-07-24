AIGuard = AIBase:subclass'AIGuard'

function AIGuard:initialize(unit,waypoint)
	AIBase.initialize(self,unit)
	self.ai_patrol = AIPatrol(unit,waypoint)
	self.ai_suspicous = nil--AIFacing(unit)
	self.ai_investigate = nil 
	self.poptime = 360000
	self.subgoal = {self.ai_patrol}
end

function AIGuard:soundAlert(position,level)
	print (level,'sound level')
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
	v.host = self.host
	local ndt,state = v:process(dt)
	if state == 'failed' then
		return ndt,state
	elseif state == 'success' then
		if v.next then
			print (v.next)
			if v.next.reset then v.next:reset() end
			self.subgoal[#self.subgoal] = v.next
			self.subgoal[#self.subgoal]:process(dt-ndt)
			return
		else
			return 0,'success'
		end
	end
end