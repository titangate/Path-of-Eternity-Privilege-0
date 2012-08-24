local gaussianblur = {}
gaussianblur.vert = gra.newPixelEffect[[
extern number intensity = 1;
extern number rf_h = 512;

const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 tc = Texel(texture,texture_coords) * weight[0];
	tc += Texel(texture,texture_coords+intensity*vec2(0,offset[1])/rf_h)*weight[1];
	tc += Texel(texture,texture_coords-intensity*vec2(0,offset[1])/rf_h)*weight[1];

	tc += Texel(texture,texture_coords+intensity*vec2(0,offset[2])/rf_h)*weight[2];
	tc += Texel(texture,texture_coords-intensity*vec2(0,offset[2])/rf_h)*weight[2];
//	tc.a = Texel(texture,texture_coords).a;
	return color * tc;
}
]]
gaussianblur.horz = gra.newPixelEffect[[
extern number intensity = 1;
extern number rf_w = 512;

const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 tc = Texel(texture,texture_coords) * weight[0];
	tc += Texel(texture,texture_coords+intensity*vec2(offset[1],0)/rf_w)*weight[1];
	tc += Texel(texture,texture_coords-intensity*vec2(offset[1],0)/rf_w)*weight[1];

	tc += Texel(texture,texture_coords+intensity*vec2(offset[2],0)/rf_w)*weight[2];
	tc += Texel(texture,texture_coords-intensity*vec2(offset[2],0)/rf_w)*weight[2];
//	tc.a = Texel(texture,texture_coords).a;

	return color * tc;
}

]]

function gaussianblur.conf(obj)
	if type(obj.gaussianblur_intensity)=='number' then
		gaussianblur.horz:send('intensity',obj.gaussianblur_intensity)
		gaussianblur.vert:send('intensity',obj.gaussianblur_intensity)
	end
end

local blurscale = 1

function gaussianblur.predraw(obj)
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
	gaussianblur.vert:send('rf_h',h*blurscale)
	gaussianblur.horz:send('rf_w',w*blurscale)
end

function gaussianblur.postdraw(obj)
	local w = obj:getWidth()
	gra.pop()

	gra.setPixelEffect(gaussianblur.vert)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local c = canvasmanager.requireCanvas(w/blurscale,h/blurscale)
	c.canvas:clear()
	gra.setCanvas(c.canvas)
	gra.draw(obj.c.canvas)
	gra.setCanvas(obj.prevc)
	gra.setPixelEffect(gaussianblur.horz)
	gra.setColor(255,255,255)
	gra.draw(c.canvas,obj:getX(),obj:getY(),0,blurscale)
	canvasmanager.releaseCanvas(obj.c)

	canvasmanager.releaseCanvas(c)
	gra.setPixelEffect()
	obj.c = nil
end

return gaussianblur