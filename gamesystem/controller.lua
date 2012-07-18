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
	print (b)
	if b== 'l' then
		local ai = AIFindPath(self.character,Vector(x,y),1)
		self.aihost:addAI(ai)
		if self.sel and self.sel.info.interact then
			ai.next = AIInteract(self.sel)
		end
	elseif b=='r' then
		print (self.sel)
		if self.sel and self.sel.info.interact then
			interactfunc[self.sel.info.interact](self.sel)
		end
	end
end

function KMController:mousereleased(x,y,b)
end

function KMController:keypressed(k)
end

function KMController:keyreleased(k)
end

