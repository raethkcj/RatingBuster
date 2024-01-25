local addonName = ...
---@class StatLogic
local StatLogic = LibStub(addonName)

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
	["ADD_BLOCK_CHANCE_MOD_DEFENSE"] = {
		-- Passive: Block
		{
			["known"] = 107,
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_CRIT_AVOIDANCE_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_DODGE_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_MISS_MOD_DEFENSE"] = {
		-- Base
		{
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
	["ADD_PARRY_MOD_DEFENSE"] = {
		-- Passive: Parry
		{
			["known"] = 3127,
			["value"] = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE,
		}
	},
}