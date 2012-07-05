local img = {}
function requireImage(f)
	if not img[f] then
		img[f] = love.graphics.newImage(f)
	end
	return img[f]
end
	