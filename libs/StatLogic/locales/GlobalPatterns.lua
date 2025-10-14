local addonName, addon = ...
local StatLogic = LibStub(addonName)
local locale = GetLocale()

-- Metatable that forces keys to be UTF8-lowercase
local lowerMT = {
	__newindex = function(t, k, v)
		if k then
			rawset(t, k:utf8lower(), v)
		end
	end
}

-----------------------
-- Whole Text Lookup --
-----------------------
-- Strings without numbers; mainly used for enchants or easy exclusions
---@alias WholeTextEntry { [Stat]: number } | false
---@type { [string]: WholeTextEntry }
addon.WholeTextLookup = setmetatable({}, lowerMT)
local W = addon.WholeTextLookup

local exclusions = {
	"",
	" \n",
	EMPTY_SOCKET_RED,
	EMPTY_SOCKET_YELLOW,
	EMPTY_SOCKET_BLUE,
	EMPTY_SOCKET_META,
	EMPTY_SOCKET_PRISMATIC,
	ITEM_BIND_ON_EQUIP,
	ITEM_BIND_ON_PICKUP,
	ITEM_BIND_ON_USE,
	ITEM_BIND_QUEST,
	ITEM_SOULBOUND,
	ITEM_BIND_TO_ACCOUNT,
	ITEM_BIND_TO_BNETACCOUNT,
	ITEM_STARTS_QUEST,
	ITEM_CANT_BE_DESTROYED,
	ITEM_CONJURED,
	ITEM_DISENCHANT_NOT_DISENCHANTABLE,
	ITEM_REQ_HORDE,
	ITEM_REQ_ALLIANCE,
	C_Item.GetItemClassInfo(Enum.ItemClass.Projectile),
	INVTYPE_AMMO,
	INVTYPE_HEAD,
	INVTYPE_NECK,
	INVTYPE_SHOULDER,
	INVTYPE_BODY,
	INVTYPE_CHEST,
	INVTYPE_ROBE,
	INVTYPE_WAIST,
	INVTYPE_LEGS,
	INVTYPE_FEET,
	INVTYPE_WRIST,
	INVTYPE_HAND,
	INVTYPE_FINGER,
	INVTYPE_TRINKET,
	INVTYPE_CLOAK,
	INVTYPE_WEAPON,
	INVTYPE_SHIELD,
	INVTYPE_2HWEAPON,
	INVTYPE_WEAPONMAINHAND,
	INVTYPE_WEAPONOFFHAND,
	INVTYPE_HOLDABLE,
	INVTYPE_RANGED,
	INVTYPE_RELIC,
	INVTYPE_TABARD,
	INVTYPE_BAG,
	REFORGED,
	ITEM_HEROIC,
	ITEM_HEROIC_EPIC,
	ITEM_HEROIC_QUALITY0_DESC,
	ITEM_HEROIC_QUALITY1_DESC,
	ITEM_HEROIC_QUALITY2_DESC,
	ITEM_HEROIC_QUALITY3_DESC,
	ITEM_HEROIC_QUALITY4_DESC,
	ITEM_HEROIC_QUALITY5_DESC,
	ITEM_HEROIC_QUALITY6_DESC,
	ITEM_HEROIC_QUALITY7_DESC,
	ITEM_QUALITY0_DESC,
	ITEM_QUALITY1_DESC,
	ITEM_QUALITY2_DESC,
	ITEM_QUALITY3_DESC,
	ITEM_QUALITY4_DESC,
	ITEM_QUALITY5_DESC,
	ITEM_QUALITY6_DESC,
	ITEM_QUALITY7_DESC,
	C_Item.GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown),
	C_Item.GetItemSubClassInfo(Enum.ItemClass.Miscellaneous, Enum.ItemMiscellaneousSubclass.Mount)
}

for _, exclusion in pairs(exclusions) do
	W[exclusion] = false
end

for _, subclass in pairs(Enum.ItemArmorSubclass) do
	local subclassName = C_Item.GetItemSubClassInfo(Enum.ItemClass.Armor, subclass)
	if subclassName then
		W[subclassName] = false
	end
end

local function unescape(pattern)
	return (pattern:gsub("%%%d?%$?c", ""):gsub("%%%d?%$?[sd]", "%%s"):gsub("%.$", ""))
end

local function setPrefixPatterns(input, output)
	for _, pattern in ipairs(input) do
		output["^" .. pattern .. " *"] = true
	end
end

---@type table<string, true>
addon.TrimmedPrefixes = {}

local trimmedPrefixes = {
	ITEM_SPELL_TRIGGER_ONEQUIP,
	ITEM_SOCKET_BONUS:format("")
}

setPrefixPatterns(trimmedPrefixes, addon.TrimmedPrefixes)

-- Patterns that should be matched for breakdowns, but ignord for summaries
---@type table<string, true>
addon.IgnoreSum = setmetatable({}, lowerMT)

local ignoreSumPrefixes = {
	ITEM_SPELL_TRIGGER_ONUSE, -- "Use:"
	ITEM_SPELL_TRIGGER_ONPROC, -- "Chance on hit:"
	ITEM_SET_BONUS_GRAY:gsub("[()]", "%%%1"):gsub("%%d", "%%d+"):gsub("%%s", ""), -- "(%d) Set: %s"
	ITEM_SET_BONUS:format(""), -- "Set: %s"
}

setPrefixPatterns(ignoreSumPrefixes, addon.IgnoreSum)

addon.OnUseCooldown = ITEM_COOLDOWN_TOTAL:utf8lower():format("[^(]+"):gsub("[()]", "%%%1") .. "$"

addon.ReforgeSuffix = "%s*" .. REFORGE_TOOLTIP_LINE:format(0, "", "", ".*"):utf8lower():trim():gsub("[()]", "%%%1")

-------------------------
-- Substitution Lookup --
-------------------------
---@class SubstitutionEntry
---@field ignoreSum boolean?
---@field reduction boolean?
---@field [number] Stat[] | false
---@type { [string]: SubstitutionEntry }
addon.StatIDLookup = setmetatable({}, lowerMT)
local L = addon.StatIDLookup

local short = {
	[HP] = { {StatLogic.Stats.Health} },
	[MP] = { {StatLogic.Stats.Mana} },
	[ITEM_MOD_AGILITY_SHORT] = { {StatLogic.Stats.Agility} },
	[ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT] = { {StatLogic.Stats.ArmorPenetrationRating} },
	[ITEM_MOD_ATTACK_POWER_SHORT] = { {StatLogic.Stats.GenericAttackPower} },
	[ITEM_MOD_BLOCK_RATING_SHORT] = { {StatLogic.Stats.BlockRating} },
	[ITEM_MOD_BLOCK_VALUE_SHORT] = { {StatLogic.Stats.BlockValue} },
	[ITEM_MOD_CRIT_MELEE_RATING_SHORT] = { {StatLogic.Stats.MeleeCritRating} },
	[ITEM_MOD_CRIT_RANGED_RATING_SHORT] = { {StatLogic.Stats.RangedCritRating} },
	[ITEM_MOD_CRIT_RATING_SHORT] = { {StatLogic.Stats.CritRating} },
	[ITEM_MOD_CRIT_SPELL_RATING_SHORT] = { {StatLogic.Stats.SpellCritRating} },
	[ITEM_MOD_DEFENSE_SKILL_RATING_SHORT] = { {StatLogic.Stats.DefenseRating} },
	[ITEM_MOD_DODGE_RATING_SHORT] = { {StatLogic.Stats.DodgeRating} },
	[ITEM_MOD_EXPERTISE_RATING_SHORT] = { {StatLogic.Stats.ExpertiseRating} },
	[ITEM_MOD_EXTRA_ARMOR_SHORT] = { {StatLogic.Stats.BonusArmor} },
	[ITEM_MOD_FERAL_ATTACK_POWER_SHORT] = { {StatLogic.Stats.FeralAttackPower} },
	[ITEM_MOD_HASTE_RATING_SHORT] = { {StatLogic.Stats.HasteRating} },
	[ITEM_MOD_HEALTH_REGEN_SHORT] = { {StatLogic.Stats.HealthRegen} },
	[ITEM_MOD_HEALTH_REGENERATION_SHORT] = { {StatLogic.Stats.HealthRegen} },
	[ITEM_MOD_HEALTH_SHORT] = { {StatLogic.Stats.Health} },
	[ITEM_MOD_HIT_MELEE_RATING_SHORT] = { {StatLogic.Stats.MeleeHitRating} },
	[ITEM_MOD_HIT_RANGED_RATING_SHORT] = { {StatLogic.Stats.RangedHitRating} },
	[ITEM_MOD_HIT_RATING_SHORT] = { {StatLogic.Stats.HitRating} },
	[ITEM_MOD_HIT_SPELL_RATING_SHORT] = { {StatLogic.Stats.SpellHitRating} },
	[ITEM_MOD_INTELLECT_SHORT] = { {StatLogic.Stats.Intellect} },
	[ITEM_MOD_MANA_REGENERATION_SHORT] = { {StatLogic.Stats.GenericManaRegen} },
	[ITEM_MOD_MANA_SHORT] = { {StatLogic.Stats.Mana} },
	[ITEM_MOD_MASTERY_RATING_SHORT] = { {StatLogic.Stats.MasteryRating} },
	[ITEM_MOD_MELEE_ATTACK_POWER_SHORT] = { {StatLogic.Stats.AttackPower} },
	[ITEM_MOD_PARRY_RATING_SHORT] = { {StatLogic.Stats.ParryRating} },
	[ITEM_MOD_POWER_REGEN0_SHORT] = { {StatLogic.Stats.GenericManaRegen} },
	[ITEM_MOD_RANGED_ATTACK_POWER_SHORT] = { {StatLogic.Stats.RangedAttackPower} },
	[ITEM_MOD_RESILIENCE_RATING_SHORT] = { {StatLogic.Stats.ResilienceRating} },
	[RESILIENCE] = { {StatLogic.Stats.ResilienceRating} },
	[ITEM_MOD_PVP_POWER_SHORT] = { {StatLogic.Stats.PvpPowerRating} },
	[STAT_PVP_POWER] = { {StatLogic.Stats.PvpPowerRating} },
	[ITEM_MOD_SPELL_DAMAGE_DONE_SHORT] = { {StatLogic.Stats.SpellDamage} },
	[ITEM_MOD_SPELL_HEALING_DONE_SHORT] = { {StatLogic.Stats.HealingPower} },
	[ITEM_MOD_SPELL_PENETRATION_SHORT] = { {StatLogic.Stats.SpellPenetration} },
	[ITEM_MOD_SPELL_POWER_SHORT] = { {StatLogic.Stats.SpellPower} },
	[ITEM_MOD_SPIRIT_SHORT] = { {StatLogic.Stats.Spirit} },
	[ITEM_MOD_STAMINA_SHORT] = { {StatLogic.Stats.Stamina} },
	[ITEM_MOD_STRENGTH_SHORT] = { {StatLogic.Stats.Strength} },
	[SPELL_STATALL] = { {StatLogic.Stats.AllStats} },
	[STAT_ATTACK_POWER] = { {StatLogic.Stats.GenericAttackPower} },
	[COMBAT_RATING_NAME9] = { {StatLogic.Stats.CritRating} },
}

for pattern, stat in pairs(short) do
	L["%s " .. pattern] = stat
	L[pattern .. " %s"] = stat
end

local long = {
	[ITEM_MOD_AGILITY] = { {StatLogic.Stats.Agility} },
	[ITEM_MOD_ARMOR_PENETRATION_RATING] = { {StatLogic.Stats.ArmorPenetrationRating} },
	[ITEM_MOD_ATTACK_POWER] = { {StatLogic.Stats.GenericAttackPower} },
	[ITEM_MOD_BLOCK_RATING] = { {StatLogic.Stats.BlockRating} },
	[ITEM_MOD_BLOCK_VALUE] = { {StatLogic.Stats.BlockValue} },
	[ITEM_MOD_CRIT_MELEE_RATING] = { {StatLogic.Stats.MeleeCritRating} },
	[ITEM_MOD_CRIT_RANGED_RATING] = { {StatLogic.Stats.RangedCritRating} },
	[ITEM_MOD_CRIT_RATING] = { {StatLogic.Stats.CritRating} },
	[ITEM_MOD_CRIT_SPELL_RATING] = { {StatLogic.Stats.SpellCritRating} },
	[ITEM_MOD_DEFENSE_SKILL_RATING] = { {StatLogic.Stats.DefenseRating} },
	[ITEM_MOD_DODGE_RATING] = { {StatLogic.Stats.DodgeRating} },
	[ITEM_MOD_EXPERTISE_RATING] = { {StatLogic.Stats.ExpertiseRating} },
	[ITEM_MOD_EXTRA_ARMOR] = { {StatLogic.Stats.BonusArmor} },
	[ITEM_MOD_FERAL_ATTACK_POWER] = { {StatLogic.Stats.FeralAttackPower} },
	[ITEM_MOD_HASTE_RATING] = { {StatLogic.Stats.HasteRating} },
	[ITEM_MOD_HEALTH] = { {StatLogic.Stats.Health} },
	[ITEM_MOD_HIT_MELEE_RATING] = { {StatLogic.Stats.MeleeHitRating} },
	[ITEM_MOD_HIT_RANGED_RATING] = { {StatLogic.Stats.RangedHitRating} },
	[ITEM_MOD_HIT_RATING] = { {StatLogic.Stats.HitRating} },
	[ITEM_MOD_HIT_SPELL_RATING] = { {StatLogic.Stats.SpellHitRating} },
	[ITEM_MOD_INTELLECT] = { {StatLogic.Stats.Intellect} },
	[ITEM_MOD_MANA] = { {StatLogic.Stats.Mana} },
	[ITEM_MOD_MASTERY_RATING] = { {StatLogic.Stats.MasteryRating} },
	[ITEM_MOD_PARRY_RATING] = { {StatLogic.Stats.ParryRating} },
	[ITEM_MOD_RANGED_ATTACK_POWER] = { {StatLogic.Stats.RangedAttackPower} },
	[ITEM_MOD_RESILIENCE_RATING] = { {StatLogic.Stats.ResilienceRating} },
	[ITEM_MOD_PVP_POWER] = { {StatLogic.Stats.PvpPowerRating} },
	[ITEM_MOD_SPELL_DAMAGE_DONE] = { {StatLogic.Stats.SpellDamage} },
	[ITEM_MOD_SPELL_HEALING_DONE] = { {StatLogic.Stats.HealingPower} },
	[ITEM_MOD_SPELL_PENETRATION] = { {StatLogic.Stats.SpellPenetration} },
	[ITEM_MOD_SPELL_POWER] = { {StatLogic.Stats.SpellPower} },
	[ITEM_MOD_SPIRIT] = { {StatLogic.Stats.Spirit} },
	[ITEM_MOD_STAMINA] = { {StatLogic.Stats.Stamina} },
	[ITEM_MOD_STRENGTH] = { {StatLogic.Stats.Strength} },

	[DPS_TEMPLATE] = { {StatLogic.Stats.WeaponDPS} },
	[ARMOR_TEMPLATE] = { {StatLogic.Stats.Armor} },
	[SHIELD_BLOCK_TEMPLATE] = { {StatLogic.Stats.BlockValue} },
	[PLUS_DAMAGE_TEMPLATE] = { {StatLogic.Stats.MinWeaponDamage}, {StatLogic.Stats.MaxWeaponDamage} },
	[DAMAGE_TEMPLATE] = { {StatLogic.Stats.MinWeaponDamage}, {StatLogic.Stats.MaxWeaponDamage} },
	[PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", "")] = { {StatLogic.Stats.MinWeaponDamage}, {StatLogic.Stats.MaxWeaponDamage} },
	[AMMO_DAMAGE_TEMPLATE] = { {StatLogic.Stats.WeaponDPS} },
}

for pattern, stats in pairs(long) do
	L[unescape(pattern)] = stats
end

local regen = {
	[ITEM_MOD_HEALTH_REGEN] = { {StatLogic.Stats.HealthRegen} },
	[ITEM_MOD_HEALTH_REGENERATION] = { {StatLogic.Stats.HealthRegen} },
	[ITEM_MOD_MANA_REGENERATION] = { {StatLogic.Stats.GenericManaRegen} },
}

for pattern, stats in pairs(regen) do
	local stat = pattern:find("%%s")
	local five = pattern:find("5")
	pattern = pattern:gsub("5", "%%s")
	local i = stat > five and 1 or 2
	table.insert(stats, i, false)
	L[unescape(pattern)] = stats
end

local resistances = {
	[3] = StatLogic.Stats.FireResistance,
	[4] = StatLogic.Stats.NatureResistance,
	[5] = StatLogic.Stats.FrostResistance,
	[6] = StatLogic.Stats.ShadowResistance,
	[7] = StatLogic.Stats.ArcaneResistance,
}

if not MAX_SPELL_SCHOOLS then MAX_SPELL_SCHOOLS = 7 end
for i = 2, MAX_SPELL_SCHOOLS do
	local school = _G["DAMAGE_SCHOOL" .. i]
	L[DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", school)] = { {StatLogic.Stats.MinWeaponDamage}, {StatLogic.Stats.MaxWeaponDamage} }
	L[PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", school)] = { {StatLogic.Stats.MinWeaponDamage}, {StatLogic.Stats.MaxWeaponDamage} }
	if resistances[i] then
		L[unescape(ITEM_RESIST_SINGLE):format("%s", school)] = { {resistances[i]} }
	end
end

--------------------
-- Prefix Exclude --
--------------------
-- Exclude strings by 3-5 character prefixes
-- Used to reduce noise while debugging missing patterns
local prefixExclusions = {
	SPEED,
	ITEM_DISENCHANT_ANY_SKILL, -- "Disenchantable"
	ITEM_DISENCHANT_MIN_SKILL, -- "Disenchanting requires %s (%d)"
	ITEM_DURATION_DAYS, -- "Duration: %d days"
	ITEM_CREATED_BY, -- "|cff00ff00<Made by %s>|r"
	ITEM_COOLDOWN_TIME_DAYS, -- "Cooldown remaining: %d day"
	ITEM_UNIQUE, -- "Unique"
	ITEM_MIN_LEVEL, -- "Requires Level %d"
	ITEM_MIN_SKILL, -- "Requires %s (%d)"
	ITEM_CLASSES_ALLOWED, -- "Classes: %s"
	ITEM_RACES_ALLOWED, -- "Races: %s"
}

addon.PrefixExclude = {}
local excludeLen = 5
if locale == "koKR" or locale == "zhCN" or locale == "zhTW" then
	excludeLen = 3
end
addon.PrefixExcludeLength = excludeLen

for _, exclusion in pairs(prefixExclusions) do
	-- Set the string to exactly excludeLen characters, right-padded.
	local len = string.utf8len(exclusion)
	if len > excludeLen then
		exclusion = string.utf8sub(exclusion, 1, excludeLen)
	elseif len < excludeLen then
		exclusion = exclusion .. (" "):rep(excludeLen - len)
	end
	addon.PrefixExclude[exclusion] = true
end

---------------------
-- PreScan Exclude --
---------------------
-- Iterates all patterns, matching the whole string. Expensive so try not to use.
-- Used to reduce noise while debugging missing patterns
addon.PreScanPatterns = setmetatable({}, lowerMT)
local itemSetNamePattern = ITEM_SET_NAME:gsub("%%%d?%$?s", ".+"):gsub("%%%d?%$?d", "%%d+"):gsub("[()]", "%%%1")
addon.PreScanPatterns[itemSetNamePattern] = false