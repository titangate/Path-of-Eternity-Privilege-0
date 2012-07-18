--[[
CONTROL SCHEME:
Mouse left: move
Mouse right: interact

Inventory
Cellphone
Switch to: 

]]


KMController = Object:subclass'KMController'
function KMController:initialize(map,character,aihost)
	self.map = map
	self.character = character
	self.aihost = aihost
	assert(map and character and aihost,'controller initialization failed')
end

function KMController:mousepressed(x,y,b)
	if b== 'l' then
		if self.sel then
			local ai = AIFindPath(self.character,Vector(x,y),2)
			self.aihost:addAI(ai)

			if self.sel.info.interact then
				ai.next = AIInteract(self.map.obj.river,self.sel)
			end
		else
			local ai = AIFindPath(self.character,Vector(x,y),0)
			self.aihost:addAI(ai)
		end
	elseif b=='r' then
	end
end

function KMController:mousereleased(x,y,b)
end

function KMController:keypressed(k)
end

function KMController:keyreleased(k)
end

