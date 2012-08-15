
local g = gra
PathMap = Object:subclass'PathMap'
function PathMap:initialize(w,h,aihost)
	self._data = {}
	self.w,self.h = w,h
	self.scale = 64
	self.obj = {}
	local function cf(area,unit,state)
		if state then
			local a = unit:getObstacle()
			if a then
				unit.old_obs = a
				for v,_ in pairs(a) do
					v.obstacle = v.obstacle or 0
					if type(v.obstacle) == 'number' then
						v.obstacle = v.obstacle + 1
					end
				end
			end
		else
			if unit.old_obs then
				for v,_ in pairs(unit.old_obs) do
					if type(v.obstacle) == 'number' then
						v.obstacle = v.obstacle- 1
						if v.obstacle == 0 then
							v.obstacle = nil
						end
					end
				end
			end
		end
	end
	for x=1,w do
		table.insert(self._data,{})
		for y=1,h do
			local a = RectangleArea((x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale)
			table.insert(self._data[x],a)
			a.carryfunc = cf
		end
	end
	self.world = love.physics.newWorld()
	
	self.f_destroy = {}
	self.b_destroy = {}
	self.f_update = {}

	self.unit = {[0]={},[1]={},[2]={}}

	self.camerashift = Vector(0,0)

	self.aihost = aihost

	self.layer = 0

	self.raycastcallback = function(fixture,x,y,xn,yn,fraction)
		local obs,layer
		local ud = fixture:getUserData()
		if ud and ud.isObstacle and ud.info and ud.info.layer and ud.info.layer>=5 then
			obs = ud:isObstacle()
			layer = ud.info.layer
		else
			obs = false
		end
		if obs and self.layer <= layer and self.fraction > fraction then
			self.layer = layer
			self.hit = ud
			self.fraction = fraction
		end
		--end
		return 1
	end
end

function PathMap:setFollower(u)
	self.follower = u
end

function PathMap:setUnitIdentifier(d,unit)
	self.obj[d] = unit
end

function PathMap:setDelegate(del)
	self.del = del
end

function PathMap:setBackground(img)
	if type(img) == 'string' then
		img = requireImage(img)
	end
	self.background = img
end

function PathMap:addUnit(u,crowd)

	local layer = u.layer or 1
	if self.unit[layer][u] then return end
	u.map = self
	if u.createBody then
		u:createBody(self)
	end
	if crowd then return end
	self.unit[layer][u] = true
	u.aihost = self.aihost
end

function PathMap:setWallbatch(image,config)
	self.wallimage = image
	self.wallbatch = gra.newSpriteBatch(self.wallimage,self.w*self.h)
	self.wallconfig = config
end

function PathMap:createWallMap()

	self.wallbatch = gra.newSpriteBatch(self.wallimage,self.w*self.h)
	local c = self.wallconfig
	for x=1,self.w do
		for y=1,self.h do
			if self:hasObstacle(x,y)== 'wall' then
				self._data[x][y].pattern = {}
				local u = self:hasObstacle(x,y-1) == 'wall'
				local d = self:hasObstacle(x,y+1) == 'wall'
				local l = self:hasObstacle(x-1,y) == 'wall'
				local r = self:hasObstacle(x+1,y) == 'wall'
				if not (u or d or l or r) then
					-- stud
				elseif u and d and l and r then
					self.wallbatch:addq(c.lurd,x*self.scale+c.width/2,y*self.scale+c.height/2,0,1,1,c.ox,c.oy)
				else
					local walltable = {l,u,r,d}
					local i = 0
					while true do
						local l,u,r,d = walltable[i%4+1],walltable[(i+1)%4+1],walltable[(i+2)%4+1],walltable[(i+3)%4+1]
						if l and r and not u and not d then
							self.wallbatch:addq(c.lr,(x-1)*self.scale+c.width/2,(y-1)*self.scale+c.height/2,i*math.pi/2,1,1,c.ox,c.oy)
							break
						elseif l and u and r and not d then
							self.wallbatch:addq(c.lur,(x-1)*self.scale+c.width/2,(y-1)*self.scale+c.height/2,i*math.pi/2,1,1,c.ox,c.oy)
							break
						elseif u and r and not l and not d then
							self.wallbatch:addq(c.ur,(x-1)*self.scale+c.width/2,(y-1)*self.scale+c.height/2,i*math.pi/2,1,1,c.ox,c.oy)
							break
						elseif r and not l and not u and not d then
							self.wallbatch:addq(c.lr,(x-1)*self.scale+c.width/2,(y-1)*self.scale+c.height/2,i*math.pi/2,1,1,c.ox,c.oy)
							break
						end
						i = i +1
					end
				end

				local emptyfunc = function()end
				local dx,dy = self._data[x][y]:getCenter()
				local moverinfo = {
					width = self.scale,
					height = self.scale,
					shape = 'rectangle',
					bodytype = 'static',
					layer = 5,
					nonupdate = true,
				}
				local mover = doodadMover(dx,dy,0,nil,moverinfo)
				self._data[x][y].mover = mover
				self:addUnit(mover,true)
				mover.update = false
				mover:setUserData(mover)
			end
		end
	end
end

function PathMap:removeUnit(u)
	local layer = u.layer or 1
	if self.del then
		self.del:removeUnit(u)
	end
	u.map = nil
	if u.destroyBody then
		u:destroyBody(self)
	end
	self.unit[layer][u] = nil
	u.aihost = nil
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
		return 'bound'
	end
	return self._data[x][y].obstacle_e or self._data[x][y].obstacle 
end

function PathMap:setObstacleEditor(x,y,s)
	local x,y = self:pixelToData(x,y)
	self._data[x][y].obstacle_e = s
	-- body
--[[	local dx,dy = self._data[x][y]:getCenter()
	local moverinfo = {width = self.scale,
	height = self.scale,
	shape = 'rectangle',
	}
	local mover = DoodadMover(dx,dy,r,'static',moverinfo)
	self._data[x][y].mover = mover
	self:addUnit(mover)]]
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
function PathMap:findPath(start,finish,errorrange)
	errorrange = errorrange or 0
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
	while #open>0 and #open < 50 do
		local b,cost = unpack(extractmin(open))
		for near,c in self:getBlock(b.x,b.y) do
			local gs = g[b] + cost
			if not g[near] or g[near] > gs then
				g[near] = gs
				visited[near] = gs + heuristic(near,finale)
				comefrom[near] = b
				table.insert(open,{near,visited[near]})
			end
--			print ((near-finale):length(),errorrange)
			if (near-finale):length()<=errorrange then -- determine the distance between target and current search
				if errorrange==0 then
					table.insert(path,RectangleArea(finish.x-5,finish.y-5,10,10))
				end
				while near and comefrom[near] ~= startv do
					near=comefrom[near]
--					print (near)
					if near then
					table.insert(path,self._data[near.x][near.y])
				end
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
	for i=0,#self.unit do
		for v,_ in pairs(self.unit[i]) do
			if v.update then v:update(dt) end
		end
	end
	
	for i,v in ipairs(self.f_update) do
		v[1]:setUserData(v[2])
	end
	
	self.f_destroy = {}
	self.b_destroy = {}
	self.f_update = {}
	self.world:update(dt)
	if self.follower then
		local x,y = self.follower:getPosition()
		self.camerashift.x,self.camerashift.y=screen.halfwidth-x,screen.halfheight-y
		
	end
end

local fog = {
	gaussianblur_intensity = 2
}
function fog:getWidth()
	return screen.width
end
function fog:getHeight()
	return screen.height
end
function fog:getX()
	return 0
end
function fog:getY()
	return 0
end

local fanimg = requireImage'asset/shader/fan.png'
local circcount = 32
function PathMap:generateFog(u,canvas)
	--local canvas = canvasmanager.requireCanvas(screen.halfwidth,screen.halfheight)
	canvas.canvas:clear()
	gra.setCanvas(canvas.canvas)
	local w = screen.halfwidth
	local x1,y1 = u:getPosition()
	local up = Vector(x1,y1)
	for i=1,circcount do
		local r = math.pi*2/circcount*i
		self.hit = nil
		self.fraction = 1
		self.layer = 0
		local x2,y2 = x1+math.cos(r)*w*2,y1+math.sin(r)*w*2
		self.world:rayCast(x1,y1,x2,y2,self.raycastcallback)
		local scale = self.fraction*w/fanimg:getWidth()
		
		gra.draw(fanimg,w/2,screen.halfheight/2,r,scale,scale,0,fanimg:getHeight()/2)
		--filters.gaussianblur.postdraw(fog)
	end
	gra.setCanvas()
	--canvasmanager.releaseCanvas(canvas)
end

local invert = gra.newPixelEffect[[
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	if (Texel(texture,texture_coords).a > 0)
		return vec4(0,0,0,0);
	else
		return vec4(0,0,0,200);
}
]]
function PathMap:draw()
	local canvas
	if self.follower then
		
	end
	g.push()
	g.translate(unpack(self.camerashift))
	if self.drawlli then
		self:draw_LLI()
	else
		self:draw_normal()
	end
	g.pop()
	if self.follower then
		canvas = canvasmanager.requireCanvas(screen.halfwidth,screen.halfheight)
		self:generateFog(self.follower,canvas)
		filters.gaussianblur.conf(fog)
		filters.gaussianblur.predraw(fog)
		gra.setPixelEffect(invert)
		gra.draw(canvas.canvas,0,0,0,2)
		gra.setPixelEffect()
		filters.gaussianblur.postdraw(fog)
		canvasmanager.releaseCanvas(canvas)
	end
end

function PathMap:draw_normal()

	g.setColor(255,255,255)
	if self.background then
		gra.draw(self.background,0,0,0,4)
	end
	if self.wallbatch then
		gra.draw(self.wallbatch)
	end
	for i=0,#self.unit do
		for v,_ in pairs(self.unit[i]) do
			if v.draw then v:draw() end
		end
	end

end

function PathMap:draw_LLI()
	g.setColor(255,255,255)
	self.satbri_saturation = 0
	self.satbri_brightness = -1
	self.lli_intensity = math.random(10)
	if self.lli_radius and self.lli_radius < screen.halfwidth then
		if self.background then
			gra.draw(self.background)
		end
		if self.wallbatch then
			gra.draw(self.wallbatch)
		end
		for i=0,#self.unit do
			for v,_ in pairs(self.unit[i]) do
				if v.draw then v:draw() end
			end
		end
		filters.lli.conf(self)
		filters.lli.predraw()
		gra.setStencil(function()gra.circle('fill',screen.halfwidth,screen.halfheight,self.lli_radius)end)
		if self.background then
			gra.draw(self.background)
		end
		if self.wallbatch then
			gra.draw(self.wallbatch)
		end
		filters.lli.postdraw()
		
		for i=0,#self.unit do
			for v,_ in pairs(self.unit[i]) do
				if v.draw_LLI then
					v:draw_LLI()
				else
					v:draw()
				end
			end
		end
		gra.setStencil()

	else
		filters.lli.conf(self)
		filters.lli.predraw()
		if self.background then
			gra.draw(self.background)
		end
		if self.wallbatch then
			gra.draw(self.wallbatch)
		end
		filters.lli.postdraw()

		for i=0,#self.unit do
			for v,_ in pairs(self.unit[i]) do
				if v.draw_LLI then
					v:draw_LLI()
				else
					v:draw()
				end
			end
		end
	end
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

function PathMap:encode()
	local t = {unit = {},wall={}}
	for i=0,#self.unit do
		for v,_ in pairs(self.unit[i]) do
			if v.encode then
			local savedata = v:encode()
			savedata.identifier = v.identifier
			table.insert(t.unit,savedata)
		end
		end
	end
	for x = 1,self.w do
		table.insert(t.wall,{})
		for y = 1,self.h do
		table.insert(t.wall[x],{})
			t.wall[x][y].obstacle_e = self._data[x][y].obstacle_e
		end
	end
	return t
end

-- f: callback. receives qeuried unit, returns bool wether to keep querying or not
function PathMap:queryUnits(area,f)
	local x1,y1,w,h = area:getAABB()
	x1,y1 = self:pixelToData(x1,y1)
	x2,y2 = self:pixelToData(x1+w,y1+h)
	x1 = math.max(x1,1)
	x2 = math.min(x2,self.w)
	y1 = math.max(y1,1)
	y2 = math.min(y2,self.h)
	for x = x1,x2 do
		for y = y1,y2 do
			for u,_ in pairs(self._data[x][y]:getCarriedUnit()) do
				if area:contain(u) then
					local r = f(u)
					assert(type(r)=='boolean','Query Unit callback has to return a boolean')
					if r == false then
						return
					end
				end
			end
		end
	end
end

function PathMap:getBlockBody(x,y)
	-- a special function that returns body userdata to build doors
	assert(self._data[x][y].obstacle_e == 'wall',string.format("%d,%d is not a valid wall block",x,y))
	return self._data[x][y].mover.body
end

function PathMap:load(t)


	if t.wall then
		for x = 1,self.w do
			for y = 1,self.h do
				if t.wall[x] and t.wall[x][y] then
					self._data[x][y].obstacle_e = t.wall[x][y].obstacle_e
				end
			end
		end
	end

	self:createWallMap()
	for i,v in ipairs(t.unit) do
		local u = serial.decode(v)
		if u then
			self:addUnit(u)

			if u.patrolpath then
				self:addUnit(u.patrolpath)
			end
			if v.identifier then
				u:setIdentifier(v.identifier)
			end
		end
	end
end

function PathMap:mapToScreen(x,y)
	return x+self.camerashift.x,y+self.camerashift.y
end

function PathMap:screenToMap(x,y)
	return x-self.camerashift.x,y-self.camerashift.y
end

if DEBUG then
local shifth = 3^0.5
local shiftx,shifty = 3^0.5/2,1.5
function PathMap:DebugDraw()
	g.push()
	g.translate(unpack(self.camerashift))
--	g.rectangle('fill',0,0,screen.width,screen.height)
--	g.setBackgroundColor(255,255,255)
--	g.setColor(0,0,0,50)
	local startx = math.floor(-self.camerashift.x/self.scale)+1
	local starty = math.floor(-self.camerashift.y/self.scale)+1
	local w,h = screen.width/self.scale,screen.height/self.scale
	for x=startx,startx+w do
		for y=starty,starty+h do
			g.setColor(0,0,0,100)
			if self:hasObstacle(x,y)~='bound' then
				if self._data[x][y].obstacle_e or self._data[x][y].obstacle then
					gra.rectangle('fill',(x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale)
				else
					gra.rectangle('line',(x-1)*self.scale,(y-1)*self.scale,self.scale,self.scale)
				end
				self._data[x][y]:DebugDraw()
			end
		end
	end

	for i=0,#self.unit do
		for v,_ in pairs(self.unit[i]) do
			if v.DebugDraw then v:DebugDraw() end
		end
	end
	g.pop()
end
end