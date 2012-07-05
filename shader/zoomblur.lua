local zoomblur = {}
zoomblur.pe = love.graphics.newPixelEffect[[
	extern vec2 center; // Center of blur
	extern number intensity = 1; // effect intensity
	const number offset[5] = number[](1,1.05,1.1,1.15,1.2);
	const number weight[5] = number[](0.5,0.2,0.1,0.1,0.1);
	
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	{
		vec4 texcolor = Texel(texture, texture_coords);
		vec3 tc = texcolor.rgb * weight[0]*0.5;
		vec2 diff = texture_coords - center;
		for (int i=1;i<5;i++)
		{
			tc += Texel(texture,center + diff/offset[i]).rgb*0.2;
		}
		return color * vec4(tc, texcolor.a);
	}
]]

function zoomblur.conf(obj)
	if type(obj.zoomblur_intensity)=='number' then
		zoomblur.pe:send('intensity',obj.zoomblur_intensity)
	end
	if subclassOf(obj.zoomblur_center,Vector) then
		zoomblur.pe:send('center',obj.zoomblur_center)
	end
end

function zoomblur.predraw(obj)
	local w = obj:GetWidth()
	local h = obj:GetHeight()
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
	love.graphics.draw(zoomblur.c.canvas,obj:GetX(),obj:GetY())
	canvasmanager.releaseCanvas(zoomblur.c)
	love.graphics.setPixelEffect()
	zoomblur.c = nil
end

return zoomblur