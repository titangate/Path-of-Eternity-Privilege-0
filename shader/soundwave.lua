local soundwave = {}
soundwave.pe = gra.newPixelEffect[[
extern vec2 refcenter = vec2(0.5,0.5);
extern number intensity = 0.05;
extern number ref = 640;
vec4 effect(vec4 color,Image texture,vec2 texture_coords,vec2 pixel_coords)
{
	// convert to radial coordinates
	vec2 diff = texture_coords - refcenter;
	number req = Texel(texture,normalize(diff)).g*intensity+0.5-intensity;
	if (abs(length(diff)-req)<(ref))
		return color;
	return vec4(0,0,0,0);
}
]]

function soundwave.conf(obj)
	if type(obj.soundwave_ref)=='number' then
		soundwave.pe:send('ref',1/(obj.soundwave_ref*2))
	end
	if obj.soundwave_intensity then
		soundwave.pe:send('intensity',obj.soundwave_intensity)
	end
end

function soundwave.predraw(obj)
	gra.setPixelEffect(soundwave.pe)
end

function soundwave.postdraw(obj)
	gra.setPixelEffect()
end

return soundwave