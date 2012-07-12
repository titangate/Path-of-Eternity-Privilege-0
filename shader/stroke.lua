local stroke = {}
stroke.pe = love.graphics.newPixelEffect[[
extern number intensity = 1;
extern number rf_h = 512;
extern number rf_w = 512;

const number offset=3.2307692308;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture,texture_coords);
	if (texcolor.a>0) return color * texcolor;
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
	local w = obj:GetWidth()
	local h = obj:GetHeight()
	local w2 = math.min(screen.width,neartwo(w*blurscale))
	local c = canvasmanager.requireCanvas(w2,h)
	c.canvas:clear()
	stroke.prevc = love.graphics.getCanvas()
	love.graphics.setCanvas(c.canvas)
	stroke.c = c
	love.graphics.push()
	love.graphics.translate(-obj:GetX()+(w2-w)/blurscale,-obj:GetY())
	stroke.pe:send('rf_h',h)
	stroke.pe:send('rf_w',w2)
end

function stroke.postdraw(obj)
local w = obj:GetWidth()
local w2 = math.min(screen.width,neartwo(w*blurscale))
	love.graphics.pop()
	love.graphics.setCanvas(stroke.prevc)
	love.graphics.setPixelEffect(stroke.pe)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(stroke.c.canvas,obj:GetX()-(w2-w)/blurscale,obj:GetY())
	canvasmanager.releaseCanvas(stroke.c)
	love.graphics.setPixelEffect()
	stroke.c = nil
end

return stroke