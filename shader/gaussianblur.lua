local gaussianblur = {}
gaussianblur.vert = love.graphics.newPixelEffect[[
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

	return color * tc;
}
]]
gaussianblur.horz = love.graphics.newPixelEffect[[
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
	local w2 = math.min(screen.width,neartwo(w*blurscale))
	local c = canvasmanager.requireCanvas(w2,h)
	c.canvas:clear()
	gaussianblur.prevc = love.graphics.getCanvas()
	love.graphics.setCanvas(c.canvas)
	gaussianblur.c = c
	love.graphics.push()
	love.graphics.translate(-obj:getX()+(w2-w)/blurscale,-obj:getY())
	gaussianblur.vert:send('rf_h',h)
	gaussianblur.horz:send('rf_w',w2)
	love.graphics.setPixelEffect(gaussianblur.vert)
end

function gaussianblur.postdraw(obj)
local w = obj:getWidth()
local w2 = math.min(screen.width,neartwo(w*blurscale))
	love.graphics.pop()
	love.graphics.setCanvas(gaussianblur.prevc)
	love.graphics.setPixelEffect(gaussianblur.horz)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(gaussianblur.c.canvas,obj:getX()-(w2-w)/blurscale,obj:getY())
	canvasmanager.releaseCanvas(gaussianblur.c)
	love.graphics.setPixelEffect()
	gaussianblur.c = nil
end

return gaussianblur