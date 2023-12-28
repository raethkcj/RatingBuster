---@class StatLogicLocale
---@field Exclude table
---@field WholeTextLookup table
---@field PreScanPatterns table
---@field DeepScanSeparators table
---@field DeepScanWordSeparators table
---@field DualStatPatterns table
---@field DeepScanPatterns table
---@field StatIDLookup table
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "enUS", true)
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = tonumber
--[[
-- Item Stat Scanning Procedure
-- Trim spaces using text:trim()
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
L["ExcludeLen"] = 5 -- using string.utf8len
L["Exclude"] = {
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
	["Races"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
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
	[GetItemClassInfo(Enum.ItemClass.Projectile)] = true, -- Ice Threaded Arrow ID:19316
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
	[GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown)] = true,
	[INVTYPE_RELIC] = true,
	[INVTYPE_TABARD] = true,
	[INVTYPE_BAG] = true,
}
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
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["Minor Wizard Oil"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["Lesser Wizard Oil"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["Wizard Oil"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["Brilliant Wizard Oil"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["Superior Wizard Oil"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
	["Blessed Wizard Oil"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["Minor Mana Oil"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Lesser Mana Oil"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Brilliant Mana Oil"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Superior Mana Oil"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Eternium Line"] = {["FISHING"] = 5}, --
	["Savagery"] = {["AP"] = 70}, --
	["Vitality"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
	["Soulfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54},
	["+54 Shadow and Frost Spell Power"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54},
	["Sunfire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},
	["+50 Arcane and Fire Spell Power"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},

	["Mithril Spurs"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["Minor Mount Speed Increase"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["Equip: Run speed increased slightly."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["Run speed increased slightly"] = {["RUN_SPEED"] = 8}, --
	["Minor Speed Increase"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["Minor Speed"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["Surefooted"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Subtlety"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["2% Reduced Threat"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
	["Equip: Allows underwater breathing."] = false, -- [Band of Icy Depths] ID: 21526
	["Allows underwater breathing"] = false, --
	["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Immune to Disarm"] = false, --
	["Crusader"] = false, -- Enchant Crusader
	["Lifestealing"] = false, -- Enchant Crusader
	["Equip: Inflicts the will of the Ashbringer upon the wielder."] = false, -- Corrupted Ashbringer
	["Equip: Your melee and ranged attacks have a chance to call on the power of the Arcane if you're exalted with the Scryers, or the Light if you're exalted with the Aldor."] = false,
	["Equip: Your spells have a chance to call on the power of the Arcane if you're exalted with the Scryers, or the Light if you're exalted with the Aldor."] = false,
	["Equip: Your heals have a chance to call on the power of the Arcane if you're exalted with the Scryers, or the Light if you're exalted with the Aldor."] = false,
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) (.-)%.?$"
-- Stamina +19 = "^(.-) %+(%d+)%.?$"
-- +19 耐力 = "^%+(%d+) (.-)%.?$"
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+) Block$"] = "BLOCK_VALUE",
	["^(%d+) Armor$"] = "ARMOR",
	["Reinforced %(%+(%d+) Armor%)"] = "ARMOR_BONUS",
	["Mana Regen (%d+) per 5 sec%.$"] = "MANA_REG",
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	--["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
	["[Ss]ometimes"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Ww]hen struck in combat"] = false, -- [Essence of the Pure Flame] ID: 18815
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "Equip: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "Socket Bonus: " -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
}
L["DeepScanWordSeparators"] = {
	" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
L["DualStatPatterns"] = {
	-- all lower case
	["^%+(%d+) healing and %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^%+(%d+) healing %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects$"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-) by u?p? ?t?o? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
	"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Your attacks ignoreof your opponent's armor"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["% Threat"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["Increases your effective stealth level"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant
	["Increases mount speed%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["All Stats"] = {StatLogic.Stats.AllStats,},
	["Strength"] = {StatLogic.Stats.Strength,},
	["Agility"] = {StatLogic.Stats.Agility,},
	["Stamina"] = {StatLogic.Stats.Stamina,},
	["Intellect"] = {StatLogic.Stats.Intellect,},
	["Spirit"] = {StatLogic.Stats.Spirit,},

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
	["Defense"] = {StatLogic.Stats.Defense,},
	["Increased Defense"] = {StatLogic.Stats.Defense,},
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
	["Increases attack powerin Cat"] = {"FERAL_AP",},
	["attack power in cat"] = {"FERAL_AP",},
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
	["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["Spell Damage"] = {"SPELL_DMG", "HEAL",},
	["Increases damage and healing done by magical spells and effects"] = {"SPELL_DMG", "HEAL"},
	["Increases damage and healing done by magical spells and effects of all party members within 30 yards"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["Damage"] = {"SPELL_DMG",},
	["Increases your spell damage"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Spell Power"] = {"SPELL_DMG", "HEAL",},
	["Increases spell power"] = {"SPELL_DMG", "HEAL",}, -- WotLK
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
	["Increases healing done"] = {"HEAL",}, -- 2.3.0
	["damage donefor all magical spells"] = {"SPELL_DMG",}, -- 2.3.0
	["Increases healing done by spells and effects"] = {"HEAL",},
	["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
	["your healing"] = {"HEAL",}, -- Atiesh

	["damage per second"] = {"DPS",},
	["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["Defense Rating"] = {StatLogic.Stats.DefenseRating,},
	["Increases defense rating"] = {StatLogic.Stats.DefenseRating,},
	["Dodge Rating"] = {StatLogic.Stats.DodgeRating,},
	["Increases your dodge rating"] = {StatLogic.Stats.DodgeRating,},
	["Increases your chance to dodge an attack%"] = {StatLogic.Stats.Dodge,},
	["Parry Rating"] = {StatLogic.Stats.ParryRating,},
	["Increases your parry rating"] = {StatLogic.Stats.ParryRating,},
	["Increases your chance to parry an attack%"] = {StatLogic.Stats.Parry,},
	["Shield Block Rating"] = {StatLogic.Stats.BlockRating,}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["Block Rating"] = {StatLogic.Stats.BlockRating,},
	["Increases your block rating"] = {StatLogic.Stats.BlockRating,},
	["Increases your shield block rating"] = {StatLogic.Stats.BlockRating,},
	["Increases your chance to block attacks with a shield%"] = {"BLOCK_CHANCE",},

	["Improves your chance to hit%"] = {"MELEE_HIT", "RANGED_HIT"},
	["Hit Rating"] = {StatLogic.Stats.HitRating,},
	["Improves hit rating"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["Increases your hit rating"] = {StatLogic.Stats.HitRating,},
	["Improves melee hit rating"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["Spell Hit"] = {StatLogic.Stats.SpellHitRating,}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
	["Improves your chance to hit with spells%"] = {"SPELL_HIT"},
	["Spell Hit Rating"] = {StatLogic.Stats.SpellHitRating,},
	["Improves spell hit rating"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["Increases your spell hit rating"] = {StatLogic.Stats.SpellHitRating,},
	["Ranged Hit Rating"] = {StatLogic.Stats.RangedHitRating,},
	["Improves ranged hit rating"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["Increases your ranged hit rating"] = {StatLogic.Stats.RangedHitRating,},

	["Improves your chance to get a critical strike by%"] = {StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit},
	["Crit Rating"] = {StatLogic.Stats.CritRating,},
	["Critical Rating"] = {StatLogic.Stats.CritRating,},
	["Critical Strike Rating"] = {StatLogic.Stats.CritRating,},
	["Increases your critical hit rating"] = {StatLogic.Stats.CritRating,},
	["Increases your critical strike rating"] = {StatLogic.Stats.CritRating,},
	["Improves critical strike rating"] = {StatLogic.Stats.CritRating,},
	["Improves melee critical strike rating"] = {StatLogic.Stats.MeleeCritRating,}, -- [Cloak of Darkness] ID:33122
	["Improves your chance to get a critical strike with spells%"] = {StatLogic.Stats.SpellCrit},
	["Spell Critical Strike Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Crit Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical"] = {StatLogic.Stats.SpellCritRating,},
	["Increases your spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases the spell critical strike rating of all party members within 30 yards"] = {StatLogic.Stats.SpellCritRating,},
	["Improves spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases your ranged critical strike rating"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348
	["ranged critical strike"] = {StatLogic.Stats.RangedCritRating,},

	["Resilience"] = {StatLogic.Stats.ResilienceRating,},
	["Resilience Rating"] = {StatLogic.Stats.ResilienceRating,}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
	["Improves your resilience rating"] = {StatLogic.Stats.ResilienceRating,},

	["Haste Rating"] = {StatLogic.Stats.HasteRating},
	["Ranged Haste Rating"] = {StatLogic.Stats.RangedHasteRating},
	["Improves haste rating"] = {StatLogic.Stats.HasteRating},
	["Spell Haste Rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves melee haste rating"] = {StatLogic.Stats.MeleeHasteRating},
	["Improves spell haste rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves ranged haste rating"] = {StatLogic.Stats.RangedHasteRating},

	["expertise rating"] = {StatLogic.Stats.ExpertiseRating}, -- gems
	["Increases your expertise rating"] = {StatLogic.Stats.ExpertiseRating},
	["armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating}, -- gems
	["Increases armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating},
	["Increases your armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating}, -- Anarchy ID:39420
	["increases your armor penetration"] = {StatLogic.Stats.ArmorPenetrationRating}, -- Ring of Foul Mojo ID:43178

	-- Exclude
	["sec"] = false,
	["to"] = false,
	["Slot Bag"] = false,
	["Slot Quiver"] = false,
	["Slot Ammo Pouch"] = false,
	["Increases ranged attack speed"] = false, -- AV quiver
}