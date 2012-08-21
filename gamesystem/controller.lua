--[[
CONTROL SCHEME:
Mouse left: move
Mouse right: interact

Inventory
Cellphone
Switch to:

]]


local hotkey = require 'library.hotkey'

KMController = Object:subclass'KMController'
function KMController:initialize(map,character,aihost,system)
	self.map = map
	self.character = character
	self.aihost = aihost
	self.inv = self.character.inv
	self.system = system
	self.enable = true
	assert(map and character and aihost,'controller initialization failed')
end

function KMController:setEnabled(enable)
	self.enable = enable
end

function KMController:mousepressed(x,y,b)
	if not self.enable then return end
	x,y = self.map:screenToMap(x,y)
	if b== 'l' then
		if self.sel and self.sel.info then
			local interactrange =  self.sel.info.interactrange or 2
			local ai = AIFindPath(self.character,Vector(x,y),interactrange)
			self.aihost:addAI(ai)
			if self.sel.info and self.sel.info.interact then
				ai.next = AIInteract(self.map.obj.river,self.sel)
			end
		else
			local ai = AIFindPath(self.character,Vector(x,y),0)
			self.aihost:addAI(ai)
		end
	elseif b=='r' then
		local t = self.sel
		if t == nil then
			t = Vector(self.map:screenToMap(x,y))
		end
		local it = self.inv:getActiveItem()
		local allowance,msg = it:active(self.character,t)
		if allowance then
			--it:interact(self.character,self.sel)
		else
			self.system:hint(msg)
		end
	end
end

function KMController:mousereleased(x,y,b)
	if not self.enable then return end
end

function KMController:keypressed(k)
	if not self.enable then return end
	if k==hotkey.editor then
		self.system:setGameState'editor'
	end
	if k==hotkey.inventory then
		self.system:loadSelectionWheel()
	end
	if k==hotkey.brief then
		local brief = require 'gamesystem.brief'
		assert(global.mission,'mission not found')
		brief:setMission(global.mission)
		brief:load()
		brief.OnSetTimescale = function(t)self.system.timescale = t end
	end
end

function KMController:keyreleased(k)
	if not self.enable then return end
end

