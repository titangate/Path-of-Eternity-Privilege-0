local serial = {
	Human = require 'gameobject.human'.decode,
	River = require 'gameobject.human'.decode,
	Box2DMover = DecodeBox2DMover,
	Doodad = require 'gameobject.doodad'.decode,
	Door = CreateDoor,
	CircleArea = function(t) return CircleArea(t.x,t.y,t.r) end,
	RectangleArea = function(t) return RectangleArea(t.x,t.y,t.w,t.h) end,
	PathMap = function(t) local m = PathMap(t.w,t.h); m:load(t); return m; end,
	Mission = require 'gameobject.mission'.decode,
	Item = require 'gameobject.item'.decode,
}
function serial.decode(t,...)
	if serial[t.name] then
		return serial[t.name](t,...)
	end
	for i,v in pairs(t) do print (i,v) end
	if string.sub(t.name,1,2) == 'AI' then
		local ai = loadstring(string.format("return %s",t.name))()
		assert(ai,'Invalid AI Class')
		assert(...,'Must have a unit for AI to host upon')
		ai = ai(...)
		ai:decode(t)
		return ai
	end
end

return serial