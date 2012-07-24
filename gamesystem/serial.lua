local serial = {
	Human = require 'gameobject.human'.decode,
	River = require 'gameobject.human'.decode,
	Box2DMover = DecodeBox2DMover,
	Doodad = require 'gameobject.doodad'.decode,
	Door = CreateDoor,
}
function serial.decode(t,...)
	if serial[t.name] then
	return serial[t.name](t,...)
end
end

return serial