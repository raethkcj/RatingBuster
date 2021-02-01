--[[
Name: RatingBuster enUS locale
Revision: $Revision: 73696 $
Translated by: 
- Whitetooth (hotdogee [at] gmail [dot] com)
]]

local L = AceLibrary("AceLocale-2.2"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("enUS", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = true,
	["Waterfall-1.0 is required to access the GUI."] = true,
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb win
	["Options Window"] = true,
	["Shows the Options Window"] = true,
	-- /rb statmod
	["Enable Stat Mods"] = true,
	["Enable support for Stat Mods"] = true,
	-- /rb itemid
	["Show ItemID"] = true,
	["Show the ItemID in tooltips"] = true,
	-- /rb itemlevel
	["Show ItemLevel"] = true,
	["Show the ItemLevel in tooltips"] = true,
	-- /rb usereqlv
	["Use required level"] = true,
	["Calculate using the required level if you are below the required level"] = true,
	-- /rb setlevel
	["Set level"] = true,
	["Set the level used in calculations (0 = your level)"] = true,
	-- /rb color
	["Change text color"] = true,
	["Changes the color of added text"] = true,
	-- /rb color pick
	["Pick color"] = true,
	["Pick a color"] = true,
	-- /rb color enable
	["Enable color"] = true,
	["Enable colored text"] = true,
	-- /rb rating
	["Rating"] = true,
	["Options for Rating display"] = true,
	-- /rb rating show
	["Show Rating conversions"] = true,
	["Show Rating conversions in tooltips"] = true,
	-- /rb rating detail
	["Show detailed conversions text"] = true,
	["Show detailed text for Resiliance and Expertise conversions"] = true,
	-- /rb rating def
	["Defense breakdown"] = true,
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = true,
	-- /rb rating wpn
	["Weapon Skill breakdown"] = true,
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = true,
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = true,
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = true,
	
	-- /rb stat
	["Stat Breakdown"] = true,
	["Changes the display of base stats"] = true,
	-- /rb stat show
	["Show base stat conversions"] = true,
	["Show base stat conversions in tooltips"] = true,
	-- /rb stat str
	["Strength"] = true,
	["Changes the display of Strength"] = true,
	-- /rb stat str ap
	["Show Attack Power"] = true,
	["Show Attack Power from Strength"] = true,
	-- /rb stat str block
	["Show Block Value"] = true,
	["Show Block Value from Strength"] = true,
	-- /rb stat str dmg
	["Show Spell Damage"] = true,
	["Show Spell Damage from Strength"] = true,
	-- /rb stat str heal
	["Show Healing"] = true,
	["Show Healing from Strength"] = true,
	
	-- /rb stat agi
	["Agility"] = true,
	["Changes the display of Agility"] = true,
	-- /rb stat agi crit
	["Show Crit"] = true,
	["Show Crit chance from Agility"] = true,
	-- /rb stat agi dodge
	["Show Dodge"] = true,
	["Show Dodge chance from Agility"] = true,
	-- /rb stat agi ap
	["Show Attack Power"] = true,
	["Show Attack Power from Agility"] = true,
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = true,
	["Show Ranged Attack Power from Agility"] = true,
	-- /rb stat agi armor
	["Show Armor"] = true,
	["Show Armor from Agility"] = true,
	-- /rb stat agi heal
	["Show Healing"] = true,
	["Show Healing from Agility"] = true,
	
	-- /rb stat sta
	["Stamina"] = true,
	["Changes the display of Stamina"] = true,
	-- /rb stat sta hp
	["Show Health"] = true,
	["Show Health from Stamina"] = true,
	-- /rb stat sta dmg
	["Show Spell Damage"] = true,
	["Show Spell Damage from Stamina"] = true,
	
	-- /rb stat int
	["Intellect"] = true,
	["Changes the display of Intellect"] = true,
	-- /rb stat int spellcrit
	["Show Spell Crit"] = true,
	["Show Spell Crit chance from Intellect"] = true,
	-- /rb stat int mp
	["Show Mana"] = true,
	["Show Mana from Intellect"] = true,
	-- /rb stat int dmg
	["Show Spell Damage"] = true,
	["Show Spell Damage from Intellect"] = true,
	-- /rb stat int heal
	["Show Healing"] = true,
	["Show Healing from Intellect"] = true,
	-- /rb stat int mp5
	["Show Mana Regen"] = true,
	["Show Mana Regen while casting from Intellect"] = true,
	-- /rb stat int mp5nc
	["Show Mana Regen while NOT casting"] = true,
	["Show Mana Regen while NOT casting from Intellect"] = true,
	-- /rb stat int rap
	["Show Ranged Attack Power"] = true,
	["Show Ranged Attack Power from Intellect"] = true,
	-- /rb stat int armor
	["Show Armor"] = true,
	["Show Armor from Intellect"] = true,
	
	-- /rb stat spi
	["Spirit"] = true,
	["Changes the display of Spirit"] = true,
	-- /rb stat spi mp5
	["Show Mana Regen"] = true,
	["Show Mana Regen while casting from Spirit"] = true,
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = true,
	["Show Mana Regen while NOT casting from Spirit"] = true,
	-- /rb stat spi hp5
	["Show Health Regen"] = true,
	["Show Health Regen from Spirit"] = true,
	-- /rb stat spi dmg
	["Show Spell Damage"] = true,
	["Show Spell Damage from Spirit"] = true,
	-- /rb stat spi heal
	["Show Healing"] = true,
	["Show Healing from Spirit"] = true,
	
	-- /rb sum
	["Stat Summary"] = true,
	["Options for stat summary"] = true,
	-- /rb sum show
	["Show stat summary"] = true,
	["Show stat summary in tooltips"] = true,
	-- /rb sum ignore
	["Ignore settings"] = true,
	["Ignore stuff when calculating the stat summary"] = true,
	-- /rb sum ignore unused
	["Ignore unused items types"] = true,
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = true,
	-- /rb sum ignore equipped
	["Ignore equipped items"] = true,
	["Hide stat summary for equipped items"] = true,
	-- /rb sum ignore enchant
	["Ignore enchants"] = true,
	["Ignore enchants on items when calculating the stat summary"] = true,
	-- /rb sum ignore gem
	["Ignore gems"] = true,
	["Ignore gems on items when calculating the stat summary"] = true,
	-- /rb sum diffstyle
	["Display style for diff value"] = true,
	["Display diff values in the main tooltip or only in compare tooltips"] = true,
	-- /rb sum space
	["Add empty line"] = true,
	["Add a empty line before or after stat summary"] = true,
	-- /rb sum space before
	["Add before summary"] = true,
	["Add a empty line before stat summary"] = true,
	-- /rb sum space after
	["Add after summary"] = true,
	["Add a empty line after stat summary"] = true,
	-- /rb sum icon
	["Show icon"] = true,
	["Show the sigma icon before summary listing"] = true,
	-- /rb sum title
	["Show title text"] = true,
	["Show the title text before summary listing"] = true,
	-- /rb sum showzerostat
	["Show zero value stats"] = true,
	["Show zero value stats in summary for consistancy"] = true,
	-- /rb sum calcsum
	["Calculate stat sum"] = true,
	["Calculate the total stats for the item"] = true,
	-- /rb sum calcdiff
	["Calculate stat diff"] = true,
	["Calculate the stat difference for the item and equipped items"] = true,
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = true,
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = true,
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = true,
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = true,
	-- /rb sum basic
	["Stat - Basic"] = true,
	["Choose basic stats for summary"] = true,
	-- /rb sum physical
	["Stat - Physical"] = true,
	["Choose physical damage stats for summary"] = true,
	-- /rb sum spell
	["Stat - Spell"] = true,
	["Choose spell damage and healing stats for summary"] = true,
	-- /rb sum tank
	["Stat - Tank"] = true,
	["Choose tank stats for summary"] = true,
	-- /rb sum stat hp
	["Sum Health"] = true,
	["Health <- Health, Stamina"] = true,
	-- /rb sum stat mp
	["Sum Mana"] = true,
	["Mana <- Mana, Intellect"] = true,
	-- /rb sum stat ap
	["Sum Attack Power"] = true,
	["Attack Power <- Attack Power, Strength, Agility"] = true,
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = true,
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = true,
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = true,
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = true,
	-- /rb sum stat dmg
	["Sum Spell Damage"] = true,
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = true,
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = true,
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = true,
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = true,
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = true,
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = true,
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = true,
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = true,
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = true,
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = true,
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = true,
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = true,
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = true,
	-- /rb sum stat heal
	["Sum Healing"] = true,
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = true,
	-- /rb sum stat hit
	["Sum Hit Chance"] = true,
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = true,
	-- /rb sum stat crit
	["Sum Crit Chance"] = true,
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = true,
	-- /rb sum stat haste
	["Sum Haste"] = true,
	["Haste <- Haste Rating"] = true,
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = true,
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = true,
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = true,
	["Spell Hit Chance <- Spell Hit Rating"] = true,
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = true,
	["Spell Haste <- Spell Haste Rating"] = true,
	-- /rb sum stat mp5
	["Sum Mana Regen"] = true,
	["Mana Regen <- Mana Regen, Spirit"] = true,
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = true,
	["Mana Regen while not casting <- Spirit"] = true,
	-- /rb sum stat hp5
	["Sum Health Regen"] = true,
	["Health Regen <- Health Regen"] = true,
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = true,
	["Health Regen when out of combat <- Spirit"] = true,
	-- /rb sum stat armor
	["Sum Armor"] = true,
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = true,
	-- /rb sum stat blockvalue
	["Sum Block Value"] = true,
	["Block Value <- Block Value, Strength"] = true,
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = true,
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = true,
	-- /rb sum stat parry
	["Sum Parry Chance"] = true,
	["Parry Chance <- Parry Rating, Defense Rating"] = true,
	-- /rb sum stat block
	["Sum Block Chance"] = true,
	["Block Chance <- Block Rating, Defense Rating"] = true,
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = true,
	["Hit Avoidance <- Defense Rating"] = true,
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = true,
	["Crit Avoidance <- Defense Rating, Resilience"] = true,
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = true,
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = true, -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = true,
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = true, -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = true,
	["Block Neglect <- Weapon Skill Rating"] = true,
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = true,
	["Arcane Resistance Summary"] = true,
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = true,
	["Fire Resistance Summary"] = true,
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = true,
	["Nature Resistance Summary"] = true,
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = true,
	["Frost Resistance Summary"] = true,
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = true,
	["Shadow Resistance Summary"] = true,
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = true,
	["Weapon Max Damage Summary"] = true,
	-- /rb sum stat pen
	["Sum Penetration"] = true,
	["Spell Penetration Summary"] = true,
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = true,
	["Ignore Armor Summary"] = true,
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp str
	["Sum Strength"] = true,
	["Strength Summary"] = true,
	-- /rb sum statcomp agi
	["Sum Agility"] = true,
	["Agility Summary"] = true,
	-- /rb sum statcomp sta
	["Sum Stamina"] = true,
	["Stamina Summary"] = true,
	-- /rb sum statcomp int
	["Sum Intellect"] = true,
	["Intellect Summary"] = true,
	-- /rb sum statcomp spi
	["Sum Spirit"] = true,
	["Spirit Summary"] = true,
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = true,
	["Hit Rating Summary"] = true,
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = true,
	["Crit Rating Summary"] = true,
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = true,
	["Haste Rating Summary"] = true,
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = true,
	["Spell Hit Rating Summary"] = true,
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = true,
	["Spell Crit Rating Summary"] = true,
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = true,
	["Spell Haste Rating Summary"] = true,
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = true,
	["Dodge Rating Summary"] = true,
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = true,
	["Parry Rating Summary"] = true,
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = true,
	["Block Rating Summary"] = true,
	-- /rb sum statcomp res
	["Sum Resilience"] = true,
	["Resilience Summary"] = true,
	-- /rb sum statcomp def
	["Sum Defense"] = true,
	["Defense <- Defense Rating"] = true,
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = true,
	["Weapon Skill <- Weapon Skill Rating"] = true,
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = true,
	["Expertise <- Expertise Rating"] = true,
	-- /rb sum statcomp tp
	["Sum TankPoints"] = true,
	["TankPoints <- Health, Total Reduction"] = true,
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = true,
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = true,
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = true,
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = true,
	-- /rb sum gem
	["Gems"] = true,
	["Auto fill empty gem slots"] = true,
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = true,
	["<ItemID|Link>"] = true,
	["%s is now set to %s"] = true,
	["Queried server for Gem: %s. Try again in 5 secs."] = true,
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,

	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = true,
	["ItemID: "] = true,
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
	["numberPatterns"] = {
		{pattern = " by (%d+)", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
		{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
		-- Added [^|] so that it doesn't match enchant strings (JewelTips)
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	},
	["separators"] = {
		"/", " and ", ",", "%. ", " for ", "&", ":"
	},
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
	["statList"] = {
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
	},
	-------------------------
	-- Added info patterns --
	-------------------------
	-- $value will be replaced with the number
	-- EX: "$value% Crit" -> "+1.34% Crit"
	-- EX: "Crit $value%" -> "Crit +1.34%"
	["$value% Crit"] = true,
	["$value% Spell Crit"] = true,
	["$value% Dodge"] = true,
	["$value HP"] = true,
	["$value MP"] = true,
	["$value AP"] = true,
	["$value RAP"] = true,
	["$value Dmg"] = true,
	["$value Heal"] = true,
	["$value Armor"] = true,
	["$value Block"] = true,
	["$value MP5"] = true,
	["$value MP5(NC)"] = true,
	["$value HP5"] = true,
	["$value to be Dodged/Parried"] = true,
	["$value to be Crit"] = true,
	["$value Crit Dmg Taken"] = true,
	["$value DOT Dmg Taken"] = true,
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = true,
} end)