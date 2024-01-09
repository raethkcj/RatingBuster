local addonName = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

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

L.PreScanPatterns[Escape(DPS_TEMPLATE)] = "DPS"
--L.PreScanPatterns[Escape(ITEM_SET_BONUS_GRAY)] = false

L.DualStatPatterns[Escape(PLUS_DAMAGE_TEMPLATE_WITH_SCHOOL)] = {{"MIN_DAMAGE"}, {"MAX_DAMAGE"}}
L.DualStatPatterns[Escape(PLUS_DAMAGE_TEMPLATE)] = {{"MIN_DAMAGE"}, {"MAX_DAMAGE"}}
L.DualStatPatterns[Escape(DAMAGE_TEMPLATE_WITH_SCHOOL)] = {{"MIN_DAMAGE"}, {"MAX_DAMAGE"}}
L.DualStatPatterns[Escape(DAMAGE_TEMPLATE)] = {{"MIN_DAMAGE"}, {"MAX_DAMAGE"}}
