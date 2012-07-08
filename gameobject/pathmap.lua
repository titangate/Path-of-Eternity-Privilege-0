PathMap = Object:subclass'PathMap'
function PathMap:initialize(w,h)
	self._data = {}
	self.w,self.h = w,h
	self.scale = 64
	for x=1,w do
		table.insert(self._data,{})
		for y=1,h do
			table.insert(self._data[x],RectangleArea((x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale))
		end
	end
	self.world = love.physics.newWorld()
	self.f_destroy = {}
	self.b_destroy = {}
end

function PathMap:addUnit(u)
	u.map = self
	if u.createBody then
		u:createBody(self)
	end
end


function PathMap:removeUnit(u)
	u.map = nil
	if u.destroyBody then
		u:destroyBody(self)
	end
end

function PathMap:destroyNext(fixture,body)
	table.insert(self.f_destroy,fixture)
	table.insert(self.b_destroy,body)
	
end

-- returns the area object associated with the coordiantes given
function PathMap:getArea(x,y)
	assert(x>=0 and x<self.w*self.scale,'coordinates out of bounds')
	assert(y>=0 and y<self.h*self.scale,'coordinates out of bounds')
	local x,y = self:pixelToData(x,y)
	return self._data[x][y]
end

function PathMap:pixelToData(x,y)
	return math.ceil(x/self.scale),math.ceil(y/self.scale)
end

function PathMap:hasObstacle(x,y)
	if x<1 or x>self.w-1 or y<1 or y>self.h-1 then
		return true
	end
	return self._data[x][y].obstacle
end

-- The implementation of nearby blocks iterator
function PathMap:_getBlock(x,y)
	
	if not self:hasObstacle(x+1,y) then
		coroutine.yield(Vector(x+1,y),10)
		if not self:hasObstacle(x+1,y-1) and not self:hasObstacle(x,y-1) then
			coroutine.yield(Vector(x+1,y-1),14)
		end
		
		if not self:hasObstacle(x+1,y+1) and not self:hasObstacle(x,y+1) then
			coroutine.yield(Vector(x+1,y+1),14)
		end
	end
	
	
	if not self:hasObstacle(x-1,y) then
		coroutine.yield(Vector(x-1,y),10)
		if not self:hasObstacle(x-1,y-1) and not self:hasObstacle(x,y-1) then
			coroutine.yield(Vector(x-1,y-1),14)
		end
		
		if not self:hasObstacle(x-1,y+1) and not self:hasObstacle(x,y+1) then
			coroutine.yield(Vector(x-1,y+1),14)
		end
	end
	
	if not self:hasObstacle(x,y-1) then
		coroutine.yield(Vector(x,y-1),10)
	end
	if not self:hasObstacle(x,y+1) then
		coroutine.yield(Vector(x,y+1),10)
	end
end

-- Get associated walkable blocks
function PathMap:getBlock(x,y)
	return coroutine.wrap(function() self:_getBlock(x,y) end)
end

local function heuristic(a,b)
	return math.abs(a.x-b.x)+math.abs(a.y-b.y)
end

local function extractmin(b)
	local t,m = 1,b[1][2]
	for i=2,#b do
		if b[i][2] < m then
			t,m = i,b[i][2]
		end
	end
	return table.remove(b,t)
end

-- A Star
function PathMap:findPath(start,finish)
	local sx,sy = self:pixelToData(start.x,start.y)
	local fx,fy = self:pixelToData(finish.x,finish.y)
	
	local finale = Vector(fx,fy)
	local startv = Vector(sx,sy)
	if finale==startv then
		return {RectangleArea(finish.x-10,finish.y-10,20,20)}
	end
	local g = VectorIndexMap()
	g[startv] = heuristic(startv,finale)
	local open = {{startv,heuristic(startv,finale)}}
	local comefrom = VectorIndexMap()
	local path = {}
	local visited = VectorIndexMap()
	while #open>0 do
		local b,cost = unpack(extractmin(open))
		for near,c in self:getBlock(b.x,b.y) do
			local gs = g[b] + cost
			if not g[near] or g[near] > gs then
				g[near] = gs
				visited[near] = gs + heuristic(near,finale)
				comefrom[near] = b
				table.insert(open,{near,visited[near]})
			end
			if near == finale then
				table.insert(path,RectangleArea(finish.x-5,finish.y-5,10,10))
				while comefrom[finale] ~= startv do
					finale=comefrom[finale]
					table.insert(path,self._data[finale.x][finale.y])
				end
				return path
			end
		end
	end
	return {self._data[sx][sy]}
end

function PathMap:update(dt)
	for i,v in ipairs(self.f_destroy) do
		v:destroy()
	end
	for i,v in ipairs(self.b_destroy) do
		v:destroy()
	end
	self.f_destroy = {}
	self.b_destroy = {}
	self.world:update(dt)
end

function PathMap:draw()
end

function PathMap:getNearbyArea(target,distance)
	local x,y = self:pixelToData(target.x,target.y)
	local openset = {{Vector(x,y),0}}
	local closedset = VectorIndexMap
	local searchset = {Vector(self._data[x][y]:random())}
	while #openset> 0 do
		local b,l = unpack(table.remove(openset))
		if l<distance then
			table.insert(searchset,Vector(self._data[b.x][b.y]:random()))
			for near,c in self:getBlock(b.x,b.y) do
				if not closedset[near] then
					closedset[near] = true
					table.insert(openset,{near,l+1})
				end
			end
		end
	end
	return searchset
end

if DEBUG then
local shifth = 3^0.5
local shiftx,shifty = 3^0.5/2,1.5
function PathMap:DebugDraw()
	local g = love.graphics
	g.push()
	g.setColor(255,255,255)
	g.rectangle('fill',0,0,screen.width,screen.height)
--	g.setBackgroundColor(255,255,255)
	g.setColor(0,0,0,125)
	for x=1,self.w do
		for y=1,self.h do
			if self._data[x][y].obstacle then
				love.graphics.rectangle('fill',(x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale)
			else
				love.graphics.rectangle('line',(x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale)
			end
--			self._data[x][y]:DebugDraw()
		end
	end
	g.pop()
end
end