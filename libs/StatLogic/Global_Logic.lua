local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub(addonName)

local function conversionFallback(classTable, conversionFunc)
	local t = getmetatable(classTable) or classTable
	return setmetatable(t, { __index = function(_, level)
		return level == UnitLevel("player") and conversionFunc(StatLogic) or 0
	end })
end

StatLogic.StatModTable["GLOBAL"] = {
	["ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MIN"] = {
		-- Base
		{
			["value"] = 0.5,
		}
	},
	["ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MAX"] = {
		-- Base
		{
			["value"] = 0.5,
		}
	},
	["ADD_MELEE_CRIT_MOD_AGI"] = {
		{
			["level"] = conversionFallback(addon.CritPerAgi[addon.class], StatLogic.GetCritPerAgi),
		}
	},
	["ADD_RANGED_CRIT_MOD_AGI"] = {
		{
			["level"] = addon.CritPerAgi[addon.class]
		}
	},
	["ADD_SPELL_CRIT_MOD_INT"] = {
		{
			["level"] = conversionFallback(addon.SpellCritPerInt[addon.class], StatLogic.GetSpellCritPerInt),
		}
	},
	["ADD_DODGE_MOD_AGI"] = {
		{
			["level"] = conversionFallback(addon.DodgePerAgi[addon.class], StatLogic.GetDodgePerAgi)
		}
	},
}