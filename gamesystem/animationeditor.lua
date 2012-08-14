require 'gameobject.animation'
local animationeditor = {}

function animationeditor:load()
	self.animatedparts = {}
	local function mousep()
		local x,y = love.mouse.getPosition()
		return Vector(x-screen.halfwidth,y-screen.halfheight)
	end
	table.insert(self.animatedparts,AnimatedPart(3,requireImage'unit/riverhead.png'))
	table.insert(self.animatedparts,AnimatedPart(3,requireImage'unit/genericfoot.png'))
	table.insert(self.animatedparts,AnimatedPart(3,requireImage'unit/genericfoot.png'))
	self.animatedparts[1]:setSelection(true)

	local selection = {}
	local sellist = loveframes.Create'list'
	for i,v in ipairs(self.animatedparts) do
		local b = loveframes.Create('button',sellist)
		b:setText(tostring(i))
		b.OnClick = function()
			for i2,v in ipairs(self.animatedparts) do
				v:setSelection(i==i2)
			end
		end
		self.animatedparts[i]:setMouseP(mousep)
	end

	local framelist = loveframes.Create'list'
	framelist:setPos(0,300)
	for i=1,3 do
		local b = loveframes.Create('button',framelist)
		b:setText(tostring(i))
		b.OnClick = function()
			self.frame = i
			for _,v in ipairs(self.animatedparts) do
				v:jumpToFrame(i)
			end
		end
	end
end

function animationeditor:update(dt)
	for i,v in ipairs(self.animatedparts) do
		v:update(dt)
	end

end

function animationeditor:draw()
	gra.push()
	gra.translate(screen.halfwidth,screen.halfheight)
	for i,v in ipairs(self.animatedparts) do
		v:draw()
	end
	gra.pop()
end

function animationeditor:keypressed(k)
end

function animationeditor:keyreleased(k)
end

function animationeditor:mousepressed(x,y,b)
	for i,v in ipairs(self.animatedparts) do
		v:mousepressed(x-screen.halfwidth,y-screen.halfheight,b)
	end
end
function animationeditor:mousereleased()
	for i,v in ipairs(self.animatedparts) do
		v:mousereleased()
	end
end

function animationeditor:loadSelectionWheel()

end
--animationeditor:load()

return animationeditor