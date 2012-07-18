local selectionwheel = {}
local essential = require 'library.essential'

local centerPos = {150,150}
local firstLayout = {}
local secondLayout = {}
local maxSecondLayoutCount = 6

local wheelspan = math.pi*2
for i=1,4 do
	local firstLayoutShift = 80
	local r = (1-i)*wheelspan/4
	local x,y = math.cos(r),math.sin(r)
	firstLayout[i] = {centerPos[1]+x*firstLayoutShift,centerPos[2]+y*firstLayoutShift}
end

local secondLayerSpanUnit = math.pi/2/3

function selectionwheel:redoSecondLayout(start,count)
	for i=1,count do
		local secondLayoutShift = 160
		local r = (1-i)*secondLayerSpanUnit+start
		local x,y = math.cos(r),math.sin(r)
		secondLayout[i] = {centerPos[1]+x*secondLayoutShift,centerPos[2]+y*secondLayoutShift}
--		print (unpack(secondLayout[i]))
	end
end

function selectionwheel:highlight(layer,index)
	if layer == 'first' then
		for i,v in ipairs(self.firstLayoutButton) do
			v.active = i==index
		end
	else
		for i,v in ipairs(self.secondLayoutButton) do
			v.active = i==index
		end
	end
end

local fantime = 0.3
function selectionwheel:fanFirstLayout(state)
	if state then
		for i=1,#firstLayout do
			loveframes.anim:easy(self.firstLayoutButton[i],'staticx',centerPos[1],firstLayout[i][1],fantime,loveframes.style.quadInOut)
			loveframes.anim:easy(self.firstLayoutButton[i],'staticy',centerPos[2],firstLayout[i][2],fantime,loveframes.style.quadInOut)
			loveframes.anim:easy(self.firstLayoutButton[i],'opacity',centerPos[1],firstLayout[i][1],fantime,loveframes.style.quadInOut)
		end
	end
end

function selectionwheel:fanSecondLayout(state,buttonindex,count)
	local cp = firstLayout[buttonindex]
	if state then
		local r = (1-buttonindex)*wheelspan/4 + (count/2-0.5)*secondLayerSpanUnit
		self:redoSecondLayout(r,count)
		for i=1,count do
	--		self.secondLayoutButton[i]:setPos(unpack(secondLayout[i]))
			loveframes.anim:easy(self.secondLayoutButton[i],'staticx',cp[1],secondLayout[i][1],fantime,loveframes.style.quadInOut)
			loveframes.anim:easy(self.secondLayoutButton[i],'staticy',cp[2],secondLayout[i][2],fantime,loveframes.style.quadInOut)
			loveframes.anim:easy(self.secondLayoutButton[i],'opacity',cp[1],secondLayout[i][1],fantime,loveframes.style.quadInOut)
			self.secondLayoutButton[i]:SetVisible(true)
		end
		for i=count+1,maxSecondLayoutCount do
			self.secondLayoutButton[i]:SetVisible(false)
		end
	end
end

function selectionwheel:load()
	local frame = loveframes.Create('frame')
	frame:setSize(600,600)
	function frame.Draw(object)
		local x,y = object:GetPos()
		x,y = x+centerPos[1]+32,y+centerPos[2]+32
		love.graphics.setColor(255,255,255,76.5)
		love.graphics.circle('fill',x,y,40,6)
		love.graphics.circle('fill',x,y,120,6)
		love.graphics.circle('fill',x,y,204)
	end
	local centerButton = loveframes.Create('circlebutton',frame)
	centerButton:setSize(64,64)
	centerButton:setPos(unpack(centerPos))
	centerButton:setImage(requireImage'asset/difficulty/hard.png')
	local firstLayoutButton = {}
	for i=1,4 do
		firstLayoutButton[i] = loveframes.Create('circlebutton',frame)
		firstLayoutButton[i]:setSize(64,64)
		firstLayoutButton[i]:setPos(unpack(firstLayout[i]))
		firstLayoutButton[i]:setImage(requireImage'asset/difficulty/hard.png')
		firstLayoutButton[i].OnClick = function(object)
			self:fanSecondLayout(true,i,math.random(1,6))
			self:highlight('first',i)
		end
	end
	self:redoSecondLayout(secondLayerSpanUnit*2.5,6)
	local secondLayoutButton = {}
	for i=1,maxSecondLayoutCount do
		secondLayoutButton[i] = loveframes.Create('circlebutton',frame)
		secondLayoutButton[i]:setSize(64,64)
		secondLayoutButton[i]:setImage(requireImage'asset/difficulty/hard.png')
		secondLayoutButton[i]:SetVisible(false)
		secondLayoutButton[i].OnClick = function(object)
			self:highlight('second',i)
		end
	end

	self.firstLayoutButton = firstLayoutButton
	self.secondLayoutButton = secondLayoutButton
	self:fanFirstLayout(true)
--	self:fanSecondLayout(true,1,6)
	self.selectionwheelframe = frame
	frame:Center()

	frame.filter = filters.vibrate
	frame.vibrate_ref = 5
	loveframes.anim:easy(frame,"vibrate_ref",5,0,0.3)
	wait(0.3)
	frame.filter = nil
--	loveframes.anim:easy(self.selectionwheelframe,'y',screen.height,self.selectionwheelframe.y,0.3,loveframes.style.quadInOut)
end

function selectionwheel:loadFirstLayout(t)
	for i,v in ipairs(t) do
		for k,a in pairs(v) do print (k,a) end
		self.firstLayoutButton[i]:setImage(v.image)
		self.firstLayoutButton[i]:setText(v.text)
	end
end

function selectionwheel:dismiss()
	loveframes.anim:easy(self.selectionwheelframe,'y',self.selectionwheelframe.y,screen.height,0.3,loveframes.style.quadInOut)
end

return selectionwheel