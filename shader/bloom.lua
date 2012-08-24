local bloom = {}
bloom.pe = gra.newPixelEffect[[
extern vec2 image_size;
extern number intensity = 1;
vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
{
    vec2 offset = vec2(1.0)/image_size*intensity;
    color = Texel(tex, tc); // maybe add a weight here?

    color += Texel(tex, tc + vec2(-offset.x, offset.y));
    color += Texel(tex, tc + vec2(0, offset.y));
    color += Texel(tex, tc + vec2(offset.x, offset.y));

    color += Texel(tex, tc + vec2(-offset.x, 0));
    color += Texel(tex, tc + vec2(0, 0));
    color += Texel(tex, tc + vec2(offset.x, 0));

    color += Texel(tex, tc + vec2(-offset.x, -offset.y));
    color += Texel(tex, tc + vec2(0, -offset.y));
    color += Texel(tex, tc + vec2(offset.x, -offset.y));

    return color / (10-intensity); // use 10.0 for regular blurring.
}
]]

function bloom.conf(obj)
	if obj.bloom_intensity then
		bloom.pe:send('intensity',obj.bloom_intensity)
	end
end
local blurscale = 1

function bloom.predraw(obj)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local c = canvasmanager.requireCanvas(w/blurscale,h/blurscale)
	c.canvas:clear()
	obj.prevc = gra.getCanvas()
	gra.setCanvas(c.canvas)
	obj.c = c
	gra.push()
	gra.translate(-obj:getX(),-obj:getY())
	gra.scale(1/blurscale)
	bloom.pe:send('image_size',{w*blurscale,h*blurscale})
end

function bloom.postdraw(obj)
	gra.pop()
	gra.setCanvas(obj.prevc)
	gra.setPixelEffect(bloom.pe)
	gra.setColor(255,255,255)
	gra.draw(obj.c.canvas,obj:getX(),obj:getY(),0,blurscale)
	canvasmanager.releaseCanvas(obj.c)
	gra.setPixelEffect()
	obj.c = nil
end

return bloom