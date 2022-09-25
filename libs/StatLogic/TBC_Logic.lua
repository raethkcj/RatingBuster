local addonName, addonTable = ...
local StatLogic = LibStub:GetLibrary(addonName)

-- Level 60 rating base
addonTable.RatingBase = {
	[CR_WEAPON_SKILL] = 2.5,
	[CR_DEFENSE_SKILL] = 1.5,
	[CR_DODGE] = 12,
	[CR_PARRY] = 15,
	[CR_BLOCK] = 5,
	[CR_HIT_MELEE] = 10,
	[CR_HIT_RANGED] = 10,
	[CR_HIT_SPELL] = 8,
	[CR_CRIT_MELEE] = 14,
	[CR_CRIT_RANGED] = 14,
	[CR_CRIT_SPELL] = 14,
	[CR_HIT_TAKEN_MELEE] = 10, -- hit avoidance
	[CR_HIT_TAKEN_RANGED] = 10,
	[CR_HIT_TAKEN_SPELL] = 8,
	[CR_CRIT_TAKEN_MELEE] = 25, -- resilience
	[CR_CRIT_TAKEN_RANGED] = 25,
	[CR_CRIT_TAKEN_SPELL] = 25,
	[CR_HASTE_MELEE] = 10,
	[CR_HASTE_RANGED] = 10,
	[CR_HASTE_SPELL] = 10,
	[CR_WEAPON_SKILL_MAINHAND] = 2.5,
	[CR_WEAPON_SKILL_OFFHAND] = 2.5,
	[CR_WEAPON_SKILL_RANGED] = 2.5,
	[CR_EXPERTISE] = 2.5,
}
addonTable.SetCRMax()

StatLogic.GenericStatMap = {
	[CR_HIT] = {
		[CR_HIT_MELEE] = true,
		[CR_HIT_RANGED] = true,
	},
	[CR_CRIT] = {
		[CR_CRIT_MELEE] = true,
		[CR_CRIT_RANGED] = true,
	},
	[CR_HASTE] = {
		[CR_HASTE_MELEE] = true,
		[CR_HASTE_RANGED] = true,
	},
}

--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [int], [level])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit.
-- Args
	spi
			number - spirit
	[int] - (defaults: PlayerInt)
			number - intellect
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[mp5nc]
		number - mana regen per 5 seconds when out of combat
	[statid]
		string - "MANA_REG_NOT_CASTING"
-- Remarks
	Player class is no longer a parameter
	ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
-- Examples
	StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	StatLogic:GetNormalManaRegenFromSpi(10, 15)
	StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local BaseManaRegenPerSpi = {
	[1] = 0.034965,
	[2] = 0.034191,
	[3] = 0.033465,
	[4] = 0.032526,
	[5] = 0.031661,
	[6] = 0.031076,
	[7] = 0.030523,
	[8] = 0.029994,
	[9] = 0.029307,
	[10] = 0.028661,
	[11] = 0.027584,
	[12] = 0.026215,
	[13] = 0.025381,
	[14] = 0.0243,
	[15] = 0.023345,
	[16] = 0.022748,
	[17] = 0.021958,
	[18] = 0.021386,
	[19] = 0.02079,
	[20] = 0.020121,
	[21] = 0.019733,
	[22] = 0.019155,
	[23] = 0.018819,
	[24] = 0.018316,
	[25] = 0.017936,
	[26] = 0.017576,
	[27] = 0.017201,
	[28] = 0.016919,
	[29] = 0.016581,
	[30] = 0.016233,
	[31] = 0.015994,
	[32] = 0.015707,
	[33] = 0.015464,
	[34] = 0.015204,
	[35] = 0.014956,
	[36] = 0.014744,
	[37] = 0.014495,
	[38] = 0.014302,
	[39] = 0.014094,
	[40] = 0.013895,
	[41] = 0.013724,
	[42] = 0.013522,
	[43] = 0.013363,
	[44] = 0.013175,
	[45] = 0.012996,
	[46] = 0.012853,
	[47] = 0.012687,
	[48] = 0.012539,
	[49] = 0.012384,
	[50] = 0.012233,
	[51] = 0.012113,
	[52] = 0.011973,
	[53] = 0.011859,
	[54] = 0.011714,
	[55] = 0.011575,
	[56] = 0.011473,
	[57] = 0.011342,
	[58] = 0.011245,
	[59] = 0.01111,
	[60] = 0.010999,
	[61] = 0.0107,
	[62] = 0.010522,
	[63] = 0.01029,
	[64] = 0.010119,
	[65] = 0.009968,
	[66] = 0.009808,
	[67] = 0.009651,
	[68] = 0.009553,
	[69] = 0.009445,
	[70] = 0.009327,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(int, 3, "nil", "number")
	self:argCheck(level, 4, "nil", "number")

	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 70 then
		level = UnitLevel("player")
	end

	-- if int is invalid input, default to player int
	if type(int) ~= "number" then
		local _
		_, int = UnitStat("player",4)
	end
	-- Calculate
	return (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REG_NOT_CASTING"
end

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
addonTable.CritPerAgi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = {
		0.2500, 0.2381, 0.2381, 0.2273, 0.2174, 0.2083, 0.2083, 0.2000, 0.1923, 0.1923,
		0.1852, 0.1786, 0.1667, 0.1613, 0.1563, 0.1515, 0.1471, 0.1389, 0.1351, 0.1282,
		0.1282, 0.1250, 0.1190, 0.1163, 0.1111, 0.1087, 0.1064, 0.1020, 0.1000, 0.0962,
		0.0943, 0.0926, 0.0893, 0.0877, 0.0847, 0.0833, 0.0820, 0.0794, 0.0781, 0.0758,
		0.0735, 0.0725, 0.0704, 0.0694, 0.0676, 0.0667, 0.0649, 0.0633, 0.0625, 0.0610,
		0.0595, 0.0588, 0.0575, 0.0562, 0.0549, 0.0543, 0.0532, 0.0521, 0.0510, 0.0500,
		0.0469, 0.0442, 0.0418, 0.0397, 0.0377, 0.0360, 0.0344, 0.0329, 0.0315, 0.0303,
	},
	[StatLogic:GetClassIdOrName("PALADIN")] = {
		0.2174, 0.2070, 0.2070, 0.1976, 0.1976, 0.1890, 0.1890, 0.1812, 0.1812, 0.1739,
		0.1739, 0.1672, 0.1553, 0.1553, 0.1449, 0.1449, 0.1403, 0.1318, 0.1318, 0.1242,
		0.1208, 0.1208, 0.1144, 0.1115, 0.1087, 0.1060, 0.1035, 0.1011, 0.0988, 0.0945,
		0.0925, 0.0925, 0.0887, 0.0870, 0.0836, 0.0820, 0.0820, 0.0791, 0.0776, 0.0750,
		0.0737, 0.0737, 0.0713, 0.0701, 0.0679, 0.0669, 0.0659, 0.0639, 0.0630, 0.0612,
		0.0604, 0.0596, 0.0580, 0.0572, 0.0557, 0.0550, 0.0544, 0.0530, 0.0524, 0.0512,
		0.0491, 0.0483, 0.0472, 0.0456, 0.0446, 0.0437, 0.0425, 0.0416, 0.0408, 0.0400,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.2840, 0.2834, 0.2711, 0.2530, 0.2430, 0.2337, 0.2251, 0.2171, 0.2051, 0.1984,
		0.1848, 0.1670, 0.1547, 0.1441, 0.1330, 0.1267, 0.1194, 0.1117, 0.1060, 0.0998,
		0.0962, 0.0910, 0.0872, 0.0829, 0.0797, 0.0767, 0.0734, 0.0709, 0.0680, 0.0654,
		0.0637, 0.0614, 0.0592, 0.0575, 0.0556, 0.0541, 0.0524, 0.0508, 0.0493, 0.0481,
		0.0470, 0.0457, 0.0444, 0.0433, 0.0421, 0.0413, 0.0402, 0.0391, 0.0382, 0.0373,
		0.0366, 0.0358, 0.0350, 0.0341, 0.0334, 0.0328, 0.0321, 0.0314, 0.0307, 0.0301,
		0.0297, 0.0290, 0.0284, 0.0279, 0.0273, 0.0270, 0.0264, 0.0259, 0.0254, 0.0250,
	},
	[StatLogic:GetClassIdOrName("ROGUE")] = {
		0.4476, 0.4290, 0.4118, 0.3813, 0.3677, 0.3550, 0.3321, 0.3217, 0.3120, 0.2941,
		0.2640, 0.2394, 0.2145, 0.1980, 0.1775, 0.1660, 0.1560, 0.1450, 0.1355, 0.1271,
		0.1197, 0.1144, 0.1084, 0.1040, 0.0980, 0.0936, 0.0903, 0.0865, 0.0830, 0.0792,
		0.0768, 0.0741, 0.0715, 0.0691, 0.0664, 0.0643, 0.0628, 0.0609, 0.0592, 0.0572,
		0.0556, 0.0542, 0.0528, 0.0512, 0.0497, 0.0486, 0.0474, 0.0464, 0.0454, 0.0440,
		0.0431, 0.0422, 0.0412, 0.0404, 0.0394, 0.0386, 0.0378, 0.0370, 0.0364, 0.0355,
		0.0334, 0.0322, 0.0307, 0.0296, 0.0286, 0.0276, 0.0268, 0.0262, 0.0256, 0.0250,
	},
	[StatLogic:GetClassIdOrName("PRIEST")] = {
		0.0909, 0.0909, 0.0909, 0.0865, 0.0865, 0.0865, 0.0865, 0.0826, 0.0826, 0.0826,
		0.0826, 0.0790, 0.0790, 0.0790, 0.0790, 0.0757, 0.0757, 0.0757, 0.0727, 0.0727,
		0.0727, 0.0727, 0.0699, 0.0699, 0.0699, 0.0673, 0.0673, 0.0673, 0.0649, 0.0649,
		0.0649, 0.0627, 0.0627, 0.0627, 0.0606, 0.0606, 0.0606, 0.0586, 0.0586, 0.0586,
		0.0568, 0.0568, 0.0551, 0.0551, 0.0551, 0.0534, 0.0534, 0.0519, 0.0519, 0.0519,
		0.0505, 0.0505, 0.0491, 0.0491, 0.0478, 0.0478, 0.0466, 0.0466, 0.0454, 0.0454,
		0.0443, 0.0444, 0.0441, 0.0433, 0.0426, 0.0419, 0.0414, 0.0412, 0.0410, 0.0400,
	},
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1663, 0.1663, 0.1583, 0.1583, 0.1511, 0.1511, 0.1511, 0.1446, 0.1446, 0.1385,
		0.1385, 0.1330, 0.1330, 0.1279, 0.1231, 0.1188, 0.1188, 0.1147, 0.1147, 0.1073,
		0.1073, 0.1039, 0.1039, 0.1008, 0.0978, 0.0950, 0.0950, 0.0924, 0.0924, 0.0875,
		0.0875, 0.0853, 0.0831, 0.0831, 0.0792, 0.0773, 0.0773, 0.0756, 0.0756, 0.0723,
		0.0707, 0.0707, 0.0693, 0.0679, 0.0665, 0.0652, 0.0639, 0.0627, 0.0627, 0.0605,
		0.0594, 0.0583, 0.0583, 0.0573, 0.0554, 0.0545, 0.0536, 0.0536, 0.0528, 0.0512,
		0.0496, 0.0486, 0.0470, 0.0456, 0.0449, 0.0437, 0.0427, 0.0417, 0.0408, 0.0400,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.0771, 0.0771, 0.0771, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0701,
		0.0701, 0.0701, 0.0701, 0.0701, 0.0671, 0.0671, 0.0671, 0.0671, 0.0671, 0.0643,
		0.0643, 0.0643, 0.0643, 0.0617, 0.0617, 0.0617, 0.0617, 0.0617, 0.0593, 0.0593,
		0.0593, 0.0593, 0.0571, 0.0571, 0.0571, 0.0551, 0.0551, 0.0551, 0.0551, 0.0532,
		0.0532, 0.0532, 0.0532, 0.0514, 0.0514, 0.0514, 0.0498, 0.0498, 0.0498, 0.0482,
		0.0482, 0.0482, 0.0467, 0.0467, 0.0467, 0.0454, 0.0454, 0.0454, 0.0441, 0.0441,
		0.0435, 0.0432, 0.0424, 0.0423, 0.0422, 0.0411, 0.0412, 0.0408, 0.0404, 0.0400,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1500, 0.1500, 0.1429, 0.1429, 0.1429, 0.1364, 0.1364, 0.1364, 0.1304, 0.1304,
		0.1250, 0.1250, 0.1250, 0.1200, 0.1154, 0.1111, 0.1111, 0.1111, 0.1071, 0.1034,
		0.1000, 0.1000, 0.0968, 0.0968, 0.0909, 0.0909, 0.0909, 0.0882, 0.0882, 0.0833,
		0.0833, 0.0811, 0.0811, 0.0789, 0.0769, 0.0750, 0.0732, 0.0732, 0.0714, 0.0698,
		0.0682, 0.0682, 0.0667, 0.0667, 0.0638, 0.0625, 0.0625, 0.0612, 0.0600, 0.0588,
		0.0577, 0.0577, 0.0566, 0.0556, 0.0545, 0.0536, 0.0526, 0.0517, 0.0517, 0.0500,
		0.0484, 0.0481, 0.0470, 0.0455, 0.0448, 0.0435, 0.0436, 0.0424, 0.0414, 0.0405,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.2020, 0.2020, 0.1923, 0.1923, 0.1836, 0.1836, 0.1756, 0.1756, 0.1683, 0.1553,
		0.1496, 0.1496, 0.1443, 0.1443, 0.1346, 0.1346, 0.1303, 0.1262, 0.1262, 0.1122,
		0.1122, 0.1092, 0.1063, 0.1063, 0.1010, 0.1010, 0.0985, 0.0962, 0.0962, 0.0878,
		0.0859, 0.0859, 0.0841, 0.0824, 0.0808, 0.0792, 0.0777, 0.0777, 0.0762, 0.0709,
		0.0696, 0.0696, 0.0685, 0.0673, 0.0651, 0.0641, 0.0641, 0.0631, 0.0621, 0.0585,
		0.0577, 0.0569, 0.0561, 0.0561, 0.0546, 0.0539, 0.0531, 0.0525, 0.0518, 0.0493,
		0.0478, 0.0472, 0.0456, 0.0447, 0.0438, 0.0430, 0.0424, 0.0412, 0.0406, 0.0400,
	},
}

local zero = setmetatable({}, {
	__index = function()
		return 0
	end
})

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
addonTable.SpellCritPerInt = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = zero,
	[StatLogic:GetClassIdOrName("PALADIN")] = {
		0.0832, 0.0793, 0.0793, 0.0757, 0.0757, 0.0724, 0.0694, 0.0694, 0.0666, 0.0666,
		0.0640, 0.0616, 0.0594, 0.0574, 0.0537, 0.0537, 0.0520, 0.0490, 0.0490, 0.0462,
		0.0450, 0.0438, 0.0427, 0.0416, 0.0396, 0.0387, 0.0387, 0.0370, 0.0362, 0.0347,
		0.0340, 0.0333, 0.0326, 0.0320, 0.0308, 0.0303, 0.0297, 0.0287, 0.0282, 0.0273,
		0.0268, 0.0264, 0.0256, 0.0256, 0.0248, 0.0245, 0.0238, 0.0231, 0.0228, 0.0222,
		0.0219, 0.0216, 0.0211, 0.0208, 0.0203, 0.0201, 0.0198, 0.0191, 0.0189, 0.0185,
		0.0157, 0.0153, 0.0148, 0.0143, 0.0140, 0.0136, 0.0133, 0.0131, 0.0128, 0.0125,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.0699, 0.0666, 0.0666, 0.0635, 0.0635, 0.0608, 0.0608, 0.0583, 0.0583, 0.0559,
		0.0559, 0.0538, 0.0499, 0.0499, 0.0466, 0.0466, 0.0451, 0.0424, 0.0424, 0.0399,
		0.0388, 0.0388, 0.0368, 0.0358, 0.0350, 0.0341, 0.0333, 0.0325, 0.0318, 0.0304,
		0.0297, 0.0297, 0.0285, 0.0280, 0.0269, 0.0264, 0.0264, 0.0254, 0.0250, 0.0241,
		0.0237, 0.0237, 0.0229, 0.0225, 0.0218, 0.0215, 0.0212, 0.0206, 0.0203, 0.0197,
		0.0194, 0.0192, 0.0186, 0.0184, 0.0179, 0.0177, 0.0175, 0.0170, 0.0168, 0.0164,
		0.0157, 0.0154, 0.0150, 0.0144, 0.0141, 0.0137, 0.0133, 0.0130, 0.0128, 0.0125,
	},
	[StatLogic:GetClassIdOrName("ROGUE")] = zero,
	[StatLogic:GetClassIdOrName("PRIEST")] = {
		0.1710, 0.1636, 0.1568, 0.1505, 0.1394, 0.1344, 0.1297, 0.1254, 0.1214, 0.1140,
		0.1045, 0.0941, 0.0875, 0.0784, 0.0724, 0.0684, 0.0627, 0.0597, 0.0562, 0.0523,
		0.0502, 0.0470, 0.0453, 0.0428, 0.0409, 0.0392, 0.0376, 0.0362, 0.0348, 0.0333,
		0.0322, 0.0311, 0.0301, 0.0289, 0.0281, 0.0273, 0.0263, 0.0256, 0.0249, 0.0241,
		0.0235, 0.0228, 0.0223, 0.0216, 0.0210, 0.0206, 0.0200, 0.0196, 0.0191, 0.0186,
		0.0183, 0.0178, 0.0175, 0.0171, 0.0166, 0.0164, 0.0160, 0.0157, 0.0154, 0.0151,
		0.0148, 0.0145, 0.0143, 0.0139, 0.0137, 0.0134, 0.0132, 0.0130, 0.0127, 0.0125,
	},
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1333, 0.1272, 0.1217, 0.1217, 0.1166, 0.1120, 0.1077, 0.1037, 0.1000, 0.1000,
		0.0933, 0.0875, 0.0800, 0.0756, 0.0700, 0.0666, 0.0636, 0.0596, 0.0571, 0.0538,
		0.0518, 0.0500, 0.0474, 0.0459, 0.0437, 0.0424, 0.0412, 0.0394, 0.0383, 0.0368,
		0.0354, 0.0346, 0.0333, 0.0325, 0.0314, 0.0304, 0.0298, 0.0289, 0.0283, 0.0272,
		0.0267, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235, 0.0231, 0.0226, 0.0220, 0.0215,
		0.0210, 0.0207, 0.0201, 0.0199, 0.0193, 0.0190, 0.0187, 0.0182, 0.0179, 0.0175,
		0.0164, 0.0159, 0.0152, 0.0147, 0.0142, 0.0138, 0.0134, 0.0131, 0.0128, 0.0125,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.1637, 0.1574, 0.1516, 0.1411, 0.1364, 0.1320, 0.1279, 0.1240, 0.1169, 0.1137,
		0.1049, 0.0930, 0.0871, 0.0731, 0.0671, 0.0639, 0.0602, 0.0568, 0.0538, 0.0505,
		0.0487, 0.0460, 0.0445, 0.0422, 0.0405, 0.0390, 0.0372, 0.0338, 0.0325, 0.0312,
		0.0305, 0.0294, 0.0286, 0.0278, 0.0269, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235,
		0.0230, 0.0215, 0.0211, 0.0206, 0.0201, 0.0197, 0.0192, 0.0188, 0.0184, 0.0179,
		0.0176, 0.0173, 0.0170, 0.0166, 0.0162, 0.0154, 0.0151, 0.0149, 0.0146, 0.0143,
		0.0143, 0.0143, 0.0143, 0.0142, 0.0142, 0.0138, 0.0133, 0.0131, 0.0128, 0.0125,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, 0.0825, 0.0767, 0.0717, 0.0688, 0.0635, 0.0600, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, 0.0446, 0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		0.0256, 0.0248, 0.0243, 0.0236, 0.0229, 0.0224, 0.0220, 0.0214, 0.0209, 0.0204,
		0.0200, 0.0195, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0172, 0.0168, 0.0165,
		0.0159, 0.0154, 0.0148, 0.0143, 0.0138, 0.0135, 0.0130, 0.0127, 0.0125, 0.0122,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.1431, 0.1369, 0.1312, 0.1259, 0.1211, 0.1166, 0.1124, 0.1124, 0.1086, 0.0984,
		0.0926, 0.0851, 0.0807, 0.0750, 0.0684, 0.0656, 0.0617, 0.0594, 0.0562, 0.0516,
		0.0500, 0.0477, 0.0463, 0.0437, 0.0420, 0.0409, 0.0394, 0.0384, 0.0366, 0.0346,
		0.0339, 0.0325, 0.0318, 0.0309, 0.0297, 0.0292, 0.0284, 0.0276, 0.0269, 0.0256,
		0.0252, 0.0244, 0.0240, 0.0233, 0.0228, 0.0223, 0.0219, 0.0214, 0.0209, 0.0202,
		0.0198, 0.0193, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0173, 0.0169, 0.0164,
		0.0162, 0.0157, 0.0150, 0.0146, 0.0142, 0.0137, 0.0133, 0.0131, 0.0128, 0.0125,
	},
}

addonTable.APPerStr = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 2,
	[StatLogic:GetClassIdOrName("PALADIN")] = 2,
	[StatLogic:GetClassIdOrName("HUNTER")] = 1,
	[StatLogic:GetClassIdOrName("ROGUE")] = 1,
	[StatLogic:GetClassIdOrName("PRIEST")] = 1,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 2,
	[StatLogic:GetClassIdOrName("MAGE")] = 1,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 1,
	[StatLogic:GetClassIdOrName("DRUID")] = 2,
}

addonTable.APPerAgi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 0,
	[StatLogic:GetClassIdOrName("PALADIN")] = 0,
	[StatLogic:GetClassIdOrName("HUNTER")] = 1,
	[StatLogic:GetClassIdOrName("ROGUE")] = 1,
	[StatLogic:GetClassIdOrName("PRIEST")] = 0,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 0,
	[StatLogic:GetClassIdOrName("MAGE")] = 0,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 0,
	[StatLogic:GetClassIdOrName("DRUID")] = 0,
}

addonTable.RAPPerAgi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 1,
	[StatLogic:GetClassIdOrName("PALADIN")] = 0,
	[StatLogic:GetClassIdOrName("HUNTER")] = 1,
	[StatLogic:GetClassIdOrName("ROGUE")] = 1,
	[StatLogic:GetClassIdOrName("PRIEST")] = 0,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 0,
	[StatLogic:GetClassIdOrName("MAGE")] = 0,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 0,
	[StatLogic:GetClassIdOrName("DRUID")] = 0,
}

addonTable.BaseDodge = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 0.7580,
	[StatLogic:GetClassIdOrName("PALADIN")] = 0.6520,
	[StatLogic:GetClassIdOrName("HUNTER")] = -5.4500,
	[StatLogic:GetClassIdOrName("ROGUE")] = -0.5900,
	[StatLogic:GetClassIdOrName("PRIEST")] = 3.1830,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 1.6750,
	[StatLogic:GetClassIdOrName("MAGE")] = 3.4575,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 2.0350,
	[StatLogic:GetClassIdOrName("DRUID")] = -1.8720,
}

addonTable.RegisterValidatorEvents()

StatLogic.StatModTable = {}
if addonTable.playerClass == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Nurturing Instinct (Rank 2) - 2,14
		--        Increases your healing spells by up to 25%/50% of your Strength.
		-- 2.4.0 Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
		["ADD_HEALING_MOD_AGI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.5, 1,
				},
			},
		},
		-- Druid: Intensity (Rank 3) - 3,6
		--        Allows 10/20/30% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Druid: Dreamstate (Rank 3) - 1,17
		--        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.04, 0.07, 0.10,
				},
			},
		},
		-- Druid: Feral Swiftness (Rank 2) - 2,6
		--        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Druid: Natural Perfection (Rank 3) - 3,18
		--        Your critical strike chance with all spells is increased by 3% and melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Druid: Balance of Power (Rank 2) - 1,16
		--        Increases your chance to hit with all spells and reduces the chance you'll be hit by spells by 2%/4%.
		["ADD_HIT_TAKEN"] = {
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Druid: Thick Hide (Rank 3) - 2,5
		--        Increases your Armor contribution from items by 4%/7%/10%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Moonkin Form - Buff
		--        While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
			{
				["value"] = 2.8,
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["value"] = 5,
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			{
				["value"] = 5,
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STA"] = { -- Heart of the Wild: +4%/8%/12%/16%/20% stamina in bear / dire bear
		{
			["tab"] = 2,
			["num"] = 15,
			["rank"] = {
				0.04, 0.08, 0.12, 0.16, 0.2,
			},
			["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
		},
		{
			["tab"] = 2,
			["num"] = 15,
			["rank"] = {
				0.04, 0.08, 0.12, 0.16, 0.2,
			},
			["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
		},
		{ -- Survival of the Fittest: +1%/2%/3% all stats
		["tab"] = 2,
		["num"] = 16,
		["rank"] = {
			0.01, 0.02, 0.03,
		},
	},
	{ -- Bear Form / Dire Bear Form: +25% stamina
	["value"] = 0.25,
	["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
},
{ -- Bear Form / Dire Bear Form: +25% stamina
["value"] = 0.25,
["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STR"] = {
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- 2.3.0 This talent no longer provides 4/8/12/16/20% bonus Strength in Cat Form. Instead it provides 2/4/6/8/10% bonus attack power.
		["MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_AGI"] = {
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Living Spirit (Rank 3) - 3,16
		--        Increases your total Spirit by 5%/10%/15%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_SPI"] = {
			{
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
	}
elseif addonTable.playerClass == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
		-- Hunter: Aspect of the Viper - Buff
		--         The hunter takes on the aspects of a viper, regenerating mana equal to 25% of his Intellect every 5 sec.
		-- TODO: Gronnstalker's Armor, (2) Set: Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
		-- 2.2.0: Aspect of the Viper: This ability has received a slight redesign. The
		-- amount of mana regained will increase as the Hunters percentage of
		-- mana remaining decreases. At about 60% mana, it is equivalent to the
		-- previous version of Aspect of the Viper. Below that margin, it is
		-- better (up to twice as much mana as the old version); while above
		-- that margin, it will be less effective. The mana regained never drops
		-- below 10% of intellect every 5 sec. or goes above 50% of intellect
		-- every 5 sec.
		["ADD_MANA_REG_MOD_INT"] = {
			{
				["value"] = 0.25,
				["buff"] = GetSpellInfo(34074),			-- ["Aspect of the Viper"],
			},
		},
		-- Hunter: Careful Aim (Rank 3) - 2,16
		--         Increases your ranged attack power by an amount equal to 15%/30%/45% of your total Intellect.
		["ADD_RANGED_AP_MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.15, 0.30, 0.45,
				},
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 3,14
		--         Reduces all damage taken by 2%/4% and increases attack power by 2%/4%.
		["MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		-- Hunter: Master Marksman (Rank 5) - 2,19
		--         Increases your ranged attack power by 2%/4%/6%/8%/10%.
		-- Hunter: Survival Instincts (Rank 2) - 3,14
		--         Reduces all damage taken by 2%/4% and increases attack power by 2%/4%.
		["MOD_RANGED_AP"] = {
			{
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
			{
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		-- Hunter: Catlike Reflexes (Rank 3) - 1,19
		--         Increases your chance to dodge by 1%/2%/3% and your pet's chance to dodge by an additional 3%/6%/9%.
		-- Hunter: Aspect of the Monkey - Buff
		--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.
		-- Hunter: Improved Aspect of the Monkey (Rank 3) - 1,4
		--         Increases the Dodge bonus of your Aspect of the Monkey by 2%/4%/6%.
		-- Hunter: Deterrence - Buff
		--         Dodge and Parry chance increased by 25%.
		["ADD_DODGE"] = {
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					1, 2, 3,
				},
			},
			{
				["value"] = 8,
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			{
				["value"] = 25,
				["buff"] = GetSpellInfo(31567),		-- ["Deterrence"],
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 1,14
		--         Reduces all damage taken by 2%/4%.

		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Hunter: Thick Hide (Rank 3) - 1,5
		--         Increases the armor rating of your pets by 20% and your armor contribution from items by 4%/7%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 1,
				["num"] = 5,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
		},
		-- Hunter: Survivalist (Rank 5) - 3,9
		--         Increases total health by 2%/4%/6%/8%/10%.
		-- Hunter: Endurance Training (Rank 5) - 1,2
		--         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
		["MOD_HEALTH"] = {
			{
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
			{
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		-- Hunter: Lightning Reflexes (Rank 5) - 3,18
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		["MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.03, 0.06,
				},
			},
		},
	}
elseif addonTable.playerClass == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
		-- Mage: Arcane Fortitude - 1,9
		--       Increases your armor by an amount equal to 50% of your Intellect.
		-- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
		["ADD_ARMOR_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					1,
				},
			},
		},
		-- Mage: Arcane Meditation (Rank 3) - 1,12
		--       Allows 10/20/30% of your Mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
			{
				-- All ranks of Mage Armor give 30% regen
				["rank"] = setmetatable({}, {
					__index = function(t, k)
						return k and 0.3
					end
				}),
				["buff"] = GetSpellInfo(6117),		-- ["Mage Armor"],
			},
		},
		-- Mage: Mind Mastery (Rank 5) - 1,22
		--       Increases spell damage by up to 5%/10%/15%/20%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Mage: Arctic Winds (Rank 5) - 3,20
		--       Reduces the chance melee and ranged attacks will hit you by 1%/2%/3%/4%/5%.
		["ADD_HIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Mage: Prismatic Cloak (Rank 2) - 1,16
		--       Reduces all damage taken by 2%/4%.
		-- Mage: Playing with Fire (Rank 3) - 2,13
		--       Increases all spell damage caused by 1%/2%/3% and all spell damage taken by 1%/2%/3%.
		-- Mage: Frozen Core (Rank 3) - 3,14
		--       Reduces the damage taken by Frost and Fire effects by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
			{
				["FIRE"] = true,
				["FROST"] = true,
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Mage: Arcane Mind (Rank 5) - 1,15
		--       Increases your total Intellect by 3%/6%/9%/12%/15%.
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
	}
elseif addonTable.playerClass == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
		-- Paladin: Pursuit of Justice (Rank 2) - 3,9
		--          Reduces the chance you'll be hit by spells by 1%/2%/3% and increases movement and mounted movement speed by 5%/10%/15%. This does not stack with other movement speed increasing effects.
		["ADD_HIT_TAKEN"] = {
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					-0.05, -0.1, -0.15,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Divine Purpose (Rank 3) - 3,20
		--          Melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Paladin: Blessed Life (Rank 3) - 1,18
		--          All attacks against you have a 4%/7%/10% chance to cause half damage.
		-- Paladin: Ardent Defender (Rank 5) - 2,19
		--          When you have less than 20% health, all damage taken is reduced by 6%/12%/18%/24%/30%.
		-- Paladin: Spell Warding (Rank 2) - 2,13
		--          All spell damage taken is reduced by 2%/4%.
		-- Paladin: Improved Righteous Fury (Rank 3) - 2,7
		--          While Righteous Fury is active, all damage taken is reduced by 2%/4%/6% and increases the amount of threat generated by your Righteous Fury spell by 16%/33%/50%.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.035, -0.05,
				},
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					-0.06, -0.12, -0.18, -0.24, -0.3,
				},
				["condition"] = "(UnitHealth('player') / UnitHealthMax('player')) < 0.35",
			},
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
				["buff"] = GetSpellInfo(25781),		-- ["Righteous Fury"],
			},
		},
		-- Paladin: Toughness (Rank 5) - 2,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Divine Strength (Rank 5) - 1,1
		--          Increases your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			{
				["tab"] = 1,
				["num"] = 1,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Sacred Duty (Rank 2) - 2,16
		--          Increases your total Stamina by 3%/6%, reduces the cooldown of your Divine Shield spell by 60 sec and reduces the attack speed penalty by 100%.
		-- Paladin: Combat Expertise (Rank 5) - 2,21
		--          Increases your expertise by 1/2/3/4/5 and total Stamina by 2%/4%/6%/8%/10%. -- 2.3.0
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.03, 0.06
				},
			},
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Divine Intellect (Rank 5) - 1,2
		--          Increases your total Intellect by 2%/4%/6%/8%/10%.
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Shield Specialization (Rank 3) - 2,8
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		["MOD_BLOCK_VALUE"] = {
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	}
elseif addonTable.playerClass == "PRIEST" then
	StatLogic.StatModTable["PRIEST"] = {
		-- Priest: Meditation (Rank 3) - 1,9
		--         Allows 10/20/30% of your Mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_SPELL_DMG_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_HEALING_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: OLD: Elune's Grace (Rank 6) - Buff, NE priest only
		--         OLD: Ranged damage taken reduced by 167 and chance to dodge increased by 10%.
		-- 2.3.0 Elune's Grace (Night Elf) effect changed to reduce chance to be hit by melee and ranged attacks by 20% for 15 seconds. There is now only 1 rank of the spell.
		-- Priest: Elune's Grace (Rank 1) - Buff, NE priest only
		--         Reduces the chance you'll be hit by melee and ranged attacks by 20% for 15 sec.
		["ADD_HIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["value"] = 20,
				["buff"] = GetSpellInfo(2651),		-- ["Elune's Grace"],
			},
		},
		-- Priest: Shadow Resilience (Rank 2) - 3,16
		--         Reduces the chance you'll be critically hit by all spells by 2%/4%.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Priest: Spell Warding (Rank 5) - 2,4
		--         Reduces all spell damage taken by 2%/4%/6%/8%/10%.
		-- Priest: OLD: Pain Suppression - Buff
		--         OLD: Reduces all damage taken by 60% for 8 sec.
		-- 2.1.0 "Pain Suppression" now reduces damage taken by 65% and increases resistance to Dispel mechanics by 65% for the duration.
		-- 2.3.0 Pain Suppression (Discipline Talent) is now usable on friendly targets, instantly reduces the target's threat by 5%, reduces damage taken by 40% and its cooldown has been reduced to 2 minutes.
		-- Priest: 2.3.0: Pain Suppression - Buff
		--         2.3.0: Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.
		["MOD_DMG_TAKEN"] = {
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 4,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.4,
				["buff"] = GetSpellInfo(33206),		-- ["Pain Suppression"],
			},
		},
		-- Priest: Mental Strength (Rank 5) - 1,13
		--         IIncreases your maximum Mana by 2%/4%/6%/8%/10%.
		["MOD_MANA"] = {
			{
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		-- Priest: Spirit of Redemption - 2,13
		--         Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.
		["MOD_SPI"] = {
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			{
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					0.05,
				},
			},
		},
	}
elseif addonTable.playerClass == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
		-- Rogue: Deadliness (Rank 5) - 3,17
		--        Increases your attack power by 2%/4%/6%/8%/10%.
		["MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Rogue: Lightning Reflexes (Rank 5) - 2,3
		--        Increases your Dodge chance by 1%/2%/3%/4%/5%.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		-- Rogue: Ghostly Strike - Buff
		--        Dodge chance increased by 15%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			{
				["rank"] = {
					50, 50,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
			{
				["value"] = 15,
				["buff"] = GetSpellInfo(31022),		-- ["Ghostly Strike"],
			},
		},
		-- Rogue: Sleight of Hand (Rank 2) - 3,3
		--        Reduces the chance you are critically hit by melee and ranged attacks by 2% and increases the threat reduction of your Feint ability by 20%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Rogue: Heightened Senses (Rank 2) - 3,12
		--        Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by 2%/4%.
		-- Rogue: Cloak of Shadows - buff
		--        Instantly removes all existing harmful spell effects and increases your chance to resist all spells by 90% for 5 sec. Does not remove effects that prevent you from using Cloak of Shadows.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		["ADD_HIT_TAKEN"] = {
			{
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 12,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.9,
				["buff"] = GetSpellInfo(39666),		-- ["Cloak of Shadows"],
			},
			{
				["RANGED"] = true,
				["rank"] = {
					0, -0.25,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
		},
		-- Rogue: Deadened Nerves (Rank 5) - 1,19
		--        Decreases all physical damage taken by 1%/2%/3%/4%/5%
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		-- Rogue: Sinister Calling (Rank 5) - 3,21
		--        Increases your total Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	}
elseif addonTable.playerClass == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
		-- Shaman: Shamanistic Rage - Buff
		--         Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 15% of your attack power. Lasts 30 sec.
		-- 2.3.0 Shamanistic Rage (Enhancement) now also reduces all damage taken by 30% for the duration.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.3,
				["buff"] = GetSpellInfo(30823),		-- ["Shamanistic Rage"],
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_SPELL_DMG_MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_HEALING_MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Unrelenting Storm (Rank 5) - 1,14
		--         Regenerate mana equal to 2%/4%/6%/8%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Anticipation (Rank 5) - 2,9
		--         Increases your chance to dodge by an additional 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Shaman: Elemental Shields (Rank 3) - 1,18
		--         Reduces the chance you will be critically hit by melee and ranged attacks by 2%/4%/6%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Shaman: Elemental Warding (Rank 3) - 1,4
		--         Reduces damage taken from Fire, Frost and Nature effects by 4%/7%/10%.
		["MOD_DMG_TAKEN"] = {
			{
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Shaman: Toughness (Rank 5) - 2,11
		--         Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Shaman: Ancestral Knowledge (Rank 5) - 2,1
		--         Increases your maximum Mana by 1%/2%/3%/4%/5%.
		["MOD_MANA"] = {
			{
				["tab"] = 2,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Shaman: Shield Specialization 5/5 - 2,2
		--         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
		["MOD_BLOCK_VALUE"] = {
			{
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
	}
elseif addonTable.playerClass == "WARLOCK" then
	StatLogic.StatModTable["WARLOCK"] = {
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%.
		["ADD_SPELL_DMG_MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Resilience (Rank 3) - 2,18
		--          Reduces the chance you'll be critically hit by melee and spells by 1%/2%/3% and reduces all damage your summoned demon takes by 15%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Warlock: Master Demonologist (Rank 5) - 2,17
		--          Voidwalker - Reduces physical damage taken by 2%/4%/6%/8%/10%.
		-- Warlock: Soul Link (Rank 1) - 2,19
		--          When active, 20% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter or Felguard demon instead. In addition, both the demon and master will inflict 5% more damage. Lasts as long as the demon is active.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(11775)).."')" --"UnitCreatureFamily('pet') == '"..L["Voidwalker"].."'",	-- ["Torment"]
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.2,
				["buff"] = GetSpellInfo(25228),		-- ["Soul Link"],
			},
		},
		-- Warlock: Fel Stamina (Rank 3) - 2,9
		--          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
		["MOD_HEALTH"] = {
			{
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Warlock: Fel Intellect (Rank 3) - 2,6
		--          Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum mana by 1%/2%/3%.
		["MOD_MANA"] = {
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		["MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
	}
elseif addonTable.playerClass == "WARRIOR" then
	StatLogic.StatModTable["WARRIOR"] = {
		-- Warrior: Improved Berserker Stance (Rank 5) - 2,20 - Stance
		--          Increases attack power by 2%/4%/6%/8%/10% while in Berserker Stance.
		["MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
		},
		-- Warrior: Shield Wall - Buff
		--          Reduces the Physical and magical damage taken by the caster by 75% for 10 sec.
		-- Warrior: Defensive Stance - stance
		--          A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases threat generated.
		-- Warrior: Berserker Stance - stance
		--          An aggressive stance. Critical hit chance is increased by 3% and all damage taken is increased by 10%.
		-- Warrior: Death Wish - Buff
		--          When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%. Lasts 30 sec.
		-- Warrior: Recklessness - Buff
		--          The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.
		-- Warrior: Improved Defensive Stance (Rank 3) - 3,18
		--          Reduces all spell damage taken while in Defensive Stance by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.75,
				["buff"] = GetSpellInfo(41196),		-- ["Shield Wall"],
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.1,
				["stance"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = 0.1,
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = 0.05,
				["buff"] = GetSpellInfo(12292),		-- ["Death Wish"],
			},
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = 0.2,
				["buff"] = GetSpellInfo(13847),		-- ["Recklessness"],
			},
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Warrior: Toughness (Rank 5) - 3,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 3,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STA"] = {
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Warrior: Shield Mastery (Rank 3) - 3,16
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		["MOD_BLOCK_VALUE"] = {
			{
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	}
end

if addonTable.playerRace == "NightElf" then
	StatLogic.StatModTable["NightElf"] = {
		-- Night Elf : Quickness - Racial
		--             Dodge chance increased by 1%.
		["ADD_DODGE"] = {
			{
				["value"] = 1,
			},
		},
	}
elseif addonTable.playerRace == "Tauren" then
	StatLogic.StatModTable["Tauren"] = {
		-- Tauren: Endurance - Racial
		--         Total Health increased by 5%.
		["MOD_HEALTH"] = {
			{
				["value"] = 0.05,
			},
		},
	}
elseif addonTable.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
		-- Gnome: Expansive Mind - Racial
		--        Increase Intelligence by 5%.
		["MOD_INT"] = {
			{
				["value"] = 0.05,
			},
		},
	}
elseif addonTable.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
		-- Human: The Human Spirit - Racial
		--        Increase Spirit by 10%.
		["MOD_SPIRIT"] = {
			{
				["value"] = 0.1,
			},
		},
	}
end

StatLogic.StatModTable["ALL"] = {
	-- Paladin: Lay on Hands (Rank 1/2) - Buff
	--          Armor increased by 15%/30%.
	-- Priest: Inspiration (Rank 1/2/3) - Buff
	--         Increases armor by 8%/16%/25%.
	-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
	--         Increases your armor value by 8%/16%/25%.
	["MOD_ARMOR"] = {
		{
			["rank"] = {
				0.15, 0.30,
			},
			["buff"] = GetSpellInfo(27154),		-- ["Lay on Hands"],
		},
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["buff"] = GetSpellInfo(15363),		-- ["Inspiration"],
		},
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["buff"] = GetSpellInfo(16237),		-- ["Ancestral Fortitude"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_STR"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_AGI"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_STA"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Ember Skyfire Diamond
	-- 2% Intellect
	["MOD_INT"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
		},
		{
			["meta"] = 35503,
			["value"] = 0.02,
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_SPI"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
		},
	},
	-- Whitemend Wisdom
	-- Increases healing by up to 10% of your total Intellect.
	["ADD_HEALING_MOD_INT"] = {
		{
			["set"] = 571,
			["pieces"] = 2,
			["value"] = 0.1,
		}
	},
	-- Wrath of Spellfire
	-- Increases spell damage by up to 7% of your total Intellect.
	["ADD_SPELL_DMG_MOD_INT"] = {
		{
			["set"] = 552,
			["pieces"] = 3,
			["value"] = 0.07,
		},
	},
	-- Primal Mooncloth
	-- Allow 5% of your Mana regeneration to continue while casting.
	["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
		{
			["set"] = 554,
			["pieces"] = 3,
			["value"] = 0.05,
		},
	},
}
