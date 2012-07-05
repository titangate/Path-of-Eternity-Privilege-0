local t = {["Use mindpower to generate a spiritual mist, hallucinate enemies and grant yourself invisibility. Using any skill or item will cancel your invisibility. The first strike you fire with invisibility will be a garanteed critical strike."]="使用精神力量把自己包裹在一团雾气之中，致幻敌人并隐身。使用任何技能将会取消技能效果。在显身时的一击将会是必中的致命一击。",
["Duration"]="持续时间",
["You have vanished from enemys' sights."]="你在敌人视线中消失了",
["INVISIBILITY"]="隐身术",
["ACTIVE"]="主动技能",
["Buff"]="技能效果",
["Invisibility"]="隐身术",
["隐身术"] = 1,
}

local ts = {
	'localization.chr2',
	'localization.chr3',
	'localization.chr4',
}
for i,tm in ipairs(ts) do
	tm = require(tm)
	for k,v in pairs(tm) do
		if #v>0 then
			t[k] = v
		end
	end
end


return treturn {
["START GAME"]="",
["NAME: LILY ROSEMARIE HAMILTON"]="",
["HEARTRATE: "]="",
["START HOSPTIAL GAMEPLAY DEMO"]="",
["RESUME GAME"]="",
["GENDER: FEMALE"]="",
["HOSPITALIZED IN SINCE: JUL 1, 2012"]="",
["BLOOD PRESSURE: %d/%d mmHg"]="",
["DATE OF BIRTH: DEC/16/1993"]="",
["RACE: CAUCASIAN"]="",
["RESTART FROM LAST CHECKPOINT"]="",
["str"]="",
["STATUS: COMA"]="",
["Path of Eternity Priviledge Zero // frame time: %.2fms (%d fps)."]="",
["DATE: JUL 11, 2012"]="",
["EXIT TO OPERATION SYSTEM"]="",
["QUIT GAME"]="",
["HEIGHT: 1.60 M"]="",
}
