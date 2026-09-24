local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

StatLogic.RatingBase = {}

-- Extracted from the client at GameTables/OCTRegenMP.txt via wow.tools.local
local OCTRegenMP = 0.25

-- Extracted from the client at GameTables/RegenMPPerSpt.txt via wow.tools.local
local RegenMPPerSpt = {
	["PALADIN"] = 0.100,
	["HUNTER"]  = 0.100,
	["PRIEST"]  = 0.125,
	["SHAMAN"]  = 0.100,
	["MAGE"]    = 0.125,
	["WARLOCK"] = 0.100,
	["DRUID"]   = 0.100,
}

local NormalManaRegenPerSpi = function()
	local _, spi = UnitStat("player", LE_UNIT_STAT_SPIRIT)
	return 5 * (spi > 50 and RegenMPPerSpt[addon.class] or OCTRegenMP)
end

-- Below level 20 (Gathered by Alessandro Barbieri)
local OCTRegenHP = {
	["WARRIOR"] = 1.125,    -- No data
	["PALADIN"] = 0.194,
	["HUNTER"]  = 0.2805,   -- No data
	["ROGUE"]   = 1.0000,   -- No data
	["PRIEST"]  = 0.0951,   -- No data
	["SHAMAN"]  = 0.214287, -- No data
	["MAGE"]    = 0.0935,
	["WARLOCK"] = 0.1055,
	["DRUID"]   = 0.112,
}

-- Above level 20 (Gathered by Alessandro Barbieri)
local RegenHPPerSpt = {
	["WARRIOR"] = 0.375,
	["PALADIN"] = 0.094,
	["HUNTER"]  = 0.0935,
	["ROGUE"]   = 0.333333, -- No data
	["PRIEST"]  = 0.0317,
	["SHAMAN"]  = 0.071429, -- No data
	["MAGE"]    = 0.0315,
	["WARLOCK"] = 0.036,
	["DRUID"]   = 0.0476,
}

local NormalHealthRegenPerSpi = function()
	local _, spi = UnitStat("player", LE_UNIT_STAT_SPIRIT)
	local classRegen = spi > 50 and RegenHPPerSpt or OCTRegenHP
	return 5 * classRegen[addon.class]
end

-- CritPerAgi, SpellCritPerInt, and DodgePerAgi collected via addon comms from users like you <3
addon.CritPerAgi = {
	["WARRIOR"] = {
		0.2500, 0.2381, 0.2381, 0.2273, 0.2174, 0.2083, 0.2083, 0.2000, 0.1923, 0.1923,
		0.1852, 0.1786, 0.1667, 0.1613, 0.1563, 0.1515, 0.1471, 0.1389, 0.1351, 0.1282,
		0.1282, 0.1250, 0.1190, 0.1163, 0.1111, 0.1087, 0.1064, 0.1020, 0.1000, 0.0962,
		0.0943, 0.0926, 0.0893, 0.0877, 0.0847, 0.0833, 0.0820, 0.0794, 0.0781, 0.0758,
		0.0735, 0.0725, 0.0704, 0.0694, 0.0676, 0.0667, 0.0649, 0.0633, 0.0625, 0.0610,
		0.0595, 0.0588, 0.0575, 0.0562, 0.0549, 0.0543, 0.0532, 0.0521, 0.0510, 0.0500,
	},
	["PALADIN"] = {
		0.2150, 0.2048, 0.2048, 0.1955, 0.1955, 0.1870, 0.1870, 0.1792, 0.1792, 0.1720,
		0.1720, 0.1654, 0.1536, 0.1536, 0.1433, 0.1433, 0.1387, 0.1303, 0.1303, 0.1229,
		0.1194, 0.1194, 0.1132, 0.1103, 0.1075, 0.1049, 0.1024, 0.1000, 0.0977, 0.0935,
		0.0915, 0.0915, 0.0878, 0.0860, 0.0827, 0.0811, 0.0811, 0.0782, 0.0768, 0.0741,
		0.0729, 0.0729, 0.0705, 0.0694, 0.0672, 0.0662, 0.0652, 0.0632, 0.0623, 0.0606,
		0.0597, 0.0589, 0.0573, 0.0566, 0.0551, 0.0544, 0.0538, 0.0524, 0.0518, 0.0506,
	},
	["HUNTER"] = {
		0.2174, 0.2083, 0.2000, 0.1852, 0.1786, 0.1724, 0.1667, 0.1613, 0.1515, 0.1471,
		0.1351, 0.1190, 0.1087, 0.1000, 0.0909, 0.0862, 0.0806, 0.0746, 0.0704, 0.0658,
		0.0633, 0.0595, 0.0568, 0.0538, 0.0515, 0.0495, 0.0472, 0.0455, 0.0435, 0.0417,
		0.0407, 0.0391, 0.0376, 0.0365, 0.0352, 0.0342, 0.0331, 0.0321, 0.0311, 0.0303,
		0.0296, 0.0287, 0.0279, 0.0272, 0.0265, 0.0259, 0.0253, 0.0245, 0.0239, 0.0234,
		0.0229, 0.0224, 0.0219, 0.0213, 0.0209, 0.0206, 0.0201, 0.0197, 0.0192, 0.0189,
	},
	["ROGUE"] = {
		0.4348, 0.4167, 0.4000, 0.3704, 0.3571, 0.3448, 0.3226, 0.3125, 0.3030, 0.2857,
		0.2564, 0.2326, 0.2083, 0.1923, 0.1724, 0.1613, 0.1515, 0.1408, 0.1316, 0.1235,
		0.1163, 0.1111, 0.1053, 0.1010, 0.0952, 0.0909, 0.0877, 0.0840, 0.0806, 0.0769,
		0.0746, 0.0719, 0.0694, 0.0671, 0.0645, 0.0625, 0.0610, 0.0592, 0.0575, 0.0556,
		0.0541, 0.0526, 0.0513, 0.0498, 0.0483, 0.0472, 0.0461, 0.0450, 0.0441, 0.0427,
		0.0418, 0.0410, 0.0400, 0.0392, 0.0383, 0.0375, 0.0368, 0.0360, 0.0353, 0.0345,
	},
	["PRIEST"] = {
		0.1000, 0.1000, 0.1000, 0.0952, 0.0952, 0.0952, 0.0952, 0.0909, 0.0909, 0.0909,
		0.0909, 0.0870, 0.0870, 0.0870, 0.0870, 0.0833, 0.0833, 0.0833, 0.0800, 0.0800,
		0.0800, 0.0800, 0.0769, 0.0769, 0.0769, 0.0741, 0.0741, 0.0741, 0.0714, 0.0714,
		0.0714, 0.0690, 0.0690, 0.0690, 0.0667, 0.0667, 0.0667, 0.0645, 0.0645, 0.0645,
		0.0625, 0.0625, 0.0606, 0.0606, 0.0606, 0.0588, 0.0588, 0.0571, 0.0571, 0.0571,
		0.0556, 0.0556, 0.0541, 0.0541, 0.0526, 0.0526, 0.0513, 0.0513, 0.0500, 0.0500,
	},
	["SHAMAN"] = {
		0.1650, 0.1650, 0.1571, 0.1571, 0.1500, 0.1500, 0.1500, 0.1435, 0.1435, 0.1375,
		0.1375, 0.1320, 0.1320, 0.1269, 0.1222, 0.1179, 0.1179, 0.1138, 0.1138, 0.1065,
		0.1065, 0.1031, 0.1031, 0.0100, 0.0971, 0.0943, 0.0943, 0.0917, 0.0917, 0.0868,
		0.0868, 0.0846, 0.0825, 0.0825, 0.0786, 0.0767, 0.0767, 0.0750, 0.0750, 0.0717,
		0.0702, 0.0702, 0.0688, 0.0673, 0.0660, 0.0647, 0.0635, 0.0623, 0.0623, 0.0600,
		0.0589, 0.0579, 0.0579, 0.0569, 0.0550, 0.0541, 0.0532, 0.0532, 0.0524, 0.0508,
	},
	["MAGE"] = {
		0.0900, 0.0900, 0.0900, 0.0857, 0.0857, 0.0857, 0.0857, 0.0857, 0.0857, 0.0818,
		0.0818, 0.0818, 0.0818, 0.0818, 0.0783, 0.0783, 0.0783, 0.0783, 0.0783, 0.0750,
		0.0750, 0.0750, 0.0750, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0692, 0.0692,
		0.0692, 0.0692, 0.0667, 0.0667, 0.0667, 0.0643, 0.0643, 0.0643, 0.0643, 0.0621,
		0.0621, 0.0621, 0.0621, 0.0600, 0.0600, 0.0600, 0.0581, 0.0581, 0.0581, 0.0563,
		0.0563, 0.0563, 0.0545, 0.0545, 0.0545, 0.0529, 0.0529, 0.0529, 0.0514, 0.0514,
	},
	["WARLOCK"] = {
		0.1500, 0.1500, 0.1429, 0.1429, 0.1429, 0.1364, 0.1364, 0.1364, 0.1304, 0.1304,
		0.1250, 0.1250, 0.1250, 0.1200, 0.1154, 0.1111, 0.1111, 0.1111, 0.1071, 0.1034,
		0.1000, 0.1000, 0.0968, 0.0968, 0.0909, 0.0909, 0.0909, 0.0882, 0.0882, 0.0833,
		0.0833, 0.0811, 0.0811, 0.0789, 0.0769, 0.0750, 0.0732, 0.0732, 0.0714, 0.0698,
		0.0682, 0.0682, 0.0667, 0.0667, 0.0638, 0.0625, 0.0625, 0.0612, 0.0600, 0.0588,
		0.0577, 0.0577, 0.0566, 0.0556, 0.0545, 0.0536, 0.0526, 0.0517, 0.0517, 0.0500,
	},
	["DRUID"] = {
		0.2050, 0.2050, 0.1952, 0.1952, 0.1864, 0.1864, 0.1783, 0.1783, 0.1708, 0.1577,
		0.1519, 0.1519, 0.1464, 0.1464, 0.1367, 0.1367, 0.1323, 0.1281, 0.1281, 0.1139,
		0.1139, 0.1108, 0.1079, 0.1079, 0.1025, 0.1025, 0.1000, 0.0976, 0.0976, 0.0891,
		0.0872, 0.0872, 0.0854, 0.0837, 0.0820, 0.0804, 0.0788, 0.0788, 0.0774, 0.0719,
		0.0707, 0.0707, 0.0695, 0.0683, 0.0661, 0.0651, 0.0651, 0.0641, 0.0631, 0.0594,
		0.0586, 0.0577, 0.0569, 0.0569, 0.0554, 0.0547, 0.0539, 0.0532, 0.0526, 0.0500,
	},
}

-- In Vanilla, these are all equal to CritPerAgi, except Hunter/Rogue which are exactly double
addon.DodgePerAgi = setmetatable({}, {
	__index = function (t, class)
		t[class] = setmetatable({}, {__index = function(classTable, level)
			local dodgePerAgi = rawget(addon.CritPerAgi[class], level)
			if dodgePerAgi then
				if class == "HUNTER" or class == "ROGUE" then
					dodgePerAgi = dodgePerAgi * 2
				end
				classTable[level] = dodgePerAgi
				return dodgePerAgi
			end
		end })
		return t[class]
	end
})

addon.SpellCritPerInt = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = {
		0.0750, 0.0714, 0.0714, 0.0682, 0.0682, 0.0652, 0.0625, 0.0625, 0.0600, 0.0600,
		0.0577, 0.0556, 0.0536, 0.0517, 0.0484, 0.0484, 0.0469, 0.0441, 0.0441, 0.0417,
		0.0405, 0.0395, 0.0385, 0.0375, 0.0357, 0.0349, 0.0349, 0.0333, 0.0326, 0.0313,
		0.0306, 0.0300, 0.0294, 0.0288, 0.0278, 0.0273, 0.0268, 0.0259, 0.0254, 0.0246,
		0.0242, 0.0238, 0.0231, 0.0231, 0.0224, 0.0221, 0.0214, 0.0208, 0.0205, 0.0200,
		0.0197, 0.0195, 0.019, 0.0188, 0.0183, 0.0181, 0.0179, 0.0172, 0.0170, 0.0167,
	},
	["HUNTER"] = {
		0.0700, 0.0667, 0.0667, 0.0636, 0.0636, 0.0609, 0.0609, 0.0583, 0.0583, 0.0560,
		0.0560, 0.0538, 0.0500, 0.0500, 0.0467, 0.0467, 0.0452, 0.0424, 0.0424, 0.0400,
		0.0389, 0.0389, 0.0368, 0.0359, 0.0350, 0.0341, 0.0333, 0.0326, 0.0318, 0.0304,
		0.0298, 0.0298, 0.0286, 0.0280, 0.0269, 0.0264, 0.0264, 0.0255, 0.0250, 0.0241,
		0.0237, 0.0237, 0.0230, 0.0226, 0.0219, 0.0215, 0.0212, 0.0206, 0.0203, 0.0197,
		0.0194, 0.0192, 0.0187, 0.0184, 0.0179, 0.0177, 0.0175, 0.0171, 0.0169, 0.0165,
	},
	["ROGUE"] = addon.zero,
	["PRIEST"] = {
		0.1909, 0.1826, 0.1750, 0.1680, 0.1556, 0.1500, 0.1448, 0.1400, 0.1355, 0.1273,
		0.1167, 0.1050, 0.0977, 0.0875, 0.0808, 0.0764, 0.0700, 0.0667, 0.0627, 0.0583,
		0.0560, 0.0525, 0.0506, 0.0477, 0.0457, 0.0438, 0.0420, 0.0404, 0.0389, 0.0372,
		0.0359, 0.0347, 0.0336, 0.0323, 0.0313, 0.0304, 0.0294, 0.0286, 0.0278, 0.0269,
		0.0263, 0.0255, 0.0249, 0.0241, 0.0235, 0.0230, 0.0223, 0.0219, 0.0213, 0.0208,
		0.0204, 0.0199, 0.0195, 0.0191, 0.0186, 0.0183, 0.0179, 0.0176, 0.0171, 0.0168,
	},
	["SHAMAN"] = {
		0.1286, 0.1227, 0.1174, 0.1174, 0.1125, 0.1080, 0.1038, 0.1000, 0.0964, 0.0964,
		0.0900, 0.0844, 0.0771, 0.0730, 0.0675, 0.0643, 0.0614, 0.0574, 0.0551, 0.0519,
		0.0500, 0.0482, 0.0458, 0.0443, 0.0422, 0.0409, 0.0397, 0.0380, 0.0370, 0.0355,
		0.0342, 0.0333, 0.0321, 0.0314, 0.0303, 0.0293, 0.0287, 0.0278, 0.0273, 0.0262,
		0.0257, 0.0252, 0.0245, 0.0239, 0.0233, 0.0227, 0.0223, 0.0218, 0.0213, 0.0208,
		0.0203, 0.0200, 0.0194, 0.0191, 0.0186, 0.0184, 0.0180, 0.0175, 0.0173, 0.0169,
	},
	["MAGE"] = {
		0.1920, 0.1846, 0.1778, 0.1655, 0.1600, 0.1548, 0.1500, 0.1455, 0.1371, 0.1333,
		0.1231, 0.1091, 0.1021, 0.0857, 0.0787, 0.0750, 0.0706, 0.0667, 0.0632, 0.0593,
		0.0571, 0.0539, 0.0522, 0.0495, 0.0475, 0.0457, 0.0436, 0.0397, 0.0381, 0.0366,
		0.0358, 0.0345, 0.0336, 0.0327, 0.0316, 0.0308, 0.0298, 0.0291, 0.0282, 0.0276,
		0.0270, 0.0253, 0.0247, 0.0241, 0.0235, 0.0231, 0.0225, 0.0220, 0.0215, 0.0211,
		0.0207, 0.0203, 0.0199, 0.0194, 0.0190, 0.0181, 0.0177, 0.0175, 0.0171, 0.0168,
	},
	["WARLOCK"] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, 0.0825, 0.0767, 0.0717, 0.0688, 0.0635, 0.0600, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, 0.0446, 0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		0.0256, 0.0248, 0.0243, 0.0236, 0.0229, 0.0224, 0.0220, 0.0214, 0.0209, 0.0204,
		0.0200, 0.0195, 0.0191, 0.0186, 0.0182, 0.0179, 0.0176, 0.0172, 0.0168, 0.0165,
	},
	["DRUID"] = {
		0.1455, 0.1391, 0.1333, 0.1280, 0.1231, 0.1185, 0.1143, 0.1143, 0.1103, 0.1000,
		0.0941, 0.0865, 0.0821, 0.0762, 0.0696, 0.0667, 0.0627, 0.0604, 0.0571, 0.0525,
		0.0508, 0.0485, 0.0471, 0.0444, 0.0427, 0.0416, 0.0400, 0.0390, 0.0372, 0.0352,
		0.0344, 0.0330, 0.0323, 0.0314, 0.0302, 0.0296, 0.0288, 0.0281, 0.0274, 0.0260,
		0.0256, 0.0248, 0.0244, 0.0237, 0.0232, 0.0227, 0.0222, 0.0218, 0.0212, 0.0205,
		0.0201, 0.0196, 0.0194, 0.0189, 0.0185, 0.0182, 0.0179, 0.0176, 0.0172, 0.0167,
	},
}

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		["ADD_AP_MOD_FERAL_ATTACK_POWER"] = {
			-- Cat Form
			{
				["value"] = 1,
				["aura"] = 768,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Bear Form
			{
				["value"] = 1,
				["aura"] = 5487,
				["group"] = addon.ExclusiveGroup.Feral,
			},
			-- Dire Bear Form
			{
				["value"] = 1,
				["aura"] = 9634,
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
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Reflection
			{
				["trait"] = 104917,
				["rank"] = {
					0.17, 0.33, 0.50,
				},
			},
			-- Set: Stormrage Raiment
			{
				["set"] = 214,
				["pieces"] = 3,
				["value"] = 0.15,
			},
		},
		["ADD_ARMOR_MOD_DEFENSE"] = {
			-- Talent: Thick Hide
			{
				["trait"] = 2,
				["rank"] = {
					0.67, 1.33, 2.00,
				},
			},
		},
		["MOD_ARMOR"] = {
			-- Buff: Bear Form
			{
				["value"] = 1.8,
				["aura"] = 5487,
			},
			-- Buff: Dire Bear Form
			{
				["value"] = 3.6,
				["aura"] = 9634,
			},
			-- Buff: Moonkin Form
			{
				["value"] = 3.6,
				["aura"] = 24858,
			},
		},
		["MOD_SPI"] = {
			-- Talent: Living Spirit
			{
				["trait"] = 104911,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Heart of the Wild (Bear Form)
			{
				["trait"] = 104939,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["aura"] = 5487,
			},
			-- Talent: Heart of the Wild (Dire Bear Form)
			{
				["trait"] = 104939,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["aura"] = 9634,
			},
		},
		["MOD_STR"] = {
			-- Talent: Heart of the Wild (Cat Form)
			{
				["trait"] = 104939,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
				["aura"] = 768,
			},
		},
		["MOD_INT"] = {
			-- Talent: Heart of the Wild
			{
				["trait"] = 104939,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
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
				["value"] = 2,
			},
		},
		["ADD_AP_MOD_INT"] = {
			-- Talent: Careful Aim
			{
				["trait"] = 105008,
				["rank"] = {
					0.2, 0.4, 0.6, 0.8, 1.0,
				},
			},
		},
		["ADD_RANGED_AP_MOD_INT"] = {
			-- Talent: Careful Aim
			{
				["trait"] = 105008,
				["rank"] = {
					0.2, 0.4, 0.6, 0.8, 1.0,
				},
			},
		},
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Bestial Discipline
			{
				["trait"] = 104963,
				["rank"] = {
					0.25, 0.50,
				},
			},
			-- Talent: Rapid Recuperation
			{
				["trait"] = 104999,
				["rank"] = {
					0.25, 0.50,
				},
				["aura"] = 1242512,
			},
			-- Talent: Resourcefulness
			{
				["trait"] = 104983,
				["value"] = 0.50,
				["aura"] = 1242688,
				["spellid"] = 440529,
			},
		},
		["MOD_HEALTH"] = {
			-- Talent: Survivalist
			{
				["trait"] = 104992,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_AGI"] = {
			-- Talent: Lightning Reflexes
			{
				["trait"] = 110859,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
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
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_BONUS_ARMOR_MOD_INT"] = {
			-- Talent: Arcane Resilience
			{
				["trait"] = 105809,
				["rank"] = {
					0.25, 0.50,
				},
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Arcane Meditation
			{
				["trait"] = 105803,
				["rank"] = {
					0.17, 0.33, 0.50,
				},
			},
			-- Buff: Mage Armor
			{
				["value"] = 0.3,
				["aura"] = 6117,
			},
		},
		["MOD_NORMAL_MANA_REGEN"] = {
		},
		["MOD_INT"] = {
			-- Talent: Arcane Mind
			{
				["trait"] = 105800,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_SPI"] = {
		}
	}
elseif addon.class == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
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
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Reverence
			{
				["trait"] = 110871,
				["rank"] = {
					0.10, 0.20, 0.30,
				},
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["MOD_AP"] = {
			-- Talent: Vindication
			{
				["trait"] = 105702,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
				["aura"] = 440668,
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Toughness
			{
				["trait"] = 105630,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_STR"] = {
			-- Talent: Divine Strength
			{
				["trait"] = 105328,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Divine Intellect
			{
				["trait"] = 105332,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Sacred Duty
			{
				["trait"] = 105632,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Champion of the Light
			{
				["trait"] = 110882,
				["rank"] = {
					0.33, 0.66, 1.00,
				},
			}
		},
		["ADD_HEALING_MOD_INT"] = {
			-- Talent: Champion of the Light
			{
				["trait"] = 110882,
				["rank"] = {
					0.33, 0.66, 1.00,
				},
			}
		},
		["MOD_BLOCK_VALUE"] = {
			-- Talent: Shield Specialization
			{
				["trait"] = 110874,
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
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Meditation
			{
				["trait"] = 105843,
				["rank"] = {
					0.17, 0.33, 0.50,
				},
			},
			-- Talent: Spirit Tap
			{
				["trait"] = 105833,
				["value"] = 0.50,
				["aura"] = 15271,
			},
		},
		["ADD_SPELL_DMG_MOD_SPI"] = {
			-- Talent: Spiritual Guidance
			{
				["trait"] = 105853,
				["rank"] = {
					0.01, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		["ADD_HEALING_MOD_SPI"] = {
			-- Talent: Spiritual Guidance (Rank 5) - 2,14
			{
				["trait"] = 105853,
				["rank"] = {
					0.05, 0.10, 0.15, 0.20, 0.25,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Mental Strength
			{
				["trait"] = 105837,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["MOD_SPI"] = {
			-- Talent: Spirit Tap
			{
				["trait"] = 105833,
				["value"] = 1.00,
				["aura"] = 15271,
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
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		[StatLogic.Stats.MeleeCrit] = {
			-- Talent: Hack and Slash
			{
				["trait"] = 105727,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Dagger] = true,
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
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["MOD_HEALTH"] = {
			-- Talent: Improved Reincarnation
			{
				["trait"] = 104737,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
		["MOD_STA"] = {
			-- Talent: Toughness
			{
				["trait"] = 104746,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["MOD_INT"] = {
			-- Talent: Ancestral Knowledge
			{
				["trait"] = 104756,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
		},
		["ADD_AP_MOD_INT"] = {
			-- Talent: Mental Dexterity
			{
				["trait"] = 104755,
				["rank"] = {
					0.33, 0.67, 1.00,
				},
			},
		},
		["ADD_SPELL_DMG_MOD_INT"] = {
			-- Talent: Mental Quickness
			{
				["trait"] = 104744,
				["rank"] = {
					0.15, 0.30,
				},
			},
		},
		["ADD_HEALING_MOD_INT"] = {
			-- Talent: Mental Quickness
			{
				["trait"] = 104744,
				["rank"] = {
					0.15, 0.30,
				},
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Mindfulness
			{
				["trait"] = 104734,
				["rank"] = {
					0.17, 0.33, 0.50,
				},
			},
			-- Talent: Improved Stormstrike
			{
				["trait"] = 104742,
				["value"] = 0.50,
				["aura"] = 1238931,
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
		["ADD_NORMAL_MANA_REGEN_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Soul Harvesting
			{
				["trait"] = 105922,
				["rank"] = {
					0.50, 1.00,
				},
				["aura"] = 1242853,
			},
		},
		["MOD_NORMAL_MANA_REGEN"] = {
			-- Talent: Soul Harvesting
			{
				["trait"] = 105922,
				["rank"] = {
					0.50, 1.00,
				},
				["aura"] = 1242853,
			},
		},
		["MOD_STA"] = {
			-- Talent: Demonic Embrace
			{
				["trait"] = 1059072,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		["ADD_GENERIC_MANA_REGEN_MOD_MANA"] = {
			-- Talent: Demonic Sacrifice (Fel Energy)
			{
				["trait"] = 105900,
				["value"] = 0.02 * 5/4,
				["aura"] = 18792,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Demonic Sacrifice (Fel Stamina)
			{
				["trait"] = 105900,
				["value"] = 0.03 * 5/4,
				["aura"] = 18790,
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
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["regen"] = NormalHealthRegenPerSpi,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["MOD_ARMOR"] = {
			-- Talent: Toughness
			{
				["trait"] = 105973,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.10,
				},
			},
			-- Buff: Death Wish
			{
				["value"] = -0.20,
				["aura"] = 12328,
			},
		},
		[StatLogic.Stats.MeleeCrit] = {
			-- Talent: Weaponmaster
			{
				["trait"] = 105944,
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
		["MOD_HEALTH"] = {
			-- Buff: Last Stand
			{
				["trait"] = 105970,
				["value"] = 0.30,
				["aura"] = 12976,
			},
		},
		["ADD_HEALTH_REG_MOD_HEALTH"] = {
			-- Talent: Blood Craze
			{
				["trait"] = 105934,
				["rank"] = {
					0.01 * 5/6, 0.02 * 5/6, 0.03 * 5/6,
				},
				["aura"] = 16488,
			},
		},
	}
end

if addon.playerRace == "Dwarf" then
	StatLogic.StatModTable["Dwarf"] = {
		[StatLogic.Stats.WeaponSkill] = {
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Guns] = true,
				},
				["group"] = addon.ExclusiveGroup.WeaponRacial,
			}
		},
	}
elseif addon.playerRace == "Tauren" then
	StatLogic.StatModTable["Tauren"] = {
		-- Tauren: Endurance - Racial
		--         Total Health increased by 5%.
		["MOD_HEALTH"] = {
			{
				["value"] = 0.05,
			}
		}
	}
elseif addon.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
		-- Gnome: Expansive Mind - Racial
		--        Increase Intelligence by 5%.
		["MOD_INT"] = {
			{
				["value"] = 0.05,
			}
		}
	}
elseif addon.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
		-- Human: The Human Spirit - Racial
		--        Increase Spirit by 5%.
		["MOD_SPI"] = {
			{
				["value"] = 0.05,
			}
		},
		[StatLogic.Stats.WeaponSkill] = {
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Mace1H] = true,
					[Enum.ItemWeaponSubclass.Mace2H] = true,
					[Enum.ItemWeaponSubclass.Sword1H] = true,
					[Enum.ItemWeaponSubclass.Sword2H] = true,
				},
				["group"] = addon.ExclusiveGroup.WeaponRacial,
			}
		}
	}
elseif addon.playerRace == "Orc" then
	StatLogic.StatModTable["Orc"] = {
		[StatLogic.Stats.WeaponSkill] = {
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Axe1H] = true,
					[Enum.ItemWeaponSubclass.Axe2H] = true,
				},
				["group"] = addon.ExclusiveGroup.WeaponRacial,
			}
		}
	}
elseif addon.playerRace == "Troll" then
	StatLogic.StatModTable["Troll"] = {
		["MOD_NORMAL_HEALTH_REG"] = {
			-- Troll: Regeneration - Racial
			--   Health regeneration rate increased by 10%.
			{
				["value"] = 0.1,
			},
		},
		["ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG"] = {
			-- Troll: Regeneration - Racial
			--   10% of total Health regeneration may continue during combat.
			{
				["value"] = 0.1,
				["spellid"] = 20555,
			},
		},
		[StatLogic.Stats.WeaponSkill] = {
			{
				["value"] = 5,
				["weaponSubclass"] = {
					[Enum.ItemWeaponSubclass.Bows] = true,
					[Enum.ItemWeaponSubclass.Thrown] = true,
				},
				["group"] = addon.ExclusiveGroup.WeaponRacial,
			}
		}
	}
end

StatLogic.StatModTable["ALL"] = {
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
			["value"] = 2,
		},
	},
	["MOD_ARMOR"] = {
		-- Buff: Lay on Hands
		{
			["rank"] = {
				0.15, 0.30,
			},
			["aura"] = 20236,
			["spellid"] = 20235,
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
			["aura"] = 16177,
			["group"] = addon.ExclusiveGroup.Armor,
			["spellid"] = 16176,
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
		-- Buff: Spirit of Zandalar
		{
			["value"] = 0.15,
			["aura"] = 24425,
			["group"] = addon.ExclusiveGroup.Zandalar,
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
		-- Buff: Spirit of Zandalar
		{
			["value"] = 0.15,
			["aura"] = 24425,
			["group"] = addon.ExclusiveGroup.Zandalar,
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
		-- Buff: Spirit of Zandalar
		{
			["value"] = 0.15,
			["aura"] = 24425,
			["group"] = addon.ExclusiveGroup.Zandalar,
		},
		-- Buff: Mol'dar's Moxie
		{
			["value"] = 0.15,
			["aura"] = 22818,
			["group"] = addon.ExclusiveGroup.Moxie,
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
		-- Buff: Spirit of Zandalar
		{
			["value"] = 0.15,
			["aura"] = 24425,
			["group"] = addon.ExclusiveGroup.Zandalar,
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
		-- Buff: Spirit of Zandalar
		{
			["value"] = 0.15,
			["aura"] = 24425,
			["group"] = addon.ExclusiveGroup.Zandalar,
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
		-- Green Dragon Mail
		{
			["set"] = 490,
			["pieces"] = 3,
			["value"] = 0.15,
		},
		-- Green Dragon Mail (SoD)
		{
			["set"] = 1791,
			["pieces"] = 3,
			["value"] = 0.15,
		},
		-- Aura of the Blue Dragon
		{
			["aura"] = 23684,
			["value"] = 1.00,
		},
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
}
