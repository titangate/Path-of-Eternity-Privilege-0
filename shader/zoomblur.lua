local zoomblur = {}
zoomblur.pe = love.graphics.newPixelEffect[[
	extern vec2 center; // Center of blur
	extern number intensity = 1; // effect intensity
	const number offset[5] = number[](0,0.05,0.1,0.15,0.2);
	const number weight[5] = number[](0.5,0.2,0.1,0.1,0.1);
	
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords)*weight[0];
		vec2 diff = (texture_coords - center);
		for (int i=1;i<5;i++)
		{
			texcolor += Texel(texture,center + diff*(1+offset[i]*intensity))*weight[i];
		}
		return color * texcolor;
	}
]]

function zoomblur.conf(obj)
--	print (obj.zoomblur_center)
	if type(obj.zoomblur_intensity)=='number' then
		zoomblur.pe:send('intensity',obj.zoomblur_intensity)
	end
	if type(obj.zoomblur_center)=='table' then
		local x,y = unpack(obj.zoomblur_center)
		x = x/zoomblur.c.w
		y = y/zoomblur.c.w
		zoomblur.pe:send('center',{x,1-y})
	end
end

function zoomblur.predraw(obj)
	local w = obj:GetWidth()
	local h = obj:GetHeight()
	w = math.min(screen.width,neartwo(w))
	local c = canvasmanager.requireCanvas(w,h)
	c.canvas:clear()
	zoomblur.prevc = love.graphics.getCanvas()
	love.graphics.setCanvas(c.canvas)
	zoomblur.c = c
	love.graphics.push()
	love.graphics.translate(-obj:GetX(),-obj:GetY())
end

function zoomblur.postdraw(obj)
	local w = obj:GetWidth()
	love.graphics.pop()
	love.graphics.setCanvas(zoomblur.prevc)
	love.graphics.setPixelEffect(zoomblur.pe)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(zoomblur.c.canvas,obj:GetX(),obj:GetY())
	canvasmanager.releaseCanvas(zoomblur.c)
	love.graphics.setPixelEffect()
	zoomblur.c = nil
end

return zoomblur