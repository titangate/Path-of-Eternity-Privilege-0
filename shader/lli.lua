local lli = {}
lli.pe = gra.newPixelEffect[[
//const int normalscale = 64;
extern number saturation = 0;
extern number brightness = 0;
const vec3 luminanceWeight = vec3(0.299,0.587,0.114);

extern number intensity = 1;
extern number rf_h = 512;

const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 tc = Texel(texture, texture_coords);

	tc += Texel(texture,texture_coords+intensity*vec2(0,offset[1])/rf_h)*weight[1];
	tc += Texel(texture,texture_coords-intensity*vec2(0,offset[1])/rf_h)*weight[1];

	tc += Texel(texture,texture_coords+intensity*vec2(0,offset[2])/rf_h)*weight[2];
	tc += Texel(texture,texture_coords-intensity*vec2(0,offset[2])/rf_h)*weight[2];

	float avg = (tc.r + tc.g + tc.b)/3;

	tc.r = max(0, min(1, avg+(tc.r-0.5)*(saturation/0.01)+brightness));
	tc.g = max(0, min(1, avg+(tc.g-0.5)*(saturation/0.01)+brightness));
	tc.b = max(0, min(1, avg+(tc.b-0.5)*(saturation/0.01)+brightness));
	return color * tc;
}
]]


function lli.conf(obj)
	if obj.satbri_saturation then
		lli.pe:send('saturation',obj.satbri_saturation)
	end
	
	if obj.satbri_brightness then
		lli.pe:send('brightness',obj.satbri_brightness)
	end

	if obj.lli_intensity then
		lli.pe:send('intensity',obj.lli_intensity)
	end

end

function lli.predraw(obj)
	gra.setPixelEffect(lli.pe)
	lli.pe:send('rf_h',screen.height)
end

function lli.postdraw(obj)
	gra.setPixelEffect()
end

return lli