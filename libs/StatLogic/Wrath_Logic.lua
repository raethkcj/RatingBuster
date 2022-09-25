local addonName, addonTable = ...
local StatLogic = LibStub:GetLibrary(addonName)

-- 3.1.0
-- Haste Rating: Shamans, Paladins, Druids, and Death Knights now receive 30% more melee haste from Haste Rating.
local ExtraHasteClasses = {
	["PALADIN"] = true,
	["DEATHKNIGHT"] = true,
	["SHAMAN"] = true,
	["DRUID"] = true,
}
local extraHaste = ExtraHasteClasses[addonTable.playerClass] and 1.3 or 1

-- Level 60 rating base
addonTable.RatingBase = {
	[CR_WEAPON_SKILL] = 2.5,
	[CR_DEFENSE_SKILL] = 1.5,
	[CR_DODGE] = 13.8,
	[CR_PARRY] = 13.8,
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
	[CR_CRIT_TAKEN_MELEE] = 28.75, -- resilience
	[CR_CRIT_TAKEN_RANGED] = 28.75,
	[CR_CRIT_TAKEN_SPELL] = 28.75,
	[CR_HASTE_MELEE] = 10 / extraHaste,
	[CR_HASTE_RANGED] = 10,
	[CR_HASTE_SPELL] = 10,
	[CR_WEAPON_SKILL_MAINHAND] = 2.5,
	[CR_WEAPON_SKILL_OFFHAND] = 2.5,
	[CR_WEAPON_SKILL_RANGED] = 2.5,
	[CR_EXPERTISE] = 2.5,
	[CR_ARMOR_PENETRATION] = 4.69512176513672 / 1.1,
}
addonTable.SetCRMax()

StatLogic.GenericStatMap = {
	[CR_HIT] = {
		[CR_HIT_MELEE] = true,
		[CR_HIT_RANGED] = true,
		[CR_HIT_SPELL] = true,
	},
	[CR_CRIT] = {
		[CR_CRIT_MELEE] = true,
		[CR_CRIT_RANGED] = true,
		[CR_CRIT_SPELL] = true,
	},
	[CR_HASTE] = {
		[CR_HASTE_MELEE] = true,
		[CR_HASTE_RANGED] = true,
		[CR_HASTE_SPELL] = true,
	},
}

--[[---------------------------------
	:GetNormalManaRegenFromSpi(spi, [int], [level])
-------------------------------------
Notes:
	* Formula and BASE_REGEN values derived by Whitetooth (hotdogee [at] gmail [dot] com)
	* Calculates the mana regen per 5 seconds from spirit when out of 5 second rule for given intellect and level.
	* Player class is no longer a parameter
	* ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
Arguments:
	number - Spirit
	[optional] number - Intellect. Default: player's intellect
	[optional] number - Level used in calculations. Default: player's level
Returns:
	; mp5o5sr : number - Mana regen per 5 seconds when out of 5 second rule
	; statid : string - "MANA_REG_NOT_CASTING"
Example:
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15)
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
local BaseManaRegenPerSpi = {
	[1] =  0.020979,
	[2] =  0.020515,
	[3] =  0.020079,
	[4] =  0.019516,
	[5] =  0.018997,
	[6] =  0.018646,
	[7] =  0.018314,
	[8] =  0.017997,
	[9] =  0.017584,
	[10] = 0.017197,
	[11] = 0.016551,
	[12] = 0.015729,
	[13] = 0.015229,
	[14] = 0.014580,
	[15] = 0.014008,
	[16] = 0.013650,
	[17] = 0.013175,
	[18] = 0.012832,
	[19] = 0.012475,
	[20] = 0.012073,
	[21] = 0.011840,
	[22] = 0.011494,
	[23] = 0.011292,
	[24] = 0.010990,
	[25] = 0.010761,
	[26] = 0.010546,
	[27] = 0.010321,
	[28] = 0.010151,
	[29] = 0.009949,
	[30] = 0.009740,
	[31] = 0.009597,
	[32] = 0.009425,
	[33] = 0.009278,
	[34] = 0.009123,
	[35] = 0.008974,
	[36] = 0.008847,
	[37] = 0.008698,
	[38] = 0.008581,
	[39] = 0.008457,
	[40] = 0.008338,
	[41] = 0.008235,
	[42] = 0.008113,
	[43] = 0.008018,
	[44] = 0.007906,
	[45] = 0.007798,
	[46] = 0.007713,
	[47] = 0.007612,
	[48] = 0.007524,
	[49] = 0.007430,
	[50] = 0.007340,
	[51] = 0.007268,
	[52] = 0.007184,
	[53] = 0.007116,
	[54] = 0.007029,
	[55] = 0.006945,
	[56] = 0.006884,
	[57] = 0.006805,
	[58] = 0.006747,
	[59] = 0.006667,
	[60] = 0.006600,
	[61] = 0.006421,
	[62] = 0.006314,
	[63] = 0.006175,
	[64] = 0.006072,
	[65] = 0.005981,
	[66] = 0.005885,
	[67] = 0.005791,
	[68] = 0.005732,
	[69] = 0.005668,
	[70] = 0.005596,
	[71] = 0.005316,
	[72] = 0.005049,
	[73] = 0.004796,
	[74] = 0.004555,
	[75] = 0.004327,
	[76] = 0.004110,
	[77] = 0.003903,
	[78] = 0.003708,
	[79] = 0.003522,
	[80] = 0.003345,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(int, 3, "nil", "number")
	self:argCheck(level, 4, "nil", "number")

	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 80 then
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

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
addonTable.CritPerAgi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = {
		0.2587, 0.2264, 0.2264, 0.2264, 0.2264, 0.2012, 0.2012, 0.2012, 0.2012, 0.2012,
		0.1811, 0.1811, 0.1646, 0.1646, 0.1509, 0.1509, 0.1509, 0.1393, 0.1393, 0.1293,
		0.1293, 0.1293, 0.1207, 0.1132, 0.1132, 0.1065, 0.1065, 0.1006, 0.1006, 0.0953,
		0.0953, 0.0905, 0.0905, 0.0862, 0.0862, 0.0823, 0.0823, 0.0787, 0.0787, 0.0755,
		0.0724, 0.0724, 0.0696, 0.0696, 0.0671, 0.0671, 0.0647, 0.0624, 0.0624, 0.0604,
		0.0604, 0.0584, 0.0566, 0.0566, 0.0549, 0.0549, 0.0533, 0.0517, 0.0517, 0.0503,
		0.0477, 0.0453, 0.0431, 0.0421, 0.0402, 0.0385, 0.0370, 0.0355, 0.0342, 0.0335,
		0.0312, 0.0287, 0.0266, 0.0248, 0.0232, 0.0216, 0.0199, 0.0185, 0.0172, 0.0160,
	},
	[StatLogic:GetClassIdOrName("PALADIN")] = {
		0.2164, 0.2164, 0.2164, 0.1924, 0.1924, 0.1924, 0.1924, 0.1732, 0.1732, 0.1732,
		0.1732, 0.1732, 0.1574, 0.1574, 0.1443, 0.1443, 0.1443, 0.1332, 0.1332, 0.1237,
		0.1237, 0.1237, 0.1154, 0.1082, 0.1082, 0.1082, 0.1019, 0.1019, 0.0962, 0.0962,
		0.0911, 0.0911, 0.0866, 0.0866, 0.0825, 0.0825, 0.0825, 0.0787, 0.0787, 0.0753,
		0.0753, 0.0753, 0.0721, 0.0693, 0.0693, 0.0666, 0.0666, 0.0641, 0.0641, 0.0618,
		0.0597, 0.0597, 0.0577, 0.0577, 0.0559, 0.0559, 0.0541, 0.0525, 0.0525, 0.0509,
		0.0495, 0.0481, 0.0468, 0.0456, 0.0444, 0.0444, 0.0422, 0.0422, 0.0412, 0.0403,
		0.0368, 0.0346, 0.0321, 0.0299, 0.0275, 0.0258, 0.0240, 0.0222, 0.0206, 0.0192,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.2840, 0.2834, 0.2711, 0.2530, 0.2430, 0.2337, 0.2251, 0.2171, 0.2051, 0.1984,
		0.1848, 0.1670, 0.1547, 0.1441, 0.1330, 0.1267, 0.1194, 0.1117, 0.1060, 0.0998,
		0.0962, 0.0910, 0.0872, 0.0829, 0.0797, 0.0767, 0.0734, 0.0709, 0.0680, 0.0654,
		0.0637, 0.0614, 0.0592, 0.0575, 0.0556, 0.0541, 0.0524, 0.0508, 0.0493, 0.0481,
		0.0470, 0.0457, 0.0444, 0.0433, 0.0421, 0.0413, 0.0402, 0.0391, 0.0382, 0.0373,
		0.0366, 0.0358, 0.0350, 0.0341, 0.0334, 0.0328, 0.0321, 0.0314, 0.0307, 0.0301,
		0.0297, 0.0290, 0.0284, 0.0279, 0.0273, 0.0270, 0.0264, 0.0259, 0.0254, 0.0250,
		0.0232, 0.0216, 0.0201, 0.0187, 0.0173, 0.0161, 0.0150, 0.0139, 0.0129, 0.0120,
	},
	[StatLogic:GetClassIdOrName("ROGUE")] = {
		0.4476, 0.4290, 0.4118, 0.3813, 0.3677, 0.3550, 0.3321, 0.3217, 0.3120, 0.2941,
		0.2640, 0.2394, 0.2145, 0.1980, 0.1775, 0.1660, 0.1560, 0.1450, 0.1355, 0.1271,
		0.1197, 0.1144, 0.1084, 0.1040, 0.0980, 0.0936, 0.0903, 0.0865, 0.0830, 0.0792,
		0.0768, 0.0741, 0.0715, 0.0691, 0.0664, 0.0643, 0.0628, 0.0609, 0.0592, 0.0572,
		0.0556, 0.0542, 0.0528, 0.0512, 0.0497, 0.0486, 0.0474, 0.0464, 0.0454, 0.0440,
		0.0431, 0.0422, 0.0412, 0.0404, 0.0394, 0.0386, 0.0378, 0.0370, 0.0364, 0.0355,
		0.0334, 0.0322, 0.0307, 0.0296, 0.0286, 0.0276, 0.0268, 0.0262, 0.0256, 0.0250,
		0.0232, 0.0216, 0.0201, 0.0187, 0.0173, 0.0161, 0.0150, 0.0139, 0.0129, 0.0120,
	},
	[StatLogic:GetClassIdOrName("PRIEST")] = {
		0.0912, 0.0912, 0.0912, 0.0868, 0.0868, 0.0868, 0.0868, 0.0829, 0.0829, 0.0829,
		0.0829, 0.0793, 0.0793, 0.0793, 0.0793, 0.0760, 0.0760, 0.0760, 0.0729, 0.0729,
		0.0729, 0.0729, 0.0701, 0.0701, 0.0701, 0.0675, 0.0675, 0.0675, 0.0651, 0.0651,
		0.0651, 0.0629, 0.0629, 0.0629, 0.0608, 0.0608, 0.0608, 0.0588, 0.0588, 0.0588,
		0.0570, 0.0570, 0.0553, 0.0553, 0.0553, 0.0536, 0.0536, 0.0521, 0.0521, 0.0521,
		0.0507, 0.0507, 0.0493, 0.0493, 0.0480, 0.0480, 0.0468, 0.0468, 0.0456, 0.0456,
		0.0445, 0.0446, 0.0443, 0.0434, 0.0427, 0.0421, 0.0415, 0.0413, 0.0412, 0.0401,
		0.0372, 0.0344, 0.0320, 0.0299, 0.0276, 0.0257, 0.0240, 0.0222, 0.0207, 0.0192,
	},
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = {
		0.2587, 0.2264, 0.2264, 0.2264, 0.2264, 0.2012, 0.2012, 0.2012, 0.2012, 0.2012,
		0.1811, 0.1811, 0.1646, 0.1646, 0.1509, 0.1509, 0.1509, 0.1393, 0.1393, 0.1293,
		0.1293, 0.1293, 0.1207, 0.1132, 0.1132, 0.1065, 0.1065, 0.1006, 0.1006, 0.0953,
		0.0953, 0.0905, 0.0905, 0.0862, 0.0862, 0.0823, 0.0823, 0.0787, 0.0787, 0.0755,
		0.0724, 0.0724, 0.0696, 0.0696, 0.0671, 0.0671, 0.0647, 0.0624, 0.0624, 0.0604,
		0.0604, 0.0584, 0.0566, 0.0566, 0.0549, 0.0549, 0.0533, 0.0517, 0.0517, 0.0503,
		0.0477, 0.0453, 0.0431, 0.0421, 0.0402, 0.0385, 0.0370, 0.0355, 0.0342, 0.0335,
		0.0312, 0.0287, 0.0266, 0.0248, 0.0232, 0.0216, 0.0199, 0.0185, 0.0172, 0.0160,
	},
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1039, 0.1039, 0.0990, 0.0990, 0.0945, 0.0945, 0.0945, 0.0903, 0.0903, 0.0866,
		0.0866, 0.0831, 0.0831, 0.0799, 0.0770, 0.0742, 0.0742, 0.0717, 0.0717, 0.0670,
		0.0670, 0.0649, 0.0649, 0.0630, 0.0611, 0.0594, 0.0594, 0.0577, 0.0577, 0.0547,
		0.0547, 0.0533, 0.0520, 0.0520, 0.0495, 0.0483, 0.0483, 0.0472, 0.0472, 0.0452,
		0.0442, 0.0442, 0.0433, 0.0424, 0.0416, 0.0407, 0.0400, 0.0392, 0.0392, 0.0378,
		0.0371, 0.0365, 0.0365, 0.0358, 0.0346, 0.0341, 0.0335, 0.0335, 0.0330, 0.0320,
		0.0310, 0.0304, 0.0294, 0.0285, 0.0281, 0.0273, 0.0267, 0.0261, 0.0255, 0.0250,
		0.0232, 0.0216, 0.0201, 0.0187, 0.0173, 0.0161, 0.0150, 0.0139, 0.0129, 0.0120,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.0773, 0.0773, 0.0773, 0.0736, 0.0736, 0.0736, 0.0736, 0.0736, 0.0736, 0.0703,
		0.0703, 0.0703, 0.0703, 0.0703, 0.0672, 0.0672, 0.0672, 0.0672, 0.0672, 0.0644,
		0.0644, 0.0644, 0.0644, 0.0618, 0.0618, 0.0618, 0.0618, 0.0618, 0.0595, 0.0595,
		0.0595, 0.0595, 0.0573, 0.0573, 0.0573, 0.0552, 0.0552, 0.0552, 0.0552, 0.0533,
		0.0533, 0.0533, 0.0533, 0.0515, 0.0515, 0.0515, 0.0499, 0.0499, 0.0499, 0.0483,
		0.0483, 0.0483, 0.0468, 0.0468, 0.0468, 0.0455, 0.0455, 0.0455, 0.0442, 0.0442,
		0.0442, 0.0442, 0.0429, 0.0429, 0.0429, 0.0418, 0.0418, 0.0418, 0.0407, 0.0407,
		0.0377, 0.0351, 0.0329, 0.0303, 0.0281, 0.0262, 0.0242, 0.0227, 0.0209, 0.0196,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1189, 0.1189, 0.1132, 0.1132, 0.1132, 0.1081, 0.1081, 0.1081, 0.1034, 0.1034,
		0.0991, 0.0991, 0.0991, 0.0959, 0.0944, 0.0928, 0.0914, 0.0899, 0.0885, 0.0871,
		0.0857, 0.0844, 0.0831, 0.0818, 0.0805, 0.0792, 0.0780, 0.0768, 0.0756, 0.0745,
		0.0733, 0.0722, 0.0711, 0.0700, 0.0690, 0.0679, 0.0669, 0.0659, 0.0649, 0.0639,
		0.0630, 0.0620, 0.0611, 0.0602, 0.0593, 0.0584, 0.0576, 0.0567, 0.0559, 0.0551,
		0.0543, 0.0535, 0.0527, 0.0519, 0.0512, 0.0504, 0.0497, 0.0490, 0.0483, 0.0476,
		0.0469, 0.0462, 0.0455, 0.0449, 0.0442, 0.0436, 0.0430, 0.0424, 0.0418, 0.0412,
		0.0384, 0.0355, 0.0330, 0.0309, 0.0287, 0.0264, 0.0245, 0.0229, 0.0212, 0.0198,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.1262, 0.1262, 0.1202, 0.1202, 0.1148, 0.1148, 0.1098, 0.1098, 0.1052, 0.0971,
		0.0935, 0.0935, 0.0902, 0.0902, 0.0842, 0.0842, 0.0814, 0.0789, 0.0789, 0.0701,
		0.0701, 0.0682, 0.0664, 0.0664, 0.0631, 0.0631, 0.0616, 0.0601, 0.0601, 0.0549,
		0.0537, 0.0537, 0.0526, 0.0515, 0.0505, 0.0495, 0.0485, 0.0485, 0.0476, 0.0443,
		0.0435, 0.0435, 0.0428, 0.0421, 0.0407, 0.0401, 0.0401, 0.0394, 0.0388, 0.0366,
		0.0361, 0.0356, 0.0351, 0.0351, 0.0341, 0.0337, 0.0332, 0.0328, 0.0324, 0.0308,
		0.0299, 0.0295, 0.0285, 0.0279, 0.0274, 0.0269, 0.0265, 0.0258, 0.0254, 0.0250,
		0.0232, 0.0216, 0.0201, 0.0187, 0.0173, 0.0161, 0.0150, 0.0139, 0.0129, 0.0120,
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
		0.0159, 0.0154, 0.0149, 0.0145, 0.0140, 0.0136, 0.0134, 0.0131, 0.0128, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.0699, 0.0666, 0.0666, 0.0635, 0.0635, 0.0608, 0.0608, 0.0583, 0.0583, 0.0559,
		0.0559, 0.0538, 0.0499, 0.0499, 0.0466, 0.0466, 0.0451, 0.0424, 0.0424, 0.0399,
		0.0388, 0.0388, 0.0368, 0.0358, 0.0350, 0.0341, 0.0333, 0.0325, 0.0318, 0.0304,
		0.0297, 0.0297, 0.0285, 0.0280, 0.0269, 0.0264, 0.0264, 0.0254, 0.0250, 0.0241,
		0.0237, 0.0237, 0.0229, 0.0225, 0.0218, 0.0215, 0.0212, 0.0206, 0.0203, 0.0197,
		0.0194, 0.0192, 0.0186, 0.0184, 0.0179, 0.0177, 0.0175, 0.0170, 0.0168, 0.0164,
		0.0157, 0.0154, 0.0150, 0.0144, 0.0141, 0.0137, 0.0133, 0.0130, 0.0128, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
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
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = zero,
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1333, 0.1272, 0.1217, 0.1217, 0.1166, 0.1120, 0.1077, 0.1037, 0.1000, 0.1000,
		0.0933, 0.0875, 0.0800, 0.0756, 0.0700, 0.0666, 0.0636, 0.0596, 0.0571, 0.0538,
		0.0518, 0.0500, 0.0474, 0.0459, 0.0437, 0.0424, 0.0412, 0.0394, 0.0383, 0.0368,
		0.0354, 0.0346, 0.0333, 0.0325, 0.0314, 0.0304, 0.0298, 0.0289, 0.0283, 0.0272,
		0.0267, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235, 0.0231, 0.0226, 0.0220, 0.0215,
		0.0210, 0.0207, 0.0201, 0.0199, 0.0193, 0.0190, 0.0187, 0.0182, 0.0179, 0.0175,
		0.0164, 0.0159, 0.0152, 0.0147, 0.0142, 0.0138, 0.0134, 0.0131, 0.0128, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.1637, 0.1574, 0.1516, 0.1411, 0.1364, 0.1320, 0.1279, 0.1240, 0.1169, 0.1137,
		0.1049, 0.0930, 0.0871, 0.0731, 0.0671, 0.0639, 0.0602, 0.0568, 0.0538, 0.0505,
		0.0487, 0.0460, 0.0445, 0.0422, 0.0405, 0.0390, 0.0372, 0.0338, 0.0325, 0.0312,
		0.0305, 0.0294, 0.0286, 0.0278, 0.0269, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235,
		0.0230, 0.0215, 0.0211, 0.0206, 0.0201, 0.0197, 0.0192, 0.0188, 0.0184, 0.0179,
		0.0176, 0.0173, 0.0170, 0.0166, 0.0162, 0.0154, 0.0151, 0.0149, 0.0146, 0.0143,
		0.0143, 0.0143, 0.0143, 0.0143, 0.0142, 0.0138, 0.0134, 0.0131, 0.0128, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, 0.0825, 0.0767, 0.0717, 0.0688, 0.0635, 0.0600, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, 0.0446, 0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		0.0256, 0.0248, 0.0243, 0.0236, 0.0229, 0.0224, 0.0220, 0.0214, 0.0209, 0.0204,
		0.0200, 0.0195, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0172, 0.0168, 0.0165,
		0.0159, 0.0154, 0.0148, 0.0143, 0.0138, 0.0135, 0.0130, 0.0127, 0.0126, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.1431, 0.1369, 0.1312, 0.1259, 0.1211, 0.1166, 0.1124, 0.1124, 0.1086, 0.0984,
		0.0926, 0.0851, 0.0807, 0.0750, 0.0684, 0.0656, 0.0617, 0.0594, 0.0562, 0.0516,
		0.0500, 0.0477, 0.0463, 0.0437, 0.0420, 0.0409, 0.0394, 0.0384, 0.0366, 0.0346,
		0.0339, 0.0325, 0.0318, 0.0309, 0.0297, 0.0292, 0.0284, 0.0276, 0.0269, 0.0256,
		0.0252, 0.0244, 0.0240, 0.0233, 0.0228, 0.0223, 0.0219, 0.0214, 0.0209, 0.0202,
		0.0198, 0.0193, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0173, 0.0169, 0.0164,
		0.0162, 0.0157, 0.0150, 0.0146, 0.0142, 0.0137, 0.0133, 0.0131, 0.0128, 0.0125,
		0.0116, 0.0108, 0.0101, 0.0093, 0.0087, 0.0081, 0.0075, 0.0070, 0.0065, 0.0060,
	},
}

addonTable.APPerStr = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 2,
	[StatLogic:GetClassIdOrName("PALADIN")] = 2,
	[StatLogic:GetClassIdOrName("HUNTER")] = 1,
	[StatLogic:GetClassIdOrName("ROGUE")] = 1,
	[StatLogic:GetClassIdOrName("PRIEST")] = 1,
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 2,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 1,
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
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 0,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 1,
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
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 0,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 0,
	[StatLogic:GetClassIdOrName("MAGE")] = 0,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 0,
	[StatLogic:GetClassIdOrName("DRUID")] = 0,
}

addonTable.BaseDodge = {
	[StatLogic:GetClassIdOrName("WARRIOR")] =     3.6640,
	[StatLogic:GetClassIdOrName("PALADIN")] =     3.4943,
	[StatLogic:GetClassIdOrName("HUNTER")] =     -4.0873,
	[StatLogic:GetClassIdOrName("ROGUE")] =       2.0957,
	[StatLogic:GetClassIdOrName("PRIEST")] =      3.4178,
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 3.6640,
	[StatLogic:GetClassIdOrName("SHAMAN")] =      2.1080,
	[StatLogic:GetClassIdOrName("MAGE")] =        3.6587,
	[StatLogic:GetClassIdOrName("WARLOCK")] =     2.4211,
	[StatLogic:GetClassIdOrName("DRUID")] =       5.6097,
}

addonTable.StatModValidators.glyph = {
	validate = function(case)
		return IsPlayerSpell(case.glyph)
	end,
	events = {
		["GLYPH_ADDED"] = true,
		["GLYPH_REMOVED"] = true,
	}
}
addonTable.StatModCacheInvalidators["PLAYER_TALENT_UPDATE"] = addonTable.StatModCacheInvalidators["CHARACTER_POINTS_CHANGED"]
addonTable.RegisterValidatorEvents()

addonTable.bonusArmorItemEquipLoc = {
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

local BuffGroup = {
	MOD_PHYS_DMG_TAKEN = 1,
	MOD_AP = 2,
	MOD_STATS = 3,
}

StatLogic.StatModTable = {}
if addonTable.playerClass == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		-- Druid: Master Shapeshifter (Rank 2) - 3,9
		--        Moonkin Form - Increases spell damage by 2%/4%.
		--      * Does not affect char window stats
		-- Druid: Earth and Moon (Rank 5) - 1,27
		--        Also increases your spell damage by 1%/2%/3%/4%/5%.
		--      * Does not affect char window stats
		--[[
		["MOD_SPELL_DMG"] = {
		{
		["rank"] = {
		0.02, 0.04,
		},
		["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
		},
		{
		["tab"] = 1,
		["num"] = 27,
		["rank"] = {
		0.01, 0.02, 0.03, 0.04, 0.05,
		},
		},
		},
		--]]
		-- Druid: Master Shapeshifter (Rank 2) - 3,9
		--        Tree of Life Form - Increases healing by 2%/4%.
		--      * Does not affect char window stats
		--[[
		["MOD_HEALING"] = {
		{
		["rank"] = {
		0.02, 0.04,
		},
		["buff"] = GetSpellInfo(33891),		-- ["Tree of Life"],
		},
		},
		--]]
		-- Druid: Improved Moonkin Form (Rank 3) - 1,19
		--        Your Moonkin Aura also causes affected targets to gain 1%/2%/3% haste and you to gain 10/20/30% of your spirit as additional spell damage.
		["ADD_SPELL_DMG_MOD_SPI"] = {
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["buff"] = GetSpellInfo(24858), -- ["Moonkin Form"],
			},
		},
		-- Druid: Improved Tree of Life (Rank 3) - 3,24
		--        Increases your Armor while in Tree of Life Form by 33%/66%/100%, and increases your healing spell power by 5%/10%/15% of your spirit while in Tree of Life Form.
		["ADD_HEALING_MOD_SPI"] = {
			{
				["tab"] = 3,
				["num"] = 24,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
				["buff"] = GetSpellInfo(33891), -- ["Tree of Life"],
			},
		},
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		-- 3.0.1: Increases your spell damage and healing by 4%/8%/12% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
			},
		},
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		-- 3.0.1: Increases your spell damage and healing by 4%/8%/12% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
			},
		},
		-- Druid: Nurturing Instinct (Rank 2) - 2,14
		--        Increases your healing spells by up to 25%/50% of your Strength.
		-- 2.4.0: Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
		-- 3.0.1: 2,15: Increases your healing spells by up to 35%/70% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
		["ADD_HEALING_MOD_AGI"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.35, 0.7,
				},
			},
		},
		-- Druid: Intensity (Rank 3) - 3,6
		--        Allows 17/33/50% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 3,
				["num"] = 7,
				["rank"] = {
					0.17, 0.33, 0.50,
				},
			},
		},
		-- Druid: Dreamstate (Rank 3) - 1,15
		--        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.04, 0.07, 0.10,
				},
			},
		},
		-- Druid: Feral Swiftness (Rank 2) - 2,6
		--        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
		-- Druid: Natural Reaction (Rank 3) - 2,16
		--        Increases your dodge while in Bear Form or Dire Bear Form by 2%/4%/6%, and you regenerate 3 rage every time you dodge while in Bear Form or Dire Bear Form.
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
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Druid: Barkskin - Buff
		--        All damage taken is reduced by 20%.
		-- Druid: Improved Barkskin (Rank 2) - 3,25
		--        Increases the damage reduction granted by your Barkskin spell by 5/10%
		-- Druid: Natural Perfection (Rank 3) - 3,19
		--        Your critical strike chance with all spells is increased by 3% and critical strikes against you
		--        give you the Natural Perfection effect reducing all damage taken by 2/3/4%.  Stacks up to 3 times.  Lasts 8 sec.
		-- Druid: Protector of the Pack (Rank 5) - 2,22
		--        Increases your attack power in Bear Form and Dire Bear Form by 2%/4%/6%, and for each friendly player
		--        in your party when you enter Bear Form or Dire Bear Form, damage you take is reduced while in Bear Form and Dire Bear Form by 1%/2%/3%.
		-- Druid: Balance of Power (Rank 2) - 1,17
		--        Increases your chance to hit with all spells by 2%/4% and reduces the damage taken by all spells by 3%/6%.
		["MOD_DMG_TAKEN"] = {
			-- Barkskin
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
				["buff"] = GetSpellInfo(22812),		-- ["Barkskin"],
			},
			-- Improved Barkskin
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 25,
				["rank"] = {
					-0.05, -0.1,
				},
				["buff"] = GetSpellInfo(22812),		-- ["Barkskin"],
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
				["tab"] = 3,
				["num"] = 19,
				["rank"] = {
					-0.02, -0.03, -0.04,
				},
				["buff"] = GetSpellInfo(45283),		-- ["Natural Perfection"],
				["buffStack"] = 3, -- max number of stacks
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
				["num"] = 22,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
				["condition"] = "GetNumPartyMembers() == 1",
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
				["num"] = 22,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
				["condition"] = "GetNumPartyMembers() == 2",
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
				["num"] = 22,
				["rank"] = {
					-0.03, -0.06, -0.09,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
				["condition"] = "GetNumPartyMembers() == 3",
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
				["num"] = 22,
				["rank"] = {
					-0.04, -0.08, -0.12,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
				["condition"] = "GetNumPartyMembers() == 4",
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
				["num"] = 22,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
				["condition"] = "GetNumPartyMembers() == 1",
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
				["num"] = 22,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
				["condition"] = "GetNumPartyMembers() == 2",
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
				["num"] = 22,
				["rank"] = {
					-0.03, -0.06, -0.09,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
				["condition"] = "GetNumPartyMembers() == 3",
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
				["num"] = 22,
				["rank"] = {
					-0.04, -0.08, -0.12,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
				["condition"] = "GetNumPartyMembers() == 4",
			},
			--Balance of Power
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					-0.03, -0.06,
				},
			},
		},
		-- Druid: Thick Hide (Rank 3) - 2,5
		--        Increases your Armor contribution from items by 4%/7%/10%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 370%, and stamina by 25%.
		-- Druid: Moonkin Form - Buff
		--        While in this form the armor contribution from items is increased by 370% and
		--        all party and raid members within 45 yards have their spell critical chance increased by 5%.
		--        Spell critical strikes in this form have a chance to instantly regenerate 2% of your total mana.
		-- Druid: Improved Tree of Life (Rank 3) - 3,24
		--        Increases your Armor while in Tree of Life Form by 67%/133%/200%
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		--        , and increases your armor contribution from cloth and leather items in Bear Form and Dire Bear Form by 11/22/33%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
			{
				["value"] = 1.8,
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["value"] = 3.7,
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			{
				["value"] = 3.7,
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
			{
				["tab"] = 3,
				["num"] = 24,
				["rank"] = {
					0.67, 1.33, 2,
				},
				["buff"] = GetSpellInfo(33891),		-- ["Tree of Life"],
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.11, 0.22, 0.33,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.11, 0.22, 0.33,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		--if class == "DRUID" and select(5, GetTalentInfo(2, 10)) > 0 and weaponItemEquipLoc[select(9, GetItemInfo(link))] then
		-- Druid: Predatory Strikes (Rank 3) - 2,10
		--				Increases your melee attack power in Cat, Bear and Dire Bear Forms by
		--				7,14,20% of any attack power on your equipped weapon.
		["MOD_FAP"] = {
			{
				["tab"] = 2,
				["num"] = 10,
				["rank"] = {
					0.07, 0.14, 0.20,
				},
			},
		},
		-- Druid: Survival Instincts - Buff
		--        Health increased by 30% of maximum while in Bear Form, Cat Form, or Dire Bear Form.
		--        Patch 3.0.8: The extra health from this ability now persists in all forms,
		--        but the ability can only be activated in Cat Form, Bear Form, or Dire Bear Form.
		["MOD_HEALTH"] = {
			{
				["value"] = 0.3,
				["buff"] = GetSpellInfo(50322),		-- ["Survival Instincts"],
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Heart of the Wild (Rank 5) - 2,17
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition,
		--        while in Bear or Dire Bear Form your Stamina is increased by 2/4/6/8/10% and
		--        while in Cat Form your attack power is increased by 2/4/6/8/10%.
		-- Druid: Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- 9038:  Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 370%, and stamina by 25%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		["MOD_STA"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			-- Heart of the Wild: +2/4/6/8/10% stamina in bear / dire bear
			{
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			-- Survival of the Fittest: 2%/4%/6% all stats
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
			-- Bear Form / Dire Bear Form: +25% stamina
			{
				["value"] = 0.25,
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			-- Bear Form / Dire Bear Form: +25% stamina
			{
				["value"] = 0.25,
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		["MOD_STR"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Heart of the Wild (Rank 5) - 2,17
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition,
		--        while in Bear or Dire Bear Form your Stamina is increased by 2/4/6/8/10% and
		--        while in Cat Form your attack power is increased by 2/4/6/8/10%.
		-- Druid: Protector of the Pack (Rank 5) - 2,22
		--        Increases your attack power in Bear Form and Dire Bear Form by 2%/4%/6%, and for each friendly player in your party when you enter Bear Form or Dire Bear Form, damage you take is reduced while in Bear Form and Dire Bear Form by 1%/2%/3%.
		["MOD_AP"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
			{
				["tab"] = 2,
				["num"] = 22,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 22,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		["MOD_AGI"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Heart of the Wild (Rank 5) - 2,17
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition,
		--        while in Bear or Dire Bear Form your Stamina is increased by 2/4/6/8/10% and
		--        while in Cat Form your attack power is increased by 2/4/6/8/10%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		-- Druid: Furor (Rank 5) - 3,3
		--        Increases your total Intellect while in Moonkin form by 2%/4%/6%/8%/10%.
		["MOD_INT"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
			{
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
		},
		-- Druid: Improved Mark of the Wild (Rank 2) - 3,1
		--        increases all of your total attributes by 1/2%.
		-- Druid: Living Spirit (Rank 3) - 3,17
		--        Increases your total Spirit by 5%/10%/15%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,18
		--        Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
		["MOD_SPI"] = {
			-- Improved Mark of the Wild
			{
				["tab"] = 3,
				["num"] = 1,
				["rank"] = {
					0.01, 0.02,
				},
			},
			{
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
			{
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
		},
	}
elseif addonTable.playerClass == "DEATHKNIGHT" then
	StatLogic.StatModTable["DEATHKNIGHT"] = {
		-- Death Knight: Forceful Deflection - Passive
		--               Increases your Parry Rating by 25% of your total Strength.
		["ADD_PARRY_RATING_MOD_STR"] = {
			{
				["value"] = 0.25,
			},
		},
		-- Death Knight: Bladed Armor (Rank 5) - 1,4
		--               You gain 5/10/15/20/25 attack power for every 1000 points of your armor value.
		--         9014: Increases your attack power by 1/2/3/4/5 for every 180 armor value you have.
		["ADD_AP_MOD_ARMOR"] = {
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					1/180, 2/180, 3/180, 4/180, 5/180,
				},
			},
		},
		-- Death Knight: Blade Barrier - Buff - 1,3
		--               Whenever your Blood Runes are on cooldown, you gain the Blade Barrier effect, which decreases damage taken by 1/2/3/4/5% for the next 10 sec.
		-- Death Knight: Icebound Fortitude - Buff
		--               Damage taken reduced by 30%+def*0.15.
		-- Death Knight: Glyph of Icebound Fortitude - Major Glyph
		--               Your Icebound Fortitude now always grants at least 30% damage reduction, regardless of your defense skill.
		-- Death Knight: Bone Shield - Buff
		--               Damage reduced by 20%.
		-- Death Knight: Anti-Magic Shell - Buff
		--               Spell damage reduced by 75%.
		-- Death Knight: Frost Presence - Buff
		--               Increasing Stamina by 6%, armor contribution from cloth, leather, mail and plate items by 60%, and reducing damage taken by 8%.
		-- Death Knight: Will of the Necropolis (Rank 3) - 1,24
		--               Damage that would take you below 35% health or taken while you are at 35% health is reduced by 5%/10%/15%
		-- Death Knight: Magic Suppression (Rank 3) - 3,17
		--               You take 2%/4%/6% less damage from all magic.
		--        3.2.0: 3,18
		-- Enchant: Rune of Spellshattering - EnchantID: 3367
		--          Deflects 4% of all spell damage to 2h weapon
		-- Enchant: Rune of Spellbreaking - EnchantID: 3595
		--          Deflects 2% of all spell damage to 1h weapon
		-- Death Knight: Improved Frost Presence (Rank 2) - 2,21
		--               While in Blood Presence or Unholy Presence, you retain 3/6% stamina from Frost Presence,
		--               and damage done to you is decreased by an additional 1/2% in Frost Presence.
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
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
				["buff"] = GetSpellInfo(55226),		-- ["Blade Barrier"],
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
				["value"] = -0.30,
				["buff"] = GetSpellInfo(48792),		-- ["Icebound Fortitude"],
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
				["value"] = -0.10,
				["buff"] = GetSpellInfo(48792),		-- ["Icebound Fortitude"],
				["glyph"] = 58625, -- Glyph of Icebound Fortitude
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
				["value"] = -0.20,
				["buff"] = GetSpellInfo(49222),		-- ["Bone Shield"],
			},
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.75,
				["buff"] = GetSpellInfo(48707),		-- ["Anti-Magic Shell"],
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
				["value"] = -0.08,
				["stance"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
			},
			--Will of the Necropolis (Rank 3) - 1,24
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
				["num"] = 24,
				["rank"] = {
					-0.05, -0.1, -0.15,
				},
				["condition"] = "((UnitHealth('player') / UnitHealthMax('player')) < 0.35)",
			},
			--Magic Suppression (Rank 3) - 3,18
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
			-- Rune of Spellshattering
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.04,
				["slot"] = INVSLOT_MAINHAND,
				["enchant"] = 3367,
			},
			-- Rune of Spellbreaking
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.02,
				["slot"] = INVSLOT_MAINHAND,
				["enchant"] = 3595,
			},
			-- Rune of Spellbreaking
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.02,
				["slot"] = INVSLOT_OFFHAND,
				["enchant"] = 3595,
			},
			-- Improved Frost Presence
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
				["num"] = 21,
				["rank"] = {
					-0.01, -0.02,
				},
				["stance"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
			},
		},
		-- Death Knight: Anticipation (Rank 5) - 3,3
		--               Increases your Dodge chance by 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			{
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Death Knight: Frigid Dreadplate (Rank 3) - 2,13
		--               Reduces the chance melee attacks will hit you by 1%/2%/3%.
		["ADD_HIT_TAKEN"] = {
			{
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Death Knight: Toughness (Rank 5) - 2,3
		--               Increases your armor value from items by 2/4/6/8/10% and reduces the duration of all movement slowing effects by 50%.
		-- Death Knight: Unbreakable Armor - Buff
		--               Increases your armor by 25%, your total Strength by 20%
		-- Death Knight: Glyph of Unbreakable Armor - Major Glyph
		--               Increases the armor granted by Unbreakable Armor by 20%.
		-- Death Knight: Frost Presence - Buff
		--               Increasing Stamina by 6%, armor contribution from cloth, leather, mail and plate items by 60%, and reducing damage taken by 5%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
			{
				["value"] = 0.25,
				["buff"] = GetSpellInfo(51271),		-- ["Unbreakable Armor"],
			},
			{
				["value"] = 0.2,
				["buff"] = GetSpellInfo(51271),		-- ["Unbreakable Armor"],
				["glyph"] = 58635,		-- ["Glyph of Unbreakable Armor"],
			},
			{
				["value"] = 0.6,
				["stance"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
			},
		},
		-- Death Knight: Veteran of the Third War (Rank 3) - 1,14
		--               Increases your total Strength by 2%/4%/6% and your total Stamina by 1%/2%/3%.
		-- Enchant: Rune of the Stoneskin Gargoyle - EnchantID: 3847
		--          +25 Defense and +2% Stamina to 2h weapon
		-- Death Knight: Frost Presence - Buff
		--               Increasing Stamina by 8%, armor contribution from cloth, leather, mail
		--               and plate items by 60%, and reducing damage taken by 5%.
		-- Death Knight: Improved Frost Presence (Rank 2) - 2,21
		--               While in Blood Presence or Unholy Presence, you retain 4/8% stamina from Frost Presence,
		--               and damage done to you is decreased by an additional 1/2% in Frost Presence.
		["MOD_STA"] = {
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			{
				["value"] = 0.02,
				["slot"] = INVSLOT_MAINHAND,
				["enchant"] = 3847,
			},
			{
				["value"] = 0.08,
				["stance"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
			},
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.04, 0.08,
				},
				["stance"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
			},
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.04, 0.08,
				},
				["stance"] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
			},
		},
		-- Death Knight: Veteran of the Third War (Rank 3) - 1,14
		--               Increases your total Strength by 6% and your total Stamina by 3%.
		-- Death Knight: Unbreakable Armor - Buff
		--               Increasing your armor by 25% and increasing your Strength by 20% for 20 sec.
		-- Death Knight: Ravenous Dead (Rank 3) - 3,7
		--               Increases your total Strength 1%/2%/3% and the contribution your Ghouls get from your Strength and Stamina by 20%/40%/60%
		-- Death Knight: Abomination's Might - 1,17
		--               Also increases your total Strength by 1%/2%.
		-- Death Knight: Endless Winter (Rank 2) - 2,12
		--               Your strength is increased by 2%/4%.
		["MOD_STR"] = {
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
			{
				["value"] = 0.2,
				["buff"] = GetSpellInfo(51271),		-- ["Unbreakable Armor"],
			},
			{
				["tab"] = 3,
				["num"] = 7,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.01, 0.02,
				},
			},
			-- Endless Winter
			{
				["tab"] = 2,
				["num"] = 12,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	}
elseif addonTable.playerClass == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
		-- Hunter: Hunter vs. Wild (Rank 3) - 3,14
		--         Increases you and your pet's attack power and ranged attack power equal to 10%/20%/30% of your total Stamina.
		["ADD_AP_MOD_STA"] = {
			{
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Hunter: Careful Aim (Rank 3) - 2,4
		--         Increases your ranged attack power by an amount equal to 33%/66%/100% of your total Intellect.
		["ADD_RANGED_AP_MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 4,
				["rank"] = {
					0.33, 0.66, 1,
				},
			},
		},
		-- Hunter: Catlike Reflexes (Rank 3) - 1,19
		--         Increases your chance to dodge by 1%/2%/3% and your pet's chance to dodge by an additional 3%/6%/9%.
		-- Hunter: Aspect of the Monkey - Buff
		--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 18%. Only one Aspect can be active at a time.
		-- Hunter: Improved Aspect of the Monkey (Rank 3) - 1,4
		--         Increases the Dodge bonus of your Aspect of the Monkey and Aspect of the Dragonhawk by 2%/4%/6%.
		-- Hunter: Aspect of the Dragonhawk (Rank 2) - Buff
		--         The hunter takes on the aspects of a dragonhawk, increasing ranged attack power by 300 and chance to dodge by 18%.
		["ADD_DODGE"] = {
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					1, 2, 3,
				},
			},
			{
				["value"] = 18,
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
				["rank"] = {
					18, 18,
				},
				["buff"] = GetSpellInfo(61846),		-- ["Aspect of the Dragonhawk"],
			},
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(61846),		-- ["Aspect of the Dragonhawk"],
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 3,7
		--         Reduces all damage taken by 2%/4% and increases the critical strike chance of your Arcane Shot, Steady Shot, and Explosive Shot by 2%/4%.
		-- Hunter: Aspect Mastery - 1,8
		--         Aspect of the Monkey - Reduces the damage done to you while active by 5%.
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
				["tab"] = 3,
				["num"] = 7,
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
				["tab"] = 1,
				["num"] = 8,
				["value"] = -0.05,
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
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
		-- Hunter: Endurance Training (Rank 5) - 1,2
		--         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
		["MOD_HEALTH"] = {
			{
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Hunter: Survivalist (Rank 5) - 3,8
		--         Increases your Stamina by 2%/4%/6%/8%/10%.
		["MOD_STA"] = {
			{
				["tab"] = 3,
				["num"] = 8,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Hunter: Hunting Party (Rank 3) - 3,27
		--         Increases your total Agility by an additional 1/2/3%
		-- Hunter: Combat Experience (Rank 2) - 2,16
		--         Increases your total Agility and Intellect by 2%/4%.
		-- Hunter: Lightning Reflexes (Rank 5) - 3,17
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			{
				["tab"] = 3,
				["num"] = 27,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.02, 0.04,
				},
			},
			{
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,16
		--         Increases your total Agility and Intellect by 2%/4%.
		["MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	}
elseif addonTable.playerClass == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
		["ADD_SPELL_CRIT_RATING_MOD_SPI"] = {
			-- Mage: Molten Armor (Rank 3) - Buff
			--       increases your critical strike rating by 35% of your spirit
			{
				["rank"] = {
					0.35, 0.35, 0.35, 0.35, 0.35, 0.35, -- 3 ranks
				},
				["buff"] = GetSpellInfo(30482), -- ["Molten Armor"],
			},
			-- Mage: Glyph of Molten Armor - Major Glyph
			--       Your Molten Armor grants an additional 20% of your spirit as critical strike rating.
			{
				["rank"] = {
					0.2, 0.2, 0.2, 0.2, 0.2, 0.2, -- 3 ranks
				},
				["buff"] = GetSpellInfo(30482), -- ["Molten Armor"],
				["glyph"] = 56382, -- Glyph of Molten Armor,
			},
			-- Mage: Khadgar's Regalia(843), Sunstrider's Regalia(844) 2pc - Item Set
			--       converts an additional 15% of your spirit into critical strike rating when Molten Armor is active.
			{
				["rank"] = {
					0.15, 0.15, 0.15, 0.15, 0.15, 0.15, -- 3 ranks
				},
				["buff"] = GetSpellInfo(30482), -- ["Molten Armor"],
				-- Khadgar's Regalia
				["set"] = 843,
				["pieces"] = 2,
			},
			{
				["rank"] = {
					0.15, 0.15, 0.15, 0.15, 0.15, 0.15, -- 3 ranks
				},
				["buff"] = GetSpellInfo(30482), -- ["Molten Armor"],
				-- Sunstrider's Regalia
				["set"] = 844,
				["pieces"] = 2,
			},
		},
		-- Mage: Arcane Fortitude - 1,4
		--       Increases your armor by an amount equal to 50%/100%/150% of your Intellect.
		["ADD_ARMOR_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					0.5, 1, 1.5,
				},
			},
		},
		-- Mage: Arcane Meditation (Rank 3) - 1,13
		--       Allows 17/33/50% of your Mana regeneration to continue while casting.
		-- Mage: Mage Armor (Rank 6) - Buff
		--       Resistance to all magic schools increased by 40 and allows 50% of your mana regeneration to continue while casting.
		-- Mage: Khadgar's Regalia(843), Sunstrider's Regalia(844) 2pc - Item Set
		--       Increases the armor you gain from Ice Armor by 20%, the mana regeneration you gain from Mage Armor by 10%,
		--       and converts an additional 15% of your spirit into critical strike rating when Molten Armor is active.
		-- Mage: Glyph of Mage Armor - Major Glyph
		--       Your Mage Armor spell grants an additional 20% mana regeneration while casting.
		-- Mage: Pyromaniac (Rank 3) - 2,19
		--       Increases chance to critically hit by 1%/2%/3% and allows 17/33/50% of your mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					0.17, 0.33, 0.5,
				},
			},
			{
				["value"] = 0.5,
				["buff"] = GetSpellInfo(6117), -- ["Mage Armor"],
			},
			{
				["value"] = 0.1,
				["buff"] = GetSpellInfo(6117), -- ["Mage Armor"],
				-- Khadgar's Regalia
				["set"] = 843,
				["pieces"] = 2,
			},
			{
				["value"] = 0.1,
				["buff"] = GetSpellInfo(6117), -- ["Mage Armor"],
				-- Sunstrider's Regalia
				["set"] = 844,
				["pieces"] = 2,
			},
			{
				["value"] = 0.2,
				["buff"] = GetSpellInfo(6117), -- ["Mage Armor"],
				["glyph"] = 56383, -- Glyph of Mage Armor,
			},
			{
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.17, 0.33, 0.5,
				},
			},
		},
		-- Mage: Mind Mastery (Rank 5) - 1,25
		--       Increases spell damage by up to 3%/6%/9%/12%/15% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 25,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 25,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Mage: Arctic Winds (Rank 5) - 3,20
		--       Reduces the chance melee and ranged attacks will hit you by 1%/2%/3%/4%/5%.
		-- 3.0.1: 3,21
		-- Mage: Improved Blink (Rank 2) - Buff - 1,13
		--       Chance to be hit by all attacks and spells reduced by 13%/25%.
		-- 3.0.1: 1,15: Chance to be hit by all attacks and spells reduced by 15%/30%.
		["ADD_HIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
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
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					-0.15, -0.30,
				},
				["buff"] = GetSpellInfo(46989),		-- ["Improved Blink"],
			},
		},
		-- Mage: Prismatic Cloak (Rank 3) - 1,16
		--       Reduces all damage taken by 2%/4%.
		-- 3.0.1: 1,18: Reduces all damage taken by 2%/4%/6%.
		-- Mage: Playing with Fire (Rank 3) - 2,13
		--       Increases all spell damage caused by 1%/2%/3%(doesn't effect char tab stat) and all spell damage taken by 1%/2%/3%.
		-- 3.0.1: 2,14
		-- Mage: Frozen Core (Rank 3) - 3,14
		--       Reduces the damage taken by Frost and Fire effects by 2%/4%/6%.
		-- 3.0.1: 3,16
		-- 8962: Reduces the damage taken from all spells by 2%/4%/6%.
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
					-0.02, -0.04, -0.06,
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
				["num"] = 14,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
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
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Mage: Arcane Instability (Rank 3) - 1,19
		--       Increases your spell damage and critical strike chance by 1%/2%/3%.
		-- This does not increase spell power
		-- ["MOD_SPELL_DMG"] = {
		-- {
		-- ["tab"] = 1,
		-- ["num"] = 19,
		-- ["rank"] = {
		-- 0.01, 0.02, 0.03,
		-- },
		-- },
		-- },
		-- Mage: Arcane Mind (Rank 5) - 1,15
		--       Increases your total Intellect by 3%/6%/9%/12%/15%.
		-- 3.0.1: 1,17
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Mage: Student of the Mind (Rank 3) - 1,9
		--       Increases your total Spirit by 4%/7%/10%.
		["MOD_SPI"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
		},
	}
elseif addonTable.playerClass == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
		-- Paladin: Sheath of Light (Rank 3) - 3,24
		--          Increases your spell power by an amount equal to 10%/20%/30% of your attack power
		--   3.1.0: 3,24
		["ADD_SPELL_DMG_MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 24,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_HEALING_MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 24,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Paladin: Touched by the Light (Rank 3) - 2,21
		--          Increases your spell power by an amount equal to 20/40/60% of your Strength
		["ADD_SPELL_DMG_MOD_STR"] = {
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.2, 0.4, 0.6,
				},
			},
		},
		["ADD_HEALING_MOD_STR"] = {
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.2, 0.4, 0.6,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,21
		--          Increases your spell power by 4%/8%/12%/16%/20% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 21,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,21
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 21,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
		},
		-- Paladin: Anticipation (Rank 5) - 2,5
		--          Increases your chance to dodge by 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Paladin: Divine Purpose (Rank 2) - 3,16
		--          Reduces your chance to be hit by spells and ranged attacks by 2%/4% and
		--          gives your Hand of Freedom spell a 50%/100% chance to remove any Stun effects on the target.
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
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Paladin: Blessed Life (Rank 3) - 1,19
		--          All attacks against you have a 4%/7%/10% chance to cause half damage.
		-- Paladin: Ardent Defender (Rank 3) - 2,18
		--          When you have less than 35% health, all damage taken is reduced by 7/13/20%.
		-- Paladin: Improved Righteous Fury (Rank 3) - 2,7
		--          While Righteous Fury is active, all damage taken is reduced by 2%/4%/6%.
		-- Paladin: Guarded by the Light (Rank 2) - 2,23
		--          Reduces spell damage taken by 3%/6% and reduces the mana cost of your Holy Shield, Avenger's Shield and Shield of Righteousness spells by 15%/30%.
		-- Paladin: Shield of the Templar (Rank 3) - 2,24
		--          Reduces all damage taken by 1/2/3%
		-- Paladin: Glyph of Divine Plea - Major Glyph
		--          While Divine Plea is active, you take 3% reduced damage from all sources.
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
				["num"] = 19,
				["rank"] = {
					-0.02, -0.035, -0.05,
				},
			},
			-- Ardent Defender
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
				["num"] = 18,
				["rank"] = {
					-0.07, -0.13, -0.2,
				},
				["condition"] = "((UnitHealth('player') / UnitHealthMax('player')) < 0.35)",
			},
			-- Improved Righteous Fury
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
			-- Guarded by the Light
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 23,
				["rank"] = {
					-0.03, -0.06,
				},
			},
			-- Shield of the Templar
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
				["num"] = 24,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
			-- Glyph of Divine Plea
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["value"] = -0.03,
				["buff"] = GetSpellInfo(54428),		-- ["Divine Plea"],
				["glyph"] = 63223, -- Glyph of Shield Wall,
			},
		},
		-- Paladin: Toughness (Rank 5) - 2,8
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Divine Strength (Rank 5) - 2,2
		--          Increases your total Strength by 3%/6%/9%/12%/15%.
		["MOD_STR"] = {
			{
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Paladin: Sacred Duty (Rank 2) - 2,14
		--          Increases your total Stamina by 4%/8%
		--          Sacred Duty now provides 2 / 4% Stamina, down from 4 / 8% Stamina.
		-- Paladin: Combat Expertise (Rank 3) - 2,20
		--          Increases your expertise by 2/4/6, total Stamina and chance to critically hit by 2%/4%/6%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				},
			},
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
		},
		-- Paladin: Divine Intellect (Rank 5) - 1,4
		--          Increases your total Intellect by 2/4/6/8/10%.
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		-- Paladin: Redoubt (Rank 3) - 2,19
		--          Increases your block value by 10%/20%/30% and
		--          damaging melee and ranged attacks against you have a 10% chance to increase your chance to block by 30%.  Lasts 10 sec or 5 blocks.
		["MOD_BLOCK_VALUE"] = {
			{
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	}
elseif addonTable.playerClass == "PRIEST" then
	StatLogic.StatModTable["PRIEST"] = {
		-- Priest: Focused Power (Rank 2) - 1,16
		--         Increases your total spell damage and healing done by 2%/4%.
		-- ["MOD_SPELL_DMG"] = {
		-- {
		-- ["tab"] = 1,
		-- ["num"] = 16,
		-- ["rank"] = {
		-- 0.02, 0.04,
		-- },
		-- },
		-- },
		-- Priest: Focused Power (Rank 2) - 1,16
		--         Increases your total spell damage and healing done by 2%/4%.
		-- ["MOD_HEALING"] = {
		-- {
		-- ["tab"] = 1,
		-- ["num"] = 16,
		-- ["rank"] = {
		-- 0.02, 0.04,
		-- },
		-- },
		-- },
		-- Priest: Meditation (Rank 3) - 1,7
		--         Allows 17/33/50% of your Mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 7,
				["rank"] = {
					0.17, 0.33, 0.5,
				},
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell power by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Twisted Faith (Rank 5) - 3,26
		--         Increases your spell power by 4/8/12/16/20% of your total Spirit
		["ADD_SPELL_DMG_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			{
				["tab"] = 3,
				["num"] = 26,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell power by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Twisted Faith (Rank 5) - 3,26
		--         Increases your spell power by 4/8/12/16/20% of your total Spirit
		["ADD_HEALING_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			{
				["tab"] = 3,
				["num"] = 26,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
		},
		-- Priest: Spell Warding (Rank 5) - 2,4
		--         Reduces all spell damage taken by 2%/4%/6%/8%/10%.
		-- Priest: Dispersion - Buff
		--         Reduces all damage by 90%
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
				["value"] = -0.9,
				["buff"] = GetSpellInfo(47585),		-- ["Dispersion"],
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,17
		--         Increases your total Stamina and Spirit by 1%/2%/3%/4%/5% and increases your spell haste by 1%/2%/3%/4%/5%.
		-- Priest: Improved Power Word: Fortitude (Rank 2) - 1,5
		--         Increases your total Stamina by 2/4%.
		["MOD_STA"] = {
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			{
				["tab"] = 1,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		-- Priest: Mental Strength (Rank 5) - 1,14
		--         Increases your total Intellect by 3%/6%/9%/12%/15%.
		["MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,17
		--         Increases your total Stamina and Spirit by 1%/2%/3%/4%/5% and increases your spell haste by 1%/2%/3%/4%/5%.
		-- Priest: Spirit of Redemption - 2,13
		--         Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.
		["MOD_SPI"] = {
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			{
				["tab"] = 2,
				["num"] = 13,
				["value"] = 0.05,
			},
		},
	}
elseif addonTable.playerClass == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
		-- Rogue: Deadliness (Rank 5) - 3,18
		--        Increases your attack power by 2%/4%/6%/8%/10%.
		-- Rogue: Savage Combat (Rank 2) - 2,26
		--        Increases your total attack power by 2%/4%.
		["MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
			{
				["tab"] = 2,
				["num"] = 26,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		-- Rogue: Lightning Reflexes (Rank 5) - 2,12
		--        Increases your Dodge chance by 2/4/6% and gives you 4/7/10% melee haste.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		-- Rogue: Ghostly Strike - Buff
		--        Dodge chance increased by 15%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 12,
				["rank"] = {
					2, 4, 6,
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
		-- Rogue: Sleight of Hand (Rank 2) - 3,4
		--        Reduces the chance you are critically hit by melee and ranged attacks by 1%/2% and increases the threat reduction of your Feint ability by 10%/20%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 4,
				["rank"] = {
					-0.01, -0.02,
				},
			},
		},
		-- Rogue: Heightened Senses (Rank 2) - 3,13
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
				["num"] = 13,
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
		-- Rogue: Deadened Nerves (Rank 3) - 1,20
		--        Reduces all damage taken by 2%/4%/6%.
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
				["num"] = 20,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Rogue: Sinister Calling (Rank 5) - 3,22
		--        Increases your total Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			{
				["tab"] = 3,
				["num"] = 22,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Rogue: Endurance (Rank 2) - 2,7
		--        increases your total Stamina by 2%/4%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	}
elseif addonTable.playerClass == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
		-- Shaman: Mental Dexterity (Rank 3) - 2,15
		--         Increases your Attack Power by 33%/66%/100% of your Intellect.
		["ADD_AP_MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.33, 0.66, 1,
				},
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,25
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell power equal to 10%/20%/30% of your attack power.
		--  3.1.0: 2,25
		["ADD_SPELL_DMG_MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 25,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,25
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell power equal to 10%/20%/30% of your attack power.
		--  3.1.0: 2,25
		["ADD_HEALING_MOD_AP"] = {
			{
				["tab"] = 2,
				["num"] = 25,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Unrelenting Storm (Rank 3) - 1,13
		--         Regenerate mana equal to 4%/8%/12% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,21
		--         Increases your healing by an amount equal to 5%/10%/15% of your Intellect.
		["ADD_HEALING_MOD_INT"] = {
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
		},
		-- Shaman: Anticipation (Rank 5) - 2,10
		--         Increases your chance to dodge by an additional 1%/2%/3%
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 10,
				["rank"] = {
					1, 2, 3,
				},
			},
		},
		-- Shaman: Elemental Warding (Rank 3) - 1,4
		--         Now reduces all damage taken by 2/4/6%.
		-- Shaman: Shamanistic Rage - Buff
		--         Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 15% of your attack power. Lasts 30 sec.
		-- Shaman: Astral Shift - Buff
		--         When stunned, feared or silenced you shift into the Astral Plane reducing all damage taken by 30% for the duration of the stun, fear or silence effect.
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
				["num"] = 4,
				["rank"] = {
					-0.02, -0.04, -0.06,
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
				["value"] = -0.3,
				["buff"] = GetSpellInfo(30823),		-- ["Shamanistic Rage"],
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
				["value"] = -0.3,
				["buff"] = GetSpellInfo(51479),		-- ["Astral Shift"],
			},
		},
		-- Shaman: Toughness (Rank 5) - 2,12
		--         Increases your total stamina by 2/4/6/8/10%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 12,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Shaman: Ancestral Knowledge (Rank 5) - 2,3
		--         Increases your intellect by 2%/4%/6%/8%/10%.
		["MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
	}
elseif addonTable.playerClass == "WARLOCK" then
	StatLogic.StatModTable["WARLOCK"] = {
		-- Warlock: Metamorphosis - Buff
		--          This form increases your armor by 600%, damage by 20%, reduces the chance you'll be critically hit by melee attacks by 6% and reduces the duration of stun and snare effects by 50%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["value"] = -0.06,
				["buff"] = GetSpellInfo(47241),		-- ["Metamorphosis"],
			},
		},
		-- Warlock: Metamorphosis - Buff
		--          This form increases your armor by 600%, damage by 20%, reduces the chance you'll be critically hit by melee attacks by 6% and reduces the duration of stun and snare effects by 50%.
		["MOD_ARMOR"] = {
			{
				["value"] = 6,
				["buff"] = GetSpellInfo(47241),		-- ["Metamorphosis"],
			},
		},
		-- Warlock: Demonic Pact - 2,26
		--          Your pet's criticals apply the Demonic Pact effect to your party or raid members. Demonic Pact increases spell power by 2%/4%/6%/8%/10% of your Spell Damage for 12 sec.
		-- Warlock: Malediction (Rank 3) - 1,23
		--          Increases the damage bonus effect of your Curse of the Elements spell by an additional 3%, and increases your spell damage by 1%/2%/3%.
		--        * Does not affect char window stats
		["MOD_SPELL_DMG"] = {
			{
				["tab"] = 2,
				["num"] = 26,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(47240),		-- ["Demonic Pact"],
			},
		},
		-- Warlock: Demonic Pact - 2,26
		--          Your pet's criticals apply the Demonic Pact effect to your party or raid members. Demonic Pact increases spell power by 2%/4%/6%/8%/10% of your Spell Damage for 12 sec.
		["MOD_HEALING"] = {
			{
				["tab"] = 2,
				["num"] = 26,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(47240),		-- ["Demonic Pact"],
			},
		},
		-- Warlock: Fel Armor (Rank 4) - Buff
		--          Surrounds the caster with fel energy, increasing spell power by 50/100/150/180 plus additional spell power equal to 30% of your Spirit.
		-- Warlock: Demonic Aegis (Rank 3) - 2,11
		--          Increases the effectiveness of your Demon Armor and Fel Armor spells by 10%/20%/30%.
		-- Warlock: Glyph of Life Tap - Major Glyph
		--          When you use Life Tap, you gain 20% of your Spirit as spell power for 40 sec.
		--          Life Tap - Buff
		["ADD_SPELL_DMG_MOD_SPI"] = {
			{
				["rank"] = {
					0.3, 0.3, 0.3, 0.3, -- 4 ranks
				},
				["buff"] = GetSpellInfo(28176), -- ["Fel Armor"],
			},
			{
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					0.03, 0.06, 0.09,
				},
				["buff"] = GetSpellInfo(28176), -- ["Fel Armor"],
			},
			{
				["value"] = 0.2,
				["glyph"] = 63320,
				["buff"] = GetSpellInfo(63321), -- ["Life Tap"],
			},
		},
		-- Warlock: Fel Armor (Rank 4) - Buff
		--          Surrounds the caster with fel energy, increasing spell power by 50/100/150/180 plus additional spell power equal to 30% of your Spirit.
		-- Warlock: Demonic Aegis (Rank 3) - 2,11
		--          Increases the effectiveness of your Demon Armor and Fel Armor spells by 10%/20%/30%.
		--   3.1.0: 2,11
		["ADD_HEALING_MOD_SPI"] = {
			{
				["value"] = 0.2,
				["glyph"] = 63320,
				["buff"] = GetSpellInfo(63321), -- ["Life Tap"],
			},
		},
		-- 3.3.0 Imp stam total 233: pet base 118, player base 90, pet sta from player sta 0.75, pet kings 1.1, fel vitality 1.15
		-- /dump floor((118+floor(90*0.75))*1.1)*1.05 = 233.45 match
		-- /dump (118+floor(90*0.75))*1.1*1.05 = 224.025 wrong
		-- Warlock: Fel Vitality (Rank 3) - 2,7
		--          Increases the Stamina and Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 15% and increases your maximum health and mana by 1%/2%/3%.
		["ADD_PET_STA_MOD_STA"] = {
			-- Base
			{
				["value"] = 0.75-1,
				["condition"] = "UnitExists('pet')",
			},
			-- Blessings on pet: floor() * 1.1
			--{
			--	["value"] = 0.1, -- BoK, BoSanc
			--	["condition"] = "UnitBuff('pet', GetSpellInfo(20217)) or UnitBuff('pet', GetSpellInfo(25898)) or UnitBuff('pet', GetSpellInfo(20911)) or UnitBuff('pet', GetSpellInfo(25899))",
			--},
			-- Fel Vitality: floor() * 1.15
			{
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		["ADD_PET_INT_MOD_INT"] = {
			-- Base
			{
				["value"] = 0.3-1,
				["condition"] = "UnitExists('pet')",
			},
			-- Blessings on pet
			--{
			--	["value"] = 0.1,
			--	["condition"] = "UnitBuff('pet', GetSpellInfo(20217)) or UnitBuff('pet', GetSpellInfo(25898)) or UnitBuff('pet', GetSpellInfo(20911)) or UnitBuff('pet', GetSpellInfo(25899))",
			--},
			-- Fel Vitality
			{
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet") - WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3; its actually 0.75
		--          Increases your spell damage by an amount equal to 4/8/12% of the total of your active demon's Stamina plus Intellect.
		["ADD_SPELL_DMG_MOD_PET_STA"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet") - WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
		--          Increases your spell damage by an amount equal to 4/8/12% of the total of your active demon's Stamina plus Intellect.
		["ADD_SPELL_DMG_MOD_PET_INT"] = {
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.04, 0.08, 0.12,
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
		-- Warlock: Master Demonologist (Rank 5) - 2,16
		--          Voidwalker - Reduces physical damage taken by 2%/4%/6%/8%/10%.
		--          Felhunter - Reduces all spell damage taken by 2%/4%/6%/8%/10%.
		--          Felguard - Increases all damage done by 5%, and reduces all damage taken by 1%/2%/3%/4%/5%.
		-- Warlock: Soul Link (Rank 1) - Buff
		--          When active, 15% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter, Felguard, or enslaved demon instead.  That damage cannot be prevented. Lasts as long as the demon is active and controlled.
		["MOD_DMG_TAKEN"] = {
			-- Voidwalker
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(27490) or "").."')" -- ["Torment"]
			},
			-- Felhunter
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(27496) or "").."')" -- ["Devour Magic"]
			},
			-- Felguard
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
				["num"] = 16,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(47993) or "").."')" -- ["Anguish"]
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
				["value"] = -0.15,
				["buff"] = GetSpellInfo(25228),		-- ["Soul Link"],
			},
		},
		-- Warlock: Fel Vitality (Rank 3) - 2,7
		--          Increases the Stamina and Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health and mana by 1%/2%/3%.
		["MOD_HEALTH"] = {
			{
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Warlock: Fel Vitality (Rank 3) - 2,7
		--          Increases the Stamina and Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 15% and increases your maximum health and mana by 1%/2%/3%.
		["MOD_MANA"] = {
			{
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 4/7/10%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
		},
	}
elseif addonTable.playerClass == "WARRIOR" then
	StatLogic.StatModTable["WARRIOR"] = {
		-- Warrior: Improved Spell Reflection (Rank 2) - 3,10
		--          Reduces the chance you'll be hit by spells by 2%/4%
		["ADD_HIT_TAKEN"] = {
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 10,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Warrior: Armored to the Teeth (Rank 3) - 2,1
		--          Increases your attack power by 1/2/3 for every 108 armor value you have.
		["ADD_AP_MOD_ARMOR"] = {
			{
				["tab"] = 2,
				["num"] = 1,
				["rank"] = {
					1/108, 2/108, 3/108,
				},
			},
		},
		-- Warrior: Anticipation (Rank 5) - 3,5
		--          Increases your Dodge chance by 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			{
				["tab"] = 3,
				["num"] = 5,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Warrior: Shield Wall - Buff
		--          All damage taken reduced by 60%.
		-- Warrior: Glyph of Shield Wall - Major Glyph
		--          Reduces the cooldown on Shield Wall by 2 min, but Shield Wall now only reduces damage taken by 40%.
		-- Warrior: Defensive Stance - stance
		--          A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases threat generated.
		-- Warrior: Berserker Stance - stance
		--          An aggressive stance. Critical hit chance is increased by 3% and all damage taken is increased by 5%.
		-- Warrior: Death Wish - Buff
		--          When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%. Lasts 30 sec.
		-- Warrior: Recklessness - Buff
		--          The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.
		-- Warrior: Improved Defensive Stance (Rank 2) - 3,17
		--          While in Defensive Stance all spell damage is reduced by 3%/6%.
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
				["value"] = -0.6,
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
				["value"] = 0.2,
				["buff"] = GetSpellInfo(41196),		-- ["Shield Wall"],
				["glyph"] = 63329, -- Glyph of Shield Wall,
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
				["value"] = 0.05,
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
			-- Improved Defensive Stance
			{
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					-0.03, -0.06,
				},
			},
		},
		-- Warrior: Last Stand - Buff
		--          When activated, this ability temporarily grants you 30% of your maximum health for 20 sec.
		["MOD_HEALTH"] = {
			{
				["value"] = 0.3,
				["buff"] = GetSpellInfo(12975),		-- ["Last Stand"],
			},
		},
		-- Warrior: Toughness (Rank 5) - 3,9
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			{
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Warrior: Vitality (Rank 3) - 3,20
		--          Increases your total Strength by 2%/4%/6%, Stamina by 3/6/9% and your Expertise by 2/4/6.
		-- Warrior: Strength of Arms (Rank 2) - 1,22
		--          Increases your total Strength and Stamina by 2%/4% and your Expertise by 2/4.
		["MOD_STA"] = {
			{
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					0.03, 0.06, 0.09,
				},
			},
			{
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		-- Warrior: Vitality (Rank 3) - 3,20
		--          Increases your total Strength by 2%/4%/6%, Stamina by 3/6/9% and your Expertise by 2/4/6.
		-- Warrior: Strength of Arms (Rank 2) - 1,22
		--          Increases your total Strength and total health by 2%/4%.
		-- Warrior: Improved Berserker Stance (Rank 5) - 2,22 - Stance
		--          Increases strength by 4/8/12/16/20% while in Berserker Stance.
		["MOD_STR"] = {
			{
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06,
				},
			},
			{
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.02, 0.04,
				},
			},
			{
				["tab"] = 2,
				["num"] = 22,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
		},
		-- Warrior: Shield Mastery (Rank 2) - 3,8
		--          Increases your block value by 15%/30% and reduces the cooldown of your Shield Block ability by 10/20 sec.
		["MOD_BLOCK_VALUE"] = {
			{
				["tab"] = 3,
				["num"] = 8,
				["rank"] = {
					0.15, 0.3,
				},
			},
		},
	}
end

if addonTable.playerRace == "NightElf" then
	StatLogic.StatModTable["NightElf"] = {
		["ADD_HIT_TAKEN"] = {
			-- Night Elf : Quickness - Racial
			--             Reduces the chance that melee and ranged attackers will hit you by 2%.
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["value"] = -0.02,
				["race"] = "NightElf",
			},
		}
	}
elseif addonTable.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
		["MOD_INT"] = {
			-- Gnome: Expansive Mind - Racial
			--        Increase Intelligence by 5%.
			{
				["value"] = 0.05,
				["race"] = "Gnome",
			},
		}
	}
elseif addonTable.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
		["MOD_SPIRIT"] = {
			-- Human: The Human Spirit - Racial
			--        Increase Spirit by 3%.
			{
				["value"] = 0.03,
				["race"] = "Human",
			},
		}
	}
end

StatLogic.StatModTable["ALL"] = {
	-- ICC: Chill of the Throne
	--      Chance to dodge reduced by 20%.
	["ADD_DODGE"] = {
		{
			["value"] = -20,
			["buff"] = GetSpellInfo(69127),		-- ["Chill of the Throne"],
		},
	},
	-- Replenishment - Buff
	--   Replenishes 1% of maximum mana per 5 sec.
	-- Priest: Vampiric Touch
	--         Priest's party or raid members gain 1% of their maximum mana per 5 sec when the priest deals damage from Mind Blast.
	-- Paladin: Judgements of the Wise
	--          Your damaging Judgement spells have a 100% chance to grant the Replenishment effect to
	--          up to 10 party or raid members mana regeneration equal to 1% of their maximum mana per 5 sec for 15 sec
	-- Hunter: Hunting Party
	--         Your Arcane Shot, Explosive Shot and Steady Shot critical strikes have a 100% chance to
	--         grant up to 10 party or raid members mana regeneration equal to 1% of the maximum mana per 5 sec.
	["ADD_MANA_REG_MOD_MANA"] = {
		{
			["value"] = 0.01,
			["buff"] = GetSpellInfo(57669),		-- ["Replenishment"],
		},
	},
	-- Priest: Pain Suppression - Buff
	--         Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.
	-- Priest: Grace - Buff
	--         Reduces damage taken by 1%.
	-- Warrior: Vigilance - Buff
	--          Damage taken reduced by 3% and 10% of all threat transferred to warrior.
	-- Paladin: Blessing of Sanctuary - Buff
	--          Damage taken reduced by up to 3%, strength and stamina increased by 10%.
	-- MetaGem: Effulgent Skyflare Diamond - 41377
	--          +32 Stamina and Reduce Spell Damage Taken by 2%
	-- Paladin: Lay on Hands (Rank 1/2) - Buff
	--          Physical damage taken reduced by 10/20%.
	-- Priest: Inspiration (Rank 1/2/3) - Buff
	--         Reduces physical damage taken by 3/7/10%.
	-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
	--         Reduces physical damage taken by 3/7/10%.
	["MOD_DMG_TAKEN"] = {
		-- Pain Suppression
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
		-- Grace
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["HOLY"] = true,
			["FIRE"] = true,
			["NATURE"] = true,
			["FROST"] = true,
			["SHADOW"] = true,
			["ARCANE"] = true,
			["value"] = -0.01,
			["buff"] = GetSpellInfo(47930),		-- ["Grace"],
		},
		-- Vigilance
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["HOLY"] = true,
			["FIRE"] = true,
			["NATURE"] = true,
			["FROST"] = true,
			["SHADOW"] = true,
			["ARCANE"] = true,
			["value"] = -0.03,
			["buff"] = GetSpellInfo(50720),		-- ["Vigilance"],
		},
		-- Blessing of Sanctuary
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["HOLY"] = true,
			["FIRE"] = true,
			["NATURE"] = true,
			["FROST"] = true,
			["SHADOW"] = true,
			["ARCANE"] = true,
			["value"] = -0.03,
			["buff"] = GetSpellInfo(20911),		-- ["Blessing of Sanctuary"],
		},
		-- Greater Blessing of Sanctuary
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["HOLY"] = true,
			["FIRE"] = true,
			["NATURE"] = true,
			["FROST"] = true,
			["SHADOW"] = true,
			["ARCANE"] = true,
			["value"] = -0.03,
			["buff"] = GetSpellInfo(25899),		-- ["Greater Blessing of Sanctuary"],
		},
		-- Effulgent Skyflare Diamond
		{
			["HOLY"] = true,
			["FIRE"] = true,
			["NATURE"] = true,
			["FROST"] = true,
			["SHADOW"] = true,
			["ARCANE"] = true,
			["value"] = -0.02,
			["meta"] = 41377,
		},
		-- Lay on Hands
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["rank"] = {
				-0.1, -0.2,
			},
			["buff"] = GetSpellInfo(20236),		-- ["Lay on Hands"],
		},
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["rank"] = {
				-0.03, -0.07, -0.1,
			},
			["buff"] = GetSpellInfo(15363),		-- ["Inspiration"],
			["group"] = BuffGroup.MOD_PHYS_DMG_TAKEN,
		},
		{
			["MELEE"] = true,
			["RANGED"] = true,
			["rank"] = {
				-0.03, -0.07, -0.1,
			},
			["buff"] = GetSpellInfo(16237),		-- ["Ancestral Fortitude"],
			["group"] = BuffGroup.MOD_PHYS_DMG_TAKEN,
		},
	},
	-- MetaGem: Eternal Earthsiege Diamond - 41396
	--          +21 Defense Rating and +5% Shield Block Value
	-- MetaGem: Eternal Earthstorm Diamond - 35501
	--          +12 Defense Rating and +5% Shield Block Value
	["MOD_BLOCK_VALUE"] = {
		{
			["value"] = 0.05,
			["meta"] = 41396,
		},
		{
			["value"] = 0.05,
			["meta"] = 35501,
		},
	},
	-- Paladin: Lay on Hands (Rank 1/2) - Buff
	--          Physical damage taken reduced by 10%/20%.
	-- Priest: Inspiration (Rank 1/2/3) - Buff
	--         Reduces physical damage taken by 3/7/10%.
	-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
	--         Reduces physical damage taken by 3/7/10%.
	-- MetaGem: Austere Earthsiege Diamond - 41380
	--          +32 Stamina and 2% Increased Armor Value from Items
	["MOD_ARMOR"] = {
		{
			["value"] = 0.02,
			["meta"] = 41380,
		},
	},
	-- Hunter: Trueshot Aura - Buff
	--         Attack power increased by 10%.
	-- Death Knight: Abomination's Might - Buff
	--               Attack power increased by 5/10%.
	-- Shaman: Unleashed Rage - Buff
	--         Melee attack power increased by 4/7/10%.
	["MOD_AP"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(19506),		-- ["Trueshot Aura"],
			["group"] = BuffGroup.MOD_AP,
		},
		{
			["rank"] = {
				0.05, 0.1,
			},
			["buff"] = GetSpellInfo(53137),		-- ["Abomination's Might"],
			["group"] = BuffGroup.MOD_AP,
		},
		{
			["rank"] = {
				0.04, 0.07, 0.1,
			},
			["buff"] = GetSpellInfo(30802),		-- ["Unleashed Rage"],
			["group"] = BuffGroup.MOD_AP,
		},
	},
	-- MetaGem: Beaming Earthsiege Diamond - 41389
	--          +21 Critical Strike Rating and +2% Mana
	["MOD_MANA"] = {
		{
			["value"] = 0.02,
			["meta"] = 41389,
		},
	},
	-- Paladin: Blessing of Kings, Greater Blessing of Kings - Buff
	--          Increases stats by 10%.
	-- Paladin: Blessing of Sanctuary, Greater Blessing of Sanctuary - Buff
	--          Damage taken reduced by up to 3%, strength and stamina increased by 10%. Does not stack with Blessing of Kings.
	-- Leatherworking: Blessing of Forgotten Kings - Buff
	--                 Increases stats by 8%.
	["MOD_STR"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		-- Blessing of Sanctuary
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20911),		-- ["Blessing of Sanctuary"],
			["group"] = BuffGroup.MOD_STATS,
		},
		-- Greater Blessing of Sanctuary
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25899),		-- ["Greater Blessing of Sanctuary"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.08,
			["buff"] = GetSpellInfo(69378),		-- ["Blessing of Forgotten Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
	},
	-- Paladin: Blessing of Kings, Greater Blessing of Kings - Buff
	--          Increases stats by 10%.
	-- Leatherworking: Blessing of Forgotten Kings - Buff
	--                 Increases stats by 8%.
	["MOD_AGI"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.08,
			["buff"] = GetSpellInfo(69378),		-- ["Blessing of Forgotten Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
	},
	-- Paladin: Blessing of Kings, Greater Blessing of Kings - Buff
	--          Increases stats by 10%.
	-- Paladin: Blessing of Sanctuary, Greater Blessing of Sanctuary - Buff
	--          Damage taken reduced by up to 3%, strength and stamina increased by 10%. Does not stack with Blessing of Kings.
	-- Leatherworking: Blessing of Forgotten Kings - Buff
	--                 Increases stats by 8%.
	["MOD_STA"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		-- Blessing of Sanctuary
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20911),		-- ["Blessing of Sanctuary"],
			["group"] = BuffGroup.MOD_STATS,
		},
		-- Greater Blessing of Sanctuary
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25899),		-- ["Greater Blessing of Sanctuary"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.08,
			["buff"] = GetSpellInfo(69378),		-- ["Blessing of Forgotten Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
	},
	-- Paladin: Blessing of Kings, Greater Blessing of Kings - Buff
	--          Increases stats by 10%.
	-- Leatherworking: Blessing of Forgotten Kings - Buff
	--                 Increases stats by 8%.
	-- MetaGem: Ember Skyfire Diamond - 35503
	--          +14 Spell Power and +2% Intellect
	-- MetaGem: Ember Skyflare Diamond - 41333
	--          +25 Spell Power and +2% Intellect
	["MOD_INT"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.08,
			["buff"] = GetSpellInfo(69378),		-- ["Blessing of Forgotten Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.02,
			["meta"] = 35503,
		},
		{
			["value"] = 0.02,
			["meta"] = 41333,
		},
	},
	-- Paladin: Blessing of Kings, Greater Blessing of Kings - Buff
	--          Increases stats by 10%.
	-- Leatherworking: Blessing of Forgotten Kings - Buff
	--                 Increases stats by 8%.
	["MOD_SPI"] = {
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.1,
			["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
		{
			["value"] = 0.08,
			["buff"] = GetSpellInfo(69378),		-- ["Blessing of Forgotten Kings"],
			["group"] = BuffGroup.MOD_STATS,
		},
	},
}

--=====================================--
-- Avoidance stats diminishing returns --
--=====================================--
-- Formula reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
--[[---------------------------------
This includes
1. Dodge from Dodge Rating, Defense, Agility.
2. Parry from Parry Rating, Defense.
3. Chance to be missed from Defense.

The following is the result of hours of work gathering data from beta servers and then spending even more time running multiple regression analysis on the data.

1. DR for Dodge, Parry, Missed are calculated separately.
2. Base avoidances are not affected by DR, (ex: Dodge from base Agility)
3. Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
4. Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
5. Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
6. c and k values depend on class but does not change with level.

7. The DR formula:

1/x' = 1/c+k/x

x' is the diminished stat before converting to IEEE754.
x is the stat before diminishing returns.
c is the cap of the stat, and changes with class.
k is is a value that changes with class.
-----------------------------------]]
-- The following K, C_p, C_d are calculated by Whitetooth (hotdogee [at] gmail [dot] com)
local K = {
	[StatLogic:GetClassIdOrName("WARRIOR")]     = 0.956,
	[StatLogic:GetClassIdOrName("PALADIN")]     = 0.956,
	[StatLogic:GetClassIdOrName("HUNTER")]      = 0.988,
	[StatLogic:GetClassIdOrName("ROGUE")]       = 0.988,
	[StatLogic:GetClassIdOrName("PRIEST")]      = 0.983,
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 0.956,
	[StatLogic:GetClassIdOrName("SHAMAN")]      = 0.988,
	[StatLogic:GetClassIdOrName("MAGE")]        = 0.983,
	[StatLogic:GetClassIdOrName("WARLOCK")]     = 0.983,
	[StatLogic:GetClassIdOrName("DRUID")]       = 0.972,
}
local C_p = {
	[StatLogic:GetClassIdOrName("WARRIOR")]     = 1/0.021275,
	[StatLogic:GetClassIdOrName("PALADIN")]     = 1/0.021275,
	[StatLogic:GetClassIdOrName("HUNTER")]      = 1/0.006870,
	[StatLogic:GetClassIdOrName("ROGUE")]       = 1/0.006870,
	[StatLogic:GetClassIdOrName("PRIEST")]      = 0, --use tank stats
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 1/0.021275,
	[StatLogic:GetClassIdOrName("SHAMAN")]      = 1/0.006870,
	[StatLogic:GetClassIdOrName("MAGE")]        = 0, --use tank stats
	[StatLogic:GetClassIdOrName("WARLOCK")]     = 0, --use tank stats
	[StatLogic:GetClassIdOrName("DRUID")]       = 0, --use tank stats
}
local C_d = {
	[StatLogic:GetClassIdOrName("WARRIOR")]     = 1/0.011347,
	[StatLogic:GetClassIdOrName("PALADIN")]     = 1/0.011347,
	[StatLogic:GetClassIdOrName("HUNTER")]      = 1/0.006870,
	[StatLogic:GetClassIdOrName("ROGUE")]       = 1/0.006870,
	[StatLogic:GetClassIdOrName("PRIEST")]      = 1/0.006650,
	[StatLogic:GetClassIdOrName("DEATHKNIGHT")] = 1/0.011347,
	[StatLogic:GetClassIdOrName("SHAMAN")]      = 1/0.006870,
	[StatLogic:GetClassIdOrName("MAGE")]        = 1/0.006650,
	[StatLogic:GetClassIdOrName("WARLOCK")]     = 1/0.006650,
	[StatLogic:GetClassIdOrName("DRUID")]       = 1/0.008555,
}

-- I've done extensive tests that show the miss cap is 16% for warriors.
-- Because the only tank I have with 150 pieces of epic gear required for the tests is a warrior,
-- Until someone that has the will and gear to preform the tests for other classes, I'm going to assume the cap is the same(which most likely isn't)
local C_m = setmetatable({}, {
	__index = function()
		return 16
	end
})

function StatLogic:GetMissedChanceBeforeDR()
	local baseDefense, additionalDefense = UnitDefense("player")
	local defenseFromDefenseRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL))
	local modMissed = defenseFromDefenseRating * 0.04
	local drFreeMissed = 5 + (baseDefense + additionalDefense - defenseFromDefenseRating) * 0.04
	return modMissed, drFreeMissed
end
--[[---------------------------------
	:GetDodgeChanceBeforeDR()
-------------------------------------
Notes:
	* Calculates your current Dodge% before diminishing returns.
	* Dodge% = modDodge + drFreeDodge
	* drFreeDodge includes:
	** Base dodge
	** Dodge from base agility
	** Dodge modifier from base defense
	** Dodge modifers from talents or spells
	* modDodge includes
	** Dodge from dodge rating
	** Dodge from additional defense
	** Dodge from additional dodge
Arguments:
	None
Returns:
	; modDodge : number - The part that is affected by diminishing returns.
	; drFreeDodge : number - The part that isn't affected by diminishing returns.
Example:
	local modDodge, drFreeDodge = StatLogic:GetDodgeChanceBeforeDR()
-----------------------------------]]
local BaseDodge
function StatLogic:GetDodgeChanceBeforeDR()
	local class = StatLogic:GetClassIdOrName(addonTable.playerClass)

	-- drFreeDodge
	local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 2) -- 2 = Agility
	local baseAgi = stat - posBuff - negBuff
	local dodgePerAgi = self:GetDodgePerAgi()
	--[[
	local drFreeDodge = BaseDodge[class] + dodgePerAgi * baseAgi
		+ self:GetStatMod("ADD_DODGE") + (baseDefense - UnitLevel("player") * 5) * 0.04
	--]]
	-- modDodge
	local dodgeFromDodgeRating = self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, UnitLevel("player"))
	local dodgeFromDefenceRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL)) * 0.04
	local dodgeFromAdditionalAgi = dodgePerAgi * (effectiveStat - baseAgi)
	local modDodge = dodgeFromDodgeRating + dodgeFromDefenceRating + dodgeFromAdditionalAgi

	local drFreeDodge = GetDodgeChance() - self:GetAvoidanceAfterDR("DODGE", modDodge, class)

	return modDodge, drFreeDodge
end

--[[---------------------------------
	:GetParryChanceBeforeDR()
-------------------------------------
Notes:
	* Calculates your current Parry% before diminishing returns.
	* Parry% = modParry + drFreeParry
	* drFreeParry includes:
	** Base parry
	** Parry from base agility
	** Parry modifier from base defense
	** Parry modifers from talents or spells
	* modParry includes
	** Parry from parry rating
	** Parry from additional defense
	** Parry from additional parry
Arguments:
	None
Returns:
	; modParry : number - The part that is affected by diminishing returns.
	; drFreeParry : number - The part that isn't affected by diminishing returns.
Example:
	local modParry, drFreeParry = StatLogic:GetParryChanceBeforeDR()
-----------------------------------]]
function StatLogic:GetParryChanceBeforeDR()
	local class = StatLogic:GetClassIdOrName(addonTable.playerClass)

	-- Defense is floored
	local parryFromParryRating = self:GetEffectFromRating(GetCombatRating(CR_PARRY), CR_PARRY)
	local parryFromDefenceRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL)) * 0.04
	local modParry = parryFromParryRating + parryFromDefenceRating

	-- drFreeParry
	local drFreeParry = GetParryChance() - self:GetAvoidanceAfterDR("PARRY", modParry, class)

	return modParry, drFreeParry
end

--[[---------------------------------
	:GetAvoidanceAfterDR(avoidanceType, avoidanceBeforeDR[, class])
-------------------------------------
Notes:
	* Avoidance DR formula and k, C_p, C_d constants derived by Whitetooth (hotdogee [at] gmail [dot] com)
	* avoidanceBeforeDR is the part that is affected by diminishing returns.
	* See :GetClassIdOrName(class) for valid class values.
	* Calculates the avoidance after diminishing returns, this includes:
	*# Dodge from Dodge Rating, Defense, Agility.
	*# Parry from Parry Rating, Defense.
	*# Chance to be missed from Defense.
	* The DR formula: 1/x' = 1/c+k/x
	** x' is the diminished stat before converting to IEEE754.
	** x is the stat before diminishing returns.
	** c is the cap of the stat, and changes with class.
	** k is is a value that changes with class.
	* Formula details:
	*# DR for Dodge, Parry, Missed are calculated separately.
	*# Base avoidances are not affected by DR, (ex: Dodge from base Agility)
	*# Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
	*# Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
	*# Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
	*# c and k values depend on class but does not change with level.
	:{| class="wikitable"
	! !!k!!C_p!!1/C_p!!C_d!!1/C_d
	|-
	|Warrior||0.9560||47.003525||0.021275||88.129021||0.011347
	|-
	|Paladin||0.9560||47.003525||0.021275||88.129021||0.011347
	|-
	|Hunter||0.9880||145.560408||0.006870||145.560408||0.006870
	|-
	|Rogue||0.9880||145.560408||0.006870||145.560408||0.006870
	|-
	|Priest||0.9530||0||0||150.375940||0.006650
	|-
	|Deathknight||0.9560||47.003525||0.021275||88.129021||0.011347
	|-
	|Shaman||0.9880||145.560408||0.006870||145.560408||0.006870
	|-
	|Mage||0.9530||0||0||150.375940||0.006650
	|-
	|Warlock||0.9530||0||0||150.375940||0.006650
	|-
	|Druid||0.9720||0||0||116.890707||0.008555
	|}
Arguments:
	string - "DODGE", "PARRY", "MELEE_HIT_AVOID"(NYI)
	number - amount of avoidance before diminishing returns in percentages.
	[optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
	; avoidanceAfterDR : number - avoidance after diminishing returns in percentages.
Example:
	local modParry, drFreeParry = StatLogic:GetParryChanceBeforeDR()
	local modParryAfterDR = StatLogic:GetAvoidanceAfterDR("PARRY", modParry)
	local parry = modParryAfterDR + drFreeParry

	local modParryAfterDR = StatLogic:GetAvoidanceAfterDR("PARRY", modParry, "WARRIOR")
	local parry = modParryAfterDR + drFreeParry
-----------------------------------]]
function StatLogic:GetAvoidanceAfterDR(avoidanceType, avoidanceBeforeDR, class)
	-- argCheck for invalid input
	self:argCheck(avoidanceType, 2, "string")
	self:argCheck(avoidanceBeforeDR, 3, "number")
	self:argCheck(class, 4, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and StatLogic:GetClassIdOrName(strupper(class)) ~= nil then
		class = StatLogic:GetClassIdOrName(strupper(class))
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 10 then
		class = StatLogic:GetClassIdOrName(addonTable.playerClass)
	end

	local C = C_d
	if avoidanceType == "PARRY" then
		C = C_p
	elseif avoidanceType == "MELEE_HIT_AVOID" then
		C = C_m
	end

	return 1 / (1 / C[class] + K[class] / avoidanceBeforeDR)
end

--[[---------------------------------
	:GetAvoidanceGainAfterDR(avoidanceType, gainBeforeDR)
-------------------------------------
Notes:
	* Calculates the avoidance gain after diminishing returns with player's current stats.
Arguments:
	string - "DODGE", "PARRY", "MELEE_HIT_AVOID"(NYI)
	number - Avoidance gain before diminishing returns in percentages.
Returns:
	; gainAfterDR : number - Avoidance gain after diminishing returns in percentages.
Example:
	-- How much dodge will I gain with +30 Agi after DR?
	local gainAfterDR = StatLogic:GetAvoidanceGainAfterDR("DODGE", 30*StatLogic:GetDodgePerAgi())
	-- How much dodge will I gain with +20 Parry Rating after DR?
	local gainAfterDR = StatLogic:GetAvoidanceGainAfterDR("PARRY", StatLogic:GetEffectFromRating(20, CR_PARRY))
-----------------------------------]]
function StatLogic:GetAvoidanceGainAfterDR(avoidanceType, gainBeforeDR)
	-- argCheck for invalid input
	self:argCheck(gainBeforeDR, 2, "number")
	local class = StatLogic:GetClassIdOrName(addonTable.playerClass)

	if avoidanceType == "PARRY" then
		local modAvoidance, drFreeAvoidance = self:GetParryChanceBeforeDR()
		local newAvoidanceChance = self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) + drFreeAvoidance
		if newAvoidanceChance < 0 then newAvoidanceChance = 0 end
		return newAvoidanceChance - GetParryChance()
	elseif avoidanceType == "DODGE" then
		local modAvoidance, drFreeAvoidance = self:GetDodgeChanceBeforeDR()
		local newAvoidanceChance = self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) + drFreeAvoidance
		if newAvoidanceChance < 0 then newAvoidanceChance = 0 end -- because GetDodgeChance() is 0 when negative
		return newAvoidanceChance - GetDodgeChance()
	elseif avoidanceType == "MELEE_HIT_AVOID" then
		local modAvoidance = self:GetMissedChanceBeforeDR()
		return self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) - self:GetAvoidanceAfterDR(avoidanceType, modAvoidance)
	end
end
