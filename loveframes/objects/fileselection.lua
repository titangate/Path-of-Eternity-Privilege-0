--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- frame class
require 'loveframes.objects.frame'
fileselection = class("frame", frame)
fileselection:include(loveframes.templates.default)
local function horzBar(parent,image,text,width,height)
	local l = loveframes.Create('list',parent)
	function l.Draw() end
	l.spacing = 10
	l:setSize(width,height)
	l.button = loveframes.Create('circlebutton',l)
	l.button:setImage(image)
	l.button:setSize(height,height)
	l.button:setText''
	l.text = loveframes.Create('text',l)
	l.text:setText(text)
	l.text:SetWidth(width-height-10)
	l.text:SetFont(font.smallfont)
	l:SetDisplayType'horizontal'
	return l
end
function fileselection:initialize(...)
	frame.initialize(self,...)
	self.filelist = loveframes.Create('list',self)
	self.fileinput = loveframes.Create('textinput',self)
	self.confirmbutton = loveframes.Create('button',self)

	self:setSize(600,400)

	self.filelist:setSize(580,300)
	self.filelist:SetY(30)
	self.filelist:CenterX()
	

	self.fileinput:setSize(580,25)
	self.fileinput:SetY(345)
	self.fileinput:CenterX()

	self.confirmbutton:setText(LocalizedString'OK')
	self.confirmbutton:SetY(375)
	self.confirmbutton:CenterX()
	self.confirmbutton.OnClick = function()
		if self.confirmcallback then self.confirmcallback(self.basedirectory..self.fileinput.text) end
		self:dismiss()
	end

	self:setName(LocalizedString'Select File')
	
	if not love.filesystem.exists'userdata' then
		love.filesystem.mkdir'userdata'
	end
	self.dirs = {}
	self:setDirectory'userdata/'

end

function fileselection:setStyle(style,title)
	self:setName(title or LocalizedString'Select File')
end

function fileselection:setDirectory(d)
	table.insert(self.dirs,self.basedirectory)
	self.basedirectory = d
	self:enumerate()
end

function fileselection:enumerate()
	self.filelist:Clear()
	local files = love.filesystem.enumerate(self.basedirectory)
	if self.basedirectory ~= 'userdata/' then
		local b = horzBar(syringelist,requireImage'asset/icon/up.png',{LocalizedString'Up'},550,64)
		b.button.OnClick = function()
			self.basedirectory=(table.remove(self.dirs))
			self:enumerate()
		end

		self.filelist:AddItem(b)
	end
	for i,v in ipairs(files) do
		local file = self.basedirectory..v
		if love.filesystem.isDirectory(file) then
			local b = horzBar(syringelist,requireImage'asset/icon/folder.png',{v,LocalizedString'Folder'},550,64)
			b.button.OnClick = function()
				self:setDirectory(self.basedirectory..v..'/')
			
			end
			self.filelist:AddItem(b)
			
		else
			if string.sub(v,#v-3) == '.png' then
				local b = horzBar(syringelist,requireImage(self.basedirectory..v),{v,LocalizedString'Image'},550,64)
				b.button.OnClick = function()
					for i,v in ipairs(self.filelist.children) do
						v.button.active = nil
					end
					b.button.active = true
					self:select(v)
				end
				self.filelist:AddItem(b)
			else
				local b = horzBar(syringelist,requireImage'asset/icon/file.png',{v,LocalizedString'File'},550,64)
				b.button.OnClick = function()
					for i,v in ipairs(self.filelist.children) do
						v.button.active = nil
					end
					b.button.active = true
					self:select(v)
				end
				self.filelist:AddItem(b)
			end
		end
	end
end

function fileselection:select(file)
	self.fileinput:setText(file)
end

function fileselection:setCallbacks(confirmcallback,cancelcallback)
	self.confirmcallback = confirmcallback
	self.cancelcallback = cancelcallback
end

