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
end

function demogame:update(dt)
	
	
	host:process(dt)
	u:update(dt)
	c:update(dt)
	m:update(dt)
	e:update(dt)
end

function demogame:draw()
	
	if DEBUG then
		m:DebugDraw()
--		u:DebugDraw()
		host:DebugDraw()
		e:DebugDraw()
	end
	u:draw()
	m:draw()
	c:draw()
end

demogame:load()

return demogame