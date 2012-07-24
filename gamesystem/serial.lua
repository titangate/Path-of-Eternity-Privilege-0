local serial = {
	Human = require 'gameobject.human'.decode,
	River = require 'gameobject.human'.decode,
	Box2DMover = DecodeBox2DMover,
	Doodad = require 'gameobject.doodad'.decode,
	Door = CreateDoor,
}
function serial.decode(t,...)
	assert(serial[t.name])
	return serial[t.name](t,...)
end

return serial