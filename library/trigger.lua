local waits = {w={},c={}}
function coroutinemsg(...)
	print (...)
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

return waits