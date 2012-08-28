local t = {
	hospital = {
		medicine_information_for_cai = {
			text = "DOSE FOR CAI'S PSYCHOLOGICAL TREATMENT INCLUDES CAFFINE.",
			cost = 10,
			icon = 'item/needle.png',
			class = 'clue',
		},

		medicine_location = {
			text = 'PRESCRIPTION DRUGS ARE IS LOCKED AWAY IN THE SAFE IN DRUG STORAGE.',
			cost = 10,
			icon = 'item/needle.png',
			class = 'clue',
		},

		poisonmedicine = {
			text = "BY INJECTING TETROTOXIDE INTO CAI'S DESIGNATED MEDICINE, IT WILL LIKELY BE TREATED AS A MEDICAL INCIDENT.",
			cost = 30,
			icon = 'item/needle.png',
			class = 'assassination_method',
			combo = {'medicine_information_for_cai','medicine_location'}
		},

		poisonmedicine_advanced = {
			text = "BY INJECTING TETROTOXIDE INTO CAI'S DESIGNATED MEDICINE, IT WILL LIKELY BE TREATED AS A MEDICAL INCIDENT.",
			cost = 30,
			icon = 'item/needle.png',
			class = 'assassination_method',
			combo = {'medicine_information_for_cai','medicine_location',}
		},

	}
}


return t