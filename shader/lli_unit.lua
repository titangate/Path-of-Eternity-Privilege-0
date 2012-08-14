local lli_unit = {}
lli_unit.pe = gra.newPixelEffect[[
extern vec2 pixel_size;

vec4 effect(vec4 c, Image tex, vec2 tc, vec2 pixel_coords)
{
    vec4 color = vec4(1.0);
    // the kernel
    color +=  1. * Texel(tex, tc + vec2(-pixel_size.x, -pixel_size.y));
    color +=  2. * Texel(tex, tc + vec2( 0, -pixel_size.y));
    color +=  1. * Texel(tex, tc + vec2( pixel_size.x, -pixel_size.y));
    color += -1. * Texel(tex, tc + vec2(-pixel_size.x, pixel_size.y));
    color += -2. * Texel(tex, tc + vec2( 0, pixel_size.y));
    color += -1. * Texel(tex, tc + vec2(pixel_size.x, pixel_size.y));
    vec4 texcolor = Texel(tex,tc);
    color = color + texcolor*0.5;
    color.a = texcolor.a;
    return color*c;
}
]]


function lli_unit.conf(obj)
	
end

function lli_unit.predraw(obj)
	gra.setPixelEffect(lli_unit.pe)
	local n = 1/obj:getWidth()
	lli_unit.pe:send('pixel_size',{n,n})
end

function lli_unit.postdraw(obj)
	gra.setPixelEffect()
end

return lli_unit