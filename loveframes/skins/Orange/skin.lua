--[[------------------------------------------------
	-- L�VE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- skin table
local skin = {}

-- skin info (you always need this in a skin)
skin.name = "Orange"
skin.author = "Nikolai Resokav"
skin.version = "1.0"

local smallfont = gra.newFont(10)
local imagebuttonfont = gra.newFont(15)
local bordercolor = {143, 143, 143, 255}

-- controls 
skin.controls = {}

-- frame
skin.controls.frame_border_color 					= bordercolor
skin.controls.frame_body_color 						= {255, 255, 255, 150}
skin.controls.frame_top_color						= {255, 153, 0, 255}
skin.controls.frame_name_color						= {255, 255, 255, 255}
skin.controls.frame_name_font						= smallfont

-- button
skin.controls.button_border_down_color				= bordercolor
skin.controls.button_border_nohover_color			= bordercolor
skin.controls.button_border_hover_color				= bordercolor
skin.controls.button_body_down_color				= {255, 173, 51, 255}
skin.controls.button_body_nohover_color				= {255, 255, 255, 255}
skin.controls.button_body_hover_color				= {255, 184, 77, 255}
skin.controls.button_text_down_color				= {255, 255, 255, 255}
skin.controls.button_text_nohover_color				= {0, 0, 0, 200}
skin.controls.button_text_hover_color				= {255, 255, 255, 255}
skin.controls.button_text_font 						= smallfont

-- image button
skin.controls.imagebutton_text_down_color			= {255, 255, 255, 255}
skin.controls.imagebutton_text_nohover_color		= {0, 0, 0, 200}
skin.controls.imagebutton_text_hover_color			= {255, 255, 255, 255}
skin.controls.imagebutton_text_font 				= imagebuttonfont

-- close button
skin.controls.closebutton_body_down_color			= {255, 255, 255, 255}
skin.controls.closebutton_body_nohover_color		= {255, 255, 255, 255}
skin.controls.closebutton_body_hover_color			= {255, 255, 255, 255}

-- progress bar
skin.controls.progressbar_border_color 				= bordercolor
skin.controls.progressbar_body_color 				= {255, 255, 255, 255}
skin.controls.progressbar_bar_color					= {0, 255, 0, 255}
skin.controls.progressbar_text_color				= {0, 0, 0, 255}
skin.controls.progressbar_text_font					= smallfont

-- list
skin.controls.list_border_color						= bordercolor
skin.controls.list_body_color 						= {232, 232, 232, 255}

-- scrollbar
skin.controls.scrollbar_border_down_color			= bordercolor
skin.controls.scrollbar_border_hover_color			= bordercolor
skin.controls.scrollbar_border_nohover_color		= bordercolor
skin.controls.scrollbar_body_down_color				= {255, 173, 51, 255}
skin.controls.scrollbar_body_nohover_color 			= {255, 255, 255, 255}
skin.controls.scrollbar_body_hover_color 			= {255, 184, 77, 255}

-- scrollarea
skin.controls.scrollarea_body_color 				= {200, 200, 200, 255}
skin.controls.scrollarea_border_color				= bordercolor

-- scrollbody
skin.controls.scrollbody_body_color					= {0, 0, 0, 0}

-- panel
skin.controls.panel_body_color 						= {232, 232, 232, 255}
skin.controls.panel_border_color					= bordercolor

-- tab panel
skin.controls.tabpanel_body_color 					= {232, 232, 232, 255}
skin.controls.tabpanel_border_color					= bordercolor

-- tab button
skin.controls.tab_border_nohover_color				= bordercolor
skin.controls.tab_border_hover_color				= bordercolor
skin.controls.tab_body_nohover_color				= {255, 255, 255, 255}
skin.controls.tab_body_hover_color					= {255, 173, 51, 255}
skin.controls.tab_text_nohover_color				= {0, 0, 0, 200}
skin.controls.tab_text_hover_color					= {255, 255, 255, 255}
skin.controls.tab_text_font 						= smallfont

-- multichoice
skin.controls.multichoice_body_color				= {240, 240, 240, 255}
skin.controls.multichoice_border_color				= bordercolor
skin.controls.multichoice_text_color				= {0, 0, 0, 255}
skin.controls.multichoice_text_font					= smallfont

-- multichoicelist
skin.controls.multichoicelist_body_color			= {240, 240, 240, 200}
skin.controls.multichoicelist_border_color			= bordercolor

-- multichoicerow
skin.controls.multichoicerow_body_nohover_color		= {240, 240, 240, 200}
skin.controls.multichoicerow_body_hover_color		= {255, 117, 26, 255}
skin.controls.multichoicerow_border_color			= {50, 50, 50, 255}
skin.controls.multichoicerow_text_nohover_color		= {0, 0, 0, 150}
skin.controls.multichoicerow_text_hover_color		= {255, 255, 255, 255}
skin.controls.multichoicerow_text_font				= smallfont

-- tooltip
skin.controls.tooltip_border_color					= bordercolor
skin.controls.tooltip_body_color					= {255, 255, 255, 255}
skin.controls.tooltip_text_color					= {0, 0, 0, 255}
skin.controls.tooltip_text_font						= smallfont

-- text input
skin.controls.textinput_border_color				= bordercolor
skin.controls.textinput_body_color					= {240, 240, 240, 255}
skin.controls.textinput_blinker_color				= {0, 0, 0, 255}

-- slider
skin.controls.slider_bar_color						= bordercolor
skin.controls.slider_bar_outline_color				= {220, 220, 220, 255}

-- checkbox
skin.controls.checkbox_border_color					= bordercolor
skin.controls.checkbox_body_color					= {255, 255, 255, 255}
skin.controls.checkbox_check_color					= {255, 173, 51, 255}
skin.controls.checkbox_text_color					= {0, 0, 0, 255}
skin.controls.checkbox_text_font					= smallfont

-- collapsiblecategory
skin.controls.collapsiblecategory_text_color		= {0, 0, 0, 255}
skin.controls.collapsiblecategory_body_color		= {255, 255, 255, 255}
skin.controls.collapsiblecategory_border_color		= bordercolor

-- columnlist
skin.controls.columnlist_border_color				= bordercolor
skin.controls.columnlist_body_color					= {232, 232, 232, 255}

-- columlistarea
skin.controls.columnlistarea_border_color			= bordercolor
skin.controls.columnlistarea_body_color				= {232, 232, 232, 255}

-- columnlistheader
skin.controls.columnlistheader_border_down_color	= bordercolor
skin.controls.columnlistheader_border_nohover_color	= bordercolor
skin.controls.columnlistheader_border_hover_color	= bordercolor
skin.controls.columnlistheader_body_down_color		= {255, 173, 51, 255}
skin.controls.columnlistheader_body_nohover_color	= {255, 255, 255, 255}
skin.controls.columnlistheader_body_hover_color		= {255, 184, 77, 255}
skin.controls.columnlistheader_text_down_color		= {255, 255, 255, 255}
skin.controls.columnlistheader_text_nohover_color	= {0, 0, 0, 200}
skin.controls.columnlistheader_text_hover_color		= {255, 255, 255, 255}
skin.controls.columnlistheader_text_font 			= smallfont

-- columnlistrow
skin.controls.columnlistrow_border1_color			= bordercolor
skin.controls.columnlistrow_body1_color				= {232, 232, 232, 255}
skin.controls.columnlistrow_border2_color			= bordercolor
skin.controls.columnlistrow_body2_color				= {200, 200, 200, 255}

-- modalbackground
skin.controls.modalbackground_body_color			= {255, 255, 255, 100}

--[[---------------------------------------------------------
	- func: OutlinedRectangle(object)
	- desc: creates and outlined rectangle
--]]---------------------------------------------------------
function skin.OutlinedRectangle(x, y, width, height, ovt, ovb, ovl, ovr)

	local ovt = ovt or false
	local ovb = ovb or false
	local ovl = ovl or false
	local ovr = ovr or false
	
	-- top
	if ovt == false then
		gra.rectangle("fill", x, y, width, 1)
	end
	
	-- bottom
	if ovb == false then
		gra.rectangle("fill", x, y + height - 1, width, 1)
	end
	
	-- left
	if ovl == false then
		gra.rectangle("fill", x, y, 1, height)
	end
	
	-- right
	if ovr == false then
		gra.rectangle("fill", x + width - 1, y, 1, height)
	end
	
end

--[[---------------------------------------------------------
	- func: DrawRepeatingImage(image, x, y, width, height)
	- desc: draw a repeating image a box
--]]---------------------------------------------------------
function skin.DrawRepeatingImage(image, x, y, width, height)

	local image = gra.newImage(image)
	local iwidth = image:getWidth()
	local iheight = image:getHeight()
	local cords = {}
	local posx = 0
	local posy = 0
	local stencilfunc = function() gra.rectangle("fill", x, y, width, height) end
	local stencil = gra.newStencil(stencilfunc)
	
	while posy < height do
	
		table.insert(cords, {posx, posy})
		
		if posx >= width then
			posx = 0
			posy = posy + iheight
		else
			posx = posx + iwidth
		end
		
	end
	
	gra.setStencil(stencil)
	
	for k, v in ipairs(cords) do
		gra.setColor(255, 255, 255, 255)
		gra.draw(image, x + v[1], y + v[2])
	end
	
	gra.setStencil()
	
end

--[[---------------------------------------------------------
	- func: skin.DrawGradient(x, y, width, height, 
			direction, color, colormod)
	- desc: draws a gradient
--]]---------------------------------------------------------
function skin.DrawGradient(x, y, width, height, direction, color, colormod)

	local color = color
	local colormod = colormod or 0
	local percent = 0
	local once = false
		
	if direction == "up" then
	
		for i=1, height - 1 do
			percent = i/height * 255
			color = {color[1], color[2], color[3], loveframes.util.Round(percent)}
			gra.setColor(unpack(color))
			gra.rectangle("fill", x, y + i, width, 1)
		end
	
	end
	
end

--[[---------------------------------------------------------
	- func: DrawFrame(object)
	- desc: draws the frame object
--]]---------------------------------------------------------
function skin.DrawFrame(object)

	local gradientcolor = {}
	
	-- frame body
	gra.setColor(unpack(skin.controls.frame_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
	-- frame top bar
	gra.setColor(unpack(skin.controls.frame_top_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), 25)
	
	gradientcolor = {skin.controls.frame_top_color[1] - 20, skin.controls.frame_top_color[2] - 20, 0, 255}
	skin.DrawGradient(object:getX(), object:getY(), object:getWidth(), 25, "up", gradientcolor)
	
	gra.setColor(unpack(skin.controls.frame_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY() + 25, object:getWidth(), 1)
	
	-- frame name section
	sfn(skin.controls.frame_name_font)
	gra.setColor(unpack(skin.controls.frame_name_color))
	pn(object.name, object:getX() + 5, object:getY() + 5)
	
	-- frame border
	gra.setColor(unpack(skin.controls.frame_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())

end

--[[---------------------------------------------------------
	- func: DrawButton(object)
	- desc: draws the button object
--]]---------------------------------------------------------
function skin.DrawButton(object)

	local index	= loveframes.config["ACTIVESKIN"]
	local font = skin.controls.button_text_font
	local twidth = font:getWidth(object.text)
	local theight = font:getHeight(object.text)
	local hover = object.hover
	local down = object.down
	local gradientcolor = {}
	
	if down == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_down_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_down_color[1] - 20, skin.controls.button_body_down_color[2] - 20, skin.controls.button_body_down_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button text
		sfn(skin.controls.button_text_font)
		gra.setColor(unpack(skin.controls.button_text_down_color))
		pn(object.text, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	elseif hover == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_hover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_hover_color[1] - 20, skin.controls.button_body_hover_color[2] - 20, skin.controls.button_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button text
		sfn(skin.controls.button_text_font)
		gra.setColor(unpack(skin.controls.button_text_hover_color))
		pn(object.text, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	else
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_nohover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_nohover_color[1] - 20, skin.controls.button_body_nohover_color[2] - 20, skin.controls.button_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button text
		sfn(skin.controls.button_text_font)
		gra.setColor(unpack(skin.controls.button_text_nohover_color))
		pn(object.text, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	end

end

--[[---------------------------------------------------------
	- func: DrawCloseButton(object)
	- desc: draws the close button object
--]]---------------------------------------------------------
function skin.DrawCloseButton(object)

	local index	= loveframes.config["ACTIVESKIN"]
	local font = skin.controls.button_text_font
	local twidth = font:getWidth("X")
	local theight = font:getHeight("X")
	local hover = object.hover
	local down = object.down
	local image = skin.images["close.png"]
	local gradientcolor = {}
	
	if down == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.closebutton_body_down_color))
		gra.draw(image, object:getX(), object:getY())
		
	elseif hover == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.closebutton_body_hover_color))
		gra.draw(image, object:getX(), object:getY())
		
	else
			
		-- button body
		gra.setColor(unpack(skin.controls.closebutton_body_nohover_color))
		gra.draw(image, object:getX(), object:getY())
		
	end
	
end

--[[---------------------------------------------------------
	- func: DrawImage(object)
	- desc: draws the image object
--]]---------------------------------------------------------
function skin.DrawImage(object)
	
	local image = object.image
	local color = object.imagecolor
	
	if color then
		gra.setColor(unpack(color))
		gra.draw(image)
	else
		gra.setColor(255, 255, 255, 255)
		gra.draw(image, object:getX(), object:getY())
	end
	
end

--[[---------------------------------------------------------
	- func: DrawImageButton(object)
	- desc: draws the image button object
--]]---------------------------------------------------------

function skin.DrawImageButton(object)

	local index	= loveframes.config["ACTIVESKIN"]
	local font = skin.controls.imagebutton_text_font
	local twidth = font:getWidth(object.text)
	local theight = font:getHeight(object.text)
	local hover = object.hover
	local down = object.down
	local image = object:GetImage()
	
	if down == true then
	
		if image ~= false then
			gra.setColor(255, 255, 255, 255)
			gra.draw(image, object:getX() + 1, object:getY() + 1)
		end
		
		sfn(font)
		gra.setColor(0, 0, 0, 255)
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2 + 1, object:getY() + object:getHeight() - theight - 5 + 1)
		gra.setColor(unpack(skin.controls.imagebutton_text_down_color))
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2 + 1, object:getY() + object:getHeight() - theight - 6 + 1)
		
	elseif hover == true then
	
		if image ~= false then
			gra.setColor(255, 255, 255, 255)
			gra.draw(image, object:getX(), object:getY())
		end
		
		sfn(font)
		gra.setColor(0, 0, 0, 255)
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight() - theight - 5)
		gra.setColor(unpack(skin.controls.imagebutton_text_hover_color))
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight() - theight - 6)
		
	else
		
		if image ~= false then
			gra.setColor(255, 255, 255, 255)
			gra.draw(image, object:getX(), object:getY())
		end
		
		sfn(font)
		gra.setColor(0, 0, 0, 255)
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight() - theight - 5)
		gra.setColor(unpack(skin.controls.imagebutton_text_down_color))
		pn(object:GetText(), object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight() - theight - 6)
		
	end

end

--[[---------------------------------------------------------
	- func: DrawProgressBar(object)
	- desc: draws the progress bar object
--]]---------------------------------------------------------
function skin.DrawProgressBar(object)

	local font = skin.controls.progressbar_text_font
	local twidth = font:getWidth(object.value .. "/" ..object.max)
	local theight = font:getHeight(object.value .. "/" ..object.max)
	local gradientcolor = {}
	
	-- progress bar body
	gra.setColor(unpack(skin.controls.progressbar_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	gra.setColor(unpack(skin.controls.progressbar_bar_color))
	gra.rectangle("fill", object:getX(), object:getY(), object.progress, object:getHeight())
	gradientcolor = {skin.controls.progressbar_bar_color[1], skin.controls.progressbar_bar_color[2] - 20, skin.controls.progressbar_bar_color[3], 255}
	skin.DrawGradient(object:getX(), object:getY(), object.progress, object:getHeight(), "up", gradientcolor)
	sfn(font)
	gra.setColor(unpack(skin.controls.progressbar_text_color))
	pn(object.value .. "/" ..object.max, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
	
	-- progress bar border
	gra.setColor(unpack(skin.controls.progressbar_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
end

--[[---------------------------------------------------------
	- func: DrawScrollArea(object)
	- desc: draws the scroll area object
--]]---------------------------------------------------------
function skin.DrawScrollArea(object)

	gra.setColor(unpack(skin.controls.scrollarea_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	gra.setColor(unpack(skin.controls.scrollarea_border_color))
	
	if object.bartype == "vertical" then
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight(), true, true)
	elseif object.bartype == "horizontal" then
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight(), false, false, true, true)
	end
	
end

--[[---------------------------------------------------------
	- func: DrawScrollBar(object)
	- desc: draws the scroll bar object
--]]---------------------------------------------------------
function skin.DrawScrollBar(object)

	local gradientcolor = {}

	if object.dragging == true then
		gra.setColor(unpack(skin.controls.scrollbar_body_down_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		gradientcolor = {skin.controls.scrollbar_body_down_color[1] - 20, skin.controls.scrollbar_body_down_color[2] - 20, skin.controls.scrollbar_body_down_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY(), object:getWidth(), object:getHeight(), "up", gradientcolor)
		gra.setColor(unpack(skin.controls.scrollbar_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	elseif object.hover == true then
		gra.setColor(unpack(skin.controls.scrollbar_body_hover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		gradientcolor = {skin.controls.scrollbar_body_hover_color[1] - 20, skin.controls.scrollbar_body_hover_color[2] - 20, skin.controls.scrollbar_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY(), object:getWidth(), object:getHeight(), "up", gradientcolor)
		gra.setColor(unpack(skin.controls.scrollbar_border_hover_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	else
		gra.setColor(unpack(skin.controls.scrollbar_body_nohover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		gradientcolor = {skin.controls.scrollbar_body_nohover_color[1] - 20, skin.controls.scrollbar_body_nohover_color[2] - 20, skin.controls.scrollbar_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY(), object:getWidth(), object:getHeight(), "up", gradientcolor)
		gra.setColor(unpack(skin.controls.scrollbar_border_nohover_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	end
	
	if object.bartype == "vertical" then
		gra.setColor(unpack(skin.controls.scrollbar_border_nohover_color))
		gra.rectangle("fill", object:getX() + 3, object:getY() + object:getHeight()/2 - 3, object:getWidth() - 6, 1)
		gra.rectangle("fill", object:getX() + 3, object:getY() + object:getHeight()/2, object:getWidth() - 6, 1)
		gra.rectangle("fill", object:getX() + 3, object:getY() + object:getHeight()/2 + 3, object:getWidth() - 6, 1)
	else
		gra.setColor(unpack(skin.controls.scrollbar_border_nohover_color))
		gra.rectangle("fill", object:getX() + object:getWidth()/2 - 3, object:getY() + 3, 1, object:getHeight() - 6)
		gra.rectangle("fill", object:getX() + object:getWidth()/2, object:getY() + 3, 1, object:getHeight() - 6)
		gra.rectangle("fill", object:getX() + object:getWidth()/2 + 3, object:getY() + 3, 1, object:getHeight() - 6)
	end
	
end

--[[---------------------------------------------------------
	- func: DrawScrollBody(object)
	- desc: draws the scroll body object
--]]---------------------------------------------------------
function skin.DrawScrollBody(object)

	gra.setColor(unpack(skin.controls.scrollbody_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())

end

--[[---------------------------------------------------------
	- func: DrawPanel(object)
	- desc: draws the panel object
--]]---------------------------------------------------------
function skin.DrawPanel(object)

	gra.setColor(unpack(skin.controls.panel_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	gra.setColor(unpack(skin.controls.panel_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: DrawList(object)
	- desc: draws the list object
--]]---------------------------------------------------------
function skin.DrawList(object)

	gra.setColor(unpack(skin.controls.list_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
end

--[[---------------------------------------------------------
	- func: DrawList(object)
	- desc: used to draw over the object and it's children
--]]---------------------------------------------------------
function skin.DrawOverList(object)

	gra.setColor(unpack(skin.controls.list_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: DrawTabPanel(object)
	- desc: draws the tab panel object
--]]---------------------------------------------------------
function skin.DrawTabPanel(object)

	local buttonheight = object:getHeightOfButtons()
	
	gra.setColor(unpack(skin.controls.tabpanel_body_color))
	gra.rectangle("fill", object:getX(), object:getY() + buttonheight, object:getWidth(), object:getHeight() - buttonheight)
	gra.setColor(unpack(skin.controls.tabpanel_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY() + buttonheight - 1, object:getWidth(), object:getHeight() - buttonheight + 2)
	
	object:SetScrollButtonSize(15, buttonheight)

end

--[[---------------------------------------------------------
	- func: DrawTabButton(object)
	- desc: draws the tab button object
--]]---------------------------------------------------------
function skin.DrawTabButton(object)

	local index	= loveframes.config["ACTIVESKIN"]
	local font = skin.controls.tab_text_font
	local twidth = font:getWidth(object.text)
	local theight = font:getHeight(object.text)
	local hover = object.hover
	local activetab = object.activetab
	local image = object.image
	local gradientcolor = {}
	
	local imagewidth
	local imageheight
	
	if image then
		imagewidth = image:getWidth()
		imageheight = image:getHeight()
	end
			
	if object.tabnumber == object.parent.tab then
			
		-- button body
		gra.setColor(unpack(skin.controls.tab_body_hover_color))
		gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
		gradientcolor = {skin.controls.tab_body_hover_color[1] - 20, skin.controls.tab_body_hover_color[2] - 20, skin.controls.tab_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		gra.setColor(unpack(skin.controls.tabpanel_border_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
				
		if image then
			-- button image
			gra.setColor(255, 255, 255, 255)
			gra.draw(image, object:getX() + 5, object:getY() + object:getHeight()/2 - imageheight/2)
			-- button text
			sfn(skin.controls.tab_text_font)
			gra.setColor(unpack(skin.controls.tab_text_hover_color))
			pn(object.text, object:getX() + imagewidth + 10, object:getY() + object:getHeight()/2 - theight/2)
		else
			-- button text
			sfn(skin.controls.tab_text_font)
			gra.setColor(unpack(skin.controls.tab_text_hover_color))
			pn(object.text, object:getX() + 5, object:getY() + object:getHeight()/2 - theight/2)
		end
				
	else
				
		-- button body
		gra.setColor(unpack(skin.controls.tab_body_nohover_color))
		gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
		gradientcolor = {skin.controls.tab_body_nohover_color[1] - 20, skin.controls.tab_body_nohover_color[2] - 20, skin.controls.tab_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		gra.setColor(unpack(skin.controls.tabpanel_border_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
				
		if image then
			-- button image
			gra.setColor(255, 255, 255, 150)
			gra.draw(image, object:getX() + 5, object:getY() + object:getHeight()/2 - imageheight/2)
			-- button text
			sfn(skin.controls.tab_text_font)
			gra.setColor(unpack(skin.controls.tab_text_nohover_color))
			pn(object.text, object:getX() + imagewidth + 10, object:getY() + object:getHeight()/2 - theight/2)
		else
			-- button text
			sfn(skin.controls.tab_text_font)
			gra.setColor(unpack(skin.controls.tab_text_nohover_color))
			pn(object.text, object:getX() + 5, object:getY() + object:getHeight()/2 - theight/2)
		end
				
	end

end

--[[---------------------------------------------------------
	- func: DrawMultiChoice(object)
	- desc: draws the multi choice object
--]]---------------------------------------------------------
function skin.DrawMultiChoice(object)
	
	local image = skin.images["multichoice-arrow.png"]
	
	gra.setColor(unpack(skin.controls.multichoice_body_color))
	gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
	
	gra.setColor(skin.controls.multichoice_text_color)
	sfn(skin.controls.multichoice_text_font)
	
	local h = smallfont:getHeight()
	
	if object.choice == "" then
		pn(object.text, object:getX() + 5, object:getY() + object:getHeight()/2 - h/2)
	else
		pn(object.choice, object:getX() + 5, object:getY() + object:getHeight()/2 - h/2)
	end
	
	gra.setColor(255, 255, 255, 255)
	gra.draw(image, object:getX() + object:getWidth() - 20, object:getY() + 5)
	
	gra.setColor(unpack(skin.controls.multichoice_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: DrawMultiChoiceList(object)
	- desc: draws the multi choice list object
--]]---------------------------------------------------------
function skin.DrawMultiChoiceList(object)
	
	gra.setColor(unpack(skin.controls.multichoicelist_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: DrawOverMultiChoiceList(object)
	- desc: draws over the multi choice list object
--]]---------------------------------------------------------
function skin.DrawOverMultiChoiceList(object)

	gra.setColor(unpack(skin.controls.multichoicelist_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight() + 1)
	
end

--[[---------------------------------------------------------
	- func: DrawMultiChoiceRow(object)
	- desc: draws the multi choice row object
--]]---------------------------------------------------------
function skin.DrawMultiChoiceRow(object)
	
	sfn(skin.controls.multichoicerow_text_font)
	
	if object.hover == true then
		gra.setColor(unpack(skin.controls.multichoicerow_body_hover_color))
		gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
		gra.setColor(unpack(skin.controls.multichoicerow_text_hover_color))
		pn(object.text, object:getX() + 5, object:getY() + 5)
	else
		gra.setColor(unpack(skin.controls.multichoicerow_body_nohover_color))
		gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
		gra.setColor(unpack(skin.controls.multichoicerow_text_nohover_color))
		pn(object.text, object:getX() + 5, object:getY() + 5)
	end
	
end

--[[---------------------------------------------------------
	- func: DrawToolTip(object)
	- desc: draws the tool tip object
--]]---------------------------------------------------------
function skin.DrawToolTip(object)
		
	gra.setColor(unpack(skin.controls.tooltip_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	gra.setColor(unpack(skin.controls.tooltip_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	gra.setColor(unpack(skin.controls.tooltip_text_color))
	
end

--[[---------------------------------------------------------
	- func: DrawText(object)
	- desc: draws the text object
--]]---------------------------------------------------------
function skin.DrawText(object)
	
end

--[[---------------------------------------------------------
	- func: DrawTextInput(object)
	- desc: draws the text input object
--]]---------------------------------------------------------
function skin.DrawTextInput(object)

	local height = object.font:getHeight("a")
	local twidth = object.font:getWidth(object.text)
	local focus = object:GetFocus()
	local showblink = object:GetBlinkerVisibility()
	
	gra.setColor(unpack(skin.controls.textinput_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
	object:setTextOffsetY(object:getHeight()/2 - height/2)
	
	if object.xoffset ~= 0 then
		object:setTextOffsetX(-5)
	else
		object:setTextOffsetX(5)
	end
	
	if showblink == true and focus == true then
	
		gra.setColor(unpack(skin.controls.textinput_blinker_color))
		
		if object.xoffset ~= 0 then
			gra.rectangle("fill", object.blinkx, object.blinky, 1, height)
		else
			gra.rectangle("fill", object.blinkx, object.blinky, 1, height)
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: DrawOverTextInput(object)
	- desc: draws over the text input object
--]]---------------------------------------------------------
function skin.DrawOverTextInput(object)

	gra.setColor(unpack(skin.controls.textinput_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: DrawScrollButton(object)
	- desc: draws the scroll button object
--]]---------------------------------------------------------
function skin.DrawScrollButton(object)

	local hover = object.hover
	local down = object.down
	local gradientcolor = {}
	
	if down == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_down_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_down_color[1] - 20, skin.controls.button_body_down_color[2] - 20, skin.controls.button_body_down_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	elseif hover == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_hover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_hover_color[1] - 20, skin.controls.button_body_hover_color[2] - 20, skin.controls.button_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	else
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_nohover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_nohover_color[1] - 20, skin.controls.button_body_nohover_color[2] - 20, skin.controls.button_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	end
	
	if object.scrolltype == "up" then
		local image = skin.images["arrow-up.png"]
		if object.hover == true then
			gra.setColor(255, 255, 255, 255)
		else
			gra.setColor(255, 255, 255, 150)
		end
		gra.draw(image, object:getX() + object:getWidth()/2 - image:getWidth()/2, object:getY() + object:getHeight()/2 - image:getHeight()/2)
	elseif object.scrolltype == "down" then
		local image = skin.images["arrow-down.png"]
		if object.hover == true then
			gra.setColor(255, 255, 255, 255)
		else
			gra.setColor(255, 255, 255, 150)
		end
		gra.draw(image, object:getX() + object:getWidth()/2 - image:getWidth()/2, object:getY() + object:getHeight()/2 - image:getHeight()/2)
	elseif object.scrolltype == "left" then
		local image = skin.images["arrow-left.png"]
		if object.hover == true then
			gra.setColor(255, 255, 255, 255)
		else
			gra.setColor(255, 255, 255, 150)
		end
		gra.draw(image, object:getX() + object:getWidth()/2 - image:getWidth()/2, object:getY() + object:getHeight()/2 - image:getHeight()/2)
	elseif object.scrolltype == "right" then
		local image = skin.images["arrow-right.png"]
		if object.hover == true then
			gra.setColor(255, 255, 255, 255)
		else
			gra.setColor(255, 255, 255, 150)
		end
		gra.draw(image, object:getX() + object:getWidth()/2 - image:getWidth()/2, object:getY() + object:getHeight()/2 - image:getHeight()/2)
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawSlider(object)
	- desc: draws the slider object
--]]---------------------------------------------------------
function skin.DrawSlider(object)
	
	if object.slidetype == "horizontal" then
		
		gra.setColor(unpack(skin.controls.slider_bar_outline_color))
		gra.rectangle("fill", object:getX(), object:getY() + object:getHeight()/2 - 5, object:getWidth(), 10)
		
		gra.setColor(unpack(skin.controls.slider_bar_color))
		gra.rectangle("fill", object:getX() + 5, object:getY() + object:getHeight()/2, object:getWidth() - 10, 1)
		
	elseif object.slidetype == "vertical" then
		
		gra.setColor(unpack(skin.controls.slider_bar_outline_color))
		gra.rectangle("fill", object:getX() + object:getWidth()/2 - 5, object:getY(), 10, object:getHeight())
		
		gra.setColor(unpack(skin.controls.slider_bar_color))
		gra.rectangle("fill", object:getX() + object:getWidth()/2, object:getY() + 5, 1, object:getHeight() - 10)
		
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawSliderButton(object)
	- desc: draws the slider button object
--]]---------------------------------------------------------
function skin.DrawSliderButton(object)

	local index	= loveframes.config["ACTIVESKIN"]
	local hover = object.hover
	local down = object.down
	local gradientcolor = {}
	
	if down == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_down_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_down_color[1] - 20, skin.controls.button_body_down_color[2] - 20, skin.controls.button_body_down_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	elseif hover == true then
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_hover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_hover_color[1] - 20, skin.controls.button_body_hover_color[2] - 20, skin.controls.button_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	else
			
		-- button body
		gra.setColor(unpack(skin.controls.button_body_nohover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.button_body_nohover_color[1] - 20, skin.controls.button_body_nohover_color[2] - 20, skin.controls.button_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- button border
		gra.setColor(unpack(skin.controls.button_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawCheckBox(object)
	- desc: draws the check box object
--]]---------------------------------------------------------
function skin.DrawCheckBox(object)
	
	local font = smallfont
	local linesize = (1 * (object.boxwidth * 0.05))
	local checked = object.checked
	local height = font:getHeight()
	local gradientcolor = {}
	
	gra.setColor(unpack(skin.controls.checkbox_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object.boxwidth, object.boxheight)
	
	gra.setColor(unpack(skin.controls.checkbox_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object.boxwidth, object.boxheight)
	
	if checked == true then
	
			gra.setColor(unpack(skin.controls.checkbox_check_color))
		gra.rectangle("fill", object:getX() + 4, object:getY() + 4, object.boxwidth - 8, object.boxheight - 8)
	
		gradientcolor = {skin.controls.checkbox_check_color[1] - 20, skin.controls.checkbox_check_color[2] - 20, skin.controls.checkbox_check_color[3] - 20, 255}
		skin.DrawGradient(object:getX() + 4, object:getY() + 4, object.boxwidth - 8, object.boxheight - 8, "up", gradientcolor)
		
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawCollapsibleCategory(object)
	- desc: draws the collapsible category object
--]]---------------------------------------------------------
function skin.DrawCollapsibleCategory(object)
	
	local font = smallfont
	local gradientcolor = {skin.controls.collapsiblecategory_body_color[1] - 20, skin.controls.collapsiblecategory_body_color[2] - 20, skin.controls.collapsiblecategory_body_color[3] - 20, 255}
	
	gra.setColor(unpack(skin.controls.collapsiblecategory_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
	gra.setColor(unpack(gradientcolor))
	skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
	
	gra.setColor(unpack(skin.controls.collapsiblecategory_text_color))
	pn(object.text, object:getX() + 5, object:getY() + 5)
	
	gra.setColor(unpack(skin.controls.collapsiblecategory_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: skin.DrawColumnList(object)
	- desc: draws the column list object
--]]---------------------------------------------------------
function skin.DrawColumnList(object)
	
	gra.setColor(unpack(skin.controls.columnlist_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: skin.DrawColumnListHeader(object)
	- desc: draws the column list header object
--]]---------------------------------------------------------
function skin.DrawColumnListHeader(object)
	
	local font = skin.controls.columnlistheader_text_font
	local twidth = font:getWidth(object.name)
	local theight = font:getHeight(object.name)
	local hover = object.hover
	local down = object.down
	local gradientcolor = {}
	
	if down == true then
			
		-- header body
		gra.setColor(unpack(skin.controls.columnlistheader_body_down_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.columnlistheader_body_down_color[1] - 20, skin.controls.columnlistheader_body_down_color[2] - 20, skin.controls.columnlistheader_body_down_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- header name
		sfn(font)
		gra.setColor(unpack(skin.controls.columnlistheader_text_down_color))
		pn(object.name, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- header border
		gra.setColor(unpack(skin.controls.columnlistheader_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	elseif hover == true then
			
		-- header body
		gra.setColor(unpack(skin.controls.columnlistheader_body_hover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.columnlistheader_body_hover_color[1] - 20, skin.controls.columnlistheader_body_hover_color[2] - 20, skin.controls.columnlistheader_body_hover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- header name
		sfn(font)
		gra.setColor(unpack(skin.controls.columnlistheader_text_hover_color))
		pn(object.name, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- header border
		gra.setColor(unpack(skin.controls.columnlistheader_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	else
			
		-- header body
		gra.setColor(unpack(skin.controls.columnlistheader_body_nohover_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gradientcolor = {skin.controls.columnlistheader_body_nohover_color[1] - 20, skin.controls.columnlistheader_body_nohover_color[2] - 20, skin.controls.columnlistheader_body_nohover_color[3] - 20, 255}
		skin.DrawGradient(object:getX(), object:getY() - 1, object:getWidth(), object:getHeight(), "up", gradientcolor)
		
		-- header name
		sfn(font)
		gra.setColor(unpack(skin.controls.button_text_nohover_color))
		pn(object.name, object:getX() + object:getWidth()/2 - twidth/2, object:getY() + object:getHeight()/2 - theight/2)
		
		-- header border
		gra.setColor(unpack(skin.controls.columnlistheader_border_down_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawColumnListArea(object)
	- desc: draws the column list area object
--]]---------------------------------------------------------
function skin.DrawColumnListArea(object)
	
	gra.setColor(unpack(skin.controls.columnlistarea_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: skin.DrawOverColumnListArea(object)
	- desc: draws over the column list area object
--]]---------------------------------------------------------
function skin.DrawOverColumnListArea(object)

	gra.setColor(unpack(skin.controls.columnlist_border_color))
	skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

--[[---------------------------------------------------------
	- func: skin.DrawColumnListRow(object)
	- desc: draws the column list row object
--]]---------------------------------------------------------
function skin.DrawColumnListRow(object)
	
	local colorindex = object:GetColorIndex()
	local font = object:GetFont()
	local height = font:getHeight("a")
	
	object:setTextPos(5, object:getHeight()/2 - height/2)
	object:setTextColor(bordercolor)
	
	if colorindex == 1 then
	
		gra.setColor(unpack(skin.controls.columnlistrow_body1_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gra.setColor(unpack(skin.controls.columnlistrow_border1_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
		
	else
	
		gra.setColor(unpack(skin.controls.columnlistrow_body2_color))
		gra.rectangle("fill", object:getX() + 1, object:getY() + 1, object:getWidth() - 2, object:getHeight() - 2)
		
		gra.setColor(unpack(skin.controls.columnlistrow_border2_color))
		skin.OutlinedRectangle(object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
	end
	
end

--[[---------------------------------------------------------
	- func: skin.DrawModalBackground(object)
	- desc: draws the modal background object
--]]---------------------------------------------------------
function skin.DrawModalBackground(object)

	gra.setColor(unpack(skin.controls.modalbackground_body_color))
	gra.rectangle("fill", object:getX(), object:getY(), object:getWidth(), object:getHeight())
	
end

-- register the skin
loveframes.skins.Register(skin)