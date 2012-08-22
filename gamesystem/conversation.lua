local sound = require 'library.sound'
Conversation = Object:subclass'Conversation'
function Conversation:setMode(mode)
	-- mode: subtitle/conversation/overhead
	self.mode = mode
end

function Conversation:play()
	if self.voice then
		if self.mode == 'subtitle' then
			self.s = sound.play(self.voice,'conversation')
			assert(self.s)
		end
		
	end
	local t = loveframes.Create('text')
	t:setText(string.format("%s %s",self.speaker,self.message))
	t:SetY(screen.height-100)
	t:CenterX()
	print (t.height,'text height')
	t.filter = filters.vibrate
	loveframes.anim:easy(t,'vibrate_ref',3,0,1)
	wait(1)

	if self.time then
		wait(self.time)
	else
		waitUntil(function()return self.s:isStopped()end)
	end
	loveframes.anim:easy(t,'vibrate_ref',0,3,1)
	if self.finishcallback then
		self.finishcallback(self)
	end
	wait(1)
	t:Remove()
end

function Conversation:initialize(speaker,message,voice,time,finishcallback)
	self.speaker = speaker
	self.message = message
	self.voice = voice
	self.finishcallback = finishcallback
	self.time = time
end

local conversation = {
	mode = 'subtitle', 
}
function conversation.playConversation(speaker,message,voice,time,finishcallback)
	local c = Conversation(speaker,message,voice,time,finishcallback)
	c:setMode(conversation.mode)
	c:play()
end


function conversation.setMode(mode)
	conversation.mode = mode
end

return conversation