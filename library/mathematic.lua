function normalize(...)
	local r = {}
	local length = 0
	for i,v in ipairs(arg) do
		table.insert(r,v)
		length = length + v*v
	end
	length = length ^ 0.5
	for i,v in ipairs(r) do
		r[i] = v/length
	end
	return unpack(r)
end

local keydir = {
	x=1,
	r=1,
	y=2,
	g=2,
	z=3,
	b=3,
	a=4,
}

local Vectormeta = {

	__newindex = function(table,key,value)
		if keydir[key] then
			key = keydir[key]
		end
		rawset(table,key,value)
	end,
	__tostring = function(self) return "Vector X:" ..tostring(rawget(self,1)).." Y:" ..tostring(rawget(self,2))  end,
	__eq = function(self,other)
		if #self == #other then
			for i=1,#self do
				if self[i]~=other[i] then
					return false
				end
			end
			return true
		else
			return false
		end
	end,
	__add = function(self,b)
		local v = Vector()
		for i=1,#self do
			v[i] = b[i] + self[i]
		end
		return v
	end,
	
	__sub = function(self,b)
		local v = Vector()
		for i=1,#self do
			v[i] = -b[i] + self[i]
		end
		return v
	end,
	
	__mul = function(self,b)
		assert(type(b)=='number')
		local v = Vector()
		for i=1,#self do
			v[i] = self[i] *b
		end
		return v
	end,
	__div = function(self,b)
		assert(type(b)=='number')
		local v = Vector()
		for i=1,#self do
			v[i] = self[i] /b
		end
		return v
	end,
}

function Vectormeta.__index(t,key)
	if keydir[key] then
		key = keydir[key]
	end
	local a = rawget(Vector,key)
	return a or rawget(t,key)
end

Vector = {}
setmetatable(Vector,{
	__call = function(self, ...) 
		local t = arg
		return setmetatable(t, Vectormeta) 
	end,
}
)

function Vector:length()
	local length = 0
	
	for i,v in ipairs(self) do
		length = length + v*v
	end
	return length ^ 0.5
end


local VectorIndexMapmeta = {
	__index = function(table,key)
		
		key = key[1]*10000+key[2]
		return rawget(table,key)
	end,
	__newindex = function(table,key,value)
		key = key[1]*10000+key[2]
		rawset(table,key,value)
	end,
}


VectorIndexMap = {}
setmetatable(VectorIndexMap,{
__call = function(self, ...) 
	local t = arg
	return setmetatable(t, VectorIndexMapmeta) 
end})


