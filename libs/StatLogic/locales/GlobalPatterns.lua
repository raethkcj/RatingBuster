local addonName = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local StatLogic = LibStub("StatLogic")

local function Escape(text)
   return text:lower():gsub("[().+%-*?%%[^$]", "%%%1"):gsub("%%%%s", "(.+)")
end

L.WholeTextLookup[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}
L.WholeTextLookup[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}
L.WholeTextLookup[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}
L.WholeTextLookup[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}

L.WholeTextLookup[""] = false
L.WholeTextLookup[" \n"] = false
L.WholeTextLookup[ITEM_BIND_ON_EQUIP] = false
L.WholeTextLookup[ITEM_BIND_ON_PICKUP] = false
L.WholeTextLookup[ITEM_BIND_ON_USE] = false
L.WholeTextLookup[ITEM_BIND_QUEST] = false
L.WholeTextLookup[ITEM_SOULBOUND] = false
L.WholeTextLookup[ITEM_STARTS_QUEST] = false
L.WholeTextLookup[ITEM_CANT_BE_DESTROYED] = false
L.WholeTextLookup[ITEM_CONJURED] = false
L.WholeTextLookup[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = false
L.WholeTextLookup[ITEM_REQ_HORDE] = false
L.WholeTextLookup[ITEM_REQ_ALLIANCE] = false
L.WholeTextLookup[GetItemClassInfo(Enum.ItemClass.Projectile)] = false
L.WholeTextLookup[INVTYPE_AMMO] = false
L.WholeTextLookup[INVTYPE_HEAD] = false
L.WholeTextLookup[INVTYPE_NECK] = false
L.WholeTextLookup[INVTYPE_SHOULDER] = false
L.WholeTextLookup[INVTYPE_BODY] = false
L.WholeTextLookup[INVTYPE_CHEST] = false
L.WholeTextLookup[INVTYPE_ROBE] = false
L.WholeTextLookup[INVTYPE_WAIST] = false
L.WholeTextLookup[INVTYPE_LEGS] = false
L.WholeTextLookup[INVTYPE_FEET] = false
L.WholeTextLookup[INVTYPE_WRIST] = false
L.WholeTextLookup[INVTYPE_HAND] = false
L.WholeTextLookup[INVTYPE_FINGER] = false
L.WholeTextLookup[INVTYPE_TRINKET] = false
L.WholeTextLookup[INVTYPE_CLOAK] = false
L.WholeTextLookup[INVTYPE_WEAPON] = false
L.WholeTextLookup[INVTYPE_SHIELD] = false
L.WholeTextLookup[INVTYPE_2HWEAPON] = false
L.WholeTextLookup[INVTYPE_WEAPONMAINHAND] = false
L.WholeTextLookup[INVTYPE_WEAPONOFFHAND] = false
L.WholeTextLookup[INVTYPE_HOLDABLE] = false
L.WholeTextLookup[INVTYPE_RANGED] = false
L.WholeTextLookup[INVTYPE_RELIC] = false
L.WholeTextLookup[INVTYPE_TABARD] = false
L.WholeTextLookup[INVTYPE_BAG] = false
L.WholeTextLookup[GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown)] = false
local mount = GetItemSubClassInfo(Enum.ItemClass.Miscellaneous, Enum.ItemMiscellaneousSubclass.Mount)
if mount then L.WholeTextLookup[mount] = false end

for _, subclass in pairs(Enum.ItemArmorSubclass) do
	local subclassName = GetItemSubClassInfo(Enum.ItemClass.Armor, subclass)
	if subclassName then
		L.WholeTextLookup[subclassName] = false
	end
end

do
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
		[ITEM_MOD_HEALTH_REGEN] = {StatLogic.Stats.HealthRegen},
		[ITEM_MOD_HEALTH_REGENERATION] = {StatLogic.Stats.HealthRegen},
		[ITEM_MOD_HIT_MELEE_RATING] = {StatLogic.Stats.MeleeHitRating},
		[ITEM_MOD_HIT_RANGED_RATING] = {StatLogic.Stats.RangedHitRating},
		[ITEM_MOD_HIT_RATING] = {StatLogic.Stats.HitRating},
		[ITEM_MOD_HIT_SPELL_RATING] = {StatLogic.Stats.SpellHitRating},
		[ITEM_MOD_INTELLECT] = {StatLogic.Stats.Intellect},
		[ITEM_MOD_MANA] = {StatLogic.Stats.Mana},
		[ITEM_MOD_MANA_REGENERATION] = {StatLogic.Stats.ManaRegen},
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
		[PLUS_DAMAGE_TEMPLATE] = {StatLogic.Stats.WeaponDamageMin, StatLogic.Stats.WeaponDamageMax},
		[DAMAGE_TEMPLATE] = {StatLogic.Stats.WeaponDamageMin, StatLogic.Stats.WeaponDamageMax},
	}

	for pattern, stats in pairs(long) do
		pattern = pattern:gsub("%%c", "")
		local temp = {}
		local indices = {}

		-- Gather the indices of the real stats
		local i = 0
		local j = 1
		repeat
			i = pattern:find("%%s", i + 1)
			if i then
				temp[i] = stats[j]
				indices[#indices + 1] = i
				j = j + 1
			end
		until not i

		-- Gather the indices of each 5
		i = 0
		repeat
			i = pattern:find("%f[%+%-%d]5%f[^%+%-%d]", i + 1)
			if i then
				temp[i] = false
				indices[#indices + 1] = i
			end
		until not i

		pattern = pattern:gsub("%f[%+%-%d]5%f[^%+%-%d]", "%%s")

		-- Insert a false in the stat table for each 5, in order
		table.sort(indices)
		local newStats = {}
		for _, index in ipairs(indices) do
			newStats[#newStats + 1] = temp[index]
		end

		L.StatIDLookup[pattern] = newStats
	end
end

do
	local short = {
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
		[ITEM_MOD_SPELL_DAMAGE_DONE_SHORT] = {StatLogic.Stats.SpellDamage},
		[ITEM_MOD_SPELL_HEALING_DONE_SHORT] = {StatLogic.Stats.HealingPower},
		[ITEM_MOD_SPELL_PENETRATION_SHORT] = {StatLogic.Stats.SpellPenetration},
		[ITEM_MOD_SPELL_POWER_SHORT] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}},
		[ITEM_MOD_SPIRIT_SHORT] = {StatLogic.Stats.Spirit},
		[ITEM_MOD_STAMINA_SHORT] = {StatLogic.Stats.Stamina},
		[ITEM_MOD_STRENGTH_SHORT] = {StatLogic.Stats.Strength},
	}

	for pattern, stat in pairs(short) do
		L.StatIDLookup["%s " .. pattern] = stat
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

for _, exclusion in pairs(prefixExclusions) do
	-- Set the string to exactly PrefixExcludeLength characters, right-padded.
	local len = string.utf8len(exclusion)
	if len > L.PrefixExcludeLength then
		exclusion = string.utf8sub(exclusion, 1, L.PrefixExcludeLength)
	elseif len < L.PrefixExcludeLength then
		exclusion = exclusion .. (" "):rep(L.PrefixExcludeLength - len)
	end
	L.PrefixExclude[exclusion] = true
end

L.DualStatPatterns[Escape(PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL)] = {{StatLogic.Stats.WeaponDamageMin}, {StatLogic.Stats.WeaponDamageMax}}
L.DualStatPatterns[Escape(DAMAGE_TEMPLATE_WITH_SCHOOL)] = {{StatLogic.Stats.WeaponDamageMin}, {StatLogic.Stats.WeaponDamageMax}}