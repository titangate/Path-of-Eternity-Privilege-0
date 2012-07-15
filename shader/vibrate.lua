local vibrate = {}
vibrate.pe = love.graphics.newPixelEffect[[
//const int normalscale = 64;
extern number ref = 1;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	number hazeoff = fract(sin(dot(texture_coords.xy ,vec2(12.9898,78.233))) * 43758.5453)-0.5;
	vec2 hazeoff2d = vec2(hazeoff,0);
	return Texel(texture,texture_coords+hazeoff2d*ref)*color;
}
]]

function vibrate.conf(obj)
	if type(obj.vibrate_ref)=='number' then
		vibrate.pe:send('ref',1.2^obj.vibrate_ref-1)
	end
end

function vibrate.predraw(obj)
	local w = obj:getWidth()
	local h = obj:getHeight()
	local w2 = math.min(screen.width,neartwo(w*2))
	local c = canvasmanager.requireCanvas(w2,h)
	c.canvas:clear()
	vibrate.prevc = love.graphics.getCanvas()
	love.graphics.setCanvas(c.canvas)
	vibrate.c = c
	love.graphics.push()
	love.graphics.translate(-obj:getX()+(w2-w)/2,-obj:getY())
	love.graphics.setColor(255,255,255)
end

function vibrate.postdraw(obj)
local w = obj:getWidth()
local w2 = math.min(screen.width,neartwo(w*2))
	love.graphics.pop()
	love.graphics.setCanvas(vibrate.prevc)
	love.graphics.setPixelEffect(vibrate.pe)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(vibrate.c.canvas,obj:getX()-(w2-w)/2,obj:getY())
	canvasmanager.releaseCanvas(vibrate.c)
	love.graphics.setPixelEffect()
	vibrate.c = nil
end

return vibrate