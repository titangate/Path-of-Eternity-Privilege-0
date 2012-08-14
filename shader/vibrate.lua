local vibrate = {}
vibrate.pe = gra.newPixelEffect[[
//const int normalscale = 64;
extern number ref = 1;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	number hazeoff = fract(sin(dot(texture_coords.xy ,vec2(12.9898,78.233))) * 43758.5453)-0.5;
	vec2 hazeoff2d = vec2(hazeoff,0);
	return Texel(texture,texture_coords+hazeoff2d*ref)*color;
}
]]

function vibrate.conf(obj)
	if type(obj.vibrate_ref)=='number' then
		vibrate.pe:send('ref',1.2^obj.vibrate_ref-1)
	end
end

function vibrate.predraw(obj)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local c = canvasmanager.requireCanvas(w,h)
	c.canvas:clear()
	vibrate.prevc = gra.getCanvas()
	gra.setCanvas(c.canvas)
	vibrate.c = c
	gra.push()
	--gra.scale(1/option.retina)
	gra.translate(-obj:getX(),(-obj:getY()))
	gra.setColor(255,255,255)
end

function vibrate.postdraw(obj)
local w = obj:getWidth()
	gra.pop()
	gra.setCanvas(vibrate.prevc)
	gra.setPixelEffect(vibrate.pe)
	gra.setColor(255,255,255)
	gra.setBlendMode'premultiplied'
	gra.draw(vibrate.c.canvas,(obj:getX()),(obj:getY()))
	canvasmanager.releaseCanvas(vibrate.c)
	gra.setPixelEffect()
	gra.setBlendMode'alpha'
	vibrate.c = nil
end

return vibrate