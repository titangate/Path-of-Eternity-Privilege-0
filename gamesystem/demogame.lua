local demogame = {}

function demogame:load()
	-- Game Init --
	
	m = PathMap(20,20)
	m._data[5][5].obstacle = true
	host = AIHost(m)
	u = Human(Box2DMover,10,10,0,'kinematic')
	m:addUnit(u)
	
	area = CircleArea(300,300,100)
	--host:findPath(Vector(50,50),Vector(100,100))
	
	-- Debugs.
	

	a = Vector(1,1)
	c = Crowd(RectangleArea(100,100,400,400),20)
	c:addSource(RectangleArea(256,256,80,80))
	c:addSource(u:getRepelField())
	m:addUnit(c)
	
	e = Exposure(u,host,m.world)
	
	--patrolai = AIPatrol(u,{Vector(100,100,0,4),Vector(300,100,1,3),Vector(500,500,2,2),Vector(100,300,3,5),})
	patrolai = AIInvestigate(u,Vector(400,300))
	host:addAI(patrolai)
	loveframes.anim:easy(self,'scale',0,1,0.5)
	self.scale = 0
end

function demogame:loadresume()
	loveframes.anim:easy(self,'scale',0,1,0.25)
	self.scale = 0
end

function demogame:dismiss()
	loveframes.anim:easy(self,'scale',1,0,0.5)
	local mm = require'gamesystem.mainmenu'
	wait(0.25)
	mm:loadpause()
	self.host.push(mm,1)
--	m:loadpause()
	
end

function demogame:update(dt)
	host:process(dt)
	u:update(dt)
	c:update(dt)
	m:update(dt)
	e:update(dt)
end

function demogame:draw()
	local prev,canvas
	if self.scale ~=1 then
		love.graphics.push()
		love.graphics.translate(screen.halfwidth,screen.halfheight)
		love.graphics.scale(self.scale)
		love.graphics.translate(-screen.halfwidth*self.scale,-self.scale*screen.halfheight)
		canvas = canvasmanager.requireCanvas(screen.width,screen.height)
		canvas.canvas:clear()
		prev = love.graphics.getCanvas()
		love.graphics.setCanvas(canvas.canvas)
	end
	love.graphics.setColor(255,255,255)
	if DEBUG then
		m:DebugDraw()
--		u:DebugDraw()
		host:DebugDraw()
		e:DebugDraw()
	end
	u:draw()
	m:draw()
	c:draw()
	if self.scale ~=1 then
		love.graphics.pop()
		love.graphics.setColor(255,255,255,255*self.scale)
		love.graphics.setCanvas(prev)
		love.graphics.draw(canvas.canvas)
		canvasmanager.releaseCanvas(canvas)
	end
end

function demogame:keypressed(k)
	if k=='escape' then
		coroutinemsg(coroutine.resume(coroutine.create(function()self:dismiss()end)))
	end
end

function demogame:keyreleased(k)
end

function demogame:mousepressed()
end
function demogame:mousereleased()
end
--demogame:load()

return demogame