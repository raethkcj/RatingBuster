local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

-----------------------------------
-- Avoidance diminishing returns --
-----------------------------------
-- Formula reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
--[[-------------------------------
This includes
1. Dodge from Dodge Rating, Defense, Agility.
2. Parry from Parry Rating, Defense.
3. Chance to be missed from Defense.

The following is the result of hours of work gathering data from beta servers and then spending even more time running multiple regression analysis on the data.

1. DR for Dodge, Parry, Miss are calculated separately.
2. Base avoidances are not affected by DR, (ex: Dodge from base Agility)
3. Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
4. Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
5. Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
6. c and k values depend on class but does not change with level.

7. The DR formula:

1/x' = 1/c+k/x

x' is the diminished stat before converting to IEEE754.
x is the stat before diminishing returns.
c is the cap of the stat, and changes with class.
k is is a value that changes with class.
-----------------------------------]]

function StatLogic:GetMissChanceBeforeDR()
	local baseDefense, additionalDefense = UnitDefense("player")
	local defenseFromDefenseRating = floor(GetCombatRatingBonus(CR_DEFENSE_SKILL))
	local modMiss = defenseFromDefenseRating * 0.04
	local drFreeMiss = 5 + (baseDefense + additionalDefense - defenseFromDefenseRating) * 0.04
	return modMiss, drFreeMiss
end

--[[
Formula by Whitetooth (hotdogee [at] gmail [dot] com)
Calculates the dodge percentage per agility for your current class and level.
Only works for your currect class and current level, does not support class and level args.
Calculations got a bit more complicated with the introduction of the avoidance DR in WotLK, these are the values we know or can be calculated easily:
D'=Total Dodge% after DR
D_r=Dodge from Defense and Dodge Rating before DR
D_b=Dodge unaffected by DR (BaseDodge + Dodge from talent/buffs + penalty from uncapped Defense skill)
A=Total Agility
A_b=Base Agility (This is what you have with no gear on)
A_g=Total Agility - Base Agility
Let d be the Dodge/Agi value we are going to calculate.

 1     1     k
--- = --- + ---
 x'    c     x

x'=D'-D_b-A_b*d
x=A_g*d+D_r

1/(D'-D_b-A_b*d)=1/C_d+k/(A_g*d+D_r)=(A_g*d+D_r+C_d*k)/(C_d*A_g*d+C_d*D_r)

C_d*A_g*d+C_d*D_r=[(D'-D_b)-A_b*d]*[Ag*d+(D_r+C_d*k)]

After rearranging the terms, we get an equation of type a*d^2+b*d+c where
a=-A_g*A_b
b=A_g(D'-D_b)-A_b(D_r+C_d*k)-C_dA_g
c=(D'-D_b)(D_r+C_d*k)-C_d*D_r
Dodge/Agi=(-b-(b^2-4ac)^0.5)/(2a)
]]
---@return number dodge Dodge percentage per agility
function StatLogic:GetDodgePerAgi()
	-- Collect data
	local D_dr = GetDodgeChance()
	if D_dr == 0 then
		return 0
	end
	local dodgeFromDodgeRating = GetCombatRatingBonus(CR_DODGE)
	local D_r = dodgeFromDodgeRating
	local D_b = self:GetStatMod("ADD_DODGE")
	if addon.tocversion < 40000 then
		local baseDefense, modDefense = UnitDefense("player")
		local dodgeFromModDefense = modDefense * 0.04
		D_r = D_r + dodgeFromModDefense
		D_b = D_b + (baseDefense - UnitLevel("player") * 5) * 0.04
	end
	local stat, effectiveStat, posBuff, negBuff = UnitStat("player", LE_UNIT_STAT_AGILITY)
	local modAgi = 1
	if addon.ModAgiClasses and addon.ModAgiClasses[addon.class] then
		modAgi = self:GetStatMod("MOD_AGI")
		-- Talents that modify Agi will not add to posBuff, so we need to calculate baseAgi
		-- But Agi from Kings etc. will add to posBuff, so we subtract those if present
		for _, case in ipairs(StatLogic.StatModTable["ALL"]["MOD_AGI"]) do
			if case.group == addon.ExclusiveGroup.AllStats then
				if StatLogic:GetAuraInfo(case.aura, true) then
					modAgi = modAgi - case.value
				end
			end
		end
	end
	local A = effectiveStat
	local A_b = ceil((stat - posBuff - negBuff) / modAgi)
	local A_g = A - A_b
	local C = addon.C_d[addon.class]
	local k = addon.K[addon.class]
	-- Solve a*x^2+b*x+c
	local a = -A_g*A_b
	local b = A_g*(D_dr-D_b)-A_b*(D_r+C*k)-C*A_g
	local c = (D_dr-D_b)*(D_r+C*k)-C*D_r

	local dodgePerAgi
	if a == 0 then
		dodgePerAgi = -c / b
	else
		dodgePerAgi = (-b-(b^2-4*a*c)^0.5)/(2*a)
	end

	return dodgePerAgi
end

--[[
Calculates your current Dodge% before diminishing returns.
Dodge% = diminishableDodge + drFreeDodge

drFreeDodge includes:
* Base dodge
* Dodge from base agility
* Dodge modifier from base defense
* Dodge modifers from talents or spells

diminishableDodge includes
* Dodge from dodge rating
* Dodge from additional defense
* Dodge from non-base agility
]]
---@return number diminishableDodge The part that is affected by diminishing returns.
---@return number drFreeDodge The part that isn't affected by diminishing returns.
function StatLogic:GetDodgeChanceBeforeDR()
	local agility, _, posBuff, negBuff = UnitStat("player", LE_UNIT_STAT_AGILITY)
	local baseAgi = agility - posBuff - negBuff

	local diminishableDodge = GetCombatRatingBonus(CR_DODGE)
		+ floor(GetCombatRatingBonus(CR_DEFENSE_SKILL) or 0) * 0.04
		+ (agility - baseAgi) * self:GetStatMod("ADD_DODGE_MOD_AGI")

	local drFreeDodge = GetDodgeChance() - self:GetAvoidanceAfterDR(StatLogic.Stats.Dodge, diminishableDodge)

	return diminishableDodge, drFreeDodge
end

---@return number parry Parry percentage per strength
function StatLogic:GetParryPerStr()
	-- Collect data
	local P_dr = GetParryChance()
	if P_dr == 0 then
		return 0
	end
	local parryFromParryRating = GetCombatRatingBonus(CR_PARRY)
	local P_r = parryFromParryRating
	local P_b = self:GetStatMod("ADD_PARRY")
	local stat, effectiveStat, posBuff, negBuff = UnitStat("player", LE_UNIT_STAT_STRENGTH)
	local modStr = 1
	-- if addon.ModStrClasses[addon.class] then
	-- 	modStr = self:GetStatMod("MOD_STR")
	-- 	-- Talents that modify Str will not add to posBuff, so we need to calculate baseStr
	-- 	-- But Str from Kings etc. will add to posBuff, so we subtract those if present
	-- 	for _, case in ipairs(StatLogic.StatModTable["ALL"]["MOD_STR"]) do
	-- 		if case.group == addon.ExclusiveGroup.AllStats then
	-- 			if StatLogic:GetAuraInfo(case.aura, true) then
	-- 				modStr = modStr - case.value
	-- 			end
	-- 		end
	-- 	end
	-- end
	local A = effectiveStat
	local A_b = ceil((stat - posBuff - negBuff) / modStr)
	local A_g = A - A_b
	local C = addon.C_p[addon.class]
	local k = addon.K[addon.class]
	-- Solve a*x^2+b*x+c
	local a = -A_g*A_b
	local b = A_g*(P_dr-P_b)-A_b*(P_r+C*k)-C*A_g
	local c = (P_dr-P_b)*(P_r+C*k)-C*P_r

	local parryPerStr
	if a == 0 then
		parryPerStr = -c / b
	else
		parryPerStr = (-b-(b^2-4*a*c)^0.5)/(2*a)
	end

	return parryPerStr
end

--[[
Calculates your current Parry% before diminishing returns.
Parry% = diminishableParry + drFreeParry

drFreeParry includes:
* Base parry
* Parry from base strength
* Parry modifier from base defense
* Parry modifers from talents or spells

diminishableParry includes
* Parry from parry rating
* Parry from additional defense
* Parry from non-base strength
]]
---@return number diminishableParry The part that is affected by diminishing returns.
---@return number drFreeParry The part that isn't affected by diminishing returns.
function StatLogic:GetParryChanceBeforeDR()
	local strength, _, posBuff, negBuff = UnitStat("player", LE_UNIT_STAT_STRENGTH)
	local baseStr = strength - posBuff - negBuff

	local diminishableParry = GetCombatRatingBonus(CR_PARRY)
		+ floor(GetCombatRatingBonus(CR_DEFENSE_SKILL) or 0) * 0.04
		+ (strength - baseStr) * self:GetStatMod("ADD_PARRY_MOD_STR")

	local drFreeParry = GetParryChance() - self:GetAvoidanceAfterDR(StatLogic.Stats.Parry, diminishableParry)

	return diminishableParry, drFreeParry
end

---@return number diminishableBlockChance The part that is affected by diminishing returns.
---@return number drFreeBlockChance The part that isn't affected by diminishing returns.
function StatLogic:GetBlockChanceBeforeDR()
	local diminishableBlockChance = GetMastery() * self:GetStatMod("ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT")
		+ floor(GetCombatRatingBonus(CR_DEFENSE_SKILL) or 0) * 0.04

	local drFreeBlockChance = GetBlockChance() - self:GetAvoidanceAfterDR(StatLogic.Stats.BlockChance, diminishableBlockChance)

	return diminishableBlockChance, drFreeBlockChance
end

--[[
Avoidance DR formula and k, C_p, C_d constants derived by Whitetooth (hotdogee [at] gmail [dot] com)
avoidanceBeforeDR is the part that is affected by diminishing returns.
See :GetClassIdOrName(class) for valid class values.

Calculates the avoidance after diminishing returns, this includes:
* Dodge from Dodge Rating, Defense, Agility.
* Parry from Parry Rating, Defense.
* Chance to be missed from Defense.

The DR formula: 1/x' = 1/c+k/x
* x' is the diminished stat before converting to IEEE754.
* x is the stat before diminishing returns.
* c is the cap of the stat, and changes with class.
* k is is a value that changes with class.

Formula details:
* DR for Dodge, Parry, Miss are calculated separately.
* Base avoidances are not affected by DR, (ex: Dodge from base Agility)
* Death Knight's Parry from base Strength is affected by DR, base for parry is 5%.
* Direct avoidance gains from talents and spells(ex: Evasion) are not affected by DR.
* Indirect avoidance gains from talents and spells(ex: +Agility from Kings) are affected by DR
* c and k values depend on class but does not change with level.
]]
---@param stat `StatLogic.Stats.Dodge`|`StatLogic.Stats.Parry`|`StatLogic.Stats.Miss|`StatLogic.Stats.BlockChance`
---@param avoidanceBeforeDR number Amount of avoidance before diminishing returns in percentages.
---@return number avoidanceAfterDR Avoidance after diminishing returns in percentages.
function StatLogic:GetAvoidanceAfterDR(stat, avoidanceBeforeDR)
	local C = addon.C_d
	if stat == StatLogic.Stats.Parry then
		C = addon.C_p
	elseif stat == StatLogic.Stats.Miss then
		C = addon.C_m
	elseif stat == StatLogic.Stats.BlockChance then
		C = addon.C_b
		-- See https://sacreddutydotnet.wordpress.com/2012/09/14/avoidance-diminishing-returns-in-mop-followup-2/
		avoidanceBeforeDR = math.floor(128 * avoidanceBeforeDR + 0.5) / 128
	end

	if C and avoidanceBeforeDR > 0 then
		local class = addon.class
		return 1 / (1 / C[class] + addon.K[class] / avoidanceBeforeDR)
	elseif avoidanceBeforeDR > 0 then
		return avoidanceBeforeDR
	else
		return 0
	end
end

-- Calculates the avoidance gain after diminishing returns with player's current stats.
---@param stat `StatLogic.Stats.Dodge`|`StatLogic.Stats.Parry`|`StatLogic.Stats.Miss`|`StatLogic.Stats.BlockChance`
---@param gainBeforeDR number Avoidance gain before diminishing returns in percentages.
---@return number gainAfterDR Avoidance gain after diminishing returns in percentages.
function StatLogic:GetAvoidanceGainAfterDR(stat, gainBeforeDR)
	if stat == StatLogic.Stats.Parry then
		local modAvoidance, drFreeAvoidance = self:GetParryChanceBeforeDR()
		local newAvoidanceChance = self:GetAvoidanceAfterDR(stat, modAvoidance + gainBeforeDR) + drFreeAvoidance
		if newAvoidanceChance < 0 then newAvoidanceChance = 0 end
		return newAvoidanceChance - GetParryChance()
	elseif stat == StatLogic.Stats.Dodge then
		local modAvoidance, drFreeAvoidance = self:GetDodgeChanceBeforeDR()
		local newAvoidanceChance = self:GetAvoidanceAfterDR(stat, modAvoidance + gainBeforeDR) + drFreeAvoidance
		if newAvoidanceChance < 0 then newAvoidanceChance = 0 end -- because GetDodgeChance() is 0 when negative
		return newAvoidanceChance - GetDodgeChance()
	elseif stat == StatLogic.Stats.Miss then
		local modAvoidance = self:GetMissChanceBeforeDR()
		return self:GetAvoidanceAfterDR(stat, modAvoidance + gainBeforeDR) - self:GetAvoidanceAfterDR(stat, modAvoidance)
	elseif stat == StatLogic.Stats.BlockChance then
		local modAvoidance, drFreeAvoidance = self:GetBlockChanceBeforeDR()
		local newAvoidanceChance = self:GetAvoidanceAfterDR(stat, modAvoidance + gainBeforeDR) + drFreeAvoidance
		if newAvoidanceChance < 0 then newAvoidanceChance = 0 end
		return newAvoidanceChance - GetBlockChance()
	else
		return gainBeforeDR
	end
end

function StatLogic:GetResilienceEffectGainAfterDR(gainBeforeDR)
	local currentResilienceBeforeDR = self:GetEffectFromRating(GetCombatRating(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN), StatLogic.Stats.ResilienceRating)
	local currentResilienceAfterDR = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	return self:GetResilienceEffectAfterDR(currentResilienceBeforeDR + gainBeforeDR) - currentResilienceAfterDR
end