local sound = require 'library.sound'

local demogame = {}

function demogame:load()
	-- Game Init --
	
	m = PathMap(20,20)
	m:setWallbatch(requireImage'asset/terrain/yellowwall.png',{
		width = 64,
		height = 64,
		ox = 32,
		oy = 32,
		lurd = love.graphics.newQuad(0,0,64,64,256,64),
		lr = love.graphics.newQuad(64,0,64,64,256,64),
		lur = love.graphics.newQuad(128,0,64,64,256,64),
		ur = love.graphics.newQuad(192,0,64,64,256,64),
		})
	m._data[5][5].obstacle = 'wall'
	m._data[5][6].obstacle = 'wall'
	m._data[6][6].obstacle = 'wall'
	m._data[4][5].obstacle = 'wall'
	m._data[3][5].obstacle = 'wall'
	m._data[3][6].obstacle = 'wall'
	m._data[3][4].obstacle = 'wall'
	m:createWallMap()
	host = AIHost(m)
	u = Human(Box2DMover,100,100,0,'kinematic')
	u2 = Human(Box2DMover,300,200,0,'kinematic')
	
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

	sel = Selection(u)
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
	sound.setCenter(u:getPosition())
	
	if u2in then
		u2:update(dt)
	end
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
		if self.s then
			self.s:DebugDraw()
		end
	end
	u:draw()
	if u2in then
		u2:draw()
	end
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
	if k=='a' then
		m:addUnit(u2)
		u2in = true
	end
end

function demogame:keyreleased(k)
end

function demogame:mousepressed(x,y,b)
	self.s = Sound('sound/effect/machine1.ogg',Vector(x,y),100)
	self.s:play()
	if u2in then
		u2:setPosition(x,y)
		u:face(u2,true)
	end
end
function demogame:mousereleased()
end
--demogame:load()

return demogame