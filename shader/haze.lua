local haze = {}
haze.pe = gra.newPixelEffect[[
//const int normalscale = 64;
extern number ref = 1;
extern Image normal;
extern vec2 offset;
const vec2 shift = vec2(1,1);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
//	number hazeoff = fract(sin(dot(texture_coords.xy ,vec2(12.9898,78.233))) * 43758.5453)-0.5;
	vec2 hazeoff2d = (Texel(normal,texture_coords+offset).rg-shift)*ref;
	return Texel(texture,texture_coords+hazeoff2d)*0.5+Texel(texture,texture_coords)*0.5;
}
]]

function haze.conf(obj)
	if type(obj.haze_ref)=='number' then
		haze.pe:send('ref',obj.haze_ref)
	end
	if obj.haze_normal then
		haze.pe:send('normal',obj.haze_normal)
	end
	if obj.haze_offset then
		haze.pe:send('offset',obj.haze_offset)
	end
end

function haze.predraw(obj)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local c = canvasmanager.requireCanvas(w,h)
	c.canvas:clear()
	haze.prevc = gra.getCanvas()
	gra.setCanvas(c.canvas)
	haze.c = c
	gra.push()
	gra.translate(-obj:getX(),-obj:getY())
end

function haze.postdraw(obj)
	gra.pop()
	gra.setCanvas(haze.prevc)
	gra.setPixelEffect(haze.pe)
	gra.setColor(255,255,255)
	gra.draw(haze.c.canvas,obj:getX(),obj:getY())
	canvasmanager.releaseCanvas(haze.c)
	gra.setPixelEffect()
	haze.c = nil
end


function haze.predraw(obj)
	gra.setPixelEffect(haze.pe)
end

function haze.postdraw(obj)
	gra.setPixelEffect()
end

return haze