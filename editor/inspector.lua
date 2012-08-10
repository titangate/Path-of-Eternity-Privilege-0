function Unit:fillInspector(editor,list)
	local te = loveframes.Create('text',list)
	te:setText(LocalizedString'OBJECT SELECTED')
	te:SetFont(font.imagebuttonfont)
	editor.namefield = te
	editor.atts = {}
	local at = {'x','y','angle','identifier'}
	for i,v in ipairs(at) do
		local te = loveframes.Create('text',list)
		te:setText(v)
		te:SetFont(font.imagebuttonfont)
		te:SetWidth(450)
		local ti = loveframes.Create('textinput',list)
		editor.atts[v]={text = te,box = ti}
	end

	editor.atts.identifier.box.OnEnter = function(object,text)
		editor.sel:setIdentifier(text)
	end

	local deletebutton = loveframes.Create('button',list)
	deletebutton:setText(LocalizedString'DELETE OBJECT')
	deletebutton:setSize(100,20)
	deletebutton.OnClick = function(object)
		if editor.sel then
			assert(editor.map)
			editor.map:removeUnit(editor.sel)
		end
	end
end

function River:fillInspector(editor,list)
	Unit.fillInspector(self,editor,list)
	local removePatrolPath = loveframes.Create('button',list)
	removePatrolPath:setText(LocalizedString'REMOVE PATROL PATH')
	removePatrolPath:setSize(100,20)
	removePatrolPath.OnClick = function(object)
		if editor.sel then
			assert(editor.map)
			editor.sel.patrolpath = nil
		end
	end
end

function PatrolPath:fillInspector(editor,list,unit)
	for i,v in ipairs(unit.waypoint) do
		local te = loveframes.Create('text',list)
		te:setText(LocalizedString'stops for')
		te:SetFont(font.imagebuttonfont)
		te:SetWidth(450)
		local ti = loveframes.Create('textinput',list)
		ti:setText(tostring(unit.waypoint[i][4] or 0))
		ti.OnEnter = function(object,text)
			unit.waypoint[i][4] = tonumber(text)
		end

		local te = loveframes.Create('text',list)
		te:setText(LocalizedString'while facing')
		te:SetFont(font.imagebuttonfont)
		te:SetWidth(450)
		local ti = loveframes.Create('textinput',list)
		ti:setText(tostring(unit.waypoint[i][3] or 0))
		ti.OnEnter = function(object,text)
			unit.waypoint[i][3] = tonumber(text)
		end

		local split = loveframes.Create('text',list)
		split:setText(' ')
	end

end