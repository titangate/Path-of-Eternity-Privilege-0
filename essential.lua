local img = {}
function requireImage(f)
	if not img[f] then
		img[f] = love.graphics.newImage(f)
	end
	return img[f]
end

local essential = {}
function essential.setTextureQuality()
	-- unimplemented
end
function essential.getAvailableTextureQuality()
	return {'HIGH'}
end

return essential