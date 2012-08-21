
function hotkey.load(t)
	if t then
		hotkey = t
	end
end

function hotkey.getImageTable()
   return img
end

function hotkey.save()
	
	local s = json.encode(hotkey)
	love.filesystem.write('hotkey',s)
end

return hotkey