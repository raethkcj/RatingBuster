local addonName, addon = ...

--[[
Name: RatingBuster
Revision: $Revision: 78903 $
Author: Whitetooth, raethkcj
Description: Converts combat ratings in tooltips into normal percentages.
]]

---------------
-- Libraries --
---------------
local StatLogic = LibStub("StatLogic")
local L = LibStub("AceLocale-3.0"):GetLocale("RatingBuster")
local S = setmetatable(addon.S, { __index = L })
---@cast L RatingBusterLocale

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
local addonNameWithVersion = ("%s %s"):format(addonName, RatingBuster.version)
RatingBuster.date = ("$Date: 2008-07-22 15:35:19 +0800 (星期二, 22 七月 2008) $"):gsub("^.-(%d%d%d%d%-%d%d%-%d%d).-$", "%1")

-----------
-- Cache --
-----------
local cache = setmetatable({}, {
	__index = function(t, k)
		t[k] = setmetatable({}, { __mode = "kv" })
		return t[k]
	end,
})

---------------------
-- Local Variables --
---------------------
local _
local _, class = UnitClass("player")
local playerLevel
local db -- Initialized in :OnInitialize()

-- Localize globals
local pairs = pairs
local ipairs = ipairs
local type = type
local select = select
local tinsert = tinsert
local tremove = tremove
local tsort = table.sort
local unpack = unpack
local tonumber = tonumber

local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance

local GetActiveTalentGroup = GetActiveTalentGroup or C_SpecializationInfo.GetActiveSpecGroup
local GetSpecialization = GetSpecialization or C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo or C_SpecializationInfo.GetSpecializationInfo

---------------------------
-- Slash Command Options --
---------------------------

local function getOption(info, dataType)
	dataType = dataType or "profile"
	return db[dataType][info[#info]]
end

local function getGlobalOption(info)
	return getOption(info, "global")
end

local function setOption(info, value, dataType)
	dataType = dataType or "profile"
	db[dataType][info[#info]] = value
	RatingBuster:ClearCache()
end

local function setGlobalOption(info, value)
	return setOption(info, value, "global")
end

local function getGem(info)
	return db.profile[info[#info]].gemLink
end

local function setGem(info, value)
	if value == "" then
		db.profile[info[#info]].itemID = nil
		db.profile[info[#info]].gemID = nil
		db.profile[info[#info]].gemName = nil
		db.profile[info[#info]].gemLink = nil
		return
	end
	local gemID, gemText = StatLogic:GetGemID(value)
	if gemID and gemText then
		local name, link = C_Item.GetItemInfo(value)
		local itemID = link:match("item:(%d+)")
		db.profile[info[#info]].itemID = itemID
		db.profile[info[#info]].gemID = gemID
		db.profile[info[#info]].gemName = name
		db.profile[info[#info]].gemLink = link
		-- Trim spaces
		gemText = gemText:trim()
		-- Strip color codes
		if gemText:sub(-2) == "|r" then
			gemText = gemText:sub(1, -3)
		end
		if gemText:sub(1, 10):find("|c%x%x%x%x%x%x%x%x") then
			gemText = gemText:sub(11)
		end
		db.profile[info[#info]].gemText = gemText
		RatingBuster:ClearCache()
		local socket = "EMPTY_SOCKET_" .. info[#info]:sub(7):upper()
		if not debugstack():find("AceConsole") then
			RatingBuster:Print(L["%s is now set to %s"]:format(_G[socket], link))
		end
	else
		RatingBuster:Print(L["Queried server for Gem: %s. Try again in 5 secs."]:format(value))
	end
end

local function getColor(info)
	local color = db.global[info[#info]]
	return color:GetRGB()
end

local function setColor(info, r, g, b)
	local color = db.global[info[#info]]
	color:SetRGB(r, g, b)
	RatingBuster:ClearCache()
end

ColorPickerFrame:SetMovable(true)
ColorPickerFrame:EnableMouse(true)
ColorPickerFrame:RegisterForDrag("LeftButton")
ColorPickerFrame:SetScript("OnDragStart", function()
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
	set = setOption,
	args = {
		help = {
			type = 'execute',
			name = L["Help"],
			desc = L["Show this help message"],
			order = 1,
			func = function()
				LibStub("AceConfigCmd-3.0").HandleCommand(RatingBuster, "rb", addonNameWithVersion, "")
			end,
			dialogHidden = true,
		},
		debug = {
			type = "execute",
			name = "Debug",
			desc = "Toggle debugging",
			func = function()
				RatingBuster:ClearCache()
				StatLogic:ClearCache()
			end,
			dialogHidden = true,
		},
		pp = {
			type = "execute",
			name = "Performance Profile",
			desc = "Execute a performance test and display the results",
			func = function()
				RatingBuster:PerformanceProfile()
			end,
			dialogHidden = true,
		},
		rating = {
			type = 'group',
			name = L["Rating"],
			desc = L["Options for Rating display"],
			order = 2,
			hidden = function()
				return addon.tocversion < 20000
			end,
			args = {
				showRatings = {
					type = 'toggle',
					name = L["Show Rating conversions"],
					desc = L["Show Rating conversions in tooltips"],
					order = 1,
					width = "full",
				},
				enableAvoidanceDiminishingReturns = {
					type = 'toggle',
					name = L["Enable Avoidance Diminishing Returns"],
					desc = L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"],
					order = 5,
					width = "full",
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
			order = 3,
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
					name = L[StatLogic.Stats.Strength],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Strength]),
					width = "full",
					order = 3,
					args = {},
					hidden = true,
				},
				agi = {
					type = 'group',
					name = L[StatLogic.Stats.Agility],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Agility]),
					width = "full",
					order = 4,
					args = {},
					hidden = true,
				},
				sta = {
					type = 'group',
					name = L[StatLogic.Stats.Stamina],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Stamina]),
					width = "full",
					order = 5,
					args = {},
					hidden = true,
				},
				int = {
					type = 'group',
					name = L[StatLogic.Stats.Intellect],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Intellect]),
					width = "full",
					order = 6,
					args = {},
					hidden = true,
				},
				spi = {
					type = 'group',
					name = L[StatLogic.Stats.Spirit],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Spirit]),
					width = "full",
					order = 7,
					args = {},
					hidden = true,
				},
				hit = {
					type = 'group',
					name = L[StatLogic.Stats.HitRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.HitRating]),
					width = "full",
					order = 8,
					args = {},
					hidden = true,
				},
				crit = {
					type = 'group',
					name = L[StatLogic.Stats.CritRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.CritRating]),
					width = "full",
					order = 9,
					args = {},
					hidden = true,
				},
				haste = {
					type = 'group',
					name = L[StatLogic.Stats.HasteRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.HasteRating]),
					width = "full",
					order = 10,
					args = {},
					hidden = true,
				},
				mastery = {
					type = 'group',
					name = L[StatLogic.Stats.MasteryRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.MasteryRating]),
					order = 11,
					args = {},
					hidden = true,
				},
				health = {
					type = 'group',
					name = L[StatLogic.Stats.Health],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Health]),
					width = "full",
					order = 12,
					args = {},
					hidden = true,
				},
				mana_regen = {
					type = 'group',
					name = L[StatLogic.Stats.ManaRegen],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.ManaRegen]),
					width = "full",
					order = 13,
					args = {},
					hidden = true,
				},
				ap = {
					type = 'group',
					name = L[StatLogic.Stats.AttackPower],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.AttackPower]),
					order = 14,
					args = {},
					hidden = true,
				},
				weaponskill = {
					type = 'group',
					name = L[StatLogic.Stats.WeaponSkill],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.WeaponSkill]),
					order = 15,
					hidden = true,
					--[[
					hidden = function()
						return addon.tocversion >= 20000
					end,
					]]--
					args = {
						wpnBreakDown = {
							type = 'toggle',
							name = L["Weapon Skill breakdown"],
							desc = L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"],
							width = "full",
						},
					},
				},
				expertise = {
					type = 'group',
					name = L[StatLogic.Stats.ExpertiseRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.ExpertiseRating]),
					order = 16,
					hidden = true,
					args = {},
				},
				spell_power = {
					type = 'group',
					name = L[StatLogic.Stats.SpellPower],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.SpellPower]),
					order = 17,
					args = {},
					hidden = true,
				},
				spell_dmg = {
					type = 'group',
					name = L[StatLogic.Stats.SpellDamage],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.SpellDamage]),
					order = 18,
					args = {},
					hidden = true,
				},
				spell_crit = {
					type = 'group',
					name = L[StatLogic.Stats.SpellCrit],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.SpellCrit]),
					width = "full",
					order = 19,
					args = {},
					hidden = true,
				},
				armor = {
					type = 'group',
					name = L[StatLogic.Stats.Armor],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Armor]),
					order = 20,
					args = {},
					hidden = true,
				},
				defense = {
					type = 'group',
					name = L[StatLogic.Stats.Defense],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Defense]),
					order = 21,
					hidden = true,
					args = {},
				},
				resilience = {
					type = 'group',
					name = L[StatLogic.Stats.ResilienceRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.ResilienceRating]),
					order = 22,
					args = {},
					hidden = true,
				},
				pvp_power = {
					type = 'group',
					name = L[StatLogic.Stats.PvpPowerRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.PvpPowerRating]),
					order = 23,
					args = {},
					hidden = true,
				},
			},
		},
		sum = {
			type = 'group',
			name = L["Stat Summary"],
			desc = L["Options for stat summary"],
			order = 4,
			args = {
				sumGroup = {
					name = "",
					type = 'group',
					inline = true,
					get = getGlobalOption,
					set = setGlobalOption,
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
							order = 5,
						},
						showItemID = {
							type = 'toggle',
							name = L["Show ItemID"],
							desc = L["Show the ItemID in tooltips"],
							order = 6,
						},
						showItemLevel = {
							type = 'toggle',
							name = L["Show ItemLevel"],
							desc = L["Show the ItemLevel in tooltips"],
							order = 7,
						},
						sumShowIcon = {
							type = 'toggle',
							name = L["Show icon"],
							desc = L["Show the sigma icon before stat summary"],
							order = 8,
						},
						sumShowTitle = {
							type = 'toggle',
							name = L["Show title text"],
							desc = L["Show the title text before stat summary"],
							order = 9,
						},
						sumShowProfile = {
							type = 'toggle',
							name = L["Show profile name"],
							desc = L["Show profile name before stat summary"],
							order = 10,
						},
						showZeroValueStat = {
							type = 'toggle',
							name = L["Show zero value stats"],
							desc = L["Show zero value stats in summary for consistancy"],
							order = 11,
						},
						sumSortAlpha = {
							type = 'toggle',
							name = L["Sort StatSummary alphabetically"],
							desc = L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"],
							order = 12,
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
						space = {
							type = 'group',
							name = L["Add empty line"],
							inline = true,
							order = 15,
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
					},
				},
				ignore = {
					type = 'group',
					name = L["Ignore settings"],
					desc = L["Ignore stuff when calculating the stat summary"],
					get = getGlobalOption,
					set = setGlobalOption,
					args = {
						sumIgnoreUnused = {
							type = 'toggle',
							name = L["Ignore unused item types"],
							desc = L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"],
						},
						sumIgnoreNonPrimaryStat = {
							type = 'toggle',
							name = L["Ignore non-primary stat"],
							desc = L["Show stat summary only for items with your specialization's primary stat"],
							hidden = function()
								return addon.tocversion < 40000
							end,
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
							hidden = function()
								return addon.tocversion < 20000
							end,
						},
						sumIgnoreExtraSockets = {
							type = 'toggle',
							name = L["Ignore extra sockets"],
							desc = L["Ignore sockets from professions or consumable items when calculating the stat summary"],
							hidden = function()
								return addon.tocversion < 20000
							end,
						}
					},
				},
				basic = {
					type = 'group',
					name = L["Stat - Basic"],
					desc = L["Choose basic stats for summary"],
					args = {
						sumHP = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Health]),
							desc = L["Health <- Health, Stamina"],
							order = 1,
						},
						sumMP = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Mana]),
							desc = L["Mana <- Mana, Intellect"],
							order = 2,
						},
						sumManaRegen = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ManaRegen]),
							desc = L["Mana Regen <- Mana Regen, Spirit"],
							order = 3,
						},
						sumManaRegenNotCasting = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ManaRegenNotCasting]),
							desc = L["Mana Regen while not casting <- Spirit"],
							order = 4,
							hidden = function()
								return StatLogic:GetStatMod("ADD_MANA_REGEN_NOT_CASTING_MOD_NORMAL_MANA_REGEN") == 0
							end,
						},
						sumManaRegenOutOfCombat = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ManaRegenOutOfCombat]),
							desc = L["Mana Regen while not casting <- Spirit"],
							order = 4,
							hidden = function()
								return StatLogic:GetStatMod("ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_NORMAL_MANA_REGEN") == 0
							end,
						},
						sumHP5 = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.HealthRegen]),
							desc = L["Health Regen <- Health Regen"],
							order = 5,
						},
						sumHP5OC = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.HealthRegenOutOfCombat]),
							desc = L["Health Regen when out of combat <- Spirit"],
							order = 6,
						},
						sumStr = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Strength]),
							order = 7,
						},
						sumAgi = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Agility]),
							order = 8,
						},
						sumSta = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Stamina]),
							order = 9,
						},
						sumInt = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Intellect]),
							order = 10,
						},
						sumSpi = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Spirit]),
							order = 11,
						},
						sumMastery = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Mastery]),
							order = 12,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.MasteryRating)
							end,
						},
						sumMasteryEffect = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MasteryEffect]),
							order = 12,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.MasteryRating)
							end,
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
							name = L["Sum %s"]:format(L[StatLogic.Stats.AttackPower]),
							desc = L["Attack Power <- Attack Power, Strength, Agility"],
							width = "double",
							order = 1,
						},
						sumHit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeHit]),
							desc = L["Hit Chance <- Hit Rating, Weapon Skill Rating"],
							order = 2,
						},
						sumHitRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeHitRating]),
							order = 3,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.MeleeHitRating)
							end,
						},
						sumCrit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeCrit]),
							desc = L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"],
							order = 4,
						},
						sumCritRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeCritRating]),
							order = 5,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.MeleeCritRating)
							end,
						},
						sumHaste = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeHaste]),
							desc = L["Haste <- Haste Rating"],
							order = 6,
						},
						sumHasteRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.MeleeHasteRating]),
							order = 7,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.MeleeHasteRating)
							end,
						},
						sumIgnoreArmor = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.IgnoreArmor]),
							hidden = function()
								return addon.tocversion >= 20000 and addon.tocversion < 30000
							end,
							order = 8,
						},
						sumArmorPenetration = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ArmorPenetration]),
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.ArmorPenetrationRating)
							end,
							order = 9,
						},
						sumArmorPenetrationRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ArmorPenetrationRating]),
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.ArmorPenetrationRating)
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
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedAttackPower]),
							desc = L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"],
							width = "double",
							order = 12,
						},
						sumRangedHit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedHit]),
							desc = L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"],
							order = 13,
						},
						sumRangedHitRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedHitRating]),
							order = 14,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.RangedHitRating)
							end,
						},
						sumRangedCrit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedCrit]),
							desc = L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"],
							order = 15,
						},
						sumRangedCritRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedCritRating]),
							order = 16,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.RangedCritRating)
							end,
						},
						sumRangedHaste = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedHaste]),
							desc = L["Ranged Haste <- Haste Rating, Ranged Haste Rating"],
							order = 17,
						},
						sumRangedHasteRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.RangedHasteRating]),
							order = 18,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.RangedHasteRating)
							end,
						},
						weapon = {
							type = 'header',
							name = L["Weapon"],
							order = 19,
						},
						sumWeaponAverageDamage = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.AverageWeaponDamage]),
							order = 20,
						},
						sumWeaponDPS = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.WeaponDPS]),
							order = 21,
						},
						sumDodgeNeglect = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.DodgeReduction]),
							desc = L["Dodge Reduction <- Expertise, Weapon Skill Rating"],
							order = 22,
						},
						sumParryNeglect = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ParryReduction]),
							desc = L["Parry Reduction <- Expertise, Weapon Skill Rating"],
							order = 23,
						},
						sumWeaponSkill = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.WeaponSkill]),
							desc = L["Weapon Skill <- Weapon Skill Rating"],
							order = 24,
							hidden = function()
								return addon.tocversion >= 20000
							end,
						},
						sumExpertise = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Expertise]),
							desc = L["Expertise <- Expertise Rating"],
							order = 25,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.ExpertiseRating)
							end,
						},
					},
				},
				spell = {
					type = 'group',
					name = L["Stat - Spell"],
					desc = L["Choose spell damage and healing stats for summary"],
					args = {
						sumSpellPower = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellPower]),
							desc = L[StatLogic.Stats.SpellPower],
						},
						sumSpellDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellDamage]),
							desc = L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"],
						},
						sumHolyDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.HolyDamage]),
							desc = L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"],
						},
						sumArcaneDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ArcaneDamage]),
							desc = L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"],
						},
						sumFireDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FireDamage]),
							desc = L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"],
						},
						sumNatureDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.NatureDamage]),
							desc = L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"],
						},
						sumFrostDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FrostDamage]),
							desc = L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"],
						},
						sumShadowDmg = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ShadowDamage]),
							desc = L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"],
						},
						sumHealing = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.HealingPower]),
							desc = L["Healing <- Healing, Intellect, Spirit, Agility, Strength"],
						},
						sumSpellHit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellHit]),
							desc = L["Spell Hit Chance <- Spell Hit Rating"],
						},
						sumSpellHitRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellHitRating]),
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.SpellHitRating)
							end,
						},
						sumSpellCrit = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellCrit]),
							desc = L["Spell Crit Chance <- Spell Crit Rating, Intellect"],
						},
						sumSpellCritRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellCritRating]),
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.SpellCritRating)
							end,
						},
						sumSpellHaste = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellHaste]),
							desc = L["Spell Haste <- Spell Haste Rating"],
						},
						sumSpellHasteRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellHasteRating]),
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.SpellHasteRating)
							end,
						},
						sumPenetration = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.SpellPenetration]),
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
							name = L["Sum %s"]:format(L[StatLogic.Stats.Avoidance]),
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
							name = L["Sum %s"]:format(L[StatLogic.Stats.Dodge]),
							desc = L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"],
							order = 3,
						},
						sumDodgeRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.DodgeRating]),
							order = 4,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.DodgeRating)
							end,
						},
						sumBlock = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.BlockChance]),
							desc = L["Block Chance <- Block Rating, Defense Rating"],
							order = 5,
						},
						sumBlockRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.BlockRating]),
							order = 6,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.BlockRating)
							end,
						},
						sumBlockValue = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.BlockValue]),
							desc = L["Block Value <- Block Value, Strength"],
							order = 7,
							hidden = function()
								return addon.tocversion >= 40000
							end,
						},
						sumParry = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Parry]),
							desc = L["Parry Chance <- Parry Rating, Defense Rating"],
							order = 8,
						},
						sumParryRating = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ParryRating]),
							order = 9,
							hidden = function()
								return not StatLogic:RatingExists(StatLogic.Stats.ParryRating)
							end,
						},
						sumHitAvoid = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Miss]),
							desc = L["Hit Avoidance <- Defense Rating"],
							order = 10,
							hidden = function()
								return addon.tocversion >= 40000
							end,
						},
						sumArmor = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Armor]),
							desc = L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"],
							order = 11,
						},
						sumDefense = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Defense]),
							desc = L["Defense <- Defense Rating"],
							order = 12,
							hidden = function()
								return addon.tocversion >= 40000
							end,
						},
						sumCritAvoid = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.CritAvoidance]),
							desc = L["Crit Avoidance <- Defense Rating, Resilience"],
							order = 13,
							hidden = function()
								return addon.tocversion >= 40000
							end,
						},
						sumResilience = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.Resilience]),
							order = 14,
							hidden = function()
								return addon.tocversion < 20000
							end,
						},
						sumPvpPower = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.PvpPower]),
							order = 15,
							hidden = function()
								return addon.tocversion < 50000
							end,
						},
						sumArcaneResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ArcaneResistance]),
							order = 16,
						},
						sumFireResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FireResistance]),
							order = 17,
						},
						sumNatureResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.NatureResistance]),
							order = 18,
						},
						sumFrostResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FrostResistance]),
							order = 19,
						},
						sumShadowResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ShadowResistance]),
							order = 20,
						},
					},
				},
				gem = {
					type = 'group',
					name = L["Gems"],
					desc = L["Auto fill empty gem slots"],
					hidden = function()
						return addon.tocversion < 20000
					end,
					args = {
						sumGemRed = {
							type = 'input',
							name = EMPTY_SOCKET_RED,
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 1,
						},
						sumGemYellow = {
							type = 'input',
							name = EMPTY_SOCKET_YELLOW,
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 2,
						},
						sumGemBlue = {
							type = 'input',
							name = EMPTY_SOCKET_BLUE,
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 3,
						},
						sumGemMeta = {
							type = 'input',
							name = EMPTY_SOCKET_META,
							desc = L["ItemID or Link of the gem you would like to auto fill"],
							usage = L["<ItemID|Link>"],
							get = getGem,
							set = setGem,
							order = 4,
						},
						sumGemPrismatic = {
							type = 'input',
							name = EMPTY_SOCKET_PRISMATIC,
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
			order = 5,
			get = function(info)
				local db = RatingBuster.db:GetNamespace("AlwaysBuffed")
				if db then
					return db.profile[info[#info]]
				end
			end,
			set = function(info, v)
				local db = RatingBuster.db:GetNamespace("AlwaysBuffed")
				if db then
					db.profile[info[#info]] = v
					RatingBuster:ClearCache()
					StatLogic:InvalidateEvent("UNIT_AURA", "player")
				end
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
					name = L["$class Self Buffs"]:gsub("$class", (UnitClass("player"))),
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

---------------------
-- Saved Variables --
---------------------
-- Default values
local defaults = {
	global = {
		textColor = CreateColor(1.0, 0.996, 0.545),
		enableReforgeUI = true,

		showSum = true,
		calcSum = true,
		calcDiff = true,
		sumDiffStyle = "main",
		hideBlizzardComparisons = true,
		showItemID = false,
		showItemLevel = false,
		sumShowIcon = true,
		sumShowTitle = true,
		sumShowProfile = true,
		showZeroValueStat = false,
		sumSortAlpha = false,
		sumStatColor = CreateColor(NORMAL_FONT_COLOR:GetRGBA()),
		sumValueColor = CreateColor(NORMAL_FONT_COLOR:GetRGBA()),
		sumBlankLine = true,
		sumBlankLineAfter = false,

		sumIgnoreUnused = true,
		sumIgnoreEquipped = false,
		sumIgnoreEnchant = true,
		sumIgnoreGems = false,
		sumIgnoreExtraSockets = true,

		swapProfileKeybinding = "",
	},
	profile = {
		enableAvoidanceDiminishingReturns = StatLogic.GetAvoidanceAfterDR and true or false,
		showRatings = true,
		wpnBreakDown = false,
		showStats = true,
		sumAvoidWithBlock = false,

		-- Base stat conversions
		showBlockValueFromStr = false,

		showRAPFromAgi = false,
		showArmorFromAgi = false,

		showHealthFromSta = false,

		showManaFromInt = false,
		showManaRegenNotCastingFromManaRegen = false,
		showManaRegenOutOfCombatFromManaRegen = false,
		showSpellCritFromInt = true,

		showModifiedRangedAttackPower = false,

		showHP5NCFromHealth = false,

		showMeleeHitFromHitRating = false,
		showMeleeCritFromCritRating = false,
		showMeleeHasteFromHasteRating = false,
		showSpellHitFromHitRating = false,
		showSpellCritFromCritRating = false,
		showSpellHasteFromHasteRating = false,

		showDefenseFromDefenseRating = false,
		showExpertiseFromExpertiseRating = false,
		showCritAvoidanceFromResilience = false,
		showCritDamageReductionFromResilience = false,
		showPvpDamageReductionFromResilience = false,
		showMasteryFromMasteryRating = false,
		------------------
		-- Stat Summary --
		------------------
		-- Basic
		sumHP = true,
		sumMP = true,
		sumManaRegen = true,
		sumManaRegenNotCasting = false,
		sumManaRegenOutOfCombat = false,
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
		sumSpellHitRating = false,
		sumSpellCrit = false,
		sumSpellCritRating = false,
		sumSpellHaste = false,
		sumSpellHasteRating = false,
		sumPenetration = false,
		-- Tank
		sumArmor = false,
		sumDodge = false,
		sumDodgeRating = false,
		sumParry = false,
		sumParryRating = false,
		sumBlock = false,
		sumBlockRating = false,
		sumBlockValue = false,
		sumHitAvoid = false,
		sumCritAvoid = false,
		sumArcaneResist = false,
		sumFrostResist = false,
		sumNatureResist = false,
		sumFireResist = false,
		sumShadowResist = false,
		sumResilience = true,
		sumPvpPower = true,
		sumDefense = false,
		sumAvoidance = false,
		sumMasteryEffect = true,
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
		sumGemPrismatic = {
			itemID = nil,
			gemID = nil,
			gemText = nil,
		};
	},
}

-- Class specific settings
if class == "DEATHKNIGHT" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumMP = false
	defaults.profile.sumManaRegen = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.sumArmorPenetration = true
	defaults.profile.showSpellHitFromExpertise = false
elseif class == "DRUID" then
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumSpellDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
	defaults.profile.sumArmorPenetration = true
elseif class == "HUNTER" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumWeaponSkill = true
	defaults.profile.sumRAP = true
	defaults.profile.sumRangedHit = true
	defaults.profile.sumRangedCrit = true
	defaults.profile.sumRangedHaste = true
	defaults.profile.showModifiedRangedAttackPower = true
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showAPFromAgi = false
	defaults.profile.showRAPFromAgi = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.sumArmorPenetration = true
	defaults.profile.showSpellHitFromExpertise = false
	defaults.profile.showParryReductionFromExpertise = false
elseif class == "MAGE" then
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumSpellDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
	defaults.profile.showDodgeReductionFromExpertise = false
	defaults.profile.showParryReductionFromExpertise = false
	defaults.profile.showAPFromStr = false
elseif class == "MONK" then
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumSpellDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
elseif class == "PALADIN" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumWeaponSkill = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumHolyDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
elseif class == "PRIEST" then
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumShadowDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
	defaults.profile.showDodgeReductionFromExpertise = false
	defaults.profile.showParryReductionFromExpertise = false
	defaults.profile.showAPFromStr = false
elseif class == "ROGUE" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumWeaponSkill = true
	defaults.profile.sumMP = false
	defaults.profile.sumManaRegen = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.sumArmorPenetration = true
	defaults.profile.showSpellHitFromExpertise = false
elseif class == "SHAMAN" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumWeaponSkill = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumSpellDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
elseif class == "WARLOCK" then
	if addon.tocversion >= 30000 then
		defaults.profile.sumSpellPower = true
		defaults.profile.showSpellDmgFromSpellPower = false
		defaults.profile.showHealingFromSpellPower = false
	else
		defaults.profile.sumSpellDmg = true
		defaults.profile.sumHealing = true
	end
	defaults.profile.sumSpellHit = true
	defaults.profile.sumSpellCrit = true
	defaults.profile.sumSpellHaste = true
	defaults.profile.showCritFromAgi = false
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellHitFromHitRating = true
	defaults.profile.showSpellCritFromCritRating = true
	defaults.profile.showSpellHasteFromHasteRating = true
	defaults.profile.showDodgeReductionFromExpertise = false
	defaults.profile.showParryReductionFromExpertise = false
	defaults.profile.showAPFromStr = false
elseif class == "WARRIOR" then
	defaults.profile.sumWeaponAverageDamage = true
	defaults.profile.sumWeaponSkill = true
	defaults.profile.sumAvoidance = true
	defaults.profile.sumArmor = true
	defaults.profile.sumMP = false
	defaults.profile.sumManaRegen = false
	defaults.profile.sumAP = true
	defaults.profile.sumHit = true
	defaults.profile.sumCrit = true
	defaults.profile.sumHaste = true
	defaults.profile.sumExpertise = true
	defaults.profile.showSpellCritFromInt = false
	defaults.profile.showMeleeHitFromHitRating = true
	defaults.profile.showMeleeCritFromCritRating = true
	defaults.profile.showMeleeHasteFromHasteRating = true
	defaults.profile.sumArmorPenetration = true
	defaults.profile.showSpellHitFromExpertise = false
end

do
	local migrationOptions = {
		sumMP5   = { "sumManaRegen" },
		sumMP5NC = { "sumManaRegenNotCasting", "sumManaRegenOutOfCombat" },
		showMP5FromInt = { "showManaRegenFromInt", "showManaRegenFromManaRegen" },
		showMP5FromSpi = { "showManaRegenFromSpi", "showManaRegenFromManaRegen" },
		showMP5NCFromInt = { "showManaRegenNotCastingFromManaRegen", "showManaRegenOutOfCombatFromManaRegen" },
		showMP5NCFromSpi = { "showManaRegenNotCastingFromManaRegen", "showManaRegenOutOfCombatFromManaRegen" },
		ratingPhysical = { "showMeleeHitFromHitRating", "showMeleeCritFromCritRating", "showMeleeHasteFromHasteRating" },
		ratingSpell = { "showSpellHitFromHitRating", "showSpellCritFromCritRating", "showSpellHasteFromHasteRating" },
	}

	function addon.MigrateOptions(db)
		for old, newOptions in pairs(migrationOptions) do
			if db.profile[old] ~= nil then
				for _, new in ipairs(newOptions) do
					db.profile[new] = db.profile[old]
				end
				db.profile[old] = nil
			end
		end
	end
end

-- Generate options from expansion-specific StatModTables in StatLogic
do
	-- Backwards compatibility
	local statToOptionKey = setmetatable({
		["AP"] = "AP",
		["HEALTH_REG"] = "HP5",
		["NORMAL_HEALTH_REG"] = "HP5NC",
		["RANGED_AP"] = "RAP",
	},
	{
		__index = function(_, stat)
			if type(stat) == "table" then
				return tostring(stat)
			else
				-- Remove underscores, PascalCase
				return (stat:gsub("[%W_]*(%w+)[%W_]*", function(word)
					return word:lower():gsub("^%l", string.upper)
				end))
			end
		end
	})

	-- Backwards compatibility
	local statStringToStat = setmetatable({
		["AGI"] = StatLogic.Stats.Agility,
		["AP"] = StatLogic.Stats.AttackPower,
		["HEALING"] = StatLogic.Stats.HealingPower,
		["HEALTH_REG"] = StatLogic.Stats.HealthRegen,
		["INT"] = StatLogic.Stats.Intellect,
		["NORMAL_HEALTH_REG"] = StatLogic.Stats.HealthRegenOutOfCombat,
		["PVP_DAMAGE_REDUCTION"] = StatLogic.Stats.PvPDamageReduction,
		["RANGED_AP"] = StatLogic.Stats.RangedAttackPower,
		["SPELL_DMG"] = StatLogic.Stats.SpellDamage,
		["SPI"] = StatLogic.Stats.Spirit,
		["STA"] = StatLogic.Stats.Stamina,
		["STR"] = StatLogic.Stats.Strength,
	},
	{
		__index = function(_, stat)
			if type(stat) == "string" then
				local stat_name = stat:gsub("(%u)(%u+)_?", function(head, tail)
					return head .. tail:lower()
				end)
				return StatLogic.Stats[stat_name]
			else
				return stat
			end
		end
	})

	local statModSources = {}

	---@param add string?
	---@param mod string
	---@param sources { [string]: true }
	local addStatModOption = function(add, mod, sources)
		-- Override groups that are hidden by default
		local groupID, rating = mod:lower():gsub("_rating$", "")
		if mod == "RANGED_AP" then
			groupID = "ap"
		end
		if mod == "MASTERY_EFFECT" then
			groupID = "mastery"
		end

		local group = options.args.stat.args[groupID]
		if not group then return end
		group.hidden = false
		if rating > 0 then
			-- Rename Defense group to Defense Rating
			local mod_stat = statStringToStat[mod]
			group.name = L[mod_stat]
			group.desc = L["Changes the display of %s"]:format(L[mod_stat])
		end

		local key, name
		if add then
			-- ADD_HEALING_MOD_INT -> showHealingFromInt
			key = "show" .. statToOptionKey[add] .. "From" .. statToOptionKey[mod]
			name = L["Show %s"]:format(L[statStringToStat[add]])
		else
			key = "showModified" .. tostring(statStringToStat[mod])
			name = L["Show Modified %s"]:format(L[statStringToStat[mod]])
		end

		if defaults.profile[key] == nil then
			defaults.profile[key] = true
		end

		local option = group.args[key]
		if not option then
			option = {
				type = "toggle",
				width = "full",
				-- Prioritize direct results of rating conversion,
				-- as well as "modified" options
				order = (rating == 1 or not add) and 1 or nil,
			}
		end

		option.name = name

		if next(sources) then
			-- First, add to a set to ensure uniqueness among multiple statModTypes
			for source in pairs(sources) do
				statModSources[mod] = statModSources[mod] or {}
				statModSources[mod][add or mod] = statModSources[mod][add or mod] or {}
				statModSources[mod][add or mod][source] = true
			end

			-- Second, convert to an array just so we can use table.concat
			local sources_array = {}
			for source in pairs(statModSources[mod][add or mod]) do
				table.insert(sources_array, source)
			end
			option.desc = table.concat(sources_array, "\n")
		end

		group.args[key] = option
	end

	local season = C_Seasons and C_Seasons.HasActiveSeason() and C_Seasons.GetActiveSeason()
	local showRunes = season and season == Enum.SeasonID.SeasonOfDiscovery

	local function GenerateStatModOptions()
		local statModContext = StatLogic:NewStatModContext()
		for _, modList in pairs(StatLogic.StatModTable) do
			for statMod, cases in pairs(modList) do
				local add = StatLogic.StatModInfo[statMod].add
				local mod = StatLogic.StatModInfo[statMod].mod

				if mod then
					local sources = {}
					local showMod = false
					for _, case in ipairs(cases) do
						local showCase = false
						if not case.rune or showRunes then
							showMod = true
							showCase = true
						end
						if showCase then
							local name, icon
							local sourceSpell = case.aura or case.glyph or case.known or case.spellid
							if sourceSpell then
								local sourceSpellInfo = C_Spell.GetSpellInfo(sourceSpell)
								if sourceSpellInfo then
									name = sourceSpellInfo.name
									icon = sourceSpellInfo.iconID
								end
							elseif case.tab then
								name, icon = StatLogic:GetOrderedTalentInfo(case.tab, case.num)
							elseif case.set then
								name = C_Item.GetItemSetInfo(case.set)
								icon = [[Interface/PaperDollInfoFrame/UI-EquipmentManager-Toggle]]
							elseif case.enchant then
								name = StatLogic:GetEnchantText(case.enchant)
								-- Currently, all enchant statMods are Death Knight Runeforges
								icon = [[Interface/ICONS/Spell_DeathKnight_FrozenRuneWeapon]]
							end
							if name and icon then
								local source = "|T"..icon..":20|t"..name
								sources[source] = true
							end
						end
					end

					if showMod then
						if add then
							-- Molten Armor and Forceful Deflection give rating,
							-- but we show it to the user as the converted stat
							add = add:gsub("_RATING", "")

							-- We want to show the user Armor, regardless of where it comes from
							if add == "BONUS_ARMOR" then
								add = "ARMOR"
							end

							if add == "GENERIC_MANA_REGEN" or add == "NORMAL_MANA_REGEN" then
								add = "MANA_REGEN"
							elseif mod == "GENERIC_MANA_REGEN" or mod == "NORMAL_MANA_REGEN" then
								mod = "MANA_REGEN"
							elseif mod == "NORMAL_HEALTH_REG" then
								if statModContext("ADD_NORMAL_HEALTH_REG_MOD_SPI") > 0 then
									-- Vanilla through Wrath
									mod = "SPI"
								elseif statModContext("ADD_NORMAL_HEALTH_REG_MOD_HEALTH") > 0 then
									-- Cata onwards
									mod = "HEALTH"
								end
							elseif mod == "MANA" then
								mod = "INT"
							end

							-- Demonic Knowledge technically scales with pet stats,
							-- but we compute the scaling from player's stats
							mod = mod:gsub("^PET_", "")
						end

						addStatModOption(add, mod, sources)
					end
				end
			end
		end
	end

	local function GenerateAuraOptions()
		for modType, modList in pairs(StatLogic.StatModTable) do
			for modName, mods in pairs(modList) do
				if not StatLogic.StatModIgnoresAlwaysBuffed[modName] then
					for _, mod in ipairs(mods) do
						if mod.aura and (not mod.rune or showRunes) then
							local spellInfo = C_Spell.GetSpellInfo(mod.aura)
							if spellInfo then
								local name, icon = spellInfo.name, spellInfo.iconID
								local option = {
									type = 'toggle',
									name = "|T"..icon..":25:25:-2:0|t"..name,
								}
								options.args.alwaysBuffed.args[modType].args[name] = option
								options.args.alwaysBuffed.args[modType].hidden = false

								-- If it's a spell the player knows, use the highest rank for the description
								local spellId = mod.spellid or mod.known or mod.aura
								if IsPlayerSpell(spellId) then
									spellId = C_Spell.GetSpellIDForSpellIdentifier(name) or spellId
								end
								local spell = Spell:CreateFromSpellID(spellId)
								if not spell:IsSpellEmpty() then
									spell:ContinueOnSpellLoad(function()
										option.desc = spell:GetSpellDescription()
									end)
								end
							end
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

local function AddProfileSwapOptions(profileOptions, db)
	local profileSwapOptions = {
		[addonName .. "ProfileSwap"] = {
			name = L["Swap Profiles"],
			type = "group",
			inline = true,
			order = 100,
			hidden = function(info)
				return info[0] ~= addonNameWithVersion
			end,
			args = {
				swapProfileKeybinding = {
					name = L["Swap Profile Keybinding"],
					type = 'keybinding',
					get = getGlobalOption,
					set = setGlobalOption,
					width = "full",
					order = 1,
				},
				description = {
					type = "description",
					order = 2,
					name = L["Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."],
				},
				primaryProfile = {
					name = L["Primary Profile"],
					desc = L["Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."],
					type = "select",
					values = "ListProfiles",
					disabled = function()
						return db.IsDualSpecEnabled and db:IsDualSpecEnabled()
					end,
					get = function(info)
						return db.char[info[#info]]
					end,
					set = function(info, value)
						db.char[info[#info]] = value
					end,
					order = 3,
				},
				secondaryProfile = {
					name = L["Secondary Profile"],
					desc = L["Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."],
					type = "select",
					values = "ListProfiles",
					disabled = function()
						return db.IsDualSpecEnabled and db:IsDualSpecEnabled()
					end,
					get = function(info)
						return db.char[info[#info]]
					end,
					set = function(info, value)
						db.char[info[#info]] = value
					end,
					order = 4,
				},
			},
		},
	}

	for key, option in pairs(profileSwapOptions) do
		profileOptions.args[key] = option
	end
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
function RatingBuster:ClearCache()
	wipe(cache)
end

function RatingBuster:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonNameWithVersion, options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonNameWithVersion, addonName)
end

function RatingBuster:InitializeDatabase()
	local defaultProfile = UnitClass("player")
	RatingBuster.db = LibStub("AceDB-3.0"):New("RatingBusterDB", defaults, defaultProfile)
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileChanged", function()
		if LibStub("AceConfigDialog-3.0").OpenFrames[addonNameWithVersion] then
			LibStub("AceConfigDialog-3.0"):Open(addonNameWithVersion)
		end
		addon.RepaintStaticTooltips()
		if ReforgingFrame then
			ReforgingFrame_Update(ReforgingFrame)
		end
		addon.MigrateOptions(db)
	end)
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileCopied", function()
		RatingBuster:ClearCache()
		addon.MigrateOptions(db)
	end)
	RatingBuster.db.RegisterCallback(RatingBuster, "OnProfileReset", "ClearCache")
	db = RatingBuster.db

	addon.MigrateOptions(db)

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(RatingBuster.db)
	options.args.profiles.order = 5

	local LibDualSpec = LibStub('LibDualSpec-1.0', true)

	if LibDualSpec then
		LibDualSpec:EnhanceDatabase(RatingBuster.db, "RatingBusterDB")
		LibDualSpec:EnhanceOptions(options.args.profiles, RatingBuster.db)
	end

	AddProfileSwapOptions(options.args.profiles, RatingBuster.db)

	local always_buffed = RatingBuster.db:RegisterNamespace("AlwaysBuffed", {
		profile = {
			['*'] = false
		}
	})
	StatLogic:SetupAuraInfo(always_buffed)

	local conversion_data = RatingBuster.db:RegisterNamespace("ConversionData", {
		global = {
			[LE_EXPANSION_LEVEL_CURRENT] = {
				['*'] = {
					['*'] = {}
				},
			}
		}
	})
	RatingBuster.conversion_data = conversion_data
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
	addon:EnableHook(self.ProcessTooltip)
	-- Initialize playerLevel
	playerLevel = UnitLevel("player")
	-- for setting a new level
	self:RegisterEvent("PLAYER_LEVEL_UP")
	-- Events that require cache clearing
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", RatingBuster.ClearCache) -- talent point changed
	self:RegisterBucketEvent("UNIT_AURA", 1) -- fire at most once every 1 second
end

function RatingBuster:OnDisable()
	addon:DisableHook()
end

do
	local spec = GetActiveTalentGroup()

	function RatingBuster:GetDisplayedSpec()
		return spec
	end

	local f = CreateFrame("Button", addonName .. "ProfileSwap")
	f:RegisterForClicks("AnyDown")
	f:SetScript("OnClick", function()
		if db.IsDualSpecEnabled and db:IsDualSpecEnabled() then
			-- Toggle between 1 and 2
			spec = 3 - spec
			db:SetProfile(db:GetDualSpecProfile(spec))
		else
			spec = GetActiveTalentGroup()
			local currentProfile = db:GetCurrentProfile()
			if currentProfile ~= db.char.primaryProfile then
				db:SetProfile(db.char.primaryProfile or currentProfile)
			else
				db:SetProfile(db.char.secondaryProfile or currentProfile)
			end
		end
	end)

	function RatingBuster:EnableKeybindings(tooltip)
		if not InCombatLockdown() then
			SetOverrideBindingClick(f, false, RatingBuster.db.global.swapProfileKeybinding, f:GetName())
		end

		tooltip.RatingBusterOnHideEnabled = true
		if not tooltip.RatingBusterKeybindHooked and not tooltip:GetName():find("ShoppingTooltip") then
			tooltip.RatingBusterKeybindHooked = true
			tooltip:HookScript("OnHide", function()
				if not InCombatLockdown() and tooltip.RatingBusterOnHideEnabled then
					tooltip.RatingBusterOnHideEnabled = false
					ClearOverrideBindings(f)
				end
			end)
		end
	end

	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			ClearOverrideBindings(self)
		elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
			spec = ...
		end
	end)
end

-- event = PLAYER_LEVEL_UP
-- arg1 = New player level
function RatingBuster:PLAYER_LEVEL_UP(_, newlevel)
	playerLevel = newlevel
	RatingBuster:ClearCache()
end

-- event = UNIT_AURA
-- arg1 = List of UnitIDs in the AceBucket interval
function RatingBuster:UNIT_AURA(units)
	if units.player then
		RatingBuster:ClearCache()
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
	[EMPTY_SOCKET_PRISMATIC] = "sumGemPrismatic", -- EMPTY_SOCKET_PRISMATIC = "Prismatic Socket";
}

-- Avoidance Diminishing Returns
---@type { [Stat]: SummaryCalcFunction }
local summaryFunc = {}
local equippedSum = setmetatable({}, {
	__index = function() return 0 end
})
local equippedBlock, equippedDodge, equippedParry, equippedMiss, equippedResilience
local processedBlock, processedDodge, processedParry, processedMiss, processedResilience

local scanningTooltipOwners = {
	["WorldFrame"] = true,
	["UIParent"] = true,
}

---@param tooltip ClassicGameTooltip
function RatingBuster.ProcessTooltip(tooltip)
	-- Do nothing if the tooltip is being used as a hidden scanning tooltip
	if tooltip:GetAnchorType() == "ANCHOR_NONE" and (not tooltip:GetOwner() or scanningTooltipOwners[tooltip:GetOwner():GetName()]) then
		return
	end

	if not tooltip.GetItem then return end
	local _, link = tooltip:GetItem()
	if not link then return end
	local item = Item:CreateFromItemLink(link)
	if item:IsItemEmpty() or not item:IsItemDataCached() then return end

	RatingBuster:EnableKeybindings(tooltip)

	local itemMinLevel, _, _, _, _, _, _, itemClass = select(5, C_Item.GetItemInfo(link))

	local statModContext = StatLogic:NewStatModContext({
		profile = db:GetCurrentProfile(),
		spec = RatingBuster:GetDisplayedSpec(),
		level = math.max(itemMinLevel, playerLevel),
		itemClass = itemClass,
	})

	---------------------
	-- Tooltip Scanner --
	---------------------
	-- Get equipped item avoidances
	if db.profile.enableAvoidanceDiminishingReturns then
		local red = db.profile.sumGemRed.gemID
		local yellow = db.profile.sumGemYellow.gemID
		local blue = db.profile.sumGemBlue.gemID
		local meta = db.profile.sumGemMeta.gemID
		local _, _, difflink1 = StatLogic:GetDiffID(tooltip, db.global.sumIgnoreEnchant, db.global.sumIgnoreGems, db.global.sumIgnoreExtraSockets, red, yellow, blue, meta)
		StatLogic:GetSum(difflink1, equippedSum, statModContext)
		equippedSum[StatLogic.Stats.Strength] = equippedSum[StatLogic.Stats.Strength] * statModContext("MOD_STR")
		equippedSum[StatLogic.Stats.Agility] = equippedSum[StatLogic.Stats.Agility] * statModContext("MOD_AGI")
		equippedBlock = summaryFunc[StatLogic.Stats.BlockChanceBeforeDR](equippedSum, statModContext, "sum", difflink1) * -1
		equippedDodge = summaryFunc[StatLogic.Stats.DodgeBeforeDR](equippedSum, statModContext, "sum", difflink1) * -1
		equippedParry = summaryFunc[StatLogic.Stats.ParryBeforeDR](equippedSum, statModContext, "sum", difflink1) * -1
		equippedMiss = summaryFunc[StatLogic.Stats.MissBeforeDR](equippedSum, statModContext, "sum", difflink1) * -1
		equippedResilience = summaryFunc[StatLogic.Stats.ResilienceBeforeDR](equippedSum, statModContext, "sum", difflink1) * -1
		processedBlock = GetBlockChance() > 0 and equippedBlock or 0
		processedDodge = GetDodgeChance() > 0 and equippedDodge or 0
		processedParry = GetParryChance() > 0 and equippedParry or 0
		processedMiss = equippedMiss
		processedResilience = equippedResilience
	else
		equippedBlock = 0
		equippedDodge = 0
		equippedParry = 0
		equippedMiss = 0
		equippedResilience = 0
		processedBlock = 0
		processedDodge = 0
		processedParry = 0
		processedMiss = 0
		processedResilience = 0
	end
	-- Loop through tooltip lines starting at line 2
	local tipTextLeft = tooltip:GetName().."TextLeft"
	for i = 2, tooltip:NumLines() do
		local fontString = _G[tipTextLeft..i]
		local text = fontString:GetText()
		if text then
			local color = CreateColor(fontString:GetTextColor())
			text = RatingBuster:ProcessLine(text, link, color, statModContext)
			if text then
				fontString:SetText(text)
			end
		end
	end

	-- Item Level and Item ID
	local statR, statG, statB = db.global.sumStatColor:GetRGB()
	local valueR, valueG, valueB = db.global.sumValueColor:GetRGB()
	if db.global.showItemLevel then
		tooltip:AddDoubleLine(L["ItemLevel: "], item:GetCurrentItemLevel(), statR, statG, statB, valueR, valueG, valueB)
	end
	if db.global.showItemID then
		tooltip:AddDoubleLine(L["ItemID: "], item:GetItemID(), statR, statG, statB, valueR, valueG, valueB)
	end

	-- Stat Summary
	if db.global.showSum then
		RatingBuster:StatSummary(tooltip, link, statModContext)
	end

	-- Repaint tooltip
	tooltip:Show()
end

function RatingBuster:ProcessLine(text, link, color, statModContext)
	-- Get data from cache if available
	local cacheKey = statModContext:CacheKey()
	local cacheID = text .. statModContext.level
	local cacheText = cache[cacheKey][cacheID]
	if cacheText then
		if cacheText ~= text then
			return cacheText
		end
	elseif EmptySocketLookup[text] and db.profile[EmptySocketLookup[text]].gemText then -- Replace empty sockets with gem text
		local gemText = db.profile[EmptySocketLookup[text]].gemText
		text = RatingBuster:ProcessLine(gemText, link, color, statModContext)
		cache[cacheKey][cacheID] = text
		return text
	elseif text:find("%d") then -- do nothing if we don't find a number
		-- Temporarily replace exclusions
		local exclusions = false
		for exclusion, replacement in pairs(L["exclusions"]) do
			local count
			text, count = text:gsub(exclusion, replacement)
			if count > 0 then
				exclusions = true
			end
		end
		-- Initial pattern check, do nothing if not found
		-- Check for separators and bulid separatorTable
		local separatorTable = {}
		for _, sep in ipairs(L["separators"]) do
			if text:find(sep) then
				tinsert(separatorTable, sep)
			end
		end
		-- RecursivelySplitLine
		text = RatingBuster:RecursivelySplitLine(text, separatorTable, link, color, statModContext)
		-- Revert exclusions
		if exclusions then
			for exclusion, replacement in pairs(L["exclusions"]) do
				text = text:gsub(replacement, exclusion)
			end
		end
		cache[cacheKey][cacheID] = text
		-- SetText
		return text
	else
		cache[cacheKey][cacheID] = text
		return text
	end
end

---------------------------------------------------------------------------------
-- Recursive algorithm that divides a string into pieces using the separators in separatorTable,
-- processes them separately, then joins them back together
---------------------------------------------------------------------------------
-- text = "+24 Agility/+4 Stamina and +4 Spell Crit/+5 Spirit"
-- separatorTable = {"/", " and ", ","}
-- RatingBuster:RecursivelySplitLine("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ",", "%. ", " for ", "&"})
-- RatingBuster:RecursivelySplitLine("+6法術傷害及5耐力", {"/", "和", ",", "。", " 持續 ", "&", "及",})
function RatingBuster:RecursivelySplitLine(text, separatorTable, link, color, statModContext)
	if type(separatorTable) == "table" and table.maxn(separatorTable) > 0 then
		local sep = tremove(separatorTable, 1)
		text = text:gsub(sep, "@")
		text = strsplittable("@", text)
		local processedText = {}
		local tempTable = {}
		for _, t in ipairs(text) do
			copyTable(tempTable, separatorTable)
			tinsert(processedText, self:RecursivelySplitLine(t, tempTable, link, color, statModContext))
		end
		-- Remove frontier patterns, as they get printed oddly in the repl of a gsub
		sep = sep:gsub("%%f%[.-%]", "")
		-- Join text
		return (table.concat(processedText, "@"):gsub("@", sep))
	else
		return self:ProcessText(text, link, color, statModContext)
	end
end

local escaped_large_number_sep = LARGE_NUMBER_SEPERATOR:gsub("[-.]", "%%%1")

---@param text string
---@param link string
---@param color ColorMixin
---@param statModContext StatModContext
---@return string
function RatingBuster:ProcessText(text, link, color, statModContext)
	-- Convert text to lower so we don't have to worry about same ratings with different cases
	local lowerText = text:lower()
	-- Check if text has a matching pattern
	for _, numPattern in ipairs(L["numberPatterns"]) do
		-- Capture the stat value
		local _, insertionPoint, value = lowerText:find(numPattern)
		if value then
			-- Capture the stat name
			for _, statPattern in ipairs(L["statList"]) do
				local pattern, stat = unpack(statPattern)
				---@cast pattern string
				if lowerText:find(pattern) then
					value = value:gsub(escaped_large_number_sep, "")
					value = tonumber(value)
					if not value then return text end
					local infoTable = StatLogic.StatTable.new()
					RatingBuster:ProcessStat(stat, value, infoTable, link, color, statModContext, true, false)
					local effects = {}
					-- Group effects with identical values
					for statID, effect in pairs(infoTable) do
						if type(statID) == "table" and statID.isPercent or statID == "Spell" then
							if floor(abs(effect) * 100 + 0.5) > 0 then
								effect = ("%+.2f"):format(effect):gsub("(%.%d-)0+$", "%1"):trim(".") .. "%"
								effects[effect] = effects[effect] or {}
								tinsert(effects[effect], S[statID])
							end
						elseif statID == "Percent" then
							if floor(abs(effect) * 100 + 0.5) > 0 then
								effect = ("%+.2f"):format(effect):gsub("(%.%d-)0+$", "%1"):trim(".") .. "%"
								effects[effect] = effects[effect] or {}
							end
						else
							if floor(abs(effect) * 10 + 0.5) > 0 then
								effect = ("%+.1f"):format(effect):gsub("(%.%d-)0+$", "%1"):trim(".")
							elseif floor(abs(effect) + 0.5) > 0 then
								effect = ("%+.0f"):format(effect)
							else
								-- Effect is too small to show
								effect = false
							end

							if effect then
								effects[effect] = effects[effect] or {}
								if statID ~= "Decimal" then
									tinsert(effects[effect], S[statID])
								end
							end
						end
					end
					local info = {}
					for effect, stats in pairs(effects) do
						if #stats > 0 then
							effect = effect .. " " .. table.concat(stats, ", ")
						end
						tinsert(info, tostring(effect))
					end
					table.sort(info, function(a, b)
						return #a < #b
					end)
					local infoString = table.concat(info, ", ")
					if infoString ~= "" then
						-- Change insertion point if necessary
						local _, statInsertionPoint = lowerText:find(pattern)
						if statInsertionPoint > insertionPoint then
							insertionPoint = statInsertionPoint
						end

						-- Backwards Compatibility
						if not db.global.textColor.GenerateHexColorMarkup then
							local old = db.global.textColor
							if type(old) == "table" and old.r and old.g and old.b then
								db.global.textColor = CreateColor(old.r, old.g, old.b)
							else
								db.global.textColor = defaults.global.textColor
							end
						end

						-- Insert info into text. table.concat should be more efficient than many .. concats
						return table.concat({
							text:sub(1, insertionPoint),
							" ",
							db.global.textColor:GenerateHexColorMarkup(),
							"(",
							infoString,
							")",
							"|r",
							text:sub(insertionPoint + 1)
						})
					else
						return text
					end
				end
			end
		end
	end
	return text
end

---@param stat Stat
---@param value number
---@param infoTable table
---@param link string
---@param color any
---@param statModContext StatModContext
---@param isBaseStat boolean
---@param show boolean
function RatingBuster:ProcessStat(stat, value, infoTable, link, color, statModContext, isBaseStat, show)
	if value == 0 then return end
	if StatLogic.GenericStatMap[stat] then
		local statList = StatLogic.GenericStatMap[stat]
		for _, convertedStatID in ipairs(statList) do
			RatingBuster:ProcessStat(convertedStatID, value, infoTable, link, color, statModContext, false, true)
		end
	elseif stat == StatLogic.Stats.HitRating then
		local meleeHitRating = value * statModContext("ADD_MELEE_HIT_RATING_MOD_HIT_RATING")
		self:ProcessStat(StatLogic.Stats.MeleeHitRating, meleeHitRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showMeleeHitFromHitRating)

		local spellHitRating = value * statModContext("ADD_SPELL_HIT_RATING_MOD_HIT_RATING")
		self:ProcessStat(StatLogic.Stats.SpellHitRating, spellHitRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showSpellHitFromHitRating)
	elseif stat == StatLogic.Stats.CritRating then
		value = value * statModContext("MOD_CRIT_RATING")

		local meleeCritRating = value * statModContext("ADD_MELEE_CRIT_RATING_MOD_CRIT_RATING")
		self:ProcessStat(StatLogic.Stats.MeleeCritRating, meleeCritRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showMeleeCritFromCritRating)

		local spellCritRating = value * statModContext("ADD_SPELL_CRIT_RATING_MOD_CRIT_RATING")
		self:ProcessStat(StatLogic.Stats.SpellCritRating, spellCritRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showSpellCritFromCritRating)
	elseif stat == StatLogic.Stats.HasteRating then
		value = value * statModContext("MOD_HASTE_RATING")

		local meleeHasteRating = value * statModContext("ADD_MELEE_HASTE_RATING_MOD_HASTE_RATING")
		self:ProcessStat(StatLogic.Stats.MeleeHasteRating, meleeHasteRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showMeleeHasteFromHasteRating)

		local spellHasteRating = value * statModContext("ADD_SPELL_HASTE_RATING_MOD_HASTE_RATING")
		self:ProcessStat(StatLogic.Stats.SpellHasteRating, spellHasteRating, infoTable, link, color, statModContext, isBaseStat, db.profile.showSpellHasteFromHasteRating)
	elseif StatLogic.RatingBase[stat] and db.profile.showRatings then
		--------------------
		-- Combat Ratings --
		--------------------
		-- Calculate stat value
		local effect = StatLogic:GetEffectFromRating(value, stat, statModContext.level)
		if stat == StatLogic.Stats.DefenseRating then
			self:ProcessStat(StatLogic.Stats.Defense, effect, infoTable, link, color, statModContext, false, db.profile.showDefenseFromDefenseRating)
		elseif stat == StatLogic.Stats.DodgeRating then
			self:ProcessStat(StatLogic.Stats.Dodge, effect, infoTable, link, color, statModContext, isBaseStat, show or isBaseStat)

			local critRating = value * statModContext("ADD_CRIT_RATING_MOD_DODGE_RATING")
			self:ProcessStat(StatLogic.Stats.CritRating, critRating, infoTable, link, color, statModContext, false, db.profile.showCritFromDodgeRating)
		elseif stat == StatLogic.Stats.ParryRating then
			self:ProcessStat(StatLogic.Stats.Parry, effect, infoTable, link, color, statModContext, isBaseStat, show or isBaseStat)

			local critRating = value * statModContext("ADD_CRIT_RATING_MOD_PARRY_RATING")
			self:ProcessStat(StatLogic.Stats.CritRating, critRating, infoTable, link, color, statModContext, false, db.profile.showCritFromParryRating)
		elseif stat == StatLogic.Stats.BlockRating then
			self:ProcessStat(StatLogic.Stats.BlockChance, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.MeleeHitRating then
			self:ProcessStat(StatLogic.Stats.MeleeHit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.RangedHitRating then
			self:ProcessStat(StatLogic.Stats.RangedHit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.SpellHitRating then
			self:ProcessStat(StatLogic.Stats.SpellHit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.MeleeCritRating then
			self:ProcessStat(StatLogic.Stats.MeleeCrit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.RangedCritRating then
			self:ProcessStat(StatLogic.Stats.RangedCrit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.SpellCritRating then
			self:ProcessStat(StatLogic.Stats.SpellCrit, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.MeleeHasteRating then
			self:ProcessStat(StatLogic.Stats.MeleeHaste, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.RangedHasteRating then
			self:ProcessStat(StatLogic.Stats.RangedHaste, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.SpellHasteRating then
			self:ProcessStat(StatLogic.Stats.SpellHaste, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.ExpertiseRating then
			if addon.tocversion < 30000 then
				-- Expertise is truncated in TBC but not in Wrath
				effect = floor(effect)
			end
			self:ProcessStat(StatLogic.Stats.Expertise, effect, infoTable, link, color, statModContext, isBaseStat, db.profile.showExpertiseFromExpertiseRating)
		elseif stat == StatLogic.Stats.ArmorPenetrationRating then
			self:ProcessStat(StatLogic.Stats.ArmorPenetration, effect, infoTable, link, color, statModContext, isBaseStat, show)
		elseif stat == StatLogic.Stats.ResilienceRating then
			self:ProcessStat(StatLogic.Stats.Resilience, effect, infoTable, link, color, statModContext, isBaseStat, db.profile.showResilienceFromResilienceRating)
		elseif stat == StatLogic.Stats.MasteryRating then
			effect = effect * statModContext("MOD_MASTERY_RATING")
			self:ProcessStat(StatLogic.Stats.Mastery, effect, infoTable, link, color, statModContext, isBaseStat, db.profile.showMasteryFromMasteryRating)
		elseif stat == StatLogic.Stats.PvpPowerRating then
			self:ProcessStat(StatLogic.Stats.PvpPower, effect, infoTable, link, color, statModContext, isBaseStat, db.profile.showPvpPowerFromPvpPowerRating)
		end
	elseif stat == StatLogic.Stats.Strength and db.profile.showStats then
		local mod = statModContext("MOD_STR")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedStrength then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local attackPower = value * statModContext("ADD_AP_MOD_STR")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromStr)

		local blockValue = value * statModContext("ADD_BLOCK_VALUE_MOD_STR")
		self:ProcessStat(StatLogic.Stats.BlockValue, blockValue, infoTable, link, color, statModContext, false, db.profile.showBlockValueFromStr)

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_STR")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromStr)

		local healingPower = value * statModContext("ADD_HEALING_MOD_STR")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromStr)

		local parryRating = value * statModContext("ADD_PARRY_RATING_MOD_STR")
		self:ProcessStat(StatLogic.Stats.ParryRating, parryRating, infoTable, link, color, statModContext, false, db.profile.showParryFromStr)

		local parry = value * statModContext("ADD_PARRY_MOD_STR")
		self:ProcessStat(StatLogic.Stats.Parry, parry, infoTable, link, color, statModContext, false, db.profile.showParryFromStr)
	elseif stat == StatLogic.Stats.Agility and db.profile.showStats then
		local mod = statModContext("MOD_AGI")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedAgility then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local attackPower = value * statModContext("ADD_AP_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromAgi)

		local rangedAttackPower = value * statModContext("ADD_RANGED_AP_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.RangedAttackPower, rangedAttackPower, infoTable, link, color, statModContext, false, db.profile.showRAPFromAgi)

		local meleeCrit = value * statModContext("ADD_MELEE_CRIT_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.MeleeCrit, meleeCrit, infoTable, link, color, statModContext, false, db.profile.showMeleeCritFromAgi)

		local dodge = value * statModContext("ADD_DODGE_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.Dodge, dodge, infoTable, link, color, statModContext, false, db.profile.showDodgeFromAgi)

		local bonusArmor = value * statModContext("ADD_BONUS_ARMOR_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.BonusArmor, bonusArmor, infoTable, link, color, statModContext, false, db.profile.showArmorFromAgi)

		local healingPower = value * statModContext("ADD_HEALING_MOD_AGI")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromAgi)
	elseif stat == StatLogic.Stats.Stamina and db.profile.showStats then
		local mod = statModContext("MOD_STA")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedStamina then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local health = value * statModContext("ADD_HEALTH_MOD_STA")
		self:ProcessStat(StatLogic.Stats.Health, health, infoTable, link, color, statModContext, false, db.profile.showHealthFromSta)

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_STA")
			+ statModContext("ADD_SPELL_DMG_MOD_PET_STA") * statModContext("MOD_PET_STA") * statModContext("ADD_PET_STA_MOD_STA")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromSta)

		local attackPower = value * statModContext("ADD_AP_MOD_STA")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromSta)
	elseif stat == StatLogic.Stats.Intellect and db.profile.showStats then
		local mod = statModContext("MOD_INT")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedIntellect then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local mana = value * statModContext("ADD_MANA_MOD_INT")
		self:ProcessStat(StatLogic.Stats.Mana, mana, infoTable, link, color, statModContext, false, db.profile.showManaFromInt)

		local spellCrit = value * statModContext("ADD_SPELL_CRIT_MOD_INT")
		self:ProcessStat(StatLogic.Stats.SpellCrit, spellCrit, infoTable, link, color, statModContext, false, db.profile.showSpellCritFromInt)

		local spellPower = value * statModContext("ADD_SPELL_POWER_MOD_INT")
		self:ProcessStat(StatLogic.Stats.SpellPower, spellPower, infoTable, link, color, statModContext, false, db.profile.showSpellPowerFromInt)

		local spellDamage = value * (
			statModContext("ADD_SPELL_DMG_MOD_INT")
			+ statModContext("ADD_SPELL_DMG_MOD_PET_INT") * statModContext("MOD_PET_INT") * statModContext("ADD_PET_INT_MOD_INT")
		)
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromInt)

		local healingPower = value * statModContext("ADD_HEALING_MOD_INT")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromInt)

		local genericManaRegen = value * statModContext("ADD_GENERIC_MANA_REGEN_MOD_INT")
		-- TODO: Options key using wrong dest stat
		self:ProcessStat(StatLogic.Stats.GenericManaRegen, genericManaRegen, infoTable, link, color, statModContext, false, db.profile.showManaRegenFromInt)

		local normalManaRegen = value * statModContext("ADD_NORMAL_MANA_REGEN_MOD_INT")
		-- TODO: Options key using wrong dest stat
		self:ProcessStat(StatLogic.Stats.NormalManaRegen, normalManaRegen, infoTable, link, color, statModContext, false, db.profile.showManaRegenFromInt)

		local rangedAttackPower = value * statModContext("ADD_RANGED_AP_MOD_INT")
		self:ProcessStat(StatLogic.Stats.RangedAttackPower, rangedAttackPower, infoTable, link, color, statModContext, false, db.profile.showRAPFromInt)

		local bonusArmor = value * statModContext("ADD_BONUS_ARMOR_MOD_INT")
		self:ProcessStat(StatLogic.Stats.BonusArmor, bonusArmor, infoTable, link, color, statModContext, false, db.profile.showArmorFromInt)

		local attackPower = value * statModContext("ADD_AP_MOD_INT")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromInt)

		local agility = value * statModContext("ADD_AGI_MOD_INT")
		self:ProcessStat(StatLogic.Stats.Agility, agility, infoTable, link, color, statModContext, false, db.profile.showAgiFromInt)
	elseif stat == StatLogic.Stats.Spirit and db.profile.showStats then
		local mod = statModContext("MOD_SPI")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedSpirit then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local normalManaRegen = value * statModContext("ADD_NORMAL_MANA_REGEN_MOD_SPI")
		-- TODO: Options key using wrong dest stat
		self:ProcessStat(StatLogic.Stats.NormalManaRegen, normalManaRegen, infoTable, link, color, statModContext, false, db.profile.showManaRegenFromSpi)

		local healthRegenOutOfCombat = value * statModContext("ADD_NORMAL_HEALTH_REG_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.HealthRegenOutOfCombat, healthRegenOutOfCombat, infoTable, link, color, statModContext, false, db.profile.showHP5NCFromSpi)

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromSpi)

		local healingPower = value * statModContext("ADD_HEALING_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromSpi)

		local hitRating = value * statModContext("ADD_HIT_RATING_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.HitRating, hitRating, infoTable, link, color, statModContext, false, db.profile.showHitFromSpi)

		local expertiseRating = value * statModContext("ADD_EXPERTISE_RATING_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.ExpertiseRating, expertiseRating, infoTable, link, color, statModContext, false, db.profile.showExpertiseFromSpi)

		local spellHitRating = value * statModContext("ADD_SPELL_HIT_RATING_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.SpellHitRating, spellHitRating, infoTable, link, color, statModContext, false, db.profile.showSpellHitFromSpi)

		local spellCritRating = value * statModContext("ADD_SPELL_CRIT_RATING_MOD_SPI")
		self:ProcessStat(StatLogic.Stats.SpellCritRating, spellCritRating, infoTable, link, color, statModContext, false, db.profile.showSpellCritFromSpi)
	elseif stat == StatLogic.Stats.Health then
		local mod = statModContext("MOD_HEALTH")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedHealth then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local healthRegenOutOfCombat = value * statModContext("ADD_NORMAL_HEALTH_REG_MOD_HEALTH")
		self:ProcessStat(StatLogic.Stats.HealthRegenOutOfCombat, healthRegenOutOfCombat, infoTable, link, color, statModContext, false, db.profile.showHP5NCFromHealth)

		local healthRegen = value * statModContext("ADD_HEALTH_REG_MOD_HEALTH")
		self:ProcessStat(StatLogic.Stats.HealthRegen, healthRegen, infoTable, link, color, statModContext, false, db.profile.showHP5FromHealth)
	elseif stat == StatLogic.Stats.HealthRegenOutOfCombat then
		local mod = statModContext("MOD_NORMAL_HEALTH_REG")
		value = value * mod
		if show then
			infoTable[stat] = infoTable[stat] + value
		end

		-- TODO: Options key using wrong source stat
		local healthRegen = value * statModContext("ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG")
		self:ProcessStat(StatLogic.Stats.HealthRegen, healthRegen, infoTable, link, color, statModContext, false, db.profile.showHP5FromHealth or db.profile.showHP5FromSpi)
	elseif stat == StatLogic.Stats.HealthRegen then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Mana then
		local mod = statModContext("MOD_MANA")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedMana then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_MANA")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromInt)

		local healingPower = value * statModContext("ADD_HEALING_MOD_MANA")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromInt)

		local genericManaRegen = value * statModContext("ADD_GENERIC_MANA_REGEN_MOD_MANA")
		-- TODO: Options key using wrong dest AND source stats
		self:ProcessStat(StatLogic.Stats.GenericManaRegen, genericManaRegen, infoTable, link, color, statModContext, false, db.profile.showManaRegenFromInt)
	elseif stat == StatLogic.Stats.NormalManaRegen then
		local mod = statModContext("MOD_NORMAL_MANA_REGEN")
		value = value * mod

		local manaRegen = value * math.min(statModContext("ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"), 1)
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegen, manaRegen, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenFromManaRegen)

		local manaRegenNotCasting = value * statModContext("ADD_MANA_REGEN_NOT_CASTING_MOD_NORMAL_MANA_REGEN")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegenNotCasting, manaRegenNotCasting, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenNotCastingFromManaRegen)

		local manaRegenOutOfCombat = value * statModContext("ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_NORMAL_MANA_REGEN")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegenOutOfCombat, manaRegenOutOfCombat, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenOutOfCombatFromManaRegen)
	elseif stat == StatLogic.Stats.GenericManaRegen then
		local manaRegen = value * statModContext("ADD_MANA_REGEN_MOD_GENERIC_MANA_REGEN")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegen, manaRegen, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenFromManaRegen)

		local manaRegenNotCasting = value * statModContext("ADD_MANA_REGEN_NOT_CASTING_MOD_GENERIC_MANA_REGEN")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegenNotCasting, manaRegenNotCasting, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenNotCastingFromManaRegen)

		local manaRegenOutOfCombat = value * statModContext("ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_GENERIC_MANA_REGEN")
		-- TODO: Options key using wrong source stat
		self:ProcessStat(StatLogic.Stats.ManaRegenOutOfCombat, manaRegenOutOfCombat, infoTable, link, color, statModContext, false, show and db.profile.showManaRegenOutOfCombatFromManaRegen)
	elseif stat == StatLogic.Stats.ManaRegen then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.ManaRegenNotCasting then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.ManaRegenOutOfCombat then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Defense then
		if show and isBaseStat then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = value
		end
		local blockChance = value * statModContext("ADD_BLOCK_CHANCE_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.BlockChance, blockChance, infoTable, link, color, statModContext, false, db.profile.showBlockChanceFromDefense)

		local critAvoidance = value * statModContext("ADD_CRIT_AVOIDANCE_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.CritAvoidance, critAvoidance, infoTable, link, color, statModContext, false, db.profile.showCritAvoidanceFromDefense)

		local dodge = value * statModContext("ADD_DODGE_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.Dodge, dodge, infoTable, link, color, statModContext, false, db.profile.showDodgeFromDefense)

		local miss = value * statModContext("ADD_MISS_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.Miss, dodge, infoTable, link, color, statModContext, false, db.profile.showMissFromDefense)

		local parry = value * statModContext("ADD_PARRY_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.Parry, parry, infoTable, link, color, statModContext, false, db.profile.showParryFromDefense)

		local strength = value * statModContext("ADD_STR_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.Strength, strength, infoTable, link, color, statModContext, false, db.profile.showStrFromDefense)

		local attackPower = value * statModContext("ADD_AP_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromDefense)

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_DEFENSE")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromDefense)
	elseif stat == StatLogic.Stats.BlockChance then
		if db.profile.enableAvoidanceDiminishingReturns then
			processedBlock = processedBlock + value
			value = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.BlockChance, processedBlock) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.BlockChance, processedBlock - value)
		end
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.CritAvoidance then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Miss then
		if db.profile.enableAvoidanceDiminishingReturns then
			processedMiss = processedMiss + value
			value = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, processedMiss) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, processedMiss - value)
		end
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.CritDamageReduction then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.PvPDamageReduction then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.PvpPower then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Dodge then
		if db.profile.enableAvoidanceDiminishingReturns then
			processedDodge = processedDodge + value
			value = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, processedDodge) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, processedDodge - value)
		end
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Parry then
		if db.profile.enableAvoidanceDiminishingReturns then
			processedParry = processedParry + value
			value = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry - value)
		end
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.MeleeHit then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.SpellHit then
		if show and isBaseStat then
			local displayType = "Percent"
			if (
				db.profile.showMeleeHitFromHitRating
				and statModContext("ADD_SPELL_HIT_MOD_SPELL_HIT_RATING") ~= statModContext("ADD_MELEE_HIT_MOD_MELEE_HIT_RATING")
			) then
				displayType = "Spell"
			end
			infoTable[displayType] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.MeleeCrit then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.SpellCrit then
		if show and isBaseStat then
			local displayType = "Percent"
			if (
				db.profile.showMeleeCritFromCritRating
				and statModContext("ADD_SPELL_CRIT_MOD_SPELL_CRIT_RATING") ~= statModContext("ADD_MELEE_CRIT_MOD_MELEE_CRIT_RATING")
			) then
				displayType = "Spell"
			end
			infoTable[displayType] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local dodge = value * statModContext("ADD_DODGE_MOD_SPELL_CRIT")
		self:ProcessStat(StatLogic.Stats.Dodge, dodge, infoTable, link, color, statModContext, false, db.profile.showDodgeFromSpellCrit)
	elseif stat == StatLogic.Stats.MeleeHaste then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.SpellHaste then
		if show and isBaseStat then
			local displayType = "Percent"
			if (
				db.profile.showMeleeHasteFromHasteRating
				and statModContext("ADD_SPELL_HASTE_MOD_SPELL_HASTE_RATING") ~= statModContext("ADD_MELEE_HASTE_MOD_MELEE_HASTE_RATING")
			) then
				displayType = "Spell"
			end
			infoTable[displayType] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Expertise then
		if show and isBaseStat then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local dodgeReduction = value * -statModContext("ADD_DODGE_REDUCTION_MOD_EXPERTISE")
		self:ProcessStat(StatLogic.Stats.DodgeReduction, dodgeReduction, infoTable, link, color, statModContext, false, db.profile.showDodgeReductionFromExpertise)

		local parryReduction = value * -statModContext("ADD_PARRY_REDUCTION_MOD_EXPERTISE")
		self:ProcessStat(StatLogic.Stats.ParryReduction, parryReduction, infoTable, link, color, statModContext, false, db.profile.showParryReductionFromExpertise)

		local spellHit = value * statModContext("ADD_SPELL_HIT_MOD_EXPERTISE")
		self:ProcessStat(StatLogic.Stats.SpellHit, spellHit, infoTable, link, color, statModContext, false, db.profile.showSpellHitFromExpertise)
	elseif stat == StatLogic.Stats.ArmorPenetration then
		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Resilience then
		if db.profile.enableAvoidanceDiminishingReturns and addon.tocversion >= 40000 then
			processedResilience = processedResilience + value
			value = StatLogic:GetResilienceEffectGainAfterDR(processedResilience) - StatLogic:GetResilienceEffectAfterDR(processedResilience - value)
		end

		if show and isBaseStat then
			infoTable["Percent"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local critAvoidance = value * statModContext("ADD_CRIT_AVOIDANCE_MOD_RESILIENCE")
		self:ProcessStat(StatLogic.Stats.CritAvoidance, critAvoidance, infoTable, link, color, statModContext, false, db.profile.showCritAvoidanceFromResilience)

		local critDmgReduction = value * statModContext("ADD_CRIT_DAMAGE_REDUCTION_MOD_RESILIENCE")
		self:ProcessStat(StatLogic.Stats.CritDamageReduction, critDmgReduction, infoTable, link, color, statModContext, false, db.profile.showCritDamageReductionFromResilience)

		local pvpDmgReduction = value * statModContext("ADD_PVP_DAMAGE_REDUCTION_MOD_RESILIENCE")
		self:ProcessStat(StatLogic.Stats.PvPDamageReduction, pvpDmgReduction, infoTable, link, color, statModContext, false, db.profile.showPvpDamageReductionFromResilience)
	elseif stat == StatLogic.Stats.DodgeReduction then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.ParryReduction then
		if show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.Mastery then
		if show and isBaseStat then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
		local masteryEffect = value * statModContext("ADD_MASTERY_EFFECT_MOD_MASTERY")
		self:ProcessStat(StatLogic.Stats.MasteryEffect, masteryEffect, infoTable, link, color, statModContext, false, db.profile.showMasteryEffectFromMastery)
	elseif stat == StatLogic.Stats.MasteryEffect then
		if show then
			-- Always use Percent for now. Ideally we'd set up localizations to map MasteryEffect to invididual Mastery names
			infoTable["Percent"] = infoTable[stat] + value
		end
		local blockChance = value * statModContext("ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT")
		self:ProcessStat(StatLogic.Stats.BlockChance, blockChance, infoTable, link, color, statModContext, false, db.profile.showBlockChanceFromMasteryEffect)
	elseif stat == StatLogic.Stats.Armor then
		local base, bonus = StatLogic:GetArmorDistribution(link, value, color)
		local mod = statModContext("MOD_ARMOR")
		value = base * mod + bonus
		self:ProcessStat(StatLogic.Stats.BonusArmor, value, infoTable, link, color, statModContext, mod ~= 1 and db.profile.showModifiedArmor, false)
	elseif stat == StatLogic.Stats.BonusArmor then
		if isBaseStat then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		-- TODO: Options key using wrong source stat
		local attackPower = value * statModContext("ADD_AP_MOD_ARMOR")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromArmor)
	elseif stat == StatLogic.Stats.GenericAttackPower then
		local attackPower = value * statModContext("ADD_AP_MOD_GENERIC_ATTACK_POWER")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, true, false)

		local rangedAttackPower = value * statModContext("ADD_RANGED_AP_MOD_GENERIC_ATTACK_POWER")
		self:ProcessStat(StatLogic.Stats.RangedAttackPower, rangedAttackPower, infoTable, link, color, statModContext, true, false)
	elseif stat == StatLogic.Stats.AttackPower then
		local mod = statModContext("MOD_AP")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedAttackPower then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local spellPower = value * statModContext("ADD_SPELL_POWER_MOD_AP")
		self:ProcessStat(StatLogic.Stats.SpellPower, spellPower, infoTable, link, color, statModContext, false, db.profile.showSpellPowerFromAP)

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_AP")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromAP)

		local healingPower = value * statModContext("ADD_HEALING_MOD_AP")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromAP)
	elseif stat == StatLogic.Stats.RangedAttackPower then
		local mod = statModContext("MOD_RANGED_AP")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedRangedAttackPower then
			infoTable[stat] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.SpellPower then
		local mod = statModContext("MOD_SPELL_POWER")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedSpellPower then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local spellDamage = value * statModContext("ADD_SPELL_DMG_MOD_SPELL_POWER")
		self:ProcessStat(StatLogic.Stats.SpellDamage, spellDamage, infoTable, link, color, statModContext, false, db.profile.showSpellDmgFromSpellPower)

		local healingPower = value * statModContext("ADD_HEALING_MOD_SPELL_POWER")
		self:ProcessStat(StatLogic.Stats.HealingPower, healingPower, infoTable, link, color, statModContext, false, db.profile.showHealingFromSpellPower)

		local attackPower = value * statModContext("ADD_AP_MOD_SPELL_POWER")
		self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable, link, color, statModContext, false, db.profile.showAPFromSpellPower)
	elseif stat == StatLogic.Stats.SpellDamage then
		local mod = statModContext("MOD_SPELL_DMG")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedSpellDamage then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end

		local blockValue = value * statModContext("ADD_BLOCK_VALUE_MOD_SPELL_DMG")
		self:ProcessStat(StatLogic.Stats.BlockValue, blockValue, infoTable, link, color, statModContext, false, db.profile.showBlockValueFromSpellDmg)
	elseif stat == StatLogic.Stats.HealingPower then
		local mod = statModContext("MOD_HEALING")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedHealing then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	elseif stat == StatLogic.Stats.BlockValue then
		local mod = statModContext("MOD_BLOCK_VALUE")
		value = value * mod
		if isBaseStat and mod ~= 1 and db.profile.showModifiedBlockValue then
			infoTable["Decimal"] = value
		elseif show then
			infoTable[stat] = infoTable[stat] + value
		end
	end
end

------------------
-- Reforging UI --
------------------
EventUtil.ContinueOnAddOnLoaded("Blizzard_ReforgingUI", function()
	local function hookReforgingFontString(fontString)
		local og_SetText = fontString.SetText
		fontString.SetText = function(self, text, ...)
			local statModContext = StatLogic:NewStatModContext({
				profile = db:GetCurrentProfile(),
				spec = RatingBuster:GetDisplayedSpec()
			})
			og_SetText(self, RatingBuster:ProcessText(text, "", {}, statModContext), ...)
		end
	end

	local hooked = {}
	hooksecurefunc("ReforgingFrame_GetStatRow", function(index, tryAdd)
		if hooked[index] or not tryAdd then return end
		hooked[index] = true

		local leftStat = _G["ReforgingFrameLeftStat"..index];
		local rightStat = _G["ReforgingFrameRightStat"..index];
		hookReforgingFontString(leftStat.text)
		hookReforgingFontString(rightStat.text)
	end)
end)

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
	if not tooltip or not db.global.hideBlizzardComparisons then return end

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
		[Enum.ItemArmorSubclass.Plate] = true,
	},
	PALADIN = {
		[Enum.ItemArmorSubclass.Plate] = true,
	},
	HUNTER = {
		[Enum.ItemArmorSubclass.Mail] = true,
	},
	ROGUE = {
		[Enum.ItemArmorSubclass.Leather] = true,
	},
	PRIEST = {
		[Enum.ItemArmorSubclass.Cloth] = true,
	},
	DEATHKNIGHT = {
		[Enum.ItemArmorSubclass.Plate] = true,
	},
	SHAMAN = {
		[Enum.ItemArmorSubclass.Mail] = true,
	},
	MAGE = {
		[Enum.ItemArmorSubclass.Cloth] = true,
	},
	MONK = {
		[Enum.ItemArmorSubclass.Leather] = true,
	},
	WARLOCK = {
		[Enum.ItemArmorSubclass.Cloth] = true,
	},
	DRUID = {
		[Enum.ItemArmorSubclass.Leather] = true,
	},
}

if addon.tocversion < 40000 then
	classArmorTypes["WARRIOR"][Enum.ItemArmorSubclass.Mail] = true
	classArmorTypes["WARRIOR"][Enum.ItemArmorSubclass.Leather] = true

	classArmorTypes["PALADIN"][Enum.ItemArmorSubclass.Mail] = true
	classArmorTypes["PALADIN"][Enum.ItemArmorSubclass.Leather] = true
	classArmorTypes["PALADIN"][Enum.ItemArmorSubclass.Cloth] = true

	classArmorTypes["HUNTER"][Enum.ItemArmorSubclass.Leather] = true

	classArmorTypes["DEATHKNIGHT"][Enum.ItemArmorSubclass.Mail] = true
	classArmorTypes["DEATHKNIGHT"][Enum.ItemArmorSubclass.Leather] = true

	classArmorTypes["SHAMAN"][Enum.ItemArmorSubclass.Leather] = true
	classArmorTypes["SHAMAN"][Enum.ItemArmorSubclass.Cloth] = true

	classArmorTypes["DRUID"][Enum.ItemArmorSubclass.Cloth] = true
end

local armorTypes = {
	[Enum.ItemArmorSubclass["Plate"]] = true,
	[Enum.ItemArmorSubclass["Mail"]] = true,
	[Enum.ItemArmorSubclass["Leather"]] = true,
	[Enum.ItemArmorSubclass["Cloth"]] = true,
}

---@alias SummaryCalcFunction fun(sum: StatTable, statModContext: StatModContext, sumType?, link?): number

---@class SummaryCalcData
---@field option string?
---@field stat Stat
---@field func SummaryCalcFunction

---@type SummaryCalcData[]
local summaryCalcData = {
	-----------
	-- Basic --
	-----------
	-- Strength - STR
	{
		option = "sumStr",
		stat = StatLogic.Stats.Strength,
		func = function(sum, statModContext)
			return statModContext("MOD_STR") * (
				sum[StatLogic.Stats.Strength]
				+ summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_STR_MOD_DEFENSE")
			)
		end,
	},
	-- Agility - AGI
	{
		option = "sumAgi",
		stat = StatLogic.Stats.Agility,
		func = function(sum, statModContext)
			return statModContext("MOD_AGI") * (
				sum[StatLogic.Stats.Agility]
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_AGI_MOD_INT")
			)
		end,
	},
	-- Stamina - STA
	{
		option = "sumSta",
		stat = StatLogic.Stats.Stamina,
		func = function(sum, statModContext)
			return statModContext("MOD_STA") * sum[StatLogic.Stats.Stamina]
		end,
	},
	-- Intellect - INT
	{
		option = "sumInt",
		stat = StatLogic.Stats.Intellect,
		func = function(sum, statModContext)
			return statModContext("MOD_INT") * sum[StatLogic.Stats.Intellect]
		end,
	},
	-- Spirit - SPI
	{
		option = "sumSpi",
		stat = StatLogic.Stats.Spirit,
		func = function(sum, statModContext)
			return statModContext("MOD_SPI") * sum[StatLogic.Stats.Spirit]
		end,
	},
	{
		stat = StatLogic.Stats.MasteryRating,
		func = function(sum, statModContext)
			return statModContext("MOD_MASTERY_RATING") * sum[StatLogic.Stats.MasteryRating]
		end,
	},
	{
		option = "sumMastery",
		stat = StatLogic.Stats.Mastery,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.MasteryRating](sum, statModContext) * statModContext("ADD_MASTERY_MOD_MASTERY_RATING")
		end,
	},
	{
		option = "sumMasteryEffect",
		stat = StatLogic.Stats.MasteryEffect,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.Mastery](sum, statModContext) * statModContext("ADD_MASTERY_EFFECT_MOD_MASTERY")
		end,
	},
	-- Health - HEALTH, STA
	{
		option = "sumHP",
		stat = StatLogic.Stats.Health,
		func = function(sum, statModContext)
			return (sum[StatLogic.Stats.Health] + (summaryFunc[StatLogic.Stats.Stamina](sum, statModContext) * statModContext("ADD_HEALTH_MOD_STA"))) * statModContext("MOD_HEALTH")
		end,
	},
	-- Mana - MANA, INT
	{
		option = "sumMP",
		stat = StatLogic.Stats.Mana,
		func = function(sum, statModContext)
			return (sum[StatLogic.Stats.Mana] + (summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_MANA_MOD_INT"))) * statModContext("MOD_MANA")
		end,
	},
	-- Health Regen - HEALTH_REG
	{
		option = "sumHP5",
		stat = StatLogic.Stats.HealthRegen,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.HealthRegen]
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_NORMAL_HEALTH_REG_MOD_SPI") * statModContext("MOD_NORMAL_HEALTH_REG") * statModContext("ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG")
				+ summaryFunc[StatLogic.Stats.Health](sum, statModContext) * (
					statModContext("ADD_HEALTH_REG_MOD_HEALTH")
					+ statModContext("ADD_NORMAL_HEALTH_REG_MOD_HEALTH") * statModContext("MOD_NORMAL_HEALTH_REG") * statModContext("ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG")
				)
		end,
	},
	-- Health Regen while Out of Combat - HEALTH_REG, SPI
	{
		option = "sumHP5OC",
		stat = StatLogic.Stats.HealthRegenOutOfCombat,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.HealthRegen]
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_NORMAL_HEALTH_REG_MOD_SPI") * statModContext("MOD_NORMAL_HEALTH_REG")
				+ summaryFunc[StatLogic.Stats.Health](sum, statModContext) * statModContext("ADD_NORMAL_HEALTH_REG_MOD_HEALTH") * statModContext("MOD_NORMAL_HEALTH_REG")
		end,
	},
	{
		option = "sumGenericManaRegen",
		stat = StatLogic.Stats.GenericManaRegen,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.GenericManaRegen]
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_GENERIC_MANA_REGEN_MOD_INT")
				+ summaryFunc[StatLogic.Stats.Mana](sum, statModContext) * statModContext("ADD_GENERIC_MANA_REGEN_MOD_MANA")
		end,
	},
	{
		option = "sumNormalManaRegen",
		stat = StatLogic.Stats.NormalManaRegen,
		func = function(sum, statModContext)
			return statModContext("MOD_NORMAL_MANA_REGEN") * (
				summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_NORMAL_MANA_REGEN_MOD_INT")
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_NORMAL_MANA_REGEN_MOD_SPI")
			)
		end,
	},
	{
		option = "sumManaRegen",
		stat = StatLogic.Stats.ManaRegen,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.GenericManaRegen](sum, statModContext) * statModContext("ADD_MANA_REGEN_MOD_GENERIC_MANA_REGEN")
				+ summaryFunc[StatLogic.Stats.NormalManaRegen](sum, statModContext) * math.min(statModContext("ADD_MANA_REGEN_MOD_NORMAL_MANA_REGEN"), 1)
		end,
	},
	{
		option = "sumManaRegenNotCasting",
		stat = StatLogic.Stats.ManaRegenNotCasting,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.GenericManaRegen](sum, statModContext) * statModContext("ADD_MANA_REGEN_NOT_CASTING_MOD_GENERIC_MANA_REGEN")
				+ summaryFunc[StatLogic.Stats.NormalManaRegen](sum, statModContext) * statModContext("ADD_MANA_REGEN_NOT_CASTING_MOD_NORMAL_MANA_REGEN")
		end,
	},
	{
		option = "sumManaRegenOutOfCombat",
		stat = StatLogic.Stats.ManaRegenOutOfCombat,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.GenericManaRegen](sum, statModContext) * statModContext("ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_GENERIC_MANA_REGEN")
				+ summaryFunc[StatLogic.Stats.NormalManaRegen](sum, statModContext) * statModContext("ADD_MANA_REGEN_OUT_OF_COMBAT_MOD_NORMAL_MANA_REGEN")
		end,
	},
	---------------------
	-- Physical Damage --
	---------------------
	{
		option = "sumAP",
		stat = StatLogic.Stats.AttackPower,
		func = function(sum, statModContext)
			local apPerSP = statModContext("ADD_AP_MOD_SPELL_POWER")
			return statModContext("MOD_AP") * (
				sum[StatLogic.Stats.AttackPower]
				+ sum[StatLogic.Stats.GenericAttackPower] * statModContext("ADD_AP_MOD_GENERIC_ATTACK_POWER")
				+ sum[StatLogic.Stats.FeralAttackPower] * statModContext("ADD_AP_MOD_FERAL_ATTACK_POWER")
				+ summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_AP_MOD_STR")
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_AP_MOD_AGI")
				+ summaryFunc[StatLogic.Stats.Stamina](sum, statModContext) * statModContext("ADD_AP_MOD_STA")
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_AP_MOD_INT")
				+ summaryFunc[StatLogic.Stats.Armor](sum, statModContext) * statModContext("ADD_AP_MOD_ARMOR")
				+ sum[StatLogic.Stats.Defense] * statModContext("ADD_AP_MOD_DEFENSE")
				+ (apPerSP == 0 and 0 or apPerSP * summaryFunc[StatLogic.Stats.SpellPower](sum, statModContext))
			)
		end,
	},
	-- Ranged Attack Power - RANGED_AP, AP, AGI, INT
	{
		option = "sumRAP",
		stat = StatLogic.Stats.RangedAttackPower,
		func = function(sum, statModContext)
			return statModContext("MOD_RANGED_AP") * (
				sum[StatLogic.Stats.RangedAttackPower]
				+ sum[StatLogic.Stats.GenericAttackPower] * statModContext("ADD_RANGED_AP_MOD_GENERIC_ATTACK_POWER")
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_RANGED_AP_MOD_AGI")
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_RANGED_AP_MOD_INT")
				+ summaryFunc[StatLogic.Stats.Stamina](sum, statModContext) * statModContext("ADD_AP_MOD_STA")
				+ summaryFunc[StatLogic.Stats.Armor](sum, statModContext) * statModContext("ADD_AP_MOD_ARMOR")
			)
		end,
	},
	{
		stat = StatLogic.Stats.HitRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.HitRating]
				+ sum[StatLogic.Stats.Spirit] * statModContext("ADD_HIT_RATING_MOD_SPI")
		end,
	},
	-- Hit Chance - MELEE_HIT_RATING, WEAPON_SKILL
	{
		option = "sumHit",
		stat = StatLogic.Stats.MeleeHit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeHit]
				+ summaryFunc[StatLogic.Stats.MeleeHitRating](sum, statModContext) * statModContext("ADD_MELEE_HIT_MOD_MELEE_HIT_RATING")
		end,
	},
	-- Hit Rating - MELEE_HIT_RATING
	{
		option = "sumHitRating",
		stat = StatLogic.Stats.MeleeHitRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeHitRating]
				+ summaryFunc[StatLogic.Stats.HitRating](sum, statModContext) * statModContext("ADD_MELEE_HIT_RATING_MOD_HIT_RATING")
		end,
	},
	-- Ranged Hit Chance - MELEE_HIT_RATING, RANGED_HIT_RATING, AGI
	{
		option = "sumRangedHit",
		stat = StatLogic.Stats.RangedHit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedHit]
				+ summaryFunc[StatLogic.Stats.RangedHitRating](sum, statModContext) * statModContext("ADD_RANGED_HIT_MOD_RANGED_HIT_RATING")
		end,
	},
	-- Ranged Hit Rating - RANGED_HIT_RATING
	{
		option = "sumRangedHitRating",
		stat = StatLogic.Stats.RangedHitRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedHitRating]
				+ summaryFunc[StatLogic.Stats.HitRating](sum, statModContext) * statModContext("ADD_RANGED_HIT_RATING_MOD_HIT_RATING")
		end,
	},
	{
		stat = StatLogic.Stats.CritRating,
		func = function (sum, statModContext)
			return statModContext("MOD_CRIT_RATING") * (
				sum[StatLogic.Stats.CritRating]
				+ summaryFunc[StatLogic.Stats.DodgeRating](sum, statModContext) * statModContext("ADD_CRIT_RATING_MOD_DODGE_RATING")
				+ summaryFunc[StatLogic.Stats.ParryRating](sum, statModContext) * statModContext("ADD_CRIT_RATING_MOD_PARRY_RATING")
			)
		end,
	},
	-- Crit Chance - MELEE_CRIT, MELEE_CRIT_RATING, AGI
	{
		option = "sumCrit",
		stat = StatLogic.Stats.MeleeCrit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeCrit]
				+ sum[StatLogic.Stats.MeleeCritRating] * statModContext("ADD_MELEE_CRIT_MOD_MELEE_CRIT_RATING")
				+ summaryFunc[StatLogic.Stats.MeleeCritRating](sum, statModContext) * statModContext("ADD_MELEE_CRIT_MOD_MELEE_CRIT_RATING")
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_MELEE_CRIT_MOD_AGI")
		end,
	},
	-- Crit Rating - MELEE_CRIT_RATING
	{
		option = "sumCritRating",
		stat = StatLogic.Stats.MeleeCritRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeCritRating]
				+ summaryFunc[StatLogic.Stats.CritRating](sum, statModContext) * statModContext("ADD_MELEE_CRIT_RATING_MOD_CRIT_RATING")
		end,
	},
	-- Ranged Crit Chance - MELEE_CRIT_RATING, RANGED_CRIT_RATING, AGI
	{
		option = "sumRangedCrit",
		stat = StatLogic.Stats.RangedCrit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedCrit]
				+ summaryFunc[StatLogic.Stats.RangedCritRating](sum, statModContext) * statModContext("ADD_RANGED_CRIT_MOD_RANGED_CRIT_RATING")
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_RANGED_CRIT_MOD_AGI")
		end,
	},
	-- Ranged Crit Rating - RANGED_CRIT_RATING
	{
		option = "sumRangedCritRating",
		stat = StatLogic.Stats.RangedCritRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedCritRating]
				+ summaryFunc[StatLogic.Stats.CritRating](sum, statModContext) * statModContext("ADD_RANGED_CRIT_RATING_MOD_CRIT_RATING")
		end,
	},
	{
		stat = StatLogic.Stats.HasteRating,
		func = function (sum, statModContext)
			return statModContext("MOD_HASTE_RATING") * sum[StatLogic.Stats.HasteRating]
		end,
	},
	-- Haste - MELEE_HASTE_RATING
	{
		option = "sumHaste",
		stat = StatLogic.Stats.MeleeHaste,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeHaste]
				+ summaryFunc[StatLogic.Stats.MeleeHasteRating](sum, statModContext) * statModContext("ADD_MELEE_HASTE_MOD_MELEE_HASTE_RATING")
		end,
	},
	-- Haste Rating - MELEE_HASTE_RATING
	{
		option = "sumHasteRating",
		stat = StatLogic.Stats.MeleeHasteRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MeleeHasteRating]
				+ summaryFunc[StatLogic.Stats.HasteRating](sum, statModContext) * statModContext("ADD_MELEE_HASTE_RATING_MOD_HASTE_RATING")
		end,
	},
	-- Ranged Haste - RANGED_HASTE_RATING
	{
		option = "sumRangedHaste",
		stat = StatLogic.Stats.RangedHaste,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedHaste]
				+ summaryFunc[StatLogic.Stats.RangedHasteRating](sum, statModContext) * statModContext("ADD_RANGED_HASTE_MOD_RANGED_HASTE_RATING")
		end,
	},
	-- Ranged Haste Rating - RANGED_HASTE_RATING
	{
		option = "sumRangedHasteRating",
		stat = StatLogic.Stats.RangedHasteRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.RangedHasteRating]
				+ summaryFunc[StatLogic.Stats.HasteRating](sum, statModContext) * statModContext("ADD_RANGED_HASTE_RATING_MOD_HASTE_RATING")
		end,
	},
	{
		option = "sumWeaponSkill",
		stat = StatLogic.Stats.WeaponSkill,
		func = function(sum)
			return sum[StatLogic.Stats.WeaponSkill]
		end,
	},
	-- Expertise - EXPERTISE_RATING
	{
		option = "sumExpertise",
		stat = StatLogic.Stats.Expertise,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.Expertise]
				+ summaryFunc[StatLogic.Stats.ExpertiseRating](sum, statModContext) * statModContext("ADD_EXPERTISE_MOD_EXPERTISE_RATING")
		end,
	},
	-- Expertise Rating - EXPERTISE_RATING
	{
		option = "sumExpertiseRating",
		stat = StatLogic.Stats.ExpertiseRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.ExpertiseRating]
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_EXPERTISE_RATING_MOD_SPI")
		end,
	},
	-- Dodge Reduction - EXPERTISE_RATING, WEAPON_SKILL
	{
		option = "sumDodgeNeglect",
		stat = StatLogic.Stats.DodgeReduction,
		func = function(sum, statModContext)
			local effect = summaryFunc[StatLogic.Stats.Expertise](sum, statModContext)
			if addon.tocversion < 30000 then
				effect = floor(effect)
			end
			return sum[StatLogic.Stats.DodgeReduction]
				+ effect * statModContext("ADD_DODGE_REDUCTION_MOD_EXPERTISE")
				+ sum[StatLogic.Stats.WeaponSkill] * 0.1
		end,
	},
	-- Parry Reduction - EXPERTISE_RATING
	{
		option = "sumParryNeglect",
		stat = StatLogic.Stats.ParryReduction,
		func = function(sum, statModContext)
			local effect = summaryFunc[StatLogic.Stats.Expertise](sum, statModContext)
			if addon.tocversion < 30000 then
				effect = floor(effect)
			end
			return sum[StatLogic.Stats.ParryReduction]
				+ effect * statModContext("ADD_PARRY_REDUCTION_MOD_EXPERTISE")
		end,
	},
	-- Weapon Average Damage - StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage
	{
		option = "sumWeaponAverageDamage",
		stat = StatLogic.Stats.AverageWeaponDamage,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.MinWeaponDamage] * statModContext("ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MIN")
				+ sum[StatLogic.Stats.MaxWeaponDamage] * statModContext("ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MAX")
		end,
	},
	-- Weapon DPS - DPS
	{
		option = "sumWeaponDPS",
		stat = StatLogic.Stats.WeaponDPS,
		func = function(sum)
			return sum[StatLogic.Stats.WeaponDPS]
		end,
	},
	-- Ignore Armor - IGNORE_ARMOR
	{
		option = "sumIgnoreArmor",
		stat = StatLogic.Stats.IgnoreArmor,
		func = function(sum)
			return sum[StatLogic.Stats.IgnoreArmor]
		end,
	},
	-- Armor Penetration - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetration",
		stat = StatLogic.Stats.ArmorPenetration,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.ArmorPenetrationRating] * statModContext("ADD_ARMOR_PENETRATION_MOD_ARMOR_PENETRATION_RATING")
		end,
	},
	-- Armor Penetration Rating - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetrationRating",
		stat = StatLogic.Stats.ArmorPenetrationRating,
		func = function(sum) return
			sum[StatLogic.Stats.ArmorPenetrationRating]
		end,
	},
	------------------------------
	-- Spell Damage and Healing --
	------------------------------
	-- Spell Damage - SPELL_DMG, STA, INT, SPI
	{
		option = "sumSpellPower",
		stat = StatLogic.Stats.SpellPower,
		func = function(sum, statModContext)
			local spPerAP = statModContext("ADD_SPELL_POWER_MOD_AP")
			return statModContext("MOD_SPELL_POWER") * (
				sum[StatLogic.Stats.SpellPower]
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_SPELL_POWER_MOD_INT")
				+ (spPerAP == 0 and 0 or spPerAP * summaryFunc[StatLogic.Stats.AttackPower](sum, statModContext))
			)
		end,
	},
	{
		option = "sumSpellDmg",
		stat = StatLogic.Stats.SpellDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * (
				sum[StatLogic.Stats.SpellDamage]
				+ summaryFunc[StatLogic.Stats.SpellPower](sum, statModContext) * statModContext("ADD_SPELL_DMG_MOD_SPELL_POWER")
				+ summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_SPELL_DMG_MOD_STR")
				+ summaryFunc[StatLogic.Stats.Stamina](sum, statModContext) * (statModContext("ADD_SPELL_DMG_MOD_STA") + statModContext("ADD_SPELL_DMG_MOD_PET_STA") * statModContext("MOD_PET_STA") * statModContext("ADD_PET_STA_MOD_STA"))
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * (
					(statModContext("ADD_SPELL_DMG_MOD_INT") + statModContext("ADD_SPELL_DMG_MOD_PET_INT") * statModContext("MOD_PET_INT") * statModContext("ADD_PET_INT_MOD_INT"))
					+ statModContext("ADD_SPELL_DMG_MOD_MANA") * statModContext("MOD_MANA") * statModContext("ADD_MANA_MOD_INT")
				) + summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_SPELL_DMG_MOD_SPI")
				+ summaryFunc[StatLogic.Stats.AttackPower](sum, statModContext) * statModContext("ADD_SPELL_DMG_MOD_AP")
				+ sum[StatLogic.Stats.Defense] * statModContext("ADD_SPELL_DMG_MOD_DEFENSE")
			)
		end,
	},
	-- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	{
		option = "sumHolyDmg",
		stat = StatLogic.Stats.HolyDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * sum[StatLogic.Stats.HolyDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumArcaneDmg",
		stat = StatLogic.Stats.ArcaneDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * sum[StatLogic.Stats.ArcaneDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	{
		option = "sumFireDmg",
		stat = StatLogic.Stats.FireDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * sum[StatLogic.Stats.FireDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumNatureDmg",
		stat = StatLogic.Stats.NatureDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * (
				sum[StatLogic.Stats.NatureDamage]
				+ sum[StatLogic.Stats.Agility] * statModContext("ADD_NATURE_DAMAGE_MOD_AGI")
			) + summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumFrostDmg",
		stat = StatLogic.Stats.FrostDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * sum[StatLogic.Stats.FrostDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	{
		option = "sumShadowDmg",
		stat = StatLogic.Stats.ShadowDamage,
		func = function(sum, statModContext)
			return statModContext("MOD_SPELL_DMG") * sum[StatLogic.Stats.ShadowDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext)
		 end,
	},
	-- Healing - HEAL, AGI, STR, INT, SPI, AP
	{
		option = "sumHealing",
		stat = StatLogic.Stats.HealingPower,
		func = function(sum, statModContext)
			return statModContext("MOD_HEALING") * (
				sum[StatLogic.Stats.HealingPower]
				+ summaryFunc[StatLogic.Stats.SpellPower](sum, statModContext) * statModContext("ADD_HEALING_MOD_SPELL_POWER")
				+ (summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_HEALING_MOD_STR"))
				+ (summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_HEALING_MOD_AGI"))
				+ (summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * (
					statModContext("ADD_HEALING_MOD_INT"))
					+ statModContext("ADD_HEALING_MOD_MANA") * statModContext("MOD_MANA") * statModContext("ADD_MANA_MOD_INT")
				) + (summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_HEALING_MOD_SPI"))
				+ (summaryFunc[StatLogic.Stats.AttackPower](sum, statModContext) * statModContext("ADD_HEALING_MOD_AP"))
			)
		end,
	},
	-- Spell Hit Chance - SPELL_HIT_RATING
	{
		option = "sumSpellHit",
		stat = StatLogic.Stats.SpellHit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellHit]
				+ summaryFunc[StatLogic.Stats.SpellHitRating](sum, statModContext) * statModContext("ADD_SPELL_HIT_MOD_SPELL_HIT_RATING")
				+ summaryFunc[StatLogic.Stats.Expertise](sum, statModContext) * statModContext("ADD_SPELL_HIT_MOD_EXPERTISE")
		end,
	},
	-- Spell Hit Rating - SPELL_HIT_RATING
	{
		option = "sumSpellHitRating",
		stat = StatLogic.Stats.SpellHitRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellHitRating]
				+ summaryFunc[StatLogic.Stats.HitRating](sum, statModContext) * statModContext("ADD_SPELL_HIT_RATING_MOD_HIT_RATING")
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_SPELL_HIT_RATING_MOD_SPI")
		end,
	},
	-- Spell Crit Chance - SPELL_CRIT_RATING, INT
	{
		option = "sumSpellCrit",
		stat = StatLogic.Stats.SpellCrit,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellCrit]
				+ summaryFunc[StatLogic.Stats.SpellCritRating](sum, statModContext) * statModContext("ADD_SPELL_CRIT_MOD_SPELL_CRIT_RATING")
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_SPELL_CRIT_MOD_INT")
		end,
	},
	-- Spell Crit Rating - SPELL_CRIT_RATING
	{
		option = "sumSpellCritRating",
		stat = StatLogic.Stats.SpellCritRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellCritRating]
				+ summaryFunc[StatLogic.Stats.CritRating](sum, statModContext) * statModContext("ADD_SPELL_CRIT_RATING_MOD_CRIT_RATING")
				+ summaryFunc[StatLogic.Stats.Spirit](sum, statModContext) * statModContext("ADD_SPELL_CRIT_RATING_MOD_SPI")
		end,
	},
	-- Spell Haste - SPELL_HASTE_RATING
	{
		option = "sumSpellHaste",
		stat = StatLogic.Stats.SpellHaste,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellHaste]
				+ summaryFunc[StatLogic.Stats.SpellHasteRating](sum, statModContext) * statModContext("ADD_SPELL_HASTE_MOD_SPELL_HASTE_RATING")
		end,
	},
	-- Spell Haste Rating - SPELL_HASTE_RATING
	{
		option = "sumSpellHasteRating",
		stat = StatLogic.Stats.SpellHasteRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.SpellHasteRating]
				+ summaryFunc[StatLogic.Stats.HasteRating](sum, statModContext) * statModContext("ADD_SPELL_HASTE_RATING_MOD_HASTE_RATING")
		end,
	},
	-- Spell Penetration - SPELLPEN
	{
		option = "sumPenetration",
		stat = StatLogic.Stats.SpellPenetration,
		func = function(sum)
			return sum[StatLogic.Stats.SpellPenetration]
		end,
	},
	----------
	-- Tank --
	----------
	-- Armor - ARMOR, ARMOR_BONUS, AGI, INT
	{
		option = "sumArmor",
		stat = StatLogic.Stats.Armor,
		func = function(sum, statModContext)
			return statModContext("MOD_ARMOR") * sum[StatLogic.Stats.Armor]
				+ sum[StatLogic.Stats.BonusArmor]
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_BONUS_ARMOR_MOD_AGI")
				+ summaryFunc[StatLogic.Stats.Intellect](sum, statModContext) * statModContext("ADD_BONUS_ARMOR_MOD_INT")
		 end,
	},
	-- Dodge Chance Before DR - DODGE, DODGE_RATING, DEFENSE, AGI
	{
		option = "sumDodgeBeforeDR",
		stat = StatLogic.Stats.DodgeBeforeDR,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.DodgeRating] * statModContext("ADD_DODGE_MOD_DODGE_RATING")
				+ summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_DODGE_MOD_DEFENSE")
				+ summaryFunc[StatLogic.Stats.Agility](sum, statModContext) * statModContext("ADD_DODGE_MOD_AGI")
		end,
	},
	-- Dodge Chance
	{
		option = "sumDodge",
		stat = StatLogic.Stats.Dodge,
		func = function(sum, statModContext, sumType)
			local dodge = summaryFunc[StatLogic.Stats.DodgeBeforeDR](sum, statModContext)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					dodge = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, dodge)
				elseif sumType == "sum" then
					dodge = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, equippedDodge + dodge) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, equippedDodge)
				end
			end
			return statModContext("MOD_DODGE") * (
				dodge
				+ sum[StatLogic.Stats.Dodge]
				+ summaryFunc[StatLogic.Stats.SpellCrit](sum, statModContext) * statModContext("ADD_DODGE_MOD_SPELL_CRIT")
			)
		 end,
	},
	-- Dodge Rating - DODGE_RATING
	{
		option = "sumDodgeRating",
		stat = StatLogic.Stats.DodgeRating,
		func = function(sum)
			return sum[StatLogic.Stats.DodgeRating]
		end,
	},
	-- Parry Chance Before DR - PARRY, PARRY_RATING, DEFENSE
	{
		option = "sumParryBeforeDR",
		stat = StatLogic.Stats.ParryBeforeDR,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.ParryRating](sum, statModContext) * statModContext("ADD_PARRY_MOD_PARRY_RATING")
				+ summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_PARRY_MOD_DEFENSE")
				+ summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_PARRY_MOD_STR")
		end,
	},
	-- Parry Chance
	{
		option = "sumParry",
		stat = StatLogic.Stats.Parry,
		func = function(sum, statModContext, sumType)
			local parry = summaryFunc[StatLogic.Stats.ParryBeforeDR](sum, statModContext)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					parry = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, parry)
				elseif sumType == "sum" then
					parry = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, equippedParry + parry) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, equippedParry)
				end
			end
			return GetParryChance() > 0 and (
				parry
				+ sum[StatLogic.Stats.Parry]
			) or 0
		 end,
	},
	-- Parry Rating - PARRY_RATING
	{
		option = "sumParryRating",
		stat = StatLogic.Stats.ParryRating,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.ParryRating]
				+ summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_PARRY_RATING_MOD_STR")
		end,
	},
	{
		option = "sumBlockChanceBeforeDR",
		stat = StatLogic.Stats.BlockChanceBeforeDR,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.BlockRating] * statModContext("ADD_BLOCK_MOD_BLOCK_RATING")
				+ summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_BLOCK_CHANCE_MOD_DEFENSE")
				+ summaryFunc[StatLogic.Stats.MasteryEffect](sum, statModContext) * statModContext("ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT")
		end,
	},
	-- Block Chance - BLOCK, BLOCK_RATING, DEFENSE
	{
		option = "sumBlock",
		stat = StatLogic.Stats.BlockChance,
		func = function(sum, statModContext, sumType)
			local blockChance = summaryFunc[StatLogic.Stats.BlockChanceBeforeDR](sum, statModContext)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					blockChance = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.BlockChance, blockChance)
				elseif sumType == "sum" then
					blockChance = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.BlockChance, equippedBlock + blockChance) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.BlockChance, equippedBlock)
				end
			end
			return GetBlockChance() > 0 and (
				blockChance
				+ sum[StatLogic.Stats.BlockChance]
			) or 0
		end,
	},
	-- Block Rating - BLOCK_RATING
	{
		option = "sumBlockRating",
		stat = StatLogic.Stats.BlockRating,
		func = function(sum)
			return sum[StatLogic.Stats.BlockRating]
		end,
	},
	-- Block Value - BLOCK_VALUE, STR
	{
		option = "sumBlockValue",
		stat = StatLogic.Stats.BlockValue,
		func = function(sum, statModContext)
			return GetBlockChance() > 0 and (
				statModContext("MOD_BLOCK_VALUE") * (
					sum[StatLogic.Stats.BlockValue]
					+ summaryFunc[StatLogic.Stats.Strength](sum, statModContext) * statModContext("ADD_BLOCK_VALUE_MOD_STR")
					+ summaryFunc[StatLogic.Stats.SpellDamage](sum, statModContext) * statModContext("ADD_BLOCK_VALUE_MOD_SPELL_DMG")
				)
			) or 0
		end,
	},
	-- Hit Avoidance Before DR - DEFENSE
	{
		option = "sumHitAvoidBeforeDR",
		stat = StatLogic.Stats.MissBeforeDR,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_MISS_MOD_DEFENSE")
		end,
	},
	-- Hit Avoidance
	{
		option = "sumHitAvoid",
		stat = StatLogic.Stats.Miss,
		func = function(sum, statModContext, sumType)
			local miss = summaryFunc[StatLogic.Stats.MissBeforeDR](sum, statModContext)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					miss = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, miss)
				elseif sumType == "sum" then
					miss = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, equippedMiss + miss) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, equippedMiss)
				end
			end
			return miss
		 end,
	},
	-- Defense - DEFENSE_RATING
	{
		option = "sumDefense",
		stat = StatLogic.Stats.Defense,
		func = function(sum, statModContext)
			return sum[StatLogic.Stats.Defense]
				+ sum[StatLogic.Stats.DefenseRating] * statModContext("ADD_DEFENSE_MOD_DEFENSE_RATING")
		end,
	},
	-- Avoidance - DODGE, PARRY, MELEE_HIT_AVOID, BLOCK(Optional)
	{
		option = "sumAvoidance",
		stat = StatLogic.Stats.Avoidance,
		func = function(sum, statModContext, sumType, link)
			local dodge = summaryFunc[StatLogic.Stats.Dodge](sum, statModContext, sumType, link)
			local parry = summaryFunc[StatLogic.Stats.Parry](sum, statModContext, sumType, link)
			local miss = summaryFunc[StatLogic.Stats.Miss](sum, statModContext, sumType, link)
			local block = 0
			if db.profile.sumAvoidWithBlock then
				block = summaryFunc[StatLogic.Stats.BlockChance](sum, statModContext, sumType, link)
			end
			return parry + dodge + miss + block
		end,
	},
	-- Crit Avoidance - RESILIENCE_RATING, DEFENSE
	{
		option = "sumCritAvoid",
		stat = StatLogic.Stats.CritAvoidance,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.Resilience](sum, statModContext) * statModContext("ADD_CRIT_AVOIDANCE_MOD_RESILIENCE")
				+ summaryFunc[StatLogic.Stats.Defense](sum, statModContext) * statModContext("ADD_CRIT_AVOIDANCE_MOD_DEFENSE")
		 end,
	},
	-- Resilience - RESILIENCE_RATING
	{
		option = "sumResilienceRating",
		stat = StatLogic.Stats.ResilienceRating,
		func = function(sum)
			return sum[StatLogic.Stats.ResilienceRating]
		end,
	},
	{
		stat = StatLogic.Stats.ResilienceBeforeDR,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.ResilienceRating](sum, statModContext) * statModContext("ADD_RESILIENCE_MOD_RESILIENCE_RATING")
		end,
	},
	{
		option = "sumResilience",
		stat = StatLogic.Stats.Resilience,
		func = function(sum, statModContext, sumType)
			local resilience = summaryFunc[StatLogic.Stats.ResilienceBeforeDR](sum, statModContext)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					resilience = StatLogic:GetResilienceEffectGainAfterDR(resilience)
				elseif sumType == "sum" then
					resilience = StatLogic:GetResilienceEffectGainAfterDR(equippedResilience + resilience) - StatLogic:GetResilienceEffectGainAfterDR(equippedResilience)
				end
			end
			return resilience
		 end,
	},
	{
		stat = StatLogic.Stats.PvpPowerRating,
		func = function(sum)
			return sum[StatLogic.Stats.PvpPowerRating]
		end,
	},
	{
		option = "sumPvpPower",
		stat = StatLogic.Stats.PvpPower,
		func = function(sum, statModContext)
			return summaryFunc[StatLogic.Stats.PvpPowerRating](sum, statModContext) * statModContext("ADD_PVP_POWER_MOD_PVP_POWER_RATING")
		 end,
	},
	-- Arcane Resistance - ARCANE_RES
	{
		option = "sumArcaneResist",
		stat = StatLogic.Stats.ArcaneResistance,
		func = function(sum)
			return sum[StatLogic.Stats.ArcaneResistance]
		end,
	},
	-- Fire Resistance - FIRE_RES
	{
		option = "sumFireResist",
		stat = StatLogic.Stats.FireResistance,
		func = function(sum)
			return sum[StatLogic.Stats.FireResistance]
		end,
	},
	-- Nature Resistance - NATURE_RES
	{
		option = "sumNatureResist",
		stat = StatLogic.Stats.NatureResistance,
		func = function(sum)
			return sum[StatLogic.Stats.NatureResistance]
		end,
	},
	-- Frost Resistance - FROST_RES
	{
		option = "sumFrostResist",
		stat = StatLogic.Stats.FrostResistance,
		func = function(sum)
			return sum[StatLogic.Stats.FrostResistance]
		end,
	},
	-- Shadow Resistance - SHADOW_RES
	{
		option = "sumShadowResist",
		stat = StatLogic.Stats.ShadowResistance,
		func = function(sum)
			return sum[StatLogic.Stats.ShadowResistance]
		end,
	},
}

-- Build summaryFunc
for _, calcData in pairs(summaryCalcData) do
	summaryFunc[calcData.stat] = calcData.func
end

local function sumSortAlphaComp(a, b)
	return a[1] < b[1]
end

local function WriteSummary(tooltip, output)
	if db.global.sumBlankLine then
		tooltip:AddLine(" ")
	end

	local headerIcon
	if db.global.sumShowIcon then
		headerIcon = "|TInterface\\AddOns\\RatingBuster\\images\\Sigma:0|t "
	end

	local headerText
	if db.global.sumShowTitle then
		headerText = L["Stat Summary"]
	end
	if db.global.sumShowProfile then
		local profile = db:GetCurrentProfile()
		if headerText then
			headerText = headerText .. ": " .. profile
		else
			headerText = profile
		end
	end
	if headerIcon or headerText then
		tooltip:AddLine((headerIcon or "") .. HIGHLIGHT_FONT_COLOR_CODE .. (headerText or "") .. FONT_COLOR_CODE_CLOSE)
	end

	local statR, statG, statB = db.global.sumStatColor:GetRGB()
	local valueR, valueG, valueB = db.global.sumValueColor:GetRGB()
	for _, o in ipairs(output) do
		tooltip:AddDoubleLine(o[1], o[2], statR, statG, statB, valueR, valueG, valueB)
	end
	if db.global.sumBlankLineAfter then
		tooltip:AddLine(" ")
	end
end

local primaryStats = {
	StatLogic.Stats.Strength,
	StatLogic.Stats.Agility,
	StatLogic.Stats.Stamina,
	StatLogic.Stats.Intellect,
	StatLogic.Stats.Spirit,
}

local primaryStatsByClassAndSpec = {
	ROGUE = {
		StatLogic.Stats.Agility,
		StatLogic.Stats.Agility,
		StatLogic.Stats.Agility,
	},
	HUNTER = {
		StatLogic.Stats.Agility,
		StatLogic.Stats.Agility,
		StatLogic.Stats.Agility,
	},
	WARRIOR = {
		StatLogic.Stats.Strength,
		StatLogic.Stats.Strength,
		StatLogic.Stats.Strength,
	},
	DEATHKNIGHT = {
		StatLogic.Stats.Strength,
		StatLogic.Stats.Strength,
		StatLogic.Stats.Strength,
	},
	PRIEST = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
	},
	MAGE = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
	},
	WARLOCK = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Intellect,
	},
	DRUID = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Agility,
		StatLogic.Stats.Intellect,
	},
	PALADIN = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Strength,
		StatLogic.Stats.Strength,
	},
	SHAMAN = {
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Agility,
		StatLogic.Stats.Intellect,
	},
}

local function GetInferredPrimaryStat()
	local _, class = UnitClass("player")
	local spec = GetPrimaryTalentTree()
	if not class or not spec then
		return nil
	end
	return primaryStatsByClassAndSpec[class][spec]
end

local function GetPrimaryStat()
	if addon.tocversion < 40000 then
		return nil
	end
	if not GetSpecialization or not GetSpecializationInfo then
		return GetInferredPrimaryStat()
	end
	local spec = GetSpecialization()
	if not spec then
		return nil
	end
	local specPrimaryStat = select(6, GetSpecializationInfo(spec))
	return primaryStats[specPrimaryStat]
end

function RatingBuster:StatSummary(tooltip, link, statModContext)
	-- Hide stat summary for equipped items
	if db.global.sumIgnoreEquipped and C_Item.IsEquippedItem(link) then return end

	-- Show stat summary only for highest level armor type and items you can use with uncommon quality and up
	if db.global.sumIgnoreUnused then
		local _, _, itemQuality, _, _, _, _, _, inventoryType, _, _, classID, subclassID = C_Item.GetItemInfo(link)

		-- Check rarity
		if not itemQuality or itemQuality < 2 then
			return
		end

		-- Check armor type
		if classID == Enum.ItemClass.Armor and armorTypes[subclassID] and (not classArmorTypes[class][subclassID]) and inventoryType ~= "INVTYPE_CLOAK" then
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
	local red = db.profile.sumGemRed.gemID
	local yellow = db.profile.sumGemYellow.gemID
	local blue = db.profile.sumGemBlue.gemID
	local meta = db.profile.sumGemMeta.gemID
	local prismatic = db.profile.sumGemPrismatic.gemID

	if db.global.sumIgnoreEnchant then
		link = StatLogic:RemoveEnchant(link)
	end
	if db.global.sumIgnoreExtraSockets then
		link = StatLogic:RemoveExtraSockets(link)
	end
	if db.global.sumIgnoreGems then
		link = StatLogic:RemoveGem(link)
	else
		link = StatLogic:BuildGemmedTooltip(link, red, yellow, blue, meta, prismatic)
	end

	-- Diff Display Style
	-- Main Tooltip: tooltipLevel = 0
	-- Compare Tooltip 1: tooltipLevel = 1
	-- Compare Tooltip 2: tooltipLevel = 2
	local id
	local tooltipLevel = 0
	local mainTooltip = tooltip
	-- Determine tooltipLevel and id
	if db.global.calcDiff and (db.global.sumDiffStyle == "comp") then
		-- Obtain main tooltip
		local owner = tooltip:GetOwner()
	    if owner.GetObjectType and owner:GetObjectType() == "GameTooltip" then
			mainTooltip = owner
		end
		-- Detemine tooltip level
		local _, mainlink, difflink1, difflink2 = StatLogic:GetDiffID(mainTooltip, db.global.sumIgnoreEnchant, db.global.sumIgnoreGems, db.global.sumIgnoreExtraSockets, red, yellow, blue, meta)
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
		id = StatLogic:GetDiffID(link, db.global.sumIgnoreEnchant, db.global.sumIgnoreGems, db.global.sumIgnoreExtraSockets, red, yellow, blue, meta)
	end
	if not id then return end

	local numLines = StatLogic:GetItemTooltipNumLines(link)

	-- Check Cache
	local cacheKey = statModContext:CacheKey()
	local cached = cache[cacheKey][id]
	if cached and cached.numLines == numLines then
		if table.maxn(cached) == 0 then return end
		WriteSummary(tooltip, cached)
		return
	end

	-------------------------
	-- Build Summary Table --
	local statData = {}
	statData.sum = StatLogic:GetSum(link, nil, statModContext)
	if not statData.sum then return end
	if not db.global.calcSum then
		statData.sum = nil
	end

	if db.global.sumIgnoreNonPrimaryStat then
		local primaryStat = GetPrimaryStat()
		if primaryStat and statData.sum[primaryStat] == 0 then
			return
		end
	end

	-- Ignore bags
	if not StatLogic:GetDiff(link) then return end

	-- Get Diff Data
	if db.global.calcDiff then
		if db.global.sumDiffStyle == "comp" then
			if tooltipLevel > 0 then
				statData.diff1 = select(tooltipLevel, StatLogic:GetDiff(mainTooltip, nil, nil, db.global.sumIgnoreEnchant, db.global.sumIgnoreGems, db.global.sumIgnoreExtraSockets, red, yellow, blue, meta))
			end
		else
			statData.diff1, statData.diff2 = StatLogic:GetDiff(link, nil, nil, db.global.sumIgnoreEnchant, db.global.sumIgnoreGems, db.global.sumIgnoreExtraSockets, red, yellow, blue, meta)
		end
	end

	local summary = {}
	for _, calcData in ipairs(summaryCalcData) do
		if db.profile[calcData.option] then
			local entry = {
				stat = calcData.stat,
			}
			for statDataType, statTable in pairs(statData) do
				entry[statDataType] = calcData.func(statTable, statModContext, statDataType, link)
			end
			tinsert(summary, entry)
		end
	end

	local calcSum = db.global.calcSum
	local calcDiff = db.global.calcDiff

	local showZeroValueStat = db.global.showZeroValueStat
	------------------------
	-- Build Output Table --
	local output = {}
	output.numLines = numLines
	for _, t in ipairs(summary) do
		local stat, s, d1, d2 = t.stat, t.sum, t.diff1, t.diff2
		local isPercent = stat.isPercent
		local right, left
		local skip
		if not showZeroValueStat then
			if (s == 0 or not s) and (d1 == 0 or not d1) and (d2 == 0 or not d2) then
				skip = true
			end
		end
		if not skip then
			if calcSum and calcDiff then
				local d = ((not s) or ((s - floor(s)) == 0)) and ((not d1) or ((d1 - floor(d1)) == 0)) and ((not d2) or ((d2 - floor(d2)) == 0)) and not isPercent
				if s then
					if d then
						s = ("%d"):format(s)
					elseif isPercent then
						s = ("%.2f%%"):format(s)
					else
						s = ("%.1f"):format(s)
					end
					if d1 then
						if d then
							d1 = colorNum(("%+d"):format(d1), d1)
						elseif isPercent then
							d1 = colorNum(("%+.2f%%"):format(d1), d1)
						else
							d1 = colorNum(("%+.1f"):format(d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(("%+d"):format(d2), d2)
							elseif isPercent then
								d2 = colorNum(("%+.2f%%"):format(d2), d2)
							else
								d2 = colorNum(("%+.1f"):format(d2), d2)
							end
							right = ("%s (%s||%s)"):format(s, d1, d2)
						else
							right = ("%s (%s)"):format(s, d1)
						end
					else
						right = s
					end
				else
					if d1 then
						if d then
							d1 = colorNum(("%+d"):format(d1), d1)
						elseif isPercent then
							d1 = colorNum(("%+.2f%%"):format(d1), d1)
						else
							d1 = colorNum(("%+.1f"):format(d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(("%+d"):format(d2), d2)
							elseif isPercent then
								d2 = colorNum(("%+.2f%%"):format(d2), d2)
							else
								d2 = colorNum(("%+.1f"):format(d2), d2)
							end
							right = ("(%s||%s)"):format(d1, d2)
						else
							right = ("(%s)"):format(d1)
						end
					end
				end
			elseif calcSum then
				if s then
					if (s - floor(s)) == 0 then
						s = ("%d"):format(s)
					elseif isPercent then
						s = ("%.2f%%"):format(s)
					else
						s = ("%.1f"):format(s)
					end
					right = s
				end
			elseif calcDiff then
				local d = ((not d1) or (d1 - floor(d1)) == 0) and ((not d2) or ((d2 - floor(d2)) == 0))
				if d1 then
					if d then
						d1 = colorNum(("%+d"):format(d1), d1)
					elseif isPercent then
						d1 = colorNum(("%+.2f%%"):format(d1), d1)
					else
						d1 = colorNum(("%+.1f"):format(d1), d1)
					end
					if d2 then
						if d then
							d2 = colorNum(("%+d"):format(d2), d2)
						elseif isPercent then
							d2 = colorNum(("%+.2f%%"):format(d2), d2)
						else
							d2 = colorNum(("%+.1f"):format(d2), d2)
						end
						right = ("%s||%s"):format(d1, d2)
					else
						right = d1
					end
				end
			end
			if right then
				left = L[stat]
				tinsert(output, {left, right})
			end
		end
	end
	-- sort alphabetically if option enabled
	if db.global.sumSortAlpha then
		tsort(output, sumSortAlphaComp)
	end
	-- Write cache
	cache[cacheKey][id] = output
	if table.maxn(output) == 0 then return end
	WriteSummary(tooltip, output)
end

function RatingBuster:PerformanceProfile()
	if not GetCVarBool("scriptProfile") then
		print("The console variable \"scriptProfile\" must be enabled to do performance profiling.\nEnable it and reload to continue. Be sure to disable it again when you are finished.")
		return
	end

	-- Process the tooltips for all of the player's equipped gear
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		GameTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
		GameTooltip:SetInventoryItem("player", i)
		self.ProcessTooltip(GameTooltip --[[@as ClassicGameTooltip]])
		GameTooltip:Hide()
	end

	local tables = {
		["RatingBuster"] = self,
		["StatLogic"] = StatLogic
	}

	for name, addonTable in pairs(tables) do
		print(name)
		print("(ms) (count) (function)")
		local unsorted = {}
		local rankings = {}
		for k,v in pairs(addonTable) do
			if type(v) == "function" then
				local time, count = GetFunctionCPUUsage(v, false)
				if count > 0 then
					unsorted[time] = {
						count = count,
						name = k
					}
					tinsert(rankings, time)
				end
			end
		end
		table.sort(rankings, function(a,b) return a > b end)
		for i, time in ipairs(rankings) do
			if i <= 10 then
				print(string.format("  %2.2f %4d %s", time, unsorted[time].count, unsorted[time].name))
			end
		end
	end
end