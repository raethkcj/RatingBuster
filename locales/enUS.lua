--[[
Name: RatingBuster enUS locale
Revision: $Revision: 73696 $
Translated by:
- Whitetooth (hotdogee [at] gmail [dot] com)
]]

---@class RatingBusterLocale
---@field numberPatterns table
---@field exclusions table
---@field separators table
---@field statList table
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "enUS", true)
L["RatingBuster Options"] = true
local StatLogic = LibStub("StatLogic")
---------------------------
-- Slash Command Options --
---------------------------
-- /rb help
L["Help"] = true
L["Show this help message"] = true
-- /rb win
L["Options Window"] = true
L["Shows the Options Window"] = true
-- /rb statmod
L["Enable Stat Mods"] = true
L["Enable support for Stat Mods"] = true
L["Enable Avoidance Diminishing Returns"] = true
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = true

-- /rb itemid
L["Show ItemID"] = true
L["Show the ItemID in tooltips"] = true
-- /rb itemlevel
L["Show ItemLevel"] = true
L["Show the ItemLevel in tooltips"] = true
-- /rb usereqlv
L["Use required level"] = true
L["Calculate using the required level if you are below the required level"] = true
-- /rb setlevel
L["Set level"] = true
L["Set the level used in calculations (0 = your level)"] = true
-- /rb color
L["Change text color"] = true
L["Changes the color of added text"] = true
L["Change number color"] = true
-- /rb rating
L["Rating"] = true
L["Options for Rating display"] = true
-- /rb rating show
L["Show Rating conversions"] = true
L["Show Rating conversions in tooltips"] = true
-- /rb rating spell
L["Show Spell Hit/Haste"] = true
L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
L["Show Physical Hit/Haste"] = true
L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show detailed conversions text"] = true
L["Show detailed text for Resilience and Expertise conversions"] = true
-- /rb rating def
L["Defense breakdown"] = true
L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = true
-- /rb rating wpn
L["Weapon Skill breakdown"] = true
L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = true
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = true
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = true

-- /rb stat
L["Stat Breakdown"] = true
L["Changes the display of base stats"] = true
-- /rb stat show
L["Show base stat conversions"] = true
L["Show base stat conversions in tooltips"] = true
-- /rb stat str
L["Strength"] = true
L["Changes the display of Strength"] = true

-- /rb stat agi
L["Agility"] = true
L["Changes the display of Agility"] = true
-- /rb stat agi crit
L["Show Crit"] = true
L["Show Crit chance from Agility"] = true
-- /rb stat agi dodge
L["Show Dodge"] = true
L["Show Dodge chance from Agility"] = true

-- /rb stat sta
L["Stamina"] = true
L["Changes the display of Stamina"] = true

-- /rb stat int
L["Intellect"] = true
L["Changes the display of Intellect"] = true
-- /rb stat int spellcrit
L["Show Spell Crit"] = true
L["Show Spell Crit chance from Intellect"] = true

-- /rb stat spi
L["Spirit"] = true
L["Changes the display of Spirit"] = true

---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = true
L["Changes the display of Armor"] = true
L["Attack Power"] = true
L["Changes the display of Attack Power"] = true
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = true
L["Options for stat summary"] = true
-- /rb sum show
L["Show stat summary"] = true
L["Show stat summary in tooltips"] = true
-- /rb sum ignore
L["Ignore settings"] = true
L["Ignore stuff when calculating the stat summary"] = true
-- /rb sum ignore unused
L["Ignore unused item types"] = true
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = true
-- /rb sum ignore equipped
L["Ignore equipped items"] = true
L["Hide stat summary for equipped items"] = true
-- /rb sum ignore enchant
L["Ignore enchants"] = true
L["Ignore enchants on items when calculating the stat summary"] = true
-- /rb sum ignore gem
L["Ignore gems"] = true
L["Ignore gems on items when calculating the stat summary"] = true
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
-- /rb sum diffstyle
L["Display style for diff value"] = true
L["Display diff values in the main tooltip or only in compare tooltips"] = true
L["Hide Blizzard Item Comparisons"] = true
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = true
-- /rb sum space
L["Add empty line"] = true
L["Add a empty line before or after stat summary"] = true
-- /rb sum space before
L["Add before summary"] = true
L["Add a empty line before stat summary"] = true
-- /rb sum space after
L["Add after summary"] = true
L["Add a empty line after stat summary"] = true
-- /rb sum icon
L["Show icon"] = true
L["Show the sigma icon before summary listing"] = true
-- /rb sum title
L["Show title text"] = true
L["Show the title text before summary listing"] = true
-- /rb sum showzerostat
L["Show zero value stats"] = true
L["Show zero value stats in summary for consistancy"] = true
-- /rb sum calcsum
L["Calculate stat sum"] = true
L["Calculate the total stats for the item"] = true
-- /rb sum calcdiff
L["Calculate stat diff"] = true
L["Calculate the stat difference for the item and equipped items"] = true
-- /rb sum sort
L["Sort StatSummary alphabetically"] = true
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = true
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = true
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = true
-- /rb sum basic
L["Stat - Basic"] = true
L["Choose basic stats for summary"] = true
-- /rb sum physical
L["Stat - Physical"] = true
L["Choose physical damage stats for summary"] = true
L["Ranged"] = true
L["Weapon"] = true
-- /rb sum spell
L["Stat - Spell"] = true
L["Choose spell damage and healing stats for summary"] = true
-- /rb sum tank
L["Stat - Tank"] = true
L["Choose tank stats for summary"] = true
-- /rb sum stat hp
L["Sum Health"] = true
L["Health <- Health, Stamina"] = true
-- /rb sum stat mp
L["Sum Mana"] = true
L["Mana <- Mana, Intellect"] = true
-- /rb sum stat ap
L["Sum Attack Power"] = true
L["Attack Power <- Attack Power, Strength, Agility"] = true
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = true
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = true
-- /rb sum stat dmg
L["Sum Spell Damage"] = true
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = true
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = true
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = true
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = true
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = true
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = true
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = true
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = true
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = true
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = true
-- /rb sum stat heal
L["Sum Healing"] = true
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = true
-- /rb sum stat hit
L["Sum Hit Chance"] = true
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = true
-- /rb sum stat crit
L["Sum Crit Chance"] = true
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = true
-- /rb sum stat haste
L["Sum Haste"] = true
L["Haste <- Haste Rating"] = true
L["Sum Ranged Hit Chance"] = true
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = true
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = true
L["Ranged Hit Rating Summary"] = true
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = true
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = true
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = true
L["Ranged Crit Rating Summary"] = true
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = true
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = true
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = true
L["Ranged Haste Rating Summary"] = true

-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = true
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = true
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = true
L["Spell Hit Chance <- Spell Hit Rating"] = true
-- /rb sum stat hastespell
L["Sum Spell Haste"] = true
L["Spell Haste <- Spell Haste Rating"] = true
-- /rb sum stat mp5
L["Sum Mana Regen"] = true
L["Mana Regen <- Mana Regen, Spirit"] = true
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = true
L["Mana Regen while not casting <- Spirit"] = true
-- /rb sum stat hp5
L["Sum Health Regen"] = true
L["Health Regen <- Health Regen"] = true
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = true
L["Health Regen when out of combat <- Spirit"] = true
-- /rb sum stat armor
L["Sum Armor"] = true
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = true
-- /rb sum stat blockvalue
L["Sum Block Value"] = true
L["Block Value <- Block Value, Strength"] = true
-- /rb sum stat dodge
L["Sum Dodge Chance"] = true
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = true
-- /rb sum stat parry
L["Sum Parry Chance"] = true
L["Parry Chance <- Parry Rating, Defense Rating"] = true
-- /rb sum stat block
L["Sum Block Chance"] = true
L["Block Chance <- Block Rating, Defense Rating"] = true
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = true
L["Hit Avoidance <- Defense Rating"] = true
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = true
L["Crit Avoidance <- Defense Rating, Resilience"] = true
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = true
L["Dodge Neglect <- Expertise, Weapon Skill Rating"] = true -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = true
L["Parry Neglect <- Expertise, Weapon Skill Rating"] = true -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = true
L["Block Neglect <- Weapon Skill Rating"] = true
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = true
L["Arcane Resistance Summary"] = true
-- /rb sum stat resfire
L["Sum Fire Resistance"] = true
L["Fire Resistance Summary"] = true
-- /rb sum stat resnature
L["Sum Nature Resistance"] = true
L["Nature Resistance Summary"] = true
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = true
L["Frost Resistance Summary"] = true
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = true
L["Shadow Resistance Summary"] = true
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = true
L["Weapon DPS Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = true
L["Spell Penetration Summary"] = true
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = true
L["Ignore Armor Summary"] = true
L["Sum Armor Penetration"] = true
L["Armor Penetration Summary"] = true
L["Sum Armor Penetration Rating"] = true
L["Armor Penetration Rating Summary"] = true
-- /rb sum statcomp str
L["Sum Strength"] = true
L["Strength Summary"] = true
-- /rb sum statcomp agi
L["Sum Agility"] = true
L["Agility Summary"] = true
-- /rb sum statcomp sta
L["Sum Stamina"] = true
L["Stamina Summary"] = true
-- /rb sum statcomp int
L["Sum Intellect"] = true
L["Intellect Summary"] = true
-- /rb sum statcomp spi
L["Sum Spirit"] = true
L["Spirit Summary"] = true
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = true
L["Hit Rating Summary"] = true
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = true
L["Crit Rating Summary"] = true
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = true
L["Haste Rating Summary"] = true
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = true
L["Spell Hit Rating Summary"] = true
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = true
L["Spell Crit Rating Summary"] = true
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = true
L["Spell Haste Rating Summary"] = true
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = true
L["Dodge Rating Summary"] = true
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = true
L["Parry Rating Summary"] = true
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = true
L["Block Rating Summary"] = true
-- /rb sum statcomp res
L["Sum Resilience"] = true
L["Resilience Summary"] = true
-- /rb sum statcomp def
L["Sum Defense"] = true
L["Defense <- Defense Rating"] = true
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = true
L["Weapon Skill <- Weapon Skill Rating"] = true
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = true
L["Expertise <- Expertise Rating"] = true
-- /rb sum statcomp avoid
L["Sum Avoidance"] = true
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = true
-- /rb sum gem
L["Gems"] = true
L["Auto fill empty gem slots"] = true
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = true
L["<ItemID|Link>"] = true
L["%s is now set to %s"] = true
L["Queried server for Gem: %s. Try again in 5 secs."] = true
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = true
L["ItemID: "] = true

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = true
L["$class Self Buffs"] = true -- $class will be replaced with localized player class
L["Raid Buffs"] = true

-----------------------
-- Matching Patterns --
-----------------------
-- Items to check --
--------------------
-- [Potent Ornate Topaz]
-- +6 Spell Damage, +5 Spell Crit Rating
--------------------
-- ZG enchant
-- +10 Defense Rating/+10 Stamina/+15 Block Value
--------------------
-- [Glinting Flam Spessarite]
-- +3 Hit Rating and +3 Agility
--------------------
-- ItemID: 22589
-- [Atiesh, Greatstaff of the Guardian] warlock version
-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
--------------------
-- [Brilliant Wizard Oil]
-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes.
----------------------------------------------------------------------------------------------------
-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
--
-- The first pass searches for the rating number, the patterns are read from ["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from ["statList"] here,
-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike",
-- this way "spell critical strike" does get matched by "critical strike".
-- Strings need to be in lower case letters, because string.lower is called on lookup
--
-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file,
-- but will need to go in game and find out what needs to be put in here.
-- For example, in english I found 3 different strings that maps to StatLogic.Stats.MeleeCritRating: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents StatLogic.Stats.MeleeCritRating, and so on.
-- In other languages there may be 5 different strings that should all map to StatLogic.Stats.MeleeCritRating.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = " by (%d+)%f[^%d%%]", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)%f[^%d%%]", addInfo = "AfterStat",},
	{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "add.-(%d+)[^%%]?$", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	{pattern = "chest, legs, hands or feet by (%d+)"},
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
	["head, chest, shoulders, legs,"] = "head chest shoulders legs", -- Borean Armor Kit
	["chest, legs,"] = "chest legs", -- Vindicator's Armor Kit
}
L["separators"] = {
	"/", " and ", ",", "%. ", " for ", "&", ":", "\n"
}
--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = "lowers intellect of target", id = nil}, -- Brain Hacker
	{pattern = "reduces an enemy's armor", id = nil}, -- Annihilator

	{pattern = SPELL_STAT1_NAME:lower(), id = StatLogic.Stats.Strength}, -- Strength
	{pattern = SPELL_STAT2_NAME:lower(), id = StatLogic.Stats.Agility}, -- Agility
	{pattern = SPELL_STAT3_NAME:lower(), id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = SPELL_STAT4_NAME:lower(), id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = SPELL_STAT5_NAME:lower(), id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "defense rating", id = StatLogic.Stats.DefenseRating},
	{pattern = "dodge rating", id = StatLogic.Stats.DodgeRating},
	{pattern = "increases dodge", id = StatLogic.Stats.DodgeRating},
	{pattern = "block rating", id = StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "parry rating", id = StatLogic.Stats.ParryRating},

	{pattern = "spell power", id = nil}, -- Shiffar's Nexus-Horn
	{pattern = "spell critical strikes", id = nil}, -- Cyclone Regalia, Tirisfal Regalia
	{pattern = "spell critical strike rating", id = StatLogic.Stats.SpellCritRating},
	{pattern = "spell critical hit rating", id = StatLogic.Stats.SpellCritRating},
	{pattern = "spell critical rating", id = StatLogic.Stats.SpellCritRating},
	{pattern = "spell crit rating", id = StatLogic.Stats.SpellCritRating},
	{pattern = "spell critical", id = StatLogic.Stats.SpellCritRating},
	{pattern = "attack power", id = ATTACK_POWER},
	{pattern = "ranged critical strike", id = StatLogic.Stats.RangedCritRating},
	{pattern = "ranged critical hit rating", id = StatLogic.Stats.RangedCritRating},
	{pattern = "ranged critical rating", id = StatLogic.Stats.RangedCritRating},
	{pattern = "ranged crit rating", id = StatLogic.Stats.RangedCritRating},
	{pattern = "critical strike rating", id = StatLogic.Stats.CritRating},
	{pattern = "critical hit rating", id = StatLogic.Stats.CritRating},
	{pattern = "critical rating", id = StatLogic.Stats.CritRating},
	{pattern = "crit rating", id = StatLogic.Stats.CritRating},

	{pattern = "spell hit rating", id = StatLogic.Stats.SpellHitRating},
	{pattern = "ranged hit rating", id = StatLogic.Stats.RangedHitRating},
	{pattern = "hit rating", id = StatLogic.Stats.HitRating},

	{pattern = "resilience", id = StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{pattern = "spell haste rating", id = StatLogic.Stats.SpellHasteRating},
	{pattern = "ranged haste rating", id = StatLogic.Stats.RangedHasteRating},
	{pattern = "haste rating", id = StatLogic.Stats.HasteRating},

	{pattern = "expertise rating", id = StatLogic.Stats.ExpertiseRating},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.Stats.AllStats},
	{pattern = "health", id = nil}, -- Scroll of Enchant Chest - Health (prevents matching Armor)

	{pattern = "armor penetration", id = StatLogic.Stats.ArmorPenetrationRating},
	{pattern = ARMOR:lower(), id = ARMOR},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = true
L["$value% Spell Crit"] = true
L["$value% Dodge"] = true
L["$value HP"] = true
L["$value MP"] = true
L["$value AP"] = true
L["$value RAP"] = true
L["$value Spell Dmg"] = true
L["$value Heal"] = true
L["$value Armor"] = true
L["$value Block"] = true
L["$value MP5"] = true
L["$value MP5(NC)"] = true
L["$value HP5"] = true
L["$value HP5(NC)"] = true
L["$value to be Dodged/Parried"] = true
L["$value to be Crit"] = true
L["$value Crit Dmg Taken"] = true
L["$value DOT Dmg Taken"] = true
L["$value Dmg Taken"] = true
L["$value% Parry"] = true
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = true

L["EMPTY_SOCKET_RED"] = EMPTY_SOCKET_RED -- EMPTY_SOCKET_RED = "Red Socket";
L["EMPTY_SOCKET_YELLOW"] = EMPTY_SOCKET_YELLOW -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
L["EMPTY_SOCKET_BLUE"] = EMPTY_SOCKET_BLUE -- EMPTY_SOCKET_BLUE = "Blue Socket";
L["EMPTY_SOCKET_META"] = EMPTY_SOCKET_META -- EMPTY_SOCKET_META = "Meta Socket";

L["HEALING"] = STAT_SPELLHEALING
L["SPELL_CRIT"] = PLAYERSTAT_SPELL_COMBAT .. " " .. SPELL_CRIT_CHANCE
L["STR"] = SPELL_STAT1_NAME
L["AGI"] = SPELL_STAT2_NAME
L["STA"] = SPELL_STAT3_NAME
L["INT"] = SPELL_STAT4_NAME
L["SPI"] = SPELL_STAT5_NAME
L["PARRY"] = PARRY
L["MANA_REG"] = "Mana Regen"
L["NORMAL_MANA_REG"] = "Mana Regen (Not Casting)"
L["HEALTH_REG"] = "Health Regen"
L["NORMAL_HEALTH_REG"] = "Health Regen (Out of Combat)"
L["PET_STA"] = PET .. SPELL_STAT3_NAME -- Pet Stamina
L["PET_INT"] = PET .. SPELL_STAT4_NAME -- Pet Intellect
L["StatModOptionName"] = "%s %s"

L["IGNORE_ARMOR"] = "Ignore Armor"
L["MELEE_DMG"] = "Melee Weapon "..DAMAGE -- DAMAGE = "Damage"

L[StatLogic.Stats.Strength] = SPELL_STAT1_NAME
L[StatLogic.Stats.Agility] = SPELL_STAT2_NAME
L[StatLogic.Stats.Stamina] = SPELL_STAT3_NAME
L[StatLogic.Stats.Intellect] = SPELL_STAT4_NAME
L[StatLogic.Stats.Spirit] = SPELL_STAT5_NAME
L["ARMOR"] = ARMOR

L["FIRE_RES"] = RESISTANCE2_NAME
L["NATURE_RES"] = RESISTANCE3_NAME
L["FROST_RES"] = RESISTANCE4_NAME
L["SHADOW_RES"] = RESISTANCE5_NAME
L["ARCANE_RES"] = RESISTANCE6_NAME

L["BLOCK_VALUE"] = "Block Value"

L["AP"] = ATTACK_POWER_TOOLTIP
L["RANGED_AP"] = RANGED_ATTACK_POWER
L["FERAL_AP"] = "Feral "..ATTACK_POWER_TOOLTIP

L["HEAL"] = "Healing"

L["SPELL_DMG"] = STAT_SPELLDAMAGE
L["HOLY_SPELL_DMG"] = SPELL_SCHOOL1_CAP.." "..DAMAGE
L["FIRE_SPELL_DMG"] = SPELL_SCHOOL2_CAP.." "..DAMAGE
L["NATURE_SPELL_DMG"] = SPELL_SCHOOL3_CAP.." "..DAMAGE
L["FROST_SPELL_DMG"] = SPELL_SCHOOL4_CAP.." "..DAMAGE
L["SHADOW_SPELL_DMG"] = SPELL_SCHOOL5_CAP.." "..DAMAGE
L["ARCANE_SPELL_DMG"] = SPELL_SCHOOL6_CAP.." "..DAMAGE

L["SPELLPEN"] = PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION

L["HEALTH"] = HEALTH
L["MANA"] = MANA

L["AVERAGE_DAMAGE"] = "Average Damage"
L["DPS"] = "Damage Per Second"

L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2 -- COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.DodgeRating] = COMBAT_RATING_NAME3 -- COMBAT_RATING_NAME3 = "Dodge Rating"
L[StatLogic.Stats.ParryRating] = COMBAT_RATING_NAME4 -- COMBAT_RATING_NAME4 = "Parry Rating"
L[StatLogic.Stats.BlockRating] = COMBAT_RATING_NAME5 -- COMBAT_RATING_NAME5 = "Block Rating"
L[StatLogic.Stats.MeleeHitRating] = COMBAT_RATING_NAME6 -- COMBAT_RATING_NAME6 = "Hit Rating"
L[StatLogic.Stats.RangedHitRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
L[StatLogic.Stats.SpellHitRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_SPELL_COMBAT = "Spell"
L[StatLogic.Stats.MeleeCritRating] = COMBAT_RATING_NAME9 -- COMBAT_RATING_NAME9 = "Crit Rating"
L[StatLogic.Stats.RangedCritRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.SpellCritRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.ResilienceRating] = COMBAT_RATING_NAME15 -- COMBAT_RATING_NAME15 = "Resilience"
L[StatLogic.Stats.MeleeHasteRating] = "Haste "..RATING --
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING
L[StatLogic.Stats.SpellHasteRating] = PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING
L[StatLogic.Stats.ExpertiseRating] = "Expertise".." "..RATING
L[StatLogic.Stats.ArmorPenetrationRating] = ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
L["MELEE_CRIT_DMG_REDUCTION"] = "Crit Damage Reduction(%)"
L[StatLogic.Stats.Defense] = DEFENSE
L[StatLogic.Stats.Dodge] = DODGE.."(%)"
L[StatLogic.Stats.Parry] = PARRY.."(%)"
L[StatLogic.Stats.BlockChance] = BLOCK.."(%)"
L["AVOIDANCE"] = "Avoidance(%)"
L["MELEE_HIT"] = "Hit Chance(%)"
L["RANGED_HIT"] = PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)"
L["SPELL_HIT"] = PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)"
L[StatLogic.Stats.Miss] = "Hit Avoidance(%)"
L[StatLogic.Stats.MeleeCrit] = MELEE_CRIT_CHANCE.."(%)" -- MELEE_CRIT_CHANCE = "Crit Chance"
L[StatLogic.Stats.RangedCrit] = PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.SpellCrit] = PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L["MELEE_CRIT_AVOID"] = "Crit Avoidance(%)"
L["MELEE_HASTE"] = "Haste(%)" --
L["RANGED_HASTE"] = PLAYERSTAT_RANGED_COMBAT.." Haste(%)"
L["SPELL_HASTE"] = PLAYERSTAT_SPELL_COMBAT.." Haste(%)"
L["EXPERTISE"] = "Expertise"
L["ARMOR_PENETRATION"] = "Armor Penetration(%)"
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
-- Expertise -> Dodge Neglect, Parry Neglect
L["DODGE_NEGLECT"] = DODGE.." Neglect(%)"
L["PARRY_NEGLECT"] = PARRY.." Neglect(%)"
L["BLOCK_NEGLECT"] = BLOCK.." Neglect(%)"
-- Misc Stats
L["WEAPON_SKILL"] = "Weapon "..SKILL