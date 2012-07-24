
local startgamepanel = loveframes.Create"panel"
function startgamepanel.Draw() end

local text1 = loveframes.Create("text", startgamepanel)
text1:setText("GAMEPLAY STUFF HERE")
text1:SetAlwaysUpdate(true)
text1.Update = function(object, dt)
	object:Center()
end
tabs1:AddTab(LocalizedString"GAMEPLAY", startgamepanel)

local imagebutton1 = loveframes.Create("circlebutton", startgamepanel)
imagebutton1:setImage("asset/difficulty/normal.png")
imagebutton1:setPos(5, 30)
imagebutton1:setText(LocalizedString"NORMAL")
imagebutton1:setSize(96,96)
imagebutton1.active = true

local imagebutton2 = loveframes.Create("circlebutton", startgamepanel)
imagebutton2:setImage("asset/difficulty/hard.png")
imagebutton2:setPos(150, 30)
imagebutton2:setText(LocalizedString"HARD")
imagebutton2:setSize(96,96)

local imagebutton3 = loveframes.Create("circlebutton", startgamepanel)
imagebutton3:setImage("asset/difficulty/brutal.png")
imagebutton3:setPos(295, 30)
imagebutton3:setText(LocalizedString"BRUTAL")
imagebutton3:setSize(96,96)

local function switchDifficulty(object)
	imagebutton1.active = false
	imagebutton2.active = false
	imagebutton3.active = false
	object.active = true
end
imagebutton1.OnClick = switchDifficulty
imagebutton2.OnClick = switchDifficulty
imagebutton3.OnClick = switchDifficulty