local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

-- Level 60 rating base
StatLogic.RatingBase = {
	[StatLogic.Stats.DodgeRating] = 20.700001,
	[StatLogic.Stats.ParryRating] = 20.700001,
	[StatLogic.Stats.BlockRating] = 6.900001,
	[StatLogic.Stats.MeleeHitRating] = 8,
	[StatLogic.Stats.RangedHitRating] = 8,
	[StatLogic.Stats.SpellHitRating] = 8,
	[StatLogic.Stats.MeleeCritRating] = 14,
	[StatLogic.Stats.RangedCritRating] = 14,
	[StatLogic.Stats.SpellCritRating] = 14,
	[StatLogic.Stats.ResilienceRating] = 9.29154,
	[StatLogic.Stats.MeleeHasteRating] = 10,
	[StatLogic.Stats.RangedHasteRating] = 10,
	[StatLogic.Stats.SpellHasteRating] = 10,
	[StatLogic.Stats.ExpertiseRating] = 8,
	[StatLogic.Stats.MasteryRating] = 14,
	[StatLogic.Stats.PvPPowerRating] = 14,
}

local NormalManaRegenPerSpi = function(level)
	return 0
end

local NormalManaRegenPerInt = function(level)
	return 0
end

local ten_thousandth = setmetatable({}, { __index = function()
	return 0.0001
end})

-- Extracted from gtChanceToMeleeCrit.db2 or from gametables/chancetomeleecrit.txt via wow.tools or wago.tools
addon.CritPerAgi = {
	["WARRIOR"] = ten_thousandth,
	["PALADIN"] = ten_thousandth,
	["HUNTER"] = {
		0.28399998, 0.28343450, 0.27107434, 0.25299009, 0.24300528, 0.23373590, 0.22510740, 0.21705529, 0.20513687, 0.19836421,
		0.18475310, 0.16697281, 0.15469900, 0.14408800, 0.13299321, 0.12666360, 0.11942229, 0.11166529, 0.10597830, 0.09980580,
		0.09615530, 0.09103050, 0.08718610, 0.08293830, 0.07972230, 0.07674040, 0.07341370, 0.07086710, 0.06801100, 0.06537160,
		0.06374390, 0.06141140, 0.05923970, 0.05754870, 0.05563030, 0.05412970, 0.05242280, 0.05081710, 0.04930400, 0.04811060,
		0.04697090, 0.04566750, 0.04443200, 0.04325920, 0.04214440, 0.04125640, 0.04023690, 0.03910780, 0.03818660, 0.03730590,
		0.03659920, 0.03578580, 0.03500600, 0.03413840, 0.03342470, 0.03284840, 0.03207870, 0.03144330, 0.03073430, 0.03014770,
		0.02967120, 0.02903510, 0.02842440, 0.02791680, 0.02734930, 0.02695050, 0.02641880, 0.02590650, 0.02541260, 0.02499810,
		0.02323340, 0.02159340, 0.02006910, 0.01865240, 0.01733570, 0.01611190, 0.01497460, 0.01391750, 0.01293510, 0.01202200,
		0.00920000, 0.00700000, 0.00530000, 0.00400000, 0.00310000, 0.00236497, 0.00179860, 0.00136889, 0.00104272, 0.00079395,
	},
	["ROGUE"] = {
		0.44760874, 0.42895829, 0.41180005, 0.38129635, 0.36767855, 0.35500005, 0.33209683, 0.32171875, 0.31196965, 0.29414291,
		0.26397441, 0.23941860, 0.21447919, 0.19798079, 0.17749999, 0.16604841, 0.15598490, 0.14499999, 0.13546050, 0.12709880,
		0.11970930, 0.11438890, 0.10836840, 0.10398989, 0.09804760, 0.09359090, 0.09030700, 0.08651260, 0.08302420, 0.07919230,
		0.07682840, 0.07406480, 0.07149310, 0.06909400, 0.06641940, 0.06434380, 0.06277440, 0.06091720, 0.05916670, 0.05719440,
		0.05564870, 0.05418420, 0.05279490, 0.05121890, 0.04973430, 0.04856130, 0.04744240, 0.04637390, 0.04535240, 0.04399570,
		0.04307530, 0.04219260, 0.04118000, 0.04037260, 0.03944440, 0.03855810, 0.03784930, 0.03703240, 0.03637810, 0.03550000,
		0.03342530, 0.03217190, 0.03063990, 0.02958330, 0.02859720, 0.02767470, 0.02680990, 0.02619590, 0.02560950, 0.02498790,
		0.02323930, 0.02158280, 0.02006820, 0.01865040, 0.01733170, 0.01611110, 0.01496370, 0.01391220, 0.01293340, 0.01202690,
		0.00920000, 0.00700000, 0.00530000, 0.00400000, 0.00310000, 0.00236497, 0.00179860, 0.00136889, 0.00104272, 0.00079395,
	},
	["PRIEST"] = {
		0.09117501, 0.09117501, 0.09117501, 0.08683330, 0.08683330, 0.08683330, 0.08683330, 0.08288640, 0.08288640, 0.08288640,
		0.08288640, 0.07928260, 0.07928260, 0.07928260, 0.07928260, 0.07597920, 0.07597920, 0.07597920, 0.07294000, 0.07294000,
		0.07294000, 0.07294000, 0.07013460, 0.07013460, 0.07013460, 0.06753700, 0.06753700, 0.06753700, 0.06512500, 0.06512500,
		0.06512500, 0.06287930, 0.06287930, 0.06287930, 0.06078330, 0.06078330, 0.06078330, 0.05882260, 0.05882260, 0.05882260,
		0.05698440, 0.05698440, 0.05525760, 0.05525760, 0.05525760, 0.05363240, 0.05363240, 0.05210000, 0.05210000, 0.05210000,
		0.05065280, 0.05065280, 0.04928380, 0.04928380, 0.04798680, 0.04798680, 0.04675640, 0.04675640, 0.04558750, 0.04558750,
		0.04449120, 0.04458550, 0.04426580, 0.04344670, 0.04271900, 0.04207770, 0.04151880, 0.04133470, 0.04117830, 0.04014610,
		0.03721430, 0.03440570, 0.03199120, 0.02989340, 0.02762880, 0.02568310, 0.02399340, 0.02223780, 0.02072160, 0.01919470,
		0.01460000, 0.01110000, 0.00850000, 0.00650000, 0.00490000, 0.00373818, 0.00284295, 0.00216372, 0.00164817, 0.00125496,
	},
	["DEATHKNIGHT"] = ten_thousandth,
	["SHAMAN"] = {
		0.10389999, 0.10389999, 0.09895240, 0.09895240, 0.09445460, 0.09445460, 0.09445460, 0.09034780, 0.09034780, 0.08658330,
		0.08658330, 0.08312000, 0.08312000, 0.07992310, 0.07696300, 0.07421430, 0.07421430, 0.07165520, 0.07165520, 0.06703230,
		0.06703230, 0.06493750, 0.06493750, 0.06296970, 0.06111770, 0.05937140, 0.05937140, 0.05772220, 0.05772220, 0.05468420,
		0.05468420, 0.05328210, 0.05195000, 0.05195000, 0.04947620, 0.04832560, 0.04832560, 0.04722730, 0.04722730, 0.04517390,
		0.04421280, 0.04421280, 0.04329170, 0.04240820, 0.04156000, 0.04074510, 0.03996150, 0.03920760, 0.03920760, 0.03778180,
		0.03710710, 0.03645610, 0.03645610, 0.03582760, 0.03463330, 0.03406560, 0.03351610, 0.03351610, 0.03298410, 0.03196920,
		0.03102490, 0.03040300, 0.02935380, 0.02848270, 0.02807010, 0.02734040, 0.02668210, 0.02608150, 0.02552060, 0.02499630,
		0.02323170, 0.02159180, 0.02006760, 0.01865100, 0.01733440, 0.01611080, 0.01497350, 0.01391650, 0.01293410, 0.01202110,
		0.00920000, 0.00700000, 0.00530000, 0.00400000, 0.00310000, 0.00236497, 0.00179860, 0.00136889, 0.00104272, 0.00079395,
	},
	["MAGE"] = {
		0.07730000, 0.07730000, 0.07730000, 0.07361910, 0.07361910, 0.07361910, 0.07361910, 0.07361910, 0.07361910, 0.07027270,
		0.07027270, 0.07027270, 0.07027270, 0.07027270, 0.06721740, 0.06721740, 0.06721740, 0.06721740, 0.06721740, 0.06441670,
		0.06441670, 0.06441670, 0.06441670, 0.06184000, 0.06184000, 0.06184000, 0.06184000, 0.06184000, 0.05946150, 0.05946150,
		0.05946150, 0.05946150, 0.05725930, 0.05725930, 0.05725930, 0.05521430, 0.05521430, 0.05521430, 0.05521430, 0.05331030,
		0.05331030, 0.05331030, 0.05331030, 0.05153330, 0.05153330, 0.05153330, 0.04987100, 0.04987100, 0.04987100, 0.04831250,
		0.04831250, 0.04831250, 0.04684850, 0.04684850, 0.04684850, 0.04547060, 0.04547060, 0.04547060, 0.04417140, 0.04417140,
		0.04417140, 0.04417140, 0.04294440, 0.04294440, 0.04294440, 0.04178380, 0.04178380, 0.04178380, 0.04068420, 0.04068420,
		0.03770730, 0.03513640, 0.03289360, 0.03031370, 0.02810910, 0.02620340, 0.02415630, 0.02273530, 0.02089190, 0.01956960,
		0.01490000, 0.01140000, 0.00860000, 0.00660000, 0.00500000, 0.00381447, 0.00290097, 0.00220788, 0.00168180, 0.00128057,
	},
	["WARLOCK"] = {
		0.11890000, 0.11890000, 0.11323810, 0.11323810, 0.11323810, 0.10809090, 0.10809090, 0.10809090, 0.10339131, 0.10339131,
		0.09908330, 0.09908330, 0.09908330, 0.09588690, 0.09435100, 0.09284449, 0.09136671, 0.08991690, 0.08849440, 0.08709860,
		0.08572890, 0.08438450, 0.08306500, 0.08176980, 0.08049830, 0.07924990, 0.07802420, 0.07682060, 0.07563860, 0.07447780,
		0.07333770, 0.07221780, 0.07111770, 0.07003690, 0.06897500, 0.06793170, 0.06690660, 0.06589910, 0.06490910, 0.06393600,
		0.06297960, 0.06203950, 0.06111540, 0.06020690, 0.05931370, 0.05843550, 0.05757210, 0.05672300, 0.05588810, 0.05506700,
		0.05425950, 0.05346520, 0.05268400, 0.05191560, 0.05115970, 0.05041620, 0.04968460, 0.04896490, 0.04825680, 0.04756000,
		0.04687440, 0.04619980, 0.04553590, 0.04488260, 0.04423960, 0.04360670, 0.04298380, 0.04237070, 0.04176730, 0.04117320,
		0.03835480, 0.03549250, 0.03302780, 0.03088310, 0.02865060, 0.02642220, 0.02451550, 0.02286540, 0.02123210, 0.01981670,
		0.01510000, 0.01150000, 0.00870000, 0.00670000, 0.00510000, 0.00389076, 0.00295899, 0.00225204, 0.00171544, 0.00130618,
	},
	["MONK"] = {
		0.12622500, 0.12622500, 0.12021430, 0.12021430, 0.11475000, 0.11475000, 0.10976091, 0.10976091, 0.10518750, 0.09709619,
		0.09349999, 0.09349999, 0.09016070, 0.09016070, 0.08415000, 0.08415000, 0.08143550, 0.07889060, 0.07889060, 0.07012500,
		0.07012500, 0.06822970, 0.06643420, 0.06643420, 0.06311250, 0.06311250, 0.06157320, 0.06010710, 0.06010710, 0.05488040,
		0.05371280, 0.05371280, 0.05259380, 0.05152040, 0.05049000, 0.04950000, 0.04854810, 0.04854810, 0.04763210, 0.04428950,
		0.04352590, 0.04352590, 0.04278810, 0.04207500, 0.04071770, 0.04007140, 0.04007140, 0.03944530, 0.03883850, 0.03658700,
		0.03606430, 0.03555630, 0.03506250, 0.03506250, 0.03411490, 0.03366000, 0.03321710, 0.03278570, 0.03236540, 0.03078660,
		0.02988460, 0.02950110, 0.02849640, 0.02791070, 0.02738060, 0.02690250, 0.02647340, 0.02577280, 0.02537310, 0.02499810,
		0.02323340, 0.02159340, 0.02006910, 0.01865240, 0.01733570, 0.01611190, 0.01497460, 0.01391750, 0.01293510, 0.01202200,
		0.00920000, 0.00700000, 0.00530000, 0.00400000, 0.00310000, 0.00236497, 0.00179860, 0.00136889, 0.00104272, 0.00079395,
	},
	["DRUID"] = {
		0.12622500, 0.12622500, 0.12021430, 0.12021430, 0.11475000, 0.11475000, 0.10976091, 0.10976091, 0.10518750, 0.09709619,
		0.09349999, 0.09349999, 0.09016070, 0.09016070, 0.08415000, 0.08415000, 0.08143550, 0.07889060, 0.07889060, 0.07012500,
		0.07012500, 0.06822970, 0.06643420, 0.06643420, 0.06311250, 0.06311250, 0.06157320, 0.06010710, 0.06010710, 0.05488040,
		0.05371280, 0.05371280, 0.05259380, 0.05152040, 0.05049000, 0.04950000, 0.04854810, 0.04854810, 0.04763210, 0.04428950,
		0.04352590, 0.04352590, 0.04278810, 0.04207500, 0.04071770, 0.04007140, 0.04007140, 0.03944530, 0.03883850, 0.03658700,
		0.03606430, 0.03555630, 0.03506250, 0.03506250, 0.03411490, 0.03366000, 0.03321710, 0.03278570, 0.03236540, 0.03078660,
		0.02988460, 0.02950110, 0.02849640, 0.02791070, 0.02738060, 0.02690250, 0.02647340, 0.02577280, 0.02537310, 0.02499810,
		0.02323340, 0.02159340, 0.02006910, 0.01865240, 0.01733570, 0.01611190, 0.01497460, 0.01391750, 0.01293510, 0.01202200,
		0.00920000, 0.00700000, 0.00530000, 0.00400000, 0.00310000, 0.00236497, 0.00179860, 0.00136889, 0.00104272, 0.00079395,
	},
}

-- Extracted from gtChanceToSpellCrit.db2 or from gametables/chancetospellcrit.txt via wow.tools or wago.tools
addon.SpellCritPerInt = {
	["WARRIOR"] = ten_thousandth,
	["PALADIN"] = {
		0.08322500, 0.07926190, 0.07926190, 0.07565909, 0.07565909, 0.07236956, 0.06935417, 0.06935417, 0.06658000, 0.06658000,
		0.06401923, 0.06164815, 0.05944643, 0.05739655, 0.05369355, 0.05369355, 0.05201562, 0.04895588, 0.04895588, 0.04623611,
		0.04498649, 0.04380263, 0.04267949, 0.04161250, 0.03963095, 0.03870930, 0.03870930, 0.03698889, 0.03618478, 0.03467708,
		0.03396939, 0.03329000, 0.03263725, 0.03200962, 0.03082408, 0.03026364, 0.02972321, 0.02869828, 0.02821187, 0.02728689,
		0.02684677, 0.02642063, 0.02560769, 0.02560769, 0.02484328, 0.02447794, 0.02377857, 0.02311806, 0.02280137, 0.02219333,
		0.02190131, 0.02161688, 0.02106962, 0.02080625, 0.02029878, 0.02005422, 0.01981548, 0.01913218, 0.01891477, 0.01849444,
		0.01585238, 0.01541204, 0.01486161, 0.01447391, 0.01398739, 0.01364344, 0.01342339, 0.01310630, 0.01280385, 0.01251504,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["HUNTER"] = ten_thousandth,
	["ROGUE"] = ten_thousandth,
	["PRIEST"] = {
		0.17102273, 0.16358695, 0.15677085, 0.15050001, 0.13935185, 0.13437499, 0.12974138, 0.12541667, 0.12137098, 0.11401515,
		0.10451388, 0.09406250, 0.08750000, 0.07838542, 0.07235577, 0.06840909, 0.06270833, 0.05972222, 0.05615672, 0.05225694,
		0.05016666, 0.04703125, 0.04533132, 0.04275568, 0.04089674, 0.03919271, 0.03762500, 0.03617789, 0.03483796, 0.03329646,
		0.03215812, 0.03109504, 0.03010000, 0.02894231, 0.02807836, 0.02726449, 0.02631119, 0.02559524, 0.02491722, 0.02411859,
		0.02351562, 0.02280303, 0.02226331, 0.02162356, 0.02101955, 0.02056011, 0.02001330, 0.01959635, 0.01909899, 0.01862624,
		0.01826456, 0.01783175, 0.01750000, 0.01710227, 0.01664823, 0.01635870, 0.01601064, 0.01574268, 0.01535714, 0.01505000,
		0.01481299, 0.01447115, 0.01425189, 0.01393519, 0.01368182, 0.01343750, 0.01320175, 0.01297414, 0.01271115, 0.01250000,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["DEATHKNIGHT"] = ten_thousandth,
	["SHAMAN"] = {
		0.13328572, 0.12722727, 0.12169566, 0.12169566, 0.11662501, 0.11195999, 0.10765384, 0.10366667, 0.09996429, 0.09996429,
		0.09330000, 0.08746875, 0.07997143, 0.07564865, 0.06997500, 0.06664286, 0.06361364, 0.05955319, 0.05712245, 0.05382692,
		0.05183333, 0.04998214, 0.04744068, 0.04588525, 0.04373438, 0.04240909, 0.04116176, 0.03942254, 0.03834246, 0.03682895,
		0.03543038, 0.03455555, 0.03332143, 0.03254651, 0.03144944, 0.03042391, 0.02977659, 0.02885567, 0.02827273, 0.02717476,
		0.02665714, 0.02615888, 0.02544545, 0.02476991, 0.02412931, 0.02352101, 0.02313223, 0.02257258, 0.02203937, 0.02153077,
		0.02104511, 0.02073333, 0.02013669, 0.01985106, 0.01930345, 0.01904082, 0.01866000, 0.01817532, 0.01794231, 0.01749375,
		0.01638977, 0.01585243, 0.01519881, 0.01467376, 0.01422447, 0.01378727, 0.01338805, 0.01307383, 0.01277848, 0.01250000,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["MAGE"] = {
		0.16369999, 0.15740384, 0.15157406, 0.14112069, 0.13641668, 0.13201613, 0.12789063, 0.12401515, 0.11692857, 0.11368056,
		0.10493589, 0.09301137, 0.08707447, 0.07308036, 0.06709017, 0.06394531, 0.06018382, 0.05684028, 0.05384868, 0.05052469,
		0.04872024, 0.04598314, 0.04448370, 0.04219072, 0.04051980, 0.03897619, 0.03720454, 0.03382231, 0.03248016, 0.03124046,
		0.03054105, 0.02944245, 0.02861888, 0.02784014, 0.02692434, 0.02623397, 0.02541926, 0.02480303, 0.02407353, 0.02352011,
		0.02299157, 0.02153947, 0.02109536, 0.02056533, 0.02006127, 0.01967548, 0.01921362, 0.01877294, 0.01835202, 0.01794956,
		0.01764009, 0.01726793, 0.01698133, 0.01656883, 0.01624008, 0.01544340, 0.01510148, 0.01488182, 0.01456406, 0.01430944,
		0.01430944, 0.01430944, 0.01430944, 0.01425958, 0.01421007, 0.01377946, 0.01337418, 0.01311699, 0.01282915, 0.01251529,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["WARLOCK"] = {
		0.15000002, 0.14347826, 0.13749999, 0.13200001, 0.12692307, 0.12222222, 0.11785715, 0.11379310, 0.11000000, 0.10645162,
		0.09705883, 0.08918919, 0.08250000, 0.07674419, 0.07173913, 0.06875000, 0.06346154, 0.06000000, 0.05689655, 0.05409836,
		0.05156250, 0.04925373, 0.04714286, 0.04459460, 0.04285714, 0.04177215, 0.03975903, 0.03837209, 0.03666667, 0.03548387,
		0.03473684, 0.03333333, 0.03235294, 0.03113208, 0.03027523, 0.02946429, 0.02844828, 0.02773109, 0.02682927, 0.02619047,
		0.02558140, 0.02481203, 0.02426471, 0.02357143, 0.02291667, 0.02244898, 0.02200000, 0.02142857, 0.02088608, 0.02037037,
		0.02000000, 0.01952663, 0.01907514, 0.01864407, 0.01823204, 0.01793478, 0.01755319, 0.01718750, 0.01683673, 0.01650000,
		0.01590571, 0.01540285, 0.01476212, 0.01428429, 0.01384886, 0.01345145, 0.01302733, 0.01273351, 0.01261621, 0.01250000,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["MONK"] = {
		0.14311364, 0.13689130, 0.13118751, 0.12594000, 0.12109616, 0.11661111, 0.11244642, 0.11244642, 0.10856897, 0.09839062,
		0.09260294, 0.08509459, 0.08073077, 0.07496429, 0.06844565, 0.06559375, 0.06173530, 0.05940566, 0.05622322, 0.05161475,
		0.04997619, 0.04770455, 0.04630147, 0.04372917, 0.04198000, 0.04088961, 0.03935625, 0.03839634, 0.03661047, 0.03459890,
		0.03385484, 0.03245876, 0.03180303, 0.03086765, 0.02970283, 0.02915278, 0.02836487, 0.02761842, 0.02691026, 0.02559756,
		0.02518800, 0.02440698, 0.02403435, 0.02332222, 0.02281522, 0.02232979, 0.02186458, 0.02141837, 0.02085099, 0.02018269,
		0.01980189, 0.01931595, 0.01908182, 0.01863018, 0.01819942, 0.01788920, 0.01758939, 0.01729945, 0.01692742, 0.01639844,
		0.01615364, 0.01565851, 0.01502430, 0.01457144, 0.01415761, 0.01373175, 0.01334287, 0.01305882, 0.01277076, 0.01250000,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
	["DRUID"] = {
		0.14311364, 0.13689130, 0.13118751, 0.12594000, 0.12109616, 0.11661111, 0.11244642, 0.11244642, 0.10856897, 0.09839062,
		0.09260294, 0.08509459, 0.08073077, 0.07496429, 0.06844565, 0.06559375, 0.06173530, 0.05940566, 0.05622322, 0.05161475,
		0.04997619, 0.04770455, 0.04630147, 0.04372917, 0.04198000, 0.04088961, 0.03935625, 0.03839634, 0.03661047, 0.03459890,
		0.03385484, 0.03245876, 0.03180303, 0.03086765, 0.02970283, 0.02915278, 0.02836487, 0.02761842, 0.02691026, 0.02559756,
		0.02518800, 0.02440698, 0.02403435, 0.02332222, 0.02281522, 0.02232979, 0.02186458, 0.02141837, 0.02085099, 0.02018269,
		0.01980189, 0.01931595, 0.01908182, 0.01863018, 0.01819942, 0.01788920, 0.01758939, 0.01729945, 0.01692742, 0.01639844,
		0.01615364, 0.01565851, 0.01502430, 0.01457144, 0.01415761, 0.01373175, 0.01334287, 0.01305882, 0.01277076, 0.01250000,
		0.01162642, 0.01079815, 0.01005528, 0.00934361, 0.00868896, 0.00807199, 0.00749542, 0.00697189, 0.00647547, 0.00601838,
		0.00458339, 0.00349034, 0.00265690, 0.00202346, 0.00154105, 0.00117566, 0.00089411, 0.00068049, 0.00051835, 0.00039469,
	},
}

addon.DodgePerAgi = {
	["WARRIOR"] = ten_thousandth,
	["PALADIN"] = ten_thousandth,
	["HUNTER"] = {
		[85] = 0.002273,
	},
	["ROGUE"] = {
		[85] = 0.004107,
	},
	["PRIEST"] = ten_thousandth,
	["DEATHKNIGHT"] = ten_thousandth,
	["SHAMAN"] = {
		[85] = 0.003289,
	},
	["MAGE"] = ten_thousandth,
	["MONK"] = {
		[85] = 0.004105,
	},
	["WARLOCK"] = ten_thousandth,
	["DRUID"] = {
		[85] = 0.004105,
	},
}

addon.ParryPerStr = {
	["WARRIOR"] = {
		[85] = 0.004105,
	},
	["PALADIN"] = {
		[85] = 0.004105,
	},
	["HUNTER"] = addon.zero,
	["ROGUE"] = ten_thousandth,
	["PRIEST"] = addon.zero,
	["DEATHKNIGHT"] = {
		[85] = 0.004105,
	},
	["SHAMAN"] = ten_thousandth,
	["MAGE"] = addon.zero,
	["MONK"] = ten_thousandth,
	["WARLOCK"] = addon.zero,
	["DRUID"] = addon.zero,
}

addon.bonusArmorInventoryTypes = {
	["INVTYPE_WEAPON"] = true,
	["INVTYPE_2HWEAPON"] = true,
	["INVTYPE_WEAPONMAINHAND"] = true,
	["INVTYPE_WEAPONOFFHAND"] = true,
	["INVTYPE_HOLDABLE"] = true,
	["INVTYPE_RANGED"] = true,
	["INVTYPE_THROWN"] = true,
	["INVTYPE_RANGEDRIGHT"] = true,
	["INVTYPE_NECK"] = true,
	["INVTYPE_FINGER"] = true,
	["INVTYPE_TRINKET"] = true,
}

addon.baseArmorTable = {}

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Total Eclipse
			{
				["spec"] = 1,
				["value"] = 1.875,
			},
			-- Mastery: Razor Claws (Cat Form)
			{
				["spec"] = 2,
				["value"] = 3.13,
				["aura"] = 768,
			},
			-- Mastery: Nature's Guardian (Bear Form)
			{
				["spec"] = 2,
				["value"] = 2,
				["aura"] = 5487,
			},
			-- Mastery: Harmony
			{
				["spec"] = 3,
				["value"] = 1.25,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Druid: Cat Form - Buff
			{
				["value"] = 2,
				["aura"] = 768,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Druid: Bear Form - Buff
			{
				["value"] = 2,
				["aura"] = 5487,
				["group"] = addon.ExclusiveGroup.Feral,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["MOD_ARMOR"] = {
			-- Buff: Bear Form
			{
				["aura"] = 5487,
				["value"] = 1.2,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Passive: Thick Hide (Bear Form)
			{
				["aura"] = 5487,
				["value"] = 3.3,
				["group"] = addon.ExclusiveGroup.Feral,
				["known"] = 16931,
			},
			-- Buff: Tree of Life
			{
				["value"] = 1.2,
				["aura"] = 33891,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Passive: Mastery: Nature's Guardian
			-- TODO: Get value from tooltip?
			{
				["known"] = 77494,
				["value"] = 0.16,
			},
			-- Buff: Moonkin Form
			{
				["value"] = 1.0,
				["aura"] = 24858,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Buff: Tree of Life Form
			{
				["value"] = 1.2,
				["aura"] = 33891,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Talent: Heart of the Wild (Bear Form)
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 0.95,
				["aura"] = 5487,
			},
		},
		["MOD_AGI"] = {
			-- Leather Specialization (Feral)
			{
				["value"] = 0.05,
				["armorspec"] = {
					[2] = true,
				},
				["known"] = 86097,
			},
			-- Talent: Heart of the Wild
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 0.06,
			},
			-- Talent: Heart of the Wild (Bear Form)
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 0.5,
				["aura"] = 5487,
			},
			-- Talent: Heart of the Wild (Cat Form)
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 1.1,
				["aura"] = 768,
			},
		},
		["MOD_STA"] = {
			-- Buff: Bear Form
			{
				["aura"] = 5487,
				["value"] = 0.4,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Leather Specialization (Guardian) (Bear Form)
			{
				["value"] = 0.05,
				["armorspec"] = {
					[3] = true,
				},
				["known"] = 86096,
				["aura"] = 5487,
			},
			-- Talent: Heart of the Wild
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 0.06,
			},
		},
		["MOD_INT"] = {
			-- Leather Specialization (Balance, Restoration)
			{
				["value"] = 0.05,
				["armorspec"] = {
					[1] = true,
					[4] = true,
				},
				["spellid"] = 86104,
			},
			-- Talent: Heart of the Wild
			{
				["tab"] = 6,
				["num"] = 1,
				["value"] = 0.06,
			},
		},
		["MOD_HASTE_RATING"] = {
			-- Buff: Bear Form
			{
				["aura"] = 5487,
				["value"] = 0.5,
			},
		},
		["MOD_CRIT_RATING"] = {
			-- Buff: Bear Form
			{
				["aura"] = 5487,
				["value"] = 0.5,
			},
		},
		["MOD_HEALTH"] = {
			-- Buff: Might of Ursoc
			{
				["aura"] = 106922,
				["value"] = 0.3,
			},
		},
		["ADD_DODGE"] = {
			-- Buff: Savage Defense
			{
				["aura"] = 62606,
				["value"] = 45,
			},
		},
		["ADD_NATURE_DAMAGE_MOD_AGI"] = {
			-- Passive: Nurturing Instinct
			{
				["known"] = 33873,
				["value"] = 1,
			},
		},
		["ADD_HEALING_MOD_AGI"] = {
			-- Passive: Nurturing Instinct
			{
				["known"] = 33873,
				["value"] = 1,
			},
		},
		["ADD_HIT_RATING_MOD_SPI"] = {
			-- Passive: Balance of Power
			{
				["known"] = 33596,
				["value"] = 1,
			},
		},
		["ADD_AGI_MOD_INT"] = {
			-- Passive: Killer Instinct
			{
				["known"] = 108299,
				["value"] = 1,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Passive: Meditation
			{
				["known"] = 85101,
				["value"] = 0.5,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Ysera's Gift
			{
				["tab"] = 2,
				["num"] = 1,
				["value"] = 0.05,
			},
		},
	}
elseif addon.class == "DEATHKNIGHT" then
	StatLogic.StatModTable["DEATHKNIGHT"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Blood Shield
			{
				["spec"] = 1,
				["value"] = 6.25,
			},
			-- Mastery: Frozen Heart
			{
				["spec"] = 2,
				["value"] = 2,
			},
			-- Mastery: Dreadblade
			{
				["spec"] = 3,
				["value"] = 2.5,
			},
		},
		["ADD_DODGE"] = {
			-- Veteran of the Third War
			{
				["known"] = 50029,
				["value"] = 2,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
			-- Buff: Dancing Rune Weapon
			{
				["aura"] = 81256,
				["value"] = 20,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["MOD_STR"] = {
			-- Buff: Pillar of Frost
			{
				["aura"] = 51271,
				["value"] = 0.2,
			},
			-- Plate Specialization (Frost, Unholy)
			{
				["value"] = 0.05,
				["armorspec"] = {
					[2] = true,
					[3] = true,
				},
				["spellid"] = 86113,
			},
			-- Passive: Unholy Might
			{
				["known"] = 91107,
				["value"] = 0.35,
			},
		},
		["MOD_STA"] = {
			-- Buff: Blood Presence
			{
				["aura"] = 48263,
				["value"] = 0.25,
			},
			-- Passive: Veteran of the Third War
			{
				["known"] = 50029,
				["value"] = 0.09,
			},
			-- Plate Specialization (Blood)
			{
				["value"] = 0.05,
				["armorspec"] = {
					[1] = true,
				},
				["known"] = 86537,
			},
		},
		["MOD_ARMOR"] = {
			-- Buff: Blood Presence
			{
				["aura"] = 48263,
				["value"] = 0.55,
			},
		},
		["MOD_HEALTH"] = {
			-- Buff: Vampiric Blood
			{
				["aura"] = 5233,
				["value"] = 0.15,
			},
		},
		["ADD_CRIT_RATING_MOD_DODGE_RATING"] = {
			-- Buff: Riposte
			{
				["aura"] = 145677,
				["value"] = 0.75,
			},
		},
		["ADD_CRIT_RATING_MOD_PARRY_RATING"] = {
			-- Buff: Riposte
			{
				["aura"] = 145677,
				["value"] = 0.75,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Conversion
			{
				["tab"] = 4,
				["num"] = 3,
				["aura"] = 119975,
				["value"] = 0.03 * 5,
			},
		},
	}
elseif addon.class == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Master of Beasts
			{
				["spec"] = 1,
				["value"] = 2,
			},
			-- Mastery: Wild Quiver
			{
				["spec"] = 2,
				["value"] = 2,
			},
			-- Mastery: Essence of the Viper
			{
				["spec"] = 3,
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_RANGED_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["MOD_RANGED_AP"] = {
			-- Buff: Aspect of the Hawk
			{
				["buff"] = 13165,
				["value"] = 0.35,
				["group"] = addon.ExclusiveGroup.Aspect,
			},
			-- Buff: Aspect of the Iron Hawk
			{
				["buff"] = 109260,
				["value"] = 0.35,
				["group"] = addon.ExclusiveGroup.Aspect,
			},
		},
		["MOD_AGI"] = {
			-- Mail Specialization
			{
				["value"] = 0.05,
				["known"] = 86538,
				["armorspec"] = {
					[0] = true,
					[1] = true,
					[2] = true,
					[3] = true,
				},
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Spirit Bond
			{
				["tab"] = 3,
				["num"] = 3,
				["value"] = 0.03 * 2.5,
			},
		},
	}
elseif addon.class == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Mana Adept
			{
				["spec"] = 1,
				["value"] = 2,
			},
			-- Mastery: Ignite
			{
				["spec"] = 2,
				["value"] = 1.5,
			},
			-- Mastery: Icicles
			{
				["spec"] = 3,
				["value"] = 2,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["MOD_INT"] = {
			-- Passive: Wizardry
			{
				["known"] = 89744,
				["value"] = 0.05,
			},
		},
		["MOD_MANA_REGEN"] = {
			-- Talent: Invocation
			{
				["aura"] = 116257,
				["value"] = -0.5,
			},
			-- Talent: Rune of Power
			{
				["aura"] = 116014,
				["value"] = 0.75,
			},
		},
	}
elseif addon.class == "MONK" then
	StatLogic.StatModTable["MONK"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Elusive Brawler
			{
				["spec"] = 1,
				["value"] = 0.625,
			},
			-- Mastery: Gift of the Serpent
			{
				["spec"] = 2,
				["value"] = 1.25,
			},
			-- Mastery: Bottled Fury
			{
				["spec"] = 3,
				["value"] = 2.5,
			},
		},
		["ADD_DODGE"] = {
			-- Buff: Elusive Brew
			-- TODO: Needs to be exact spell ID
			{
				["aura"] = 115308,
				["value"] = 30,
			},
			{
				["aura"] = 126050,
				["value"] = 25,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
			-- Passive: Swift Reflexes
			{
				["known"] = 124334,
				["value"] = 5.0,
			},
			-- Buff: Shuffle
			{
				["aura"] = 115307,
				["value"] = 20,
			},
			-- Buff: Sparring
			{
				["aura"] = 116033,
				["stack"] = 5,
				["max_stacks"] = 3,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = -1,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 2,
			},
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = -2,
			},
		},
		["ADD_RANGED_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["MOD_HEALTH"] = {
			-- Buff: Fortifying Brew
			{
				["aura"] = 120954,
				["value"] = 0.2,
			},
		},
		["MOD_AGI"] = {
			-- Leather Specialization
			{
				["value"] = 0.05,
				["known"] = 120227,
				["armorspec"] = {
					[3] = true,
				},
			},
		},
		["MOD_STA"] = {
			-- Stance of the Sturdy Ox
			{
				["stance"] = "interface/icons/monk_stance_drunkenox",
				["value"] = 0.2,
			},
			-- Leather Specialization
			{
				["value"] = 0.05,
				["known"] = 120225,
				["armorspec"] = {
					[1] = true,
				},
			},
		},
		["MOD_INT"] = {
			-- Leather Specialization
			{
				["value"] = 0.05,
				["known"] = 120224,
				["armorspec"] = {
					[2] = true,
				},
			},
		},
		["ADD_HIT_RATING_MOD_SPI"] = {
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = 0.5,
			},
		},
		["ADD_EXPERTISE_RATING_MOD_SPI"] = {
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = 0.5,
			},
		},
		["MOD_HASTE_RATING"] = {
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = 0.5,
			},
		},
		["ADD_AP_MOD_SPELL_POWER"] = {
			-- Stance of the Wise Serpent
			{
				["stance"] = "interface/icons/monk_stance_wiseserpent",
				["value"] = 2,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Passive: Mana Meditation
			{
				["known"] = 121278,
				["value"] = 0.5,
			},
		},
	}
elseif addon.class == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Illuminated Healing
			{
				["spec"] = 1,
				["value"] = 1.25,
			},
			-- Mastery: Divine Bulwark
			{
				["spec"] = 2,
				["value"] = 1,
			},
			-- Mastery: Hand of Light
			{
				["spec"] = 3,
				["value"] = 1.85,
			},
		},
		["ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT"] = {
			-- Mastery: Divine Bulwark
			{
				["spec"] = 2,
				["value"] = 1,
			},
		},
		["ADD_DODGE"] = {
			-- Passive: Sanctuary
			{
				["known"] = 105805,
				["value"] = 2,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
			-- Passive: Guarded by the Light
			{
				["known"] = 53592,
				["value"] = -1,
			},
			-- Passive: Sword of Light
			{
				["known"] = 53503,
				["value"] = -1,
			},
		},
		["MOD_STR"] = {
			-- Buff: Ancient Power
			{
				["aura"] = 86700,
				["stack"] = 0.01,
				["max_stacks"] = 12,
			},
			-- Plate Specialization
			{
				["value"] = 0.05,
				["known"] = 86539,
				["armorspec"] = {
					[3] = true,
				},
			},
		},
		["MOD_STA"] = {
			-- Passive: Guarded by the Light
			{
				["known"] = 53592,
				["value"] = 0.25,
			},
			-- Plate Specialization
			{
				["value"] = 0.05,
				["known"] = 86102,
				["armorspec"] = {
					[2] = true,
				},
			},
		},
		["MOD_INT"] = {
			-- Plate Specialization
			{
				["value"] = 0.05,
				["known"] = 86103,
				["armorspec"] = {
					[1] = true,
				},
			},
		},
		["ADD_SPELL_POWER_MOD_AP"] = {
			-- Passive: Guarded by the Light
			{
				["known"] = 53592,
				["value"] = 0.5,
			},
			-- Passive: Sword of Light
			{
				["known"] = 53503,
				["value"] = 0.5,
			},
		},
		["MOD_ARMOR"] = {
			-- Passive: Sanctuary
			{
				["known"] = 105805,
				["value"] = 0.1,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Passive: Holy Insight
			{
				["known"] = 112859,
				["value"] = 0.5,
			},
		},
	}
elseif addon.class == "PRIEST" then
	StatLogic.StatModTable["PRIEST"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Shield Discipline
			{
				["spec"] = 1,
				["value"] = 1.6,
			},
			-- Mastery: Echo of Light
			{
				["spec"] = 2,
				["value"] = 1.3,
			},
			-- Mastery: Shadowy Recall
			{
				["spec"] = 3,
				["value"] = 1.8,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_HIT_RATING_MOD_SPI"] = {
			-- Passive: Spiritual Precision
			{
				["known"] = 47573,
				["value"] = 1,
			},
		},
		["MOD_ARMOR"] = {
			-- Buff: Inner Fire
			{
				["aura"] = 588,
				["value"] = 0.6,
			},
			-- Buff: Shadowform
			{
				["aura"] = 15473,
				["value"] = 1,
			},
		},
		["MOD_SPELL_POWER"] = {
			-- Buff: Inner Fire
			{
				["aura"] = 588,
				["value"] = 0.1,
			},
		},
		["MOD_INT"] = {
			-- Passive: Mysticism
			{
				["known"] = 89745,
				["value"] = 0.05,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Passive: Meditation
			{
				["known"] = 95860,
				["value"] = 0.5,
			},
			-- Passive: Meditation
			{
				["known"] = 95861,
				["value"] = 0.5,
			},
		},
	}
elseif addon.class == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Potent Poisons
			{
				["spec"] = 1,
				["value"] = 3.5,
			},
			-- Mastery: Main Gauche
			{
				["spec"] = 2,
				["value"] = 2,
			},
			-- Mastery: Executioner
			{
				["spec"] = 3,
				["value"] = 3,
			},
		},
		["ADD_DODGE"] = {
			-- Buff: Evasion
			{
				["aura"] = 5277,
				["value"] = 100,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_RANGED_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Buff: Recuperate
			{
				["aura"] = 73651,
				["value"] = 0.04 * 5/3,
			},
		},
		["MOD_AGI"] = {
			-- Leather Specialization
			{
				["known"] = 86092,
				["value"] = 0.05,
			},
			-- Passive: Sinister Calling
			{
				["known"] = 31220,
				["value"] = 0.3,
			},
		},
		["MOD_AP"] = {
			-- Passive: Vitality
			{
				["known"] = 61329,
				["value"] = 0.4,
			},
		},
	}
elseif addon.class == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Elemental Overload
			{
				["spec"] = 1,
				["value"] = 2,
			},
			-- Mastery: Enhanced Elements
			{
				["spec"] = 2,
				["value"] = 2,
			},
			-- Mastery: Deep Healing
			{
				["spec"] = 3,
				["value"] = 3,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
	}
elseif addon.class == "WARLOCK" then
	StatLogic.StatModTable["WARLOCK"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Potent Afflictions
			{
				["spec"] = 1,
				["value"] = 3.1,
			},
			-- Mastery: Master Demonologist
			{
				["spec"] = 2,
				["value"] = 1,
			},
			-- Mastery: Emberstorm
			{
				["spec"] = 3,
				["value"] = 1,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_SPELL_POWER_MOD_INT"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["MOD_HEALTH"] = {
			-- Passive: Fel Armor
			{
				["known"] = 104938,
				["value"] = 0.1,
			},
		},
		["MOD_INT"] = {
			-- Passive: Nethermancy
			{
				["known"] = 86091,
				["value"] = 0.05,
			},
		},
		["MOD_ARMOR"] = {
			-- Passive: Nether Plating (Metamorphosis)
			{
				["known"] = 114129,
				["value"] = 2.5,
				["aura"] = 103958,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Passive: Nether Plating (Dark Apotheosis)
			{
				["known"] = 114129,
				["value"] = 2.5,
				["aura"] = 114168,
				["group"] = addon.ExclusiveGroup.Feral,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Burning Rush
			{
				["tab"] = 4,
				["num"] = 2,
				["aura"] = 111400,
				["value"] = 0.04 * 5,
			},
			-- Talent: Grimoire of Sacrifice
			{
				["tab"] = 5,
				["num"] = 3,
				["aura"] = 108503,
				["value"] = 0.02,
			},
		},
	}
elseif addon.class == "WARRIOR" then
	StatLogic.StatModTable["WARRIOR"] = {
		["ADD_MASTERY_EFFECT_MOD_MASTERY"] = {
			-- Mastery: Strikes of Opportunity
			{
				["spec"] = 1,
				["value"] = 2.2,
			},
			-- Mastery: Unshackled Fury
			{
				["spec"] = 2,
				["value"] = 1.4,
			},
			-- Mastery: Critical Block
			{
				["spec"] = 3,
				["value"] = 2.2,
			},
		},
		["ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT"] = {
			-- Mastery: Critical Block
			{
				["spec"] = 3,
				["value"] = 0.5 / 2.2,
			},
		},
		["ADD_PARRY"] = {
			-- Base
			{
				["value"] = 3.0,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_RANGED_AP_MOD_AGI"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
	}
end

if addon.playerRace == "Dwarf" then
	StatLogic.StatModTable["Dwarf"] = {
	}
elseif addon.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
	}
elseif addon.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
	}
elseif addon.playerRace == "Orc" then
	StatLogic.StatModTable["Orc"] = {
	}
elseif addon.playerRace == "Troll" then
	StatLogic.StatModTable["Troll"] = {
	}
end

StatLogic.StatModTable["ALL"] = {
	["ADD_MELEE_HIT_RATING_MOD_HIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_RANGED_HIT_RATING_MOD_HIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_SPELL_HIT_RATING_MOD_HIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_MELEE_CRIT_RATING_MOD_CRIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_RANGED_CRIT_RATING_MOD_CRIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_SPELL_CRIT_RATING_MOD_CRIT_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_MELEE_HASTE_RATING_MOD_HASTE_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_RANGED_HASTE_RATING_MOD_HASTE_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_SPELL_HASTE_RATING_MOD_HASTE_RATING"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_DODGE_REDUCTION_MOD_EXPERTISE"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_PARRY_REDUCTION_MOD_EXPERTISE"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_SPELL_HIT_MOD_EXPERTISE"] = {
		{
			["value"] = 1.0,
		},
	},
	["ADD_HEALTH_MOD_STA"] = {
		{
			["level"] = setmetatable({
				[81] = 10.8,
				[82] = 11.6,
				[83] = 12.4,
				[84] = 13.2,
				[85] = 14.0,
			}, {
				__index = function(_, level)
					if level > 85 then
						return 14
					else
						return 10
					end
				end
			})
		},
	},
	["ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_NORMAL_MANA_REGEN"] = {
		-- Base
		{
			["value"] = 1.0,
		},
	},
	["ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_GENERIC_MANA_REGEN"] = {
		-- Base
		{
			["value"] = 1.0,
		},
	},
	["MOD_STR"] = {
	},
	["MOD_AGI"] = {
	},
	["ADD_DODGE"] = {
		-- Base (All Classes)
		{
			["value"] = 3.0,
		},
	},
	["ADD_PARRY_MOD_STR"] = {
		{
			["level"] = addon.conversionFallback(addon.ParryPerStr[addon.class], StatLogic.GetParryPerStr)
		}
	},
}

-----------------------------------
-- Avoidance diminishing returns --
-----------------------------------
-- Obtained using https://github.com/raethkcj/MistsDiminishingReturns
addon.K = {
	["WARRIOR"]     = 0.956,
	["PALADIN"]     = 0.886,
	["HUNTER"]      = 0.988,
	["ROGUE"]       = 0.988,
	["PRIEST"]      = 0.983,
	["DEATHKNIGHT"] = 0.956,
	["SHAMAN"]      = 0.988,
	["MONK"]        = 1.422,
	["MAGE"]        = 0.983,
	["WARLOCK"]     = 0.983,
	["DRUID"]       = 1.222,
}

addon.C_p = {
	["WARRIOR"]     = 237.186,
	["PALADIN"]     = 237.186,
	["HUNTER"]      = 0,
	["ROGUE"]       = 145.560,
	["PRIEST"]      = 0,
	["DEATHKNIGHT"] = 237.186,
	["SHAMAN"]      = 145.560,
	["MAGE"]        = 0,
	["MONK"]        = 90.6425,
	["WARLOCK"]     = 0,
	["DRUID"]       = 0,
}

addon.C_d = {
	["WARRIOR"]     = 90.6425,
	["PALADIN"]     = 66.5675,
	["HUNTER"]      = 145.560,
	["ROGUE"]       = 145.560,
	["PRIEST"]      = 150.376,
	["DEATHKNIGHT"] = 90.6425,
	["SHAMAN"]      = 145.560,
	["MAGE"]        = 150.376,
	["MONK"]        = 501.253,
	["WARLOCK"]     = 150.376,
	["DRUID"]       = 150.376,
}

addon.C_b = {
	["WARRIOR"]     = 150.3759,
	["PALADIN"]     = 150.3759,
	["HUNTER"]      = 0,
	["ROGUE"]       = 0,
	["PRIEST"]      = 0,
	["DEATHKNIGHT"] = 0,
	["SHAMAN"]      = 0,
	["MAGE"]        = 0,
	["MONK"]        = 0,
	["WARLOCK"]     = 0,
	["DRUID"]       = 0,
}

addon.ModAgiClasses = {
	["DRUID"] = true,
	["HUNTER"] = true,
	["ROGUE"] = true,
	["SHAMAN"] = true,
}