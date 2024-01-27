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
local GSM = function(...)
	return StatLogic:GetStatMod(...)
end
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

local function getOption(info, dataType)
	dataType = dataType or "profile"
	return db[dataType][info[#info]]
end
local function setOption(info, value, dataType)
	dataType = dataType or "profile"
	db[dataType][info[#info]] = value
	clearCache()
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
		local name, link = GetItemInfo(value)
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
		clearCache()
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
	clearCache()
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
				ratingPhysical = {
					type = 'toggle',
					name = L["Show Physical Hit/Haste"],
					desc = L["Show Physical Hit/Haste from Hit/Haste Rating"],
					order = 2,
					width = "full",
					hidden = function()
						local genericHit = StatLogic.GenericStatMap[StatLogic.Stats.HitRating]
						return (not genericHit)
					end
				},
				ratingSpell = {
					type = 'toggle',
					name = L["Show Spell Hit/Haste"],
					desc = L["Show Spell Hit/Haste from Hit/Haste Rating"],
					order = 3,
					width = "full",
					hidden = function()
						local genericHit = StatLogic.GenericStatMap[StatLogic.Stats.HitRating]
						return (not genericHit) or (not tContains(genericHit, StatLogic.Stats.SpellHitRating))
					end
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
				},
				agi = {
					type = 'group',
					name = L[StatLogic.Stats.Agility],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Agility]),
					width = "full",
					order = 4,
					args = {
						showCritFromAgi = {
							type = 'toggle',
							name = L["Show %s"]:format(L[StatLogic.Stats.MeleeCrit]),
							width = "full",
						},
						showDodgeFromAgi = {
							type = 'toggle',
							name = L["Show %s"]:format(L[StatLogic.Stats.Dodge]),
							width = "full",
						},
					},
				},
				sta = {
					type = 'group',
					name = L[StatLogic.Stats.Stamina],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Stamina]),
					width = "full",
					order = 5,
					args = {},
				},
				int = {
					type = 'group',
					name = L[StatLogic.Stats.Intellect],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Intellect]),
					width = "full",
					order = 6,
					args = {
						showSpellCritFromInt = {
							type = 'toggle',
							name = L["Show %s"]:format(L[StatLogic.Stats.SpellCrit]),
							width = "full",
						},
					},
				},
				spi = {
					type = 'group',
					name = L[StatLogic.Stats.Spirit],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Spirit]),
					width = "full",
					order = 7,
					args = {},
				},
				ap = {
					type = 'group',
					name = L[StatLogic.Stats.AttackPower],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.AttackPower]),
					order = 8,
					args = {},
					hidden = true,
				},
				weaponskill = {
					type = 'group',
					name = L[StatLogic.Stats.WeaponSkill],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.WeaponSkill]),
					order = 9,
					hidden = function()
						return addon.tocversion >= 20000
					end,
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
					order = 9.5,
					hidden = true,
					args = {},
				},
				defense = {
					type = 'group',
					name = L[StatLogic.Stats.Defense],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Defense]),
					order = 10,
					hidden = true,
					args = {},
				},
				armor = {
					type = 'group',
					name = L[StatLogic.Stats.Armor],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.Armor]),
					order = 11,
					args = {},
					hidden = true,
				},
				resilience = {
					type = 'group',
					name = L[StatLogic.Stats.ResilienceRating],
					desc = L["Changes the display of %s"]:format(L[StatLogic.Stats.ResilienceRating]),
					order = 11,
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
					get = function(info)
						return getOption(info, "global")
					end,
					set = function(info, value)
						setOption(info, value, "global")
					end,
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
							desc = L["Show the sigma icon before summary listing"],
							order = 8,
						},
						sumShowTitle = {
							type = 'toggle',
							name = L["Show title text"],
							desc = L["Show the title text before summary listing"],
							order = 9,
						},
						showZeroValueStat = {
							type = 'toggle',
							name = L["Show zero value stats"],
							desc = L["Show zero value stats in summary for consistancy"],
							order = 10,
						},
						sumSortAlpha = {
							type = 'toggle',
							name = L["Sort StatSummary alphabetically"],
							desc = L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"],
							order = 11,
						},
						sumStatColor = {
							type = 'color',
							name = L["Change text color"],
							desc = L["Changes the color of added text"],
							get = getColor,
							set = setColor,
							order = 12,
						},
						sumValueColor = {
							type = 'color',
							name = L["Change number color"],
							desc = L["Changes the color of added text"],
							get = getColor,
							set = setColor,
							order = 13,
						},
						space = {
							type = 'group',
							name = L["Add empty line"],
							inline = true,
							order = 14,
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
					get = function(info)
						return getOption(info, "global")
					end,
					set = function(info, value)
						setOption(info, value, "global")
					end,
					args = {
						sumIgnoreUnused = {
							type = 'toggle',
							name = L["Ignore unused item types"],
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
						sumMP5 = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ManaRegen]),
							desc = L["Mana Regen <- Mana Regen, Spirit"],
							order = 3,
						},
						sumMP5NC = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ManaRegenNotCasting]),
							desc = L["Mana Regen while not casting <- Spirit"],
							order = 4,
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
							hidden = function()
								return addon.tocversion >= 40000
							end,
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
							name = L["Sum %s"]:format(L[StatLogic.Stats.ResilienceRating]),
							order = 14,
						},
						sumArcaneResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ArcaneResistance]),
							order = 15,
						},
						sumFireResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FireResistance]),
							order = 16,
						},
						sumNatureResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.NatureResistance]),
							order = 17,
						},
						sumFrostResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.FrostResistance]),
							order = 18,
						},
						sumShadowResist = {
							type = 'toggle',
							name = L["Sum %s"]:format(L[StatLogic.Stats.ShadowResistance]),
							order = 19,
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
	},
	profile = {
		enableAvoidanceDiminishingReturns = StatLogic.GetAvoidanceAfterDR and true or false,
		showRatings = true,
		wpnBreakDown = false,
		showStats = true,
		sumAvoidWithBlock = false,
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
		showHP5NCFromSpi = false,

		showDefenseFromDefenseRating = false,
		showDodgeReductionFromExpertise = false,
		showParryReductionFromExpertise = false,
		showCritAvoidanceFromResilience = false,
		showCritDamageReductionFromResilience = false,
		showPvpDamageReductionFromResilience = false,
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
	defaults.profile.showDodgeFromAgi = false
	defaults.profile.showSpellCritFromInt = false
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
	-- Backwards compatibility
	local statToOptionKey = setmetatable({
		["AP"] = "AP",
		["MANA_REG"] = "MP5",
		["NORMAL_MANA_REG"] = "MP5NC",
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
		["AP"] = StatLogic.Stats.AttackPower,
		["RANGED_AP"] = StatLogic.Stats.RangedAttackPower,
		["MANA"] = StatLogic.Stats.Mana,
		["MANA_REG"] = StatLogic.Stats.ManaRegen,
		["NORMAL_MANA_REG"] = StatLogic.Stats.ManaRegenNotCasting,
		["HEALTH"] = StatLogic.Stats.Health,
		["HEALTH_REG"] = StatLogic.Stats.HealthRegen,
		["NORMAL_HEALTH_REG"] = StatLogic.Stats.HealthRegenOutOfCombat,
		["SPELL_DMG"] = StatLogic.Stats.SpellDamage,
		["SPELL_HIT"] = StatLogic.Stats.SpellHit,
		["SPELL_CRIT"] = StatLogic.Stats.SpellCrit,
		["HEALING"] = StatLogic.Stats.HealingPower,
		["DODGE_REDUCTION"] = StatLogic.Stats.DodgeReduction,
		["PARRY_REDUCTION"] = StatLogic.Stats.ParryReduction,
		["BLOCK_CHANCE"] = StatLogic.Stats.BlockChance,
		["CRIT_AVOIDANCE"] = StatLogic.Stats.CritAvoidance,
		["DODGE"] = StatLogic.Stats.Dodge,
		["MISS"] = StatLogic.Stats.Miss,
		["PARRY"] = StatLogic.Stats.Parry,
		["BLOCK_VALUE"] = StatLogic.Stats.BlockValue,
		["CRIT_DAMAGE_REDUCTION"] = StatLogic.Stats.CritDamageReduction,
		["PVP_DAMAGE_REDUCTION"] = StatLogic.Stats.PvPDamageReduction,
	},
	{
		__index = function(_, stat)
			return stat
		end
	})

	local addStatModOption = function(add, mod, sources)
		-- Override groups that are hidden by default
		local groupID, rating = tostring(mod):lower():gsub("rating$", "")
		local group = options.args.stat.args[groupID]
		if not group then return end
		group.hidden = false
		if rating > 0 then
			-- Rename Defense group to Defense Rating
			group.name = L[mod]
			group.desc = L["Changes the display of %s"]:format(L[mod])
		end

		-- ADD_HEALING_MOD_INT -> showHealingFromInt
		local key = "show" .. statToOptionKey[add] .. "From" .. statToOptionKey[mod]
		if defaults.profile[key] == nil then
			defaults.profile[key] = true
		end

		local option = group.args[key]
		if not option then
			option = {
				type = "toggle",
				width = "full",
				order = rating == 1 and 1 or nil,
			}
		else
			sources = option.desc .. ", " .. sources
		end

		option.name = L["Show %s"]:format(L[statStringToStat[add]])
		option.desc = sources

		group.args[key] = option
	end

	local function GenerateStatModOptions()
		for _, modList in pairs(StatLogic.StatModTable) do
			for statMod, cases in pairs(modList) do
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
						if case.aura then
							source = GetSpellInfo(case.aura)
						elseif case.tab then
							source = StatLogic:GetOrderedTalentInfo(case.tab, case.num)
						elseif case.glyph then
							source = GetSpellInfo(case.glyph)
						elseif case.spellid then
							source = GetSpellInfo(case.spellid)
						end
						sources = sources .. source
						firstSource = false
					end

					-- Molten Armor and Forceful Deflection give rating,
					-- but we show it to the user as the converted stat
					add = add:gsub("_RATING", "")

					-- We want to show the user Armor, regardless of where it comes from
					if add == "BONUS_ARMOR" then
						add = StatLogic.Stats.Armor
					end

					if mod == "NORMAL_MANA_REG" then
						mod = "SPI"
						if GSM("ADD_NORMAL_MANA_REG_MOD_INT") > 0 then
							-- "Normal mana regen" is added from both int and spirit
							addStatModOption(add, "INT", sources)
						end
					elseif mod == "NORMAL_HEALTH_REG" then
						mod = "SPI"
					elseif mod == "MANA" then
						mod = "INT"
					end

					-- Demonic Knowledge technically scales with pet stats,
					-- but we compute the scaling from player's stats
					mod = mod:gsub("^PET_", "")

					addStatModOption(add, mod, sources)
				end
			end
		end

		for stat in pairs(StatLogic.RatingBase) do
			local converted = StatLogic.Stats[tostring(stat):gsub("Rating$", "")]
			if converted then
				addStatModOption(converted, stat)
			end
		end
	end

	local season = C_Seasons and C_Seasons.HasActiveSeason() and C_Seasons.GetActiveSeason()
	local showRunes =  season ~= Enum.SeasonID.NoSeason and season ~= Enum.SeasonID.Hardcore

	local function GenerateAuraOptions()
		for modType, modList in pairs(StatLogic.StatModTable) do
			for modName, mods in pairs(modList) do
				if not StatLogic.StatModIgnoresAlwaysBuffed[modName] then
					for _, mod in ipairs(mods) do
						if mod.aura and (not mod.rune or showRunes) then
							local name, _, icon = GetSpellInfo(mod.aura)
							local option = {
								type = 'toggle',
								name = "|T"..icon..":25:25:-2:0|t"..name,
							}
							options.args.alwaysBuffed.args[modType].args[name] = option
							options.args.alwaysBuffed.args[modType].hidden = false

							-- If it's a spell the player knows, use the highest rank for the description
							local spellId = mod.aura
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
	db = RatingBuster.db

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
	addon:EnableHook(self.ProcessTooltip)
	-- Initialize playerLevel
	playerLevel = UnitLevel("player")
	-- for setting a new level
	self:RegisterEvent("PLAYER_LEVEL_UP")
	-- Events that require cache clearing
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", clearCache) -- talent point changed
	self:RegisterBucketEvent("UNIT_AURA", 1) -- fire at most once every 1 second
end

function RatingBuster:OnDisable()
	addon:DisableHook()
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
local processedDodge, processedParry, processedMissed, processedResilience

local scanningTooltipOwners = {
	["WorldFrame"] = true,
	["UIParent"] = true,
}

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
		StatLogic:GetSum(difflink1, equippedSum)
		equippedSum[StatLogic.Stats.Strength] = equippedSum[StatLogic.Stats.Strength] * GSM("MOD_STR")
		equippedSum[StatLogic.Stats.Agility] = equippedSum[StatLogic.Stats.Agility] * GSM("MOD_AGI")
		equippedDodge = summaryFunc[StatLogic.Stats.DodgeBeforeDR](equippedSum, "sum", difflink1) * -1
		equippedParry = summaryFunc[StatLogic.Stats.ParryBeforeDR](equippedSum, "sum", difflink1) * -1
		equippedMissed = summaryFunc[StatLogic.Stats.MissBeforeDR](equippedSum, "sum", difflink1) * -1
		processedDodge = equippedDodge
		processedParry = equippedParry
		processedMissed = equippedMissed
		processedResilience = equippedSum[StatLogic.Stats.ResilienceRating] * -1
	else
		equippedDodge = 0
		equippedParry = 0
		equippedMissed = 0
		processedDodge = 0
		processedParry = 0
		processedMissed = 0
		processedResilience = 0
	end
	-- Loop through tooltip lines starting at line 2
	local tipTextLeft = tooltip:GetName().."TextLeft"
	for i = 2, tooltip:NumLines() do
		local fontString = _G[tipTextLeft..i]
		local text = fontString:GetText()
		if text then
			local color = CreateColor(fontString:GetTextColor())
			text = RatingBuster:ProcessLine(text, link, color)
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
		RatingBuster:StatSummary(tooltip, link)
	end

	-- Repaint tooltip
	tooltip:Show()
end

function RatingBuster:ProcessLine(text, link, color)
	-- Get data from cache if available
	local cacheID = text..playerLevel
	local cacheText = cache[cacheID]
	if cacheText then
		if cacheText ~= text then
			return cacheText
		end
	elseif EmptySocketLookup[text] and db.profile[EmptySocketLookup[text]].gemText then -- Replace empty sockets with gem text
		text = db.profile[EmptySocketLookup[text]].gemText
		cache[cacheID] = text
		-- SetText
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
		text = RatingBuster:RecursivelySplitLine(text, separatorTable, link, color)
		-- Revert exclusions
		if exclusions then
			for exclusion, replacement in pairs(L["exclusions"]) do
				text = text:gsub(replacement, exclusion)
			end
		end
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
-- RatingBuster:RecursivelySplitLine("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ",", "%. ", " for ", "&"})
-- RatingBuster:RecursivelySplitLine("+6法術傷害及5耐力", {"/", "和", ",", "。", " 持續 ", "&", "及",})
function RatingBuster:RecursivelySplitLine(text, separatorTable, link, color)
	if type(separatorTable) == "table" and table.maxn(separatorTable) > 0 then
		local sep = tremove(separatorTable, 1)
		text =  text:gsub(sep, "@")
		text = strsplittable("@", text)
		local processedText = {}
		local tempTable = {}
		for _, t in ipairs(text) do
			copyTable(tempTable, separatorTable)
			tinsert(processedText, self:RecursivelySplitLine(t, tempTable, link, color))
		end
		-- Join text
		return (table.concat(processedText, "@"):gsub("@", sep))
	else
		return self:ProcessText(text, link, color)
	end
end

function RatingBuster:ProcessText(text, link, color)
	-- Convert text to lower so we don't have to worry about same ratings with different cases
	local lowerText = text:lower()
	-- Check if text has a matching pattern
	for _, num in ipairs(L["numberPatterns"]) do
		-- Capture the stat value
		local _, insertionPoint, value, partialtext = lowerText:find(num.pattern)
		if value then
			-- Check and switch captures if needed
			if partialtext and tonumber(partialtext) then
				value, partialtext = partialtext, value
			end
			-- Capture the stat name
			for _, statPattern in ipairs(L["statList"]) do
				local pattern, stat = unpack(statPattern)
				if (not partialtext and lowerText:find(pattern)) or (partialtext and partialtext:find(pattern)) then
					value = tonumber(value)
					local infoTable = StatLogic.StatTable.new()
					RatingBuster:ProcessStat(stat, value, infoTable, link, color)
					local effects = {}
					-- Group effects with identical values
					for statID, effect in pairs(infoTable) do
						if  type(statID) == "table" and statID.isPercent or statID == "Spell" then
							effect = ("%+.2f%%"):format(effect)
							effects[effect] = effects[effect] or {}
							tinsert(effects[effect], S[statID])
						elseif statID == "Percent" then
							effect = ("%+.2f%%"):format(effect)
							effects[effect] = effects[effect] or {}
						else
							if floor(abs(effect) * 10 + 0.5) > 0 then
								effect = ("%+.1f"):format(effect)
							elseif floor(abs(effect) + 0.5) > 0 then
								effect = ("%+.0f"):format(effect)
							end
							effects[effect] = effects[effect] or {}
							if statID ~= "Decimal" then
								tinsert(effects[effect], S[statID])
							end
						end
					end
					local info = {}
					for effect, stats in pairs(effects) do
						if #stats > 0 then
							effect = effect .. " " .. table.concat(stats, ", ")
						end
						tinsert(info, effect)
					end
					table.sort(info, function(a, b)
						return #a < #b
					end)
					local infoString = table.concat(info, ", ")
					if infoString ~= "" then
						-- Change insertion point if necessary
						if num.addInfo == "AfterStat" then
							local _, statInsertionPoint = lowerText:find(pattern)
							if statInsertionPoint > insertionPoint then
								insertionPoint = statInsertionPoint
							end
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

do
	local RatingType = {
		Melee = {
			[StatLogic.Stats.MeleeHitRating] = true,
			[StatLogic.Stats.MeleeCritRating] = true,
			[StatLogic.Stats.MeleeHasteRating] = true,
		},
		Ranged = {
			[StatLogic.Stats.RangedHitRating] = true,
			[StatLogic.Stats.RangedCritRating] = true,
			[StatLogic.Stats.RangedHasteRating] = true,
		},
		Spell = {
			[StatLogic.Stats.SpellHitRating] = true,
			[StatLogic.Stats.SpellCritRating] = true,
			[StatLogic.Stats.SpellHasteRating] = true,
		},
		Decimal = {
			[StatLogic.Stats.DefenseRating] = true,
			[StatLogic.Stats.ExpertiseRating] = true,
		}
	}

	function RatingBuster:ProcessStat(statID, value, infoTable, link, color)
		if StatLogic.GenericStatMap[statID] then
			local statList = StatLogic.GenericStatMap[statID]
			for _, convertedStatID in ipairs(statList) do
				if not RatingType.Ranged[convertedStatID] then
					RatingBuster:ProcessStat(convertedStatID, value, infoTable)
				end
			end
		elseif StatLogic.RatingBase[statID] and db.profile.showRatings then
			--------------------
			-- Combat Ratings --
			--------------------
			-- Calculate stat value
			local effect = StatLogic:GetEffectFromRating(value, statID, playerLevel)
			if statID == StatLogic.Stats.DefenseRating then
				if db.profile.showDefenseFromDefenseRating then
					infoTable["Decimal"] = effect
				end
				self:ProcessStat(StatLogic.Stats.Defense, effect, infoTable)
			elseif statID == StatLogic.Stats.DodgeRating and db.profile.enableAvoidanceDiminishingReturns then
				infoTable["Percent"] = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, processedDodge + effect) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, processedDodge)
				processedDodge = processedDodge + effect
			elseif statID == StatLogic.Stats.ParryRating and db.profile.enableAvoidanceDiminishingReturns then
				infoTable["Percent"] = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry + effect) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry)
				processedParry = processedParry + effect
			elseif statID == StatLogic.Stats.ExpertiseRating then
				if addon.tocversion < 30000 then
					-- Expertise is truncated in TBC but not in Wrath
					effect = floor(effect)
				end
				if db.profile.showExpertiseFromExpertiseRating then
					infoTable["Decimal"] = effect
				end
				if db.profile.showDodgeReductionFromExpertise then
					local dodgeReduction = effect * -GSM("ADD_DODGE_REDUCTION_MOD_EXPERTISE")
					infoTable[StatLogic.Stats.DodgeReduction] = infoTable[StatLogic.Stats.DodgeReduction] + dodgeReduction
				end
				if db.profile.showParryReductionFromExpertise then
					local parryReduction = effect * -GSM("ADD_PARRY_REDUCTION_MOD_EXPERTISE")
					infoTable[StatLogic.Stats.ParryReduction] = infoTable[StatLogic.Stats.ParryReduction] + parryReduction
				end
			elseif statID == StatLogic.Stats.ResilienceRating then
				if db.profile.enableAvoidanceDiminishingReturns and StatLogic.GetResilienceEffectGainAfterDR then
					effect = StatLogic:GetResilienceEffectGainAfterDR(processedResilience + value, processedResilience)
					processedResilience = processedResilience + value
				end

				if db.profile.showResilienceFromResilienceRating then
					infoTable["Percent"] = effect
				end
				local critAvoidance = effect * GSM("ADD_CRIT_AVOIDANCE_MOD_RESILIENCE")
				if db.profile.showCritAvoidanceFromResilience then
					infoTable[StatLogic.Stats.CritAvoidance] = infoTable[StatLogic.Stats.CritAvoidance] + critAvoidance
				end
				local critDmgReduction = effect * GSM("ADD_CRIT_DAMAGE_REDUCTION_MOD_RESILIENCE")
				if db.profile.showCritDamageReductionFromResilience then
					infoTable[StatLogic.Stats.CritDamageReduction] = infoTable[StatLogic.Stats.CritDamageReduction] + critDmgReduction
				end
				local pvpDmgReduction = effect * GSM("ADD_PVP_DAMAGE_REDUCTION_MOD_RESILIENCE")
				if db.profile.showPvpDamageReductionFromResilience then
					infoTable[StatLogic.Stats.PvPDamageReduction] = infoTable[StatLogic.Stats.PvPDamageReduction] + pvpDmgReduction
				end
			elseif statID == StatLogic.Stats.MasteryRating then
				if db.profile.showMasteryEffectFromMastery then
					effect = effect * GSM("ADD_MASTERY_EFFECT_MOD_MASTERY")
					infoTable["Percent"] = infoTable[StatLogic.Stats.MasteryEffect] + effect
				end
			else
				local show = false
				local displayType = "Percent"
				if RatingType.Melee[statID] then
					if db.profile.ratingPhysical then
						show = true
					end
				elseif RatingType.Spell[statID] then
					if db.profile.ratingSpell then
						if not db.profile.ratingPhysical then
							show = true
						elseif ( statID == StatLogic.Stats.SpellHitRating or (statID == StatLogic.Stats.SpellHasteRating and StatLogic.ExtraHasteClasses[class])) then
							show = true
							displayType = "Spell"
						end
					end
				elseif RatingType.Decimal[statID] then
					show = true
					displayType = "Decimal"
				else
					show = true
				end

				if show then
					infoTable[displayType] = effect
				end
			end
		elseif statID == StatLogic.Stats.Strength and db.profile.showStats then
			--------------
			-- Strength --
			--------------
			value = value * GSM("MOD_STR")
			local attackPower = value * GSM("ADD_AP_MOD_STR")
			self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable)
			if db.profile.showAPFromStr then
				local effect = attackPower * GSM("MOD_AP")
				infoTable[StatLogic.Stats.AttackPower] = infoTable[StatLogic.Stats.AttackPower] + effect
			end
			if db.profile.showBlockValueFromStr then
				local effect = value * GSM("ADD_BLOCK_VALUE_MOD_STR")
				infoTable[StatLogic.Stats.BlockValue] = infoTable[StatLogic.Stats.BlockValue] + effect
			end
			if db.profile.showSpellDmgFromStr then
				local effect = value * GSM("MOD_SPELL_DMG") * GSM("ADD_SPELL_DMG_MOD_STR")
				infoTable[StatLogic.Stats.SpellDamage] = infoTable[StatLogic.Stats.SpellDamage] + effect
			end
			if db.profile.showHealingFromStr then
				local effect = value * GSM("MOD_HEALING") * GSM("ADD_HEALING_MOD_STR")
				infoTable[StatLogic.Stats.HealingPower] = infoTable[StatLogic.Stats.HealingPower] + effect
			end
			-- Death Knight: Forceful Deflection - Passive
			if db.profile.showParryFromStr then
				local rating = value * GSM("ADD_PARRY_RATING_MOD_STR")
				local effect = StatLogic:GetEffectFromRating(rating, StatLogic.Stats.ParryRating, playerLevel)
				if db.profile.enableAvoidanceDiminishingReturns then
					local effectNoDR = effect
					effect = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry + effect) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry)
					processedParry = processedParry + effectNoDR
				end
				infoTable[StatLogic.Stats.Parry] = infoTable[StatLogic.Stats.Parry] + effect
			else
				local rating = value * GSM("ADD_PARRY_RATING_MOD_STR")
				local effect = StatLogic:GetEffectFromRating(rating, StatLogic.Stats.ParryRating, playerLevel)
				processedParry = processedParry + effect
			end
		elseif statID == StatLogic.Stats.Agility and db.profile.showStats then
			-------------
			-- Agility --
			-------------
			value = value * GSM("MOD_AGI")
			local attackPower = value * GSM("ADD_AP_MOD_AGI")
			self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable)
			if db.profile.showAPFromAgi then
				local effect = attackPower * GSM("MOD_AP")
				infoTable[StatLogic.Stats.AttackPower] = infoTable[StatLogic.Stats.AttackPower] + effect
			end
			if db.profile.showRAPFromAgi then
				local effect = value * GSM("ADD_RANGED_AP_MOD_AGI") * GSM("MOD_RANGED_AP")
				infoTable[StatLogic.Stats.RangedAttackPower] = infoTable[StatLogic.Stats.RangedAttackPower] + effect
			end
			if db.profile.showCritFromAgi then
				local effect = value * StatLogic:GetCritPerAgi()
				infoTable[StatLogic.Stats.MeleeCrit] = infoTable[StatLogic.Stats.MeleeCrit] + effect
			end
			if db.profile.showDodgeFromAgi then
				local effect = value * StatLogic:GetDodgePerAgi()
				infoTable[StatLogic.Stats.Dodge] = infoTable[StatLogic.Stats.Dodge] + effect
			end
			local bonusArmor = value * GSM("ADD_BONUS_ARMOR_MOD_AGI")
			self:ProcessStat(StatLogic.Stats.BonusArmor, bonusArmor, infoTable)
			if db.profile.showArmorFromAgi then
				infoTable[StatLogic.Stats.Armor] = infoTable[StatLogic.Stats.Armor] + bonusArmor
			end
			if db.profile.showHealingFromAgi then
				local effect = value * GSM("MOD_HEALING") * GSM("ADD_HEALING_MOD_AGI")
				infoTable[StatLogic.Stats.HealingPower] = infoTable[StatLogic.Stats.HealingPower] + effect
			end
		elseif statID == StatLogic.Stats.Stamina and db.profile.showStats then
			-------------
			-- Stamina --
			-------------
			value = value * GSM("MOD_STA")
			if db.profile.showHealthFromSta then
				local effect = value * GSM("ADD_HEALTH_MOD_STA") * GSM("MOD_HEALTH")
				infoTable[StatLogic.Stats.Health] = infoTable[StatLogic.Stats.Health] + effect
			end
			if db.profile.showSpellDmgFromSta then
				local effect = value * GSM("MOD_SPELL_DMG") * (GSM("ADD_SPELL_DMG_MOD_STA")
					+ GSM("ADD_SPELL_DMG_MOD_PET_STA") * GSM("MOD_PET_STA") * GSM("ADD_PET_STA_MOD_STA"))
				infoTable[StatLogic.Stats.SpellDamage] = infoTable[StatLogic.Stats.SpellDamage] + effect
			end
			-- "ADD_AP_MOD_STA" -- Hunter: Hunter vs. Wild
			if db.profile.showAPFromSta then
				local effect = value * GSM("ADD_AP_MOD_STA") * GSM("MOD_AP")
				infoTable[StatLogic.Stats.AttackPower] = infoTable[StatLogic.Stats.AttackPower] + effect
			end
		elseif statID == StatLogic.Stats.Intellect and db.profile.showStats then
			---------------
			-- Intellect --
			---------------
			value = value * GSM("MOD_INT")
			if db.profile.showManaFromInt then
				local effect = value * GSM("ADD_MANA_MOD_INT") * GSM("MOD_MANA")
				infoTable[StatLogic.Stats.Mana] = infoTable[StatLogic.Stats.Mana] + effect
			end
			if db.profile.showSpellCritFromInt then
				local effect = value * StatLogic:GetSpellCritPerInt()
				infoTable[StatLogic.Stats.SpellCrit] = infoTable[StatLogic.Stats.SpellCrit] + effect
			end
			if db.profile.showSpellDmgFromInt then
				local effect = value * GSM("MOD_SPELL_DMG") * (
					GSM("ADD_SPELL_DMG_MOD_INT")
					+ GSM("ADD_SPELL_DMG_MOD_PET_INT") * GSM("MOD_PET_INT") * GSM("ADD_PET_INT_MOD_INT")
					+ GSM("ADD_SPELL_DMG_MOD_MANA") * GSM("MOD_MANA") * GSM("ADD_MANA_MOD_INT")
				)
				infoTable[StatLogic.Stats.SpellDamage] = infoTable[StatLogic.Stats.SpellDamage] + effect
			end
			if db.profile.showHealingFromInt then
				local effect = value * GSM("MOD_HEALING") * (
					GSM("ADD_HEALING_MOD_INT")
					+ GSM("ADD_HEALING_MOD_MANA") * GSM("MOD_MANA") * GSM("ADD_MANA_MOD_INT")
				)
				infoTable[StatLogic.Stats.HealingPower] = infoTable[StatLogic.Stats.HealingPower] + effect
			end
			if db.profile.showMP5FromInt then
				local effect = value * GSM("ADD_MANA_REG_MOD_INT")
					+ value * GSM("ADD_NORMAL_MANA_REG_MOD_INT") * GSM("MOD_NORMAL_MANA_REG") * math.min(GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG"), 1)
					+ value * GSM("ADD_MANA_MOD_INT") * GSM("MOD_MANA") * GSM("ADD_MANA_REG_MOD_MANA") -- Replenishment
				infoTable[StatLogic.Stats.ManaRegen] = infoTable[StatLogic.Stats.ManaRegen] + effect
			end
			if db.profile.showMP5NCFromInt then
				local effect = value * GSM("ADD_MANA_REG_MOD_INT")
					+ value * GSM("ADD_NORMAL_MANA_REG_MOD_INT") * GSM("MOD_NORMAL_MANA_REG")
					+ value * GSM("ADD_MANA_MOD_INT") * GSM("MOD_MANA") * GSM("ADD_MANA_REG_MOD_MANA") -- Replenishment
				infoTable[StatLogic.Stats.ManaRegenNotCasting] = infoTable[StatLogic.Stats.ManaRegenNotCasting] + effect
			end
			if db.profile.showRAPFromInt then
				local effect = value * GSM("ADD_RANGED_AP_MOD_INT") * GSM("MOD_RANGED_AP")
				infoTable[StatLogic.Stats.RangedAttackPower] = infoTable[StatLogic.Stats.RangedAttackPower] + effect
			end
			if db.profile.showArmorFromInt then
				local effect = value * GSM("ADD_BONUS_ARMOR_MOD_INT")
				infoTable[StatLogic.Stats.Armor] = infoTable[StatLogic.Stats.Armor] + effect
			end
			local attackPower = value * GSM("ADD_AP_MOD_INT")
			self:ProcessStat(StatLogic.Stats.AttackPower, attackPower, infoTable)
			if db.profile.showAPFromInt then
				local effect = attackPower * GSM("MOD_AP")
				infoTable[StatLogic.Stats.AttackPower] = infoTable[StatLogic.Stats.AttackPower] + effect
			end
		elseif statID == StatLogic.Stats.Spirit and db.profile.showStats then
			------------
			-- Spirit --
			------------
			value = value * GSM("MOD_SPI")
			if db.profile.showMP5FromSpi then
				local effect = value * GSM("ADD_NORMAL_MANA_REG_MOD_SPI") * GSM("MOD_NORMAL_MANA_REG") * math.min(GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG"), 1)
				infoTable[StatLogic.Stats.ManaRegen] = infoTable[StatLogic.Stats.ManaRegen] + effect
			end
			if db.profile.showMP5NCFromSpi then
				local effect = value * GSM("ADD_NORMAL_MANA_REG_MOD_SPI") * GSM("MOD_NORMAL_MANA_REG")
				infoTable[StatLogic.Stats.ManaRegenNotCasting] = infoTable[StatLogic.Stats.ManaRegenNotCasting] + effect
			end
			if db.profile.showHP5FromSpi then
				local effect = value * GSM("ADD_NORMAL_HEALTH_REG_MOD_SPI") * GSM("MOD_NORMAL_HEALTH_REG") * GSM("ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG")
				infoTable[StatLogic.Stats.HealthRegen] = infoTable[StatLogic.Stats.HealthRegen] + effect
			end
			if db.profile.showHP5NCFromSpi then
				local effect = value * GSM("ADD_NORMAL_HEALTH_REG_MOD_SPI") * GSM("MOD_NORMAL_HEALTH_REG")
				infoTable[StatLogic.Stats.HealthRegenOutOfCombat] = infoTable[StatLogic.Stats.HealthRegenOutOfCombat] + effect
			end
			if db.profile.showSpellDmgFromSpi then
				local effect = value * GSM("ADD_SPELL_DMG_MOD_SPI") * GSM("MOD_SPELL_DMG")
				infoTable[StatLogic.Stats.SpellDamage] = infoTable[StatLogic.Stats.SpellDamage] + effect
			end
			if db.profile.showHealingFromSpi then
				local effect = value * GSM("ADD_HEALING_MOD_SPI") * GSM("MOD_HEALING")
				infoTable[StatLogic.Stats.HealingPower] = infoTable[StatLogic.Stats.HealingPower] + effect
			end
			if db.profile.showSpellHitFromSpi then
				local rating = value * GSM("ADD_SPELL_HIT_RATING_MOD_SPI")
				local effect = StatLogic:GetEffectFromRating(rating, StatLogic.Stats.SpellHitRating, playerLevel)
				infoTable[StatLogic.Stats.SpellHit] = infoTable[StatLogic.Stats.SpellHit] + effect
			end
			if db.profile.showSpellCritFromSpi then
				local rating = value * GSM("ADD_SPELL_CRIT_RATING_MOD_SPI")
				local effect = StatLogic:GetEffectFromRating(rating, StatLogic.Stats.SpellCritRating, playerLevel)
				infoTable[StatLogic.Stats.SpellCrit] = infoTable[StatLogic.Stats.SpellCrit] + effect
			end
		elseif statID == StatLogic.Stats.Defense then
			local blockChance = value * GSM("ADD_BLOCK_CHANCE_MOD_DEFENSE")
			if db.profile.showBlockChanceFromDefense then
				infoTable[StatLogic.Stats.BlockChance] = infoTable[StatLogic.Stats.BlockChance] + blockChance
			end

			local critAvoidance = value * GSM("ADD_CRIT_AVOIDANCE_MOD_DEFENSE")
			if db.profile.showCritAvoidanceFromDefense then
				infoTable[StatLogic.Stats.CritAvoidance] = infoTable[StatLogic.Stats.CritAvoidance] + critAvoidance
			end

			local dodge = value * GSM("ADD_DODGE_MOD_DEFENSE")
			if dodge > 0 then
				if db.profile.enableAvoidanceDiminishingReturns then
					dodge = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, processedDodge + dodge) - StatLogic:GetAvoidanceAfterDR(StatLogic.Stats.Dodge, processedDodge)
					processedDodge = processedDodge + dodge
				end
				if db.profile.showDodgeFromDefense then
					infoTable[StatLogic.Stats.Dodge] = infoTable[StatLogic.Stats.Dodge] + dodge
				end
			end

			local miss = value * GSM("ADD_MISS_MOD_DEFENSE")
			if miss > 0 then
				if db.profile.enableAvoidanceDiminishingReturns then
					miss = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, processedMissed + miss) - StatLogic:GetAvoidanceAfterDR(StatLogic.Stats.Miss, processedMissed)
					processedMissed = processedMissed + miss
				end
				if db.profile.showMissFromDefense then
					infoTable[StatLogic.Stats.Miss] = infoTable[StatLogic.Stats.Miss] + miss
				end
			end

			local parry = value * GSM("ADD_PARRY_MOD_DEFENSE")
			if parry > 0 then
				if db.profile.enableAvoidanceDiminishingReturns then
					parry = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, processedParry + parry) - StatLogic:GetAvoidanceAfterDR(StatLogic.Stats.Parry, processedParry)
					processedParry = processedParry + parry
				end
				if db.profile.showParryFromDefense then
					infoTable[StatLogic.Stats.Parry] = infoTable[StatLogic.Stats.Parry] + parry
				end
			end
		elseif statID == StatLogic.Stats.Armor then
			local base, bonus = StatLogic:GetArmorDistribution(link, value, color)
			value = base * GSM("MOD_ARMOR") + bonus
			self:ProcessStat(StatLogic.Stats.BonusArmor, value, infoTable)
		elseif db.profile.showAPFromArmor and statID == StatLogic.Stats.BonusArmor then
			local effect = value * GSM("ADD_AP_MOD_ARMOR") * GSM("MOD_AP")
			infoTable[StatLogic.Stats.AttackPower] = infoTable[StatLogic.Stats.AttackPower] + effect
		elseif statID == StatLogic.Stats.AttackPower then
			------------------
			-- Attack Power --
			------------------
			value = value * GSM("MOD_AP")
			if db.profile.showSpellDmgFromAP then
				local effect = value * GSM("ADD_SPELL_DMG_MOD_AP") * GSM("MOD_SPELL_DMG")
				infoTable[StatLogic.Stats.SpellDamage] = infoTable[StatLogic.Stats.SpellDamage] + effect
			end
			if db.profile.showHealingFromAP then
				local effect = value * GSM("ADD_HEALING_MOD_AP") * GSM("MOD_HEALING")
				infoTable[StatLogic.Stats.HealingPower] = infoTable[StatLogic.Stats.HealingPower] + effect
			end
		end
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

local summaryCalcData = {
	-----------
	-- Basic --
	-----------
	-- Strength - STR
	{
		option = "sumStr",
		name = StatLogic.Stats.Strength,
		func = function(sum)
			return sum[StatLogic.Stats.Strength]
		end,
	},
	-- Agility - AGI
	{
		option = "sumAgi",
		name = StatLogic.Stats.Agility,
		func = function(sum)
			return sum[StatLogic.Stats.Agility]
		end,
	},
	-- Stamina - STA
	{
		option = "sumSta",
		name = StatLogic.Stats.Stamina,
		func = function(sum)
			return sum[StatLogic.Stats.Stamina]
		end,
	},
	-- Intellect - INT
	{
		option = "sumInt",
		name = StatLogic.Stats.Intellect,
		func = function(sum)
			return sum[StatLogic.Stats.Intellect]
		end,
	},
	-- Spirit - SPI
	{
		option = "sumSpi",
		name = StatLogic.Stats.Spirit,
		func = function(sum)
			return sum[StatLogic.Stats.Spirit]
		end,
	},
	{
		option = "sumMastery",
		name = StatLogic.Stats.Mastery,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.MasteryRating], StatLogic.Stats.MasteryRating)
		end,
	},
	{
		option = "sumMasteryEffect",
		name = StatLogic.Stats.MasteryEffect,
		func = function(sum)
			return summaryFunc[StatLogic.Stats.Mastery](sum) * GSM("ADD_MASTERY_EFFECT_MOD_MASTERY")
		end,
		ispercent = true,
	},
	-- Health - HEALTH, STA
	{
		option = "sumHP",
		name = StatLogic.Stats.Health,
		func = function(sum)
			return (sum[StatLogic.Stats.Health] + (sum[StatLogic.Stats.Stamina] * GSM("ADD_HEALTH_MOD_STA"))) * GSM("MOD_HEALTH")
		end,
	},
	-- Mana - MANA, INT
	{
		option = "sumMP",
		name = StatLogic.Stats.Mana,
		func = function(sum)
			return (sum[StatLogic.Stats.Mana] + (sum[StatLogic.Stats.Intellect] * GSM("ADD_MANA_MOD_INT"))) * GSM("MOD_MANA")
		end,
	},
	-- Health Regen - HEALTH_REG
	{
		option = "sumHP5",
		name = StatLogic.Stats.HealthRegen,
		func = function(sum)
			return sum[StatLogic.Stats.HealthRegen]
				+ sum[StatLogic.Stats.Spirit] * GSM("ADD_NORMAL_HEALTH_REG_MOD_SPI") * GSM("MOD_NORMAL_HEALTH_REG") * GSM("ADD_HEALTH_REG_MOD_NORMAL_HEALTH_REG")
		end,
	},
	-- Health Regen while Out of Combat - HEALTH_REG, SPI
	{
		option = "sumHP5OC",
		name = StatLogic.Stats.HealthRegenOutOfCombat,
		func = function(sum)
			return sum[StatLogic.Stats.HealthRegen]
				+ sum[StatLogic.Stats.Spirit] * GSM("ADD_NORMAL_HEALTH_REG_MOD_SPI") * GSM("MOD_NORMAL_HEALTH_REG")
		end,
	},
	-- Mana Regen - MANA_REG, SPI, INT
	{
		option = "sumMP5",
		name = StatLogic.Stats.ManaRegen,
		func = function(sum)
			return sum[StatLogic.Stats.ManaRegen]
				+ sum[StatLogic.Stats.Intellect] * GSM("ADD_MANA_REG_MOD_INT")
				+ math.min(GSM("ADD_MANA_REG_MOD_NORMAL_MANA_REG"), 1) * GSM("MOD_NORMAL_MANA_REG") * (
					sum[StatLogic.Stats.Intellect] * GSM("ADD_NORMAL_MANA_REG_MOD_INT")
					+ sum[StatLogic.Stats.Spirit] * GSM("ADD_NORMAL_MANA_REG_MOD_SPI")
				) + summaryFunc[StatLogic.Stats.Mana](sum) * GSM("ADD_MANA_REG_MOD_MANA")
		end,
	},
	-- Mana Regen while Not casting - MANA_REG, SPI, INT
	{
		option = "sumMP5NC",
		name = StatLogic.Stats.ManaRegenNotCasting,
		func = function(sum)
			return sum[StatLogic.Stats.ManaRegen]
				+ sum[StatLogic.Stats.Intellect] * GSM("ADD_MANA_REG_MOD_INT")
				+ GSM("MOD_NORMAL_MANA_REG") * (
					sum[StatLogic.Stats.Intellect] * GSM("ADD_NORMAL_MANA_REG_MOD_INT")
					+ sum[StatLogic.Stats.Spirit] * GSM("ADD_NORMAL_MANA_REG_MOD_SPI")
				) + summaryFunc[StatLogic.Stats.Mana](sum) * GSM("ADD_MANA_REG_MOD_MANA")
		end,
	},
	---------------------
	-- Physical Damage --
	---------------------
	-- Attack Power - AP, STR, AGI
	{
		option = "sumAP",
		name = StatLogic.Stats.AttackPower,
		func = function(sum)
			return GSM("MOD_AP") * (
				-- Feral Druid Predatory Strikes
				(sum[StatLogic.Stats.FeralAttackPower] > 0 and GSM("MOD_FERAL_AP") or 1) * (
					sum[StatLogic.Stats.AttackPower]
					+ sum[StatLogic.Stats.FeralAttackPower] * GSM("ADD_AP_MOD_FERAL_AP")
				) + sum[StatLogic.Stats.Strength] * GSM("ADD_AP_MOD_STR")
				+ sum[StatLogic.Stats.Agility] * GSM("ADD_AP_MOD_AGI")
				+ sum[StatLogic.Stats.Stamina] * GSM("ADD_AP_MOD_STA")
				+ sum[StatLogic.Stats.Intellect] * GSM("ADD_AP_MOD_INT")
				+ summaryFunc[StatLogic.Stats.Armor](sum) * GSM("ADD_AP_MOD_ARMOR")
			)
		end,
	},
	-- Ranged Attack Power - RANGED_AP, AP, AGI, INT
	{
		option = "sumRAP",
		name = StatLogic.Stats.RangedAttackPower,
		func = function(sum)
			return (GSM("MOD_RANGED_AP") + GSM("MOD_AP") - 1) * (
				sum[StatLogic.Stats.RangedAttackPower]
				+ sum[StatLogic.Stats.AttackPower]
				+ sum[StatLogic.Stats.Agility] * GSM("ADD_RANGED_AP_MOD_AGI")
				+ sum[StatLogic.Stats.Intellect] * GSM("ADD_RANGED_AP_MOD_INT")
				+ sum[StatLogic.Stats.Stamina] * GSM("ADD_AP_MOD_STA")
				+ summaryFunc[StatLogic.Stats.Armor](sum) * GSM("ADD_AP_MOD_ARMOR")
			)
		end,
	},
	-- Hit Chance - MELEE_HIT_RATING, WEAPON_SKILL
	{
		option = "sumHit",
		name = StatLogic.Stats.MeleeHit,
		func = function(sum)
			return sum[StatLogic.Stats.MeleeHit]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.MeleeHitRating], StatLogic.Stats.MeleeHitRating, playerLevel)
				+ sum[StatLogic.Stats.WeaponSkill] * 0.1
		end,
		ispercent = true,
	},
	-- Hit Rating - MELEE_HIT_RATING
	{
		option = "sumHitRating",
		name = StatLogic.Stats.MeleeHitRating,
		func = function(sum)
			return sum[StatLogic.Stats.MeleeHitRating]
		end,
	},
	-- Ranged Hit Chance - MELEE_HIT_RATING, RANGED_HIT_RATING, AGI
	{
		option = "sumRangedHit",
		name = StatLogic.Stats.RangedHit,
		func = function(sum)
			return sum[StatLogic.Stats.RangedHit]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.RangedHitRating], StatLogic.Stats.RangedHitRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Ranged Hit Rating - RANGED_HIT_RATING
	{
		option = "sumRangedHitRating",
		name = StatLogic.Stats.RangedHitRating,
		func = function(sum)
			return sum[StatLogic.Stats.RangedHitRating]
		end,
	},
	-- Crit Chance - MELEE_CRIT, MELEE_CRIT_RATING, AGI
	{
		option = "sumCrit",
		name = StatLogic.Stats.MeleeCrit,
		func = function(sum)
			return sum[StatLogic.Stats.MeleeCrit]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.MeleeCritRating], StatLogic.Stats.MeleeCritRating, playerLevel)
				+ sum[StatLogic.Stats.Agility] * StatLogic:GetCritPerAgi()
		end,
		ispercent = true,
	},
	-- Crit Rating - MELEE_CRIT_RATING
	{
		option = "sumCritRating",
		name = StatLogic.Stats.MeleeCritRating,
		func = function(sum)
			return sum[StatLogic.Stats.MeleeCritRating]
		end,
	},
	-- Ranged Crit Chance - MELEE_CRIT_RATING, RANGED_CRIT_RATING, AGI
	{
		option = "sumRangedCrit",
		name = StatLogic.Stats.RangedCrit,
		func = function(sum)
			return sum[StatLogic.Stats.RangedCrit]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.RangedCritRating], StatLogic.Stats.RangedCritRating, playerLevel)
				+ sum[StatLogic.Stats.Agility] * StatLogic:GetCritPerAgi()
		end,
		ispercent = true,
	},
	-- Ranged Crit Rating - RANGED_CRIT_RATING
	{
		option = "sumRangedCritRating",
		name = StatLogic.Stats.RangedCritRating,
		func = function(sum)
			return sum[StatLogic.Stats.RangedCritRating]
		end,
	},
	-- Haste - MELEE_HASTE_RATING
	{
		option = "sumHaste",
		name = StatLogic.Stats.MeleeHaste,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.MeleeHasteRating], StatLogic.Stats.MeleeHasteRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Haste Rating - MELEE_HASTE_RATING
	{
		option = "sumHasteRating",
		name = StatLogic.Stats.MeleeHasteRating,
		func = function(sum)
			return sum[StatLogic.Stats.MeleeHasteRating]
		end,
	},
	-- Ranged Haste - RANGED_HASTE_RATING
	{
		option = "sumRangedHaste",
		name = StatLogic.Stats.RangedHaste,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.RangedHasteRating], StatLogic.Stats.RangedHasteRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Ranged Haste Rating - RANGED_HASTE_RATING
	{
		option = "sumRangedHasteRating",
		name = StatLogic.Stats.RangedHasteRating,
		func = function(sum)
			return sum[StatLogic.Stats.RangedHasteRating]
		end,
	},
	-- Expertise - EXPERTISE_RATING
	{
		option = "sumExpertise",
		name = StatLogic.Stats.Expertise,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.ExpertiseRating], StatLogic.Stats.ExpertiseRating, playerLevel)
		end,
	},
	-- Expertise Rating - EXPERTISE_RATING
	{
		option = "sumExpertiseRating",
		name = StatLogic.Stats.ExpertiseRating,
		func = function(sum)
			return sum[StatLogic.Stats.ExpertiseRating]
		end,
	},
	-- Dodge Reduction - EXPERTISE_RATING, WEAPON_SKILL
	{
		option = "sumDodgeNeglect",
		name = StatLogic.Stats.DodgeReduction,
		func = function(sum)
			local effect = StatLogic:GetEffectFromRating(sum[StatLogic.Stats.ExpertiseRating], StatLogic.Stats.ExpertiseRating, playerLevel)
			if addon.tocversion < 30000 then
				effect = floor(effect)
			end
			return effect * GSM("ADD_DODGE_REDUCTION_MOD_EXPERTISE") + sum[StatLogic.Stats.WeaponSkill] * 0.1
		end,
		ispercent = true,
	},
	-- Parry Reduction - EXPERTISE_RATING
	{
		option = "sumParryNeglect",
		name = StatLogic.Stats.ParryReduction,
		func = function(sum)
			local effect = StatLogic:GetEffectFromRating(sum[StatLogic.Stats.ExpertiseRating], StatLogic.Stats.ExpertiseRating, playerLevel)
			if addon.tocversion < 30000 then
				effect = floor(effect)
			end
			return effect * GSM("ADD_PARRY_REDUCTION_MOD_EXPERTISE")
		end,
		ispercent = true,
	},
	-- Weapon Average Damage - StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage
	{
		option = "sumWeaponAverageDamage",
		name = StatLogic.Stats.AverageWeaponDamage,
		func = function(sum)
			return sum[StatLogic.Stats.MinWeaponDamage] * GSM("ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MIN")
				+ sum[StatLogic.Stats.MaxWeaponDamage] * GSM("ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MAX")
		end,
	},
	-- Weapon DPS - DPS
	{
		option = "sumWeaponDPS",
		name = StatLogic.Stats.WeaponDPS,
		func = function(sum)
			return sum[StatLogic.Stats.WeaponDPS]
		end,
	},
	-- Ignore Armor - IGNORE_ARMOR
	{
		option = "sumIgnoreArmor",
		name = StatLogic.Stats.IgnoreArmor,
		func = function(sum)
			return sum[StatLogic.Stats.IgnoreArmor]
		end,
	},
	-- Armor Penetration - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetration",
		name = StatLogic.Stats.ArmorPenetration,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.ArmorPenetrationRating], StatLogic.Stats.ArmorPenetrationRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Armor Penetration Rating - ARMOR_PENETRATION_RATING
	{
		option = "sumArmorPenetrationRating",
		name = StatLogic.Stats.ArmorPenetrationRating,
		func = function(sum) return
			sum[StatLogic.Stats.ArmorPenetrationRating]
		end,
	},
	------------------------------
	-- Spell Damage and Healing --
	------------------------------
	-- Spell Damage - SPELL_DMG, STA, INT, SPI
	{
		option = "sumSpellDmg",
		name = StatLogic.Stats.SpellDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * (
				sum[StatLogic.Stats.SpellDamage]
				+ sum[StatLogic.Stats.Strength] * GSM("ADD_SPELL_DMG_MOD_STR")
				+ sum[StatLogic.Stats.Stamina] * (GSM("ADD_SPELL_DMG_MOD_STA") + GSM("ADD_SPELL_DMG_MOD_PET_STA") * GSM("MOD_PET_STA") * GSM("ADD_PET_STA_MOD_STA"))
				+ sum[StatLogic.Stats.Intellect] * (
					(GSM("ADD_SPELL_DMG_MOD_INT") + GSM("ADD_SPELL_DMG_MOD_PET_INT") * GSM("MOD_PET_INT") * GSM("ADD_PET_INT_MOD_INT"))
					+ GSM("ADD_SPELL_DMG_MOD_MANA") * GSM("MOD_MANA") * GSM("ADD_MANA_MOD_INT")
				) + sum[StatLogic.Stats.Spirit] * GSM("ADD_SPELL_DMG_MOD_SPI")
				+ summaryFunc[StatLogic.Stats.AttackPower](sum) * GSM("ADD_SPELL_DMG_MOD_AP")
			)
		end,
	},
	-- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	{
		option = "sumHolyDmg",
		name = StatLogic.Stats.HolyDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.HolyDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumArcaneDmg",
		name = StatLogic.Stats.ArcaneDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.ArcaneDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	{
		option = "sumFireDmg",
		name = StatLogic.Stats.FireDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.FireDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumNatureDmg",
		name = StatLogic.Stats.NatureDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.NatureDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	{
		option = "sumFrostDmg",
		name = StatLogic.Stats.FrostDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.FrostDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	{
		option = "sumShadowDmg",
		name = StatLogic.Stats.ShadowDamage,
		func = function(sum)
			return GSM("MOD_SPELL_DMG") * sum[StatLogic.Stats.ShadowDamage]
				+ summaryFunc[StatLogic.Stats.SpellDamage](sum)
		 end,
	},
	-- Healing - HEAL, AGI, STR, INT, SPI, AP
	{
		option = "sumHealing",
		name = StatLogic.Stats.HealingPower,
		func = function(sum)
			return GSM("MOD_HEALING") * (
				sum[StatLogic.Stats.HealingPower]
				+ (sum[StatLogic.Stats.Strength] * GSM("ADD_HEALING_MOD_STR"))
				+ (sum[StatLogic.Stats.Agility] * GSM("ADD_HEALING_MOD_AGI"))
				+ (sum[StatLogic.Stats.Intellect] * (
					GSM("ADD_HEALING_MOD_INT"))
					+ GSM("ADD_HEALING_MOD_MANA") * GSM("MOD_MANA") * GSM("ADD_MANA_MOD_INT")
				) + (sum[StatLogic.Stats.Spirit] * GSM("ADD_HEALING_MOD_SPI"))
				+ (summaryFunc[StatLogic.Stats.AttackPower](sum) * GSM("ADD_HEALING_MOD_AP"))
			)
		end,
	},
	-- Spell Hit Chance - SPELL_HIT_RATING
	{
		option = "sumSpellHit",
		name = StatLogic.Stats.SpellHit,
		func = function(sum)
			return sum[StatLogic.Stats.SpellHit]
				+ StatLogic:GetEffectFromRating(summaryFunc[StatLogic.Stats.SpellHitRating](sum), StatLogic.Stats.SpellHitRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Spell Hit Rating - SPELL_HIT_RATING
	{
		option = "sumSpellHitRating",
		name = StatLogic.Stats.SpellHitRating,
		func = function(sum)
			return sum[StatLogic.Stats.SpellHitRating]
				+ sum[StatLogic.Stats.Spirit] * GSM("ADD_SPELL_HIT_RATING_MOD_SPI")
		end,
	},
	-- Spell Crit Chance - SPELL_CRIT_RATING, INT
	{
		option = "sumSpellCrit",
		name = StatLogic.Stats.SpellCrit,
		func = function(sum)
			return sum[StatLogic.Stats.SpellCrit]
				+ StatLogic:GetEffectFromRating(summaryFunc[StatLogic.Stats.SpellCritRating](sum), StatLogic.Stats.SpellCritRating, playerLevel)
				+ sum[StatLogic.Stats.Intellect] * StatLogic:GetSpellCritPerInt()
		end,
		ispercent = true,
	},
	-- Spell Crit Rating - SPELL_CRIT_RATING
	{
		option = "sumSpellCritRating",
		name = StatLogic.Stats.SpellCritRating,
		func = function(sum)
			return sum[StatLogic.Stats.SpellCritRating]
				+ sum[StatLogic.Stats.Spirit] * GSM("ADD_SPELL_CRIT_RATING_MOD_SPI")
		end,
	},
	-- Spell Haste - SPELL_HASTE_RATING
	{
		option = "sumSpellHaste",
		name = StatLogic.Stats.SpellHaste,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.SpellHasteRating], StatLogic.Stats.SpellHasteRating, playerLevel)
		end,
		ispercent = true,
	},
	-- Spell Haste Rating - SPELL_HASTE_RATING
	{
		option = "sumSpellHasteRating",
		name = StatLogic.Stats.SpellHasteRating,
		func = function(sum)
			return sum[StatLogic.Stats.SpellHasteRating]
		end,
	},
	-- Spell Penetration - SPELLPEN
	{
		option = "sumPenetration",
		name = StatLogic.Stats.SpellPenetration,
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
		name = StatLogic.Stats.Armor,
		func = function(sum)
			return GSM("MOD_ARMOR") * sum[StatLogic.Stats.Armor]
				+ sum[StatLogic.Stats.BonusArmor]
				+ sum[StatLogic.Stats.Agility] * GSM("ADD_BONUS_ARMOR_MOD_AGI")
				+ sum[StatLogic.Stats.Intellect] * GSM("ADD_BONUS_ARMOR_MOD_INT")
		 end,
	},
	-- Dodge Chance Before DR - DODGE, DODGE_RATING, DEFENSE, AGI
	{
		option = "sumDodgeBeforeDR",
		name = StatLogic.Stats.DodgeBeforeDR,
		func = function(sum)
			return sum[StatLogic.Stats.Dodge]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.DodgeRating], StatLogic.Stats.DodgeRating, playerLevel)
				+ summaryFunc[StatLogic.Stats.Defense](sum) * GSM("ADD_DODGE_MOD_DEFENSE")
				+ sum[StatLogic.Stats.Agility] * StatLogic:GetDodgePerAgi()
		end,
		ispercent = true,
	},
	-- Dodge Chance
	{
		option = "sumDodge",
		name = StatLogic.Stats.Dodge,
		func = function(sum, sumType)
			local dodge = summaryFunc[StatLogic.Stats.DodgeBeforeDR](sum)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					dodge = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, dodge)
				elseif sumType == "sum" then
					dodge = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, equippedDodge + dodge) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Dodge, equippedDodge)
				end
			end
			return dodge
		 end,
		ispercent = true,
	},
	-- Dodge Rating - DODGE_RATING
	{
		option = "sumDodgeRating",
		name = StatLogic.Stats.DodgeRating,
		func = function(sum)
			return sum[StatLogic.Stats.DodgeRating]
		end,
	},
	-- Parry Chance Before DR - PARRY, PARRY_RATING, DEFENSE
	{
		option = "sumParryBeforeDR",
		name = StatLogic.Stats.ParryBeforeDR,
		func = function(sum)
			return GetParryChance() > 0 and (
				sum[StatLogic.Stats.Parry]
				+ StatLogic:GetEffectFromRating(summaryFunc[StatLogic.Stats.ParryRating](sum), StatLogic.Stats.ParryRating, playerLevel)
				+ summaryFunc[StatLogic.Stats.Defense](sum) * GSM("ADD_PARRY_MOD_DEFENSE")
			) or 0
		end,
		ispercent = true,
	},
	-- Parry Chance
	{
		option = "sumParry",
		name = StatLogic.Stats.Parry,
		func = function(sum, sumType)
			local parry = summaryFunc[StatLogic.Stats.ParryBeforeDR](sum)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					parry = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, parry)
				elseif sumType == "sum" then
					parry = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, equippedParry + parry) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Parry, equippedParry)
				end
			end
			return parry
		 end,
		ispercent = true,
	},
	-- Parry Rating - PARRY_RATING
	{
		option = "sumParryRating",
		name = StatLogic.Stats.ParryRating,
		func = function(sum)
			return sum[StatLogic.Stats.ParryRating]
				+ sum[StatLogic.Stats.Strength] * GSM("ADD_PARRY_RATING_MOD_STR")
		end,
	},
	-- Block Chance - BLOCK, BLOCK_RATING, DEFENSE
	{
		option = "sumBlock",
		name = StatLogic.Stats.BlockChance,
		func = function(sum)
			return GetBlockChance() > 0 and (
				sum[StatLogic.Stats.BlockChance]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.BlockRating], StatLogic.Stats.BlockRating, playerLevel)
				+ summaryFunc[StatLogic.Stats.Defense](sum) * GSM("ADD_BLOCK_CHANCE_MOD_DEFENSE")
				+ summaryFunc[StatLogic.Stats.MasteryEffect](sum) * GSM("ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT")
			) or 0
		end,
		ispercent = true,
	},
	-- Block Rating - BLOCK_RATING
	{
		option = "sumBlockRating",
		name = StatLogic.Stats.BlockRating,
		func = function(sum)
			return sum[StatLogic.Stats.BlockRating]
		end,
	},
	-- Block Value - BLOCK_VALUE, STR
	{
		option = "sumBlockValue",
		name = StatLogic.Stats.BlockValue,
		func = function(sum)
			return GetBlockChance() > 0 and (
				GSM("MOD_BLOCK_VALUE") * (
					sum[StatLogic.Stats.BlockValue]
					+ sum[StatLogic.Stats.Strength] * GSM("ADD_BLOCK_VALUE_MOD_STR")
				)
			) or 0
		end,
	},
	-- Hit Avoidance Before DR - DEFENSE
	{
		option = "sumHitAvoidBeforeDR",
		name = StatLogic.Stats.MissBeforeDR,
		func = function(sum)
			return summaryFunc[StatLogic.Stats.Defense](sum) * GSM("ADD_MISS_MOD_DEFENSE")
		end,
		ispercent = true,
	},
	-- Hit Avoidance
	{
		option = "sumHitAvoid",
		name = StatLogic.Stats.Miss,
		func = function(sum, sumType)
			local missed = summaryFunc[StatLogic.Stats.MissBeforeDR](sum)
			if db.profile.enableAvoidanceDiminishingReturns then
				if (sumType == "diff1") or (sumType == "diff2") then
					missed = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, missed)
				elseif sumType == "sum" then
					missed = StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, equippedMissed + missed) - StatLogic:GetAvoidanceGainAfterDR(StatLogic.Stats.Miss, equippedMissed)
				end
			end
			return missed
		 end,
		ispercent = true,
	},
	-- Defense - DEFENSE_RATING
	{
		option = "sumDefense",
		name = StatLogic.Stats.Defense,
		func = function(sum)
			return sum[StatLogic.Stats.Defense]
				+ StatLogic:GetEffectFromRating(sum[StatLogic.Stats.DefenseRating], StatLogic.Stats.DefenseRating, playerLevel)
		end,
	},
	-- Avoidance - DODGE, PARRY, MELEE_HIT_AVOID, BLOCK(Optional)
	{
		option = "sumAvoidance",
		name = StatLogic.Stats.Avoidance,
		ispercent = true,
		func = function(sum, sumType, link)
			local dodge = summaryFunc[StatLogic.Stats.Dodge](sum, sumType, link)
			local parry = summaryFunc[StatLogic.Stats.Parry](sum, sumType, link)
			local missed = summaryFunc[StatLogic.Stats.Miss](sum, sumType, link)
			local block = 0
			if db.profile.sumAvoidWithBlock then
				block = summaryFunc[StatLogic.Stats.BlockChance](sum, sumType, link)
			end
			return parry + dodge + missed + block
		end,
	},
	-- Crit Avoidance - RESILIENCE_RATING, DEFENSE
	{
		option = "sumCritAvoid",
		name = StatLogic.Stats.CritAvoidance,
		func = function(sum)
			return StatLogic:GetEffectFromRating(sum[StatLogic.Stats.ResilienceRating], StatLogic.Stats.ResilienceRating) * GSM("ADD_CRIT_AVOIDANCE_MOD_RESILIENCE")
				+ summaryFunc[StatLogic.Stats.Defense](sum) * GSM("ADD_CRIT_AVOIDANCE_MOD_DEFENSE")
		 end,
		ispercent = true,
	},
	-- Resilience - RESILIENCE_RATING
	{
		option = "sumResilience",
		name = StatLogic.Stats.ResilienceRating,
		func = function(sum)
			return sum[StatLogic.Stats.ResilienceRating]
		end,
	},
	-- Arcane Resistance - ARCANE_RES
	{
		option = "sumArcaneResist",
		name = StatLogic.Stats.ArcaneResistance,
		func = function(sum)
			return sum[StatLogic.Stats.ArcaneResistance]
		end,
	},
	-- Fire Resistance - FIRE_RES
	{
		option = "sumFireResist",
		name = StatLogic.Stats.FireResistance,
		func = function(sum)
			return sum[StatLogic.Stats.FireResistance]
		end,
	},
	-- Nature Resistance - NATURE_RES
	{
		option = "sumNatureResist",
		name = StatLogic.Stats.NatureResistance,
		func = function(sum)
			return sum[StatLogic.Stats.NatureResistance]
		end,
	},
	-- Frost Resistance - FROST_RES
	{
		option = "sumFrostResist",
		name = StatLogic.Stats.FrostResistance,
		func = function(sum)
			return sum[StatLogic.Stats.FrostResistance]
		end,
	},
	-- Shadow Resistance - SHADOW_RES
	{
		option = "sumShadowResist",
		name = StatLogic.Stats.ShadowResistance,
		func = function(sum)
			return sum[StatLogic.Stats.ShadowResistance]
		end,
	},
}

-- Build summaryFunc
for _, calcData in pairs(summaryCalcData) do
	summaryFunc[calcData.name] = calcData.func
end

local function sumSortAlphaComp(a, b)
	return a[1] < b[1]
end

local function WriteSummary(tooltip, output)
	if db.global.sumBlankLine then
		tooltip:AddLine(" ")
	end
	if db.global.sumShowTitle then
		tooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..L["Stat Summary"]..FONT_COLOR_CODE_CLOSE)
		if db.global.sumShowIcon then
			tooltip:AddTexture("Interface\\AddOns\\RatingBuster\\images\\Sigma")
		end
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

function RatingBuster:StatSummary(tooltip, link)
	-- Hide stat summary for equipped items
	if db.global.sumIgnoreEquipped and IsEquippedItem(link) then return end

	-- Show stat summary only for highest level armor type and items you can use with uncommon quality and up
	if db.global.sumIgnoreUnused then
		local _, _, itemRarity, _, _, _, _, _, inventoryType, _, classID, subclassID = GetItemInfo(link)

		-- Check rarity
		if not itemRarity or itemRarity < 2 then
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

	if db.global.sumIgnoreEnchant then
		link = StatLogic:RemoveEnchant(link)
	end
	if db.global.sumIgnoreExtraSockets then
		link = StatLogic:RemoveExtraSockets(link)
	end
	if db.global.sumIgnoreGems then
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
	if not db.global.calcSum then
		statData.sum = nil
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
	-- Apply Base Stat Mods
	for _, v in pairs(statData) do
		v[StatLogic.Stats.Strength] = (v[StatLogic.Stats.Strength] or 0) * GSM("MOD_STR")
		v[StatLogic.Stats.Agility] = (v[StatLogic.Stats.Agility] or 0) * GSM("MOD_AGI")
		v[StatLogic.Stats.Stamina] = (v[StatLogic.Stats.Stamina] or 0) * GSM("MOD_STA")
		v[StatLogic.Stats.Intellect] = (v[StatLogic.Stats.Intellect] or 0) * GSM("MOD_INT")
		v[StatLogic.Stats.Spirit] = (v[StatLogic.Stats.Spirit] or 0) * GSM("MOD_SPI")
	end

	local summary = {}
	for _, calcData in ipairs(summaryCalcData) do
		if db.profile[calcData.option] then
			local entry = {
				name = calcData.name,
				ispercent = calcData.ispercent,
			}
			for statDataType, statTable in pairs(statData) do
				entry[statDataType] = calcData.func(statTable, statDataType, link)
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
						s = ("%d"):format(s)
					elseif ispercent then
						s = ("%.2f%%"):format(s)
					else
						s = ("%.1f"):format(s)
					end
					if d1 then
						if d then
							d1 = colorNum(("%+d"):format(d1), d1)
						elseif ispercent then
							d1 = colorNum(("%+.2f%%"):format(d1), d1)
						else
							d1 = colorNum(("%+.1f"):format(d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(("%+d"):format(d2), d2)
							elseif ispercent then
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
						elseif ispercent then
							d1 = colorNum(("%+.2f%%"):format(d1), d1)
						else
							d1 = colorNum(("%+.1f"):format(d1), d1)
						end
						if d2 then
							if d then
								d2 = colorNum(("%+d"):format(d2), d2)
							elseif ispercent then
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
					elseif ispercent then
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
					elseif ispercent then
						d1 = colorNum(("%+.2f%%"):format(d1), d1)
					else
						d1 = colorNum(("%+.1f"):format(d1), d1)
					end
					if d2 then
						if d then
							d2 = colorNum(("%+d"):format(d2), d2)
						elseif ispercent then
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
				left = L[n]
				tinsert(output, {left, right})
			end
		end
	end
	-- sort alphabetically if option enabled
	if db.global.sumSortAlpha then
		tsort(output, sumSortAlphaComp)
	end
	-- Write cache
	cache[id] = output
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
		self.ProcessTooltip(GameTooltip)
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