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

addon.CritPerAgi = {
	["WARRIOR"] = {
		[60] = 0.0500,
	},
	["PALADIN"] = {
		[60] = 0.0506,
	},
	["HUNTER"] = {
		[60] = 0.0189,
	},
	["ROGUE"] = {
		[60] = 0.0345,
	},
	["PRIEST"] = {
		[60] = 0.0500,
	},
	["SHAMAN"] = {
		[25] = 0.0971,
		[60] = 0.0508,
	},
	["MAGE"] = {
		[60] = 0.0514,
	},
	["WARLOCK"] = {
		[25] = 0.0909,
		[60] = 0.0500,
	},
	["DRUID"] = {
		[25] = 0.1025,
		[60] = 0.0500,
	},
}

addon.SpellCritPerInt = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = {
		[60] = 0.0167,
	},
	["HUNTER"] = {
		[60] = 0.0165,
	},
	["ROGUE"] = addon.zero,
	["PRIEST"] = {
		[60] = 0.0168,
	},
	["SHAMAN"] = {
		[60] = 0.0169,
	},
	["MAGE"] = {
		[60] = 0.0168,
	},
	["WARLOCK"] = {
		[25] = 0.0429,
		[60] = 0.0165,
	},
	["DRUID"] = {
		[25] = 0.0427,
		[60] = 0.0167,
	},
}

addon.DodgePerAgi = {
	["WARRIOR"] = {
		[60] = 0.0500,
	},
	["PALADIN"] = {
		[60] = 0.0506,
	},
	["HUNTER"] = {
		[60] = 0.0377,
	},
	["ROGUE"] = {
		[60] = 0.0690,
	},
	["PRIEST"] = {
		[60] = 0.0500,
	},
	["SHAMAN"] = {
		[25] = 0.0971,
		[60] = 0.0508,
	},
	["MAGE"] = {
		[60] = 0.0514,
	},
	["WARLOCK"] = {
		[25] = 0.0909,
		[60] = 0.0500,
	},
	["DRUID"] = {
		[25] = 0.1025,
		[60] = 0.0500,
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
				["rune"] = 6889,
				["slot"] = INVSLOT_CHEST,
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
			-- Hunter: Aspect of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["rune"] = 6891,
				["slot"] = INVSLOT_CHEST,
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
			-- Hunter: Aspect of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["rune"] = 6891,
				["slot"] = INVSLOT_CHEST,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_STA"] = {
			-- Hunter: Aspect of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["rune"] = 6891,
				["slot"] = INVSLOT_CHEST,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_INT"] = {
			-- Hunter: Aspect of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["rune"] = 6891,
				["slot"] = INVSLOT_CHEST,
				["aura"] = 409580,
				["value"] = 0.1,
			},
		},
		["MOD_SPI"] = {
			-- Hunter: Aspect of the Lion - Rune
			--   increasing total stats for the Hunter by an additional 10%
			{
				["rune"] = 6891,
				["slot"] = INVSLOT_CHEST,
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
			-- Mage: Arcane Meditation (Rank 3) - 1,12
			--       Allows 5/10/15% of your Mana regeneration to continue while casting.
			{
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
			},
			-- Mage: Mage Armor - Buff
			{
				["value"] = 0.3,
				["aura"] = 6117,		-- ["Mage Armor"],
			},
			-- Mage: Enlightenment - Rune
			--   While below 30% mana 10% of your mana regeneration continues while casting.
			{
				["rune"] = 6922,
				["slot"] = INVSLOT_CHEST,
				["value"] = 0.1,
				["aura"] = 412325,
			},
			-- Mage: Arcane Surge - Rune
			--   Afterward, your normal mana regeneration is activated and increased by 300% for 8 sec.
			{
				["rune"] = 7021,
				["slot"] = INVSLOT_LEGS,
				["value"] = 1.0,
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
				["rune"] = 6729,
				["slot"] = INVSLOT_CHEST,
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
		["ADD_BLOCK_VALUE_MOD_STR"] = {
			-- Base
			{
				["value"] = 0.05,
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Base
			{
				["value"] = 1.7000,
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
				["rune"] = 7041,
				["slot"] = INVSLOT_CHEST,
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
				["rune"] = 6876,
				["slot"] = INVSLOT_CHEST,
				["value"] = 0.15,
			},
		},
		["ADD_MANA_REG_MOD_MANA"] = {
			-- Shaman: Water Shield - Rune
			--   The caster is surrounded by 3 globes of water, granting 1% of your maximum mana per 5 sec.
			{
				["rune"] = 6875,
				["slot"] = INVSLOT_HAND,
				["value"] = 0.01,
				["aura"] = 408510,
			},
		},
		["MOD_HEALTH"] = {
			-- Shaman: Way of Earth: Rune
			--   While Rockbiter Weapon is active on your main hand weapon, you gain 30% increased health
			{
				["rune"] = 6886,
				["slot"] = INVSLOT_LEGS,
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
				["rune"] = 6952,
				["slot"] = INVSLOT_CHEST,
				["value"] = 10,
			},
			-- Rune: Demonic Grace
			{
				["rune"] = 7039,
				["slot"] = INVSLOT_LEGS,
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
				["rune"] = 6952,
				["slot"] = INVSLOT_CHEST,
				["value"] = 10,
			},
			-- Rune: Demonic Grace
			{
				["rune"] = 7039,
				["slot"] = INVSLOT_LEGS,
				["value"] = 30,
				["aura"] = 425463,
			},
		},
		["MOD_ARMOR"] = {
			-- Warlock: Metamorphosis - Rune
			--   Transform into a Demon, increasing Armor by 500%
			{
				["rune"] = 6816,
				["slot"] = INVSLOT_HAND,
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
				["rune"] = 7039,
				["slot"] = INVSLOT_LEGS,
				["value"] = 30,
				["aura"] = 425463,
			},
		},
		-- Warlock: Demonic Pact - Rune
		--   Demonic Pact increases spell damage and healing by 10% of your spell damage
		["MOD_SPELL_DMG"] = {
			{
				["rune"] = 7038,
				["slot"] = INVSLOT_LEGS,
				["value"] = 0.1,
				["aura"] = 425467,
			},
		},
		-- Warlock: Demonic Pact - Rune
		--   Demonic Pact increases spell damage and healing by 10% of your spell damage
		["MOD_HEALING"] = {
			{
				["rune"] = 7038,
				["slot"] = INVSLOT_LEGS,
				["value"] = 0.1,
				["aura"] = 425467,
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
		}
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
		-- Aspect of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
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
		-- Aspect of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
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
		-- Aspect of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
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
		-- Aspect of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
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
		-- Aspect of the Lion - Buff
		--   Increases stats by 10%.
		{
			["value"] = 0.1,
			["aura"] = 409583,
			["group"] = addon.BuffGroup.AllStats,
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
