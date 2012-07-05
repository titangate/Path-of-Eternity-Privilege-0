local l
local function switchfonts(loc)
	local t = {
	eng = function()
		fonts = {}
		fonts.default24 = love.graphics.newFont(24)
		pfn = love.graphics.printf
		sfn = love.graphics.setFont
		
		function fontGetWrap(font,text,width)
			
				return font:getWrap(text,width)
		end
	end,
	chr = function()
		fonts = {}
		local f = 'simsun.ttc'
		fonts.default24 = love.graphics.newFont(24)
		fonts.oldsans12 = love.graphics.newFont(f, 12)
		fonts.oldsans20 = love.graphics.newFont(f, 20)
		fonts.oldsans24 = love.graphics.newFont(f, 24)
		fonts.oldsans32 = love.graphics.newFont(f, 32)
		fonts.bigfont = love.graphics.newFont(f,25)
		fonts.midfont = love.graphics.newFont(f,19)
		fonts.smallfont = love.graphics.newFont(f,13)
		local fontsizes = {
			[fonts.default24] = 24,
			[fonts.oldsans12] = 12,
			[fonts.oldsans20] = 20,
			[fonts.oldsans24] = 24,
			[fonts.oldsans32] = 32,
			[fonts.bigfont] = 25,
			[fonts.midfont] = 19,
			[fonts.smallfont] = 13,
		}
		local pf = love.graphics.printf
		local fw = 25
		function pfn(text,x,y,limit,align)
			text = tostring(text)
			limit = limit or 9999999
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
		local sf = love.graphics.setFont
		function sfn(font)
			sf(font)
			fw = fontsizes[font] or fw
			
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
	switchfonts(loc)
end