--[[
Name: RatingBuster enUS locale
Revision: $Revision: 73696 $
Translated by:
- Whitetooth (hotdogee [at] gmail [dot] com)
]]

local _, addon = ...
addon.tocversion = select(4, GetBuildInfo())

---@class RatingBusterLocale
---@field numberPatterns table
---@field exclusions table
---@field separators table
---@field statList { [1]: string, [2]: Stat|false }[]
---@field [string] string

---@class RatingBusterDefaultLocale : RatingBusterLocale
---@field [string] string|true

---@type RatingBusterDefaultLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "enUS", true)
addon.S = {}
local S = addon.S
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
L["Enable integration with Blizzard Reforging UI"] = true
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
L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = true
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = true
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = true

-- /rb stat
L["Stat Breakdown"] = true
L["Changes the display of base stats"] = true
-- /rb stat show
L["Show base stat conversions"] = true
L["Show base stat conversions in tooltips"] = true
L["Changes the display of %s"] = true
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = true
L["Options for stat summary"] = true
L["Sum %s"] = true
-- /rb sum show
L["Show stat summary"] = true
L["Show stat summary in tooltips"] = true
-- /rb sum ignore
L["Ignore settings"] = true
L["Ignore stuff when calculating the stat summary"] = true
-- /rb sum ignore unused
L["Ignore unused item types"] = true
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = true
L["Ignore non-primary stat"] = true
L["Show stat summary only for items with your specialization's primary stat"] = true
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
L["Show the sigma icon before stat summary"] = true
-- /rb sum title
L["Show title text"] = true
L["Show the title text before stat summary"] = true
L["Show profile name"] = true
L["Show profile name before stat summary"] = true
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
L["Health <- Health, Stamina"] = true
-- /rb sum stat mp
L["Mana <- Mana, Intellect"] = true
-- /rb sum stat ap
L["Attack Power <- Attack Power, Strength, Agility"] = true
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = true
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = true
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = true
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = true
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = true
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = true
-- /rb sum stat heal
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = true
-- /rb sum stat hit
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = true
-- /rb sum stat crit
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = true
-- /rb sum stat haste
L["Haste <- Haste Rating"] = true
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = true
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = true
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = true

-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = true
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = true
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = true
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen, Spirit"] = true
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = true
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = true
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = true
-- /rb sum stat armor
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = true
-- /rb sum stat blockvalue
L["Block Value <- Block Value, Strength"] = true
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = true
-- /rb sum stat parry
L["Parry Chance <- Parry Rating, Defense Rating"] = true
-- /rb sum stat block
L["Block Chance <- Block Rating, Defense Rating"] = true
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = true
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating, Resilience"] = true
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise, Weapon Skill Rating"] = true -- 2.3.0
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise, Weapon Skill Rating"] = true -- 2.3.0

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = true
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = true
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = true
-- /rb sum statcomp avoid
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = true
-- /rb sum gem
L["Gems"] = true
L["Auto fill empty gem slots"] = true
L["ItemID or Link of the gem you would like to auto fill"] = true
L["<ItemID|Link>"] = true
L["%s is now set to %s"] = true
L["Queried server for Gem: %s. Try again in 5 secs."] = true

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
L["Stat Multiplier"] = true
L["Attack Power Multiplier"] = true
L["Reduced Physical Damage Taken"] = true

L["Swap Profiles"] = true
L["Swap Profile Keybinding"] = true
L["Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."] = true
L["Primary Profile"] = true
L["Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."] = true
L["Secondary Profile"] = true
L["Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."] = true

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
addon.numberPattern = "([%+%-]?[%d" .. LARGE_NUMBER_SEPERATOR .. "]+)%f[^%w%%+]"
L["numberPatterns"] = {
	" by " .. addon.numberPattern,
	addon.numberPattern,
}

-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
	["head, chest, shoulders, legs,"] = "head chest shoulders legs", -- Borean Armor Kit
	["chest, legs,"] = "chest legs", -- Vindicator's Armor Kit
}
L["separators"] = {
	"/", " and ", ",%f[^%d]", "%. ", " for ", "&", ":", "\n"
}
--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{"lowers intellect of target", false}, -- Brain Hacker
	{"reduces an enemy's armor", false}, -- Annihilator

	{SPELL_STAT1_NAME:lower(), StatLogic.Stats.Strength}, -- Strength
	{SPELL_STAT2_NAME:lower(), StatLogic.Stats.Agility}, -- Agility
	{SPELL_STAT3_NAME:lower(), StatLogic.Stats.Stamina}, -- Stamina
	{SPELL_STAT4_NAME:lower(), StatLogic.Stats.Intellect}, -- Intellect
	{SPELL_STAT5_NAME:lower(), StatLogic.Stats.Spirit}, -- Spirit
	{"defense rating", StatLogic.Stats.DefenseRating},
	{DEFENSE:lower(), StatLogic.Stats.Defense},
	{"dodge rating", StatLogic.Stats.DodgeRating},
	{"increases dodge", StatLogic.Stats.DodgeRating},
	{"block rating", StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{"parry rating", StatLogic.Stats.ParryRating},

	{"spell power", false}, -- Shiffar's Nexus-Horn
	{"spell critical strikes", false}, -- Cyclone Regalia, Tirisfal Regalia
	{"spell critical strike rating", StatLogic.Stats.SpellCritRating},
	{"spell critical hit rating", StatLogic.Stats.SpellCritRating},
	{"spell critical rating", StatLogic.Stats.SpellCritRating},
	{"spell crit rating", StatLogic.Stats.SpellCritRating},
	{"spell critical", StatLogic.Stats.SpellCritRating},
	{"attack power", StatLogic.Stats.GenericAttackPower},
	{"ranged critical strike", StatLogic.Stats.RangedCritRating},
	{"ranged critical hit rating", StatLogic.Stats.RangedCritRating},
	{"ranged critical rating", StatLogic.Stats.RangedCritRating},
	{"ranged crit rating", StatLogic.Stats.RangedCritRating},
	{"critical strike rating", StatLogic.Stats.CritRating},
	{"critical hit rating", StatLogic.Stats.CritRating},
	{"critical rating", StatLogic.Stats.CritRating},
	{"crit rating", StatLogic.Stats.CritRating},

	{"spell hit rating", StatLogic.Stats.SpellHitRating},
	{"ranged hit rating", StatLogic.Stats.RangedHitRating},
	{"hit rating", StatLogic.Stats.HitRating},

	{"resilience", StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{"spell haste rating", StatLogic.Stats.SpellHasteRating},
	{"ranged haste rating", StatLogic.Stats.RangedHasteRating},
	{"haste rating", StatLogic.Stats.HasteRating},

	{"expertise rating", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},
	{"health", false}, -- Scroll of Enchant Chest - Health (prevents matching Armor)

	{"armor penetration", StatLogic.Stats.ArmorPenetrationRating},
	{"elemental mastery", false}, -- Frost Witch's Regalia
	{"mastery rating", StatLogic.Stats.MasteryRating},
	{"mastery", StatLogic.Stats.MasteryRating},
	{ARMOR:lower(), StatLogic.Stats.Armor},
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["Show %s"] = SHOW.." %s"
L["Show Modified %s"] = "Show Modified %s"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["Spell"] = "Spell"

-- Basic Attributes
L[StatLogic.Stats.Strength] = SPELL_STAT1_NAME
L[StatLogic.Stats.Agility] = SPELL_STAT2_NAME
L[StatLogic.Stats.Stamina] = SPELL_STAT3_NAME
L[StatLogic.Stats.Intellect] = SPELL_STAT4_NAME
L[StatLogic.Stats.Spirit] = SPELL_STAT5_NAME
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.MasteryRating] = STAT_MASTERY.." "..RATING

-- Resources
L[StatLogic.Stats.Health] = HEALTH
S[StatLogic.Stats.Health] = "HP"
L[StatLogic.Stats.Mana] = MANA
S[StatLogic.Stats.Mana] = "MP"
L[StatLogic.Stats.ManaRegen] = "Mana Regen"
S[StatLogic.Stats.ManaRegen] = "MP5"

local ManaRegenOutOfCombat = "Mana Regen (Out of Combat)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "Mana Regen (Not Casting)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "MP5(NC)"

L[StatLogic.Stats.HealthRegen] = "Health Regen"
S[StatLogic.Stats.HealthRegen] = "HP5"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Health Regen (Out of Combat)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "HP5(NC)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = ATTACK_POWER_TOOLTIP
S[StatLogic.Stats.AttackPower] = "AP"
L[StatLogic.Stats.FeralAttackPower] = "Feral "..ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.IgnoreArmor] = "Ignore Armor"
L[StatLogic.Stats.ArmorPenetration] = "Armor Penetration"
L[StatLogic.Stats.ArmorPenetrationRating] = ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "Average Damage"
L[StatLogic.Stats.WeaponDPS] = "Damage Per Second"

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = STAT_HIT_CHANCE
L[StatLogic.Stats.MeleeHitRating] = COMBAT_RATING_NAME6 -- COMBAT_RATING_NAME6 = "Hit Rating"
L[StatLogic.Stats.MeleeCrit] = MELEE_CRIT_CHANCE -- MELEE_CRIT_CHANCE = "Crit Chance"
S[StatLogic.Stats.MeleeCrit] = "Crit"
L[StatLogic.Stats.MeleeCritRating] = COMBAT_RATING_NAME9 -- COMBAT_RATING_NAME9 = "Crit Rating"
L[StatLogic.Stats.MeleeHaste] = STAT_HASTE
L[StatLogic.Stats.MeleeHasteRating] = STAT_HASTE.." "..RATING

L[StatLogic.Stats.WeaponSkill] = "Weapon "..SKILL
L[StatLogic.Stats.Expertise] = STAT_EXPERTISE
L[StatLogic.Stats.ExpertiseRating] = STAT_EXPERTISE.." "..RATING
L[StatLogic.Stats.DodgeReduction] = DODGE.." Reduction"
S[StatLogic.Stats.DodgeReduction] = "to be Dodged"
L[StatLogic.Stats.ParryReduction] = PARRY.." Reduction"
S[StatLogic.Stats.ParryReduction] = "to be Parried"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = RANGED_ATTACK_POWER
S[StatLogic.Stats.RangedAttackPower] = "RAP"
L[StatLogic.Stats.RangedHit] = PLAYERSTAT_RANGED_COMBAT.." "..STAT_HIT_CHANCE
L[StatLogic.Stats.RangedHitRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
L[StatLogic.Stats.RangedCrit] = PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE
L[StatLogic.Stats.RangedCritRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.RangedHaste] = PLAYERSTAT_RANGED_COMBAT.." "..STAT_HASTE
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." "..STAT_HASTE.." "..RATING

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = STAT_SPELLDAMAGE
S[StatLogic.Stats.SpellDamage] = "Spell Dmg"
L[StatLogic.Stats.HealingPower] = "Healing" -- STAT_SPELL_HEALING
S[StatLogic.Stats.HealingPower] = "Heal"
L[StatLogic.Stats.SpellPenetration] = PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION

L[StatLogic.Stats.HolyDamage] = SPELL_SCHOOL1_CAP.." "..DAMAGE
L[StatLogic.Stats.FireDamage] = SPELL_SCHOOL2_CAP.." "..DAMAGE
L[StatLogic.Stats.NatureDamage] = SPELL_SCHOOL3_CAP.." "..DAMAGE
L[StatLogic.Stats.FrostDamage] = SPELL_SCHOOL4_CAP.." "..DAMAGE
L[StatLogic.Stats.ShadowDamage] = SPELL_SCHOOL5_CAP.." "..DAMAGE
L[StatLogic.Stats.ArcaneDamage] = SPELL_SCHOOL6_CAP.." "..DAMAGE

L[StatLogic.Stats.SpellHit] = PLAYERSTAT_SPELL_COMBAT.." "..STAT_HIT_CHANCE
S[StatLogic.Stats.SpellHit] = "Spell Hit"
L[StatLogic.Stats.SpellHitRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_SPELL_COMBAT = "Spell"
L[StatLogic.Stats.SpellCrit] = PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE
S[StatLogic.Stats.SpellCrit] = "Spell Crit"
L[StatLogic.Stats.SpellCritRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.SpellHaste] = PLAYERSTAT_SPELL_COMBAT.." "..STAT_HASTE
L[StatLogic.Stats.SpellHasteRating] = PLAYERSTAT_SPELL_COMBAT.." "..STAT_HASTE.." "..RATING

-- Tank Stats
L[StatLogic.Stats.Armor] = ARMOR
S[StatLogic.Stats.Armor] = "Armor"

L[StatLogic.Stats.Avoidance] = STAT_AVOIDANCE
L[StatLogic.Stats.Dodge] = DODGE
S[StatLogic.Stats.Dodge] = "Dodge"
L[StatLogic.Stats.DodgeRating] = COMBAT_RATING_NAME3 -- COMBAT_RATING_NAME3 = "Dodge Rating"
L[StatLogic.Stats.Parry] = PARRY
S[StatLogic.Stats.Parry] = "Parry"
L[StatLogic.Stats.ParryRating] = COMBAT_RATING_NAME4 -- COMBAT_RATING_NAME4 = "Parry Rating"
L[StatLogic.Stats.BlockChance] = BLOCK_CHANCE
L[StatLogic.Stats.BlockRating] = COMBAT_RATING_NAME5 -- COMBAT_RATING_NAME5 = "Block Rating"
L[StatLogic.Stats.BlockValue] = "Block Value"
S[StatLogic.Stats.BlockValue] = "Block"
L[StatLogic.Stats.Miss] = MISS

L[StatLogic.Stats.Defense] = DEFENSE
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING -- COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = CRIT_ABBR.." "..STAT_AVOIDANCE
S[StatLogic.Stats.CritAvoidance] = "Crit Avoid"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = COMBAT_RATING_NAME15.." "..RATING
L[StatLogic.Stats.CritDamageReduction] = "Crit Damage Reduction"
S[StatLogic.Stats.CritDamageReduction] = "Crit Dmg Taken"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Taken"

L[StatLogic.Stats.FireResistance] = RESISTANCE2_NAME
L[StatLogic.Stats.NatureResistance] = RESISTANCE3_NAME
L[StatLogic.Stats.FrostResistance] = RESISTANCE4_NAME
L[StatLogic.Stats.ShadowResistance] = RESISTANCE5_NAME
L[StatLogic.Stats.ArcaneResistance] = RESISTANCE6_NAME