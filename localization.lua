local l
local function switchfont(loc)
	local t = {
	eng = function()
		
		font = {}

		font.smallfont = love.graphics.newFont('oldsansblack.ttf',12)
		font.imagebuttonfont = love.graphics.newFont('oldsansblack.ttf',15)
		pn = love.graphics.print
		pfn = love.graphics.printf
		sfn = love.graphics.setFont
		
		function fontGetWrap(font,text,width)
			
				return font:getWrap(text,width)
		end
	end,
	chr = function()
		font = {}
		local f = 'simsun.ttc'
		font.smallfont = love.graphics.newFont(f, 12)
		font.imagebuttonfont = love.graphics.newFont(f,15)
		local fontizes = {
			[font.imagebuttonfont] = 15,
			[font.smallfont] = 12,
		}
		local pf = love.graphics.printf
		local fw = 25
		function pfn(text,x,y,limit,align)
			text = tostring(text)
			limit = limit or 9999999
			align = align or 'left'
			local f = love.graphics.getFont()
			if f:getWidth(text) <= limit then
				pf(text,x,y,limit,align)
			else
				local len = #text
				local lines = math.ceil(len/3/(limit/fw))
				local h = math.floor(limit/fw)
				for i=1,lines do
					local txt = string.sub(text,(h*(i-1))*3+1,3*h*i)
					love.graphics.printf(txt,x,y+(i-1)*fw,limit,align)
				end
			end
		end
		pn = pfn
		local sf = love.graphics.setFont
		function sfn(font)
			sf(font)
			fw = fontizes[font] or fw
		end
		
		function fontGetWrap(font,text,width)
			text = tostring(text)
			limit = limit or 9999999
			local f = font
			if f:getWidth(text) <= width then
				return f:getWrap(text,width)
			else
				local len = #text
				return width,math.ceil(len/3/fw)
			end
		end
	end,}
	t[loc]()
end

function setLocalization(loc)
	
	if loc == 'eng' then 
		
		function LocalizedString(str)
			return str
		end
	else
		print (loc)
		
		l = require('localization.'..loc)
		function LocalizedString(str)
			return l[str] or str
		end
	end
	switchfont(loc)
end