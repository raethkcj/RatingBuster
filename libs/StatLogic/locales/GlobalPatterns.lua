local addonName, addon = ...
local StatLogic = LibStub(addonName)
local locale = GetLocale()

local lowerMT = {
	__newindex = function(t, k, v)
		if k then
			rawset(t, k:utf8lower(), v)
		end
	end
}

addon.WholeTextLookup = setmetatable({}, lowerMT)
local W = addon.WholeTextLookup
addon.StatIDLookup = setmetatable({}, lowerMT)
local L = addon.StatIDLookup

W[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}
W[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}
W[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}
W[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}

local exclusions = {
	"",
	" \n",
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
	GetItemClassInfo(Enum.ItemClass.Projectile),
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
	GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown),
	GetItemSubClassInfo(Enum.ItemClass.Miscellaneous, Enum.ItemMiscellaneousSubclass.Mount)
}

for _, exclusion in pairs(exclusions) do
	W[exclusion] = false
end

for _, subclass in pairs(Enum.ItemArmorSubclass) do
	local subclassName = GetItemSubClassInfo(Enum.ItemClass.Armor, subclass)
	if subclassName then
		W[subclassName] = false
	end
end

local function unescape(pattern)
	return pattern:gsub("%%%d?%$?c", ""):gsub("%%%d?%$?[sd]", "%%s"):gsub("%.$", ""):utf8lower()
end

local long = {
	[ITEM_MOD_AGILITY] = {StatLogic.Stats.Agility},
	[ITEM_MOD_ARMOR_PENETRATION_RATING] = {StatLogic.Stats.ArmorPenetrationRating},
	[ITEM_MOD_ATTACK_POWER] = {StatLogic.Stats.AttackPower},
	[ITEM_MOD_BLOCK_RATING] = {StatLogic.Stats.BlockRating},
	[ITEM_MOD_BLOCK_VALUE] = {StatLogic.Stats.BlockValue},
	[ITEM_MOD_CRIT_MELEE_RATING] = {StatLogic.Stats.MeleeCritRating},
	[ITEM_MOD_CRIT_RANGED_RATING] = {StatLogic.Stats.RangedCritRating},
	[ITEM_MOD_CRIT_RATING] = {StatLogic.Stats.CritRating},
	[ITEM_MOD_CRIT_SPELL_RATING] = {StatLogic.Stats.SpellCritRating},
	[ITEM_MOD_DEFENSE_SKILL_RATING] = {StatLogic.Stats.DefenseRating},
	[ITEM_MOD_DODGE_RATING] = {StatLogic.Stats.DodgeRating},
	[ITEM_MOD_EXPERTISE_RATING] = {StatLogic.Stats.ExpertiseRating},
	[ITEM_MOD_EXTRA_ARMOR] = {StatLogic.Stats.BonusArmor},
	[ITEM_MOD_FERAL_ATTACK_POWER] = {StatLogic.Stats.FeralAttackPower},
	[ITEM_MOD_HASTE_RATING] = {StatLogic.Stats.HasteRating},
	[ITEM_MOD_HEALTH] = {StatLogic.Stats.Health},
	[ITEM_MOD_HIT_MELEE_RATING] = {StatLogic.Stats.MeleeHitRating},
	[ITEM_MOD_HIT_RANGED_RATING] = {StatLogic.Stats.RangedHitRating},
	[ITEM_MOD_HIT_RATING] = {StatLogic.Stats.HitRating},
	[ITEM_MOD_HIT_SPELL_RATING] = {StatLogic.Stats.SpellHitRating},
	[ITEM_MOD_INTELLECT] = {StatLogic.Stats.Intellect},
	[ITEM_MOD_MANA] = {StatLogic.Stats.Mana},
	[ITEM_MOD_MASTERY_RATING] = {StatLogic.Stats.MasteryRating},
	[ITEM_MOD_PARRY_RATING] = {StatLogic.Stats.ParryRating},
	[ITEM_MOD_RANGED_ATTACK_POWER] = {StatLogic.Stats.RangedAttackPower},
	[ITEM_MOD_RESILIENCE_RATING] = {StatLogic.Stats.ResilienceRating},
	[ITEM_MOD_SPELL_DAMAGE_DONE] = {StatLogic.Stats.SpellDamage},
	[ITEM_MOD_SPELL_HEALING_DONE] = {StatLogic.Stats.HealingPower},
	[ITEM_MOD_SPELL_PENETRATION] = {StatLogic.Stats.SpellPenetration},
	[ITEM_MOD_SPELL_POWER] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}},
	[ITEM_MOD_SPIRIT] = {StatLogic.Stats.Spirit},
	[ITEM_MOD_STAMINA] = {StatLogic.Stats.Stamina},
	[ITEM_MOD_STRENGTH] = {StatLogic.Stats.Strength},

	[DPS_TEMPLATE] = {StatLogic.Stats.WeaponDPS},
	[ARMOR_TEMPLATE] = {StatLogic.Stats.Armor},
	[SHIELD_BLOCK_TEMPLATE] = {StatLogic.Stats.BlockValue},
	[PLUS_DAMAGE_TEMPLATE] = {StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage},
	[DAMAGE_TEMPLATE] = {StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage},
	[PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", "")] = {StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage},
	[AMMO_DAMAGE_TEMPLATE] = {StatLogic.Stats.WeaponDPS},
}

for pattern, stats in pairs(long) do
	L[unescape(pattern):utf8lower()] = stats
end

local regen = {
	[ITEM_MOD_HEALTH_REGEN] = {StatLogic.Stats.HealthRegen},
	[ITEM_MOD_HEALTH_REGENERATION] = {StatLogic.Stats.HealthRegen},
	[ITEM_MOD_MANA_REGENERATION] = {StatLogic.Stats.ManaRegen},
}

for pattern, stats in pairs(regen) do
	local stat = pattern:find("%%s")
	local five = pattern:find("5")
	pattern = pattern:gsub("5", "%%s")
	local i = stat > five and 1 or 2
	table.insert(stats, i, false)
	L[unescape(pattern):utf8lower()] = stats
end

local short = {
	[HP] = {StatLogic.Stats.Health},
	[MP] = {StatLogic.Stats.Mana},
	[ITEM_MOD_AGILITY_SHORT] = {StatLogic.Stats.Agility},
	[ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT] = {StatLogic.Stats.ArmorPenetrationRating},
	[ITEM_MOD_ATTACK_POWER_SHORT] = {StatLogic.Stats.AttackPower},
	[ITEM_MOD_BLOCK_RATING_SHORT] = {StatLogic.Stats.BlockRating},
	[ITEM_MOD_BLOCK_VALUE_SHORT] = {StatLogic.Stats.BlockValue},
	[ITEM_MOD_CRIT_MELEE_RATING_SHORT] = {StatLogic.Stats.MeleeCritRating},
	[ITEM_MOD_CRIT_RANGED_RATING_SHORT] = {StatLogic.Stats.RangedCritRating},
	[ITEM_MOD_CRIT_RATING_SHORT] = {StatLogic.Stats.CritRating},
	[ITEM_MOD_CRIT_SPELL_RATING_SHORT] = {StatLogic.Stats.SpellCritRating},
	[ITEM_MOD_DEFENSE_SKILL_RATING_SHORT] = {StatLogic.Stats.DefenseRating},
	[ITEM_MOD_DODGE_RATING_SHORT] = {StatLogic.Stats.DodgeRating},
	[ITEM_MOD_EXPERTISE_RATING_SHORT] = {StatLogic.Stats.ExpertiseRating},
	[ITEM_MOD_EXTRA_ARMOR_SHORT] = {StatLogic.Stats.BonusArmor},
	[ITEM_MOD_FERAL_ATTACK_POWER_SHORT] = {StatLogic.Stats.FeralAttackPower},
	[ITEM_MOD_HASTE_RATING_SHORT] = {StatLogic.Stats.HasteRating},
	[ITEM_MOD_HEALTH_REGEN_SHORT] = {StatLogic.Stats.HealthRegen},
	[ITEM_MOD_HEALTH_REGENERATION_SHORT] = {StatLogic.Stats.HealthRegen},
	[ITEM_MOD_HEALTH_SHORT] = {StatLogic.Stats.Health},
	[ITEM_MOD_HIT_MELEE_RATING_SHORT] = {StatLogic.Stats.MeleeHitRating},
	[ITEM_MOD_HIT_RANGED_RATING_SHORT] = {StatLogic.Stats.RangedHitRating},
	[ITEM_MOD_HIT_RATING_SHORT] = {StatLogic.Stats.HitRating},
	[ITEM_MOD_HIT_SPELL_RATING_SHORT] = {StatLogic.Stats.SpellHitRating},
	[ITEM_MOD_INTELLECT_SHORT] = {StatLogic.Stats.Intellect},
	[ITEM_MOD_MANA_REGENERATION_SHORT] = {StatLogic.Stats.ManaRegen},
	[ITEM_MOD_MANA_SHORT] = {StatLogic.Stats.Mana},
	[ITEM_MOD_MASTERY_RATING_SHORT] = {StatLogic.Stats.MasteryRating},
	[ITEM_MOD_MELEE_ATTACK_POWER_SHORT] = {StatLogic.Stats.AttackPower},
	[ITEM_MOD_PARRY_RATING_SHORT] = {StatLogic.Stats.ParryRating},
	[ITEM_MOD_POWER_REGEN0_SHORT] = {StatLogic.Stats.ManaRegen},
	[ITEM_MOD_RANGED_ATTACK_POWER_SHORT] = {StatLogic.Stats.RangedAttackPower},
	[ITEM_MOD_RESILIENCE_RATING_SHORT] = {StatLogic.Stats.ResilienceRating},
	[RESILIENCE] = {StatLogic.Stats.ResilienceRating},
	[ITEM_MOD_SPELL_DAMAGE_DONE_SHORT] = {StatLogic.Stats.SpellDamage},
	[ITEM_MOD_SPELL_HEALING_DONE_SHORT] = {StatLogic.Stats.HealingPower},
	[ITEM_MOD_SPELL_PENETRATION_SHORT] = {StatLogic.Stats.SpellPenetration},
	[ITEM_MOD_SPELL_POWER_SHORT] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}},
	[ITEM_MOD_SPIRIT_SHORT] = {StatLogic.Stats.Spirit},
	[ITEM_MOD_STAMINA_SHORT] = {StatLogic.Stats.Stamina},
	[ITEM_MOD_STRENGTH_SHORT] = {StatLogic.Stats.Strength},
	[SPELL_STATALL] = {StatLogic.Stats.AllStats},
	[STAT_ATTACK_POWER] = {StatLogic.Stats.AttackPower},
	[COMBAT_RATING_NAME9] = {StatLogic.Stats.CritRating},
}

for pattern, stat in pairs(short) do
	L[("%s " .. pattern):utf8lower()] = stat
	L[(pattern .. " %s"):utf8lower()] = stat
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
	L[DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", school):utf8lower()] = {StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage}
	L[PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL:format("%s", "%s", school):utf8lower()] = {StatLogic.Stats.MinWeaponDamage, StatLogic.Stats.MaxWeaponDamage}
	if resistances[i] then
		L[unescape(ITEM_RESIST_SINGLE):format("%s", school):utf8lower()] = {resistances[i]}
	end
end

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
	ITEM_SPELL_TRIGGER_ONUSE, -- "Use:"
	ITEM_SPELL_TRIGGER_ONPROC, -- "Chance on hit:"
	ITEM_SET_BONUS, -- "Set: %s"
}

--------------------
-- Prefix Exclude --
--------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
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

-- Used to reduce noise while debugging missing patterns
addon.PreScanPatterns = setmetatable({}, lowerMT)
local str = ITEM_SET_NAME:gsub("%%%d?%$?s", ".+"):gsub("%%%d?%$?d", "%%d+"):gsub("[()]", "%%%1")
print("ITEM_SET_NAME:", str)
addon.PreScanPatterns[str] = false