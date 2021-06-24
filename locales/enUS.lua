--[[
Name: RatingBuster enUS locale
Revision: $Revision: 73696 $
Translated by: 
- Whitetooth (hotdogee [at] gmail [dot] com)
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "enUS", true)
L["RatingBuster Options"] = true
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
-- /rb color pick
L["Pick color"] = true
L["Pick a color"] = true
-- /rb color enable
L["Enable color"] = true
L["Enable colored text"] = true
-- /rb rating
L["Rating"] = true
L["Options for Rating display"] = true
-- /rb rating show
L["Show Rating conversions"] = true
L["Show Rating conversions in tooltips"] = true
-- /rb rating detail
L["Show detailed conversions text"] = true
L["Show detailed text for Resiliance and Expertise conversions"] = true
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
-- /rb stat str ap
L["Show Attack Power"] = true
L["Show Attack Power from Strength"] = true
-- /rb stat str block
L["Show Block Value"] = true
L["Show Block Value from Strength"] = true
-- /rb stat str dmg
L["Show Spell Damage"] = true
L["Show Spell Damage from Strength"] = true
-- /rb stat str heal
L["Show Healing"] = true
L["Show Healing from Strength"] = true

-- /rb stat agi
L["Agility"] = true
L["Changes the display of Agility"] = true
-- /rb stat agi crit
L["Show Crit"] = true
L["Show Crit chance from Agility"] = true
-- /rb stat agi dodge
L["Show Dodge"] = true
L["Show Dodge chance from Agility"] = true
-- /rb stat agi ap
L["Show Attack Power"] = true
L["Show Attack Power from Agility"] = true
-- /rb stat agi rap
L["Show Ranged Attack Power"] = true
L["Show Ranged Attack Power from Agility"] = true
-- /rb stat agi armor
L["Show Armor"] = true
L["Show Armor from Agility"] = true
-- /rb stat agi heal
L["Show Healing"] = true
L["Show Healing from Agility"] = true

-- /rb stat sta
L["Stamina"] = true
L["Changes the display of Stamina"] = true
-- /rb stat sta hp
L["Show Health"] = true
L["Show Health from Stamina"] = true
-- /rb stat sta dmg
L["Show Spell Damage"] = true
L["Show Spell Damage from Stamina"] = true

-- /rb stat int
L["Intellect"] = true
L["Changes the display of Intellect"] = true
-- /rb stat int spellcrit
L["Show Spell Crit"] = true
L["Show Spell Crit chance from Intellect"] = true
-- /rb stat int mp
L["Show Mana"] = true
L["Show Mana from Intellect"] = true
-- /rb stat int dmg
L["Show Spell Damage"] = true
L["Show Spell Damage from Intellect"] = true
-- /rb stat int heal
L["Show Healing"] = true
L["Show Healing from Intellect"] = true
-- /rb stat int mp5
L["Show Mana Regen"] = true
L["Show Mana Regen while casting from Intellect"] = true
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = true
L["Show Mana Regen while NOT casting from Intellect"] = true
-- /rb stat int rap
L["Show Ranged Attack Power"] = true
L["Show Ranged Attack Power from Intellect"] = true
-- /rb stat int armor
L["Show Armor"] = true
L["Show Armor from Intellect"] = true

-- /rb stat spi
L["Spirit"] = true
L["Changes the display of Spirit"] = true
-- /rb stat spi mp5
L["Show Mana Regen"] = true
L["Show Mana Regen while casting from Spirit"] = true
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = true
L["Show Mana Regen while NOT casting from Spirit"] = true
-- /rb stat spi hp5
L["Show Health Regen"] = true
L["Show Health Regen from Spirit"] = true
-- /rb stat spi dmg
L["Show Spell Damage"] = true
L["Show Spell Damage from Spirit"] = true
-- /rb stat spi heal
L["Show Healing"] = true
L["Show Healing from Spirit"] = true

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
L["Ignore unused items types"] = true
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
-- /rb sum diffstyle
L["Display style for diff value"] = true
L["Display diff values in the main tooltip or only in compare tooltips"] = true
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
-- /rb sum stat fap
L["Sum Feral Attack Power"] = true
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = true
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
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = true
L["Weapon Max Damage Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = true
L["Spell Penetration Summary"] = true
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = true
L["Ignore Armor Summary"] = true
-- /rb sum stat weapondps
--["Sum Weapon DPS"] = true,
--["Weapon DPS Summary"] = true,
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
-- /rb sum statcomp tp
L["Sum TankPoints"] = true
L["TankPoints <- Health, Total Reduction"] = true
-- /rb sum statcomp tr
L["Sum Total Reduction"] = true
L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = true
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
-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = " by (%d+)", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " and ", ",", "%. ", " for ", "&", ":"
}
--[[ Rating ID
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
--
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "defense rating", id = CR_DEFENSE_SKILL},
	{pattern = "dodge rating", id = CR_DODGE},
	{pattern = "block rating", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "parry rating", id = CR_PARRY},

	{pattern = "spell critical strike rating", id = CR_CRIT_SPELL},
	{pattern = "spell critical hit rating", id = CR_CRIT_SPELL},
	{pattern = "spell critical rating", id = CR_CRIT_SPELL},
	{pattern = "spell crit rating", id = CR_CRIT_SPELL},
	{pattern = "spell critical", id = CR_CRIT_SPELL},
	{pattern = "ranged critical strike rating", id = CR_CRIT_RANGED},
	{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
	{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
	{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
	{pattern = "critical strike rating", id = CR_CRIT_MELEE},
	{pattern = "critical hit rating", id = CR_CRIT_MELEE},
	{pattern = "critical rating", id = CR_CRIT_MELEE},
	{pattern = "crit rating", id = CR_CRIT_MELEE},

	{pattern = "spell hit rating", id = CR_HIT_SPELL},
	{pattern = "ranged hit rating", id = CR_HIT_RANGED},
	{pattern = "hit rating", id = CR_HIT_MELEE},

	{pattern = "resilience", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "spell haste rating", id = CR_HASTE_SPELL},
	{pattern = "ranged haste rating", id = CR_HASTE_RANGED},
	{pattern = "haste rating", id = CR_HASTE_MELEE},
	{pattern = "speed rating", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	{pattern = "skill rating", id = CR_WEAPON_SKILL},
	{pattern = "expertise rating", id = CR_EXPERTISE},

	{pattern = "hit avoidance rating", id = CR_HIT_TAKEN_MELEE},
	--[[
	{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
	{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
	{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
	{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
	{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
	{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
	{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
	{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
	{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
	--]]
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
L["$value Dmg"] = true
L["$value Heal"] = true
L["$value Armor"] = true
L["$value Block"] = true
L["$value MP5"] = true
L["$value MP5(NC)"] = true
L["$value HP5"] = true
L["$value to be Dodged/Parried"] = true
L["$value to be Crit"] = true
L["$value Crit Dmg Taken"] = true
L["$value DOT Dmg Taken"] = true

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = true