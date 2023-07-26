local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

addon.RatingBase = {}

--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit for any class.
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
	["WARRIOR"] = 0,
	["PALADIN"] = 0.1,
	["HUNTER"] = 0.1,
	["ROGUE"] = 0,
	["PRIEST"] = 0.125,
	["SHAMAN"] = 0.1,
	["MAGE"] = 0.125,
	["WARLOCK"] = 0.1,
	["DRUID"] = 0.1125,
}

---@param spi integer
---@param class? string Defaults to player class
---@return number mp5nc Mana regen per 5 seconds when out of combat
---@return string statid
---@diagnostic disable-next-line:duplicate-set-field
function StatLogic:GetNormalManaRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	class = self:ValidateClass(class)
	-- Calculate
	return spi * NormalManaRegenPerSpi[class] * 5, "MANA_REG_NOT_CASTING"
end

addon.BaseMeleeCrit = {
	["WARRIOR"] = 0.0000,
	["PALADIN"] = 1.7000,
	["HUNTER"]  = 0.0000,
	["ROGUE"]   = 0.0000,
	["PRIEST"]  = 3.0000,
	["SHAMAN"]  = 1.7000,
	["MAGE"]    = 3.2000,
	["WARLOCK"] = 2.0000,
	["DRUID"]   = 0.9000,
}

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
		[60] = 0.0508,
	},
	["MAGE"] = {
		[60] = 0.0514,
	},
	["WARLOCK"] = {
		[60] = 0.0500,
	},
	["DRUID"] = {
		[60] = 0.0500,
	},
}

local zero = setmetatable({}, {
	__index = function()
		return 0
	end
})

addon.BaseSpellCrit = {
	["WARRIOR"] =  0.0000,
	["PALADIN"] =  3.5000,
	["HUNTER"]  =  3.6000,
	["ROGUE"]   =  0.0000,
	["PRIEST"]  =  0.8000,
	["SHAMAN"]  = -0.7000,
	["MAGE"]    = -4.8000,
	["WARLOCK"] = -0.3000,
	["DRUID"]   =  1.8000,
}

addon.SpellCritPerInt = {
	["WARRIOR"] = zero,
	["PALADIN"] = {
		[60] = 0.0167,
	},
	["HUNTER"] = {
		[60] = 0.0165,
	},
	["ROGUE"] = zero,
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
		[60] = 0.0165,
	},
	["DRUID"] = {
		[60] = 0.0167,
	},
}

addon.APPerStr = {
	["WARRIOR"] = 2,
	["PALADIN"] = 2,
	["HUNTER"] = 1,
	["ROGUE"] = 1,
	["PRIEST"] = 1,
	["SHAMAN"] = 2,
	["MAGE"] = 1,
	["WARLOCK"] = 1,
	["DRUID"] = 2,
}

addon.APPerAgi = {
	["WARRIOR"] = 0,
	["PALADIN"] = 0,
	["HUNTER"] = 1,
	["ROGUE"] = 1,
	["PRIEST"] = 0,
	["SHAMAN"] = 0,
	["MAGE"] = 0,
	["WARLOCK"] = 0,
	["DRUID"] = 0,
}

addon.RAPPerAgi = {
	["WARRIOR"] = 1,
	["PALADIN"] = 0,
	["HUNTER"] = 2,
	["ROGUE"] = 1,
	["PRIEST"] = 0,
	["SHAMAN"] = 0,
	["MAGE"] = 0,
	["WARLOCK"] = 0,
	["DRUID"] = 0,
}

addon.BaseDodge = {
	["WARRIOR"] = 0.0000,
	["PALADIN"] = 0.7000,
	["HUNTER"] = 0.0000,
	["ROGUE"] = 0.0000,
	["PRIEST"] = 3.0000,
	["SHAMAN"] = 1.7000,
	["MAGE"] = 3.2000,
	["WARLOCK"] = 2.0000,
	["DRUID"] = 0.9000,
}

addon.DodgePerAgiMaxLevel = {
	["WARRIOR"] = 0.0500,
	["PALADIN"] = 0.0506,
	["HUNTER"] = 0.0377,
	["ROGUE"] = 0.0690,
	["PRIEST"] = 0.0500,
	["SHAMAN"] = 0.0508,
	["MAGE"] = 0.0514,
	["WARLOCK"] = 0.0500,
	["DRUID"] = 0.0500,
}

addon.RegisterValidatorEvents()

local BuffGroup = {
	MOD_ARMOR = 1,
}

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
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
				["buff"] = 768,		-- ["Cat Form"],
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Sharpened Claws, Cat Form
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = 768,
			},
			-- Sharpened Claws, Bear Form
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = 5487,
			},
			-- Sharpened Claws, Dire Bear Form
			{
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = 9634,
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
				["buff"] = 5487,		-- ["Bear Form"],
			},
			-- Druid: Dire Bear Form - Buff
			--        Shapeshift into a dire bear, increasing melee attack power by 180, armor contribution from items by 360%, and health by 1240.
			{
				["value"] = 4.6,
				["buff"] = 9634,		-- ["Dire Bear Form"],
			},
			-- Druid: Moonkin Form - Buff
			--        While in this form the armor contribution from items is increased by 360%, and all party members within 30 yards have their spell critical chance increased by 3%.
			{
				["value"] = 4.6,
				["buff"] = 24858,		-- ["Moonkin Form"],
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
				["buff"] = 5487,		-- ["Bear Form"],
			},
			{
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.20,
				},
				["buff"] = 9634,		-- ["Dire Bear Form"],
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
				["buff"] = 768,		-- ["Cat Form"],
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
		["ADD_DODGE"] = {
			-- Hunter: Aspect of the Monkey - Buff
			--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.
			{
				["value"] = 8,
				["buff"] = 13163,		-- ["Aspect of the Monkey"],
			},
			-- Hunter: Improved Aspect of the Monkey (Rank 5) - 1,4
			--         Increases the Dodge bonus of your Aspect of the Monkey by 1/2/3/4/5%.
			{
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
				["buff"] = 13163,		-- ["Aspect of the Monkey"],
			},
			-- Hunter: Deterrence - Buff
			--         Dodge and Parry chance increased by 25%.
			{
				["value"] = 25,
				["buff"] = 19263,		-- ["Deterrence"],
			},
		},
		["ADD_MELEE_CRIT"] = {
			{
				["tab"] = 3,
				["num"] = 13,
				["rank"] = {
					1, 2, 3,
				},
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
elseif addon.class == "MAGE" then
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
				["value"] = 0.3,
				["buff"] = 6117,		-- ["Mage Armor"],
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
elseif addon.class == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
		["ADD_MELEE_CRIT"] = {
			-- Conviction
			{
				["tab"] = 3,
				["num"] = 7,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
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
elseif addon.class == "PRIEST" then
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
				["buff"] = 2651,		-- ["Elune's Grace"],
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
elseif addon.class == "ROGUE" then
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
				["value"] = 50,
				["buff"] = 5277,		-- ["Evasion"],
			},
			{
				["value"] = 15,
				["buff"] = 14278,		-- ["Ghostly Strike"],
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Malice
			{
				["tab"] = 1,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			-- Dagger Specialization
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
			-- Fist Weapon Specialization
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
elseif addon.class == "SHAMAN" then
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
		["ADD_MELEE_CRIT"] = {
			-- Elemental Devastation
			{
				["tab"] = 1,
				["num"] = 11,
				["buff"] = 30165,
				["rank"] = {
					3, 6, 9,
				},
			},
			-- Thundering Strikes
			{
				["tab"] = 2,
				["num"] = 4,
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
elseif addon.class == "WARLOCK" then
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
				["buff"] = 25228,		-- ["Soul Link"],
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
elseif addon.class == "WARRIOR" then
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
				["buff"] = 871,		-- ["Shield Wall"],
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
				["buff"] = 13847,		-- ["Recklessness"],
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
				["buff"] = 12328,		-- ["Death Wish"],
			},
		},
		["ADD_MELEE_CRIT"] = {
			-- Cruelty
			{
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					1, 2, 3, 4, 5,
				}
			},
			-- Axe Specialization
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
			-- Polearm Specialization
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
			["buff"] = 20236,		-- ["Lay on Hands"],
		},
		-- Priest: Inspiration (Rank 1/2/3) - Buff
		--         Increases armor by 8%/16%/25%.
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["buff"] = 15363,		-- ["Inspiration"],
			["group"] = BuffGroup.MOD_ARMOR,
		},
		-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
		--         Increases your armor value by 8%/16%/25%.
		{
			["rank"] = {
				0.08, 0.16, 0.25,
			},
			["buff"] = 16237,		-- ["Ancestral Fortitude"],
			["group"] = BuffGroup.MOD_ARMOR,
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_STR"] = {
		{
			["value"] = 0.1,
			["buff"] = 20217,		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = 25898,		-- ["Greater Blessing of Kings"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_AGI"] = {
		{
			["value"] = 0.1,
			["buff"] = 20217,		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = 25898,		-- ["Greater Blessing of Kings"],
		},
	},
	-- Blessing of Kings - Buff
	-- Increases stats by 10%.
	-- Greater Blessing of Kings - Buff
	-- Increases stats by 10%.
	["MOD_STA"] = {
		{
			["value"] = 0.1,
			["buff"] = 20217,		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = 25898,		-- ["Greater Blessing of Kings"],
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
			["buff"] = 20217,		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = 25898,		-- ["Greater Blessing of Kings"],
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
			["buff"] = 20217,		-- ["Blessing of Kings"],
		},
		{
			["value"] = 0.1,
			["buff"] = 25898,		-- ["Greater Blessing of Kings"],
		},
	},
	["ADD_MELEE_CRIT"] = {
		-- Leader of the Pack
		{
			["buff"] = 24932,
			["value"] = 3,
		},
		-- Rallying Cry of the Dragonslayer
		{
			["buff"] = 22888,
			["value"] = 5,
		},
	},
	["ADD_SPELL_CRIT"] = {
		-- Moonkin Aura
		{
			["buff"] = 24907,
			["value"] = 3,
		},
		-- Rallying Cry of the Dragonslayer
		{
			["buff"] = 22888,
			["value"] = 10,
		},
	}
}
