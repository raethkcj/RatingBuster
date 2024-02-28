local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

StatLogic.RatingBase = {}

-- Extracted from the client at GameTables/OCTRegenMP.txt via wow.tools.local
local OCTRegenMP = {
	["PALADIN"] = 0.25,
	["HUNTER"]  = 0.25,
	["PRIEST"]  = 0.25,
	["SHAMAN"]  = 0.25,
	["MAGE"]    = 0.25,
	["WARLOCK"] = 0.25,
	["DRUID"]   = 0.25,
}

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

-- Y-intercepts from commonly cited regen formulas
local RegenMPBase = {
	["PALADIN"] = 15.0,
	["HUNTER"]  = 15.0,
	["PRIEST"]  = 12.5,
	["SHAMAN"]  = 17.0,
	["MAGE"]    = 12.5,
	["WARLOCK"] = 15.0,
	["DRUID"]   = 15.0,
}

local NormalManaRegenPerSpi = function()
	local _, spi = UnitStat("player", 5)
	local low = OCTRegenMP[addon.class]
	local high = RegenMPPerSpt[addon.class]
	local base = RegenMPBase[addon.class]
	return 5 * (spi > base / (low - high) and high or low)
end

-- CritPerAgi, SpellCritPerInt, and DodgePerAgi collected via addon comms from users like you <3
addon.CritPerAgi = {
	["WARRIOR"] = {
		0.2500, 0.2381, 0.2381, 0.2273, 0.2174, 0.2083, 0.2083, nil,    nil,    nil,
		0.1852, 0.1786, 0.1667, 0.1613, 0.1563, 0.1515, 0.1471, nil,    0.1351, 0.1282,
		0.1282, nil,    nil,    0.1163, 0.1111, 0.1087, 0.1064, 0.1020, 0.1000, 0.0962,
		0.0943, 0.0926, 0.0893, 0.0877, 0.0847, 0.0833, 0.0820, 0.0794, 0.0781, 0.0758,
		[60] = 0.0500,
	},
	["PALADIN"] = {
		0.2150, 0.2048, 0.2048, 0.1955, 0.1955, 0.1870, nil,    0.1792, nil,    nil,
		nil,    nil,    nil,    nil,    nil,    nil,    nil,    0.1303, 0.1303, 0.1229,
		nil,    nil,    0.1132, nil,    0.1075, 0.1049, 0.1024, 0.1000, 0.0977, 0.0935,
		0.0915, 0.0915, 0.0878, 0.0860, 0.0827, 0.0811, 0.0811, 0.0782, 0.0768, 0.0741,
		[60] = 0.0506,
	},
	["HUNTER"] = {
		0.2174, 0.2083, 0.2000, 0.1852, 0.1786, 0.1724, 0.1667, 0.1613, 0.1515, 0.1471,
		0.1351, 0.1190, 0.1087, 0.1000, 0.0909, 0.0862, 0.0806, 0.0746, nil,    0.0658,
		0.0633, nil,    0.0568, nil,    0.0515, 0.0495, 0.0472, 0.0455, 0.0435, 0.0417,
		0.0407, 0.0391, 0.0376, 0.0365, 0.0352, 0.0342, 0.0331, 0.0321, 0.0311, 0.0303,
		[60] = 0.0189,
	},
	["ROGUE"] = {
		0.4348, 0.4167, 0.4000, 0.3704, 0.3571, 0.3448, nil,    0.3125, 0.3030, 0.2857,
		0.2564, 0.2326, 0.2083, nil,    0.1724, nil,    nil,    nil,    0.1316, 0.1235,
		nil,    0.1111, 0.1053, 0.1010, 0.0952, 0.0909, 0.0877, 0.0840, 0.0806, 0.0769,
		0.0746, 0.0719, 0.0694, 0.0671, 0.0645, 0.0625, 0.0610, 0.0592, 0.0575, 0.0556,
		[60] = 0.0345,
	},
	["PRIEST"] = {
		0.1000, 0.1000, 0.1000, 0.0952, 0.0952, 0.0952, 0.0952, 0.0909, 0.0909, 0.0909,
		0.0909, 0.0870, 0.0870, 0.0870, nil,    0.0833, 0.0833, 0.0833, nil,    0.0800,
		0.0800, 0.0800, nil,    0.0769, 0.0769, 0.0741, 0.0741, 0.0741, 0.0714, 0.0714,
		0.0714, 0.0690, 0.0690, 0.0690, 0.0667, 0.0667, 0.0667, 0.0645, 0.0645, 0.0645,
		[60] = 0.0500,
	},
	["SHAMAN"] = {
		0.1650, 0.1650, 0.1571, 0.1571, 0.1500, 0.1500, 0.1500, 0.1435, 0.1435, 0.1375,
		0.1375, 0.1320, 0.1320, 0.1269, 0.1222, 0.1179, 0.1179, 0.1138, nil,    nil,
		[22] = 0.1031,
		[23] = 0.1031,
		[25] = 0.0971,
		[28] = 0.0917,
		[29] = 0.0917,
		[30] = 0.0868,
		[32] = 0.0846,
		[34] = 0.0825,
		[37] = 0.0767,
		[38] = 0.0750,
		[40] = 0.0717,
		[60] = 0.0508,
	},
	["MAGE"] = {
		0.0900, 0.0900, 0.0900, 0.0857, 0.0857, 0.0857, 0.0857, 0.0857, 0.0857, 0.0818,
		0.0818, 0.0818, 0.0818, 0.0818, 0.0783, nil,    nil,    0.0783, 0.0783, 0.0750,
		0.0750, 0.0750, 0.0750, 0.0720, 0.0720, 0.0720, 0.0720, 0.0720, 0.0692, 0.0692,
		0.0692, 0.0692, 0.0667, 0.0667, 0.0667, 0.0643, 0.0643, 0.0643, 0.0643, 0.0621,
		[60] = 0.0514,
	},
	["WARLOCK"] = {
		0.1500, 0.1500, 0.1429, 0.1429, 0.1429, 0.1364, 0.1364, 0.1364, 0.1304, 0.1304,
		0.1250, 0.1250, nil,    nil,    0.1154, 0.1111, 0.1111, nil,    0.1071, 0.1034,
		0.1000, 0.1000, 0.0968, nil,    0.0909, 0.0909, 0.0909, 0.0882, 0.0882, 0.0833,
		0.0833, 0.0811, 0.0811, 0.0789, 0.0769, 0.0750, 0.0732, 0.0732, 0.0714, 0.0698,
		[60] = 0.0500,
	},
	["DRUID"] = {
		0.2050, 0.2050, nil,    0.1952, 0.1864, 0.1864, 0.1783, 0.1783, 0.1708, 0.1577,
		0.1519, 0.1519, 0.1464, 0.1464, 0.1367, 0.1367, 0.1323, 0.1281, nil,    0.1139,
		nil,    0.1108, nil,    nil,    0.1025, 0.1025, 0.1000, 0.0976, 0.0976, 0.0891,
		0.0872, 0.0872, 0.0854, 0.0837, 0.0820, 0.0804, 0.0788, 0.0788, 0.0774, 0.0719,
		[60] = 0.0500,
	},
}

-- In Vanilla, these are all equal to CritPerAgi, except Hunter/Rogue which are exactly double
addon.DodgePerAgi = setmetatable({
	["HUNTER"] = setmetatable({}, {
		__index = function(_, level)
			local critPerAgi = addon.CritPerAgi["HUNTER"][level]
			return critPerAgi and critPerAgi * 2 or nil
		end
	}),
	["ROGUE"] = setmetatable({}, {
		__index = function(_, level)
			local critPerAgi = addon.CritPerAgi["ROGUE"][level]
			return critPerAgi and critPerAgi * 2 or nil
		end
	})
}, {
	__index = addon.CritPerAgi
})

addon.SpellCritPerInt = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = {
		0.0750, 0.0714, 0.0714, 0.0682, 0.0682, 0.0652, nil,    0.0625, nil,    nil,
		nil,    nil,    nil,    nil,    nil,    nil,    nil,    0.0441, 0.0441, 0.0417,
		nil,    nil,    0.0385, nil,    0.0357, 0.0349, 0.0349, 0.0333, 0.0326, 0.0313,
		0.0306, 0.0300, 0.0294, 0.0288, 0.0278, 0.0273, 0.0268, 0.0259, 0.0254, 0.0246,
		[60] = 0.0167,
	},
	["HUNTER"] = {
		0.0700, 0.0667, 0.0667, 0.0636, 0.0636, 0.0609, 0.0609, 0.0583, 0.0583, 0.0560,
		0.0560, 0.0538, 0.0500, 0.0500, 0.0467, 0.0467, 0.0452, 0.0424, nil,    0.0400,
		0.0389, 0.0389, 0.0368, nil,    0.0350, 0.0341, 0.0333, 0.0326, 0.0318, 0.0304,
		0.0298, 0.0298, 0.0286, 0.0280, 0.0269, 0.0264, 0.0264, 0.0255, 0.0250, 0.0241,
		[60] = 0.0165,
	},
	["ROGUE"] = addon.zero,
	["PRIEST"] = {
		0.1909, 0.1826, 0.1750, 0.1680, 0.1556, 0.1500, 0.1448, 0.1400, 0.1355, 0.1273,
		0.1167, 0.1050, 0.0977, 0.0875, nil,    0.0764, 0.0700, 0.0667, nil,    0.0583,
		0.0560, 0.0525, nil,    0.0477, 0.0457, 0.0438, 0.0420, 0.0404, 0.0389, 0.0372,
		0.0359, 0.0347, 0.0336, 0.0323, 0.0313, 0.0304, 0.0294, 0.0286, nil,    0.0269,
		[60] = 0.0168,
	},
	["SHAMAN"] = {
		0.1286, 0.1227, 0.1174, 0.1174, 0.1125, 0.1080, 0.1038, 0.1000, 0.0964, 0.0964,
		0.0900, 0.0844, 0.0771, 0.0730, 0.0675, 0.0643, 0.0614, 0.0574, nil,    nil,
		[22] = 0.0482,
		[23] = 0.0458,
		[28] = 0.0380,
		[29] = 0.0370,
		[30] = 0.0355,
		[32] = 0.0333,
		[34] = 0.0314,
		[37] = 0.0287,
		[38] = 0.0278,
		[40] = 0.0262,
		[60] = 0.0169,
	},
	["MAGE"] = {
		0.1920, 0.1846, 0.1778, 0.1655, 0.1600, 0.1548, 0.1500, 0.1455, 0.1371, 0.1333,
		0.1231, 0.1091, 0.1021, 0.0857, 0.0787, 0.0750, nil,    0.0667, 0.0632, 0.0593,
		0.0571, 0.0539, 0.0522, 0.0495, 0.0475, 0.0457, 0.0436, 0.0397, 0.0381, 0.0366,
		0.0358, 0.0345, 0.0336, 0.0327, 0.0316, 0.0308, 0.0298, 0.0291, 0.0282, 0.0276,
		[60] = 0.0168,
	},
	["WARLOCK"] = {
		0.1500, 0.1435, 0.1375, 0.1320, 0.1269, 0.1222, 0.1179, 0.1138, 0.1100, 0.1065,
		0.0971, 0.0892, nil,    nil,    0.0717, 0.0688, 0.0635,    nil, 0.0569, 0.0541,
		0.0516, 0.0493, 0.0471, nil,    0.0429, 0.0418, 0.0398, 0.0384, 0.0367, 0.0355,
		0.0347, 0.0333, 0.0324, 0.0311, 0.0303, 0.0295, 0.0284, 0.0277, 0.0268, 0.0262,
		[60] = 0.0165,
	},
	["DRUID"] = {
		0.1455, 0.1391, nil,    0.1280, 0.1231, 0.1185, 0.1143, 0.1143, 0.1103, 0.1000,
		0.0941, 0.0865, 0.0821, 0.0762, 0.0696, 0.0667, 0.0627, 0.0604, nil,    0.0525,
		nil,    0.0485, nil,    nil,    0.0427, 0.0416, 0.0400, 0.0390, 0.0372, 0.0352,
		0.0344, 0.0330, 0.0323, 0.0314, 0.0302, 0.0296, 0.0288, 0.0281, 0.0274, 0.0260,
		[60] = 0.0167,
	},
}

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
		["ADD_AP_MOD_FERAL_AP"] = {
			-- Cat Form
			{
				["value"] = 1,
				["aura"] = 768,
				["group"] = addon.BuffGroup.Feral,
			},
			-- Bear Form
			{
				["value"] = 1,
				["aura"] = 5487,
				["group"] = addon.BuffGroup.Feral,
			},
			-- Dire Bear Form
			{
				["value"] = 1,
				["aura"] = 9634,
				["group"] = addon.BuffGroup.Feral,
			},
		},
		["ADD_AP_MOD_STR"] = {
			-- Base
			{
				["value"] = 2,
			},
		},
		["ADD_AP_MOD_AGI"] = {
			-- Druid: Cat Form - Buff
			{
				["value"] = 1,
				["aura"] = 768,
			},
		},
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 1.8000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.0625 * 5,
			},
		},
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			-- Talent: Reflection
			{
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
			-- Rune: Dreamstate
			{
				["known"] = 408258,
				["rune"] = true,
				["value"] = 0.5,
				["aura"] = 408261,
			}
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.9000,
			},
			-- Talent: Feline Swiftness (Cat Form)
			{
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["aura"] = 768,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 0.9000,
			},
			-- Talent: Sharpened Claws (Cat Form)
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["aura"] = 768,
			},
			-- Talent: Sharpened Claws (Bear Form)
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["aura"] = 5487,
			},
			-- Talent: Sharpened Claws (Dire Bear Form)
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["aura"] = 9634,
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
				["value"] = 1.8,
				["aura"] = 5487,		-- ["Bear Form"],
			},
			-- Druid: Dire Bear Form - Buff
			--        Shapeshift into a dire bear, increasing melee attack power by 180, armor contribution from items by 360%, and health by 1240.
			{
				["value"] = 3.6,
				["aura"] = 9634,		-- ["Dire Bear Form"],
			},
			-- Druid: Moonkin Form - Buff
			--        While in this form the armor contribution from items is increased by 360%, and all party members within 30 yards have their spell critical chance increased by 3%.
			{
				["value"] = 3.6,
				["aura"] = 24858,		-- ["Moonkin Form"],
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
				["aura"] = 5487,		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["aura"] = 9634,		-- ["Dire Bear Form"],
			},
		},
		["MOD_HEALTH"] = {
			-- Rune: Survival Instincts
			{
				["known"] = 408024,
				["rune"] = true,
				["value"] = 0.3,
				["aura"] = 408024,
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
				["aura"] = 768,		-- ["Cat Form"],
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
			-- Rune: Expose Weakness
			{
				["known"] = 409504,
				["rune"] = true,
				["value"] = 0.40,
				["aura"] = 409507,
			},
		},
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 3.6000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.125 * 5,
			},
		},
		["ADD_MANA_REG_MOD_MANA"] = {
			-- Buff: Aspect of the Viper
			{
				["value"] = 0.10 * 5/3,
				["aura"] = 415423,
				["rune"] = true,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.0000,
			},
			-- Buff: Aspect of the Monkey
			{
				["value"] = 8,
				["aura"] = 13163,
			},
			-- Talent: Improved Aspect of the Monkey (Aspect of the Monkey)
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["aura"] = 13163,
			},
			-- Buff: Deterrence
			{
				["value"] = 25,
				["aura"] = 19263,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 0.0000,
			},
			-- Talent: Killer Instinct
			{
				["tab"] = 3,
				["num"] = 13,
				["rank"] = {
					1, 2, 3,
				},
			},
			-- Rune: Master Marksman
			{
				["known"] = 409428,
				["rune"] = true,
				["value"] = 5,
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
		["MOD_STR"] = {
			-- Hunter: Heart of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["known"] = 409580,
				["rune"] = true,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_AGI"] = {
			-- Hunter: Lightning Reflexes (Rank 5) - 3,15
			--         Increases your Agility by 3%/6%/9%/12%/15%.
			{
				["tab"] = 3,
				["num"] = 15,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
			-- Hunter: Heart of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["known"] = 409580,
				["rune"] = true,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_STA"] = {
			-- Hunter: Heart of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["known"] = 409580,
				["rune"] = true,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_INT"] = {
			-- Hunter: Heart of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["known"] = 409580,
				["rune"] = true,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_SPI"] = {
			-- Hunter: Heart of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["known"] = 409580,
				["rune"] = true,
				["aura"] = 409580,
				["value"] = 0.1,
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
				["value"] = 3.2000,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 3.2000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
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
		["ADD_BONUS_ARMOR_MOD_INT"] = {
			{
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.5,
				},
			},
		},
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			-- Talent: Arcane Meditation
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
			-- Buff: Mage Armor
			{
				["value"] = 0.3,
				["aura"] = 6117,
			},
			-- Rune: Enlightenment
			{
				["known"] = 412324,
				["rune"] = true,
				["value"] = 0.1,
				["aura"] = 412325,
			},
			-- Rune: Arcane Surge
			{
				["known"] = 425124,
				["rune"] = true,
				["value"] = 1.0,
				["aura"] = 425124,
			},
		},
		["MOD_NORMAL_MANA_REG"] = {
			-- Arcane Surge
			{
				["known"] = 425124,
				["rune"] = true,
				["value"] = 3.00,
				["aura"] = 425124,
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
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 0.2000,
			},
			-- Rune: Burnout
			{
				["known"] = 412286,
				["rune"] = true,
				["value"] = 15,
			},
			-- Buff: Scroll of Arcane Power I
			{
				["aura"] = 430952,
				["value"] = 1,
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
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 3.5000,
			},
			-- Buff: Sanctified Orb
			{
				["aura"] = 24865,
				["value"] = 3,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.7000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.125 * 5,
			},
		},
		["ADD_MANA_REG_MOD_MANA"] = {
			-- Rune: Guarded by the Light
			{
				["known"] = 415059,
				["rune"] = true,
				["value"] = 0.05 * 5/3,
				["aura"] = 415058,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 0.7000,
			},
			-- Talent: Conviction
			{
				["tab"] = 3,
				["num"] = 7,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			-- Buff: Sanctified Orb
			{
				["aura"] = 24865,
				["value"] = 3,
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
		["ADD_SPELL_DMG_MOD_AP"] = {
			-- Rune: Sheath of Light
			{
				["known"] = 426158,
				["rune"] = true,
				["value"] = 0.30,
			},
		},
		["ADD_HEALING_MOD_AP"] = {
			-- Rune: Sheath of Light
			{
				["known"] = 426158,
				["rune"] = true,
				["value"] = 0.30,
			},
		},
		["MOD_BLOCK_VALUE"] = {
			-- Paladin: Shield Specialization (Rank 3) - 2,8
			--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
			-- Paladin: Aegis - Rune
			--   Increases your block value by 30%
			{
				["known"] = 425589,
				["rune"] = true,
				["value"] = 0.3,
			}
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
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 3.0000,
			},
		},
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 0.8000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.041667 * 5,
			},
		},
		["ADD_MANA_REG_MOD_MANA"] = {
			-- Rune: Dispersion
			{
				["known"] = 425294,
				["rune"] = true,
				["value"] = 0.3,
				["aura"] = 425294,
			},
		},
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
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 3.0000,
			},
			-- Buff: Elune's Grace (Night Elf Priest Racial)
			{
				["value"] = 10,
				["aura"] = 2651,
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
		["MOD_HEALTH"] = {
			-- Rune: Rolling with the Punches
			{
				["known"] = 400016,
				["rune"] = true,
				["value"] = 0.30,
				["aura"] = 400015,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 0.0000,
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
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 0.0000,
			},
			-- Talent: Malice
			{
				["tab"] = 1,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			-- Talent: Dagger Specialization
			{
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weapon"] = {
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
				["weapon"] = {
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
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 2.3000,
			},
		},
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.071429 * 5,
			},
		},
		["ADD_MANA_REG_MOD_INT"] = {
			-- Rune: Power Surge
			{
				["known"] = 415100,
				["rune"] = true,
				["value"] = 0.15,
			},
		},
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 1.7000,
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
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 1.7000,
			},
			-- Talent: Elemental Devastation
			{
				["tab"] = 1,
				["num"] = 11,
				["aura"] = 30165,
				["rank"] = {
					3, 6, 9,
				},
			},
			-- Talent: Thundering Strikes
			{
				["tab"] = 2,
				["num"] = 4,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		["MOD_AP"] = {
			-- Rune: Two-Handed Mastery
			{
				["known"] = 436364,
				["rune"] = true,
				["aura"] = 436365,
				["value"] = 0.10,
			},
			-- Rune: Spirit of the Alpha (Loyal Beta)
			{
				["known"] = 408696,
				["rune"] = true,
				["value"] = 0.20,
				["aura"] = 443320,
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
		["MOD_BLOCK_VALUE"] = {
			-- Shaman: Shield Specialization 5/5 - 2,2
			--         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
			{
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			-- Shaman: Shield Mastery - Rune
			--   You also always gain 10% increased chance to Block and 15% increased Block value.
			{
				["known"] = 408524,
				["rune"] = true,
				["value"] = 0.15,
			},
		},
		["ADD_MANA_REG_MOD_MANA"] = {
			-- Shaman: Water Shield - Rune
			--   The caster is surrounded by 3 globes of water, granting 1% of your maximum mana per 5 sec.
			{
				["known"] = 408510,
				["rune"] = true,
				["value"] = 0.01,
				["aura"] = 408510,
			},
			-- Rune: Shamanistic Rage
			{
				["known"] = 425336,
				["rune"] = true,
				["value"] = 0.25,
				["aura"] = 425336,
			},
		},
		["MOD_HEALTH"] = {
			-- Shaman: Way of Earth: Rune
			--   While Rockbiter Weapon is active on your main hand weapon, you gain 30% increased health
			{
				["known"] = 408531,
				["rune"] = true,
				["value"] = 0.3,
				["aura"] = 408680
			}
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
		["ADD_NORMAL_MANA_REG_MOD_SPI"] = {
			{
				["regen"] = NormalManaRegenPerSpi,
			},
		},
		["ADD_NORMAL_HEALTH_REG_MOD_SPI"] = {
			-- Base
			{
				["value"] = 0.045455 * 5,
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
		["ADD_SPELL_CRIT"] = {
			-- Base
			{
				["value"] = 1.7000,
			},
			-- Rune: Demonic Tactics
			{
				["known"] = 412727,
				["rune"] = true,
				["value"] = 10,
			},
			-- Rune: Demonic Grace
			{
				["known"] = 425463,
				["rune"] = true,
				["value"] = 30,
				["aura"] = 425463,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 2.0000,
			},
			-- Rune: Demonic Tactics
			{
				["known"] = 412727,
				["rune"] = true,
				["value"] = 10,
			},
			-- Rune: Demonic Grace
			{
				["known"] = 425463,
				["rune"] = true,
				["value"] = 30,
				["aura"] = 425463,
			},
		},
		["MOD_ARMOR"] = {
			-- Warlock: Metamorphosis - Rune
			--   Transform into a Demon, increasing Armor by 500%
			{
				["known"] = 403789,
				["rune"] = true,
				["value"] = 5.0,
				["aura"] = 403789,
			},
		},
		["ADD_DODGE"] = {
			-- Base
			{
				["value"] = 2.0000,
			},
			-- Rune: Demonic Grace
			{
				["known"] = 425463,
				["rune"] = true,
				["value"] = 30,
				["aura"] = 425463,
			},
			-- Rune: Dance of the Wicked
			--   You and your demon pet gain dodge chance equal to your spell critical strike chance.
			{
				["known"] = 412798,
				["rune"] = true,
				["aura"] = 412800,
				["tooltip"] = true,
				-- TODO: ADD_DODGE_MOD_SPELL_CRIT?
			}
		},
		-- Warlock: Demonic Pact - Rune
		--   Demonic Pact increases spell damage and healing by 10% of your spell damage
		["MOD_SPELL_DMG"] = {
			{
				["known"] = 425464,
				["rune"] = true,
				["value"] = 0.1,
				["aura"] = 425467,
			},
		},
		-- Warlock: Demonic Pact - Rune
		--   Demonic Pact increases spell damage and healing by 10% of your spell damage
		["MOD_HEALING"] = {
			{
				["known"] = 425464,
				["rune"] = true,
				["value"] = 0.1,
				["aura"] = 425467,
			},
		},
		["ADD_PET_STA_MOD_STA"] = {
			-- Base
			{
				["value"] = 0.75,
				["pet"] = true,
			},
		},
		["ADD_SPELL_DMG_MOD_PET_STA"] = {
			-- Rune: Demonic Knowledge
			{
				["known"] = 412732,
				["rune"] = true,
				["value"] = 0.10,
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
		["ADD_SPELL_DMG_MOD_PET_INT"] = {
			-- Rune: Demonic Knowledge
			{
				["known"] = 412732,
				["rune"] = true,
				["value"] = 0.10,
				["pet"] = true,
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
				["value"] = 0.0000,
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
				["value"] = 0.05,
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
				["aura"] = 12328,		-- ["Death Wish"],
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 0.0000,
			},
			-- Talent: Cruelty
			{
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					1, 2, 3, 4, 5,
				}
			},
			-- Talent: Axe Specialization
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weapon"] = {
					[Enum.ItemWeaponSubclass.Axe1H] = true,
					[Enum.ItemWeaponSubclass.Axe2H] = true,
				},
			},
			-- Talent: Polearm Specialization
			{
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["weapon"] = {
					[Enum.ItemWeaponSubclass.Polearm] = true,
				},
			},
			-- Berserker Stance
			{
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
				["value"] = 3,
			},
			-- Buff: Recklessness
			{
				["aura"] = 17538,
				["value"] = 100,
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
	}
end

if addon.playerRace == "NightElf" then
	StatLogic.StatModTable["NightElf"] = {
		-- Night Elf : Quickness - Racial
		--             Dodge chance increased by 1%.
		["ADD_DODGE"] = {
			{
				["value"] = 1,
			},
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
		-- Paladin: Lay on Hands (Rank 1/2) - Buff
		--          Armor increased by 15%/30%.
		{
			["rank"] = {
				0.15, 0.30,
			},
			["aura"] = 20236,
			["spellid"] = 20235,
		},
		-- Priest: Inspiration (Rank 1/2/3) - Buff
		--         Increases armor by 8%/16%/25%.
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["aura"] = 15363,
			["group"] = addon.BuffGroup.Armor,
		},
		-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
		--         Increases your armor value by 8%/16%/25%.
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["aura"] = 16237,
			["group"] = addon.BuffGroup.Armor,
			["spellid"] = 16240,
		},
	},
	["MOD_STR"] = {
		-- Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Greater Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Heart of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
			["rune"] = true,
		},
	},
	["MOD_AGI"] = {
		-- Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Greater Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Heart of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
			["rune"] = true,
		},
	},
	["MOD_STA"] = {
		-- Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Greater Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Heart of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
			["rune"] = true,
		},
	},
	["MOD_INT"] = {
		-- Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Greater Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Heart of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
			["rune"] = true,
		},
	},
	["MOD_SPI"] = {
		-- Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 20217,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Greater Blessing of Kings - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 25898,
			["group"] = addon.BuffGroup.AllStats,
		},
		-- Heart of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
			["rune"] = true,
		},
	},
	["MOD_HEALTH"] = {
		-- Rune: Rallying Cry
		{
			["aura"] = 426490,
			["value"] = 0.15,
			["rune"] = true,
		},
	},
	["ADD_MELEE_CRIT"] = {
		-- Buff: Leader of the Pack
		{
			["aura"] = 24932,
			["value"] = 3,
		},
		-- Buff: Rallying Cry of the Dragonslayer
		{
			["aura"] = 22888,
			["value"] = 5,
		},
		-- Buff: Songflower Serenade
		{
			["aura"] = 15366,
			["value"] = 5,
		},
		-- Buff: Fire Festival Fury
		{
			["aura"] = 29338,
			["value"] = 3,
		},
		-- Buff: Elixir of the Mongoose
		{
			["aura"] = 17538,
			["value"] = 2,
		},
		-- Buff: Boon of Blackfathom
		{
			["aura"] = 430947,
			["value"] = 2,
		},
		-- Set: Blood Tiger Harness
		{
			["set"] = 442,
			["pieces"] = 2,
			["value"] = 1,
		},
		-- Set: The Gladiator
		{
			["set"] = 1,
			["pieces"] = 5,
			["value"] = 1,
		},
		-- Set: The Defiler's Purpose
		{
			["set"] = 486,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Highlander's Purpose
		{
			["set"] = 471,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Defiler's Fortitude
		{
			["set"] = 484,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Defiler's Determination
		{
			["set"] = 483,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Highlander's Determination
		{
			["set"] = 469,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Defiler's Resolution
		{
			["set"] = 487,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Highlander's Resolution
		{
			["set"] = 467,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: The Highlander's Resolve
		{
			["set"] = 468,
			["pieces"] = 3,
			["value"] = 1,
		},
		-- Set: Lawbringer Armor
		{
			["set"] = 208,
			["pieces"] = 5,
			["value"] = 1,
		},
		-- Set: Black Dragon Mail
		{
			["set"] = 489,
			["pieces"] = 3,
			["value"] = 2,
		},
		-- Set: Irradiated Garments
		{
			["set"] = 1584,
			["pieces"] = 2,
			["value"] = 1,
		},
		-- Set: Insulated Leathers
		{
			["set"] = 1585,
			["pieces"] = 2,
			["value"] = 1,
		},
	},
	["ADD_SPELL_CRIT"] = {
		-- Buff: Moonkin Aura
		{
			["aura"] = 24907,
			["value"] = 3,
		},
		-- Buff: Rallying Cry of the Dragonslayer
		{
			["aura"] = 22888,
			["value"] = 10,
		},
		-- Buff: Songflower Serenade
		{
			["aura"] = 15366,
			["value"] = 5,
		},
		-- Buff: Slip'kik's Savvy
		{
			["aura"] = 22820,
			["value"] = 3,
		},
		-- Buff: Fire Festival Fury
		{
			["aura"] = 29338,
			["value"] = 3,
		},
		-- Buff: Spark of Inspiration
		{
			["aura"] = 438536,
			["value"] = 4,
		},
	},
	["ADD_DODGE"] = {
		-- Set: Overlord's Resolution
		{
			["set"] = 464,
			["pieces"] = 2,
			["value"] = 1,
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
		}
	},
}
