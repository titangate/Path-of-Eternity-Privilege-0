Mission = Object:subclass'Mission'
function Mission:initialize(def)
	self.def = def
end

function Mission:setTargetInfo(target,k,v)
	assert(self.def.targets[target])
	self.def.targets[target][k] = v
end

function Mission:setObjectiveStatus(objective,status,describ)
	assert(self.objectives[objective])
	self.objectives[objective].status = status
	self.objectives[objective].statusdescription = describ
end

function Mission:encode()
	return {
		name = self.class.name,
		info = self.def,
	}
end


local mission = {}
local missiondef
function mission.load()
	missiondef = require 'mission.definition'
end

function mission.decode(t)
	return mission.create(t.info)
end

function mission.create(def,x,y,r)
	if type(def) == 'string' then
		def = missiondef[def]
	end

	local d = Mission(table.copy(def))
	return d
end

mission.load()

return mission