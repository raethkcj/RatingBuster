local addonName = ...

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
local StatLogic = LibStub("StatLogic")
local GSM = function(...)
	return StatLogic:GetStatMod(...)
end
local L = LibStub("AceLocale-3.0"):GetLocale("RatingBuster")

--------------------
-- AceAddon Setup --
--------------------
---@class RatingBuster: AceAddon, AceConsole-3.0, AceEvent-3.0, AceBucket-3.0
RatingBuster = LibStub("AceAddon-3.0"):NewAddon("RatingBuster", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
RatingBuster.title = "Rating Buster"
--[===[@non-debug@
RatingBuster.version = "@project-version@"
--@end-non-debug@]===]
--@debug@
RatingBuster.version = "(development)"
--@end-debug@
local addonNameWithVersion = string.format("%s %s", addonName, RatingBuster.version)
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
local profileDB, globalDB -- Initialized in :OnInitialize()

-- Localize globals
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
local tocversion = select(4, GetBuildInfo())

local GetItemInfoCached = setmetatable({}, { __index = function(self, n)
	self[n] = {GetItemInfo(n)} -- store in cache
	return self[n] -- return result
end })
local GetItemInfo = function(item)
	return unpack(GetItemInfoCached[item])
end
local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance

---------------------------
-- Slash Command Options --
---------------------------

local function getOption(info)
	if type(globalDB[info[#info]]) ~= "nil" then
		return globalDB[info[#info]]
	else
		return profileDB[info[#info]]
	end
end
local function setOptionAndClearCache(info, value)
	if type(globalDB[info[#info]]) ~= "nil" then
		globalDB[info[#info]] = value
	else
		profileDB[info[#info]] = value
	end
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
local function getColor(info)
	local color = globalDB[info[#info]]
	if not color then
		color = profileDB[info[#info]]
	end
	return color:GetRGB()
end
local function setColor(info, r, g, b)
	local color = globalDB[info[#info]]
	if not color then
		color = profileDB[info[#info]]
	end
	color:SetRGB(r, g, b)
	clearCache()
end

ColorPickerFrame:SetMovable(true)
ColorPickerFrame:EnableMouse(true)
ColorPickerFrame:RegisterForDrag("LeftButton")
ColorPickerFrame:SetScript("OnDragStart", function(self, button)
	for _, frame in ipairs(C_System.GetFrameStack()) do
		if frame == ColorPickerFrameHeader then
			ColorPickerFrame:StartMoving()
		end
	end
end)
ColorPickerFrame:SetScript("OnDragStop", ColorPickerFrame.StopMovingOrSizing)

local options = {
	type = 'group',
	get = getOption,
	set = setOptionAndClearCache,
	args = {
		help = {
			type = 'execute',
			name = L["Help"],
			desc = L["Show this help message"],
			func = function()
				LibStub("AceConfigCmd-3.0").HandleCommand(RatingBuster, "rb", addonNameWithVersion, "")
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
			max = GetMaxPlayerLevel(),
			step = 1,
		},
		rating = {
			type = 'group',
			name = L["Rating"],
			desc = L["Options for Rating display"],
			order = 1,
			args = {
				showRatings = {
					type = 'toggle',
					name = L["Show Rating conversions"],
					desc = L["Show Rating conversions in tooltips"],
				},
				ratingSpell = {
					type = 'toggle',
					name = L["Show Spell Hit/Haste"],
					desc = L["Show Spell Hit/Haste from Hit/Haste Rating"],
					hidden = function()
						local genericHit = StatLogic.GenericStatMap[StatLogic.GenericStats.CR_HIT]
						return (not genericHit) or (not tContains(genericHit, CR_HIT_SPELL))
					end
				},
				ratingPhysical = {
					type = 'toggle',
					name = L["Show Physical Hit/Haste"],
					desc = L["Show Physical Hit/Haste from Hit/Haste Rating"],
				},
				detailedConversionText = {
					type = 'toggle',
					name = L["Show detailed conversions text"],
					desc = L["Show detailed text for Resilience and Expertise conversions"],
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
				enableAvoidanceDiminishingReturns = {
					type = 'toggle',
					name = L["Enable Avoidance Diminishing Returns"],
					desc = L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"],
					hidden = function()
						return not StatLogic.GetAvoidanceAfterDR
					end,
				},
			},
		},
		stat = {
			type = 'group',
			name = L["Stat Breakdown"],
			desc = L["Changes the display of base stats"],
			order = 2,
			args = {
				showStats = {
					type = 'toggle',
					name = L["Show base stat conversions"],
					desc = L["Show base stat conversions in tooltips"],
					width = "full",
					order = 1,
				},
				textColor = {
					type = 'color',
					name = L["Change text color"],
					desc = L["Changes the color of added text"],
					get = getColor,
					set = setColor,
					order = 2,
				},
				str = {
					type = 'group',
					name = L["Strength"],
					desc = L["Changes the display of Strength"],
					width = "full",
					order = 3,
					args = {
						showAPFromStr = {
							type = 'toggle',
							name = L["Show Attack Power"],
							desc = L["Show Attack Power from Strength"],
							width = "full",
						},
						showBlockValueFromStr = {
							type = 'toggle',
							name = L["Show Block Value"],
							desc = L["Show Block Value from Strength"],
							width = "full",
						},
					},
				},
				agi = {
					type = 'group',
					name = L["Agility"],
					desc = L["Changes the display of Agility"],
					width = "full",
					order = 4,
					args = {
						showCritFromAgi = {
							type = 'toggle',
							name = L["Show Crit"],
							desc = L["Show Crit chance from Agility"],
							width = "full",
						},
						showDodgeFromAgi = {
							type = 'toggle',
							name = L["Show Dodge"],
							desc = L["Show Dodge chance from Agility"],
							width = "full",
						},
						showAPFromAgi = {
							type = 'toggle',
							name = L["Show Attack Power"],
							desc = L["Show Attack Power from Agility"],
							width = "full",
						},
						showRAPFromAgi = {
							type = 'toggle',
							name = L["Show Ranged Attack Power"],
							desc = L["Show Ranged Attack Power from Agility"],
							width = "full",
						},
						showArmorFromAgi = {
							type = 'toggle',
							name = L["Show Armor"],
							desc = L["Show Armor from Agility"],
							width = "full",
						},
					},
				},
				sta = {
					type = 'group',
					name = L["Stamina"],
					desc = L["Changes the display of Stamina"],
					width = "full",
					order = 5,
					args = {
						showHealthFromSta = {
							type = 'toggle',
							name = L["Show Health"],
							desc = L["Show Health from Stamina"],
							width = "full",
						},
					},
				},
				int = {
					type = 'group',
					name = L["Intellect"],
					desc = L["Changes the display of Intellect"],
					width = "full",
					order = 6,
					args = {
						showSpellCritFromInt = {
							type = 'toggle',
							name = L["Show Spell Crit"],
							desc = L["Show Spell Crit chance from Intellect"],
							width = "full",
						},
						showManaFromInt = {
							type = 'toggle',
							name = L["Show Mana"],
							desc = L["Show Mana from Intellect"],
							width = "full",
						},
						showMP5FromInt = {
							type = 'toggle',
							name = L["Show Mana Regen"],
							desc = L["Show Mana Regen while casting from Intellect"],
							width = "full",
						},
						showMP5NCFromInt = {
							type = 'toggle',
							name = L["Show Mana Regen while NOT casting"],
							desc = L["Show Mana Regen while NOT casting from Intellect"],
							width = "full",
						},
					},
				},
				spi = {
					type = 'group',
					name = L["Spirit"],
					desc = L["Changes the display of Spirit"],
					width = "full",
					order = 7,
					args = {
						showMP5NCFromSpi = {
							type = 'toggle',
							name = L["Show Mana Regen while NOT casting"],
							desc = L["Show Mana Regen while NOT casting from Spirit"],
							width = "full",
						},
						showHP5FromSpi = {
							type = 'toggle',
							name = L["Show Health Regen"],
							desc = L["Show Health Regen from Spirit"],
							width = "full",
						},
					},
				},
				ap = {
					type = 'group',
					name = L["Attack Power"],
					desc = L["Changes the display of Attack Power"],
					order = 8,
					args = {},
					hidden = true,
				},
				armor = {
					type = 'group',
					name = L["Armor"],
					desc = L["Changes the display of Armor"],
					order = 9,
					args = {},
					hidden = true,
				},
			},
		},
		sum = {
			type = 'group',
			name = L["Stat Summary"],
			desc = L["Options for stat summary"],
			order = 3,
			args = {
				showSum = {
					type = 'toggle',
					name = L["Show stat summary"],
					desc = L["Show stat summary in tooltips"],
					order = 1,
				},
				calcSum = {
					type = 'toggle',
					name = L["Calculate stat sum"],
					desc = L["Calculate the total stats for the item"],
					order = 2,
				},
				calcDiff = {
					type = 'toggle',
					name = L["Calculate stat diff"],
					desc = L["Calculate the stat difference for the item and equipped items"],
					order = 3,
				},
				sumDiffStyle = {
					type = 'select',
					name = L["Display style for diff value"],
					desc = L["Display diff values in the main tooltip or only in compare tooltips"],
					values = {
						["comp"] = "Compare",
						["main"] = "Main"
					},
					order = 4,
				},
				hideBlizzardComparisons = {
					type = 'toggle',
					name = L["Hide Blizzard Item Comparisons"],
					desc = L["Disable Blizzard stat change summary when using the built-in comparison tooltip"],
					width = "double",
					order = 4.5,
				},
				sumShowIcon = {
					type = 'toggle',
					name = L["Show icon"],
					desc = L["Show the sigma icon before summary listing"],
					order = 5,
				},
				sumShowTitle = {
					type = 'toggle',
					name = L["Show title text"],
					desc = L["Show the title text before summary listing"],
					order = 6,
				},
				showZeroValueStat = {
					type = 'toggle',
					name = L["Show zero value stats"],
					desc = L["Show zero value stats in summary for consistancy"],
					order = 7,
				},
				sumSortAlpha = {
					type = 'toggle',
					name = L["Sort StatSummary alphabetically"],
					desc = L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"],
					order = 8,
				},
				space = {
					type = 'group',
					name = L["Add empty line"],
					inline = true,
					args = {
						sumBlankLine = {
							type = 'toggle',
							name = L["Add before summary"],
							desc = L["Add a empty line before stat summary"],
							order = 10,
						},
						sumBlankLineAfter = {
							type = 'toggle',
							name = L["Add after summary"],
							desc = L["Add a empty line after stat summary"],
							order = 11,
						},
					},
				},
				sumStatColor = {
					type = 'color',
					name = L["Change text color"],
					desc = L["Changes the color of added text"],
					get = getColor,
					set = setColor,
					order = 13,
				},
				sumValueColor = {
					type = 'color',
					name = L["Change number color"],
					desc = L["Changes the color of added text"],
					get = getColor,
					set = setColor,
					order = 14,
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
				basic = {
					type = 'group',
					name = L["Stat - Basic"],
					desc = L["Choose basic stats for summary"],
					args = {
						sumHP = {
							type = 'toggle',
							name = L["Sum Health"],
							desc = L["Health <- Health, Stamina"],
							order = 1,
						},
						sumMP = {
							type = 'toggle',
							name = L["Sum Mana"],
							desc = L["Mana <- Mana, Intellect"],
							order = 2,
						},
						sumMP5 = {
							type = 'toggle',
							name = L["Sum Mana Regen"],
							desc = L["Mana Regen <- Mana Regen, Spirit"],
							order = 3,
						},
						sumMP5NC = {
							type = 'toggle',
							name = L["Sum Mana Regen while not casting"],
							desc = L["Mana Regen while not casting <- Spirit"],
							order = 4,
						},
						sumHP5 = {
							type = 'toggle',
							name = L["Sum Health Regen"],
							desc = L["Health Regen <- Health Regen"],
							order = 5,
						},
						sumHP5OC = {
							type = 'toggle',
							name = L["Sum Health Regen when out of combat"],
							desc = L["Health Regen when out of combat <- Spirit"],
							order = 6,
						},
						sumStr = {
							type = 'toggle',
							name = L["Sum Strength"],
							desc = L["Strength Summary"],
							order = 7,
						},
						sumAgi = {
							type = 'toggle',
							name = L["Sum Agility"],
							desc = L["Agility Summary"],
							order = 8,
						},
						sumSta = {
							type = 'toggle',
							name = L["Sum Stamina"],
							desc = L["Stamina Summary"],
							order = 9,
						},
						sumInt = {
							type = 'toggle',
							name = L["Sum Intellect"],
							desc = L["Intellect Summary"],
							order = 10,
						},
						sumSpi = {
							type = 'toggle',
							name = L["Sum Spirit"],
							desc = L["Spirit Summary"],
							order = 11,
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
							width = "double",
							order = 1,
						},
						sumHit = {
							type = 'toggle',
							name = L["Sum Hit Chance"],
							desc = L["Hit Chance <- Hit Rating, Weapon Skill Rating"],
							order = 2,
						},
						sumHitRating = {
							type = 'toggle',
							name = L["Sum Hit Rating"],
							desc = L["Hit Rating Summary"],
							order = 3,
						},
						sumCrit = {
							type = 'toggle',
							name = L["Sum Crit Chance"],
							desc = L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"],
							order = 4,
						},
						sumCritRating = {
							type = 'toggle',
							name = L["Sum Crit Rating"],
							desc = L["Crit Rating Summary"],
							order = 5,
						},
						sumHaste = {
							type = 'toggle',
							name = L["Sum Haste"],
							desc = L["Haste <- Haste Rating"],
							order = 6,
						},
						sumHasteRating = {
							type = 'toggle',
							name = L["Sum Haste Rating"],
							desc = L["Haste Rating Summary"],
							order = 7,
						},
						sumIgnoreArmor = {
							type = 'toggle',
							name = L["Sum Ignore Armor"],
							desc = L["Ignore Armor Summary"],
							hidden = function()
								return StatLogic:RatingExists(CR_ARMOR_PENETRATION)
							end,
							order = 8,
						},
						sumArmorPenetration = {
							type = 'toggle',
							name = L["Sum Armor Penetration"],
							desc = L["Armor Penetration Summary"],
							hidden = function()
								return not StatLogic:RatingExists(CR_ARMOR_PENETRATION)
							end,
							order = 9,
						},
						sumArmorPenetrationRating = {
							type = 'toggle',
							name = L["Sum Armor Penetration Rating"],
							desc = L["Armor Penetration Rating Summary"],
							hidden = function()
								return not StatLogic:RatingExists(CR_ARMOR_PENETRATION)
							end,
							order = 10,
						},
						ranged = {
							type = 'header',
							name = L["Ranged"],
							order = 11,
						},
						sumRAP = {
							type = 'toggle',
							name = L["Sum Ranged Attack Power"],
							desc = L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"],
							width = "double",
							order = 12,
						},
						sumRangedHit = {
							type = 'toggle',
							name = L["Sum Ranged Hit Chance"],
							desc = L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"],
							order = 13,
						},
						sumRangedHitRating = {
							type = 'toggle',
							name = L["Sum Ranged Hit Rating"],
							desc = L["Ranged Hit Rating Summary"],
							order = 14,
						},
						sumRangedCrit = {
							type = 'toggle',
							name = L["Sum Ranged Crit Chance"],
							desc = L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"],
							order = 15,
						},
						sumRangedCritRating = {
							type = 'toggle',
							name = L["Sum Ranged Crit Rating"],
							desc = L["Ranged Crit Rating Summary"],
							order = 16,
						},
						sumRangedHaste = {
							type = 'toggle',
							name = L["Sum Ranged Haste"],
							desc = L["Ranged Haste <- Haste Rating, Ranged Haste Rating"],
							order = 17,
						},
						sumRangedHasteRating = {
							type = 'toggle',
							name = L["Sum Ranged Haste Rating"],
							desc = L["Ranged Haste Rating Summary"],
							order = 18,
						},
						weapon = {
							type = 'header',
							name = L["Weapon"],
							order = 19,
						},
						sumWeaponAverageDamage = {
							type = 'toggle',
							name = L["Sum Weapon Average Damage"],
							desc = L["Weapon Average Damage Summary"],
							order = 20,
						},
						sumWeaponDPS = {
							type = 'toggle',
							name = L["Sum Weapon DPS"],
							desc = L["Weapon DPS Summary"],
							order = 21,
						},
						sumDodgeNeglect = {
							type = 'toggle',
							name = L["Sum Dodge Neglect"],
							desc = L["Dodge Neglect <- Expertise, Weapon Skill Rating"],
							order = 22,
						},
						sumParryNeglect = {
							type = 'toggle',
							name = L["Sum Parry Neglect"],
							desc = L["Parry Neglect <- Expertise, Weapon Skill Rating"],
							order = 23,
						},
						sumBlockNeglect = {
							type = 'toggle',
							name = L["Sum Block Neglect"],
							desc = L["Block Neglect <- Weapon Skill Rating"],
							order = 24,
						},
						sumWeaponSkill = {
							type = 'toggle',
							name = L["Sum Weapon Skill"],
							desc = L["Weapon Skill <- Weapon Skill Rating"],
							order = 25,
						},
						sumExpertise = {
							type = 'toggle',
							name = L["Sum Expertise"],
							desc = L["Expertise <- Expertise Rating"],
							order = 26,
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
						sumAvoidance = {
							type = 'toggle',
							name = L["Sum Avoidance"],
							desc = L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"],
							order = 1,
						},
						sumAvoidWithBlock = {
							type = 'toggle',
							name = L["Include block chance in Avoidance summary"],
							desc = L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"],
							order = 2,
						},
						sumDodge = {
							type = 'toggle',
							name = L["Sum Dodge Chance"],
							desc = L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"],
							order = 3,
						},
						sumDodgeRating = {
							type = 'toggle',
							name = L["Sum Dodge Rating"],
							desc = L["Dodge Rating Summary"],
							order = 4,
						},
						sumBlock = {
							type = 'toggle',
							name = L["Sum Block Chance"],
							desc = L["Block Chance <- Block Rating, Defense Rating"],
							order = 5,
						},
						sumBlockRating = {
							type = 'toggle',
							name = L["Sum Block Rating"],
							desc = L["Block Rating Summary"],
							order = 6,
						},
						sumBlockValue = {
							type = 'toggle',
							name = L["Sum Block Value"],
							desc = L["Block Value <- Block Value, Strength"],
							order = 7,
						},
						sumParry = {
							type = 'toggle',
							name = L["Sum Parry Chance"],
							desc = L["Parry Chance <- Parry Rating, Defense Rating"],
							order = 8,
						},
						sumParryRating = {
							type = 'toggle',
							name = L["Sum Parry Rating"],
							desc = L["Parry Rating Summary"],
							order = 9,
						},
						sumHitAvoid = {
							type = 'toggle',
							name = L["Sum Hit Avoidance"],
							desc = L["Hit Avoidance <- Defense Rating"],
							order = 10,
						},
						sumArmor = {
							type = 'toggle',
							name = L["Sum Armor"],
							desc = L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"],
							order = 11,
						},
						sumDefense = {
							type = 'toggle',
							name = L["Sum Defense"],
							desc = L["Defense <- Defense Rating"],
							order = 12,
						},
						sumCritAvoid = {
							type = 'toggle',
							name = L["Sum Crit Avoidance"],
							desc = L["Crit Avoidance <- Defense Rating, Resilience"],
							order = 13,
						},
						sumResilience = {
							type = 'toggle',
							name = L["Sum Resilience"],
							desc = L["Resilience Summary"],
							order = 14,
						},
						sumArcaneResist = {
							type = 'toggle',
							name = L["Sum Arcane Resistance"],
							desc = L["Arcane Resistance Summary"],
							order = 15,
						},
						sumFireResist = {
							type = 'toggle',
							name = L["Sum Fire Resistance"],
							desc = L["Fire Resistance Summary"],
							order = 16,
						},
						sumNatureResist = {
							type = 'toggle',
							name = L["Sum Nature Resistance"],
							desc = L["Nature Resistance Summary"],
							order = 17,
						},
						sumFrostResist = {
							type = 'toggle',
							name = L["Sum Frost Resistance"],
							desc = L["Frost Resistance Summary"],
							order = 18,
						},
						sumShadowResist = {
							type = 'toggle',
							name = L["Sum Shadow Resistance"],
							desc = L["Shadow Resistance Summary"],
							order = 19,
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
		alwaysBuffed = {
			type = "group",
			name = "AlwaysBuffed",
			order = 4,
			get = function(info)
				local db = RatingBuster.db:GetNamespace("AlwaysBuffed")
				return db.profile[info[#info]]
			end,
			set = function(info, v)
				local db = RatingBuster.db:GetNamespace("AlwaysBuffed")
				db.profile[info[#info]] = v
				clearCache()
				StatLogic:InvalidateEvent("UNIT_AURA", "player")
			end,
      args = {
        description = {
					type = "description",
          name = L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"],
          order = 1,
        },
        description2 = {
					type = "description",
          name = " ",
          order = 2,
        },
        [class] = {
					type = "group",
					dialogInline = true,
          name = gsub(L["$class Self Buffs"], "$class", (UnitClass("player"))),
          order = 5,
					hidden = true,
					args = {},
        },
        ALL = {
					type = "group",
					dialogInline = true,
          name = L["Raid Buffs"],
          order = 6,
					args = {},
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

---------------------
-- Saved Variables --
---------------------
-- Default values
local defaults = {
	global = {
		showItemLevel = false,
		showItemID = false,
		useRequiredLevel = true,
		customLevel = 0,
		textColor = CreateColor(1.0, 0.996, 0.545),
		showSum = true,
		sumIgnoreUnused = true,
		sumIgnoreEquipped = false,
		sumIgnoreEnchant = true,
		sumIgnoreGems = false,
		sumBlankLine = true,
		sumBlankLineAfter = false,
		sumStatColor = CreateColor(NORMAL_FONT_COLOR:GetRGBA()),
		sumValueColor = CreateColor(NORMAL_FONT_COLOR:GetRGBA()),
		sumShowIcon = true,
		sumShowTitle = true,
		sumDiffStyle = "main",
		sumSortAlpha = false,
		calcDiff = true,
		calcSum = true,
		hideBlizzardComparisons = true,
	},
	profile = {
		enableStatMods = true,
		enableAvoidanceDiminishingReturns = StatLogic.GetAvoidanceAfterDR and true or false,
		showRatings = true,
		detailedConversionText = false,
		defBreakDown = false,
		wpnBreakDown = false,
		expBreakDown = false,
		showStats = true,
		sumAvoidWithBlock = false,
		showZeroValueStat = false,
		--[[
		Str -> AP, Block
		Agi -> Crit, Dodge, AP, RAP, Armor
		Sta -> Health
		Int -> Mana, SpellCrit, MP5NC
		Spi -> MP5NC, HP5
		--]]
		-- Base stat conversions
		showAPFromStr = false,
		showBlockValueFromStr = false,

		showCritFromAgi = true,
		showDodgeFromAgi = true,
		showAPFromAgi = false,
		showRAPFromAgi = false,
		showArmorFromAgi = false,

		showHealthFromSta = false,

		showManaFromInt = false,
		showSpellCritFromInt = true,
		showMP5NCFromInt = false,

		showMP5NCFromSpi = false,
		showHP5FromSpi = false,
		------------------
		-- Stat Summary --
		------------------
		-- Basic
		sumHP = true,
		sumMP = true,
		sumMP5 = true,
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
		sumHit = false,
		sumHitRating = false,
		sumCrit = false,
		sumCritRating = false,
		sumHaste = false,
		sumHasteRating = false,
		sumIgnoreArmor = false,
		sumArmorPenetration = false,
		-- Ranged
		sumRAP = false,
		sumRangedHit = false,
		sumRangedHitRating = false,
		sumRangedCrit = false,
		sumRangedCritRating = false,
		sumRangedHaste = false,
		sumRangedHasteRating = false,
		-- Weapon
		sumWeaponAverageDamage = false,
		sumWeaponDPS = false,
		sumExpertise = false,
		sumWeaponSkill = false,
		sumDodgeNeglect = false,
		sumParryNeglect = false,
		sumBlockNeglect = false,
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
		sumResilience = true, -- new
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

-- Class specific settings
if class == "DEATHKNIGHT" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumMP = false
	defaults.profile.sumMP5 = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.ratingPhysical = true
	defaults.profile.sumArmorPenetration = true
elseif class == "DRUID" then
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.ratingPhysical = true
	defaults.profile.ratingSpell = true
	defaults.profile.sumArmorPenetration = true
elseif class == "HUNTER" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumRAP = true
	defaults.profile.sumRangedHit = true
	defaults.profile.sumRangedCrit = true
	defaults.profile.sumRangedHaste = true
	defaults.profile.showMP5FromInt = true -- Aspect of the Viper
	defaults.profile.showRAPFromAgi = true
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showRAPFromInt = true
	defaults.profile.ratingPhysical = true
	defaults.profile.sumArmorPenetration = true
elseif class == "MAGE" then
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.ratingSpell = true
elseif class == "PALADIN" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumHolyDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.ratingPhysical = true
	defaults.profile.ratingSpell = true
elseif class == "PRIEST" then
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.ratingSpell = true
elseif class == "ROGUE" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumMP = false
	defaults.profile.sumMP5 = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.ratingPhysical = true
	defaults.profile.sumArmorPenetration = true
elseif class == "SHAMAN" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.sumHealing = true
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.ratingPhysical = true
	defaults.profile.ratingSpell = true
elseif class == "WARLOCK" then
	defaults.profile.sumSpellDmg = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.ratingSpell = true
elseif class == "WARRIOR" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumMP = false
	defaults.profile.sumMP5 = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.ratingPhysical = true
	defaults.profile.sumArmorPenetration = true
end

-- Generate options from expansion-specific StatModTables in StatLogic
do
	-- Mostly for backwards compatibility
	local statToOptionKey = setmetatable({
		["AP"] = "AP",
		["MANA_REG"] = "MP5",
		["RANGED_AP"] = "RAP",
	},
	{
		__index = function(_, statMod)
			-- Remove underscores, PascalCase
			return string.gsub(statMod, "[%W_]*(%w+)[%W_]*", function(word)
				return word:lower():gsub("^%l", string.upper)
			end)
		end
	})

	local addStatModOption = function(add, mod, sources)
		-- ADD_HEALING_MOD_INT -> showHealingFromInt
		local key = "show" .. statToOptionKey[add] .. "From" .. statToOptionKey[mod]
		defaults.profile[key] = true

		-- Override Armor and Attack Power being hidden by default,
		-- since most classes have no useful breakdowns from them.
		local group = options.args.stat.args[mod:lower()]
		group.hidden = false

		local option = group.args[key]
		if not option then
			option = {
				type = "toggle",
				width = "full",
			}
		else
			sources = option.desc .. ", " .. sources
		end

		option.name = L.statModOptionDesc(SHOW, L[add], L["from"], L[mod])
		option.desc = sources

		options.args.stat.args[mod:lower()].args[key] = option
	end

	local function GenerateStatModOptions()
		for statMod, cases in pairs(StatLogic.StatModTable[class]) do
			local add = StatLogic.StatModInfo[statMod].add
			local mod = StatLogic.StatModInfo[statMod].mod

			if add and mod then
				local sources = ""
				local firstSource = true
				for _, case in ipairs(cases) do
					if not firstSource then
						sources = sources .. ", "
					end
					local source = ""
					if case.buff then
						source = GetSpellInfo(case.buff)
					elseif case.tab then
						source = StatLogic:GetOrderedTalentInfo(case.tab, case.num)
					elseif case.glyph then
						source = GetSpellInfo(case.glyph)
					end
					sources = sources .. source
					firstSource = false
				end

				-- Molten Armor and Forceful Deflection give rating,
				-- but we show it to the user as the converted stat
				add = add:gsub("_RATING", "")

				if mod == "NORMAL_MANA_REG" then
					-- "Normal mana regen" is added from both int and spirit
					addStatModOption(add, "INT", sources)
					mod = "SPI"
				elseif mod == "AP" then
					-- Paladin's Sheathe of Light, Touched by the Light
					-- Shaman's Mental Quickness.
					-- TODO: Shaman AP can also come from INT in Wrath
					if StatLogic:GetAPPerStr(class) > 0 then
						addStatModOption(add, "STR", sources)
					end
					if StatLogic:GetAPPerAgi(class) > 0 then
						addStatModOption(add, "AGI", sources)
					end
				end

				-- Demonic Knowledge technically scales with pet stats,
				-- but we compute the scaling from player's stats
				mod = mod:gsub("^PET_", "")

				addStatModOption(add, mod, sources)
			end
		end
	end

	-- Ignore Stat Mods that mostly exist for Tank Points
	local ignoredStatMods = {
		["MOD_DMG_TAKEN"] = true,
		["ADD_DODGE"] = true,
		["ADD_HIT_TAKEN"] = true,
	}
	local function GenerateAuraOptions()
		for modType, modList in pairs(StatLogic.StatModTable) do
			for modName, mods in pairs(modList) do
				if not ignoredStatMods[modName] then
					for _, mod in ipairs(mods) do
						if mod.buff then
							local name, _, icon = GetSpellInfo(mod.buff)
							local option = {
								type = 'toggle',
								name = "|T"..icon..":25:25:-2:0|t"..name,
							}
							options.args.alwaysBuffed.args[modType].args[name] = option
							options.args.alwaysBuffed.args[modType].hidden = false

							-- If it's a spell the player knows, use the highest rank for the description
							local spellId = mod.buff
							if IsPlayerSpell(spellId) then
								spellId = select(7,GetSpellInfo(name)) or spellId
							end
							local spell = Spell:CreateFromSpellID(spellId)
							spell:ContinueOnSpellLoad(function()
								option.desc = spell:GetSpellDescription()
							end)
						end
					end
				end
			end
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("SPELLS_CHANGED")
	f:SetScript("OnEvent", function()
		if StatLogic:TalentCacheExists() then
			GenerateStatModOptions()
			GenerateAuraOptions()
			RatingBuster:InitializeDatabase()
		else
			-- Talents are not guaranteed to exist on SPELLS_CHANGED,
			-- and there is no definite event for when they will exist.
			-- Recheck every 1 second after SPELLS_CHANGED until they exist.
			local ticker
			ticker = C_Timer.NewTicker(1, function()
				if StatLogic:TalentCacheExists() then
					GenerateStatModOptions()
					GenerateAuraOptions()
					RatingBuster:InitializeDatabase()
					ticker:Cancel()
				end
			end)
		end
		f:UnregisterEvent("SPELLS_CHANGED")
	end)
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
	wipe(cache)
end

function RatingBuster:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonNameWithVersion, options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonNameWithVersion, addonName)
end

function RatingBuster:InitializeDatabase()
	RatingBuster.db = LibStub("AceDB-3.0"):New("RatingBusterDB", defaults, class)
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileChanged", "RefreshConfig")
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileCopied", "RefreshConfig")
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileReset", "RefreshConfig")
	profileDB = RatingBuster.db.profile
	globalDB = RatingBuster.db.global

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(RatingBuster.db)
	options.args.profiles.order = 5

	local LibDualSpec = LibStub('LibDualSpec-1.0', true)

	if LibDualSpec then
		LibDualSpec:EnhanceDatabase(RatingBuster.db, "RatingBusterDB")
		LibDualSpec:EnhanceOptions(options.args.profiles, RatingBuster.db)
	end

	local always_buffed = RatingBuster.db:RegisterNamespace("AlwaysBuffed", {
		profile = {
			['*'] = false
		}
	})
	StatLogic:SetupAuraInfo(always_buffed.profile)
end

SLASH_RATINGBUSTER1, SLASH_RATINGBUSTER2 = "/ratingbuster", "/rb"
function SlashCmdList.RATINGBUSTER(input)
  if not input or input:trim() == "" then
		if not LibStub("AceConfigDialog-3.0").OpenFrames[addonNameWithVersion] then
			LibStub("AceConfigDialog-3.0"):Open(addonNameWithVersion)
		else
			LibStub("AceConfigDialog-3.0"):Close(addonNameWithVersion)
		end
  else
    LibStub("AceConfigCmd-3.0").HandleCommand(RatingBuster, "rb", addonNameWithVersion, input)
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
function RatingBuster:PLAYER_LEVEL_UP(_, newlevel)
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

-- Avoidance Diminishing Returns
local summaryFunc = {}
local equippedSum = setmetatable({}, {
	__index = function() return 0 end
})
local equippedDodge, equippedParry, equippedMissed
local processedDodge, processedParry, processedMissed

-- Utilities for checking nested recipes
local ITEM_MIN_LEVEL_PATTERN = ITEM_MIN_LEVEL:gsub("%%d", "%%d+")
local BIND_TRADE_PATTERN = BIND_TRADE_TIME_REMAINING:gsub("%%s", ".*")
local BEGIN_ITEM_SPELL_TRIGGER_ONUSE = "^" .. ITEM_SPELL_TRIGGER_ONUSE

function RatingBuster.ProcessTooltip(tooltip, name, link)
	-- Check if we're in standby mode
	--if not RatingBuster:IsActive() then return end

	-- Process nested recipes only once
	local itemType = select(6, GetItemInfoInstant(link))
	local isRecipe = itemType == Enum.ItemClass.Recipe

	if isRecipe and tooltip.rb_processed_nested_recipe then
		tooltip.rb_processed_nested_recipe = false
		return
	end

	---------------------------
	-- Set calculation level --
	---------------------------
	calcLevel = globalDB.customLevel or 0
	if calcLevel == 0 then
		calcLevel = playerLevel
	end
	if globalDB.useRequiredLevel and link then
		local _, _, _, _, reqLevel = GetItemInfo(link)
		--RatingBuster:Print(link..", "..calcLevel)
		if reqLevel and calcLevel < reqLevel then
			calcLevel = reqLevel
		end
	end
	---------------------
	-- Tooltip Scanner --
	---------------------
	-- Get equipped item avoidances
	if profileDB.enableAvoidanceDiminishingReturns then
		local red = profileDB.sumGemRed.gemID
		local yellow = profileDB.sumGemYellow.gemID
		local blue = profileDB.sumGemBlue.gemID
		local meta = profileDB.sumGemMeta.gemID
		local _, mainlink, difflink1, difflink2 = StatLogic:GetDiffID(tooltip, globalDB.sumIgnoreEnchant, globalDB.sumIgnoreGems, red, yellow, blue, meta, profileDB.sumIgnorePris)
		StatLogic:GetSum(difflink1, equippedSum)
		equippedSum["STR"] = equippedSum["STR"] * GSM("MOD_STR")
		equippedSum["AGI"] = equippedSum["AGI"] * GSM("MOD_AGI")
		equippedDodge = summaryFunc["DODGE_NO_DR"](equippedSum, "sum", difflink1) * -1
		equippedParry = summaryFunc["PARRY_NO_DR"](equippedSum, "sum", difflink1) * -1
		equippedMissed = summaryFunc["MELEE_HIT_AVOID_NO_DR"](equippedSum, "sum", difflink1) * -1
		processedDodge = equippedDodge
		processedParry = equippedParry
		processedMissed = equippedMissed
	else
		equippedDodge = 0
		equippedParry = 0
		equippedMissed = 0
		processedDodge = 0
		processedParry = 0
		processedMissed = 0
	end
	-- Loop through tooltip lines starting at line 2
	local tipTextLeft = tooltip:GetName().."TextLeft"
	for i = 2, tooltip:NumLines() do
		local fontString = _G[tipTextLeft..i]
		local text = fontString:GetText()
		if text then
			local color = CreateColor(fontString:GetTextColor())
			if isRecipe and not tooltip.rb_processed_nested_recipe then
				-- Workaround to detect nested items from recipes
				-- Check if any line is:
				-- a) Fourth or higher and:
				--	1) Matches any uncommon or higher item quality color
				--	2) Is neither BIND_TRADE_PATTERN nor ITEM_SPELL_TRIGGER_ONUSE
				-- b) Sixth or higher and:
				--	1) Has a minimum required level
				--
				--	Items to test:
				--	Classic/TBC [Grimoire of Blood Pact (Rank 2)] 16322
				--	TBC/Wrath [Design: Glinting Pyrestone] 32306
				local quality = false
				if i > 3 then
					for j = Enum.ItemQuality.Good, Enum.ItemQuality.Heirloom do
						if StatLogic.AreColorsEqual(ITEM_QUALITY_COLORS[j].color, color)
						and not (
							(j == Enum.ItemQuality.Heirloom and text:match(BIND_TRADE_PATTERN))
							or (j == Enum.ItemQuality.Good and text:match(BEGIN_ITEM_SPELL_TRIGGER_ONUSE))
						) then
							quality = true
							break
						end
					end
				end
				if quality
				or i > 5 and text:find(ITEM_MIN_LEVEL_PATTERN)
				then
					tooltip.rb_processed_nested_recipe = true
				end
			end

			text = RatingBuster:ProcessLine(text, link, color)
			if text then
				fontString:SetText(text)
			end
		end
	end
	----------------------------
	-- Item Level and Item ID --
	----------------------------
	-- Check for ItemLevel addon, do nothing if found
	if not ItemLevel_AddInfo and (globalDB.showItemLevel or globalDB.showItemID) and link then
		if cache[link] then
			tooltip:AddLine(cache[link])
		else
			-- Get the Item ID from the link string
			local _, link, _, level = GetItemInfo(link)
			if link then
				local _, _, id = strfind(link, "item:(%d+)")
				local newLine = ""
				local statColor = globalDB.sumStatColor
				local valueColor = globalDB.sumValueColor
				if level and globalDB.showItemLevel then
					newLine = newLine .. statColor:WrapTextInColorCode(L["ItemLevel: "])
					newLine = newLine .. valueColor:WrapTextInColorCode(level)
				end
				if id and globalDB.showItemID then
					if newLine ~= "" then
						newLine = newLine..", "
					end
					newLine = newLine .. statColor:WrapTextInColorCode(L["ItemID: "])
					newLine = newLine .. valueColor:WrapTextInColorCode(id)
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
	if globalDB.showSum then
		RatingBuster:StatSummary(tooltip, name, link)
	end
	---------------------
	-- Repaint tooltip --
	---------------------
	tooltip:Show()
end


function RatingBuster:ProcessLine(text, link, color)
	-- Get data from cache if available
	local cacheID = text..calcLevel
	local cacheText = cache[cacheID]
	if cacheText then
		if cacheText ~= text then
			return cacheText
		end
	elseif EmptySocketLookup[text] and profileDB[EmptySocketLookup[text]].gemText then -- Replace empty sockets with gem text
		text = profileDB[EmptySocketLookup[text]].gemText
		cache[cacheID] = text
		-- SetText
		return text
	elseif strfind(text, "%d") then -- do nothing if we don't find a number
		-- Initial pattern check, do nothing if not found
		-- Check for separators and bulid separatorTable
		local separatorTable = {}
		for _, sep in ipairs(L["separators"]) do
			if strfind(text, sep) then
				tinsert(separatorTable, sep)
			end
		end
		-- SplitDoJoin
		text = RatingBuster:SplitDoJoin(text, separatorTable, link, color)
		cache[cacheID] = text
		-- SetText
		return text
	end
end


---------------------------------------------------------------------------------
-- Recursive algorithm that divides a string into pieces using the separators in separatorTable,
-- processes them separately, then joins them back together
---------------------------------------------------------------------------------
-- text = "+24 Agility/+4 Stamina and +4 Spell Crit/+5 Spirit"
-- separatorTable = {"/", " and ", ","}
-- RatingBuster:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ",", "%. ", " for ", "&"})
-- RatingBuster:SplitDoJoin("+6法術傷害及5耐力", {"/", "和", ",", "。", " 持續 ", "&", "及",})
function RatingBuster:SplitDoJoin(text, separatorTable, link, color)
	if type(separatorTable) == "table" and table.maxn(separatorTable) > 0 then
		local sep = tremove(separatorTable, 1)
		text =  gsub(text, sep, "@")
		text = {strsplit("@", text)}
		local processedText = {}
		local tempTable = {}
		for _, t in ipairs(text) do
			copyTable(tempTable, separatorTable)
			tinsert(processedText, self:SplitDoJoin(t, tempTable, link, color))
		end
		-- Join text
		return (gsub(strjoin("@", unpack(processedText)), "@", sep))
	else
		return self:ProcessText(text, link, color)
	end
end


function RatingBuster:ProcessText(text, link, color)
	-- Find and set color code (used to fix gem text color) pattern:|cxxxxxxxx
	local currentColorCode = select(3, strfind(text, "(|c%x%x%x%x%x%x%x%x)")) or "|r"
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
					local infoString = RatingBuster:ProcessStat(stat.id, value, link, color)
					if infoString ~= "" then
						-- Add parenthesis
						infoString = "("..infoString..")"
						if not globalDB.textColor.GenerateHexColorMarkup then
							-- Backwards Compatibility
							local old = globalDB.textColor
							if type(old) == "table" and old.r and old.g and old.b then
								globalDB.textColor = CreateColor(old.r, old.g, old.b)
							else
								globalDB.textColor = defaults.global.textColor
							end
						end
						-- Add Color
						infoString = globalDB.textColor:GenerateHexColorMarkup()..infoString..currentColorCode
						-- Build replacement string
						if num.addInfo == "AfterNumber" then -- Add after number
							infoString = gsub(infoString, "%%", "%%%%%%%%") -- sub "%" with "%%%%"
							-- Only substitue the number pattern's actual captured number
							-- This allows checking for invalid characters after the digits,
							-- while still placing the infoString directly after the digits.
							local numPattern = num.pattern:match(".-%)")
							infoString = gsub(strsub(text, s, e), numPattern, "%0 "..infoString, 1) -- sub "33" with "33 (3.33%)"
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

do
	local RatingType = {
		Melee = {
			[CR_HIT_MELEE] = true,
			[CR_CRIT_MELEE] = true,
			[CR_HASTE_MELEE] = true,
		},
		Ranged = {
			[CR_HIT_RANGED] = true,
			[CR_CRIT_RANGED] = true,
			[CR_HASTE_RANGED] = true,
		},
		Spell = {
			[CR_HIT_SPELL] = true,
			[CR_CRIT_SPELL] = true,
			[CR_HASTE_SPELL] = true,
		},
		Decimal = {
			[CR_WEAPON_SKILL] = true,
			[CR_DEFENSE_SKILL] = true,
			[CR_WEAPON_SKILL_MAINHAND] = true,
			[CR_WEAPON_SKILL_OFFHAND] = true,
			[CR_WEAPON_SKILL_RANGED] = true,
			[CR_EXPERTISE] = true,
		}
	}
	
	function RatingBuster:ProcessStat(statID, value, link, color)
		local infoString = ""
		if StatLogic.GenericStatMap[statID] then
			local statList = StatLogic.GenericStatMap[statID]
			local first = true
			for _, convertedStatID in ipairs(statList) do
				if not RatingType.Ranged[convertedStatID] then
					local result = RatingBuster:ProcessStat(convertedStatID, value)
					if result and result ~= "" then
						if not first then
							infoString = infoString .. ", "
						end
						infoString = infoString .. result
						first = false
					end
				end
			end
		elseif type(statID) == "number" and profileDB.showRatings then
			--------------------
			-- Combat Ratings --
			--------------------
			-- Calculate stat value
			local effect, strID = StatLogic:GetEffectFromRating(value, statID, calcLevel)
			--self:Debug(reversedAmount..", "..amount..", "..v[2]..", "..RatingBuster.targetLevel)-- debug
			-- If rating is resilience, add a minus sign
			if strID == "DEFENSE" and profileDB.defBreakDown then
				effect = effect * 0.04
				processedDodge = processedDodge + effect
				processedMissed = processedMissed + effect
				local numStats = 5
				if GetParryChance() == 0 then
					numStats = numStats - 1
				else
					processedParry = processedParry + effect
				end
				if GetBlockChance() == 0 then
					numStats = numStats - 1
				end
				infoString = format("%+.2f%% x"..numStats, effect)
			elseif strID == "DODGE" and profileDB.enableAvoidanceDiminishingReturns then
				infoString = format("%+.2f%%", StatLogic:GetAvoidanceGainAfterDR("DODGE", processedDodge + effect) - StatLogic:GetAvoidanceGainAfterDR("DODGE", processedDodge))
				processedDodge = processedDodge + effect
			elseif strID == "PARRY" and profileDB.enableAvoidanceDiminishingReturns then
				infoString = format("%+.2f%%", StatLogic:GetAvoidanceGainAfterDR("PARRY", processedParry + effect) - StatLogic:GetAvoidanceGainAfterDR("PARRY", processedParry))
				processedParry = processedParry + effect
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
			elseif statID == CR_RESILIENCE_CRIT_TAKEN then -- Resilience
				effect = effect * -1
				if profileDB.detailedConversionText then
					local infoTable = {}
					
					if tocversion >= 30000 then
						-- Wrath
						tinsert(infoTable, (L["$value to be Crit"]:gsub("$value", format("%+.2f%%%%", effect))))
						tinsert(infoTable, (L["$value Crit Dmg Taken"]:gsub("$value", format("%+.2f%%%%", effect * RESILIENCE_CRIT_CHANCE_TO_DAMAGE_REDUCTION_MULTIPLIER))))
						tinsert(infoTable, (L["$value Dmg Taken"]:gsub("$value", format("%+.2f%%%%", effect * RESILIENCE_CRIT_CHANCE_TO_CONSTANT_DAMAGE_REDUCTION_MULTIPLIER))))
					elseif tocversion >= 20000 then
						-- TBC
						tinsert(infoTable, (L["$value to be Crit"]:gsub("$value", format("%+.2f%%%%", effect))))
						tinsert(infoTable, (L["$value Crit Dmg Taken"]:gsub("$value", format("%+.2f%%%%", effect * 2))))
						tinsert(infoTable, (L["$value DOT Dmg Taken"]:gsub("$value", format("%+.2f%%%%", effect))))
					end
					
					infoString = strjoin(", ", unpack(infoTable))
				else
					infoString = format("%+.2f%%", effect)
				end
			else
				local pattern = "%+.2f%%"
				local show = false
				if RatingType.Melee[statID] then
					if profileDB.ratingPhysical then
						show = true
					end
				elseif RatingType.Spell[statID] then
					if profileDB.ratingSpell then
						if not profileDB.ratingPhysical then
							show = true
						elseif ( statID == CR_HIT_SPELL or (statID == CR_HASTE_SPELL and StatLogic.ExtraHasteClasses[class])) then
							show = true
							pattern = L["$value Spell"]:gsub("$value", "%%+.2f%%%%")
						end
					end
				elseif RatingType.Decimal[statID] then
					show = true
					pattern = "%+.2f"
				else
					show = true
				end

				if show then
					infoString = format(pattern, effect)
				end
			end
		elseif statID == SPELL_STAT1_NAME and profileDB.showStats then
			--------------
			-- Strength --
			--------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_STR")
				value = value * statmod
			end
			local infoTable = {}
			if profileDB.showAPFromStr then
				local mod = GSM("MOD_AP")
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
			-- Shaman: Mental Quickness
			-- Paladin: Sheath of Light, Touched by the Light
			if profileDB.showSpellDmgFromStr then
				local mod = GSM("MOD_AP") * GSM("MOD_SPELL_DMG")
				local effect = (value * StatLogic:GetAPPerStr(class) * GSM("ADD_SPELL_DMG_MOD_AP")
				+ value * GSM("ADD_SPELL_DMG_MOD_STR")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.0f", effect))))
				end
			end
			if profileDB.showHealingFromStr then
				local mod = GSM("MOD_AP") * GSM("MOD_HEALING")
				local effect = (value * StatLogic:GetAPPerStr(class) * GSM("ADD_HEALING_MOD_AP")
				+ value * GSM("ADD_HEALING_MOD_STR")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.0f", effect))))
				end
			end
			-- Death Knight: Forceful Deflection - Passive
			if profileDB.showParryFromStr then
				local rating = value * GSM("ADD_PARRY_RATING_MOD_STR")
				local effect = StatLogic:GetEffectFromRating(rating, 4, calcLevel)
				if profileDB.enableAvoidanceDiminishingReturns then
					local effectNoDR = effect
					effect = StatLogic:GetAvoidanceGainAfterDR("PARRY", processedParry + effect) - StatLogic:GetAvoidanceGainAfterDR("PARRY", processedParry)
					processedParry = processedParry + effectNoDR
				end
				if effect > 0 then
					tinsert(infoTable, (gsub(L["$value% Parry"], "$value", format("%+.2f", effect))))
				end
			else
				local rating = value * GSM("ADD_PARRY_RATING_MOD_STR")
				local effect = StatLogic:GetEffectFromRating(rating, 4, calcLevel)
				processedParry = processedParry + effect
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif statID == SPELL_STAT2_NAME and profileDB.showStats then
			-------------
			-- Agility --
			-------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_AGI")
				value = value * statmod
			end
			local infoTable = {}
			if profileDB.showAPFromAgi then
				local mod = GSM("MOD_AP")
				local effect = value * StatLogic:GetAPPerAgi(class) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.0f", effect))))
				end
			end
			if profileDB.showRAPFromAgi then
				local mod = GSM("MOD_RANGED_AP")
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
			-- Shaman: Mental Quickness
			-- Paladin: Sheath of Light, Touched by the Light
			if profileDB.showSpellDmgFromAgi then
				local mod = GSM("MOD_AP") * GSM("MOD_SPELL_DMG")
				local effect = (value * StatLogic:GetAPPerAgi(class) * GSM("ADD_SPELL_DMG_MOD_AP")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.0f", effect))))
				end
			end
			-- Druid: Nurturing Instinct
			if profileDB.showHealingFromAgi then
				local mod = GSM("MOD_AP") * GSM("MOD_HEALING")
				local effect = (value * StatLogic:GetAPPerAgi(class) * GSM("ADD_HEALING_MOD_AP")
				+ value * GSM("ADD_HEALING_MOD_AGI") / GSM("MOD_AP")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.0f", effect))))
				end
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif statID == SPELL_STAT3_NAME and profileDB.showStats then
			-------------
			-- Stamina --
			-------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_STA")
				value = value * statmod
			end
			local infoTable = {}
			if profileDB.showHealthFromSta then
				local mod = GSM("MOD_HEALTH")
				local effect = value * 10 * mod -- 10 Health per Sta
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value HP"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value HP"], "$value", format("%+.0f", effect))))
				end
			end
			if profileDB.showSpellDmgFromSta then
				local mod = GSM("MOD_SPELL_DMG")
				local effect = value * mod * (GSM("ADD_SPELL_DMG_MOD_STA")
				+ GSM("ADD_SPELL_DMG_MOD_PET_STA") * GSM("ADD_PET_STA_MOD_STA"))
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				end
			end
			-- "ADD_AP_MOD_STA" -- Hunter: Hunter vs. Wild
			if profileDB.showAPFromSta then
				local mod = GSM("MOD_AP")
				local effect = value * GSM("ADD_AP_MOD_STA") * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.0f", effect))))
				end
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif statID == SPELL_STAT4_NAME and profileDB.showStats then
			---------------
			-- Intellect --
			---------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_INT")
				value = value * statmod
			end
			local infoTable = {}
			if profileDB.showManaFromInt then
				local mod = GSM("MOD_MANA")
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
				local mod = GSM("MOD_SPELL_DMG")
				local effect = value * mod * (GSM("ADD_SPELL_DMG_MOD_INT")
				+ GSM("ADD_SPELL_DMG_MOD_PET_INT") * GSM("ADD_PET_INT_MOD_INT"))
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showHealingFromInt then
				local mod = GSM("MOD_HEALING")
				local effect = value * GSM("ADD_HEALING_MOD_INT") * mod
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showMP5FromInt then
				local effect
				if tocversion >= 20400 then -- 2.4.0
					local _, int = UnitStat("player", 4)
					local _, spi = UnitStat("player", 5)
					effect = value * GSM("ADD_MANA_REG_MOD_INT")
					+ (StatLogic:GetNormalManaRegenFromSpi(spi, int + value, calcLevel)
					- StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)) * GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
					+ value * 15 * GSM("MOD_MANA") * GSM("ADD_MANA_REG_MOD_MANA") -- Replenishment
				else
					effect = value * GSM("ADD_MANA_REG_MOD_INT")
				end
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value MP5"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showMP5NCFromInt then
				local effect
				if tocversion >= 20400 then -- 2.4.0
					local _, int = UnitStat("player", 4)
					local _, spi = UnitStat("player", 5)
					effect = value * GSM("ADD_MANA_REG_MOD_INT")
					+ StatLogic:GetNormalManaRegenFromSpi(spi, int + value, calcLevel)
					- StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)
					+ value * 15 * GSM("MOD_MANA") * GSM("ADD_MANA_REG_MOD_MANA") -- Replenishment
				else
					effect = value * GSM("ADD_MANA_REG_MOD_INT")
				end
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value MP5(NC)"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showRAPFromInt then
				local mod = GSM("MOD_RANGED_AP")
				local effect = value * GSM("ADD_RANGED_AP_MOD_INT") * mod
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value RAP"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showArmorFromInt then
				local effect = value * GSM("ADD_ARMOR_MOD_INT")
				if floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Armor"], "$value", format("%+.0f", effect))))
				end
			end
			-- "ADD_AP_MOD_INT" -- Shaman: Mental Dexterity
			if profileDB.showAPFromInt then
				local mod = GSM("MOD_AP")
				local effect = value * GSM("ADD_AP_MOD_INT") * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.0f", effect))))
				end
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif statID == SPELL_STAT5_NAME and profileDB.showStats then
			------------
			-- Spirit --
			------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_SPI")
				value = value * statmod
			end
			local infoTable = {}
			if profileDB.showMP5FromSpi then
				local mod = GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
				local effect
				if tocversion >= 20400 then -- 2.4.0
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
				if tocversion >= 20400 then -- 2.4.0
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
				local mod = GSM("MOD_SPELL_DMG")
				local effect = value * GSM("ADD_SPELL_DMG_MOD_SPI") * mod
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showHealingFromSpi then
				local mod = GSM("MOD_HEALING")
				local effect = value * GSM("ADD_HEALING_MOD_SPI") * mod
				if floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
				end
			end
			if profileDB.showSpellCritFromSpi then
				local mod = GSM("ADD_SPELL_CRIT_RATING_MOD_SPI")
				local effect = StatLogic:GetEffectFromRating(value * mod, CR_CRIT_SPELL, calcLevel)
				if effect > 0 then
					tinsert(infoTable, (gsub(L["$value% Spell Crit"], "$value", format("%+.2f", effect))))
				end
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif profileDB.showAPFromArmor and statID == ARMOR then
			-----------
			-- Armor --
			-----------
			if profileDB.enableStatMods then
				local base, bonus = StatLogic:GetArmorDistribution(link, value, color)
				value = base * GSM("MOD_ARMOR") + bonus
			end
			local infoTable = {}
			local effect = value * GSM("ADD_AP_MOD_ARMOR") * GSM("MOD_AP")
			if floor(abs(effect) * 10 + 0.5) > 0 then
				tinsert(infoTable, (gsub(L["$value AP"], "$value", format("%+.1f", effect))))
			end
			infoString = strjoin(", ", unpack(infoTable))
		elseif statID == ATTACK_POWER then
			------------------
			-- Attack Power --
			------------------
			local statmod = 1
			if profileDB.enableStatMods then
				statmod = GSM("MOD_AP")
				value = value * statmod
			end
			local infoTable = {}
			-- Shaman: Mental Quickness
			-- Paladin: Sheath of Light, Touched by the Light
			if profileDB.showSpellDmgFromAP then
				local mod = GSM("MOD_AP") * GSM("MOD_SPELL_DMG")
				local effect = (value * GSM("ADD_SPELL_DMG_MOD_AP")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Spell Dmg"], "$value", format("%+.0f", effect))))
				end
			end
			if profileDB.showHealingFromAP then
				local mod = GSM("MOD_AP") * GSM("MOD_HEALING")
				local effect = (value * GSM("ADD_HEALING_MOD_AP")) * mod
				if (mod ~= 1 or statmod ~= 1) and floor(abs(effect) * 10 + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.1f", effect))))
				elseif floor(abs(effect) + 0.5) > 0 then
					tinsert(infoTable, (gsub(L["$value Heal"], "$value", format("%+.0f", effect))))
				end
			end
			infoString = strjoin(", ", unpack(infoTable))
		end
		return infoString
	end
end

local blizzardComparisonPatterns = {
	[ITEM_DELTA_DESCRIPTION] = true,
	[ITEM_DELTA_MULTIPLE_COMPARISON_DESCRIPTION] = true,
}

local function RemoveFontString(fontString)
	fontString:SetText("")
	fontString:Hide()
	fontString:SetWidth(0)
end

local function RemoveBlizzardItemComparisons(tooltip)
	if not tooltip or not globalDB.hideBlizzardComparisons then return end

	for _, shoppingTooltip in pairs(tooltip.shoppingTooltips) do
		local tipTextLeft = shoppingTooltip:GetName().."TextLeft"
		local tipTextRight = shoppingTooltip:GetName().."TextRight"
		local isBlizzardComparison = false

		for i = 2, shoppingTooltip:NumLines() do
			local fontString = _G[tipTextLeft..i]
			local text = fontString:GetText()
			if text then
				if not isBlizzardComparison and blizzardComparisonPatterns[text] then
					isBlizzardComparison = true
					local previousFontString = _G[tipTextLeft .. (i-1)]
					if previousFontString:GetText():find("^%s*") then
						RemoveFontString(previousFontString)
					end
				end

				if isBlizzardComparison then
					RemoveFontString(fontString)
					RemoveFontString(_G[tipTextRight..i])
				end
			end
		end
		shoppingTooltip:Show()
	end
end

hooksecurefunc("GameTooltip_ShowCompareItem", RemoveBlizzardItemComparisons)

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
		[Enum.ItemArmorSubclass["Plate"]] = true,
		[Enum.ItemArmorSubclass["Mail"]] = true,
		[Enum.ItemArmorSubclass["Leather"]] = true,
	},
	PALADIN = {
		[Enum.ItemArmorSubclass["Plate"]] = true,
		[Enum.ItemArmorSubclass["Mail"]] = true,
		[Enum.ItemArmorSubclass["Leather"]] = true,
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
	HUNTER = {
		[Enum.ItemArmorSubclass["Mail"]] = true,
		[Enum.ItemArmorSubclass["Leather"]] = true,
	},
	ROGUE = {
		[Enum.ItemArmorSubclass["Leather"]] = true,
	},
	PRIEST = {
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
	DEATHKNIGHT = {
		[Enum.ItemArmorSubclass["Plate"]] = true,
		[Enum.ItemArmorSubclass["Mail"]] = true,
		[Enum.ItemArmorSubclass["Leather"]] = true,
	},
	SHAMAN = {
		[Enum.ItemArmorSubclass["Mail"]] = true,
		[Enum.ItemArmorSubclass["Leather"]] = true,
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
	MAGE = {
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
	WARLOCK = {
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
	DRUID = {
		[Enum.ItemArmorSubclass["Leather"]] = true,
		[Enum.ItemArmorSubclass["Cloth"]] = true,
	},
}

local armorTypes = {
	[Enum.ItemArmorSubclass["Plate"]] = true,
	[Enum.ItemArmorSubclass["Mail"]] = true,
	[Enum.ItemArmorSubclass["Leather"]] = true,
	[Enum.ItemArmorSubclass["Cloth"]] = true,
}

-- Interface_<Expansion>/FrameXML/PaperDollFrame.lua Compatibility
if not ARMOR_PER_AGILITY then ARMOR_PER_AGILITY = 2 end
if not BLOCK_PER_STRENGTH then BLOCK_PER_STRENGTH = 0.05 end
if not DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE then DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE = 0.04 end

local summaryCalcData = {
	-----------
	-- Basic --
	-----------
	-- Strength - STR
	{
		option = "sumStr",
		name = "STR",
		func = function(sum)
			return sum["STR"]
		end,
	},
	-- Agility - AGI
	{
		option = "sumAgi",
		name = "AGI",
		func = function(sum)
			return sum["AGI"]
		end,
	},
	-- Stamina - STA
	{
		option = "sumSta",
		name = "STA",
		func = function(sum)
			return sum["STA"]
		end,
	},
	-- Intellect - INT
	{
		option = "sumInt",
		name = "INT",
		func = function(sum)
			return sum["INT"]
		end,
	},
	-- Spirit - SPI
	{
		option = "sumSpi",
		name = "SPI",
		func = function(sum)
			return sum["SPI"]
		end,
	},
	-- Health - HEALTH, STA
	{
		option = "sumHP",
		name = "HEALTH",
		func = function(sum)
			return (sum["HEALTH"] + (sum["STA"] * 10)) * GSM("MOD_HEALTH")
		end,
	},
	-- Mana - MANA, INT
	{
		option = "sumMP",
		name = "MANA",
		func = function(sum)
			return (sum["MANA"] + (sum["INT"] * 15)) * GSM("MOD_MANA")
		end,
	},
	-- Health Regen - HEALTH_REG
	{
		option = "sumHP5",
		name = "HEALTH_REG",
		func = function(sum)
			return sum["HEALTH_REG"]
		end,
	},
	-- Health Regen while Out of Combat - HEALTH_REG, SPI
	{
		option = "sumHP5OC",
		name = "HEALTH_REG_OUT_OF_COMBAT",
		func = function(sum)
			return sum["HEALTH_REG"] + StatLogic:GetHealthRegenFromSpi(sum["SPI"], class)
		end,
	},
	-- Mana Regen - MANA_REG, SPI, INT
	{
		option = "sumMP5",
		name = "MANA_REG",
		func = function(sum)
			if tocversion >= 20400 then -- 2.4.0
				local _, int = UnitStat("player", 4)
				local _, spi = UnitStat("player", 5)
				return sum["MANA_REG"]
				 + (sum["INT"] * GSM("ADD_MANA_REG_MOD_INT"))
				 + (StatLogic:GetNormalManaRegenFromSpi(spi + sum["SPI"], int + sum["INT"], calcLevel)
				 - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)) * GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG")
				 + summaryFunc["MANA"](sum) * GSM("ADD_MANA_REG_MOD_MANA")
			else
				return sum["MANA_REG"]
				 + (sum["INT"] * GSM("ADD_MANA_REG_MOD_INT"))
				 + (StatLogic:GetNormalManaRegenFromSpi(sum["SPI"], class) * GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG"))
			end
		end,
	},
	-- Mana Regen while Not casting - MANA_REG, SPI, INT
	{
		option = "sumMP5NC",
		name = "MANA_REG_NOT_CASTING",
		func = function(sum)
			if tocversion >= 20400 then -- 2.4.0
				local _, int = UnitStat("player", 4)
				local _, spi = UnitStat("player", 5)
				return sum["MANA_REG"]
				 + (sum["INT"] * GSM("ADD_MANA_REG_MOD_INT"))
				 + StatLogic:GetNormalManaRegenFromSpi(spi + sum["SPI"], int + sum["INT"], calcLevel)
				 - StatLogic:GetNormalManaRegenFromSpi(spi, int, calcLevel)
				 + summaryFunc["MANA"](sum) * GSM("ADD_MANA_REG_MOD_MANA")
			else
				return sum["MANA_REG"]
				 + (sum["INT"] * GSM("ADD_MANA_REG_MOD_INT"))
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
		func = function(sum)
			return GSM("MOD_AP") * (
				-- Feral Druid Predatory Strikes
				(sum["FERAL_AP"] > 0 and GSM("MOD_FAP") or 1) * (
					sum["AP"]
					+ sum["FERAL_AP"] * GSM("ADD_AP_MOD_FAP")
				) + sum["STR"] * StatLogic:GetAPPerStr(class)
				+ sum["AGI"] * StatLogic:GetAPPerAgi(class)
				+ sum["STA"] * GSM("ADD_AP_MOD_STA")
				+ sum["INT"] * GSM("ADD_AP_MOD_INT")
				+ summaryFunc["ARMOR"](sum) * GSM("ADD_AP_MOD_ARMOR")
			)
		end,
	},
	-- Ranged Attack Power - RANGED_AP, AP, AGI, INT
	{
		option = "sumRAP",
		name = "RANGED_AP",
		func = function(sum)
			return (GSM("MOD_RANGED_AP") + GSM("MOD_AP") - 1) * (
				sum["RANGED_AP"]
				+ sum["AP"]
				+ sum["AGI"] * StatLogic:GetRAPPerAgi(class)
				+ sum["INT"] * GSM("ADD_RANGED_AP_MOD_INT")
				+ sum["STA"] * GSM("ADD_AP_MOD_STA")
				+ summaryFunc["ARMOR"](sum) * GSM("ADD_AP_MOD_ARMOR")
			)
		end,
	},
	-- Hit Chance - MELEE_HIT_RATING, WEAPON_SKILL
	{
		option = "sumHit",
		name = "MELEE_HIT",
		func = function(sum)
			return sum["MELEE_HIT"]
				+ StatLogic:GetEffectFromRating(sum["MELEE_HIT_RATING"], "MELEE_HIT_RATING", calcLevel)
				+ sum["WEAPON_SKILL"] * 0.1
		end,
		ispercent = true,
	},
	-- Hit Rating - MELEE_HIT_RATING
	{
		option = "sumHitRating",
		name = "MELEE_HIT_RATING",
		func = function(sum)
			return sum["MELEE_HIT_RATING"]
		end,
	},
	-- Ranged Hit Chance - MELEE_HIT_RATING, RANGED_HIT_RATING, AGI
	{
		option = "sumRangedHit",
		name = "RANGED_HIT",
		func = function(sum)
			return sum["RANGED_HIT"]
				+ StatLogic:GetEffectFromRating(sum["RANGED_HIT_RATING"], "RANGED_HIT_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Ranged Hit Rating - RANGED_HIT_RATING
	{
		option = "sumRangedHitRating",
		name = "RANGED_HIT_RATING",
		func = function(sum)
			return sum["RANGED_HIT_RATING"]
		end,
	},
	-- Crit Chance - MELEE_CRIT, MELEE_CRIT_RATING, AGI
	{
		option = "sumCrit",
		name = "MELEE_CRIT",
		func = function(sum)
			return sum["MELEE_CRIT"]
				+ StatLogic:GetEffectFromRating(sum["MELEE_CRIT_RATING"], "MELEE_CRIT_RATING", calcLevel)
				+ StatLogic:GetCritFromAgi(sum["AGI"], class, calcLevel)
		end,
		ispercent = true,
	},
	-- Crit Rating - MELEE_CRIT_RATING
	{
		option = "sumCritRating",
		name = "MELEE_CRIT_RATING",
		func = function(sum)
			return sum["MELEE_CRIT_RATING"]
		end,
	},
	-- Ranged Crit Chance - MELEE_CRIT_RATING, RANGED_CRIT_RATING, AGI
	{
		option = "sumRangedCrit",
		name = "RANGED_CRIT",
		func = function(sum)
			return sum["RANGED_CRIT"]
				+ StatLogic:GetEffectFromRating(sum["RANGED_CRIT_RATING"], "RANGED_CRIT_RATING", calcLevel)
				+ StatLogic:GetCritFromAgi(sum["AGI"], class, calcLevel)
		end,
		ispercent = true,
	},
	-- Ranged Crit Rating - RANGED_CRIT_RATING
	{
		option = "sumRangedCritRating",
		name = "RANGED_CRIT_RATING",
		func = function(sum)
			return sum["RANGED_CRIT_RATING"]
		end,
	},
	-- Haste - MELEE_HASTE_RATING
	{
		option = "sumHaste",
		name = "MELEE_HASTE",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["MELEE_HASTE_RATING"], "MELEE_HASTE_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Haste Rating - MELEE_HASTE_RATING
	{
		option = "sumHasteRating",
		name = "MELEE_HASTE_RATING",
		func = function(sum)
			return sum["MELEE_HASTE_RATING"]
		end,
	},
	-- Ranged Haste - RANGED_HASTE_RATING
	{
		option = "sumRangedHaste",
		name = "RANGED_HASTE",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["RANGED_HASTE_RATING"], "RANGED_HASTE_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Ranged Haste Rating - RANGED_HASTE_RATING
	{
		option = "sumRangedHasteRating",
		name = "RANGED_HASTE_RATING",
		func = function(sum)
			return sum["RANGED_HASTE_RATING"]
		end,
	},
	-- Expertise - EXPERTISE_RATING
	{
		option = "sumExpertise",
		name = "EXPERTISE",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["EXPERTISE_RATING"], "EXPERTISE_RATING", calcLevel)
		end,
	},
	-- Expertise Rating - EXPERTISE_RATING
	{
		option = "sumExpertiseRating",
		name = "EXPERTISE_RATING",
		func = function(sum)
			return sum["EXPERTISE_RATING"]
		end,
	},
	-- Dodge Neglect - EXPERTISE_RATING, WEAPON_SKILL
	{
		option = "sumDodgeNeglect",
		name = "DODGE_NEGLECT",
		func = function(sum)
			return floor(StatLogic:GetEffectFromRating(sum["EXPERTISE_RATING"], "EXPERTISE_RATING", calcLevel)) * 0.25
				+ sum["WEAPON_SKILL"] * 0.1
		end,
		ispercent = true,
	},
	-- Parry Neglect - EXPERTISE_RATING
	{
		option = "sumParryNeglect",
		name = "PARRY_NEGLECT",
		func = function(sum)
			return floor(StatLogic:GetEffectFromRating(sum["EXPERTISE_RATING"], "EXPERTISE_RATING", calcLevel)) * 0.25
		end,
		ispercent = true,
	},
	-- Weapon Average Damage - MIN_DAMAGE, MAX_DAMAGE
	{
		option = "sumWeaponAverageDamage",
		name = "AVERAGE_DAMAGE",
		func = function(sum)
			return (sum["MIN_DAMAGE"] + sum["MAX_DAMAGE"]) / 2
		end,
	},
	-- Weapon DPS - DPS
	{
		option = "sumWeaponDPS",
		name = "DPS",
		func = function(sum)
			return sum["DPS"]
		end,
	},
	-- Ignore Armor - IGNORE_ARMOR
	{
		option = "sumIgnoreArmor",
		name = "IGNORE_ARMOR",
		func = function(sum)
			return sum["IGNORE_ARMOR"]
		end,
	},
	-- Armor Penetration - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetration",
		name = "ARMOR_PENETRATION",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["ARMOR_PENETRATION_RATING"], "ARMOR_PENETRATION_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Armor Penetration Rating - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetrationRating",
		name = "ARMOR_PENETRATION_RATING",
		func = function(sum) return
			sum["ARMOR_PENETRATION_RATING"]
		end,
	},
	------------------------------
	-- Spell Damage and Healing --
	------------------------------
	-- Spell Damage - SPELL_DMG, STA, INT, SPI
	{
		option = "sumSpellDmg",
		name = "SPELL_DMG",
		func = function(sum)
			return sum["SPELL_DMG"]
				+ sum["STR"] * GSM("ADD_SPELL_DMG_MOD_STR")
				+ sum["STA"] * (GSM("ADD_SPELL_DMG_MOD_STA") + GSM("ADD_SPELL_DMG_MOD_PET_STA") * GSM("ADD_PET_STA_MOD_STA"))
				+ sum["INT"] * (GSM("ADD_SPELL_DMG_MOD_INT") + GSM("ADD_SPELL_DMG_MOD_PET_INT") * GSM("ADD_PET_INT_MOD_INT"))
				+ sum["SPI"] * GSM("ADD_SPELL_DMG_MOD_SPI")
				+ summaryFunc["AP"](sum) * GSM("ADD_SPELL_DMG_MOD_AP")
		end,
	},
	-- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	{
		option = "sumHolyDmg",
		name = "HOLY_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["HOLY_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumArcaneDmg",
		name = "ARCANE_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["ARCANE_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	{
		option = "sumFireDmg",
		name = "FIRE_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["FIRE_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumNatureDmg",
		name = "NATURE_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["NATURE_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumFrostDmg",
		name = "FROST_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["FROST_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	{
		option = "sumShadowDmg",
		name = "SHADOW_SPELL_DMG",
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum["SHADOW_SPELL_DMG"]
			) + summaryFunc["SPELL_DMG"](sum)
		 end,
	},
	-- Healing - HEAL, AGI, STR, INT, SPI, AP
	{
		option = "sumHealing",
		name = "HEAL",
		func = function(sum)
			return GSM("MOD_HEALING") * (
				sum["HEAL"]
				+ (sum["STR"] * GSM("ADD_HEALING_MOD_STR"))
				+ (sum["AGI"] * GSM("ADD_HEALING_MOD_AGI"))
				+ (sum["INT"] * GSM("ADD_HEALING_MOD_INT"))
				+ (sum["SPI"] * GSM("ADD_HEALING_MOD_SPI"))
				+ (summaryFunc["AP"](sum) * GSM("ADD_HEALING_MOD_AP"))
			)
		end,
	},
	-- Spell Hit Chance - SPELL_HIT_RATING
	{
		option = "sumSpellHit",
		name = "SPELL_HIT",
		func = function(sum)
			return sum["SPELL_HIT"]
				+ StatLogic:GetEffectFromRating(sum["SPELL_HIT_RATING"], "SPELL_HIT_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Spell Hit Rating - SPELL_HIT_RATING
	{
		option = "sumSpellHitRating",
		name = "SPELL_HIT_RATING",
		func = function(sum)
			return sum["SPELL_HIT_RATING"]
		end,
	},
	-- Spell Crit Chance - SPELL_CRIT_RATING, INT
	{
		option = "sumSpellCrit",
		name = "SPELL_CRIT",
		func = function(sum)
			return sum["SPELL_CRIT"]
				+ StatLogic:GetEffectFromRating(summaryFunc["SPELL_CRIT_RATING"](sum), "SPELL_CRIT_RATING", calcLevel)
				+ StatLogic:GetSpellCritFromInt(sum["INT"], class, calcLevel)
		end,
		ispercent = true,
	},
	-- Spell Crit Rating - SPELL_CRIT_RATING
	{
		option = "sumSpellCritRating",
		name = "SPELL_CRIT_RATING",
		func = function(sum)
			return sum["SPELL_CRIT_RATING"]
				+ sum["SPI"] * GSM("ADD_SPELL_CRIT_RATING_MOD_SPI")
		end,
	},
	-- Spell Haste - SPELL_HASTE_RATING
	{
		option = "sumSpellHaste",
		name = "SPELL_HASTE",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["SPELL_HASTE_RATING"], "SPELL_HASTE_RATING", calcLevel)
		end,
		ispercent = true,
	},
	-- Spell Haste Rating - SPELL_HASTE_RATING
	{
		option = "sumSpellHasteRating",
		name = "SPELL_HASTE_RATING",
		func = function(sum)
			return sum["SPELL_HASTE_RATING"]
		end,
	},
	-- Spell Penetration - SPELLPEN
	{
		option = "sumPenetration",
		name = "SPELLPEN",
		func = function(sum)
			return sum["SPELLPEN"]
		end,
	},
	----------
	-- Tank --
	----------
	-- Armor - ARMOR, ARMOR_BONUS, AGI, INT
	{
		option = "sumArmor",
		name = "ARMOR",
		func = function(sum)
			return GSM("MOD_ARMOR") * sum["ARMOR"]
				+ sum["ARMOR_BONUS"]
				+ sum["AGI"] * ARMOR_PER_AGILITY
				+ sum["INT"] * GSM("ADD_ARMOR_MOD_INT")
		 end,
	},
	-- Dodge Chance Before DR - DODGE, DODGE_RATING, DEFENSE, AGI
	{
		option = "sumDodgeBeforeDR",
		name = "DODGE_NO_DR",
		func = function(sum)
			return sum["DODGE"]
				+ StatLogic:GetEffectFromRating(sum["DODGE_RATING"], "DODGE_RATING", calcLevel)
				+ summaryFunc["DEFENSE"](sum) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
				+ StatLogic:GetDodgeFromAgi(sum["AGI"])
		end,
		ispercent = true,
	},
	-- Dodge Chance
	{
		option = "sumDodge",
		name = "DODGE",
		func = function(sum, sumType, link)
			local dodge = summaryFunc["DODGE_NO_DR"](sum)
			if profileDB.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					dodge = StatLogic:GetAvoidanceGainAfterDR("DODGE", dodge)
				elseif sumType == "sum" then
					dodge = StatLogic:GetAvoidanceGainAfterDR("DODGE", equippedDodge + dodge) - StatLogic:GetAvoidanceGainAfterDR("DODGE", equippedDodge)
				end
			end
			return dodge
		 end,
		ispercent = true,
	},
	-- Dodge Rating - DODGE_RATING
	{
		option = "sumDodgeRating",
		name = "DODGE_RATING",
		func = function(sum)
			return sum["DODGE_RATING"]
		end,
	},
	-- Parry Chance Before DR - PARRY, PARRY_RATING, DEFENSE
	{
		option = "sumParryBeforeDR",
		name = "PARRY_NO_DR",
		func = function(sum)
			return GetParryChance() > 0 and (
				sum["PARRY"]
				+ StatLogic:GetEffectFromRating(summaryFunc["PARRY_RATING"](sum), "PARRY_RATING", calcLevel)
				+ summaryFunc["DEFENSE"](sum) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
			) or 0
		end,
		ispercent = true,
	},
	-- Parry Chance
	{
		option = "sumParry",
		name = "PARRY",
		func = function(sum, sumType, link)
			local parry = summaryFunc["PARRY_NO_DR"](sum)
			if profileDB.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					parry = StatLogic:GetAvoidanceGainAfterDR("PARRY", parry)
				elseif sumType == "sum" then
					parry = StatLogic:GetAvoidanceGainAfterDR("PARRY", equippedParry + parry) - StatLogic:GetAvoidanceGainAfterDR("PARRY", equippedParry)
				end
			end
			return parry
		 end,
		ispercent = true,
	},
	-- Parry Rating - PARRY_RATING
	{
		option = "sumParryRating",
		name = "PARRY_RATING",
		func = function(sum)
			return sum["PARRY_RATING"]
				+ sum["STR"] * GSM("ADD_PARRY_RATING_MOD_STR")
		end,
	},
	-- Block Chance - BLOCK, BLOCK_RATING, DEFENSE
	{
		option = "sumBlock",
		name = "BLOCK",
		func = function(sum)
			return GetBlockChance() > 0 and (
				sum["BLOCK"]
				+ StatLogic:GetEffectFromRating(sum["BLOCK_RATING"], "BLOCK_RATING", calcLevel)
				+ summaryFunc["DEFENSE"](sum) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
			) or 0
		end,
		ispercent = true,
	},
	-- Block Rating - BLOCK_RATING
	{
		option = "sumBlockRating",
		name = "BLOCK_RATING",
		func = function(sum)
			return sum["BLOCK_RATING"]
		end,
	},
	-- Block Value - BLOCK_VALUE, STR
	{
		option = "sumBlockValue",
		name = "BLOCK_VALUE",
		func = function(sum)
			return GetBlockChance() > 0 and (
				GSM("MOD_BLOCK_VALUE") * (
					sum["BLOCK_VALUE"]
					+ sum["STR"] * StatLogic:GetBlockValuePerStr(class)
				)
			) or 0
		end,
	},
	-- Hit Avoidance Before DR - DEFENSE
	{
		option = "sumHitAvoidBeforeDR",
		name = "MELEE_HIT_AVOID_NO_DR",
		func = function(sum)
			return summaryFunc["DEFENSE"](sum) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
		end,
		ispercent = true,
	},
	-- Hit Avoidance
	{
		option = "sumHitAvoid",
		name = "MELEE_HIT_AVOID",
		func = function(sum, sumType, link)
			local missed = summaryFunc["MELEE_HIT_AVOID_NO_DR"](sum)
			if profileDB.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					missed = StatLogic:GetAvoidanceGainAfterDR("MELEE_HIT_AVOID", missed)
				elseif sumType == "sum" then
					missed = StatLogic:GetAvoidanceGainAfterDR("MELEE_HIT_AVOID", equippedMissed + missed) - StatLogic:GetAvoidanceGainAfterDR("MELEE_HIT_AVOID", equippedMissed)
				end
			end
			return missed
		 end,
		ispercent = true,
	},
	-- Defense - DEFENSE_RATING
	{
		option = "sumDefense",
		name = "DEFENSE",
		func = function(sum)
			return sum["DEFENSE"]
				+ StatLogic:GetEffectFromRating(sum["DEFENSE_RATING"], "DEFENSE_RATING", calcLevel)
		end,
	},
	-- Avoidance - DODGE, PARRY, MELEE_HIT_AVOID, BLOCK(Optional)
	{
		option = "sumAvoidance",
		name = "AVOIDANCE",
		ispercent = true,
		func = function(sum, sumType, link)
			local dodge = summaryFunc["DODGE"](sum, sumType, link)
			local parry = summaryFunc["PARRY"](sum, sumType, link)
			local missed = summaryFunc["MELEE_HIT_AVOID"](sum, sumType, link)
			local block = 0
			if profileDB.sumAvoidWithBlock then
				block = summaryFunc["BLOCK"](sum, sumType, link)
			end
			return parry + dodge + missed + block
		end,
	},
	-- Crit Avoidance - RESILIENCE_RATING, DEFENSE
	{
		option = "sumCritAvoid",
		name = "MELEE_CRIT_AVOID",
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum["RESILIENCE_RATING"], "RESILIENCE_RATING", calcLevel)
				+ summaryFunc["DEFENSE"](sum) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
		 end,
		ispercent = true,
	},
	-- Resilience - RESILIENCE_RATING
	{
		option = "sumResilience",
		name = "RESILIENCE_RATING",
		func = function(sum)
			return sum["RESILIENCE_RATING"]
		end,
	},
	-- Arcane Resistance - ARCANE_RES
	{
		option = "sumArcaneResist",
		name = "ARCANE_RES",
		func = function(sum)
			return sum["ARCANE_RES"]
		end,
	},
	-- Fire Resistance - FIRE_RES
	{
		option = "sumFireResist",
		name = "FIRE_RES",
		func = function(sum)
			return sum["FIRE_RES"]
		end,
	},
	-- Nature Resistance - NATURE_RES
	{
		option = "sumNatureResist",
		name = "NATURE_RES",
		func = function(sum)
			return sum["NATURE_RES"]
		end,
	},
	-- Frost Resistance - FROST_RES
	{
		option = "sumFrostResist",
		name = "FROST_RES",
		func = function(sum)
			return sum["FROST_RES"]
		end,
	},
	-- Shadow Resistance - SHADOW_RES
	{
		option = "sumShadowResist",
		name = "SHADOW_RES",
		func = function(sum)
			return sum["SHADOW_RES"]
		end,
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

-- Build summaryFunc
for _, calcData in pairs(summaryCalcData) do
	summaryFunc[calcData.name] = calcData.func
end

local function sumSortAlphaComp(a, b)
	return a[1] < b[1]
end

local function WriteSummary(tooltip, output)
	if globalDB.sumBlankLine then
		tooltip:AddLine(" ")
	end
	if globalDB.sumShowTitle then
		tooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..L["Stat Summary"]..FONT_COLOR_CODE_CLOSE)
		if globalDB.sumShowIcon then
			tooltip:AddTexture("Interface\\AddOns\\RatingBuster\\images\\Sigma")
		end
	end
	local statR, statG, statB = globalDB.sumStatColor:GetRGB()
	local valueR, valueG, valueB = globalDB.sumValueColor:GetRGB()
	for _, o in ipairs(output) do
		tooltip:AddDoubleLine(o[1], o[2], statR, statG, statB, valueR, valueG, valueB)
	end
	if globalDB.sumBlankLineAfter then
		tooltip:AddLine(" ")
	end
end

function RatingBuster:StatSummary(tooltip, name, link)
	-- Hide stat summary for equipped items
	if globalDB.sumIgnoreEquipped and IsEquippedItem(link) then return end

	-- Show stat summary only for highest level armor type and items you can use with uncommon quality and up
	if globalDB.sumIgnoreUnused then
		local _, _, itemRarity, _, _, _, _, _, itemEquipLoc, _, classID, subclassID = GetItemInfo(link)

		-- Check rarity
		if not itemRarity or itemRarity < 2 then
			return
		end

		-- Check armor type
		if classID == Enum.ItemClass.Armor and armorTypes[subclassID] and (not classArmorTypes[class][subclassID]) and itemEquipLoc ~= "INVTYPE_CLOAK" then
			return
		end

		-- Check for Red item types
		local tName = tooltip:GetName()
		if _G[tName.."TextRight3"]:GetText() and select(2, _G[tName.."TextRight3"]:GetTextColor()) < 0.2 then
			return
		end
		if _G[tName.."TextRight4"]:GetText() and select(2, _G[tName.."TextRight4"]:GetTextColor()) < 0.2 then
			return
		end
		if select(2, _G[tName.."TextLeft3"]:GetTextColor()) < 0.2 then
			return
		end
		if select(2, _G[tName.."TextLeft4"]:GetTextColor()) < 0.2 then
			return
		end
	end

	-- Ignore enchants and gems on items when calculating the stat summary
	local red = profileDB.sumGemRed.gemID
	local yellow = profileDB.sumGemYellow.gemID
	local blue = profileDB.sumGemBlue.gemID
	local meta = profileDB.sumGemMeta.gemID

	if globalDB.sumIgnoreEnchant then
		link = StatLogic:RemoveEnchant(link)
	end
	if globalDB.sumIgnoreGems then
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
	if globalDB.calcDiff and (globalDB.sumDiffStyle == "comp") then
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
		local _, mainlink, difflink1, difflink2 = StatLogic:GetDiffID(mainTooltip, globalDB.sumIgnoreEnchant, globalDB.sumIgnoreGems, red, yellow, blue, meta)
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
		id = StatLogic:GetDiffID(link, globalDB.sumIgnoreEnchant, globalDB.sumIgnoreGems, red, yellow, blue, meta)
	end

	local numLines = tooltip:NumLines()

	-- Check Cache
	if cache[id] and cache[id].numLines == numLines then
		if table.maxn(cache[id]) == 0 then return end
		WriteSummary(tooltip, cache[id])
		return
	end

	-------------------------
	-- Build Summary Table --
	local statData = {}
	statData.sum = StatLogic:GetSum(link)
	if not statData.sum then return end
	if not globalDB.calcSum then
		statData.sum = nil
	end

	-- Ignore bags
	if not StatLogic:GetDiff(link) then return end

	-- Get Diff Data
	if globalDB.calcDiff then
		if globalDB.sumDiffStyle == "comp" then
			if tooltipLevel > 0 then
				statData.diff1 = select(tooltipLevel, StatLogic:GetDiff(mainTooltip, nil, nil, globalDB.sumIgnoreEnchant, globalDB.sumIgnoreGems, red, yellow, blue, meta))
			end
		else
			statData.diff1, statData.diff2 = StatLogic:GetDiff(link, nil, nil, globalDB.sumIgnoreEnchant, globalDB.sumIgnoreGems, red, yellow, blue, meta)
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
			v["STR"] = v["STR"] * GSM("MOD_STR")
			v["AGI"] = v["AGI"] * GSM("MOD_AGI")
			v["STA"] = v["STA"] * GSM("MOD_STA")
			v["INT"] = v["INT"] * GSM("MOD_INT")
			v["SPI"] = v["SPI"] * GSM("MOD_SPI")
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
			d[k] = (sum["HEALTH"] + (sum["STA"] * 10)) * GSM("MOD_HEALTH")
		end
		tinsert(summary, d)
	end
	local summaryCalcData = {
		-- Health - HEALTH, STA
		sumHP = {
			name = "HEALTH",
			func = function(sum)
				return (sum["HEALTH"] + (sum["STA"] * 10)) * GSM("MOD_HEALTH")
			end,
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
					entry[statDataType] = calcData.func(statTable, statDataType, link)
				end
			end
			tinsert(summary, entry)
		end
	end

	local calcSum = globalDB.calcSum
	local calcDiff = globalDB.calcDiff
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
	output.numLines = numLines
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
	if globalDB.sumSortAlpha then
		tsort(output, sumSortAlphaComp)
	end
	-- Write cache
	cache[id] = output
	if table.maxn(output) == 0 then return end
	WriteSummary(tooltip, output)
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
		ItemRefTooltip:SetInventoryItem("player", 12)
		RatingBuster.ProcessTooltip(ItemRefTooltip, link)
	end
	return GetTime() - t1
end
