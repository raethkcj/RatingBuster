--[[
Name: RatingBuster
Revision: $Revision: 78903 $
Author: Whitetooth, raethkcj
Description: Converts combat ratings in tooltips into normal percentages.
]]

---------------
-- Libraries --
---------------
local TipHooker = LibStub("TipHooker-1.0")
local StatLogic = LibStub("StatLogic-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RatingBuster")
local BI = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()


--------------------
-- AceAddon Setup --
--------------------
-- AceAddon Initialization
RatingBuster = LibStub("AceAddon-3.0"):NewAddon("RatingBuster", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
RatingBuster.title = "Rating Buster"
RatingBuster.version = "1.3.8 (r"..gsub("$Revision: 78903 $", "(%d+)", "%1")..")"
RatingBuster.date = gsub("$Date: 2008-07-22 15:35:19 +0800 (星期二, 22 七月 2008) $", "^.-(%d%d%d%d%-%d%d%-%d%d).-$", "%1")

-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection
local function clearCache()
	for k in pairs(cache) do
		cache[k] = nil
	end
end
--debug
--RatingBuster.cache = cache


---------------------
-- Local Variables --
---------------------
local _
local _, class = UnitClass("player")
local calcLevel, playerLevel
local profileDB, profileDB -- Initialized in :OnInitialize()


-- Localize globals
local _G = getfenv(0)
local strfind = strfind
local strsub = strsub
local gsub = gsub
local pairs = pairs
local ipairs = ipairs
local type = type
local select = select
local tinsert = tinsert
local tremove = tremove
local tsort = table.sort
local strsplit = strsplit
local strjoin = strjoin
local unpack = unpack
local tonumber = tonumber
local UnitStat = UnitStat
local wowBuildNo = select(2, GetBuildInfo())

local GetItemInfoCached = setmetatable({}, { __index = function(self, n)
	self[n] = {GetItemInfo(n)} -- store in cache
	return self[n] -- return result
end })
local GetItemInfo = function(item)
	return unpack(GetItemInfoCached[item])
end
local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance

---------------------
-- Saved Variables --
---------------------
-- Default values
local defaults = {
	profile = {
		showItemLevel = true,
		showItemID = false,
		useRequiredLevel = true,
		customLevel = 0,
		textColor = {r = 1.0, g = 0.996,  b = 0.545, hex = "|cfffffe8b"},
		enableTextColor = true,
		enableStatMods = true,
		showRatings = true,
		detailedConversionText = false,
		defBreakDown = false,
		wpnBreakDown = false,
		expBreakDown = false,
		showStats = true,
		showSum = true,
		sumIgnoreUnused = true,
		sumIgnoreEquipped = false,
		sumIgnoreEnchant = true,
		sumIgnoreGems = false,
		sumBlankLine = true,
		sumBlankLineAfter = false,
		sumShowIcon = true,
		sumShowTitle = true,
		sumDiffStyle = "main",
		sumSortAlpha = false,
		sumAvoidWithBlock = false,
		showZeroValueStat = false,
		calcDiff = true,
		calcSum = true,
		--[[
		Str -> AP, Block, Healing
		Agi -> Crit, Dodge, AP, RAP, Armor
		Sta -> Health, SpellDmg
		Int -> Mana, SpellCrit, SpellDmg, Healing, MP5, RAP, Armor
		Spi -> MP5, MP5NC, HP5, SpellDmg, Healing
		--]]
		-- Base stat conversions
		showAPFromStr = false,
		showBlockValueFromStr = false,

		showCritFromAgi = true,
		showDodgeFromAgi = true,
		showAPFromAgi = false,
		showRAPFromAgi = false,
		showArmorFromAgi = false,
		showHealingFromAgi = false, -- Druid - Nurturing Instinct

		showHealthFromSta = false,
		showSpellDmgFromSta = false, -- Warlock

		showManaFromInt = false,
		showSpellCritFromInt = true,
		showSpellDmgFromInt = false, -- Druid, Mage, Paladin, Shaman, Warlock
		showHealingFromInt = false, -- Druid, Paladin, Shaman
		showMP5FromInt = false, 
		showMP5NCFromInt = false,
		showRAPFromInt = false, -- Hunter
		showArmorFromInt = false, -- Mage

		showMP5FromSpi = false, -- Druid, Mage, Priest
		showMP5NCFromSpi = false,
		showHP5FromSpi = false,
		showSpellDmgFromSpi = false, -- Priest
		showHealingFromSpi = false, -- Priest
		------------------
		-- Stat Summary --
		------------------
		-- Basic
		sumHP = false,
		sumMP = false,
		sumMP5 = false,
		sumMP5NC = false,
		sumHP5 = false,
		sumHP5OC = false,
		sumStr = false,
		sumAgi = false,
		sumSta = false,
		sumInt = false,
		sumSpi = false,
		-- Physical
		sumAP = false,
		sumRAP = false,
		sumFAP = false,
		sumHit = false,
		sumHitRating = false, -- new
		sumCrit = false,
		sumCritRating = false, -- new
		sumHaste = false, -- new
		sumHasteRating = false, -- new
		sumExpertise = false,
		sumWeaponSkill = false,
		sumDodgeNeglect = false,
		sumParryNeglect = false,
		sumBlockNeglect = false,
		sumWeaponMaxDamage = false,
		sumWeaponDPS = false,
		sumIgnoreArmor = false, -- new
		-- Spell
		sumSpellDmg = false,
		sumArcaneDmg = false,
		sumFrostDmg = false,
		sumNatureDmg = false,
		sumFireDmg = false,
		sumShadowDmg = false,
		sumHolyDmg = false,
		sumHealing = false,
		sumSpellHit = false,
		sumSpellHitRating = false, -- new
		sumSpellCrit = false,
		sumSpellCritRating = false, -- new
		sumSpellHaste = false, -- new
		sumSpellHasteRating = false, -- new
		sumPenetration = false, -- new
		-- Tank
		sumArmor = false,
		sumDodge = false,
		sumDodgeRating = false, -- new
		sumParry = false,
		sumParryRating = false, -- new
		sumBlock = false,
		sumBlockRating = false, -- new
		sumBlockValue = false,
		sumHitAvoid = false,
		sumCritAvoid = false,
		sumArcaneResist = false,
		sumFrostResist = false,
		sumNatureResist = false,
		sumFireResist = false,
		sumShadowResist = false,
		sumResilience = false, -- new
		sumDefense = false,
		sumTankPoints = false,
		sumTotalReduction = false,
		sumAvoidance = false,
		-- Gems
		sumGemRed = {
			itemID = nil,
			gemID = nil,
			gemText = nil,
		};
		sumGemYellow = {
			itemID = nil,
			gemID = nil,
			gemText = nil,
		};
		sumGemBlue = {
			itemID = nil,
			gemID = nil,
			gemText = nil,
		};
		sumGemMeta = {
			itemID = nil,
			gemID = nil,
			gemText = nil,
		};
	}
}



---------------------------
-- Slash Command Options --
---------------------------

local function getProfileOption(info, value)
	return profileDB[info[#info]]
end
local function setProfileOptionAndClearCache(info, value)
	profileDB[info[#info]] = value
	clearCache()
end
local function getGem(info)
	return profileDB[info[#info]].gemLink
end
local function setGem(info, value)
	if value == "" then
		profileDB[info[#info]].itemID = nil
		profileDB[info[#info]].gemID = nil
		profileDB[info[#info]].gemName = nil
		profileDB[info[#info]].gemLink = nil
		return
	end
	local gemID, gemText = StatLogic:GetGemID(value)
	if gemID and gemText then
		local name, link = GetItemInfo(value)
		local itemID = link:match("item:(%d+)")
		profileDB[info[#info]].itemID = itemID
		profileDB[info[#info]].gemID = gemID
		profileDB[info[#info]].gemName = name
		profileDB[info[#info]].gemLink = link
		-- Trim spaces
		gemText = strtrim(gemText)
		-- Strip color codes
		if strsub(gemText, -2) == "|r" then
			gemText = strsub(gemText, 1, -3)
		end
		if strfind(strsub(gemText, 1, 10), "|c%x%x%x%x%x%x%x%x") then
			gemText = strsub(gemText, 11)
		end
		profileDB[info[#info]].gemText = gemText
		clearCache()
		local socket = strsub(info[#info], 7).." Socket"
		if not debugstack():find("AceConsole") then
			RatingBuster:Print(L["%s is now set to %s"]:format(L[socket], link))
		end
	else
		RatingBuster:Print(L["Queried server for Gem: %s. Try again in 5 secs."]:format(value))
	end
end

local options = {
	type = 'group',
	get = getProfileOption,
	set = setProfileOptionAndClearCache,
	args = {
		help = {
			type = 'execute',
			name = L["Help"],
			desc = L["Show this help message"],
			func = function()
				LibStub("AceConfigCmd-3.0").HandleCommand("RatingBuster", "rb", "RatingBuster", "")
			end
		},
		enableStatMods = {
			type = 'toggle',
			name = L["Enable Stat Mods"],
			desc = L["Enable support for Stat Mods"],
		},
		showItemID = {
			type = 'toggle',
			name = L["Show ItemID"],
			desc = L["Show the ItemID in tooltips"],
		},
		showItemLevel = {
			type = 'toggle',
			name = L["Show ItemLevel"],
			desc = L["Show the ItemLevel in tooltips"],
		},
		useRequiredLevel = {
			type = 'toggle',
			name = L["Use required level"],
			desc = L["Calculate using the required level if you are below the required level"],
		},
		customLevel = {
			type = 'range',
			name = L["Set level"],
			desc = L["Set the level used in calculations (0 = your level)"],
			min = 0,
			max = 73, -- set to level cap + 3
			step = 1,
		},
		rating = {
			type = 'group',
			name = L["Rating"],
			desc = L["Options for Rating display"],
			args = {
				showRatings = {
					type = 'toggle',
					name = L["Show Rating conversions"],
					desc = L["Show Rating conversions in tooltips"],
				},
				detailedConversionText = {
					type = 'toggle',
					name = L["Show detailed conversions text"],
					desc = L["Show detailed text for Resiliance and Expertise conversions"],
				},
				defBreakDown = {
					type = 'toggle',
					name = L["Defense breakdown"],
					desc = L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"],
				},
				wpnBreakDown = {
					type = 'toggle',
					name = L["Weapon Skill breakdown"],
					desc = L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"],
				},
				expBreakDown = {
					type = 'toggle',
					name = L["Expertise breakdown"],
					desc = L["Convert Expertise into Dodge Neglect and Parry Neglect"],
				},
				color = {
					type = 'group',
					name = L["Change text color"],
					desc = L["Changes the color of added text"],
					args = {
						pick = {
							type = 'execute',
							name = L["Pick color"],
							desc = L["Pick a color"],
							func = function()
								CloseMenus()
								ColorPickerFrame.func = function()
									profileDB.textColor.r, profileDB.textColor.g, profileDB.textColor.b = ColorPickerFrame:GetColorRGB();
									profileDB.textColor.hex = "|cff"..string.format("%02x%02x%02x", profileDB.textColor.r * 255, profileDB.textColor.g * 255, profileDB.textColor.b * 255)
									-- clear cache
									clearCache()
								end
								ColorPickerFrame:SetColorRGB(profileDB.textColor.r, profileDB.textColor.g, profileDB.textColor.b);
								ColorPickerFrame.previousValues = {r = profileDB.textColor.r, g = profileDB.textColor.g, b = profileDB.textColor.b};
								ColorPickerFrame:Show()
							end,
						},
						enableTextColor = {
							type = 'toggle',
							name = L["Enable color"],
							desc = L["Enable colored text"],
						},
					},
				},
			},
		},
		stat = {
			type = 'group',
			name = L["Stat Breakdown"],
			desc = L["Changes the display of base stats"],
			args = {
				showStats = {
					type = 'toggle',
					name = L["Show base stat conversions"],
					desc = L["Show base stat conversions in tooltips"],
				},
				str = {
					type = 'group',
					name = L["Strength"],
					desc = L["Changes the display of Strength"],
					args = {
						showAPFromStr = {
							type = 'toggle',
							name = L["Show Attack Power"],
							desc = L["Show Attack Power from Strength"],
						},
						showBlockValueFromStr = {
							type = 'toggle',
							name = L["Show Block Value"],
							desc = L["Show Block Value from Strength"],
						},
					},
				},
				agi = {
					type = 'group',
					name = L["Agility"],
					desc = L["Changes the display of Agility"],
					args = {
						showCritFromAgi = {
							type = 'toggle',
							name = L["Show Crit"],
							desc = L["Show Crit chance from Agility"],
						},
						showDodgeFromAgi = {
							type = 'toggle',
							name = L["Show Dodge"],
							desc = L["Show Dodge chance from Agility"],
						},
						showAPFromAgi = {
							type = 'toggle',
							name = L["Show Attack Power"],
							desc = L["Show Attack Power from Agility"],
						},
						showRAPFromAgi = {
							type = 'toggle',
							name = L["Show Ranged Attack Power"],
							desc = L["Show Ranged Attack Power from Agility"],
						},
						showArmorFromAgi = {
							type = 'toggle',
							name = L["Show Armor"],
							desc = L["Show Armor from Agility"],
						},
					},
				},
				sta = {
					type = 'group',
					name = L["Stamina"],
					desc = L["Changes the display of Stamina"],
					args = {
						showHealthFromSta = {
							type = 'toggle',
							name = L["Show Health"],
							desc = L["Show Health from Stamina"],
						},
					},
				},
				int = {
					type = 'group',
					name = L["Intellect"],
					desc = L["Changes the display of Intellect"],
					args = {
						showSpellCritFromInt = {
							type = 'toggle',
							name = L["Show Spell Crit"],
							desc = L["Show Spell Crit chance from Intellect"],
						},
						showManaFromInt = {
							type = 'toggle',
							name = L["Show Mana"],
							desc = L["Show Mana from Intellect"],
						},
						showMP5FromInt = {
							type = 'toggle',
							name = L["Show Mana Regen"],
							desc = L["Show Mana Regen while casting from Intellect"],
						},
						showMP5NCFromInt = {
							type = 'toggle',
							name = L["Show Mana Regen while NOT casting"],
							desc = L["Show Mana Regen while NOT casting from Intellect"],
						},
					},
				},
				spi = {
					type = 'group',
					name = L["Spirit"],
					desc = L["Changes the display of Spirit"],
					args = {
						showMP5NCFromSpi = {
							type = 'toggle',
							name = L["Show Mana Regen while NOT casting"],
							desc = L["Show Mana Regen while NOT casting from Spirit"],
						},
						showHP5FromSpi = {
							type = 'toggle',
							name = L["Show Health Regen"],
							desc = L["Show Health Regen from Spirit"],
						},
					},
				},
			},
		},
		sum = {
			type = 'group',
			name = L["Stat Summary"],
			desc = L["Options for stat summary"],
			args = {
				showSum = {
					type = 'toggle',
					name = L["Show stat summary"],
					desc = L["Show stat summary in tooltips"],
				},
				ignore = {
					type = 'group',
					name = L["Ignore settings"],
					desc = L["Ignore stuff when calculating the stat summary"],
					args = {
						sumIgnoreUnused = {
							type = 'toggle',
							name = L["Ignore unused items types"],
							desc = L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"],
						},
						sumIgnoreEquipped = {
							type = 'toggle',
							name = L["Ignore equipped items"],
							desc = L["Hide stat summary for equipped items"],
						},
						sumIgnoreEnchant = {
							type = 'toggle',
							name = L["Ignore enchants"],
							desc = L["Ignore enchants on items when calculating the stat summary"],
						},
						sumIgnoreGems = {
							type = 'toggle',
							name = L["Ignore gems"],
							desc = L["Ignore gems on items when calculating the stat summary"],
						},
					},
				},
				sumDiffStyle = {
					type = 'select',
					name = L["Display style for diff value"],
					desc = L["Display diff values in the main tooltip or only in compare tooltips"],
					values = {
						["comp"] = "Compare",
						["main"] = "Main"
					},
				},
				space = {
					type = 'group',
					name = L["Add empty line"],
					desc = L["Add a empty line before or after stat summary"],
					args = {
						sumBlankLine = {
							type = 'toggle',
							name = L["Add before summary"],
							desc = L["Add a empty line before stat summary"],
						},
						sumBlankLineAfter = {
							type = 'toggle',
							name = L["Add after summary"],
							desc = L["Add a empty line after stat summary"],
						},
					},
				},
				sumShowIcon = {
					type = 'toggle',
					name = L["Show icon"],
					desc = L["Show the sigma icon before summary listing"],
				},
				sumShowTitle = {
					type = 'toggle',
					name = L["Show title text"],
					desc = L["Show the title text before summary listing"],
				},
				showZeroValueStat = {
					type = 'toggle',
					name = L["Show zero value stats"],
					desc = L["Show zero value stats in summary for consistancy"],
				},
				calcSum = {
					type = 'toggle',
					name = L["Calculate stat sum"],
					desc = L["Calculate the total stats for the item"],
				},
				calcDiff = {
					type = 'toggle',
					name = L["Calculate stat diff"],
					desc = L["Calculate the stat difference for the item and equipped items"],
				},
				sumSortAlpha = {
					type = 'toggle',
					name = L["Sort StatSummary alphabetically"],
					desc = L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"],
				},
				sumAvoidWithBlock = {
					type = 'toggle',
					name = L["Include block chance in Avoidance summary"],
					desc = L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"],
				},
				basic = {
					type = 'group',
					name = L["Stat - Basic"],
					desc = L["Choose basic stats for summary"],
					args = {
						sumHP = {
							type = 'toggle',
							name = L["Sum Health"],
							desc = L["Health <- Health, Stamina"],
						},
						sumMP = {
							type = 'toggle',
							name = L["Sum Mana"],
							desc = L["Mana <- Mana, Intellect"],
						},
						sumMP5 = {
							type = 'toggle',
							name = L["Sum Mana Regen"],
							desc = L["Mana Regen <- Mana Regen, Spirit"],
						},
						sumMP5NC = {
							type = 'toggle',
							name = L["Sum Mana Regen while not casting"],
							desc = L["Mana Regen while not casting <- Spirit"],
						},
						sumHP5 = {
							type = 'toggle',
							name = L["Sum Health Regen"],
							desc = L["Health Regen <- Health Regen"],
						},
						sumHP5OC = {
							type = 'toggle',
							name = L["Sum Health Regen when out of combat"],
							desc = L["Health Regen when out of combat <- Spirit"],
						},
						sumStr = {
							type = 'toggle',
							name = L["Sum Strength"],
							desc = L["Strength Summary"],
						},
						sumAgi = {
							type = 'toggle',
							name = L["Sum Agility"],
							desc = L["Agility Summary"],
						},
						sumSta = {
							type = 'toggle',
							name = L["Sum Stamina"],
							desc = L["Stamina Summary"],
						},
						sumInt = {
							type = 'toggle',
							name = L["Sum Intellect"],
							desc = L["Intellect Summary"],
						},
						sumSpi = {
							type = 'toggle',
							name = L["Sum Spirit"],
							desc = L["Spirit Summary"],
						},
					},
				},
				physical = {
					type = 'group',
					name = L["Stat - Physical"],
					desc = L["Choose physical damage stats for summary"],
					args = {
						sumAP = {
							type = 'toggle',
							name = L["Sum Attack Power"],
							desc = L["Attack Power <- Attack Power, Strength, Agility"],
						},
						sumRAP = {
							type = 'toggle',
							name = L["Sum Ranged Attack Power"],
							desc = L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"],
						},
						sumFAP = {
							type = 'toggle',
							name = L["Sum Feral Attack Power"],
							desc = L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"],
						},
						sumHit = {
							type = 'toggle',
							name = L["Sum Hit Chance"],
							desc = L["Hit Chance <- Hit Rating, Weapon Skill Rating"],
						},
						sumHitRating = {
							type = 'toggle',
							name = L["Sum Hit Rating"],
							desc = L["Hit Rating Summary"],
						},
						sumCrit = {
							type = 'toggle',
							name = L["Sum Crit Chance"],
							desc = L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"],
						},
						sumCritRating = {
							type = 'toggle',
							name = L["Sum Crit Rating"],
							desc = L["Crit Rating Summary"],
						},
						sumHaste = {
							type = 'toggle',
							name = L["Sum Haste"],
							desc = L["Haste <- Haste Rating"],
						},
						sumHasteRating = {
							type = 'toggle',
							name = L["Sum Haste Rating"],
							desc = L["Haste Rating Summary"],
						},
						sumDodgeNeglect = {
							type = 'toggle',
							name = L["Sum Dodge Neglect"],
							desc = L["Dodge Neglect <- Expertise, Weapon Skill Rating"],
						},
						sumParryNeglect = {
							type = 'toggle',
							name = L["Sum Parry Neglect"],
							desc = L["Parry Neglect <- Expertise, Weapon Skill Rating"],
						},
						sumBlockNeglect = {
							type = 'toggle',
							name = L["Sum Block Neglect"],
							desc = L["Block Neglect <- Weapon Skill Rating"],
						},
						sumWeaponSkill = {
							type = 'toggle',
							name = L["Sum Weapon Skill"],
							desc = L["Weapon Skill <- Weapon Skill Rating"],
						},
						sumExpertise = {
							type = 'toggle',
							name = L["Sum Expertise"],
							desc = L["Expertise <- Expertise Rating"],
						},
						sumWeaponMaxDamage = {
							type = 'toggle',
							name = L["Sum Weapon Max Damage"],
							desc = L["Weapon Max Damage Summary"],
						},
						--[[
						weapondps = {
						type = 'toggle',
						name = L["Sum Weapon DPS"],
						desc = L["Weapon DPS Summary"],
						get = function() return profileDB.sumWeaponDPS end,
						set = function(v)
						profileDB.sumWeaponDPS = v
						-- clear cache
						clearCache()
						end,
						},
						--]]
						sumIgnoreArmor = {
							type = 'toggle',
							name = L["Sum Ignore Armor"],
							desc = L["Ignore Armor Summary"],
						},
					},
				},
				spell = {
					type = 'group',
					name = L["Stat - Spell"],
					desc = L["Choose spell damage and healing stats for summary"],
					args = {
						sumSpellDmg = {
							type = 'toggle',
							name = L["Sum Spell Damage"],
							desc = L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"],
						},
						sumHolyDmg = {
							type = 'toggle',
							name = L["Sum Holy Spell Damage"],
							desc = L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"],
						},
						sumArcaneDmg = {
							type = 'toggle',
							name = L["Sum Arcane Spell Damage"],
							desc = L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"],
						},
						sumFireDmg = {
							type = 'toggle',
							name = L["Sum Fire Spell Damage"],
							desc = L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"],
						},
						sumNatureDmg = {
							type = 'toggle',
							name = L["Sum Nature Spell Damage"],
							desc = L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"],
						},
						sumFrostDmg = {
							type = 'toggle',
							name = L["Sum Frost Spell Damage"],
							desc = L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"],
						},
						sumShadowDmg = {
							type = 'toggle',
							name = L["Sum Shadow Spell Damage"],
							desc = L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"],
						},
						sumHealing = {
							type = 'toggle',
							name = L["Sum Healing"],
							desc = L["Healing <- Healing, Intellect, Spirit, Agility, Strength"],
						},
						sumSpellHit = {
							type = 'toggle',
							name = L["Sum Spell Hit Chance"],
							desc = L["Spell Hit Chance <- Spell Hit Rating"],
						},
						sumSpellHitRating = {
							type = 'toggle',
							name = L["Sum Spell Hit Rating"],
							desc = L["Spell Hit Rating Summary"],
						},
						sumSpellCrit = {
							type = 'toggle',
							name = L["Sum Spell Crit Chance"],
							desc = L["Spell Crit Chance <- Spell Crit Rating, Intellect"],
						},
						sumSpellCritRating = {
							type = 'toggle',
							name = L["Sum Spell Crit Rating"],
							desc = L["Spell Crit Rating Summary"],
						},
						sumSpellHaste = {
							type = 'toggle',
							name = L["Sum Spell Haste"],
							desc = L["Spell Haste <- Spell Haste Rating"],
						},
						sumSpellHasteRating = {
							type = 'toggle',
							name = L["Sum Spell Haste Rating"],
							desc = L["Spell Haste Rating Summary"],
						},
						sumPenetration = {
							type = 'toggle',
							name = L["Sum Penetration"],
							desc = L["Spell Penetration Summary"],
						},
					},
				},
				tank = {
					type = 'group',
					name = L["Stat - Tank"],
					desc = L["Choose tank stats for summary"],
					args = {
						sumArmor = {
							type = 'toggle',
							name = L["Sum Armor"],
							desc = L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"],
						},
						sumDefense = {
							type = 'toggle',
							name = L["Sum Defense"],
							desc = L["Defense <- Defense Rating"],
						},
						sumDodge = {
							type = 'toggle',
							name = L["Sum Dodge Chance"],
							desc = L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"],
						},
						sumDodgeRating = {
							type = 'toggle',
							name = L["Sum Dodge Rating"],
							desc = L["Dodge Rating Summary"],
						},
						sumParry = {
							type = 'toggle',
							name = L["Sum Parry Chance"],
							desc = L["Parry Chance <- Parry Rating, Defense Rating"],
						},
						sumParryRating = {
							type = 'toggle',
							name = L["Sum Parry Rating"],
							desc = L["Parry Rating Summary"],
						},
						sumBlock = {
							type = 'toggle',
							name = L["Sum Block Chance"],
							desc = L["Block Chance <- Block Rating, Defense Rating"],
						},
						sumBlockRating = {
							type = 'toggle',
							name = L["Sum Block Rating"],
							desc = L["Block Rating Summary"],
						},
						sumBlockValue = {
							type = 'toggle',
							name = L["Sum Block Value"],
							desc = L["Block Value <- Block Value, Strength"],
						},
						sumHitAvoid = {
							type = 'toggle',
							name = L["Sum Hit Avoidance"],
							desc = L["Hit Avoidance <- Defense Rating"],
						},
						sumCritAvoid = {
							type = 'toggle',
							name = L["Sum Crit Avoidance"],
							desc = L["Crit Avoidance <- Defense Rating, Resilience"],
						},
						sumResilience = {
							type = 'toggle',
							name = L["Sum Resilience"],
							desc = L["Resilience Summary"],
						},
						sumArcaneResist = {
							type = 'toggle',
							name = L["Sum Arcane Resistance"],
							desc = L["Arcane Resistance Summary"],
						},
						sumFireResist = {
							type = 'toggle',
							name = L["Sum Fire Resistance"],
							desc = L["Fire Resistance Summary"],
						},
						sumNatureResist = {
							type = 'toggle',
							name = L["Sum Nature Resistance"],
							desc = L["Nature Resistance Summary"],
						},
						sumFrostResist = {
							type = 'toggle',
							name = L["Sum Frost Resistance"],
							desc = L["Frost Resistance Summary"],
						},
						sumShadowResist = {
							type = 'toggle',
							name = L["Sum Shadow Resistance"],
							desc = L["Shadow Resistance Summary"],
						},
						sumAvoidance = {
							type = 'toggle',
							name = L["Sum Avoidance"],
							desc = L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"],
						},
					},
				},
				gem = {
					type = 'group',
					name = L["Gems"],
					desc = L["Auto fill empty gem slots"],
					args = {
						sumGemRed = {
							type = 'input',
							name = L["Red Socket"],
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 1,
						},
						sumGemYellow = {
							type = 'input',
							name = L["Yellow Socket"],
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 2,
						},
						sumGemBlue = {
							type = 'input',
							name = L["Blue Socket"],
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 3,
						},
						sumGemMeta = {
							type = 'input',
							name = L["Meta Socket"],
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 4,
						},
					},
				},
			},
		},
	},
}

-- TankPoints support, version check
local tpSupport
local tpLocale
if TankPoints and (tonumber(strsub(TankPoints.version, 1, 3)) >= 2.6) then
	tpSupport = true
	tpLocale = LibStub("AceLocale-3.0"):GetLocale("TankPoints", true)
	options.args.sum.args.tank.args.sumTankPoints = {
		type = 'toggle',
		name = L["Sum TankPoints"],
		desc = L["TankPoints <- Health, Total Reduction"],
	}
	options.args.sum.args.tank.args.sumTotalReduction = {
		type = 'toggle',
		name = L["Sum Total Reduction"],
		desc = L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"],
	}
	--[[
	options.args.sum.args.tank.args.sumAvoidance = {
		type = 'toggle',
		name = L["Sum Avoidance"],
		desc = L["Avoidance <- Dodge, Parry, MobMiss"],
	}
	--]]
end

-- Class specific settings
if class == "DRUID" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumFAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumDodge = true
	defaults.profile.sumArmor = true
	defaults.profile.sumResilience = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.sumMP5 = true
	defaults.profile.showHealingFromAgi = true
	defaults.profile.showSpellDmgFromInt = true
	defaults.profile.showHealingFromInt = true
	defaults.profile.showMP5FromInt = true -- Dreamstate (Rank 3) - 1,17
	defaults.profile.showMP5FromSpi = true
	options.args.stat.args.agi.args.showHealingFromAgi = { -- Nurturing Instinct (Rank 2) - 2,14
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(47180) or "nil")..")",						-- ["Nurturing Instinct"]
		desc = L["Show Healing from Agility"].." ("..tostring(GetSpellInfo(47180) or "nil")..")",			-- ["Nurturing Instinct"]
	}
	options.args.stat.args.int.args.showSpellDmgFromInt = { -- Lunar Guidance (Rank 3) - 1,12
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(33591) or "nil")..")",					-- ["Lunar Guidance"]
		desc = L["Show Spell Damage from Intellect"].." ("..tostring(GetSpellInfo(33591) or "nil")..")",	-- ["Lunar Guidance"]
	}
	options.args.stat.args.int.args.showHealingFromInt = { -- Lunar Guidance (Rank 3) - 1,12
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(33591) or "nil")..")",
		desc = L["Show Healing from Intellect"].." ("..tostring(GetSpellInfo(33591) or "nil")..")",
	}
	options.args.stat.args.spi.args.showMP5FromSpi = { -- Intensity (Rank 3) - 3,6
		type = 'toggle',
		name = L["Show Mana Regen"].." ("..tostring(GetSpellInfo(35359) or "nil")..")",
		desc = L["Show Mana Regen while casting from Spirit"].." ("..tostring(GetSpellInfo(35359) or "nil")..")",
	}
end
if class == "HUNTER" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumRAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumMP5 = true
	defaults.profile.showMP5FromInt = true -- Aspect of the Viper
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showRAPFromInt = true
	options.args.stat.args.int.args.showRAPFromInt = { -- Careful Aim
		type = 'toggle',
		name = L["Show Ranged Attack Power"].." ("..tostring(GetSpellInfo(34484) or "nil")..")",
		desc = L["Show Ranged Attack Power from Intellect"].." ("..tostring(GetSpellInfo(34484) or "nil")..")",
	}
end
if class == "MAGE" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumMP5 = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellDmgFromInt = true
	defaults.profile.showArmorFromInt = true
	defaults.profile.showMP5FromInt = true
	defaults.profile.showMP5FromSpi = true
	options.args.stat.args.int.args.showSpellDmgFromInt = { -- Mind Mastery (Rank 5) - 1,22
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(31588) or "nil")..")",
		desc = L["Show Spell Damage from Intellect"].." ("..tostring(GetSpellInfo(31588) or "nil")..")",
	}
	options.args.stat.args.int.args.showArmorFromInt = { -- Arcane Fortitude - 1,9
		type = 'toggle',
		name = L["Show Armor"].." ("..tostring(GetSpellInfo(28574) or "nil")..")",
		desc = L["Show Armor from Intellect"].." ("..tostring(GetSpellInfo(28574) or "nil")..")",
	}
	options.args.stat.args.spi.args.showMP5FromSpi = { -- Arcane Meditation (Rank 3) - 1,12
		type = 'toggle',
		name = L["Show Mana Regen"].." ("..tostring(GetSpellInfo(18464) or "nil")..")",
		desc = L["Show Mana Regen while casting from Spirit"].." ("..tostring(GetSpellInfo(18464) or "nil")..")",
	}
end
if class == "PALADIN" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumHolyDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.sumMP5 = true
	defaults.profile.showSpellDmgFromInt = true
	defaults.profile.showHealingFromInt = true
	options.args.stat.args.int.args.showSpellDmgFromInt = { -- Holy Guidance (Rank 5) - 1,19
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(31841) or "nil")..")",
		desc = L["Show Spell Damage from Intellect"].." ("..tostring(GetSpellInfo(31841) or "nil")..")",
	}
	options.args.stat.args.int.args.showHealingFromInt = { -- Holy Guidance (Rank 5) - 1,19
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(31841) or "nil")..")",
		desc = L["Show Healing from Intellect"].." ("..tostring(GetSpellInfo(31841) or "nil")..")",
	}
end
if class == "PRIEST" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.sumMP5 = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showMP5FromInt = true
	defaults.profile.showMP5FromSpi = true
	defaults.profile.showSpellDmgFromSpi = true
	defaults.profile.showHealingFromSpi = true
	options.args.stat.args.spi.args.showMP5FromSpi = { -- Meditation (Rank 3) - 1,9
		type = 'toggle',
		name = L["Show Mana Regen"].." ("..tostring(GetSpellInfo(38346) or "nil")..")",
		desc = L["Show Mana Regen while casting from Spirit"].." ("..tostring(GetSpellInfo(38346) or "nil")..")",
	}
	options.args.stat.args.spi.args.showSpellDmgFromSpi = { -- Spiritual Guidance (Rank 5) - 2,14, Improved Divine Spirit (Rank 2) - 1,15 - Buff
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(15031) or "nil")..", "..tostring(GetSpellInfo(33182) or "nil")..")",
		desc = L["Show Spell Damage from Spirit"].." ("..tostring(GetSpellInfo(15031) or "nil")..", "..tostring(GetSpellInfo(33182) or "nil")..")",
	}
	options.args.stat.args.spi.args.showHealingFromSpi = { -- Spiritual Guidance (Rank 5) - 2,14, Improved Divine Spirit (Rank 2) - 1,15 - Buff
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(15031) or "nil")..", "..tostring(GetSpellInfo(33182) or "nil")..")",
		desc = L["Show Healing from Spirit"].." ("..tostring(GetSpellInfo(15031) or "nil")..", "..tostring(GetSpellInfo(33182) or "nil")..")",
	}
end
if class == "ROGUE" then
	defaults.profile.sumHP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
end
if class == "SHAMAN" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.sumMP5 = true
	defaults.profile.showSpellDmgFromStr = true
	defaults.profile.showHealingFromStr = true
	defaults.profile.showSpellDmgFromInt = true
	defaults.profile.showHealingFromInt = true
	defaults.profile.showMP5FromInt = true
	options.args.stat.args.str.args.showSpellDmgFromStr = { -- Mental Quickness (Rank 3) - 2,15
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(30814) or "nil")..")",
		desc = L["Show Spell Damage from Strength"].." ("..tostring(GetSpellInfo(30814) or "nil")..")",
	}
	options.args.stat.args.str.args.showHealingFromStr = { -- Mental Quickness (Rank 3) - 2,15
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(30814) or "nil")..")",
		desc = L["Show Healing from Strength"].." ("..tostring(GetSpellInfo(30814) or "nil")..")",
	}
	options.args.stat.args.int.args.showSpellDmgFromInt = { -- Nature's Blessing (Rank 3) - 3,18
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(30869) or "nil")..")",
		desc = L["Show Spell Damage from Intellect"].." ("..tostring(GetSpellInfo(30869) or "nil")..")",
	}
	options.args.stat.args.int.args.showHealingFromInt = { -- Nature's Blessing (Rank 3) - 3,18
		type = 'toggle',
		name = L["Show Healing"].." ("..tostring(GetSpellInfo(30869) or "nil")..")",
		desc = L["Show Healing from Intellect"].." ("..tostring(GetSpellInfo(30869) or "nil")..")",
	}
end
if class == "WARLOCK" then
	defaults.profile.sumHP = true
	defaults.profile.sumMP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellDmgFromSta = true
	defaults.profile.showSpellDmgFromInt = true
	options.args.stat.args.sta.args.showSpellDmgFromSta = { -- Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(35693) or "nil")..")",
		desc = L["Show Spell Damage from Stamina"].." ("..tostring(GetSpellInfo(35693) or "nil")..")",
	}
	options.args.stat.args.int.args.showSpellDmgFromInt = { -- Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		type = 'toggle',
		name = L["Show Spell Damage"].." ("..tostring(GetSpellInfo(35693) or "nil")..")",
		desc = L["Show Spell Damage from Intellect"].." ("..tostring(GetSpellInfo(35693) or "nil")..")",
	}
end
if class == "WARRIOR" then
	defaults.profile.sumHP = true
	defaults.profile.sumResilience = true
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
end

-----------
-- Tools --
-----------
-- copyTable
local function copyTable(to, from)
	if to then
		for k in pairs(to) do
			to[k] = nil
		end
		setmetatable(to, nil)
	else
		to = {}
	end
	for k,v in pairs(from) do
		if type(k) == "table" then
			k = copyTable({}, k)
		end
		if type(v) == "table" then
			v = copyTable({}, v)
		end
		to[k] = v
	end
	setmetatable(to, getmetatable(from))
	return to
end


---------------------
-- Initializations --
---------------------
--[[ Loading Process Event Reference
{
ADDON_LOADED - When this addon is loaded
VARIABLES_LOADED - When all addons are loaded
PLAYER_LOGIN - Most information about the game world should now be available to the UI
}
--]]
-- OnInitialize(name) called at ADDON_LOADED
function RatingBuster:RefreshConfig()
	profileDB = self.db.profile
end

function RatingBuster:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RatingBusterDB", defaults, "profile")
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	profileDB = self.db.profile

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("RatingBuster", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RatingBuster", "RatingBuster")
end

SLASH_RATINGBUSTER1, SLASH_RATINGBUSTER2 = "/ratingbuster", "/rb"
function SlashCmdList.RATINGBUSTER(input)
  if not input or input:trim() == "" then
		if not LibStub("AceConfigDialog-3.0").OpenFrames["RatingBuster"] then
			LibStub("AceConfigDialog-3.0"):Open("RatingBuster")
		else
			LibStub("AceConfigDialog-3.0"):Close("RatingBuster")
		end
  else
    LibStub("AceConfigCmd-3.0").HandleCommand("RatingBuster", "rb", "RatingBuster", input)
  end
end

-- OnEnable() called at PLAYER_LOGIN
function RatingBuster:OnEnable()
	-- Hook item tooltips
	TipHooker:Hook(self.ProcessTooltip, "item")
	-- Initialize playerLevel
	playerLevel = UnitLevel("player")
	-- for setting a new level
	self:RegisterEvent("PLAYER_LEVEL_UP")
	-- Events that require cache clearing
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", clearCache) -- talent point changed
	self:RegisterBucketEvent("UNIT_AURA", 1) -- fire at most once every 1 second
end

function RatingBuster:OnDisable()
	-- Unhook item tooltips
	TipHooker:Unhook(self.ProcessTooltip, "item")
end

-- event = PLAYER_LEVEL_UP
-- arg1 = New player level
function RatingBuster:PLAYER_LEVEL_UP(event, newlevel)
	playerLevel = newlevel
	clearCache()
end

-- event = UNIT_AURA
-- arg1 = List of UnitIDs in the AceBucket interval
function RatingBuster:UNIT_AURA(units)
	if units.player then
		clearCache()
	end
end

--------------------------
-- Process Tooltip Core --
--------------------------
--[[
"+15 Agility"
-> "+15 Agility (+0.46% Crit)"
"+15 Crit Rating"
-> "+15 Crit Rating (+1.20%)"
"Equip: Increases your hit rating by 10."
-> "Equip: Increases your hit rating by 10 (+1.20%)."
--]]
-- Empty Sockets
local EmptySocketLookup = {
	[EMPTY_SOCKET_RED] = "sumGemRed", -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = "sumGemYellow", -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = "sumGemBlue", -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = "sumGemMeta", -- EMPTY_SOCKET_META = "Meta Socket";
}
-- Color code (used to fix gem text color)
local currentColorCode
function RatingBuster.ProcessTooltip(tooltip, name, link)
	-- Check if we're in standby mode
	--if not RatingBuster:IsActive() then return end
	---------------------------
	-- Set calculation level --
	---------------------------
	calcLevel = profileDB.customLevel or 0
	if calcLevel == 0 then
		calcLevel = playerLevel
	end
	if profileDB.useRequiredLevel and link then
		local _, _, _, _, reqLevel = GetItemInfo(link)
		--RatingBuster:Print(link..", "..calcLevel)
		if reqLevel and calcLevel < reqLevel then
			calcLevel = reqLevel
		end
	end
	---------------------
	-- Tooltip Scanner --
	---------------------
	-- Loop through tooltip lines starting at line 2
	local tipTextLeft = tooltip:GetName().."TextLeft"
	for i = 2, tooltip:NumLines() do
		local fontString = _G[tipTextLeft..i]
		local text = fontString:GetText()
		if text then
			-- Get data from cache if available
			local cacheID = text..calcLevel
			local cacheText = cache[cacheID]
			if cacheText then
				if cacheText ~= text then
					fontString:SetText(cacheText)
				end
			elseif EmptySocketLookup[text] and profileDB[EmptySocketLookup[text]].gemText then -- Replace empty sockets with gem text
				text = profileDB[EmptySocketLookup[text]].gemText
				cache[cacheID] = text
				-- SetText
				fontString:SetText(text)
			elseif strfind(text, "%d") then -- do nothing if we don't find a number
				-- Find and set color code (used to fix gem text color) pattern:|cxxxxxxxx
				currentColorCode = select(3, strfind(text, "(|c%x%x%x%x%x%x%x%x)")) or "|r"
				-- Initial pattern check, do nothing if not found
				-- Check for separators and bulid separatorTable
				local separatorTable = {}
				for _, sep in ipairs(L["separators"]) do
					if strfind(text, sep) then
						tinsert(separatorTable, sep)
					end
				end
				-- SplitDoJoin
				text = RatingBuster:SplitDoJoin(text, separatorTable)
				cache[cacheID] = text
				-- SetText
				fontString:SetText(text)
			end
		end
		local width = fontString:GetWrappedWidth()
		if width > tooltip:GetMinimumWidth() then
			tooltip:SetMinimumWidth(math.ceil(width))
		end
	end
	----------------------------
	-- Item Level and Item ID --
	----------------------------
	-- Check for ItemLevel addon, do nothing if found
	if not ItemLevel_AddInfo and (profileDB.showItemLevel or profileDB.showItemID) and link then
		if cache[link] then
			tooltip:AddLine(cache[link])
		else
			-- Get the Item ID from the link string
			local _, link, _, level = GetItemInfo(link)
			if link then
				local _, _, id = strfind(link, "item:(%d+)")
				local newLine = ""
				if level and profileDB.showItemLevel then
					newLine = newLine..L["ItemLevel: "]..level
				end
				if id and profileDB.showItemID then
					if newLine ~= "" then
						newLine = newLine..", "
					end
					newLine = newLine..L["ItemID: "]..id
				end
				if newLine ~= "" then
					cache[link] = newLine
					tooltip:AddLine(newLine)
				end
			end
		end
	end
	------------------
	-- Stat Summary --
	------------------
	--[[
	----------------
	-- Base Stats --
	----------------
	-- Health - HEALTH, STA
	-- Mana - MANA, INT
	-- Attack Power - AP, STR, AGI
	-- Ranged Attack Power - RANGED_AP, INT, AP, STR, AGI
	-- Feral Attack Power - FERAL_AP, AP, STR, AGI
	-- Spell Damage - SPELL_DMG, STA, INT, SPI
	-- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	-- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	-- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	-- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	-- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	-- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	-- Healing - HEAL, STR, INT, SPI
	-- Hit Chance - MELEE_HIT_RATING, WEAPON_RATING
	-- Crit Chance - MELEE_CRIT_RATING, WEAPON_RATING, AGI
	-- Spell Hit Chance - SPELL_HIT_RATING
	-- Spell Crit Chance - SPELL_CRIT_RATING, INT
	-- Mana Regen - MANA_REG, SPI
	-- Health Regen - HEALTH_REG
	-- Mana Regen Not Casting - SPI
	-- Health Regen While Casting - SPI
	-- Armor - ARMOR, ARMOR_BONUS, AGI, INT
	-- Block Value - BLOCK_VALUE, STR
	-- Dodge Chance - DODGE_RATING, DEFENSE_RATING, AGI
	-- Parry Chance - PARRY_RATING, DEFENSE_RATING
	-- Block Chance - BLOCK_RATING, DEFENSE_RATING
	-- Hit Avoidance - DEFENSE_RATING, MELEE_HIT_AVOID_RATING
	-- Crit Avoidance - DEFENSE_RATING, RESILIENCE_RATING, MELEE_CRIT_AVOID_RATING
	-- Dodge Neglect - EXPERTISE_RATING, WEAPON_RATING
	-- Parry Neglect - EXPERTISE_RATING, WEAPON_RATING
	-- Block Neglect - WEAPON_RATING
	---------------------
	-- Composite Stats --
	---------------------
	-- Strength - STR
	-- Agility - AGI
	-- Stamina - STA
	-- Intellect - INT
	-- Spirit - SPI
	-- Defense - DEFENSE_RATING
	-- Weapon Skill - WEAPON_RATING
	-- Expertise - EXPERTISE_RATING
	--]]
	if profileDB.showSum then
		RatingBuster:StatSummary(tooltip, name, link)
	end
	---------------------
	-- Repaint tooltip --
	---------------------
	tooltip:Show()
end

---------------------------------------------------------------------------------
-- Recursive algorithm that divides a string into pieces using the separators in separatorTable,
-- processes them separately, then joins them back together
---------------------------------------------------------------------------------
-- text = "+24 Agility/+4 Stamina and +4 Spell Crit/+5 Spirit"
-- separatorTable = {"/", " and ", ","}
-- RatingBuster:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ",", "%. ", " for ", "&"})
-- RatingBuster:SplitDoJoin("+6法術傷害及5耐力", {"/", "和", ",", "。", " 持續 ", "&", "及",})
function RatingBuster:SplitDoJoin(text, separatorTable)
	if type(separatorTable) == "table" and table.maxn(separatorTable) > 0 then
		local sep = tremove(separatorTable, 1)
		text =  gsub(text, sep, "@")
		text = {strsplit("@", text)}
		local processedText = {}
		local tempTable = {}
		for _, t in ipairs(text) do
			--self:Print(t[1])
			copyTable(tempTable, separatorTable)
			tinsert(processedText, self:SplitDoJoin(t, tempTable))
		end
		-- Join text
		return (gsub(strjoin("@", unpack(processedText)), "@", sep))
	else
		--self:Print(cacheID)
		return self:ProcessText(text)
	end
end


function RatingBuster:ProcessText(text)
	--self:Print(text)
	-- Check if test has a matching pattern
	for _, num in ipairs(L["numberPatterns"]) do
		-- Convert text to lower so we don't have to worry about same ratings with different cases
		local lowerText = string.lower(text)
		-- Capture the stat value
		local s, e, value, partialtext = strfind(lowerText, num.pattern)
		if value then
			-- Check and switch captures if needed
			if partialtext and tonumber(partialtext) then
				value, partialtext = partialtext, value
			end
			-- Capture the stat name
			for _, stat in ipairs(L["statList"]) do
				if (not partialtext and strfind(lowerText, stat.pattern)) or (partialtext and strfind(partialtext, stat.pattern)) then
					value = tonumber(value)
					local infoString = ""
					if type(stat.id) == "number" and stat.id >= 1 and stat.id <= 24 and profileDB.showRatings then
						--------------------
						-- Combat Ratings --
						--------------------
						-- Calculate stat value
						local effect, strID = StatLogic:GetEffectFromRating(value, stat.id, calcLevel)
						--self:Debug(reversedAmount..", "..amount..", "..v[2]..", "..RatingBuster.targetLevel)-- debug
						-- If rating is resilience, add a minus sign
						if strID == "DEFENSE" and profileDB.defBreakDown then
							effect = effect * 0.04
							local numStats = 5
							if GetParryChance() == 0 then
								numStats = numStats - 1
							end
							if GetBlockChance() == 0 then
								numStats = numStats - 1
							end
							infoString = format("%+.2f%% x"..numStats, effect)
						elseif strID == "WEAPON_SKILL" and profileDB.wpnBreakDown then
							effect = effect * 0.04
							infoString = format("%+.2f%% x5", effect)
						elseif strID == "EXPERTISE" and profileDB.expBreakDown then
							effect = floor(effect) * -0.25
							if profileDB.detailedConversionText then
								infoString = gsub(L["$value to be Dodged/Parried"], "$value", format("%+.2f%%%%", effect))
							else
								infoString = format("%+.2f%%", effect)
							end
						elseif stat.id >= 15 and stat.id <= 17 then -- Resilience
							effect = effect * -1
							if profileDB.detailedConversionText then
								infoString = gsub(L["$value to be Crit"], "$value", format("%+.2f%%%%", effect))..", "..gsub(L["$value Crit Dmg Taken"], "$value", format("%+.2f%%%%", effect * 2))..", "..gsub(L["$value DOT Dmg Taken"], "$value", format("%+.2f%%%%", effect))
							else
								infoString = format("%+.2f%%", effect)
							end
						else
							--self:Debug(text..", "..tostring(effect)..", "..value..", "..stat.id..", "..calcLevel)
							-- Build info string
							infoString = format("%+.2f", effect)
							if stat.id > 2 and stat.id < 21 then -- if rating is a percentage
								infoString = infoString.."%"
							end
						end
					elseif stat.id == SPELL_STAT1_NAME and profileDB.showStats then
						--------------
						-- Strength --
						--------------
						local statmod = 1
						if profileDB.enableStatMods then
							statmod = StatLogic:GetStatMod("MOD_STR")
							value = value * statmod
						end
						local infoTable = {}
						if profileDB.showAPFromStr then
							local mod = StatLogic:GetStatMod("MOD_AP")
							local effect = value * StatLogic:GetAPPerStr(class) * mod
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then -- so we don't get +0 AP when effect < 0.5
								tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showBlockValueFromStr then
							local effect = value * StatLogic:GetBlockValuePerStr(class)
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Block"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showSpellDmgFromStr then -- Shaman: Mental Quickness (Rank 3) - 2,15
							local mod = StatLogic:GetStatMod("MOD_AP") * StatLogic:GetStatMod("MOD_SPELL_DMG")
							local effect = value * StatLogic:GetAPPerStr(class) * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_AP") * mod
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Dmg"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Dmg"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showHealingFromStr then -- Shaman: Mental Quickness (Rank 3) - 2,15
							local mod = StatLogic:GetStatMod("MOD_AP") * StatLogic:GetStatMod("MOD_HEALING")
							local effect = value * StatLogic:GetAPPerStr(class) * StatLogic:GetStatMod("ADD_HEALING_MOD_AP") * mod
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.0f", effect))))
							end
						end
						infoString = strjoin(", ", unpack(infoTable))
					elseif stat.id == SPELL_STAT2_NAME and profileDB.showStats then
						-------------
						-- Agility --
						-------------
						local statmod = 1
						if profileDB.enableStatMods then
							statmod = StatLogic:GetStatMod("MOD_AGI")
							value = value * statmod
						end
						local infoTable = {}
						if profileDB.showAPFromAgi then
							local mod = StatLogic:GetStatMod("MOD_AP")
							local effect = value * StatLogic:GetAPPerAgi(class) * mod
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showRAPFromAgi then
							local mod = StatLogic:GetStatMod("MOD_RANGED_AP")
							local effect = value * StatLogic:GetRAPPerAgi(class) * mod
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value RAP"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value RAP"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showCritFromAgi then
							local effect = StatLogic:GetCritFromAgi(value, class, calcLevel)
							if effect > 0 then
								tinsert(infoTable, (gsub(L["$value% Crit"], "$value", format("%+.2f", effect))))
							end
						end
						if profileDB.showDodgeFromAgi and (calcLevel == playerLevel) then
							local effect = StatLogic:GetDodgeFromAgi(value)
							if effect > 0 then
								tinsert(infoTable, (gsub(L["$value% Dodge"], "$value", format("%+.2f", effect))))
							end
						end
						if profileDB.showArmorFromAgi then
							local effect = value * 2
							if effect > 0 then
								tinsert(infoTable, (gsub(L["$value Armor"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showHealingFromAgi then
							local mod = StatLogic:GetStatMod("MOD_HEALING")
							local effect = value * StatLogic:GetStatMod("ADD_HEALING_MOD_AGI") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
							end
						end
						infoString = strjoin(", ", unpack(infoTable))
					elseif stat.id == SPELL_STAT3_NAME and profileDB.showStats then
						-------------
						-- Stamina --
						-------------
						local statmod = 1
						if profileDB.enableStatMods then
							statmod = StatLogic:GetStatMod("MOD_STA")
							value = value * statmod
						end
						local infoTable = {}
						if profileDB.showHealthFromSta then
							local mod = StatLogic:GetStatMod("MOD_HEALTH")
							local effect = value * 10 * mod -- 10 Health per Sta
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value HP"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value HP"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showSpellDmgFromSta then
							local mod = StatLogic:GetStatMod("MOD_SPELL_DMG")
							local effect = value * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Dmg"], "$value", format("%+.1f", effect))))
							end
						end
						infoString = strjoin(", ", unpack(infoTable))
					elseif stat.id == SPELL_STAT4_NAME and profileDB.showStats then
						---------------
						-- Intellect --
						---------------
						local statmod = 1
						if profileDB.enableStatMods then
							statmod = StatLogic:GetStatMod("MOD_INT")
							value = value * statmod
						end
						local infoTable = {}
						if profileDB.showManaFromInt then
							local mod = StatLogic:GetStatMod("MOD_MANA")
							local effect = value * 15 * mod -- 15 Mana per Int
							if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP"], "$value", format("%+.1f", effect))))
							elseif floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP"], "$value", format("%+.0f", effect))))
							end
						end
						if profileDB.showSpellCritFromInt then
							local effect = StatLogic:GetSpellCritFromInt(value, class, calcLevel)
							if effect > 0 then
								tinsert(infoTable, (gsub(L["$value% Spell Crit"], "$value", format("%+.2f", effect))))
							end
						end
						if profileDB.showSpellDmgFromInt then
							local mod = StatLogic:GetStatMod("MOD_SPELL_DMG")
							local effect = value * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Dmg"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showHealingFromInt then
							local mod = StatLogic:GetStatMod("MOD_HEALING")
							local effect = value * StatLogic:GetStatMod("ADD_HEALING_MOD_INT") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showMP5FromInt then
							local effect
							if wowBuildNo >= '7897' then -- 2.4.0
								local _, int = UnitStat("player", 4)
								local _, spi = UnitStat("player", 5)
								effect = value * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT") + (StatLogic:GetNormalManaRegenFromSpi(spi, int + value, calcLevel) - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)) * StatLogic:GetStatMod("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
							else
								effect = value * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT")
							end
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP5"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showMP5NCFromInt then
							local effect
							if wowBuildNo >= '7897' then -- 2.4.0
								local _, int = UnitStat("player", 4)
								local _, spi = UnitStat("player", 5)
								effect = value * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT") + StatLogic:GetNormalManaRegenFromSpi(spi, int + value, calcLevel) - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)
							else
								effect = value * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT")
							end
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP5(NC)"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showRAPFromInt then
							local mod = StatLogic:GetStatMod("MOD_RANGED_AP")
							local effect = value * StatLogic:GetStatMod("ADD_RANGED_AP_MOD_INT") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value RAP"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showArmorFromInt then
							local effect = value * StatLogic:GetStatMod("ADD_ARMOR_MOD_INT")
							if floor(abs(effect) + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Armor"], "$value", format("%+.0f", effect))))
							end
						end
						infoString = strjoin(", ", unpack(infoTable))
					elseif stat.id == SPELL_STAT5_NAME and profileDB.showStats then
						------------
						-- Spirit --
						------------
						local statmod = 1
						if profileDB.enableStatMods then
							statmod = StatLogic:GetStatMod("MOD_SPI")
							value = value * statmod
						end
						local infoTable = {}
						if profileDB.showMP5FromSpi then
							local mod = StatLogic:GetStatMod("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
							local effect
							if wowBuildNo >= '7897' then -- 2.4.0
								effect = StatLogic:GetNormalManaRegenFromSpi(value, nil, calcLevel) * mod
							else
								effect = StatLogic:GetNormalManaRegenFromSpi(value, class) * mod
							end
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP5"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showMP5NCFromSpi then
							local effect
							if wowBuildNo >= '7897' then -- 2.4.0
								effect = StatLogic:GetNormalManaRegenFromSpi(value, nil, calcLevel)
							else
								effect = StatLogic:GetNormalManaRegenFromSpi(value, class)
							end
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value MP5(NC)"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showHP5FromSpi then
							local effect = StatLogic:GetHealthRegenFromSpi(value, class)
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value HP5"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showSpellDmgFromSpi then
							local mod = StatLogic:GetStatMod("MOD_SPELL_DMG")
							local effect = value * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Dmg"], "$value", format("%+.1f", effect))))
							end
						end
						if profileDB.showHealingFromSpi then
							local mod = StatLogic:GetStatMod("MOD_HEALING")
							local effect = value * StatLogic:GetStatMod("ADD_HEALING_MOD_SPI") * mod
							if floor(abs(effect) * 10 + 0.5) > 0 then
								tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
							end
						end
						infoString = strjoin(", ", unpack(infoTable))
					end
					if infoString ~= "" then
						-- Add parenthesis
						infoString = "("..infoString..")"
						-- Add Color
						if profileDB.enableTextColor then
							infoString = profileDB.textColor.hex..infoString..currentColorCode
						end
						-- Build replacement string
						if num.addInfo == "AfterNumber" then -- Add after number
							infoString = gsub(infoString, "%%", "%%%%%%%%") -- sub "%" with "%%%%"
							infoString = gsub(strsub(text, s, e), num.pattern, "%0 "..infoString, 1) -- sub "33" with "33 (3.33%)"
						else -- Add after stat
							infoString = gsub(infoString, "%%", "%%%%")
							s, e = strfind(lowerText, stat.pattern)
							infoString = "%0 "..infoString
						end
						-- Insert info into text
						return (gsub(text, strsub(text, s, e), infoString, 1)) -- because gsub has 2 return values, but we only want 1
					end
					return text
				end
			end
		end
	end
	return text
end


-- Color Numbers
local GREEN_FONT_COLOR_CODE = GREEN_FONT_COLOR_CODE -- "|cff20ff20" Green
local HIGHLIGHT_FONT_COLOR_CODE = HIGHLIGHT_FONT_COLOR_CODE -- "|cffffffff" White
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE -- "|cffffffff" White
local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE -- "|r"
local function colorNum(text, num)
	if num > 0 then
		return GREEN_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	elseif num < 0 then
		return RED_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	else
		return HIGHLIGHT_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	end
end

-- Used armor type each class uses
local classArmorTypes = {
	WARRIOR = {
		[BI["Plate"]] = true,
		[BI["Mail"]] = true,
		[BI["Leather"]] = true,
	},
	PALADIN = {
		[BI["Plate"]] = true,
		[BI["Mail"]] = true,
		[BI["Leather"]] = true,
		[BI["Cloth"]] = true,
	},
	HUNTER = {
		[BI["Mail"]] = true,
		[BI["Leather"]] = true,
	},
	ROGUE = {
		[BI["Leather"]] = true,
	},
	PRIEST = {
		[BI["Cloth"]] = true,
	},
	SHAMAN = {
		[BI["Mail"]] = true,
		[BI["Leather"]] = true,
		[BI["Cloth"]] = true,
	},
	MAGE = {
		[BI["Cloth"]] = true,
	},
	WARLOCK = {
		[BI["Cloth"]] = true,
	},
	DRUID = {
		[BI["Leather"]] = true,
		[BI["Cloth"]] = true,
	},
}

local armorTypes = {
	[BI["Plate"]] = true,
	[BI["Mail"]] = true,
	[BI["Leather"]] = true,
	[BI["Cloth"]] = true,
}


local summaryCalcData = {
	-----------
	-- Basic --
	-----------
	-- Strength - STR
	{
		option = "sumStr",
		name = "STR",
		func = function(sum) return sum["STR"] end,
	},
	-- Agility - AGI
	{
		option = "sumAgi",
		name = "AGI",
		func = function(sum) return sum["AGI"] end,
	},
	-- Stamina - STA
	{
		option = "sumSta",
		name = "STA",
		func = function(sum) return sum["STA"] end,
	},
	-- Intellect - INT
	{
		option = "sumInt",
		name = "INT",
		func = function(sum) return sum["INT"] end,
	},
	-- Spirit - SPI
	{
		option = "sumSpi",
		name = "SPI",
		func = function(sum) return sum["SPI"] end,
	},
	-- Health - HEALTH, STA
	{
		option = "sumHP",
		name = "HEALTH",
		func = function(sum) return ((sum["HEALTH"] or 0) + (sum["STA"] * 10)) * StatLogic:GetStatMod("MOD_HEALTH") end,
	},
	-- Mana - MANA, INT
	{
		option = "sumMP",
		name = "MANA",
		func = function(sum) return ((sum["MANA"] or 0) + (sum["INT"] * 15)) * StatLogic:GetStatMod("MOD_MANA") end,
	},
	-- Health Regen - HEALTH_REG
	{
		option = "sumHP5",
		name = "HEALTH_REG",
		func = function(sum) return (sum["HEALTH_REG"] or 0) end,
	},
	-- Health Regen while Out of Combat - HEALTH_REG, SPI
	{
		option = "sumHP5OC",
		name = "HEALTH_REG_OUT_OF_COMBAT",
		func = function(sum) return (sum["HEALTH_REG"] or 0) + StatLogic:GetHealthRegenFromSpi(sum["SPI"], class) end,
	},
	-- Mana Regen - MANA_REG, SPI, INT
	{
		option = "sumMP5",
		name = "MANA_REG",
		func = function(sum)
			if wowBuildNo >= '7897' then -- 2.4.0
				local _, int = UnitStat("player", 4)
				local _, spi = UnitStat("player", 5)
				return (sum["MANA_REG"] or 0)
				 + (sum["INT"] * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT"))
				 + (StatLogic:GetNormalManaRegenFromSpi(spi + sum["SPI"], int + sum["INT"], calcLevel)
				 - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)) * StatLogic:GetStatMod("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
			else
				return (sum["MANA_REG"] or 0)
				 + (sum["INT"] * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT"))
				 + (StatLogic:GetNormalManaRegenFromSpi(sum["SPI"], class) * StatLogic:GetStatMod("ADD_MANA_REG_MOD_NORMAL_MANA_REG"))
			end
		end,
	},
	-- Mana Regen while Not casting - MANA_REG, SPI, INT
	{
		option = "sumMP5NC",
		name = "MANA_REG_NOT_CASTING",
		func = function(sum)
			if wowBuildNo >= '7897' then -- 2.4.0
				local _, int = UnitStat("player", 4)
				local _, spi = UnitStat("player", 5)
				return (sum["MANA_REG"] or 0)
				 + (sum["INT"] * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT"))
				 + StatLogic:GetNormalManaRegenFromSpi(spi + sum["SPI"], int + sum["INT"], calcLevel)
				 - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)
			else
				return (sum["MANA_REG"] or 0)
				 + (sum["INT"] * StatLogic:GetStatMod("ADD_MANA_REG_MOD_INT"))
				 + StatLogic:GetNormalManaRegenFromSpi(sum["SPI"], class)
			end
		end,
	},
	---------------------
	-- Physical Damage --
	---------------------
	-- Attack Power - AP, STR, AGI
	{
		option = "sumAP",
		name = "AP",
		func = function(sum) return ((sum["AP"] or 0) + (sum["STR"] * StatLogic:GetAPPerStr(class))
			 + (sum["AGI"] * StatLogic:GetAPPerAgi(class))) * StatLogic:GetStatMod("MOD_AP") end,
	},
	-- Ranged Attack Power - RANGED_AP, AP, AGI, INT
	{
		option = "sumRAP",
		name = "RANGED_AP",
		func = function(sum) return ((sum["RANGED_AP"] or 0) + (sum["AP"] or 0) + (sum["AGI"] * StatLogic:GetRAPPerAgi(class))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_RANGED_AP_MOD_INT"))) * (StatLogic:GetStatMod("MOD_RANGED_AP") + StatLogic:GetStatMod("MOD_AP") - 1) end,
	},
	-- Feral Attack Power - FERAL_AP, AP, STR, AGI
	{
		option = "sumFAP",
		name = "FERAL_AP",
		func = function(sum) return ((sum["FERAL_AP"] or 0) + (sum["AP"] or 0) + (sum["STR"] * StatLogic:GetAPPerStr(class))
			 + (sum["AGI"] * StatLogic:GetAPPerAgi(class))) * StatLogic:GetStatMod("MOD_AP") end,
	},
	-- Hit Chance - MELEE_HIT_RATING, WEAPON_RATING
	{
		option = "sumHit",
		name = "MELEE_HIT",
		func = function(sum)
			local s = 0
			for id, v in pairs(sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					s = s + StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel) * 0.04
					break
				end
			end
			return s + StatLogic:GetEffectFromRating((sum["MELEE_HIT_RATING"] or 0), "MELEE_HIT_RATING", calcLevel)
			+ (sum["MELEE_HIT"] or 0)
		end,
		ispercent = true,
	},
	-- Hit Rating - MELEE_HIT_RATING
	{
		option = "sumHitRating",
		name = "MELEE_HIT_RATING",
		func = function(sum) return (sum["MELEE_HIT_RATING"] or 0) end,
	},
	-- Crit Chance - MELEE_CRIT_RATING, WEAPON_RATING, AGI
	{
		option = "sumCrit",
		name = "MELEE_CRIT",
		func = function(sum)
			local s = 0
			for id, v in pairs(sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					s = s + StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel) * 0.04
					break
				end
			end
			return s + StatLogic:GetEffectFromRating((sum["MELEE_CRIT_RATING"] or 0), "MELEE_CRIT_RATING", calcLevel)
			+ StatLogic:GetCritFromAgi(sum["AGI"], class, calcLevel)
			+ (sum["MELEE_CRIT"] or 0)
		end,
		ispercent = true,
	},
	-- Crit Rating - MELEE_CRIT_RATING
	{
		option = "sumCritRating",
		name = "MELEE_CRIT_RATING",
		func = function(sum) return (sum["MELEE_CRIT_RATING"] or 0) end,
	},
	-- Haste - MELEE_HASTE_RATING
	{
		option = "sumHaste",
		name = "MELEE_HASTE",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["MELEE_HASTE_RATING"] or 0), "MELEE_HASTE_RATING", calcLevel) end,
		ispercent = true,
	},
	-- Haste Rating - MELEE_HASTE_RATING
	{
		option = "sumHasteRating",
		name = "MELEE_HASTE_RATING",
		func = function(sum) return (sum["MELEE_HASTE_RATING"] or 0) end,
	},
	-- Expertise - EXPERTISE_RATING
	{
		option = "sumExpertise",
		name = "EXPERTISE",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["EXPERTISE_RATING"] or 0), "EXPERTISE_RATING", calcLevel) end,
	},
	-- Dodge Neglect - EXPERTISE_RATING, WEAPON_RATING -- 2.3.0
	{
		option = "sumDodgeNeglect",
		name = "DODGE_NEGLECT",
		func = function(sum)
			local s = 0
			for id, v in pairs(sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					s = StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel) * 0.04
				end
			end
			s = s + floor(StatLogic:GetEffectFromRating((sum["EXPERTISE_RATING"] or 0), "EXPERTISE_RATING", calcLevel)) * 0.25
			return s
		end,
		ispercent = true,
	},
	-- Parry Neglect - EXPERTISE_RATING, WEAPON_RATING -- 2.3.0
	{
		option = "sumParryNeglect",
		name = "PARRY_NEGLECT",
		func = function(sum)
			local s = 0
			for id, v in pairs(sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					s = StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel) * 0.04
				end
			end
			s = s + floor(StatLogic:GetEffectFromRating((sum["EXPERTISE_RATING"] or 0), "EXPERTISE_RATING", calcLevel)) * 0.25
			return s
		end,
		ispercent = true,
	},
	-- Block Neglect - WEAPON_RATING
	{
		option = "sumBlockNeglect",
		name = "BLOCK_NEGLECT",
		func = function(sum)
			for id, v in pairs(sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					return StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel) * 0.04
				end
			end
			return 0
		end,
		ispercent = true,
	},
	-- Weapon Max Damage - MAX_DAMAGE
	{
		option = "sumWeaponMaxDamage",
		name = "MAX_DAMAGE",
		func = function(sum) return (sum["MAX_DAMAGE"] or 0) end,
	},
	-- Ignore Armor - IGNORE_ARMOR
	{
		option = "sumIgnoreArmor",
		name = "IGNORE_ARMOR",
		func = function(sum) return (sum["IGNORE_ARMOR"] or 0) end,
	},
	------------------------------
	-- Spell Damage and Healing --
	------------------------------
	-- Spell Damage - SPELL_DMG, STA, INT, SPI
	{
		option = "sumSpellDmg",
		name = "SPELL_DMG",
		func = function(sum)
			local ap = ((sum["AP"] or 0) + (sum["STR"] * StatLogic:GetAPPerStr(class))
			 + (sum["AGI"] * StatLogic:GetAPPerAgi(class))) * StatLogic:GetStatMod("MOD_AP")
			return ((sum["SPELL_DMG"] or 0) + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))
			 + (ap * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_AP"))) * StatLogic:GetStatMod("MOD_SPELL_DMG")
		end,
	},
	-- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	{
		option = "sumHolyDmg",
		name = "HOLY_SPELL_DMG",
		func = function(sum) return ((sum["HOLY_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumArcaneDmg",
		name = "ARCANE_SPELL_DMG",
		func = function(sum) return ((sum["ARCANE_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	{
		option = "sumFireDmg",
		name = "FIRE_SPELL_DMG",
		func = function(sum) return ((sum["FIRE_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumNatureDmg",
		name = "NATURE_SPELL_DMG",
		func = function(sum) return ((sum["NATURE_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumFrostDmg",
		name = "FROST_SPELL_DMG",
		func = function(sum) return ((sum["FROST_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	{
		option = "sumShadowDmg",
		name = "SHADOW_SPELL_DMG",
		func = function(sum) return ((sum["SHADOW_SPELL_DMG"] or 0) + (sum["SPELL_DMG"] or 0)
			 + (sum["STA"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_STA"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_SPELL_DMG_MOD_SPI"))) * StatLogic:GetStatMod("MOD_SPELL_DMG") end,
	},
	-- Healing - HEAL, AGI, STR, INT, SPI
	{
		option = "sumHealing",
		name = "HEAL",
		func = function(sum)
			local ap = ((sum["AP"] or 0) + (sum["STR"] * StatLogic:GetAPPerStr(class))
			 + (sum["AGI"] * StatLogic:GetAPPerAgi(class))) * StatLogic:GetStatMod("MOD_AP")
			return ((sum["HEAL"] or 0)
			 + (sum["STR"] * StatLogic:GetStatMod("ADD_HEALING_MOD_STR"))
			 + (sum["INT"] * StatLogic:GetStatMod("ADD_HEALING_MOD_INT"))
			 + (sum["SPI"] * StatLogic:GetStatMod("ADD_HEALING_MOD_SPI"))
			 + (sum["AGI"] * StatLogic:GetStatMod("ADD_HEALING_MOD_AGI"))
			 + (ap * StatLogic:GetStatMod("ADD_HEALING_MOD_AP"))) * StatLogic:GetStatMod("MOD_SPELL_DMG")
		end,
	},
	-- Spell Hit Chance - SPELL_HIT_RATING
	{
		option = "sumSpellHit",
		name = "SPELL_HIT",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["SPELL_HIT_RATING"] or 0), "SPELL_HIT_RATING", calcLevel)
			+ (sum["SPELL_HIT"] or 0)
		end,
		ispercent = true,
	},
	-- Spell Hit Rating - SPELL_HIT_RATING
	{
		option = "sumSpellHitRating",
		name = "SPELL_HIT_RATING",
		func = function(sum) return (sum["SPELL_HIT_RATING"] or 0) end,
	},
	-- Spell Crit Chance - SPELL_CRIT_RATING, INT
	{
		option = "sumSpellCrit",
		name = "SPELL_CRIT",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["SPELL_CRIT_RATING"] or 0), "SPELL_CRIT_RATING", calcLevel)
			 + StatLogic:GetSpellCritFromInt(sum["INT"], class, calcLevel)
			 + (sum["SPELL_CRIT"] or 0)
		end,
		ispercent = true,
	},
	-- Spell Crit Rating - SPELL_CRIT_RATING
	{
		option = "sumSpellCritRating",
		name = "SPELL_CRIT_RATING",
		func = function(sum) return (sum["SPELL_CRIT_RATING"] or 0) end,
	},
	-- Spell Haste - SPELL_HASTE_RATING
	{
		option = "sumSpellHaste",
		name = "SPELL_HASTE",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["SPELL_HASTE_RATING"] or 0), "SPELL_HASTE_RATING", calcLevel) end,
		ispercent = true,
	},
	-- Spell Haste Rating - SPELL_HASTE_RATING
	{
		option = "sumSpellHasteRating",
		name = "SPELL_HASTE_RATING",
		func = function(sum) return (sum["SPELL_HASTE_RATING"] or 0) end,
	},
	-- Spell Penetration - SPELLPEN
	{
		option = "sumPenetration",
		name = "SPELLPEN",
		func = function(sum) return (sum["SPELLPEN"] or 0) end,
	},
	----------
	-- Tank --
	----------
	-- Armor - ARMOR, ARMOR_BONUS, AGI, INT
	{
		option = "sumArmor",
		name = "ARMOR",
		func = function(sum) return (sum["ARMOR"] or 0) * StatLogic:GetStatMod("MOD_ARMOR")
			 + (sum["ARMOR_BONUS"] or 0) + ((sum["AGI"] or 0) * 2)
			 + ((sum["INT"] or 0) * StatLogic:GetStatMod("ADD_ARMOR_MOD_INT")) end,
	},
	-- Dodge Chance - DODGE_RATING, DEFENSE_RATING, AGI
	{
		option = "sumDodge",
		name = "DODGE",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["DODGE_RATING"] or 0), "DODGE_RATING", calcLevel)
			 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
			 + StatLogic:GetDodgeFromAgi(sum["AGI"]) end,
		ispercent = true,
	},
	-- Dodge Rating - DODGE_RATING
	{
		option = "sumDodgeRating",
		name = "DODGE_RATING",
		func = function(sum) return (sum["DODGE_RATING"] or 0) end,
	},
	-- Parry Chance - PARRY_RATING, DEFENSE_RATING
	{
		option = "sumParry",
		name = "PARRY",
		func = function(sum)
			if GetParryChance() == 0 then return 0 end
			return StatLogic:GetEffectFromRating((sum["PARRY_RATING"] or 0), "PARRY_RATING", calcLevel)
				 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
		end,
		ispercent = true,
	},
	-- Parry Rating - PARRY_RATING
	{
		option = "sumParryRating",
		name = "PARRY_RATING",
		func = function(sum) return (sum["PARRY_RATING"] or 0) end,
	},
	-- Block Chance - BLOCK_RATING, DEFENSE_RATING
	{
		option = "sumBlock",
		name = "BLOCK",
		func = function(sum)
			if GetBlockChance() == 0 then return 0 end
			return StatLogic:GetEffectFromRating((sum["BLOCK_RATING"] or 0), "BLOCK_RATING", calcLevel)
				 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
		end,
		ispercent = true,
	},
	-- Block Rating - BLOCK_RATING
	{
		option = "sumBlockRating",
		name = "BLOCK_RATING",
		func = function(sum) return (sum["BLOCK_RATING"] or 0) end,
	},
	-- Block Value - BLOCK_VALUE, STR
	{
		option = "sumBlockValue",
		name = "BLOCK_VALUE",
		func = function(sum)
			if GetBlockChance() == 0 then return 0 end
			return (sum["BLOCK_VALUE"] or 0) * StatLogic:GetStatMod("MOD_BLOCK_VALUE")
				 + ((sum["STR"] or 0) * StatLogic:GetBlockValuePerStr(class))
		end,
	},
	-- Hit Avoidance - DEFENSE_RATING, MELEE_HIT_AVOID_RATING
	{
		option = "sumHitAvoid",
		name = "MELEE_HIT_AVOID",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["MELEE_HIT_AVOID_RATING"] or 0), "MELEE_HIT_AVOID_RATING", calcLevel)
			 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04 end,
		ispercent = true,
	},
	-- Crit Avoidance - DEFENSE_RATING, RESILIENCE_RATING, MELEE_CRIT_AVOID_RATING
	{
		option = "sumCritAvoid",
		name = "MELEE_CRIT_AVOID",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["MELEE_CRIT_AVOID_RATING"] or 0), "MELEE_CRIT_AVOID_RATING", calcLevel)
			 + StatLogic:GetEffectFromRating((sum["RESILIENCE_RATING"] or 0), "RESILIENCE_RATING", calcLevel)
			 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04 end,
		ispercent = true,
	},
	-- Resilience - RESILIENCE_RATING
	{
		option = "sumResilience",
		name = "RESILIENCE_RATING",
		func = function(sum) return (sum["RESILIENCE_RATING"] or 0) end,
	},
	-- Arcane Resistance - ARCANE_RES
	{
		option = "sumArcaneResist",
		name = "ARCANE_RES",
		func = function(sum) return (sum["ARCANE_RES"] or 0) end,
	},
	-- Fire Resistance - FIRE_RES
	{
		option = "sumFireResist",
		name = "FIRE_RES",
		func = function(sum) return (sum["FIRE_RES"] or 0) end,
	},
	-- Nature Resistance - NATURE_RES
	{
		option = "sumNatureResist",
		name = "NATURE_RES",
		func = function(sum) return (sum["NATURE_RES"] or 0) end,
	},
	-- Frost Resistance - FROST_RES
	{
		option = "sumFrostResist",
		name = "FROST_RES",
		func = function(sum) return (sum["FROST_RES"] or 0) end,
	},
	-- Shadow Resistance - SHADOW_RES
	{
		option = "sumShadowResist",
		name = "SHADOW_RES",
		func = function(sum) return (sum["SHADOW_RES"] or 0) end,
	},
	-- Defense - DEFENSE_RATING
	{
		option = "sumDefense",
		name = "DEFENSE",
		func = function(sum) return StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) end,
	},
	-- Avoidance - PARRY, DODGE, MOBMISS
	{
		option = "sumAvoidance",
		name = "AVOIDANCE",
		ispercent = true,
		func = function(sum)
			local dodge, parry, mobMiss, block
			if GetParryChance() == 0 then
				parry = 0
			else
				--parry = summaryCalcData["PARRY"].func(sum)
				parry = StatLogic:GetEffectFromRating((sum["PARRY_RATING"] or 0), "PARRY_RATING", calcLevel)
				 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
			end
			dodge = StatLogic:GetEffectFromRating((sum["DODGE_RATING"] or 0), "DODGE_RATING", calcLevel)
			 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
			 + StatLogic:GetDodgeFromAgi(sum["AGI"])
			mobMiss = (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
			if profileDB.sumAvoidWithBlock then
				if GetBlockChance() == 0 then
					block = 0
				else
					block = StatLogic:GetEffectFromRating((sum["BLOCK_RATING"] or 0), "BLOCK_RATING", calcLevel)
					 + (StatLogic:GetEffectFromRating((sum["DEFENSE_RATING"] or 0), "DEFENSE_RATING", calcLevel) + (sum["DEFENSE"] or 0)) * 0.04
				end
				return parry + dodge + mobMiss + block
			end
			return parry + dodge + mobMiss
		end,
		ispercent = true,
	},
}
if tpSupport == true then
	-- TankPoints
	tinsert(summaryCalcData, {
		option = "sumTankPoints",
		name = "TANKPOINTS",
		func = function(diffTable1)
			-- Item type
			local itemType = diffTable1.itemType
			local right
			-- Calculate current TankPoints
			local tpSource = {}
			local TP = TankPoints
			local TPTips = TankPointsTooltips
			TP:GetSourceData(tpSource, TP_MELEE)
			local tpResults = {}
			copyTable(tpResults, tpSource)
			TP:GetTankPoints(tpResults, TP_MELEE)
			-- Update if different
			if floor(TP.resultsTable.tankPoints[TP_MELEE]) ~= floor(tpResults.tankPoints[TP_MELEE]) then
				copyTable(TP.sourceTable, tpSource)
				copyTable(TP.resultsTable, tpResults)
			end
			----------------------------------------------------
			-- Calculate TP difference with 1st equipped item --
			----------------------------------------------------
			local tpTable = {}
			-- Set the forceShield arg
			local forceShield
			-- if not equipped shield and item is shield then force on
			-- if not equipped shield and item is not shield then nil
			-- if equipped shield and item is shield then nil
			-- if equipped shield and item is not shield then force off
			if ((diffTable1.diffItemType1 ~= "INVTYPE_SHIELD") and (diffTable1.diffItemType2 ~= "INVTYPE_SHIELD")) and (itemType == "INVTYPE_SHIELD") then
				forceShield = true
			elseif ((diffTable1.diffItemType1 == "INVTYPE_SHIELD") or (diffTable1.diffItemType2 == "INVTYPE_SHIELD")) and (itemType ~= "INVTYPE_SHIELD") then
				forceShield = false
			end
			-- Get the tp table
			TP:GetSourceData(tpTable, TP_MELEE, forceShield)
			-- Build changes table
			local changes = TPTips:BuildChanges({}, diffTable1)
			-- Alter tp table
			TP:AlterSourceData(tpTable, changes, forceShield)
			-- Calculate TankPoints from tpTable
			TP:GetTankPoints(tpTable, TP_MELEE, forceShield)
			-- Calculate tp difference
			local diff = floor(tpTable.tankPoints[TP_MELEE]) - floor(TP.resultsTable.tankPoints[TP_MELEE])
	
			return diff
		end,
	})
	-- Total Reduction
	tinsert(summaryCalcData, {
		option = "sumTotalReduction",
		name = "TOTALREDUCTION",
		ispercent = true,
		func = function(diffTable1)
			-- Item type
			local itemType = diffTable1.itemType
			local right
			-- Calculate current TankPoints
			local tpSource = {}
			local TP = TankPoints
			local TPTips = TankPointsTooltips
			TP:GetSourceData(tpSource, TP_MELEE)
			local tpResults = {}
			copyTable(tpResults, tpSource)
			TP:GetTankPoints(tpResults, TP_MELEE)
			-- Update if different
			if floor(TP.resultsTable.tankPoints[TP_MELEE]) ~= floor(tpResults.tankPoints[TP_MELEE]) then
				copyTable(TP.sourceTable, tpSource)
				copyTable(TP.resultsTable, tpResults)
			end
			----------------------------------------------------
			-- Calculate TP difference with 1st equipped item --
			----------------------------------------------------
			local tpTable = {}
			-- Set the forceShield arg
			local forceShield
			-- if not equipped shield and item is shield then force on
			-- if not equipped shield and item is not shield then nil
			-- if equipped shield and item is shield then nil
			-- if equipped shield and item is not shield then force off
			if ((diffTable1.diffItemType1 ~= "INVTYPE_SHIELD") and (diffTable1.diffItemType2 ~= "INVTYPE_SHIELD")) and (itemType == "INVTYPE_SHIELD") then
				forceShield = true
			elseif ((diffTable1.diffItemType1 == "INVTYPE_SHIELD") or (diffTable1.diffItemType2 == "INVTYPE_SHIELD")) and (itemType ~= "INVTYPE_SHIELD") then
				forceShield = false
			end
			-- Get the tp table
			TP:GetSourceData(tpTable, TP_MELEE, forceShield)
			-- Build changes table
			local changes = TPTips:BuildChanges({}, diffTable1)
			-- Alter tp table
			TP:AlterSourceData(tpTable, changes, forceShield)
			-- Calculate TankPoints from tpTable
			TP:GetTankPoints(tpTable, TP_MELEE, forceShield)
			-- Calculate tp difference
			local diff = tpTable.totalReduction[TP_MELEE] - TP.resultsTable.totalReduction[TP_MELEE]
			
			return diff * 100
		end,
	})
	--[[
	-- Avoidance
	tinsert(summaryCalcData, {
		option = "sumAvoidance",
		name = "AVOIDANCE",
		ispercent = true,
		func = function(diffTable1)
			-- Item type
			local itemType = diffTable1.itemType
			local right
			-- Calculate current TankPoints
			local tpSource = {}
			local TP = TankPoints
			local TPTips = TankPointsTooltips
			TP:GetSourceData(tpSource, TP_MELEE)
			local tpResults = {}
			copyTable(tpResults, tpSource)
			TP:GetTankPoints(tpResults, TP_MELEE)
			-- Update if different
			if floor(TP.resultsTable.tankPoints[TP_MELEE]) ~= floor(tpResults.tankPoints[TP_MELEE]) then
				copyTable(TP.sourceTable, tpSource)
				copyTable(TP.resultsTable, tpResults)
			end
			----------------------------------------------------
			-- Calculate TP difference with 1st equipped item --
			----------------------------------------------------
			local tpTable = {}
			-- Set the forceShield arg
			local forceShield
			-- if not equipped shield and item is shield then force on
			-- if not equipped shield and item is not shield then nil
			-- if equipped shield and item is shield then nil
			-- if equipped shield and item is not shield then force off
			if ((diffTable1.diffItemType1 ~= "INVTYPE_SHIELD") and (diffTable1.diffItemType2 ~= "INVTYPE_SHIELD")) and (itemType == "INVTYPE_SHIELD") then
				forceShield = true
			elseif ((diffTable1.diffItemType1 == "INVTYPE_SHIELD") or (diffTable1.diffItemType2 == "INVTYPE_SHIELD")) and (itemType ~= "INVTYPE_SHIELD") then
				forceShield = false
			end
			-- Get the tp table
			TP:GetSourceData(tpTable, TP_MELEE, forceShield)
			-- Build changes table
			local changes = TPTips:BuildChanges({}, diffTable1)
			-- Alter tp table
			TP:AlterSourceData(tpTable, changes, forceShield)
			-- Calculate TankPoints from tpTable
			TP:GetTankPoints(tpTable, TP_MELEE, forceShield)
			-- Calculate tp difference
			local diff = tpTable.mobMissChance + tpTable.dodgeChance + tpTable.parryChance - TP.resultsTable.mobMissChance - TP.resultsTable.dodgeChance - TP.resultsTable.parryChance
			
			return diff * 100
		end,
	})
	--]]
end


function sumSortAlphaComp(a, b)
	return a[1] < b[1]
end

function RatingBuster:StatSummary(tooltip, name, link)
	-- Hide stat summary for equipped items
	if profileDB.sumIgnoreEquipped and IsEquippedItem(link) then return end
	
	-- Show stat summary only for highest level armor type and items you can use with uncommon quality and up
	if profileDB.sumIgnoreUnused then
		local _, _, itemRarity, _, _, _, itemSubType, _, itemEquipLoc = GetItemInfo(link)
		
		-- Check rarity
		if not itemRarity or itemRarity < 2 then
			return
		end

		-- Check armor type
		if armorTypes[itemSubType] and (not classArmorTypes[class][itemSubType]) and itemEquipLoc ~= "INVTYPE_CLOAK" then
			--self:Print("Check armor type", itemSubType)
			return
		end
		
		-- Check for Red item types
		local tName = tooltip:GetName()
		if _G[tName.."TextRight3"]:GetText() and select(2, _G[tName.."TextRight3"]:GetTextColor()) < 0.2 then
			--self:Print("TextRight3", select(2, _G[tName.."TextRight3"]:GetTextColor()))
			return
		end
		if _G[tName.."TextRight4"]:GetText() and select(2, _G[tName.."TextRight4"]:GetTextColor()) < 0.2 then
			--self:Print("TextRight4", select(2, _G[tName.."TextRight4"]:GetTextColor()))
			return
		end
		if select(2, _G[tName.."TextLeft3"]:GetTextColor()) < 0.2 then
			--self:Print("TextLeft3", select(2, _G[tName.."TextLeft3"]:GetTextColor()))
			return
		end
		if select(2, _G[tName.."TextLeft4"]:GetTextColor()) < 0.2 then
			--self:Print("TextLeft4", select(2, _G[tName.."TextLeft4"]:GetTextColor()))
			return
		end
	end
	
	-- Ignore enchants and gems on items when calculating the stat summary
	local red = profileDB.sumGemRed.gemID
	local yellow = profileDB.sumGemYellow.gemID
	local blue = profileDB.sumGemBlue.gemID
	local meta = profileDB.sumGemMeta.gemID
	
	if profileDB.sumIgnoreEnchant then
		link = StatLogic:RemoveEnchant(link)
	end
	if profileDB.sumIgnoreGems then
		link = StatLogic:RemoveGem(link)
	else
		link = StatLogic:BuildGemmedTooltip(link, red, yellow, blue, meta)
	end
	
	-- Diff Display Style
	-- Main Tooltip: tooltipLevel = 0
	-- Compare Tooltip 1: tooltipLevel = 1
	-- Compare Tooltip 2: tooltipLevel = 2
	local id
	local tooltipLevel = 0
	local mainTooltip = tooltip
	-- Determine tooltipLevel and id
	if profileDB.calcDiff and (profileDB.sumDiffStyle == "comp") then
		-- Obtain main tooltip
		for _, t in pairs(TipHooker.SupportedTooltips) do
			if mainTooltip:IsOwned(t) then
				mainTooltip = t
				break
			end
		end
		for _, t in pairs(TipHooker.SupportedTooltips) do
			if mainTooltip:IsOwned(t) then
				mainTooltip = t
				break
			end
		end
		-- Detemine tooltip level
		local _, mainlink, difflink1, difflink2 = StatLogic:GetDiffID(mainTooltip, profileDB.sumIgnoreEnchant, profileDB.sumIgnoreGems, red, yellow, blue, meta)
		if link == mainlink then
			tooltipLevel = 0
		elseif link == difflink1 then
			tooltipLevel = 1
		elseif link == difflink2 then
			tooltipLevel = 2
		end
		-- Construct id
		if tooltipLevel > 0 then
			id = link..mainlink
		else
			id = "sum"..link
		end
	else
		id = StatLogic:GetDiffID(link, profileDB.sumIgnoreEnchant, profileDB.sumIgnoreGems, red, yellow, blue, meta)
	end
	
	-- Check Cache
	if cache[id] then
		if table.maxn(cache[id]) == 0 then return end
		-- Write Tooltip
		if profileDB.sumBlankLine then
			tooltip:AddLine(" ")
		end
		if profileDB.sumShowTitle then
			tooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..L["Stat Summary"]..FONT_COLOR_CODE_CLOSE)
			if profileDB.sumShowIcon then
				tooltip:AddTexture("Interface\\AddOns\\RatingBuster\\images\\Sigma")
			end
		end
		for _, o in ipairs(cache[id]) do
			tooltip:AddDoubleLine(o[1], o[2])
		end
		if profileDB.sumBlankLineAfter then
			tooltip:AddLine(" ")
		end
		return
	end
	
	-------------------------
	-- Build Summary Table --
	local statData = {}
	statData.sum = StatLogic:GetSum(link)
	if not statData.sum then return end
	if not profileDB.calcSum then
		statData.sum = nil
	end
	
	-- Ignore bags
	if not StatLogic:GetDiff(link) then return end
	
	-- Get Diff Data
	if profileDB.calcDiff then
		if profileDB.sumDiffStyle == "comp" then
			if tooltipLevel > 0 then
				statData.diff1 = select(tooltipLevel, StatLogic:GetDiff(mainTooltip, nil, nil, profileDB.sumIgnoreEnchant, profileDB.sumIgnoreGems, red, yellow, blue, meta))
			end
		else
			statData.diff1, statData.diff2 = StatLogic:GetDiff(link, nil, nil, profileDB.sumIgnoreEnchant, profileDB.sumIgnoreGems, red, yellow, blue, meta)
		end
	end
	-- Apply Base Stat Mods
	for _, v in pairs(statData) do
		v["STR"] = (v["STR"] or 0)
		v["AGI"] = (v["AGI"] or 0)
		v["STA"] = (v["STA"] or 0)
		v["INT"] = (v["INT"] or 0)
		v["SPI"] = (v["SPI"] or 0)
	end
	if profileDB.enableStatMods then
		for _, v in pairs(statData) do
			v["STR"] = v["STR"] * StatLogic:GetStatMod("MOD_STR")
			v["AGI"] = v["AGI"] * StatLogic:GetStatMod("MOD_AGI")
			v["STA"] = v["STA"] * StatLogic:GetStatMod("MOD_STA")
			v["INT"] = v["INT"] * StatLogic:GetStatMod("MOD_INT")
			v["SPI"] = v["SPI"] * StatLogic:GetStatMod("MOD_SPI")
		end
	end
	-- Summary Table
	--[[
	local statData = {
		sum = {},
		diff1 = {},
		diff2 = {},
	}
	if profileDB.sumHP then
		local d = {name = "HEALTH"}
		for k, sum in pairs(data) do
			d[k] = ((sum["HEALTH"] or 0) + (sum["STA"] * 10)) * StatLogic:GetStatMod("MOD_HEALTH")
		end
		tinsert(summary, d)
	end
	local summaryCalcData = {
		-- Health - HEALTH, STA
		sumHP = {
			name = "HEALTH",
			func = function(sum) return ((sum["HEALTH"] or 0) + (sum["STA"] * 10)) * StatLogic:GetStatMod("MOD_HEALTH") end,
			ispercent = false,
		},
	}
	--]]
	local summary = {}
	for _, calcData in pairs(summaryCalcData) do
		if profileDB[calcData.option] then
			local entry = {
				name = calcData.name,
				ispercent = calcData.ispercent,
			}
			for statDataType, statTable in pairs(statData) do
				if tpSupport and ((calcData.name == "TANKPOINTS") or (calcData.name == "TOTALREDUCTION")) and (statDataType == "sum") then
					entry[statDataType] = nil
				else
					entry[statDataType] = calcData.func(statTable)
				end
			end
			tinsert(summary, entry)
		end
	end
	
	local calcSum = profileDB.calcSum
	local calcDiff = profileDB.calcDiff
	-- Weapon Skill - WEAPON_RATING
	if profileDB.sumWeaponSkill then
		local weapon = {}
		if calcSum then
			for id, v in pairs(statData.sum) do
				if strsub(id, -13) == "WEAPON_RATING" then
					weapon[id] = true
					local entry = {
						name = strsub(id, 1, -8),
					}
					entry.sum = StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel)
					if calcDiff and statData.diff1 then
						entry.diff1 = StatLogic:GetEffectFromRating((statData.diff1[id] or 0), CR_WEAPON_SKILL, calcLevel)
						if statData.diff2 then
							entry.diff2 = StatLogic:GetEffectFromRating((statData.diff2[id] or 0), CR_WEAPON_SKILL, calcLevel)
						end
					end
					tinsert(summary, entry)
				end
			end
		end
		if calcDiff and statData.diff1 then
			for id, v in pairs(statData.diff1) do
				if (strsub(id, -13) == "WEAPON_RATING") and not weapon[id] then
					weapon[id] = true
					local entry = {
						name = strsub(id, 1, -8),
						sum = 0,
					}
					entry.diff1 = StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel)
					if statData.diff2 then
						entry.diff2 = StatLogic:GetEffectFromRating((statData.diff2[id] or 0), CR_WEAPON_SKILL, calcLevel)
					end
					tinsert(summary, entry)
				end
			end
			if statData.diff2 then
				for id, v in pairs(statData.diff2) do
					if (strsub(id, -13) == "WEAPON_RATING") and not weapon[id] then
						weapon[id] = true
						local entry = {
							name = strsub(id, 1, -8),
							sum = 0,
							diff1 = 0,
						}
						entry.diff2 = StatLogic:GetEffectFromRating(v, CR_WEAPON_SKILL, calcLevel)
						tinsert(summary, entry)
					end
				end
			end
		end
	end
	
	local showZeroValueStat = profileDB.showZeroValueStat
	------------------------
	-- Build Output Table --
	local output = {}
	for _, t in ipairs(summary) do
		local n, s, d1, d2, ispercent = t.name, t.sum, t.diff1, t.diff2, t.ispercent
		local right, left
		local skip
		if not showZeroValueStat then
			if (s == 0 or not s) and (d1 == 0 or not d1) and (d2 == 0 or not d2) then
				skip = true
			end
		end
		if not skip then
			if calcSum and calcDiff then
				local d = ((not s) or ((s - floor(s)) == 0)) and ((not d1) or ((d1 - floor(d1)) == 0)) and ((not d2) or ((d2 - floor(d2)) == 0)) and not ispercent
				if s then
					if d then
						s = format("%d", s)
					elseif ispercent then
						s = format("%.2f%%", s)
					else
						s = format("%.1f", s)
					end
					if d1 then
						if d then
							d1 = colorNum(format("%+d", d1), d1)
						elseif ispercent then
							d1 = colorNum(format("%+.2f%%", d1), d1)
						else
							d1 = colorNum(format("%+.1f", d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(format("%+d", d2), d2)
							elseif ispercent then
								d2 = colorNum(format("%+.2f%%", d2), d2)
							else
								d2 = colorNum(format("%+.1f", d2), d2)
							end
							right = format("%s (%s||%s)", s, d1, d2)
						else
							right = format("%s (%s)", s, d1)
						end
					else
						right = s
					end
				else
					if d1 then
						if d then
							d1 = colorNum(format("%+d", d1), d1)
						elseif ispercent then
							d1 = colorNum(format("%+.2f%%", d1), d1)
						else
							d1 = colorNum(format("%+.1f", d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(format("%+d", d2), d2)
							elseif ispercent then
								d2 = colorNum(format("%+.2f%%", d2), d2)
							else
								d2 = colorNum(format("%+.1f", d2), d2)
							end
							right = format("(%s||%s)", d1, d2)
						else
							right = format("(%s)", d1)
						end
					end
				end
			elseif calcSum then
				if s then
					if (s - floor(s)) == 0 then
						s = format("%d", s)
					elseif ispercent then
						s = format("%.2f%%", s)
					else
						s = format("%.1f", s)
					end
					right = s
				end
			elseif calcDiff then
				local d = ((not d1) or (d1 - floor(d1)) == 0) and ((not d2) or ((d2 - floor(d2)) == 0))
				if d1 then
					if d then
						d1 = colorNum(format("%+d", d1), d1)
					elseif ispercent then
						d1 = colorNum(format("%+.2f%%", d1), d1)
					else
						d1 = colorNum(format("%+.1f", d1), d1)
					end
					if d2 then
						if d then
							d2 = colorNum(format("%+d", d2), d2)
						elseif ispercent then
							d2 = colorNum(format("%+.2f%%", d2), d2)
						else
							d2 = colorNum(format("%+.1f", d2), d2)
						end
						right = format("%s||%s", d1, d2)
					else
						right = d1
					end
				end
			end
			if right then
				if n == "TANKPOINTS" then
					if tpSupport then
						left = tpLocale["TankPoints"]
					else
						left = "TankPoints"
					end
				elseif n == "TOTALREDUCTION" then
					if tpSupport then
						left = tpLocale["Total Reduction"]
					else
						left = "Total Reduction"
					end
				else
					left = StatLogic:GetStatNameFromID(n)
				end
				tinsert(output, {left, right})
			end
		end
	end
	-- sort alphabetically if option enabled
	if profileDB.sumSortAlpha then
		tsort(output, sumSortAlphaComp)
	end
	-- Write cache
	cache[id] = output
	if table.maxn(output) == 0 then return end
	-------------------
	-- Write Tooltip --
	if profileDB.sumBlankLine then
		tooltip:AddLine(" ")
	end
	if profileDB.sumShowTitle then
		tooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..L["Stat Summary"]..FONT_COLOR_CODE_CLOSE)
		if profileDB.sumShowIcon then
			tooltip:AddTexture("Interface\\AddOns\\RatingBuster\\images\\Sigma")
		end
	end
	for _, o in ipairs(output) do
		tooltip:AddDoubleLine(o[1], o[2])
	end
	if profileDB.sumBlankLineAfter then
		tooltip:AddLine(" ")
	end
end


-- RatingBuster:Bench(1000)
---------
-- self:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ","})
-- 1000 times: 0.16 - 0.18 without Compost
-- 1000 times: 0.22 - 0.24 with Compost
---------
-- RatingBuster.ProcessTooltip(ItemRefTooltip, link)
-- 1000 times: 0.31 sec - 0.7.6
-- 1000 times: 0.29 sec - 0.
-- 1000 times: 0.24 sec - 0.8.58.0
---------
-- strjoin 1000000 times: 0.46
-- ..      1000000 times: 0.27
--------------
function RatingBuster:Bench(k)
	local t1 = GetTime()
	local link = GetInventoryItemLink("player", 12)
	for i = 1, k, 1 do
		---------------------------------------------------------------------------
		--self:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ","})
		---------------------------------------------------------------------------
		ItemRefTooltip:SetInventoryItem("player", 12)
		RatingBuster.ProcessTooltip(ItemRefTooltip, link)
		---------------------------------------------------------------------------
		--ItemRefTooltip:SetScript("OnTooltipSetItem", function(frame, ...) RatingBuster:Print("OnTooltipSetItem") end)
		----------------------------------------------------------------------
		--local h = strjoin("", "test", "123")
		--local h = "test".."123"
		--------------------------------------------------------------------------------
	end
	return GetTime() - t1
end
