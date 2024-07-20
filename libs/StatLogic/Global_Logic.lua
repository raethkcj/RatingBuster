local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub(addonName)

local function conversionFallback(classTable, conversionFunc)
	return setmetatable({}, { __index = function(_, level)
		return classTable[level] or level == UnitLevel("player") and conversionFunc(StatLogic) or 0
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

addon.GenerateWeaponSubclassStats()

for stat in pairs(StatLogic.RatingBase) do
	local rating_name = stat.name:gsub("(%l)(%u)", "%1_%2"):upper()
	local add = rating_name:gsub("_RATING$", "")
	local mod = rating_name
	local stat_mod = {
		add = add,
		mod = mod,
		initialValue = 0,
		finalAdjust = 0,
	}
	local name = ("ADD_%s_MOD_%s"):format(stat_mod.add, stat_mod.mod)
	StatLogic.StatModInfo[name] = stat_mod
	StatLogic.StatModTable["GLOBAL"][name] = {
		{
			["level"] = setmetatable({}, {
				__index = function(t, level)
					t[level] = StatLogic:GetEffectFromRating(1, stat, level)
					return t[level]
				end
			}),
		}
	}
end