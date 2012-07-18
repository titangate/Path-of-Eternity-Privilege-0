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
	local ai = AIFindPath(self.character,Vector(x,y))
	self.aihost:addAI(ai)
end

function KMController:mousereleased(x,y,b)
end

function KMController:keypressed(k)
end

function KMController:keyreleased(k)
end

