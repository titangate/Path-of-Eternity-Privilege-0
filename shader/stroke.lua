local stroke = {}
stroke.pe = gra.newPixelEffect[[
extern number intensity = 1;
extern number rf_h = 512;
extern number rf_w = 512;

const number offset=3.2307692308;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture,texture_coords);
	if (texcolor.a>0) return texcolor;
	number alpha = Texel(texture,texture_coords+intensity*vec2(0,offset)/rf_h).a;
	alpha += Texel(texture,texture_coords-intensity*vec2(0,offset)/rf_h).a;
	alpha += Texel(texture,texture_coords+intensity*vec2(offset,0)/rf_w).a;
	alpha += Texel(texture,texture_coords-intensity*vec2(offset,0)/rf_w).a;
	if (alpha>0) {alpha = 255;}
	return vec4(color.rgb,alpha);
}
]]

function stroke.conf(obj)
	if type(obj.stroke_intensity)=='number' then
		stroke.pe:send('intensity',obj.stroke_intensity)
	end
end

local blurscale = 1

function stroke.predraw(obj)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local w2 = math.min(screen.width,neartwo(w*blurscale))
	local c = canvasmanager.requireCanvas(w2,h)
	c.canvas:clear()
	obj.prevc = gra.getCanvas()
	gra.setCanvas(c.canvas)
	obj.c = c
	gra.push()
	gra.translate(-obj:getX()+(w2-w)/blurscale,-obj:getY())
	stroke.pe:send('rf_h',h)
	stroke.pe:send('rf_w',w2)
end

function stroke.postdraw(obj)
local w = obj:getWidth()
local w2 = math.min(screen.width,neartwo(w*blurscale))
	gra.pop()
	gra.setCanvas(obj.prevc)
	gra.setPixelEffect(stroke.pe)
	gra.setColor(255,255,255)
	gra.draw(obj.c.canvas,obj:getX()-(w2-w)/blurscale,obj:getY())
	canvasmanager.releaseCanvas(obj.c)
	gra.setPixelEffect()
	obj.c = nil
	obj.prevc = nil
end

return stroke