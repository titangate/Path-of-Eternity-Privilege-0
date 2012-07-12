local EKG = {}
EKG.pe = love.graphics.newPixelEffect[[
//const int normalscale = 64;
extern number center = 0.5;
extern number range = 0.1;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	color.a = color.a*min(1,(1-abs(texture_coords.x-center)/range));
	texture_coords.x = fract(texture_coords.x);
	return Texel(texture,texture_coords)*color;
}
]]


function EKG.conf(obj)
	if obj.EKG_center then
		EKG.pe:send('center',obj.EKG_center)
	end
	
	if obj.EKG_range then
		EKG.pe:send('range',obj.EKG_range)
	end
end

function EKG.predraw(obj)
	love.graphics.setPixelEffect(EKG.pe)
end

function EKG.postdraw(obj)
	love.graphics.setPixelEffect()
end

return EKG