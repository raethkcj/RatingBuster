local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub(addonName)

local function conversionFallback(classTable, conversionFunc)
	return setmetatable({}, { __index = function(_, level)
		return classTable[level] or level == UnitLevel("player") and conversionFunc(StatLogic) or 0
	end })
end

local RatingScalars = {
	0.03846150, 0.03846150, 0.03846150, 0.03846150,  0.03846150,  0.03846150,  0.03846150,  0.03846150,  0.03846150,  0.03846150,
	0.05769232, 0.07692309, 0.09615381, 0.11538458,  0.13461540,  0.15384622,  0.17307690,  0.19230772,  0.21153854,  0.23076922,
	0.24999999, 0.26923081, 0.28846148, 0.30769230,  0.32692312,  0.34615375,  0.36538462,  0.38461539,  0.40384621,  0.42307689,
	0.44230761, 0.46153843, 0.48076930, 0.50000002,  0.51923075,  0.53846147,  0.55769229,  0.57692302,  0.59615379,  0.61538461,
	0.63461533, 0.65384615, 0.67307692, 0.69230765,  0.71153847,  0.73076929,  0.74999996,  0.76923078,  0.78846160,  0.80769228,
	0.82692315, 0.84615392, 0.86538460, 0.88461537,  0.90384624,  0.92307691,  0.94230768,  0.96153855,  0.98076923,  1.00000000,
	1.03797464, 1.07894744, 1.12328768, 1.17142849,  1.22388062,  1.28125003,  1.34426230,  1.41379307,  1.49090911,  1.57692297,
	1.69669417, 1.82556218, 1.96421831, 2.11340541,  2.27392361,  2.44663375,  2.63246166,  2.83240353,  3.04753145,  3.27899897,
	4.30560143, 5.65397461, 7.42754553, 9.75272320, 12.80571629, 16.18357410, 20.77294586, 26.32850114, 33.81642349, 42.75362112,
}

local ResilienceScalars = {
	[81] = 4.09289612,
	[82] = 5.10881490,
	[83] = 6.37689952,
	[84] = 7.95974263,
	[85] = 9.93547022,
	[86] = 12.37685034,
	[87] = 16.14371783,
	[88] = 20.44870926,
	[89] = 26.36807246,
	[90] = 33.36368352,
}
setmetatable(ResilienceScalars, { __index = RatingScalars })

---@param stat Stat
---@param level number
---@return number
function addon.GetRatingScalar(stat, level)
	if stat == StatLogic.Stats.ResilienceRating then
		return ResilienceScalars[level]
	else
		return RatingScalars[level]
	end
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
	["ADD_AP_MOD_GENERIC_ATTACK_POWER"] = {
		{
			value = 1,
		},
	},
	["ADD_RANGED_AP_MOD_GENERIC_ATTACK_POWER"] = {
		{
			value = 1,
		},
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
	["ADD_MANA_REGEN_MOD_GENERIC_MANA_REGEN"] = {
		{
			["value"] = 1,
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