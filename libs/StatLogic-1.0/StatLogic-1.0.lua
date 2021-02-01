--[[
Name: StatLogic-1.0
Description: A Library for stat conversion, calculation and summarization.
Revision: $Revision: 78899 $
Author: Whitetooth
Email: hotdogee [at] gmail [dot] com
LastUpdate: $Date: 2008-07-22 14:29:37 +0800 (星期二, 22 七月 2008) $
Website:
Documentation:
SVN: $URL: http://svn.wowace.com/wowace/trunk/StatLogicLib/StatLogic-1.0/StatLogic-1.0.lua $
Dependencies: AceLibrary, AceLocale-2.2, UTF8
License: LGPL v2.1
Features:
	StatConversion -
		Ratings -> Effect
		Str -> AP, Block
		Agi -> Crit, Dodge, AP, RAP, Armor
		Sta -> Health, SpellDmg(Talant)
		Int -> Mana, SpellCrit
		Spi -> MP5, HP5
		and more!
	StatMods - Get stat mods from talants and buffs for every class
	BaseStats - for all classes and levels
	ItemStatParser - Fast multi level indexing algorithm instead of calling strfind for every stat
]]

-- This library is still in early development, please consider not using this library until the documentation is writen on wowace.
-- Unless you don't mind putting up with breaking changes that may or may not happen during early development.

local MAJOR_VERSION = "StatLogic-1.0"
local MINOR_VERSION = tonumber(("$Revision: 78899 $"):sub(12, -3))

if not AceLibrary then error(MAJOR_VERSION.." requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end


---------------
-- Libraries --
---------------
-- Pattern matching
local L = AceLibrary("AceLocale-2.2"):new(MAJOR_VERSION..MINOR_VERSION)
-- Display text
local D = AceLibrary("AceLocale-2.2"):new(MAJOR_VERSION..MINOR_VERSION.."D")


-------------------
-- Set Debugging --
-------------------
local DEBUG = false
function CmdHandler()
	DEBUG = not DEBUG
end
SlashCmdList["STATLOGICDEBUG"] = CmdHandler
SLASH_STATLOGICDEBUG1 = "/sldebug";


-------------------------
-- Localization Tables --
-------------------------
local PatternLocale = {}
local DisplayLocale = {}
PatternLocale.enUS = {
	["tonumber"] = tonumber,
	--[[
	-- Item Stat Scanning Procedure
	-- Trim spaces using strtrim(text)
	-- Strip color codes
	-- 1. Fast Exclude - Exclude obvious lines that do not need to be checked
	--    Exclude a string by matching the whole string, these strings are indexed in L.Exclude.
	--    Exclude a string by looking at the first X chars, these strings are indexed in L.Exclude.
	--    Exclude lines starting with '"'. (Flavor text)
	--    Exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
	-- 2. Whole Text Lookup - Mainly used for enchants or stuff without numbers
	--    Whole strings are indexed in L.WholeTextLookup
	-- 3. Single Plus Stat Check - "+10 Spirit"
	--    String is matched with pattern L.SinglePlusStatCheck, 2 captures are returned.
	--    If a match is found, the non-number capture is looked up in L.StatIDLookup.
	-- 4. Single Equip Stat Check - "Equip: Increases attack power by 81."
	--    String is matched with pattern L.SingleEquipStatCheck, 2 captures are returned.
	--    If a match is found, the non-number capture is looked up in L.StatIDLookup.
	-- 5. Pre Scan - Short list of patterns that will be checked before going into Deep Scan.
	-- 6. Deep Scan - When all the above checks fail, we will use the Deep Scan, this is slow but only about 10% of the lines need it.
	--    Strip leading "Equip: ", "Socket Bonus: ".
	--    Strip trailing ".".
	--    Separate the string using L.DeepScanSeparators.
	--    Check if the separated strings are found in L.WholeTextLookup.
	--    Try to match each separated string to patterns in L.DeepScanPatterns in order, patterns in L.DeepScanPatterns should have less inclusive patterns listed first and more inclusive patterns listed last.
	--    If no match then separae the string using L.DeepScanWordSeparators, then check again.
	--]]
	------------------
	-- Fast Exclude --
	------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 5, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
		["Disen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
		["Durat"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		["<Made"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
		["Coold"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
		["Uniqu"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
		["Requi"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
		["\nRequ"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
		["Class"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
		["Races:"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
		["Use: "] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
		["Chanc"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
		-- Set Bonuses
		-- ITEM_SET_BONUS = "Set: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["Set: "] = true,
		["(2) S"] = true,
		["(3) S"] = true,
		["(4) S"] = true,
		["(5) S"] = true,
		["(6) S"] = true,
		["(7) S"] = true,
		["(8) S"] = true,
		-- Equip type
		["Projectile"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},
	--[[DEBUG stuff, no need to translate
	textTable = {
		"Spell Damage +6 and Spell Hit Rating +5",
		"+3 Stamina, +4 Critical Strike Rating",
		"+26 Healing Spells & 2% Reduced Threat",
		"+3 Stamina/+4 Critical Strike Rating",
		"Socket Bonus: 2 mana per 5 sec.",
		"Equip: Increases damage and healing done by magical spells and effects by up to 150.",
		"Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.",
		"Equip: Increases damage and healing done by magical spells and effects of all party members within 30 yards by up to 33.",
		"Equip: Increases healing done by magical spells and effects of all party members within 30 yards by up to 62.",
		"Equip: Increases your spell damage by up to 120 and your healing by up to 300.",
		"Equip: Restores 11 mana per 5 seconds to all party members within 30 yards.",
		"Equip: Increases healing done by spells and effects by up to 300.",
		"Equip: Increases attack power by 420 in Cat, Bear, Dire Bear, and Moonkin forms only.",
		"+10 Defense Rating/+10 Stamina/+15 Block Value", -- ZG Enchant
		"+26 Attack Power and +14 Critical Strike Rating", -- Swift Windfire Diamond ID:28556
		"+26 Healing Spells & 2% Reduced Threat", -- Bracing Earthstorm Diamond ID:25897
		"+6 Spell Damage, +5 Spell Crit Rating", -- Potent Ornate Topaz ID: 28123
		----
		"Critical Rating +6 and Dodge Rating +5", -- Assassin's Fire Opal ID:30565
		"Healing +11 and 2 mana per 5 sec.", -- Royal Tanzanite ID: 30603
	}
	--]]
	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	-- http://wow.allakhazam.com/db/enchant.html?slot=0&locale=enUS
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["Minor Wizard Oil"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
		["Lesser Wizard Oil"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
		["Wizard Oil"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
		["Brilliant Wizard Oil"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
		["Superior Wizard Oil"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
		["Blessed Wizard Oil"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

		["Minor Mana Oil"] = {["MANA_REG"] = 4}, -- ID: 20745
		["Lesser Mana Oil"] = {["MANA_REG"] = 8}, -- ID: 20747
		["Brilliant Mana Oil"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
		["Superior Mana Oil"] = {["MANA_REG"] = 14}, -- ID: 22521

		["Eternium Line"] = {["FISHING"] = 5}, --
		["Savagery"] = {["AP"] = 70}, --
		["Vitality"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
		["Soulfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["Sunfire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

		["Mithril Spurs"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["Minor Mount Speed Increase"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["Equip: Run speed increased slightly."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["Run speed increased slightly"] = {["RUN_SPEED"] = 8}, --
		["Minor Speed Increase"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
		["Minor Speed"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
		["Surefooted"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

		["Subtlety"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
		["2% Reduced Threat"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
		["Equip: Allows underwater breathing."] = false, -- [Band of Icy Depths] ID: 21526
		["Allows underwater breathing"] = false, --
		["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639
		["Immune to Disarm"] = false, --
		["Crusader"] = false, -- Enchant Crusader
		["Lifestealing"] = false, -- Enchant Crusader
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) (.-)%.?$"
	-- Stamina +19 = "^(.-) %+(%d+)%.?$"
	-- +19 耐力 = "^%+(%d+) (.-)%.?$"
	-- Some have a "." at the end of string like:
	-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
	["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
	["SingleEquipStatCheck"] = "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$",
	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before deep scan
	["PreScanPatterns"] = {
		--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
		--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
		["^(%d+) Block$"] = "BLOCK_VALUE",
		["^(%d+) Armor$"] = "ARMOR",
		["Reinforced %(%+(%d+) Armor%)"] = "ARMOR_BONUS",
		["Mana Regen (%d+) per 5 sec%.$"] = "MANA_REG",
		["^%+?%d+ %- (%d+) .-Damage$"] = "MAX_DAMAGE",
		["^%(([%d%.]+) damage per second%)$"] = "DPS",
		-- Exclude
		["^(%d+) Slot"] = false, -- Set Name (0/9)
		["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		-- Procs
		--["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond] 
		["[Ss]ometimes"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["[Ww]hen struck in combat"] = false, -- [Essence of the Pure Flame] ID: 18815
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "Equip: ", -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
	["Socket Bonus: "] = "Socket Bonus: ", -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	-- Strip trailing "."
	["."] = ".",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
	},
	["DeepScanWordSeparators"] = {
		" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
	},
	["DualStatPatterns"] = { -- all lower case
		["^%+(%d+) healing and %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^%+(%d+) healing %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects$"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-) by u?p? ?t?o? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
		"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
		"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["Your attacks ignoreof your opponent's armor"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
		["% Threat"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
		["Increases your effective stealth level"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant
		["Increases mount speed%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

		["All Stats"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["Strength"] = {"STR",},
		["Agility"] = {"AGI",},
		["Stamina"] = {"STA",},
		["Intellect"] = {"INT",},
		["Spirit"] = {"SPI",},

		["Arcane Resistance"] = {"ARCANE_RES",},
		["Fire Resistance"] = {"FIRE_RES",},
		["Nature Resistance"] = {"NATURE_RES",},
		["Frost Resistance"] = {"FROST_RES",},
		["Shadow Resistance"] = {"SHADOW_RES",},
		["Arcane Resist"] = {"ARCANE_RES",}, -- Arcane Armor Kit +8 Arcane Resist
		["Fire Resist"] = {"FIRE_RES",}, -- Flame Armor Kit +8 Fire Resist
		["Nature Resist"] = {"NATURE_RES",}, -- Frost Armor Kit +8 Frost Resist
		["Frost Resist"] = {"FROST_RES",}, -- Nature Armor Kit +8 Nature Resist
		["Shadow Resist"] = {"SHADOW_RES",}, -- Shadow Armor Kit +8 Shadow Resist
		["Shadow resistance"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
		["All Resistances"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["Resist All"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

		["Fishing"] = {"FISHING",}, -- Fishing enchant ID:846
		["Fishing Skill"] = {"FISHING",}, -- Fishing lure
		["Increased Fishing"] = {"FISHING",}, -- Equip: Increased Fishing +20.
		["Mining"] = {"MINING",}, -- Mining enchant ID:844
		["Herbalism"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["Skinning"] = {"SKINNING",}, -- Skinning enchant ID:865

		["Armor"] = {"ARMOR_BONUS",},
		["Defense"] = {"DEFENSE",},
		["Increased Defense"] = {"DEFENSE",},
		["Block"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["Block Value"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["Shield Block Value"] = {"BLOCK_VALUE",}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
		["Increases the block value of your shield"] = {"BLOCK_VALUE",},

		["Health"] = {"HEALTH",},
		["HP"] = {"HEALTH",},
		["Mana"] = {"MANA",},

		["Attack Power"] = {"AP",},
		["Increases attack power"] = {"AP",},
		["Attack Power when fighting Undead"] = {"AP_UNDEAD",},
		-- [Wristwraps of Undead Slaying] ID:23093
		["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
		["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
		["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
		["Increases attack powerwhen fighting Undead and Demons"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
		["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
		["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},
		["Ranged Attack Power"] = {"RANGED_AP",},
		["Increases ranged attack power"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

		["Health Regen"] = {"MANA_REG",},
		["Health per"] = {"HEALTH_REG",},
		["health per"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
		["Health every"] = {"MANA_REG",},
		["health every"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["your normal health regeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
		["Restoreshealth per 5 sec"] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
		["Restoreshealth every 5 sec"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["Mana Regen"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
		["Mana per"] = {"MANA_REG",},
		["mana per"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
		["Mana every"] = {"MANA_REG",},
		["mana every"] = {"MANA_REG",},
		["Mana every 5 seconds"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
		["Mana every 5 Sec"] = {"MANA_REG",}, --
		["mana every 5 sec"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
		["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
		["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
		["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
		["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
		["Restoresmana per 5 sec"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
		["Mana restored per 5 seconds"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
		["Mana Regenper 5 sec"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
		["Mana per 5 Sec"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913

		["Spell Penetration"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
		["Increases your spell penetration"] = {"SPELLPEN",},

		["Healing and Spell Damage"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
		["Damage and Healing Spells"] = {"SPELL_DMG", "HEAL",},
		["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",},
		["Spell Damage"] = {"SPELL_DMG", "HEAL",},
		["Increases damage and healing done by magical spells and effects"] = {"SPELL_DMG", "HEAL"},
		["Increases damage and healing done by magical spells and effects of all party members within 30 yards"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
		["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
		["Damage"] = {"SPELL_DMG",},
		["Increases your spell damage"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
		["Spell Power"] = {"SPELL_DMG", "HEAL",},
		["Holy Damage"] = {"HOLY_SPELL_DMG",},
		["Arcane Damage"] = {"ARCANE_SPELL_DMG",},
		["Fire Damage"] = {"FIRE_SPELL_DMG",},
		["Nature Damage"] = {"NATURE_SPELL_DMG",},
		["Frost Damage"] = {"FROST_SPELL_DMG",},
		["Shadow Damage"] = {"SHADOW_SPELL_DMG",},
		["Holy Spell Damage"] = {"HOLY_SPELL_DMG",},
		["Arcane Spell Damage"] = {"ARCANE_SPELL_DMG",},
		["Fire Spell Damage"] = {"FIRE_SPELL_DMG",},
		["Nature Spell Damage"] = {"NATURE_SPELL_DMG",},
		["Frost Spell Damage"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
		["Shadow Spell Damage"] = {"SHADOW_SPELL_DMG",},
		["Increases damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["Increases damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["Increases damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",},
		["Increases damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",},
		["Increases damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",},
		["Increases damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",},
		["Increases the damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
		["Increases the damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Added just in case
		
		["Increases damage done to Undead by magical spells and effects"] = {"SPELL_DMG_UNDEAD"}, -- [Robe of Undead Cleansing] ID:23085
		["Increases damage done to Undead by magical spells and effects.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
		["Increases damage done to Undead and Demons by magical spells and effects"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

		["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
		["Increases Healing"] = {"HEAL",},
		["Healing"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
		["healing Spells"] = {"HEAL",},
		["Damage Spells"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
		["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
		["Increases healing done"] = {"HEAL",}, -- 2.3.0
		["damage donefor all magical spells"] = {"SPELL_DMG",}, -- 2.3.0
		["Increases healing done by spells and effects"] = {"HEAL",},
		["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
		["your healing"] = {"HEAL",}, -- Atiesh

		["damage per second"] = {"DPS",},
		["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

		["Defense Rating"] = {"DEFENSE_RATING",},
		["Increases defense rating"] = {"DEFENSE_RATING",},
		["Dodge Rating"] = {"DODGE_RATING",},
		["Increases your dodge rating"] = {"DODGE_RATING",},
		["Parry Rating"] = {"PARRY_RATING",},
		["Increases your parry rating"] = {"PARRY_RATING",},
		["Shield Block Rating"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
		["Block Rating"] = {"BLOCK_RATING",},
		["Increases your block rating"] = {"BLOCK_RATING",},
		["Increases your shield block rating"] = {"BLOCK_RATING",},

		["Hit Rating"] = {"MELEE_HIT_RATING",},
		["Improves hit rating"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
		["Improves melee hit rating"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
		["Increases your hit rating"] = {"MELEE_HIT_RATING",},
		["Spell Hit"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
		["Spell Hit Rating"] = {"SPELL_HIT_RATING",},
		["Improves spell hit rating"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
		["Increases your spell hit rating"] = {"SPELL_HIT_RATING",},
		["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
		["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},

		["Crit Rating"] = {"MELEE_CRIT_RATING",},
		["Critical Rating"] = {"MELEE_CRIT_RATING",},
		["Critical Strike Rating"] = {"MELEE_CRIT_RATING",},
		["Increases your critical hit rating"] = {"MELEE_CRIT_RATING",},
		["Increases your critical strike rating"] = {"MELEE_CRIT_RATING",},
		["Improves critical strike rating"] = {"MELEE_CRIT_RATING",},
		["Improves melee critical strike rating"] = {"MELEE_CRIT_RATING",}, -- [Cloak of Darkness] ID:33122
		["Spell Critical Strike Rating"] = {"SPELL_CRIT_RATING",},
		["Spell Critical strike rating"] = {"SPELL_CRIT_RATING",},
		["Spell Critical Rating"] = {"SPELL_CRIT_RATING",},
		["Spell Crit Rating"] = {"SPELL_CRIT_RATING",},
		["Increases your spell critical strike rating"] = {"SPELL_CRIT_RATING",},
		["Increases the spell critical strike rating of all party members within 30 yards"] = {"SPELL_CRIT_RATING",},
		["Improves spell critical strike rating"] = {"SPELL_CRIT_RATING",},
		["Increases your ranged critical strike rating"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

		["Improves hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
		["Improves melee hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
		["Improves ranged hit avoidance rating"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
		["Improves spell hit avoidance rating"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
		["Resilience"] = {"RESILIENCE_RATING",},
		["Resilience Rating"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
		["Improves your resilience rating"] = {"RESILIENCE_RATING",},
		["Improves critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
		["Improves melee critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
		["Improves ranged critical avoidance rating"] = {"RANGED_CRIT_AVOID_RATING",},
		["Improves spell critical avoidance rating"] = {"SPELL_CRIT_AVOID_RATING",},

		["Haste Rating"] = {"MELEE_HASTE_RATING"},
		["Spell Haste Rating"] = {"SPELL_HASTE_RATING"},
		["Ranged Haste Rating"] = {"RANGED_HASTE_RATING"},
		["Improves haste rating"] = {"MELEE_HASTE_RATING"},
		["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
		["Improves spell haste rating"] = {"SPELL_HASTE_RATING"},
		["Improves ranged haste rating"] = {"RANGED_HASTE_RATING"},

		["Increases dagger skill rating"] = {"DAGGER_WEAPON_RATING"},
		["Increases sword skill rating"] = {"SWORD_WEAPON_RATING"}, -- [Warblade of the Hakkari] ID:19865
		["Increases Two-Handed Swords skill rating"] = {"2H_SWORD_WEAPON_RATING"},
		["Increases axe skill rating"] = {"AXE_WEAPON_RATING"},
		["Two-Handed Axe Skill Rating"] = {"2H_AXE_WEAPON_RATING"}, -- [Ethereum Nexus-Reaver] ID:30722
		["Increases two-handed axes skill rating"] = {"2H_AXE_WEAPON_RATING"},
		["Increases mace skill rating"] = {"MACE_WEAPON_RATING"},
		["Increases two-handed maces skill rating"] = {"2H_MACE_WEAPON_RATING"},
		["Increases gun skill rating"] = {"GUN_WEAPON_RATING"},
		["Increases Crossbow skill rating"] = {"CROSSBOW_WEAPON_RATING"},
		["Increases Bow skill rating"] = {"BOW_WEAPON_RATING"},
		["Increases feral combat skill rating"] = {"FERAL_WEAPON_RATING"},
		["Increases fist weapons skill rating"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
		["Increases unarmed skill rating"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
		["Increases staff skill rating"] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410
		
		["Increases your expertise rating"] = {"EXPERTISE_RATING"},
		-- Exclude
		["sec"] = false,
		["to"] = false,
		["Slot Bag"] = false,
		["Slot Quiver"] = false,
		["Slot Ammo Pouch"] = false,
		["Increases ranged attack speed"] = false, -- AV quiver
	},
}
DisplayLocale.enUS = {
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
		["THREAT_MOD"] = {"Threat(%)", "Threat(%)"},
		["STEALTH_LEVEL"] = {"Stealth Level", "Stealth"},
		["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
		["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

		["STR"] = {SPELL_STAT1_NAME, "Str"},
		["AGI"] = {SPELL_STAT2_NAME, "Agi"},
		["STA"] = {SPELL_STAT3_NAME, "Sta"},
		["INT"] = {SPELL_STAT4_NAME, "Int"},
		["SPI"] = {SPELL_STAT5_NAME, "Spi"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
		["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

		["FISHING"] = {"Fishing", "Fishing"},
		["MINING"] = {"Mining", "Mining"},
		["HERBALISM"] = {"Herbalism", "Herbalism"},
		["SKINNING"] = {"Skinning", "Skinning"},

		["BLOCK_VALUE"] = {"Block Value", "Block Value"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
		["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
		["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Undead)", "AP(Undead)"},
		["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Demon)", "AP(Demon)"},

		["HEAL"] = {"Healing", "Heal"},

		["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
		["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Undead)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
		["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Demon)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
		["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
		["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
		["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
		["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
		["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
		["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

		["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {HEALTH.." Regen", "HP5"},
		["MANA_REG"] = {MANA.." Regen", "MP5"},

		["MAX_DAMAGE"] = {"Max Damage", "Max Dmg"},
		["DPS"] = {"Damage Per Second", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"Hit Avoidance "..RATING, "Hit Avoidance "..RATING},
		["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING},
		["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
		["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
		["MELEE_CRIT_AVOID_RATING"] = {"Crit Avoidance "..RATING, "Crit Avoidance "..RATING},
		["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING},
		["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"Haste "..RATING, "Haste "..RATING}, --
		["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
		["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
		["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
		["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
		["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
		["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
		["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
		["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
		["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
		["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
		["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
		["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
		["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},
		["STAFF_WEAPON_RATING"] = {"Staff "..SKILL.." "..RATING, "Staff "..RATING}, -- Leggings of the Fang ID:10410
		--["EXPERTISE_RATING"] = {STAT_EXPERTISE.." "..RATING, STAT_EXPERTISE.." "..RATING},
		["EXPERTISE_RATING"] = {"Expertise".." "..RATING, "Expertise".." "..RATING},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." Regen (Out of combat)", "HP5(OC)"},
		["MANA_REG_NOT_CASTING"] = {MANA.." Regen (Not casting)", "MP5(NC)"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction(%)", "Crit Dmg Reduc(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
		["DEFENSE"] = {DEFENSE, "Def"},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["AVOIDANCE"] = {"Avoidance(%)", "Avoidance(%)"},
		["MELEE_HIT"] = {"Hit Chance(%)", "Hit(%)"},
		["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
		["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
		["MELEE_HIT_AVOID"] = {"Hit Avoidance(%)", "Hit Avd(%)"},
		["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit Avd(%)"},
		["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit Avd(%)"},
		["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
		["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
		["MELEE_CRIT_AVOID"] = {"Crit Avoidance(%)", "Crit Avd(%)"},
		["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Avd(%)"},
		["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Avd(%)"},
		["MELEE_HASTE"] = {"Haste(%)", "Haste(%)"}, --
		["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Haste(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
		["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Haste(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
		["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
		["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
		["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
		["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
		["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
		["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
		["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
		["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
		["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
		["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
		["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},
		["STAFF_WEAPON"] = {"Staff "..SKILL, "Staff"}, -- Leggings of the Fang ID:10410
		--["EXPERTISE"] = {STAT_EXPERTISE, STAT_EXPERTISE},
		["EXPERTISE"] = {"Expertise", "Expertise"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		-- Expertise -> Dodge Neglect, Parry Neglect
		["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
		["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
		["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
		["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
		["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"Threat", "Threat"},
		["CAST_TIME"] = {"Casting Time", "Cast Time"},
		["MANA_COST"] = {"Mana Cost", "Mana Cost"},
		["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
		["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
		["COOLDOWN"] = {"Cooldown", "CD"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
		["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
		["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
		["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
		["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
		["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
		["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
		["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
		["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
		["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
		["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
		["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
		["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
		["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
		["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
		["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
		["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
		["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
		["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
		["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
		["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
		["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
		["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
		["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
		["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
		["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
	},
}

PatternLocale.enGB = PatternLocale.enUS
DisplayLocale.enGB = DisplayLocale.enUS

-- koKR localization by fenlis
PatternLocale.koKR = {
	["tonumber"] = tonumber,
	------------------
	-- Fast Exclude --
	------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 3,
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "착용 시 귀속"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "획득 시 귀속"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "사용 시 귀속"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "퀘스트 아이템"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "귀속 아이템"; -- Item is Soulbound
		--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "푸른색 보석 홈";
		--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "얼개 보석 홈";
		--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "붉은색 보석 홈";
		--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "노란색 보석 홈";
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "퀘스트 시작 아이템"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "그 아이템은 버릴 수 없습니다."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "창조된 아이템"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "마력 추출 불가"; -- Items which cannot be disenchanted ever
		["마력 "] = true, -- ITEM_DISENCHANT_ANY_SKILL = "마력 추출 가능"; -- Items that can be disenchanted at any skill level
		-- ITEM_DISENCHANT_MIN_SKILL = "마력 추출 요구 사항: %s (%d)"; -- Minimum enchanting skill needed to disenchant
		["지속시"] = true, -- ITEM_DURATION_DAYS = "지속시간: %d일";
		["<제작"] = true, -- ITEM_CREATED_BY = "|cff00ff00<제작자: %s>|r"; -- %s is the creator of the item
		["재사용"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "재사용 대기시간: %d일";
		["고유 "] = true, -- Unique (20)
		["최소 "] = true, -- Requires Level xx
		["\n최소"] = true, -- Requires Level xx
		["직업:"] = true, -- Classes: xx
		["종족:"] = true, -- Races: xx (vendor mounts)
		["사용 "] = true, -- Use:
		["발동 "] = true, -- Chance On Hit:
		-- Set Bonuses
		-- ITEM_SET_BONUS = "세트 효과: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) 세트 효과: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["세트 "] = true,
		["(2)"] = true,
		["(3)"] = true,
		["(4)"] = true,
		["(5)"] = true,
		["(6)"] = true,
		["(7)"] = true,
		["(8)"] = true,
		-- Equip type
		["투사체"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},
	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	-- http://wow.allakhazam.com/db/enchant.html?slot=0&locale=enUS
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["최하급 마술사 오일"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
		["하급 마술사 오일"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
		["마술사 오일"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
		["반짝이는 마술사 오일"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
		["상급 마술사 오일"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
		["신성한 마술사 오일"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

		["최하급 마나 오일"] = {["MANA_REG"] = 4}, -- ID: 20745
		["하급 마나 오일"] = {["MANA_REG"] = 8}, -- ID: 20747
		["반짝이는 마나 오일"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
		["상급 마나 오일"] = {["MANA_REG"] = 14}, -- ID: 22521

		["에터니움 낚시줄"] = {["FISHING"] = 5}, --
		["전투력"] = {["AP"] = 70}, -- 전투력
		["활력"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
		["냉기의 영혼"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["태양의 불꽃"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

		["미스릴 박차"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["최하급 탈것 속도 증가"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["착용 효과: 이동 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["이동 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, --
		["하급 이동 속도 증가"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
		["하급 이동 속도"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
		["침착함"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

		["위협 수준 감소"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
		["위협 수준 +2%"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
		["착용 효과: 시전자를 물 속에서 숨쉴 수 있도록 해줍니다."] = false, -- [Band of Icy Depths] ID: 21526
		["시전자를 물 속에서 숨쉴 수 있도록 해줍니다"] = false, --
		["착용 효과: 무장해제에 면역이 됩니다."] = false, -- [Stronghold Gauntlets] ID: 12639
		["무장해제에 면역이 됩니다"] = false, --
		["성전사"] = false, -- Enchant Crusader
		["흡혈"] = false, -- Enchant Crusader
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) (.-)%.?$"
	-- Stamina +19 = "^(.-) %+(%d+)%.?$"
	-- +19 耐力 = "^%+(%d+) (.-)%.?$"
	-- Some have a "." at the end of string like:
	-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
	["SinglePlusStatCheck"] = "^(.-) ([%+%-]%d+)%.?$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
	["SingleEquipStatCheck"] = "^착용 효과: (.-) (%d+)만큼(.-)$",
	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before deep scan
	["PreScanPatterns"] = {
		--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
		--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
		["^(%d+)의 피해 방어$"] = "BLOCK_VALUE",
		["^방어도 (%d+)$"] = "ARMOR",
		["방어도 보강 %(%+(%d+)%)"] = "ARMOR_BONUS",
		["매 5초마다 (%d+)의 생명력이 회복됩니다.$"] = "HEALTH_REG",
		["매 5초마다 (%d+)의 마나가 회복됩니다.$"] = "MANA_REG",
		["^.-공격력 %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
		["^%(초당 공격력 ([%d%.]+)%)$"] = "DPS",
		-- Exclude
		["^(%d+)칸"] = false, -- Set Name (0/9)
		["^[%D ]+ %((%d+)/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		-- Procs
		["발동"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["확률로"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["가격 당했을 때"] = false, -- [Essence of the Pure Flame] ID: 18815
		["성공하면"] = false,
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "착용 효과: ",
	["Socket Bonus: "] = "보석 장착 보너스: ",
	-- Strip trailing "."
	["."] = ".",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
		" / ",
	},
	["DeepScanWordSeparators"] = {
		-- only put word separators here like "and" in english
		--" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
	},
	["DualStatPatterns"] = { -- all lower case
		["^%+(%d+) 치유량 %+(%d+) 주문 공격력$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^모든 주문 및 효과에 의한 치유량이 최대 (%d+)만큼, 공격력이 최대 (%d+)만큼 증가합니다$"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-) (%d+)만큼(.-)$", -- "xxx by up to 22 xxx" (scan first)
		"^(.-) 최대 (%d+)만큼(.-)$", -- "xxx by up to 22 xxx" (scan first)
		"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
		"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["공격 시 적의 방어도를 무시합니다"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
		["% 위협"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
		["은신 효과가 증가합니다"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		["무기 공격력"] = {"MELEE_DMG"}, -- Enchant
		["탈것의 속도가%만큼 증가합니다"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

		["모든 능력치"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["힘"] = {"STR",},
		["민첩성"] = {"AGI",},
		["체력"] = {"STA",},
		["지능"] = {"INT",},
		["정신력"] = {"SPI",},

		["비전 저항력"] = {"ARCANE_RES",},
		["화염 저항력"] = {"FIRE_RES",},
		["자연 저항력"] = {"NATURE_RES",},
		["냉기 저항력"] = {"FROST_RES",},
		["암흑 저항력"] = {"SHADOW_RES",},
		["비전 저항"] = {"ARCANE_RES",}, -- Arcane Armor Kit +8 Arcane Resist
		["화염 저항"] = {"FIRE_RES",}, -- Flame Armor Kit +8 Fire Resist
		["자연 저항"] = {"NATURE_RES",}, -- Frost Armor Kit +8 Frost Resist
		["냉기 저항"] = {"FROST_RES",}, -- Nature Armor Kit +8 Nature Resist
		["암흑 저항"] = {"SHADOW_RES",}, -- Shadow Armor Kit +8 Shadow Resist
		["암흑 저항력"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
		["모든 저항력"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["모든 저항"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

		["낚시"] = {"FISHING",}, -- Fishing enchant ID:846
		["낚시 숙련도"] = {"FISHING",}, -- Fishing lure
		["낚시 숙련도가 증가합니다"] = {"FISHING",}, -- Equip: Increased Fishing +20.
		["채광"] = {"MINING",}, -- Mining enchant ID:844
		["약초 채집"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["무두질"] = {"SKINNING",}, -- Skinning enchant ID:865

		["방어도"] = {"ARMOR_BONUS",},
		["방어 숙련"] = {"DEFENSE",},
		["방어 숙련 증가"] = {"DEFENSE",},
		["피해 방어"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["피해 방어량"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["방패의 피해 방어량이 증가합니다"] = {"BLOCK_VALUE",},

		["생명력"] = {"HEALTH",},
		["HP"] = {"HEALTH",},
		["마나"] = {"MANA",},

		["전투력"] = {"AP",},
		["전투력이 증가합니다"] = {"AP",},
		["언데드 공격 시 전투력"] = {"AP_UNDEAD",},
		-- [Wristwraps of Undead Slaying] ID:23093
		["언데드 공격 시 전투력이 증가합니다"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
		["언데드와 전투 시 전투력이 증가합니다. 또한 은빛여명회의 대리인으로서 스컬지석을 모을 수 있습니다"] = {"AP_UNDEAD",},
		["악마에 대한 전투력이 증가합니다"] = {"AP_DEMON",},
		["언데드 및 악마에 대한 전투력이 증가합니다"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
		["달빛야수 변신 상태일 때 전투력"] = {"FERAL_AP",},
		["달빛야수 변신 상태일 때 전투력이 증가합니다"] = {"FERAL_AP",},
		["원거리 전투력"] = {"RANGED_AP",},
		["원거리 전투력이 증가합니다"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

		["생명력 회복량"] = {"MANA_REG",},
		["매 초마다 (.+)의 생명력"] = {"HEALTH_REG",},
		["health per"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
		["Health every"] = {"MANA_REG",},
		["health every"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["your normal health regeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
		["매 5초마다 (.+)의 생명력"] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
		["Restoreshealth every 5 sec"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["마나 회복량"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
		["매 초마다 (.+)의 마나"] = {"MANA_REG",},
		["mana per"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
		["Mana every"] = {"MANA_REG",},
		["mana every"] = {"MANA_REG",},
		["매 5초마다 (.+)의 마나"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
		["Mana every 5 Sec"] = {"MANA_REG",}, --
		["5초당 마나 회복량"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
		["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
		["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
		["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
		["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
		["Restoresmana per 5 sec"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
		["Mana restored per 5 seconds"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
		["Mana Regenper 5 sec"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
		["Mana per 5 Sec"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913

		["주문 관통력"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
		["주문 관통력이 증가합니다"] = {"SPELLPEN",},

		["치유량 및 주문 공격력"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
		["치유 및 주문 공격력"] = {"SPELL_DMG", "HEAL",},
		["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",},
		["주문 공격력"] = {"SPELL_DMG", "HEAL",},
		["모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"},
		["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
		["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
		["공격력"] = {"SPELL_DMG",},
		["주문 공격력이 증가합니다"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
		["주문 위력"] = {"SPELL_DMG",},
		["신성 피해"] = {"HOLY_SPELL_DMG",},
		["비전 피해"] = {"ARCANE_SPELL_DMG",},
		["화염 피해"] = {"FIRE_SPELL_DMG",},
		["자연 피해"] = {"NATURE_SPELL_DMG",},
		["냉기 피해"] = {"FROST_SPELL_DMG",},
		["암흑 피해"] = {"SHADOW_SPELL_DMG",},
		["신성 주문 공격력"] = {"HOLY_SPELL_DMG",},
		["비전 주문 공격력"] = {"ARCANE_SPELL_DMG",},
		["화염 주문 공격력"] = {"FIRE_SPELL_DMG",},
		["자연 주문 공격력"] = {"NATURE_SPELL_DMG",},
		["냉기 주문 공격력"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
		["암흑 주문 공격력"] = {"SHADOW_SPELL_DMG",},
		["암흑 계열의 주문과 효과의 공격력이 증가합니다"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["냉기 계열의 주문과 효과의 공격력이 증가합니다"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["신성 계열의 주문과 효과의 공격력이 증가합니다"] = {"HOLY_SPELL_DMG",},
		["비전 계열의 주문과 효과의 공격력이 증가합니다"] = {"ARCANE_SPELL_DMG",},
		["화염 계열의 주문과 효과의 공격력이 증가합니다"] = {"FIRE_SPELL_DMG",},
		["자연 계열의 주문과 효과의 공격력이 증가합니다"] = {"NATURE_SPELL_DMG",},
		["Increases the damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
		["Increases the damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",}, -- Added just in case
		["Increases the damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Added just in case
		
		-- [Robe of Undead Cleansing] ID:23085
		["언데드에 대한 효과나 주문에 의한 피해가 증가합니다"] = {"SPELL_DMG_UNDEAD"},
		["언데드와 전투 시 모든 주문 및 효과에 의한 피해량이 증가합니다. 또한 은빛여명회의 대리인으로서 스컬지석을 모을 수 있습니다"] = {"SPELL_DMG_UNDEAD"},
		["언데드 및 악마에 대한 주문 및 효과에 의한 공격력이 증가합니다"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

		["주문 치유량"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
		["치유량 증가"] = {"HEAL",},
		["치유량"] = {"HEAL",},
		["healing Spells"] = {"HEAL",},
		["주문 공격력"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
		["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
		["모든 주문 및 효과에 의한 치유량이"] = {"HEAL",}, -- 2.3.0
		["공격력이 증가합니다"] = {"SPELL_DMG",}, -- 2.3.0
		["모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",},
		["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",}, -- Atiesh
		["your healing"] = {"HEAL",}, -- Atiesh

		["초당 공격력"] = {"DPS",},
		["초당의 피해 추가"] = {"DPS",}, -- [Thorium Shells] ID: 15977

		["방어 숙련도"] = {"DEFENSE_RATING",},
		["방어 숙련도가 증가합니다"] = {"DEFENSE_RATING",},
		["회피 숙련도"] = {"DODGE_RATING",},
		["회피 숙련도가 증가합니다."] = {"DODGE_RATING",},
		["무기 막기 숙련도"] = {"PARRY_RATING",},
		["무기 막기 숙련도가 증가합니다"] = {"PARRY_RATING",},
		["방패 막기 숙련도"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
		["방패 막기 숙련도"] = {"BLOCK_RATING",},
		["방패 막기 숙련도가 증가합니다"] = {"BLOCK_RATING",},
		["방패 막기 숙련도가 증가합니다"] = {"BLOCK_RATING",},

		["적중도"] = {"MELEE_HIT_RATING",},
		["적중도가 증가합니다"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
		["근접 적중도가 증가합니다"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
		["Increases your hit rating"] = {"MELEE_HIT_RATING",},
		["주문 적중"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
		["주문 적중도"] = {"SPELL_HIT_RATING",},
		["주문의 적중도"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
		["주문 적중도가 증가합니다"] = {"SPELL_HIT_RATING",},
		["원거리 적중도"] = {"RANGED_HIT_RATING",},
		["원거리 적중도가 증가합니다"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},

		["치명타 적중도"] = {"MELEE_CRIT_RATING",},
		["Critical Rating"] = {"MELEE_CRIT_RATING",},
		["Critical Strike Rating"] = {"MELEE_CRIT_RATING",},
		["치명타 적중도가 증가합니다"] = {"MELEE_CRIT_RATING",},
		["근접 치명타 적중도가 증가합니다"] = {"MELEE_CRIT_RATING",},
		["Improves critical strike rating"] = {"MELEE_CRIT_RATING",},
		["주문 극대화 적중도"] = {"SPELL_CRIT_RATING",},
		["주문의 극대화 적중도"] = {"SPELL_CRIT_RATING",},
		["Spell Critical Rating"] = {"SPELL_CRIT_RATING",},
		["Spell Crit Rating"] = {"SPELL_CRIT_RATING",},
		["주문의 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
		["주위 30미터 반경에 있는 모든 파티원의 주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
		["주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
		["원거리 치명타 적중도가 증가합니다"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

		["공격 회피 숙련도가 증가합니다"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
		["근접 공격 회피 숙련도가 증가합니다"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
		["원거리 공격 회피 숙련도가 증가합니다"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
		["주문 공격 회피 숙련도가 증가합니다"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
		["탄력도"] = {"RESILIENCE_RATING",},
		["탄력도"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
		["탄력도가 증가합니다"] = {"RESILIENCE_RATING",},
		["치명타 회피 숙련도가 증가합니다"] = {"MELEE_CRIT_AVOID_RATING",},
		["근접 치명타 회피 숙련도가 증가합니다"] = {"MELEE_CRIT_AVOID_RATING",},
		["원거리 치명타 회피 숙련도가 증가합니다"] = {"RANGED_CRIT_AVOID_RATING",},
		["주문 치명타 회피 숙련도가 증가합니다"] = {"SPELL_CRIT_AVOID_RATING",},

		["공격 가속도"] = {"MELEE_HASTE_RATING"},
		["주문 시전 가속도"] = {"SPELL_HASTE_RATING"},
		["원거리 공격 가속도"] = {"RANGED_HASTE_RATING"},
		["공격 가속도가 증가합니다"] = {"MELEE_HASTE_RATING"},
		["근접 공격 가속도가 증가합니다"] = {"MELEE_HASTE_RATING"},
		["주문 시전 가속도가 증가합니다"] = {"SPELL_HASTE_RATING"},
		["원거리 공격 가속도가 증가합니다"] = {"RANGED_HASTE_RATING"},

		["단검류 숙련도가 증가합니다"] = {"DAGGER_WEAPON_RATING"},
		["한손 도검류 숙련도가 증가합니다"] = {"SWORD_WEAPON_RATING"},
		["양손 도검류 숙련도가 증가합니다"] = {"2H_SWORD_WEAPON_RATING"},
		["한손 도끼류 숙련도가 증가합니다"] = {"AXE_WEAPON_RATING"},
		["양손 도끼류 숙련도가 증가합니다"] = {"2H_AXE_WEAPON_RATING"},
		["Increases two-handed axes skill rating"] = {"2H_AXE_WEAPON_RATING"},
		["한손 둔기류 숙련도가 증가합니다"] = {"MACE_WEAPON_RATING"},
		["양손 둔기류 숙련도가 증가합니다"] = {"2H_MACE_WEAPON_RATING"},
		["총기류 숙련도가 증가합니다"] = {"GUN_WEAPON_RATING"},
		["석궁류 숙련도가 증가합니다"] = {"CROSSBOW_WEAPON_RATING"},
		["활류 숙련도가 증가합니다"] = {"BOW_WEAPON_RATING"},
		["야생 전투 숙련도가 증가합니다"] = {"FERAL_WEAPON_RATING"},
		["장착 무기류 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
		["맨손 전투 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
		["지팡이류 숙련도가 증가합니다."] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410
		
		["숙련도가 증가합니다"] = {"EXPERTISE_RATING"},
		-- Exclude
		["초"] = false,
		["to"] = false,
		["칸 가방"] = false,
		["칸 화살통"] = false,
		["칸 탄환 주머니"] = false,
		["원거리 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
		["원거리 무기 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
	},
}
DisplayLocale.koKR = {
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["IGNORE_ARMOR"] = {"방어도 무시", "Ignore Armor"},
		["THREAT_MOD"] = {"위협(%)", "Threat(%)"},
		["STEALTH_LEVEL"] = {"은신 등급", "Stealth"},
		["MELEE_DMG"] = {"근접 무기 "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"탈것 속도(%)", "Mount Spd(%)"},
		["RUN_SPEED"] = {"이동 속도(%)", "Run Spd(%)"},

		["STR"] = {SPELL_STAT1_NAME, "Str"},
		["AGI"] = {SPELL_STAT2_NAME, "Agi"},
		["STA"] = {SPELL_STAT3_NAME, "Sta"},
		["INT"] = {SPELL_STAT4_NAME, "Int"},
		["SPI"] = {SPELL_STAT5_NAME, "Spi"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {"효과에 의한"..ARMOR, ARMOR.."(Bonus)"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
		["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

		["FISHING"] = {"낚시", "Fishing"},
		["MINING"] = {"채광", "Mining"},
		["HERBALISM"] = {"약초채집", "Herbalism"},
		["SKINNING"] = {"무두질", "Skinning"},

		["BLOCK_VALUE"] = {"피해 방어량", "Block Value"},

		["AP"] = {"전투력", "AP"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
		["FERAL_AP"] = {"야생 전투력", "Feral AP"},
		["AP_UNDEAD"] = {"전투력 (언데드)", "AP(Undead)"},
		["AP_DEMON"] = {"전투력 (악마)", "AP(Demon)"},

		["HEAL"] = {"치유량", "Heal"},

		["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
		["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (언데드)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
		["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (악마)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
		["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
		["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
		["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
		["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
		["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
		["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

		["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {HEALTH.." 재생", "HP5"},
		["MANA_REG"] = {MANA.." 재생", "MP5"},

		["MAX_DAMAGE"] = {"최대 공격력", "Max Dmg"},
		["DPS"] = {"초당 공격력", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"근접 공격 회피 "..RATING, "Hit Avoidance "..RATING},
		["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 공격 회피 "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING},
		["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 공격 회피 "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
		["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
		["MELEE_CRIT_AVOID_RATING"] = {"근접 치명타 공격 회피 "..RATING, "Crit Avoidance "..RATING},
		["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 공격 회피 "..RATING, PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING},
		["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 공격 회피 "..RATING, PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"가속도 "..RATING, "Haste "..RATING}, --
		["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도 "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
		["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도 "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
		["DAGGER_WEAPON_RATING"] = {"단검류 "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"도검류 "..SKILL.." "..RATING, "Sword "..RATING},
		["2H_SWORD_WEAPON_RATING"] = {"양손 도검류 "..SKILL.." "..RATING, "2H Sword "..RATING},
		["AXE_WEAPON_RATING"] = {"도끼류 "..SKILL.." "..RATING, "Axe "..RATING},
		["2H_AXE_WEAPON_RATING"] = {"양손 도끼류 "..SKILL.." "..RATING, "2H Axe "..RATING},
		["MACE_WEAPON_RATING"] = {"둔기류 "..SKILL.." "..RATING, "Mace "..RATING},
		["2H_MACE_WEAPON_RATING"] = {"양손 둔기류 "..SKILL.." "..RATING, "2H Mace "..RATING},
		["GUN_WEAPON_RATING"] = {"총기류 "..SKILL.." "..RATING, "Gun "..RATING},
		["CROSSBOW_WEAPON_RATING"] = {"석궁류 "..SKILL.." "..RATING, "Crossbow "..RATING},
		["BOW_WEAPON_RATING"] = {"활류 "..SKILL.." "..RATING, "Bow "..RATING},
		["FERAL_WEAPON_RATING"] = {"야생 "..SKILL.." "..RATING, "Feral "..RATING},
		["FIST_WEAPON_RATING"] = {"장착 무기류 "..SKILL.." "..RATING, "Unarmed "..RATING},
		["STAFF_WEAPON_RATING"] = {"지팡이류 "..SKILL.." "..RATING, "Staff "..RATING}, -- Leggings of the Fang ID:10410
		--["EXPERTISE_RATING"] = {STAT_EXPERTISE.." "..RATING, STAT_EXPERTISE.." "..RATING},
		["EXPERTISE_RATING"] = {"숙련 ".." "..RATING, "Expertise".." "..RATING},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." 재생 (비전투)", "HP5(OC)"},
		["MANA_REG_NOT_CASTING"] = {MANA.." 재생 (미시전)", "MP5(NC)"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"치명타 피해 감소(%)", "Crit Dmg Reduc(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
		["DEFENSE"] = {DEFENSE, "Def"},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["AVOIDANCE"] = {"공격 회피(%)", "Avoidance(%)"},
		["MELEE_HIT"] = {"적중률(%)", "Hit(%)"},
		["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." 적중률(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
		["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." 적중률(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
		["MELEE_HIT_AVOID"] = {"근접 공격 회피(%)", "Hit Avd(%)"},
		["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." 공격 회피(%)", PLAYERSTAT_RANGED_COMBAT.." Hit Avd(%)"},
		["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." 공격 회피(%)", PLAYERSTAT_SPELL_COMBAT.." Hit Avd(%)"},
		["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
		["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
		["MELEE_CRIT_AVOID"] = {"근접 치명타 공격 회피(%)", "Crit Avd(%)"},
		["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 공격 회피(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Avd(%)"},
		["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 공격 회피(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Avd(%)"},
		["MELEE_HASTE"] = {"가속도(%)", "Haste(%)"}, --
		["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
		["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
		["DAGGER_WEAPON"] = {"단검류 "..SKILL, "Dagger"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"도검류 "..SKILL, "Sword"},
		["2H_SWORD_WEAPON"] = {"양손 도검류 "..SKILL, "2H Sword"},
		["AXE_WEAPON"] = {"도끼류 "..SKILL, "Axe"},
		["2H_AXE_WEAPON"] = {"양손 도끼류 "..SKILL, "2H Axe"},
		["MACE_WEAPON"] = {"둔기류 "..SKILL, "Mace"},
		["2H_MACE_WEAPON"] = {"양손 둔기류 "..SKILL, "2H Mace"},
		["GUN_WEAPON"] = {"총기류 "..SKILL, "Gun"},
		["CROSSBOW_WEAPON"] = {"석궁류 "..SKILL, "Crossbow"},
		["BOW_WEAPON"] = {"활류 "..SKILL, "Bow"},
		["FERAL_WEAPON"] = {"야생 "..SKILL, "Feral"},
		["FIST_WEAPON"] = {"장착 무기류 "..SKILL, "Unarmed"},
		["STAFF_WEAPON"] = {"지팡이류 "..SKILL, "Staff"}, -- Leggings of the Fang ID:10410
		--["EXPERTISE"] = {STAT_EXPERTISE, STAT_EXPERTISE},
		["EXPERTISE"] = {"숙련 ", "Expertise"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		-- Expertise -> Dodge Neglect, Parry Neglect
		["DODGE_NEGLECT"] = {DODGE.." 무시(%)", DODGE.." Neglect(%)"},
		["PARRY_NEGLECT"] = {PARRY.." 무시(%)", PARRY.." Neglect(%)"},
		["BLOCK_NEGLECT"] = {BLOCK.." 무시(%)", BLOCK.." Neglect(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"치명타 공격력(%)", "Crit Dmg(%)"},
		["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 공격력(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
		["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 공격력(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"위협", "Threat"},
		["CAST_TIME"] = {"시전 시간", "Cast Time"},
		["MANA_COST"] = {"마나 소모량", "Mana Cost"},
		["RAGE_COST"] = {"분노 소모량", "Rage Cost"},
		["ENERGY_COST"] = {"기력 소모량", "Energy Cost"},
		["COOLDOWN"] = {"재사용 대기 시간", "CD"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
		["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
		["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
		["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
		["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
		["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
		["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
		["MOD_ARMOR"] = {"Mod 아이템에 의한 "..ARMOR.."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
		["MOD_BLOCK_VALUE"] = {"Mod 피해 방어량".."(%)", "Mod Block Value".."(%)"},
		["MOD_DMG"] = {"Mod 피해".."(%)", "Mod Dmg".."(%)"},
		["MOD_DMG_TAKEN"] = {"Mod 피해량".."(%)", "Mod Dmg Taken".."(%)"},
		["MOD_CRIT_DAMAGE"] = {"Mod 치명타 피해".."(%)", "Mod Crit Dmg".."(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod 치명타 피해량".."(%)", "Mod Crit Dmg Taken".."(%)"},
		["MOD_THREAT"] = {"Mod 위협".."(%)", "Mod Threat".."(%)"},
		["MOD_AP"] = {"Mod ".."전투력".."(%)", "Mod AP".."(%)"},
		["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." ".."전투력".."(%)", "Mod RAP".."(%)"},
		["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
		["MOD_HEALING"] = {"Mod 치유량".."(%)", "Mod Heal".."(%)"},
		["MOD_CAST_TIME"] = {"Mod 시전 시간".."(%)", "Mod Cast Time".."(%)"},
		["MOD_MANA_COST"] = {"Mod 마나 소모량".."(%)", "Mod Mana Cost".."(%)"},
		["MOD_RAGE_COST"] = {"Mod 분노 소모량".."(%)", "Mod Rage Cost".."(%)"},
		["MOD_ENERGY_COST"] = {"Mod 기력 소모량".."(%)", "Mod Energy Cost".."(%)"},
		["MOD_COOLDOWN"] = {"Mod 재사용 대기 시간".."(%)", "Mod CD".."(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"무기 "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
		["WEAPON_SKILL"] = {"무기 "..SKILL, "Weapon"..SKILL},
		["MAINHAND_WEAPON_RATING"] = {"주 장비 "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
		["OFFHAND_WEAPON_RATING"] = {"보조 장비 "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
		["RANGED_WEAPON_RATING"] = {"원거리 무기 "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
	},
}

-- zhTW localization by CuteMiyu, Ryuji
PatternLocale.zhTW = {
	["tonumber"] = tonumber,
	--["Dual Wield"] = "雙武器",
	-------------------
	-- Exclude Table --
	-------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 3, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "Meta Socket";
		--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "Red Socket";
		--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
		
		--["Disen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
		--["Durat"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		--["<Made"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
		--["Coold"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
		["裝備單一限定"] = true, -- Unique-Equipped
		[ITEM_UNIQUE] = true, -- ITEM_UNIQUE = "Unique";
		["唯一("] = true, -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)";
		["需要等"] = true, -- Requires Level xx
		["\n需要"] = true, -- Requires Level xx
		["需要 "] = true, -- Requires Level xx
		["需要騎"] = true, -- Requires Level xx
		["職業:"] = true, -- Classes: xx
		["種族:"] = true, -- Races: xx (vendor mounts)
		["使用:"] = true, -- Use:
		["擊中時"] = true, -- Chance On Hit:
		["需要鑄"] = true,
		["需要影"] = true,
		["需要月"] = true,
		["需要魔"] = true,
		-- Set Bonuses
		-- ITEM_SET_BONUS = "Set: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["套裝:"] = true,
		["(2)"] = true,
		["(3)"] = true,
		["(4)"] = true,
		["(5)"] = true,
		["(6)"] = true,
		["(7)"] = true,
		["(8)"] = true,
		-- Equip type
		["彈藥"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},
	--[[
	textTable = {
		"+6法術傷害及+5法術命中等級",
		"+3  耐力, +4 致命一擊等級",
		"++26 治療法術 & 降低2% 威脅值",
		"+3 耐力/+4 致命一擊等級",
		"插槽加成:每5秒+2法力",
		"裝備： 使所有法術和魔法效果所造成的傷害和治療效果提高最多150點。",
		"裝備： 使半徑30碼範圍內所有小隊成員的法術致命一擊等級提高28點。",
		"裝備： 使30碼範圍內的所有隊友提高所有法術和魔法效果所造成的傷害和治療效果，最多33點。",
		"裝備： 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果提高最多62點。",
		"裝備： 使你的法術傷害提高最多120點，以及你的治療效果最多300點。",
		"裝備： 使周圍半徑30碼範圍內的隊友每5秒恢復11點法力。",
		"裝備： 使法術所造成的治療效果提高最多300點。",
		"裝備： 在獵豹、熊、巨熊和梟獸形態下的攻擊強度提高420點。",
		-- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		-- "+26 Attack Power and +14 Critical Strike Rating": Swift Windfire Diamond ID:28556
		"+26治療和+9法術傷害及降低2%威脅值", --: Bracing Earthstorm Diamond ID:25897
		-- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		----
		-- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
		-- "Healing +11 and 2 mana per 5 sec.": Royal Tanzanite ID: 30603
	}
	--]]
	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["初級巫師之油"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
		["次級巫師之油"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
		["巫師之油"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
		["卓越巫師之油"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
		["超強巫師之油"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
		["受祝福的巫師之油"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

		["初級法力之油"] = {["MANA_REG"] = 4}, --
		["次級法力之油"] = {["MANA_REG"] = 8}, --
		["卓越法力之油"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --
		["超強法力之油"] = {["MANA_REG"] = 14}, --

		["恆金漁線釣魚"] = {["FISHING"] = 5}, --
		["兇蠻"] = {["AP"] = 70}, --
		["活力"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
		["靈魂冰霜"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["烈日火焰"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

		["秘銀馬刺"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["坐騎移動速度略微提升"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["裝備：略微提高移動速度。"] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["略微提高移動速度"] = {["RUN_SPEED"] = 8}, --
		["略微提高奔跑速度"] = {["RUN_SPEED"] = 8}, --
		["移動速度略微提升"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
		["初級速度"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
		["穩固"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954 

		["狡詐"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
		["威脅值降低2%"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
		["裝備: 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
		["使你可以在水下呼吸"] = false, --
		["裝備: 免疫繳械。"] = false, -- [Stronghold Gauntlets] ID: 12639
		["免疫繳械"] = false, --
		["十字軍"] = false, -- Enchant Crusader
		["生命偷取"] = false, -- Enchant Crusader
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
	-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
	-- +19 耐力 = "^%+(%d+) (.-)$"
	--["SinglePlusStatCheck"] = "^%+(%d+) ([%a ]+%a)$",
	["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
	--裝備: 提高法術命中等級28點
	--裝備: 使所有法術和魔法效果所造成的傷害和治療效果提高最多50點。
	--"裝備： (.-)提高(最多)?(%d+)(點)?(.-)。$",
	-- 用\230?\156?\128?\229?\164?\154?(%d+)\233?\187?\158?並不安全
	["SingleEquipStatCheck"] = "裝備: (.-)(%d+)點(.-)。$",
	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before deep scan
	["PreScanPatterns"] = {
		--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
		--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
		["^(%d+)格擋$"] = "BLOCK_VALUE",
		["^(%d+)點護甲$"] = "ARMOR",
		["強化護甲 %+(%d+)"] = "ARMOR_BONUS",
		["^%+?%d+ %- (%d+).-傷害$"] = "MAX_DAMAGE",
		["^%(每秒傷害([%d%.]+)%)$"] = "DPS",
		-- Exclude
		["^(%d+)格.-包"] = false, -- # of slots and bag type
		["^(%d+)格.-袋"] = false, -- # of slots and bag type
		["^(%d+)格容器"] = false, -- # of slots and bag type
		["^.+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		-- Procs
		["機率"] = false, --[挑戰印記] ID:27924
		["有機會"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["有可能"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["命中時"] = false, -- [黑色摧毀者手套] ID:22194
		["被擊中之後"] = false, -- [Essence of the Pure Flame] ID: 18815
		["在你殺死一個敵人"] = false, -- [注入精華的蘑菇] ID:28109
		["每當你的"] = false, -- [電光相容器] ID: 28785
		["被擊中時"] = false, -- 
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "裝備: ", -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
	["Socket Bonus: "] = "插槽加成:", -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	-- Strip trailing "."
	["."] = "。",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"。", -- "裝備： 對不死生物的攻擊強度提高$s1點。同時也可為銀色黎明收集天譴石。": 黎明聖印
	},
	["DeepScanWordSeparators"] = {
		"及", "和", "並", "，" -- [發光的暗影卓奈石] ID:25894 "+24攻擊強度及略微提高奔跑速度", [刺客的火焰蛋白石] ID:30565 "+6致命一擊等級及+5閃躲等級"
	},
	["DualStatPatterns"] = { -- all lower case
		["^%+(%d+)治療和%+(%d+)法術傷害$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^%+(%d+)治療和%+(%d+)法術傷害及"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^使法術和魔法效果所造成的治療效果提高最多(%d+)點，法術傷害提高最多(%d+)點$"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-)提高最多([%d%.]+)點(.-)$", -- 
		"^(.-)提高最多([%d%.]+)(.-)$", -- 
		"^(.-)，最多([%d%.]+)點(.-)$", -- 
		"^(.-)，最多([%d%.]+)(.-)$", -- 
		"^(.-)最多([%d%.]+)點(.-)$", -- 
		"^(.-)最多([%d%.]+)(.-)$", -- 
		"^(.-)提高([%d%.]+)點(.-)$", -- 
		"^(.-)提高([%d%.]+)(.-)$", -- 
		"^(.-)([%d%.]+)點(.-)$", -- 
		"^(.-) ?([%+%-][%d%.]+) ?點(.-)$", -- 
		"^(.-) ?([%+%-][%d%.]+) ?(.-)$", -- 
		"^(.-) ?([%d%.]+) ?點(.-)$", -- 
		"^(.-) ?([%d%.]+) ?(.-)$", -- 
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		--["%昏迷抗性"] = {},
		["你的攻擊無視目標點護甲值"] = {"IGNORE_ARMOR"},
		["使你的有效潛行等級提高"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		["潛行"] = {"STEALTH_LEVEL"}, -- Cloak Enchant
		["武器傷害"] = {"MELEE_DMG"}, -- Enchant
		["使坐騎速度提高%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

		["所有屬性"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["力量"] = {"STR",},
		["敏捷"] = {"AGI",},
		["耐力"] = {"STA",},
		["智力"] = {"INT",},
		["精神"] = {"SPI",},

		["秘法抗性"] = {"ARCANE_RES",},
		["火焰抗性"] = {"FIRE_RES",},
		["自然抗性"] = {"NATURE_RES",},
		["冰霜抗性"] = {"FROST_RES",},
		["暗影抗性"] = {"SHADOW_RES",},
		["陰影抗性"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
		["所有抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["全部抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["抵抗全部"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["點所有魔法抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",}, -- [鋸齒黑曜石之盾] ID:22198

		["釣魚"] = {"FISHING",}, -- Fishing enchant ID:846
		["釣魚技能"] = {"FISHING",}, -- Fishing lure
		["使釣魚技能"] = {"FISHING",}, -- Equip: Increased Fishing +20.
		["採礦"] = {"MINING",}, -- Mining enchant ID:844
		["草藥學"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["剝皮"] = {"SKINNING",}, -- Skinning enchant ID:865

		["護甲"] = {"ARMOR_BONUS",},
		["護甲值"] = {"ARMOR_BONUS",},
		["強化護甲"] = {"ARMOR_BONUS",},
		["防禦"] = {"DEFENSE",},
		["增加防禦"] = {"DEFENSE",},
		["格擋"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["格擋值"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["提高格擋值"] = {"BLOCK_VALUE",},
		["使你盾牌的格擋值"] = {"BLOCK_VALUE",},

		["生命力"] = {"HEALTH",},
		["法力"] = {"MANA",},

		["攻擊強度"] = {"AP",},
		["使攻擊強度"] = {"AP",},
		["提高攻擊強度"] = {"AP",},
		["對不死生物的攻擊強度"] = {"AP_UNDEAD",}, -- [黎明聖印] ID:13209 -- [弒妖裹腕] ID:23093
		["對不死生物和惡魔的攻擊強度"] = {"AP_UNDEAD", "AP_DEMON",}, -- [勇士徽章] ID:23206
		["對惡魔的攻擊強度"] = {"AP_DEMON",},
		["在獵豹、熊、巨熊和梟獸形態下的攻擊強度"] = {"FERAL_AP",}, -- Atiesh ID:22632
		["在獵豹、熊、巨熊還有梟獸形態下的攻擊強度"] = {"FERAL_AP",}, -- 
		["遠程攻擊強度"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

		["每5秒恢復生命力"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["一般的生命力恢復速度"] = {"HEALTH_REG",}, -- [Demons Blood] ID: 10779
		
		["每5秒法力"] = {"MANA_REG",}, --
		["每5秒恢復法力"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
		["每五秒恢復法力"] = {"MANA_REG",}, -- 長者之XXX
		["法力恢復"] = {"MANA_REG",}, --
		["使周圍半徑30碼範圍內的隊友每5秒恢復法力"] = {"MANA_REG",}, --

		["法術穿透"] = {"SPELLPEN",},
		["法術穿透力"] = {"SPELLPEN",},
		["使你的法術穿透力"] = {"SPELLPEN",},
		
		["法術傷害和治療"] = {"SPELL_DMG", "HEAL",},
		["治療和法術傷害"] = {"SPELL_DMG", "HEAL",},
		["法術傷害"] = {"SPELL_DMG", "HEAL",},
		["使法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"},
		["使所有法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"},
		["使所有法術和魔法效果所造成的傷害和治療效果提高最多"] = {"SPELL_DMG", "HEAL"},
		["使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"}, -- Atiesh, ID: 22630
		--StatLogic:GetSum("22630")
		--SetTip("22630")
		-- Atiesh ID:22630, 22631, 22632, 22589
				--裝備: 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的傷害和治療效果提高最多33點。 -- 22630 -- 2.1.0
				--裝備: 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果提高最多62點。 -- 22631
				--裝備: 使半徑30碼範圍內所有小隊成員的法術致命一擊等級提高28點。 -- 22589
				--裝備: 使周圍半徑30碼範圍內的隊友每5秒恢復11點法力。
		["使你的法術傷害"] = {"SPELL_DMG",}, -- Atiesh ID:22631
		["傷害"] = {"SPELL_DMG",},
		["法術能量"] = {"SPELL_DMG", "HEAL" },
		["神聖傷害"] = {"HOLY_SPELL_DMG",},
		["秘法傷害"] = {"ARCANE_SPELL_DMG",},
		["火焰傷害"] = {"FIRE_SPELL_DMG",},
		["自然傷害"] = {"NATURE_SPELL_DMG",},
		["冰霜傷害"] = {"FROST_SPELL_DMG",},
		["暗影傷害"] = {"SHADOW_SPELL_DMG",},
		["神聖法術傷害"] = {"HOLY_SPELL_DMG",},
		["秘法法術傷害"] = {"ARCANE_SPELL_DMG",},
		["火焰法術傷害"] = {"FIRE_SPELL_DMG",},
		["自然法術傷害"] = {"NATURE_SPELL_DMG",},
		["冰霜法術傷害"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
		["暗影法術傷害"] = {"SHADOW_SPELL_DMG",},
		["使秘法法術和效果所造成的傷害"] = {"ARCANE_SPELL_DMG",},
		["使火焰法術和效果所造成的傷害"] = {"FIRE_SPELL_DMG",},
		["使冰霜法術和效果所造成的傷害"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["使神聖法術和效果所造成的傷害"] = {"HOLY_SPELL_DMG",},
		["使自然法術和效果所造成的傷害"] = {"NATURE_SPELL_DMG",},
		["使暗影法術和效果所造成的傷害"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		
		-- [Robe of Undead Cleansing] ID:23085
		["使魔法和法術效果對不死生物造成的傷害"] = {"SPELL_DMG_UNDEAD",}, -- [黎明符文] ID:19812
		["提高所有法術和效果對不死生物所造成的傷害"] = {"SPELL_DMG_UNDEAD",}, -- [淨妖長袍] ID:23085
		["提高法術和魔法效果對不死生物和惡魔所造成的傷害"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON",}, -- [勇士徽章] ID:23207

		["你的治療效果"] = {"HEAL",}, -- Atiesh ID:22631
		["治療法術"] = {"HEAL",}, -- +35 Healing Glove Enchant
		["治療效果"] = {"HEAL",}, -- [聖使祝福手套] Socket Bonus
		["治療"] = {"HEAL",},
		["神聖效果"] = {"HEAL",},-- Enchant Ring - Healing Power
		["使法術所造成的治療效果"] = {"HEAL",},
		["使法術和魔法效果所造成的治療效果"] = {"HEAL",},
		["使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果"] = {"HEAL",}, -- Atiesh, ID: 22631

		["每秒傷害"] = {"DPS",},
		["每秒傷害提高"] = {"DPS",}, -- [Thorium Shells] ID: 15997

		["防禦等級"] = {"DEFENSE_RATING",},
		["提高防禦等級"] = {"DEFENSE_RATING",},
		["提高你的防禦等級"] = {"DEFENSE_RATING",},
		["使防禦等級"] = {"DEFENSE_RATING",},
		["使你的防禦等級"] = {"DEFENSE_RATING",},
		["閃躲等級"] = {"DODGE_RATING",},
		["提高閃躲等級"] = {"DODGE_RATING",},
		["提高你的閃躲等級"] = {"DODGE_RATING",},
		["使閃躲等級"] = {"DODGE_RATING",},
		["使你的閃躲等級"] = {"DODGE_RATING",},
		["招架等級"] = {"PARRY_RATING",},
		["提高招架等級"] = {"PARRY_RATING",},
		["提高你的招架等級"] = {"PARRY_RATING",},
		["使招架等級"] = {"PARRY_RATING",},
		["使你的招架等級"] = {"PARRY_RATING",},
		["格擋機率等級"] = {"BLOCK_RATING",},
		["提高格擋機率等級"] = {"BLOCK_RATING",},
		["提高你的格擋機率等級"] = {"BLOCK_RATING",},
		["使格擋機率等級"] = {"BLOCK_RATING",},
		["使你的格擋機率等級"] = {"BLOCK_RATING",},
		["格擋等級"] = {"BLOCK_RATING",},
		["提高格擋等級"] = {"BLOCK_RATING",},
		["提高你的格擋等級"] = {"BLOCK_RATING",},
		["使格擋等級"] = {"BLOCK_RATING",},
		["使你的格擋等級"] = {"BLOCK_RATING",},
		["盾牌格擋等級"] = {"BLOCK_RATING",},
		["提高盾牌格擋等級"] = {"BLOCK_RATING",},
		["提高你的盾牌格擋等級"] = {"BLOCK_RATING",},
		["使盾牌格擋等級"] = {"BLOCK_RATING",},
		["使你的盾牌格擋等級"] = {"BLOCK_RATING",},

		["命中等級"] = {"MELEE_HIT_RATING",},
		["提高命中等級"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
		["提高近戰命中等級"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
		["使你的命中等級"] = {"MELEE_HIT_RATING",},
		["法術命中等級"] = {"SPELL_HIT_RATING",},
		["提高法術命中等級"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
		["使你的法術命中等級"] = {"SPELL_HIT_RATING",},
		["遠程命中等級"] = {"RANGED_HIT_RATING",},
		["提高遠距命中等級"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		["使你的遠程命中等級"] = {"RANGED_HIT_RATING",},

		["致命一擊"] = {"MELEE_CRIT_RATING",}, -- ID:31868
		["致命一擊等級"] = {"MELEE_CRIT_RATING",},
		["提高致命一擊等級"] = {"MELEE_CRIT_RATING",},
		["使你的致命一擊等級"] = {"MELEE_CRIT_RATING",},
		["近戰致命一擊等級"] = {"MELEE_CRIT_RATING",},
		["提高近戰致命一擊等級"] = {"MELEE_CRIT_RATING",}, -- [屠殺者腰帶] ID:21639
		["使你的近戰致命一擊等級"] = {"MELEE_CRIT_RATING",},
		["法術致命一擊等級"] = {"SPELL_CRIT_RATING",},
		["提高法術致命一擊等級"] = {"SPELL_CRIT_RATING",}, -- [伊利達瑞的復仇] ID:28040
		["使你的法術致命一擊等級"] = {"SPELL_CRIT_RATING",},
		["使半徑30碼範圍內所有小隊成員的法術致命一擊等級"] = {"SPELL_CRIT_RATING",}, -- Atiesh, ID: 22589
		["遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},
		["提高遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},
		["使你的遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},

		["提高命中迴避率"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING, Necklace of Trophies ID: 31275 (Patch 2.0.10 changed it to Hit Rating)
		["提高近戰命中迴避率"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
		["提高遠距命中迴避率"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
		["提高法術命中迴避率"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
		["韌性"] = {"RESILIENCE_RATING",},
		["韌性等級"] = {"RESILIENCE_RATING",},
		["使你的韌性等級"] = {"RESILIENCE_RATING",},
		["提高致命一擊等級迴避率"] = {"MELEE_CRIT_AVOID_RATING",},
		["提高近戰致命一擊等級迴避率"] = {"MELEE_CRIT_AVOID_RATING",},
		["提高遠距致命一擊等級迴避率"] = {"RANGED_CRIT_AVOID_RATING",},
		["提高法術致命一擊等級迴避率"] = {"SPELL_CRIT_AVOID_RATING",},

		["加速等級"] = {"MELEE_HASTE_RATING"}, -- Enchant Gloves
		["攻擊速度"] = {"MELEE_HASTE_RATING"},
		["攻擊速度等級"] = {"MELEE_HASTE_RATING"},
		["提高加速等級"] = {"MELEE_HASTE_RATING"},
		["提高近戰加速等級"] = {"MELEE_HASTE_RATING"},
		["法術加速等級"] = {"SPELL_HASTE_RATING"},
		["提高法術加速等級"] = {"SPELL_HASTE_RATING"},
		["遠程攻擊加速等級"] = {"RANGED_HASTE_RATING"},
		["提高遠程攻擊加速等級"] = {"RANGED_HASTE_RATING"},

		["使匕首技能等級"] = {"DAGGER_WEAPON_RATING"},
		["匕首武器技能等級"] = {"DAGGER_WEAPON_RATING"},
		["使劍類技能等級"] = {"SWORD_WEAPON_RATING"},
		["劍類武器技能等級"] = {"SWORD_WEAPON_RATING"},
		["使單手劍技能等級"] = {"SWORD_WEAPON_RATING"},
		["單手劍武器技能等級"] = {"SWORD_WEAPON_RATING"},
		["使雙手劍技能等級"] = {"2H_SWORD_WEAPON_RATING"},
		["雙手劍武器技能等級"] = {"2H_SWORD_WEAPON_RATING"},
		["使斧類技能等級"] = {"AXE_WEAPON_RATING"},
		["斧類武器技能等級"] = {"AXE_WEAPON_RATING"},
		["使單手斧技能等級"] = {"AXE_WEAPON_RATING"},
		["單手斧武器技能等級"] = {"AXE_WEAPON_RATING"},
		["使雙手斧技能等級"] = {"2H_AXE_WEAPON_RATING"},
		["雙手斧武器技能等級"] = {"2H_AXE_WEAPON_RATING"},
		["使錘類技能等級"] = {"MACE_WEAPON_RATING"},
		["錘類武器技能等級"] = {"MACE_WEAPON_RATING"},
		["使單手錘技能等級"] = {"MACE_WEAPON_RATING"},
		["單手錘武器技能等級"] = {"MACE_WEAPON_RATING"},
		["使雙手錘技能等級"] = {"2H_MACE_WEAPON_RATING"},
		["雙手錘武器技能等級"] = {"2H_MACE_WEAPON_RATING"},
		["使槍械技能等級"] = {"GUN_WEAPON_RATING"},
		["槍械武器技能等級"] = {"GUN_WEAPON_RATING"},
		["使弩技能等級"] = {"CROSSBOW_WEAPON_RATING"},
		["弩武器技能等級"] = {"CROSSBOW_WEAPON_RATING"},
		["使弓箭技能等級"] = {"BOW_WEAPON_RATING"},
		["弓箭武器技能等級"] = {"BOW_WEAPON_RATING"},
		["使野性戰鬥技巧等級"] = {"FERAL_WEAPON_RATING"},
		["野性戰鬥技巧等級"] = {"FERAL_WEAPON_RATING"},
		["使拳套技能等級"] = {"FIST_WEAPON_RATING"},
		["拳套武器技能等級"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
		
		["使你的熟練等級提高"] = {"EXPERTISE_RATING"},
		-- Exclude
		["秒"] = false,
		--["to"] = false,
		["格容器"] = false,
		["格箭袋"] = false,
		["格彈藥袋"] = false,
		["遠程攻擊速度%"] = false, -- AV quiver
	},
}
DisplayLocale.zhTW = {
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["IGNORE_ARMOR"] = {"無視護甲", "無視護甲"},
		["THREAT_MOD"] = {"威脅(%)", "威脅(%)"},
		["STEALTH_LEVEL"] = {"偷竊等級", "偷竊"},
		["MELEE_DMG"] = {"近戰傷害", "近戰"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"騎乘速度(%)", "騎速(%)"},
		["RUN_SPEED"] = {"奔跑速度(%)", "跑速(%)"},

		["STR"] = {SPELL_STAT1_NAME, "力量"},
		["AGI"] = {SPELL_STAT2_NAME, "敏捷"},
		["STA"] = {SPELL_STAT3_NAME, "耐力"},
		["INT"] = {SPELL_STAT4_NAME, "智力"},
		["SPI"] = {SPELL_STAT5_NAME, "精神"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {"裝甲加成", "裝甲加成"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "火抗"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "自抗"},
		["FROST_RES"] = {RESISTANCE4_NAME, "冰抗"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "暗抗"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "秘抗"},

		["FISHING"] = {"釣魚", "釣魚"},
		["MINING"] = {"採礦", "採礦"},
		["HERBALISM"] = {"草藥", "草藥"},
		["SKINNING"] = {"剝皮", "剝皮"},

		["BLOCK_VALUE"] = {"格擋值", "格擋值"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "攻擊強度"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "遠攻強度"},
		["FERAL_AP"] = {"野性攻擊強度", "野性強度"},
		["AP_UNDEAD"] = {"攻擊強度(不死)", "攻擊強度(不死)"},
		["AP_DEMON"] = {"攻擊強度(惡魔)", "攻擊強度(惡魔)"},

		["HEAL"] = {"法術治療", "治療"},

		["SPELL_DMG"] = {"法術傷害", "法傷"},
		["SPELL_DMG_UNDEAD"] = {"法術傷害(不死)", "法傷(不死)"},
		["SPELL_DMG_DEMON"] = {"法術傷害(惡魔)", "法傷(惡魔)"},
		["HOLY_SPELL_DMG"] = {"神聖法術傷害", "神聖法傷"},
		["FIRE_SPELL_DMG"] = {"火焰法術傷害", "火焰法傷"},
		["NATURE_SPELL_DMG"] = {"自然法術傷害", "自然法傷"},
		["FROST_SPELL_DMG"] = {"冰霜法術傷害", "冰霜法傷"},
		["SHADOW_SPELL_DMG"] = {"暗影法術傷害", "暗影法傷"},
		["ARCANE_SPELL_DMG"] = {"秘法法術傷害", "秘法法傷"},

		["SPELLPEN"] = {"法術穿透", SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {"生命恢復", "HP5"},
		["MANA_REG"] = {"法力恢復", "MP5"},

		["MAX_DAMAGE"] = {"最大傷害", "大傷"},
		["DPS"] = {"每秒傷害", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {"遠程命中等級", "遠程命中等級"}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {"法術命中等級", "法術命中等級"}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"避免命中等級", "避免命中等級"},
		["RANGED_HIT_AVOID_RATING"] = {"避免遠程命中等級", "避免遠程命中等級"},
		["SPELL_HIT_AVOID_RATING"] = {"避免法術命中等級", "避免法術命中等級"},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {"遠程致命等級", "遠程致命等級"},
		["SPELL_CRIT_RATING"] = {"法術致命等級", "法術致命等級"},
		["MELEE_CRIT_AVOID_RATING"] = {"避免致命等級", "避免致命等級"},
		["RANGED_CRIT_AVOID_RATING"] = {"避免遠程致命等級", "避免遠程致命等級"},
		["SPELL_CRIT_AVOID_RATING"] = {"避免法術致命等級", "避免法術致命等級"},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"攻擊加速等級", "攻擊加速等級"}, --
		["RANGED_HASTE_RATING"] = {"遠程加速等級", "遠程加速等級"},
		["SPELL_HASTE_RATING"] = {"法術加速等級", "法術加速等級"},
		["DAGGER_WEAPON_RATING"] = {"匕首技能等級", "匕首等級"}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"劍技能等級", "劍等級"},
		["2H_SWORD_WEAPON_RATING"] = {"雙手劍技能等級", "雙手劍等級"},
		["AXE_WEAPON_RATING"] = {"斧技能等級", "斧等級"},
		["2H_AXE_WEAPON_RATING"] = {"雙手斧技能等級", "雙手斧等級"},
		["MACE_WEAPON_RATING"] = {"鎚技能等級", "鎚等級"},
		["2H_MACE_WEAPON_RATING"] = {"雙手鎚技能等級", "雙手鎚等級"},
		["GUN_WEAPON_RATING"] = {"槍械技能等級", "槍械等級"},
		["CROSSBOW_WEAPON_RATING"] = {"弩技能等級", "弩等級"},
		["BOW_WEAPON_RATING"] = {"弓技能等級", "弓等級"},
		["FERAL_WEAPON_RATING"] = {"野性技能等級", "野性等級"},
		["FIST_WEAPON_RATING"] = {"徒手技能等級", "徒手等級"},
		["STAFF_WEAPON_RATING"] = {"法杖技能等級", "法杖等級"}, -- Leggings of the Fang ID:10410
		--["EXPERTISE_RATING"] = {STAT_EXPERTISE.." "..RATING, STAT_EXPERTISE.." "..RATING},
		["EXPERTISE_RATING"] = {"熟練等級", "熟練等級"},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {"一般回血", "一般回血"},
		["MANA_REG_NOT_CASTING"] = {"一般回魔", "一般回魔"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"致命減傷(%)", "致命減傷(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {"遠程致命減傷(%)", "遠程致命減傷(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {"法術致命減傷(%)", "法術致命減傷(%)"},
		["DEFENSE"] = {DEFENSE, DEFENSE},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["MELEE_HIT"] = {"命中(%)", "命中(%)"},
		["RANGED_HIT"] = {"遠程命中(%)", "遠程命中(%)"},
		["SPELL_HIT"] = {"法術命中(%)", "法術命中(%)"},
		["MELEE_HIT_AVOID"] = {"迴避命中(%)", "迴避命中(%)"},
		["RANGED_HIT_AVOID"] = {"迴避遠程命中(%)", "迴避遠程命中(%)"},
		["SPELL_HIT_AVOID"] = {"迴避法術命中(%)", "迴避法術命中(%)"},
		["MELEE_CRIT"] = {"致命(%)", "致命(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {"遠程致命(%)", "遠程致命(%)"},
		["SPELL_CRIT"] = {"法術致命(%)", "法術致命(%)"},
		["MELEE_CRIT_AVOID"] = {"迴避致命(%)", "迴避致命(%)"},
		["RANGED_CRIT_AVOID"] = {"迴避遠程致命(%)", "迴避遠程致命(%)"},
		["SPELL_CRIT_AVOID"] = {"迴避法術致命(%)", "迴避法術致命(%)"},
		["MELEE_HASTE"] = {"攻擊加速(%)", "攻擊加速(%)"}, --
		["RANGED_HASTE"] = {"遠程加速(%)", "遠程加速(%)"},
		["SPELL_HASTE"] = {"法術加速(%)", "法術加速(%)"},
		["DAGGER_WEAPON"] = {"匕首技能", "匕首"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"劍技能", "劍"},
		["2H_SWORD_WEAPON"] = {"雙手劍技能", "雙手劍"},
		["AXE_WEAPON"] = {"斧技能", "斧"},
		["2H_AXE_WEAPON"] = {"雙手斧技能", "雙手斧"},
		["MACE_WEAPON"] = {"鎚技能", "鎚"},
		["2H_MACE_WEAPON"] = {"雙手鎚技能", "雙手鎚"},
		["GUN_WEAPON"] = {"槍械技能", "槍械"},
		["CROSSBOW_WEAPON"] = {"弩技能", "弩"},
		["BOW_WEAPON"] = {"弓技能", "弓"},
		["FERAL_WEAPON"] = {"野性技能", "野性"},
		["FIST_WEAPON"] = {"徒手技能", "徒手"},
		["STAFF_WEAPON"] = {"法杖技能", "法杖"}, -- Leggings of the Fang ID:10410
		--["EXPERTISE"] = {STAT_EXPERTISE, STAT_EXPERTISE},
		["EXPERTISE"] = {"熟練", "熟練"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		-- Expertise -> Dodge Neglect, Parry Neglect
		["DODGE_NEGLECT"] = {"防止被閃躲(%)", "防止被閃躲(%)"},
		["PARRY_NEGLECT"] = {"防止被招架(%)", "防止被招架(%)"},
		["BLOCK_NEGLECT"] = {"防止被格擋(%)", "防止被格擋(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"致命一擊(%)", "致命(%)"},
		["RANGED_CRIT_DMG"] = {"遠程致命一擊(%)", "遠程致命(%)"},
		["SPELL_CRIT_DMG"] = {"法術致命一擊(%)", "法術致命(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"威脅", "威脅"},
		["CAST_TIME"] = {"施法時間", "施法時間"},
		["MANA_COST"] = {"法力成本", "法力成本"},
		["RAGE_COST"] = {"怒氣成本", "怒氣成本"},
		["ENERGY_COST"] = {"能量成本", "能量成本"},
		["COOLDOWN"] = {"技能冷卻", "技能冷卻"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"修正力量(%)", "修正力量(%)"},
		["MOD_AGI"] = {"修正敏捷(%)", "修正敏捷(%)"},
		["MOD_STA"] = {"修正耐力(%)", "修正耐力(%)"},
		["MOD_INT"] = {"修正智力(%)", "修正智力(%)"},
		["MOD_SPI"] = {"修正精神(%)", "修正精神(%)"},
		["MOD_HEALTH"] = {"修正生命(%)", "修正生命(%)"},
		["MOD_MANA"] = {"修正法力(%)", "修正法力(%)"},
		["MOD_ARMOR"] = {"修正裝甲(%)", "修正裝甲(%)"},
		["MOD_BLOCK_VALUE"] = {"修正格擋值(%)", "修正格擋值(%)"},
		["MOD_DMG"] = {"修正傷害(%)", "修正傷害(%)"},
		["MOD_DMG_TAKEN"] = {"修正受傷害(%)", "修正受傷害(%)"},
		["MOD_CRIT_DAMAGE"] = {"修正致命(%)", "修正致命(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"修正受致命(%)", "修正受致命(%)"},
		["MOD_THREAT"] = {"修正威脅(%)", "修正威脅(%)"},
		["MOD_AP"] = {"修正攻擊強度(%)", "修正攻擊強度(%)"},
		["MOD_RANGED_AP"] = {"修正遠程攻擊強度(%)", "修正遠攻強度(%)"},
		["MOD_SPELL_DMG"] = {"修正法術傷害(%)", "修正法傷(%)"},
		["MOD_HEALING"] = {"修正法術治療(%)", "修正治療(%)"},
		["MOD_CAST_TIME"] = {"修正施法時間(%)", "修正施法時間(%)"},
		["MOD_MANA_COST"] = {"修正法力成本(%)", "修正法力成本(%)"},
		["MOD_RAGE_COST"] = {"修正怒氣成本(%)", "修正怒氣成本(%)"},
		["MOD_ENERGY_COST"] = {"修正能量成本(%)", "修正能量成本(%)"},
		["MOD_COOLDOWN"] = {"修正技能冷卻(%)", "修正技能冷卻(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"武器技能等級", "武器技能等級"},
		["WEAPON_SKILL"] = {"武器技能", "武器技能"},
		["MAINHAND_WEAPON_RATING"] = {"主手武器技能等級", "主手武器技能等級"},
		["OFFHAND_WEAPON_RATING"] = {"副手武器技能等級", "副手武器技能等級"},
		["RANGED_WEAPON_RATING"] = {"遠程武器技能等級", "遠程武器技能等級"},
	},
}

-- deDE localization by Gailly, Dleh
PatternLocale.deDE = {
	["tonumber"] = function(s)
		local n = tonumber(s)
		if n then
			return n
		else
			return tonumber((gsub(s, ",", "%.")))
		end
	end,
	-------------------
	-- Fast Exclude --
	-------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 5, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
		["Entza"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
		["Dauer"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		["<Herg"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
		["Verbl"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
		["Einzi"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
		["Benöt"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
		["\nBenö"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
		["Klasse"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
		["Völke"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
		["Benut"] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
		["Treff"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
		-- Set Bonuses
		-- ITEM_SET_BONUS = "Set: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["Set: "] = true,
		["(2) S"] = true,
		["(3) S"] = true,
		["(4) S"] = true,
		["(5) S"] = true,
		["(6) S"] = true,
		["(7) S"] = true,
		["(8) S"] = true,
		-- Equip type
		["Projektil"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},
	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["Wildheit"] = {["AP"] = 70}, --
		["Unbändigkeit"] = {["AP"] = 70}, --

		["Schwaches Zauberöl"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
		["Geringes Zauberöl"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
		["Zauberöl"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
		["Überragendes Zauberöl"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
		["Hervorragendes Zauberöl"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
		["Gesegnetes Zauberöl"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

		["Schwaches Manaöl"] = {["MANA_REG"] = 4}, --
		["Geringes Manaöl"] = {["MANA_REG"] = 8}, --
		["Überragendes Manaöl"] = {["MANA_REG"] = 14}, --
		["Hervorragendes Manaöl"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --


		["Eterniumangelschnur"] = {["FISHING"] = 5}, --
		["Vitalität"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
		["Seelenfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["Sonnenfeuer"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

		["Mithrilsporen"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["Schwache Reittierttempo-Strigerung"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["Anlegen: Lauftempo ein wenig erhöht."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["Lauftempo ein wenig erhöht"] = {["RUN_SPEED"] = 8}, --
		["Schwache Temposteigerung"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
		["Schwaches Tempo"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
		["Sicherer Stand"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

		["Feingefühl"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
		["2% verringerte Bedrohung"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
		["Anlegen: Ermöglicht Unterwasseratmung."] = false, -- [Band of Icy Depths] ID: 21526
		["Ermöglicht Unterwasseratmung"] = false, --
		["Anlegen: Immun gegen Entwaffnen."] = false, -- [Stronghold Gauntlets] ID: 12639
		["Immun gegen Entwaffnen"] = false, --
		["Kreuzfahrer"] = false, -- Enchant Crusader
		["Lebensdiebstahl"] = false, -- Enchant Crusader
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
	-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
	-- +19 ?? = "^%+(%d+) (.-)$"
	--["SinglePlusStatCheck"] = "^%+(%d+) ([%a ]+%a)$",
	["SinglePlusStatCheck"] = "^%+(%d+) (.-)$",
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) (.-)%.?$"
	-- Stamina +19 = "^(.-) %+(%d+)%.?$"
	-- +19 耐力 = "^%+(%d+) (.-)%.?$"
	-- +19 Ausdauer = "^%+(%d+) (.-)%.?$" (deDE :))
	-- Some have a "." at the end of string like:
	-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
	["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
	["SingleEquipStatCheck"] = "^Anlegen: (.-) um b?i?s? ?z?u? ?(%d+) ?(.-)%.$",
	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before base scan
	["PreScanPatterns"] = {
		--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
		--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
		["^(%d+) Block$"] = "BLOCK_VALUE",
		["^(%d+) Rüstung$"] = "ARMOR",
		["Verstärkte %(%+(%d+) Rüstung%)"] = "ARMOR_BUFF",
		["Mana Regeneration (%d+) alle 5 Sek%.$"] = "MANA_REG",
		["^%+?%d+ %- (%d+) .-[Ss]chaden$"] = "MAX_DAMAGE",
		["^%(([%d%,]+) Schaden pro Sekunde%)$"] = "DPS",
		-- Exclude
		["^(%d+) Slot"] = false, -- Set Name (0/9)
		["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		-- Procs
		["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["[Ee]s besteht eine Chance"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["[Ff]ügt dem Angreifer"] = false, -- [Essence of the Pure Flame] ID: 18815
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "Anlegen: ", -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
	["Socket Bonus: "] = "Sockelbonus: ", -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	-- Strip trailing "."
	["."] = ".",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"[^ ][^S][^e][^k]%. ",  -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
														-- Importent for deDE to not separate "alle 5 Sek. 2 Mana"
	},
	["DeepScanWordSeparators"] = {
		" und ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
	},
	["DualStatPatterns"] = { -- all lower case
		["^%+(%d+) heilzauber %+(%d+) schadenszauber$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^%+(%d+) heilung %+(%d+) zauberschaden$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["^erhöht durch sämtliche zauber und magische effekte verursachte heilung um bis zu (%d+) und den verursachten schaden um bis zu (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-) um b?i?s? ?z?u? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
		"^(.-)5 [Ss]ek%. (%d+) (.-)$",  -- "xxx 5 Sek. 8 xxx" (scan 2nd)
		"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 3rd)
		"^(.-) ?([%d%,]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["Eure Angriffe ignorierenRüstung eures Gegners"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
		["% Bedrohung"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
		["Erhöht Eure effektive Verstohlenheitsstufe"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		["Waffenschaden"] = {"MELEE_DMG"}, -- Enchant
		["Erhöht das Reittiertempo%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

		["Alle Werte"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["Stärke"] = {"STR",},
		["Beweglichkeit"] = {"AGI",},
		["Ausdauer"] = {"STA",},
		["Intelligenz"] = {"INT",},
		["Willenskraft"] = {"SPI",},

		["Arkanwiderstand"] = {"ARCANE_RES",},
		["Feuerwiderstand"] = {"FIRE_RES",},
		["Naturwiderstand"] = {"NATURE_RES",},
		["Frostwiderstand"] = {"FROST_RES",},
		["Schattenwiderstand"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
		["Alle Widerstände"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["Alle Widerstandsarten"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

		["Angeln"] = {"FISHING",}, -- Fishing enchant ID:846
		["Angelfertigkeit"] = {"FISHING",}, -- Fishing lure
		["Bergbau"] = {"MINING",}, -- Mining enchant ID:844
		["Kräuterkunde"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["Kürschnerei"] = {"SKINNING",}, -- Skinning enchant ID:865

		["Rüstung"] = {"ARMOR_BONUS",},
		["Verteidigung"] = {"DEFENSE",},
		["Erhöht die Verteidigungswertung"] = {"DEFENSE",},
		["Blocken"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["Blockwert"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["Erhöht den Blockwert Eures Schildes"] = {"BLOCK_VALUE",},

		["Gesundheit"] = {"HEALTH",},
		["HP"] = {"HEALTH",},
		["Mana"] = {"MANA",},

		["Angriffskraft"] = {"AP",},
		["Erhöht Angriffskraft"] = {"AP",},
		["Erhöht die Angriffskraft"] = {"AP",},
		["Erhöht die Angriffskraft im Kampf gegen Untote"] = {"AP_UNDEAD",}, -- [Wristwraps of Undead Slaying] ID:23093
		["Erhöht die Angriffskraft gegen Untote"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
		["Erhöht die Angriffskraft im Kampf gegen Untote. Ermöglicht das Einsammeln von Geißelsteinen im Namen der Argentumdämmerung"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
		["Erhöht die Angriffskraft im Kampf gegen Dämonen"] = {"AP_DEMON",}, -- [Mark of the Champion] ID:23206
		["Angriffskraft in Katzengestalt, Bärengestalt oder Terrorbärengestalt"] = {"FERAL_AP",},
		["Erhöht die Angriffskraft in Katzengestalt, Bärengestalt, Terrorbärengestalt oder Mondkingestalt"] = {"FERAL_AP",},
		["Distanzangriffskraft"] = {"RANGED_AP",},
		["Erhöht die Distanzangriffskraft"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

		["Gesundheit wieder her"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
		["Gesundheitsregeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779

		["Mana wieder her"] = {"MANA_REG",},
		["Mana alle 5 Sek"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
		["Mana alle 5 Sekunden"] = {"MANA_REG",},
		["alle 5 Sek.Mana"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
		["Mana bei allen Gruppenmitgliedern, die sich im Umkreis von 30 befinden, wieder her"] = {"MANA_REG",}, -- Atiesh
		["Manaregeneration"] = {"MANA_REG",},
		["alle Mana"] = {"MANA_REG",},
		["stellt alle Mana wieder her"] = {"MANA_REG",},

		["Zauberdurchschlagskraft"] = {"SPELLPEN",},
		["Erhöht Eure Zauberdurchschlagskraft"] = {"SPELLPEN",},
		["Schaden und Heilung"] = {"SPELL_DMG", "HEAL",},
		["Damage and Healing Spells"] = {"SPELL_DMG", "HEAL",},
		["Zauberschaden und Heilung"] = {"SPELL_DMG", "HEAL",},
		["Zauberschaden"] = {"SPELL_DMG", "HEAL",},
		["Zauberkraft"] = {"SPELL_DMG", "HEAL",},
		["Erhöht durch Zauber und magische Effekte verursachten Schaden und Heilung"] = {"SPELL_DMG", "HEAL"},
		["Erhöht durch Zauber und magische Effekte zugefügten Schaden und Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
		["Zauberschaden und Heilung"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
		["Schaden"] = {"SPELL_DMG",},
		["Erhöht Euren Zauberschaden"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
		["Zauberschaden"] = {"SPELL_DMG",},
		["Schadenszauber"] = {"SPELL_DMG"},
		["Heiligschaden"] = {"HOLY_SPELL_DMG",},
		["Arkanschaden"] = {"ARCANE_SPELL_DMG",},
		["Feuerschaden"] = {"FIRE_SPELL_DMG",},
		["Naturschaden"] = {"NATURE_SPELL_DMG",},
		["Frostschaden"] = {"FROST_SPELL_DMG",},
		["Schattenschaden"] = {"SHADOW_SPELL_DMG",},
		["Heiligzauberschaden"] = {"HOLY_SPELL_DMG",},
		["Arkanzauberschaden"] = {"ARCANE_SPELL_DMG",},
		["Feuerzauberschaden"] = {"FIRE_SPELL_DMG",},
		["Naturzauberschaden"] = {"NATURE_SPELL_DMG",},
		["Frostzauberschaden"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
		["Schattenzauberschaden"] = {"SHADOW_SPELL_DMG",},
		["Erhöht durch Arkanzauber und Arkaneffekte zugefügten Schaden"] = {"ARCANE_SPELL_DMG",},
		["Erhöht durch Feuerzauber und Feuereffekte zugefügten Schaden"] = {"FIRE_SPELL_DMG",},
		["Erhöht durch Frostzauber und Frosteffekte zugefügten Schaden"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["Erhöht durch Heiligzauber und Heiligeffekte zugefügten Schaden"] = {"HOLY_SPELL_DMG",},
		["Erhöht durch Naturzauber und Natureffekte zugefügten Schaden"] = {"NATURE_SPELL_DMG",},
		["Erhöht durch Schattenzauber und Schatteneffekte zugefügten Schaden"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871

		["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote"] = {"SPELL_DMG_UNDEAD"}, -- [Robe of Undead Cleansing] ID:23085
		["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote um bis zu 48. Ermöglicht das Einsammeln von Geißelsteinen im Namen der Argentumdämmerung."] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
		["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote und Dämonen"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

		["Erhöht Heilung"] = {"HEAL",},
		["Heilung"] = {"HEAL",},
		["Heilzauber"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057

		["Erhöht durch Zauber und Effekte verursachte Heilung"] = {"HEAL",},
		["Erhöht durch Zauber und magische Effekte zugefügte Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {"HEAL",}, -- Atiesh
		--					["your healing"] = {"HEAL",}, -- Atiesh

		["Schaden pro Sekunde"] = {"DPS",},
		["zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997 "Verursacht 17.5 zusätzlichen Schaden pro Sekunde."
		["Verursacht zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997

		["Verteidigungswertung"] = {"DEFENSE_RATING",},
		["Erhöht Verteidigungswertung"] = {"DEFENSE_RATING",},
		["Erhöht die Verteidigungswertung"] = {"DEFENSE_RATING",},
		["Ausweichwertung"] = {"DODGE_RATING",},
		["Erhöht Eure Ausweichwertung"] = {"DODGE_RATING",},
		["Parierwertung"] = {"PARRY_RATING",},
		["Erhöht Eure Parierwertung"] = {"PARRY_RATING",},
		["Blockwertung"] = {"BLOCK_RATING",},
		["Erhöht Eure Blockwertung"] = {"BLOCK_RATING",},
		["Erhöt den Blockwet Eures Schildes"] = {"BLOCK_RATING",},

		["Trefferwertung"] = {"MELEE_HIT_RATING",},
		["Erhöht Trefferwertung"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
		["Erhöht Eure Trefferwertung"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
		["Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
		["Erhöht Zaubertrefferwertung"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
		["Erhöht Eure Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
		["Distanztrefferwertung"] = {"RANGED_HIT_RATING",},
		["Erhöht Distanztrefferwertung"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		["Erhöht Eure Distanztrefferwertung"] = {"RANGED_HIT_RATING",},

		["kritische Trefferwertung"] = {"MELEE_CRIT_RATING",},
		["Erhöht kritische Trefferwertung"] = {"MELEE_CRIT_RATING",},
		["Erhöht Eure kritische Trefferwertung"] = {"MELEE_CRIT_RATING",},
		["kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
		["Erhöht kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
		["Erhöht Eure kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
		["Erhöht die kritische Zaubertrefferwertung aller Gruppenmitglieder innerhalb von 30 Metern"] = {"SPELL_CRIT_RATING",},
		["Erhöht Eure kritische Distanztrefferwertung"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

		--	["Improves hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
		--	["Improves melee hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
		--	["Improves ranged hit avoidance rating"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
		--	["Improves spell hit avoidance rating"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
		["Abhärtung"] = {"RESILIENCE_RATING",},
		["Abhärtungswertung"] = {"RESILIENCE_RATING",},
		["Erhöht Eure Abhärtungswertung"] = {"RESILIENCE_RATING",},
		--	["Improves critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
		--	["Improves melee critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
		--	["Improves ranged critical avoidance rating"] = {"RANGED_CRIT_AVOID_RATING",},
		--	["Improves spell critical avoidance rating"] = {"SPELL_CRIT_AVOID_RATING",},

		["Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
		["Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
		["Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
		["Erhöht Tempowertung"] = {"MELEE_HASTE_RATING"}, -- [Pfeilabwehrender Brustschutz] ID:33328
		["Erhöht Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
		["Erhöht Eure Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
		["Erhöht Eure Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
		["Erhöht Zaubertempowertung"] = {"SPELL_HASTE_RATING"},

		["Erhöht die Fertigkeitswertung für Dolche"] = {"DAGGER_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Schwerter"] = {"SWORD_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Zweihandschwerter"] = {"2H_SWORD_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Äxte"] = {"AXE_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Zweihandäxte"] = {"2H_AXE_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Kolben"] = {"MACE_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Zweihandkolben"] = {"2H_MACE_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Schusswaffen"] = {"GUN_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Armbrüste"] = {"CROSSBOW_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Bögen"] = {"BOW_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für 'Wilder Kampf'"] = {"FERAL_WEAPON_RATING"},
		["Erhöht die Fertigkeitswertung für Faustwaffen"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
		["Erhöht die Fertigkeitswertung für unbewaffneten Kampf"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533

		["Erhöht die Waffenkundewertung"] = {"EXPERTISE_RATING"},
		-- Exclude
		["Sek"] = false,
		["bis"] = false,
		["Platz Tasche"] = false,
		["Platz Köcher"] = false,
		["Platz Munitionsbeutel"] = false,
		["Erhöht das Distanzangriffstempo"] = false, -- AV quiver
	},
}
DisplayLocale.deDE = {
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	
	-- NOTE I left many of the english terms because german players tend to use them and germans are much tooo long
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["IGNORE_ARMOR"] = {"Rüstung ignorieren", "Rüstung igno."},
		["STEALTH_LEVEL"] = {"Verstohlenheitslevel", "Verstohlenheit"},
		["MELEE_DMG"] = {"Waffenschaden", "Waffenschaden"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"Reitgeschwindigkeit(%)", "Reitgeschw.(%)"},
		["RUN_SPEED"] = {"Laufgeschwindigkeit(%)", "Laufgeschw.(%)"},

		["STR"] = {SPELL_STAT1_NAME, "Stärke"},
		["AGI"] = {SPELL_STAT2_NAME, "Bewegl"},
		["STA"] = {SPELL_STAT3_NAME, "Ausdauer"},
		["INT"] = {SPELL_STAT4_NAME, "Int"},
		["SPI"] = {SPELL_STAT5_NAME, "Wille"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {ARMOR.." von Bonus", ARMOR.."(Bonus)"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "FW"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "NW"},
		["FROST_RES"] = {RESISTANCE4_NAME, "FrW"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "SW"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "AW"},

		["FISHING"] = {"Angeln", "Angeln"},
		["MINING"] = {"Bergbau", "Bergbau"},
		["HERBALISM"] = {"Kräuterkunde", "Kräutern"},
		["SKINNING"] = {"Kürschnerei", "Küschnern"},

		["BLOCK_VALUE"] = {"Blockwert", "Blockwert"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
		["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
		["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Untot)", "AP(Untot)"},
		["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Dämon)", "AP(Dämon)"},

		["HEAL"] = {"Heilung", "Heilung"},

		["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Schaden"},
		["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Untot)", PLAYERSTAT_SPELL_COMBAT.." Schaden".."(Untot)"},
		["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Dämon)", PLAYERSTAT_SPELL_COMBAT.." Schaden".."(Dämon)"},
		["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Schaden"},
		["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Schaden"},
		["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Schaden"},
		["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Schaden"},
		["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Schaden"},
		["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.."Schaden"},

		["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {HEALTH.." Regeneration", "HP5"},
		["MANA_REG"] = {MANA.." Regeneration", "MP5"},

		["MAX_DAMAGE"] = {"Maximalschaden", "Max Schaden"},
		["DPS"] = {"Schaden pro Sekunde", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"Treffervermeidung "..RATING, "Treffervermeidung "..RATING},
		["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Treffervermeidung "..RATING, PLAYERSTAT_RANGED_COMBAT.." Treffervermeidung "..RATING},
		["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Treffervermeidung "..RATING, PLAYERSTAT_SPELL_COMBAT.." Treffervermeidung "..RATING},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
		["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
		["MELEE_CRIT_AVOID_RATING"] = {"Kritvermeidung "..RATING, "Kritvermeidung "..RATING},
		["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Kritvermeidung "..RATING, PLAYERSTAT_RANGED_COMBAT.." Kritvermeidung "..RATING},
		["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Kritvermeidung "..RATING, PLAYERSTAT_SPELL_COMBAT.." Kritvermeidung "..RATING},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"Hast "..RATING, "Hast  "..RATING}, --
		["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Hast  "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hast  "..RATING},
		["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Hast  "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hast  "..RATING},
		["EXPERTISE_RATING"] = {"Waffenkundewertung", "Waffenkundewertung"},
		["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
		["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
		["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
		["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
		["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
		["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
		["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
		["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
		["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
		["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
		["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." Regeneration (Nicht im Kampf)", "HP5(OC)"},
		["MANA_REG_NOT_CASTING"] = {MANA.." Regeneration (Nicht zaubernd)", "MP5(NC)"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"Krit Schadenverminderung (%)", "Krit Schaden Verm(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Krit Schadenverminderung(%)", PLAYERSTAT_RANGED_COMBAT.." Krit Schaden Verm(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Krit Schadenverminderung(%)", PLAYERSTAT_SPELL_COMBAT.." Krit Schaden Verm(%)"},
		["DEFENSE"] = {DEFENSE, "Def"},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["AVOIDANCE"] = {"Vermeidung(%)", "Vermeidung(%)"},
		["MELEE_HIT"] = {"Trefferchance(%)", "Treffer(%)"},
		["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Trefferchance(%)", PLAYERSTAT_RANGED_COMBAT.." Treffer(%)"},
		["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Trefferchance(%)", PLAYERSTAT_SPELL_COMBAT.." Treffer(%)"},
		["MELEE_HIT_AVOID"] = {"Treffer Vermeidung(%)", "Treffer Vermeid(%)"},
		["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Treffer Vermeidung(%)", PLAYERSTAT_RANGED_COMBAT.." Trefferermeidung(%)"},
		["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Treffer Vermeidung(%)", PLAYERSTAT_SPELL_COMBAT.." Treffervermeidung(%)"},
		["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Krit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Krit(%)"},
		["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Krit(%)"},
		["MELEE_CRIT_AVOID"] = {"Kritvermeidung(%)", "Kritvermeidung(%)"},
		["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Kritvermeidung(%)", PLAYERSTAT_RANGED_COMBAT.." Kritvermeidung(%)"},
		["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Kritvermeidung(%)", PLAYERSTAT_SPELL_COMBAT.." Kritvermeidung(%)"},
		["MELEE_HASTE"] = {"Hast(%)", "Hast(%)"}, --
		["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Hast(%)", PLAYERSTAT_RANGED_COMBAT.." Hast(%)"},
		["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Hast(%)", PLAYERSTAT_SPELL_COMBAT.." Hast(%)"},
		["EXPERTISE"] = {"Waffenkunde", "Waffenkunde"},
		["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
		["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
		["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
		["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
		["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
		["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
		["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
		["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
		["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
		["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
		["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		["DODGE_NEGLECT"] = {DODGE.." Verhinderung(%)", DODGE.." Verhinderung(%)"},
		["PARRY_NEGLECT"] = {PARRY.." Verhinderung(%)", PARRY.." Verhinderung(%)"},
		["BLOCK_NEGLECT"] = {BLOCK.." Verhinderung(%)", BLOCK.." Verhinderung(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"Krit Schaden(%)", "Crit Schaden(%)"},
		["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)", PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)"},
		["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)", PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"Bedrohung", "Bedrohung"},
		["CAST_TIME"] = {"Zauberzeit", "Zauberzeit"},
		["MANA_COST"] = {"Manakosten", "Mana"},
		["RAGE_COST"] = {"Wutkosten", "Wut"},
		["ENERGY_COST"] = {"Energiekosten", "Energie"},
		["COOLDOWN"] = {"Abklingzeit", "CD"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
		["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
		["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
		["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
		["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
		["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
		["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
		["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
		["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
		["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
		["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
		["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
		["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
		["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
		["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
		["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
		["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
		["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
		["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
		["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
		["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
		["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"Waffe "..SKILL.." "..RATING, "Waffe"..SKILL.." "..RATING},
		["WEAPON_SKILL"] = {"Waffe "..SKILL, "Waffe"..SKILL},
		["MAINHAND_WEAPON_RATING"] = {"Waffenhandwaffe "..SKILL.." "..RATING, "Waffenhand"..SKILL.." "..RATING},
		["OFFHAND_WEAPON_RATING"] = {"Schildhandwaffe "..SKILL.." "..RATING, "Schildhand"..SKILL.." "..RATING},
		["RANGED_WEAPON_RATING"] = {"Fernkampfwaffe "..SKILL.." "..RATING, "Fernkampf"..SKILL.." "..RATING},
	},
}

-- frFR localization by Tixu
PatternLocale.frFR = {
	["tonumber"] = function(s)
		local n = tonumber(s)
		if n then
			return n
		else
			return tonumber((gsub(s, ",", "%.")))
		end
	end,
	------------------
	-- Fast Exclude --
	------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 5, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "Meta Socket";
		--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "Red Socket";
		--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
		--["Disen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		--["Durat"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		["Temps"] = true, -- temps de recharge...
		["<Arti"] = true, -- artisan
		["Uniqu"] = true, -- Unique (20)
		["Nivea"] = true, -- Niveau
		["\nNive"] = true, -- Niveau
		["Class"] = true, -- Classes: xx
		["Races"] = true, -- Races: xx (vendor mounts)
		["Utili"] = true, -- Utiliser:
		["Chanc"] = true, -- Chance de toucher:
		["Requi"] = true, -- Requiert
		["\nRequ"] = true,-- Requiert
		["Néces"] = true,--nécessite plus de gemmes...
		-- Set Bonuses
		["Ensem"] = true,--ensemble
		["(2) E"] = true,
		["(2) E"] = true,
		["(3) E"] = true,
		["(4) E"] = true,
		["(5) E"] = true,
		["(6) E"] = true,
		["(7) E"] = true,
		["(8) E"] = true,
		-- Equip type
		["Proje"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},

	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		--ToDo
		["Huile de sorcier mineure"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
		["Huile de sorcier inférieure"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
		["Huile de sorcier"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
		["Huile de sorcier brillante"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
		["Huile de sorcier excellente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
		["Huile de sorcier bénite"] = {["SPELL_DMG_UNDEAD"] = 60}, --

		["Huile de mana mineure"] = {["MANA_REG"] = 4}, --
		["Huile de mana inférieure"] = {["MANA_REG"] = 8}, --
		["Huile de mana brillante"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --
		["Huile de mana excellente"] = {["MANA_REG"] = 14}, --

		["Eternium Line"] = {["FISHING"] = 5}, --
		["Feu solaire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --
		["Augmentation mineure de la vitesse de la monture"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["Pied sûr"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

		["Equip: Allows underwater breathing."] = false, -- [Band of Icy Depths] ID: 21526
		["Allows underwater breathing"] = false, --
		["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639
		["Immune to Disarm"] = false, --
		["Lifestealing"] = false, -- Enchant Crusader

		--translated
		["Eperons en mithril"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["Équipé\194\160: La vitesse de course augmente légèrement."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["La vitesse de course augmente légèrement"] = {["RUN_SPEED"] = 8}, --
		["Augmentation mineure de vitesse"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
		["Vitalité"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
		["Âme de givre"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["Sauvagerie"] = {["AP"] = 70}, --
		["Vitesse mineure"] = {["RUN_SPEED"] = 8},
		["Vitesse mineure et +9 en Endurance"] = {["RUN_SPEED"] = 8, ["STA"] = 9},--enchant

		["Croisé"] = false, -- Enchant Crusader
		["Mangouste"] = false, -- Enchant Mangouste
		["Arme impie"] = false,
		["Équipé : Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, --cape Onyxia
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	["SingleEquipStatCheck"] = "^Équipé\194\160: Augmente (.-) ?de (%d+) ?a?u? ?m?a?x?i?m?u?m? ?(.-)%.?$",

	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before deep scan
	["PreScanPatterns"] = {
		["Bloquer.- (%d+)"] = "BLOCK_VALUE",
		["Armure.- (%d+)"] = "ARMOR",
		["^Équipé\194\160: Rend (%d+) points de vie toutes les 5 seco?n?d?e?s?%.?$"]= "HEAL_REG",
		["^Équipé\194\160: Rend (%d+) points de mana toutes les 5 seco?n?d?e?s?%.?$"]= "MANA_REG",
		["Renforcé %(%+(%d+) Armure%)"]= "ARMOR_BONUS",
		["Lunette %(%+(%d+) points? de dégâts?%)"]="RANGED_AP",
		["^%(([%d%,]+) dégâts par seconde%)$"] = "DPS",

		-- Exclude
		["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		--["Confère une chance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["Rend parfois"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["Vous gagnez une"] = false, -- condensateur de foudre
		["Dégâts:"] = false, -- ligne de degats des armes
		["Votre technique"] = false,
		["^%+?%d+ %- %d+ points de dégâts %(.-%)$"]= false, -- ligne de degats des baguettes/ +degats (Thunderfury)
		["Permettent au porteur"] = false, -- Casques Ombrelunes
		["^.- %(%d+%) requis"] = false, --metier requis pour porter ou utiliser
		["^.- ?[Vv]?o?u?s? [Cc]onfèren?t? .-"] = false, --proc
		["^.- ?l?e?s? ?[Cc]hances .-"] = false, --proc
		["^.- par votre sort .-"] = false, --augmentation de capacité de sort
		["^.- la portée de .-"] = false, --augmentation de capacité de sort
		["^.- la durée de .-"] = false, --augmentation de capacité de sort
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "Équipé\194\160: ", --\194\160= espace insécable
	["Socket Bonus: "] = "Bonus de sertissage\194\160: ",
	-- Strip trailing "."
	["."] = ".",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
	},
	["DeepScanWordSeparators"] = {
		" et ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
	},
	["DualStatPatterns"] = { -- all lower case
		["les soins %+(%d+) et les dégâts %+ (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
		["les soins %+(%d+) les dégâts %+ (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
		["soins prodigués d'un maximum de (%d+) et les dégâts d'un maximum de (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
	},
	["DeepScanPatterns"] = {
		"^(.-) ?([%+%-]%d+) ?(.-)%.?$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
		"^(.-) ?([%d%,]+) ?(.-)%.?$", -- 22.22 xxx xxx (scan last)
		"^.-: (.-)([%+%-]%d+) ?(.-)%.?$", --Bonus de sertissage : +3 xxx
		"^(.-) augmentée?s? de (%d+) ?(.-)%%?%.?$",--sometimes this pattern is needed but not often.
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["votre niveau de camouflage actuel"] = {"STEALTH_LEVEL"},

		--dégats melee
		["aux dégâts des armes"] = {"MELEE_DMG"},
		["aux dégâts de l'arme"] = {"MELEE_DMG"},
		["aux dégâts en mêlée"] = {"MELEE_DMG"},
		["dégâts de l'arme"] = {"MELEE_DMG"},

		--vitesse de course
		["vitesse de monture"]= {"MOUNT_SPEED"},

		--caracteristiques
		["à toutes les caractéristiques"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["force"] = {"STR",},
		["agilité"] = {"AGI",},
		["endurance"] = {"STA",},
		["en endurance"] = {"STA",},
		["intelligence"] = {"INT",},
		["esprit"] = {"SPI",},

		--résistances
		["à la résistance arcanes"] = {"ARCANE_RES",},
		["à la résistance aux arcanes"] = {"ARCANE_RES",},

		["à la résistance feu"] = {"FIRE_RES",},
		["à la résistance au feu"] = {"FIRE_RES",},

		["à la résistance nature"] = {"NATURE_RES",},
		["à la résistance à la nature"] = {"NATURE_RES",},

		["à la résistance givre"] = {"FROST_RES",},
		["à la résistance au givre"] = {"FROST_RES",},

		["à la résistance ombre"] = {"SHADOW_RES",},
		["à la résistance à l'ombre"] = {"SHADOW_RES",},

		["à toutes les résistances"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

		--artisanat
		["pêche"] = {"FISHING",},
		["minage"] = {"MINING",},
		["herboristerie"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["dépeçage"] = {"SKINNING",}, -- Skinning enchant ID:865

		--
		["armure"] = {"ARMOR_BONUS",},

		["défense"] = {"DEFENSE",},

		["valeur de blocage"] = {"BLOCK_VALUE",},
		["à la valeur de blocage"] = {"BLOCK_VALUE",},
		["la valeur de blocage de votre bouclier"] = {"BLOCK_VALUE",},

		["points de vie"] = {"HEALTH",},
		["aux points de vie"] = {"HEALTH",},
		["points de mana"] = {"MANA",},

		["la puissance d'attaque"] = {"AP",},
		["à la puissance d'attaque"] = {"AP",},
		["puissance d'attaque"] = {"AP",},



		--ToDo
		["Augmente dela puissance d'attaque lorsque vous combattez des morts-vivants"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",},
		--["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
		--["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
		--["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},


		--ranged AP
		["la puissance des attaques à distance"] = {"RANGED_AP",},
		--Feral
		["la puissance d'attaque pour les formes de félin, d'ours, d'ours redoutable et de sélénien uniquement"] = {"FERAL_AP",},

		--regen
		["points de mana toutes les 5 secondes"] = {"MANA_REG",},
		["point de mana toutes les 5 secondes"] = {"MANA_REG",},
		["points de vie toutes les 5 secondes"] = {"HEALTH_REG",},
		["point de vie toutes les 5 secondes"] = {"HEALTH_REG",},
		["points de mana toutes les 5 sec"] = {"MANA_REG",},
		["points de vie toutes les 5 sec"] = {"HEALTH_REG",},
		["point de mana toutes les 5 sec"] = {"MANA_REG",},
		["point de vie toutes les 5 sec"] = {"HEALTH_REG",},
		["mana toutes les 5 secondes"] = {"MANA_REG",},
		["régén. de mana"] = {"MANA_REG",},


		--pénétration des sorts
		["la pénétration de vos sorts"] = {"SPELLPEN",},
		["à la pénétration des sorts"] = {"SPELLPEN",},
		--Puissance soins et sorts
		["à la puissance des sorts"] = {"SPELL_DMG",},
		["les soins prodigués par les sorts et effets"] = {"HEAL",},
		["les dégâts et les soins produits par les sorts et effets magiques"] = {"SPELL_DMG", "HEAL"},
		["aux dégâts des sorts et aux soins"] = {"SPELL_DMG", "HEAL"},
		["aux dégâts des sorts"] = {"SPELL_DMG",},
		["dégâts des sorts"] = {"SPELL_DMG",},
		["aux sorts de soins"] = {"HEAL",},
		["aux soins"] = {"HEAL",},
		["soins"] = {"HEAL",},
		["les soins prodigués par les sorts et effets d’un maximum"] = {"HEAL",},

		--ToDo
		["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques d'un maximum de"] = {"SPELL_DMG_UNDEAD"},

		["les dégâts infligés par les sorts et effets d'ombre"]={"SHADOW_SPELL_DMG",},
		["aux dégâts des sorts d'ombre"]={"SHADOW_SPELL_DMG",},
		["aux dégâts d'ombre"]={"SHADOW_SPELL_DMG",},

		["les dégâts infligés par les sorts et effets de givre"]={"FROST_SPELL_DMG",},
		["aux dégâts des sorts de givre"]={"FROST_SPELL_DMG",},
		["aux dégâts de givre"]={"FROST_SPELL_DMG",},

		["les dégâts infligés par les sorts et effets de feu"]={"FIRE_SPELL_DMG",},
		["aux dégâts des sorts de feu"]={"FIRE_SPELL_DMG",},
		["aux dégâts de feu"]={"FIRE_SPELL_DMG",},

		["les dégâts infligés par les sorts et effets de nature"]={"NATURE_SPELL_DMG",},
		["aux dégâts des sorts de nature"]={"NATURE_SPELL_DMG",},
		["aux dégâts de nature"]={"NATURE_SPELL_DMG",},

		["les dégâts infligés par les sorts et effets des arcanes"]={"ARCANE_SPELL_DMG",},
		["aux dégâts des sorts d'arcanes"]={"ARCANE_SPELL_DMG",},
		["aux dégâts d'arcanes"]={"ARCANE_SPELL_DMG",},

		["les dégâts infligés par les sorts et effets du sacré"]={"HOLY_SPELL_DMG",},
		["aux dégâts des sorts du sacré"]={"HOLY_SPELL_DMG",},
		["aux dégâts du sacré"]={"HOLY_SPELL_DMG",},

		--ToDo
		--["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
		--["Increases Healing"] = {"HEAL",},
		--["Healing"] = {"HEAL",},
		--["healing Spells"] = {"HEAL",},
		--["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
		--["Increases healing done by spells and effects"] = {"HEAL",},
		--["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
		--["your healing"] = {"HEAL",}, -- Atiesh

		["dégâts par seconde"] = {"DPS",},
		--["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

		["score de défense"] = {"DEFENSE_RATING",},
		["au score de défense"] = {"DEFENSE_RATING",},
		["le score de défense"] = {"DEFENSE_RATING",},
		["votre score de défense"] = {"DEFENSE_RATING",},

		["score d'esquive"] = {"DODGE_RATING",},
		["le score d'esquive"] = {"DODGE_RATING",},
		["au score d'esquive"] = {"DODGE_RATING",},
		["votre score d'esquive"] = {"DODGE_RATING",},

		["score de parade"] = {"PARRY_RATING",},
		["au score de parade"] = {"PARRY_RATING",},
		["le score de parade"] = {"PARRY_RATING",},
		["votre score de parade"] = {"PARRY_RATING",},

		["score de blocage"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
		["le score de blocage"] = {"BLOCK_RATING",},
		["votre score de blocage"] = {"BLOCK_RATING",},
		["au score de blocage"] = {"BLOCK_RATING",},

		["score de toucher"] = {"MELEE_HIT_RATING",},
		["le score de toucher"] = {"MELEE_HIT_RATING",},
		["votre score de toucher"] = {"MELEE_HIT_RATING",},
		["au score de toucher"] = {"MELEE_HIT_RATING",},

		["score de coup critique"] = {"MELEE_CRIT_RATING",},
		["score de critique"] = {"MELEE_CRIT_RATING",},
		["le score de coup critique"] = {"MELEE_CRIT_RATING",},
		["votre score de coup critique"] = {"MELEE_CRIT_RATING",},
		["au score de coup critique"] = {"MELEE_CRIT_RATING",},
		["au score de critique"] = {"MELEE_CRIT_RATING",},

		["score de résilience"] = {"RESILIENCE_RATING",},
		["le score de résilience"] = {"RESILIENCE_RATING",},
		["au score de résilience"] = {"RESILIENCE_RATING",},
		["votre score de résilience"] = {"RESILIENCE_RATING",},
		["à la résilience"] = {"RESILIENCE_RATING",},

		["le score de toucher des sorts"] = {"SPELL_HIT_RATING",},
		["score de toucher des sorts"] = {"SPELL_HIT_RATING",},
		["au score de toucher des sorts"] = {"SPELL_HIT_RATING",},
		["votre score de toucher des sorts"] = {"SPELL_HIT_RATING",},


		["le score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
		["score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
		["score de critique des sorts"] = {"SPELL_CRIT_RATING",},
		["au score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
		["au score de critique des sorts"] = {"SPELL_CRIT_RATING",},
		["votre score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
		["au score de coup critique de sorts"] = {"SPELL_CRIT_RATING",},
		["aux score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},--blizzard! faute d'orthographe!!

		--ToDo
		--["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
		--["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		--["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},
		["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

		["score de hâte"] = {"MELEE_HASTE_RATING"},
		["score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
		["score de hâte à distance"] = {"RANGED_HASTE_RATING"},
		--["Improves haste rating"] = {"MELEE_HASTE_RATING"},
		--["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
		--["Improves ranged haste rating"] = {"SPELL_HASTE_RATING"},
		--["Improves spell haste rating"] = {"RANGED_HASTE_RATING"},

		["le score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
		["score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
		["le score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
		["score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
		["le score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
		["score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
		["le score de la compétence masses"]= {"MACE_WEAPON_RATING"},
		["score de la compétence masses"]= {"MACE_WEAPON_RATING"},
		["le score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
		["score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
		["le score de la compétence haches"] = {"AXE_WEAPON_RATING"},
		["score de la compétence haches"] = {"AXE_WEAPON_RATING"},
		["le score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},
		["score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},

		["le score de la compétence armes de pugilat"] = {"FIST_WEAPON_RATING"},
		["le score de compétence combat farouche"] = {"FERAL_WEAPON_RATING"},
		["le score de la compétence mains nues"] = {"FIST_WEAPON_RATING"},

		--ToDo
		--["Increases gun skill rating"] = {"GUN_WEAPON_RATING"},
		--["Increases Crossbow skill rating"] = {"CROSSBOW_WEAPON_RATING"},
		--["Increases Bow skill rating"] = {"BOW_WEAPON_RATING"},

		--ToDo
		-- Exclude
		--["sec"] = false,
		--["to"] = false,
		--["Slot Bag"] = false,
		--["Slot Quiver"] = false,
		--["Slot Ammo Pouch"] = false,
		--["Increases ranged attack speed"] = false, -- AV quiver
	},
}
DisplayLocale.frFR = {
	--ToDo
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
		["STEALTH_LEVEL"] = {"Stealth Level", "Stealth"},
		["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
		["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

		["STR"] = {SPELL_STAT1_NAME, "Str"},
		["AGI"] = {SPELL_STAT2_NAME, "Agi"},
		["STA"] = {SPELL_STAT3_NAME, "Sta"},
		["INT"] = {SPELL_STAT4_NAME, "Int"},
		["SPI"] = {SPELL_STAT5_NAME, "Spi"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
		["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

		["FISHING"] = {"Fishing", "Fishing"},
		["MINING"] = {"Mining", "Mining"},
		["HERBALISM"] = {"Herbalism", "Herbalism"},
		["SKINNING"] = {"Skinning", "Skinning"},

		["BLOCK_VALUE"] = {"Block Value", "Block Value"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
		["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
		["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Undead)", "AP(Undead)"},
		["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Demon)", "AP(Demon)"},

		["HEAL"] = {"Healing", "Heal"},

		["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
		["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Undead)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
		["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Demon)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
		["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
		["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
		["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
		["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
		["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
		["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

		["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {HEALTH.." Regen", "HP5"},
		["MANA_REG"] = {MANA.." Regen", "MP5"},

		["MAX_DAMAGE"] = {"Max Damage", "Max Dmg"},
		["DPS"] = {"Dégats par seconde", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"Hit Avoidance "..RATING, "Hit Avoidance "..RATING},
		["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance "..RATING},
		["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance "..RATING},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
		["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
		["MELEE_CRIT_AVOID_RATING"] = {"Crit Avoidance "..RATING, "Crit Avoidance "..RATING},
		["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING},
		["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"Haste "..RATING, "Haste "..RATING}, --
		["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
		["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
		["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
		["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
		["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
		["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
		["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
		["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
		["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
		["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
		["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
		["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
		["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." Regen (Out of combat)", "HP5(OC)"},
		["MANA_REG_NOT_CASTING"] = {MANA.." Regen (Not casting)", "MP5(NC)"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction(%)", "Crit Dmg Reduc(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
		["DEFENSE"] = {DEFENSE, "Def"},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["MELEE_HIT"] = {"Hit Chance(%)", "Hit(%)"},
		["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
		["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
		["MELEE_HIT_AVOID"] = {"Hit Avoidance(%)", "Hit Avd(%)"},
		["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit Avd(%)"},
		["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit Avd(%)"},
		["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
		["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
		["MELEE_CRIT_AVOID"] = {"Crit Avoidance(%)", "Crit Avd(%)"},
		["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Avd(%)"},
		["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Avd(%)"},
		["MELEE_HASTE"] = {"Haste(%)", "Haste(%)"}, --
		["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Haste(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
		["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Haste(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
		["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
		["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
		["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
		["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
		["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
		["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
		["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
		["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
		["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
		["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
		["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
		["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
		["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
		["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
		["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"Threat", "Threat"},
		["CAST_TIME"] = {"Casting Time", "Cast Time"},
		["MANA_COST"] = {"Mana Cost", "Mana Cost"},
		["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
		["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
		["COOLDOWN"] = {"Cooldown", "CD"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
		["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
		["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
		["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
		["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
		["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
		["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
		["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
		["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
		["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
		["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
		["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
		["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
		["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
		["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
		["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
		["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
		["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
		["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
		["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
		["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
		["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
		["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
		["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
		["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
		["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
	},
}

-- zhCN localization by iceburn
PatternLocale.zhCN = {
	["tonumber"] = tonumber,
	------------------
	-- Fast Exclude --
	------------------
	-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
	["ExcludeLen"] = 3, -- using string.utf8len
	["Exclude"] = {
		[""] = true,
		[" \n"] = true,
		[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
		[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
		[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
		[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
		[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
		[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
		[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
		[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
		[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
		["分解"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
		["分解需"] = true, -- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
		["持续时"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
		["<由%s"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
		["冷却时"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
		["装备唯"] = true, -- Unique-Equipped
		["唯一"] = true, -- ITEM_UNIQUE = "Unique";
		["唯一("] = true, -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)";
		["需要等"] = true, -- Requires Level xx
		["需要 "] = true, -- Requires Level xx
		["需要锻"] = true, -- Requires Level xx
		["\n需要"] = true, -- Requires Level xx
		["职业："] = true, -- Classes: xx
		["种族："] = true, -- Races: xx (vendor mounts)
		["使用："] = true, -- Use:
		["击中时"] = true, -- Chance On Hit:
		-- Set Bonuses
		-- ITEM_SET_BONUS = "Set: %s";
		-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
		-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
		["套装："] = true,
		["(2) 套装"] = true,
		["(3) 套装"] = true,
		["(4) 套装"] = true,
		["(5) 套装"] = true,
		["(6) 套装"] = true,
		["(7) 套装"] = true,
		["(8) 套装"] = true,
		-- Equip type
		["弹药"] = true, -- Ice Threaded Arrow ID:19316
		[INVTYPE_AMMO] = true,
		[INVTYPE_HEAD] = true,
		[INVTYPE_NECK] = true,
		[INVTYPE_SHOULDER] = true,
		[INVTYPE_BODY] = true,
		[INVTYPE_CHEST] = true,
		[INVTYPE_ROBE] = true,
		[INVTYPE_WAIST] = true,
		[INVTYPE_LEGS] = true,
		[INVTYPE_FEET] = true,
		[INVTYPE_WRIST] = true,
		[INVTYPE_HAND] = true,
		[INVTYPE_FINGER] = true,
		[INVTYPE_TRINKET] = true,
		[INVTYPE_CLOAK] = true,
		[INVTYPE_WEAPON] = true,
		[INVTYPE_SHIELD] = true,
		[INVTYPE_2HWEAPON] = true,
		[INVTYPE_WEAPONMAINHAND] = true,
		[INVTYPE_WEAPONOFFHAND] = true,
		[INVTYPE_HOLDABLE] = true,
		[INVTYPE_RANGED] = true,
		[INVTYPE_THROWN] = true,
		[INVTYPE_RANGEDRIGHT] = true,
		[INVTYPE_RELIC] = true,
		[INVTYPE_TABARD] = true,
		[INVTYPE_BAG] = true,
	},
	--[[
	textTable = {
		"法术伤害 +6 及法术命中等级 +5",
		"+3  耐力, +4 爆击等级",
		"++26 治疗法术 & 降低2% 威胁值",
		"+3 耐力/+4 爆击等级",
		"插槽加成:每5秒+2法力",
		"装备: 使所有法术和魔法效果所造成的伤害和治疗效果提高最多150点。",
		"装备: 使半径30码范围内所有小队成员的法术爆击等级提高28点。",
		"装备: 使30码范围内的所有队友提高所有法术和魔法效果所造成的伤害和治疗效果，最多33点。",
		"装备: 使周围半径30码范围内队友的所有法术和魔法效果所造成的治疗效果提高最多62点。",
		"装备: 使你的法术伤害提高最多120点，以及你的治疗效果最多300点。",
		"装备: 使周围半径30码范围内的队友每5秒恢复11点法力。",
		"装备: 使法术所造成的治疗效果提高最多300点。",
		"装备: 在猎豹、熊、巨熊和枭兽形态下的攻击强度提高420点。",
		-- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		-- "+26 Attack Power and +14 Critical Strike Rating": Swift Windfire Diamond ID:28556
		-- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		-- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		----
		-- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
		-- "Healing +11 and 2 mana per 5 sec.": Royal Tanzanite ID: 30603
	}
	--]]
	-----------------------
	-- Whole Text Lookup --
	-----------------------
	-- Mainly used for enchants that doesn't have numbers in the text
	["WholeTextLookup"] = {
		[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["野性"] = {["AP"] = 70}, --

		["初级巫师之油"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
		["次级巫师之油"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
		["巫师之油"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
		["卓越巫师之油"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
		["神圣巫师之油"] = {["SPELL_DMG_UNDEAD"] = 60}, --

		["超强法力之油"] = {["MANA_REG"] = 14}, --
		["初级法力之油"] = {["MANA_REG"] = 4}, --
		["次级法力之油"] = {["MANA_REG"] = 8}, --
		["卓越法力之油"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --
		["超强巫师之油"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --

		["恒金渔线"] = {["FISHING"] = 5}, --
		["活力"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
		["魂霜"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
		["阳炎"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --
		["+40 法术伤害"] = {["SPELL_DMG"] = 40, ["HEAL"] = 40}, --
		["+30 法术伤害"] = {["SPELL_DMG"] = 30, ["HEAL"] = 30}, --

		["秘银马刺"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
		["坐骑移动速度略微提升"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
		["装备： 略微提高移动速度。"] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
		["移动速度略微提升"] = {["RUN_SPEED"] = 8}, --
		["略微提高奔跑速度"] = {["RUN_SPEED"] = 8}, --
		["移动速度略微提升"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
		["初级速度"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
		["稳固"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" 

		["狡诈"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
		["威胁减少2%"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
		["装备： 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
		["使你可以在水下呼吸"] = false, --
		["装备： 免疫缴械。"] = false, -- [Stronghold Gauntlets] ID: 12639
		["免疫缴械"] = false, --
		["十字军"] = false, -- Enchant Crusader
		["生命偷取"] = false, -- Enchant Crusader
	},
	----------------------------
	-- Single Plus Stat Check --
	----------------------------
	-- depending on locale, it may be
	-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
	-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
	-- +19 耐力 = "^%+(%d+) (.-)$"
	-- Some have a "." at the end of string like:
	-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
	["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)$",
	-----------------------------
	-- Single Equip Stat Check --
	-----------------------------
	-- stat1, value, stat2 = strfind
	-- stat = stat1..stat2
	-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
	--装备: 增加法术命中等级 11点。
	--装备: 提高所有法术和魔法效果所造成的伤害和治疗效果，最多46点。
	--"装备： (.-)提高(最多)?(%d+)(点)?(.-)。$",
	["SingleEquipStatCheck"] = "装备： (.-)(%d+)点(.-)。$",
	-------------
	-- PreScan --
	-------------
	-- Special cases that need to be dealt with before base scan
	["PreScanPatterns"] = {
		["^装备: 猫形态下的攻击强度增加(%d+)"] = "FERAL_AP",
		["^装备: 与亡灵作战时的攻击强度提高(%d+)点"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
		["^(%d+)格挡$"] = "BLOCK_VALUE",
		["^(%d+)点护甲$"] = "ARMOR",
		["强化护甲 %+(%d+)"] = "ARMOR_BONUS",
		["护甲值提高(%d+)点"] = "ARMOR_BONUS",
		["每5秒恢复(%d+)点法力值。$"] = "MANA_REG",
		["每5秒恢复(%d+)点生命值。$"] = "HEALTH_REG",
		["每5秒回复(%d+)点法力值。$"] = "MANA_REG",
		["每5秒回复(%d+)点法力值$"] = "MANA_REG",
		["每5秒回复(%d+)点生命值。$"] = "HEALTH_REG",
		["^%+?%d+ %- (%d+).-伤害$"] = "MAX_DAMAGE",
		["^（每秒伤害([%d%.]+)）$"] = "DPS",
		-- Exclude
		["^(%d+)格.-包"] = false, -- # of slots and bag type
		["^(%d+)格.-袋"] = false, -- # of slots and bag type
		["^(%d+)格容器"] = false, -- # of slots and bag type
		["^.+（(%d+)/%d+）$"] = false, -- Set Name (0/9)
		["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
		-- Procs
		["几率"] = false, --[挑战印记] ID:27924
		["机率"] = false, 
		["有一定几率"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
		["有可能"] = false, -- [Darkmoon Card: Heroism] ID:19287
		["命中时"] = false, -- [黑色摧毁者手套] ID:22194
		["被击中之后"] = false, -- [Essence of the Pure Flame] ID: 18815
		["在杀死一个敌人"] = false, -- [注入精华的蘑菇] ID:28109
		["每当你的"] = false, -- [电光相容器] ID: 28785
		["被击中时"] = false, -- 
		["你每施放一次法术，此增益的效果就降低17点伤害和34点治疗效果"] = false, --赞达拉英雄护符 ID:19950
	},
	--------------
	-- DeepScan --
	--------------
	-- Strip leading "Equip: ", "Socket Bonus: "
	["Equip: "] = "装备: ", -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
	["Socket Bonus: "] = "镶孔奖励: ", -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	-- Strip trailing "."
	["."] = "。",
	["DeepScanSeparators"] = {
		"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
		" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
		", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
		"、", -- 防御者雕文
		"。", 
	},
	["DeepScanWordSeparators"] = {
		"及", "和", "并", "，","以及", "持续 "-- [发光的暗影卓奈石] ID:25894 "+24 攻击强度及略微提高奔跑速度", [刺客的火焰蛋白石] ID:30565 "爆击等级 +6 及躲闪等级 +5"
	},
	["DeepScanPatterns"] = {
		"^(.-)提高最多([%d%.]+)点(.-)$", -- 
		"^(.-)提高最多([%d%.]+)(.-)$", -- 
		"^(.-)，最多([%d%.]+)点(.-)$", -- 
		"^(.-)，最多([%d%.]+)(.-)$", -- 
		"^(.-)最多([%d%.]+)点(.-)$", -- 
		"^(.-)最多([%d%.]+)(.-)$", -- 
		"^(.-)提高([%d%.]+)点(.-)$", -- 
		"^(.-)提高([%d%.]+)(.-)$", -- 
		"^(.-)([%d%.]+)点(.-)$", -- 
		"^(.-) ?([%+%-][%d%.]+) ?点(.-)$", -- 
		"^(.-) ?([%+%-][%d%.]+) ?(.-)$", -- 
		"^(.-) ?([%d%.]+) ?点(.-)$", -- 
		"^(.-) ?([%d%.]+) ?(.-)$", -- 
	},
	-----------------------
	-- Stat Lookup Table --
	-----------------------
	["StatIDLookup"] = {
		["你的攻击无视目标的点护甲值"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
		["% 威胁"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
		["使你的潜行等级提高"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
		["潜行"] = {"STEALTH_LEVEL"}, -- Cloak Enchant
		["武器伤害"] = {"MELEE_DMG"}, -- Enchant
		["近战伤害"] = {"MELEE_DMG"}, -- Enchant
		["使坐骑速度提高%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048
		["坐骑速度"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

		["所有属性"] = {"STR", "AGI", "STA", "INT", "SPI",},
		["力量"] = {"STR",},
		["敏捷"] = {"AGI",},
		["耐力"] = {"STA",},
		["智力"] = {"INT",},
		["精神"] = {"SPI",},

		["奥术抗性"] = {"ARCANE_RES",},
		["火焰抗性"] = {"FIRE_RES",},
		["自然抗性"] = {"NATURE_RES",},
		["冰霜抗性"] = {"FROST_RES",},
		["暗影抗性"] = {"SHADOW_RES",},
		["阴影抗性"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
		["所有抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["全部抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["抵抗全部"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
		["点所有魔法抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",}, -- [锯齿黑曜石之盾] ID:22198

		["钓鱼"] = {"FISHING",}, -- Fishing enchant ID:846
		["钓鱼技能"] = {"FISHING",}, -- Fishing lure
		["使钓鱼技能"] = {"FISHING",}, -- Equip: Increased Fishing +20.
		["采矿"] = {"MINING",}, -- Mining enchant ID:844
		["草药学"] = {"HERBALISM",}, -- Heabalism enchant ID:845
		["剥皮"] = {"SKINNING",}, -- Skinning enchant ID:865

		["护甲"] = {"ARMOR_BONUS",},
		["护甲值"] = {"ARMOR_BONUS",},
		["强化护甲"] = {"ARMOR_BONUS",},
		["护甲值提高(%d+)点"] = {"ARMOR_BONUS",},
		["防御"] = {"DEFENSE",},
		["增加防御"] = {"DEFENSE",},
		["格挡值"] = {"BLOCK_VALUE",}, -- +22 Block Value
		["使你的盾牌格挡值"] = {"BLOCK_VALUE",},

		["生命值"] = {"HEALTH",},
		["法力值"] = {"MANA",},

		["攻击强度"] = {"AP",},
		["攻击强度提高"] = {"AP",},
		["提高攻击强度"] = {"AP",},
		["与亡灵作战时的攻击强度"] = {"AP_UNDEAD",}, -- [黎明圣印] ID:13209 -- [弑妖裹腕] ID:23093
		["与亡灵和恶魔作战时的攻击强度"] = {"AP_UNDEAD", "AP_DEMON",}, -- [勇士徽章] ID:23206
		["与恶魔作战时的攻击强度"] = {"AP_DEMON",},
		["在猎豹、熊、巨熊和枭兽形态下的攻击强度"] = {"FERAL_AP",}, -- Atiesh ID:22632
		["使你的近战和远程攻击强度"] = {"AP"},
		["远程攻击强度"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

		["每5秒恢复(%d+)点生命值"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
		["每5秒回复(%d+)点生命值"] = {"HEALTH_REG",}, 
		["生命值恢复速度"] = {"HEALTH_REG",}, -- [Demons Blood] ID: 10779
		
		["每5秒法力"] = {"MANA_REG",}, --
		["每5秒恢复法力"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
		["每5秒恢复(%d+)点法力值"] = {"MANA_REG",}, 
		["每5秒回复(%d+)点法力值"] = {"MANA_REG",}, 
		["每5秒法力回复"] = {"MANA_REG",}, 
		["法力恢复"] = {"MANA_REG",}, 
		["法力回复"] = {"MANA_REG",}, 
		["使周围半径30码范围内的所有小队成员每5秒恢复(%d+)点法力值"] = {"MANA_REG",}, --

		["法术穿透"] = {"SPELLPEN",},
		["法术穿透力"] = {"SPELLPEN",},
		["使你的法术穿透提高"] = {"SPELLPEN",},
		
		["法术伤害和治疗"] = {"SPELL_DMG", "HEAL",},
		["法术治疗和伤害"] = {"SPELL_DMG", "HEAL",},
		["治疗和法术伤害"] = {"SPELL_DMG", "HEAL",},
		["法术伤害"] = {"SPELL_DMG",},
		["提高法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"},
		["使周围半径30码范围内的所有小队成员的法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"}, -- Atiesh, ID: 22630
		["提高所有法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"},		--StatLogic:GetSum("22630")
		["提高所有法术和魔法效果所造成的伤害和治疗效果，最多"] = {"SPELL_DMG", "HEAL"},
		--SetTip("22630")
		-- Atiesh ID:22630, 22631, 22632, 22589
						--装备: 使周围半径30码范围内队友的所有法术和魔法效果所造成的伤害和治疗效果提高最多33点。 -- 22630 -- 2.1.0
						--装备: 使周围半径30码范围内队友的所有法术和魔法效果所造成的治疗效果提高最多62点。 -- 22631
						--装备: 使半径30码范围内所有小队成员的法术爆击等级提高28点。 -- 22589
						--装备: 使周围半径30码范围内的队友每5秒恢复11点法力。
		["使你的法术伤害"] = {"SPELL_DMG",}, -- Atiesh ID:22631
		["伤害"] = {"SPELL_DMG",},
		["法术能量"] = {"SPELL_DMG", "HEAL",},
		["神圣伤害"] = {"HOLY_SPELL_DMG",},
		["奥术伤害"] = {"ARCANE_SPELL_DMG",},
		["火焰伤害"] = {"FIRE_SPELL_DMG",},
		["自然伤害"] = {"NATURE_SPELL_DMG",},
		["冰霜伤害"] = {"FROST_SPELL_DMG",},
		["暗影伤害"] = {"SHADOW_SPELL_DMG",},
		["神圣法术伤害"] = {"HOLY_SPELL_DMG",},
		["奥术法术伤害"] = {"ARCANE_SPELL_DMG",},
		["火焰法术伤害"] = {"FIRE_SPELL_DMG",},
		["自然法术伤害"] = {"NATURE_SPELL_DMG",},
		["冰霜法术伤害"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
		["暗影法术伤害"] = {"SHADOW_SPELL_DMG",},
		["提高奥术法术和效果所造成的伤害"] = {"ARCANE_SPELL_DMG",},
		["提高火焰法术和效果所造成的伤害"] = {"FIRE_SPELL_DMG",},
		["提高冰霜法术和效果所造成的伤害"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		["提高神圣法术和效果所造成的伤害"] = {"HOLY_SPELL_DMG",},
		["提高自然法术和效果所造成的伤害"] = {"NATURE_SPELL_DMG",},
		["提高暗影法术和效果所造成的伤害"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
		
		["魔法和法术效果对亡灵造成的伤害"] = {"SPELL_DMG_UNDEAD",}, -- [黎明符文] ID:19812
		["所有法术和效果对亡灵所造成的伤害"] = {"SPELL_DMG_UNDEAD",}, -- [净妖长袍] ID:23085
		["魔法和法术效果对亡灵和恶魔所造成的伤害"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON",}, -- [勇士徽章] ID:23207
		
		["使法术治疗"] = {"HEAL",},
		["你的治疗效果"] = {"HEAL",}, -- Atiesh ID:22631
		["治疗法术"] = {"HEAL",}, -- +35 Healing Glove Enchant
		["治疗效果"] = {"HEAL",}, -- [圣使祝福手套] Socket Bonus
		["治疗"] = {"HEAL",},
		["法术治疗"] = {"HEAL",},
		["神圣效果"] = {"HEAL",},-- Enchant Ring - Healing Power
		["提高法术所造成的治疗效果"] = {"HEAL",},
		["提高所有法术和魔法效果所造成的治疗效果"] = {"HEAL",},
		["使周围半径30码范围内的所有小队成员的法术和魔法效果所造成的治疗效果"] = {"HEAL",}, -- Atiesh, ID: 22631

		["每秒伤害"] = {"DPS",},
		["每秒伤害提高"] = {"DPS",}, -- [Thorium Shells] ID: 15997

		["防御等级"] = {"DEFENSE_RATING",},
		["防御等级提高"] = {"DEFENSE_RATING",},
		["提高你的防御等级"] = {"DEFENSE_RATING",},
		["使防御等级"] = {"DEFENSE_RATING",},
		["使你的防御等级"] = {"DEFENSE_RATING",},
		
		["躲闪等级"] = {"DODGE_RATING",},
		["提高躲闪等级"] = {"DODGE_RATING",},
		["躲闪等级提高"] = {"DODGE_RATING",},
		["躲闪等级提高(%d+)"] = {"DODGE_RATING",},
		["提高你的躲闪等级"] = {"DODGE_RATING",},
		["使躲闪等级"] = {"DODGE_RATING",},
		["使你的躲闪等级"] = {"DODGE_RATING",},
		
		["招架等级"] = {"PARRY_RATING",},
		["提高招架等级"] = {"PARRY_RATING",},
		["提高你的招架等级"] = {"PARRY_RATING",},
		["使招架等级"] = {"PARRY_RATING",},
		["使你的招架等级"] = {"PARRY_RATING",},
		
		["盾挡等级"] = {"BLOCK_RATING",},
		["提高盾挡等级"] = {"BLOCK_RATING",},
		["提高你的盾挡等级"] = {"BLOCK_RATING",},
		["使盾挡等级"] = {"BLOCK_RATING",},
		["使你的盾挡等级"] = {"BLOCK_RATING",},
		
		["格挡等级"] = {"BLOCK_RATING",},
		["提高格挡等级"] = {"BLOCK_RATING",},
		["提高你的格挡等级"] = {"BLOCK_RATING",},
		["使格挡等级"] = {"BLOCK_RATING",},
		["使你的格挡等级"] = {"BLOCK_RATING",},
		
		["盾牌格挡等级"] = {"BLOCK_RATING",},
		["提高盾牌格挡等级"] = {"BLOCK_RATING",},
		["提高你的盾牌格挡等级"] = {"BLOCK_RATING",},
		["使盾牌格挡等级"] = {"BLOCK_RATING",},
		["使你的盾牌格挡等级"] = {"BLOCK_RATING",},

		["命中等级"] = {"MELEE_HIT_RATING",},
		["提高命中等级"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
		["提高近战命中等级"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
		["使你的命中等级"] = {"MELEE_HIT_RATING",},
		
		["法术命中等级"] = {"SPELL_HIT_RATING",},
		["提高法术命中等级"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
		["使你的法术命中等级"] = {"SPELL_HIT_RATING",},
		
		["远程命中等级"] = {"RANGED_HIT_RATING",},
		["提高远程命中等级"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
		["使你的远程命中等级"] = {"RANGED_HIT_RATING",},

		["爆击等级"] = {"MELEE_CRIT_RATING",},
		["提高爆击等级"] = {"MELEE_CRIT_RATING",},
		["使你的爆击等级"] = {"MELEE_CRIT_RATING",},
		
		["近战爆击等级"] = {"MELEE_CRIT_RATING",},
		["提高近战爆击等级"] = {"MELEE_CRIT_RATING",}, -- [屠杀者腰带] ID:21639
		["使你的近战爆击等级"] = {"MELEE_CRIT_RATING",},
		
		["法术爆击等级"] = {"SPELL_CRIT_RATING",},
		["法术爆击"] = {"SPELL_CRIT_RATING",},
		["提高法术爆击等级"] = {"SPELL_CRIT_RATING",}, -- [伊利达瑞的复仇] ID:28040
		["使你的法术爆击等级"] = {"SPELL_CRIT_RATING",},
		["使周围半径30码范围内的所有小队成员的法术爆击等级"] = {"SPELL_CRIT_RATING",}, -- Atiesh, ID: 22589
		
		["远程爆击等级"] = {"RANGED_CRIT_RATING",},
		["提高远程爆击等级"] = {"RANGED_CRIT_RATING",},
		["使你的远程爆击等级"] = {"RANGED_CRIT_RATING",},

		["提高命中躲闪等级"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING, Necklace of Trophies ID: 31275 (Patch 2.0.10 changed it to Hit Rating)
		["提高近战命中躲闪等级"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
		["提高远程命中躲闪等级"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
		["提高法术命中躲闪等级"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING

		["韧性"] = {"RESILIENCE_RATING",},
		["韧性等级"] = {"RESILIENCE_RATING",},
		["使你的韧性等级"] = {"RESILIENCE_RATING",},
		["提高爆击躲闪等级"] = {"MELEE_CRIT_AVOID_RATING",},
		["提高近战爆击躲闪等级"] = {"MELEE_CRIT_AVOID_RATING",},
		["提高远程爆击躲闪等级"] = {"RANGED_CRIT_AVOID_RATING",},
		["提高法术爆击躲闪等级"] = {"SPELL_CRIT_AVOID_RATING",},

		["急速等级"] = {"MELEE_HASTE_RATING"}, -- Enchant Gloves
		["攻击速度"] = {"MELEE_HASTE_RATING"},
		["法术急速等级"] = {"SPELL_HASTE_RATING"},
		["远程急速等级"] = {"RANGED_HASTE_RATING"},
		["提高急速等级"] = {"MELEE_HASTE_RATING"},
		["提高近战急速等级"] = {"MELEE_HASTE_RATING"},
		["提高法术急速等级"] = {"SPELL_HASTE_RATING"},
		["提高远程急速等级"] = {"RANGED_HASTE_RATING"},

		["匕首技能"] = {"DAGGER_WEAPON_RATING"},
		["匕首技能等级"] = {"DAGGER_WEAPON_RATING"},
		["剑类技能"] = {"SWORD_WEAPON_RATING"},
		["剑类武器技能等级"] = {"SWORD_WEAPON_RATING"},
		["单手剑技能"] = {"SWORD_WEAPON_RATING"},
		["单手剑技能等级"] = {"SWORD_WEAPON_RATING"},
		["双手剑技能"] = {"2H_SWORD_WEAPON_RATING"},
		["双手剑技能等级"] = {"2H_SWORD_WEAPON_RATING"},
		["斧类技能"] = {"AXE_WEAPON_RATING"},
		["斧类武器技能等级"] = {"AXE_WEAPON_RATING"},
		["单手斧技能"] = {"AXE_WEAPON_RATING"},
		["单手斧技能等级"] = {"AXE_WEAPON_RATING"},
		["双手斧技能"] = {"2H_AXE_WEAPON_RATING"},
		["双手斧技能等级"] = {"2H_AXE_WEAPON_RATING"},
		["锤类技能"] = {"MACE_WEAPON_RATING"},
		["锤类武器技能等级"] = {"MACE_WEAPON_RATING"},
		["单手锤技能"] = {"MACE_WEAPON_RATING"},
		["单手锤技能等级"] = {"MACE_WEAPON_RATING"},
		["双手锤技能"] = {"2H_MACE_WEAPON_RATING"},
		["双手锤技能等级"] = {"2H_MACE_WEAPON_RATING"},
		["枪械技能"] = {"GUN_WEAPON_RATING"},
		["枪械技能等级"] = {"GUN_WEAPON_RATING"},
		["弩技能"] = {"CROSSBOW_WEAPON_RATING"},
		["弩技能等级"] = {"CROSSBOW_WEAPON_RATING"},
		["弓技能"] = {"BOW_WEAPON_RATING"},
		["弓技能等级"] = {"BOW_WEAPON_RATING"},
		["野性战斗技能"] = {"FERAL_WEAPON_RATING"},
		["野性战斗技能等级"] = {"FERAL_WEAPON_RATING"},
		["拳套技能"] = {"FIST_WEAPON_RATING"},
		["拳套技能等级"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533

		["使你的精准等级提高"] = {"EXPERTISE_RATING"},
		-- Exclude
		["秒"] = false,
		["到"] = false,
		["格容器"] = false,
		["格箭袋"] = false,
		["格弹药袋"] = false,
		["远程攻击速度%"] = false, -- AV quiver
	},
}
DisplayLocale.zhCN = {
	----------------
	-- Stat Names --
	----------------
	-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
	-- localization effect when a locale is not available for that language, you don't have to use global
	-- strings in your localization.
	["StatIDToName"] = {
		--[StatID] = {FullName, ShortName},
		---------------------------------------------------------------------------
		-- Tier1 Stats - Stats parsed directly off items
		["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
		["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";
		
		["STEALTH_LEVEL"] = {"潜行等级", "潜行"},
		["IGNORE_ARMOR"] = {"你的攻击无视目标的 %d+ 点护甲值。", "忽略护甲"},
		["MELEE_DMG"] = {"近战伤害", "近战伤害"}, -- DAMAGE = "Damage"
		["MOUNT_SPEED"] = {"骑乘速度(%)", "骑速(%)"},
		["RUN_SPEED"] = {"移动速度(%)", "跑速(%)"},

		["STR"] = {SPELL_STAT1_NAME, "力"},
		["AGI"] = {SPELL_STAT2_NAME, "敏"},
		["STA"] = {SPELL_STAT3_NAME, "耐"},
		["INT"] = {SPELL_STAT4_NAME, "智"},
		["SPI"] = {SPELL_STAT5_NAME, "精"},
		["ARMOR"] = {ARMOR, ARMOR},
		["ARMOR_BONUS"] = {"护甲加成", "护甲"},

		["FIRE_RES"] = {RESISTANCE2_NAME, "火抗"},
		["NATURE_RES"] = {RESISTANCE3_NAME, "自然抗"},
		["FROST_RES"] = {RESISTANCE4_NAME, "冰抗"},
		["SHADOW_RES"] = {RESISTANCE5_NAME, "暗抗"},
		["ARCANE_RES"] = {RESISTANCE6_NAME, "奥抗"},

		["FISHING"] = {"钓鱼", "钓鱼"},
		["MINING"] = {"采矿", "采矿"},
		["HERBALISM"] = {"草药学", "草药"},
		["SKINNING"] = {"剥皮", "剥皮"},

		["BLOCK_VALUE"] = {"盾牌格挡值", "格挡值"},

		["AP"] = {ATTACK_POWER_TOOLTIP, "攻强"},
		["RANGED_AP"] = {RANGED_ATTACK_POWER, "远攻强度"},
		["FERAL_AP"] = {"野性"..ATTACK_POWER_TOOLTIP, "野性强度"},
		["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.."(亡灵)", "攻强(亡灵)"},
		["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.."(恶魔)", "攻强(恶魔)"},

		["HEAL"] = {"法术治疗", "治疗"},

		["SPELL_DMG"] = {"法术伤害", "法伤"},
		["SPELL_DMG_UNDEAD"] = {"法术伤害(亡灵)", PLAYERSTAT_SPELL_COMBAT.."法伤".."(亡灵)"},
		["SPELL_DMG_DEMON"] = {"法术伤害(恶魔)", PLAYERSTAT_SPELL_COMBAT.."法伤".."(亡灵)"},
		["HOLY_SPELL_DMG"] = {"神圣法术伤害", SPELL_SCHOOL1_CAP.."法伤"},
		["FIRE_SPELL_DMG"] = {"火焰法术伤害", SPELL_SCHOOL2_CAP.."法伤"},
		["NATURE_SPELL_DMG"] = {"自然法术伤害", SPELL_SCHOOL3_CAP.."法伤"},
		["FROST_SPELL_DMG"] = {"冰霜法术伤害", SPELL_SCHOOL4_CAP.."法伤"},
		["SHADOW_SPELL_DMG"] = {"暗影法术伤害", SPELL_SCHOOL5_CAP.."法伤"},
		["ARCANE_SPELL_DMG"] = {"奥术法术伤害", SPELL_SCHOOL6_CAP.."法伤"},

		["SPELLPEN"] = {"法术穿透", SPELL_PENETRATION},

		["HEALTH"] = {HEALTH, HP},
		["MANA"] = {MANA, MP},
		["HEALTH_REG"] = {"生命恢复", "HP5"},
		["MANA_REG"] = {"法力恢复", "MP5"},

		["MAX_DAMAGE"] = {"最大伤害", "大伤"},
		["DPS"] = {"每秒伤害", "DPS"},

		["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
		["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
		["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
		["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
		["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
		["RANGED_HIT_RATING"] = {"远程命中等级", "远程命中"}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
		["SPELL_HIT_RATING"] = {"法术命中等级", "法术命中"}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
		["MELEE_HIT_AVOID_RATING"] = {"近战命中躲闪等级", "近战命中躲闪"},
		["RANGED_HIT_AVOID_RATING"] = {"远程命中躲闪等级", "远程命中躲闪"},
		["SPELL_HIT_AVOID_RATING"] = {"法术命中躲闪等级", "法术命中躲闪"},
		["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
		["RANGED_CRIT_RATING"] = {"远程爆击等级", "远程爆击"},
		["SPELL_CRIT_RATING"] = {"法术爆击等级", "法术爆击"},
		["MELEE_CRIT_AVOID_RATING"] = {"爆击躲闪等级", "近战爆击躲闪"},
		["RANGED_CRIT_AVOID_RATING"] = {"远程爆击躲闪等级", "远程爆击躲闪"},
		["SPELL_CRIT_AVOID_RATING"] = {"法术爆击躲闪等级", "法术爆击躲闪"},
		["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
		["MELEE_HASTE_RATING"] = {"近战急速等级", "近战急速"}, --
		["RANGED_HASTE_RATING"] = {"远程急速等级", "远程急速"},
		["SPELL_HASTE_RATING"] = {"法术急速等级", "法术急速"},
		["DAGGER_WEAPON_RATING"] = {"匕首技能等级", "匕首等级"}, -- SKILL = "Skill"
		["SWORD_WEAPON_RATING"] = {"剑类武器技能等级", "剑等级"},
		["2H_SWORD_WEAPON_RATING"] = {"双手剑技能等级", "双手剑等级"},
		["AXE_WEAPON_RATING"] = {"斧类武器技能等级", "斧等级"},
		["2H_AXE_WEAPON_RATING"] = {"双手斧技能等级", "双手斧等级"},
		["MACE_WEAPON_RATING"] = {"锤类武器技能等级", "锤等级"},
		["2H_MACE_WEAPON_RATING"] = {"双手锤技能等级", "双手锤等级"},
		["GUN_WEAPON_RATING"] = {"枪械技能等级", "枪等级"},
		["CROSSBOW_WEAPON_RATING"] = {"弩技能等级", "弩等级"},
		["BOW_WEAPON_RATING"] = {"弓技能等级", "弓等级"},
		["FERAL_WEAPON_RATING"] = {"野性技能等级", "野性等级"},
		["FIST_WEAPON_RATING"] = {"徒手技能等级", "徒手等级"},
		["STAFF_WEAPON_RATING"] = {"法杖技能等级", "法杖等级"}, -- Leggings of the Fang ID:10410
		["EXPERTISE_RATING"] = {"精准等级", "精准等级"},

		---------------------------------------------------------------------------
		-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
		-- Str -> AP, Block Value
		-- Agi -> AP, Crit, Dodge
		-- Sta -> Health
		-- Int -> Mana, Spell Crit
		-- Spi -> mp5nc, hp5oc
		-- Ratings -> Effect
		["HEALTH_REG_OUT_OF_COMBAT"] = {"正常回血", "正常回血"},
		["MANA_REG_NOT_CASTING"] = {"正常回魔", "正常回魔"},
		["MELEE_CRIT_DMG_REDUCTION"] = {"爆击减伤(%)", "爆击减伤(%)"},
		["RANGED_CRIT_DMG_REDUCTION"] = {"远程爆击减伤(%)", "远程爆击减伤(%)"},
		["SPELL_CRIT_DMG_REDUCTION"] = {"法术爆击减伤(%)", "法术爆击减伤(%)"},
		["DEFENSE"] = {DEFENSE, DEFENSE},
		["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
		["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
		["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
		["AVOIDANCE"] = {"完全豁免(%)", "豁免(%)"},
		["MELEE_HIT"] = {"物理命中(%)", "命中(%)"},
		["RANGED_HIT"] = {"远程命中(%)", "远程命中(%)"},
		["SPELL_HIT"] = {"法术命中(%)", "法术命中(%)"},
		["MELEE_HIT_AVOID"] = {"躲闪命中(%)", "躲闪命中(%)"},
		["RANGED_HIT_AVOID"] = {"躲闪远程命中(%)", "躲闪远程命中(%)"},
		["SPELL_HIT_AVOID"] = {"躲闪法术命中(%)", "躲闪法术命中(%)"},
		["MELEE_CRIT"] = {"物理爆击(%)", "物理爆击(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
		["RANGED_CRIT"] = {"远程爆击(%)", "远程爆击(%)"},
		["SPELL_CRIT"] = {"法术爆击(%)", "法术爆击(%)"},
		["MELEE_CRIT_AVOID"] = {"躲闪近战爆击(%)", "躲闪爆击(%)"},
		["RANGED_CRIT_AVOID"] = {"躲闪远程爆击(%)", "躲闪远程爆击(%)"},
		["SPELL_CRIT_AVOID"] = {"躲闪法术爆击(%)", "躲闪法术爆击(%)"},
		["MELEE_HASTE"] = {"近战急速(%)", "近战急速(%)"}, --
		["RANGED_HASTE"] = {"远程急速(%)", "远程急速(%)"},
		["SPELL_HASTE"] = {"法术急速(%)", "法术急速(%)"},
		["DAGGER_WEAPON"] = {"匕首技能", "匕首"}, -- SKILL = "Skill"
		["SWORD_WEAPON"] = {"剑技能", "剑"},
		["2H_SWORD_WEAPON"] = {"双手剑技能", "双手剑"},
		["AXE_WEAPON"] = {"斧技能", "斧"},
		["2H_AXE_WEAPON"] = {"双手斧技能", "双手斧"},
		["MACE_WEAPON"] = {"锤技能", "锤"},
		["2H_MACE_WEAPON"] = {"双手锤技能", "双手锤"},
		["GUN_WEAPON"] = {"枪械技能", "枪械"},
		["CROSSBOW_WEAPON"] = {"弩技能", "弩"},
		["BOW_WEAPON"] = {"弓技能", "弓"},
		["FERAL_WEAPON"] = {"野性技能", "野性"},
		["FIST_WEAPON"] = {"徒手战斗技能", "徒手"},
		["STAFF_WEAPON_RATING"] = {"法杖技能", "法杖"}, -- Leggings of the Fang ID:10410
		["EXPERTISE"] = {"精准", "精准"},

		---------------------------------------------------------------------------
		-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
		-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
		-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
		-- Expertise -> Dodge Neglect, Parry Neglect
		["DODGE_NEGLECT"] = {"防止被躲闪(%)", "防止被躲闪(%)"},
		["PARRY_NEGLECT"] = {"防止被招架(%)", "防止被招架(%)"},
		["BLOCK_NEGLECT"] = {"防止被格挡(%)", "防止被格挡(%)"},

		---------------------------------------------------------------------------
		-- Talants
		["MELEE_CRIT_DMG"] = {"物理爆击(%)", "爆击(%)"},
		["RANGED_CRIT_DMG"] = {"远程爆击(%)", "远程爆击(%)"},
		["SPELL_CRIT_DMG"] = {"法术爆击(%)", "法爆(%)"},

		---------------------------------------------------------------------------
		-- Spell Stats
		-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
		-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
		-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
		-- Use strsplit("@", text) to seperate the spell name and statid
		["THREAT"] = {"威胁值", "威胁"},
		["CAST_TIME"] = {"施法时间", "施法时间"},
		["MANA_COST"] = {"消耗法力", "消耗法力"},
		["RAGE_COST"] = {"消耗怒气", "消耗怒气"},
		["ENERGY_COST"] = {"消耗能量", "消耗能量"},
		["COOLDOWN"] = {"冷却时间", "冷却"},

		---------------------------------------------------------------------------
		-- Stats Mods
		["MOD_STR"] = {"修正力量(%)", "修正力量(%)"},
		["MOD_AGI"] = {"修正敏捷(%)", "修正敏捷(%)"},
		["MOD_STA"] = {"修正耐力(%)", "修正耐力(%)"},
		["MOD_INT"] = {"修正智力(%)", "修正智力(%)"},
		["MOD_SPI"] = {"修正精神(%)", "修正精神(%)"},
		["MOD_HEALTH"] = {"修正生命(%)", "修正生命(%)"},
		["MOD_MANA"] = {"修正法力(%)", "修正法力(%)"},
		["MOD_ARMOR"] = {"修正护甲(%)", "修正装甲(%)"},
		["MOD_BLOCK_VALUE"] = {"修正格挡值(%)", "修正格挡值(%)"},
		["MOD_DMG"] = {"修正伤害(%)", "修正伤害(%)"},
		["MOD_DMG_TAKEN"] = {"修正承受伤害(%)", "修正受伤害(%)"},
		["MOD_CRIT_DAMAGE"] = {"修正爆击(%)", "修正爆击(%)"},
		["MOD_CRIT_DAMAGE_TAKEN"] = {"修正承受爆击(%)", "修正受爆击(%)"},
		["MOD_THREAT"] = {"修正威胁(%)", "修正威胁(%)"},
		["MOD_AP"] = {"修正近战攻击强度(%)", "修正攻强(%)"},
		["MOD_RANGED_AP"] = {"修正远程攻击强度(%)", "修正远攻强度(%)"},
		["MOD_SPELL_DMG"] = {"修正法术伤害(%)", "修正法伤(%)"},
		["MOD_HEALING"] = {"修正法术治疗(%)", "修正治疗(%)"},
		["MOD_CAST_TIME"] = {"修正施法时间(%)", "修正施法时间(%)"},
		["MOD_MANA_COST"] = {"修正消耗法力(%)", "修正消耗法力(%)"},
		["MOD_RAGE_COST"] = {"修正消耗怒气(%)", "修正消耗怒气(%)"},
		["MOD_ENERGY_COST"] = {"修正消耗能量(%)", "修正消耗能量(%)"},
		["MOD_COOLDOWN"] = {"修正技能冷却(%)", "修正技能冷却(%)"},

		---------------------------------------------------------------------------
		-- Misc Stats
		["WEAPON_RATING"] = {"武器技能等级", "武器技能等级"},
		["WEAPON_SKILL"] = {"武器技能", "武器技能"},
		["MAINHAND_WEAPON_RATING"] = {"主手武器技能等级", "主手武器技能等级"},
		["OFFHAND_WEAPON_RATING"] = {"副手武器技能等级", "副手武器技能等级"},
		["RANGED_WEAPON_RATING"] = {"远程武器技能等级", "远程武器技能等级"},
	},
}

--[[
PatternLocale.esES = {
}
DisplayLocale.esES = {
}
--]]

-- Uncomment below to print out print out every missing translation for each locale
-- L:EnableDebugging()
-- D:EnableDebugging()

-- Enable dynamic locales for Display text
D:EnableDynamicLocales()

-- Add all lower case strings to ["StatIDLookup"]
local strutf8lower = string.utf8lower
for n, l in pairs(PatternLocale) do
	if type(l) == "table" and type(l.StatIDLookup) == "table" then
		local temp = {}
		for k, v in pairs(l.StatIDLookup) do
			temp[strutf8lower(k)] = v
		end
		for k, v in pairs(temp) do
			l.StatIDLookup[k] = v
		end
	end
	-- Register AceLocale-2.2 translations
	L:RegisterTranslations(n, function() return l end)
end
for n, l in pairs(DisplayLocale) do
	-- Register AceLocale-2.2 translations
	D:RegisterTranslations(n, function() return l end)
end

L:Debug()


--------------------
-- Initialization --
--------------------
local StatLogic = {}


-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection


--------------
-- Activate --
--------------
local tip, tipMiner

-- Called when a newer version is registered
local function activate(self, oldLib)
	if oldLib and oldLib.tip then
		tip = oldLib.tip
		self.tip = tip
	else
		-- Create a custom tooltip for scanning
		tip = CreateFrame("GameTooltip", "StatLogicTooltip", nil, "GameTooltipTemplate")
		self.tip = tip
		tip:SetOwner(UIParent, "ANCHOR_NONE")
		for i = 1, 30 do
			tip[i] = _G["StatLogicTooltipTextLeft"..i]
			if not tip[i] then
				tip[i] = tip:CreateFontString()
				tip:AddFontStrings(tip[i], tip:CreateFontString())
			end
		end
	end
	
	if oldLib and oldLib.tipMiner then
		tipMiner = oldLib.tipMiner
		self.tipMiner = tipMiner
	else
		-- Create a custom tooltip for data mining
		tipMiner = CreateFrame("GameTooltip", "StatLogicMinerTooltip", nil, "GameTooltipTemplate")
		self.tipMiner = tipMiner
		tipMiner:SetOwner(UIParent, "ANCHOR_NONE")
		for i = 1, 30 do
			tipMiner[i] = _G["StatLogicMinerTooltipTextLeft"..i]
			if not tipMiner[i] then
				tipMiner[i] = tipMiner:CreateFontString()
				tipMiner:AddFontStrings(tipMiner[i], tipMiner:CreateFontString())
			end
		end
	end
end


---------------------
-- Local Variables --
---------------------
-- Player info
local _, playerClass = UnitClass("player")
local _, playerRace = UnitRace("player")

-- Localize globals
local _G = getfenv(0)
local strfind = strfind
local strsub = strsub
local strupper = strupper
local strutf8lower = string.utf8lower
local strmatch = strmatch
local strtrim = strtrim
local strsplit = strsplit
local strjoin = strjoin
local gmatch = gmatch
local gsub = gsub
local strutf8sub = string.utf8sub
local pairs = pairs
local ipairs = ipairs
local type = type
local tonumber = L.tonumber
local loadstring = loadstring
local GetInventoryItemLink = GetInventoryItemLink
local unpack = unpack
local GetLocale = GetLocale
local IsUsableSpell = IsUsableSpell
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetPlayerBuffName = GetPlayerBuffName
local GetTalentInfo = GetTalentInfo
wowBuildNo = select(2, GetBuildInfo()) -- need a global for loadstring
local wowBuildNo = wowBuildNo

-- Cached GetItemInfo
local GetItemInfoCached = setmetatable({}, { __index = function(self, n)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture = GetItemInfo(n)
		if itemName then
				-- store in cache only if it exists in the local cache
				self[n] = {itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture}
				return self[n] -- return result
		end
end })
local GetItemInfo = function(item)
	local info = GetItemInfoCached[item]
	if info then
		return unpack(info)
	end
end


---------------
-- Lua Tools --
---------------
-- metatable for stat tables
local statTableMetatable = {
	__add = function(op1, op2)
		if type(op2) == "table" then
			for k, v in pairs(op2) do
				if type(v) == "number" then
					op1[k] = (op1[k] or 0) + v
					if op1[k] == 0 then
						op1[k] = nil
					end
				end
			end
		end
		return op1
	end,
	__sub = function(op1, op2)
		if type(op2) == "table" then
			for k, v in pairs(op2) do
				if type(v) == "number" then
					op1[k] = (op1[k] or 0) - v
					if op1[k] == 0 then
						op1[k] = nil
					end
				elseif k == "itemType" then
					local i = 1
					while op1["diffItemType"..i] do
						i = i + 1
					end
					op1["diffItemType"..i] = op2.itemType
				end
			end
		end
		return op1
	end,
}

-- Table pool borrowed from Tablet-2.0 (ckknight) --
local pool = {}

-- Delete table and return to pool
local function del(t)
	if t then
		for k in pairs(t) do
			t[k] = nil
		end
		setmetatable(t, nil)
		pool[t] = true
	end
end

local function delMulti(t)
	if t then
		for k in pairs(t) do
			if type(t[k]) == "table" then
				del(t[k])
			else
				t[k] = nil
			end
		end
		setmetatable(t, nil)
		pool[t] = true
	end
end

-- Copy table
local function copy(parent)
	local t = next(pool) or {}
	pool[t] = nil
	if parent then
		for k,v in pairs(parent) do
			t[k] = v
		end
		setmetatable(t, getmetatable(parent))
	end
	return t
end

-- New table
local function new(...)
	local t = next(pool) or {}
	pool[t] = nil

	for i = 1, select('#', ...), 2 do
		local k = select(i, ...)
		if k then
			t[k] = select(i+1, ...)
		else
			break
		end
	end
	return t
end

-- New stat table
local function newStatTable(...)
	local t = next(pool) or {}
	pool[t] = nil
	setmetatable(t, statTableMetatable)

	for i = 1, select('#', ...), 2 do
		local k = select(i, ...)
		if k then
			t[k] = select(i+1, ...)
		else
			break
		end
	end
	return t
end

StatLogic.StatTable = {}
StatLogic.StatTable.new = newStatTable
StatLogic.StatTable.del = del
StatLogic.StatTable.copy = copy

-- End of Table pool --

-- deletes the contents of a table, then returns itself
local function clearTable(t)
	if t then
		for k in pairs(t) do
			if type(t[k]) == "table" then
				del(t[k]) -- child tables get put into the pool
			else
				t[k] = nil
			end
		end
		setmetatable(t, nil)
	end
	return t
end

-- copyTable
local function copyTable(to, from)
	if not clearTable(to) then
		to = new()
	end
	for k,v in pairs(from) do
		if type(k) == "table" then
			k = copyTable(new(), k)
		end
		if type(v) == "table" then
			v = copyTable(new(), v)
		end
		to[k] = v
	end
	setmetatable(to, getmetatable(from))
	return to
end


local function print(text)
	if DEBUG == true then
		DEFAULT_CHAT_FRAME:AddMessage(text)
	end
end

-- SetTip("item:3185:0:0:0:0:0:1957")
function SetTip(item)
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	ItemRefTooltip:ClearLines()
	ItemRefTooltip:SetHyperlink(link)
	ItemRefTooltip:Show()
end

----------------
-- Stat Tools --
----------------
local function StripGlobalStrings(text)
	-- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	text = gsub(text, "%%%%", "%%") -- "%%" -> "%"
	text = gsub(text, " ?%%%d?%.?%d?%$?[cdsgf]", "") -- delete "%d", "%s", "%c", "%g", "%2$d", "%.2f" and a space in front of it if found
	-- So StripGlobalStrings(ITEM_SOCKET_BONUS) = "Socket Bonus:"
	return text
end

local ClassNameToID = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"DRUID",
	["WARRIOR"] = 1,
	["PALADIN"] = 2,
	["HUNTER"] = 3,
	["ROGUE"] = 4,
	["PRIEST"] = 5,
	["SHAMAN"] = 6,
	["MAGE"] = 7,
	["WARLOCK"] = 8,
	["DRUID"] = 9,
}

function StatLogic:GetClassIDFromName(class)
	return ClassNameToID[class]
end

function StatLogic:GetStatNameFromID(stat)
	local name = D.StatIDToName[stat]
	if not name then return end
	return unpack(name)
end

function StatLogic:SetStatNameLocale(locale)
	if D:HasLocale(locale) then
		D:SetLocale(locale)
	end
end

--[[
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
--]]

local RatingNameToID = {
	[CR_WEAPON_SKILL] = "WEAPON_RATING",
	[CR_DEFENSE_SKILL] = "DEFENSE_RATING",
	[CR_DODGE] = "DODGE_RATING",
	[CR_PARRY] = "PARRY_RATING",
	[CR_BLOCK] = "BLOCK_RATING",
	[CR_HIT_MELEE] = "MELEE_HIT_RATING",
	[CR_HIT_RANGED] = "RANGED_HIT_RATING",
	[CR_HIT_SPELL] = "SPELL_HIT_RATING",
	[CR_CRIT_MELEE] = "MELEE_CRIT_RATING",
	[CR_CRIT_RANGED] = "RANGED_CRIT_RATING",
	[CR_CRIT_SPELL] = "SPELL_CRIT_RATING",
	[CR_HIT_TAKEN_MELEE] = "MELEE_HIT_AVOID_RATING",
	[CR_HIT_TAKEN_RANGED] = "RANGED_HIT_AVOID_RATING",
	[CR_HIT_TAKEN_SPELL] = "SPELL_HIT_AVOID_RATING",
	[CR_CRIT_TAKEN_MELEE] = "MELEE_CRIT_AVOID_RATING",
	[CR_CRIT_TAKEN_RANGED] = "RANGED_CRIT_AVOID_RATING",
	[CR_CRIT_TAKEN_SPELL] = "SPELL_CRIT_AVOID_RATING",
	[CR_HASTE_MELEE] = "MELEE_HASTE_RATING",
	[CR_HASTE_RANGED] = "RANGED_HASTE_RATING",
	[CR_HASTE_SPELL] = "SPELL_HASTE_RATING",
	[CR_WEAPON_SKILL_MAINHAND] = "MAINHAND_WEAPON_RATING",
	[CR_WEAPON_SKILL_OFFHAND] = "OFFHAND_WEAPON_RATING",
	[CR_WEAPON_SKILL_RANGED] = "RANGED_WEAPON_RATING",
	[CR_EXPERTISE] = "EXPERTISE_RATING",
	["DEFENSE_RATING"] = CR_DEFENSE_SKILL,
	["DODGE_RATING"] = CR_DODGE,
	["PARRY_RATING"] = CR_PARRY,
	["BLOCK_RATING"] = CR_BLOCK,
	["MELEE_HIT_RATING"] = CR_HIT_MELEE,
	["RANGED_HIT_RATING"] = CR_HIT_RANGED,
	["SPELL_HIT_RATING"] = CR_HIT_SPELL,
	["MELEE_CRIT_RATING"] = CR_CRIT_MELEE,
	["RANGED_CRIT_RATING"] = CR_CRIT_RANGED,
	["SPELL_CRIT_RATING"] = CR_CRIT_SPELL,
	["MELEE_HIT_AVOID_RATING"] = CR_HIT_TAKEN_MELEE,
	["RANGED_HIT_AVOID_RATING"] = CR_HIT_TAKEN_RANGED,
	["SPELL_HIT_AVOID_RATING"] = CR_HIT_TAKEN_SPELL,
	["MELEE_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_MELEE,
	["RANGED_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_RANGED,
	["SPELL_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_SPELL,
	["RESILIENCE_RATING"] = CR_CRIT_TAKEN_MELEE,
	["MELEE_HASTE_RATING"] = CR_HASTE_MELEE,
	["RANGED_HASTE_RATING"] = CR_HASTE_RANGED,
	["SPELL_HASTE_RATING"] = CR_HASTE_SPELL,
	["DAGGER_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["SWORD_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_SWORD_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["AXE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_AXE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["MACE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_MACE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["GUN_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["CROSSBOW_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["BOW_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["FERAL_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["FIST_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["WEAPON_RATING"] = CR_WEAPON_SKILL,
	["MAINHAND_WEAPON_RATING"] = CR_WEAPON_SKILL_MAINHAND,
	["OFFHAND_WEAPON_RATING"] = CR_WEAPON_SKILL_OFFHAND,
	["RANGED_WEAPON_RATING"] = CR_WEAPON_SKILL_RANGED,
	["EXPERTISE_RATING"] = CR_EXPERTISE,
}

function StatLogic:GetRatingIDFromName(rating)
	return RatingNameToID[rating]
end

local RatingIDToConvertedStat = {
	"WEAPON_SKILL",
	"DEFENSE",
	"DODGE",
	"PARRY",
	"BLOCK",
	"MELEE_HIT",
	"RANGED_HIT",
	"SPELL_HIT",
	"MELEE_CRIT",
	"RANGED_CRIT",
	"SPELL_CRIT",
	"MELEE_HIT_AVOID",
	"RANGED_HIT_AVOID",
	"SPELL_HIT_AVOID",
	"MELEE_CRIT_AVOID",
	"RANGED_CRIT_AVOID",
	"SPELL_CRIT_AVOID",
	"MELEE_HASTE",
	"RANGED_HASTE",
	"SPELL_HASTE",
	"WEAPON_SKILL",
	"WEAPON_SKILL",
	"WEAPON_SKILL",
	"EXPERTISE",
}

local function GetStanceIcon()
	local currentStance = GetShapeshiftForm()
	if currentStance ~= 0 then
		return GetShapeshiftFormInfo(currentStance)
	end
end

local function GetPlayerBuffRank(buff)
	local hasBuff, rank = GetPlayerBuffName(buff)
	if hasBuff then
		return strmatch(rank, "(%d+)") or 1
	end
end

local function GetTotalDefense(unit)
	local base, modifier = UnitDefense(unit);
	return base + modifier
end


--============--
-- Base Stats --
--============--
--[[
local RaceClassStatBase = {
	-- The Human Spirit - Increase Spirit by 5%
	Human = { --{20, 20, 20, 20, 21}
		WARRIOR = { --{3, 0, 2, 0, 0}
			{23, 20, 22, 20, 22}
		},
		PALADIN = { --{2, 0, 2, 0, 1}
			{22, 20, 22, 20, 23}
		},
		ROGUE = { --{1, 3, 1, 0, 0}
			{21, 23, 21, 20, 22}
		},
		PRIEST = { --{0, 0, 0, 2, 3}
			{20, 20, 20, 22, 25}
		},
		MAGE = { --{0, 0, 0, 3, 2}
			{20, 20, 20, 23, 24}
		},
		WARLOCK = { --{0, 0, 1, 2, 2}
			{20, 20, 21, 22, 24}
		},
	},
	Dwarf = { --{22, 16, 23, 19, 19}
		WARRIOR = {
			{25, 16, 25, 19, 19}
		},
		PALADIN = {
			{24, 16, 25, 19, 20}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{22, 19, 24, 19, 20}
		},
		ROGUE = {
			{23, 19, 24, 19, 19}
		},
		PRIEST = {
			{22, 16, 23, 21, 22}
		},
	},
	NightElf = { --{17, 25, 19, 20, 20}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{20, 25, 21, 20, 20}
		},
		HUNTER = {
			{17, 28, 20, 20, 21}
		},
		ROGUE = {
			{18, 28, 20, 20, 20}
		},
		PRIEST = {
			{17, 25, 19, 22, 23}
		},
		DRUID = { --{1, 0, 0, 2, 2}
			{18, 25, 19, 22, 22}
		},
	},
	-- Expansive Mind - Increase Intelligence by 5%
	Gnome = { --{15, 23, 19, 24, 20}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{18, 23, 21, 24, 20}
		},
		ROGUE = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
	Draenei = { --{21, 17, 19, 21, 22}
		WARRIOR = { --{3, 0, 2, 0, 0}
			{24, 17, 21, 21, 22}
		},
		PALADIN = { --{2, 0, 2, 0, 1}
			{23, 17, 21, 21, 23}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{21, 20, 20, 21, 23}
		},
		PRIEST = { --{0, 0, 0, 2, 3}
			{21, 17, 19, 23, 25}
		},
		SHAMAN = { --{1, 0, 1, 1, 2}
			{26, 15, 23, 16, 24}
		},
		MAGE = { --{0, 0, 0, 3, 2}
			{21, 17, 19, 24, 24}
		},
	},
	Orc = { --{23, 17, 22, 17, 23}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{26, 17, 24, 17, 23}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{23, 20, 23, 17, 24}
		},
		ROGUE = { --{1, 3, 1, 0, 0}
			{, , , , }
		},
		SHAMAN = { --{1, 0, 1, 1, 2}
			{24, 17, 23, 18, 25}
		},
		WARLOCK = { --{0, 0, 1, 2, 2}
			{, , , , }
		},
	},
	Scourge = { --{19, 18, 21, 18, 25}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{22, 18, 23, 18, 25}
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
	Tauren = { --{25, 15, 22, 15, 22}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{28, 15, 24, 15, 22}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{, , , , }
		},
		SHAMAN = {
			{, , , , }
		},
		DRUID = { --{1, 0, 0, 2, 2}
			{26, 15, 22, 17, 24}
		},
	},
	Troll = { --{21, 22, 21, 16, 21}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{24, 22, 23, 16, 21}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{, , , , }
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		SHAMAN = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
	},
	BloodElf = { --{17, 22, 18, 24, 19}
		PALADIN = {--{2, 0, 2, 0, 1}
			{24, 16, 25, 19, 20}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{21, 25, 22, 16, 22}
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
}
--]]
local RaceBaseStat = {
	["Human"] = {20, 20, 20, 20, 21},
	["Dwarf"] = {22, 16, 23, 19, 19},
	["NightElf"] = {17, 25, 19, 20, 20},
	["Gnome"] = {15, 23, 19, 24, 20},
	["Draenei"] = {21, 17, 19, 21, 22},
	["Orc"] = {23, 17, 22, 17, 23},
	["Scourge"] = {19, 18, 21, 18, 25},
	["Tauren"] = {25, 15, 22, 15, 22},
	["Troll"] = {21, 22, 21, 16, 21},
	["BloodElf"] = {17, 22, 18, 24, 19},
}
local ClassBonusStat = {
	["DRUID"] = {1, 0, 0, 2, 2},
	["HUNTER"] = {0, 3, 1, 0, 1},
	["MAGE"] = {0, 0, 0, 3, 2},
	["PALADIN"] = {2, 0, 2, 0, 1},
	["PRIEST"] = {0, 0, 0, 2, 3},
	["ROGUE"] = {1, 3, 1, 0, 0},
	["SHAMAN"] = {1, 0, 1, 1, 2},
	["WARLOCK"] = {0, 0, 1, 2, 2},
	["WARRIOR"] = {3, 0, 2, 0, 0},
}
local ClassBaseHealth = {
	["DRUID"] = 54,
	["HUNTER"] = 46,
	["MAGE"] = 52,
	["PALADIN"] = 38,
	["PRIEST"] = 52,
	["ROGUE"] = 45,
	["SHAMAN"] = 47,
	["WARLOCK"] = 43,
	["WARRIOR"] = 40,
}
local ClassBaseMana = {
	["DRUID"] = 70,
	["HUNTER"] = 85,
	["MAGE"] = 120,
	["PALADIN"] = 80,
	["PRIEST"] = 130,
	["ROGUE"] = 0,
	["SHAMAN"] = 75,
	["WARLOCK"] = 110,
	["WARRIOR"] = 0,
}
--http://wowvault.ign.com/View.php?view=Stats.List&category_select_id=9

--==================================--
-- Stat Mods from Talants and Buffs --
--==================================--
--[[ Aura mods from Thottbot
Apply Aura: Mod Total Stat % (All stats)
Apply Aura: Mod Total Stat % (Strength)
Apply Aura: Mod Total Stat % (Agility)
Apply Aura: Mod Total Stat % (Stamina)
Apply Aura: Mod Total Stat % (Intellect)
Apply Aura: Mod Total Stat % (Spirit)
Apply Aura: Mod Max Health %
Apply Aura: Reduces Attacker Chance to Hit with Melee
Apply Aura: Reduces Attacker Chance to Hit with Ranged
Apply Aura: Reduces Attacker Chance to Hit with Spells (Spells)
Apply Aura: Reduces Attacker Chance to Crit with Melee
Apply Aura: Reduces Attacker Chance to Crit with Ranged
Apply Aura: Reduces Attacker Critical Hit Damage with Melee by %
Apply Aura: Reduces Attacker Critical Hit Damage with Ranged by %
Apply Aura: Mod Dmg % (Spells)
Apply Aura: Mod Dmg % Taken (Fire, Frost)
Apply Aura: Mod Dmg % Taken (Spells)
Apply Aura: Mod Dmg % Taken (All)
Apply Aura: Mod Dmg % Taken (Physical)
Apply Aura: Mod Base Resistance % (Physical)
Apply Aura: Mod Block Percent
Apply Aura: Mod Parry Percent
Apply Aura: Mod Dodge Percent
Apply Aura: Mod Shield Block %
Apply Aura: Mod Detect
Apply Aura: Mod Skill Talent (Defense)
--]]
--[[ StatModAuras, mods not in use are commented out for now
"MOD_STR",
"MOD_AGI",
"MOD_STA",
"MOD_INT",
"MOD_SPI",
"MOD_HEALTH",
"MOD_MANA",
"MOD_ARMOR",
"MOD_BLOCK_VALUE",
--"MOD_DMG", school,
"MOD_DMG_TAKEN", school,
--"MOD_CRIT_DAMAGE", school,
"MOD_CRIT_DAMAGE_TAKEN", school,
--"MOD_THREAT", school,

"ADD_DODGE",
--"ADD_PARRY",
--"ADD_BLOCK",
--"ADD_STEALTH_DETECT",
--"ADD_STEALTH",
--"ADD_DEFENSE",
--"ADD_THREAT", school,
"ADD_HIT_TAKEN", school,
"ADD_CRIT_TAKEN", school,

--Talents
"ADD_SPELL_DMG_MOD_INT"
"ADD_HEALING_MOD_INT"
"ADD_MANA_REG_MOD_INT"
"ADD_RANGED_AP_MOD_INT"
"ADD_ARMOR_MOD_INT"
"ADD_SPELL_DMG_MOD_STA"
"ADD_SPELL_DMG_MOD_SPI"
"ADD_SPELL_DMG_MOD_AP" -- Shaman Mental Quickness
"ADD_HEALING_MOD_SPI"
"ADD_HEALING_MOD_STR"
"ADD_HEALING_MOD_AP" -- Shaman Mental Quickness
"ADD_MANA_REG_MOD_NORMAL_MANA_REG"
"MOD_AP"
"MOD_RANGED_AP"
"MOD_SPELL_DMG"
"MOD_HEALING"

--"ADD_CAST_TIME"
--"MOD_CAST_TIME"
--"ADD_MANA_COST"
--"MOD_MANA_COST"
--"ADD_RAGE_COST"
--"MOD_RAGE_COST"
--"ADD_ENERGY_COST"
--"MOD_ENERGY_COST"
--"ADD_COOLDOWN"
--"MOD_COOLDOWN"
--]]

local StatModInfo = {
	------------------------------------------------------------------------------
	-- initialValue: sets the initial value for the stat mod
	-- if initialValue == 0, inter-mod operations are done with addition,
	-- if initialValue == 1, inter-mod operations are done with multiplication,
	------------------------------------------------------------------------------
	-- finalAdjust: added to the final result before returning,
	-- so we can adjust the return value to be used in addition or multiplication
	-- for addition: initialValue + finalAdjust = 0
	-- for multiplication: initialValue + finalAdjust = 1
	------------------------------------------------------------------------------
	-- school: school arg is required for these mods
	------------------------------------------------------------------------------
	["ADD_CRIT_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 0,
		school = true,
	},
	["ADD_HIT_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 0,
		school = true,
	},
	["ADD_DODGE"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_MANA_REG_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_RANGED_AP_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_ARMOR_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_STR"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_AGI"] = { -- Nurturing Instinct
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["MOD_CRIT_DAMAGE_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_CRIT_DAMAGE"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_ARMOR"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_HEALTH"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_MANA"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_STR"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_AGI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_BLOCK_VALUE"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_RANGED_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPELL_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_HEALING"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
}

------------------
-- StatModTable --
------------------
local StatModTable = {
	["DRUID"] = {
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Nurturing Instinct (Rank 2) - 2,14
		--        Increases your healing spells by up to 25%/50% of your Strength.
		-- 2.4.0 Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
		["ADD_HEALING_MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.5, 1,
				},
			},
		},
		-- Druid: Intensity (Rank 3) - 3,6
		--        Allows 5%/10%/15% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Druid: Dreamstate (Rank 3) - 1,17
		--        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.04, 0.07, 0.10,
				},
			},
		},
		-- Druid: Feral Swiftness (Rank 2) - 2,6
		--        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[2] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[3] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Druid: Natural Perfection (Rank 3) - 3,18
		--        Your critical strike chance with all spells is increased by 3% and melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Druid: Balance of Power (Rank 2) - 1,16
		--        Increases your chance to hit with all spells and reduces the chance you'll be hit by spells by 2%/4%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Druid: Thick Hide (Rank 3) - 2,5
		--        Increases your Armor contribution from items by 4%/7%/10%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Moonkin Form - Buff
		--        While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					1.04, 1.07, 1.1,
				},
			},
			[2] = {
				["rank"] = {
					2.8,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[3] = {
				["rank"] = {
					5,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[4] = {
				["rank"] = {
					5,
				},
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STA"] = { -- Heart of the Wild: +4%/8%/12%/16%/20% stamina in bear / dire bear
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[2] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[3] = { -- Survival of the Fittest: +1%/2%/3% all stats
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			[4] = { -- Bear Form / Dire Bear Form: +25% stamina
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[5] = { -- Bear Form / Dire Bear Form: +25% stamina
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- 2.3.0 This talent no longer provides 4/8/12/16/20% bonus Strength in Cat Form. Instead it provides 2/4/6/8/10% bonus attack power.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Living Spirit (Rank 3) - 3,16
		--        Increases your total Spirit by 5%/10%/15%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_SPI"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
	},
	["HUNTER"] = {
		-- Hunter: Aspect of the Viper - Buff
		--         The hunter takes on the aspects of a viper, regenerating mana equal to 25% of his Intellect every 5 sec.
		-- TODO: Gronnstalker's Armor, (2) Set: Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
		-- 2.2.0: Aspect of the Viper: This ability has received a slight redesign. The
		-- amount of mana regained will increase as the Hunters percentage of 
		-- mana remaining decreases. At about 60% mana, it is equivalent to the
		-- previous version of Aspect of the Viper. Below that margin, it is 
		-- better (up to twice as much mana as the old version); while above 
		-- that margin, it will be less effective. The mana regained never drops
		-- below 10% of intellect every 5 sec. or goes above 50% of intellect 
		-- every 5 sec. 
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(34074),			-- ["Aspect of the Viper"],
			},
		},
		-- Hunter: Careful Aim (Rank 3) - 2,16
		--         Increases your ranged attack power by an amount equal to 15%/30%/45% of your total Intellect.
		["ADD_RANGED_AP_MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.15, 0.30, 0.45,
				},
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 3,14
		--         Reduces all damage taken by 2%/4%.
		-- 2.1.0 "Survival Instincts" now also increase attack power by 2/4%.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		-- Hunter: Master Marksman (Rank 5) - 2,19
		--         Increases your ranged attack power by 2%/4%/6%/8%/10%.
		["MOD_RANGED_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Hunter: Catlike Reflexes (Rank 3) - 1,19
		--         Increases your chance to dodge by 1%/2%/3% and your pet's chance to dodge by an additional 3%/6%/9%.
		-- Hunter: Aspect of the Monkey - Buff
		--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.
		-- Hunter: Improved Aspect of the Monkey (Rank 3) - 1,4
		--         Increases the Dodge bonus of your Aspect of the Monkey by 2%/4%/6%.
		-- Hunter: Deterrence - Buff
		--         Dodge and Parry chance increased by 25%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					1, 2, 3,
				},
			},
			[2] = {
				["rank"] = {
					8,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			[4] = {
				["rank"] = {
					25,
				},
				["buff"] = GetSpellInfo(31567),		-- ["Deterrence"],
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 1,14
		--         Reduces all damage taken by 2%/4%.

		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Hunter: Thick Hide (Rank 3) - 1,5
		--         Increases the armor rating of your pets by 20% and your armor contribution from items by 4%/7%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 5,
				["rank"] = {
					1.04, 1.07, 1.1,
				},
			},
		},
		-- Hunter: Survivalist (Rank 5) - 3,9
		--         Increases total health by 2%/4%/6%/8%/10%.
		-- Hunter: Endurance Training (Rank 5) - 1,2
		--         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
		["MOD_HEALTH"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					1.01, 1.02, 1.03, 1.04, 1.05,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		-- Hunter: Lightning Reflexes (Rank 5) - 3,18
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.01, 0.02,
				},
			},
			[2] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.03, 0.06,
				},
			},
		},
	},
	["MAGE"] = {
		-- Mage: Arcane Fortitude - 1,9
		--       Increases your armor by an amount equal to 50% of your Intellect.
		-- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
		["ADD_ARMOR_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					1,
				},
			},
		},
		-- Mage: Arcane Meditation (Rank 3) - 1,12
		--       Allows 5%/10%/15% of your Mana regeneration to continue while casting.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Mage: Mind Mastery (Rank 5) - 1,22
		--       Increases spell damage by up to 5%/10%/15%/20%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Mage: Arctic Winds (Rank 5) - 3,20
		--       Reduces the chance melee and ranged attacks will hit you by 1%/2%/3%/4%/5%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Mage: Prismatic Cloak (Rank 2) - 1,16
		--       Reduces all damage taken by 2%/4%.
		-- Mage: Playing with Fire (Rank 3) - 2,13
		--       Increases all spell damage caused by 1%/2%/3% and all spell damage taken by 1%/2%/3%.
		-- Mage: Frozen Core (Rank 3) - 3,14
		--       Reduces the damage taken by Frost and Fire effects by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			[2] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
			[3] = {
				["FIRE"] = true,
				["FROST"] = true,
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Mage: Arcane Mind (Rank 5) - 1,15
		--       Increases your total Intellect by 3%/6%/9%/12%/15%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
	},
	["PALADIN"] = {
		-- Paladin: Pursuit of Justice (Rank 2) - 3,9
		--          Reduces the chance you'll be hit by spells by 1%/2%/3% and increases movement and mounted movement speed by 5%/10%/15%. This does not stack with other movement speed increasing effects.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					-0.05, -0.1, -0.15,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Divine Purpose (Rank 3) - 3,20
		--          Melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Paladin: Blessed Life (Rank 3) - 1,18
		--          All attacks against you have a 4%/7%/10% chance to cause half damage.
		-- Paladin: Ardent Defender (Rank 5) - 2,19
		--          When you have less than 20% health, all damage taken is reduced by 6%/12%/18%/24%/30%.
		-- Paladin: Spell Warding (Rank 2) - 2,13
		--          All spell damage taken is reduced by 2%/4%.
		-- Paladin: Improved Righteous Fury (Rank 3) - 2,7
		--          While Righteous Fury is active, all damage taken is reduced by 2%/4%/6% and increases the amount of threat generated by your Righteous Fury spell by 16%/33%/50%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.035, -0.05,
				},
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					-0.06, -0.12, -0.18, -0.24, -0.3,
				},
				["condition"] = "(UnitHealth('player') / UnitHealthMax('player')) < 0.35",
			},
			[3] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			[4] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
				["buff"] = GetSpellInfo(25781),		-- ["Righteous Fury"],
			},
		},
		-- Paladin: Toughness (Rank 5) - 2,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Paladin: Divine Strength (Rank 5) - 1,1
		--          Increases your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 1,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Sacred Duty (Rank 2) - 2,16
		--          Increases your total Stamina by 3%/6%, reduces the cooldown of your Divine Shield spell by 60 sec and reduces the attack speed penalty by 100%.
		-- Paladin: Combat Expertise (Rank 5) - 2,21
		--          Increases your expertise by 1/2/3/4/5 and total Stamina by 2%/4%/6%/8%/10%. -- 2.3.0
		["MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.03, 0.06
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Paladin: Divine Intellect (Rank 5) - 1,2
		--          Increases your total Intellect by 2%/4%/6%/8%/10%.
		["MOD_INT"] = {
			[1] = {
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
			[1] = {
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	},
	["PRIEST"] = {
		-- Priest: Meditation (Rank 3) - 1,9
		--         Allows 5%/10%/15% of your Mana regeneration to continue while casting.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_SPELL_DMG_MOD_SPI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_HEALING_MOD_SPI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: OLD: Elune's Grace (Rank 6) - Buff, NE priest only
		--         OLD: Ranged damage taken reduced by 167 and chance to dodge increased by 10%.
		-- 2.3.0 Elune's Grace (Night Elf) effect changed to reduce chance to be hit by melee and ranged attacks by 20% for 15 seconds. There is now only 1 rank of the spell.
		-- Priest: Elune's Grace (Rank 1) - Buff, NE priest only
		--         Reduces the chance you'll be hit by melee and ranged attacks by 20% for 15 sec.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["rank"] = {
					20,
				},
				["buff"] = GetSpellInfo(2651),		-- ["Elune's Grace"],
			},
		},
		-- Priest: Shadow Resilience (Rank 2) - 3,16
		--         Reduces the chance you'll be critically hit by all spells by 2%/4%.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Priest: Spell Warding (Rank 5) - 2,4
		--         Reduces all spell damage taken by 2%/4%/6%/8%/10%.
		-- Priest: OLD: Pain Suppression - Buff
		--         OLD: Reduces all damage taken by 60% for 8 sec.
		-- 2.1.0 "Pain Suppression" now reduces damage taken by 65% and increases resistance to Dispel mechanics by 65% for the duration.
		-- 2.3.0 Pain Suppression (Discipline Talent) is now usable on friendly targets, instantly reduces the target's threat by 5%, reduces damage taken by 40% and its cooldown has been reduced to 2 minutes.
		-- Priest: 2.3.0: Pain Suppression - Buff
		--         2.3.0: Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.
		["MOD_DMG_TAKEN"] = {
			[1] = {
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
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.4,
				},
				["buff"] = GetSpellInfo(33206),		-- ["Pain Suppression"],
			},
		},
		-- Priest: Mental Strength (Rank 5) - 1,13
		--         IIncreases your maximum Mana by 2%/4%/6%/8%/10%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		-- Priest: Spirit of Redemption - 2,13
		--         Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.
		["MOD_SPI"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					0.05,
				},
			},
		},
	},
	["ROGUE"] = {
		-- Rogue: Deadliness (Rank 5) - 3,17
		--        Increases your attack power by 2%/4%/6%/8%/10%.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Rogue: Lightning Reflexes (Rank 5) - 2,3
		--        Increases your Dodge chance by 1%/2%/3%/4%/5%.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		-- Rogue: Ghostly Strike - Buff
		--        Dodge chance increased by 15%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			[2] = {
				["rank"] = {
					50, 50,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
			[3] = {
				["rank"] = {
					15,
				},
				["buff"] = GetSpellInfo(31022),		-- ["Ghostly Strike"],
			},
		},
		-- Rogue: Sleight of Hand (Rank 2) - 3,3
		--        Reduces the chance you are critically hit by melee and ranged attacks by 2% and increases the threat reduction of your Feint ability by 20%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Rogue: Heightened Senses (Rank 2) - 3,12
		--        Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by 2%/4%.
		-- Rogue: Cloak of Shadows - buff
		--        Instantly removes all existing harmful spell effects and increases your chance to resist all spells by 90% for 5 sec. Does not remove effects that prevent you from using Cloak of Shadows.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
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
			[2] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.9,
				},
				["buff"] = GetSpellInfo(39666),		-- ["Cloak of Shadows"],
			},
			[3] = {
				["RANGED"] = true,
				["rank"] = {
					0, -0.25,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
		},
		-- Rogue: Deadened Nerves (Rank 5) - 1,19
		--        Decreases all physical damage taken by 1%/2%/3%/4%/5%
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		-- Rogue: Sinister Calling (Rank 5) - 3,21
		--        Increases your total Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02,
				},
			},
			[2] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	},
	["SHAMAN"] = {
		-- Shaman: Shamanistic Rage - Buff
		--         Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 15% of your attack power. Lasts 30 sec.
		-- 2.3.0 Shamanistic Rage (Enhancement) now also reduces all damage taken by 30% for the duration.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.3,
				},
				["buff"] = GetSpellInfo(30823),		-- ["Shamanistic Rage"],
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_SPELL_DMG_MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_HEALING_MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Unrelenting Storm (Rank 5) - 1,14
		--         Regenerate mana equal to 2%/4%/6%/8%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Anticipation (Rank 5) - 2,9
		--         Increases your chance to dodge by an additional 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Shaman: Elemental Shields (Rank 3) - 1,18
		--         Reduces the chance you will be critically hit by melee and ranged attacks by 2%/4%/6%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Shaman: Elemental Warding (Rank 3) - 1,4
		--         Reduces damage taken from Fire, Frost and Nature effects by 4%/7%/10%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Shaman: Toughness (Rank 5) - 2,11
		--         Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Shaman: Ancestral Knowledge (Rank 5) - 2,1
		--         Increases your maximum Mana by 1%/2%/3%/4%/5%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 1,
				["rank"] = {
					1.01, 1.02, 1.03, 1.04, 1.05,
				},
			},
		},
		-- Shaman: Shield Specialization 5/5 - 2,2
		--         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
		["MOD_BLOCK_VALUE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
	},
	["WARLOCK"] = {
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
		["ADD_SPELL_DMG_MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Resilience (Rank 3) - 2,18
		--          Reduces the chance you'll be critically hit by melee and spells by 1%/2%/3% and reduces all damage your summoned demon takes by 15%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Warlock: Master Demonologist (Rank 5) - 2,17
		--          Voidwalker - Reduces physical damage taken by 2%/4%/6%/8%/10%.
		-- Warlock: Soul Link (Rank 1) - 2,19
		--          When active, 20% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter or Felguard demon instead. In addition, both the demon and master will inflict 5% more damage. Lasts as long as the demon is active.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(27490)).."')" --"UnitCreatureFamily('pet') == '"..L["Voidwalker"].."'",	-- ["Torment"]
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.2,
				},
				["buff"] = GetSpellInfo(25228),		-- ["Soul Link"],
			},
		},
		-- Warlock: Fel Stamina (Rank 3) - 2,9
		--          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
		["MOD_HEALTH"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1.01, 1.02, 1.03,
				},
			},
		},
		-- Warlock: Fel Intellect (Rank 3) - 2,6
		--          Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum mana by 1%/2%/3%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					1.01, 1.02, 1.03,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			[1] = {
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
			[1] = {
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
	},
	["WARRIOR"] = {
		-- Warrior: Improved Berserker Stance (Rank 5) - 2,20 - Stance
		--          Increases attack power by 2%/4%/6%/8%/10% while in Berserker Stance.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
		},
		-- Warrior: Shield Wall - Buff
		--          Reduces the Physical and magical damage taken by the caster by 75% for 10 sec.
		-- Warrior: Defensive Stance - stance
		--          A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases threat generated.
		-- Warrior: Berserker Stance - stance
		--          An aggressive stance. Critical hit chance is increased by 3% and all damage taken is increased by 10%.
		-- Warrior: Death Wish - Buff
		--          When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%. Lasts 30 sec.
		-- Warrior: Recklessness - Buff
		--          The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.
		-- Warrior: Improved Defensive Stance (Rank 3) - 3,18
				--          Reduces all spell damage taken while in Defensive Stance by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.75,
				},
				["buff"] = GetSpellInfo(41196),		-- ["Shield Wall"],
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			},
			[3] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
			[4] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.05,
				},
				["buff"] = GetSpellInfo(12292),		-- ["Death Wish"],
			},
			[5] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(13847),		-- ["Recklessness"],
			},
			[6] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Warrior: Toughness (Rank 5) - 3,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 5,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Warrior: Shield Mastery (Rank 3) - 3,16
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		["MOD_BLOCK_VALUE"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	},
	["ALL"] = {
		-- Priest: Power Infusion - Buff
		--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
		["MOD_SPELL_DMG"] = {
			[1] = {
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(37274),		-- ["Power Infusion"],
			},
		},
		-- Priest: Power Infusion - Buff
		--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
		["MOD_HEALING"] = {
			[1] = {
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(37274),		-- ["Power Infusion"],
			},
		},
		-- Night Elf : Quickness - Racial
		--             Dodge chance increased by 1%.
		["ADD_DODGE"] = {
			[1] = {
				["rank"] = {
					1,
				},
				["race"] = "NightElf",
			},
		},
		-- Paladin: Lay on Hands (Rank 1/2) - Buff
		--          Armor increased by 15%/30%.
		-- Priest: Inspiration (Rank 1/2/3) - Buff
		--         Increases armor by 8%/16%/25%.
		-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
		--         Increases your armor value by 8%/16%/25%.
		["MOD_ARMOR"] = {
			[1] = {
				["rank"] = {
					1.15, 1.30,
				},
				["buff"] = GetSpellInfo(27154),		-- ["Lay on Hands"],
			},
			[2] = {
				["rank"] = {
					1.08, 1.16, 1.25,
				},
				["buff"] = GetSpellInfo(15363),		-- ["Inspiration"],
			},
			[3] = {
				["rank"] = {
					1.08, 1.16, 1.25,
				},
				["buff"] = GetSpellInfo(16237),		-- ["Ancestral Fortitude"],
			},
		},
		-- Tauren: Endurance - Racial
		--         Total Health increased by 5%.
		["MOD_HEALTH"] = {
			[1] = {
				["rank"] = {
					1.05,
				},
				["race"] = "Tauren",
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_STR"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_AGI"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_STA"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Gnome: Expansive Mind - Racial
		--        Increase Intelligence by 5%.
		["MOD_INT"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
			[3] = {
				["rank"] = {
					0.05,
				},
				["race"] = "Gnome",
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Human: The Human Spirit - Racial
		--        Increase Spirit by 10%.
		["MOD_SPI"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
			[3] = {
				["rank"] = {
					0.1,
				},
				["race"] = "Human",
			},
		},
	},
}

function StatLogic:GetStatMod(stat, school)
	local statModInfo = StatModInfo[stat]
	local mod = statModInfo.initialValue
	-- if school is required for this statMod but not given
	if statModInfo.school and not school then return mod end
	-- Class specific mods
	if type(StatModTable[playerClass][stat]) == "table" then
		for _, case in ipairs(StatModTable[playerClass][stat]) do
			local ok = true
			if school and not case[school] then ok = nil end
			if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
			if ok and case.buff and not GetPlayerBuffName(case.buff) then ok = nil end
			if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
			if ok then
				local r, _
				-- if talant field
				if case.tab and case.num then
					_, _, _, _, r = GetTalentInfo(case.tab, case.num)
				-- no talant but buff is given
				elseif case.buff then
					r = GetPlayerBuffRank(case.buff)
				-- no talant but all other given conditions are statisfied
				elseif case.condition or case.stance then
					r = 1
				end
				if r and r ~= 0 and case.rank[r] then
					if statModInfo.initialValue == 0 then
						mod = mod + case.rank[r]
					else
						mod = mod * case.rank[r]
					end
				end
			end
		end
	end
	-- Non class specific mods
	if type(StatModTable["ALL"][stat]) == "table" then
		for _, case in ipairs(StatModTable["ALL"][stat]) do
			local ok = true
			if school and not case[school] then ok = nil end
			if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
			if ok and case.buff and not GetPlayerBuffName(case.buff) then ok = nil end
			if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
			if ok and case.race and case.race ~= playerRace then ok = nil end
			if ok then
				local r
				-- there are no talants in non class specific mods
				-- check buff
				if case.buff then
					r = GetPlayerBuffRank(case.buff)
				-- no talant but all other given conditions are statisfied
				elseif case.condition or case.stance or case.race then
					r = 1
				end
				if r and r ~= 0 and case.rank[r] then
					if statModInfo.initialValue == 0 then
						mod = mod + case.rank[r]
					else
						mod = mod * case.rank[r]
					end
				end
			end
		end
	end

	return mod + statModInfo.finalAdjust
end


--=================--
-- Stat Conversion --
--=================--
function StatLogic:GetReductionFromArmor(armor, attackerLevel)
	local levelModifier = attackerLevel
	if ( levelModifier > 59 ) then
		levelModifier = levelModifier + (4.5 * (levelModifier - 59))
	end
	local temp = armor / (85 * levelModifier + 400)
	local armorReduction = temp / (1 + temp)
	-- caps at 75%
	if armorReduction > 0.75 then
		armorReduction = 0.75
	end
	if armorReduction < 0 then
		armorReduction = 0
	end
	return armorReduction
end

function StatLogic:GetEffectFromDefense(defense, attackerLevel)
	return (defense - attackerLevel * 5) * 0.04
end


--[[---------------------------------
{	:GetEffectFromRating(rating, id, [level])
-------------------------------------
-- Description
	Calculates the stat effects from ratings for any level.
-- Args
	rating
			number - rating value
	id
			number - rating id as defined in PaperDollFrame.lua
	[level] - (defaults: PlayerClass)
			number - player level
-- Returns
	effect
		number - effect value
	effect name
		string - name of converted effect, ex: "DODGE", "PARRY"
-- Remarks
-- Examples
	StatLogic:GetEffectFromRating(10, CR_DODGE)
	StatLogic:GetEffectFromRating(10, CR_DODGE, 70)
}
-----------------------------------]]

--[[ Rating ID as definded in PaperDollFrame.lua
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
--]]

-- Level 60 rating base
local RatingBase = {
	[CR_WEAPON_SKILL] = 2.5,
	[CR_DEFENSE_SKILL] = 1.5,
	[CR_DODGE] = 12,
	[CR_PARRY] = 15,
	[CR_BLOCK] = 5,
	[CR_HIT_MELEE] = 10,
	[CR_HIT_RANGED] = 10,
	[CR_HIT_SPELL] = 8,
	[CR_CRIT_MELEE] = 14,
	[CR_CRIT_RANGED] = 14,
	[CR_CRIT_SPELL] = 14,
	[CR_HIT_TAKEN_MELEE] = 10, -- hit avoidance
	[CR_HIT_TAKEN_RANGED] = 10,
	[CR_HIT_TAKEN_SPELL] = 8,
	[CR_CRIT_TAKEN_MELEE] = 25, -- resilience
	[CR_CRIT_TAKEN_RANGED] = 25,
	[CR_CRIT_TAKEN_SPELL] = 25,
	[CR_HASTE_MELEE] = 10, -- changed in 2.2
	[CR_HASTE_RANGED] = 10, -- changed in 2.2
	[CR_HASTE_SPELL] = 10, -- changed in 2.2
	[CR_WEAPON_SKILL_MAINHAND] = 2.5,
	[CR_WEAPON_SKILL_OFFHAND] = 2.5,
	[CR_WEAPON_SKILL_RANGED] = 2.5,
	[CR_EXPERTISE] = 2.5,
}

-- Formula reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
--  Parry Rating, Defense Rating, and Block Rating: Low-level players 
--   will now convert these ratings into their corresponding defensive 
--   stats at the same rate as level 34 players.
function StatLogic:GetEffectFromRating(rating, id, level)
	-- if id is stringID then convert to numberID
	if type(id) == "string" and RatingNameToID[id] then
		id = RatingNameToID[id]
	end
	-- check for invalid input
	if type(rating) ~= "number" or id < 1 or id > 24 then return 0 end
	-- defaults to player level if not given
	level = level or UnitLevel("player")
	--2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players 
	--   will now convert these ratings into their corresponding defensive 
	--   stats at the same rate as level 34 players.
	if (id == CR_DEFENSE_SKILL or id == CR_PARRY or id == CR_BLOCK) and level < 34 then
		level = 34
	end
	if level >= 60 then
		return rating/RatingBase[id]*((-3/82)*level+(131/41)), RatingIDToConvertedStat[id]
	elseif level >= 10 then
		return rating/RatingBase[id]/((1/52)*level-(8/52)), RatingIDToConvertedStat[id]
	else
		return rating/RatingBase[id]/((1/52)*10-(8/52)), RatingIDToConvertedStat[id]
	end
end


--[[---------------------------------
{	:GetAPPerStr([class])
-------------------------------------
-- Description
	Gets the attack power per strength for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power per strength
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per strength.
-- Examples
	StatLogic:GetAPPerStr()
	StatLogic:GetAPPerStr("WARRIOR")
}
-----------------------------------]]

local APPerStr = {
	2, 2, 1, 1, 1, 2, 1, 1, 2,
	--["WARRIOR"] = 2,
	--["PALADIN"] = 2,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 1,
	--["SHAMAN"] = 2,
	--["MAGE"] = 1,
	--["WARLOCK"] = 1,
	--["DRUID"] = 2,
}

function StatLogic:GetAPPerStr(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return APPerStr[class], "AP"
end


--[[---------------------------------
:GetAPFromStr(str, [class])
-------------------------------------
Description:
	Calculates the attack power from strength for any class.
Arguments:
	str
			number - strength
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
Returns:
	[ap]
		number - attack power
	[statid]
		string - "AP"
Remarks:
	Player level does not effect block value per strength.
Examples:
	StatLogic:GetAPFromStr(1) -- GetAPPerStr
	StatLogic:GetAPFromStr(10)
	StatLogic:GetAPFromStr(10, "WARRIOR")
-----------------------------------]]
function StatLogic:GetAPFromStr(str, class)
	-- argCheck for invalid input
	self:argCheck(str, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return str * APPerStr[class], "AP"
end


--[[---------------------------------
{	:GetBlockValuePerStr([class])
-------------------------------------
-- Description
	Gets the block value per strength for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[blockValue]
		number - block value per strength
	[statid]
		string - "BLOCK_VALUE"
-- Remarks
	Player level does not effect block value per strength.
-- Examples
	StatLogic:GetBlockValuePerStr()
	StatLogic:GetBlockValuePerStr("WARRIOR")
}
-----------------------------------]]

local BlockValuePerStr = {
	0.05, 0.05, 0, 0, 0, 0.05, 0, 0, 0,
	--["WARRIOR"] = 0.05,
	--["PALADIN"] = 0.05,
	--["HUNTER"] = 0,
	--["ROGUE"] = 0,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0.05,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetBlockValuePerStr(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return BlockValuePerStr[class], "BLOCK_VALUE"
end


--[[---------------------------------
{	:GetBlockValueFromStr(str, [class])
-------------------------------------
-- Description
	Calculates the block value from strength for any class.
-- Args
	str
			number - strength
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[blockValue]
		number - block value
	[statid]
		string - "BLOCK_VALUE"
-- Remarks
	Player level does not effect block value per strength.
-- Examples
	StatLogic:GetBlockValueFromStr(1) -- GetBlockValuePerStr
	StatLogic:GetBlockValueFromStr(10)
	StatLogic:GetBlockValueFromStr(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetBlockValueFromStr(str, class)
	-- argCheck for invalid input
	self:argCheck(str, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return str * BlockValuePerStr[class], "BLOCK_VALUE"
end


--[[---------------------------------
{	:GetAPPerAgi([class])
-------------------------------------
-- Description
	Gets the attack power per agility for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power per agility
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per agility.
	Support for Cat Form.
-- Examples
	StatLogic:GetAPPerAgi()
	StatLogic:GetAPPerAgi("ROGUE")
}
-----------------------------------]]

local APPerAgi = {
	0, 0, 1, 1, 0, 0, 0, 0, 0,
	--["WARRIOR"] = 0,
	--["PALADIN"] = 0,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetAPPerAgi(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Check druid cat form
	if (class == 9) and GetPlayerBuffName((GetSpellInfo(32356))) then		-- ["Cat Form"]
		return 1
	end
	return APPerAgi[class], "AP"
end


--[[---------------------------------
{	:GetAPFromAgi(agi, [class])
-------------------------------------
-- Description
	Calculates the attack power from agility for any class.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per agility.
-- Examples
	StatLogic:GetAPFromAgi(1) -- GetAPPerAgi
	StatLogic:GetAPFromAgi(10)
	StatLogic:GetAPFromAgi(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetAPFromAgi(agi, class)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return agi * APPerAgi[class], "AP"
end


--[[---------------------------------
{	:GetRAPPerAgi([class])
-------------------------------------
-- Description
	Gets the ranged attack power per agility for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[rap]
		number - ranged attack power per agility
	[statid]
		string - "RANGED_AP"
-- Remarks
	Player level does not effect ranged attack power per agility.
-- Examples
	StatLogic:GetRAPPerAgi()
	StatLogic:GetRAPPerAgi("HUNTER")
}
-----------------------------------]]

local RAPPerAgi = {
	1, 0, 1, 1, 0, 0, 0, 0, 0,
	--["WARRIOR"] = 1,
	--["PALADIN"] = 0,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetRAPPerAgi(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
{	:GetRAPFromAgi(agi, [class])
-------------------------------------
-- Description
	Calculates the ranged attack power from agility for any class.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[rap]
		number - ranged attack power
	[statid]
		string - "RANGED_AP"
-- Remarks
	Player level does not effect ranged attack power per agility.
-- Examples
	StatLogic:GetRAPFromAgi(1) -- GetRAPPerAgi
	StatLogic:GetRAPFromAgi(10)
	StatLogic:GetRAPFromAgi(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetRAPFromAgi(agi, class)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return agi * RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
{	:GetBaseDodge([class])
-------------------------------------
-- Description
	Gets the base dodge percentage for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[dodge]
		number - base dodge percentage
	[statid]
		string - "DODGE"
-- Remarks
-- Examples
	StatLogic:GetBaseDodge()
	StatLogic:GetBaseDodge("WARRIOR")
}
-----------------------------------]]

-- Numbers derived by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local BaseDodge = {
	0.7580, 0.6520, -5.4500, -0.5900, 3.1830, 1.6750, 3.4575, 2.0350, -1.8720,
	--["WARRIOR"] = 0.7580,
	--["PALADIN"] = 0.6520,
	--["HUNTER"] = -5.4500,
	--["ROGUE"] = -0.5900,
	--["PRIEST"] = 3.1830,
	--["SHAMAN"] = 1.6750,
	--["MAGE"] = 3.4575,
	--["WARLOCK"] = 2.0350,
	--["DRUID"] = -1.8720,
}

function StatLogic:GetBaseDodge(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return BaseDodge[class], "DODGE"
end


--[[---------------------------------
{	:GetDodgePerAgi()
-------------------------------------
-- Description
	Calculates the dodge percentage per agility for your current class and level.
-- Args
-- Returns
	[dodge]
		number - dodge percentage per agility
	[statid]
		string - "DODGE"
-- Remarks
	Only works for your currect class and current level, does not support class and level args.
-- Examples
	StatLogic:GetDodgePerAgi()
}
-----------------------------------]]

function StatLogic:GetDodgePerAgi()
	local _, agility = UnitStat("player", 2)
	local class = ClassNameToID[playerClass]
	-- dodgeFromAgi is %
	local dodgeFromAgi = GetDodgeChance() - self:GetStatMod("ADD_DODGE") - self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, UnitLevel("player")) - self:GetEffectFromDefense(GetTotalDefense("player"), UnitLevel("player"))
	return (dodgeFromAgi - BaseDodge[class]) / agility, "DODGE"
end


--[[---------------------------------
{	:GetDodgeFromAgi(agi)
-------------------------------------
-- Description
	Calculates the dodge chance from agility for your current class and level.
-- Args
	agi
			number - agility
-- Returns
	[dodge]
		number - dodge percentage
	[statid]
		string - "DODGE"
-- Remarks
	Only works for your currect class and current level, does not support class and level args.
-- Examples
	StatLogic:GetDodgeFromAgi(1) -- GetDodgePerAgi
	StatLogic:GetDodgeFromAgi(10)
}
-----------------------------------]]

function StatLogic:GetDodgeFromAgi(agi)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	-- Calculate
	return agi * self:GetDodgePerAgi(), "DODGE"
end


--[[---------------------------------
{	:GetCritFromAgi(agi, [class], [level])
-------------------------------------
-- Description
	Calculates the melee/ranged crit chance from agility for any class or level.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[crit]
		number - melee/ranged crit percentage
	[statid]
		string - "MELEE_CRIT"
-- Remarks
-- Examples
	StatLogic:GetCritFromAgi(1) -- GetCritPerAgi
	StatLogic:GetCritFromAgi(10)
	StatLogic:GetCritFromAgi(10, "WARRIOR")
	StatLogic:GetCritFromAgi(10, nil, 70)
	StatLogic:GetCritFromAgi(10, "WARRIOR", 70)
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local CritPerAgi = {
	 [1] = {0.2500, 0.2174, 0.2840, 0.4476, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
	 [2] = {0.2381, 0.2070, 0.2834, 0.4290, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
	 [3] = {0.2381, 0.2070, 0.2711, 0.4118, 0.0909, 0.1583, 0.0771, 0.1429, 0.1923, },
	 [4] = {0.2273, 0.1976, 0.2530, 0.3813, 0.0865, 0.1583, 0.0735, 0.1429, 0.1923, },
	 [5] = {0.2174, 0.1976, 0.2430, 0.3677, 0.0865, 0.1511, 0.0735, 0.1429, 0.1836, },
	 [6] = {0.2083, 0.1890, 0.2337, 0.3550, 0.0865, 0.1511, 0.0735, 0.1364, 0.1836, },
	 [7] = {0.2083, 0.1890, 0.2251, 0.3321, 0.0865, 0.1511, 0.0735, 0.1364, 0.1756, },
	 [8] = {0.2000, 0.1812, 0.2171, 0.3217, 0.0826, 0.1446, 0.0735, 0.1364, 0.1756, },
	 [9] = {0.1923, 0.1812, 0.2051, 0.3120, 0.0826, 0.1446, 0.0735, 0.1304, 0.1683, },
	[10] = {0.1923, 0.1739, 0.1984, 0.2941, 0.0826, 0.1385, 0.0701, 0.1304, 0.1553, },
	[11] = {0.1852, 0.1739, 0.1848, 0.2640, 0.0826, 0.1385, 0.0701, 0.1250, 0.1496, },
	[12] = {0.1786, 0.1672, 0.1670, 0.2394, 0.0790, 0.1330, 0.0701, 0.1250, 0.1496, },
	[13] = {0.1667, 0.1553, 0.1547, 0.2145, 0.0790, 0.1330, 0.0701, 0.1250, 0.1443, },
	[14] = {0.1613, 0.1553, 0.1441, 0.1980, 0.0790, 0.1279, 0.0701, 0.1200, 0.1443, },
	[15] = {0.1563, 0.1449, 0.1330, 0.1775, 0.0790, 0.1231, 0.0671, 0.1154, 0.1346, },
	[16] = {0.1515, 0.1449, 0.1267, 0.1660, 0.0757, 0.1188, 0.0671, 0.1111, 0.1346, },
	[17] = {0.1471, 0.1403, 0.1194, 0.1560, 0.0757, 0.1188, 0.0671, 0.1111, 0.1303, },
	[18] = {0.1389, 0.1318, 0.1117, 0.1450, 0.0757, 0.1147, 0.0671, 0.1111, 0.1262, },
	[19] = {0.1351, 0.1318, 0.1060, 0.1355, 0.0727, 0.1147, 0.0671, 0.1071, 0.1262, },
	[20] = {0.1282, 0.1242, 0.0998, 0.1271, 0.0727, 0.1073, 0.0643, 0.1034, 0.1122, },
	[21] = {0.1282, 0.1208, 0.0962, 0.1197, 0.0727, 0.1073, 0.0643, 0.1000, 0.1122, },
	[22] = {0.1250, 0.1208, 0.0910, 0.1144, 0.0727, 0.1039, 0.0643, 0.1000, 0.1092, },
	[23] = {0.1190, 0.1144, 0.0872, 0.1084, 0.0699, 0.1039, 0.0643, 0.0968, 0.1063, },
	[24] = {0.1163, 0.1115, 0.0829, 0.1040, 0.0699, 0.1008, 0.0617, 0.0968, 0.1063, },
	[25] = {0.1111, 0.1087, 0.0797, 0.0980, 0.0699, 0.0978, 0.0617, 0.0909, 0.1010, },
	[26] = {0.1087, 0.1060, 0.0767, 0.0936, 0.0673, 0.0950, 0.0617, 0.0909, 0.1010, },
	[27] = {0.1064, 0.1035, 0.0734, 0.0903, 0.0673, 0.0950, 0.0617, 0.0909, 0.0985, },
	[28] = {0.1020, 0.1011, 0.0709, 0.0865, 0.0673, 0.0924, 0.0617, 0.0882, 0.0962, },
	[29] = {0.1000, 0.0988, 0.0680, 0.0830, 0.0649, 0.0924, 0.0593, 0.0882, 0.0962, },
	[30] = {0.0962, 0.0945, 0.0654, 0.0792, 0.0649, 0.0875, 0.0593, 0.0833, 0.0878, },
	[31] = {0.0943, 0.0925, 0.0637, 0.0768, 0.0649, 0.0875, 0.0593, 0.0833, 0.0859, },
	[32] = {0.0926, 0.0925, 0.0614, 0.0741, 0.0627, 0.0853, 0.0593, 0.0811, 0.0859, },
	[33] = {0.0893, 0.0887, 0.0592, 0.0715, 0.0627, 0.0831, 0.0571, 0.0811, 0.0841, },
	[34] = {0.0877, 0.0870, 0.0575, 0.0691, 0.0627, 0.0831, 0.0571, 0.0789, 0.0824, },
	[35] = {0.0847, 0.0836, 0.0556, 0.0664, 0.0606, 0.0792, 0.0571, 0.0769, 0.0808, },
	[36] = {0.0833, 0.0820, 0.0541, 0.0643, 0.0606, 0.0773, 0.0551, 0.0750, 0.0792, },
	[37] = {0.0820, 0.0820, 0.0524, 0.0628, 0.0606, 0.0773, 0.0551, 0.0732, 0.0777, },
	[38] = {0.0794, 0.0791, 0.0508, 0.0609, 0.0586, 0.0756, 0.0551, 0.0732, 0.0777, },
	[39] = {0.0781, 0.0776, 0.0493, 0.0592, 0.0586, 0.0756, 0.0551, 0.0714, 0.0762, },
	[40] = {0.0758, 0.0750, 0.0481, 0.0572, 0.0586, 0.0723, 0.0532, 0.0698, 0.0709, },
	[41] = {0.0735, 0.0737, 0.0470, 0.0556, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
	[42] = {0.0725, 0.0737, 0.0457, 0.0542, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
	[43] = {0.0704, 0.0713, 0.0444, 0.0528, 0.0551, 0.0693, 0.0532, 0.0667, 0.0685, },
	[44] = {0.0694, 0.0701, 0.0433, 0.0512, 0.0551, 0.0679, 0.0514, 0.0667, 0.0673, },
	[45] = {0.0676, 0.0679, 0.0421, 0.0497, 0.0551, 0.0665, 0.0514, 0.0638, 0.0651, },
	[46] = {0.0667, 0.0669, 0.0413, 0.0486, 0.0534, 0.0652, 0.0514, 0.0625, 0.0641, },
	[47] = {0.0649, 0.0659, 0.0402, 0.0474, 0.0534, 0.0639, 0.0498, 0.0625, 0.0641, },
	[48] = {0.0633, 0.0639, 0.0391, 0.0464, 0.0519, 0.0627, 0.0498, 0.0612, 0.0631, },
	[49] = {0.0625, 0.0630, 0.0382, 0.0454, 0.0519, 0.0627, 0.0498, 0.0600, 0.0621, },
	[50] = {0.0610, 0.0612, 0.0373, 0.0440, 0.0519, 0.0605, 0.0482, 0.0588, 0.0585, },
	[51] = {0.0595, 0.0604, 0.0366, 0.0431, 0.0505, 0.0594, 0.0482, 0.0577, 0.0577, },
	[52] = {0.0588, 0.0596, 0.0358, 0.0422, 0.0505, 0.0583, 0.0482, 0.0577, 0.0569, },
	[53] = {0.0575, 0.0580, 0.0350, 0.0412, 0.0491, 0.0583, 0.0467, 0.0566, 0.0561, },
	[54] = {0.0562, 0.0572, 0.0341, 0.0404, 0.0491, 0.0573, 0.0467, 0.0556, 0.0561, },
	[55] = {0.0549, 0.0557, 0.0334, 0.0394, 0.0478, 0.0554, 0.0467, 0.0545, 0.0546, },
	[56] = {0.0543, 0.0550, 0.0328, 0.0386, 0.0478, 0.0545, 0.0454, 0.0536, 0.0539, },
	[57] = {0.0532, 0.0544, 0.0321, 0.0378, 0.0466, 0.0536, 0.0454, 0.0526, 0.0531, },
	[58] = {0.0521, 0.0530, 0.0314, 0.0370, 0.0466, 0.0536, 0.0454, 0.0517, 0.0525, },
	[59] = {0.0510, 0.0524, 0.0307, 0.0364, 0.0454, 0.0528, 0.0441, 0.0517, 0.0518, },
	[60] = {0.0500, 0.0512, 0.0301, 0.0355, 0.0454, 0.0512, 0.0441, 0.0500, 0.0493, },
	[61] = {0.0469, 0.0491, 0.0297, 0.0334, 0.0443, 0.0496, 0.0435, 0.0484, 0.0478, },
	[62] = {0.0442, 0.0483, 0.0290, 0.0322, 0.0444, 0.0486, 0.0432, 0.0481, 0.0472, },
	[63] = {0.0418, 0.0472, 0.0284, 0.0307, 0.0441, 0.0470, 0.0424, 0.0470, 0.0456, },
	[64] = {0.0397, 0.0456, 0.0279, 0.0296, 0.0433, 0.0456, 0.0423, 0.0455, 0.0447, },
	[65] = {0.0377, 0.0446, 0.0273, 0.0286, 0.0426, 0.0449, 0.0422, 0.0448, 0.0438, },
	[66] = {0.0360, 0.0437, 0.0270, 0.0276, 0.0419, 0.0437, 0.0411, 0.0435, 0.0430, },
	[67] = {0.0344, 0.0425, 0.0264, 0.0268, 0.0414, 0.0427, 0.0412, 0.0436, 0.0424, },
	[68] = {0.0329, 0.0416, 0.0259, 0.0262, 0.0412, 0.0417, 0.0408, 0.0424, 0.0412, },
	[69] = {0.0315, 0.0408, 0.0254, 0.0256, 0.0410, 0.0408, 0.0404, 0.0414, 0.0406, },
	[70] = {0.0303, 0.0400, 0.0250, 0.0250, 0.0400, 0.0400, 0.0400, 0.0405, 0.0400, },
	[71] = {0.0297, 0.0393, 0.0246, 0.0244, 0.0390, 0.0392, 0.0396, 0.0396, 0.0394, },
	[72] = {0.0292, 0.0385, 0.0242, 0.0238, 0.0381, 0.0384, 0.0393, 0.0387, 0.0388, },
	[73] = {0.0287, 0.0378, 0.0238, 0.0233, 0.0372, 0.0377, 0.0389, 0.0379, 0.0383, },
}

function StatLogic:GetCritFromAgi(agi, class, level)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 73 then
		level = UnitLevel("player")
	end
	-- Calculate
	return agi * CritPerAgi[level][class], "MELEE_CRIT"
end


--[[---------------------------------
{	:GetSpellCritFromInt(int, [class], [level])
-------------------------------------
-- Description
	Calculates the spell crit chance from intellect for any class or level.
-- Args
	int
			number - intellect
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[spellcrit]
		number - spell crit percentage
	[statid]
		string - "SPELL_CRIT"
-- Remarks
-- Examples
	StatLogic:GetSpellCritFromInt(1) -- GetSpellCritPerInt
	StatLogic:GetSpellCritFromInt(10)
	StatLogic:GetSpellCritFromInt(10, "MAGE")
	StatLogic:GetSpellCritFromInt(10, nil, 70)
	StatLogic:GetSpellCritFromInt(10, "MAGE", 70)
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local SpellCritPerInt = {
	 [1] = {0.0000, 0.0832, 0.0699, 0.0000, 0.1710, 0.1333, 0.1637, 0.1500, 0.1431, },
	 [2] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1636, 0.1272, 0.1574, 0.1435, 0.1369, },
	 [3] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1568, 0.1217, 0.1516, 0.1375, 0.1312, },
	 [4] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1505, 0.1217, 0.1411, 0.1320, 0.1259, },
	 [5] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1394, 0.1166, 0.1364, 0.1269, 0.1211, },
	 [6] = {0.0000, 0.0724, 0.0608, 0.0000, 0.1344, 0.1120, 0.1320, 0.1222, 0.1166, },
	 [7] = {0.0000, 0.0694, 0.0608, 0.0000, 0.1297, 0.1077, 0.1279, 0.1179, 0.1124, },
	 [8] = {0.0000, 0.0694, 0.0583, 0.0000, 0.1254, 0.1037, 0.1240, 0.1138, 0.1124, },
	 [9] = {0.0000, 0.0666, 0.0583, 0.0000, 0.1214, 0.1000, 0.1169, 0.1100, 0.1086, },
	[10] = {0.0000, 0.0666, 0.0559, 0.0000, 0.1140, 0.1000, 0.1137, 0.1065, 0.0984, },
	[11] = {0.0000, 0.0640, 0.0559, 0.0000, 0.1045, 0.0933, 0.1049, 0.0971, 0.0926, },
	[12] = {0.0000, 0.0616, 0.0538, 0.0000, 0.0941, 0.0875, 0.0930, 0.0892, 0.0851, },
	[13] = {0.0000, 0.0594, 0.0499, 0.0000, 0.0875, 0.0800, 0.0871, 0.0825, 0.0807, },
	[14] = {0.0000, 0.0574, 0.0499, 0.0000, 0.0784, 0.0756, 0.0731, 0.0767, 0.0750, },
	[15] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0724, 0.0700, 0.0671, 0.0717, 0.0684, },
	[16] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0684, 0.0666, 0.0639, 0.0688, 0.0656, },
	[17] = {0.0000, 0.0520, 0.0451, 0.0000, 0.0627, 0.0636, 0.0602, 0.0635, 0.0617, },
	[18] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0597, 0.0596, 0.0568, 0.0600, 0.0594, },
	[19] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0562, 0.0571, 0.0538, 0.0569, 0.0562, },
	[20] = {0.0000, 0.0462, 0.0399, 0.0000, 0.0523, 0.0538, 0.0505, 0.0541, 0.0516, },
	[21] = {0.0000, 0.0450, 0.0388, 0.0000, 0.0502, 0.0518, 0.0487, 0.0516, 0.0500, },
	[22] = {0.0000, 0.0438, 0.0388, 0.0000, 0.0470, 0.0500, 0.0460, 0.0493, 0.0477, },
	[23] = {0.0000, 0.0427, 0.0368, 0.0000, 0.0453, 0.0474, 0.0445, 0.0471, 0.0463, },
	[24] = {0.0000, 0.0416, 0.0358, 0.0000, 0.0428, 0.0459, 0.0422, 0.0446, 0.0437, },
	[25] = {0.0000, 0.0396, 0.0350, 0.0000, 0.0409, 0.0437, 0.0405, 0.0429, 0.0420, },
	[26] = {0.0000, 0.0387, 0.0341, 0.0000, 0.0392, 0.0424, 0.0390, 0.0418, 0.0409, },
	[27] = {0.0000, 0.0387, 0.0333, 0.0000, 0.0376, 0.0412, 0.0372, 0.0398, 0.0394, },
	[28] = {0.0000, 0.0370, 0.0325, 0.0000, 0.0362, 0.0394, 0.0338, 0.0384, 0.0384, },
	[29] = {0.0000, 0.0362, 0.0318, 0.0000, 0.0348, 0.0383, 0.0325, 0.0367, 0.0366, },
	[30] = {0.0000, 0.0347, 0.0304, 0.0000, 0.0333, 0.0368, 0.0312, 0.0355, 0.0346, },
	[31] = {0.0000, 0.0340, 0.0297, 0.0000, 0.0322, 0.0354, 0.0305, 0.0347, 0.0339, },
	[32] = {0.0000, 0.0333, 0.0297, 0.0000, 0.0311, 0.0346, 0.0294, 0.0333, 0.0325, },
	[33] = {0.0000, 0.0326, 0.0285, 0.0000, 0.0301, 0.0333, 0.0286, 0.0324, 0.0318, },
	[34] = {0.0000, 0.0320, 0.0280, 0.0000, 0.0289, 0.0325, 0.0278, 0.0311, 0.0309, },
	[35] = {0.0000, 0.0308, 0.0269, 0.0000, 0.0281, 0.0314, 0.0269, 0.0303, 0.0297, },
	[36] = {0.0000, 0.0303, 0.0264, 0.0000, 0.0273, 0.0304, 0.0262, 0.0295, 0.0292, },
	[37] = {0.0000, 0.0297, 0.0264, 0.0000, 0.0263, 0.0298, 0.0254, 0.0284, 0.0284, },
	[38] = {0.0000, 0.0287, 0.0254, 0.0000, 0.0256, 0.0289, 0.0248, 0.0277, 0.0276, },
	[39] = {0.0000, 0.0282, 0.0250, 0.0000, 0.0249, 0.0283, 0.0241, 0.0268, 0.0269, },
	[40] = {0.0000, 0.0273, 0.0241, 0.0000, 0.0241, 0.0272, 0.0235, 0.0262, 0.0256, },
	[41] = {0.0000, 0.0268, 0.0237, 0.0000, 0.0235, 0.0267, 0.0230, 0.0256, 0.0252, },
	[42] = {0.0000, 0.0264, 0.0237, 0.0000, 0.0228, 0.0262, 0.0215, 0.0248, 0.0244, },
	[43] = {0.0000, 0.0256, 0.0229, 0.0000, 0.0223, 0.0254, 0.0211, 0.0243, 0.0240, },
	[44] = {0.0000, 0.0256, 0.0225, 0.0000, 0.0216, 0.0248, 0.0206, 0.0236, 0.0233, },
	[45] = {0.0000, 0.0248, 0.0218, 0.0000, 0.0210, 0.0241, 0.0201, 0.0229, 0.0228, },
	[46] = {0.0000, 0.0245, 0.0215, 0.0000, 0.0206, 0.0235, 0.0197, 0.0224, 0.0223, },
	[47] = {0.0000, 0.0238, 0.0212, 0.0000, 0.0200, 0.0231, 0.0192, 0.0220, 0.0219, },
	[48] = {0.0000, 0.0231, 0.0206, 0.0000, 0.0196, 0.0226, 0.0188, 0.0214, 0.0214, },
	[49] = {0.0000, 0.0228, 0.0203, 0.0000, 0.0191, 0.0220, 0.0184, 0.0209, 0.0209, },
	[50] = {0.0000, 0.0222, 0.0197, 0.0000, 0.0186, 0.0215, 0.0179, 0.0204, 0.0202, },
	[51] = {0.0000, 0.0219, 0.0194, 0.0000, 0.0183, 0.0210, 0.0176, 0.0200, 0.0198, },
	[52] = {0.0000, 0.0216, 0.0192, 0.0000, 0.0178, 0.0207, 0.0173, 0.0195, 0.0193, },
	[53] = {0.0000, 0.0211, 0.0186, 0.0000, 0.0175, 0.0201, 0.0170, 0.0191, 0.0191, },
	[54] = {0.0000, 0.0208, 0.0184, 0.0000, 0.0171, 0.0199, 0.0166, 0.0186, 0.0186, },
	[55] = {0.0000, 0.0203, 0.0179, 0.0000, 0.0166, 0.0193, 0.0162, 0.0182, 0.0182, },
	[56] = {0.0000, 0.0201, 0.0177, 0.0000, 0.0164, 0.0190, 0.0154, 0.0179, 0.0179, },
	[57] = {0.0000, 0.0198, 0.0175, 0.0000, 0.0160, 0.0187, 0.0151, 0.0176, 0.0176, },
	[58] = {0.0000, 0.0191, 0.0170, 0.0000, 0.0157, 0.0182, 0.0149, 0.0172, 0.0173, },
	[59] = {0.0000, 0.0189, 0.0168, 0.0000, 0.0154, 0.0179, 0.0146, 0.0168, 0.0169, },
	[60] = {0.0000, 0.0185, 0.0164, 0.0000, 0.0151, 0.0175, 0.0143, 0.0165, 0.0164, },
	[61] = {0.0000, 0.0157, 0.0157, 0.0000, 0.0148, 0.0164, 0.0143, 0.0159, 0.0162, },
	[62] = {0.0000, 0.0153, 0.0154, 0.0000, 0.0145, 0.0159, 0.0143, 0.0154, 0.0157, },
	[63] = {0.0000, 0.0148, 0.0150, 0.0000, 0.0143, 0.0152, 0.0143, 0.0148, 0.0150, },
	[64] = {0.0000, 0.0143, 0.0144, 0.0000, 0.0139, 0.0147, 0.0142, 0.0143, 0.0146, },
	[65] = {0.0000, 0.0140, 0.0141, 0.0000, 0.0137, 0.0142, 0.0142, 0.0138, 0.0142, },
	[66] = {0.0000, 0.0136, 0.0137, 0.0000, 0.0134, 0.0138, 0.0138, 0.0135, 0.0137, },
	[67] = {0.0000, 0.0133, 0.0133, 0.0000, 0.0132, 0.0134, 0.0133, 0.0130, 0.0133, },
	[68] = {0.0000, 0.0131, 0.0130, 0.0000, 0.0130, 0.0131, 0.0131, 0.0127, 0.0131, },
	[69] = {0.0000, 0.0128, 0.0128, 0.0000, 0.0127, 0.0128, 0.0128, 0.0125, 0.0128, },
	[70] = {0.0000, 0.0125, 0.0125, 0.0000, 0.0125, 0.0125, 0.0125, 0.0122, 0.0125, },
	[71] = {0.0000, 0.0122, 0.0123, 0.0000, 0.0123, 0.0122, 0.0122, 0.0119, 0.0122, },
	[72] = {0.0000, 0.0120, 0.0120, 0.0000, 0.0121, 0.0120, 0.0119, 0.0116, 0.0120, },
	[73] = {0.0000, 0.0118, 0.0118, 0.0000, 0.0119, 0.0117, 0.0117, 0.0114, 0.0118, },
}

function StatLogic:GetSpellCritFromInt(int, class, level)
	-- argCheck for invalid input
	self:argCheck(int, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 73 then
		level = UnitLevel("player")
	end
	-- Calculate
	return int * SpellCritPerInt[level][class], "SPELL_CRIT"
end


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
	0, 0.1, 0.1, 0, 0.125, 0.1, 0.125, 0.1, 0.1125,
	--["WARRIOR"] = 0,
	--["PALADIN"] = 0.1,
	--["HUNTER"] = 0.1,
	--["ROGUE"] = 0,
	--["PRIEST"] = 0.125,
	--["SHAMAN"] = 0.1,
	--["MAGE"] = 0.125,
	--["WARLOCK"] = 0.1,
	--["DRUID"] = 0.1125,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return spi * NormalManaRegenPerSpi[class] * 5, "MANA_REG_NOT_CASTING"
end

-- New mana regen from spirit code for 2.4
local BaseManaRegenPerSpi
if wowBuildNo >= '7897' then
	--[[---------------------------------
	{	:GetNormalManaRegenFromSpi(spi, [int], [level])
	-------------------------------------
	-- Description
		Calculates the mana regen per 5 seconds while NOT casting from spirit.
	-- Args
		spi
				number - spirit
		[int] - (defaults: PlayerInt)
				number - intellect
		[level] - (defaults: PlayerLevel)
				number - player level used for calculation
	-- Returns
		[mp5nc]
			number - mana regen per 5 seconds when out of combat
		[statid]
			string - "MANA_REG_NOT_CASTING"
	-- Remarks
		Player class is no longer a parameter
		ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
	-- Examples
		StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
		StatLogic:GetNormalManaRegenFromSpi(10, 15)
		StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
	}
	-----------------------------------]]

	-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
	local BaseManaRegenPerSpi = {
		[1] = 0.034965,
		[2] = 0.034191,
		[3] = 0.033465,
		[4] = 0.032526,
		[5] = 0.031661,
		[6] = 0.031076,
		[7] = 0.030523,
		[8] = 0.029994,
		[9] = 0.029307,
		[10] = 0.028661,
		[11] = 0.027584,
		[12] = 0.026215,
		[13] = 0.025381,
		[14] = 0.0243,
		[15] = 0.023345,
		[16] = 0.022748,
		[17] = 0.021958,
		[18] = 0.021386,
		[19] = 0.02079,
		[20] = 0.020121,
		[21] = 0.019733,
		[22] = 0.019155,
		[23] = 0.018819,
		[24] = 0.018316,
		[25] = 0.017936,
		[26] = 0.017576,
		[27] = 0.017201,
		[28] = 0.016919,
		[29] = 0.016581,
		[30] = 0.016233,
		[31] = 0.015994,
		[32] = 0.015707,
		[33] = 0.015464,
		[34] = 0.015204,
		[35] = 0.014956,
		[36] = 0.014744,
		[37] = 0.014495,
		[38] = 0.014302,
		[39] = 0.014094,
		[40] = 0.013895,
		[41] = 0.013724,
		[42] = 0.013522,
		[43] = 0.013363,
		[44] = 0.013175,
		[45] = 0.012996,
		[46] = 0.012853,
		[47] = 0.012687,
		[48] = 0.012539,
		[49] = 0.012384,
		[50] = 0.012233,
		[51] = 0.012113,
		[52] = 0.011973,
		[53] = 0.011859,
		[54] = 0.011714,
		[55] = 0.011575,
		[56] = 0.011473,
		[57] = 0.011342,
		[58] = 0.011245,
		[59] = 0.01111,
		[60] = 0.010999,
		[61] = 0.0107,
		[62] = 0.010522,
		[63] = 0.01029,
		[64] = 0.010119,
		[65] = 0.009968,
		[66] = 0.009808,
		[67] = 0.009651,
		[68] = 0.009553,
		[69] = 0.009445,
		[70] = 0.009327,
	}

	function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
		-- argCheck for invalid input
		self:argCheck(spi, 2, "number")
		self:argCheck(int, 3, "nil", "number")
		self:argCheck(level, 4, "nil", "number")
		
		-- if level is invalid input, default to player level
		if type(level) ~= "number" or level < 1 or level > 70 then
			level = UnitLevel("player")
		end
		
		-- if int is invalid input, default to player int
		if type(int) ~= "number" then
			local _
			_, int = UnitStat("player",4)
		end
		-- Calculate
		return (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REG_NOT_CASTING"
	end
end


--[[---------------------------------
{	:GetHealthRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the health regen per 5 seconds when out of combat from spirit for any class.
-- Args
	spi
			number - spirit
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[hp5oc]
		number - health regen per 5 seconds when out of combat
	[statid]
		string - "HEALTH_REG_OUT_OF_COMBAT"
-- Remarks
	Player level does not effect health regen per spirit.
-- Examples
	StatLogic:GetHealthRegenFromSpi(1) -- GetHealthRegenPerSpi
	StatLogic:GetHealthRegenFromSpi(10)
	StatLogic:GetHealthRegenFromSpi(10, "MAGE")
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local HealthRegenPerSpi = {
	0.5, 0.125, 0.125, 0.333333, 0.041667, 0.071429, 0.041667, 0.045455, 0.0625,
	--["WARRIOR"] = 0.5,
	--["PALADIN"] = 0.125,
	--["HUNTER"] = 0.125,
	--["ROGUE"] = 0.333333,
	--["PRIEST"] = 0.041667,
	--["SHAMAN"] = 0.071429,
	--["MAGE"] = 0.041667,
	--["WARLOCK"] = 0.045455,
	--["DRUID"] = 0.0625,
}

function StatLogic:GetHealthRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return spi * HealthRegenPerSpi[class] * 5, "HEALTH_REG_OUT_OF_COMBAT"
end


----------
-- Gems --
----------

function StatLogic:RemoveEnchant(link)
	-- check link
	if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, 0, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId)
end

function StatLogic:RemoveGem(link)
	-- check link
	if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, enchantId, 0, 0, 0, 0, suffixId, uniqueId)
end

function StatLogic:RemoveEnchantGem(link)
	-- check link
	if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, 0, 0, 0, 0, 0, suffixId, uniqueId)
end

function StatLogic:ModEnchantGem(link, enc, gem1, gem2, gem3, gem4)
	-- check link
	if not strfind(link, "item:%d+") then
		return
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, enc or enchantId or 0, gem1 or jewelId1 or 0, gem2 or jewelId2 or 0, gem3 or jewelId3 or 0, gem4 or jewelId4 or 0, suffixId or 0, uniqueId or 0)
end

--[[---------------------------------
{	:BuildGemmedTooltip(item, red, yellow, blue, meta)
-------------------------------------
-- Description
	Returns a modified link with all empty sockets replaced with the specified gems,
	sockets already gemmed will remain.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	red
		string or number - gemID to replace a red socket
	yellow
		string or number - gemID to replace a yellow socket
	blue
		string or number - gemID to replace a blue socket
	meta
		string or number - gemID to replace a meta socket
-- Returns
	link
		string - modified item link
-- Remarks
-- Examples
	StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119)
	SetTip("item:28619")
	SetTip(StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119))
}
-----------------------------------]]
local EmptySocketLookup = {
	[EMPTY_SOCKET_RED] = 0, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = 0, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = 0, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = 0, -- EMPTY_SOCKET_META = "Meta Socket";
}
function StatLogic:BuildGemmedTooltip(item, red, yellow, blue, meta)
	local _
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return item end
	else
		return item
	end
	-- Check if item is in local cache
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	if not name then return item end
	
	-- Check gemID
	if not red or not tonumber(red) then red = 0 end
	if not yellow or not tonumber(yellow) then yellow = 0 end
	if not blue or not tonumber(blue) then blue = 0 end
	if not meta or not tonumber(meta) then meta = 0 end
	if red == 0 and yellow == 0 and blue == 0 and meta == 0 then return link end -- nothing to modify
	-- Fill EmptySocketLookup
	EmptySocketLookup[EMPTY_SOCKET_RED] = red
	EmptySocketLookup[EMPTY_SOCKET_YELLOW] = yellow
	EmptySocketLookup[EMPTY_SOCKET_BLUE] = blue
	EmptySocketLookup[EMPTY_SOCKET_META] = meta
	
	-- Build socket list
	local socketList = {}
	-- Get a link without any socketed gems
	local cleanLink = link:match("(item:%d+)")
	-- Start parsing
	tip:ClearLines() -- this is required or SetX won't work the second time its called
	tip:SetHyperlink(link)
	for i = 2, tip:NumLines() do
		local text = tip[i]:GetText()
		-- Trim spaces
		text = strtrim(text)
		-- Strip color codes
		if strsub(text, -2) == "|r" then
			text = strsub(text, 1, -3)
		end
		if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
			text = strsub(text, 11)
		end
		local socketFound = EmptySocketLookup[text]
		if socketFound then
			socketList[#socketList+1] = socketFound
		end
	end
	-- If there are no sockets
	if #socketList == 0 then return link end
	-- link breakdown
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	if socketList[1] and (not jewelId1 or jewelId1 == "0") then jewelId1 = socketList[1] end
	if socketList[2] and (not jewelId2 or jewelId2 == "0") then jewelId2 = socketList[2] end
	if socketList[3] and (not jewelId3 or jewelId3 == "0") then jewelId3 = socketList[3] end
	if socketList[4] and (not jewelId4 or jewelId4 == "0") then jewelId4 = socketList[4] end
	return strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId)
end

--[[---------------------------------
{	:GetGemID(item)
-------------------------------------
-- Description
	Returns the gemID and gemText of a gem for use in links
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
-- Returns
	gemID
		number - gemID
	gemText
		string - text when socketed in an item
-- Remarks
-- Examples
	StatLogic:GetGemID(28363)
}
-----------------------------------]]
-- SetTip("item:3185:0:2946")
function StatLogic:GetGemID(item)
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	local itemID = item
	if type(item) == "string" then
		local temp = item:match("item:(%d+)")
		if temp then
			itemID = temp
		end
		itemID = tonumber(itemID)
	end
	-- Check if item is in local cache
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	if not name then
		if tonumber(itemID) then
			-- Query server for item
			tipMiner:SetHyperlink("item:"..itemID);
		end
		return
	end
	itemID = link:match("item:(%d+)")
	if not GetItemInfo(6948) then -- Hearthstone
		-- Query server for Hearthstone
		tipMiner:SetHyperlink("item:"..itemID);
		return
	end
	local gemScanLink = "item:6948:0:%d:0:0:0:0:0"
	local gemID
	-- Start GemID scan
	for gemID = 4000, 1, -1 do
		local itemLink = gemScanLink:format(gemID)
		local _, gem1Link = GetItemGem(itemLink, 1)
		if gem1Link and itemID == gem1Link:match("item:(%d+)") then
			tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
			tipMiner:SetHyperlink(itemLink);
			return gemID, StatLogicMinerTooltipTextLeft4:GetText()
		end
	end
end


-- ================== --
-- Stat Summarization --
-- ================== --
--[[---------------------------------
{	:GetSum(item, [table])
-------------------------------------
-- Description
	Calculates the sum of all stats for a specified item.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[table]
			table - the sum of stat values are writen to this table if provided
-- Returns
	[sum]
		table - {
			["itemType"] = itemType,
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
-- Remarks
-- Examples
	StatLogic:GetSum(21417) -- [Ring of Unspoken Names]
	StatLogic:GetSum("item:28040:2717")
	StatLogic:GetSum("item:19019:117") -- TF
	StatLogic:GetSum("item:3185:0:0:0:0:0:1957") -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	StatLogic:GetSum(24396)
	SetTip("item:3185:0:0:0:0:0:1957")
	-- [Deadly Fire Opal] ID:30582 - Attack Power +8 and Critical Rating +5
	-- [Gnomeregan Auto-Blocker 600] ID:29387
	StatLogic:GetSum("item:30538:3011:2739:2739:2739:0") -- [Midnight Legguards] with enchant and gems
	StatLogic:GetSum("item:30538:3011:2739:2739:2739:0") -- [Midnight Legguards] with enchant and gems
}
-----------------------------------]]
function StatLogic:GetSum(item, table)
	-- Locale check
	if not D:HasLocale(GetLocale()) then return end
	local _
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	-- Check if item is in local cache
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	if not name then return end

	-- Clear table values
	clearTable(table)
	-- Initialize table
	table = table or new()
	setmetatable(table, statTableMetatable)

	-- Get data from cache if available
	if cache[link] then
		copyTable(table, cache[link])
		return table
	end

	-- Set metadata
	table.itemType = itemType
	table.link = link

	-- Don't scan Relics because they don't have general stats
	if itemType == "INVTYPE_RELIC" then
		cache[link] = copy(table)
		return table
	end

	-- Start parsing
	tip:ClearLines() -- this is required or SetX won't work the second time its called
	tip:SetHyperlink(link)
	print(link)
	for i = 2, tip:NumLines() do
		local text = tip[i]:GetText()

		-- Trim spaces
		text = strtrim(text)
		-- Strip color codes
		if strsub(text, -2) == "|r" then
			text = strsub(text, 1, -3)
		end
		if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
			text = strsub(text, 11)
		end

		local _, g, b = tip[i]:GetTextColor()
		-----------------------
		-- Whole Text Lookup --
		-----------------------
		-- Mainly used for enchants or stuff without numbers:
		-- "Mithril Spurs"
		local found
		local idTable = L.WholeTextLookup[text]
		if idTable == false then
			found = true
			print("|cffadadad".."  WholeText Exclude: "..text)
		elseif idTable then
			found = true
			for id, value in pairs(L.WholeTextLookup[text]) do
				-- sum stat
				table[id] = (table[id] or 0) + value
				print("|cffff5959".."  WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
			end
		end
		-- Fast Exclude --
		-- Exclude obvious strings that do not need to be checked, also exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
		if not (found or L.Exclude[text] or L.Exclude[strutf8sub(text, 1, L.ExcludeLen)] or strsub(text, 1, 1) == '"' or g < 0.8 or (b < 0.99 and b > 0.1)) then
			--print(text.." = ")
			-- Strip enchant time
			-- ITEM_ENCHANT_TIME_LEFT_DAYS = "%s (%d day)";
			-- ITEM_ENCHANT_TIME_LEFT_DAYS_P1 = "%s (%d days)";
			-- ITEM_ENCHANT_TIME_LEFT_HOURS = "%s (%d hour)";
			-- ITEM_ENCHANT_TIME_LEFT_HOURS_P1 = "%s (%d hrs)";
			-- ITEM_ENCHANT_TIME_LEFT_MIN = "%s (%d min)"; -- Enchantment name, followed by the time left in minutes
			-- ITEM_ENCHANT_TIME_LEFT_SEC = "%s (%d sec)"; -- Enchantment name, followed by the time left in seconds
			--[[ Seems temp enchants such as mana oil can't be seen from item links, so commented out
			if strfind(text, "%)") then
				print("test")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_DAYS, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_DAYS_P1, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_HOURS, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_HOURS_P1, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_MIN, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_SEC, "%%s ", ""), "%%", "%%%%"), "")
			end
			--]]
			----------------------------
			-- Single Plus Stat Check --
			----------------------------
			-- depending on locale, L.SinglePlusStatCheck may be
			-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
			-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
			-- +19 耐力 = "^%+(%d+) (.-)$"
			if not found then
				local _, _, value, statText = strfind(strutf8lower(text), L.SinglePlusStatCheck)
				if value then
					if tonumber(statText) then
						value, statText = statText, value
					end
					local idTable = L.StatIDLookup[statText]
					if idTable == false then
						found = true
						print("|cffadadad".."  SinglePlus Exclude: "..text)
					elseif idTable then
						found = true
						local debugText = "|cffff5959".."  SinglePlus: ".."|cffffc259"..text
						for _, id in ipairs(idTable) do
							--print("  '"..value.."', '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
						end
						print(debugText)
					else
						-- pattern match but not found in L.StatIDLookup, keep looking
					end
				end
			end
			-----------------------------
			-- Single Equip Stat Check --
			-----------------------------
			-- depending on locale, L.SingleEquipStatCheck may be
			-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
			if not found then
				local _, _, statText1, value, statText2 = strfind(text, L.SingleEquipStatCheck)
				if value then
					local statText = statText1..statText2
					local idTable = L.StatIDLookup[strutf8lower(statText)]
					if idTable == false then
						found = true
						print("|cffadadad".."  SingleEquip Exclude: "..text)
					elseif idTable then
						found = true
						local debugText = "|cffff5959".."  SingleEquip: ".."|cffffc259"..text
						for _, id in ipairs(idTable) do
							--print("  '"..value.."', '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
						end
						print(debugText)
					else
						-- pattern match but not found in L.StatIDLookup, keep looking
					end
				end
			end
			-- PreScan for special cases, that will fit wrongly into DeepScan
			-- PreScan also has exclude patterns
			if not found then
				for pattern, id in pairs(L.PreScanPatterns) do
					local value
					found, _, value = strfind(text, pattern)
					if found then
						--found = true
						if id ~= false then
							local debugText = "|cffff5959".."  PreScan: ".."|cffffc259"..text
							--print("  '"..value.."' = '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
							print(debugText)
						else
							print("|cffadadad".."  PreScan Exclude: "..text)
						end
						break
					end
				end
				if found then

				end
			end
			--------------
			-- DeepScan --
			--------------
			--[[
			-- Strip trailing "."
			["."] = ".",
			["DeepScanSeparators"] = {
				"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
				" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
				", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
				"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
			},
			["DeepScanWordSeparators"] = {
				" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
			},
			["DeepScanPatterns"] = {
				"^(.-) by u?p? ?t?o? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
				"^(.-) ?%+(%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
				"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
			},
			--]]
			if not found then
				-- Get a local copy
				local text = text
				-- Strip leading "Equip: ", "Socket Bonus: "
				text = gsub(text, ITEM_SPELL_TRIGGER_ONEQUIP, "") -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
				text = gsub(text, StripGlobalStrings(ITEM_SOCKET_BONUS), "") -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
				-- Trim spaces
				text = strtrim(text)
				-- Strip trailing "."
				if strutf8sub(text, -1) == L["."] then
					text = strutf8sub(text, 1, -2)
				end
				-- Replace separators with @
				for _, sep in ipairs(L.DeepScanSeparators) do
					if strfind(text, sep) then
						text = gsub(text, sep, "@")
					end
				end
				-- Split text using @
				text = {strsplit("@", text)}
				for i, text in ipairs(text) do
					-- Trim spaces
					text = strtrim(text)
					-- Strip trailing "."
					if strutf8sub(text, -1) == L["."] then
						text = strutf8sub(text, 1, -2)
					end
					print("|cff008080".."S"..i..": ".."'"..text.."'")
					-- Whole Text Lookup
					local foundWholeText = false
					local idTable = L.WholeTextLookup[text]
					if idTable == false then
						foundWholeText = true
						found = true
						print("|cffadadad".."  DeepScan WholeText Exclude: "..text)
					elseif idTable then
						foundWholeText = true
						found = true
						for id, value in pairs(L.WholeTextLookup[text]) do
							-- sum stat
							table[id] = (table[id] or 0) + value
							print("|cffff5959".."  DeepScan WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
						end
					else
						-- pattern match but not found in L.WholeTextLookup, keep looking
					end
					-- Scan DualStatPatterns
					if not foundWholeText then
						for pattern, dualStat in pairs(L.DualStatPatterns) do
							local lowered = strutf8lower(text)
							local _, dEnd, value1, value2 = strfind(lowered, pattern)
							if value1 and value2 then
								foundWholeText = true
								found = true
								local debugText = "|cffff5959".."  DeepScan DualStat: ".."|cffffc259"..text
								for _, id in ipairs(dualStat[1]) do
									--print("  '"..value.."', '"..id.."'")
									-- sum stat
									table[id] = (table[id] or 0) + tonumber(value1)
									debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
								end
								for _, id in ipairs(dualStat[2]) do
									--print("  '"..value.."', '"..id.."'")
									-- sum stat
									table[id] = (table[id] or 0) + tonumber(value2)
									debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
								end
								print(debugText)
								if dEnd ~= string.len(lowered) then
									foundWholeText = false
									text = string.sub(text, dEnd + 1)
								end
								break
							end
						end
					end
					local foundDeepScan1 = false
					if not foundWholeText then
						local lowered = strutf8lower(text)
						-- Pattern scan
						for _, pattern in ipairs(L.DeepScanPatterns) do -- try all patterns in order
							local _, _, statText1, value, statText2 = strfind(lowered, pattern)
							if value then
								local statText = statText1..statText2
								local idTable = L.StatIDLookup[statText]
								if idTable == false then
									foundDeepScan1 = true
									found = true
									print("|cffadadad".."  DeepScan Exclude: "..text)
									break -- break out of pattern loop and go to the next separated text
								elseif idTable then
									foundDeepScan1 = true
									found = true
									local debugText = "|cffff5959".."  DeepScan: ".."|cffffc259"..text
									for _, id in ipairs(idTable) do
										--print("  '"..value.."', '"..id.."'")
										-- sum stat
										table[id] = (table[id] or 0) + tonumber(value)
										debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
									end
									print(debugText)
									break -- break out of pattern loop and go to the next separated text
								else
									-- Not matching pattern
								end
							end
						end
					end
					-- If still not found, use the word separators to split the text
					if not foundWholeText and not foundDeepScan1 then
						-- Replace separators with @
						for _, sep in ipairs(L.DeepScanWordSeparators) do
							if strfind(text, sep) then
								text = gsub(text, sep, "@")
							end
						end
						-- Split text using @
						text = {strsplit("@", text)}
						for j, text in ipairs(text) do
							-- Trim spaces
							text = strtrim(text)
							-- Strip trailing "."
							if strutf8sub(text, -1) == L["."] then
								text = strutf8sub(text, 1, -2)
							end
							print("|cff008080".."S"..i.."-"..j..": ".."'"..text.."'")
							-- Whole Text Lookup
							local foundWholeText = false
							local idTable = L.WholeTextLookup[text]
							if idTable == false then
								foundWholeText = true
								found = true
								print("|cffadadad".."  DeepScan2 WholeText Exclude: "..text)
							elseif idTable then
								foundWholeText = true
								found = true
								for id, value in pairs(L.WholeTextLookup[text]) do
									-- sum stat
									table[id] = (table[id] or 0) + value
									print("|cffff5959".."  DeepScan2 WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
								end
							else
								-- pattern match but not found in L.WholeTextLookup, keep looking
							end
							-- Scan DualStatPatterns
							if not foundWholeText then
								for pattern, dualStat in pairs(L.DualStatPatterns) do
									local lowered = strutf8lower(text)
									local _, _, value1, value2 = strfind(lowered, pattern)
									if value1 and value2 then
										foundWholeText = true
										found = true
										local debugText = "|cffff5959".."  DeepScan2 DualStat: ".."|cffffc259"..text
										for _, id in ipairs(dualStat[1]) do
											--print("  '"..value.."', '"..id.."'")
											-- sum stat
											table[id] = (table[id] or 0) + tonumber(value1)
											debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
										end
										for _, id in ipairs(dualStat[2]) do
											--print("  '"..value.."', '"..id.."'")
											-- sum stat
											table[id] = (table[id] or 0) + tonumber(value2)
											debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
										end
										print(debugText)
										break
									end
								end
							end
							local foundDeepScan2 = false
							if not foundWholeText then
								local lowered = strutf8lower(text)
								-- Pattern scan
								for _, pattern in ipairs(L.DeepScanPatterns) do
									local _, _, statText1, value, statText2 = strfind(lowered, pattern)
									if value then
										local statText = statText1..statText2
										local idTable = L.StatIDLookup[statText]
										if idTable == false then
											foundDeepScan2 = true
											found = true
											print("|cffadadad".."  DeepScan2 Exclude: "..text)
											break
										elseif idTable then
											foundDeepScan2 = true
											found = true
											local debugText = "|cffff5959".."  DeepScan2: ".."|cffffc259"..text
											for _, id in ipairs(idTable) do
												--print("  '"..value.."', '"..id.."'")
												-- sum stat
												table[id] = (table[id] or 0) + tonumber(value)
												debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
											end
											print(debugText)
											break
										else
											-- pattern match but not found in L.StatIDLookup, keep looking
											print("  DeepScan2 Lookup Fail: |cffffd4d4'"..statText.."'|r, pattern = |cff72ff59'"..pattern.."'")
										end
									end
								end -- for
							end
							if not foundWholeText and not foundDeepScan2 then
								print("  DeepScan2 Fail: |cffff0000'"..text.."'")
							end
						end
					end -- if not foundWholeText and not foundDeepScan1 then
				end
			end

			if not found then
				print("  No Match: |cffff0000'"..text.."'")
				if DEBUG and RatingBuster then
					RatingBuster.db.profile.test = text
				end
			end
		else
			--print("Excluded: "..text)
		end
	end
	cache[link] = copy(table)
	return table
end


--[[---------------------------------
{	:GetDiffID(item, [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta])
-------------------------------------
-- Description
	Returns a unique identification string of the diff calculation,
	the identification string is made up of links concatenated together, can be used for cache indexing
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[ignoreEnchant]
			boolean - ignore enchants when calculating the id
	[ignoreGem]
			boolean - ignore gems when calculating the id
	[red]
		string or number - gemID to replace a red socket
	[yellow]
		string or number - gemID to replace a yellow socket
	[blue]
		string or number - gemID to replace a blue socket
	[meta]
		string or number - gemID to replace a meta socket
-- Returns
	[id]
		string - a unique identification string of the diff calculation
	[link]
		string - link of main item
	[linkDiff1]
		string - link of compare item 1
	[linkDiff2]
		string - link of compare item 2
-- Remarks
-- Examples
	StatLogic:GetDiffID(21417) -- Ring of Unspoken Names
	StatLogic:GetDiffID("item:18832:2564:0:0:0:0:0:0", true, true) -- Brutality Blade with +15 agi enchant
	http://www.wowwiki.com/EnchantId
}
-----------------------------------]]

local getSlotID = {
	INVTYPE_AMMO           = 0,
	INVTYPE_GUNPROJECTILE  = 0,
	INVTYPE_BOWPROJECTILE  = 0,
	INVTYPE_HEAD           = 1,
	INVTYPE_NECK           = 2,
	INVTYPE_SHOULDER       = 3,
	INVTYPE_BODY           = 4,
	INVTYPE_CHEST          = 5,
	INVTYPE_ROBE           = 5,
	INVTYPE_WAIST          = 6,
	INVTYPE_LEGS           = 7,
	INVTYPE_FEET           = 8,
	INVTYPE_WRIST          = 9,
	INVTYPE_HAND           = 10,
	INVTYPE_FINGER         = {11,12},
	INVTYPE_TRINKET        = {13,14},
	INVTYPE_CLOAK          = 15,
	INVTYPE_WEAPON         = {16,17},
	INVTYPE_2HWEAPON       = 16+17,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND  = 17,
	INVTYPE_SHIELD         = 17,
	INVTYPE_HOLDABLE       = 17,
	INVTYPE_RANGED         = 18,
	INVTYPE_RANGEDRIGHT    = 18,
	INVTYPE_RELIC          = 18,
	INVTYPE_GUN            = 18,
	INVTYPE_CROSSBOW       = 18,
	INVTYPE_WAND           = 18,
	INVTYPE_THROWN         = 18,
	INVTYPE_TABARD         = 19,
}

function StatLogic:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	local name, itemType, link, linkDiff1, linkDiff2
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	-- Check if item is in local cache
	name, link, _, _, _, _, _, _, itemType = GetItemInfo(item)
	if not name then return end
	-- Get equip location slot id for use in GetInventoryItemLink
	local slotID = getSlotID[itemType]
	-- Don't do bags
	if not slotID then return end

	-- 1h weapon, check if player can dual wield, check for 2h equipped
	if itemType == "INVTYPE_WEAPON" then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		-- If player can Dual Wield, calculate offhand difference
		if IsUsableSpell(GetSpellInfo(674)) then		-- ["Dual Wield"]
			local _, _, _, _, _, _, _, _, eqItemType = GetItemInfo(linkDiff1)
			-- If 2h is equipped, copy diff1 to diff2
			if eqItemType == "INVTYPE_2HWEAPON" then
				linkDiff2 = linkDiff1
			else
				linkDiff2 = GetInventoryItemLink("player", 17) or "NOITEM"
			end
		end
	-- Ring or trinket
	elseif type(slotID) == "table" then
		-- Get slot link
		linkDiff1 = GetInventoryItemLink("player", slotID[1]) or "NOITEM"
		linkDiff2 = GetInventoryItemLink("player", slotID[2]) or "NOITEM"
	-- 2h weapon, so we calculate the difference with equipped main hand and off hand
	elseif itemType == "INVTYPE_2HWEAPON" then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		linkDiff2= GetInventoryItemLink("player", 17) or "NOITEM"
	-- Off hand slot, check if we have 2h equipped
	elseif slotID == 17 then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		-- If 2h is equipped
		local _, _, _, _, _, _, _, _, eqItemType = GetItemInfo(linkDiff1)
		if eqItemType ~= "INVTYPE_2HWEAPON" then
			linkDiff1 = GetInventoryItemLink("player", 17) or "NOITEM"
		end
	-- Single slot item
	else
		linkDiff1 = GetInventoryItemLink("player", slotID) or "NOITEM"
	end

	-- Ignore Enchants
	if ignoreEnchant then
		link = self:RemoveEnchant(link)
		linkDiff1 = self:RemoveEnchant(linkDiff1)
		if linkDiff2 then
			linkDiff2 = self:RemoveEnchant(linkDiff2)
		end
	end

	-- Ignore Gems
	if ignoreGem then
		link = self:RemoveGem(link)
		linkDiff1 = self:RemoveGem(linkDiff1)
		if linkDiff2 then
			linkDiff2 = self:RemoveGem(linkDiff2)
		end
	else
		link = self:BuildGemmedTooltip(link, red, yellow, blue, meta)
		linkDiff1 = self:BuildGemmedTooltip(linkDiff1, red, yellow, blue, meta)
		if linkDiff2 then
			linkDiff2 = self:BuildGemmedTooltip(linkDiff2, red, yellow, blue, meta)
		end
	end

	-- Build ID string
	local id = link..linkDiff1
	if linkDiff2 then
		id = id..linkDiff2
	end

	return id, link, linkDiff1, linkDiff2
end


--[[---------------------------------
{	:GetDiff(item, [diff1], [diff2], [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta])
-------------------------------------
-- Description
	Calculates the stat diffrence from the specified item and your currently equipped items.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[diff1]
			table - stat difference of item and equipped item 1 are writen to this table if provided
	[diff2]
			table - stat difference of item and equipped item 2 are writen to this table if provided
	[ignoreEnchant]
			boolean - ignore enchants when calculating stat diffrences
	[ignoreGem]
			boolean - ignore gems when calculating stat diffrences
	[red]
		string or number - gemID to replace a red socket
	[yellow]
		string or number - gemID to replace a yellow socket
	[blue]
		string or number - gemID to replace a blue socket
	[meta]
		string or number - gemID to replace a meta socket
-- Returns
	[diff1]
		table - {
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
	[diff2]
		table - {
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
-- Remarks
-- Examples
	StatLogic:GetDiff(21417, {}) -- Ring of Unspoken Names
	StatLogic:GetDiff(21452) -- Staff of the Ruins
}
-----------------------------------]]

-- TODO 2.1.0: Use SetHyperlinkCompareItem in StatLogic:GetDiff
function StatLogic:GetDiff(item, diff1, diff2, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	-- Locale check
	if not D:HasLocale(GetLocale()) then return end

	-- Get DiffID
	local id, link, linkDiff1, linkDiff2 = self:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	if not id then return end

	-- Clear Tables
	clearTable(diff1)
	clearTable(diff2)

	-- Get diff data from cache if available
	if cache[id..1] then
		copyTable(diff1, cache[id..1])
		if cache[id..2] then
			copyTable(diff2, cache[id..2])
		end
		return diff1, diff2
	end

	-- Get item sum, results are written into diff1 table
	itemSum = self:GetSum(link)
	if not itemSum then return end
	local itemType = itemSum.itemType

	if itemType == "INVTYPE_2HWEAPON" then
		local equippedSum1, equippedSum2
		-- Get main hand item sum
		if linkDiff1 == "NOITEM" then
			equippedSum1 = newStatTable()
		else
			equippedSum1 = self:GetSum(linkDiff1)
		end
		-- Get off hand item sum
		if linkDiff2 == "NOITEM" then
			equippedSum2 = newStatTable()
		else
			equippedSum2 = self:GetSum(linkDiff2)
		end
		-- Calculate diff
		diff1 = copyTable(diff1, itemSum) - equippedSum1 - equippedSum2
		-- Return table to pool
		del(equippedSum1)
		del(equippedSum2)
	else
		local equippedSum
		-- Get equipped item 1 sum
		if linkDiff1 == "NOITEM" then
			equippedSum = newStatTable()
		else
			equippedSum = self:GetSum(linkDiff1)
		end
		-- Calculate item 1 diff
		diff1 = copyTable(diff1, itemSum) - equippedSum
		-- Clean up
		del(equippedSum)
		equippedSum = nil
		-- Check if item has a second equip slot
		if linkDiff2 then -- If so
			-- Get equipped item 2 sum
			if linkDiff2 == "NOITEM" then
				equippedSum = newStatTable()
			else
				equippedSum = self:GetSum(linkDiff2)
			end
			-- Calculate item 2 diff
			diff2 = copyTable(diff2, itemSum) - equippedSum
			-- Clean up
			del(equippedSum)
		end
	end
	-- Return itemSum table to pool
	del(itemSum)
	-- Write cache
	copyTable(cache[id..1], diff1)
	if diff2 then
		copyTable(cache[id..2], diff2)
	end
	-- return tables
	return diff1, diff2
end


-----------
-- DEBUG --
-----------
-- StatLogic:Bench(1000)
---------
-- self:GetSum(link, table)
-- 1000 times: 0.82 sec without cache
-- 1000 times: 0.04 sec with cache
---------
-- ItemBonusLib:ScanItemLink(link)
-- 1000 times: 1.58 sec
---------
function StatLogic:Bench(k)
	local t1 = GetTime()
	local link = GetInventoryItemLink("player", 12)
	local table = {}
	--local GetItemInfo = _G["GetItemInfo"]
	for i = 1, k, 1 do
		---------------------------------------------------------------------------
		--self:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ","})
		---------------------------------------------------------------------------
		--self:GetSum(link)
		--ItemBonusLib:ScanItemLink(link)
		---------------------------------------------------------------------------
		--ItemRefTooltip:SetScript("OnTooltipSetItem", function(frame, ...) RatingBuster:Print("OnTooltipSetItem") end)
		---------------------------------------------------------------------------
		GetItemInfo(link)
	end
	return GetTime() - t1
end


function StatLogic:PatternTest()
	patternTable = {
		"(%a[%a ]+%a) ?%d* ?%a* by u?p? ?t?o? ?(%d+) ?a?n?d? ?", -- xxx xxx by 22 (scan first)
		"(%a[%a ]+) %+(%d+) ?a?n?d? ?", -- xxx xxx +22 (scan 2ed)
		"(%d+) ([%a ]+) ?a?n?d? ?", -- 22 xxx xxx (scan last)
	}
	textTable = {
		"Spell Damage +6 and Spell Hit Rating +5",
		"+3 Stamina, +4 Critical Strike Rating",
		"+26 Healing Spells & 2% Reduced Threat",
		"+3 Stamina/+4 Critical Strike Rating",
		"Socket Bonus: 2 mana per 5 sec.",
		"Equip: Increases damage and healing done by magical spells and effects by up to 150.",
		"Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.",
		"Equip: Increases damage and healing done by magical spells and effects of all party members within 30 yards by up to 33.",
		"Equip: Increases healing done by magical spells and effects of all party members within 30 yards by up to 62.",
		"Equip: Increases your spell damage by up to 120 and your healing by up to 300.",
		"Equip: Restores 11 mana per 5 seconds to all party members within 30 yards.",
		"Equip: Increases healing done by spells and effects by up to 300.",
		"Equip: Increases attack power by 420 in Cat, Bear, Dire Bear, and Moonkin forms only.",
	}
	for _, text in ipairs(textTable) do
		DEFAULT_CHAT_FRAME:AddMessage(text.." = ")
		for _, pattern in ipairs(patternTable) do
			local found
			for k, v in gmatch(text, pattern) do
				found = true
				DEFAULT_CHAT_FRAME:AddMessage("  '"..k.."', '"..v.."'")
			end
			if found then
				DEFAULT_CHAT_FRAME:AddMessage("  using: "..pattern)
				DEFAULT_CHAT_FRAME:AddMessage("----------------------------")
				break
			end
		end
	end
end

----------------------
-- Register Library --
----------------------
AceLibrary:Register(StatLogic, MAJOR_VERSION, MINOR_VERSION, activate)

_G.StatLogic = AceLibrary("StatLogic-1.0")

----------------------
-- API doc template --
----------------------
--[[---------------------------------
{	:GetDiff(item, [table1], [table2])
-------------------------------------
-- Description
	Calculates the stat diffrence from item and equipped items
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[table1]
			table - stat difference of item and equipped item 1 are writen to this table if provided
	[table2]
			table - stat difference of item and equipped item 2 are writen to this table if provided
-- Remarks
-- Examples
	StatLogic:GetDiff(21417, {}) -- Ring of Unspoken Names
	StatLogic:GetDiff(21452) -- Staff of the Ruins
}
-----------------------------------]]
