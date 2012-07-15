local l
local function switchfont(loc)
	local t = {
	English = function()
		
		font = {}

		font.smallfont = love.graphics.newFont('oldsansblack.ttf',15)
		font.imagebuttonfont = love.graphics.newFont('oldsansblack.ttf',20)
		pn = love.graphics.print
		function pfn(text,x,y,limit,align)
			if limit==0 then limit = 999999 end
			limit = limit or 999999
			align = align or 'left'
			love.graphics.printf(text,x,y,limit,align)
		end
		sfn = love.graphics.setFont
		
		function fontGetWrap(font,text,width)
			return font:getWrap(text,width)
		end
	end,
	['Simplified Chinese'] = function()
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
			if limit==0 then limit = 9999999 end
			align = align or 'left'
			
			local f = love.graphics.getFont()
--			if f and f:getWidth(text) > limit then print (f:getWidth(text)) end
			if not f or f:getWidth(text) <= limit then
				love.graphics.printf(text,x,y,limit,align)
			else
				local len = #text
				local lines = math.ceil(len/3/(limit/fw))
				if lines < 1 then
					love.graphics.printf(text,x,y,limit,align)
					return
				end
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
			local f = font
			if f:getWidth(text) <= width then
				return f:getWrap(text,width)
			else
				local len = #text
				return width,math.ceil(len/3/width*fw)
			end
		end
	end,}
	t[loc]()
end

local localization = {}
function localization.getAvailableLanguage()
	return {'English','Simplified Chinese'}
end

function localization.setLocalization(loc)
	
	if loc == 'English' then 
		
		function LocalizedString(str)
			return str
		end
	else
		l = require('localization.'..loc)
		function LocalizedString(str)
			return l[str] or str
		end
	end
	switchfont(loc)
end

return localization