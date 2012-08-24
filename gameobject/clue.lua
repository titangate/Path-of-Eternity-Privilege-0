Clue = Object:subclass'Clue'

function Clue:initialize(def)
	self.def = def
end

function Clue:getIcon()
	return self.def.icon
end

function Clue:getText()
	return self.def.text
end

local cluedef

ClueState = Object:subclass'ClueState'
function ClueState:initialize(missionname)
	self.cluerep = cluedef[missionname]
	assert(self.cluerep)
	self.missionname = missionname
	self.discovered = {}
	self.assemblelist = {}
	self:generateAssembles()
end

function ClueState:generateAssembles()
	for k,v in pairs(self.cluerep) do
		if v.combo then
			self.assemblelist[k] = v.combo
		end
	end
end

function ClueState:discover(clue)
	self.discovered[clue] = true
	local r = {}
	for k,v in pairs(self.assemblelist) do
		local success = true
		for i,clue in ipairs(v) do
			if not self.discovered[clue] then
				success = false
				break
			end
		end
		if success then
			r[#r+1] = k
			self.assemblelist[k] = nil
		end
	end
	return r
end

function ClueState:hasDiscovered(clue)
	return self.discovered[clue]
end

function ClueState:getClue(clue)
	return Clue(self.cluerep[clue])
end

function ClueState:encode()
	return {
		name = self.class.name,
		missionname = self.missionname,
		assemblelist = self.assemblelist,
		discovered = self.discovered,
	}
end

function ClueState:decode(t)
	self.assemblelist = t.assemblelist
	self.discovered = t.discovered
end

local clue = {}
function clue.load()
	cluedef = require 'clue.definition'
end
function clue.decodeState(t)
	local s = ClueState(t.missionname)
	s:decode(t)
end
function clue.decode(t)

end
clue.load()
return clue