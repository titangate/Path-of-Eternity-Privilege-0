local waits = {w={},c={}}
function coroutinemsg(state,msg)
	if not state then print (msg) end
end
function execute(f)
	coroutinemsg(coroutine.resume(coroutine.create(f)))
end
function wait(time)
	local c = coroutine.running()
	waits.w[c] = love.timer.getTime()+time
	coroutine.yield()
end

function waitUntil(condition)
	local c = coroutine.running()
	waits.c[c] = condition
	coroutine.yield()
end

function waits.update()
	local t = love.timer.getTime()
--	print (t)
	for k,v in pairs(waits.w) do
		if t>=v then
			waits.w[k] = nil
			coroutinemsg(coroutine.resume(k))
		end
	end
	for k,v in pairs(waits.c) do
		if v() then
			waits.c[k] = nil
			coroutinemsg(coroutine.resume(k))
		end
	end
end

function waits.update()
	local t = love.timer.getTime()
	local erase = {}
--	print (t)
	for k,v in pairs(waits.w) do
		if t>=v then
			table.insert(erase,k)
		end
	end
	while #erase>0 do
		local k = table.remove(erase)
		waits.w[k] = nil
		coroutinemsg(coroutine.resume(k))
	end
	for k,v in pairs(waits.c) do
		if v() then
			table.insert(erase,k)
		end
	end

	while #erase>0 do
		local k = table.remove(erase)
		waits.c[k] = nil

			coroutinemsg(coroutine.resume(k))
	end
end

function waits.reset()
	waits.w = {}
	waits.c = {}
end

return waits