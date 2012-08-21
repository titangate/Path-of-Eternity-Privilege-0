local channelsplit = {}
channelsplit.pe = gra.newPixelEffect[[
//const int normalscale = 64;
extern number intensity = 10;
extern number ref = 64;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec2 shift = vec2(intensity/ref,0);
	vec4 c1 = Texel(texture,texture_coords-shift);
	vec4 c2 = Texel(texture,texture_coords);
	vec4 c3 = Texel(texture,texture_coords+shift);
	return color*vec4(c1.r*c1.a,c2.g*c2.a,c3.b*c3.a,max(max(c1.a,c2.a),c3.a));
}
]]

function channelsplit.conf(obj)
	if type(obj.channelsplit_intensity)=='number' then
		channelsplit.pe:send('intensity',obj.channelsplit_intensity)
	end
end

function channelsplit.predraw(obj)
	channelsplit.pe:send('ref',obj:getWidth())
	gra.setPixelEffect(channelsplit.pe)
end

function channelsplit.postdraw(obj)
	gra.setPixelEffect()
	channelsplit.c = nil
end



return channelsplit