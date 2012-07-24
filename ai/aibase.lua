

AIBase = Object:subclass'AIBase'

function AIBase:initialize(unit)
	assert(unit, 'AI needs to have a host unit')
	self.unit = unit
end

function AIBase:process(dt)
	return dt,'failed'
end

