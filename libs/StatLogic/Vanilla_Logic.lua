local addonName, addonTable = ...
local StatLogic = LibStub:GetLibrary(addonName)

StatLogic.GenericStatMap = {}

--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit for any class.
-- Args
	spi
			number - spirit
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[mp5nc]
		number - mana regen per 5 seconds when out of combat
	[statid]
		string - "MANA_REG_NOT_CASTING"
-- Remarks
	Player level does not effect mana regen per spirit.
-- Examples
	StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	StatLogic:GetNormalManaRegenFromSpi(10)
	StatLogic:GetNormalManaRegenFromSpi(10, "MAGE")
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local NormalManaRegenPerSpi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = 0,
	[StatLogic:GetClassIdOrName("PALADIN")] = 0.1,
	[StatLogic:GetClassIdOrName("HUNTER")] = 0.1,
	[StatLogic:GetClassIdOrName("ROGUE")] = 0,
	[StatLogic:GetClassIdOrName("PRIEST")] = 0.125,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 0.1,
	[StatLogic:GetClassIdOrName("MAGE")] = 0.125,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 0.1,
	[StatLogic:GetClassIdOrName("DRUID")] = 0.1125,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and StatLogic:GetClassIdOrName(strupper(class)) ~= nil then
		class = StatLogic:GetClassIdOrName(strupper(class))
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = StatLogic:GetClassIdOrName(addonTable.playerClass)
	end
	-- Calculate
	return spi * NormalManaRegenPerSpi[class] * 5, "MANA_REG_NOT_CASTING"
end

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
-- TODO: These are currently TBC values
addonTable.CritPerAgi = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = {
		0.2500, 0.2381, 0.2381, 0.2273, 0.2174, 0.2083, 0.2083, 0.2000, 0.1923, 0.1923,
		0.1852, 0.1786, 0.1667, 0.1613, 0.1563, 0.1515, 0.1471, 0.1389, 0.1351, 0.1282,
		0.1282, 0.1250, 0.1190, 0.1163, 0.1111, 0.1087, 0.1064, 0.1020, 0.1000, 0.0962,
		0.0943, 0.0926, 0.0893, 0.0877, 0.0847, 0.0833, 0.0820, 0.0794, 0.0781, 0.0758,
		0.0735, 0.0725, 0.0704, 0.0694, 0.0676, 0.0667, 0.0649, 0.0633, 0.0625, 0.0610,
		0.0595, 0.0588, 0.0575, 0.0562, 0.0549, 0.0543, 0.0532, 0.0521, 0.0510, 0.0500,
	},
	[StatLogic:GetClassIdOrName("PALADIN")] = {
		0.2174, 0.2070, 0.2070, 0.1976, 0.1976, 0.1890, 0.1890, 0.1812, 0.1812, 0.1739,
		0.1739, 0.1672, 0.1553, 0.1553, 0.1449, 0.1449, 0.1403, 0.1318, 0.1318, 0.1242,
		0.1208, 0.1208, 0.1144, 0.1115, 0.1087, 0.1060, 0.1035, 0.1011, 0.0988, 0.0945,
		0.0925, 0.0925, 0.0887, 0.0870, 0.0836, 0.0820, 0.0820, 0.0791, 0.0776, 0.0750,
		0.0737, 0.0737, 0.0713, 0.0701, 0.0679, 0.0669, 0.0659, 0.0639, 0.0630, 0.0612,
		0.0604, 0.0596, 0.0580, 0.0572, 0.0557, 0.0550, 0.0544, 0.0530, 0.0524, 0.0512,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.2840, 0.2834, 0.2711, 0.2530, 0.2430, 0.2337, 0.2251, 0.2171, 0.2051, 0.1984,
		0.1848, 0.1670, 0.1547, 0.1441, 0.1330, 0.1267, 0.1194, 0.1117, 0.1060, 0.0998,
		0.0962, 0.0910, 0.0872, 0.0829, 0.0797, 0.0767, 0.0734, 0.0709, 0.0680, 0.0654,
		0.0637, 0.0614, 0.0592, 0.0575, 0.0556, 0.0541, 0.0524, 0.0508, 0.0493, 0.0481,
		0.0470, 0.0457, 0.0444, 0.0433, 0.0421, 0.0413, 0.0402, 0.0391, 0.0382, 0.0373,
		0.0366, 0.0358, 0.0350, 0.0341, 0.0334, 0.0328, 0.0321, 0.0314, 0.0307, 0.0301,
	},
	[StatLogic:GetClassIdOrName("ROGUE")] = {
		0.4476, 0.4290, 0.4118, 0.3813, 0.3677, 0.3550, 0.3321, 0.3217, 0.3120, 0.2941,
		0.2640, 0.2394, 0.2145, 0.1980, 0.1775, 0.1660, 0.1560, 0.1450, 0.1355, 0.1271,
		0.1197, 0.1144, 0.1084, 0.1040, 0.0980, 0.0936, 0.0903, 0.0865, 0.0830, 0.0792,
		0.0768, 0.0741, 0.0715, 0.0691, 0.0664, 0.0643, 0.0628, 0.0609, 0.0592, 0.0572,
		0.0556, 0.0542, 0.0528, 0.0512, 0.0497, 0.0486, 0.0474, 0.0464, 0.0454, 0.0440,
		0.0431, 0.0422, 0.0412, 0.0404, 0.0394, 0.0386, 0.0378, 0.0370, 0.0364, 0.0355,
	},
	[StatLogic:GetClassIdOrName("PRIEST")] = {
		0.0909, 0.0909, 0.0909, 0.0865, 0.0865, 0.0865, 0.0865, 0.0826, 0.0826, 0.0826,
		0.0826, 0.0790, 0.0790, 0.0790, 0.0790, 0.0757, 0.0757, 0.0757, 0.0727, 0.0727,
		0.0727, 0.0727, 0.0699, 0.0699, 0.0699, 0.0673, 0.0673, 0.0673, 0.0649, 0.0649,
		0.0649, 0.0627, 0.0627, 0.0627, 0.0606, 0.0606, 0.0606, 0.0586, 0.0586, 0.0586,
		0.0568, 0.0568, 0.0551, 0.0551, 0.0551, 0.0534, 0.0534, 0.0519, 0.0519, 0.0519,
		0.0505, 0.0505, 0.0491, 0.0491, 0.0478, 0.0478, 0.0466, 0.0466, 0.0454, 0.0454,
	},
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1663, 0.1663, 0.1583, 0.1583, 0.1511, 0.1511, 0.1511, 0.1446, 0.1446, 0.1385,
		0.1385, 0.1330, 0.1330, 0.1279, 0.1231, 0.1188, 0.1188, 0.1147, 0.1147, 0.1073,
		0.1073, 0.1039, 0.1039, 0.1008, 0.0978, 0.0950, 0.0950, 0.0924, 0.0924, 0.0875,
		0.0875, 0.0853, 0.0831, 0.0831, 0.0792, 0.0773, 0.0773, 0.0756, 0.0756, 0.0723,
		0.0707, 0.0707, 0.0693, 0.0679, 0.0665, 0.0652, 0.0639, 0.0627, 0.0627, 0.0605,
		0.0594, 0.0583, 0.0583, 0.0573, 0.0554, 0.0545, 0.0536, 0.0536, 0.0528, 0.0512,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.0771, 0.0771, 0.0771, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0735, 0.0701,
		0.0701, 0.0701, 0.0701, 0.0701, 0.0671, 0.0671, 0.0671, 0.0671, 0.0671, 0.0643,
		0.0643, 0.0643, 0.0643, 0.0617, 0.0617, 0.0617, 0.0617, 0.0617, 0.0593, 0.0593,
		0.0593, 0.0593, 0.0571, 0.0571, 0.0571, 0.0551, 0.0551, 0.0551, 0.0551, 0.0532,
		0.0532, 0.0532, 0.0532, 0.0514, 0.0514, 0.0514, 0.0498, 0.0498, 0.0498, 0.0482,
		0.0482, 0.0482, 0.0467, 0.0467, 0.0467, 0.0454, 0.0454, 0.0454, 0.0441, 0.0441,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1500, 0.1500, 0.1429, 0.1429, 0.1429, 0.1364, 0.1364, 0.1364, 0.1304, 0.1304,
		0.1250, 0.1250, 0.1250, 0.1200, 0.1154, 0.1111, 0.1111, 0.1111, 0.1071, 0.1034,
		0.1000, 0.1000, 0.0968, 0.0968, 0.0909, 0.0909, 0.0909, 0.0882, 0.0882, 0.0833,
		0.0833, 0.0811, 0.0811, 0.0789, 0.0769, 0.0750, 0.0732, 0.0732, 0.0714, 0.0698,
		0.0682, 0.0682, 0.0667, 0.0667, 0.0638, 0.0625, 0.0625, 0.0612, 0.0600, 0.0588,
		0.0577, 0.0577, 0.0566, 0.0556, 0.0545, 0.0536, 0.0526, 0.0517, 0.0517, 0.0500,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.2020, 0.2020, 0.1923, 0.1923, 0.1836, 0.1836, 0.1756, 0.1756, 0.1683, 0.1553,
		0.1496, 0.1496, 0.1443, 0.1443, 0.1346, 0.1346, 0.1303, 0.1262, 0.1262, 0.1122,
		0.1122, 0.1092, 0.1063, 0.1063, 0.1010, 0.1010, 0.0985, 0.0962, 0.0962, 0.0878,
		0.0859, 0.0859, 0.0841, 0.0824, 0.0808, 0.0792, 0.0777, 0.0777, 0.0762, 0.0709,
		0.0696, 0.0696, 0.0685, 0.0673, 0.0651, 0.0641, 0.0641, 0.0631, 0.0621, 0.0585,
		0.0577, 0.0569, 0.0561, 0.0561, 0.0546, 0.0539, 0.0531, 0.0525, 0.0518, 0.0493,
	},
}

local zero = setmetatable({}, {
	__index = function()
		return 0
	end
})

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
-- TODO: These are currently TBC values
addonTable.SpellCritPerInt = {
	[StatLogic:GetClassIdOrName("WARRIOR")] = zero,
	[StatLogic:GetClassIdOrName("PALADIN")] = {
		0.0832, 0.0793, 0.0793, 0.0757, 0.0757, 0.0724, 0.0694, 0.0694, 0.0666, 0.0666,
		0.0640, 0.0616, 0.0594, 0.0574, 0.0537, 0.0537, 0.0520, 0.0490, 0.0490, 0.0462,
		0.0450, 0.0438, 0.0427, 0.0416, 0.0396, 0.0387, 0.0387, 0.0370, 0.0362, 0.0347,
		0.0340, 0.0333, 0.0326, 0.0320, 0.0308, 0.0303, 0.0297, 0.0287, 0.0282, 0.0273,
		0.0268, 0.0264, 0.0256, 0.0256, 0.0248, 0.0245, 0.0238, 0.0231, 0.0228, 0.0222,
		0.0219, 0.0216, 0.0211, 0.0208, 0.0203, 0.0201, 0.0198, 0.0191, 0.0189, 0.0185,
	},
	[StatLogic:GetClassIdOrName("HUNTER")] = {
		0.0699, 0.0666, 0.0666, 0.0635, 0.0635, 0.0608, 0.0608, 0.0583, 0.0583, 0.0559,
		0.0559, 0.0538, 0.0499, 0.0499, 0.0466, 0.0466, 0.0451, 0.0424, 0.0424, 0.0399,
		0.0388, 0.0388, 0.0368, 0.0358, 0.0350, 0.0341, 0.0333, 0.0325, 0.0318, 0.0304,
		0.0297, 0.0297, 0.0285, 0.0280, 0.0269, 0.0264, 0.0264, 0.0254, 0.0250, 0.0241,
		0.0237, 0.0237, 0.0229, 0.0225, 0.0218, 0.0215, 0.0212, 0.0206, 0.0203, 0.0197,
		0.0194, 0.0192, 0.0186, 0.0184, 0.0179, 0.0177, 0.0175, 0.0170, 0.0168, 0.0164,
	},
	[StatLogic:GetClassIdOrName("ROGUE")] = zero,
	[StatLogic:GetClassIdOrName("PRIEST")] = {
		0.1710, 0.1636, 0.1568, 0.1505, 0.1394, 0.1344, 0.1297, 0.1254, 0.1214, 0.1140,
		0.1045, 0.0941, 0.0875, 0.0784, 0.0724, 0.0684, 0.0627, 0.0597, 0.0562, 0.0523,
		0.0502, 0.0470, 0.0453, 0.0428, 0.0409, 0.0392, 0.0376, 0.0362, 0.0348, 0.0333,
		0.0322, 0.0311, 0.0301, 0.0289, 0.0281, 0.0273, 0.0263, 0.0256, 0.0249, 0.0241,
		0.0235, 0.0228, 0.0223, 0.0216, 0.0210, 0.0206, 0.0200, 0.0196, 0.0191, 0.0186,
		0.0183, 0.0178, 0.0175, 0.0171, 0.0166, 0.0164, 0.0160, 0.0157, 0.0154, 0.0151,
	},
	[StatLogic:GetClassIdOrName("SHAMAN")] = {
		0.1333, 0.1272, 0.1217, 0.1217, 0.1166, 0.1120, 0.1077, 0.1037, 0.1000, 0.1000,
		0.0933, 0.0875, 0.0800, 0.0756, 0.0700, 0.0666, 0.0636, 0.0596, 0.0571, 0.0538,
		0.0518, 0.0500, 0.0474, 0.0459, 0.0437, 0.0424, 0.0412, 0.0394, 0.0383, 0.0368,
		0.0354, 0.0346, 0.0333, 0.0325, 0.0314, 0.0304, 0.0298, 0.0289, 0.0283, 0.0272,
		0.0267, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235, 0.0231, 0.0226, 0.0220, 0.0215,
		0.0210, 0.0207, 0.0201, 0.0199, 0.0193, 0.0190, 0.0187, 0.0182, 0.0179, 0.0175,
	},
	[StatLogic:GetClassIdOrName("MAGE")] = {
		0.1637, 0.1574, 0.1516, 0.1411, 0.1364, 0.1320, 0.1279, 0.1240, 0.1169, 0.1137,
		0.1049, 0.0930, 0.0871, 0.0731, 0.0671, 0.0639, 0.0602, 0.0568, 0.0538, 0.0505,
		0.0487, 0.0460, 0.0445, 0.0422, 0.0405, 0.0390, 0.0372, 0.0338, 0.0325, 0.0312,
		0.0305, 0.0294, 0.0286, 0.0278, 0.0269, 0.0262, 0.0254, 0.0248, 0.0241, 0.0235,
		0.0230, 0.0215, 0.0211, 0.0206, 0.0201, 0.0197, 0.0192, 0.0188, 0.0184, 0.0179,
		0.0176, 0.0173, 0.0170, 0.0166, 0.0162, 0.0154, 0.0151, 0.0149, 0.0146, 0.0143,
	},
	[StatLogic:GetClassIdOrName("WARLOCK")] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, 0.0825, 0.0767, 0.0717, 0.0688, 0.0635, 0.0600, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, 0.0446, 0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		0.0256, 0.0248, 0.0243, 0.0236, 0.0229, 0.0224, 0.0220, 0.0214, 0.0209, 0.0204,
		0.0200, 0.0195, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0172, 0.0168, 0.0165,
	},
	[StatLogic:GetClassIdOrName("DRUID")] = {
		0.1431, 0.1369, 0.1312, 0.1259, 0.1211, 0.1166, 0.1124, 0.1124, 0.1086, 0.0984,
		0.0926, 0.0851, 0.0807, 0.0750, 0.0684, 0.0656, 0.0617, 0.0594, 0.0562, 0.0516,
		0.0500, 0.0477, 0.0463, 0.0437, 0.0420, 0.0409, 0.0394, 0.0384, 0.0366, 0.0346,
		0.0339, 0.0325, 0.0318, 0.0309, 0.0297, 0.0292, 0.0284, 0.0276, 0.0269, 0.0256,
		0.0252, 0.0244, 0.0240, 0.0233, 0.0228, 0.0223, 0.0219, 0.0214, 0.0209, 0.0202,
		0.0198, 0.0193, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0173, 0.0169, 0.0164,
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
	[StatLogic:GetClassIdOrName("HUNTER")] = 2,
	[StatLogic:GetClassIdOrName("ROGUE")] = 1,
	[StatLogic:GetClassIdOrName("PRIEST")] = 0,
	[StatLogic:GetClassIdOrName("SHAMAN")] = 0,
	[StatLogic:GetClassIdOrName("MAGE")] = 0,
	[StatLogic:GetClassIdOrName("WARLOCK")] = 0,
	[StatLogic:GetClassIdOrName("DRUID")] = 0,
}

-- TODO: These are TBC values
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
		-- Druid: Reflection - 3,6
		--        Allows 5/10/15% of your Mana regeneration to continue while casting
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
		},
		-- Druid: Feline Swiftness (Rank 2) - 2,6
		--        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form by 2%/4%.
		["ADD_DODGE"] = {
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		["MOD_ARMOR"] = {
			-- Druid: Thick Hide (Rank 5) - 2,5
			--        Increases your Armor contribution from items by 2/4/6/8/10%
			{
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
			-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
			--        Shapeshift into a bear, increasing melee attack power by 120, armor contribution from items by 180%, and health by 560.
			{
				["value"] = 2.8,
				["buff"] = GetSpellInfo(5487),		-- ["Bear Form"],
			},
			-- Druid: Dire Bear Form - Buff
			--        Shapeshift into a dire bear, increasing melee attack power by 180, armor contribution from items by 360%, and health by 1240.
			{
				["value"] = 4.6,
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			-- Druid: Moonkin Form - Buff
			--        While in this form the armor contribution from items is increased by 360%, and all party members within 30 yards have their spell critical chance increased by 3%.
			{
				["value"] = 4.6,
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		["MOD_STA"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		["MOD_STR"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		["MOD_INT"] = {
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
			},
		},
	}
elseif addonTable.playerClass == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
		["ADD_DODGE"] = {
			-- Hunter: Aspect of the Monkey - Buff
			--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.
			{
				["value"] = 8,
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			-- Hunter: Improved Aspect of the Monkey (Rank 5) - 1,4
			--         Increases the Dodge bonus of your Aspect of the Monkey by 1/2/3/4/5%.
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			-- Hunter: Deterrence - Buff
			--         Dodge and Parry chance increased by 25%.
			{
				["value"] = 25,
				["buff"] = GetSpellInfo(31567),		-- ["Deterrence"],
			},
		},
		-- Hunter: Survivalist (Rank 5) - 3,8
		--         Increases total health by 2%/4%/6%/8%/10%.
		["MOD_HEALTH"] = {
			{
				["tab"] = 3,
				["num"] = 8,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		-- Hunter: Lightning Reflexes (Rank 5) - 3,15
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			{
				["tab"] = 3,
				["num"] = 15,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
	}
elseif addonTable.playerClass == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
		-- Mage: Arcane Fortitude - 1,9
		--       Increases your armor by an amount equal to 50% of your Intellect.
		["ADD_ARMOR_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.5,
				},
			},
		},
		-- Mage: Arcane Meditation (Rank 3) - 1,12
		--       Allows 5/10/15% of your Mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
			{
				-- Mage: Mage Armor - Buff
				--			Allows 30% of your mana regeneration to continue while casting.
				["rank"] = setmetatable({}, {
					__index = function(t, k)
						return k and 0.3
					end
				}),
				["buff"] = GetSpellInfo(6117),		-- ["Mage Armor"],
			},
		},
		-- Mage: Arcane Mind (Rank 5) - 1,14
		--       Increases your maximum mana by 2/4/6/8/10%
		["MOD_MANA"] = {
			{
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
	}
elseif addonTable.playerClass == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
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
		-- Priest: Meditation (Rank 3) - 1,8
		--         Allows 5/10/15% of your Mana regeneration to continue while casting.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			{
				["tab"] = 1,
				["num"] = 8,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		["ADD_SPELL_DMG_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		["ADD_HEALING_MOD_SPI"] = {
			{
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Priest: Elune's Grace (Rank 6) - Buff, NE priest only
		--         Ranged damage taken reduced by 167 and chance to dodge increased by 10%.
		["ADD_DODGE"] = {
			{
				["value"] = 10,
				["buff"] = GetSpellInfo(2651),		-- ["Elune's Grace"],
			},
		},
		-- Priest: Spell Warding (Rank 5) - 2,4
		--         Reduces all spell damage taken by 2%/4%/6%/8%/10%.
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
		},
		-- Priest: Mental Strength (Rank 5) - 1,12
		--         Increases your maximum Mana by 2%/4%/6%/8%/10%.
		["MOD_MANA"] = {
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
	}
elseif addonTable.playerClass == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
		-- Rogue: Deadliness (Rank 5) - 3,16
		--        Increases your attack power by 2%/4%/6%/8%/10%.
		["MOD_AP"] = {
			{
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Rogue: Lightning Reflexes (Rank 5) - 2,3
		--        Increases your Dodge chance by 1%/2%/3%/4%/5%.
		-- Rogue: Evasion - Buff
		--        Dodge chance increased by 50%.
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
					50
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
			{
				["value"] = 15,
				["buff"] = GetSpellInfo(31022),		-- ["Ghostly Strike"],
			},
		},
		-- Rogue: Sleight of Hand (Rank 2) - 3,3
		--        Reduces the chance you are critically hit by melee and ranged attacks by 1/2% and increases the threat reduction of your Feint ability by 20%.
		["ADD_CRIT_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02,
				},
			},
		},
		-- Rogue: Heightened Senses (Rank 2) - 3,12
		--        Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by 2%/4%.
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
		},
	}
elseif addonTable.playerClass == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
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
					-0.04, -0.07, -0.10,
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
					0.02, 0.04, 0.06, 0.08, 0.10,
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
		-- Warlock: Master Demonologist (Rank 5) - 2,15
		--          Voidwalker - Reduces physical damage taken by 2%/4%/6%/8%/10%.
		-- Warlock: Soul Link (Rank 1) - 2,19
		--          When active, 30% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter or Felguard demon instead. In addition, both the demon and master will inflict 3% more damage. Lasts as long as the demon is active.
		["MOD_DMG_TAKEN"] = {
			{
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 2,
				["num"] = 15,
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
				["value"] = -0.3,
				["buff"] = GetSpellInfo(25228),		-- ["Soul Link"],
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
		["MOD_DMG_TAKEN"] = {
			-- Warrior: Shield Wall - Buff
			--          Reduces the Physical and magical damage taken by the caster by 75% for 10 sec.
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
			-- Warrior: Defensive Stance - stance
			--          A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases threat generated.
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
			-- Warrior: Berserker Stance - stance
			--          An aggressive stance. Critical hit chance is increased by 3% and all damage taken is increased by 10%.
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
			-- Warrior: Recklessness - Buff
			--          The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.
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
		},
		["MOD_ARMOR"] = {
			-- Warrior: Toughness (Rank 5) - 3,4
			--          Increases your armor value from items by 2%/4%/6%/8%/10%.
			{
				["tab"] = 3,
				["num"] = 4,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
			-- Warrior: Death Wish - Buff
			--          When activated, increases your physical damage by 20% and makes you immune to Fear effects, but lowers your armor and all resistances by 20%.  Lasts 30 sec.
			{
				["value"] = 0.8,
				["buff"] = GetSpellInfo(12292),		-- ["Death Wish"],
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
			}
		}
	}
elseif addonTable.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
		-- Gnome: Expansive Mind - Racial
		--        Increase Intelligence by 5%.
		["MOD_INT"] = {
			{
				["value"] = 0.05,
			}
		}
	}
elseif addonTable.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
		-- Human: The Human Spirit - Racial
		--        Increase Spirit by 5%.
		["MOD_SPIRIT"] = {
			{
				["value"] = 0.05,
			}
		}
	}
end

StatLogic.StatModTable["ALL"] = {
	["MOD_ARMOR"] = {
		-- Paladin: Lay on Hands (Rank 1/2) - Buff
		--          Armor increased by 15%/30%.
		{
			["rank"] = {
				0.15, 0.30,
			},
			["buff"] = GetSpellInfo(27154),		-- ["Lay on Hands"],
		},
		-- Priest: Inspiration (Rank 1/2/3) - Buff
		--         Increases armor by 8%/16%/25%.
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["buff"] = GetSpellInfo(15363),		-- ["Inspiration"],
		},
		-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
		--         Increases your armor value by 8%/16%/25%.
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
			["meta_gem"] = 35503,
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
	-- Priest: Power Infusion - Buff
	--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
	["MOD_SPELL_DMG"] = {
		[1] = {
			["value"] = 0.2,
			["buff"] = GetSpellInfo(10060),		-- ["Power Infusion"],
		},
	},
	-- Priest: Power Infusion - Buff
	--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
	["MOD_HEALING"] = {
		[1] = {
			["value"] = 0.2,
			["buff"] = GetSpellInfo(10060),		-- ["Power Infusion"],
		},
	},
}
