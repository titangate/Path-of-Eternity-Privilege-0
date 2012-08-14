

Exposure = Object:subclass'Exposure'

function Exposure:initialize(unit,host,world)
	self.u = unit
	self.host = host
	self.world = world
	if DEBUG then
		self.rays = {}
	end
	self.maxexposure = 5--self.host:getConstant('maxexposure',unit)
	self.exposure = 0
	self.deltaexposure = 0
	self.raycastcallback = function(fixture,x,y,xn,yn,fraction)
		local u = fixture:getUserData()
--		local distance = (Vector(x,y)-Vector(u:getPosition())):length()
		if not u then return 1 end
		self.deltaexposure = self.deltaexposure + u:getExposure()*(1-fraction)*self.weight
		return 1
	end
	self.exposure = 0
end

function Exposure:update(dt)
--	self:cast(self.world,math.random()-0.5,self.host:getConstant'losdistance',dt)
	self:cast(self.world,math.random()-0.5,300,dt)
	self.exposure = self.exposure - dt
end

function Exposure:cast(world,angle,range,weight)
	self.weight = weight
	local x,y = self.u:getPosition()
	local r = self.u:getHeadAngle()+angle
	local fx,fy = x+math.cos(r)*range,y+math.sin(r)*range
	self.deltaexposure = 0
	world:rayCast(x,y,fx,fy,self.raycastcallback)
	self.exposure = self.exposure + self.deltaexposure
	
	self.exposure = math.max(0,self.exposure)
	self.exposure = math.min(self.maxexposure,self.exposure)
	if DEBUG then
		table.insert(self.rays,{x,y,fx,fy,self.exposure})
		if #self.rays>5 then
			table.remove(self.rays,1)
		end
	end
	if self.exposure > self.maxexposure then
		self.host:alert(self.unit)
	end
end

if DEBUG then
function Exposure:DebugDraw()
	for i,v in ipairs(self.rays) do
		local x1,y1,x2,y2,t=unpack(v)
		gra.setColor(255*t/5,0,255-255*t/5)
		gra.line(x1,y1,x2,y2)
	end
end
end