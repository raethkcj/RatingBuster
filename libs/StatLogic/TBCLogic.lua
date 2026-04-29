local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

-- Level 60 rating base
StatLogic.RatingBase = {
	[StatLogic.Stats.DefenseRating] = 1.5,
	[StatLogic.Stats.DodgeRating] = 12,
	[StatLogic.Stats.ParryRating] = 15,
	[StatLogic.Stats.BlockRating] = 5,
	[StatLogic.Stats.MeleeHitRating] = 10,
	[StatLogic.Stats.RangedHitRating] = 10,
	[StatLogic.Stats.SpellHitRating] = 8,
	[StatLogic.Stats.MeleeCritRating] = 14,
	[StatLogic.Stats.RangedCritRating] = 14,
	[StatLogic.Stats.SpellCritRating] = 14,
	[StatLogic.Stats.ResilienceRating] = 25,
	[StatLogic.Stats.MeleeHasteRating] = 10,
	[StatLogic.Stats.RangedHasteRating] = 10,
	[StatLogic.Stats.SpellHasteRating] = 10,
	[StatLogic.Stats.ExpertiseRating] = 2.5,
}

-- Extracted from the client at GameTables/RegenMPPerSpt.txt via wow.tools.local
local BaseManaRegenPerSpi = {
	0.034965, 0.034191, 0.033465, 0.032526, 0.031661, 0.031076, 0.030523, 0.029994, 0.029307, 0.028661,
	0.027584, 0.026215, 0.025381, 0.024300, 0.023345, 0.022748, 0.021958, 0.021386, 0.020790, 0.020121,
	0.019733, 0.019155, 0.018819, 0.018316, 0.017936, 0.017576, 0.017201, 0.016919, 0.016581, 0.016233,
	0.015994, 0.015707, 0.015464, 0.015204, 0.014956, 0.014744, 0.014495, 0.014302, 0.014094, 0.013895,
	0.013724, 0.013522, 0.013363, 0.013175, 0.012996, 0.012853, 0.012687, 0.012539, 0.012384, 0.012233,
	0.012113, 0.011973, 0.011859, 0.011714, 0.011575, 0.011473, 0.011342, 0.011245, 0.011110, 0.010999,
	0.010700, 0.010522, 0.010290, 0.010119, 0.009968, 0.009808, 0.009651, 0.009553, 0.009445, 0.009327,
}

local NormalManaRegenPerSpi = function(level)
	local _, int = UnitStat("player", LE_UNIT_STAT_INTELLECT)
	local _, spi = UnitStat("player", LE_UNIT_STAT_SPIRIT)
	return (0.001 / spi + BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5
end

local NormalManaRegenPerInt = function(level)
	local _, int = UnitStat("player", LE_UNIT_STAT_INTELLECT)
	local _, spi = UnitStat("player", LE_UNIT_STAT_SPIRIT)
	-- Derivative of regen with respect to int
	return (spi * BaseManaRegenPerSpi[level] / (2 * (int ^ 0.5))) * 5
end

-- Extracted from gtChanceToMeleeCrit.db2 or from gametables/chancetomeleecrit.txt via wow.tools or wago.tools
addon.CritPerAgi = {
	["WARRIOR"] = {
		0.2500, 0.2381, 0.2381, 0.2273, 0.2174, 0.2083, 0.2083, 0.2000, 0.1923, 0.1923,
		0.1852, 0.1786, 0.1667, 0.1613, 0.1563, 0.1515, 0.1471, 0.1389, 0.1351, 0.1282,
		0.1282, 0.1250, 0.1190, 0.1163, 0.1111, 0.1087, 0.1064, 0.1020, 0.1000, 0.0962,
		0.0943, 0.0926, 0.0893, 0.0877, 0.0847, 0.0833, 0.0820, 0.0794, 0.0781, 0.0758,
		0.0735, 0.0725, 0.0704, 0.0694, 0.0676, 0.0667, 0.0649, 0.0633, 0.0625, 0.0610,
		0.0595, 0.0588, 0.0575, 0.0562, 0.0549, 0.0543, 0.0532, 0.0521, 0.0510, 0.0500,
		0.0469, 0.0442, 0.0418, 0.0397, 0.0377, 0.0360, 0.0344, 0.0329, 0.0315, 0.0303,
	},
	["PALADIN"] = {
		0.2174, 0.2070, 0.2070, 0.1976, 0.1976, 0.1890, 0.1890, 0.1812, 0.1812, 0.1739,
		0.1739, 0.1672, 0.1553, 0.1553, 0.1449, 0.1449, 0.1403, 0.1318, 0.1318, 0.1242,
		0.1208, 0.1208, 0.1144, 0.1115, 0.1087, 0.1060, 0.1035, 0.1011, 0.0988, 0.0945,
		0.0925, 0.0925, 0.0887, 0.0870, 0.0836, 0.0820, 0.0820, 0.0791, 0.0776, 0.0750,
		0.0737, 0.0737, 0.0713, 0.0701, 0.0679, 0.0669, 0.0659, 0.0639, 0.0630, 0.0612,
		0.0604, 0.0596, 0.0580, 0.0572, 0.0557, 0.0550, 0.0544, 0.0530, 0.0524, 0.0512,
		0.0491, 0.0483, 0.0472, 0.0456, 0.0446, 0.0437, 0.0425, 0.0416, 0.0408, 0.0400,
	},
	["HUNTER"] = {
		0.2840, 0.2834, 0.2711, 0.2530, 0.2430, 0.2337, 0.2251, 0.2171, 0.2051, 0.1984,
		0.1848, 0.1670, 0.1547, 0.1441, 0.1330, 0.1267, 0.1194, 0.1117, 0.1060, 0.0998,
		0.0962, 0.0910, 0.0872, 0.0829, 0.0797, 0.0767, 0.0734, 0.0709, 0.0680, 0.0654,
		0.0637, 0.0614, 0.0592, 0.0575, 0.0556, 0.0541, 0.0524, 0.0508, 0.0493, 0.0481,
		0.0470, 0.0457, 0.0444, 0.0433, 0.0421, 0.0413, 0.0402, 0.0391, 0.0382, 0.0373,
		0.0366, 0.0358, 0.0350, 0.0341, 0.0334, 0.0328, 0.0321, 0.0314, 0.0307, 0.0301,
		0.0297, 0.0290, 0.0284, 0.0279, 0.0273, 0.0270, 0.0264, 0.0259, 0.0254, 0.0250,
	},
	["ROGUE"] = {
		0.4476, 0.4290, 0.4118, 0.3813, 0.3677, 0.3550, 0.3321, 0.3217, 0.3120, 0.2941,
		0.2640, 0.2394, 0.2145, 0.1980, 0.1775, 0.1660, 0.1560, 0.1450, 0.1355, 0.1271,
		0.1197, 0.1144, 0.1084, 0.1040, 0.0980, 0.0936, 0.0903, 0.0865, 0.0830, 0.0792,
		0.0768, 0.0741, 0.0715, 0.0691, 0.0664, 0.0643, 0.0628, 0.0609, 0.0592, 0.0572,
		0.0556, 0.0542, 0.0528, 0.0512, 0.0497, 0.0486, 0.0474, 0.0464, 0.0454, 0.0440,
		0.0431, 0.0422, 0.0412, 0.0404, 0.0394, 0.0386, 0.0378, 0.0370, 0.0364, 0.0355,
		0.0334, 0.0322, 0.0307, 0.0296, 0.0286, 0.0276, 0.0268, 0.0262, 0.0256, 0.0250,
	},
	["PRIEST"] = {
		0.0909, 0.0909, 0.0909, 0.0865, 0.0865, 0.0865, 0.0865, 0.0826, 0.0826, 0.0826,
		0.0826, 0.0790, 0.0790, 0.0790, 0.0790, 0.0757, 0.0757, 0.0757, 0.0727, 0.0727,
		0.0727, 0.0727, 0.0699, 0.0699, 0.0699, 0.0673, 0.0673, 0.0673, 0.0649, 0.0649,
		0.0649, 0.0627, 0.0627, 0.0627, 0.0606, 0.0606, 0.0606, 0.0586, 0.0586, 0.0586,
		0.0568, 0.0568, 0.0551, 0.0551, 0.0551, 0.0534, 0.0534, 0.0519, 0.0519, 0.0519,
		0.0505, 0.0505, 0.0491, 0.0491, 0.0478, 0.0478, 0.0466, 0.0466, 0.0454, 0.0454,
		0.0443, 0.0444, 0.0441, 0.0433, 0.0426, 0.0419, 0.0414, 0.0412, 0.0410, 0.0400,
	},
	["SHAMAN"] = {
		0.1663, 0.1663, 0.1583, 0.1583, 0.1511, 0.1511, 0.1511, 0.1446, 0.1446, 0.1385,
		0.1385, 0.1330, 0.1330, 0.1279, 0.1231, 0.1188, 0.1188, 0.1147, 0.1147, 0.1073,
		0.1073, 0.1039, 0.1039, 0.1008, 0.0978, 0.0950, 0.0950, 0.0924, 0.0924, 0.0875,
		0.0875, 0.0853, 0.0831, 0.0831, 0.0792, 0.0773, 0.0773, 0.0756, 0.0756, 0.0723,
		0.0707, 0.0707, 0.0693, 0.0679, 0.0665, 0.0652, 0.0639, 0.0627, 0.0627, 0.0605,
		0.0594, 0.0583, 0.0583, 0.0573, 0.0554, 0.0545, 0.0536, 0.0536, 0.0528, 0.0512,
		0.0496, 0.0486, 0.0470, 0.0456, 0.0449, 0.0437, 0.0427, 0.0417, 0.0408, 0.0400,
	},
	["MAGE"] = {
		0.0771, 0.0771, 0.0771, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0701,
		0.0701, 0.0701, 0.0701, 0.0701, 0.0671, 0.0671, 0.0671, 0.0671, 0.0671, 0.0643,
		0.0643, 0.0643, 0.0643, 0.0617, 0.0617, 0.0617, 0.0617, 0.0617, 0.0593, 0.0593,
		0.0593, 0.0593, 0.0571, 0.0571, 0.0571, 0.0551, 0.0551, 0.0551, 0.0551, 0.0532,
		0.0532, 0.0532, 0.0532, 0.0514, 0.0514, 0.0514, 0.0498, 0.0498, 0.0498, 0.0482,
		0.0482, 0.0482, 0.0467, 0.0467, 0.0467, 0.0454, 0.0454, 0.0454, 0.0441, 0.0441,
		0.0435, 0.0432, 0.0424, 0.0423, 0.0422, 0.0411, 0.0412, 0.0408, 0.0404, 0.0400,
	},
	["WARLOCK"] = {
		0.1500, 0.1500, 0.1429, 0.1429, 0.1429, 0.1364, 0.1364, 0.1364, 0.1304, 0.1304,
		0.1250, 0.1250, 0.1250, 0.1200, 0.1154, 0.1111, 0.1111, 0.1111, 0.1071, 0.1034,
		0.1000, 0.1000, 0.0968, 0.0968, 0.0909, 0.0909, 0.0909, 0.0882, 0.0882, 0.0833,
		0.0833, 0.0811, 0.0811, 0.0789, 0.0769, 0.0750, 0.0732, 0.0732, 0.0714, 0.0698,
		0.0682, 0.0682, 0.0667, 0.0667, 0.0638, 0.0625, 0.0625, 0.0612, 0.0600, 0.0588,
		0.0577, 0.0577, 0.0566, 0.0556, 0.0545, 0.0536, 0.0526, 0.0517, 0.0517, 0.0500,
		0.0484, 0.0481, 0.0470, 0.0455, 0.0448, 0.0435, 0.0436, 0.0424, 0.0414, 0.0405,
	},
	["DRUID"] = {
		0.2020, 0.2020, 0.1923, 0.1923, 0.1836, 0.1836, 0.1756, 0.1756, 0.1683, 0.1553,
		0.1496, 0.1496, 0.1443, 0.1443, 0.1346, 0.1346, 0.1303, 0.1262, 0.1262, 0.1122,
		0.1122, 0.1092, 0.1063, 0.1063, 0.1010, 0.1010, 0.0985, 0.0962, 0.0962, 0.0878,
		0.0859, 0.0859, 0.0841, 0.0824, 0.0808, 0.0792, 0.0777, 0.0777, 0.0762, 0.0709,
		0.0696, 0.0696, 0.0685, 0.0673, 0.0651, 0.0641, 0.0641, 0.0631, 0.0621, 0.0585,
		0.0577, 0.0569, 0.0561, 0.0561, 0.0546, 0.0539, 0.0531, 0.0525, 0.0518, 0.0493,
		0.0478, 0.0472, 0.0456, 0.0447, 0.0438, 0.0430, 0.0424, 0.0412, 0.0406, 0.0400,
	},
}

-- Extracted from gtChanceToSpellCrit.db2 or from gametables/chancetospellcrit.txt via wow.tools or wago.tools
addon.SpellCritPerInt = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = {
		0.0832, 0.0793, 0.0793, 0.0757, 0.0757, 0.0724, 0.0694, 0.0694, 0.0666, 0.0666,
		0.0640, 0.0616, 0.0594, 0.0574, 0.0537, 0.0537, 0.0520, 0.0490, 0.0490, 0.0462,
		0.0450, 0.0438, 0.0427, 0.0416, 0.0396, 0.0387, 0.0387, 0.0370, 0.0362, 0.0347,
		0.0340, 0.0333, 0.0326, 0.0320, 0.0308, 0.0303, 0.0297, 0.0287, 0.0282, 0.0273,
		0.0268, 0.0264, 0.0256, 0.0256, 0.0248, 0.0245, 0.0238, 0.0231, 0.0228, 0.0222,
		0.0219, 0.0216, 0.0211, 0.0208, 0.0203, 0.0201, 0.0198, 0.0191, 0.0189, 0.0185,
		0.0157, 0.0153, 0.0148, 0.0143, 0.0140, 0.0136, 0.0133, 0.0131, 0.0128, 0.0125,
	},
	["HUNTER"] = {
		0.0699, 0.0666, 0.0666, 0.0635, 0.0635, 0.0608, 0.0608, 0.0583, 0.0583, 0.0559,
		0.0559, 0.0538, 0.0499, 0.0499, 0.0466, 0.0466, 0.0451, 0.0424, 0.0424, 0.0399,
		0.0388, 0.0388, 0.0368, 0.0358, 0.0350, 0.0341, 0.0333, 0.0325, 0.0318, 0.0304,
		0.0297, 0.0297, 0.0285, 0.0280, 0.0269, 0.0264, 0.0264, 0.0254, 0.0250, 0.0241,
		0.0237, 0.0237, 0.0229, 0.0225, 0.0218, 0.0215, 0.0212, 0.0206, 0.0203, 0.0197,
		0.0194, 0.0192, 0.0186, 0.0184, 0.0179, 0.0177, 0.0175, 0.0170, 0.0168, 0.0164,
		0.0157, 0.0154, 0.0150, 0.0144, 0.0141, 0.0137, 0.0133, 0.0130, 0.0128, 0.0125,
	},
	["ROGUE"] = addon.zero,
	["PRIEST"] = {
		0.1710, 0.1636, 0.1568, 0.1505, 0.1394, 0.1344, 0.1297, 0.1254, 0.1214, 0.1140,
		0.1045, 0.0941, 0.0875, 0.0784, 0.0724, 0.0684, 0.0627, 0.0597, 0.0562, 0.0523,
		0.0502, 0.0470, 0.0453, 0.0428, 0.0409, 0.0392, 0.0376, 0.0362, 0.0348, 0.0333,
		0.0322, 0.0311, 0.0301, 0.0289, 0.0281, 0.0273, 0.0263, 0.0256, 0.0249, 0.0241,
		0.0235, 0.0228, 0.0223, 0.0216, 0.0210, 0.0206, 0.0200, 0.0196, 0.0191, 0.0186,
		0.0183, 0.0178, 0.0175, 0.0171, 0.0166, 0.0164, 0.0160, 0.0157, 0.0154, 0.0151,
		0.0148, 0.0145, 0.0143, 0.0139, 0.0137, 0.0134, 0.0132, 0.0130, 0.0127, 0.0125,
	},
	["SHAMAN"] = {
		0.1333, 0.1272, 0.1217, 0.1217, 0.1166, 0.1120, 0.1077, 0.1037, 0.1000, 0.1000,
		0.0933, 0.0875, 0.0800, 0.0756, 0.0700, 0.0666, 0.0636, 0.0596, 0.0571, 0.0538,
		0.0518, 0.0500, 0.0474, 0.0459, 0.0437, 0.0424, 0.0412, 0.0394, 0.0383, 0.0368,
		0.0354, 0.0346, 0.0333, 0.0325, 0.0314, 0.0304, 0.0298, 0.0289, 0.0283, 0.0272,
		0.0267, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235, 0.0231, 0.0226, 0.0220, 0.0215,
		0.0210, 0.0207, 0.0201, 0.0199, 0.0193, 0.0190, 0.0187, 0.0182, 0.0179, 0.0175,
		0.0164, 0.0159, 0.0152, 0.0147, 0.0142, 0.0138, 0.0134, 0.0131, 0.0128, 0.0125,
	},
	["MAGE"] = {
		0.1637, 0.1574, 0.1516, 0.1411, 0.1364, 0.1320, 0.1279, 0.1240, 0.1169, 0.1137,
		0.1049, 0.0930, 0.0871, 0.0731, 0.0671, 0.0639, 0.0602, 0.0568, 0.0538, 0.0505,
		0.0487, 0.0460, 0.0445, 0.0422, 0.0405, 0.0390, 0.0372, 0.0338, 0.0325, 0.0312,
		0.0305, 0.0294, 0.0286, 0.0278, 0.0269, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235,
		0.0230, 0.0215, 0.0211, 0.0206, 0.0201, 0.0197, 0.0192, 0.0188, 0.0184, 0.0179,
		0.0176, 0.0173, 0.0170, 0.0166, 0.0162, 0.0154, 0.0151, 0.0149, 0.0146, 0.0143,
		0.0143, 0.0143, 0.0143, 0.0142, 0.0142, 0.0138, 0.0133, 0.0131, 0.0128, 0.0125,
	},
	["WARLOCK"] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, 0.0825, 0.0767, 0.0717, 0.0688, 0.0635, 0.0600, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, 0.0446, 0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		0.0256, 0.0248, 0.0243, 0.0236, 0.0229, 0.0224, 0.0220, 0.0214, 0.0209, 0.0204,
		0.0200, 0.0195, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0172, 0.0168, 0.0165,
		0.0159, 0.0154, 0.0148, 0.0143, 0.0138, 0.0135, 0.0130, 0.0127, 0.0125, 0.0122,
	},
	["DRUID"] = {
		0.1431, 0.1369, 0.1312, 0.1259, 0.1211, 0.1166, 0.1124, 0.1124, 0.1086, 0.0984,
		0.0926, 0.0851, 0.0807, 0.0750, 0.0684, 0.0656, 0.0617, 0.0594, 0.0562, 0.0516,
		0.0500, 0.0477, 0.0463, 0.0437, 0.0420, 0.0409, 0.0394, 0.0384, 0.0366, 0.0346,
		0.0339, 0.0325, 0.0318, 0.0309, 0.0297, 0.0292, 0.0284, 0.0276, 0.0269, 0.0256,
		0.0252, 0.0244, 0.0240, 0.0233, 0.0228, 0.0223, 0.0219, 0.0214, 0.0209, 0.0202,
		0.0198, 0.0193, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0173, 0.0169, 0.0164,
		0.0162, 0.0157, 0.0150, 0.0146, 0.0142, 0.0137, 0.0133, 0.0131, 0.0128, 0.0125,
	},
}

local DodgePerCrit = {
	["WARRIOR"]     = 0.848,
	["PALADIN"]     = 1.000,
	["HUNTER"]      = 1.600,
	["ROGUE"]       = 2.000,
	["PRIEST"]      = 1.000,
	["SHAMAN"]      = 1.000,
	["MAGE"]        = 1.000,
	["WARLOCK"]     = 0.988,
	["DRUID"]       = 1.700,
}

-- These are likely all static conversions and can use DodgePerCrit
-- without any hardcoded values.
-- TODO Confirm DodgePerCrit remains accurate from 61-70; if so,
-- delete the following class-specific tables, leaving the metatable.
addon.DodgePerAgi = setmetatable({
	["WARRIOR"] = {
		[1]  = 0.2121,
		[60] = 0.0424,
	},
	["PALADIN"] = {
		[1]  = 0.2174,
		[60] = 0.0512,
	},
	["HUNTER"] = {
		[1]  = 0.4543,
		[60] = 0.0482,
	},
	["ROGUE"] = {
		[1]  = 0.8952,
		[60] = 0.0710,
	},
	["PRIEST"] = {
		[1]  = 0.0909,
		[60] = 0.0454,
	},
	["SHAMAN"] = {
		[1]  = 0.1663,
		[60] = 0.0512,
	},
	["MAGE"] = {
		[1]  = 0.0771,
		[60] = 0.0441,
	},
	["WARLOCK"] = {
		[1]  = 0.1483,
		[60] = 0.0494,
	},
	["DRUID"] = {
		[1]  = 0.3436,
		[60] = 0.0838,
	},
}, {
	__index = function (t, class)
		t[class] = setmetatable({}, {__index = function(classTable, level)
			classTable[level] = DodgePerCrit[class] * addon.CritPerAgi[class][level]
			return classTable[level]
		end })
		return t[class]
	end
})

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		["ADD_AP_MOD_FERAL_ATTACK_POWER"] = {
			-- Buff: Cat Form
			{
				["value"] = 1,
				["aura"] = 768,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Buff: Bear Form
			{
				["value"] = 1,
				["aura"] = 5487,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Buff: Dire Bear Form
			{
				["value"] = 1,
				["aura"] = 9634,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Buff: Moonkin Form
			{
				["value"] = 1,
				["aura"] = 24858,
				["group"] = addon.ExclusiveGroup.Feral,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Buff: Cat Form
			{
				["value"] = 1,
				["aura"] = 768,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.0625 * 5,
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Lunar Guidance
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		["ADD_HEALING_MOD_INT"] = {
			-- Talent: Lunar Guidance
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		["ADD_HEALING_MOD_AGI"] = {
			-- Talent: Nurturing Instinct
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.5, 1,
				},
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Intensity
			{
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_GENERIC_MANA_REGEN_MOD_INT"] = {
			-- Talent: Dreamstate
			{
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.04, 0.07, 0.10,
				},
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = -1.8720,
			},
			-- Talent: Feral Swiftness (Cat Form)
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["aura"] = 32356,
			},
			-- Talent: Feral Swiftness (Bear Form)
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["aura"] = 32357,
			},
			-- Talent: Feral Swiftness (Dire Bear Form)
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["aura"] = 9634,
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Thick Hide
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
			-- Buff: Bear Form
			{
				["value"] = 1.8,
				["aura"] = 32357,
			},
			-- Buff: Dire Bear Form
			{
				["value"] = 4,
				["aura"] = 9634,
			},
			-- Buff: Moonkin Form
			{
				["value"] = 4,
				["aura"] = 24858,
			},
		},
		["MOD_STA"] = {
			-- Talent: Heart of the Wild (Bear Form)
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["aura"] = 32357,
			},
			-- Talent: Heart of the Wild (Dire Bear Form)
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["aura"] = 9634,
			},
			-- Talent: Survival of the Fittest
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			-- Buff: Bear Form
			{
				["value"] = 0.25,
				["aura"] = 32357,
			},
			-- Buff: Dire Bear Form
			{
				["value"] = 0.25,
				["aura"] = 9634,
			},
		},
		["MOD_STR"] = {
			-- Talent: Survival of the Fittest
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		["MOD_AP"] = {
			-- Talent: Heart of the Wild (Cat Form)
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["aura"] = 32356,
			},
		},
		["MOD_AGI"] = {
			-- Talent: Survival of the Fittest
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Heart of the Wild
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
			-- Talent: Survival of the Fittest
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		["MOD_SPI"] = {
			-- Talent: Living Spirit
			{
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
			-- Talent: Survival of the Fittest
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
	}
elseif addon.class == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
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
				["value"] = 1,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.125 * 5,
			},
		},
		-- Buff: Aspect of the Viper
		-- TODO: Gronnstalker's Armor, (2) Set: Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
		-- 2.2.0: Aspect of the Viper: This ability has received a slight redesign. The
		-- amount of mana regained will increase as the Hunters percentage of
		-- mana remaining decreases. At about 60% mana, it is equivalent to the
		-- previous version of Aspect of the Viper. Below that margin, it is
		-- better (up to twice as much mana as the old version); while above
		-- that margin, it will be less effective. The mana regained never drops
		-- below 10% of intellect every 5 sec. or goes above 50% of intellect
		-- every 5 sec.
		["ADD_GENERIC_MANA_REGEN_MOD_INT"] = {
			{
				["value"] = 0.25,
				["aura"] = 34074,			-- ["Aspect of the Viper"],
			},
		},
		["ADD_RANGED_AP_MOD_INT"] = {
			-- Talent: Careful Aim
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.15, 0.30, 0.45,
				},
			},
		},
		["MOD_AP"] = {
			-- Talent: Survival Instincts
			{
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		["MOD_RANGED_AP"] = {
			-- Talent: Master Marksman
			{
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
			-- Talent: Survival Instincts
			{
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = -5.4500,
			},
			-- Talent: Catlike Reflexes
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					1, 2, 3,
				},
			},
			-- Buff: Aspect of the Monkey
			{
				["value"] = 8,
				["aura"] = 13163,
			},
			-- Talent: Improved Aspect of the Monkey
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					2, 4, 6,
				},
				["aura"] = 13163,
			},
			-- Buff: Deterrence
			{
				["value"] = 25,
				["aura"] = 31567,
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Thick Hide
			{
				["tab"] = 1,
				["num"] = 5,
				["rank"] = {
					0.04, 0.07, 0.1,
				},
			},
		},
		["MOD_HEALTH"] = {
			-- Talent: Survivalist
			{
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
			-- Talent: Endurance Training
			{
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		["MOD_AGI"] = {
			-- Talent: Combat Experience
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.01, 0.02,
				},
			},
			-- Talent: Lightning Reflexes
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Combat Experience
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.03, 0.06,
				},
			},
		},
	}
elseif addon.class == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 3.4575,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.041667 * 5,
			},
		},
		-- Mage: Arcane Fortitude - 1,9
		--       Increases your armor by an amount equal to 50% of your Intellect.
		-- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
		["ADD_BONUS_ARMOR_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					1,
				},
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Arcane Meditation
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
			-- Buff: Mage Armor
			{
				["value"] = 0.3,
				["aura"] = 6117,
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Mind Mastery
			{
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Talent: Arcane Mind
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
elseif addon.class == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.6520,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.125 * 5,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = BLOCK_PER_STRENGTH,
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Holy Guidance
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		["ADD_HEALING_MOD_INT"] = {
			-- Talent: Holy Guidance
			{
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Toughness
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_STR"] = {
			-- Talent: Divine Strength
			{
				["tab"] = 1,
				["num"] = 1,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Sacred Duty
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.03, 0.06
				},
			},
			-- Talent: Combat Expertise
			{
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Divine Intellect
			{
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_BLOCK_VALUE"] = {
			-- Talent: Shield Specialization
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	}
elseif addon.class == "PRIEST" then
	StatLogic.StatModTable["PRIEST"] = {
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 3.1830,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.041667 * 5,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Meditation
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_SPELL_DMG_MOD_SPI"] = {
			-- Talent: Spiritual Guidance
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			-- Talent: Improved Divine Spirit
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["aura"] = 39234,		-- ["Divine Spirit"],
			},
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["aura"] = 32999,		-- ["Prayer of Spirit"],
			},
		},
		["ADD_HEALING_MOD_SPI"] = {
			-- Talent: Spiritual Guidance
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			-- Talent: Improved Divine Spirit (Divine Spirit)
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["aura"] = 39234,
			},
			-- Talent: Improved Divine Spirit (Prayer of Spirit)
			{
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["aura"] = 32999,
			},
		},
		["MOD_MANA"] = {
			-- Talent: Mental Strength
			{
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Enlightenment
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Enlightenment
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		["MOD_SPI"] = {
			-- Talent: Enlightenment
			{
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			-- Talent: Spirit of Redemption
			{
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					0.05,
				},
			},
		},
	}
elseif addon.class == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
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
				["value"] = 1,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.333333 * 5,
			},
		},
		["MOD_AP"] = {
			-- Talent: Deadliness
			{
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = -0.5900,
			},
			-- Talent: Lightning Reflexes
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			-- Buff: Evasion
			{
				["value"] = 50,
				["aura"] = 5277,
			},
			-- Buff: Ghostly Strike
			{
				["value"] = 15,
				["aura"] = 14278,
			},
		},
		["MOD_AGI"] = {
			-- Talent: Vitality
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02,
				},
			},
			-- Talent: Sinister Calling
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Vitality
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		[StatLogic.Stats.MeleeCrit] = {
			-- Talent: Dagger Specialization
			{
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Dagger] = true,
				},
			},
			-- Talent: Fist Weapon Specialization
			{
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Unarmed] = true,
				},
			},
		},
	}
elseif addon.class == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.071429 * 5,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = BLOCK_PER_STRENGTH,
			},
		},
		["ADD_SPELL_DMG_MOD_AP"] = {
			-- Talent: Mental Quickness
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_HEALING_MOD_AP"] = {
			-- Talent: Mental Quickness
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_GENERIC_MANA_REGEN_MOD_INT"] = {
			-- Talent: Unrelenting Storm
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Nature's Blessing
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_HEALING_MOD_INT"] = {
			-- Talent: Nature's Blessing
			{
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 1.6750,
			},
			-- Talent: Anticipation
			{
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Toughness
			{
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_MANA"] = {
			-- Talent: Ancestral Knowledge
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
elseif addon.class == "WARLOCK" then
	StatLogic.StatModTable["WARLOCK"] = {
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 1,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 2.0350,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_INT"] = {
			{
				["regen"] = NormalManaRegenPerInt,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.045455 * 5,
			},
		},
		["ADD_PET_STA_MOD_STA"] = {
			-- Base
			{
				["value"] = 0.75,
				["pet"] = true,
			},
		},
		["MOD_PET_STA"] = {
			-- Talent: Fel Stamina
			{
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["pet"] = true,
			},
		},
		["ADD_SPELL_DMG_MOD_PET_STA"] = {
			-- Talent: Demonic Knowledge
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
				["pet"] = true,
			},
		},
		["ADD_PET_INT_MOD_INT"] = {
			-- Base
			{
				["value"] = 0.3,
				["pet"] = true,
			},
		},
		["MOD_PET_INT"] = {
			-- Talent: Fel Intellect
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["pet"] = true,
			},
		},
		["ADD_SPELL_DMG_MOD_PET_INT"] = {
			-- Talent: Demonic Knowledge
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.04, 0.08, 0.12,
				},
				["pet"] = true,
			},
		},
		["MOD_HEALTH"] = {
			-- Talent: Fel Stamina
			{
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		["MOD_MANA"] = {
			-- Talent: Fel Intellect
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Demonic Embrace
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["MOD_SPI"] = {
			-- Talent: Demonic Embrace
			{
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
	}
elseif addon.class == "WARRIOR" then
	StatLogic.StatModTable["WARRIOR"] = {
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
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.7580,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.5 * 5,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = BLOCK_PER_STRENGTH,
			},
		},
		["MOD_AP"] = {
			-- Talent: Improved Berserker Stance
			{
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Toughness
			{
				["tab"] = 3,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Vitality
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		["MOD_STR"] = {
			-- Talent: Vitality
			{
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		["MOD_BLOCK_VALUE"] = {
			-- Talent: Shield Mastery
			{
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		["MOD_HEALTH"] = {
			-- Buff: Last Stand
			{
				["tab"] = 3,
				["num"] = 6,
				["value"] = 0.30,
				["aura"] = 12976,
			},
		},
		[StatLogic.Stats.MeleeCrit] = {
			-- Talent: Poleaxe Specialization
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Axe1H] = true,
					[Enum.ItemWeaponSubclass.Axe2H] = true,
					[Enum.ItemWeaponSubclass.Polearm] = true,
				},
			},
		},
	}
end

if addon.playerRace == "Dwarf" then
	StatLogic.StatModTable["Dwarf"] = {
		[StatLogic.Stats.RangedCrit] = {
			-- Passive: Gun Specialization
			{
				["value"] = 1,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Guns] = true,
				}
			}
		},
	}
elseif addon.playerRace == "NightElf" then
	StatLogic.StatModTable["NightElf"] = {
		["ADD_DODGE"] = {
			-- Passive: Quickness
			{
				["value"] = 1,
			},
		},
	}
elseif addon.playerRace == "Tauren" then
	StatLogic.StatModTable["Tauren"] = {
		["MOD_HEALTH"] = {
			-- Passive: Endurance
			{
				["value"] = 0.05,
			},
		},
	}
elseif addon.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
		["MOD_INT"] = {
			-- Passive: Expansive Mind
			{
				["value"] = 0.05,
			},
		},
	}
elseif addon.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
		["MOD_SPI"] = {
			-- Passive: The Human Spirit
			{
				["value"] = 0.1,
			},
		},
		[StatLogic.Stats.Expertise] = {
			-- Passive: Mace Specialization
			-- Passive: Sword Specialization
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Mace1H] = true,
					[Enum.ItemWeaponSubclass.Mace2H] = true,
					[Enum.ItemWeaponSubclass.Sword1H] = true,
					[Enum.ItemWeaponSubclass.Sword2H] = true,
				}
			}
		},
	}
elseif addon.playerRace == "Orc" then
	StatLogic.StatModTable["Orc"] = {
		[StatLogic.Stats.Expertise] = {
			-- Passive: Axe Specialization
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Axe1H] = true,
					[Enum.ItemWeaponSubclass.Axe2H] = true,
				}
			}
		},
	}
elseif addon.playerRace == "Troll" then
	StatLogic.StatModTable["Troll"] = {
		["MOD_NORMAL_HEALTH_REG"] = {
			-- Passive: Regeneration
			{
				["value"] = 0.1,
			},
		},
		["ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG"] = {
			-- Passive: Regeneration
			{
				["value"] = 0.1,
				["spellid"] = 20555,
			},
		},
		[StatLogic.Stats.RangedCrit] = {
			-- Passive: Bow Specialization
			-- Passive: Throwing Specialization
			{
				["value"] = 1,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Bows] = true,
					[Enum.ItemWeaponSubclass.Thrown] = true,
				}
			}
		},
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
	["ADD_HEALTH_MOD_STA"] = {
		{
			["value"] = 10,
		},
	},
	["ADD_MANA_MOD_INT"] = {
		{
			["value"] = 15,
		},
	},
	["ADD_BONUS_ARMOR_MOD_AGI"] = {
		{
			["value"] = ARMOR_PER_AGILITY,
		},
	},
	["MOD_ARMOR"] = {
		-- Buff: Lay on Hands
		{
			["rank"] = {
				0.15, 0.30,
			},
			["aura"] = 27154,
		},
		-- Buff: Inspiration
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["aura"] = 15363,
			["group"] = addon.ExclusiveGroup.Armor,
		},
		-- Buff: Ancestral Fortitude
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["aura"] = 16237,
			["group"] = addon.ExclusiveGroup.Armor,
		},
	},
	["MOD_STR"] = {
		-- Buff: Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Buff: Greater Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
	},
	["MOD_AGI"] = {
		-- Buff: Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Buff: Greater Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
	},
	["MOD_STA"] = {
		-- Buff: Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Buff: Greater Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
	},
	["MOD_INT"] = {
		-- Buff: Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Buff: Greater Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Meta: Ember Skyfire Diamond
		{
			["meta"] = 35503,
			["value"] = 0.02,
		},
	},
	["MOD_SPI"] = {
		-- Buff: Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
		-- Buff: Greater Blessing of Kings
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.ExclusiveGroup.AllStats,
		},
	},
	["ADD_HEALING_MOD_INT"] = {
		-- Set: Whitemend Wisdom
		{
			["set"] = 571,
			["pieces"] = 2,
			["value"] = 0.1,
		}
	},
	["ADD_SPELL_DMG_MOD_INT"] = {
		-- Set: Wrath of Spellfire
		{
			["set"] = 552,
			["pieces"] = 3,
			["value"] = 0.07,
		},
	},
	["ADD_MANA_REGEN_NOT_CASTING_MOD_NORMAL_MANA_REGEN"] = {
		-- Base
		{
			["value"] = 1.0,
		},
	},
	["ADD_MANA_REGEN_NOT_CASTING_MOD_GENERIC_MANA_REGEN"] = {
		-- Base
		{
			["value"] = 1.0,
		},
	},
	["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
		-- Set: Primal Mooncloth
		{
			["set"] = 554,
			["pieces"] = 3,
			["value"] = 0.05,
		},
		-- Buff: Aura of the Blue Dragon
		{
			["aura"] = 23684,
			["value"] = 1.00,
		},
	},
	["ADD_DODGE_REDUCTION_MOD_EXPERTISE"] = {
		-- Base
		{
			["value"] = 0.25,
		}
	},
	["ADD_PARRY_REDUCTION_MOD_EXPERTISE"] = {
		-- Base
		{
			["value"] = 0.25,
		}
	},
	["ADD_BLOCK_CHANCE_MOD_DEFENSE"] = {
		-- Passive: Block
		{
			["known"] = 107,
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_CRIT_AVOIDANCE_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_DODGE_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_MISS_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_PARRY_MOD_DEFENSE"] = {
		-- Passive: Parry
		{
			["known"] = 3127,
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		},
		-- Passive: Parry (Shaman)
		{
			["known"] = 18848,
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		},
	},
	["ADD_CRIT_AVOIDANCE_MOD_RESILIENCE"] = {
		-- Base
		{
			["value"] = 1,
		},
	},
	["ADD_CRIT_DAMAGE_REDUCTION_MOD_RESILIENCE"] = {
		-- Base
		{
			["value"] = -2,
		},
	},
}
