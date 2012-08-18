local hospital = {
	name = 'BLOOD DEBT',
	city = 'LONDON',
	location = 'GENERAL HOSPITAL',
	targets = {
	cai = {
		name = 'CAI ZHONG ZHENG',
		gender = 'MALE',
		height = '1.76M',
		weight = '75KG',
		age = 45,
		description = 'Local Triad lord. Recently charged with murder of two innocent girls. Claimed by our client, pled insanity and bribed a psychiatrist to testify for him. He was ruled not guilty, but was sent to hospital until total recovery. He has a short temper, a tough one to get along with.',
		picture = 'mission/river_body.png',
		portrait = 'mission/river_potrait.jpg',
		status = 'ALIVE',
		statusdescription = 'Cai is still alive.'
	},

	},
	objectives = {
	escape = {
		name = 'ESCAPE',
		description = 'Escape the area.',
		status = 'COMPLETED',
		statusdescription = 'Not completed',
		picture = 'mission/exit.png',
		portrait = 'mission/exit.png',
		},
	},
}

local mr = {hospital = hospital,}

return mr