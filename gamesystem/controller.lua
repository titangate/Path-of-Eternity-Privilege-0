--[[
CONTROL SCHEME:
Mouse left: move
Mouse right: interact

Inventory
Cellphone
Switch to: 

]]


KMController = Object:subclass'KMController'
function KMController:initialize(map,character,aihost,system)
	self.map = map
	self.character = character
	self.aihost = aihost
	self.inv = self.character.inv
	self.system = system
	assert(map and character and aihost,'controller initialization failed')
end

function KMController:mousepressed(x,y,b)
	x,y = self.map:screenToMap(x,y)
	if b== 'l' then
		if self.sel then
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
		if self.sel then
			local it = self.inv:getActiveItem()
			local allowance,msg = it:active(self.character,self.sel)
			if allowance then
				it:interact(self.character,self.sel)
			else
				self.system:hint(msg)
			end
		end
	end
end

function KMController:mousereleased(x,y,b)
end

function KMController:keypressed(k)
end

function KMController:keyreleased(k)
end

