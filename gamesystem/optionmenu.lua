local optionmenu = {}
local essential = require 'library.essential'
function optionmenu:load()
	local frame1 = loveframes.Create("frame")
	frame1:setName(LocalizedString"OPTIONS")
	frame1:setSize(500, 300)
	frame1:Center()
	
	frame1:SetAlwaysUpdate(true)
	frame1.Update = function(object,dt)
--		object:MakeTop()
	end
	
	local tabs1 = loveframes.Create("tabs", frame1)
	tabs1:setPos(5, 30)
	tabs1:setSize(490, 265)
	
	local gameplaypanel = loveframes.Create"panel"
	function gameplaypanel.Draw() end
	
	local languagechoice = loveframes.Create("multichoice", gameplaypanel)
	languagechoice:setPos(0, 50)
	
	local localization = require 'library.localization'
	local text0 = loveframes.Create("text", gameplaypanel)
	text0:SetText(LocalizedString"LANGUAGE")
	text0:setPos(0,30)
	local modes = localization.getAvailableLanguage()
	local cos_language = {}
	for i,v in ipairs(modes) do
		languagechoice:AddChoice(LocalizedString(v))
		cos_language[LocalizedString(v)] = v
	end
	languagechoice:SetChoice(LocalizedString(option.language))
	languagechoice.OnChoiceSelected = function(object,choice)
		option.language = cos_language[choice]
		essential.save()
	end
	
	languagechoice.tooltip = tooltip:new(languagechoice, LocalizedString'Language setting will take effect after restarting the game.',300)
	languagechoice.tooltip:SetFollowCursor(false)
	languagechoice.tooltip:SetOffsets(0, -5)
	tabs1:AddTab(LocalizedString'GAMEPLAY',gameplaypanel)
	
	
	local p = loveframes.Create("progressbar",gameplaypanel)
	p:setPos(380,45)
	p:setSize(220,15)
	p:SetMinMax(0,100)
	p:SetValue(80)
	p.bar_color = {0,255,0,200}
	p.EKG_image = requireImage'asset/interface/ekg_signal.png'
	p.EKG_center = 0.2
	p.EKG_range = 0.1
	p.EKG_image:setWrap('repeat','repeat')
	p.EKG_quad = love.graphics.newQuad(0,0,p:getWidth(),p.EKG_image:getHeight(),p.EKG_image:getWidth(),p.EKG_image:getHeight())

	local p = loveframes.Create("progressbar",gameplaypanel)
	p:setPos(380,62)
	p:setSize(200,15)
	p:SetMinMax(0,100)
	p:SetValue(80)
	p.bar_color = {255,0,0,200}
	
	local compass = loveframes.Create("compass",gameplaypanel)
	compass:setPos(300,0)
	compass:setSize(96,96)
	local graphicspanel = loveframes.Create"panel"
	function graphicspanel.Draw() end
	local g = require 'library.graphics'
	g.load()
	local multichoice1 = loveframes.Create("multichoice", graphicspanel)
	multichoice1:setPos(5, 50)
	
	local text1 = loveframes.Create("text", graphicspanel)
	text1:SetText(LocalizedString"RESOLUTION")
	text1:setPos(5,30)
	local modes = g.getAvailableResolution()
	local cor = {}
	for i,v in ipairs(modes) do
		local s
		if v.fullscreen then
			s = LocalizedString'Fullscreen'
		else
			s = LocalizedString'Windowed'
		end
		s = string.format(LocalizedString("%d * %d (%s)"),v.width,v.height,s)
		multichoice1:AddChoice(s)
		cor[s] = v
	end
	local w,h,fs = g.getArgument'width',g.getArgument'height',g.getArgument'fullscreen'
	local s
	if fs then
		s = LocalizedString'Fullscreen'
	else
		s = LocalizedString'Windowed'
	end
	multichoice1:SetChoice(string.format(LocalizedString("%d * %d (%s)"),w,h,s))
	
	multichoice1.OnChoiceSelected = function(object,choice)
		local v = cor[choice]
		g.setArgument('width',v.width)
		g.setArgument('height',v.height)
		g.setArgument('fullscreen',v.fullscreen)
		g.apply()
		if self.OnReset then
			coroutinemsg(coroutine.resume(coroutine.create(self.OnReset)))
		end
--		gamesys:reset()
		frame1:MakeTop()
	end
	
	local checkbox1 = loveframes.Create("checkbox", graphicspanel)
	checkbox1:SetText({{255,255,255},LocalizedString"V SYNC"})
	checkbox1:setPos(5, 90)
	checkbox1.OnChanged = function(object2,check)
		g.setArgument('vsync',check)
		g.apply()
	end
	checkbox1:SetChecked(g.getArgument'vsync')
	
	
	checkbox1.tooltip = tooltip:new(checkbox1, LocalizedString'Enable vertical sync. Prevents graphics tearing. Restricts the video card to producing frame rate no higher than the refresh rate of the monitor.',300)
	checkbox1.tooltip:SetFollowCursor(false)
	checkbox1.tooltip:SetOffsets(0, -5)
	
	local checkbox2 = loveframes.Create("checkbox", graphicspanel)
	checkbox2:SetText({{255,255,255},LocalizedString"LIMIT UI REDRAWS"})
	checkbox2:setPos(5, 120)
	checkbox2.OnChanged = function(object2,check)
		option.seperateUI = check
		
		essential.save()
	end
	
	
	checkbox2.tooltip = tooltip:new(checkbox2, LocalizedString'Limit the refresh rate for user interface to 30 FPS. Improves game speed.')
	checkbox2.tooltip:SetFollowCursor(false)
	checkbox2.tooltip:SetOffsets(0, -5)
	
	checkbox2:SetChecked(option.seperateUI)
	
	tabs1:AddTab(LocalizedString"GRAPHICS", graphicspanel)
	
	-- 2nd coloumn
	
	local multichoice2 = loveframes.Create("multichoice", graphicspanel)
	multichoice2:setPos(255, 50)
	
	local shader = require 'shader'
	local text2 = loveframes.Create("text", graphicspanel)
	text2:SetText(LocalizedString"SHADER QUALITY")
	text2:setPos(255,30)
	local modes = shader.getAvailableQuality()
	local cos_shader = {}
	for i,v in ipairs(modes) do
		multichoice2:AddChoice(LocalizedString(v))
		cos_shader[LocalizedString(v)] = v
	end
	multichoice2:SetChoice(LocalizedString(option.shaderquality))
	multichoice2.OnChoiceSelected = function(object,choice)
		option.shaderquality = cos_shader[choice]
		shader.setQuality()
		essential.save()
	end
	
	
	multichoice2.tooltip = tooltip:new(multichoice2, LocalizedString'Lower shader settings can drastically increase frame rate. Player may experience compatablity issue on Ultra settings.',300)
	multichoice2.tooltip:SetFollowCursor(false)
	multichoice2.tooltip:SetOffsets(0, -5)
	
	local multichoice3 = loveframes.Create("multichoice", graphicspanel)
	multichoice3:setPos(255, 100)
	
	local essential = require 'library.essential'
	local text3 = loveframes.Create("text", graphicspanel)
	text3:SetText(LocalizedString"TEXTURE QUALITY")
	text3:setPos(255,80)
	local modes = essential.getAvailableTextureQuality()
	for i,v in ipairs(modes) do
		option.texturequality = cos_shader[choice]
		multichoice3:AddChoice(LocalizedString(v))
	end
	
	multichoice3:SetChoice(LocalizedString(option.shaderquality))
	multichoice3.OnChoiceSelected = function(object,choice)
	end
end

return optionmenu