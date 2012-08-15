local l
local function switchfont(loc)
	local t = {
	English = function()
		
		font = {retina = {}}
		font.smallfont = gra.newFont('NeoSans.otf',14)
		font.imagebuttonfont = gra.newFont('NeoSans.otf',20)
		font.bigfont = gra.newFont('NeoSans.otf',50)
		font.retina[font.smallfont] = gra.newFont('NeoSans.otf',14*option.retina)
		font.retina[font.imagebuttonfont] = gra.newFont('NeoSans.otf',20*option.retina)
		font.retina[font.bigfont] = gra.newFont('NeoSans.otf',50*option.retina)
		pn = gra.print
		function pfn(text,x,y,limit,align)
			if limit==0 then limit = 999999 end
			limit = limit or 999999
			align = align or 'left'
			gra.printf(text,x,y,limit,align)
		end
		sfn = gra.setFont
		
		function fontGetWrap(font,text,width)
			return font:getWrap(text,width)
		end
	end,
	['Simplified Chinese'] = function()
		font = {retina={}}
		local f = 'simsun.ttc'
		font.smallfont = gra.newFont(f, 14)
		font.imagebuttonfont = gra.newFont(f,20)
		font.bigfont = gra.newFont(f,50)
		font.retina[font.smallfont] = gra.newFont(f,14*option.retina)
		font.retina[font.imagebuttonfont] = gra.newFont(f,20*option.retina)
		font.retina[font.bigfont] = gra.newFont(f,50*option.retina)
		local fontizes = {
			[font.imagebuttonfont] = 20,
			[font.smallfont] = 14,
			[font.bigfont] = 50,
		}
		local pf = gra.printf
		local fw = 25
		function pfn(text,x,y,limit,align)
			
			text = tostring(text)
			limit = limit or 9999999
			if limit==0 then limit = 9999999 end
			align = align or 'left'
			
			local f = gra.getFont()
--			if f and f:getWidth(text) > limit then print (f:getWidth(text)) end
			if not f or f:getWidth(text) <= limit then
				gra.printf(text,x,y,limit,align)
			else
				local len = #text
				local lines = math.ceil(len/3/(limit/fw))
				if lines < 1 then
					gra.printf(text,x,y,limit,align)
					return
				end
				local h = math.floor(limit/fw)
				for i=1,lines do
					local txt = string.sub(text,(h*(i-1))*3+1,3*h*i)
					gra.printf(txt,x,y+(i-1)*fw,limit,align)
				end
			end
		end
		pn = pfn
		local sf = gra.setFont
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