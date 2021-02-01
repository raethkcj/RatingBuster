--[[
Name: LibStatLogic-1.2
Description: A Library for stat conversion, calculation and summarization.
Revision: $Revision: 74 $
Author: Whitetooth
Email: hotdogee [at] gmail [dot] com
Last Update: $Date: 2012-04-25 19:18:36 +0000 (Wed, 25 Apr 2012) $
Website:
Documentation:
SVN: $URL $
Dependencies: UTF8
License: LGPL v3
Features:
  StatConversion -
    Ratings -> Effect
    Str -> AP, Block
    Agi -> Crit, Dodge, AP, RAP, Armor
    Sta -> Health, SpellDmg(Talent)
    Int -> Mana, SpellCrit
    Spi -> MP5, HP5
    and more!
  StatMods - Get stat mods from talents and buffs for every class
  BaseStats - for all classes and levels
  ItemStatParser - Fast multi level indexing algorithm instead of calling strfind for every stat

Debug:
  /sldebug
]]

local MAJOR = "LibStatLogic-1.2"
local MINOR = "$Revision: 74 $"

local StatLogic = LibStub:NewLibrary(MAJOR, MINOR)
if not StatLogic then return end

-- For Mikk's findglobals script
local _G = _G
local tostring,tonumber,gsub,select,next,pairs,ipairs,type,unpack,strsub,strlen =
       tostring,tonumber,gsub,select,next,pairs,ipairs,type,unpack,strsub,strlen
local ceil,floor = 
       ceil,floor
local CR_DEFENSE_SKILL, CR_DODGE, CR_PARRY = 
       CR_DEFENSE_SKILL, CR_DODGE, CR_PARRY
local GetCombatRating, GetCombatRatingBonus, GetParryChance, GetDodgeChance =
       GetCombatRating, GetCombatRatingBonus, GetParryChance, GetDodgeChance
local UnitBuff, UnitDebuff, GetItemInfo, GetItemGem, GetTime = 
       UnitBuff, UnitDebuff, GetItemInfo, GetItemGem, GetTime
-- GLOBALS: error, print, setmetatable, getmetatable, debugstack
-- GLOBALS: ItemRefTooltip, UIParent, ShowUIPanel
-- GLOBALS: DEFAULT_CHAT_FRAME
       
----------------------
-- Version Checking --
----------------------
StatLogic.Major = MAJOR
StatLogic.Minor = MINOR
local wowBuildNo = tonumber((select(2, GetBuildInfo())))
StatLogic.wowBuildNo = wowBuildNo
local toc = tonumber((select(4, GetBuildInfo())))


-------------------
-- Set Debugging --
-------------------
local DEBUG = false
function CmdHandler()
  DEBUG = not DEBUG
end
SlashCmdList["STATLOGICDEBUG"] = CmdHandler
SLASH_STATLOGICDEBUG1 = "/sldebug"


-----------------
-- Debug Tools --
-----------------
local function debugPrint(text)
  if DEBUG == true then
    print(text)
  end
end

--[[---------------------------------
  :SetTip(item)
-------------------------------------
Notes:
  * This is a debugging tool for localizers
  * Displays item in ItemRefTooltip
  * item:
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string - itemId or "itemString" or "itemName" or "itemLink"
Returns:
  None
Example:
  StatLogic:SetTip("item:3185:0:0:0:0:0:1957")
-----------------------------------]]
function StatLogic:SetTip(item)
  local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
  if not link then
    DEFAULT_CHAT_FRAME:AddMessage("|c00ff0000Item not in local cache. Run '/item itemid' to quary server(requires Sniff addon).|r")
    return
  end
  ItemRefTooltip:ClearLines()
  ShowUIPanel(ItemRefTooltip)
  if ( not ItemRefTooltip:IsShown() ) then
    ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
  end
  ItemRefTooltip:SetHyperlink(link)
end

-------------------------
-- Localization Tables --
-------------------------
--[[
Localization tips
1. Enable debugging in game with /sldebug
2. There are often ItemIDs in comments for you to check if the items works correctly in game
3. Use the addon Sniff(http://www.wowinterface.com/downloads/info6259/) to get a link in game from an ItemID, Usage: /item 19316
4. Atlas + AtlasLoot is also a good source of items to check
5. Red colored text output from debug means that line does not have a match
6. Building your own ItemStrings(ex: "item:28484:1503:0:2946:2945:0:0:0"): http://www.wowwiki.com/ItemString
   linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId
7. Getting a visual on your ItemString:
  a. Display the ItemRefTooltip by clicking on a link in chat
  b. /dump StatLogic:SetTip("item:23344:2746")
6. Testing Enchants:
  a. Obtain the enchantId from wowhead.
    EX: Find the enchantId for [Golden Spellthread]:
    Find the spell page for the enchant: http://www.wowhead.com/?spell=31370
    Under Spell Details, look for "Enchant Item Permanent (2746)"
    2746 is the enchantId
  b. We need an item to attach the enchant, I like to use [Scout's Pants] ID:23344. (/item 23344 if you don't have it in your cache)
    ItemString: "item:23344:2746"
  c. /dump StatLogic:GetSum("item:23344:2746")
--]]
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
--    If no match then separate the string using L.DeepScanWordSeparators, then check again.
--]]
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
local PatternLocale = {}
local DisplayLocale = {}
PatternLocale.enUS = { -- {{{
  ["tonumber"] = tonumber,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "Plate",
  Mail = "Mail",
  Leather = "Leather",
  Cloth = "Cloth",
  ------------------
  -- Fast Exclude --
  ------------------
  -- Note to localizers: This is important for reducing lag on mouse over.
  -- Turn on /sldebug and see if there are any "No Match" strings, any 
  -- unused strings should be added in the "Exclude" table, because an unmatched 
  -- string costs a lot of CPU time, and should be prevented whenever possible.
  -- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
  ["ExcludeLen"] = 5, -- using string.utf8len
  ["Exclude"] = {
    [""] = true,
    [" \n"] = true,
    ["Binds"] = true,
    [ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
    [ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item will be bound when picked up
    [ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
    [ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
    [ITEM_BIND_TO_ACCOUNT] = true, -- ITEM_BIND_QUEST = "Binds to account";
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
    --4.0.6
    ["Item "] = true, -- ITEM_LEVEL = "Item Level %d"
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["Minor Wizard Oil"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
    ["Lesser Wizard Oil"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
    ["Wizard Oil"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
    ["Brilliant Wizard Oil"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
    ["Superior Wizard Oil"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
    ["Blessed Wizard Oil"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

    ["Minor Mana Oil"] = {["COMBAT_MANA_REGEN"] = 4}, -- ID: 20745
    ["Lesser Mana Oil"] = {["COMBAT_MANA_REGEN"] = 8}, -- ID: 20747
    ["Brilliant Mana Oil"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, -- ID: 20748
    ["Superior Mana Oil"] = {["COMBAT_MANA_REGEN"] = 14}, -- ID: 22521

    --["Eternium Line"] = {["FISHING"] = 5}, -- +5 Fishing
    --["Savagery"] = {["AP"] = 70}, -- +70 Attack Power
    --["Vitality"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- +4 Mana and Health every 5 sec
    --["Soulfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, -- Changed to +54 Shadow and Frost Spell Power
    --["Sunfire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, -- Changed to +50 Arcane and Fire Spell Power

    -- ["Mithril Spurs"] = {["MOUNT_SPEED"] = 4}, -- +4% Mount Speed
    -- ["Minor Mount Speed Increase"] = {["MOUNT_SPEED"] = 2}, -- +2% Mount Speed
    ["Equip: Run speed increased slightly."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
    ["Minor Speed Increase"] = {["RUN_SPEED"] = 8}, -- EnchantID: 911 Enchant Boots - Minor Speed "Minor Speed Increase"
    ["Minor Speed"] = {["RUN_SPEED"] = 8}, -- EnchantID: 2939 Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility"
    ["Minor Run Speed Increase"] = {["RUN_SPEED"] = 8}, -- 
    ["Minor Movement Speed"] = {["RUN_SPEED"] = 8}, -- 
    --["Surefooted"] = {["MELEE_HIT_RATING"] = 10, ["SPELL_HIT_RATING"] = 10, ["MELEE_CRIT_RATING"] = 10, ["SPELL_CRIT_RATING"] = 10}, -- EnchantID: 2658 Enchant Boots - Surefooted

    --["Subtlety"] = {["MOD_THREAT"] = -2}, -- EnchantID: 2621 Enchant Cloak - Subtlety
    ["2% Reduced Threat"] = {["MOD_THREAT"] = -2}, -- EnchantID: 2621, 2832, 3296
    ["Equip: Allows underwater breathing."] = false, -- [Band of Icy Depths] ID: 21526
    ["Allows underwater breathing"] = false, --
    ["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639
    ["Immune to Disarm"] = false, --
    ["Crusader"] = false, -- Enchant 
    ["Lifestealing"] = false, -- Enchant 
    ["Hurricane"] = false, -- Enchant 
    ["Mending"] = false, -- Enchant 
    ["Lightweave Embroidery"] = false, -- Enchant 
    ["Gnomish X-Ray Scope"] = false, -- Enchant 

    --["Tuskar's Vitality"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232 +15 Stamina and Minor Speed Increase
    --["Wisdom"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296 +10 Spirit and 2% Reduced Threat
    --["Accuracy"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788 +25 Hit Rating and +25 Critical Strike Rating
    --["Scourgebane"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247 +140 Attack Power versus Undead
    --["Icewalker"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826 +12 Hit Rating and +12 Critical Strike Rating
    ["Gatherer"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3296
    --["Greater Vitality"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244 +7 Health and Mana every 5 sec

    --["+37 Stamina and +20 Defense"] = {["STA"] = 37, ["DEFENSE_RATING"] = 20}, -- EnchantID: 3818 Defense does not equal Defense Rating...
    ["Rune of Swordbreaking"] = {["PARRY"] = 2}, -- EnchantID: 3594
    ["Rune of Swordshattering"] = {["PARRY"] = 4}, -- EnchantID: 3365
    ["Rune of the Stoneskin Gargoyle"] = {["MOD_ARMOR"] = 4, ["MOD_STA"] = 2}, -- EnchantID: 3847
    ["Rune of the Nerubian Carapace"] = {["MOD_ARMOR"] = 2, ["MOD_STA"] = 1}, -- EnchantID: 3883
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
  -- Its preferable to have as few "PreScanPatterns" as possible, only use this table if all other methods fail.
  -- Special cases that need to be dealt with before deep scan
  ["PreScanPatterns"] = {
    --["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
    --["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
    ["^(%d+) Armor$"] = "ARMOR",
    ["Increases your mastery rating by (%d+).-%)$"] = "MASTERY_RATING",
    ["%d+ secs?[,%.]"] = false, -- Procs
    ["Reinforced %(%+(%d+) Armor%)"] = "ARMOR_BONUS",
    ["Mana Regen (%d+) per 5 sec%.$"] = "COMBAT_MANA_REGEN",
    ["^%+?%d+ %- (%d+) .-Damage$"] = "MAX_DAMAGE",
    ["^%(([%d%.]+) damage per second%)$"] = "DPS",
    -- Exclude
    ["^(%d+) Slot"] = false, -- Bags
    ["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    --["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
    ["[Ss]ometimes"] = false, -- [Darkmoon Card: Heroism] ID:19287
    ["[Ww]hen struck in combat"] = false, -- [Essence of the Pure Flame] ID: 18815
    ["^Increases attack power by (%d+) in Cat, Bear, Dire Bear, and Moonkin forms only%.$"] = "FERAL_AP", -- 3.0.8 FAP change
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
    "\n", -- Meta Gems
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
    ["% Threat"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
    ["% Intellect"] = {"MOD_INT"}, -- [Ember Skyflare Diamond] ID: 41333
    ["% Shield Block Value"] = {"MOD_BLOCK_VALUE"}, -- [Eternal Earthsiege Diamond] ID: 41396
    ["% Mount Speed"] = {"MOUNT_SPEED"}, -- Mithril Spurs, Minor Mount Speed Increase
    ["Scope (Damage)"] = {"RANGED_DMG"}, -- Khorium Scope EnchantID: 2723
    ["Scope (Critical Strike Rating)"] = {"RANGED_CRIT_RATING"}, -- Stabilized Eternium Scope EnchantID: 2724
    ["Your attacks ignoreof your opponent's armor"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
    ["Increases your effective stealth level"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
    ["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant
    ["Increases mount speed%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

    ["All Stats"] = {"STR", "AGI", "STA", "INT", "SPI",},
    ["to All Stats"] = {"STR", "AGI", "STA", "INT", "SPI",}, -- [Enchanted Tear] ID: 42702
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
    ["to All Resistances"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

    ["Fishing"] = {"FISHING",}, -- Fishing enchant ID:846
    ["Fishing Skill"] = {"FISHING",}, -- Fishing lure
    ["Increased Fishing"] = {"FISHING",}, -- Equip: Increased Fishing +20.
    ["Mining"] = {"MINING",}, -- Mining enchant ID:844
    ["Herbalism"] = {"HERBALISM",}, -- Heabalism enchant ID:845
    ["Skinning"] = {"SKINNING",}, -- Skinning enchant ID:865

    ["Armor"] = {"ARMOR_BONUS",},
    ["Defense"] = {"DEFENSE",},
    ["Increased Defense"] = {"DEFENSE",},

    ["Health"] = {"HEALTH",},
    ["HP"] = {"HEALTH",},
    ["Mana"] = {"MANA",},

    ["Attack Power"] = {"AP",},
    ["Increases attack power"] = {"AP",},
    ["Attack Power when fighting Undead"] = {"AP_UNDEAD",},
    ["Attack Power versus Undead"] = {"AP_UNDEAD",}, -- Scourgebane EnchantID: 3247
    -- [Wristwraps of Undead Slaying] ID:23093
    ["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
    ["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
    ["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
    ["Increases attack powerwhen fighting Undead and Demons"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
    ["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
    ["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},
    ["Ranged Attack Power"] = {"RANGED_AP",},
    ["Increases ranged attack power"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

    ["Health Regen"] = {"COMBAT_MANA_REGEN",},
    ["Health per"] = {"COMBAT_HEALTH_REGEN",},
    ["health per"] = {"COMBAT_HEALTH_REGEN",}, -- Frostwolf Insignia Rank 6 ID:17909
    ["Health every"] = {"COMBAT_MANA_REGEN",},
    ["health every"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743
    ["your normal health regeneration"] = {"COMBAT_HEALTH_REGEN",}, -- Demons Blood ID: 10779
    ["Restoreshealth per 5 sec"] = {"COMBAT_HEALTH_REGEN",}, -- [Onyxia Blood Talisman] ID: 18406
    ["Restoreshealth every 5 sec"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743
    ["Mana Regen"] = {"COMBAT_MANA_REGEN",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
    ["Mana per"] = {"COMBAT_MANA_REGEN",},
    ["mana per"] = {"COMBAT_MANA_REGEN",}, -- Resurgence Rod ID:17743 Most common
    ["Mana every"] = {"COMBAT_MANA_REGEN",},
    ["mana every"] = {"COMBAT_MANA_REGEN",},
    ["Mana every 5 seconds"] = {"COMBAT_MANA_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["Mana every 5 Sec"] = {"COMBAT_MANA_REGEN",}, --
    ["mana every 5 sec"] = {"COMBAT_MANA_REGEN",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
    ["Mana per 5 Seconds"] = {"COMBAT_MANA_REGEN",}, -- [Royal Shadow Draenite] ID: 23109
    ["Mana Per 5 sec"] = {"COMBAT_MANA_REGEN",}, -- [Royal Shadow Draenite] ID: 23109
    ["Mana per 5 sec"] = {"COMBAT_MANA_REGEN",}, -- [Cyclone Shoulderpads] ID: 29031
    ["mana per 5 sec"] = {"COMBAT_MANA_REGEN",}, -- [Royal Tanzanite] ID: 30603
    ["Restoresmana per 5 sec"] = {"COMBAT_MANA_REGEN",}, -- [Resurgence Rod] ID:17743
    ["Mana restored per 5 seconds"] = {"COMBAT_MANA_REGEN",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
    ["Mana Regenper 5 sec"] = {"COMBAT_MANA_REGEN",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
    ["Mana per 5 Sec"] = {"COMBAT_MANA_REGEN",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913
    ["Health and Mana every 5 sec"] = {"COMBAT_HEALTH_REGEN", "COMBAT_MANA_REGEN",}, -- Greater Vitality EnchantID: 3244

    ["Spell Penetration"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
    ["Increases your spell penetration"] = {"SPELLPEN",},
    ["Increases spell penetration"] = {"SPELLPEN",},

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
    ["Shadow and Frost Spell Power"] = {"SHADOW_SPELL_DMG", "FROST_SPELL_DMG",}, -- Soulfrost
    ["Arcane and Fire Spell Power"] = {"ARCANE_SPELL_DMG", "FIRE_SPELL_DMG",}, -- Sunfire
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

    ["Hit Rating"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},
    ["Improves hit rating"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"}, -- ITEM_MOD_HIT_RATING
    ["Increases your hit rating"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},
    ["Improves melee hit rating"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
    ["Spell Hit"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
    ["Spell Hit Rating"] = {"SPELL_HIT_RATING",},
    ["Improves spell hit rating"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["Increases your spell hit rating"] = {"SPELL_HIT_RATING",},
    ["Ranged Hit Rating"] = {"RANGED_HIT_RATING",}, -- Biznicks 247x128 Accurascope EnchantID: 2523
    ["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    ["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},

    ["Crit Rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Critical Rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Critical Strike Rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Increases your critical hit rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Increases your critical strike rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Improves critical strike rating"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Improves melee critical strike rating"] = {"MELEE_CRIT_RATING",}, -- [Cloak of Darkness] ID:33122
    ["Spell Critical Strike Rating"] = {"SPELL_CRIT_RATING",},
    ["Spell Critical strike rating"] = {"SPELL_CRIT_RATING",},
    ["Spell Critical Rating"] = {"SPELL_CRIT_RATING",},
    ["Spell Crit Rating"] = {"SPELL_CRIT_RATING",},
    ["Increases your spell critical strike rating"] = {"SPELL_CRIT_RATING",},
    ["Increases the spell critical strike rating of all party members within 30 yards"] = {"SPELL_CRIT_RATING",},
    ["Improves spell critical strike rating"] = {"SPELL_CRIT_RATING",},
    ["Increases your ranged critical strike rating"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348
    ["Ranged Critical Strike"] = {"RANGED_CRIT_RATING",}, -- Heartseeker Scope EnchantID: 3608

    ["Improves hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
    ["Improves melee hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
    ["Improves ranged hit avoidance rating"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
    ["Improves spell hit avoidance rating"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
    ["Resilience"] = {"RESILIENCE_RATING",},
    ["Resilience Rating"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
    ["Improves your resilience rating"] = {"RESILIENCE_RATING",},
    ["Increases your resilience rating"] = {"RESILIENCE_RATING",},
    ["Improves critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    ["Improves melee critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    ["Improves ranged critical avoidance rating"] = {"RANGED_CRIT_AVOID_RATING",},
    ["Improves spell critical avoidance rating"] = {"SPELL_CRIT_AVOID_RATING",},

    ["Haste Rating"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Improves haste rating"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Increases your haste rating"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
    ["Increases your melee haste rating"] = {"MELEE_HASTE_RATING"},
    ["Spell Haste Rating"] = {"SPELL_HASTE_RATING"},
    ["Improves spell haste rating"] = {"SPELL_HASTE_RATING"},
    ["Increases your spell haste rating"] = {"SPELL_HASTE_RATING"},
    ["Ranged Haste Rating"] = {"RANGED_HASTE_RATING"}, -- Micro Stabilizer EnchantID: 3607
    ["Improves ranged haste rating"] = {"RANGED_HASTE_RATING"},
    ["Increases your ranged haste rating"] = {"RANGED_HASTE_RATING"},

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

    ["expertise rating"] = {"EXPERTISE_RATING"}, -- gems
    ["Increases your expertise rating"] = {"EXPERTISE_RATING"},
    ["armor penetration rating"] = {"ARMOR_PENETRATION_RATING"}, -- gems
    ["Increases armor penetration rating"] = {"ARMOR_PENETRATION_RATING"},
    ["Increases your armor penetration rating"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178

    ["mastery rating"] = {"MASTERY_RATING"}, -- gems
    ["Increases your mastery rating"] = {"MASTERY_RATING"},

    -- Exclude
    ["sec"] = false,
    ["to"] = false,
    ["Slot Bag"] = false,
    ["Slot Quiver"] = false,
    ["Slot Ammo Pouch"] = false,
    ["Increases ranged attack speed"] = false, -- AV quiver
    ["Experience gained is increased%"] = false, -- Heirlooms
  },
} -- }}}

DisplayLocale.enUS = { -- {{{
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "Stat Multiplier",
  ["Attack Power Multiplier"] = "Attack Power Multiplier",
  ["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
  ["StatIDToName"] = {
    --[StatID] = {FullName, ShortName},
    ---------------------------------------------------------------------------
    -- Tier1 Stats - Stats parsed directly off items
    ["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
    ["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
    ["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
    ["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";

    ["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
    ["MOD_THREAT"] = {"Threat", "Threat", isPercent = true},
    ["STEALTH_LEVEL"] = {"Stealth Level", "Stealth", isPercent = true},
    ["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg", isPercent = true}, -- DAMAGE = "Damage"
    ["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg", isPercent = true}, -- DAMAGE = "Damage"
    ["MOUNT_SPEED"] = {"Mount Speed", "Mount Spd", isPercent = true},
    ["RUN_SPEED"] = {"Run Speed", "Run Spd", isPercent = true},

    ["STR"] = {SPELL_STAT1_NAME, "Str"},
    ["AGI"] = {SPELL_STAT2_NAME, "Agi"},
    ["STA"] = {SPELL_STAT3_NAME, "Sta"},
    ["INT"] = {SPELL_STAT4_NAME, "Int"},
    ["SPI"] = {SPELL_STAT5_NAME, "Spi"},
    ["ARMOR"] = {ARMOR, ARMOR},
    ["ARMOR_BONUS"] = {"Bonus "..ARMOR, "Bonus "..ARMOR},

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

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
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
    ["HEALTH_REGEN"] = {HEALTH.." Regen (Normal)", "HP5(OC)"},
    ["MANA_REGEN"] = {MANA.." Regen (Normal)", "MP5(OC)"},
    ["COMBAT_HEALTH_REGEN"] = {HEALTH.." Regen (Combat)", "HP5"},
    ["COMBAT_MANA_REGEN"] = {MANA.." Regen (Combat)", "MP5"},

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
    ["EXPERTISE_RATING"] = {"Expertise "..RATING, "Expertise "..RATING},
    ["ARMOR_PENETRATION_RATING"] = {"Armor Penetration "..RATING, "ArP "..RATING},
    ["MASTERY_RATING"] = {"Mastery "..RATING, "Mastery "..RATING},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction", "Crit Dmg Reduc", isPercent = true},
    ["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc", isPercent = true},
    ["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc", isPercent = true},
    ["DEFENSE"] = {DEFENSE, "Def"},
    ["DODGE"] = {DODGE, DODGE, isPercent = true},
    ["PARRY"] = {PARRY, PARRY, isPercent = true},
    ["BLOCK"] = {BLOCK, BLOCK, isPercent = true},
    ["AVOIDANCE"] = {"Avoidance", "Avoidance", isPercent = true},
    ["MELEE_HIT"] = {"Hit Chance", "Hit", isPercent = true},
    ["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Chance", PLAYERSTAT_RANGED_COMBAT.." Hit", isPercent = true},
    ["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Chance", PLAYERSTAT_SPELL_COMBAT.." Hit", isPercent = true},
    ["MELEE_HIT_AVOID"] = {"Hit Avoidance", "Hit Avd", isPercent = true},
    ["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Avoidance", PLAYERSTAT_RANGED_COMBAT.." Hit Avd", isPercent = true},
    ["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Avoidance", PLAYERSTAT_SPELL_COMBAT.." Hit Avd", isPercent = true},
    ["MELEE_CRIT"] = {MELEE_CRIT_CHANCE, "Crit"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
    ["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE, PLAYERSTAT_RANGED_COMBAT.." Crit", isPercent = true},
    ["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE, PLAYERSTAT_SPELL_COMBAT.." Crit", isPercent = true},
    ["MELEE_CRIT_AVOID"] = {"Crit Avoidance", "Crit Avd", isPercent = true},
    ["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance", PLAYERSTAT_RANGED_COMBAT.." Crit Avd", isPercent = true},
    ["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance", PLAYERSTAT_SPELL_COMBAT.." Crit Avd", isPercent = true},
    ["MELEE_HASTE"] = {"Haste", "Haste"}, --
    ["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Haste", PLAYERSTAT_RANGED_COMBAT.." Haste", isPercent = true},
    ["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Haste", PLAYERSTAT_SPELL_COMBAT.." Haste", isPercent = true},
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
    ["ARMOR_PENETRATION"] = {"Armor Penetration", "ArP", isPercent = true},
    ["MASTERY"] = {"Mastery", "Mastery"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    -- Expertise -> Dodge Neglect, Parry Neglect
    ["DODGE_NEGLECT"] = {DODGE.." Neglect", DODGE.." Neglect", isPercent = true},
    ["PARRY_NEGLECT"] = {PARRY.." Neglect", PARRY.." Neglect", isPercent = true},
    ["BLOCK_NEGLECT"] = {BLOCK.." Neglect", BLOCK.." Neglect", isPercent = true},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"Crit Damage", "Crit Dmg", isPercent = true},
    ["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg", isPercent = true},
    ["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg", isPercent = true},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
    -- Use strsplit("@", text) to seperate the spell name and statid
    ["THREAT"] = {"Threat", "Threat"},
    ["CAST_TIME"] = {"Casting Time", "Cast Time"},
    ["MANA_COST"] = {"Mana Cost", "Mana Cost"},
    ["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
    ["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
    ["COOLDOWN"] = {"Cooldown", "CD"},

    ---------------------------------------------------------------------------
    -- Stats Mods
    ["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME, "Mod Str", isPercent = true},
    ["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME, "Mod Agi", isPercent = true},
    ["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME, "Mod Sta", isPercent = true},
    ["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME, "Mod Int", isPercent = true},
    ["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME, "Mod Spi", isPercent = true},
    ["MOD_HEALTH"] = {"Mod "..HEALTH, "Mod "..HP, isPercent = true},
    ["MOD_MANA"] = {"Mod "..MANA, "Mod "..MP, isPercent = true},
    ["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items", "Mod "..ARMOR.."(Items)", isPercent = true},
    ["MOD_BLOCK_VALUE"] = {"Mod Block Value", "Mod Block Value", isPercent = true},
    ["MOD_DMG"] = {"Mod Damage", "Mod Dmg", isPercent = true},
    ["MOD_DMG_TAKEN"] = {"Mod Damage Taken", "Mod Dmg Taken", isPercent = true},
    ["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage", "Mod Crit Dmg", isPercent = true},
    ["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken", "Mod Crit Dmg Taken", isPercent = true},
    ["MOD_THREAT"] = {"Mod Threat", "Mod Threat", isPercent = true},
    ["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP, "Mod AP", isPercent = true},
    ["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP, "Mod RAP", isPercent = true},
    ["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg", isPercent = true},
    ["MOD_HEAL"] = {"Mod Healing", "Mod Heal", isPercent = true},
    ["MOD_CAST_TIME"] = {"Mod Casting Time", "Mod Cast Time", isPercent = true},
    ["MOD_MANA_COST"] = {"Mod Mana Cost", "Mod Mana Cost", isPercent = true},
    ["MOD_RAGE_COST"] = {"Mod Rage Cost", "Mod Rage Cost", isPercent = true},
    ["MOD_ENERGY_COST"] = {"Mod Energy Cost", "Mod Energy Cost", isPercent = true},
    ["MOD_COOLDOWN"] = {"Mod Cooldown", "Mod CD", isPercent = true},
    ["CRIT_TAKEN"] = {"Chance to be critically hit", "Crit Taken", isPercent = true},
    ["HIT_TAKEN"] = {"Chance to be hit", "Hit Taken", isPercent = true},
    ["CRIT_DAMAGE_TAKEN"] = {"Critical damage taken", "Crit Dmg Taken", isPercent = true},
    ["DMG_TAKEN"] = {"Damage taken", "Dmg Taken", isPercent = true},
    ["CRIT_DAMAGE"] = {"Critical damage", "Crit Dmg", isPercent = true},
    ["DMG"] = {DAMAGE, DAMAGE},
    ["BLOCK_REDUCTION"] = {"Increases the amount your block stops by %1d", "Block Value", isPercent = true},

    ---------------------------------------------------------------------------
    -- Misc Stats
    ["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
    ["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
    ["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
    ["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
    ["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
  },
} -- }}}

PatternLocale.enGB = PatternLocale.enUS
DisplayLocale.enGB = DisplayLocale.enUS

-- koKR localization by fenlis, 7destiny, slowhand
PatternLocale.koKR = { -- {{{
  ["tonumber"] = tonumber,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "판금",
  Mail = "사슬",
  Leather = "가죽",
  Cloth = "천",
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["최하급 마나 오일"] = {["COMBAT_MANA_REGEN"] = 4}, -- ID: 20745
    ["하급 마나 오일"] = {["COMBAT_MANA_REGEN"] = 8}, -- ID: 20747
    ["반짝이는 마나 오일"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, -- ID: 20748
    ["상급 마나 오일"] = {["COMBAT_MANA_REGEN"] = 14}, -- ID: 22521

    ["에터니움 낚시줄"] = {["FISHING"] = 5}, --
    ["전투력"] = {["AP"] = 70}, --
    ["활력"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
    ["냉기의 영혼"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["태양의 불꽃"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

    ["미스릴 박차"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
    ["최하급 탈것 속도 증가"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
    ["착용 효과: 달리기 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, -- [산악연대 판금 경갑] ID: 20048
    ["달리기 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, --
    ["최하급 달리기 속도 증가"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
    ["최하급 달리기 속도"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
    ["침착함"] = {["MELEE_HIT_RATING"] = 10, ["SPELL_HIT_RATING"] = 10, ["MELEE_CRIT_RATING"] = 10, ["SPELL_CRIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

    ["위협 수준 감소"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    ["위협 수준 2%만큼 감소"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["착용 효과: 물속에서 숨쉴 수 있도록 해줍니다."] = false, -- [얼음 심연의 고리] ID: 21526
    ["물속에서 숨쉴 수 있도록 해줍니다"] = false, --
    ["착용 효과: 무장 해제의 지속시간이 50%만큼 감소합니다."] = false, -- [야성의 건들릿] ID: 12639
    ["무장해제에 면역이 됩니다"] = false, --
    ["성전사"] = false, -- Enchant Crusader
    ["흡혈"] = false, -- Enchant Crusader

    ["투스카르의 활력"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["지혜"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["적중"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["스컬지 파멸"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["극지방랑자"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["채집가"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3296
    ["상급 활력"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244
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
    ["^표범, 광포한 곰, 곰, 달빛야수 변신 상태일 때 전투력이 (%d+)만큼 증가합니다%.$"] = "FERAL_AP", -- 3.0.8 FAP change
    ["^방어도 (%d+)$"] = "ARMOR",
    ["방어도 보강 %(%+(%d+)%)"] = "ARMOR_BONUS",
    ["매 5초마다 (%d+)의 생명력이 회복됩니다.$"] = "COMBAT_HEALTH_REGEN",
    ["매 5초마다 (%d+)의 마나가 회복됩니다.$"] = "COMBAT_MANA_REGEN",
    ["^.-공격력 %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
    ["^%(초당 공격력 ([%d%.]+)%)$"] = "DPS",
    -- Exclude
    ["^(%d+)칸"] = false, -- Bags
    ["^[%D ]+ %((%d+)/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    ["일정 확률로"] = false, -- [도전의 징표] ID:27924 -- [퀴라지 예언자의 지팡이] ID:21128
    ["확률로"] = false, -- [다크문 카드: 영웅심] ID:19287
    ["가격 당했을 때"] = false, -- [순수한 불꽃의 정수] ID: 18815
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
    --", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
    "%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
    " / ",
  },
  ["DeepScanWordSeparators"] = {
    -- only put word separators here like "and" in english
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
    ["위협 수준%"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
    ["지능%"] = {"MOD_INT"}, -- [Ember Skyflare Diamond] ID: 41333
    ["방패 피해 방어량%"] = {"MOD_BLOCK_VALUE"}, -- [Eternal Earthsiege Diamond] ID: 41396
    ["조준경 (공격력)"] = {"RANGED_DMG"}, -- Khorium Scope EnchantID: 2723
    ["조준경 (치명타 적중도)"] = {"RANGED_CRIT_RATING"}, -- Stabilized Eternium Scope EnchantID: 2724
    ["공격 시 적의 방어도를 무시합니다"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
    ["은신의 효과 레벨이 증가합니다"] = {"STEALTH_LEVEL"}, -- [밤하늘 장화] ID: 8197
    ["무기 공격력"] = {"MELEE_DMG"}, -- Enchant
    ["탈것의 속도가 %만큼 증가합니다"] = {"MOUNT_SPEED"}, -- [산악연대 판금 경갑] ID: 20048

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

    ["생명력"] = {"HEALTH",},
    ["HP"] = {"HEALTH",},
    ["마나"] = {"MANA",},

    ["전투력"] = {"AP",},
    ["전투력이 증가합니다"] = {"AP",},
    ["언데드에 대한 전투력"] = {"AP_UNDEAD",},
    -- [언데드 퇴치의 손목보호대] ID:23093
    ["언데드에 대한 전투력이 증가합니다"] = {"AP_UNDEAD",}, -- [여명의 문장] ID:13209
    ["언데드에 대한 전투력이 증가합니다. 또한 은빛 여명회를 대표하여 스컬지석을 획득할 수 있습니다"] = {"AP_UNDEAD",}, -- [여명의 문장] ID:13209
    ["악마에 대한 전투력이 증가합니다"] = {"AP_DEMON",},
    ["언데드 및 악마에 대한 전투력이 증가합니다"] = {"AP_UNDEAD", "AP_DEMON",},
    ["언데드 및 악마에 대한 전투력이 증가합니다. 또한 은빛 여명회를 대표하여 스컬지석을 획득할 수 있습니다"] = {"AP_UNDEAD", "AP_DEMON",}, -- [용사의 징표] ID:23206
    ["표범, 광포한 곰, 곰, 달빛야수 변신 상태일 때 전투력"] = {"FERAL_AP",},
    ["표범, 광포한 곰, 곰, 달빛야수 변신 상태일 때 전투력이 증가합니다"] = {"FERAL_AP",},
    ["원거리 전투력"] = {"RANGED_AP",},
    ["원거리 전투력이 증가합니다"] = {"RANGED_AP",}, -- [대장군의 석궁] ID: 18837

    ["생명력 회복량"] = {"COMBAT_HEALTH_REGEN",},
    ["매 5초마다 (.+)의 생명력"] = {"COMBAT_HEALTH_REGEN",},
    ["평상시 생명력 회복 속도"] = {"COMBAT_HEALTH_REGEN",}, -- [악마의 피] ID: 10779
    ["마나 회복량"] = {"COMBAT_MANA_REGEN",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
    ["매 5초마다 (.+)의 마나"] = {"COMBAT_MANA_REGEN",},
    ["5초당 마나 회복량"] = {"COMBAT_MANA_REGEN",}, -- [호화로운 야안석] ID: 24057

    ["주문 관통력"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
    ["주문 관통력이 증가합니다"] = {"SPELLPEN",},

    ["치유량 및 주문 공격력"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
    ["치유 및 주문 공격력"] = {"SPELL_DMG", "HEAL",},
    ["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",},
    ["주문 공격력"] = {"SPELL_DMG", "HEAL",},
    ["모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"},
    ["주위 30미터 반경에 있는 모든 파티원의 주문력이 증가합니다"] = {"SPELL_DMG", "HEAL"}, -- 아티쉬
    ["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
    ["피해"] = {"SPELL_DMG",},
    ["주문 공격력이 증가합니다"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
    ["주문력"] = {"SPELL_DMG", "HEAL",},
    ["주문력이 증가합니다"] = {"SPELL_DMG", "HEAL",}, -- WotLK
    ["신성 피해"] = {"HOLY_SPELL_DMG",},
    ["비전 피해"] = {"ARCANE_SPELL_DMG",},
    ["화염 피해"] = {"FIRE_SPELL_DMG",},
    ["자연 피해"] = {"NATURE_SPELL_DMG",},
    ["냉기 피해"] = {"FROST_SPELL_DMG",},
    ["암흑 피해"] = {"SHADOW_SPELL_DMG",},
    ["신성 주문력"] = {"HOLY_SPELL_DMG",},
    ["비전 주문력"] = {"ARCANE_SPELL_DMG",},
    ["화염 주문력"] = {"FIRE_SPELL_DMG",},
    ["자연 주문력"] = {"NATURE_SPELL_DMG",},
    ["냉기 주문력"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
    ["암흑 주문력"] = {"SHADOW_SPELL_DMG",},
    ["암흑 주문력이 증가합니다"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
    ["냉기 주문력이 증가합니다"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
    ["신성 주문력이 증가합니다"] = {"HOLY_SPELL_DMG",},
    ["비전 주문력이 증가합니다"] = {"ARCANE_SPELL_DMG",},
    ["화염 주문력이 증가합니다"] = {"FIRE_SPELL_DMG",},
    ["자연 주문력이 증가합니다"] = {"NATURE_SPELL_DMG",},

    ["언데드에 대한 주문력이 증가합니다"] = {"SPELL_DMG_UNDEAD"},
    ["언데드에 대한 주문력이 증가합니다. 또한 은빛여명회의 대리인으로서 스컬지석을 모을 수 있습니다"] = {"SPELL_DMG_UNDEAD"},
    ["언데드 및 악마에 대한 주문력이 증가합니다"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [용사의 징표] ID:23207

    ["주문 치유량"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
    ["치유량 증가"] = {"HEAL",},
    ["치유량"] = {"HEAL",},
    ["주문 공격력"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
    ["모든 주문 및 효과에 의한 치유량이"] = {"HEAL",}, -- 2.3.0
    ["주문 피해가 증가합니다"] = {"SPELL_DMG",}, -- 2.3.0
    ["모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",},

    ["초당 공격력"] = {"DPS",},
    ["초당의 피해 추가"] = {"DPS",}, -- [Thorium Shells] ID: 15977

    ["방어 숙련도"] = {"DEFENSE_RATING",},
    ["방어 숙련도가 증가합니다"] = {"DEFENSE_RATING",},
    ["회피 숙련도"] = {"DODGE_RATING",},
    ["회피 숙련도가 증가합니다."] = {"DODGE_RATING",},
    ["무기 막기 숙련도"] = {"PARRY_RATING",},
    ["무기 막기 숙련도가 증가합니다"] = {"PARRY_RATING",},
    ["방패 막기 숙련도"] = {"BLOCK_RATING",},
    ["방패 막기 숙련도가 증가합니다"] = {"BLOCK_RATING",},

    ["적중도"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},
    ["적중도가 증가합니다"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"}, -- ITEM_MOD_HIT_RATING
    ["근접 적중도가 증가합니다"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
    ["주문 적중"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
    ["주문 적중도"] = {"SPELL_HIT_RATING",},
    ["주문 적중도가 증가합니다"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["원거리 적중도"] = {"RANGED_HIT_RATING",}, -- Biznicks 247x128 Accurascope EnchantID: 2523
    ["원거리 적중도가 증가합니다"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING

    ["치명타 적중도"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["치명타 적중도가 증가합니다"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["주문 극대화 적중도"] = {"SPELL_CRIT_RATING",},
    ["주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
    ["주위 30미터 반경에 있는 모든 파티원의 주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
    ["원거리 치명타 적중도"] = {"RANGED_CRIT_RATING",}, -- Heartseeker Scope EnchantID: 3608
    ["원거리 치명타 적중도가 증가합니다"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348
    ["치명타 및 주문 극대화 적중도"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["치명타 및 주문 극대화 적중도가 증가합니다"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},

    ["공격 회피 숙련도가 증가합니다"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
    ["근접 공격 회피 숙련도가 증가합니다"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
    ["원거리 공격 회피 숙련도가 증가합니다"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
    ["주문 공격 회피 숙련도가 증가합니다"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
    ["탄력도"] = {"RESILIENCE_RATING",},
    ["탄력도가 증가합니다"] = {"RESILIENCE_RATING",},
    ["치명타 회피 숙련도가 증가합니다"] = {"MELEE_CRIT_AVOID_RATING",},
    ["근접 치명타 회피 숙련도가 증가합니다"] = {"MELEE_CRIT_AVOID_RATING",},
    ["원거리 치명타 회피 숙련도가 증가합니다"] = {"RANGED_CRIT_AVOID_RATING",},
    ["주문 치명타 회피 숙련도가 증가합니다"] = {"SPELL_CRIT_AVOID_RATING",},

    ["가속도"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["가속도가 증가합니다"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["근접 공격 가속도가 증가합니다"] = {"MELEE_HASTE_RATING"},
    ["주문 시전 가속도"] = {"SPELL_HASTE_RATING"},
    ["주문 시전 가속도가 증가합니다"] = {"SPELL_HASTE_RATING"},
    ["원거리 공격 가속도"] = {"RANGED_HASTE_RATING"}, -- Micro Stabilizer EnchantID: 3607
    ["원거리 공격 가속도가 증가합니다"] = {"RANGED_HASTE_RATING"},

    ["단검류 숙련도가 증가합니다"] = {"DAGGER_WEAPON_RATING"},
    ["한손 도검류 숙련도가 증가합니다"] = {"SWORD_WEAPON_RATING"},
    ["양손 도검류 숙련도가 증가합니다"] = {"2H_SWORD_WEAPON_RATING"},
    ["한손 도끼류 숙련도가 증가합니다"] = {"AXE_WEAPON_RATING"},
    ["양손 도끼류 숙련도가 증가합니다"] = {"2H_AXE_WEAPON_RATING"},
    ["한손 둔기류 숙련도가 증가합니다"] = {"MACE_WEAPON_RATING"},
    ["양손 둔기류 숙련도가 증가합니다"] = {"2H_MACE_WEAPON_RATING"},
    ["총기류 숙련도가 증가합니다"] = {"GUN_WEAPON_RATING"},
    ["석궁류 숙련도가 증가합니다"] = {"CROSSBOW_WEAPON_RATING"},
    ["활류 숙련도가 증가합니다"] = {"BOW_WEAPON_RATING"},
    ["야성 전투 숙련도가 증가합니다"] = {"FERAL_WEAPON_RATING"},
    ["장착 무기류 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
    ["맨손 전투 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
    ["지팡이류 숙련도가 증가합니다"] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410

    ["숙련"] = {"EXPERTISE_RATING"}, -- gems
    ["숙련도가 증가합니다"] = {"EXPERTISE_RATING"},

    ["방어구 관통력"] = {"ARMOR_PENETRATION_RATING"}, -- gems
    ["방어구 관통력이 증가합니다"] = {"ARMOR_PENETRATION_RATING"},

    ["특화"] = {"MASTERY_RATING"}, -- gems
    ["특화도가 증가합니다"] = {"MASTERY_RATING"},

    -- Exclude
    ["초"] = false,
    ["칸 가방"] = false,
    ["칸 화살통"] = false,
    ["칸 탄환 주머니"] = false,
    ["원거리 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
    ["원거리 무기 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
  },
} -- }}}

DisplayLocale.koKR = { -- {{{
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "Stat Multiplier",
  ["Attack Power Multiplier"] = "Attack Power Multiplier",
  ["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
  ["StatIDToName"] = {
    --[StatID] = {FullName, ShortName},
    ---------------------------------------------------------------------------
    -- Tier1 Stats - Stats parsed directly off items
    ["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, "붉은 보석"}, -- EMPTY_SOCKET_RED = "Red Socket";
    ["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, "노란 보석"}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
    ["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, "푸른 보석"}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
    ["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, "얼개 보석"}, -- EMPTY_SOCKET_META = "Meta Socket";

    ["IGNORE_ARMOR"] = {"방어도 무시", "방무"},
    ["MOD_THREAT"] = {"위협(%)", "위협(%)"},
    ["STEALTH_LEVEL"] = {"은신 레벨 증가", "은신 레벨"},
    ["MELEE_DMG"] = {"근접 무기 공격력", "무기 공격력"}, -- DAMAGE = "Damage"
    ["RANGED_DMG"] = {"원거리 무기 공격력", "원거리 공격력"}, -- DAMAGE = "Damage"
    ["MOUNT_SPEED"] = {"탈것 속도(%)", "탈것 속도(%)"},
    ["RUN_SPEED"] = {"이동 속도(%)", "이속(%)"},

    ["STR"] = {SPELL_STAT1_NAME, SPELL_STAT1_NAME},
    ["AGI"] = {SPELL_STAT2_NAME, "민첩"},
    ["STA"] = {SPELL_STAT3_NAME, SPELL_STAT3_NAME},
    ["INT"] = {SPELL_STAT4_NAME, SPELL_STAT4_NAME},
    ["SPI"] = {SPELL_STAT5_NAME, SPELL_STAT5_NAME},
    ["ARMOR"] = {ARMOR, ARMOR},
    ["ARMOR_BONUS"] = {"효과에 의한"..ARMOR, ARMOR.."(보너스)"},

    ["FIRE_RES"] = {RESISTANCE2_NAME, "화저"},
    ["NATURE_RES"] = {RESISTANCE3_NAME, "자저"},
    ["FROST_RES"] = {RESISTANCE4_NAME, "냉저"},
    ["SHADOW_RES"] = {RESISTANCE5_NAME, "암저"},
    ["ARCANE_RES"] = {RESISTANCE6_NAME, "비저"},

    ["FISHING"] = {"낚시", "낚시"},
    ["MINING"] = {"채광", "채광"},
    ["HERBALISM"] = {"약초채집", "약초"},
    ["SKINNING"] = {"무두질", "무두"},

    ["BLOCK_VALUE"] = {"피해 방어량", "방어량"},

    ["AP"] = {"전투력", "전투력"},
    ["RANGED_AP"] = {RANGED_ATTACK_POWER, "원거리 전투력"},
    ["FERAL_AP"] = {"야성 전투력", "야성 전투력"},
    ["AP_UNDEAD"] = {"전투력 (언데드)", "전투력 (언데드)"},
    ["AP_DEMON"] = {"전투력 (악마)", "전투력 (악마)"},

    ["HEAL"] = {"치유량", "치유"},

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
    ["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." 공격력", "공격력"},
    ["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." 공격력 (언데드)", "공격력 (언데드)"},
    ["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." 공격력 (악마)", "공격력 (악마)"},
    ["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." 공격력", SPELL_SCHOOL1_CAP.." 공격력"},
    ["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." 공격력", SPELL_SCHOOL2_CAP.." 공격력"},
    ["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." 공격력", SPELL_SCHOOL3_CAP.." 공격력"},
    ["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." 공격력", SPELL_SCHOOL4_CAP.." 공격력"},
    ["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." 공격력", SPELL_SCHOOL5_CAP.." 공격력"},
    ["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." 공격력", SPELL_SCHOOL6_CAP.." 공격력"},

    ["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION},

    ["HEALTH"] = {HEALTH, "HP"},
    ["MANA"] = {MANA, "MP"},
    ["COMBAT_HEALTH_REGEN"] = {HEALTH.." 회복", "HP5"},
    ["COMBAT_MANA_REGEN"] = {MANA.." 회복", "MP5"},

    ["MAX_DAMAGE"] = {"최대 공격력", "맥뎀"},
    ["DPS"] = {"초당 공격력", "DPS"},

    ["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, "방숙"}, -- COMBAT_RATING_NAME2 = "Defense Rating"
    ["DODGE_RATING"] = {COMBAT_RATING_NAME3, "회피"}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
    ["PARRY_RATING"] = {COMBAT_RATING_NAME4, "무막"}, -- COMBAT_RATING_NAME4 = "Parry Rating"
    ["BLOCK_RATING"] = {COMBAT_RATING_NAME5, "방막"}, -- COMBAT_RATING_NAME5 = "Block Rating"
    ["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
    ["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
    ["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
    ["MELEE_HIT_AVOID_RATING"] = {"빗맞힘(숙련도)", "빗맞힘"},
    ["RANGED_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 빗맞힘(숙련도)", PLAYERSTAT_RANGED_COMBAT.." 빗맞힘"},
    ["SPELL_HIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.. "빗맞힘(숙련도)", PLAYERSTAT_RANGED_COMBAT.." 빗맞힘"},
    ["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, "치명타"}, -- COMBAT_RATING_NAME9 = "Crit Rating"
    ["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." 치명타"},
    ["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." 치명타"},
    ["MELEE_CRIT_AVOID_RATING"] = {"치명타 감소(숙련도)", "치명타 감소"},
    ["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 감소(숙련도)", PLAYERSTAT_RANGED_COMBAT.." 치명타 감소"},
    ["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 감소(숙련도)", PLAYERSTAT_SPELL_COMBAT.." 치명타 감소"},
    ["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
    ["MELEE_HASTE_RATING"] = {"가속도", "가속도"},
    ["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도"..RATING, PLAYERSTAT_RANGED_COMBAT.." 가속도"},
    ["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도", PLAYERSTAT_SPELL_COMBAT.." 가속도"},
    ["DAGGER_WEAPON_RATING"] = {"단검류 숙련도", "단검 숙련"}, -- SKILL = "Skill"
    ["SWORD_WEAPON_RATING"] = {"도검류 숙련도", "도검 숙련"},
    ["2H_SWORD_WEAPON_RATING"] = {"양손 도검류 숙련도", "양손 도검 숙련"},
    ["AXE_WEAPON_RATING"] = {"도끼류 숙련도", "도끼 숙련"},
    ["2H_AXE_WEAPON_RATING"] = {"양손 도끼류 숙련도", "양손 도끼 숙련"},
    ["MACE_WEAPON_RATING"] = {"둔기류 숙련도", "둔기 숙련"},
    ["2H_MACE_WEAPON_RATING"] = {"양손 둔기류 숙련도", "양손 둔기 숙련"},
    ["GUN_WEAPON_RATING"] = {"총기류 숙련도", "총기 숙련"},
    ["CROSSBOW_WEAPON_RATING"] = {"석궁류 숙련도", "석궁 숙련"},
    ["BOW_WEAPON_RATING"] = {"활류 숙련도", "활 숙련"},
    ["FERAL_WEAPON_RATING"] = {"야성 "..SKILL.." "..RATING, "야성 "..RATING},
    ["FIST_WEAPON_RATING"] = {"맨손 전투 숙련도", "맨손 숙련"},
    ["STAFF_WEAPON_RATING"] = {"지팡이류 숙련도", "지팡이 숙련"}, -- Leggings of the Fang ID:10410
    --["EXPERTISE_RATING"] = {STAT_EXPERTISE.." "..RATING, STAT_EXPERTISE.." "..RATING},
    ["EXPERTISE_RATING"] = {"숙련".." "..RATING, "숙련".." "..RATING},
    ["ARMOR_PENETRATION_RATING"] = {"방어구 관통력", "방어구 관통력"},
    ["MASTERY_RATING"] = {"특화도"..RATING, "특화"..RATING},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {HEALTH.." 회복 (비전투)", "HP5(OC)"},
    ["MANA_REGEN"] = {MANA.." 회복 (비시전)", "MP5(OC)"},
    ["MELEE_CRIT_DMG_REDUCTION"] = {"치명타 피해 감소(%)", "치명 피해감소(%)"},
    ["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_RANGED_COMBAT.." 치명 피해감소(%)"},
    ["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_SPELL_COMBAT.." 치명 피해감소(%)"},
    ["DEFENSE"] = {DEFENSE, "방숙"},
    ["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
    ["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
    ["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
    ["AVOIDANCE"] = {"방어행동(%)", "방어행동(%)"},
    ["MELEE_HIT"] = {"적중(%)", "적중(%)"},
    ["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." 적중(%)", PLAYERSTAT_RANGED_COMBAT.." 적중(%)"},
    ["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." 적중(%)", PLAYERSTAT_SPELL_COMBAT.." 적중(%)"},
    ["MELEE_HIT_AVOID"] = {"빗맞힘(%)", "빗맞힘(%)"},
    ["RANGED_HIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." 빗맞힘(%)", PLAYERSTAT_RANGED_COMBAT.." 빗맞힘(%)"},
    ["SPELL_HIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." 빗맞힘(%)", PLAYERSTAT_SPELL_COMBAT.." 빗맞힘(%)"},
    ["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "치명타(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
    ["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." 치명타(%)"},
    ["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_CRIT_CHANCE.."(%)", "극대화(%)"},
    ["MELEE_CRIT_AVOID"] = {"치명타 감소(%)", "치명타 감소(%)"},
    ["RANGED_CRIT_AVOID"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 감소(%)", PLAYERSTAT_RANGED_COMBAT.." 치명타 감소(%)"},
    ["SPELL_CRIT_AVOID"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 감소(%)", PLAYERSTAT_SPELL_COMBAT.." 치명타 감소(%)"},
    ["MELEE_HASTE"] = {"가속도(%)", "가속도(%)"},
    ["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도(%)", PLAYERSTAT_RANGED_COMBAT.." 가속도(%)"},
    ["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도(%)", PLAYERSTAT_SPELL_COMBAT.." 가속도(%)"},
    ["DAGGER_WEAPON"] = {"단검류 숙련", "단검 숙련"}, -- SKILL = "Skill"
    ["SWORD_WEAPON"] = {"도검류 숙련", "도검 숙련"},
    ["2H_SWORD_WEAPON"] = {"양손 도검류 숙련", "양손 도검 숙련"},
    ["AXE_WEAPON"] = {"도끼류 숙련", "도끼 숙련"},
    ["2H_AXE_WEAPON"] = {"양손 도끼류 숙련", "양손 도끼 숙련"},
    ["MACE_WEAPON"] = {"둔기류 숙련", "둔기 숙련"},
    ["2H_MACE_WEAPON"] = {"양손 둔기류 숙련", "양손 둔기 숙련"},
    ["GUN_WEAPON"] = {"총기류 숙련", "총기 숙련"},
    ["CROSSBOW_WEAPON"] = {"석궁류 숙련", "석궁 숙련"},
    ["BOW_WEAPON"] = {"활류 숙련", "활 숙련"},
    ["FERAL_WEAPON"] = {"야성 "..SKILL, "야성"},
    ["FIST_WEAPON"] = {"맨손 전투 숙련", "맨손 숙련"},
    ["STAFF_WEAPON"] = {"지팡이류 숙련", "지팡이 숙련"}, -- Leggings of the Fang ID:10410
    --["EXPERTISE"] = {STAT_EXPERTISE, STAT_EXPERTISE},
    ["EXPERTISE"] = {"숙련 ", "숙련"},
    ["ARMOR_PENETRATION"] = {"방어구 관통(%)", "방어구 관통(%)"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    -- Expertise -> Dodge Neglect, Parry Neglect
    ["DODGE_NEGLECT"] = {"회피 무시(%)", "회피 무시(%)"},
    ["PARRY_NEGLECT"] = {"무기 막기 무시(%)", "무막 무시(%)"},
    ["BLOCK_NEGLECT"] = {"방패 막기 무시(%)", "방막 무시(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"치명타 피해(%)", "치명타 피해(%)"},
    ["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 피해(%)", PLAYERSTAT_RANGED_COMBAT.." 치명타 피해(%)"},
    ["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 피해(%)", PLAYERSTAT_SPELL_COMBAT.." 치명타 피해(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
    -- Use strsplit("@", text) to seperate the spell name and statid
    ["THREAT"] = {"위협 수준", "위협"},
    ["CAST_TIME"] = {"시전 시간", "시전"},
    ["MANA_COST"] = {"마나 소비량", "마나"},
    ["RAGE_COST"] = {"분노 소비량", "분노"},
    ["ENERGY_COST"] = {"기력 소비량", "기력"},
    ["COOLDOWN"] = {"재사용 대기시간", "쿨타임"},

    ---------------------------------------------------------------------------
    -- Stats Mods
    ["MOD_STR"] = {"효과: "..SPELL_STAT1_NAME.."(%)", "효과: "..SPELL_STAT1_NAME.."(%)"},
    ["MOD_AGI"] = {"효과: "..SPELL_STAT2_NAME.."(%)", "효과: ".."민첩(%)"},
    ["MOD_STA"] = {"효과: "..SPELL_STAT3_NAME.."(%)", "효과: "..SPELL_STAT3_NAME.."(%)"},
    ["MOD_INT"] = {"효과: "..SPELL_STAT4_NAME.."(%)", "효과: "..SPELL_STAT4_NAME.."(%)"},
    ["MOD_SPI"] = {"효과: "..SPELL_STAT5_NAME.."(%)", "효과: "..SPELL_STAT5_NAME.."(%)"},
    ["MOD_HEALTH"] = {"효과: "..HEALTH.."(%)", "효과: HP(%)"},
    ["MOD_MANA"] = {"효과: "..MANA.."(%)", "효과: MP(%)"},
    ["MOD_ARMOR"] = {"효과: 아이템에 의한 "..ARMOR.."(%)", "효과: "..ARMOR.."(아이템)(%)"},
    ["MOD_BLOCK_VALUE"] = {"효과: 피해 방어량(%)", "효과: 방어량(%)"},
    ["MOD_DMG"] = {"효과: 공격력(%)", "효과: 공격력(%)"},
    ["MOD_DMG_TAKEN"] = {"효과: 피해량(%)", "효과: 피해량(%)"},
    ["MOD_CRIT_DAMAGE"] = {"효과: 치명타 공격력(%)", "효과: 치명타 공격력(%)"},
    ["MOD_CRIT_DAMAGE_TAKEN"] = {"효과: 치명타 피해량(%)", "효과: 치명타 피해량(%)"},
    ["MOD_THREAT"] = {"효과: 위협 수준(%)", "효과: 위협(%)"},
    ["MOD_AP"] = {"효과: ".."전투력(%)", "효과: 전투력(%)"},
    ["MOD_RANGED_AP"] = {"효과: "..PLAYERSTAT_RANGED_COMBAT.." 전투력(%)", "효과: "..PLAYERSTAT_RANGED_COMBAT.." 전투력(%)"},
    ["MOD_SPELL_DMG"] = {"효과: "..PLAYERSTAT_SPELL_COMBAT.." 공격력(%)", "효과: "..PLAYERSTAT_SPELL_COMBAT.." 공격력(%)"},
    ["MOD_HEAL"] = {"효과: 치유량(%)", "효과: 치유량(%)"},
    ["MOD_CAST_TIME"] = {"효과: 시전 시간(%)", "효과: 시전(%)"},
    ["MOD_MANA_COST"] = {"효과: 마나 소비량(%)", "효과: 마나(%)"},
    ["MOD_RAGE_COST"] = {"효과: 분노 소비량(%)", "효과: 분노(%)"},
    ["MOD_ENERGY_COST"] = {"효과: 기력 소비량(%)", "효과: 기력(%)"},
    ["MOD_COOLDOWN"] = {"효과: 재사용 대기시간(%)", "효과: 쿨타임(%)"},
    ["CRIT_TAKEN"] = {"치명타 적중률(%)", "치타"},
    ["HIT_TAKEN"] = {"적중률(%)", "적중"},
    ["CRIT_DAMAGE_TAKEN"] = {"받는 치명타 피해(%)", "받는 크리"},
    ["DMG_TAKEN"] = {"피해(%)", "피해"},
    ["CRIT_DAMAGE"] = {"치명타 피해(%)", "치타 피해"},
    ["DMG"] = {DAMAGE, DAMAGE},
    ["BLOCK_REDUCTION"] = {"Increases the amount your block stops by %1d", "Block Value", isPercent = true},

    ---------------------------------------------------------------------------
    -- Misc Stats
    ["WEAPON_RATING"] = {"무기 숙련도", "무기 숙련도"},
    ["WEAPON_SKILL"] = {"무기 숙련", "무기 숙련"},
    ["MAINHAND_WEAPON_RATING"] = {"주 장비 무기 숙련도", "주 장비 무기 숙련도"},
    ["OFFHAND_WEAPON_RATING"] = {"보조 장비 무기 숙련도", "보조 장비 무기 숙련도"},
    ["RANGED_WEAPON_RATING"] = {"원거리 무기 숙련도", "원거리 무기 숙련도"},
  },
} -- }}}

-- zhTW localization by CuteMiyu, Ryuji
PatternLocale.zhTW = { -- {{{
  ["tonumber"] = tonumber,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "鎧甲",
  Mail = "鎖甲",
  Leather = "皮甲",
  Cloth = "布甲",
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
    [ITEM_BIND_TO_ACCOUNT] = true, -- ITEM_BIND_QUEST = "Binds to account";
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
    ["物品等"] = true,
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["初級法力之油"] = {["COMBAT_MANA_REGEN"] = 4}, --
    ["次級法力之油"] = {["COMBAT_MANA_REGEN"] = 8}, --
    ["卓越法力之油"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --
    ["超強法力之油"] = {["COMBAT_MANA_REGEN"] = 14}, --

    ["恆金漁線釣魚"] = {["FISHING"] = 5}, --
    ["兇蠻"] = {["AP"] = 70}, --
    ["活力"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, --
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

    ["狡詐"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    ["威脅值降低2%"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["裝備: 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
    ["使你可以在水下呼吸"] = false, --
    ["裝備: 免疫繳械。"] = false, -- [Stronghold Gauntlets] ID: 12639
    ["免疫繳械"] = false, --
    ["十字軍"] = false, -- Enchant 
    ["生命偷取"] = false, -- Enchant 
    ["颶風"] = false, -- Enchant 
    ["光紋刺繡"] = false, -- Enchant 

    ["巨牙活力"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["智慧精進"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["精確"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["天譴剋星"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["冰行者"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["採集者"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3238
    ["強效活力"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244
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
    ["^(%d+)點護甲$"] = "ARMOR",
    ["使你的精通等級提高(%d+).-%)$"] = "MASTERY_RATING",
    ["%d+秒"] = false, -- Procs
    ["強化護甲 %+(%d+)"] = "ARMOR_BONUS",
    ["^%+?%d+ ?%- ?(%d+).-傷害$"] = "MAX_DAMAGE",
    ["^%(每秒傷害([%d%.]+)%)$"] = "DPS",
    -- Exclude
    ["^(%d+)格.-包"] = false, -- # of slots and bag type
    ["^(%d+)格.-包"] = false, -- # of slots and bag type
    ["^(%d+)格.-袋"] = false, -- # of slots and bag type
    ["^(%d+)格容器"] = false, -- # of slots and bag type
    ["^.+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    --["機率"] = false, --[挑戰印記] ID:27924
    ["有機會"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
    ["有可能"] = false, -- [Darkmoon Card: Heroism] ID:19287
    ["命中時"] = false, -- [黑色摧毀者手套] ID:22194
    ["被擊中之後"] = false, -- [Essence of the Pure Flame] ID: 18815
    ["在你殺死一個敵人"] = false, -- [注入精華的蘑菇] ID:28109
    ["每當你的"] = false, -- [電光相容器] ID: 28785
    ["被擊中時"] = false, --
    ["^使你在獵豹、熊、巨熊和梟獸形態下的攻擊強度提高(%d+)點。$"] = "FERAL_AP", -- 3.0.8 FAP change
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
    "^提高(.-)([%d%.]+)點(.-)$", -- 提高法術能量98點 ID: 40685
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

    ["每5秒恢復生命力"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743
    ["一般的生命力恢復速度"] = {"COMBAT_HEALTH_REGEN",}, -- [Demons Blood] ID: 10779

    ["每5秒法力"] = {"COMBAT_MANA_REGEN",}, --
    ["每5秒恢復法力"] = {"COMBAT_MANA_REGEN",}, -- [Royal Tanzanite] ID: 30603
    ["每五秒恢復法力"] = {"COMBAT_MANA_REGEN",}, -- 長者之XXX
    ["法力恢復"] = {"COMBAT_MANA_REGEN",}, --
    ["使周圍半徑30碼範圍內的隊友每5秒恢復法力"] = {"COMBAT_MANA_REGEN",}, --

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

    ["命中等級"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},
    ["提高命中等級"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"}, -- ITEM_MOD_HIT_RATING
    ["提高近戰命中等級"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
    ["使你的命中等級"] = {"MELEE_HIT_RATING",},
    ["法術命中等級"] = {"SPELL_HIT_RATING",},
    ["提高法術命中等級"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["使你的法術命中等級"] = {"SPELL_HIT_RATING",},
    ["遠程命中等級"] = {"RANGED_HIT_RATING",},
    ["提高遠距命中等級"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    ["使你的遠程命中等級"] = {"RANGED_HIT_RATING",},

    ["致命一擊"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"}, -- ID:31868
    ["致命一擊等級"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["提高致命一擊等級"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["使你的致命一擊等級"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
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

    ["加速等級"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"}, -- Enchant Gloves
    ["攻擊速度"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["攻擊速度等級"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["提高加速等級"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
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
    ["熟練等級"] = {"EXPERTISE_RATING"},
    ["護甲穿透等級"] = {"ARMOR_PENETRATION_RATING"},
    ["你的護甲穿透等級提高"] = {"ARMOR_PENETRATION_RATING"},
    ["精通等級"] = {"MASTERY_RATING",},
    ["使你的精通等級"] = {"MASTERY_RATING",},

    -- Exclude
    ["秒"] = false,
    --["to"] = false,
    ["格容器"] = false,
    ["格箭袋"] = false,
    ["格彈藥袋"] = false,
    ["遠程攻擊速度%"] = false, -- AV quiver
  },
} -- }}}

DisplayLocale.zhTW = { -- {{{
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "總屬性提高%",
  ["Attack Power Multiplier"] = "攻擊強度提高%",
  ["Reduced Physical Damage Taken"] = "物理傷害減少%",
  ["10% Melee/Ranged Attack Speed"] = "10%物理攻速",
  ["5% Spell Haste"] = "5%法術加速",
  ["StatIDToName"] = {
    --[StatID] = {FullName, ShortName},
    ---------------------------------------------------------------------------
    -- Tier1 Stats - Stats parsed directly off items
    ["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
    ["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
    ["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
    ["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";

    ["IGNORE_ARMOR"] = {"無視護甲", "無視護甲"},
    ["MOD_THREAT"] = {"威脅(%)", "威脅(%)"},
    ["STEALTH_LEVEL"] = {"偷竊等級", "偷竊"},
    ["MELEE_DMG"] = {"近戰傷害", "近戰"},
    ["RANGED_DMG"] = {"遠程傷害", "遠程"},
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

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
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
    ["COMBAT_HEALTH_REGEN"] = {"生命恢復", "HP5"},
    ["COMBAT_MANA_REGEN"] = {"法力恢復", "MP5"},

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
    ["ARMOR_PENETRATION_RATING"] = {"護甲穿透等級", "護甲穿透等級"},
    ["MASTERY_RATING"] = {"精通等級", "精通等級"},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {"一般回血", "一般回血"},
    ["MANA_REGEN"] = {"一般回魔", "一般回魔"},
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
    ["ARMOR_PENETRATION"] = {"護甲穿透(%)", "護甲穿透(%)"},
    ["MASTERY"] = {"精通", "精通"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    -- Expertise -> Dodge Neglect, Parry Neglect
    ["DODGE_NEGLECT"] = {"防止被閃躲(%)", "防止被閃躲(%)"},
    ["PARRY_NEGLECT"] = {"防止被招架(%)", "防止被招架(%)"},
    ["BLOCK_NEGLECT"] = {"防止被格擋(%)", "防止被格擋(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"致命一擊(%)", "致命(%)"},
    ["RANGED_CRIT_DMG"] = {"遠程致命一擊(%)", "遠程致命(%)"},
    ["SPELL_CRIT_DMG"] = {"法術致命一擊(%)", "法術致命(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
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
    ["MOD_HEAL"] = {"修正法術治療(%)", "修正治療(%)"},
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
} -- }}}

-- deDE localization by Gailly, Dleh
PatternLocale.deDE = { -- {{{
  ["tonumber"] = function(s)
    local n = tonumber(s)
    if n then
      return n
    else
      return tonumber((gsub(s, ",", "%.")))
    end
  end,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "Platte",
  Mail = "Kette",
  Leather = "Leder",
  Cloth = "Stoff",
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
    ["Einzi"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique
    ["Limit"] = true, -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
    ["Benöt"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
    ["\nBenö"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
    ["Klass"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["Schwaches Manaöl"] = {["COMBAT_MANA_REGEN"] = 4}, --
    ["Geringes Manaöl"] = {["COMBAT_MANA_REGEN"] = 8}, --
    ["Überragendes Manaöl"] = {["COMBAT_MANA_REGEN"] = 14}, --
    ["Hervorragendes Manaöl"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --

    ["Eterniumangelschnur"] = {["FISHING"] = 5}, --
    ["Vitalität"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, --
    ["Seelenfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["Sonnenfeuer"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

    ["Mithrilsporen"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
    ["Schwache Reittierttempo-Strigerung"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
    ["Anlegen: Lauftempo ein wenig erhöht."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
    ["Lauftempo ein wenig erhöht"] = {["RUN_SPEED"] = 8}, --
    ["Schwache Temposteigerung"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
    ["Schwaches Tempo"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
    ["Sicherer Stand"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

    ["Feingefühl"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    ["2% verringerte Bedrohung"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["Anlegen: Ermöglicht Unterwasseratmung."] = false, -- [Band of Icy Depths] ID: 21526
    ["Ermöglicht Unterwasseratmung"] = false, --
    ["Anlegen: Immun gegen Entwaffnen."] = false, -- [Stronghold Gauntlets] ID: 12639
    ["Immun gegen Entwaffnen"] = false, --
    ["Kreuzfahrer"] = false, -- Enchant Crusader
    ["Lebensdiebstahl"] = false, -- Enchant Crusader

    ["Vitalität der Tuskarr"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["Weisheit"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["Präzision"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["Geißelbann"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["Eiswandler"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["Sammler"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3296
    ["Große Vitalität"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244

    ["+37 Ausdauer und +20 Verteidigung"] = {["STA"] = 37, ["DEFENSE_RATING"] = 20}, -- Defense does not equal Defense Rating...
    ["Rune des Schwertbrechens"] = {["PARRY"] = 2}, -- EnchantID: 3594
    ["Rune des Schwertberstens"] = {["PARRY"] = 4}, -- EnchantID: 3365
    ["Rune des Steinhautgargoyles"] = {["MOD_ARMOR"] = 4, ["MOD_STA"] = 2}, -- EnchantID: 3847
    ["Rune der nerubischen Panzerung"] = {["MOD_ARMOR"] = 2, ["MOD_STA"] = 1}, -- EnchantID: 3883
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
  -- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
  ["SingleEquipStatCheck"] = "^Anlegen: (.-) um b?i?s? ?z?u? ?(%d+) ?(.-)%.$",
  -------------
  -- PreScan --
  -------------
  -- Special cases that need to be dealt with before base scan
  ["PreScanPatterns"] = {
    --["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
    --["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
    ["^Erhöht die Angriffskraft um (%d+) nur in Katzen%-, Bären%-, Terrorbären%- und Mondkingestalt%.$"] = "FERAL_AP", -- 3.0.8 FAP change
    ["^(%d+) Rüstung$"] = "ARMOR",
    ["Verstärkte %(%+(%d+) Rüstung%)"] = "ARMOR_BUFF",
    ["Mana Regeneration (%d+) alle 5 Sek%.$"] = "COMBAT_MANA_REGEN",
    ["^%+?%d+ %- (%d+) .-[Ss]chaden$"] = "MAX_DAMAGE",
    ["^%(([%d%.]+) Schaden pro Sekunde%)$"] = "DPS",
    -- Exclude
    ["^(%d+) Platz"] = false, -- Bags
    ["^.+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    --["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
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
    "([^S][^e][^k])%. ",  -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
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
    "^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
  },
  -----------------------
  -- Stat Lookup Table --
  -----------------------
  ["StatIDLookup"] = {
    ["Eure Angriffe ignorierenRüstung eures Gegners"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
    ["% Bedrohung"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
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

    ["Gesundheit wieder her"] = {"COMBAT_HEALTH_REGEN",}, -- Frostwolf Insignia Rank 6 ID:17909
    ["Gesundheitsregeneration"] = {"COMBAT_HEALTH_REGEN",}, -- Demons Blood ID: 10779
    ["stellt alle gesundheit wieder her"] = {"COMBAT_HEALTH_REGEN",}, -- Shard of the Flame ID: 17082


    ["Mana wieder her"] = {"COMBAT_MANA_REGEN",},
    ["Mana alle 5 Sek"] = {"COMBAT_MANA_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["Mana alle 5 Sekunden"] = {"COMBAT_MANA_REGEN",},
    ["alle 5 Sek.Mana"] = {"COMBAT_MANA_REGEN",}, -- [Royal Shadow Draenite] ID: 23109
    ["Mana bei allen Gruppenmitgliedern, die sich im Umkreis von 30 befinden, wieder her"] = {"COMBAT_MANA_REGEN",}, -- Atiesh
    ["Manaregeneration"] = {"COMBAT_MANA_REGEN",},
    ["alle Mana"] = {"COMBAT_MANA_REGEN",},
    ["stellt alle Mana wieder her"] = {"COMBAT_MANA_REGEN",},

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
    ["Zaubermacht"] = {"SPELL_DMG", "HEAL",},
    ["Erhöht die Zaubermacht"] = {"SPELL_DMG", "HEAL",}, -- WotLK
    ["Erhöht Zaubermacht"] = {"SPELL_DMG", "HEAL",}, -- WotLK
    ["Erhöht Zaubermacht um"] = {"SPELL_DMG", "HEAL",},
    ["Erhöht die Zaubermacht um"] = {"SPELL_DMG", "HEAL",},
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
    --                    ["your healing"] = {"HEAL",}, -- Atiesh

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
    ["Erhöht den Blockwet Eures Schildes"] = {"BLOCK_RATING",},

    ["Trefferwertung"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},
    ["Erhöht Trefferwertung"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"}, -- ITEM_MOD_HIT_RATING
    ["Erhöht Eure Trefferwertung"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"}, -- ITEM_MOD_HIT_MELEE_RATING
    ["Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
    ["Erhöht Zaubertrefferwertung"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["Erhöht Eure Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
    ["Distanztrefferwertung"] = {"RANGED_HIT_RATING",},
    ["Erhöht Distanztrefferwertung"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    ["Erhöht Eure Distanztrefferwertung"] = {"RANGED_HIT_RATING",},

    ["kritische Trefferwertung"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Erhöht kritische Trefferwertung"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["Erhöht Eure kritische Trefferwertung"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING"},
    ["kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
    ["Erhöht kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
    ["Erhöht Eure kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
    ["Erhöht die kritische Zaubertrefferwertung aller Gruppenmitglieder innerhalb von 30 Metern"] = {"SPELL_CRIT_RATING",},
    ["Erhöht Eure kritische Distanztrefferwertung"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

    --    ["Improves hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
    --    ["Improves melee hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
    --    ["Improves ranged hit avoidance rating"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
    --    ["Improves spell hit avoidance rating"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
    ["Abhärtung"] = {"RESILIENCE_RATING",},
    ["Abhärtungswertung"] = {"RESILIENCE_RATING",},
    ["Erhöht Eure Abhärtungswertung"] = {"RESILIENCE_RATING",},
    --    ["Improves critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    --    ["Improves melee critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    --    ["Improves ranged critical avoidance rating"] = {"RANGED_CRIT_AVOID_RATING",},
    --    ["Improves spell critical avoidance rating"] = {"SPELL_CRIT_AVOID_RATING",},

    ["Tempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Erhöht Tempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"}, -- [Pfeilabwehrender Brustschutz] ID:33328
    ["Erhöht Eure Tempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Angriffstempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Erhöht Angriffstempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Erhöht Eure Angriffstempowertung"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
    ["Erhöht Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
    ["Erhöht Eure Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
    ["Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
    ["Erhöht Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
    ["Erhöht Eure Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},

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

    ["Waffenkundewertung"] = {"EXPERTISE_RATING"},
    ["Erhöht die Waffenkundewertung"] = {"EXPERTISE_RATING"},
    ["Erhöht Eure Waffenkundewertung um"] = {"EXPERTISE_RATING"},

    ["Rüstungsdurchschlagwertung"] = {"ARMOR_PENETRATION_RATING"},
    ["Erhöht den Rüstungsdurchschlagwert um"] = {"ARMOR_PENETRATION_RATING"},
    ["Erhöht die Rüstungsdurchschlagwertung um"] = {"ARMOR_PENETRATION_RATING"},
    ["Erhöht Eure Rüstungsdurchschlagwertung um"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178

    ["Meisterschaftswertung"] = {"MASTERY_RATING"}, -- gems
    ["Erhöht Meisterschaftswertung"] = {"MASTERY_RATING"},
    ["Erhöht Eure Meisterschaftswertung"] = {"MASTERY_RATING"},

    -- Exclude
    ["Sek"] = false,
    ["bis"] = false,
    ["Platz Tasche"] = false,
    ["Platz Köcher"] = false,
    ["Platz Munitionsbeutel"] = false,
    ["Erhöht das Distanzangriffstempo"] = false, -- AV quiver
  },
} -- }}}

DisplayLocale.deDE = { -- {{{
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.

  ["Stat Multiplier"] = "Wertemultiplikatoren",
  ["Attack Power Multiplier"] = "Angriffskraft-Multiplikatoren",
  ["Reduced Physical Damage Taken"] = "Reduzierter erlittener physischer Schaden",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
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
    ["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg"}, -- DAMAGE = "Damage"
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

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
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
    ["COMBAT_HEALTH_REGEN"] = {HEALTH.." Regeneration", "HP5"},
    ["COMBAT_MANA_REGEN"] = {MANA.." Regeneration", "MP5"},

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
    ["MELEE_HASTE_RATING"] = {"Tempowertung", "Tempowertung"}, --
    ["RANGED_HASTE_RATING"] = {"Distanztempowertung", "Distanztempowertung"},
    ["SPELL_HASTE_RATING"] = {"Zaubertempowertung", "Zaubertempowertung"},
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
    ["ARMOR_PENETRATION_RATING"] = {"Rüstungsdurchschlagwertung", "ArP".." "..RATING},
    ["MASTERY_RATING"] = {"Meisterschaftswertung", "Meisterschaftswertung"},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {HEALTH.." Regeneration (Nicht im Kampf)", "HP5(OC)"},
    ["MANA_REGEN"] = {MANA.." Regeneration (Nicht im Kampf)", "MP5(OC)"},
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
    ["MELEE_HASTE"] = {"Tempo(%)", "Tempo(%)"}, --
    ["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Tempo(%)", PLAYERSTAT_RANGED_COMBAT.." Tempo(%)"},
    ["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Tempo(%)", PLAYERSTAT_SPELL_COMBAT.." Tempo(%)"},
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
    ["ARMOR_PENETRATION"] = {"Rüstungsdurchschlag(%)", "ArP(%)"},
    ["MASTERY"] = {"Meisterschaft", "Meisterschaft"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    ["DODGE_NEGLECT"] = {DODGE.." Verhinderung(%)", DODGE.." Verhinderung(%)"},
    ["PARRY_NEGLECT"] = {PARRY.." Verhinderung(%)", PARRY.." Verhinderung(%)"},
    ["BLOCK_NEGLECT"] = {BLOCK.." Verhinderung(%)", BLOCK.." Verhinderung(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"Krit Schaden(%)", "Crit Schaden(%)"},
    ["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)", PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)"},
    ["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)", PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
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
    ["MOD_HEAL"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
    ["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
    ["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
    ["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
    ["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
    ["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},
    ["CRIT_TAKEN"] = {"Chance kritisch getroffen zu werden", "Krit. Treffer bekommen", isPercent = true},
    ["HIT_TAKEN"] = {"Chance getroffen zu werden", "Treffer bekommen", isPercent = true},
    ["CRIT_DAMAGE_TAKEN"] = {"Kritischer Schaden genommen", "Krit. Schaden genommen", isPercent = true},
    ["DMG_TAKEN"] = {"Schaden genommen", "Schaden genommen", isPercent = true},
    ["CRIT_DAMAGE"] = {"Kritischer Schaden", "Krit. Schaden", isPercent = true},
    ["DMG"] = {DAMAGE, DAMAGE},
    ["BLOCK_REDUCTION"] = {"Erhöht die Menge, die Euer Blocken stoppt, um %1d", "Blockwertung", isPercent = true},

    ---------------------------------------------------------------------------
    -- Misc Stats
    ["WEAPON_RATING"] = {"Waffe "..SKILL.." "..RATING, "Waffe"..SKILL.." "..RATING},
    ["WEAPON_SKILL"] = {"Waffe "..SKILL, "Waffe"..SKILL},
    ["MAINHAND_WEAPON_RATING"] = {"Waffenhandwaffe "..SKILL.." "..RATING, "Waffenhand"..SKILL.." "..RATING},
    ["OFFHAND_WEAPON_RATING"] = {"Schildhandwaffe "..SKILL.." "..RATING, "Schildhand"..SKILL.." "..RATING},
    ["RANGED_WEAPON_RATING"] = {"Fernkampfwaffe "..SKILL.." "..RATING, "Fernkampf"..SKILL.." "..RATING},
  },
} -- }}}

-- frFR localization by Tixu
PatternLocale.frFR = { -- {{{
  ["tonumber"] = function(s)
    local n = tonumber(s)
    if n then
      return n
    else
      return tonumber((gsub(s, ",", "%.")))
    end
  end,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "Plaques",
  Mail = "Mailles",
  Leather = "Cuir",
  Cloth = "Tissu",
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["Huile de mana mineure"] = {["COMBAT_MANA_REGEN"] = 4}, --
    ["Huile de mana inférieure"] = {["COMBAT_MANA_REGEN"] = 8}, --
    ["Huile de mana brillante"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --
    ["Huile de mana excellente"] = {["COMBAT_MANA_REGEN"] = 14}, --

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
    ["Vitalité"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
    ["Âme de givre"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["Sauvagerie"] = {["AP"] = 70}, --
    ["Vitesse mineure"] = {["RUN_SPEED"] = 8},
    ["Vitesse mineure et +9 en Endurance"] = {["RUN_SPEED"] = 8, ["STA"] = 9},--enchant

    ["Croisé"] = false, -- Enchant Crusader
    ["Mangouste"] = false, -- Enchant Mangouste
    ["Arme impie"] = false,
    ["Équipé : Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, --cape Onyxia

    ["Vitalité rohart"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["Sagesse"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["Précision"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["Plaie-du-Fléau"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["Marcheglace"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["Récolteur"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3296
    ["Vitalité supérieure"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244

  },
  ----------------------------
  -- Single Plus Stat Check --
  ----------------------------
  ["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
  -----------------------------
  -- Single Equip Stat Check --
  -----------------------------
  ["SingleEquipStatCheck"] = "^Équipé\194\160: Augmente (.-) ?de (%d+) ?a?u? ?m?a?x?i?m?u?m? ?(.-)%.?.-$",

  -------------
  -- PreScan --
  -------------
  -- Special cases that need to be dealt with before deep scan
  ["PreScanPatterns"] = {
    ["^Augmente la puissance d'attaque de (%d+) seulement en forme de félin, ours, ours redoutable ou sélénien%.$"] = "FERAL_AP", -- 3.0.8 FAP change
    ["Armure.- (%d+)"] = "ARMOR",
    ["^Équipé\194\160: Rend (%d+) points de vie toutes les 5 seco?n?d?e?s?%.?$"]= "COMBAT_HEALTH_REGEN",
    ["^Équipé\194\160: Rend (%d+) points de mana toutes les 5 seco?n?d?e?s?%.?$"]= "COMBAT_MANA_REGEN",
    ["Renforcé %(%+(%d+) Armure%)"]= "ARMOR_BONUS",
    ["Lunette %(%+(%d+) points? de dégâts?%)"]="RANGED_AP",
    ["^%(([%d%,]+) dégâts par seconde%)$"] = "DPS",

    -- Exclude
    ["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    --["Confère une chance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
    ["Rend parfois"] = false, -- [Darkmoon Card: Heroism] ID:19287
    ["Vous gagnez une"] = false, -- condensateur de foudre
    ["Dégâts ?:"] = false, -- ligne de degats des armes
    ["Dégâts\194\160:"] = false, -- ligne de degats des armes
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
    "^(.-) augmentée?s? de (%d+) ?(.-)%%?%.?$",--sometimes this pattern is needed but not often
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
    ["à l'agilité"] = {"AGI",}, -- Shifting Shadow Crystal [39935]
    ["endurance"] = {"STA",},
    ["en endurance"] = {"STA",},
    ["à l'endurance"] = {"STA",}, -- Shifting Shadow Crystal [39935]
    ["intelligence"] = {"INT",},
    ["esprit"] = {"SPI",},
    ["à l'esprit"] = {"SPI",}, -- Purified Shadowsong Amethyst [37503]


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
    ["points de mana toutes les 5 secondes"] = {"COMBAT_MANA_REGEN",},
    ["point de mana toutes les 5 secondes"] = {"COMBAT_MANA_REGEN",},
    ["points de vie toutes les 5 secondes"] = {"COMBAT_HEALTH_REGEN",},
    ["point de vie toutes les 5 secondes"] = {"COMBAT_HEALTH_REGEN",},
    ["points de mana toutes les 5 sec"] = {"COMBAT_MANA_REGEN",},
    ["points de vie toutes les 5 sec"] = {"COMBAT_HEALTH_REGEN",},
    ["point de mana toutes les 5 sec"] = {"COMBAT_MANA_REGEN",},
    ["point de vie toutes les 5 sec"] = {"COMBAT_HEALTH_REGEN",},
    ["mana toutes les 5 secondes"] = {"COMBAT_MANA_REGEN",},
    ["régén. de mana"] = {"COMBAT_MANA_REGEN",},


    --pénétration des sorts
    ["la pénétration de vos sorts"] = {"SPELLPEN",},
    ["à la pénétration des sorts"] = {"SPELLPEN",},
    --Puissance soins et sorts
    ["à la puissance des sorts"] = {"SPELL_DMG", "HEAL"},
    ["la puissance des sorts"] = {"SPELL_DMG", "HEAL"},
    ["les soins prodigués par les sorts et effets"] = {"HEAL",},
    ["augmente la puissance des sorts de"] = {"SPELL_DMG", "HEAL"},
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

    ["score de toucher"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["le score de toucher"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["votre score de toucher"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["au score de toucher"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    
    --mastery
    ["score de maîtrise"] = {"MASTERY_RATING",}, -- gems
    ["votre score de maîtrise"] = {"MASTERY_RATING",},
    ["au score de maîtrise"] = {"MASTERY_RATING",},
    ["le score de maîtrise"] = {"MASTERY_RATING",},

    ["score de coup critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["score de critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["le score de coup critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["votre score de coup critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["au score de coup critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["au score de critique"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},

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

    ["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348
    ["au score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Enchant given by Heartseeker Scope [41167]

    ["score de hâte"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["le score de hâte"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["au score de hâte"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["votre score de hâte"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
    ["le score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
    ["score de hâte à distance"] = {"RANGED_HASTE_RATING"},
    ["le score de hâte à distance"] = {"RANGED_HASTE_RATING"},

    ["le score de pénétration d'armure"] = {"ARMOR_PENETRATION_RATING"},
    ["votre score de pénétration d'armure"] = {"ARMOR_PENETRATION_RATING"},

    ["votre score d'expertise"] = {"EXPERTISE_RATING"},
    ["le score d'expertise"] = {"EXPERTISE_RATING"},

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
  },
} -- }}}

DisplayLocale.frFR = { -- {{{
  --ToDo
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "Stat Multiplier",
  ["Attack Power Multiplier"] = "Attack Power Multiplier",
  ["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
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
    ["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg"}, -- DAMAGE = "Damage"
    ["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
    ["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

    ["STR"] = {SPELL_STAT1_NAME, "For"},
    ["AGI"] = {SPELL_STAT2_NAME, "Agi"},
    ["STA"] = {SPELL_STAT3_NAME, "End"},
    ["INT"] = {SPELL_STAT4_NAME, "Int"},
    ["SPI"] = {SPELL_STAT5_NAME, "Esp"},
    ["ARMOR"] = {ARMOR, ARMOR},
    ["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

    ["FIRE_RES"] = {RESISTANCE2_NAME, "RF"},
    ["NATURE_RES"] = {RESISTANCE3_NAME, "RN"},
    ["FROST_RES"] = {RESISTANCE4_NAME, "RG"},
    ["SHADOW_RES"] = {RESISTANCE5_NAME, "RO"},
    ["ARCANE_RES"] = {RESISTANCE6_NAME, "RA"},

    ["FISHING"] = {"Pêche", "Pêche"},
    ["MINING"] = {"Minage", "Minage"},
    ["HERBALISM"] = {"Herboristerie", "Herboristerie"},
    ["SKINNING"] = {"Dépeçage", "Dépeçage"},

    ["BLOCK_VALUE"] = {"Valeur de blocage", "Valeur de blocage"},

    ["AP"] = {ATTACK_POWER_TOOLTIP, "PA"},
    ["RANGED_AP"] = {RANGED_ATTACK_POWER, "PAD"},
    ["FERAL_AP"] = {ATTACK_POWER_TOOLTIP.." combat farouche", "PA C. Farouche"},
    ["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (mort-vivant)", "PA(démon)"},
    ["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (démon)", "PA(démon)"},

    ["HEAL"] = {"Soins", "Soin"},

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
    ["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
    ["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (mort-vivant)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(démon)"},
    ["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (démon)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(démon)"},
    ["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
    ["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
    ["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
    ["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
    ["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
    ["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

    ["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

    ["HEALTH"] = {HEALTH, HP},
    ["MANA"] = {MANA, MP},
    ["COMBAT_HEALTH_REGEN"] = {"Regen "..HEALTH, "HP5"},
    ["COMBAT_MANA_REGEN"] = {"Regen "..MANA, "MP5"},

    ["MAX_DAMAGE"] = {"Dégât max", "Dmg max"},
    ["DPS"] = {"Dégâts par seconde", "DPS"},

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
    ["RANGED_CRIT_RATING"] = {COMBAT_RATING_NAME9.." "..PLAYERSTAT_RANGED_COMBAT, COMBAT_RATING_NAME9.." "..PLAYERSTAT_RANGED_COMBAT},
    ["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
    ["MELEE_CRIT_AVOID_RATING"] = {"Crit Avoidance "..RATING, "Crit Avoidance "..RATING},
    ["RANGED_CRIT_AVOID_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_RANGED_COMBAT.." Crit Avoidance "..RATING},
    ["SPELL_CRIT_AVOID_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING, PLAYERSTAT_SPELL_COMBAT.." Crit Avoidance "..RATING},
    ["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
    ["MELEE_HASTE_RATING"] = {"Hâte "..RATING, "Hâte "..RATING}, --
    ["RANGED_HASTE_RATING"] = {"Hâte "..PLAYERSTAT_RANGED_COMBAT..RATING, "Hâte "..PLAYERSTAT_RANGED_COMBAT..RATING},
    ["SPELL_HASTE_RATING"] = {"Hâte "..PLAYERSTAT_SPELL_COMBAT..RATING, "Hâte "..PLAYERSTAT_SPELL_COMBAT..RATING},
    ["DAGGER_WEAPON_RATING"] = {"Dague "..SKILL.." "..RATING, "Dague "..RATING}, -- SKILL = "Skill"
    ["SWORD_WEAPON_RATING"] = {"Epée "..SKILL.." "..RATING, "Epée "..RATING},
    ["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
    ["AXE_WEAPON_RATING"] = {"Hache "..SKILL.." "..RATING, "Hache "..RATING},
    ["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
    ["MACE_WEAPON_RATING"] = {"Masse "..SKILL.." "..RATING, "Masse "..RATING},
    ["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
    ["GUN_WEAPON_RATING"] = {"Arme à feu "..SKILL.." "..RATING, "Arme à feu "..RATING},
    ["CROSSBOW_WEAPON_RATING"] = {"Arbalète "..SKILL.." "..RATING, "Arbalète "..RATING},
    ["BOW_WEAPON_RATING"] = {"Arc "..SKILL.." "..RATING, "Arc "..RATING},
    ["FERAL_WEAPON_RATING"] = {"Farouche "..SKILL.." "..RATING, "Farouche "..RATING},
    ["FIST_WEAPON_RATING"] = {"Main nue "..SKILL.." "..RATING, "Main nue "..RATING},
    ["EXPERTISE_RATING"] = {"Expertise".." "..RATING, "Expertise".." "..RATING},
    ["ARMOR_PENETRATION_RATING"] = {"Pénétration d'armure".." "..RATING, "ArP".." "..RATING},
    ["MASTERY_RATING"] = {RATING .. " de maîtrise", RATING .. " de maîtrise"},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {"Regen vie (hors combat)", "HP5(HC)"},
    ["MANA_REGEN"] = {"Regen mana (hors cast)", "MP5(HC)"},
    ["MELEE_CRIT_DMG_REDUCTION"] = {"Réduction des dégâts critiques(%)", "Réduc dmg crit(%)"},
    ["RANGED_CRIT_DMG_REDUCTION"] = {"Réduction des dégâts à distance critiques(%)", "Réduc dmg crit disc(%)"},
    ["SPELL_CRIT_DMG_REDUCTION"] = {"Réduction des dégâts des sorts critiques(%)", "Réduc dmg crit sorts(%)"},
    ["DEFENSE"] = {DEFENSE, "Def"},
    ["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
    ["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
    ["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
    ["MELEE_HIT"] = {"Toucher(%)", "Toucher(%)"},
    ["RANGED_HIT"] = {"Toucher à distance(%)", "Toucher à distance (%)"},
    ["SPELL_HIT"] = {"Toucher des sorts(%)", "Toucher des sorts (%)"},
    ["MELEE_HIT_AVOID"] = {"Evitement(%)", "Evt(%)"},
    ["RANGED_HIT_AVOID"] = {"Evitement à distance(%)", "Evt dist(%)"},
    ["SPELL_HIT_AVOID"] = {"Evitement des sorts(%)", "Evt sorts(%)"},
    ["MELEE_CRIT"] = {"Critique(%)", "Crit(%)"},
    ["RANGED_CRIT"] = {"Critique à distance(%)", "Crit dist(%)"},
    ["SPELL_CRIT"] = {"Critique des sorts(%)", "Crit sorts(%)"},
    ["MELEE_CRIT_AVOID"] = {"Evitement des critiques(%)", "Evt crit(%)"},
    ["RANGED_CRIT_AVOID"] = {"Evitement des critiques à distance(%)", "Evt crit dist(%)"},
    ["SPELL_CRIT_AVOID"] = {"Evitement des critiques des sorts(%)", "Evt crit sorts(%)"},
    ["MELEE_HASTE"] = {"Hâte(%)", "Hâte(%)"},
    ["RANGED_HASTE"] = {"Hâte à distance(%)", "Hâte dist(%)"},
    ["SPELL_HASTE"] = {"Hâte des sorts(%)", "Hâte sorts(%)"},
    ["DAGGER_WEAPON"] = {"Compétence de dague", "Dague"},
    ["SWORD_WEAPON"] = {"Compétence de d'épée", "Epée"},
    ["2H_SWORD_WEAPON"] = {"Compétence d'épée à deux mains", "Epée 2M"},
    ["AXE_WEAPON"] = {"Compétence de hache", "Hache"},
    ["2H_AXE_WEAPON"] = {"Compétence de hache à deux mains", "Hache 2M"},
    ["MACE_WEAPON"] = {"Compétence de masse", "Masse"},
    ["2H_MACE_WEAPON"] = {"Compétence de masse à deux mains", "Masse 2M"},
    ["GUN_WEAPON"] = {"Compétence d'arme à feu", "Arme à feu"},
    ["CROSSBOW_WEAPON"] = {"Compétence d'arbalète", "Arbalète"},
    ["BOW_WEAPON"] = {"Compétence d'arc", "Arc"},
    ["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
    ["FIST_WEAPON"] = {"Main nue "..SKILL, "Main nue"},
    ["EXPERTISE"] = {"Expertise", "Expertise"},
    ["ARMOR_PENETRATION"] = {"Pénétration d'armure(%)", "PenAr(%)"},
    ["MASTERY"] = {"Maîtrise", "Maîtrise"},
    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    ["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
    ["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
    ["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
    ["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
    ["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
    -- Use strsplit("@", text) to seperate the spell name and statid
    ["THREAT"] = {"Menace", "Menace"},
    ["CAST_TIME"] = {"Temps d'incantation", "Tps incant"},
    ["MANA_COST"] = {"Coût en mana", "Coût mana"},
    ["RAGE_COST"] = {"Coût en rage", "Coût rage"},
    ["ENERGY_COST"] = {"Coût en énergie", "Coût énergie"},
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
    ["MOD_HEAL"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
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
} -- }}}

-- zhCN localization by iceburn
PatternLocale.zhCN = { -- {{{
  ["tonumber"] = tonumber,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "板甲",
  Mail = "锁甲",
  Leather = "皮甲",
  Cloth = "布甲",
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["超强法力之油"] = {["COMBAT_MANA_REGEN"] = 14}, --
    ["初级法力之油"] = {["COMBAT_MANA_REGEN"] = 4}, --
    ["次级法力之油"] = {["COMBAT_MANA_REGEN"] = 8}, --
    ["卓越法力之油"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --
    ["超强巫师之油"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --

    ["恒金渔线"] = {["FISHING"] = 5}, --
    ["活力"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, --
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

    ["狡诈"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    ["威胁减少2%"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["装备： 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
    ["使你可以在水下呼吸"] = false, --
    ["装备： 免疫缴械。"] = false, -- [Stronghold Gauntlets] ID: 12639
    ["免疫缴械"] = false, --
    ["十字军"] = false, -- Enchant Crusader
    ["生命偷取"] = false, -- Enchant Crusader


    ["海象人的活力"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["智慧"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["精确"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["天灾斩除"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["履冰"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["采集"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3238
    ["强效活力"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244
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
    ["^(%d+)点护甲$"] = "ARMOR",
    ["强化护甲 %+(%d+)"] = "ARMOR_BONUS",
    ["护甲值提高(%d+)点"] = "ARMOR_BONUS",
    ["每5秒恢复(%d+)点法力值。$"] = "COMBAT_MANA_REGEN",
    ["每5秒恢复(%d+)点生命值。$"] = "COMBAT_HEALTH_REGEN",
    ["每5秒回复(%d+)点法力值。$"] = "COMBAT_MANA_REGEN",
    ["每5秒回复(%d+)点法力值$"] = "COMBAT_MANA_REGEN",
    ["每5秒回复(%d+)点生命值。$"] = "COMBAT_HEALTH_REGEN",
    ["^%+?%d+ %- (%d+).-伤害$"] = "MAX_DAMAGE",
    ["^（每秒伤害([%d%.]+)）$"] = "DPS",
    -- Exclude
    ["^(%d+)格.-包"] = false, -- # of slots and bag type
    ["^(%d+)格.-袋"] = false, -- # of slots and bag type
    ["^(%d+)格容器"] = false, -- # of slots and bag type
    ["^.+（(%d+)/%d+）$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    --["几率"] = false, --[挑战印记] ID:27924
    --["机率"] = false,
    --["有一定几率"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 --+12智力, 施法时有一定几率回复法力 gem ID:2835
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
  ["DualStatPatterns"] = { -- all lower case
    ["^%+(%d+)治疗和%+(%d+)法术伤害$"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["^%+(%d+)治疗和%+(%d+)法术伤害及"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["^使法术治疗提高最多(%d+)点，法术伤害提高最多(%d+)点$"] = {{"HEAL",}, {"SPELL_DMG",},},
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
    ["% 威胁"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
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

    ["每5秒恢复(%d+)点生命值"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743
    ["每5秒回复(%d+)点生命值"] = {"COMBAT_HEALTH_REGEN",},
    ["生命值恢复速度"] = {"COMBAT_HEALTH_REGEN",}, -- [Demons Blood] ID: 10779

    ["每5秒法力"] = {"COMBAT_MANA_REGEN",}, --
    ["每5秒恢复法力"] = {"COMBAT_MANA_REGEN",}, -- [Royal Tanzanite] ID: 30603
    ["每5秒恢复(%d+)点法力值"] = {"COMBAT_MANA_REGEN",},
    ["每5秒回复(%d+)点法力值"] = {"COMBAT_MANA_REGEN",},
    ["每5秒法力回复"] = {"COMBAT_MANA_REGEN",},
    ["法力恢复"] = {"COMBAT_MANA_REGEN",},
    ["法力回复"] = {"COMBAT_MANA_REGEN",},
    ["使周围半径30码范围内的所有小队成员每5秒恢复(%d+)点法力值"] = {"COMBAT_MANA_REGEN",}, --

    ["法术穿透"] = {"SPELLPEN",},
    ["法术穿透力"] = {"SPELLPEN",},
    ["使你的法术穿透提高"] = {"SPELLPEN",},

    ["法术伤害和治疗"] = {"SPELL_DMG", "HEAL",},
    ["法术强度"] = {"SPELL_DMG", "HEAL",},
    ["法术治疗和伤害"] = {"SPELL_DMG", "HEAL",},
    ["治疗和法术伤害"] = {"SPELL_DMG", "HEAL",},
    ["法术伤害"] = {"SPELL_DMG",},
    ["提高法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"},
    ["使周围半径30码范围内的所有小队成员的法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"}, -- Atiesh, ID: 22630
    ["提高所有法术和魔法效果所造成的伤害和治疗效果"] = {"SPELL_DMG", "HEAL"},        --StatLogic:GetSum("22630")
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
    ["法术强度"] = {"SPELL_DMG", "HEAL",},
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

    ["命中等级"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["提高命中等级"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
    ["使你的命中等级"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["提高近战命中等级"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING

    ["法术命中等级"] = {"SPELL_HIT_RATING",},
    ["提高法术命中等级"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["使你的法术命中等级"] = {"SPELL_HIT_RATING",},

    ["远程命中等级"] = {"RANGED_HIT_RATING",},
    ["提高远程命中等级"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    ["使你的远程命中等级"] = {"RANGED_HIT_RATING",},

    ["爆击等级"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["提高爆击等级"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["使你的爆击等级"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},

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

    ["急速等级"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"}, -- Enchant Gloves
    ["攻击速度"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["提高急速等级"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["法术急速等级"] = {"SPELL_HASTE_RATING"},
    ["远程急速等级"] = {"RANGED_HASTE_RATING"},
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
    ["精准等级"] = {"EXPERTISE_RATING",},
    ["提高精准等级"] = {"EXPERTISE_RATING",},
    ["精准等级提高"] = {"EXPERTISE_RATING",},

    ["护甲穿透等级"] = {"ARMOR_PENETRATION_RATING"},
    ["护甲穿透等级提高"] = {"ARMOR_PENETRATION_RATING"},
    -- Exclude
    ["秒"] = false,
    ["到"] = false,
    ["格容器"] = false,
    ["格箭袋"] = false,
    ["格弹药袋"] = false,
    ["远程攻击速度%"] = false, -- AV quiver
  },
} -- }}}

DisplayLocale.zhCN = { -- {{{
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "Stat Multiplier",
  ["Attack Power Multiplier"] = "Attack Power Multiplier",
  ["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
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
    ["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg"}, -- DAMAGE = "Damage"
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

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
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
    ["COMBAT_HEALTH_REGEN"] = {"生命恢复", "HP5"},
    ["COMBAT_MANA_REGEN"] = {"法力恢复", "MP5"},

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
    ["ARMOR_PENETRATION_RATING"] = {"护甲穿透等级", "护甲穿透等级"},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {"正常回血", "正常回血"},
    ["MANA_REGEN"] = {"正常回魔", "正常回魔"},
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
    ["ARMOR_PENETRATION"] = {"护甲穿透(%)", "护甲穿透(%)"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    -- Expertise -> Dodge Neglect, Parry Neglect
    ["DODGE_NEGLECT"] = {"防止被躲闪(%)", "防止被躲闪(%)"},
    ["PARRY_NEGLECT"] = {"防止被招架(%)", "防止被招架(%)"},
    ["BLOCK_NEGLECT"] = {"防止被格挡(%)", "防止被格挡(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"物理爆击(%)", "爆击(%)"},
    ["RANGED_CRIT_DMG"] = {"远程爆击(%)", "远程爆击(%)"},
    ["SPELL_CRIT_DMG"] = {"法术爆击(%)", "法爆(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
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
    ["MOD_HEAL"] = {"修正法术治疗(%)", "修正治疗(%)"},
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
} -- }}}

-- ruRU localization by Gezz
PatternLocale.ruRU = { -- {{{
  ["tonumber"] = function(s)
    local n = tonumber(s)
    if n then
      return n
    else
      return tonumber((gsub(s, ",", "%.")))
    end
  end,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "Латы",
  Mail = "Кольчуга",
  Leather = "Кожа",
  Cloth = "Ткань",
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
    ["Перек"] = true, -- Перековано
    ["Герои"] = true, -- Героический
    ["Может"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
    -- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
    ["Длите"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
    ["<Изго"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
    ["Време"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
    ["Уника"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
    ["Требу"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
    ["\nТреб"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
    ["Класс"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
    ["Расы:"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
    ["Испол"] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
    ["Возмо"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
    ["Верхо"] = true, -- Верховые животные
    -- Set Bonuses
    -- ITEM_SET_BONUS = "Set: %s";
    -- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
    -- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
    ["Компл"] = true,
    ["(2) S"] = true,
    ["(3) S"] = true,
    ["(4) S"] = true,
    ["(5) S"] = true,
    ["(6) S"] = true,
    ["(7) S"] = true,
    ["(8) S"] = true,
    -- Equip type
    ["Боеприпасы"] = true, -- Ice Threaded Arrow ID:19316
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
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

    ["Слабое волшебное масло"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
    ["Простое волшебное масло"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
    ["Волшебное масло"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
    ["Сверкающее волшебное масло"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
    ["Превосходное волшебное масло"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
    ["Благословенное волшебное масло"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

    ["Слабое масло маны"] = {["COMBAT_MANA_REGEN"] = 4}, -- ID: 20745
    ["Простое масло маны"] = {["COMBAT_MANA_REGEN"] = 8}, -- ID: 20747
    ["Сверкающее масло маны"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, -- ID: 20748
    ["Превосходное масло маны"] = {["COMBAT_MANA_REGEN"] = 14}, -- ID: 22521

    ["Eternium Line"] = {["FISHING"] = 5}, --
    ["свирепость"] = {["AP"] = 70}, --
    ["жизненная сила"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
    ["Душелед"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["Солнечный огонь"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

    ["Мифриловые шпоры"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
    ["Minor Mount Speed Increase"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
    ["Если на персонаже: скорость бега слегка увеличилась."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
    ["Небольшое увеличение скорости"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
    ["Небольшое увеличение скорости бега"] = {["RUN_SPEED"] = 8}, --
    ["Minor Speed"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
    ["верный шаг"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

    ["Скрытность"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    ["снижение угрозы на 2%"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["Если на персонаже: возможность дышать под водой."] = false, -- [Band of Icy Depths] ID: 21526
    ["Возможность дышать под водой."] = false, --
    ["Если на персонаже: Неуязвимость к способности Разоружение."] = false, -- [Stronghold Gauntlets] ID: 12639
    ["Неуязвимость к разоружению"] = false, --
    ["Рыцарь"] = false, -- Enchant Crusader
    ["Похищение жизни"] = false, -- Enchant Crusader

    ["Живучесть клыкарра"] = {["RUN_SPEED"] = 8, ["STA"] = 15}, -- EnchantID: 3232
    ["Мудрость"] = {["MOD_THREAT"] = -2, ["SPI"] = 10}, -- EnchantID: 3296
    ["Точность"] = {["MELEE_HIT_RATING"] = 25, ["SPELL_HIT_RATING"] = 25, ["MELEE_CRIT_RATING"] = 25, ["SPELL_CRIT_RATING"] = 25}, -- EnchantID: 3788
    ["Проклятие Плети"] = {["AP_UNDEAD"] = 140}, -- EnchantID: 3247
    ["Ледопроходец"] = {["MELEE_HIT_RATING"] = 12, ["SPELL_HIT_RATING"] = 12, ["MELEE_CRIT_RATING"] = 12, ["SPELL_CRIT_RATING"] = 12}, -- EnchantID: 3826
    ["Собиратель"] = {["HERBALISM"] = 5, ["MINING"] = 5, ["SKINNING"] = 5}, -- EnchantID: 3296
    ["Живучесть II"] = {["COMBAT_MANA_REGEN"] = 6, ["COMBAT_HEALTH_REGEN"] = 6}, -- EnchantID: 3244

    ["+37 к выносливости и +20 к рейтингу защиты"] = {["STA"] = 37, ["DEFENSE_RATING"] = 20}, -- Defense does not equal Defense Rating...
    ["Руна сломанных мечей"] = {["PARRY"] = 2}, -- EnchantID: 3594
    ["Руна расколотых мечей"] = {["PARRY"] = 4}, -- EnchantID: 3365
    ["Руна каменной горгульи"] = {["DEFENSE"] = 25, ["MOD_STA"] = 2}, -- EnchantID:
  },
  ----------------------------
  -- Single Plus Stat Check --
  ----------------------------
  -- depending on locale, it may be
  -- +19 Stamina = "^%+(%d+) (.-)%.?$"
  -- Stamina +19 = "^(.-) %+(%d+)%.?$"
  -- +19 ?? = "^%+(%d+) (.-)%.?$"
  -- Some have a "." at the end of string like:
  -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
  -- ["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
  ["SinglePlusStatCheck"] = "^(.-): %+(%d+)%.?$",
  -----------------------------
  -- Single Equip Stat Check --
  -----------------------------
  -- stat1, value, stat2 = strfind
  -- stat = stat1..stat2
  -- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
  --  ["SingleEquipStatCheck"] = "^Если на персонаже: (.-) ?н?е? ?б?о?л?е?е? ?ч?е?м?,? на (%d+) ?е?д?.? ?(.-)%.?$",
  ["SingleEquipStatCheck"] = "^Если на персонаже: (.-)%s?+?(%d+)%.?%s?%(?.*%)?(.-)$",
  -------------
  -- PreScan --
  -------------
  -- Special cases that need to be dealt with before deep scan
  ["PreScanPatterns"] = {
    --["^Если на персонаже: Увеличивает силу атаки на (%d+) ед. в облике кошки"] = "FERAL_AP",
    --["^Если на персонаже: Увеличение силы атаки на (%d+) ед. в битве с нежитью"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
    ["^Броня: (%d+)$"] = "ARMOR",
    ["Доспех усилен %(%+(%d+) к броне%)"] = "ARMOR_BONUS",
    ["Восполнение (%d+) ед%. маны раз в 5 сек%.$"] = "COMBAT_MANA_REGEN",
    ["Восполнение (%d+) ед%. маны раз в 5 секунд"] = "COMBAT_MANA_REGEN",
    ["Восполнение (%d+) ед%. маны в 5 секунд%."] = "COMBAT_MANA_REGEN",
    ["^Урон: %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
    ["^%(([%d%,]+) единицы урона в секунду%)$"] = "DPS",
    ["^%(([%d%.]+) ед. урона в секунду%)$"] = "DPS",
    -- Exclude
    ["^Комплект %((%d+) предмета%)"] = false, -- Set Name (0/9)
    ["^Комплект"] = false, -- Set Name (0/9)
    ["^.- %((%d+)/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    -- Procs
    --["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
    ["[Ии]ногда"] = false, -- [Darkmoon Card: Heroism] ID:19287
    ["[Пп]ри получении удара в бою"] = false, -- [Essence of the Pure Flame] ID: 18815

    ["Увеличение урона, наносимого заклинаниями и эффектами темной магии, на (%d+) ед%."] = "SHADOW_SPELL_DMG",
    ["Увеличение урона, наносимого заклинаниями и эффектами льда, на (%d+) ед%."] = "FROST_SPELL_DMG",
    ["Увеличение урона, наносимого заклинаниями и эффектами сил природы, на (%d+) ед%."] = "NATURE_SPELL_DMG",

    ["Повышение не более чем на (%d+) ед.% урона, наносимого нежити заклинаниями и магическими эффектами%."] = "SPELL_DMG_UNDEAD", -- [Robe of Undead Cleansing] ID:23085
    ["Увеличение урона, наносимого нежити и демонам от магических эффектов и заклинаний, не более чем на (%d+) ед%."] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

    ["Увеличивает силу атаки на (%d+) ед%. в облике кошки, медведя, лютого медведя или лунного совуха."] = "FERAL_AP",
  },
  --------------
  -- DeepScan --
  --------------
  -- Strip leading "Equip: ", "Socket Bonus: "
  ["Equip: "] = "Если на персонаже: ", -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
  ["Socket Bonus: "] = "При соответствии цвета: ", -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
  -- Strip trailing "."
  ["."] = ".",
  ["DeepScanSeparators"] = {
    "/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
    -- " & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
  },
  ["DeepScanWordSeparators"] = {
    -- "%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
    ", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
    " и ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
  },
  ["DualStatPatterns"] = { -- all lower case
    ["^%+(%d+) к лечению и %+(%d+) к урону от заклинаний$"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["^%+(%d+) к лечению %+(%d+) к урону от заклинаний$"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["^увеличение исцеляющих эффектов на (%d+) ед%. и урона от всех магических заклинаний и эффектов на (%d+) ед%.?$"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["увеличивает силу заклинаний на (%d+) ед%."] = {{"SPELL_DMG",},{"HEAL",},},
  },
  ["DeepScanPatterns"] = {
--    "^(.-) ?н?е? ?б?о?л?е?е? ?ч?е?м? на (%d+) ?е?д?.? ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
    "^(.-)%s?([%+%-]%d+)%s?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
    "^(.-)%s?([%d%,]+)%s(.-)$", -- 22.22 xxx xxx (scan last)
  },
  -----------------------
  -- Stat Lookup Table --
  -----------------------
  ["StatIDLookup"] = {
    --[[
    ["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant
    ["All Stats"] = {"STR", "AGI", "STA", "INT", "SPI",},
    ["Fishing"] = {"FISHING",}, -- Fishing enchant ID:846
    ["Fishing Skill"] = {"FISHING",}, -- Fishing lure
    ["Increased Fishing"] = {"FISHING",}, -- Equip: Increased Fishing +20.
    ["Mining"] = {"MINING",}, -- Mining enchant ID:844
    ["Herbalism"] = {"HERBALISM",}, -- Heabalism enchant ID:845
    ["Skinning"] = {"SKINNING",}, -- Skinning enchant ID:865
    ["Attack Power when fighting Undead"] = {"AP_UNDEAD",}, -- [Wristwraps of Undead Slaying] ID:23093
    ["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
    ["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
    ["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
    ["Increases attack powerwhen fighting Undead and Demons"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
    ["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
    ["Ranged Attack Power"] = {"RANGED_AP",},
    ["Healing and Spell Damage"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
    ["Damage and Healing Spells"] = {"SPELL_DMG", "HEAL",},
    ["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
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
    ["Shadow Spell Damage"] = {"SHADOW_SPELL_DMG",},
    ["Increases your block rating"] = {"BLOCK_RATING",},
    ["Increases your shield block rating"] = {"BLOCK_RATING",},
    ["Improves hit rating"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_RATING
    ["Improves melee hit rating"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
    ["Increases your hit rating"] = {"MELEE_HIT_RATING",},
    ["Improves spell hit rating"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
    ["Increases your spell hit rating"] = {"SPELL_HIT_RATING",},
    ["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
    ["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    ["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},
    ["Increases damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",},
    ["Increases damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",},
    ["Increases damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",},
    ["Increases damage done to Undead by magical spells and effects.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
    ["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
    ["Increases Healing"] = {"HEAL",},
    ["Healing"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
    ["healing Spells"] = {"HEAL",},
    ["Damage Spells"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
    ["Increases damage and healing done by magical spells and effects of all party members within 30 yards"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
    ["Increases healing done"] = {"HEAL",}, -- 2.3.0
    ["damage donefor all magical spells"] = {"SPELL_DMG",}, -- 2.3.0
    ["Increases healing done by spells and effects"] = {"HEAL",},
    ["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
    ["your healing"] = {"HEAL",}, -- Atiesh
    ["damage per second"] = {"DPS",},
    ["Critical Strike Rating"] = {"MELEE_CRIT_RATING",},
    ["Increases your critical hit rating"] = {"MELEE_CRIT_RATING",},
    ["Increases your critical strike rating"] = {"MELEE_CRIT_RATING",},
    ["Improves critical strike rating"] = {"MELEE_CRIT_RATING",},
    ["Improves melee critical strike rating"] = {"MELEE_CRIT_RATING",}, -- [Cloak of Darkness] ID:33122
    ["Increases the spell critical strike rating of all party members within 30 yards"] = {"SPELL_CRIT_RATING",},
    ["Increases your ranged critical strike rating"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348
    ["Improves hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RATING
    ["Improves melee hit avoidance rating"] = {"MELEE_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_MELEE_RATING
    ["Improves ranged hit avoidance rating"] = {"RANGED_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_RANGED_RATING
    ["Improves spell hit avoidance rating"] = {"SPELL_HIT_AVOID_RATING"}, -- ITEM_MOD_HIT_TAKEN_SPELL_RATING
    ["Improves your resilience rating"] = {"RESILIENCE_RATING",},
    ["Improves critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    ["Improves melee critical avoidance rating"] = {"MELEE_CRIT_AVOID_RATING",},
    ["Improves ranged critical avoidance rating"] = {"RANGED_CRIT_AVOID_RATING",},
    ["Improves spell critical avoidance rating"] = {"SPELL_CRIT_AVOID_RATING",},
    ["Increases your parry rating"] = {"PARRY_RATING",},
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
    -- Exclude
    ["sec"] = false,
    ["to"] = false,
    ["Slot Bag"] = false,
    ["Slot Quiver"] = false,
    ["Slot Ammo Pouch"] = false,
    ["Increases ranged attack speed"] = false, -- AV quiver
    --]]

    ["Увеличивает рейтинг пробивания брони на"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
    ["Повышает рейтинг пробивания брони на"] = {"ARMOR_PENETRATION_RATING"},
    ["% угрозы"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
    ["увеличение уровня эффективного действия незаметности на"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
    ["Скорость бега слегка увеличилась."] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

    ["ко всем характеристикам"] = {"STR", "AGI", "STA", "INT", "SPI",},
    ["Сила"] = {"STR",},
    ["Ловкость"] = {"AGI",},
    ["Выносливость"] = {"STA",},
    ["Интеллект"] = {"INT",},
    ["Дух"] = {"SPI",},

    ["устойчивость:тайная магия"] = {"ARCANE_RES",},
    ["устойчивость:огонь"] = {"FIRE_RES",},
    ["устойчивость:природа"] = {"NATURE_RES",},
    ["устойчивость:лед"] = {"FROST_RES",},
    ["устойчивость:тьма"] = {"SHADOW_RES",},
    ["к сопротивлению огню"] = {"FIRE_RES",},
    ["к сопротивлению силам природы"] = {"NATURE_RES",},
    ["к сопротивлению темной магии"] = {"SHADOW_RES",},
    ["к сопротивлению тайной магии"] = {"ARCANE_RES",},
    ["к сопротивлению всему"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

    ["Броня"] = {"ARMOR_BONUS",},
    ["Защита"] = {"DEFENSE",},
    ["Повышение защиты"] = {"DEFENSE",},

    ["к силе"] = {"STR",},
    ["к ловкости"] = {"AGI",},
    ["к выносливости"] = {"STA",},
    ["к интеллекту"] = {"INT",},
    ["к духу"] = {"SPI",},
    ["к здоровью"] = {"HEALTH",},
    ["HP"] = {"HEALTH",},
    ["Mana"] = {"MANA",},

    ["сила атаки"] = {"AP",},
    ["сила атаки увеличена на"] = {"AP",},
    ["к силе атаки"] = {"AP",},
    ["увеличение силы атаки на"] = {"AP",},
    ["увеличивает силу атаки на"] = {"AP",},
    ["увеличивает силу атаки наед"] = {"AP",},
    ["Увеличение силы атаки в дальнем бою наед"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

    ["здоровья каждые"] = {"COMBAT_HEALTH_REGEN",}, -- Frostwolf Insignia Rank 6 ID:17909
    ["здоровья раз в"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743
    ["ед. здоровья каждые 5 секунд"] = {"COMBAT_HEALTH_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["ед. здоровья каждые 5 сек"] = {"COMBAT_HEALTH_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["скорости восполнения здоровья - "] = {"COMBAT_HEALTH_REGEN",}, -- Demons Blood ID: 10779
    ["восполняетед. здоровья каждые 5 сек"] = {"COMBAT_HEALTH_REGEN",}, -- [Onyxia Blood Talisman] ID: 18406
    ["восполнениеед. здоровья каждые 5 сек"] = {"COMBAT_HEALTH_REGEN",}, -- [Resurgence Rod] ID:17743

    ["маны раз в"] = {"COMBAT_MANA_REGEN",}, -- Resurgence Rod ID:17743 Most common
    ["ед%. маны раз в 5 сек"] = {"COMBAT_MANA_REGEN",},
    ["ед%. маны в 5 сек"] = {"COMBAT_MANA_REGEN",},
    ["маны каждые 5 секунд"] = {"COMBAT_MANA_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["ед%. маны каждые 5 секунд"] = {"COMBAT_MANA_REGEN",}, -- [Royal Nightseye] ID: 24057
    ["восполнениеманы раз в 5 сек."] = {"COMBAT_MANA_REGEN",}, -- [Resurgence Rod] ID:17743

    ["проникающая способность заклинаний"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
    ["к проникающей способности заклинаний"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
    ["увеличение наед%. проникающей способности заклинаний на"] = {"SPELLPEN",},

    ["сила заклинаний"] = {"SPELL_DMG", "HEAL",},
    ["Увеличивает силу заклинаний на"] = {"SPELL_DMG", "HEAL",},
    ["увеличивает силу заклинаний наед"] = {"SPELL_DMG", "HEAL",},
    ["к урону от заклинаний и лечению"] = {"SPELL_DMG", "HEAL",},
    ["к урону от заклинаний"] = {"SPELL_DMG", "HEAL",},
    ["к силе заклинаний"] = {"SPELL_DMG", "HEAL",},
    ["Увеличение урона и целительного действия магических заклинаний и эффектов"] = {"SPELL_DMG", "HEAL"},
    ["к урону заклинаний от магии льда"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957

    ["Увеличение урона от светлой магии, действие до"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
    ["к лечению"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
    ["Добавляетурона в секунду"] = {"DPS",}, -- [Thorium Shells] ID: 15977

    ["рейтинг защиты"] = {"DEFENSE_RATING",},
    ["увеличивает рейтинг защиты на"] = {"DEFENSE_RATING",}, -- [Golem Skull Helm] ID: 11746
    ["к рейтингу защиты"] = {"DEFENSE_RATING",},
    ["увеличение рейтинга защиты наед"] = {"DEFENSE_RATING",},
    ["рейтинг уклонения"] = {"DODGE_RATING",},
    ["к рейтингу уклонения"] = {"DODGE_RATING",},
    ["увеличение рейтинга уклонения наед"] = {"DODGE_RATING",},
    ["рейтинг парирования"] = {"PARRY_RATING",},
    ["к рейтингу парирования"] = {"PARRY_RATING",},
    ["рейтинг блокирования щитом"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
    ["к рейтингу блока"] = {"BLOCK_RATING",}, --

    ["рейтинг меткости"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["к рейтингу меткости"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["увеличение рейтинга меткости наед"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["к рейтингу меткости заклинаний"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
    ["рейтинг меткости (заклинания)"] = {"SPELL_HIT_RATING",},


    --["Critical Rating"] = {"MELEE_CRIT_RATING",}, -- БАГ - непереведенный камень (+8 att power + 5 crit rate)
    ["рейтинг критического удара"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["к рейтингу критического удара"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["рейтинг крит%. удара оруж%. ближнего боя"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["рейтинг критического удара (заклинания)"] = {"SPELL_CRIT_RATING",},
    ["к рейтингу критического удара заклинаниями"] = {"SPELL_CRIT_RATING",},
    ["к рейтингу критического удара заклинанием"] = {"SPELL_CRIT_RATING",},
    ["Увеличение рейтинга критического эффекта заклинаний наед"] = {"SPELL_CRIT_RATING",},

    ["Устойчивость"] = {"RESILIENCE_RATING",},
    ["к устойчивости"] = {"RESILIENCE_RATING",},
    ["рейтинг устойчивости"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
    ["к рейтингу устойчивости"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992

    ["рейтинг скорости"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["к рейтингу скорости"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["рейтинг скорости боя"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["к рейтингу скорости боя"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["к рейтингу скорости заклинаний"] = {"SPELL_HASTE_RATING"},
    ["рейтинг скорости боя (заклинания)"] = {"SPELL_HASTE_RATING"},

    ["рейтинг мастерства"] = {"EXPERTISE_RATING"},
    ["к рейтингу мастерства"] = {"EXPERTISE_RATING"},

    ["к рейтингу искусности"] = {"MASTERY_RATING"},
    ["рейтинг искусности"] = {"MASTERY_RATING"},
  },
} -- }}}
DisplayLocale.ruRU = { -- {{{
  ["StatIDToName"] = {
    --[StatID] = {FullName, ShortName},
    ["MASTERY_RATING"] = {"Рейтинг искусности", "РИ"},
    ["MASTERY"] = {"Искусность", "Иск"},
  },
}

-- esES localization by Kaie Estirpe de las Sombras from Minahonda
PatternLocale.esES = { -- {{{
  ["tonumber"] = function(s)
    local n = tonumber(s)
    if n then
      return n
    else
      return tonumber((gsub(s, ",", "%.")))
    end
  end,
  -----------------
  -- Armor Types --
  -----------------
  Plate = "Placas",
  Mail = "Mallas",
  Leather = "Cuero",
  Cloth = "Tela",
  ------------------
  -- Fast Exclude --
  ------------------
  -- ExcludeLen Mirando a las primeras letras de una linea podemos excluir un monton de lineas
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
    --["Desen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
    --["Durac"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
    ["Tiemp"] = true, -- temps de recharge…
    ["<Hecho"] = true, -- artisan
    ["Único"] = true, -- Unique (20)
    ["Nivel"] = true, -- Niveau
    ["\nNive"] = true, -- Niveau
    ["Clase"] = true, -- Classes: xx
    ["Razas"] = true, -- Races: xx (vendor mounts)
    ["Uso: "] = true, -- Utiliser:
    ["Posib"] = true, -- Chance de toucher:
    ["Requi"] = true, -- Requiert
    ["\nRequ"] = true,-- Requiert
    ["Neces"] = true,--nécessite plus de gemmes...
    -- Set Bonuses
    ["Bonif"] = true,--ensemble
    ["(2) B"] = true,
    ["(2) B"] = true,
    ["(3) B"] = true,
    ["(4) B"] = true,
    ["(5) B"] = true,
    ["(6) B"] = true,
    ["(7) B"] = true,
    ["(8) B"] = true,
    -- Equip type
    ["Proye"] = true, -- Ice Threaded Arrow ID:19316
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
    [REFORGED] = true,
    [ITEM_HEROIC] = true,
    [ITEM_HEROIC_EPIC] = true,
    [ITEM_HEROIC_QUALITY0_DESC] = true,
    [ITEM_HEROIC_QUALITY1_DESC] = true,
    [ITEM_HEROIC_QUALITY2_DESC] = true,
    [ITEM_HEROIC_QUALITY3_DESC] = true,
    [ITEM_HEROIC_QUALITY4_DESC] = true,
    [ITEM_HEROIC_QUALITY5_DESC] = true,
    [ITEM_HEROIC_QUALITY6_DESC] = true,
    [ITEM_HEROIC_QUALITY7_DESC] = true,
    [ITEM_QUALITY0_DESC] = true,
    [ITEM_QUALITY1_DESC] = true,
    [ITEM_QUALITY2_DESC] = true,
    [ITEM_QUALITY3_DESC] = true,
    [ITEM_QUALITY4_DESC] = true,
    [ITEM_QUALITY5_DESC] = true,
    [ITEM_QUALITY6_DESC] = true,
    [ITEM_QUALITY7_DESC] = true,
  },

  -----------------------
  -- Whole Text Lookup --
  -----------------------
  -- Usado principalmente para encantamientos que no tienen numeros en el texto
  ["WholeTextLookup"] = {
    [EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
    [EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
    [EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
    [EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

    --ToDo
    ["Aceite de zahorí menor"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
    ["Aceite de zahorí inferior"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
    ["Aceite de zahorí"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
    ["Aceite de zahorí luminoso"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
    ["Aceite de zahorí excelente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
    ["Aceite de zahorí bendito"] = {["SPELL_DMG_UNDEAD"] = 60}, --

    ["Aceite de maná menor"] = {["COMBAT_MANA_REGEN"] = 4}, --
    ["Aceite de maná inferior"] = {["COMBAT_MANA_REGEN"] = 8}, --
    ["Aceite de maná luminoso"] = {["COMBAT_MANA_REGEN"] = 12, ["HEAL"] = 25}, --
    ["Aceite de maná excelente"] = {["COMBAT_MANA_REGEN"] = 14}, --

    ["Sedal de eternio"] = {["FISHING"] = 5}, --
    ["Fuego solar"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --
    ["Velocidad de la montura"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
    ["Pies de plomo"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

    ["Sutileza"] = {["MOD_THREAT"] = -2}, -- Enchant Cloak - Subtlety
    -- ["2% Reduced Threat"] = {["MOD_THREAT"] = -2}, -- StatLogic:GetSum("item:23344:2832")
    ["Equipar: Permite respirar bajo el agua"] = false, -- [Band of Icy Depths] ID: 21526
    ["Permite respirar bajo el agua"] = false, --
    ["Equipar: Duración de Desarmar reducida"] = false, -- [Stronghold Gauntlets] ID: 12639
    ["Immune a desarmar"] = false, --
    ["Robo de vida"] = false, -- Enchant Crusader

    --translated
    ["Espuelas de mitril"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
    ["Equipar: Velocidad de carrera aumentada ligeramente"] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048"
    ["Aumenta ligeramente la velocidad de movimiento"] = {["RUN_SPEED"] = 8}, --
    ["Aumenta ligeramente la velocidad de movimiento"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
    ["Vitalidad"] = {["COMBAT_MANA_REGEN"] = 4, ["COMBAT_HEALTH_REGEN"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
    ["Escarcha de alma"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
    ["Salvajismo"] = {["AP"] = 70}, --
    ["Velocidad menor"] = {["RUN_SPEED"] = 8},
    -- ["Vitesse mineure et +9 en Endurance"] = {["RUN_SPEED"] = 8, ["STA"] = 9},--enchant

    ["Cruzado"] = false, -- Enchant Crusader
    ["Mangosta"] = false, -- Enchant Mangouste
    ["Arma impia"] = false,
    -- ["Équipé : Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, --cape Onyxia
  },
  ----------------------------
  -- Single Plus Stat Check --
  ----------------------------
  ["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$",
  -----------------------------
  -- Single Equip Stat Check --
  -----------------------------
  ["SingleEquipStatCheck"] = "^Equipar: (.-) h?a?s?t?a? ?(%d+)(.-)?%.$",

  -------------
  -- PreScan --
  -------------
  -- Special cases that need to be dealt with before deep scan
  ["PreScanPatterns"] = {
    ["^(%d+) armadura$"] = "ARMOR",
    ["^Equipar: Restaura (%d+) p. de salud cada 5 s"]= "COMBAT_HEALTH_REGEN",
    ["^Equipar: Restaura (%d+) p. de maná cada 5 s"]= "COMBAT_MANA_REGEN",
    ["^Equipar: Aumenta (%d+) p. el poder de ataque"]= "AP",
    -- ["^Equipar: Mejora tu índice de golpe crítico (%d+) p"]= "MELEE_CRIT_RATING",
    ["Refuerza %(%+(%d+) Armadura%)"]= "ARMOR_BONUS",
    -- ["Lunette %(%+(%d+) points? de dégâts?%)"]="RANGED_AP",
    ["^%+?%d+ %- (%d+) .-Daño$"] = "MAX_DAMAGE",
    ["^%(([%d%,]+) daño por segundo%)$"] = "DPS",

    -- Exclude
    ["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
    ["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
    --["Confère une chance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
    ["A veces ganas"] = false, -- [Darkmoon Card: Heroism] ID:19287
    ["Ganas una Carga"] = false, -- El condensador de rayos ID:28785
    ["Daño:"] = false, -- ligne de degats des armes
    ["Tu técnica"] = false,
    ["^%+?%d+ %- %d+ puntos de daño %(.-%)$"]= false, -- ligne de degats des baguettes/ +degats (Thunderfury)
    -- ["Permettent au porteur"] = false, -- Casques Ombrelunes
    -- ["^.- %(%d+%) requis"] = false, --metier requis pour porter ou utiliser
    -- ["^.- ?[Vv]?o?u?s? [Cc]onfèren?t? .-"] = false, --proc
    -- ["^.- ?l?e?s? ?[Cc]hances .-"] = false, --proc
    -- ["^.- par votre sort .-"] = false, --augmentation de capacité de sort
    -- ["^.- la portée de .-"] = false, --augmentation de capacité de sort
    -- ["^.- la durée de .-"] = false, --augmentation de capacité de sort
  },
  --------------
  -- DeepScan --
  --------------
  -- Strip leading "Equip: ", "Socket Bonus: "
  ["Equip: "] = "Equipar: ", --\194\160= espacio requerido
  ["Socket Bonus: "] = "Bonus ranura: ",
    -- Strip trailing "."
  ["."] = ".",
  ["DeepScanSeparators"] = {
    "/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
    " y " , -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
    ", " , -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
    "[^p]%." , -- cuando es p y punto no separa
  },
  ["DeepScanWordSeparators"] = {
     " y ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
  },
  ["DualStatPatterns"] = { -- all lower case
    ["la salud %+(%d+) y el daño %+ (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["la salud %+(%d+) el dano %+ (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
    ["salud un máximo de (%d+) y el dano un máximo de (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
  },
  ["DeepScanPatterns"] = {
    "^(.-) ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
    -- "^(.-)5 [Ss]ek%. (%d+) (.-)$",  -- "xxx 5 Sek. 8 xxx" (scan 2nd)
    "^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 3rd)
    "^(.-) ?([%d%,]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
  },
  -----------------------
  -- Stat Lookup Table --
  -----------------------
  ["StatIDLookup"] = {
    ["Mira de korio"] = {"RANGED_DMG"}, -- Khorium Scope EnchantID: 2723
    ["Scope (Critical Strike Rating)"] = {"RANGED_CRIT_RATING"}, -- Stabilized Eternium Scope EnchantID: 2724
    ["Your attacks ignoreof your opponent's armor"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
    ["% Threat"] = {"MOD_THREAT"}, -- StatLogic:GetSum("item:23344:2613")
    ["Aumenta tu nivel efectivo de sigilo enp"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
    -- ["Velocidad de carrera"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048


    --dano melee
    ["daño de arma"] = {"MELEE_DMG"},
    ["daño del arma"] = {"MELEE_DMG"},
    ["daño en melee"] = {"MELEE_DMG"},
    ["daño de melee"] = {"MELEE_DMG"},


    --caracteristicas
    ["todas las estadísticas"] = {"STR", "AGI", "STA", "INT", "SPI",},
    ["Fuerza"] = {"STR",},
    ["Agilidad"] = {"AGI",},
    ["Aguante"] = {"STA",},
    ["Intelecto"] = {"INT",},
    ["Espíritu"] = {"SPI",},


    --resistencias
    ["resistencia arcana"] = {"ARCANE_RES",},
    ["resistencia a Arcano"] = {"ARCANE_RES",},

    ["resistencia al fuego"] = {"FIRE_RES",},
    ["resistencia al Fuego"] = {"FIRE_RES",},

    ["resistencia a la naturaleza"] = {"NATURE_RES",},
    ["resistencia a Naturaleza"] = {"NATURE_RES",},

    ["resistencia a la Escarcha"] = {"FROST_RES",},
    ["resistencia a Escarcha"] = {"FROST_RES",},

    ["resistencia a Sombras"] = {"SHADOW_RES",},
    ["resistencia a las sombras"] = {"SHADOW_RES",},

    ["a todas las resistencias"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

    --artesano
    ["pesca"] = {"FISHING",},
    ["mineria"] = {"MINING",},
    ["herboristeria"] = {"HERBALISM",}, -- Heabalism enchant ID:845
    ["desollar"] = {"SKINNING",}, -- Skinning enchant ID:865

    --
    ["armadura"] = {"ARMOR_BONUS",},

    ["defensa"] = {"DEFENSE",},

    ["salud"] = {"HEALTH",},
    ["puntos de vida"] = {"HEALTH",},
    ["puntos de maná"] = {"MANA",},

    ["aumenta el poder de ataquep"] = {"AP",},
    ["al poder de ataque"] = {"AP",},
    ["poder de ataque"] = {"AP",},
    ["aumentap. el poder ataque"] = {"AP",}, -- id:38045



    --ToDo
    ["Aumenta el poder de ataque contra muertos vivientes"] = {"AP_UNDEAD",},
    --["Increases attack powerwhen fighting Undead"] = {"AP_UNDEAD",},
    --["Increases attack powerwhen fighting Undead.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",},
    --["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
    --["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
    --["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},


    --ranged AP
    ["el poder de ataque a distancia"] = {"RANGED_AP",},
    --Feral
    ["el poder de ataque para la formas felina, de oso"] = {"FERAL_AP",},

    --regenerar
    ["maná cada 5 segundos"] = {"COMBAT_MANA_REGEN",},
    ["maná cada 5 s"] = {"COMBAT_MANA_REGEN",},
    ["puntos de vida cada 5 segundos"] = {"COMBAT_HEALTH_REGEN",},
    ["puntos de salud cada 5 segundos"] = {"COMBAT_HEALTH_REGEN",},
    ["points de mana toutes les 5 sec"] = {"COMBAT_MANA_REGEN",},
    ["points de vie toutes les 5 sec"] = {"COMBAT_HEALTH_REGEN",},
    ["p. de maná cada 5 s."] = {"COMBAT_MANA_REGEN",},
    ["p. de salud cada 5 s."] = {"COMBAT_HEALTH_REGEN",},
    ["regeneración de maná"] = {"COMBAT_MANA_REGEN",},


    --penetración de hechizos
    ["aumenta el índice de penetración de tus hechizosp"] = {"SPELLPEN",},
    ["penetración del hechizo"] = {"SPELLPEN",},
    ["aumenta el índice de penetración de armadurap"] = {"SPELLPEN",},

    --Puissance soins et sorts
    ["poder con hechizos"] = {"SPELL_DMG", "HEAL"},
    ["el poder con hechizos"] = {"SPELL_DMG", "HEAL"},
    ["Aumenta el poder con hechizosp"] = {"SPELL_DMG", "HEAL"},


    --ToDo
    ["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques d'un maximum de"] = {"SPELL_DMG_UNDEAD"},

    ["el daño inflingido por los hechizos de sombras"]={"SHADOW_SPELL_DMG",},
    ["el daño de hechizo de sombras"]={"SHADOW_SPELL_DMG",},
    ["el daño de sombras"]={"SHADOW_SPELL_DMG",},

    ["el daño inflingido por los hechizos de escarcha"]={"FROST_SPELL_DMG",},
    ["el daño de hechizos de escarcha"]={"FROST_SPELL_DMG",},
    ["el daño de escarcha"]={"FROST_SPELL_DMG",},

    ["el daño inflingido por los hechizos de fuego"]={"FIRE_SPELL_DMG",},
    ["el daño de hechizos de fuego"]={"FIRE_SPELL_DMG",},
    ["el daño de fuego"]={"FIRE_SPELL_DMG",},

    ["el daño inflingido por los hechizos de naturaleza"]={"NATURE_SPELL_DMG",},
    ["el daño de hechizos de naturaleza"]={"NATURE_SPELL_DMG",},
    ["el daño de naturaleza"]={"NATURE_SPELL_DMG",},

    ["el daño inflingido por los hechizos arcanos"]={"ARCANE_SPELL_DMG",},
    ["el daño de hechizos arcanos"]={"ARCANE_SPELL_DMG",},
    ["el daño arcano"]={"ARCANE_SPELL_DMG",},

    ["el daño inflingido por los hechizos de sagrado"]={"HOLY_SPELL_DMG",},
    ["el daño de hechizos sagrado"]={"HOLY_SPELL_DMG",},
    ["el daño de sagrado"]={"HOLY_SPELL_DMG",},

    --ToDo
    --["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
    --["Increases Healing"] = {"HEAL",},
    --["Healing"] = {"HEAL",},
    --["healing Spells"] = {"HEAL",},
    --["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
    --["Increases healing done by spells and effects"] = {"HEAL",},
    --["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
    --["your healing"] = {"HEAL",}, -- Atiesh

    ["da/195/177o por segundo"] = {"DPS",},
    --["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

    ["índice de defensa"] = {"DEFENSE_RATING",},
    ["aumenta tu índice de defensap"] = {"DEFENSE_RATING",},
    ["tu índice de defensa"] = {"DEFENSE_RATING",},

    ["índice de esquivar"] = {"DODGE_RATING",},
    ["aumenta tu índice de esquivarp"] = {"DODGE_RATING",},
    ["tu índice de esquivar"] = {"DODGE_RATING",},

    ["índice de parada"] = {"PARRY_RATING",},
    ["tu índice de parada"] = {"PARRY_RATING",},
    ["Aumenta tu índice de paradap"] = {"PARRY_RATING",},
    ["Aumenta el índice de parada"] = {"PARRY_RATING",},

    ["índice de bloqueo"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
    ["aumenta el índice de bloqueo"] = {"BLOCK_RATING",},
    ["tu índice de bloqueo"] = {"BLOCK_RATING",},

    ["mejora tu índice de golpep"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["índice de golpe"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING",},
    ["tu índice de golpep"] = {"MELEE_HIT_RATING", "SPELL_HIT_RATING"},

    ["mejora tu índice de golpe críticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["índice de criticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},
    ["tu índice de golpe críticop"] = {"MELEE_CRIT_RATING", "SPELL_CRIT_RATING",},

    ["índice de temple"] = {"RESILIENCE_RATING",},
    ["Mejora tu índice de templep"] = {"RESILIENCE_RATING",},
    ["tu índice de temple"] = {"RESILIENCE_RATING",},
    ["al temple"] = {"RESILIENCE_RATING",},

    ["tu índice de golpe con hechizos"] = {"SPELL_HIT_RATING",},
    ["índice de golpe de hechizos"] = {"SPELL_HIT_RATING",},
    ["tu indice de golpe con hechizos"] = {"SPELL_HIT_RATING",},

    ["el indice de golpe critico de hechizo"] = {"SPELL_CRIT_RATING",},
    ["indice de golpe critico de los hechizos"] = {"SPELL_CRIT_RATING",},
    ["indice de critico con hechizos"] = {"SPELL_CRIT_RATING",},

    --ToDo
    --["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
    --["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
    --["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},
    --["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

    ["índice de celeridad"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING"},
    ["mejora tu índice de celeridadp"] = {"MELEE_HASTE_RATING", "SPELL_HASTE_RATING",},
    ["Mejora tu índice de celeridad"] = {"SPELL_HASTE_RATING"},
    ["Mejora el índice de celeriad"] = {"RANGED_HASTE_RATING"},
    --["Improves haste rating"] = {"MELEE_HASTE_RATING"},
    --["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
    --["Improves ranged haste rating"] = {"SPELL_HASTE_RATING"},
    --["Improves spell haste rating"] = {"RANGED_HASTE_RATING"},

    ["tu índice de pericia"] = {"EXPERTISE_RATING"},
    ["el índice de pericia"] = {"EXPERTISE_RATING"},

    ["índice de penetración de armadura"] = {"ARMOR_PENETRATION_RATING"}, -- gems
    -- ["Increases your expertise rating"] = {"EXPERTISE_RATING"},
    -- ["Increases armor penetration rating"] = {"ARMOR_PENETRATION_RATING"},
    ["Aumenta tu índice de penetración de armadurap"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178

    -- no traducidos no se si se utilizan actualmente
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
    ["Bolsa"] = false,
    --["Slot Quiver"] = false,
    --["Slot Ammo Pouch"] = false,
    --["Increases ranged attack speed"] = false, -- AV quiver
  },
} -- }}}

DisplayLocale.esES = { -- {{{
  --ToDo
  ----------------
  -- Stat Names --
  ----------------
  -- Please localize these strings too, global strings were used in the enUS locale just to have minimum
  -- localization effect when a locale is not available for that language, you don't have to use global
  -- strings in your localization.
  ["Stat Multiplier"] = "Stat Multiplier",
  ["Attack Power Multiplier"] = "Attack Power Multiplier",
  ["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken",
  ["10% Melee/Ranged Attack Speed"] = "10% Melee/Ranged Attack Speed",
  ["5% Spell Haste"] = "5% Spell Haste",
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
    ["RANGED_DMG"] = {"Ranged Weapon "..DAMAGE, "Ranged Dmg"}, -- DAMAGE = "Damage"
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

    ["BLOCK_VALUE"] = {"Bloqueo", "Block Value"},

    ["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
    ["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
    ["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
    ["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Undead)", "AP(Undead)"},
    ["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Demon)", "AP(Demon)"},

    ["HEAL"] = {"Sanacion", "Heal"},

    ["SPELL_POWER"] = {STAT_SPELLPOWER, STAT_SPELLPOWER},
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
    ["COMBAT_HEALTH_REGEN"] = {HEALTH.." Regen", "HP5"},
    ["COMBAT_MANA_REGEN"] = {MANA.." Regen", "MP5"},

    ["MAX_DAMAGE"] = {"Max Daño", "Max Dmg"},
    ["DPS"] = {"Daño por segundo", "DPS"},

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
    ["EXPERTISE_RATING"] = {"Expertise".." "..RATING, "Expertise".." "..RATING},
    ["ARMOR_PENETRATION_RATING"] = {"Armor Penetration".." "..RATING, "ArP".." "..RATING},

    ---------------------------------------------------------------------------
    -- Tier2 Stats - Stats that only show up when broken down from a Tier1 Stat
    -- Str -> AP, Block Value
    -- Agi -> AP, Crit, Dodge
    -- Sta -> Health
    -- Int -> Mana, Spell Crit
    -- Spi -> mp5nc, hp5oc
    -- Ratings -> Effect
    ["HEALTH_REGEN"] = {HEALTH.." Regen (Out of combat)", "HP5(OC)"},
    ["MANA_REGEN"] = {MANA.." Regen (Out of casting)", "MP5(OC)"},
    ["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction(%)", "Crit Dmg Reduc(%)"},
    ["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
    ["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
    ["DEFENSE"] = {DEFENSE, "Def"},
    ["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
    ["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
    ["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
    ["MELEE_HIT"] = {"Prob. Golpe(%)", "Hit(%)"},
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
    ["MELEE_HASTE"] = {"Celeridad(%)", "Haste(%)"}, --
    ["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Celeridad(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
    ["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Celeridad(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
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
    ["EXPERTISE"] = {"Pericia", "Expertise"},
    ["ARMOR_PENETRATION"] = {"Penetr. Armadura(%)", "ArP(%)"},

    ---------------------------------------------------------------------------
    -- Tier3 Stats - Stats that only show up when broken down from a Tier2 Stat
    -- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
    -- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
    ["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
    ["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
    ["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

    ---------------------------------------------------------------------------
    -- Talents
    ["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
    ["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
    ["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

    ---------------------------------------------------------------------------
    -- Spell Stats
    -- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
    -- ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
    -- ex: "Heroic Strike@THREAT" for Heroic Strike threat value
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
    ["MOD_HEAL"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
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
} -- }}}

PatternLocale.esMX = PatternLocale.esES
DisplayLocale.esMX = DisplayLocale.esES

local locale = GetLocale()
local noPatternLocale
local L = PatternLocale[locale]
if not L then
  noPatternLocale = true
  L = PatternLocale.enUS
end

-- Setup DisplayLocale with enUS fallback if current local translation does not exist
local function SetupDisplayLocale(locale, enUS)
  for k in pairs(enUS) do
    if type(enUS[k]) == "table" and type(locale[k]) == "table" then
      SetupDisplayLocale(locale[k], enUS[k])
    elseif locale[k] then
      enUS[k] = locale[k]
    end
  end
end
if DisplayLocale[locale] then
  SetupDisplayLocale(DisplayLocale[locale], DisplayLocale.enUS)
end
local D = DisplayLocale.enUS
PatternLocale = nil
DisplayLocale = nil

-- Add all lower case strings to ["StatIDLookup"]
local strutf8lower = string.utf8lower
local temp = {}
for k, v in pairs(L.StatIDLookup) do
  temp[strutf8lower(k)] = v
end
for k, v in pairs(temp) do
  L.StatIDLookup[k] = v
end
temp = nil

--[[---------------------------------
  :GetStatNameFromID(stat)
-------------------------------------
Notes:
  * Returns localized names for stat
Arguments:
  string - "StatID". ex: "DODGE", "DODGE_RATING"
Returns:
  ; "longName" : string - The full name for stat.
  ; "shortName" : string - The short name for stat.
Example:
  local longName, shortName = StatLogic:GetStatNameFromID("FIRE_RES") -- "Fire Resistance", "FR"
-----------------------------------]]
function StatLogic:GetStatNameFromID(stat)
  local name = D.StatIDToName[stat]
  if not name then return end
  return unpack(name)
end


-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection


--------------
-- Activate --
--------------
-- When a newer version is registered
local tip = StatLogic.tip
if not tip then
  -- Create a custom tooltip for scanning
  tip = CreateFrame("GameTooltip", MAJOR.."Tooltip", nil, "GameTooltipTemplate")
  StatLogic.tip = tip
  tip:SetOwner(UIParent, "ANCHOR_NONE")
  for i = 1, 40 do
    tip[i] = _G[MAJOR.."TooltipTextLeft"..i]
    if not tip[i] then
      tip[i] = tip:CreateFontString()
      tip:AddFontStrings(tip[i], tip:CreateFontString())
      _G[MAJOR.."TooltipTextLeft"..i] = tip[i]
    end
  end
elseif not _G[MAJOR.."TooltipTextLeft40"] then
  for i = 1, 40 do
    _G[MAJOR.."TooltipTextLeft"..i] = tip[i]
  end
end
local tipMiner = StatLogic.tipMiner
if not tipMiner then
  -- Create a custom tooltip for data mining
  tipMiner = CreateFrame("GameTooltip", MAJOR.."MinerTooltip", nil, "GameTooltipTemplate")
  StatLogic.tipMiner = tipMiner
  tipMiner:SetOwner(UIParent, "ANCHOR_NONE")
  for i = 1, 40 do
    tipMiner[i] = _G[MAJOR.."MinerTooltipTextLeft"..i]
    if not tipMiner[i] then
      tipMiner[i] = tipMiner:CreateFontString()
      tipMiner:AddFontStrings(tipMiner[i], tipMiner:CreateFontString())
      _G[MAJOR.."MinerTooltipTextLeft"..i] = tipMiner[i]
    end
  end
elseif not _G[MAJOR.."MinerTooltipTextLeft40"] then
  for i = 1, 40 do
    _G[MAJOR.."MinerTooltipTextLeft"..i] = tipMiner[i]
  end
end
local StatLogicMinerTooltipTextLeft5 = _G[MAJOR.."MinerTooltipTextLeft5"]
local StatLogicMinerTooltipTextLeft6 = _G[MAJOR.."MinerTooltipTextLeft6"]

---------------------
-- Local Variables --
---------------------
-- Player info
local _, playerClass = UnitClass("player")
local _, playerRace = UnitRace("player")

-- Localize globals
local tonumber = L.tonumber
local _G = getfenv(0)
local strfind = strfind
local strsub = strsub
local strupper = strupper
local strmatch = strmatch
local strtrim = strtrim
local strsplit = strsplit
local strjoin = strjoin
local gmatch = gmatch
local gsub = gsub
local wipe = wipe
local pairs = pairs
local ipairs = ipairs
local type = type
local unpack = unpack
local strutf8lower = string.utf8lower
local strutf8sub = string.utf8sub
local GetInventoryItemLink = GetInventoryItemLink
local IsUsableSpell = IsUsableSpell
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetTalentInfo = GetTalentInfo
local GetInventoryItemID = GetInventoryItemID
local GetSpellInfo = GetSpellInfo
local GetCVarBool = GetCVarBool

-- Cached GetItemInfo
local GetItemInfoCached = setmetatable({}, { __index = function(self, n)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture, itemSellValue = GetItemInfo(n)
  if itemName then
      -- store in cache only if it exists in the local cache
      self[n] = {itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture, itemSellValue}
      return self[n] -- return result
  end
end })
local GetItemInfo = function(item)
  local info = GetItemInfoCached[item]
  if info then
    return unpack(info)
  end
end
StatLogic.GetItemInfo = GetItemInfo

-- taken from lua programming gems
local function memoize(f)
  local mem = {} -- memoizing table
  return function(x)
    if not mem[x] then
      mem[x] = f(x)
    end
    return mem[x]
  end
end
local loadstring = memoize(loadstring)

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

-- Taken from AceLibrary
function StatLogic:argCheck(arg, num, kind, kind2, kind3, kind4, kind5)
  if type(num) ~= "number" then
    return error(self, "Bad argument #3 to `argCheck' (number expected, got %s)", type(num))
  elseif type(kind) ~= "string" then
    return error(self, "Bad argument #4 to `argCheck' (string expected, got %s)", type(kind))
  end
  arg = type(arg)
  if arg ~= kind and arg ~= kind2 and arg ~= kind3 and arg ~= kind4 and arg ~= kind5 then
    local stack = debugstack()
    local func = stack:match("`argCheck'.-([`<].-['>])")
    if not func then
      func = stack:match("([`<].-['>])")
    end
    if kind5 then
      return error(self, "Bad argument #%s to %s (%s, %s, %s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, kind4, kind5, arg)
    elseif kind4 then
      return error(self, "Bad argument #%s to %s (%s, %s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, kind4, arg)
    elseif kind3 then
      return error(self, "Bad argument #%s to %s (%s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, arg)
    elseif kind2 then
      return error(self, "Bad argument #%s to %s (%s or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, arg)
    else
      return error(self, "Bad argument #%s to %s (%s expected, got %s)", tonumber(num) or 0/0, func, kind, arg)
    end
  end
end



--[[---------------------------------
  :GetClassIdOrName(class)
-------------------------------------
Notes:
  * Converts ClassID to and from "ClassName"
  * class:
  :{| class="wikitable"
  !ClassID!!"ClassName"
  |-
  |1||"WARRIOR"
  |-
  |2||"PALADIN"
  |-
  |3||"HUNTER"
  |-
  |4||"ROGUE"
  |-
  |5||"PRIEST"
  |-
  |6||"DEATHKNIGHT"
  |-
  |7||"SHAMAN"
  |-
  |8||"MAGE"
  |-
  |9||"WARLOCK"
  |-
  |10||"DRUID"
  |}
Arguments:
  number or string - ClassID or "ClassName"
Returns:
  None
Example:
  StatLogic:GetClassIdOrName("WARRIOR") -- 1
  StatLogic:GetClassIdOrName(10) -- "DRUID"
-----------------------------------]]

local ClassNameToID = {
  "WARRIOR",
  "PALADIN",
  "HUNTER",
  "ROGUE",
  "PRIEST",
  "DEATHKNIGHT",
  "SHAMAN",
  "MAGE",
  "WARLOCK",
  "DRUID",
  ["WARRIOR"] = 1,
  ["PALADIN"] = 2,
  ["HUNTER"] = 3,
  ["ROGUE"] = 4,
  ["PRIEST"] = 5,
  ["DEATHKNIGHT"] = 6,
  ["SHAMAN"] = 7,
  ["MAGE"] = 8,
  ["WARLOCK"] = 9,
  ["DRUID"] = 10,
}

function StatLogic:GetClassIdOrName(class)
  return ClassNameToID[class]
end

--[[ Interface\FrameXML\PaperDollFrame.lua
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
CR_ARMOR_PENETRATION = 25;
--]]

local RatingNameToID
RatingNameToID = {
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
  [COMBAT_RATING_RESILIENCE_CRIT_TAKEN] = "MELEE_CRIT_AVOID_RATING",
  [COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN] = "RANGED_CRIT_AVOID_RATING",
  [CR_CRIT_TAKEN_SPELL] = "SPELL_CRIT_AVOID_RATING",
  [CR_HASTE_MELEE] = "MELEE_HASTE_RATING",
  [CR_HASTE_RANGED] = "RANGED_HASTE_RATING",
  [CR_HASTE_SPELL] = "SPELL_HASTE_RATING",
  [CR_WEAPON_SKILL_MAINHAND] = "MAINHAND_WEAPON_RATING",
  [CR_WEAPON_SKILL_OFFHAND] = "OFFHAND_WEAPON_RATING",
  [CR_WEAPON_SKILL_RANGED] = "RANGED_WEAPON_RATING",
  [CR_EXPERTISE] = "EXPERTISE_RATING",
  [CR_ARMOR_PENETRATION] = "ARMOR_PENETRATION_RATING",
  [CR_MASTERY] = "MASTERY_RATING",
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
  ["MELEE_CRIT_AVOID_RATING"] = COMBAT_RATING_RESILIENCE_CRIT_TAKEN,
  ["RANGED_CRIT_AVOID_RATING"] = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN,
  ["SPELL_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_SPELL,
  ["RESILIENCE_RATING"] = COMBAT_RATING_RESILIENCE_CRIT_TAKEN,
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
  ["ARMOR_PENETRATION_RATING"] = CR_ARMOR_PENETRATION,
  ["MASTERY_RATING"] = CR_MASTERY,
}

--[[---------------------------------
  :GetRatingIdOrName(rating)
-------------------------------------
Notes:
  * Converts RatingID to and from "StatID"
  * rating:
  :;RatingID : number - As defined in PaperDollFrame.lua of Blizzard default ui
  :;"StatID" : string - The the key values of the DisplayLocale table in StatLogic
  :{| class="wikitable"
  !RatingID!!"StatID"
  |-
  |CR_WEAPON_SKILL||"WEAPON_RATING"
  |-
  |CR_DEFENSE_SKILL||"DEFENSE_RATING"
  |-
  |CR_DODGE||"DODGE_RATING"
  |-
  |CR_PARRY||"PARRY_RATING"
  |-
  |CR_BLOCK||"BLOCK_RATING"
  |-
  |CR_HIT_MELEE||"MELEE_HIT_RATING"
  |-
  |CR_HIT_RANGED||"RANGED_HIT_RATING"
  |-
  |CR_HIT_SPELL||"SPELL_HIT_RATING"
  |-
  |CR_CRIT_MELEE||"MELEE_CRIT_RATING"
  |-
  |CR_CRIT_RANGED||"RANGED_CRIT_RATING"
  |-
  |CR_CRIT_SPELL||"SPELL_CRIT_RATING"
  |-
  |CR_HIT_TAKEN_MELEE||"MELEE_HIT_AVOID_RATING"
  |-
  |CR_HIT_TAKEN_RANGED||"RANGED_HIT_AVOID_RATING"
  |-
  |CR_HIT_TAKEN_SPELL||"SPELL_HIT_AVOID_RATING"
  |-
  |CR_CRIT_TAKEN_MELEE||"MELEE_CRIT_AVOID_RATING"
  |-
  |CR_CRIT_TAKEN_RANGED||"RANGED_CRIT_AVOID_RATING"
  |-
  |CR_CRIT_TAKEN_SPELL||"SPELL_CRIT_AVOID_RATING"
  |-
  |CR_HASTE_MELEE||"MELEE_HASTE_RATING"
  |-
  |CR_HASTE_RANGED||"RANGED_HASTE_RATING"
  |-
  |CR_HASTE_SPELL||"SPELL_HASTE_RATING"
  |-
  |CR_WEAPON_SKILL_MAINHAND||"MAINHAND_WEAPON_RATING"
  |-
  |CR_WEAPON_SKILL_OFFHAND||"OFFHAND_WEAPON_RATING"
  |-
  |CR_WEAPON_SKILL_RANGED||"RANGED_WEAPON_RATING"
  |-
  |CR_EXPERTISE||"EXPERTISE_RATING"
  |-
  |CR_ARMOR_PENETRATION||"ARMOR_PENETRATION_RATING"
  |}
Arguments:
  number or string - RatingID or "StatID"
Returns:
  None
Example:
  StatLogic:GetRatingIdOrStatId("CR_WEAPON_SKILL") -- 1
  StatLogic:GetRatingIdOrStatId("DEFENSE_RATING") -- 2
  StatLogic:GetRatingIdOrStatId("DODGE_RATING") -- 3
  StatLogic:GetRatingIdOrStatId(CR_PARRY) -- "PARRY_RATING"
-----------------------------------]]
function StatLogic:GetRatingIdOrStatId(rating)
  return RatingNameToID[rating]
end

local RatingIDToConvertedStat
RatingIDToConvertedStat = {
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
  "PLAYER_DAMAGE_TAKEN",
  "SPELL_CRIT_AVOID",
  "MELEE_HASTE",
  "RANGED_HASTE",
  "SPELL_HASTE",
  "WEAPON_SKILL",
  "WEAPON_SKILL",
  "WEAPON_SKILL",
  "EXPERTISE",
  "ARMOR_PENETRATION",
  "MASTERY",
}

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

local function GetStanceIcon()
  local currentStance = GetShapeshiftForm()
  if currentStance ~= 0 then
    return GetShapeshiftFormInfo(currentStance)
  end
end
StatLogic.GetStanceIcon = GetStanceIcon

local function PlayerHasAura(aura)
  return UnitBuff("player", aura or "") or UnitDebuff("player", aura or "")
end
StatLogic.PlayerHasAura = PlayerHasAura


local function GetPlayerAuraRankStack(buff)
  --name, rank, icon, stack, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", buff)
  local name, rank, _, stack = UnitBuff("player", buff)
  if not name then -- if not a buff, check for debuff
    name, rank, _, stack = UnitDebuff("player", buff)
  end
  if name then
    if not stack or stack == 0 then
      stack = 1
    end
    return tonumber(strmatch(rank, "(%d+)") or 1), stack
  end
end
StatLogic.GetPlayerAuraRankStack = GetPlayerAuraRankStack

local function GetTotalDefense(unit)
  local base, modifier = UnitDefense(unit);
  return base + modifier
end

local function PlayerHasGlyph(glyph, talentGroup)
  for i = 1, 9 do
    local _, _, _, glyphSpellID = GetGlyphSocketInfo(i, talentGroup)
    if glyphSpellID == glyph then
      return true
    end
  end
end
StatLogic.PlayerHasGlyph = PlayerHasGlyph

---------------
-- Item Sets --
---------------
local SetToItem -- SetID comes from ItemSet.dbc
SetToItem = {
  [571] = {24264, 24261}, -- Whitemend Wisdom - Increases spell power by 10% of your total Intellect.
  [552] = {21848, 21847, 21846}, -- Wrath of Spellfire - Increases spell power by 7% of your total Intellect.
}
-- Build ItemToSet from SetToItem
local ItemToSet = {}
for set, items in pairs(SetToItem) do
  for _, item in pairs(items) do
    ItemToSet[item] = set
  end
end

-- Create a frame
local ItemSetFrame = StatLogic.ItemSetFrame
if not ItemSetFrame then
  ItemSetFrame = CreateFrame("Frame", "StatLogicItemSetFrame")
  StatLogic.ItemSetFrame = ItemSetFrame
else
  ItemSetFrame:UnregisterAllEvents()
end

--[[
PlayerItemSets = {
  [844] = 4,
}
--]]
local PlayerItemSets = {}
-- API
function StatLogic:PlayerHasItemSet(itemset)
  return PlayerItemSets[itemset]
end
-- Don't set any scripts if the class doesn't have any sets to check
if table.maxn(ItemToSet) ~= 0 then
  local WatchInventoryID = {
    (GetInventorySlotInfo("HeadSlot")),
    (GetInventorySlotInfo("ShoulderSlot")),
    (GetInventorySlotInfo("ChestSlot")),
    (GetInventorySlotInfo("HandsSlot")),
    (GetInventorySlotInfo("LegsSlot")),
  }
  local function UpdatePlayerItemSets()
    wipe(PlayerItemSets)
    for _, slot in pairs(WatchInventoryID) do
      local set = ItemToSet[GetInventoryItemID('player', slot)]
      if set then
        PlayerItemSets[set] = (PlayerItemSets[set] or 0) + 1
      end
    end
  end
  -- we will schedule this since PLAYER_EQUIPMENT_CHANGED fires multiple times when you switch whole sets
  ItemSetFrame:SetScript("OnUpdate", function(self, elapsed)
    if self.updateTime and (GetTime() >= self.updateTime) then
      self.updateTime = nil
      UpdatePlayerItemSets()
    end
  end)
  ItemSetFrame:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
  ItemSetFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
  function ItemSetFrame:PLAYER_EQUIPMENT_CHANGED()
    self.updateTime = GetTime() + 0.1 -- 0.1 sec delay
  end
  -- Initialize on PLAYER_LOGIN
  if (IsLoggedIn()) then -- LOD
    UpdatePlayerItemSets()
  else
    ItemSetFrame:RegisterEvent("PLAYER_LOGIN")
    function ItemSetFrame:PLAYER_LOGIN()
      UpdatePlayerItemSets()
    end
  end
end

--================================--
-- Armor Specialization Detection --
--================================--
local ArmorSpecClasses = {
  ["WARRIOR"] = L["Plate"],
  ["PALADIN"] = L["Plate"],
  ["DEATHKNIGHT"] = L["Plate"],
  ["HUNTER"] = L["Mail"],
  ["SHAMAN"] = L["Mail"],
  ["ROGUE"] = L["Leather"],
  ["DRUID"] = L["Leather"],
}

-- Create a frame
local ArmorSpecFrame = StatLogic.ArmorSpecFrame
if not ArmorSpecFrame then
  ArmorSpecFrame = CreateFrame("Frame", "StatLogicItemSetFrame")
  StatLogic.ArmorSpecFrame = ArmorSpecFrame
else
  ArmorSpecFrame:UnregisterAllEvents()
end

-- ArmorSpecActive =
-- nil: You have an empty or non-spec armor slot
-- 0: Appropreate armor in all slots but unspeced
-- 1, 2, 3: Appropreate armor in all slots, then its your GetPrimaryTalentTree()
local ArmorSpecActive = nil
local playerArmorType = ArmorSpecClasses[playerClass]
-- Don't set any scripts if cloth class
if playerArmorType then
  -- All 8 slots needs to have something equipped in order to receive the bonus
  local WatchInventoryID = {
    (GetInventorySlotInfo("HeadSlot")),
    (GetInventorySlotInfo("ShoulderSlot")),
    (GetInventorySlotInfo("ChestSlot")),
    (GetInventorySlotInfo("WristSlot")),
    (GetInventorySlotInfo("HandsSlot")),
    (GetInventorySlotInfo("WaistSlot")),
    (GetInventorySlotInfo("LegsSlot")),
    (GetInventorySlotInfo("FeetSlot")),
  }
  local function UpdateArmorSpecActive()
    ArmorSpecActive = nil
    for _, slot in pairs(WatchInventoryID) do
      local item = GetInventoryItemID('player', slot)
      if not item then return end
      if (select(7, GetItemInfo(item))) ~= playerArmorType then return end
    end
    -- all pass
    ArmorSpecActive = GetPrimaryTalentTree() or 0
  end
  -- we will schedule this since PLAYER_EQUIPMENT_CHANGED fires multiple times when you switch whole sets
  ArmorSpecFrame:SetScript("OnUpdate", function(self, elapsed)
    if self.updateTime and (GetTime() >= self.updateTime) then
      self.updateTime = nil
      UpdateArmorSpecActive()
    end
  end)
  ArmorSpecFrame:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
  ArmorSpecFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
  ArmorSpecFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
  function ArmorSpecFrame:PLAYER_EQUIPMENT_CHANGED()
    self.updateTime = GetTime() + 0.1 -- 0.1 sec delay
  end
  function ArmorSpecFrame:PLAYER_TALENT_UPDATE()
    self.updateTime = GetTime() + 0.1 -- 0.1 sec delay
  end
  -- Initialize on PLAYER_LOGIN
  if (IsLoggedIn()) then -- LOD
    UpdateArmorSpecActive()
  else
    ArmorSpecFrame:RegisterEvent("PLAYER_LOGIN")
    function ArmorSpecFrame:PLAYER_LOGIN()
      UpdateArmorSpecActive()
    end
  end
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
-- Stat Mods from Talents and Buffs --
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

"ADD_DODGE", -- Used in StatLogic:GetDodgePerAgi()
--"ADD_PARRY",
--"ADD_BLOCK",
--"ADD_STEALTH_DETECT",
--"ADD_STEALTH",
--"ADD_DEFENSE",
--"ADD_THREAT", school,
"ADD_HIT_TAKEN", school,
"ADD_CRIT_TAKEN", school,

--Talents
"ADD_AP_MOD_STA" -- Hunter: Hunter vs. Wild
"ADD_AP_MOD_ARMOR" -- Death Knight: Bladed Armor
"ADD_AP_MOD_INT" -- Shaman: Mental Dexterity
"ADD_PARRY_RATING_MOD_STR" -- Death Knight: Forceful Deflection - Passive
"ADD_SPELL_CRIT_RATING_MOD_SPI" -- Mage: Molten Armor - 3.1.0
"ADD_COMBAT_MANA_REGEN_MOD_INT"
"ADD_RANGED_AP_MOD_INT"
"ADD_ARMOR_MOD_INT"
"ADD_SPELL_DMG_MOD_STR" -- Paladin: Touched by the Light
"ADD_SPELL_DMG_MOD_STA"
"ADD_SPELL_DMG_MOD_INT"
"ADD_SPELL_DMG_MOD_SPI"
"ADD_SPELL_DMG_MOD_AP" -- Shaman: Mental Quickness, Paladin: Sheath of Light
"ADD_HEAL_MOD_STR" -- Paladin: Touched by the Light
"ADD_HEAL_MOD_AGI"
"ADD_HEAL_MOD_STA"
"ADD_HEAL_MOD_INT"
"ADD_HEAL_MOD_SPI"
"ADD_HEAL_MOD_AP" -- Shaman: Mental Quickness
"ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"
"MOD_AP"
"MOD_RANGED_AP"
"MOD_SPELL_DMG"
"MOD_HEAL"

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
  ["ADD_BLOCK_REDUCTION"] = { -- Meta Gems
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_AP_MOD_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_AP_MOD_STA"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_AP_MOD_ARMOR"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_PARRY_RATING_MOD_STR"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_CRIT_RATING_MOD_SPI"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_HIT_RATING_MOD_SPI"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_RANGED_AP_MOD_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_ARMOR_MOD_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_AP"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_STR"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_STA"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_SPI"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_PET_STA"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_PET_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_SPELL_DMG_MOD_MANA"] = { -- Improved Mana Gem
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_AP"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_STR"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_AGI"] = { -- Nurturing Instinct
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_STA"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_INT"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_SPI"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_HEAL_MOD_MANA"] = { -- Improved Mana Gem
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_COMBAT_MANA_REGEN_MOD_INT"] = { -- deprecated
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_COMBAT_MANA_REGEN_MOD_MANA"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"] = {
    initialValue = 0,
    finalAdjust = 0,
  },
  ["ADD_PET_STA_MOD_STA"] = {
    initialValue = 1,
    finalAdjust = -1,
  },
  ["ADD_PET_INT_MOD_INT"] = {
    initialValue = 1,
    finalAdjust = -1,
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
    initialValue = 1,
    finalAdjust = 0,
  },
  ["MOD_AGI"] = {
    initialValue = 1,
    finalAdjust = 0,
  },
  ["MOD_STA"] = {
    initialValue = 1,
    finalAdjust = 0,
  },
  ["MOD_INT"] = {
    initialValue = 1,
    finalAdjust = 0,
  },
  ["MOD_SPI"] = {
    initialValue = 1,
    finalAdjust = 0,
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
  ["MOD_HEAL"] = {
    initialValue = 0,
    finalAdjust = 1,
  },
  ["MOD_MELEE_HASTE"] = {
    initialValue = 1,
    finalAdjust = 0,
  },
  ["MOD_SPELL_HASTE"] = {
    initialValue = 1,
    finalAdjust = 0,
  },
}
StatLogic.StatModInfo = StatModInfo -- so other addons can use this directly
StatLogic.SpellSchools = {
  "MELEE",
  "RANGED",
  "HOLY",
  "FIRE",
  "NATURE",
  "FROST",
  "SHADOW",
  "ARCANE",
}
------------------
-- StatModTable --
------------------
--[[ How to add a glyph support?
1. Go to the glyph item on wowhead.
2. Click on the green Use: TEXT on the "tooltip" to go to a spell page.
3. Click on "See also" tab for a spell with a gear icon, the spell id for this page is what you put in here.
--]]
--[[ How can I get aura data?
1. /dump UnitAura("player",1)
--]]
local StatModTable = {}
StatLogic.StatModTable = StatModTable -- so other addons can use this directly
if playerClass == "DRUID" then
  StatModTable["DRUID"] = {
    -- Druid: Nurturing Instinct (Rank 2) - 2,14
    -- 4.0.1: 2,14: Increases your healing spells by up to 35%/70% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
    -- 4.0.6: 2,14: Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
    ["ADD_HEAL_MOD_AGI"] = {
      {
        ["spellid"] = 33873,
        ["tab"] = 2,
        ["num"] = 14,
        ["rank"] = {
          0.50, 1,
        },
      },
    },
    -- Healers: Meditation
    -- 4.0.1: Allows 50% of your mana regeneration from Spirit to continue while in combat.
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"] = {
      {
        ["rank"] = {
          0.50,
        },
        ["known"] = 85101, -- ["Meditation"]
      },
    },
    -- Druid: Feral Swiftness (Rank 2) - 2,1
    -- 4.0.1: Increases your chance to dodge while in Cat Form or Bear Form by 2/4%
    -- Druid: Natural Reaction (Rank 2) - 2,18
    -- 4.0.1: Reduces damage taken while in Bear Form by 6/12%, increases your dodge while in Bear Form by 3/6%, and you generate 1/3 rage every time you dodge while in Bear Form.
    ["ADD_DODGE"] = {
      {-- Feral Swiftness
        ["tab"] = 2,
        ["num"] = 1,
        ["rank"] = {
          2, 4,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Feral Swiftness
        ["tab"] = 2,
        ["num"] = 1,
        ["rank"] = {
          2, 4,
        },
        ["buff"] = 768,        -- ["Cat Form"],
      },
      {-- Natural Reaction
        ["tab"] = 2,
        ["num"] = 18,
        ["rank"] = {
          3, 6,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
    },
    -- Druid: Glyph of Barkskin
    -- 4.0.1: Reduces the chance you'll be critically hit by melee attacks by 25% while Barkskin is active.
    -- Druid: Thick Hide (Rank 3) - 2,11
    -- 4.0.1: Increases your Armor contribution from cloth and leather items by 4/7/10%, increases armor while in Bear Form by an additional 11/22/33%, and reduces the chance you'll be critically hit by melee attacks by 2/4/6%.
    -- Druid: Survival of the Fittest (Rank 3) - 2,18
    -- 4.0.1: Increases all attributes by 2%/4%/6% and reduces the chance you'll be critically hit by melee attacks by 2%/4%/6%.
    ["ADD_CRIT_TAKEN"] = {
      {-- Glyph of Barkskin
        ["MELEE"] = true,
        ["rank"] = {
          -0.25,
        },
        ["buff"] = 22812,        -- ["Barkskin"],
        ["glyph"] = 63057,
      },
      {-- Thick Hide
        ["MELEE"] = true,
        ["tab"] = 2,
        ["num"] = 11,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
      },
    },
    -- Druid: Balance of Power (Rank 2) - 1,6
    -- 4.0.1: Increases your spell hit rating by an additional amount equal to 50/100% of your Spirit.
    ["ADD_SPELL_HIT_RATING_MOD_SPI"] = {
      {
        ["spellid"] = 33596,
        ["tab"] = 1,
        ["num"] = 6,
        ["rank"] = {
          0.5, 1,
        },
      },
    },
    -- Druid: Enrage - Buff: 5229
    -- 4.0.1: Physical damage taken increased by 10%.
    -- Druid: Perseverance - Rank 3/3 - Talent: 3,5
    -- 4.0.1: Reduces all spell damage taken by 2/4/6%.
    -- Druid: Barkskin - Buff
    -- 4.0.1: All damage taken is reduced by 20%.
    -- Druid: Improved Barkskin (Rank 2) - 3,25
    -- 4.0.1: Increases the damage reduction granted by your Barkskin spell by 5/10%
    -- Druid: Natural Reaction (Rank 2) - 2,18
    -- 4.0.1: Reduces damage taken while in Bear Form by 6/12%, increases your dodge while in Bear Form by 3/6%, and you generate 1/3 rage every time you dodge while in Bear Form.
    -- Druid: Survival Instincts - Buff
    -- 4.0.1: Damage taken reduced by 60% while in Bear Form or Cat Form.
    -- 4.0.6: Damage taken reduced by 50% while in Bear Form or Cat Form.
    -- Druid: Moonkin Form - Buff
    -- 4.0.1: Armor contribution from items is increased by 120%.
    -- 4.0.6: All damage reduced by 15%.
    ["MOD_DMG_TAKEN"] = {
      {-- Enrage
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          0.1,
        },
        ["buff"] = 5229,        -- ["Enrage"],
      },
      {-- Perseverance
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 3,
        ["num"] = 5,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
      },
      {-- Natural Reaction
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 2,
        ["num"] = 18,
        ["rank"] = {
          -0.06, -0.12,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Barkskin
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
        ["buff"] = 22812,        -- ["Barkskin"],
      },
      {-- Survival Instincts - Bear
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.5,
        },
        ["buff"] = 61336,        -- ["Survival Instincts"],
        ["buff2"] = 5487,        -- ["Bear Form"],
      },
      {-- Survival Instincts - Cat
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.5,
        },
        ["buff"] = 61336,        -- ["Survival Instincts"],
        ["buff2"] = 768,        -- ["Cat Form"],
      },
      {-- Moonkin Form - Buff
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.15,
        },
        ["buff"] = 24858,        -- ["Moonkin Form"],
      },
    },
    -- Druid: Thick Hide (Rank 3) - 2,11
    -- 4.0.1: Increases your Armor contribution from cloth and leather items by 4/7/10%, increases armor while in Bear Form by an additional 11/22/33%, and reduces the chance you'll be critically hit by melee attacks by 2/4/6%.
    -- Druid: Bear Form - Buff
    -- 4.0.1: Increases melee attack power by 30, armor contribution from cloth and leather items by 65%/120%, and Stamina by 25%.  Also causes agility to increase attack power.
    -- Druid: Tree of Life - Buff
    -- 4.0.1: Armor increased by 120%.
    ["MOD_ARMOR"] = {
      {-- Thick Hide
        ["tab"] = 2,
        ["num"] = 11,
        ["rank"] = {
          0.04, 0.07, 0.1,
        },
      },
      {-- Thick Hide
        ["tab"] = 2,
        ["num"] = 11,
        ["rank"] = {
          0.11, 0.22, 0.33,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Bear Form < lv40
        ["rank"] = {
          0.65,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Bear Form >= lv40
        ["rank"] = {
          0.333333333333333333, -- 1.65 * 1.3333 = 2.2
        },
        ["buff"] = 5487,        -- ["Bear Form"],
        ["condition"] = "UnitLevel('player') >= 40",
      },
      {
        ["rank"] = {
          1.2,
        },
        ["buff"] = 33891,        -- ["Tree of Life"],
      },
    },
    -- Druid: Furor (Rank 3) - 2,2
    -- 4.0.1: Increases your maximum mana by 5/10/15%.
    ["MOD_MANA"] = {
      {
        ["tab"] = 2,
        ["num"] = 2,
        ["rank"] = {
          0.05, 0.1, 0.15,
        },
      },
    },
    -- Druid: Leather Specialization - Passive: 86530
    -- 4.0.1: Increases your primary attribute by 5% while wearing Leather in all armor slots.  Balance specialization grants Intellect, Feral specialization grants Agility while in Cat Form and Stamina while in Bear Form, and Restoration specialization grants Intellect.
    -- Druid: Heart of the Wild (Rank 5) - 3,4
    -- 4.0.1: Increases your Intellect by 2/4/6%. In addition, while in Bear Form your Stamina is increased by 3/7/10% and while in Cat Form your attack power is increased by 3/7/10%.
    -- Druid: Bear Form - Buff
    -- 4.0.1: Increases melee attack power by 30, armor contribution from cloth and leather items by 65%/120%, and Stamina by 25%.  Also causes agility to increase attack power.
    ["MOD_STA"] = {
      {-- Heart of the Wild: +2/4/6/8/10% stamina in bear / dire bear
        ["tab"] = 3,
        ["num"] = 4,
        ["rank"] = {
          0.03, 0.07, 0.1,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Bear Form
        ["rank"] = {
          0.25,
        },
        ["buff"] = 5487,        -- ["Bear Form"],
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["armorspec"] = 2,
        ["known"] = 86530,
        ["buff"] = 5487,        -- ["Bear Form"],
      },
    },
    -- Druid: Leather Specialization - Passive: 86530
    -- 4.0.1: Increases your primary attribute by 5% while wearing Leather in all armor slots.  Balance specialization grants Intellect, Feral specialization grants Agility while in Cat Form and Stamina while in Bear Form, and Restoration specialization grants Intellect.
    ["MOD_AGI"] = {
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["armorspec"] = 2,
        ["known"] = 86530,
        ["buff"] = 768,        -- ["Cat Form"],
      },
    },
    -- Druid: Heart of the Wild (Rank 5) - 3,4
    -- 4.0.1: Increases your Intellect by 2/4/6%. In addition, while in Bear Form your Stamina is increased by 3/7/10% and while in Cat Form your attack power is increased by 3/7/10%.
    -- Druid: Aggression - Passive: 84735
    -- 4.0.1: Increases your attack power by 25%.
    ["MOD_AP"] = {
      {
        ["tab"] = 3,
        ["num"] = 4,
        ["rank"] = {
          0.03, 0.07, 0.1,
        },
        ["buff"] = 768,        -- ["Cat Form"],
      },
      {
        ["rank"] = {
          0.25,
        },
        ["known"] = 84735, -- ["Aggression"]
      },
    },
    -- Druid: Leather Specialization - Passive: 86530
    -- 4.0.1: Increases your primary attribute by 5% while wearing Leather in all armor slots.  Balance specialization grants Intellect, Feral specialization grants Agility while in Cat Form and Stamina while in Bear Form, and Restoration specialization grants Intellect.
    -- Druid: Heart of the Wild (Rank 5) - 3,4
    -- 4.0.1: Increases your Intellect by 2/4/6%. In addition, while in Bear Form your Stamina is increased by 3/7/10% and while in Cat Form your attack power is increased by 3/7/10%.
    ["MOD_INT"] = {
      {
        ["tab"] = 3,
        ["num"] = 4,
        ["rank"] = {
          0.02, 0.04, 0.06,
        },
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86530,
        ["armorspec"] = 1,
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86530,
        ["armorspec"] = 3,
      },
    },
  }
elseif playerClass == "DEATHKNIGHT" then
  StatModTable["DEATHKNIGHT"] = {
    -- Death Knight: Icy Talons - Passive: 50887
    -- 4.0.6: Your melee attack speed is increased by 20%.
    -- Death Knight: Improved Icy Talons - Rank 1/1 - 2,13
    -- 4.0.6: Increases the melee and ranged attack speed of all party and raid 
    --        members within 100 yards by 10%, and your own attack speed by an additional 5%.
    -- Death Knight: Unholy Presence - Stance
    -- 4.0.6: Attack speed and rune regeneration increased 10%.
    -- Death Knight: Improved Unholy Presence - Rank 2/2 - 3,16
    -- 4.0.6: Grants you an additional 2/5% haste while in Unholy Presence. 
    ["MOD_MELEE_HASTE"] = {
      {-- Icy Talons
        ["rank"] = {
          0.2,
        },
        ["known"] = 50887,
      },
      {-- Improved Icy Talons
        ["tab"] = 2,
        ["num"] = 13,
        ["rank"] = {
          0.05,
        },
      },
      {-- Unholy Presence and Improved Unholy Presence
        ["tab"] = 3,
        ["num"] = 16,
        ["rank"] = {
          [0] = 0.1, 0.12, 0.15,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
      },
    },
    -- Tanks: Forceful Deflection - Passive
    -- 4.0.1: Increases your Parry Rating by 25% of your total Strength.
    -- 4.2.0: Increases your Parry Rating by 27% of your total Strength.
    ["ADD_PARRY_RATING_MOD_STR"] = {
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.25,
        },
        ["old"] = 14333, -- 4.2.0
      },
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.27,
        },
        ["new"] = 14333, -- 4.2.0
      },
    },
    -- Death Knight: Bladed Armor - Rank 3/3 - 1,3
    -- 4.0.1: Increases your attack power by 2/4/6 for every 180 armor value you have.
    ["ADD_AP_MOD_ARMOR"] = {
      {
        ["spellid"] = 49391,
        ["tab"] = 1,
        ["num"] = 3,
        ["rank"] = {
          2/180, 4/180, 6/180,
        },
      },
    },
    -- Death Knight: Improved Blood Presence - Rank 2/2 - Talent: 1,14 - Stance
    -- 4.0.1: Reduces the chance that you will be critically hit by melee attacks while in Blood Presence by 3/6%. In addition, while in Frost Presence or Unholy Presence, you retain 2/4% damage reduction from Blood Presence.
    ["ADD_CRIT_TAKEN"] = {
      {-- Improved Blood Presence
        ["MELEE"] = true,
        ["tab"] = 1,
        ["num"] = 14,
        ["rank"] = {
          -0.03, -0.06,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
      },
    },
    -- Death Knight: Blade Barrier - Rank 3/3 - Talent: 1,2 - Buff: 64856
    -- 4.0.1: 2/4/6% less damage taken.
    -- Death Knight: Icebound Fortitude - Buff: 48792
    -- 4.0.1: Damage taken reduced by 30%.
    -- 4.0.3: Damage taken reduced by 20%.
    -- Death Knight: Sanguine Fortitude - Rank 2/2 - 1,12 - Buff: 48792
    -- 4.0.1: Icebound Fortitude reduces damage taken by an additional 15/30%
    -- Death Knight: Bone Shield - Buff: 49222
    -- 4.0.1: Damage reduced by 20%.
    -- Death Knight: Anti-Magic Shell - Buff: 48707
    -- 4.0.1: Spell damage reduced by 75%.
    -- Death Knight: Blood Presence - Stance
    -- 4.0.1: Stamina increased by 8%.
    --        Armor contribution from cloth, leather, mail and plate items increased by 60%.
    --        Damage taken reduced by 8%.
    -- Death Knight: Improved Blood Presence - Rank 2/2 - Talent: 1,14 - Stance
    -- 4.0.1: Reduces the chance that you will be critically hit by melee attacks while in Blood Presence by 3/6%. In addition, while in Frost Presence or Unholy Presence, you retain 2/4% damage reduction from Blood Presence.
    -- Death Knight: Will of the Necropolis - Rank 3/3 - 1,15 - Buff: 81162
    -- 4.0.1: Damage taken reduced by 8/16/25%
    -- Enchant: Rune of Spellshattering - EnchantID: 3367
    -- 4.0.1: Deflects 4% of all spell damage to 2h weapon
    -- Enchant: Rune of Spellbreaking - EnchantID: 3595
    -- 4.0.1: Deflects 2% of all spell damage to 1h weapon
    ["MOD_DMG_TAKEN"] = {
      {-- Blade Barrier
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 2,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
        ["buff"] = 64856,        -- ["Blade Barrier"],
      },
      {-- Icebound Fortitude
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.20,
        },
        ["buff"] = 48792,        -- ["Icebound Fortitude"],
      },
      {-- Sanguine Fortitude
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 12,
        ["rank"] = {
          -0.15, -0.30,
        },
        ["buff"] = 48792,        -- ["Icebound Fortitude"],
      },
      {-- Bone Shield
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.20,
        },
        ["buff"] = 49222,        -- ["Bone Shield"],
      },
      {-- Anti-Magic Shell
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.75,
        },
        ["buff"] = 48707,        -- ["Anti-Magic Shell"],
      },
      {-- Blood Presence
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.08,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
      },
      {-- Improved Blood Presence
        ["tab"] = 1,
        ["num"] = 14,
        ["rank"] = {
          -0.02, -0.04,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
      },
      {-- Improved Blood Presence
        ["tab"] = 1,
        ["num"] = 14,
        ["rank"] = {
          -0.02, -0.04,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
      },
      {-- Will of the Necropolis
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 15,
        ["rank"] = {
          -0.08, -0.16, -0.25,
        },
        ["buff"] = 81162,        -- ["Will of the Necropolis"],
      },
      {-- Rune of Spellshattering
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.04,
        },
        ["slot"] = 16, -- main hand slot
        ["enchant"] = 3367,
      },
      {-- Rune of Spellbreaking
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.02,
        },
        ["slot"] = 16, -- main hand slot
        ["enchant"] = 3595,
      },
      {-- Rune of Spellbreaking
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.02,
        },
        ["slot"] = 17, -- off hand slot
        ["enchant"] = 3595,
      },
    },
    -- Death Knight: Toughness - Rank 3/3 - 1,10
    -- 4.0.1: Increases your armor value from items by 3/7/10%.
    -- Death Knight: Blood Presence - Stance
    -- 4.0.1: Stamina increased by 8%.
    --        Armor contribution from cloth, leather, mail and plate items increased by 60%.
    --        Damage taken reduced by 8%.
    -- Enchant: Rune of the Stoneskin Gargoyle - EnchantID: 3847
    -- 4.0.1: +4% Armor and +2% Stamina to 2h weapon
    -- Enchant: Rune of the Nerubian Carapace - EnchantID: 3883
    -- 4.0.1: +2% Armor and +1% Stamina to 1h weapon
    ["MOD_ARMOR"] = {
      {-- Blood Presence
        ["rank"] = {
          0.6,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
      },
      {-- Toughness
        ["tab"] = 1,
        ["num"] = 10,
        ["rank"] = {
          0.03, 0.07, 0.1,
        },
      },
    },
    -- Death Knight: Vampiric Blood - Buff: 55233
    -- 4.0.1: Maximum health increased by 15%
    -- Death Knight: Glyph of Vampiric Blood - Glyph: 58676
    -- 4.0.1: Vampiric Blood no longer grants you health
    ["MOD_HEALTH"] = {
      {-- Vampiric Blood
        ["rank"] = {
          0.15,
        },
        ["buff"] = 55233,        -- ["Vampiric Blood"],
        ["condition"] = "not LibStub('LibStatLogic-1.2').PlayerHasGlyph(58676)", -- ["Glyph of Vampiric Blood"]
      },
    },
    -- Death Knight: Plate Specialization - Passive: 86524
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Blood specialization grants Stamina, Frost specialization grants Strength, and Unholy specialization grants Strength.
    -- Death Knight: Blood Presence - Stance
    -- 4.0.1: Stamina increased by 8%.
    --        Armor contribution from cloth, leather, mail and plate items increased by 60%.
    --        Damage taken reduced by 8%.
    -- Death Knight: Veteran of the Third War - Passive: 50029
    -- 4.0.1: Increases your total Stamina by 9% and your expertise by 6.
    -- Enchant: Rune of the Stoneskin Gargoyle - EnchantID: 3847
    -- 4.0.1: +4% Armor and +2% Stamina to 2h weapon
    -- Enchant: Rune of the Nerubian Carapace - EnchantID: 3883
    -- 4.0.1: +2% Armor and +1% Stamina to 1h weapon
    ["MOD_STA"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86524,
        ["armorspec"] = 1,
      },
      {-- Blood Presence
        ["rank"] = {
          0.08,
        },
        ["stance"] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
      },
      {-- Veteran of the Third War
        ["rank"] = {
          0.09,
        },
        ["known"] = 50029, -- ["Veteran of the Third War"]
      },
      {-- Rune of the Stoneskin Gargoyle
        ["rank"] = {
          0.02,
        },
        ["slot"] = 16, -- main hand slot
        ["enchant"] = 3847,
      },
      {-- Rune of the Nerubian Carapace
        ["rank"] = {
          0.01,
        },
        ["slot"] = 16, -- main hand slot
        ["enchant"] = 3883,
      },
      {-- Rune of the Nerubian Carapace
        ["rank"] = {
          0.01,
        },
        ["slot"] = 17, -- off hand slot
        ["enchant"] = 3883,
      },
    },
    -- Death Knight: Plate Specialization - Passive: 86524
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Blood specialization grants Stamina, Frost specialization grants Strength, and Unholy specialization grants Strength.
    -- Death Knight: Unholy Might - Passive: 91107
    -- 4.0.1: Dark power courses through your limbs, increasing your Strength by 15%.
    -- 4.0.6: Dark power courses through your limbs, increasing your Strength by 5%.
    -- 4.2.0: Dark power courses through your limbs, increasing your Strength by 20%.
    -- Death Knight: Abomination's Might - 1,11
    -- 4.0.1: Also increases your total Strength by 1%/2%.
    -- Death Knight: Pillar of Frost - Buff: 51271
    -- 4.0.1: Strength increased by 20%.
    -- Death Knight: Brittle Bones - Rank 2/2 - 2,14
    -- 4.0.1: Your Strength is increased by 2/4%
    -- Death Knight: Unholy Strength - Buff: 53365
    -- 4.0.1: Strength increased by 15%
    ["MOD_STR"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86524,
        ["armorspec"] = 2,
      },
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86524,
        ["armorspec"] = 3,
      },
      {-- Unholy Might
        ["rank"] = {
          0.05,
        },
        ["known"] = 91107, -- ["Unholy Might"]
        ["old"] = 14333, -- 4.2.0
      },
      {-- Unholy Might
        ["rank"] = {
          0.2,
        },
        ["known"] = 91107, -- ["Unholy Might"]
        ["new"] = 14333, -- 4.2.0
      },
      {-- Abomination's Might
        ["tab"] = 1,
        ["num"] = 11,
        ["rank"] = {
          0.01, 0.02,
        },
      },
      {-- Pillar of Frost
        ["rank"] = {
          0.2,
        },
        ["buff"] = 51271,        -- ["Pillar of Frost"],
      },
      {-- Brittle Bones
        ["tab"] = 2,
        ["num"] = 14,
        ["rank"] = {
          0.02, 0.04,
        },
      },
      {-- Unholy Strength
        ["rank"] = {
          0.15,
        },
        ["buff"] = 53365,        -- ["Unholy Strength"],
      },
    },
  }
elseif playerClass == "HUNTER" then
  StatModTable["HUNTER"] = {
    -- Hunter: Deterrence - Buff: 19263
    -- 4.0.6: Chance to be missed by melee attacks increased by 100%, chance for ranged attacks to miss you increased by 100%, 100% chance to deflect spells.
    ["ADD_HIT_TAKEN"] = {
      {-- Deterrence
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -1,
        },
        ["buff"] = 19263,
      },
    },
    -- Hunter: Animal Handler - Passive: 87325
    -- 4.0.1: Attack Power increased by 15%.
    -- 4.0.6: Attack Power increased by 25%.
    ["MOD_AP"] = {
      {-- Animal Handler
        ["rank"] = {
          0.25,
        },
        ["known"] = 87325, -- ["Animal Handler"]
      },
    },
    -- Hunter: Hunter vs. Wild - Rank 3/3 - 3,1
    -- 4.0.1: Increases your total Stamina by 4/7/10%.
    -- 4.0.1: Increases your total Stamina by 5/10/15%.
    ["MOD_STA"] = {
      {-- Hunter vs. Wild
        ["tab"] = 3,
        ["num"] = 1,
        ["rank"] = {
          0.05, 0.1, 0.15,
        },
      },
    },
    -- Hunter: Mail Specialization - Passive: 86528
    -- 4.0.1: Increases your Agility by 5% while wearing Mail in all armor slots
    -- Hunter: Into the Wilderness - Passive: 84729
    -- 4.0.1: Agility increased by 10%.
    -- Hunter: Hunting Party - Rank 1/1 - 3,17
    -- 4.0.1: Increases your total Agility by an additional 10%
    -- 4.0.6: Increases your total Agility by an additional 2%
    ["MOD_AGI"] = {
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86528,
        ["armorspec"] = 0,
      },
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86528,
        ["armorspec"] = 1,
      },
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86528,
        ["armorspec"] = 2,
      },
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86528,
        ["armorspec"] = 3,
      },
      {-- Into the Wilderness
        ["rank"] = {
          0.1,
        },
        ["known"] = 84729, -- ["Into the Wilderness"]
      },
      {-- Hunting Party
        ["tab"] = 3,
        ["num"] = 17,
        ["rank"] = {
          0.02,
        },
      },
    },
  }
elseif playerClass == "MAGE" then
  StatModTable["MAGE"] = {
    -- Mage: Wizardry - Passive: 89744
    -- 4.0.1: Increases your Intellect by 5%
    ["MOD_INT"] = {
      {-- Wizardry
        ["rank"] = {
          0.05,
        },
        ["known"] = 89744, -- ["Wizardry"]
      },
    },
    -- Mage: Molten Armor - Buff: 30482
    -- 4.0.1: Reduces the chance you are critically hit by 5%.
    -- Mage: Firestarter - Rank 1/1 - 2,15
    -- 4.0.1: Your Molten Armor allows you to cast the Scorch spell while moving instead of reducing the chance you are critically hit.
    ["ADD_CRIT_TAKEN"] = {
      {-- Molten Armor
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.05,
        },
        ["buff"] = 30482,        -- ["Molten Armor"],
      },
      {-- Firestarter
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 2,
        ["num"] = 15,
        ["rank"] = {
          0.05,
        },
        ["buff"] = 30482,        -- ["Molten Armor"],
      },
    },
    -- Improved Mana Gem - Rank 2/2 - 1,19 - Buff: 83098
    -- 4.0.1: Increases your spell power by 1/2% of your maximum mana
    ["ADD_SPELL_DMG_MOD_MANA"] = {
      {
        ["tab"] = 1,
        ["num"] = 19,
        ["rank"] = {
          0.01, 0.02,
        },
        ["buff"] = 83098,        -- ["Improved Mana Gem"],
      },
    },
    -- Improved Mana Gem - Rank 2/2 - 1,19 - Buff: 83098
    -- 4.0.1: Increases your spell power by 1/2% of your maximum mana
    ["ADD_HEAL_MOD_MANA"] = {
      {
        ["tab"] = 1,
        ["num"] = 19,
        ["rank"] = {
          0.01, 0.02,
        },
        ["buff"] = 83098,        -- ["Improved Mana Gem"],
      },
    },
    -- Mage: Mage Armor - Buff: 6117
    -- 4.0.1: Regenerate 3% of your maximum mana every 5 sec.
    -- Mage: Glyph of Frost Armor - Glyph: 98397 - Buff: 7302
    -- 4.1.0: Your Frost Armor also causes you to regenerate 2% of your maximum mana every 5 sec.
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA"] = {
      {-- Mage Armor
        ["rank"] = {
          0.03,
        },
        ["buff"] = 6117,        -- ["Mage Armor"],
      },
      {-- Glyph of Frost Armor
        ["rank"] = {
          0.02,
        },
        ["buff"] = 7302,        -- ["Frost Armor"],
        ["glyph"] = 98397,
        ["new"] = 13914, -- 4.1.0
      },
    },
    -- Mage: Frost Armor - Buff: 7302
    -- 4.0.1: Increases armor from items by 20%.
    ["MOD_ARMOR"] = {
      {-- Frost Armor
        ["rank"] = {
          0.2,
        },
        ["buff"] = 7302,        -- ["Frost Armor"],
        ["old"] = 13914, -- 4.1.0
      },
    },
    -- Mage: Prismatic Cloak - Rank 3/3 - 1,11
    -- 4.0.1: Reduces all damage taken by 2/4/6%.
    -- Mage: Frost Armor - Buff: 7302
    -- 4.1.0: Reduces physical damage taken by 15%
    ["MOD_DMG_TAKEN"] = {
      {
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 11,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
      },
      {-- Frost Armor
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          -0.15,
        },
        ["buff"] = 7302,        -- ["Frost Armor"],
        ["new"] = 13914, -- 4.1.0
      },
    },
  }
elseif playerClass == "PALADIN" then
  StatModTable["PALADIN"] = {
    -- Healers: Meditation
    -- 4.0.1: Allows 50% of your mana regeneration from Spirit to continue while in combat.
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"] = {
      {-- Meditation
        ["rank"] = {
          0.50,
        },
        ["known"] = 95859,
      },
    },
    -- Paladin: Enlightened Judgements - Rank 2/2 - 1,11
    -- 4.0.1: Grants hit rating equal to 50/100% of any Spirit gained from items or effects
    ["ADD_SPELL_HIT_RATING_MOD_SPI"] = {
      {-- Enlightened Judgements
        ["spellid"] = 53557,
        ["tab"] = 1,
        ["num"] = 11,
        ["rank"] = {
          0.5, 1,
        },
      },
    },
    -- Tanks: Forceful Deflection - Passive
    -- 4.0.1: Increases your Parry Rating by 25% of your total Strength. (No spell, talent, ability or buff. Tanks just get it)
    -- 4.2.0: Increases your Parry Rating by 27% of your total Strength.
    ["ADD_PARRY_RATING_MOD_STR"] = {
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.25,
        },
        ["old"] = 14333, -- 4.2.0
      },
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.27,
        },
        ["new"] = 14333, -- 4.2.0
      },
    },
    -- Paladin: Sheath of Light - Passive: 53503
    -- 4.0.1: Increases your spell power by an amount equal to 30% of your attack power
    ["ADD_SPELL_DMG_MOD_AP"] = {
      {-- Sheath of Light
        ["rank"] = {
          0.3,
        },
        ["known"] = 53503,
      },
    },
    -- Paladin: Sheath of Light - Passive: 53503
    -- 4.0.1: Increases your spell power by an amount equal to 30% of your attack power
    ["ADD_HEAL_MOD_AP"] = {
      {-- Sheath of Light
        ["rank"] = {
          0.3,
        },
        ["known"] = 53503,
      },
    },
    -- Paladin: Touched by the Light - Passive: 53592
    -- 4.0.1: Increases your total Stamina by 15%, increases your spell hit by 6%, and increases your spell power by an amount equal to 60% of your Strength.
    ["ADD_SPELL_DMG_MOD_STR"] = {
      {-- Touched by the Light
        ["rank"] = {
          0.6,
        },
        ["known"] = 53592,
      },
    },
    -- Paladin: Touched by the Light - Passive: 53592
    -- 4.0.1: Increases your total Stamina by 15%, increases your spell hit by 6%, and increases your spell power by an amount equal to 60% of your Strength.
    ["ADD_HEAL_MOD_STR"] = {
      {-- Touched by the Light
        ["rank"] = {
          0.6,
        },
        ["known"] = 53592,
      },
    },
    -- Paladin: Sanctuary - Rank 3/3 - 2,8
    -- 4.0.1: Reduces the chance you'll be critically hit by melee attacks by 2/4/6% and reduces all damage taken by 3/7/10%.
    ["ADD_CRIT_TAKEN"] = {
      {-- Sanctuary
        ["MELEE"] = true,
        ["tab"] = 2,
        ["num"] = 8,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
      },
    },
    -- Paladin: Sanctuary - Rank 3/3 - 2,8
    -- 4.0.1: Reduces the chance you'll be critically hit by melee attacks by 2/4/6% and reduces all damage taken by 3/7/10%.
    -- Paladin: Ardent Defender - Buff: 31850
    -- 4.0.1: Damage taken reduced by 20%.
    ["MOD_DMG_TAKEN"] = {
      {-- Sanctuary
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 2,
        ["num"] = 8,
        ["rank"] = {
          -0.03, -0.07, -0.1,
        },
      },
      {-- Ardent Defender
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
        ["buff"] = 31850,
      },
    },
    -- Paladin: Toughness - Rank 3/3 - 2,5
    -- 4.0.1: Increases your armor value from items by 3/6/10%.
    ["MOD_ARMOR"] = {
      {
        ["tab"] = 2,
        ["num"] = 5,
        ["rank"] = {
          0.03, 0.06, 0.1,
        },
      },
    },
    -- Paladin: Plate Specialization - Passive: 86525
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Holy specialization grants Intellect, Protection specialization grants Stamina, and Retribution specialization grants Strength.
    -- Paladin: Touched by the Light - Passive: 53592
    -- 4.0.1: Increases your total Stamina by 15%, increases your spell hit by 6%, and increases your spell power by an amount equal to 60% of your Strength.
    ["MOD_STA"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86525,
        ["armorspec"] = 2,
      },
      {-- Touched by the Light
        ["rank"] = {
          0.15,
        },
        ["known"] = 53592,
      },
    },
    -- Paladin: Plate Specialization - Passive: 86525
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Holy specialization grants Intellect, Protection specialization grants Stamina, and Retribution specialization grants Strength.
    ["MOD_STR"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86525,
        ["armorspec"] = 3,
      },
    },
    -- Paladin: Plate Specialization - Passive: 86525
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Holy specialization grants Intellect, Protection specialization grants Stamina, and Retribution specialization grants Strength.
    ["MOD_INT"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86525,
        ["armorspec"] = 1,
      },
    },
  }
elseif playerClass == "PRIEST" then
  StatModTable["PRIEST"] = {
    -- Healers: Meditation
    -- 4.0.1: Allows 50% of your mana regeneration from Spirit to continue while in combat.
    -- Priest: Holy Concentration - Rank 2/2 - 2,8
    -- 4.0.1: Increases the amount of mana regeneration from Spirit while in combat by an additional 10/20%.
    -- 4.0.6: Increases the amount of mana regeneration from Spirit while in combat by an additional 15/30%.
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"] = {
      {-- Meditation (Discipline)
        ["rank"] = {
          0.5,
        },
        ["known"] = 95860,
      },
      {-- Meditation (Holy)
        ["rank"] = {
          0.5,
        },
        ["known"] = 95861,
      },
      {-- Holy Concentration
        ["spellid"] = 34859,
        ["tab"] = 2,
        ["num"] = 8,
        ["rank"] = {
          0.15, 0.30,
        },
      },
    },
    -- Priest: Twisted Faith - Rank 2/2 - 3,7
    -- 4.0.1: Grants you spell hit rating equal to 50/100% of any Spirit gained from items or effects.
    ["ADD_SPELL_HIT_RATING_MOD_SPI"] = {
      {-- Twisted Faith
        ["spellid"] = 47577,
        ["tab"] = 3,
        ["num"] = 7,
        ["rank"] = {
          0.5, 1,
        },
      },
    },
    -- Priest: Inner Fire - Buff: 588
    -- 4.0.1: Increases armor from items by 60% and spell power by 1080.
    -- Priest: Glyph of Inner Fire - Glyph: 55686 - Buff: 588
    -- 4.0.1: Increases the armor from your Inner Fire spell by 50%.
    ["MOD_ARMOR"] = {
      {-- Inner Fire
        ["rank"] = {
          0.6,
        },
        ["buff"] = 588,        -- ["Inner Fire"],
      },
      {-- Glyph of Inner Fire
        ["rank"] = {
          0.1875, -- 1.9/1.6=1.1875
        },
        ["buff"] = 588,        -- ["Inner Fire"],
        ["glyph"] = 55686,        -- ["Glyph of Inner Fire"],
      },
    },
    -- Priest: Dispersion - Buff
    -- 4.0.1: Reduces all damage by 90%
    -- Priest: Shadowform - Buff
    -- 4.0.1: All damage you take reduced by 15%.
    -- Priest: Focused Will - Rank 2/2 - 1,19 - Buff: 45241. Stack 2
    -- 4.0.1: All damage taken reduced by 4/6%. Stacks up to 2 times.
    -- Priest: Inner Sanctum - Rank 3/3 - 1,6 - Buff: 588
    -- 4.0.1: Spell damage taken is reduced by 2/4/6% while within Inner Fire
    ["MOD_DMG_TAKEN"] = {
      {-- Shadowform
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.15,
        },
        ["buff"] = 15473,        -- ["Shadowform"],
      },
      {-- Dispersion
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.9,
        },
        ["buff"] = 65544,        -- ["Dispersion"],
      },
      {-- Focused Will
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 19,
        ["rank"] = {
          -0.04, -0.06,
        },
        ["buff"] = 45241,        -- ["Focused Will"],
        ["buffStack"] = true,
      },
      {-- Inner Sanctum
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 6,
        ["rank"] = {
          -0.02, -0.04, -0.06,
        },
        ["buff"] = 588,        -- ["Inner Sanctum"],
      },
    },
    -- Priest: Enlightenment - Passive: 84732
    -- 4.0.1: Intellect increased by 15%.
    -- Priest: Mysticism - Passive: 89745
    -- 4.0.1: Increases your Intellect by 5%
    ["MOD_INT"] = {
      {-- Enlightenment
        ["rank"] = {
          0.15,
        },
        ["known"] = 84732,
      },
      {-- Mysticism
        ["rank"] = {
          0.05,
        },
        ["known"] = 89745,
      },
    },
  }
elseif playerClass == "ROGUE" then
  StatModTable["ROGUE"] = {
    -- Rogue: Savage Combat - Rank 2/2 - 2,16
    -- 4.0.1: Increases your total attack power by 2/4%.
    -- 4.2.0: Increases your total attack power by 3/6%.
    -- Rogue: Vitality - Passive: 61329
    -- 4.0.1: Increases your Attack Power by 15%.
    -- 4.0.1: Increases your Attack Power by 25%.
    -- 4.2.0: Increases your Attack Power by 30%.
    ["MOD_AP"] = {
      {-- Savage Combat
        ["tab"] = 2,
        ["num"] = 16,
        ["rank"] = {
          0.02, 0.04,
        },
        ["old"] = 14333, -- 4.2.0
      },
      {-- Savage Combat
        ["tab"] = 2,
        ["num"] = 16,
        ["rank"] = {
          0.03, 0.06,
        },
        ["new"] = 14333, -- 4.2.0
      },
      {-- Vitality
        ["rank"] = {
          0.25,
        },
        ["known"] = 61329,
        ["old"] = 14333, -- 4.2.0
      },
      {-- Vitality
        ["rank"] = {
          0.3,
        },
        ["known"] = 61329,
        ["new"] = 14333, -- 4.2.0
      },
    },
    -- Rogue: Reinforced Leather - Rank 2/2 - 2,10
    -- 4.0.1: Increases your armor contribution from cloth and leather items by 25/50%.
    ["MOD_ARMOR"] = {
      {-- Reinforced Leather
        ["tab"] = 2,
        ["num"] = 10,
        ["rank"] = {
          0.25, 0.5,
        },
      },
    },
    -- Rogue: Lightning Reflexes - Rank 3/3 - 2,8
    -- 4.0.1: Increases your chance to dodge enemy attacks by 3/6/9%
    -- Rogue: Evasion - Buff: 5277
    -- 4.0.1: Dodge chance increased by 50% and chance ranged attacks hit you reduced by 25%.
    -- Rogue: Ghostly Strike - Buff: 31022
    -- 4.0.1: Dodge chance increased by 15%.
    ["ADD_DODGE"] = {
      {-- Lightning Reflexes
        ["tab"] = 2,
        ["num"] = 8,
        ["rank"] = {
          3, 6, 9,
        },
      },
      {-- Evasion
        ["rank"] = {
          50,
        },
        ["buff"] = 5277,        -- ["Evasion"],
      },
      {-- Ghostly Strike
        ["rank"] = {
          15,
        },
        ["buff"] = 31022,        -- ["Ghostly Strike"],
      },
    },
    -- Rogue: Evasion - Buff: 5277
    -- 4.0.1: Dodge chance increased by 50% and chance ranged attacks hit you reduced by 25%.
    ["ADD_HIT_TAKEN"] = {
      {-- Evasion
        ["RANGED"] = true,
        ["rank"] = {
          -0.25,
        },
        ["buff"] = 5277,        -- ["Evasion"],
      },
    },
    -- Rogue: Cloak of Shadows - Buff: 31224
    -- 4.0.1: Resisting all hostile spells.
    -- Rogue: Glyph of Cloak of Shadows - Buff: 31224 - Glyph: 63269
    -- 4.0.1: While Cloak of Shadows is active, you take 40% less physical damage.
    -- Rogue: Cheating Death - Buff: 45182
    -- 4.0.1: All damage taken reduced by 90%
    -- 4.1.0: All damage taken reduced by 80%
    -- Rogue: Deadened Nerves - Rank 3/3 - 1,11
    -- 4.0.1: Reduces all damage taken by 3/7/10%.%
    -- Rogue: Improved Recuperate - Rank 2/2 - 2,1 - Buff: 73651
    -- 4.0.1: Reduces all damage taken by 3/6% while your Recuperate ability is active.
    ["MOD_DMG_TAKEN"] = {
      {-- Cloak of Shadows
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -1,
        },
        ["buff"] = 31224,        -- ["Cloak of Shadows"],
      },
      {-- Glyph of Cloak of Shadows
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          -0.4,
        },
        ["buff"] = 31224,        -- ["Cloak of Shadows"],
        ["glyph"] = 63269,  -- ["Glyph of Cloak of Shadows"],
      },
      {-- Cheating Death
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.9,
        },
        ["buff"] = 45182,        -- ["Cheating Death"],
        ["old"] = 13914, -- 4.1.0
      },
      {-- Cheating Death
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.8,
        },
        ["buff"] = 45182,        -- ["Cheating Death"],
        ["new"] = 13914, -- 4.1.0
      },
      {-- Deadened Nerves
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 11,
        ["rank"] = {
          -0.03, -0.07, -0.1,
        },
      },
      {-- Improved Recuperate
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 2,
        ["num"] = 1,
        ["rank"] = {
          -0.03, -0.06,
        },
        ["buff"] = 73651,        -- ["Recuperate"],
      },
    },
    -- Rogue: Leather Specialization - Passive: 86531
    -- 4.0.1: Increases your Agility by 5% while wearing Leather in all armor slots.
    -- Rogue: Sinister Calling - Passive: 31220
    -- 4.0.1: Increases your total Agility by 25%
    -- 4.0.6: Increases your total Agility by 30%
    ["MOD_AGI"] = {
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86531,
        ["armorspec"] = 0,
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86531,
        ["armorspec"] = 1,
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86531,
        ["armorspec"] = 2,
      },
      {-- Leather Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86531,
        ["armorspec"] = 3,
      },
      {-- Sinister Calling
        ["rank"] = {
          0.3,
        },
        ["known"] = 31220,
      },
    },
  }
elseif playerClass == "SHAMAN" then
  StatModTable["SHAMAN"] = {
    -- Druid: Elemental Precision - Rank 3/3 - 1,7
    -- 4.0.1: Grants you spell hit rating equal to 33/66/100% of any Spirit gained from items or effects.
    ["ADD_SPELL_HIT_RATING_MOD_SPI"] = {
      {
        ["spellid"] = 30674,
        ["tab"] = 1,
        ["num"] = 7,
        ["rank"] = {
          0.33, 0.66, 1,
        },
      },
    },
    -- Healers: Meditation
    -- 4.0.1: Allows 50% of your mana regeneration from Spirit to continue while in combat.
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"] = {
      {
        ["rank"] = {
          0.50,
        },
        ["known"] = 95862,
      },
    },
    -- Shaman: Mental Quickness - Passive: 30814
    -- 4.0.1: Increases your spell power by an amount equal to 50% of your attack power
    ["ADD_SPELL_DMG_MOD_AP"] = {
      {-- Mental Quickness
        ["rank"] = {
          0.5,
        },
        ["known"] = 30814,
      },
    },
    -- Shaman: Mental Quickness - Passive: 30814
    -- 4.0.1: Increases your spell power by an amount equal to 50% of your attack power
    ["ADD_HEAL_MOD_AP"] = {
      {-- Mental Quickness
        ["rank"] = {
          0.5,
        },
        ["known"] = 30814,
      },
    },
    -- Shaman: Elemental Warding - Rank 3/3 - 1,5
    -- 4.0.1: Reduces magical damage taken by 4/8/12%.
    -- Shaman: Shamanistic Rage - Buff: 30823
    -- 4.0.1: All damage taken reduced by 30%.
    ["MOD_DMG_TAKEN"] = {
      {-- Elemental Warding
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 1,
        ["num"] = 5,
        ["rank"] = {
          -0.04, -0.08, -0.12,
        },
      },
      {-- Shamanistic Rage
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
        ["buff"] = 30823,        -- ["Shamanistic Rage"],
      },
    },
    -- Shaman: Toughness - Rank 3/3 - 2,8
    -- 4.0.1: Increases your Stamina by 3/7/10%
    ["MOD_STA"] = {
      {
        ["tab"] = 2,
        ["num"] = 8,
        ["rank"] = {
          0.03, 0.07, 0.1,
        },
      },
    },
    -- Shaman: Mail Specialization - Passive: 86529
    -- 4.0.1: Increases your primary attribute by 5% while wearing Mail in all armor slots. Elemental specialization grants Intellect, Enhancement specialization grants Agility, and Restoration specialization grants Intellect.
    ["MOD_AGI"] = {
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86529,
        ["armorspec"] = 2,
      },
    },
    -- Shaman: Mail Specialization - Passive: 86529
    -- 4.0.1: Increases your primary attribute by 5% while wearing Mail in all armor slots. Elemental specialization grants Intellect, Enhancement specialization grants Agility, and Restoration specialization grants Intellect.
    ["MOD_INT"] = {
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86529,
        ["armorspec"] = 1,
      },
      {-- Mail Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86529,
        ["armorspec"] = 3,
      },
    },
  }
elseif playerClass == "WARLOCK" then
  StatModTable["WARLOCK"] = {
    -- Warlock: Metamorphosis - Buff: 47241
    -- 4.0.1: Armor contribution from items increased by 600%. Chance to be critically hit by melee reduced by 6%.
    ["ADD_CRIT_TAKEN"] = {
      {-- Metamorphosis
        ["MELEE"] = true,
        ["rank"] = {
          -0.06,
        },
        ["buff"] = 47241,
      },
    },
    -- Warlock: Metamorphosis - Buff: 47241
    -- 4.0.1: Armor contribution from items increased by 600%. Chance to be critically hit by melee reduced by 6%.
    ["MOD_ARMOR"] = {
      {-- Metamorphosis
        ["rank"] = {
          6,
        },
        ["buff"] = 47241,
      },
    },
    -- 3.3.0 Imp stam total 233: pet base 118, player base 90, pet sta from player sta 0.75, pet kings 1.1, fel vitality 1.15
    -- /dump floor((118+floor(90*0.75))*1.1)*1.05 = 233.45 match
    -- /dump (118+floor(90*0.75))*1.1*1.05 = 224.025 wrong
    ["ADD_PET_STA_MOD_STA"] = {
      { -- Base
        ["rank"] = {
          0.65,
        },
        ["condition"] = "UnitExists('pet')",
      },
      { -- Blessings on pet: floor() * 1.05
        ["rank"] = {
          0.05,
        }, -- BoK, MotW, EotSS
        ["condition"] = "UnitBuff('pet', GetSpellInfo(20217)) or UnitBuff('pet', GetSpellInfo(79061)) or UnitBuff('pet', GetSpellInfo(90363))",
      },
    },
    ["ADD_PET_INT_MOD_INT"] = {
      { -- Base
        ["rank"] = {
          0.5,
        },
        ["condition"] = "UnitExists('pet')",
      },
      { -- Blessings on pet: floor() * 1.05
        ["rank"] = {
          0.05,
        }, -- BoK, MotW, EotSS
        ["condition"] = "UnitBuff('pet', GetSpellInfo(20217)) or UnitBuff('pet', GetSpellInfo(79061)) or UnitBuff('pet', GetSpellInfo(90363))",
      },
    },
    -- Warlock: Soul Link - Buff: 25228
    -- 4.0.1: 20% of damage taken by master is taken by the demon instead.
    -- Warlock: Glyph of Soul Link - Buff: 25228 - Glyph: 63312
    -- 4.0.1: Increases the percentage of damage shared via your Soul Link by an additional 5%.
    ["MOD_DMG_TAKEN"] = {
      {-- Soul Link
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
        ["buff"] = 25228,        -- ["Soul Link"],
      },
      {-- Glyph of Soul Link
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.05,
        },
        ["buff"] = 25228,        -- ["Soul Link"],
        ["glyph"] = 63312,  -- ["Glyph of Soul Link"],
      },
    },
    -- Warlock: Demonic Embrace - Rank 3/3 - 2,1
    --          Increases your total Stamina by 4/7/10%.
    ["MOD_STA"] = {
      {
        ["tab"] = 2,
        ["num"] = 1,
        ["rank"] = {
          0.04, 0.07, 0.1,
        },
      },
    },
    -- Warlock: Nethermancy - Passive: 86091
    -- 4.0.1: Increases your Intellect by 5%
    ["MOD_INT"] = {
      {-- Nethermancy
        ["rank"] = {
          0.05,
        },
        ["known"] = 86091,
      },
    },
  }
elseif playerClass == "WARRIOR" then
  StatModTable["WARRIOR"] = {
    -- Tanks: Forceful Deflection - Passive
    --        Increases your Parry Rating by 25% of your total Strength.
    -- 4.2.0: Increases your Parry Rating by 27% of your total Strength.
    ["ADD_PARRY_RATING_MOD_STR"] = {
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.25,
        },
        ["old"] = 14333, -- 4.2.0
      },
      {
        ["spellid"] = 49410,
        ["rank"] = {
          0.27,
        },
        ["new"] = 14333, -- 4.2.0
      },
    },
    -- Warrior: Bastion of Defense - Rank 2/2 - 3,10 - Stance: "Interface\\Icons\\Ability_Warrior_DefensiveStance"
    -- 4.0.1: Reduces the chance you'll be critically hit by melee attacks by 3/6% while in Defensive Stance.
    ["ADD_CRIT_TAKEN"] = {
      {-- Bastion of Defense
        ["MELEE"] = true,
        ["tab"] = 3,
        ["num"] = 10,
        ["rank"] = {
          -0.03, -0.06,
        },
        ["stance"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
      },
    },
    -- Warrior: Shield Wall - Buff: 871
    -- 4.0.1: All damage taken reduced by 40%
    -- Warrior: Glyph of Shield Wall - Buff: 871 - Glyph: 63329
    -- 4.0.1: Shield Wall now reduces damage taken by 60%
    -- Warrior: Defensive Stance - Stance: "Interface\\Icons\\Ability_Warrior_DefensiveStance"
    -- 4.0.1: Decreases damage taken by 10%
    -- Warrior: Battle Stance - Stance: "Interface\\Icons\\Ability_Warrior_OffensiveStance"
    -- 4.0.1: Decreases damage taken by 5%
    -- Warrior: Death Wish - Buff: 12292
    -- 4.0.1: Increases all damage taken by 5%.
    -- Warrior: Glyph of Death Wish - Buff: 12292 - Glyph: 94374
    -- 4.0.1: Death Wish no longer increases damage taken.
    -- Warrior: Recklessness - Buff: 1719
    -- 4.0.1: All damage taken is increased by 20%.
    -- Warrior: Shield Mastery - Rank 3/3 - 3,5 - Spell Block - Buff: 97954
    -- 4.0.1: Magic damage reduced by 7/14/20%.
    ["MOD_DMG_TAKEN"] = {
      {-- Shield Wall
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
        ["buff"] = 871,        -- ["Shield Wall"],
      },
      {-- Glyph of Shield Wall
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
        ["buff"] = 871,        -- ["Shield Wall"],
        ["glyph"] = 63329, -- Glyph of Shield Wall,
      },
      {-- Defensive Stance
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
      {-- Battle Stance
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.05,
        },
        ["stance"] = "Interface\\Icons\\Ability_Warrior_OffensiveStance",
      },
      {-- Death Wish
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
        ["buff"] = 12292,        -- ["Death Wish"],
      },
      {-- Glyph of Death Wish
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.05,
        },
        ["buff"] = 12292,        -- ["Death Wish"],
        ["glyph"] = 94374,        -- Glyph of Death Wish
      },
      {-- Recklessness
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
        ["buff"] = 1719,        -- ["Recklessness"],
      },
      {-- Shield Mastery
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["tab"] = 3,
        ["num"] = 5,
        ["rank"] = {
          -0.07, -0.14, -0.2,
        },
        ["buff"] = 97954,        -- ["Spell Block"],
        ["new"] = 13914, -- 4.1.0
      },
    },
    -- Warrior: Last Stand - Buff: 12976
    -- 4.0.1: Health increased by 30% of maximum.
    ["MOD_HEALTH"] = {
      {-- Last Stand
        ["rank"] = {
          0.3,
        },
        ["buff"] = 12975,        -- ["Last Stand"],
      },
    },
    -- Warrior: Toughness - Rank 3/3 - 3,2
    -- 4.0.1: Increases your armor value from items by 3/6/10%.
    ["MOD_ARMOR"] = {
      {-- Toughness
        ["tab"] = 3,
        ["num"] = 2,
        ["rank"] = {
          0.03, 0.06, 0.1,
        },
      },
    },
    -- Warrior: Plate Specialization - Passive: 86526
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Arms specialization grants Strength, Fury specialization grants Strength, and Protection specialization grants Stamina.
    -- Warrior: Sentinel - Passive: 29144
    -- 4.0.1: Increases your total Stamina by 15%
    ["MOD_STA"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86526,
        ["armorspec"] = 3,
      },
      {-- Sentinel
        ["rank"] = {
          0.15,
        },
        ["known"] = 29144,
      },
    },
    -- Warrior: Plate Specialization - Passive: 86526
    -- 4.0.1: Increases your primary attribute by 5% while wearing Plate in all armor slots. Arms specialization grants Strength, Fury specialization grants Strength, and Protection specialization grants Stamina.
    ["MOD_STA"] = {
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86526,
        ["armorspec"] = 1,
      },
      {-- Plate Specialization
        ["rank"] = {
          0.05,
        },
        ["known"] = 86526,
        ["armorspec"] = 2,
      },
    },
  }
end
  StatModTable["ALL"] = {
    -- Death Knight: Improved Icy Talons - Buff: 55610
    -- 4.0.6: Melee and Ranged attack speed increased by 10%.
    -- Hunter: Hunting Party - Buff: 53290
    -- 4.0.6: Melee and Ranged attack speed increased by 10%.
    -- Hunter: Windfury Totem - Buff: 8512
    -- 4.0.6: Melee and Ranged attack speed increased by 10%.
    ["MOD_MELEE_HASTE"] = {
      {-- Improved Icy Talons
        ["rank"] = {
          0.1,
        },
        ["buff"] = 55610,
        ["group"] = D["10% Melee/Ranged Attack Speed"],
      },
      {-- Hunting Party
        ["rank"] = {
          0.1,
        },
        ["buff"] = 53290,
        ["group"] = D["10% Melee/Ranged Attack Speed"],
      },
      {-- Windfury Totem
        ["rank"] = {
          0.1,
        },
        ["buff"] = 8512,
        ["group"] = D["10% Melee/Ranged Attack Speed"],
      },
    },
    -- Druid: Moonkin Aura - Buff: 24907
    -- 4.0.6: Increases spell haste by 5%.
    -- Priest: Mind Quickening - Buff: 49868
    -- 4.0.6: Increases spell haste by 5%.
    -- Shaman: Wrath of Air Totem - Buff: 3738
    -- 4.0.6: Increases spell haste by 5%.
    ["MOD_SPELL_HASTE"] = {
      {-- Improved Icy Talons
        ["rank"] = {
          0.05,
        },
        ["buff"] = 24907,
        ["group"] = D["5% Spell Haste"],
      },
      {-- Mind Quickening
        ["rank"] = {
          0.05,
        },
        ["buff"] = 49868,
        ["group"] = D["5% Spell Haste"],
      },
      {-- Wrath of Air Totem
        ["rank"] = {
          0.05,
        },
        ["buff"] = 3738,
        ["group"] = D["5% Spell Haste"],
      },
    },
    -- ICC: Chill of the Throne
    --      Chance to dodge reduced by 20%.
    -- 4.0.1: Removed
    ["ADD_DODGE"] = {
      {
        ["rank"] = {
          -20,
        },
        ["buff"] = 69127,        -- ["Chill of the Throne"],
      },
    },
    -- Replenishment - Buff
    -- 4.0.1: Replenishes 1% of maximum mana per 10 sec.
    -- 4.0.1: Shadow Priest, Frost Mage, Survival Hunter, Destro Lock, Ret Paladin
    ["ADD_COMBAT_MANA_REGEN_MOD_MANA"] = {
      {
        ["rank"] = {
          0.005,
        },
        ["buff"] = 57669,        -- ["Replenishment"],
      },
    },
    -- Priest: Inspiration - Rank 2/2 - Buff: 15357
    -- 4.0.1: Reduces physical damage taken by 5/10%.
    -- Shaman: Ancestral Fortitude - Rank 2/2 - Buff: 16236
    -- 4.0.1: Reduces physical damage taken by 5/10%.
    -- Priest: Pain Suppression - Buff: 33206
    -- 4.0.1: All damage taken reduced by 40%
    -- Paladin: Divine Guardian - Buff: 70940
    -- 4.0.1: Damage taken reduced by 20%
    -- Death Knight: Anti-Magic Zone - Buff: 50461
    -- 4.0.1: Absorbs 75% of spell damage.
    -- Warrior: Safeguard - Buff: 46947
    -- 4.0.1: All damage taken reduced by 15/30%
    -- MetaGem: Shielded Skyflare Diamond - 41377
    -- 4.0.1: +32 Stamina and Reduce Spell Damage Taken by 2%
    -- Dwarf: Stoneform - Buff: 65116
    -- 4.0.1: Armor increased by 10%.
    -- 4.0.6: Damage taken reduced by 10%.
    ["MOD_DMG_TAKEN"] = {
      {-- Stoneform
        ["rank"] = {
          -0.1,
        },
        ["buff"] = 65116,        -- ["Stoneform"],
      },
      {-- Inspiration
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          -0.05, -0.1,
        },
        ["buff"] = 15357,        -- ["Inspiration"],
        ["group"] = D["Reduced Physical Damage Taken"],
      },
      {-- Ancestral Fortitude
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          -0.05, -0.1,
        },
        ["buff"] = 16236,        -- ["Ancestral Fortitude"],
        ["group"] = D["Reduced Physical Damage Taken"],
      },
      {-- Pain Suppression
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
        ["buff"] = 33206,        -- ["Pain Suppression"],
      },
      {-- Divine Guardian
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
        ["buff"] = 70940,        -- ["Divine Guardian"],
      },
      {-- Safeguard
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.15, -0.3,
        },
        ["buff"] = 46947,        -- ["Safeguard"],
      },
      {-- Anti-Magic Zone
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.75,
        },
        ["buff"] = 50461,        -- ["Anti-Magic Zone"],
      },
      {-- Effulgent Skyflare Diamond
        ["HOLY"] = true,
        ["FIRE"] = true,
        ["NATURE"] = true,
        ["FROST"] = true,
        ["SHADOW"] = true,
        ["ARCANE"] = true,
        ["rank"] = {
          -0.02,
        },
        ["meta"] = 41377,
      },
    },
    -- Warlock: Demonic Pact - Buff: 53646
    -- 4.0.1: Spell Power increased by 10%.
    -- Shaman: Totemic Wrath - Buff: 77747
    -- 4.0.1: Spell Power increased by 10%.
    -- Shaman: Flametongue Totem - Buff: 52109
    -- 4.0.1: Spell Power increased by 6%.
    -- Mage: Arcane Brilliance - Buff: 79058
    -- 4.0.1: Spell Power increased by 6%.
    -- Mage: Dalaran Brilliance - Buff: 61316
    -- 4.0.1: Spell Power increased by 6%.
    ["MOD_SPELL_DMG"] = {
      {-- Demonic Pact
        ["rank"] = {
          0.1,
        },
        ["buff"] = 53646,        -- ["Demonic Pact"],
        ["group"] = D["Spell Power Multiplier"],
      },
      {-- Totemic Wrath
        ["rank"] = {
          0.1,
        },
        ["buff"] = 77747,        -- ["Totemic Wrath"],
        ["group"] = D["Spell Power Multiplier"],
      },
      {-- Flametongue Totem
        ["rank"] = {
          0.06,
        },
        ["buff"] = 52109,        -- ["Flametongue Totem"],
        ["group"] = D["Spell Power Multiplier"],
      },
      {-- Arcane Brilliance
        ["rank"] = {
          0.06,
        },
        ["buff"] = 79058,        -- ["Arcane Brilliance"],
        ["group"] = D["Spell Power Multiplier"],
      },
      {-- Dalaran Brilliance
        ["rank"] = {
          0.06,
        },
        ["buff"] = 61316,
        ["group"] = D["Spell Power Multiplier"],
      },
    },
    -- Warlock: Demonic Pact - Buff: 53646
    -- 4.0.1: Spell Power increased by 10%.
    -- Shaman: Totemic Wrath - Buff: 77747
    -- 4.0.1: Spell Power increased by 10%.
    -- Shaman: Flametongue Totem - Buff: 52109
    -- 4.0.1: Spell Power increased by 6%.
    -- Mage: Arcane Brilliance - Buff: 79058
    -- 4.0.1: Spell Power increased by 6%.
    ["MOD_HEAL"] = {
      {
        ["rank"] = {
          0.1,
        },
        ["buff"] = 53646,        -- ["Demonic Pact"],
        ["group"] = D["Spell Power Multiplier"],
        ["newtoc"] = 40000,
      },
      {
        ["rank"] = {
          0.1,
        },
        ["buff"] = 77747,        -- ["Totemic Wrath"],
        ["group"] = D["Spell Power Multiplier"],
        ["newtoc"] = 40000,
      },
      {
        ["rank"] = {
          0.06,
        },
        ["buff"] = 52109,        -- ["Flametongue Totem"],
        ["group"] = D["Spell Power Multiplier"],
        ["newtoc"] = 40000,
      },
      {
        ["rank"] = {
          0.06,
        },
        ["buff"] = 79058,        -- ["Arcane Brilliance"],
        ["group"] = D["Spell Power Multiplier"],
        ["newtoc"] = 40000,
      },
    },
    -- Night Elf : Quickness - Racial
    -- 4.0.1: Reduces the chance that melee and ranged attackers will hit you by 2%.
    ["ADD_HIT_TAKEN"] = {
      {
        ["MELEE"] = true,
        ["RANGED"] = true,
        ["rank"] = {
          -0.02,
        },
        ["race"] = "NightElf",
      },
    },
    -- MetaGem: Eternal Earthsiege Diamond - Meta: 41396
    -- 4.0.1: +1% Shield Block Value
    -- MetaGem: Eternal Earthstorm Diamond - Meta: 35501
    -- 4.0.1: +1% Shield Block Value
    -- MetaGem: Eternal Shadowspirit Diamond - Meta: 52293
    -- 4.0.1: +5% Shield Block Value
    ["ADD_BLOCK_REDUCTION"] = {
      {-- Eternal Earthsiege Diamond
        ["rank"] = {
          0.01,
        },
        ["meta"] = 41396,
      },
      {-- Eternal Earthstorm Diamond
        ["rank"] = {
          0.01,
        },
        ["meta"] = 35501,
      },
      {-- Eternal Shadowspirit Diamond
        ["rank"] = {
          0.05,
        },
        ["meta"] = 52293,
      },
    },
    -- MetaGem: Austere Earthsiege Diamond - Meta: 41380
    -- 4.0.1: 2% Increased Armor Value from Items
    -- MetaGem: Austere Shadowspirit Diamond - Meta: 52294
    -- 4.0.1: 2% Increased Armor Value from Items
    ["MOD_ARMOR"] = {
      {-- Austere Earthsiege Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 41380,
      },
      {-- Austere Shadowspirit Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 52294,
      },
    },
    -- Hunter: Trueshot Aura - Buff: 19506
    -- 4.0.1: Attack power increased by 10%.
    -- Death Knight: Abomination's Might - Buff: 55972
    -- 4.0.1: Attack power increased by 5/10%.
    -- Shaman: Unleashed Rage - Buff: 30809
    -- 4.0.1: Melee attack power increased by 4/7/10%.
    -- Paladin: Blessing of Might - Buff: 19740
    -- 4.0.1: Increasing attack power by 10%.
    ["MOD_AP"] = {
      {-- Trueshot Aura
        ["rank"] = {
          0.1,
        },
        ["buff"] = 19506,        -- ["Trueshot Aura"],
        ["group"] = D["Attack Power Multiplier"],
      },
      {-- Abominable Might
        ["rank"] = {
          0.05, 0.1,
        },
        ["buff"] = 55972,        -- ["Abominable Might"],
        ["group"] = D["Attack Power Multiplier"],
      },
      {-- Unleashed Rage
        ["rank"] = {
          0.04, 0.07, 0.1,
        },
        ["buff"] = 30809,        -- ["Unleashed Rage"],
        ["group"] = D["Attack Power Multiplier"],
      },
      {-- Blessing of Might
        ["rank"] = {
          0.1,
        },
        ["buff"] = 19740,        -- ["Blessing of Might"],
        ["group"] = D["Attack Power Multiplier"],
      },
    },
    -- Gnome: Expansive Mind - Racial
    -- 4.0.1: Mana pool increased by 5%.
    -- MetaGem: Ember Skyfire Diamond - Meta: 35503
    -- 4.0.1: +2% Maximum Mana
    -- MetaGem: Ember Skyflare Diamond - Meta: 41333
    -- 4.0.1: +2% Maximum Mana
    -- MetaGem: Beaming Earthsiege Diamond - Meta: 41389
    -- 4.0.1: +2% Mana
    -- MetaGem: Ember Shadowspirit Diamond - Meta: 52296
    -- 4.0.1: +2% Maximum Mana
    ["MOD_MANA"] = {
      {-- Expansive Mind
        ["rank"] = {
          0.05,
        },
        ["race"] = "Gnome",
      },
      {-- Beaming Earthsiege Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 41389,
      },
      {-- Ember Skyfire Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 35503,
      },
      {-- Ember Skyflare Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 41333,
      },
      {-- Ember Shadowspirit Diamond
        ["rank"] = {
          0.02,
        },
        ["meta"] = 52296,
      },
    },
    -- Paladin: Blessing of Kings - Buff: 20217
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Druid: Mark of the Wild - Buff: 79061
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Hunter: Embrace of the Shale Spider - Buff: 90363
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Leatherworking: Blessing of Forgotten Kings - Buff: 69378
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 4%.
    ["MOD_STR"] = {
      {-- Blessing of Kings
        ["rank"] = {
          0.05,
        },
        ["buff"] = 20217,        -- ["Blessing of Kings"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Mark of the Wild
        ["rank"] = {
          0.05,
        },
        ["buff"] = 79061,        -- ["Mark of the Wild"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Embrace of the Shale Spider
        ["rank"] = {
          0.05,
        },
        ["buff"] = 90363,        -- ["Embrace of the Shale Spider"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Blessing of Forgotten Kings
        ["rank"] = {
          0.04,
        },
        ["buff"] = 69378,        -- ["Blessing of Forgotten Kings"],
        ["group"] = D["Stat Multiplier"],
      },
    },
    -- Paladin: Blessing of Kings - Buff: 20217
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Druid: Mark of the Wild - Buff: 79061
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Hunter: Embrace of the Shale Spider - Buff: 90363
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Leatherworking: Blessing of Forgotten Kings - Buff: 69378
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 4%.
    ["MOD_AGI"] = {
      {-- Blessing of Kings
        ["rank"] = {
          0.05,
        },
        ["buff"] = 20217,        -- ["Blessing of Kings"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Mark of the Wild
        ["rank"] = {
          0.05,
        },
        ["buff"] = 79061,        -- ["Mark of the Wild"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Embrace of the Shale Spider
        ["rank"] = {
          0.05,
        },
        ["buff"] = 90363,        -- ["Embrace of the Shale Spider"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Blessing of Forgotten Kings
        ["rank"] = {
          0.04,
        },
        ["buff"] = 69378,        -- ["Blessing of Forgotten Kings"],
        ["group"] = D["Stat Multiplier"],
      },
    },
    -- Paladin: Blessing of Kings - Buff: 20217
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Druid: Mark of the Wild - Buff: 79061
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Hunter: Embrace of the Shale Spider - Buff: 90363
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Leatherworking: Blessing of Forgotten Kings - Buff: 69378
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 4%.
    ["MOD_STA"] = {
      {-- Blessing of Kings
        ["rank"] = {
          0.05,
        },
        ["buff"] = 20217,        -- ["Blessing of Kings"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Mark of the Wild
        ["rank"] = {
          0.05,
        },
        ["buff"] = 79061,        -- ["Mark of the Wild"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Embrace of the Shale Spider
        ["rank"] = {
          0.05,
        },
        ["buff"] = 90363,        -- ["Embrace of the Shale Spider"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Blessing of Forgotten Kings
        ["rank"] = {
          0.04,
        },
        ["buff"] = 69378,        -- ["Blessing of Forgotten Kings"],
        ["group"] = D["Stat Multiplier"],
      },
    },
    --[[
        Up to level 80 1 stamina grants 10 health. But levels 81..85 that value increases. 
        It could be implemented as a GetHealthPerStamina(level) function (which i started to do), 
        but everyone would have to change their code to stop using the hard-coded "10 health per stamina".
        Instead we can code it as a set of conditional percentage modifiers for all classes in the "MOD_HEALTH" group
            Level    HP/sta    % increase
            =====    =======    ========
            80        10.0    0.00   (confirmed 10.0 12/12/2010, 4.0.3)
            81        10.8    0.08
            82        11.6    0.12   (confirmed 11.6 12/11/2010, 4.0.3)
            83        12.4    0.24   (confirmed 12.4 12/12/2010, 4.0.3)
            84        13.2    0.32
            85        14.0    0.40
            
        Question for Whitefang: Could the modifier be written as the following?:
                {
                    ["rank"] = { 0.08 * (UnitLevel('player') - 80) },
                    ["condition"] = "UnitLevel('player') >= 81"
                }
                
            It would be future proofed, but i don't know if it's right to code the rank based on a formula 
                (i.e. what happens if they ding?)
    --]]
    ["MOD_HEALTH"] = {
        -- Level 81..85
        {    
            ["rank"] = { 0.08, }, 
            ["condition"] = "UnitLevel('player') == 81", 
        },
        {    
            ["rank"] = { 0.12, }, 
            ["condition"] = "UnitLevel('player') == 82", 
        },
        {    
            ["rank"] = { 0.24, }, 
            ["condition"] = "UnitLevel('player') == 83", 
        },
        {    
            ["rank"] = { 0.32, }, 
            ["condition"] = "UnitLevel('player') == 84", 
        },
        {    
            ["rank"] = { 0.40, }, 
            ["condition"] = "UnitLevel('player') == 85", 
        },
    },
      
    -- Paladin: Blessing of Kings - Buff: 20217
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Druid: Mark of the Wild - Buff: 79061
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Hunter: Embrace of the Shale Spider - Buff: 90363
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 5%.
    -- Leatherworking: Blessing of Forgotten Kings - Buff: 69378
    -- 4.0.1: Strength, Agility, Stamina, and Intellect increased by 4%.
    ["MOD_INT"] = {
      {-- Blessing of Kings
        ["rank"] = {
          0.05,
        },
        ["buff"] = 20217,        -- ["Blessing of Kings"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Mark of the Wild
        ["rank"] = {
          0.05,
        },
        ["buff"] = 79061,        -- ["Mark of the Wild"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Embrace of the Shale Spider
        ["rank"] = {
          0.05,
        },
        ["buff"] = 90363,        -- ["Embrace of the Shale Spider"],
        ["group"] = D["Stat Multiplier"],
      },
      {-- Blessing of Forgotten Kings
        ["rank"] = {
          0.04,
        },
        ["buff"] = 69378,        -- ["Blessing of Forgotten Kings"],
        ["group"] = D["Stat Multiplier"],
      },
    },
    -- Shaman: Mana Tide - Buff: 16191
    -- 4.0.1: Spirit increased by 350%.
    -- Human: The Human Spirit - Racial
    -- 4.0.1: Spirit increased by 3%.
    ["MOD_SPI"] = {
      {-- Mana Tide
        ["rank"] = {
          3.5,
        },
        ["buff"] = 16191,        -- ["Mana Tide"],
      },
      {-- The Human Spirit
        ["rank"] = {
          0.03,
        },
        ["race"] = "Human",
      },
    },
  }

-- Generate buff names
for class, tables in pairs(StatModTable) do
  for modName, mods in pairs(tables) do
    for key, mod in pairs(mods) do
      if mod.buff then
        mod.buffName = GetSpellInfo(mod.buff) or "nil"
      end
      if mod.buff2 then
        mod.buff2Name = GetSpellInfo(mod.buff2) or "nil"
      end
    end
  end
end

local function IsMetaGemActive(item)
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
  local name, link, _, _, _, _, itemSubType = GetItemInfo(item)
  if not name or itemSubType ~= META_GEM then return end
  -- Start parsing
  tip:ClearLines() -- this is required or SetX won't work the second time its called
  tip:SetHyperlink(link)
  if not strfind(tip[3]:GetText(), "|cff808080") then
    -- Metagem requirements satisfied, check if metagem is equipped
    local headLink = GetInventoryItemLink("player", 1)
    if not headLink then return end
    local gemId = StatLogic:GetGemID(item)
    if not gemId then return end
    if strfind(headLink, ":"..gemId..":") then
      return true
    end
  end
end
StatLogic.IsMetaGemActive = IsMetaGemActive

local function SlotHasEnchant(enchantId, slotId)
  -- Check args
  if type(enchantId) ~= "number" then return end
  if (type(slotId) ~= "number") and (type(slotId) ~= "nil") then return end
  -- If slot is specified
  if type(slotId) == "number" then
    local slotLink = GetInventoryItemLink("player", slotId)
    if not slotLink then return end
    if strfind(slotLink, ":"..enchantId..":") then
      return 1
    end
  else
    -- check all slots 1 to 18 if slotId is nil
    local count = 0
    for slotId = 1, 18 do
      local slotLink = GetInventoryItemLink("player", slotId)
      if slotLink and strfind(slotLink, ":"..enchantId..":") then
        count = count + 1
      end
    end
    if count ~= 0 then
      return count
    end
  end
end
StatLogic.SlotHasEnchant = SlotHasEnchant

--[[---------------------------------
  :GetStatMod(stat, school)
-------------------------------------
Notes:
  * Calculates various stat mod values from talents and buffs.
  * initialValue: sets the initial value for the stat mod.
  ::if initialValue == 0, inter-mod operations are done with addition,
  ::if initialValue == 1, inter-mod operations are done with multiplication,
  * finalAdjust: added to the final result before returning, so we can adjust the return value to be used in addition or multiplication.
  :: for addition: initialValue + finalAdjust = 0
  :: for multiplication: initialValue + finalAdjust = 1
  * stat:
  :{| class="wikitable"
  !"StatMod"!!Initial value!!Final adjust!!schoo required
  |-
  |"ADD_CRIT_TAKEN"||0||0||Yes
  |-
  |"ADD_HIT_TAKEN"||0||0||Yes
  |-
  |"ADD_DODGE"||0||0||No
  |-
  |"ADD_AP_MOD_INT"||0||0||No
  |-
  |"ADD_AP_MOD_STA"||0||0||No
  |-
  |"ADD_AP_MOD_ARMOR"||0||0||No
  |-
  |"ADD_PARRY_RATING_MOD_STR"||0||0||No
  |-
  |"ADD_COMBAT_MANA_REGEN_MOD_INT"||0||0||No
  |-
  |"ADD_RANGED_AP_MOD_INT"||0||0||No
  |-
  |"ADD_ARMOR_MOD_INT"||0||0||No
  |-
  |"ADD_SPELL_DMG_MOD_AP"||0||0||No
  |-
  |"ADD_SPELL_DMG_MOD_STA"||0||0||No
  |-
  |"ADD_SPELL_DMG_MOD_INT"||0||0||No
  |-
  |"ADD_SPELL_DMG_MOD_SPI"||0||0||No
  |-
  |"ADD_HEAL_MOD_AP"||0||0||No
  |-
  |"ADD_HEAL_MOD_STR"||0||0||No
  |-
  |"ADD_HEAL_MOD_AGI"||0||0||No
  |-
  |"ADD_HEAL_MOD_STA"||0||0||No
  |-
  |"ADD_HEAL_MOD_INT"||0||0||No
  |-
  |"ADD_HEAL_MOD_SPI"||0||0||No
  |-
  |"ADD_COMBAT_MANA_REGEN_MOD_MANA_REGEN"||0||0||No
  |-
  |"MOD_CRIT_DAMAGE_TAKEN"||0||1||Yes
  |-
  |"MOD_DMG_TAKEN"||0||1||Yes
  |-
  |"MOD_CRIT_DAMAGE"||0||1||Yes
  |-
  |"MOD_DMG"||0||1||Yes
  |-
  |"MOD_ARMOR"||1||0||No
  |-
  |"MOD_HEALTH"||1||0||No
  |-
  |"MOD_MANA"||1||0||No
  |-
  |"MOD_STR"||0||1||No
  |-
  |"MOD_AGI"||0||1||No
  |-
  |"MOD_STA"||0||1||No
  |-
  |"MOD_INT"||0||1||No
  |-
  |"MOD_SPI"||0||1||No
  |-
  |"MOD_BLOCK_VALUE"||0||1||No
  |-
  |"MOD_AP"||0||1||No
  |-
  |"MOD_RANGED_AP"||0||1||No
  |-
  |"MOD_SPELL_DMG"||0||1||No
  |-
  |"MOD_HEAL"||0||1||No
  |}
Arguments:
  string - The type of stat mod you want to get
  [optional] string - Certain stat mods require an extra school argument
  [optional] string - Target spec to check
  [optional] string - modTable to check, "CLASS", "ALL", "BOTH"(default)
Returns:
  None
Example:
  StatLogic:GetStatMod("MOD_INT")
-----------------------------------]]
local buffGroup = {}
function StatLogic:GetStatMod(stat, school, talentGroup, modTable)
  local statModInfo = StatModInfo[stat]
  
    --Check that it wasn't an invalid stat
    if (statModInfo == nil) then
        local sError = "StatLogic:GetStatMod() Invalid stat mod requested \""..stat.."\""
        print(sError)
        error(sError)
    end
        
    local mod = statModInfo.initialValue
    -- if school is required for this statMod but not given
    if statModInfo.school and not school then
        --print("school is required for this stat, but none given. Returning finalAdjust value")
        return mod + statModInfo.finalAdjust 
    end
    -- disable for 4.0.1 until we get talent/buffs data implemented
    --if toc >= 40000 then return mod + statModInfo.finalAdjust end
    wipe(buffGroup)
  
  if not modTable then modTable = "BOTH" end
    
    -- Class specific mods
    if type(StatModTable[playerClass][stat]) == "table" and modTable ~= "ALL" then
    
        for _, case in ipairs(StatModTable[playerClass][stat]) do
        
            local ok = true
            if school and not case[school] then ok = nil end
            
            if ok and case.newtoc and toc < case.newtoc then ok = nil end
            if ok and case.oldtoc and toc >= case.oldtoc then ok = nil end
            if ok and case.new and wowBuildNo < case.new then ok = nil end
            if ok and case.old and wowBuildNo >= case.old then ok = nil end
            if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
            if ok and case.buffName and not PlayerHasAura(case.buffName) then ok = nil end
            if ok and case.buff2Name and not PlayerHasAura(case.buff2Name) then ok = nil end
            if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
            if ok and case.glyph and not PlayerHasGlyph(case.glyph, talentGroup) then ok = nil end
            if ok and case.enchant and not SlotHasEnchant(case.enchant, case.slot) then ok = nil end
            if ok and case.itemset and ((not PlayerItemSets[case.itemset[1]]) or PlayerItemSets[case.itemset[1]] < case.itemset[2]) then ok = nil end
            if ok and case.armorspec and case.armorspec ~= ArmorSpecActive then ok = nil end
            if ok and case.known and not IsSpellKnown(case.known) then ok = nil end
            
            if ok then
                local r, _
                local s = 1
                -- if talent field
                if case.tab and case.num then
                    _, _, _, _, r = GetTalentInfo(case.tab, case.num, nil, nil, talentGroup)
                    if case.buffName and case.buffStack then
                        _, s = GetPlayerAuraRankStack(case.buffName) -- Gets buff stack count, but use talent as rank
                    end
                    -- no talent but buff is given
                elseif case.buffName then
                    r, s = GetPlayerAuraRankStack(case.buffName)
                    if not case.buffStack then
                        s = 1
                    end
                    -- no talent but all other given conditions are statisfied
                else--if case.condition or case.stance then
                    r = 1
                end
                if r and case.rank[r] then
                    if statModInfo.initialValue == 0 and not case.mul then
                        if not case.group then
                            mod = mod + case.rank[r] * s
                        elseif not buffGroup[case.group] then -- this mod is part of a group, but not seen before
                            mod = mod + case.rank[r] * s
                            buffGroup[case.group] = case.rank[r] * s
                        elseif (case.rank[r] * s) > buffGroup[case.group] then -- seen before and this one is better, do upgrade
                            mod = mod + case.rank[r] * s - buffGroup[case.group]
                            buffGroup[case.group] = case.rank[r] * s
                        else -- seen before but not better, do nothing
                        end
                    else
                        if not case.group then
                            mod = mod * (case.rank[r] * s + 1)
                        elseif not buffGroup[case.group] then -- this mod is part of a group, but not seen before
                            mod = mod * (case.rank[r] * s + 1)
                            buffGroup[case.group] = (case.rank[r] * s + 1)
                        elseif (case.rank[r] * s + 1) > buffGroup[case.group] then -- seen before and this one is better, do upgrade
                            mod = mod * (case.rank[r] * s + 1) / buffGroup[case.group]
                            buffGroup[case.group] = (case.rank[r] * s + 1)
                        else -- seen before but not better, do nothing
                        end
                    end
                end
            end
        end
    end
    
    -- Non class specific mods
    if type(StatModTable["ALL"][stat]) == "table" and modTable ~= "CLASS"  then
        for _, case in ipairs(StatModTable["ALL"][stat]) do
            local ok = true
            if school and not case[school] then ok = nil end
            if ok and case.newtoc and toc < case.newtoc then ok = nil end
            if ok and case.oldtoc and toc >= case.oldtoc then ok = nil end
            if ok and case.new and wowBuildNo < case.new then ok = nil end
            if ok and case.old and wowBuildNo >= case.old then ok = nil end
            if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
            if ok and case.buffName and not PlayerHasAura(case.buffName) then ok = nil end
            if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
            if ok and case.race and case.race ~= playerRace then ok = nil end
            if ok and case.meta and not IsMetaGemActive(case.meta) then ok = nil end
            if ok then
                local r, _
                local s = 1
                -- if talent field
                if case.tab and case.num then
                    _, _, _, _, r = GetTalentInfo(case.tab, case.num, nil, nil, talentGroup)
                    if case.buffName and case.buffStack then
                        _, s = GetPlayerAuraRankStack(case.buffName) -- Gets buff rank and stack count
                    end
                    -- no talent but buff is given
                elseif case.buffName then
                    r, s = GetPlayerAuraRankStack(case.buffName)
                    if not case.buffStack then
                        s = 1
                    end
                    -- no talent but all other given conditions are statisfied
                else--if case.condition or case.stance then
                    r = 1
                end
                if r and case.rank[r] then
                    if statModInfo.initialValue == 0 then
                        if not case.group then
                            mod = mod + case.rank[r] * s
                        elseif not buffGroup[case.group] then -- this mod is part of a group, but not seen before
                            mod = mod + case.rank[r] * s
                            buffGroup[case.group] = case.rank[r] * s
                        elseif (case.rank[r] * s) > buffGroup[case.group] then -- seen before and this one is better, do upgrade
                            mod = mod + case.rank[r] * s - buffGroup[case.group]
                            buffGroup[case.group] = case.rank[r] * s
                        else -- seen before but not better, do nothing
                        end
                    else
                        if not case.group then
                            mod = mod * (case.rank[r] * s + 1)
                        elseif not buffGroup[case.group] then -- this mod is part of a group, but not seen before
                            mod = mod * (case.rank[r] * s + 1)
                            buffGroup[case.group] = (case.rank[r] * s + 1)
                        elseif (case.rank[r] * s + 1) > buffGroup[case.group] then -- seen before and this one is better, do upgrade
                            mod = mod * (case.rank[r] * s + 1) / buffGroup[case.group]
                            buffGroup[case.group] = (case.rank[r] * s + 1)
                        else -- seen before but not better, do nothing
                        end
                    end
                end
            end
        end
    end

    return mod + statModInfo.finalAdjust
end

--=====================================--
-- Avoidance stats diminishing returns --
--=====================================--
-- Formula reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
--[[---------------------------------
This includes
1. Dodge from Dodge Rating, Defense, Agility.
2. Parry from Parry Rating, Defense.
3. Chance to be missed from Defense.

The following is the result of hours of work gathering data from beta servers and then spending even more time running multiple regression analysis on the data.

1. DR for Dodge, Parry, Missed are calculated separately.
2. Base avoidances are not affected by DR, (ex: Dodge from base Agility)
3. Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
4. Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
5. Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
6. c and k values depend on class but does not change with level.

7. The DR formula:

1/x' = 1/c+k/x

x' is the diminished stat before converting to IEEE754.
x is the stat before diminishing returns.
c is the cap of the stat, and changes with class.
k is is a value that changes with class.
-----------------------------------]]
-- The following K, C_p, C_d are calculated by Whitetooth (hotdogee [at] gmail [dot] com)
local K = {
  0.956, 0.956, 0.988, 0.988, 0.983, 0.956, 0.988, 0.983, 0.983, 0.972,
  --["WARRIOR"]     = 0.956,
  --["PALADIN"]     = 0.956,
  --["HUNTER"]      = 0.988,
  --["ROGUE"]       = 0.988,
  --["PRIEST"]      = 0.983,
  --["DEATHKNIGHT"] = 0.956,
  --["SHAMAN"]      = 0.988,
  --["MAGE"]        = 0.983,
  --["WARLOCK"]     = 0.983,
  --["DRUID"]       = 0.972,
}
local C_p = {
  1/0.0152366, 1/0.0152366, 1/0.006870, 1/0.006870, 1/0.0152366, 1/0.0152366, 1/0.006870, 1/0.0152366, 1/0.0152366, 1/0.0152366,
  --["WARRIOR"]     = 1/0.0152366,
  --["PALADIN"]     = 1/0.0152366,
  --["HUNTER"]      = 1/0.006870,
  --["ROGUE"]       = 1/0.006870,
  --["PRIEST"]      = 0, --use tank stats
  --["DEATHKNIGHT"] = 1/0.0152366,
  --["SHAMAN"]      = 1/0.006870,
  --["MAGE"]        = 0, --use tank stats
  --["WARLOCK"]     = 0, --use tank stats
  --["DRUID"]       = 0, --use tank stats
}
local C_d = {
  1/0.0152366, 1/0.0152366, 1/0.006870, 1/0.006870, 1/0.006650, 1/0.0152366, 1/0.006870, 1/0.006650, 1/0.006650, 1/0.008555,
  --["WARRIOR"]     = 1/0.0152366,
  --["PALADIN"]     = 1/0.0152366,
  --["HUNTER"]      = 1/0.006870,
  --["ROGUE"]       = 1/0.006870,
  --["PRIEST"]      = 1/0.006650,
  --["DEATHKNIGHT"] = 1/0.0152366,
  --["SHAMAN"]      = 1/0.006870,
  --["MAGE"]        = 1/0.006650,
  --["WARLOCK"]     = 1/0.006650,
  --["DRUID"]       = 1/0.008555,
}

-- I've done extensive tests that show the miss cap is 16% for warriors.
-- Because the only tank I have with 150 pieces of epic gear required for the tests is a warrior,
-- Until someone that has the will and gear to preform the tests for other classes, I'm going to assume the cap is the same(which most likely isn't)
local C_m = {16, 16, 16, 16, 16, 16, 16, 16, 16, 16, }

function StatLogic:GetMissedChanceBeforeDR()
  local baseDefense, additionalDefense = UnitDefense("player")
  local defenseFromDefenseRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL))
  local modMissed = defenseFromDefenseRating * 0.04
  local drFreeMissed = 5 + (baseDefense + additionalDefense - defenseFromDefenseRating) * 0.04
  return modMissed, drFreeMissed
end
--[[---------------------------------
  :GetDodgeChanceBeforeDR()
-------------------------------------
Notes:
  * Calculates your current Dodge% before diminishing returns.
  * Dodge% = modDodge + drFreeDodge
  * drFreeDodge includes:
  ** Base dodge
  ** Dodge from base agility
  ** Dodge modifier from base defense
  ** Dodge modifers from talents or spells
  * modDodge includes
  ** Dodge from dodge rating
  ** Dodge from additional defense
  ** Dodge from additional dodge
Arguments:
  None
Returns:
  ; modDodge : number - The part that is affected by diminishing returns.
  ; drFreeDodge : number - The part that isn't affected by diminishing returns.
Example:
  local modDodge, drFreeDodge = StatLogic:GetDodgeChanceBeforeDR()
-----------------------------------]]
local BaseDodge
function StatLogic:GetDodgeChanceBeforeDR()
  local class = ClassNameToID[playerClass]

  -- drFreeDodge
  local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 2) -- 2 = Agility
  local baseAgi = stat - posBuff - negBuff
  local dodgePerAgi = self:GetDodgePerAgi()
  --[[
  local drFreeDodge = BaseDodge[class] + dodgePerAgi * baseAgi
    + self:GetStatMod("ADD_DODGE") + (baseDefense - UnitLevel("player") * 5) * 0.04
  --]]
  -- modDodge
  local dodgeFromDodgeRating = self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, UnitLevel("player"))
  local dodgeFromDefenceRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL)) * 0.04
  local dodgeFromAdditionalAgi = dodgePerAgi * (effectiveStat - baseAgi)
  local modDodge = dodgeFromDodgeRating + dodgeFromDefenceRating + dodgeFromAdditionalAgi

  local drFreeDodge = GetDodgeChance() - self:GetAvoidanceAfterDR("DODGE", modDodge, class)

  return modDodge, drFreeDodge
end

--[[---------------------------------
  :GetParryChanceBeforeDR()
-------------------------------------
Notes:
  * Calculates your current Parry% before diminishing returns.
  * Parry% = modParry + drFreeParry
  * drFreeParry includes:
  ** Base parry
  ** Parry from base agility
  ** Parry modifier from base defense
  ** Parry modifers from talents or spells
  * modParry includes
  ** Parry from parry rating
  ** Parry from additional defense
  ** Parry from additional parry
Arguments:
  None
Returns:
  ; modParry : number - The part that is affected by diminishing returns.
  ; drFreeParry : number - The part that isn't affected by diminishing returns.
Example:
  local modParry, drFreeParry = StatLogic:GetParryChanceBeforeDR()
-----------------------------------]]
function StatLogic:GetParryChanceBeforeDR()
  local class = ClassNameToID[playerClass]

  -- Defense is floored
  local parryFromParryRating = self:GetEffectFromRating(GetCombatRating(CR_PARRY), CR_PARRY)
  local parryFromDefenceRating = floor(self:GetEffectFromRating(GetCombatRating(CR_DEFENSE_SKILL), CR_DEFENSE_SKILL)) * 0.04
  local modParry = parryFromParryRating + parryFromDefenceRating

  -- drFreeParry
  local drFreeParry = GetParryChance() - self:GetAvoidanceAfterDR("PARRY", modParry, class)

  return modParry, drFreeParry
end

--[[---------------------------------
  :GetAvoidanceAfterDR(avoidanceType, avoidanceBeforeDR[, class])
-------------------------------------
Notes:
  * Avoidance DR formula and k, C_p, C_d constants derived by Whitetooth (hotdogee [at] gmail [dot] com)
  * avoidanceBeforeDR is the part that is affected by diminishing returns.
  * See :GetClassIdOrName(class) for valid class values.
  * Calculates the avoidance after diminishing returns, this includes:
  *# Dodge from Dodge Rating, Defense, Agility.
  *# Parry from Parry Rating, Defense.
  *# Chance to be missed from Defense.
  * The DR formula: 1/x' = 1/c+k/x
  ** x' is the diminished stat before converting to IEEE754.
  ** x is the stat before diminishing returns.
  ** c is the cap of the stat, and changes with class.
  ** k is is a value that changes with class.
  * Formula details:
  *# DR for Dodge, Parry, Missed are calculated separately.
  *# Base avoidances are not affected by DR, (ex: Dodge from base Agility)
  *# Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
  *# Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
  *# Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
  *# c and k values depend on class but does not change with level.
  :{| class="wikitable"
  ! !!k!!C_p!!1/C_p!!C_d!!1/C_d
  |-
  |Warrior||0.9560||47.003525||0.021275||88.129021||0.011347
  |-
  |Paladin||0.9560||47.003525||0.021275||88.129021||0.011347
  |-
  |Hunter||0.9880||145.560408||0.006870||145.560408||0.006870
  |-
  |Rogue||0.9880||145.560408||0.006870||145.560408||0.006870
  |-
  |Priest||0.9530||0||0||150.375940||0.006650
  |-
  |Deathknight||0.9560||47.003525||0.021275||88.129021||0.011347
  |-
  |Shaman||0.9880||145.560408||0.006870||145.560408||0.006870
  |-
  |Mage||0.9530||0||0||150.375940||0.006650
  |-
  |Warlock||0.9530||0||0||150.375940||0.006650
  |-
  |Druid||0.9720||0||0||116.890707||0.008555
  |}
Arguments:
  string - "DODGE", "PARRY", "MELEE_HIT_AVOID"(NYI)
  number - amount of avoidance before diminishing returns in percentages.
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; avoidanceAfterDR : number - avoidance after diminishing returns in percentages.
Example:
  local modParry, drFreeParry = StatLogic:GetParryChanceBeforeDR()
  local modParryAfterDR = StatLogic:GetAvoidanceAfterDR("PARRY", modParry)
  local parry = modParryAfterDR + drFreeParry

  local modParryAfterDR = StatLogic:GetAvoidanceAfterDR("PARRY", modParry, "WARRIOR")
  local parry = modParryAfterDR + drFreeParry
-----------------------------------]]
function StatLogic:GetAvoidanceAfterDR(avoidanceType, avoidanceBeforeDR, class)
  -- argCheck for invalid input
  self:argCheck(avoidanceType, 2, "string")
  self:argCheck(avoidanceBeforeDR, 3, "number")
  self:argCheck(class, 4, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end

  local C = C_d
  if avoidanceType == "PARRY" then
    C = C_p
  elseif avoidanceType == "MELEE_HIT_AVOID" then
    C = C_m
  end

  return 1 / (1 / C[class] + K[class] / avoidanceBeforeDR)
end

--[[---------------------------------
  :GetAvoidanceGainAfterDR(avoidanceType, gainBeforeDR)
-------------------------------------
Notes:
  * Calculates the avoidance gain after diminishing returns with player's current stats.
Arguments:
  string - "DODGE", "PARRY", "MELEE_HIT_AVOID"(NYI)
  number - Avoidance gain before diminishing returns in percentages.
Returns:
  ; gainAfterDR : number - Avoidance gain after diminishing returns in percentages.
Example:
  -- How much dodge will I gain with +30 Agi after DR?
  local gainAfterDR = StatLogic:GetAvoidanceGainAfterDR("DODGE", 30*StatLogic:GetDodgePerAgi())
  -- How much dodge will I gain with +20 Parry Rating after DR?
  local gainAfterDR = StatLogic:GetAvoidanceGainAfterDR("PARRY", StatLogic:GetEffectFromRating(20, CR_PARRY))
-----------------------------------]]
function StatLogic:GetAvoidanceGainAfterDR(avoidanceType, gainBeforeDR)
  -- argCheck for invalid input
  self:argCheck(gainBeforeDR, 2, "number")
  local class = ClassNameToID[playerClass]

  if avoidanceType == "PARRY" then
    local modAvoidance, drFreeAvoidance = self:GetParryChanceBeforeDR()
    local newAvoidanceChance = self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) + drFreeAvoidance
    if newAvoidanceChance < 0 then newAvoidanceChance = 0 end
    return newAvoidanceChance - GetParryChance()
  elseif avoidanceType == "DODGE" then
    local modAvoidance, drFreeAvoidance = self:GetDodgeChanceBeforeDR()
    local newAvoidanceChance = self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) + drFreeAvoidance
    if newAvoidanceChance < 0 then newAvoidanceChance = 0 end -- because GetDodgeChance() is 0 when negative
    return newAvoidanceChance - GetDodgeChance()
  elseif avoidanceType == "MELEE_HIT_AVOID" then
    local modAvoidance = self:GetMissedChanceBeforeDR()
    return self:GetAvoidanceAfterDR(avoidanceType, modAvoidance + gainBeforeDR) - self:GetAvoidanceAfterDR(avoidanceType, modAvoidance)
  end
end


function StatLogic:GetResilienceEffectAfterDR(damageReductionBeforeDR)
  -- argCheck for invalid input
  self:argCheck(damageReductionBeforeDR, 2, "number")
  return 100 - 100 * 0.99 ^ damageReductionBeforeDR
end

function StatLogic:GetResilienceEffectGainAfterDR(resAfter, resBefore)
  -- argCheck for invalid input
  self:argCheck(resAfter, 2, "number")
  self:argCheck(resBefore, 2, "nil", "number")
  local resCurrent = GetCombatRating(16)
  local drBefore
  if resBefore then
    drBefore = self:GetResilienceEffectAfterDR(self:GetEffectFromRating(resCurrent + resBefore, 16))
  else
    drBefore = GetCombatRatingBonus(16)
  end
  return self:GetResilienceEffectAfterDR(self:GetEffectFromRating(resCurrent + resAfter, 16)) - drBefore
end


--=================--
-- Stat Conversion --
--=================--
--[[---------------------------------
  :GetReductionFromArmor(armor, attackerLevel)
-------------------------------------
Notes:
  * Calculates the damage reduction from armor for given attacker level.
Arguments:
  [optional] number - Armor value. Default: player's armor value
  [optional] number - Attacker level. Default: player's level
Returns:
  ; damageRecudtion : number - Damage reduction value from 0 to 1. (not percentage)
Example:
  local damageRecudtion = StatLogic:GetReductionFromArmor(35000, 80) -- 0.69676006569452
-----------------------------------]]
function StatLogic:GetReductionFromArmor(armor, attackerLevel)
  self:argCheck(armor, 2, "nil", "number")
  self:argCheck(attackerLevel, 3, "nil", "number")
  if not armor then
    armor = select(2, UnitArmor("player"))
  end
  if not attackerLevel then
    attackerLevel = UnitLevel("player")
  end

  local levelModifier = attackerLevel
  if ( levelModifier > 80 ) then
    levelModifier = levelModifier + (4.5 * (levelModifier - 59)) + (20 * (levelModifier - 80));
  elseif ( levelModifier > 59 ) then
    levelModifier = levelModifier + (4.5 * (levelModifier - 59))
  end
  local temp = armor / (85 * levelModifier + 400)
  local armorReduction = temp / (1 + temp)
  -- caps at 0.75
  if armorReduction > 0.75 then
    armorReduction = 0.75
  end
  if armorReduction < 0 then
    armorReduction = 0
  end
  return armorReduction
end

--[[---------------------------------
  :GetEffectFromDefense(defense, attackerLevel)
-------------------------------------
Notes:
  * Calculates the effective avoidance% from defense (before diminishing returns) for given attacker level
Arguments:
  [optional] string - Total defense value. Default: player's armor value
  [optional] number - Attacker level. Default: player's level
Returns:
  ; effect : number - 0.04% per effective defense.
Example:
  local effect = StatLogic:GetEffectFromDefense(415, 83) -- 0
-----------------------------------]]
function StatLogic:GetEffectFromDefense(defense, attackerLevel)
  self:argCheck(defense, 2, "nil", "number")
  self:argCheck(attackerLevel, 3, "nil", "number")
  if not defense then
    local base, add = UnitDefense("player")
    defense = base + add
  end
  if not attackerLevel then
    attackerLevel = UnitLevel("player")
  end
  return (defense - attackerLevel * 5) * 0.04
end

-- Build Mastery tables
-- MasterSpells[class][specid]
local MasterySpells = {
  {{76838}, {76856}, {76857}}, --WARRIOR
  {{76669}, {76671}, {76672}}, --PALADIN
  {{76657}, {76659}, {76658}}, --HUNTER
  {{76803}, {76806}, {76808}}, --ROGUE
  {{77484}, {77485}, {77486}}, --PRIEST
  {{77513}, {77514}, {77515}}, --DEATHKNIGHT
  {{77222}, {77223}, {77226}}, --SHAMAN
  {{76547}, {76595}, {76613}}, --MAGE
  {{77215}, {77219}, {77220}}, --WARLOCK
  {{77492}, {77494, 77493}, {77495}}, --DRUID
}
StatLogic.MasterySpells = MasterySpells

-- MasteryEffect[class][specid]
local MasteryEffect = {}
if wowBuildNo >= 13221 then
MasteryEffect = {
  {{2},   {4.70}, {1.5,1.5}}, --WARRIOR (1) (Strikes of Opportunity 2%, Unshackled Fury 4.70%, Block Chance 1.5% & Critical Block Chance 1.5%)
  {{1},   {2.25}, {1}      }, --PALADIN (2) (Illuminated Healing 1%, Divine Bulwark 2.25%, Hand of Light 1%)
  {{1.7}, {2},    {1}      }, --HUNTER (3)
  {{3.5}, {2},    {2.5}    }, --ROGUE (4)
  {{2.5}, {1.25}, {4.3}    }, --PRIEST (5)
  {{6.25},{2},    {4}      }, --DEATHKNIGHT (6)
  {{2},   {2.5},  {2.5}    }, --SHAMAN (7)
  {{1.5}, {2.5},  {2.5}    }, --MAGE (8)
  {{1.63},{1.5},  {1.25}   }, --WARLOCK (9)
  {{1.5}, {4,3.1},{1.25}   }  --DRUID (10)
}
else
MasteryEffect = {
  {{2},{3.13},{1.25}},
  {{1},{2},{1}},
  {{1.7},{2},{1}},
  {{2.5},{1.25},{2.5}},
  {{2.5},{1.25},{4.3}},
  {{6.25},{2},{4}},
  {{2},{2.5},{2.5}},
  {{1.5},{2.5},{2.5}},
  {{1.63},{1.5},{1.25}},
  {{1.5},{4,3.1},{1.25}}
}
end
StatLogic.MasteryEffect = MasteryEffect
-- Parse spell tooltip text and populate MasteryEffect, run this if mastery values change
-- function MakeMasteryEffect()
  -- for class, specs in ipairs(MasterySpells) do
    -- MasteryEffect[class] = {}
    -- print(strsub(ClassNameToID[class], 1, 1)..strsub(strlower(ClassNameToID[class]), 2))
    -- for spec, spellids in ipairs(specs) do
      -- MasteryEffect[class][spec] = {}
      -- for i, spellid in ipairs(spellids) do
        -- tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
        -- tipMiner:AddSpellByID(spellid)
        -- print((GetSpellInfo(spellid)))
        -- print("Spec: "..(select(2, GetTalentTabInfo(spec))))
        -- print("SpellId: "..spellid)
        -- local descText = _G[MAJOR.."MinerTooltipTextLeft2"]:GetText()
        -- if not descText:find("([%.%d]+)%%") then
          -- descText = _G[MAJOR.."MinerTooltipTextLeft3"]:GetText()
          -- print(_G[MAJOR.."MinerTooltipTextLeft3"]:GetText() or "nil")
        -- else
          -- print(_G[MAJOR.."MinerTooltipTextLeft2"]:GetText() or "nil")
        -- end
        -- local effects = {}
        -- for e in descText:gmatch("([%.%d]+)%%") do
          -- tinsert(effects, tonumber(e))
        -- end
        -- if #effects == 2 then
          -- tinsert(MasteryEffect[class][spec], effects[2])
        -- elseif #effects == 3 then
          -- tinsert(MasteryEffect[class][spec], effects[3])
        -- elseif #effects == 4 then
          -- tinsert(MasteryEffect[class][spec], effects[3])
          -- tinsert(MasteryEffect[class][spec], effects[4])
        -- end
        -- --print(_G[MAJOR.."MinerTooltipTextLeft1"]:GetText() or "nil")
        -- --print(_G[MAJOR.."MinerTooltipTextLeft2"]:GetText() or "nil")
        -- --print(_G[MAJOR.."MinerTooltipTextLeft3"]:GetText() or "nil")
        -- --print("---------")
      -- end
    -- end
  -- end
  -- return MasteryEffect
-- end

--[[---------------------------------
  :GetEffectFromMastery(mastery[, specid][, class])
-------------------------------------
Notes:
  * Calculates the effect in percentage from mastery for given spec and class
Arguments:
  number - mastery value.
  [optional] number - talent spec to use. Default: player's talent spec
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
            1=first, 2=second, 3=third (e.g. Paladin: 1=Holy, 2=Protection, 3=Retribution)
Returns:
  ; effect : number - 0.04% per effective defense.
Example:
  local effect = StatLogic:GetEffectFromMastery(415) -- 0
-----------------------------------]]
function StatLogic:GetEffectFromMastery(mastery, specid, class)
  self:argCheck(mastery, 2, "number")
  self:argCheck(specid, 3, "nil", "number")
  if type(specid) ~= "number" or specid < 1 or specid > 3 then
    specid = GetPrimaryTalentTree()
    if not specid then return 0 end
  end
  -- argCheck for invalid input
  self:argCheck(class, 4, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" then
    class = ClassNameToID[strupper(class)] or ClassNameToID[playerClass]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  return mastery * MasteryEffect[class][specid][1], mastery * (MasteryEffect[class][specid][2] or 0)
end


--[[---------------------------------
  :GetEffectFromRating(rating, id[, level][, class])
-------------------------------------
Notes:
  * Combat Rating formula and constants derived by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the stat effects from ratings for any level.
  * id: Rating ID as definded in PaperDollFrame.lua
  ::CR_WEAPON_SKILL = 1
  ::CR_DEFENSE_SKILL = 2
  ::CR_DODGE = 3
  ::CR_PARRY = 4
  ::CR_BLOCK = 5
  ::CR_HIT_MELEE = 6
  ::CR_HIT_RANGED = 7
  ::CR_HIT_SPELL = 8
  ::CR_CRIT_MELEE = 9
  ::CR_CRIT_RANGED = 10
  ::CR_CRIT_SPELL = 11
  ::CR_HIT_TAKEN_MELEE = 12
  ::CR_HIT_TAKEN_RANGED = 13
  ::CR_HIT_TAKEN_SPELL = 14
  ::CR_CRIT_TAKEN_MELEE = 15
  ::CR_CRIT_TAKEN_RANGED = 16
  ::CR_CRIT_TAKEN_SPELL = 17
  ::CR_HASTE_MELEE = 18
  ::CR_HASTE_RANGED = 19
  ::CR_HASTE_SPELL = 20
  ::CR_WEAPON_SKILL_MAINHAND = 21
  ::CR_WEAPON_SKILL_OFFHAND = 22
  ::CR_WEAPON_SKILL_RANGED = 23
  ::CR_EXPERTISE = 24
  ::CR_ARMOR_PENETRATION = 25
  * The Combat Rating formula:
  ** Percentage = Rating / RatingBase / H
  *** Level 1 to 10:  H = 2/52
  *** Level 10 to 60: H = (level-8)/52
  *** Level 60 to 70: H = 82/(262-3*level)
  *** Level 70 to 80: H = (82/52)*(131/63)^((level-70)/10)
  ::{| class="wikitable"
  !RatingID!!RatingBase
  |-
  |CR_WEAPON_SKILL||2.5
  |-
  |CR_DEFENSE_SKILL||1.5
  |-
  |CR_DODGE||12
  |-
  |CR_PARRY||15
  |-
  |CR_BLOCK||5
  |-
  |CR_HIT_MELEE||10
  |-
  |CR_HIT_RANGED||10
  |-
  |CR_HIT_SPELL||8
  |-
  |CR_CRIT_MELEE||14
  |-
  |CR_CRIT_RANGED||14
  |-
  |CR_CRIT_SPELL||14
  |-
  |CR_HIT_TAKEN_MELEE||10
  |-
  |CR_HIT_TAKEN_RANGED||10
  |-
  |CR_HIT_TAKEN_SPELL||8
  |-
  |CR_CRIT_TAKEN_MELEE||25
  |-
  |CR_CRIT_TAKEN_RANGED||25
  |-
  |CR_CRIT_TAKEN_SPELL||25
  |-
  |CR_HASTE_MELEE||10
  |-
  |CR_HASTE_RANGED||10
  |-
  |CR_HASTE_SPELL||10
  |-
  |CR_WEAPON_SKILL_MAINHAND||2.5
  |-
  |CR_WEAPON_SKILL_OFFHAND||2.5
  |-
  |CR_WEAPON_SKILL_RANGED||2.5
  |-
  |CR_EXPERTISE||2.5
  |-
  |CR_ARMOR_PENETRATION||4.69512176513672
  |}
  * Parry Rating, Defense Rating, Block Rating and Resilience: Low-level players will now convert these ratings into their corresponding defensive stats at the same rate as level 34 players.
Arguments:
  number - Rating value
  number - Rating ID as defined in PaperDollFrame.lua
  [optional] number - Level used in calculations. Default: player's level
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; effect : number - Effect value
  ; effect name : string - Stat ID of converted effect, ex: "DODGE", "PARRY"
Example:
  StatLogic:GetEffectFromRating(10, CR_DODGE)
  StatLogic:GetEffectFromRating(10, CR_DODGE, 70)
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
CR_ARMOR_PENETRATION = 25;
CR_MASTERY = 26;
--]]

-- Level 60 rating base
local RatingBase
RatingBase = {
  [CR_WEAPON_SKILL] = 2.5,
  [CR_DEFENSE_SKILL] = 1.5,
  [CR_DODGE] = 13.8,
  [CR_PARRY] = 13.8,
  [CR_BLOCK] = 6.9,
  [CR_HIT_MELEE] = 9.37931,
  [CR_HIT_RANGED] = 9.37931,
  [CR_HIT_SPELL] = 8,
  [CR_CRIT_MELEE] = 14,
  [CR_CRIT_RANGED] = 14,
  [CR_CRIT_SPELL] = 14,
  [CR_HIT_TAKEN_MELEE] = 10, -- hit avoidance
  [CR_HIT_TAKEN_RANGED] = 10,
  [CR_HIT_TAKEN_SPELL] = 8,
  [COMBAT_RATING_RESILIENCE_CRIT_TAKEN] = 9.58333301544189, -- resilience
  [COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN] = 9.58333301544189,
  [CR_CRIT_TAKEN_SPELL] = 28.75,
  [CR_HASTE_MELEE] = 10, -- changed in 2.2
  [CR_HASTE_RANGED] = 10, -- changed in 2.2
  [CR_HASTE_SPELL] = 10, -- changed in 2.2
  [CR_WEAPON_SKILL_MAINHAND] = 2.5,
  [CR_WEAPON_SKILL_OFFHAND] = 2.5,
  [CR_WEAPON_SKILL_RANGED] = 2.5,
  [CR_EXPERTISE] = 2.34483,
  [CR_ARMOR_PENETRATION] = 4.69512176513672 / 1.1, -- still manually calculated cause its still 4.69 in dbc
  [CR_MASTERY] = 14,
}
if wowBuildNo >= 13914 then
RatingBase[COMBAT_RATING_RESILIENCE_CRIT_TAKEN] = 0
RatingBase[COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN] = 7.96417713165283
end
local Level34Ratings
Level34Ratings = {
  [CR_DEFENSE_SKILL] = true,
  [CR_DODGE] = true,
  [CR_PARRY] = true,
  [CR_BLOCK] = true,
  [COMBAT_RATING_RESILIENCE_CRIT_TAKEN] = true,
  [COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN] = true,
  [CR_CRIT_TAKEN_SPELL] = true,
}
-- 80-85 H data
local H = {
  [80] = 3.2789989471436,
  [81] = 4.3056015014648,
  [82] = 5.6539749145508,
  [83] = 7.4275451660156,
  [84] = 9.7527236938477,
  [85] = 12.8057159423828,
}
local H_Res = {
  [80] = 3.278999106,
  [81] = 4.092896174,
  [82] = 5.108814708,
  [83] = 6.376899732,
  [84] = 7.959742271,
  [85] = 9.935470247,
}
--[[
3.1.0
- Armor Penetration Rating: All classes now receive 25% more benefit from Armor Penetration Rating.
--]]

-- Formula reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
-- Percentage = Rating / RatingBase / H
--
-- Level 1 to 10:  H = 2/52
-- Level 10 to 60: H = (level-8)/52
-- Level 60 to 70: H = 82/(262-3*level)
-- Level 70 to 80: H = (82/52)*(131/63)^((level-70)/10)
--
--  Parry Rating, Defense Rating, Block Rating and Resilience: Low-level players
--   will now convert these ratings into their corresponding defensive
--   stats at the same rate as level 34 players.
--  Dodge Rating too

--- Calculates a combat rating's effect on its corresponding stat.
-- For a given combat rating value, this function will calculate the resulting effect on the
-- corresponding combat stat. 
-- @usage GetEffectFromRating(rating, id, [level, [class]])
-- @param rating (number) Combat rating value, e.g. 871
-- @param id (number) The Combat Rating ID to calculate the stat effect of. e.g. CR_PARRY
--    Can be one of the following values (defined in FrameXML\PaperDollFrame.lua):
--       CR_WEAPON_SKILL = 1;
--       CR_DEFENSE_SKILL = 2;
--       CR_DODGE = 3;
--       CR_PARRY = 4;
--       CR_BLOCK = 5;
--       CR_HIT_MELEE = 6;
--       CR_HIT_RANGED = 7;
--       CR_HIT_SPELL = 8;
--       CR_CRIT_MELEE = 9;
--       CR_CRIT_RANGED = 10;
--       CR_CRIT_SPELL = 11;
--       CR_HIT_TAKEN_MELEE = 12;
--       CR_HIT_TAKEN_RANGED = 13;
--       CR_HIT_TAKEN_SPELL = 14;
--       COMBAT_RATING_RESILIENCE_CRIT_TAKEN = 15;
--       COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
--       CR_CRIT_TAKEN_SPELL = 17;
--       CR_HASTE_MELEE = 18;
--       CR_HASTE_RANGED = 19;
--       CR_HASTE_SPELL = 20;
--       CR_WEAPON_SKILL_MAINHAND = 21;
--       CR_WEAPON_SKILL_OFFHAND = 22;
--       CR_WEAPON_SKILL_RANGED = 23;
--       CR_EXPERTISE = 24;
--       CR_ARMOR_PENETRATION = 25;
--       CR_MASTERY = 26;
-- @param level [optional] number - The level of the player being calculated. e.g. CR_PARRY
--        If omitted, the player's current level will be used, i.e. UnitLevel("player")
-- @param class [optional] number - A constant indicating the class of the player being calculated.
--        If omitted, the player's current class will be used. Can be one of the following values:
--            WARRIOR = 1
--            PALADIN = 2
--            HUNTER = 3
--            ROGUE = 4
--            PRIEST = 5
--            DEATHKNIGHT = 6
--            SHAMAN = 7
--            MAGE = 8
--            WARLOCK = 9
--            DRUID = 10
-- @return Returns effect, effectName
--     effect : number - Effect value as a percentage e.g. 6.47162208
--     effectName : string - Stat ID of converted effect, e.g. "PARRY"
--
-- Example - Get the effect of 871 Parry Rating on Parry for a level 84 Paladin:
--        6.47162208, "PARRY" = GetEffectFromRating(871, CR_PARRY, 84, 2)
function StatLogic:GetEffectFromRating(rating, id, level, class)
  -- if id is stringID then convert to numberID
  if type(id) == "string" and RatingNameToID[id] then
    id = RatingNameToID[id]
  end
  -- check for invalid input
  if type(rating) ~= "number" or id < 1 or id > 26 then return 0 end
  -- defaults to player level if not given
  level = level or UnitLevel("player")
  -- argCheck for invalid input
  self:argCheck(class, 5, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  --2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players
  --   will now convert these ratings into their corresponding defensive
  --   stats at the same rate as level 34 players.
  if level < 34 and Level34Ratings[id] then
    level = 34
  end
  if level >= 80 and level <= 85 then
    if id == 16 then
      return rating/RatingBase[id]/H_Res[level], RatingIDToConvertedStat[id]
    else
      return rating/RatingBase[id]/H[level], RatingIDToConvertedStat[id]
    end
  elseif level >= 70 then
    return rating/RatingBase[id]/((82/52)*(131/63)^((level-70)/10)), RatingIDToConvertedStat[id]
  elseif level >= 60 then
    return rating/RatingBase[id]/(82/(262-3*level)), RatingIDToConvertedStat[id]
  elseif level >= 10 then
    return rating/RatingBase[id]/((level-8)/52), RatingIDToConvertedStat[id]
  else
    return rating/RatingBase[id]/(2/52), RatingIDToConvertedStat[id]
  end
end


--[[---------------------------------
  :GetAPPerStr([class])
-------------------------------------
Notes:
  * Returns the attack power per strength for given class.
  * Player level does not effect attack power per strength.
Arguments:
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; ap : number - Attack power per strength
  ; statid : string - "AP"
Example:
  local ap = StatLogic:GetAPPerStr()
  local ap = StatLogic:GetAPPerStr("WARRIOR")
-----------------------------------]]

local APPerStr = {
  2, 2, 1, 1, 2, 2, 1, 2, 2, 2,
  --["WARRIOR"] = 2,
  --["PALADIN"] = 2,
  --["HUNTER"] = 1,
  --["ROGUE"] = 1,
  --["PRIEST"] = 2,
  --["DEATHKNIGHT"] = 2,
  --["SHAMAN"] = 1,
  --["MAGE"] = 2,
  --["WARLOCK"] = 2,
  --["DRUID"] = 2,
}
if wowBuildNo >= 14333 then -- 4.2.0
APPerStr = {
  2, 2, 1, 1, 2, 2, 1, 2, 2, 1,
  --["WARRIOR"] = 2,
  --["PALADIN"] = 2,
  --["HUNTER"] = 1,
  --["ROGUE"] = 1,
  --["PRIEST"] = 2,
  --["DEATHKNIGHT"] = 2,
  --["SHAMAN"] = 1,
  --["MAGE"] = 2,
  --["WARLOCK"] = 2,
  --["DRUID"] = 1,
}
end

function StatLogic:GetAPPerStr(class)
  -- argCheck for invalid input
  self:argCheck(class, 2, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  return APPerStr[class], "AP"
end


--[[---------------------------------
  :GetAPFromStr(str, [class])
-------------------------------------
Description:
  * Calculates the attack power from strength for given class.
Arguments:
  number - Strength
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; ap : number - Attack power
  ; statid : string - "AP"
Examples:
  local ap = StatLogic:GetAPFromStr(1) -- GetAPPerStr
  local ap = StatLogic:GetAPFromStr(10)
  local ap = StatLogic:GetAPFromStr(10, "WARRIOR")
-----------------------------------]]
function StatLogic:GetAPFromStr(str, class)
  -- argCheck for invalid input
  self:argCheck(str, 2, "number")
  self:argCheck(class, 3, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- Calculate
  return str * APPerStr[class], "AP"
end


--[[---------------------------------
  :GetAPPerAgi([class])
-------------------------------------
Notes:
  * Gets the attack power per agility for given class.
  * Player level does not effect attack power per agility.
  * Will check for Cat Form.
Arguments:
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; ap : number - Attack power per agility
  ; statid : string - "AP"
Example:
  local apPerAgi = StatLogic:GetAPPerAgi()
  local apPerAgi = StatLogic:GetAPPerAgi("ROGUE")
-----------------------------------]]

local APPerAgi = {
  0, 0, 1, 2, 0, 0, 2, 0, 0, 0,
  --["WARRIOR"] = 0,
  --["PALADIN"] = 0,
  --["HUNTER"] = 1,
  --["ROGUE"] = 2,
  --["PRIEST"] = 0,
  --["DEATHKNIGHT"] = 0,
  --["SHAMAN"] = 2,
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
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- Check druid cat/bear form
  if (class == 10) and (PlayerHasAura((GetSpellInfo(768))) or PlayerHasAura((GetSpellInfo(5487)))) then
    if toc >= 40000 then
      return 2
    else
      return 1
    end
  end
  return APPerAgi[class], "AP"
end


--[[---------------------------------
  :GetAPFromAgi(agi, [class])
-------------------------------------
Notes:
  * Calculates the attack power from agility for given class.
Arguments:
  number - Agility
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; ap : number - Attack power
  ; statid : string - "AP"
Example:
  local ap = StatLogic:GetAPFromAgi(1) -- GetAPPerAgi
  local ap = StatLogic:GetAPFromAgi(10)
  local ap = StatLogic:GetAPFromAgi(10, "WARRIOR")
-----------------------------------]]

function StatLogic:GetAPFromAgi(agi, class)
  -- argCheck for invalid input
  self:argCheck(agi, 2, "number")
  self:argCheck(class, 3, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- Calculate
  return agi * APPerAgi[class], "AP"
end


--[[---------------------------------
  :GetRAPPerAgi([class])
-------------------------------------
Notes:
  * Gets the ranged attack power per agility for given class.
  * Player level does not effect ranged attack power per agility.
Arguments:
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; rap : number - Ranged attack power per agility
  ; statid : string - "RANGED_AP"
Example:
  local rapPerAgi = StatLogic:GetRAPPerAgi()
  local rapPerAgi = StatLogic:GetRAPPerAgi("HUNTER")
-----------------------------------]]

local RAPPerAgi = {
  1, 0, 2, 1, 0, 0, 0, 0, 0, 0,
  --["WARRIOR"] = 1,
  --["PALADIN"] = 0,
  --["HUNTER"] = 2,
  --["ROGUE"] = 1,
  --["PRIEST"] = 0,
  --["DEATHKNIGHT"] = 0,
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
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  return RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
  :GetRAPFromAgi(agi, [class])
-------------------------------------
Notes:
  * Calculates the ranged attack power from agility for given class.
Arguments:
  number - Agility
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; rap : number - Ranged attack power
  ; statid : string - "RANGED_AP"
Example:
  local rap = StatLogic:GetRAPFromAgi(1) -- GetRAPPerAgi
  local rap = StatLogic:GetRAPFromAgi(10)
  local rap = StatLogic:GetRAPFromAgi(10, "WARRIOR")
-----------------------------------]]

function StatLogic:GetRAPFromAgi(agi, class)
  -- argCheck for invalid input
  self:argCheck(agi, 2, "number")
  self:argCheck(class, 3, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- Calculate
  return agi * RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
  :GetBaseDodge([class])
-------------------------------------
Notes:
  * BaseDodge values derived by Whitetooth (hotdogee [at] gmail [dot] com)
  * Gets the base dodge percentage for given class.
  * Base dodge is the amount of dodge you have with 0 Agility, independent of level.
Arguments:
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; dodge : number - Base dodge in percentages
  ; statid : string - "DODGE"
Example:
  local baseDodge = StatLogic:GetBaseDodge()
  local baseDodge = StatLogic:GetBaseDodge("WARRIOR")
-----------------------------------]]
-- local BaseDodge declared at StatLogic:GetDodgeChanceBeforeDR()
-- Numbers derived by Whitetooth (hotdogee [at] gmail [dot] com)
BaseDodge = {
  3.7580, 3.6520, -5.4499989748001, -0.590, 3.1830, 3.6640, 1.6750, 3.4575, 2.0350, 4.9510,
  --["WARRIOR"] =     3.7580,
  --["PALADIN"] =     3.6520,
  --["HUNTER"] =      -5.450,
  --["ROGUE"] =       -0.590,
  --["PRIEST"] =      3.1830,
  --["DEATHKNIGHT"] = 3.6640,
  --["SHAMAN"] =      1.6750,
  --["MAGE"] =        3.4575,
  --["WARLOCK"] =     2.0350,
  --["DRUID"] =       4.9510,
}
if wowBuildNo >= 14333 then -- 4.2.0
BaseDodge = {
  5, 5, -5.4499989748001, -0.590, 3.1830, 5, 1.6750, 3.4575, 2.0350, 4.9510,
  --["WARRIOR"] =     5,
  --["PALADIN"] =     5,
  --["HUNTER"] =      -5.450,
  --["ROGUE"] =       -0.590,
  --["PRIEST"] =      3.1830,
  --["DEATHKNIGHT"] = 5,
  --["SHAMAN"] =      1.6750,
  --["MAGE"] =        3.4575,
  --["WARLOCK"] =     2.0350,
  --["DRUID"] =       4.9510,
}
end

function StatLogic:GetBaseDodge(class)
  -- argCheck for invalid input
  self:argCheck(class, 2, "nil", "string", "number")
  -- if class is a class string, convert to class id
  if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    class = ClassNameToID[strupper(class)]
  -- if class is invalid input, default to player class
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  return BaseDodge[class], "DODGE"
end

--[[---------------------------------
  :GetDodgePerAgi()
-------------------------------------
Arguments:
  None
Returns:
  ; dodge : number - Dodge percentage per agility
  ; statid : string - "DODGE"
Notes:
  * Formula by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the dodge percentage per agility for your current class and level.
  * Only works for your currect class and current level, does not support class and level args.
  * Calculations got a bit more complicated with the introduction of the avoidance DR in WotLK, these are the values we know or can be calculated easily:
  ** D'=Total Dodge% after DR
  ** D_r=Dodge from Defense and Dodge Rating before DR
  ** D_b=Dodge unaffected by DR (BaseDodge + Dodge from talent/buffs + Lower then normal defense correction)
  ** A=Total Agility
  ** A_b=Base Agility (This is what you have with no gear on)
  ** A_g=Total Agility - Base Agility
  ** Let d be the Dodge/Agi value we are going to calculate.

  #  1     1     k
  # --- = --- + ---
  #  x'    c     x

  # x'=D'-D_b-A_b*d
  # x=A_g*d+D_r

  # 1/(D'-D_b-A_b*d)=1/C_d+k/(A_g*d+D_r)=(A_g*d+D_r+C_d*k)/(C_d*A_g*d+C_d*D_r)

  # C_d*A_g*d+C_d*D_r=[(D'-D_b)-A_b*d]*[Ag*d+(D_r+C_d*k)]

  # After rearranging the terms, we get an equation of type a*d^2+b*d+c where
  # a=-A_g*A_b
  # b=A_g(D'-D_b)-A_b(D_r+C_d*k)-C_dA_g
  # c=(D'-D_b)(D_r+C_d*k)-C_d*D_r
  ** Dodge/Agi=(-b-(b^2-4ac)^0.5)/(2a)
Example:
  local dodge, statid = StatLogic:GetDodgePerAgi()
-----------------------------------]]

local DodgePerAgiStatic
DodgePerAgiStatic = {
  0.0135962, 0.0192366, 0.0133266, 0.0240537, 0.0192366, 0.0135962, 0.0192366, 0.0195253, 0.0192366, 0.0240458,
  --["WARRIOR"] =     0.0135962,
  --["PALADIN"] =     0.0192366,
  --["HUNTER"] =      0.0133266,
  --["ROGUE"] =       0.0240537,
  --["PRIEST"] =      0.0192366,
  --["DEATHKNIGHT"] = 0.0135962,
  --["SHAMAN"] =      0.0192366,
  --["MAGE"] =        0.0195253,
  --["WARLOCK"] =     0.0192366,
  --["DRUID"] =       0.0240458,
}
local ZeroDodgePerAgiClasses = {}

if wowBuildNo >= 14333 then
DodgePerAgiStatic = {
  0, 0, 0.0133266, 0.0240537, 0.0192366, 0, 0.0192366, 0.0195253, 0.0192366, 0.0240458,
  --["WARRIOR"] =     0,
  --["PALADIN"] =     0,
  --["HUNTER"] =      0.0133266,
  --["ROGUE"] =       0.0240537,
  --["PRIEST"] =      0.0192366,
  --["DEATHKNIGHT"] = 0,
  --["SHAMAN"] =      0.0192366,
  --["MAGE"] =        0.0195253,
  --["WARLOCK"] =     0.0192366,
  --["DRUID"] =       0.0240458,
}
ZeroDodgePerAgiClasses = {
  ["WARRIOR"] = true,
  ["PALADIN"] = true,
  ["DEATHKNIGHT"] = true,
}
end

local ModAgiClasses = {
  ["DRUID"] = true,
  ["HUNTER"] = true,
  ["ROGUE"] = true,
  ["SHAMAN"] = true,
}
local BoK = GetSpellInfo(20217)
function StatLogic:GetDodgePerAgi()
  local level = UnitLevel("player")
  local class = ClassNameToID[playerClass]
  if level == 80 and DodgePerAgiStatic[class] then
    return DodgePerAgiStatic[class], "DODGE"
  end
  if ZeroDodgePerAgiClasses[playerClass] then
    return 0, "DODGE"
  end
  -- Collect data
  local D_dr = GetDodgeChance()
  local dodgeFromDodgeRating = self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, level)
  local baseDefense, modDefense = level * 5, 0
  local dodgeFromModDefense = modDefense * 0.04
  local D_r = dodgeFromDodgeRating + dodgeFromModDefense
  local D_b = BaseDodge[class] + self:GetStatMod("ADD_DODGE") + (baseDefense - level * 5) * 0.04
  local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 2) -- 2 = Agility
  -- Talents that modify AGI will not add to posBuff, so we need to calculate baseAgi
  -- But Kings added AGi will add to posBuff, so we need to check for Kings
  local modAgi = 1
  if ModAgiClasses[playerClass] then
    modAgi = self:GetStatMod("MOD_AGI", nil, nil, "CLASS")
  end
  local A = effectiveStat
  local A_b = ceil((stat - posBuff - negBuff) / modAgi)
  local A_g = A - A_b
  local C = C_d[class]
  local k = K[class]
  -- Solve a*x^2+b*x+c
  local a = -A_g*A_b
  local b = A_g*(D_dr-D_b)-A_b*(D_r+C*k)-C*A_g
  local c = (D_dr-D_b)*(D_r+C*k)-C*D_r
  --RatingBuster:Print(a, b, c, D_b, D_r, A_b, A_g, C, k)
  local dodgePerAgi = (-b-(b^2-4*a*c)^0.5)/(2*a)
  if a == 0 then
    dodgePerAgi = -c / b
  end
  --return dodgePerAgi
  --return floor(dodgePerAgi*10000+0.5)/10000, "DODGE"
  return dodgePerAgi, "DODGE"
end

--[[---------------------------------
  :GetDodgeFromAgi(agi)
-------------------------------------
Notes:
  * Calculates the dodge chance from agility for your current class and level.
  * Only works for your currect class and current level, does not support class and level args.
Arguments:
  number - Agility
Returns:
  ; dodge : number - Dodge percentage
  ; statid : string - "DODGE"
Example:
  local dodge = StatLogic:GetDodgeFromAgi(1) -- GetDodgePerAgi
  local dodge = StatLogic:GetDodgeFromAgi(10)
-----------------------------------]]

function StatLogic:GetDodgeFromAgi(agi)
  -- argCheck for invalid input
  self:argCheck(agi, 2, "number")
  -- Calculate
  return agi * self:GetDodgePerAgi(), "DODGE"
end


--[[---------------------------------
  :GetCritFromAgi(agi, [class], [level])
-------------------------------------
Notes:
  * CritPerAgi values reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the melee/ranged crit chance from agility for given class and level.
Arguments:
  number - Agility
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
  [optional] number - Level used in calculations. Default: player's level
Returns:
  ; crit : number - Melee/ranged crit percentage
  ; statid : string - "MELEE_CRIT"
Example:
  local crit = StatLogic:GetCritFromAgi(1) -- GetCritPerAgi
  local crit = StatLogic:GetCritFromAgi(10)
  local crit = StatLogic:GetCritFromAgi(10, "WARRIOR")
  local crit = StatLogic:GetCritFromAgi(10, nil, 70)
  local crit = StatLogic:GetCritFromAgi(10, "WARRIOR", 70)
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
local CritPerAgi
CritPerAgi = {
  [1] = {0.24999999, 0.21740000, 0.28400000, 0.44760900, 0.09117500, 0.24999999, 0.10390000, 0.07730000, 0.11890000, 0.12622500, },
  [2] = {0.23809499, 0.20704800, 0.28343401, 0.42895800, 0.09117500, 0.23809499, 0.10390000, 0.07730000, 0.11890000, 0.12622500, },
  [3] = {0.23809499, 0.20704800, 0.27107401, 0.41180002, 0.09117500, 0.23809499, 0.09895239, 0.07730000, 0.11323800, 0.12021400, },
  [4] = {0.22727300, 0.19763601, 0.25299001, 0.38129601, 0.08683330, 0.22727300, 0.09895239, 0.07361900, 0.11323800, 0.12021400, },
  [5] = {0.21739099, 0.19763601, 0.24300499, 0.36767900, 0.08683330, 0.21739099, 0.09445450, 0.07361900, 0.11323800, 0.11475000, },
  [6] = {0.20833299, 0.18904300, 0.23373601, 0.35500000, 0.08683330, 0.20833299, 0.09445450, 0.07361900, 0.10809100, 0.11475000, },
  [7] = {0.20833299, 0.18904300, 0.22510700, 0.33209701, 0.08683330, 0.20833299, 0.09445450, 0.07361900, 0.10809100, 0.10976100, },
  [8] = {0.20000001, 0.18116700, 0.21705499, 0.32171900, 0.08288640, 0.20000001, 0.09034780, 0.07361900, 0.10809100, 0.10976100, },
  [9] = {0.19230800, 0.18116700, 0.20513700, 0.31196999, 0.08288640, 0.19230800, 0.09034780, 0.07361900, 0.10339100, 0.10518699, },
  [10] = {0.19230800, 0.17392000, 0.19836400, 0.29414301, 0.08288640, 0.19230800, 0.08658330, 0.07027270, 0.10339100, 0.09709620, },
  [11] = {0.18518500, 0.17392000, 0.18475300, 0.26397400, 0.08288640, 0.18518500, 0.08658330, 0.07027270, 0.09908330, 0.09350000, },
  [12] = {0.17857100, 0.16723101, 0.16697299, 0.23941901, 0.07928260, 0.17857100, 0.08312000, 0.07027270, 0.09908330, 0.09350000, },
  [13] = {0.16666700, 0.15528600, 0.15469900, 0.21447900, 0.07928260, 0.16666700, 0.08312000, 0.07027270, 0.09908330, 0.09016070, },
  [14] = {0.16129001, 0.15528600, 0.14408800, 0.19798100, 0.07928260, 0.16129001, 0.07992310, 0.07027270, 0.09588690, 0.09016070, },
  [15] = {0.15625000, 0.14493300, 0.13299300, 0.17750000, 0.07928260, 0.15625000, 0.07696300, 0.06721740, 0.09435100, 0.08415000, },
  [16] = {0.15151500, 0.14493300, 0.12666400, 0.16604800, 0.07597920, 0.15151500, 0.07421430, 0.06721740, 0.09284450, 0.08415000, },
  [17] = {0.14705900, 0.14025799, 0.11942200, 0.15598499, 0.07597920, 0.14705900, 0.07421430, 0.06721740, 0.09136670, 0.08143550, },
  [18] = {0.13888900, 0.13175800, 0.11166499, 0.14500000, 0.07597920, 0.13888900, 0.07165520, 0.06721740, 0.08991690, 0.07889060, },
  [19] = {0.13513500, 0.13175800, 0.10597800, 0.13546100, 0.07294000, 0.13513500, 0.07165520, 0.06721740, 0.08849440, 0.07889060, },
  [20] = {0.12820500, 0.12422900, 0.09980580, 0.12709900, 0.07294000, 0.12820500, 0.06703230, 0.06441670, 0.08709860, 0.07012500, },
  [21] = {0.12820500, 0.12077800, 0.09615530, 0.11970900, 0.07294000, 0.12820500, 0.06703230, 0.06441670, 0.08572890, 0.07012500, },
  [22] = {0.12500000, 0.12077800, 0.09103050, 0.11438900, 0.07294000, 0.12500000, 0.06493750, 0.06441670, 0.08438450, 0.06822970, },
  [23] = {0.11904800, 0.11442100, 0.08718610, 0.10836800, 0.07013460, 0.11904800, 0.06493750, 0.06441670, 0.08306500, 0.06643420, },
  [24] = {0.11627900, 0.11148700, 0.08293830, 0.10399000, 0.07013460, 0.11627900, 0.06296970, 0.06184000, 0.08176980, 0.06643420, },
  [25] = {0.11111100, 0.10870000, 0.07972230, 0.09804760, 0.07013460, 0.11111100, 0.06111760, 0.06184000, 0.08049830, 0.06311250, },
  [26] = {0.10869600, 0.10604900, 0.07674040, 0.09359090, 0.06753700, 0.10869600, 0.05937140, 0.06184000, 0.07924990, 0.06311250, },
  [27] = {0.10638300, 0.10352400, 0.07341370, 0.09030700, 0.06753700, 0.10638300, 0.05937140, 0.06184000, 0.07802420, 0.06157320, },
  [28] = {0.10204100, 0.10111600, 0.07086710, 0.08651260, 0.06753700, 0.10204100, 0.05772220, 0.06184000, 0.07682060, 0.06010710, },
  [29] = {0.10000000, 0.09881820, 0.06801100, 0.08302420, 0.06512500, 0.10000000, 0.05772220, 0.05946150, 0.07563860, 0.06010710, },
  [30] = {0.09615380, 0.09452170, 0.06537160, 0.07919230, 0.06512500, 0.09615380, 0.05468420, 0.05946150, 0.07447780, 0.05488040, },
  [31] = {0.09433960, 0.09251060, 0.06374390, 0.07682840, 0.06512500, 0.09433960, 0.05468420, 0.05946150, 0.07333770, 0.05371280, },
  [32] = {0.09259260, 0.09251060, 0.06141140, 0.07406470, 0.06287930, 0.09259260, 0.05328210, 0.05946150, 0.07221780, 0.05371280, },
  [33] = {0.08928570, 0.08873470, 0.05923970, 0.07149310, 0.06287930, 0.08928570, 0.05195000, 0.05725930, 0.07111760, 0.05259370, },
  [34] = {0.08771930, 0.08696000, 0.05754870, 0.06909400, 0.06287930, 0.08771930, 0.05195000, 0.05725930, 0.07003690, 0.05152040, },
  [35] = {0.08474580, 0.08361540, 0.05563030, 0.06641940, 0.06078330, 0.08474580, 0.04947620, 0.05725930, 0.06897500, 0.05049000, },
  [36] = {0.08333330, 0.08203770, 0.05412970, 0.06434370, 0.06078330, 0.08333330, 0.04832560, 0.05521430, 0.06793170, 0.04950000, },
  [37] = {0.08196720, 0.08203770, 0.05242280, 0.06277440, 0.06078330, 0.08196720, 0.04832560, 0.05521430, 0.06690650, 0.04854810, },
  [38] = {0.07936510, 0.07905450, 0.05081710, 0.06091720, 0.05882260, 0.07936510, 0.04722730, 0.05521430, 0.06589910, 0.04854810, },
  [39] = {0.07812500, 0.07764290, 0.04930400, 0.05916670, 0.05882260, 0.07812500, 0.04722730, 0.05521430, 0.06490910, 0.04763210, },
  [40] = {0.07575760, 0.07496550, 0.04811060, 0.05719440, 0.05882260, 0.07575760, 0.04517390, 0.05331030, 0.06393600, 0.04428950, },
  [41] = {0.07352940, 0.07369490, 0.04697090, 0.05564860, 0.05698440, 0.07352940, 0.04421280, 0.05331030, 0.06297960, 0.04352590, },
  [42] = {0.07246380, 0.07369490, 0.04566750, 0.05418420, 0.05698440, 0.07246380, 0.04421280, 0.05331030, 0.06203950, 0.04352590, },
  [43] = {0.07042250, 0.07127870, 0.04443200, 0.05279490, 0.05525760, 0.07042250, 0.04329170, 0.05331030, 0.06111540, 0.04278810, },
  [44] = {0.06944440, 0.07012900, 0.04325920, 0.05121890, 0.05525760, 0.06944440, 0.04240820, 0.05153330, 0.06020690, 0.04207500, },
  [45] = {0.06756760, 0.06793750, 0.04214440, 0.04973430, 0.05525760, 0.06756760, 0.04156000, 0.05153330, 0.05931370, 0.04071770, },
  [46] = {0.06666670, 0.06689230, 0.04125640, 0.04856130, 0.05363240, 0.06666670, 0.04074510, 0.05153330, 0.05843550, 0.04007140, },
  [47] = {0.06493510, 0.06587880, 0.04023690, 0.04744240, 0.05363240, 0.06493510, 0.03996150, 0.04987100, 0.05757210, 0.04007140, },
  [48] = {0.06329110, 0.06394120, 0.03910780, 0.04637390, 0.05210000, 0.06329110, 0.03920750, 0.04987100, 0.05672300, 0.03944530, },
  [49] = {0.06250000, 0.06301450, 0.03818660, 0.04535240, 0.05210000, 0.06250000, 0.03920750, 0.04987100, 0.05588810, 0.03883850, },
  [50] = {0.06097560, 0.06123940, 0.03730590, 0.04399570, 0.05210000, 0.06097560, 0.03778180, 0.04831250, 0.05506700, 0.03658700, },
  [51] = {0.05952380, 0.06038890, 0.03659920, 0.04307530, 0.05065280, 0.05952380, 0.03710710, 0.04831250, 0.05425950, 0.03606430, },
  [52] = {0.05882350, 0.05956160, 0.03578580, 0.04219260, 0.05065280, 0.05882350, 0.03645610, 0.04831250, 0.05346520, 0.03555630, },
  [53] = {0.05747130, 0.05797330, 0.03500600, 0.04118000, 0.04928380, 0.05747130, 0.03645610, 0.04684850, 0.05268400, 0.03506250, },
  [54] = {0.05617980, 0.05721050, 0.03413840, 0.04037250, 0.04928380, 0.05617980, 0.03582760, 0.04684850, 0.05191560, 0.03506250, },
  [55] = {0.05494510, 0.05574360, 0.03342470, 0.03944440, 0.04798680, 0.05494510, 0.03463330, 0.04684850, 0.05115970, 0.03411490, },
  [56] = {0.05434780, 0.05503800, 0.03284840, 0.03855810, 0.04798680, 0.05434780, 0.03406560, 0.04547060, 0.05041610, 0.03366000, },
  [57] = {0.05319150, 0.05435000, 0.03207870, 0.03784930, 0.04675640, 0.05319150, 0.03351610, 0.04547060, 0.04968460, 0.03321710, },
  [58] = {0.05208330, 0.05302440, 0.03144320, 0.03703240, 0.04675640, 0.05208330, 0.03351610, 0.04547060, 0.04896490, 0.03278570, },
  [59] = {0.05102040, 0.05238550, 0.03073430, 0.03637810, 0.04558750, 0.05102040, 0.03298410, 0.04417140, 0.04825680, 0.03236540, },
  [60] = {0.05000000, 0.05115290, 0.03014770, 0.03550000, 0.04558750, 0.05000000, 0.03196920, 0.04417140, 0.04756000, 0.03078660, },
  [61] = {0.04761900, 0.04940910, 0.02967120, 0.03343390, 0.04449120, 0.04761900, 0.03102490, 0.04417140, 0.04687440, 0.02988460, },
  [62] = {0.04545450, 0.04831110, 0.02903510, 0.03217750, 0.04458550, 0.04545450, 0.03040300, 0.04417140, 0.04619980, 0.02950110, },
  [63] = {0.04347830, 0.04726090, 0.02842440, 0.03063990, 0.04426580, 0.04347830, 0.02935380, 0.04294440, 0.04553590, 0.02849640, },
  [64] = {0.04166670, 0.04576840, 0.02791680, 0.02959690, 0.04344670, 0.04166670, 0.02848270, 0.04294440, 0.04488250, 0.02791070, },
  [65] = {0.04000000, 0.04482470, 0.02734930, 0.02861530, 0.04271900, 0.04000000, 0.02807010, 0.04294440, 0.04423950, 0.02738060, },
  [66] = {0.03846150, 0.04391920, 0.02695050, 0.02767470, 0.04207770, 0.03846150, 0.02734040, 0.04178380, 0.04360670, 0.02690250, },
  [67] = {0.03703700, 0.04262750, 0.02641880, 0.02680990, 0.04151880, 0.03703700, 0.02668210, 0.04178380, 0.04298380, 0.02647340, },
  [68] = {0.03571430, 0.04180770, 0.02590650, 0.02618690, 0.04133470, 0.03571430, 0.02608150, 0.04178380, 0.04237070, 0.02577280, },
  [69] = {0.03448280, 0.04101890, 0.02541250, 0.02560950, 0.04117830, 0.03448280, 0.02552060, 0.04068420, 0.04176730, 0.02537310, },
  [70] = {0.03333330, 0.04025930, 0.02499810, 0.02499880, 0.04014610, 0.03333330, 0.02499630, 0.04068420, 0.04117320, 0.02499810, },
  [71] = {0.03105590, 0.03716240, 0.02323340, 0.02323930, 0.03721430, 0.03105590, 0.02323170, 0.03770730, 0.03835480, 0.02323340, },
  [72] = {0.02873560, 0.03450790, 0.02159330, 0.02158280, 0.03440570, 0.02873560, 0.02159180, 0.03513640, 0.03549250, 0.02159330, },
  [73] = {0.02673800, 0.03220740, 0.02006910, 0.02006820, 0.03199120, 0.02673800, 0.02006760, 0.03289360, 0.03302780, 0.02006910, },
  [74] = {0.02487560, 0.02978080, 0.01865240, 0.01865040, 0.02989340, 0.02487560, 0.01865100, 0.03031370, 0.03088310, 0.01865240, },
  [75] = {0.02314810, 0.02769430, 0.01733570, 0.01733160, 0.02762880, 0.02314810, 0.01733440, 0.02810910, 0.02865060, 0.01733570, },
  [76] = {0.02145920, 0.02572780, 0.01611190, 0.01611110, 0.02568310, 0.02145920, 0.01611080, 0.02620340, 0.02642220, 0.01611190, },
  [77] = {0.01992030, 0.02389010, 0.01497460, 0.01496370, 0.02399340, 0.01992030, 0.01497350, 0.02415630, 0.02451550, 0.01497460, },
  [78] = {0.01851850, 0.02229740, 0.01391750, 0.01391220, 0.02223780, 0.01851850, 0.01391650, 0.02273530, 0.02286540, 0.01391750, },
  [79] = {0.01724140, 0.02070480, 0.01293510, 0.01293340, 0.02072160, 0.01724140, 0.01293410, 0.02089190, 0.02123210, 0.01293510, },
  [80] = {0.01602560, 0.01923890, 0.01202200, 0.01202690, 0.01919470, 0.01602560, 0.01202110, 0.01956960, 0.01981670, 0.01202200, },
  [81] = {0.01219510, 0.01463970, 0.00915552, 0.00915925, 0.01461810, 0.01220460, 0.00915486, 0.01486540, 0.01509170, 0.00915552, },
  [82] = {0.00929368, 0.01114870, 0.00697209, 0.00697493, 0.01113190, 0.00929400, 0.00697159, 0.01136760, 0.01149260, 0.00697209, },
  [83] = {0.00707214, 0.00849219, 0.00530727, 0.00530944, 0.00847380, 0.00707475, 0.00530689, 0.00863687, 0.00874836, 0.00530727, },
  [84] = {0.00538793, 0.00647024, 0.00404195, 0.00404360, 0.00645353, 0.00538804, 0.00404166, 0.00657872, 0.00666263, 0.00404195, },
  [85] = {0.00410509, 0.00492412, 0.00307831, 0.00307957, 0.00491496, 0.00410348, 0.00307809, 0.00500324, 0.00507420, 0.00307831, },
  [86] = {0.00192160, 0.00230663, 0.00144129, 0.00144188, 0.00230122, 0.00192160, 0.00144118, 0.00234598, 0.00237578, 0.00144129, },
  [87] = {0.00134916, 0.00161937, 0.00101208, 0.00101249, 0.00161592, 0.00134916, 0.00101200, 0.00164819, 0.00166828, 0.00101208, },
  [88] = {0.00094733, 0.00113733, 0.00071069, 0.00071098, 0.00113472, 0.00094733, 0.00071064, 0.00115719, 0.00117148, 0.00071069, },
  [89] = {0.00066525, 0.00079868, 0.01154730, 0.00049925, 0.03508770, 0.00066525, 0.03300000, 0.00081240, 0.03296700, 0.03388430, },
  [90] = {0.00046711, 0.00056081, 0.01136360, 0.00035058, 0.03448280, 0.00046711, 0.03235290, 0.00057048, 0.03225810, 0.03333330, },
  [91] = {0.00032802, 0.00039381, 0.01123600, 0.00024617, 0.03448280, 0.00032802, 0.03203880, 0.00040052, 0.03191490, 0.03280000, },
  [92] = {0.00023034, 0.00027652, 0.01106190, 0.00017286, 0.03389830, 0.00023034, 0.03142860, 0.00028130, 0.03157890, 0.03253970, },
  [93] = {0.00016174, 0.00019418, 0.01089320, 0.00012139, 0.03333330, 0.00016174, 0.03113210, 0.00019752, 0.03125000, 0.03203130, },
  [94] = {0.00011358, 0.00013635, 0.01075270, 0.00008524, 0.03278690, 0.00011358, 0.03084110, 0.00013869, 0.03092780, 0.03178290, },
  [95] = {0.00007976, 0.00009575, 0.01059320, 0.00005985, 0.03278690, 0.00007976, 0.03000000, 0.00009739, 0.03030300, 0.03106060, },
  [96] = {0.00005600, 0.00006723, 0.01046030, 0.00004203, 0.03225810, 0.00005600, 0.02972970, 0.00006839, 0.03000000, 0.03082710, },
  [97] = {0.00003933, 0.00004721, 0.01030930, 0.00002951, 0.03174600, 0.00003933, 0.02946430, 0.00004802, 0.02970300, 0.03037040, },
  [98] = {0.00002762, 0.00003315, 0.01016260, 0.00002072, 0.03125000, 0.00002762, 0.02894740, 0.00003372, 0.02912620, 0.02992700, },
  [99] = {0.00001939, 0.00002328, 0.01002000, 0.00001455, 0.03076920, 0.00001939, 0.02869570, 0.00002368, 0.02884620, 0.02971010, },
  [100] = {0.00001362, 0.00001635, 0.00988142, 0.00001022, 0.03076920, 0.00001362, 0.02820510, 0.00001663, 0.02830190, 0.02907800, },
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
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- if level is invalid input, default to player level
  if type(level) ~= "number" or level < 1 or level > 100 then
    level = UnitLevel("player")
  end
  -- Calculate
  return agi * CritPerAgi[level][class], "MELEE_CRIT"
end

--[[---------------------------------
  :GetHealthFromSta(sta, [level])
-------------------------------------
Notes:
  * For each level beyond 80, stamina grants an additional 8% health per point. 
Arguments:
  number - Stamina
  [optional] number - Level used in calculations. Default: player's level
Returns:
  ; health : number - Health
  ; statid : string - "HEALTH"
Example:
  local health = StatLogic:GetHealthFromSta(1) -- GetHealthPerSta
  local health = StatLogic:GetHealthFromSta(10)
  local health = StatLogic:GetCritFromAgi(10, 85)
-----------------------------------]]
function StatLogic:GetHealthFromSta(sta, level)
  -- argCheck for invalid input
  self:argCheck(sta, 2, "number")
  self:argCheck(level, 3, "nil", "number")
  -- if level is invalid input, default to player level
  if type(level) ~= "number" or level < 1 or level > 100 then
    level = UnitLevel("player")
  end
  local mod = 10
  if level > 80 then
    mod = mod + (level - 80) * 0.8
  end
  -- Calculate
  return sta * mod, "HEALTH"
end


--[[---------------------------------
  :GetSpellCritFromInt(int, [class], [level])
-------------------------------------
Notes:
  * SpellCritPerInt values reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the spell crit chance from intellect for given class and level.
Arguments:
  number - Intellect
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
  [optional] number - Level used in calculations. Default: player's level
Returns:
  ; spellcrit : number - Spell crit percentage
  ; statid : string - "SPELL_CRIT"
Example:
  local spellCrit = StatLogic:GetSpellCritFromInt(1) -- GetSpellCritPerInt
  local spellCrit = StatLogic:GetSpellCritFromInt(10)
  local spellCrit = StatLogic:GetSpellCritFromInt(10, "MAGE")
  local spellCrit = StatLogic:GetSpellCritFromInt(10, nil, 70)
  local spellCrit = StatLogic:GetSpellCritFromInt(10, "MAGE", 70)
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
local SpellCritPerInt

SpellCritPerInt = {
  --WARRIOR, PALADIN, HUNTER, ROGUE, PRIEST, DEATHKNIGHT, SHAMAN, MAGE, WARLOCK, DRUID
  [1] = {0.00000000, 0.08322500, 0.06990000, 0.00000000, 0.17102300, 0.00000000, 0.13328600, 0.16370000, 0.15000000, 0.14311400, },
  [2] = {0.00000000, 0.07926190, 0.06657140, 0.00000000, 0.16358700, 0.00000000, 0.12722700, 0.15740400, 0.14347800, 0.13689100, },
  [3] = {0.00000000, 0.07926190, 0.06657140, 0.00000000, 0.15677100, 0.00000000, 0.12169600, 0.15157399, 0.13750000, 0.13118699, },
  [4] = {0.00000000, 0.07565910, 0.06354550, 0.00000000, 0.15050001, 0.00000000, 0.12169600, 0.14112100, 0.13200000, 0.12594000, },
  [5] = {0.00000000, 0.07565910, 0.06354550, 0.00000000, 0.13935200, 0.00000000, 0.11662500, 0.13641700, 0.12692300, 0.12109600, },
  [6] = {0.00000000, 0.07236960, 0.06078260, 0.00000000, 0.13437500, 0.00000000, 0.11196000, 0.13201600, 0.12222200, 0.11661100, },
  [7] = {0.00000000, 0.06935420, 0.06078260, 0.00000000, 0.12974100, 0.00000000, 0.10765400, 0.12789100, 0.11785700, 0.11244600, },
  [8] = {0.00000000, 0.06935420, 0.05825000, 0.00000000, 0.12541700, 0.00000000, 0.10366699, 0.12401500, 0.11379300, 0.11244600, },
  [9] = {0.00000000, 0.06658000, 0.05825000, 0.00000000, 0.12137101, 0.00000000, 0.09996430, 0.11692900, 0.11000000, 0.10856900, },
  [10] = {0.00000000, 0.06658000, 0.05592000, 0.00000000, 0.11401500, 0.00000000, 0.09996430, 0.11368101, 0.10645200, 0.09839060, },
  [11] = {0.00000000, 0.06401920, 0.05592000, 0.00000000, 0.10451400, 0.00000000, 0.09330000, 0.10493600, 0.09705880, 0.09260290, },
  [12] = {0.00000000, 0.06164810, 0.05376920, 0.00000000, 0.09406250, 0.00000000, 0.08746880, 0.09301140, 0.08918920, 0.08509460, },
  [13] = {0.00000000, 0.05944640, 0.04992860, 0.00000000, 0.08750000, 0.00000000, 0.07997140, 0.08707450, 0.08250000, 0.08073080, },
  [14] = {0.00000000, 0.05739660, 0.04992860, 0.00000000, 0.07838540, 0.00000000, 0.07564860, 0.07308040, 0.07674420, 0.07496430, },
  [15] = {0.00000000, 0.05369350, 0.04660000, 0.00000000, 0.07235580, 0.00000000, 0.06997500, 0.06709020, 0.07173910, 0.06844570, },
  [16] = {0.00000000, 0.05369350, 0.04660000, 0.00000000, 0.06840910, 0.00000000, 0.06664290, 0.06394530, 0.06875000, 0.06559370, },
  [17] = {0.00000000, 0.05201560, 0.04509680, 0.00000000, 0.06270830, 0.00000000, 0.06361360, 0.06018380, 0.06346150, 0.06173530, },
  [18] = {0.00000000, 0.04895590, 0.04236360, 0.00000000, 0.05972220, 0.00000000, 0.05955320, 0.05684030, 0.06000000, 0.05940570, },
  [19] = {0.00000000, 0.04895590, 0.04236360, 0.00000000, 0.05615670, 0.00000000, 0.05712240, 0.05384870, 0.05689660, 0.05622320, },
  [20] = {0.00000000, 0.04623610, 0.03994290, 0.00000000, 0.05225690, 0.00000000, 0.05382690, 0.05052470, 0.05409840, 0.05161480, },
  [21] = {0.00000000, 0.04498650, 0.03883330, 0.00000000, 0.05016670, 0.00000000, 0.05183330, 0.04872020, 0.05156250, 0.04997620, },
  [22] = {0.00000000, 0.04380260, 0.03883330, 0.00000000, 0.04703120, 0.00000000, 0.04998210, 0.04598310, 0.04925370, 0.04770450, },
  [23] = {0.00000000, 0.04267950, 0.03678950, 0.00000000, 0.04533130, 0.00000000, 0.04744070, 0.04448370, 0.04714290, 0.04630150, },
  [24] = {0.00000000, 0.04161250, 0.03584620, 0.00000000, 0.04275570, 0.00000000, 0.04588520, 0.04219070, 0.04459460, 0.04372920, },
  [25] = {0.00000000, 0.03963100, 0.03495000, 0.00000000, 0.04089670, 0.00000000, 0.04373440, 0.04051980, 0.04285710, 0.04198000, },
  [26] = {0.00000000, 0.03870930, 0.03409760, 0.00000000, 0.03919270, 0.00000000, 0.04240910, 0.03897620, 0.04177220, 0.04088960, },
  [27] = {0.00000000, 0.03870930, 0.03328570, 0.00000000, 0.03762500, 0.00000000, 0.04116180, 0.03720450, 0.03975900, 0.03935630, },
  [28] = {0.00000000, 0.03698890, 0.03251160, 0.00000000, 0.03617790, 0.00000000, 0.03942250, 0.03382230, 0.03837210, 0.03839630, },
  [29] = {0.00000000, 0.03618480, 0.03177270, 0.00000000, 0.03483800, 0.00000000, 0.03834250, 0.03248020, 0.03666670, 0.03661050, },
  [30] = {0.00000000, 0.03467710, 0.03039130, 0.00000000, 0.03329650, 0.00000000, 0.03682890, 0.03124050, 0.03548390, 0.03459890, },
  [31] = {0.00000000, 0.03396940, 0.02974470, 0.00000000, 0.03215810, 0.00000000, 0.03543040, 0.03054100, 0.03473680, 0.03385480, },
  [32] = {0.00000000, 0.03329000, 0.02974470, 0.00000000, 0.03109500, 0.00000000, 0.03455560, 0.02944240, 0.03333330, 0.03245880, },
  [33] = {0.00000000, 0.03263730, 0.02853060, 0.00000000, 0.03010000, 0.00000000, 0.03332140, 0.02861890, 0.03235290, 0.03180300, },
  [34] = {0.00000000, 0.03200960, 0.02796000, 0.00000000, 0.02894230, 0.00000000, 0.03254650, 0.02784010, 0.03113210, 0.03086760, },
  [35] = {0.00000000, 0.03082410, 0.02688460, 0.00000000, 0.02807840, 0.00000000, 0.03144940, 0.02692430, 0.03027520, 0.02970280, },
  [36] = {0.00000000, 0.03026360, 0.02637740, 0.00000000, 0.02726450, 0.00000000, 0.03042390, 0.02623400, 0.02946430, 0.02915280, },
  [37] = {0.00000000, 0.02972320, 0.02637740, 0.00000000, 0.02631120, 0.00000000, 0.02977660, 0.02541930, 0.02844830, 0.02836490, },
  [38] = {0.00000000, 0.02869830, 0.02541820, 0.00000000, 0.02559520, 0.00000000, 0.02885570, 0.02480300, 0.02773110, 0.02761840, },
  [39] = {0.00000000, 0.02821190, 0.02496430, 0.00000000, 0.02491720, 0.00000000, 0.02827270, 0.02407350, 0.02682930, 0.02691030, },
  [40] = {0.00000000, 0.02728690, 0.02410340, 0.00000000, 0.02411860, 0.00000000, 0.02717480, 0.02352010, 0.02619050, 0.02559760, },
  [41] = {0.00000000, 0.02684680, 0.02369490, 0.00000000, 0.02351560, 0.00000000, 0.02665710, 0.02299160, 0.02558140, 0.02518800, },
  [42] = {0.00000000, 0.02642060, 0.02369490, 0.00000000, 0.02280300, 0.00000000, 0.02615890, 0.02153950, 0.02481200, 0.02440700, },
  [43] = {0.00000000, 0.02560770, 0.02291800, 0.00000000, 0.02226330, 0.00000000, 0.02544550, 0.02109540, 0.02426470, 0.02403440, },
  [44] = {0.00000000, 0.02560770, 0.02254840, 0.00000000, 0.02162360, 0.00000000, 0.02476990, 0.02056530, 0.02357140, 0.02332220, },
  [45] = {0.00000000, 0.02484330, 0.02184380, 0.00000000, 0.02101960, 0.00000000, 0.02412930, 0.02006130, 0.02291670, 0.02281520, },
  [46] = {0.00000000, 0.02447790, 0.02150770, 0.00000000, 0.02056010, 0.00000000, 0.02352100, 0.01967550, 0.02244900, 0.02232980, },
  [47] = {0.00000000, 0.02377860, 0.02118180, 0.00000000, 0.02001330, 0.00000000, 0.02313220, 0.01921360, 0.02200000, 0.02186460, },
  [48] = {0.00000000, 0.02311810, 0.02055880, 0.00000000, 0.01959640, 0.00000000, 0.02257260, 0.01877290, 0.02142860, 0.02141840, },
  [49] = {0.00000000, 0.02280140, 0.02026090, 0.00000000, 0.01909900, 0.00000000, 0.02203940, 0.01835200, 0.02088610, 0.02085100, },
  [50] = {0.00000000, 0.02219330, 0.01969010, 0.00000000, 0.01862620, 0.00000000, 0.02153080, 0.01794960, 0.02037040, 0.02018270, },
  [51] = {0.00000000, 0.02190130, 0.01941670, 0.00000000, 0.01826460, 0.00000000, 0.02104510, 0.01764010, 0.02000000, 0.01980190, },
  [52] = {0.00000000, 0.02161690, 0.01915070, 0.00000000, 0.01783180, 0.00000000, 0.02073330, 0.01726790, 0.01952660, 0.01931600, },
  [53] = {0.00000000, 0.02106960, 0.01864000, 0.00000000, 0.01750000, 0.00000000, 0.02013670, 0.01698130, 0.01907510, 0.01908180, },
  [54] = {0.00000000, 0.02080620, 0.01839470, 0.00000000, 0.01710230, 0.00000000, 0.01985110, 0.01656880, 0.01864410, 0.01863020, },
  [55] = {0.00000000, 0.02029880, 0.01792310, 0.00000000, 0.01664820, 0.00000000, 0.01930340, 0.01624010, 0.01823200, 0.01819940, },
  [56] = {0.00000000, 0.02005420, 0.01769620, 0.00000000, 0.01635870, 0.00000000, 0.01904080, 0.01544340, 0.01793480, 0.01788920, },
  [57] = {0.00000000, 0.01981550, 0.01747500, 0.00000000, 0.01601060, 0.00000000, 0.01866000, 0.01510150, 0.01755320, 0.01758940, },
  [58] = {0.00000000, 0.01913220, 0.01704880, 0.00000000, 0.01574270, 0.00000000, 0.01817530, 0.01488180, 0.01718750, 0.01729950, },
  [59] = {0.00000000, 0.01891480, 0.01684340, 0.00000000, 0.01535710, 0.00000000, 0.01794230, 0.01456410, 0.01683670, 0.01692740, },
  [60] = {0.00000000, 0.01849440, 0.01644710, 0.00000000, 0.01505000, 0.00000000, 0.01749370, 0.01430940, 0.01650000, 0.01639840, },
  [61] = {0.00000000, 0.01585240, 0.01571290, 0.00000000, 0.01481300, 0.00000000, 0.01638980, 0.01430940, 0.01590570, 0.01615360, },
  [62] = {0.00000000, 0.01541200, 0.01539680, 0.00000000, 0.01447120, 0.00000000, 0.01585240, 0.01430940, 0.01540280, 0.01565850, },
  [63] = {0.00000000, 0.01486160, 0.01496970, 0.00000000, 0.01425190, 0.00000000, 0.01519880, 0.01430940, 0.01476210, 0.01502430, },
  [64] = {0.00000000, 0.01447390, 0.01442100, 0.00000000, 0.01393520, 0.00000000, 0.01467380, 0.01425960, 0.01428430, 0.01457140, },
  [65] = {0.00000000, 0.01398740, 0.01406840, 0.00000000, 0.01368180, 0.00000000, 0.01422450, 0.01421010, 0.01384890, 0.01415760, },
  [66] = {0.00000000, 0.01364340, 0.01375000, 0.00000000, 0.01343750, 0.00000000, 0.01378730, 0.01377950, 0.01345140, 0.01373170, },
  [67] = {0.00000000, 0.01342340, 0.01333460, 0.00000000, 0.01320180, 0.00000000, 0.01338800, 0.01337420, 0.01302730, 0.01334290, },
  [68] = {0.00000000, 0.01310630, 0.01303730, 0.00000000, 0.01297410, 0.00000000, 0.01307380, 0.01311700, 0.01273350, 0.01305880, },
  [69] = {0.00000000, 0.01280380, 0.01275940, 0.00000000, 0.01271110, 0.00000000, 0.01277850, 0.01282920, 0.01261620, 0.01277080, },
  [70] = {0.00000000, 0.01251500, 0.01250000, 0.00000000, 0.01250000, 0.00000000, 0.01250000, 0.01251530, 0.01250000, 0.01250000, },
  [71] = {0.00000000, 0.01162640, 0.01162640, 0.00000000, 0.01162640, 0.00000000, 0.01162640, 0.01162640, 0.01162640, 0.01162640, },
  [72] = {0.00000000, 0.01079820, 0.01079820, 0.00000000, 0.01079820, 0.00000000, 0.01079820, 0.01079820, 0.01079820, 0.01079820, },
  [73] = {0.00000000, 0.01005530, 0.01005530, 0.00000000, 0.01005530, 0.00000000, 0.01005530, 0.01005530, 0.01005530, 0.01005530, },
  [74] = {0.00000000, 0.00934361, 0.00934361, 0.00000000, 0.00934361, 0.00000000, 0.00934361, 0.00934361, 0.00934361, 0.00934361, },
  [75] = {0.00000000, 0.00868896, 0.00868896, 0.00000000, 0.00868896, 0.00000000, 0.00868896, 0.00868896, 0.00868896, 0.00868896, },
  [76] = {0.00000000, 0.00807199, 0.00807199, 0.00000000, 0.00807199, 0.00000000, 0.00807199, 0.00807199, 0.00807199, 0.00807199, },
  [77] = {0.00000000, 0.00749542, 0.00749542, 0.00000000, 0.00749542, 0.00000000, 0.00749542, 0.00749542, 0.00749542, 0.00749542, },
  [78] = {0.00000000, 0.00697189, 0.00697189, 0.00000000, 0.00697189, 0.00000000, 0.00697189, 0.00697189, 0.00697189, 0.00697189, },
  [79] = {0.00000000, 0.00647547, 0.00647547, 0.00000000, 0.00647547, 0.00000000, 0.00647547, 0.00647547, 0.00647547, 0.00647547, },
  [80] = {0.00000000, 0.00601838, 0.00601838, 0.00000000, 0.00601838, 0.00000000, 0.00601838, 0.00601838, 0.00601838, 0.00601838, },
  [81] = {0.00000000, 0.00458339, 0.00458339, 0.00000000, 0.00458339, 0.00000000, 0.00458339, 0.00458339, 0.00458339, 0.00458339, },
  [82] = {0.00000000, 0.00349034, 0.00349034, 0.00000000, 0.00349034, 0.00000000, 0.00349034, 0.00349034, 0.00349034, 0.00349034, },
  [83] = {0.00000000, 0.00265690, 0.00265690, 0.00000000, 0.00265690, 0.00000000, 0.00265690, 0.00265690, 0.00265690, 0.00265690, },
  [84] = {0.00000000, 0.00202346, 0.00202346, 0.00000000, 0.00202346, 0.00000000, 0.00202346, 0.00202346, 0.00202346, 0.00202346, },
  [85] = {0.00000000, 0.00154105, 0.00154105, 0.00000000, 0.00154105, 0.00000000, 0.00154105, 0.00154105, 0.00154105, 0.00154105, },
  [86] = {0.00000000, 0.00072153, 0.00072153, 0.00000000, 0.00072153, 0.00000000, 0.00072153, 0.00072153, 0.00072153, 0.00072153, },
  [87] = {0.00000000, 0.00050666, 0.00050666, 0.00000000, 0.00050666, 0.00000000, 0.00050666, 0.00050666, 0.00050666, 0.00050666, },
  [88] = {0.00000000, 0.00035578, 0.00035578, 0.00000000, 0.00035578, 0.00000000, 0.00035578, 0.00035578, 0.00035578, 0.00035578, },
  [89] = {0.00000000, 0.00024983, 0.00024983, 0.00000000, 0.00024983, 0.00000000, 0.00024983, 0.00024983, 0.00024983, 0.00024983, },
  [90] = {0.00000000, 0.00017543, 0.00017543, 0.00000000, 0.00017543, 0.00000000, 0.00017543, 0.00017543, 0.00017543, 0.00017543, },
  [91] = {0.00000000, 0.00012319, 0.00012319, 0.00000000, 0.00012319, 0.00000000, 0.00012319, 0.00012319, 0.00012319, 0.00012319, },
  [92] = {0.00000000, 0.00008650, 0.00008650, 0.00000000, 0.00008650, 0.00000000, 0.00008650, 0.00008650, 0.00008650, 0.00008650, },
  [93] = {0.00000000, 0.00006074, 0.00006074, 0.00000000, 0.00006074, 0.00000000, 0.00006074, 0.00006074, 0.00006074, 0.00006074, },
  [94] = {0.00000000, 0.00004265, 0.00004265, 0.00000000, 0.00004265, 0.00000000, 0.00004265, 0.00004265, 0.00004265, 0.00004265, },
  [95] = {0.00000000, 0.00002995, 0.00002995, 0.00000000, 0.00002995, 0.00000000, 0.00002995, 0.00002995, 0.00002995, 0.00002995, },
  [96] = {0.00000000, 0.00002103, 0.00002103, 0.00000000, 0.00002103, 0.00000000, 0.00002103, 0.00002103, 0.00002103, 0.00002103, },
  [97] = {0.00000000, 0.00001477, 0.00001477, 0.00000000, 0.00001477, 0.00000000, 0.00001477, 0.00001477, 0.00001477, 0.00001477, },
  [98] = {0.00000000, 0.00001037, 0.00001037, 0.00000000, 0.00001037, 0.00000000, 0.00001037, 0.00001037, 0.00001037, 0.00001037, },
  [99] = {0.00000000, 0.00000728, 0.00000728, 0.00000000, 0.00000728, 0.00000000, 0.00000728, 0.00000728, 0.00000728, 0.00000728, },
  [100] = {0.00000000, 0.00000511, 0.00000511, 0.00000000, 0.00000511, 0.00000000, 0.00000511, 0.00000511, 0.00000511, 0.00000511, },
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
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- if level is invalid input, default to player level
  if type(level) ~= "number" or level < 1 or level > 100 then
    level = UnitLevel("player")
  end
  -- Calculate
  return int * SpellCritPerInt[level][class], "SPELL_CRIT"
end


local BaseManaRegenPerSpi
--[[---------------------------------
  :GetNormalManaRegenFromSpi(spi, [int], [level])
-------------------------------------
Notes:
  * Formula and BASE_REGEN values derived by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the mana regen per 5 seconds from spirit when out of 5 second rule for given intellect and level.
  * Player class is no longer a parameter
  * ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
Arguments:
  number - Spirit
  [optional] number - Intellect. Default: player's intellect
  [optional] number - Level used in calculations. Default: player's level
Returns:
  ; mp5o5sr : number - Mana regen per 5 seconds when out of 5 second rule
  ; statid : string - "MANA_REGEN"
Example:
  local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
  local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15)
  local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
local BaseManaRegenPerSpi = {
  [1] =  0.020979,
  [2] =  0.020515,
  [3] =  0.020079,
  [4] =  0.019516,
  [5] =  0.018997,
  [6] =  0.018646,
  [7] =  0.018314,
  [8] =  0.017997,
  [9] =  0.017584,
  [10] = 0.017197,
  [11] = 0.016551,
  [12] = 0.015729,
  [13] = 0.015229,
  [14] = 0.014580,
  [15] = 0.014008,
  [16] = 0.013650,
  [17] = 0.013175,
  [18] = 0.012832,
  [19] = 0.012475,
  [20] = 0.012073,
  [21] = 0.011840,
  [22] = 0.011494,
  [23] = 0.011292,
  [24] = 0.010990,
  [25] = 0.010761,
  [26] = 0.010546,
  [27] = 0.010321,
  [28] = 0.010151,
  [29] = 0.009949,
  [30] = 0.009740,
  [31] = 0.009597,
  [32] = 0.009425,
  [33] = 0.009278,
  [34] = 0.009123,
  [35] = 0.008974,
  [36] = 0.008847,
  [37] = 0.008698,
  [38] = 0.008581,
  [39] = 0.008457,
  [40] = 0.008338,
  [41] = 0.008235,
  [42] = 0.008113,
  [43] = 0.008018,
  [44] = 0.007906,
  [45] = 0.007798,
  [46] = 0.007713,
  [47] = 0.007612,
  [48] = 0.007524,
  [49] = 0.007430,
  [50] = 0.007340,
  [51] = 0.007268,
  [52] = 0.007184,
  [53] = 0.007116,
  [54] = 0.007029,
  [55] = 0.006945,
  [56] = 0.006884,
  [57] = 0.006805,
  [58] = 0.006747,
  [59] = 0.006667,
  [60] = 0.006600,
  [61] = 0.006421,
  [62] = 0.006314,
  [63] = 0.006175,
  [64] = 0.006072,
  [65] = 0.005981,
  [66] = 0.005885,
  [67] = 0.005791,
  [68] = 0.005732,
  [69] = 0.005668,
  [70] = 0.005596,
  [71] = 0.005316,
  [72] = 0.005049,
  [73] = 0.004796,
  [74] = 0.004555,
  [75] = 0.004327,
  [76] = 0.004110,
  [77] = 0.003903,
  [78] = 0.003708,
  [79] = 0.003522,
  [80] = 0.003345,
  [81] = 0.003345,
  [82] = 0.003345,
  [83] = 0.003345,
  [84] = 0.003345,
  [85] = 0.003345,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
  -- argCheck for invalid input
  self:argCheck(spi, 2, "number")
  self:argCheck(int, 3, "nil", "number")
  self:argCheck(level, 4, "nil", "number")

  -- if level is invalid input, default to player level
  if type(level) ~= "number" or level < 1 or level > 85 then
    level = UnitLevel("player")
  end

  -- if int is invalid input, default to player int
  if type(int) ~= "number" then
    local _
    _, int = UnitStat("player",4)
  end
  -- Calculate
  return (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REGEN"
end

-- local Level80BaseMana = {
  -- 0, 23422, 0, 0, 20590, 0, 23430, 17418, 20553, 18635,
  -- --["WARRIOR"] = 0,
  -- --["PALADIN"] = 23422,
  -- --["HUNTER"] = 0,
  -- --["ROGUE"] = 0,
  -- --["PRIEST"] = 20590,
  -- --["DEATHKNIGHT"] = 0,
  -- --["SHAMAN"] = 23430,
  -- --["MAGE"] = 17418,
  -- --["WARLOCK"] = 20553,
  -- --["DRUID"] = 18635,
-- }

-- -- StatLogic:GetNormalManaRegenFromSpi2()
-- function StatLogic:GetNormalManaRegenFromSpi2(spi, int, level, class)
  -- -- argCheck for invalid input
  -- self:argCheck(spi, 2, "number")
  -- self:argCheck(int, 3, "nil", "number")
  -- self:argCheck(level, 4, "nil", "number")

  -- -- if level is invalid input, default to player level
  -- if type(level) ~= "number" or level < 1 or level > 80 then
    -- level = UnitLevel("player")
  -- end

  -- -- if int is invalid input, default to player int
  -- if type(int) ~= "number" then
    -- local _
    -- _, int = UnitStat("player",4)
  -- end
  
  -- -- if class is a class string, convert to class id
  -- if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
    -- class = ClassNameToID[strupper(class)]
  -- -- if class is invalid input, default to player class
  -- elseif type(class) ~= "number" or class < 1 or class > 10 then
    -- class = ClassNameToID[playerClass]
  -- end
  
  -- -- Calculate
  -- return Level80BaseMana[class] * 0.05 + (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REGEN"
-- end

--[[---------------------------------
  :GetHealthRegenFromSpi(spi, [class])
-------------------------------------
Notes:
  * HealthRegenPerSpi values derived by Whitetooth (hotdogee [at] gmail [dot] com)
  * Calculates the health regen per 5 seconds when out of combat from spirit for given class.
  * Player level does not effect health regen per spirit.
Arguments:
  number - Spirit
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; hp5oc : number - Health regen per 5 seconds when out of combat
  ; statid : string - "HEALTH_REGEN"
Example:
  local hp5oc = StatLogic:GetHealthRegenFromSpi(1) -- GetHealthRegenPerSpi
  local hp5oc = StatLogic:GetHealthRegenFromSpi(10)
  local hp5oc = StatLogic:GetHealthRegenFromSpi(10, "MAGE")
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
-- 4.0.1.12803: Removed Health Regen from Spirit
local HealthRegenPerSpi = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  --["WARRIOR"] = 0.5,
  --["PALADIN"] = 0.125,
  --["HUNTER"] = 0.125,
  --["ROGUE"] = 0.333333,
  --["PRIEST"] = 0.041667,
  --["DEATHKNIGHT"] = 0.5,
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
  elseif type(class) ~= "number" or class < 1 or class > 10 then
    class = ClassNameToID[playerClass]
  end
  -- Calculate
  return spi * HealthRegenPerSpi[class] * 5, "HEALTH_REGEN"
end


----------
-- Gems --
----------

--[[---------------------------------
  :RemoveEnchant(link)
-------------------------------------
Notes:
  * Remove item's enchants.
Arguments:
  string - "itemlink"
Returns:
  ; link : number - The modified link
Example:
  local link = StatLogic:RemoveEnchant("Hitem:31052:425:525:525:525:525:0:0")
  "|cffa335ee|Hitem:47468:0:2968:0:0:0:0:-2055313024:80:147|h[Cry of the Val'kyr]|h|r",
-----------------------------------]]
function StatLogic:RemoveEnchant(link)
  -- check link
  if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
    return link
  end
  local linkType, itemId, enchantId, rest = strsplit(":", link, 4)
  return strjoin(":", linkType, itemId, 0, rest)
end

--[[---------------------------------
  :RemoveGem(link)
-------------------------------------
Notes:
  * Remove item's gems.
Arguments:
  string - "itemlink"
Returns:
  ; link : number - The modified link
Example:
  local link = StatLogic:RemoveGem("Hitem:31052:425:525:525:525:525:0:0")
-----------------------------------]]
function StatLogic:RemoveGem(link)
  -- check link
  if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
    return link
  end
  local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest = strsplit(":", link, 8)
  if reforging then
  else
  end
  return strjoin(":", linkType, itemId, enchantId, 0, 0, 0, 0, rest)
end

--[[---------------------------------
  :RemoveExtraSocketGem(link)
-------------------------------------
Notes:
  * Remove gems socketed in Prismatic Sockets, this includes Eternal Belt Buckles and Blacksmith only Bracer Socket and Glove Socket.
Arguments:
  string - "itemlink"
Returns:
  ; link : number - The modified link
Example:
  local link = StatLogic:RemoveExtraSocketGem("Hitem:31052:425:525:525:525:525:0:0")
-----------------------------------]]
local itemStatsTable = {}
local GetExtraSocketGemLoc = setmetatable({}, { __index = function(self, n)
  -- We are here because what we want is not in cache
  -- Get last gem location
  local lastGemLoc = 0
  local _, _, _, jewelId1, jewelId2, jewelId3, jewelId4 = strsplit(":", n)
  if jewelId4 ~= "0" then
    lastGemLoc = 4
  elseif jewelId3 ~= "0" then
    lastGemLoc = 3
  elseif jewelId2 ~= "0" then
    lastGemLoc = 2
  elseif jewelId1 ~= "0" then
    lastGemLoc = 1
  end
  if lastGemLoc == 0 then
    self[n] = 0
    return 0
  end
  -- Get number of sockets
  wipe(itemStatsTable)
  GetItemStats(n, itemStatsTable)
  --RatingBuster:Print(itemStatsTable)
  local numSockets = (itemStatsTable["EMPTY_SOCKET_RED"] or 0) + (itemStatsTable["EMPTY_SOCKET_YELLOW"] or 0) + (itemStatsTable["EMPTY_SOCKET_BLUE"] or 0)
  if numSockets < lastGemLoc then
    self[n] = lastGemLoc
    return lastGemLoc
  else
    self[n] = 0
    return 0
  end
end })

local extraSocketLoc = {
  ["INVTYPE_WAIST"] = true,
  ["INVTYPE_WRIST"] = true,
  ["INVTYPE_HAND"] = true,
}
function StatLogic:RemoveExtraSocketGem(link)
  -- check link
  if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
    return link
  end
  -- check only belt, bracer and gloves
  local _, _, _, _, _, _, _, _, itemType = GetItemInfo(link)
  if not extraSocketLoc[itemType] then return link end
  -- Get current gem count
  local extraGemLoc = GetExtraSocketGemLoc[link]
  if extraGemLoc == 0 then return link end
  local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest = strsplit(":", link, 8)
  if extraGemLoc == 1 then
    jewelId1 = "0"
  elseif extraGemLoc == 2 then
    jewelId2 = "0"
  elseif extraGemLoc == 3 then
    jewelId3 = "0"
  elseif extraGemLoc == 4 then
    jewelId4 = "0"
  end
  return strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest)
end


--[[---------------------------------
  :RemoveEnchantGem(link)
-------------------------------------
Notes:
  * Remove item's gems and enchants.
Arguments:
  string - "itemlink"
Returns:
  ; link : number - The modified link
Example:
  local link = StatLogic:RemoveEnchantGem("Hitem:31052:425:525:525:525:525:0:0")
-----------------------------------]]
function StatLogic:RemoveEnchantGem(link)
  -- check link
  if not strfind(link, "item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+") then
    return link
  end
  local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest = strsplit(":", link, 8)
  return strjoin(":", linkType, itemId, 0, 0, 0, 0, 0, rest)
end

--[[---------------------------------
  :ModEnchantGem(link, enc, gem1, gem2, gem3, gem4)
-------------------------------------
Notes:
  * Add/Replace item's enchants or gems with given enchants or gems.
Arguments:
  string - "itemlink"
  [optional] number or string - enchantID to replace the current enchant. Default: no change
  [optional] number or string - gemID to replace the first gem. Default: no change
  [optional] number or string - gemID to replace the second gem. Default: no change
  [optional] number or string - gemID to replace the third gem. Default: no change
  [optional] number or string - gemID to replace the fourth gem. Default: no change
Returns:
  ; link : number - The modified link
Example:
  local link = StatLogic:ModEnchantGem("Hitem:31052:0:0:0:0:0:0:0", 1394)
-----------------------------------]]
function StatLogic:ModEnchantGem(link, enc, gem1, gem2, gem3, gem4)
  -- check link
  if not strfind(link, "item:%d+") then
    return
  end
  local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest = strsplit(":", link, 8)
  return strjoin(":", linkType, itemId, enc or enchantId or 0, gem1 or jewelId1 or 0, gem2 or jewelId2 or 0, gem3 or jewelId3 or 0, gem4 or jewelId4 or 0, rest)
end

--[[---------------------------------
  :BuildGemmedTooltip(item, red, yellow, blue, meta)
-------------------------------------
Notes:
  * Returns a modified link with all empty sockets replaced with the specified gems, sockets already gemmed will remain.
  * item:
  :;tooltip : table - The tooltip showing the item
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string or table - tooltip or itemId or "itemString" or "itemName" or "itemLink"
  number or string - gemID to replace a red socket
  number or string - gemID to replace a yellow socket
  number or string - gemID to replace a blue socket
  number or string - gemID to replace a meta socket
Returns:
  ; link : string - modified item link
Example:
  local link = StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119)
  StatLogic:SetTip("item:28619")
  StatLogic:SetTip(StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119))
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
    -- DEBUG
    if not text then
      print(i, tip:NumLines(), link)
    end
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
  local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest = strsplit(":", link, 8)
  if socketList[1] and (not jewelId1 or jewelId1 == "0") then jewelId1 = socketList[1] end
  if socketList[2] and (not jewelId2 or jewelId2 == "0") then jewelId2 = socketList[2] end
  if socketList[3] and (not jewelId3 or jewelId3 == "0") then jewelId3 = socketList[3] end
  if socketList[4] and (not jewelId4 or jewelId4 == "0") then jewelId4 = socketList[4] end
  return strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, rest)
end

--[[---------------------------------
  :GetGemID(item)
-------------------------------------
Notes:
  * Returns the gemID and gemText of a gem for use in links
  * item:
  :;tooltip : table - The tooltip showing the item
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string or table - Gem, tooltip or itemId or "itemString" or "itemName" or "itemLink"
Returns:
  ; gemID or false : number or bool - The gemID of this gem, false if invalid input
  ; gemText : string - The text shown in the tooltip when socketed in an item
Example:
  local gemID, gemText = StatLogic:GetGemID(28363)
-----------------------------------]]
-- SetTip("item:3185:0:2946")
function StatLogic:GetGemID(item)
  local t = GetTime()
  -- Check item
  if (type(item) == "string") or (type(item) == "number") then
	-- We have link
  elseif type(item) == "table" and type(item.GetItem) == "function" then
    -- We were given a tooltip - get the link
    _, item = item:GetItem()
    if type(item) ~= "string" then return false end
  else
    return false
  end
  -- Check if item is in local cache
  local name, link = GetItemInfo(item)
  if not name then
    if tonumber(item) then
      -- Query server for item
      tipMiner:ClearLines()
      tipMiner:SetHyperlink("item:"..item)
    else
      item = item:match("item:(%d+)")
      if item then
        -- Query server for item
        tipMiner:ClearLines()
        tipMiner:SetHyperlink("item:"..item)
      else
        return false
      end
    end
    return
  end
  local itemID = strmatch(link, "item:(%d+)")
  local itemIDPattern=format("item:%d:", itemID)    -- for testing against gem itemlinks that we find
  local gemScanLink = "item:6948:0:0:0:%d:%d"
  

  -- Method 1: Try to find the gem already in our gear. Provides a layer of safety for future expansions (and might avoid unnecessary disconnects from scanning)
  for i=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
    local eqLink = GetInventoryItemLink("player", i)
    local gemIDs = { strmatch(eqLink or "", "item:[-0-9]+:[-0-9]+:([-0-9]+):([-0-9]+):([-0-9]+):") }    -- yah garbage. this is a manual operation; it matters not.
    for i=1, #gemIDs do
		local gemID = gemIDs[i]
        local gemName, gemLink = GetItemGem(eqLink, i)
        if gemLink and gemLink:match(itemIDPattern) then
          tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
          tipMiner:SetHyperlink(gemScanLink:format(gemID, gemID))
          if GetCVarBool("colorblindMode") then
            return gemID, StatLogicMinerTooltipTextLeft6:GetText(), GetTime()-t
          else
            return gemID, StatLogicMinerTooltipTextLeft5:GetText(), GetTime()-t
          end
        end
    end
  end
  
  
  -- Method 2: Fallback scanner if we didn't find the gem in our gear. This will fail if gemIDs go higher than our assumed maximum
  if not GetItemInfo(6948) then -- Hearthstone
    -- Query server for Hearthstone
    tipMiner:ClearLines()
    tipMiner:SetHyperlink("item:6948")
    return
  end
  local gemID
  -- Start GemID scan
  for gemID = 5000, 1, -1 do    -- THIS NUMBER MAY NEED TO BE INCREASED IN NEW EXPANSIONS
    local itemLink = gemScanLink:format(gemID, gemID)
    local _, gem1Link = GetItemGem(itemLink, 3)
    if gem1Link and gem1Link:match(itemIDPattern) then
      tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
      tipMiner:SetHyperlink(itemLink)
      if GetCVarBool("colorblindMode") then
        return gemID, StatLogicMinerTooltipTextLeft6:GetText(), GetTime()-t
      else
        return gemID, StatLogicMinerTooltipTextLeft5:GetText(), GetTime()-t
      end
    end
  end
end

-- will sometimes disconnect
-- StatLogic:GetEnchantID("+10 All Stats")
--[[
function StatLogic:GetEnchantID(spell)
  -- Check item
  if not ((type(spell) == "string") or (type(spell) == "number")) then
    return
  end
  local spellName = spell
  if type(spell) == "number" then
    spellName = GetSpellInfo(spell)
  end
  if not GetItemInfo(6948) then -- Hearthstone
    -- Query server for Hearthstone
    tipMiner:ClearLines()
    tipMiner:SetHyperlink("item:6948")
    return
  end
  local scanLink = "item:6948:%d:%d:%d:%d:%d"
  local id
  -- Start EnchantID scan
  for id = 4300, 5, -5 do
    local itemLink = scanLink:format(id, id-1, id-2, id-3, id-4)
    tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
    tipMiner:SetHyperlink(itemLink)
    if StatLogicMinerTooltipTextLeft4:GetText() == spellName then
      return id, StatLogicMinerTooltipTextLeft4:GetText()
    elseif StatLogicMinerTooltipTextLeft5:GetText() and strfind(StatLogicMinerTooltipTextLeft5:GetText(), spellName) then
      return id, StatLogicMinerTooltipTextLeft5:GetText()
    elseif StatLogicMinerTooltipTextLeft6:GetText() and strfind(StatLogicMinerTooltipTextLeft6:GetText(), spellName) then
      return id, StatLogicMinerTooltipTextLeft6:GetText()
    elseif StatLogicMinerTooltipTextLeft7:GetText() and strfind(StatLogicMinerTooltipTextLeft7:GetText(), spellName) then
      return id, StatLogicMinerTooltipTextLeft7:GetText()
    elseif StatLogicMinerTooltipTextLeft8:GetText() == spellName then
      return id, StatLogicMinerTooltipTextLeft8:GetText()
    end
  end
end
--]]

-- ================== --
-- Stat Summarization --
-- ================== --
--[[---------------------------------
  :GetSum(item, [table])
-------------------------------------
Notes:
  * Calculates the sum of all stats for a specified item.
  * item:
  :;tooltip : table - The tooltip showing the item
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string or table - tooltip or itemId or "itemString" or "itemName" or "itemLink"
  table - The sum of stat values are writen to this table if provided
Returns:
  ; sumTable : table - The table with stat sum values
  :{
  ::    ["itemType"] = itemType,
  ::    ["STAT_ID1"] = value,
  ::    ["STAT_ID2"] = value,
  :}
Example:
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
-----------------------------------]]
--[[
0 = Poor
1 = Common
2 = Uncommon
3 = Rare
4 = Epic
5 = Legendary
6 = Artifact
7 = Heirloom
--]]
-- baseArmorTable[rarity][equipLoc][armorType][ilvl] = armorValue
-- Not interested in lower level items
local baseArmorTable = {
  [4] = {
    ["INVTYPE_CLOAK"] = {
      [L["Cloth"]] = {
        [200] = 404, -- Cloak of Armed Strife ID:39225
        [213] = 428, -- Cloak of the Shadowed Sun ID:40252
        [264] = 556, -- Sentinel's Winter Cloak ID:50466
      },
    },
    ["INVTYPE_LEGS"] = {
      [L["Plate"]] = {
        [226] = 2088, -- Saronite Plated Legguards ID:45267
      },
    },
  },
  [3] = {
    ["INVTYPE_CLOAK"] = {
      [L["Cloth"]] = {
        [167] = 312, -- Cloak of Tormented Skies ID:41238
        [187] = 364, -- Flowing Cloak of Command ID:37084
      },
    },
  },
}
local bonusArmorItemEquipLoc = {
  ["INVTYPE_WEAPON"] = true,
  ["INVTYPE_2HWEAPON"] = true,
  ["INVTYPE_WEAPONMAINHAND"] = true,
  ["INVTYPE_WEAPONOFFHAND"] = true,
  ["INVTYPE_HOLDABLE"] = true,
  ["INVTYPE_RANGED"] = true,
  ["INVTYPE_THROWN"] = true,
  ["INVTYPE_RANGEDRIGHT"] = true,
  ["INVTYPE_NECK"] = true,
  ["INVTYPE_FINGER"] = true,
  ["INVTYPE_TRINKET"] = true,
}
function StatLogic:GetSum(item, table)
  -- Locale check
  if noPatternLocale then return end
  -- Clear table values
  clearTable(table)
  local _
  -- Check item
  if (type(item) == "string") or (type(item) == "number") then -- common case first
  elseif type(item) == "table" and type(item.GetItem) == "function" then
    -- Get the link
    _, item = item:GetItem()
    if type(item) ~= "string" then return end
  else
    return table
  end
  -- Check if item is in local cache
  local name, link, rarity , ilvl, reqLv, _, armorType, _, itemType = GetItemInfo(item)
  if not name then return table end

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

  -- Start parsing
  tip:ClearLines() -- this is required or SetX won't work the second time its called
  tip:SetHyperlink(link)
  debugPrint(link)
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

    local r, g, b = tip[i]:GetTextColor()
    -----------------------
    -- Whole Text Lookup --
    -----------------------
    -- Mainly used for enchants or stuff without numbers:
    -- "Mithril Spurs"
    local found
    local idTable = L.WholeTextLookup[text]
    if idTable == false then
      found = true
      debugPrint("|cffadadad".."  WholeText Exclude: "..text)
    elseif idTable then
      found = true
      for id, value in pairs(L.WholeTextLookup[text]) do
        -- sum stat
        table[id] = (table[id] or 0) + value
        debugPrint("|cffff5959".."  WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
      end
    end
    -- Fast Exclude --
    -- Exclude obvious strings that do not need to be checked, also exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
    if not (found or L.Exclude[text] or L.Exclude[strutf8sub(text, 1, L.ExcludeLen)] or strsub(text, 1, 1) == '"' or g < 0.8 or (b < 0.99 and b > 0.1)) then
      --debugPrint(text.." = ")
      -- Strip enchant time
      -- ITEM_ENCHANT_TIME_LEFT_DAYS = "%s (%d day)";
      -- ITEM_ENCHANT_TIME_LEFT_DAYS_P1 = "%s (%d days)";
      -- ITEM_ENCHANT_TIME_LEFT_HOURS = "%s (%d hour)";
      -- ITEM_ENCHANT_TIME_LEFT_HOURS_P1 = "%s (%d hrs)";
      -- ITEM_ENCHANT_TIME_LEFT_MIN = "%s (%d min)"; -- Enchantment name, followed by the time left in minutes
      -- ITEM_ENCHANT_TIME_LEFT_SEC = "%s (%d sec)"; -- Enchantment name, followed by the time left in seconds
      --[[ Seems temp enchants such as mana oil can't be seen from item links, so commented out
      if strfind(text, "%)") then
        debugPrint("test")
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
            debugPrint("|cffadadad".."  SinglePlus Exclude: "..text)
          elseif idTable then
            found = true
            local debugText = "|cffff5959".."  SinglePlus: ".."|cffffc259"..text
            for _, id in ipairs(idTable) do
              --debugPrint("  '"..value.."', '"..id.."'")
              -- sum stat
              table[id] = (table[id] or 0) + tonumber(value)
              debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
            end
            debugPrint(debugText)
          else
            -- pattern match but not found in L.StatIDLookup, keep looking
            debugPrint("  SinglePlusStatCheck Lookup Fail: |cffffd4d4'"..statText.."'")
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
            debugPrint("|cffadadad".."  SingleEquip Exclude: "..text)
          elseif idTable then
            found = true
            local debugText = "|cffff5959".."  SingleEquip: ".."|cffffc259"..text
            for _, id in ipairs(idTable) do
              --debugPrint("  '"..value.."', '"..id.."'")
              -- sum stat
              table[id] = (table[id] or 0) + tonumber(value)
              debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
            end
            debugPrint(debugText)
          else
            -- pattern match but not found in L.StatIDLookup, keep looking
            debugPrint("  SingleEquipStatCheck Lookup Fail: |cffffd4d4'"..statText.."'")
          end
        end
      end
      -- PreScan for special cases, that will fit wrongly into DeepScan
      -- PreScan also has exclude patterns
      -- This is where base armor gets scanned, check text color for bonus armor
      if not found then
        for pattern, id in pairs(L.PreScanPatterns) do
          local value
          found, _, value = strfind(text, pattern)
          if found then
            --found = true
            if id ~= false then
              local debugText = "|cffff5959".."  PreScan: ".."|cffffc259"..text
              --debugPrint("  '"..value.."' = '"..id.."'")
              -- check text color for bonus armor
              if id == "ARMOR" and r == 0 and b == 0 and
              baseArmorTable[rarity] and baseArmorTable[rarity][itemType] and
              baseArmorTable[rarity][itemType][armorType] and baseArmorTable[rarity][itemType][armorType][ilvl] and
              tonumber(value) > baseArmorTable[rarity][itemType][armorType][ilvl] then
                table["ARMOR"] = (table["ARMOR"] or 0) + baseArmorTable[rarity][itemType][armorType][ilvl]
                table["ARMOR_BONUS"] = (table["ARMOR_BONUS"] or 0) + tonumber(value) - baseArmorTable[rarity][itemType][armorType][ilvl]
                debugText = debugText..", ".."|cffffff59ARMOR="..baseArmorTable[rarity][itemType][armorType][ilvl]..", ARMOR_BONUS="..(tonumber(value) - baseArmorTable[rarity][itemType][armorType][ilvl])
              else
                -- sum stat
                table[id] = (table[id] or 0) + tonumber(value)
                debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
              end
              debugPrint(debugText)
            else
              debugPrint("|cffadadad".."  PreScan Exclude: "..text.."("..pattern..")")
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
        text = gsub(text, _G.ITEM_SPELL_TRIGGER_ONEQUIP, "") -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
        text = gsub(text, StripGlobalStrings(_G.ITEM_SOCKET_BONUS), "") -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
        -- Trim spaces
        text = strtrim(text)
        -- Strip trailing "."
        if strutf8sub(text, -1) == L["."] then
          text = strutf8sub(text, 1, -2)
        end
        -- Replace separators with @
        for _, sep in ipairs(L.DeepScanSeparators) do
          if strfind(text, sep) then
             -- if there is a capture, for deDE
            if strsub(sep, 1, 1) == "(" then
              text = gsub(text, sep, "%1@")
            else
              text = gsub(text, sep, "@")
            end
          end
        end
        -- Split text using @
        text = {strsplit("@", text)}
        for i, text in ipairs(text) do
          -- Trim spaces
          text = strtrim(text)
          -- Strip color codes
          if strsub(text, -2) == "|r" then
            text = strsub(text, 1, -3)
          end
          if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
            text = strsub(text, 11)
          end
          -- Strip trailing "."
          if strutf8sub(text, -1) == L["."] then
            text = strutf8sub(text, 1, -2)
          end
          debugPrint("|cff008080".."S"..i..": ".."'"..text.."'")
          -- Whole Text Lookup
          local foundWholeText = false
          local idTable = L.WholeTextLookup[text]
          if idTable == false then
            foundWholeText = true
            found = true
            debugPrint("|cffadadad".."  DeepScan WholeText Exclude: "..text)
          elseif idTable then
            foundWholeText = true
            found = true
            for id, value in pairs(L.WholeTextLookup[text]) do
              -- sum stat
              table[id] = (table[id] or 0) + value
              debugPrint("|cffff5959".."  DeepScan WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
            end
          elseif L.Exclude[text] or L.Exclude[strutf8sub(text, 1, L.ExcludeLen)] then
            foundWholeText = true
            found = true
            debugPrint("|cffadadad".."  DeepScan Exclude: "..text)
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
                  --debugPrint("  '"..value.."', '"..id.."'")
                  -- sum stat
                  table[id] = (table[id] or 0) + tonumber(value1)
                  debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
                end
                for _, id in ipairs(dualStat[2]) do
                  --debugPrint("  '"..value.."', '"..id.."'")
                  -- sum stat
                  table[id] = (table[id] or 0) + tonumber(value2)
                  debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
                end
                debugPrint(debugText)
                if dEnd ~= strlen(lowered) then
                  foundWholeText = false
                  text = strsub(text, dEnd + 1)
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
                  debugPrint("|cffadadad".."  DeepScan Exclude: "..text)
                  break -- break out of pattern loop and go to the next separated text
                elseif idTable then
                  foundDeepScan1 = true
                  found = true
                  local debugText = "|cffff5959".."  DeepScan: ".."|cffffc259"..text
                  for _, id in ipairs(idTable) do
                    --debugPrint("  '"..value.."', '"..id.."'")
                    -- sum stat
                    table[id] = (table[id] or 0) + tonumber(value)
                    debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
                  end
                  debugPrint(debugText)
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
              -- Strip color codes
              if strsub(text, -2) == "|r" then
                text = strsub(text, 1, -3)
              end
              if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
                text = strsub(text, 11)
              end
              -- Strip trailing "."
              if strutf8sub(text, -1) == L["."] then
                text = strutf8sub(text, 1, -2)
              end
              debugPrint("|cff008080".."S"..i.."-"..j..": ".."'"..text.."'")
              -- Whole Text Lookup
              local foundWholeText = false
              local idTable = L.WholeTextLookup[text]
              if idTable == false then
                foundWholeText = true
                found = true
                debugPrint("|cffadadad".."  DeepScan2 WholeText Exclude: "..text)
              elseif idTable then
                foundWholeText = true
                found = true
                for id, value in pairs(L.WholeTextLookup[text]) do
                  -- sum stat
                  table[id] = (table[id] or 0) + value
                  debugPrint("|cffff5959".."  DeepScan2 WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
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
                      --debugPrint("  '"..value.."', '"..id.."'")
                      -- sum stat
                      table[id] = (table[id] or 0) + tonumber(value1)
                      debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
                    end
                    for _, id in ipairs(dualStat[2]) do
                      --debugPrint("  '"..value.."', '"..id.."'")
                      -- sum stat
                      table[id] = (table[id] or 0) + tonumber(value2)
                      debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
                    end
                    debugPrint(debugText)
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
                      debugPrint("|cffadadad".."  DeepScan2 Exclude: "..text)
                      break
                    elseif idTable then
                      foundDeepScan2 = true
                      found = true
                      local debugText = "|cffff5959".."  DeepScan2: ".."|cffffc259"..text
                      for _, id in ipairs(idTable) do
                        --debugPrint("  '"..value.."', '"..id.."'")
                        -- sum stat
                        table[id] = (table[id] or 0) + tonumber(value)
                        debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
                      end
                      debugPrint(debugText)
                      break
                    else
                      -- pattern match but not found in L.StatIDLookup, keep looking
                      debugPrint("  DeepScan2 Lookup Fail: |cffffd4d4'"..statText.."'|r, pattern = |cff72ff59'"..pattern.."'")
                    end
                  end
                end -- for
              end
              if not foundWholeText and not foundDeepScan2 then
                debugPrint("  DeepScan2 Fail: |cffff0000'"..text.."'")
              end
            end
          end -- if not foundWholeText and not foundDeepScan1 then
        end
      end

      if not found then
        debugPrint("  No Match: |cffff0000'"..text.."'")
        -- if DEBUG and RatingBuster then
          -- RatingBuster.db.profile.test = text
        -- end
      end
    else
      --debugPrint("Excluded: "..text); --it's helpful when debugging to see if an item's property was ignored - even if it is spammy
    end
  end
  -- Tooltip scanning done, do post processing
  --[[ 3.0.8
  Bonus Armor: The mechanics for items with bonus armor on them has
  changed (any cloth, leather, mail, or plate items with extra armor,
  or any other items with any armor). Bonus armor beyond the base
  armor of an item will no longer be multiplied by any talents or by
  the bonuses of Bear Form, Dire Bear Form, or Frost Presence.
  --]]
  if bonusArmorItemEquipLoc[itemType] and table["ARMOR"] then
    -- Convert "ARMOR" to "ARMOR_BONUS"
    table["ARMOR_BONUS"] = (table["ARMOR_BONUS"] or 0) + table["ARMOR"]
    table["ARMOR"] = nil
  end
  cache[link] = copy(table)
  return table
end

function StatLogic:GetFinalArmor(item, text)
  -- Locale check
  if noPatternLocale then return end
  local _
  -- Check item
  if (type(item) == "string") or (type(item) == "number") then -- common case first
  elseif type(item) == "table" and type(item.GetItem) == "function" then
    -- Get the link
    _, item = item:GetItem()
    if type(item) ~= "string" then return end
  else
    return
  end
  -- Check if item is in local cache
  local name, _, rarity , ilvl, _, _, armorType, _, itemType = GetItemInfo(item)
  if not name then return end


  for pattern, id in pairs(L.PreScanPatterns) do
    if id == "ARMOR" or id == "ARMOR_BONUS" then
      local found, _, value = strfind(text, pattern)
      if found then
        local armor = 0
        local bonus_armor = 0
        if id == "ARMOR" and baseArmorTable[rarity] and baseArmorTable[rarity][itemType] and
        baseArmorTable[rarity][itemType][armorType] and baseArmorTable[rarity][itemType][armorType][ilvl] and
        tonumber(value) > baseArmorTable[rarity][itemType][armorType][ilvl] then
          armor = baseArmorTable[rarity][itemType][armorType][ilvl]
          bonus_armor = tonumber(value) - baseArmorTable[rarity][itemType][armorType][ilvl]
        else
          armor = tonumber(value)
        end
        if bonusArmorItemEquipLoc[itemType] then
          bonus_armor = bonus_armor + armor
          armor = 0
        end
        return armor * self:GetStatMod("MOD_ARMOR") + bonus_armor
      end
    end
  end
end

--[[---------------------------------
  :GetDiffID(item, [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta], [ignorePris])
-------------------------------------
Notes:
  * Returns a unique identification string of the diff calculation, the identification string is made up of links concatenated together, can be used for cache indexing
  * item:
  :;tooltip : table - The tooltip showing the item
  :;itemId : number - The numeric ID of the item. e.g. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string or table - tooltip or itemId or "itemString" or "itemName" or "itemLink"
  boolean - Ignore enchants when calculating the id if true
  boolean - Ignore gems when calculating the id if true
  number or string - gemID to replace a red socket
  number or string - gemID to replace a yellow socket
  number or string - gemID to replace a blue socket
  number or string - gemID to replace a meta socket
  boolean - Ignore prismatic sockets when calculating the id if true
Returns:
  ; id : string - a unique identification string of the diff calculation, for use as cache key
  ; link : string - link of main item
  ; linkDiff1 : string - link of compare item 1
  ; linkDiff2 : string - link of compare item 2
Example:
  StatLogic:GetDiffID(21417) -- Ring of Unspoken Names
  StatLogic:GetDiffID("item:18832:2564:0:0:0:0:0:0", true, true) -- Brutality Blade with +15 agi enchant
  http://www.wowwiki.com/EnchantId
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

function HasTitanGrip(talentGroup)
  if playerClass == "WARRIOR" then
    local _, _, _, _, r = GetTalentInfo(2, 20, nil, nil, talentGroup)
    return r > 0
  end
end

function StatLogic:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta, ignorePris)
  local _, name, itemType, link, linkDiff1, linkDiff2
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
    if IsUsableSpell(GetSpellInfo(674)) then        -- ["Dual Wield"]
      local _, _, _, _, _, _, _, _, eqItemType = GetItemInfo(linkDiff1)
      -- If 2h is equipped, copy diff1 to diff2
      if eqItemType == "INVTYPE_2HWEAPON" and not HasTitanGrip() then
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
  if ignorePris then
    link = self:RemoveExtraSocketGem(link)
    linkDiff1 = self:RemoveExtraSocketGem(linkDiff1)
    if linkDiff2 then
      linkDiff2 = self:RemoveExtraSocketGem(linkDiff2)
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
  :GetDiff(item, [diff1], [diff2], [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta], [ignorePris])
-------------------------------------
Notes:
  * Calculates the stat diffrence from the specified item and your currently equipped items.
  * item:
  :;tooltip : table - The tooltip showing the item
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
Arguments:
  number or string or table - tooltip or itemId or "itemString" or "itemName" or "itemLink"
  table - Stat difference of item and equipped item 1 are writen to this table if provided
  table - Stat difference of item and equipped item 2 are writen to this table if provided
  boolean - Ignore enchants when calculating stat diffrences
  boolean - Ignore gems when calculating stat diffrences
  number or string - gemID to replace a red socket
  number or string - gemID to replace a yellow socket
  number or string - gemID to replace a blue socket
  number or string - gemID to replace a meta socket
  boolean - Ignore prismatic sockets when calculating the id if true
Returns:
  ; diff1 : table - The table with stat diff values for item 1
  :{
  ::    ["STAT_ID1"] = value,
  ::    ["STAT_ID2"] = value,
  :}
  ; diff2 : table - The table with stat diff values for item 2
  :{
  ::    ["STAT_ID1"] = value,
  ::    ["STAT_ID2"] = value,
  :}
Example:
  StatLogic:GetDiff(21417, {}) -- Ring of Unspoken Names
  StatLogic:GetDiff(21452) -- Staff of the Ruins
-----------------------------------]]

-- TODO 2.1.0: Use SetHyperlinkCompareItem in StatLogic:GetDiff
function StatLogic:GetDiff(item, diff1, diff2, ignoreEnchant, ignoreGem, red, yellow, blue, meta, ignorePris)
    debugPrint("StatLogic:GetDiff");
    --debugPrint("    item="..item)

    

  -- Locale check
  if noPatternLocale then return end

  -- Get DiffID
  local id, link, linkDiff1, linkDiff2 = self:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta, ignorePris)
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
  local itemSum = self:GetSum(link)
  if not itemSum then return end
  local itemType = itemSum.itemType

  if itemType == "INVTYPE_2HWEAPON" and not HasTitanGrip() then
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
-- 1000 times: 0.6 sec without cache
-- 1000 times: 0.012 sec with cache
---------
-- ItemBonusLib:ScanItemLink(link)
-- 1000 times: 1.58 sec
---------
-- LibItemBonus:ScanItem(link, true)
-- 1000 times: 0.72 sec without cache
-- 1000 times: 0.009 sec with cache
---------
--[[
LoadAddOn("LibItemBonus-2.0")
local LibItemBonus = LibStub("LibItemBonus-2.0")
-- #NODOC
function StatLogic:Bench(k)
  DEFAULT_CHAT_FRAME:AddMessage("test")
  local t = GetTime()
  local link = GetInventoryItemLink("player", 12)
  local table = {}
  --local GetItemInfo = _G["GetItemInfo"]
  for i = 1, k do
    ---------------------------------------------------------------------------
    --self:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ","})
    ---------------------------------------------------------------------------
    self:GetSum(link)
    --LibItemBonus:ScanItemLink(link)
    ---------------------------------------------------------------------------
    --ItemRefTooltip:SetScript("OnTooltipSetItem", function(frame, ...) RatingBuster:Print("OnTooltipSetItem") end)
    ---------------------------------------------------------------------------
    --GetItemInfo(link)
  end
  DEFAULT_CHAT_FRAME:AddMessage(GetTime() - t)
  t = GetTime()
  for i = 1, k do
    LibItemBonus:ScanItem(link, true)
  end
  DEFAULT_CHAT_FRAME:AddMessage(GetTime() - t)
  --return GetTime() - t1
end
--]]
--[[
-- #NODOC
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
--]]

-- for debugging
_G.StatLogic = StatLogic

----------------------
-- API doc template --
----------------------
--[[---------------------------------
  :SetTip(item)
-------------------------------------
Notes:
  * This is a debugging tool for localizers
  * Displays item in ItemRefTooltip
  * item:
  :;itemId : number - The numeric ID of the item. ie. 12345
  :;"itemString" : string - The full item ID in string format, e.g. "item:12345:0:0:0:0:0:0:0".
  :::Also supports partial itemStrings, by filling up any missing ":x" value with ":0", e.g. "item:12345:0:0:0"
  :;"itemName" : string - The Name of the Item, ex: "Hearthstone"
  :::The item must have been equiped, in your bags or in your bank once in this session for this to work.
  :;"itemLink" : string - The itemLink, when Shift-Clicking items.
  * Converts ClassID to and from "ClassName"
  * class:
  :{| class="wikitable"
  !ClassID!!"ClassName"
  |-
  |1||"WARRIOR"
  |-
  |2||"PALADIN"
  |-
  |3||"HUNTER"
  |-
  |4||"ROGUE"
  |-
  |5||"PRIEST"
  |-
  |6||"DEATHKNIGHT"
  |-
  |7||"SHAMAN"
  |-
  |8||"MAGE"
  |-
  |9||"WARLOCK"
  |-
  |10||"DRUID"
  |}
Arguments:
  number or string - itemId or "itemString" or "itemName" or "itemLink"
  [optional] string - Armor value. Default: player's armor value
  [optional] number - Attacker level. Default: player's level
  [optional] string or number - ClassID or "ClassName". Default: PlayerClass<br>See :GetClassIdOrName(class) for valid class values.
Returns:
  ; modParry : number - The part that is affected by diminishing returns.
  ; drFreeParry : number - The part that isn't affected by diminishing returns.
Example:
  StatLogic:SetTip("item:3185:0:0:0:0:0:1957")
-----------------------------------]]
