

gra = {}
for k,v in pairs(love.graphics) do
	gra[k] = v
end
function gra.draw(item,x,y,r,sx,sy,...)
	if x then x = x*option.retina end
	if y then y = y*option.retina end
	if not item:typeOf'Canvas' then
	sx = sx or 1
	sy = sy or sx
	if sx then sx = sx*option.retina end
	if sy then sy = sy*option.retina end
end
	love.graphics.draw(item,x,y,r,sx,sy,...)
end

function gra.drawq(item,quad,x,y,r,sx,sy,...)
	if x then x = x*option.retina end
	if y then y = y*option.retina end
	if not item:typeOf'Canvas' then
		sx = sx or 1
		sy = sy or sx
		if sx then sx = sx*option.retina end
		if sy then sy = sy*option.retina end
	end
	love.graphics.drawq(item,quad,x,y,r,sx,sy,...)
end
function gra.newCanvas(w,h)
	if w then w = w*option.retina end
	if h then h = h*option.retina end
	print (w,h,'canvas created')
	return love.graphics.newCanvas(w,h)
end
function gra.translate(x,y)
	if x then x = x*option.retina end
	if y then y = y*option.retina end
	love.graphics.translate(x,y)
end

function gra.setFont(f)
	--if  then
	gra.altfont = font.retina[f]
	love.graphics.setFont(f)
	--end
end

function gra.print(msg,x,y,r,sx,sy,ox,oy,kx,ky)
	local f = love.graphics.getFont()
	if gra.altfont and option.retina ~= 1 then
		love.graphics.setFont(gra.altfont)
	end
	if x then x = x*option.retina end
	if y then y = y*option.retina end

	love.graphics.print(msg,x,y,r,sx,sy,ox,oy,kx,ky)
	if f then love.graphics.setFont(f) end
end

function gra.printf(msg,x,y,limit,...)
	local f = love.graphics.getFont()
	if gra.altfont and option.retina ~= 1 then
		love.graphics.setFont(gra.altfont)
	end
	if x then x = x*option.retina end
	if y then y = y*option.retina end
	if limit then limit = limit*option.retina end
	love.graphics.printf(msg,x,y,limit,...)
	if f then love.graphics.setFont(f) end
end

function gra.rectangle(m,x,y,w,h)
	love.graphics.rectangle(m,x*option.retina,y*option.retina,w*option.retina,h*option.retina)
end

function gra.line(x1,y1,x2,y2)
	love.graphics.line(x1*option.retina,y1*option.retina,x2*option.retina,y2*option.retina)
end

function gra.circle(m,x,y,r,e)
	love.graphics.circle(m,x*option.retina,y*option.retina,r*option.retina,e)
end

function gra.polygon(m,...)
	for i,v in ipairs(arg) do
		arg[i] = v*option.retina
	end
	love.graphics.polygon(m,unpack(arg))
end