local satbri = {}
satbri.pe = gra.newPixelEffect[[
//const int normalscale = 64;
extern number saturation = 0;
extern number brightness = 0;
const vec3 luminanceWeight = vec3(0.299,0.587,0.114);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 pixel = Texel(texture, texture_coords);

	float avg = (pixel.r + pixel.g + pixel.b)/3;

	pixel.r = max(0, min(1, avg+(pixel.r-0.5)*(saturation/0.01)+brightness));
	pixel.g = max(0, min(1, avg+(pixel.g-0.5)*(saturation/0.01)+brightness));
	pixel.b = max(0, min(1, avg+(pixel.b-0.5)*(saturation/0.01)+brightness));
	return  pixel;
}
]]


function satbri.conf(obj)
	if obj.satbri_saturation then
		satbri.pe:send('saturation',obj.satbri_saturation)
	end
	
	if obj.satbri_brightness then
		satbri.pe:send('brightness',obj.satbri_brightness)
	end
end

function satbri.predraw(obj)
	gra.setPixelEffect(satbri.pe)
end

function satbri.postdraw(obj)
	gra.setPixelEffect()
end

return satbri