local optionmenu = {}
function optionmenu:load()
	local frame1 = loveframes.Create("frame")
	frame1:SetName("OPTIONS")
	frame1:SetSize(500, 300)
	frame1:Center()
	
	frame1:SetAlwaysUpdate(true)
	frame1.Update = function(object,dt)
--		object:MakeTop()
	end
	
	local tabs1 = loveframes.Create("tabs", frame1)
	tabs1:SetPos(5, 30)
	tabs1:SetSize(490, 265)
	
	local gameplaypanel = loveframes.Create"panel"
	function gameplaypanel.Draw() end
	
	local text1 = loveframes.Create("text", gameplaypanel)
	text1:SetText("GAMEPLAY STUFF HERE")
	text1:SetAlwaysUpdate(true)
	text1.Update = function(object, dt)
		object:Center()
	end
	tabs1:AddTab(LocalizedString"GAMEPLAY", gameplaypanel)
	
	local graphicspanel = loveframes.Create"panel"
	function graphicspanel.Draw() end
	local g = require 'gamesystem.graphics'
	g.load()
	local multichoice1 = loveframes.Create("multichoice", graphicspanel)
	multichoice1:SetPos(5, 50)
	
	local text1 = loveframes.Create("text", graphicspanel)
	text1:SetText(LocalizedString"RESOLUTION")
	text1:SetPos(5,30)
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
		gamesystem:reset()
		frame1:MakeTop()
	end
	
	local checkbox1 = loveframes.Create("checkbox", graphicspanel)
	checkbox1:SetText({{255,255,255},LocalizedString"V SYNC"})
	checkbox1:SetPos(5, 90)
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
	checkbox2:SetPos(5, 120)
	checkbox2.OnChanged = function(object2,check)
		option.seperateUI = check
	end
	
	
	checkbox2.tooltip = tooltip:new(checkbox2, LocalizedString'Limit the refresh rate for user interface to 30 FPS. Improves game speed.')
	checkbox2.tooltip:SetFollowCursor(false)
	checkbox2.tooltip:SetOffsets(0, -5)
	
	checkbox2:SetChecked(option.seperateUI)
	
	tabs1:AddTab(LocalizedString"GRAPHICS", graphicspanel)
	
	-- 2nd coloumn
	
	local multichoice2 = loveframes.Create("multichoice", graphicspanel)
	multichoice2:SetPos(255, 50)
	
	local shader = require 'shader'
	local text2 = loveframes.Create("text", graphicspanel)
	text2:SetText(LocalizedString"SHADER QUALITY")
	text2:SetPos(255,30)
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
	end
	
	
	multichoice2.tooltip = tooltip:new(multichoice2, LocalizedString'Lower shader settings can drastically increase frame rate. Player may experience compatablity issue on Ultra settings.')
	multichoice2.tooltip:SetFollowCursor(false)
	multichoice2.tooltip:SetOffsets(0, -5)
	
	local multichoice3 = loveframes.Create("multichoice", graphicspanel)
	multichoice3:SetPos(255, 100)
	
	local essential = require 'essential'
	local text3 = loveframes.Create("text", graphicspanel)
	text3:SetText(LocalizedString"TEXTURE QUALITY")
	text3:SetPos(255,80)
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