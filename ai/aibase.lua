

AIBase = Object:subclass'AIBase'

function AIBase:initialize(unit)
	assert(unit, 'AI needs to have a host unit')
	self.unit = unit
end

function AIBase:process(dt)
	return dt,'failed'
end

function AIBase:encode()
	return {name = 'AIBase'}
end

function AIBase:decode(t)
end

function AIBase:reset()end