require 'love.filesystem'
require 'love.image'


local sourcetable
local function setInThread(thread, key, value)
	assert(value)
  local set = thread.set or thread.send
  return set(thread, key, value)
end

local function getFromThread(thread, key)
  local get = thread.get or thread.receive
  return get(thread, key)
end

local function encode(thread)
	local json = require 'json'
	local filename = getFromThread(thread,'image')
	local scale = getFromThread(thread,'scale')
	local x1 = getFromThread(thread,'x1')
	local y1 = getFromThread(thread,'y1')
	local x2 = getFromThread(thread,'x2')
	local y2 = getFromThread(thread,'y2')
	local table = json.decode(getFromThread(thread,'table'))
	local image = love.image.newImageData((x2-x1+1)*scale,(y2-y1+1)*scale)
	local i,j = 1,1
	completed = 0
	totalcount = (x2-x1+1)*scale*(y2-y1+1)*scale

	for x = x1,x2,scale do
		--table.insert(result,{})
		j = 0
		for y = y1,y2,scale do
			if table[x][y].obstacle_e == 'wall' then
				image:setPixel(i,j,0,0,0,255)
			end
			j = j + 1
			completed = completed + 1
		end
		i = i + 1
	end
	image:encode(filename,'png')
end

local function decode(thread)
	local result = {}
	local img = getFromThread(thread,'image')
	local scale = getFromThread(thread,'scale')
	local x1 = getFromThread(thread,'x1')
	local y1 = getFromThread(thread,'y1')
	local x2 = getFromThread(thread,'x2')
	local y2 = getFromThread(thread,'y2')
	local i,j = 1,1
	completed = 0
	totalcount = math.ceil((x2-x1)/scale)*math.ceil((y2-y1)/scale)
	--print (completed,totalcount)
	for x = x1,x2,scale do
		table.insert(result,{})
			j = 0
		for y = y1,y2,scale do
			local r,g,b,a = img:getPixel(i,j)
			if a>127 then
				result[x][y] = 'wall'
			end
			j = j+1
		end
		i = i + 1
	end
	setInThread(thread,'result',json.encode(result))
end


local process = love.thread.getThread('processor')
if process then
	-- process
	local t = getFromThread(process,'task')
	if t == 'encode' then
		encode(process)
	end
else

	local jobdoneCallback,getTableCallback,task
	local completed,totalcount
	local taskcomplete = true
	
	

	local processor = {}

	local pathToThisFile = (...):gsub("%.", "/") .. ".lua"
	function processor.encodeTableToImageData(t,filename,x1,y1,x2,y2,scale)
		-- encode an image
		task = {
			task = 'encode',
			image = filename,
			x1 = x1,
			y1 = y1,
			x2 = x2,
			y2 = y2,
			scale = scale,
			table = t,
		}
	end

	function processor.getTableFromImageData(image,x1,y1,x2,y2,scale)
		-- deocde an image
		task = {
			task = 'decode',
			image = image,
			x1 = x1,
			y1 = y1,
			x2 = x2,
			y2 = y2,
			scale = scale,
		}
	end

	function processor.start(_getTableCallback,_jobdoneCallback)
		getTableCallback = _getTableCallback
		assert(getTableCallback)
		jobdoneCallback = _jobdoneCallback or function()end
		local thread = love.thread.newThread('processor',pathToThisFile)

		setInThread(thread,'task',task.task)
		setInThread(thread,'image',task.image)
		setInThread(thread,'x1',task.x1)
		setInThread(thread,'y1',task.y1)
		setInThread(thread,'x2',task.x2)
		setInThread(thread,'y2',task.y2)
		setInThread(thread,'scale',task.scale)
		setInThread(thread,'table',json.encode(task.table))

		--setInThread(thread,'getTableCallback',_getTableCallback)
		--setInThread(thread,'jobdoneCallback',_jobdoneCallback)
		taskcomplete = nil
		thread:start()
	end

	function processor.getPercent()
		if completed and totalcount then
			return completed/totalcount
		end
		return -1
	end

	function processor.update(dt)
		local thread = love.thread.getThread('processor')
		if thread then
			if not taskcomplete then 
				if task.task == 'decode' then
					--decode(thread)
				elseif task.task == 'encode' then
					--encode(thread)
				end
			end
		end
	end

	return processor
end