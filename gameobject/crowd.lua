require 'gameobject.human'
local behavior = {
	walk = function(unit,dir)
		unit:setMovingDirection(unpack(dir))
	end
}

Crowd = Object:subclass'Crowd'
function Crowd:initialize(area,n)
	assert(area,'invalid area')
	assert(n,'invalid maximum crowd count')
	self.source = {}
	self.crowd = {}
	self.area = area
	self:setBehavior('walk',Vector(1,0))
	self.n = n
end

function Crowd:createBody(world)
	self.world = world
end

function Crowd:spawn(x,y,r)
	assert(self.world,'crowd needed to be added to a map')
	local u = Human(Box2DMover,x,y,r,'dynamic')
	--u:createBody(self.world)
	self.world:addUnit(u,true)
	table.insert(self.crowd,u)
	self:behave(u,self.behavearg)
end

function Crowd:setBehavior(b,arg)
	self.b = b
	self.behavearg = arg
	for i,v in ipairs(self.crowd) do
		self:behave(v,arg)
	end
end

function Crowd:addSource(s)
	table.insert(self.source,s)
end

function Crowd:update(dt)
	for i,v in ipairs(self.crowd) do
		if v.map then
			if v.crowdai then v.crowdai:process(dt) end
			v:update(dt)
			if not self.area:contain(v) then
				self.world:removeUnit(v)
				
				table.remove(self.crowd,i)
				i = i - 1
			end
		else
			table.remove(self.crowd,i)
			i = i - 1
		end
	end
	if #self.crowd < self.n then
		local x,y = self.area:random()
		self:spawn(x,y,math.random()*7)
	end
	
	for i,v in ipairs(self.crowd) do
		local f = true
		love.graphics.push()
		for i,a in ipairs(self.source) do
			if a:contain(v) then
				local cv = a:getCenterVector()
				local uv = Vector(v:getPosition())
				local repel = uv-cv
				repel = repel * 100*dt/repel:length()
				local x,y = v:getPosition()
				v:setPosition(x + repel.x,y + repel.y)
				if a.attract then
					v:face(a,true)
					f = false
				end
			end
		end
		if f then v:face() end
		v:draw()
		love.graphics.pop()
	end
end

function Crowd:draw()
	for i,v in ipairs(self.crowd) do
		v:draw()
	end
end

function Crowd:addEvadeSource(u)
	table.insert(self.source,u)
end

function Crowd:behave(u,arg)
	behavior[self.b](u,arg)
end