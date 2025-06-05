local addonName = ...

---@class StatLogic
local StatLogic = LibStub(addonName)

---@class Stat
---@field name string
---@field dependents? table<Stat, number> This Stat's dependent Stats mapped to the rate at which they are inherited
---@field modifier? number The total multiplicative modifers on this stat
---@field value? number The total flat amount of this stat
---@field show boolean -- Should the stat be shown in summaries, or when broken down from a parent Stat
---@field isPercent boolean -- Whether values of the stat represent a percentage
local Stat = {
	show = true,
	isPercent = false,
}

---@param stat table?
---@return Stat
function Stat:new(stat)
	stat = stat or {}
	stat = setmetatable(stat, self)
	self.__index = self

	return stat
end

function Stat:__tostring()
	return self.name
end

function Stat:AddDependent(stat, value)
	self.dependents = self.dependents or {}
	self.dependents[stat] = (self.dependents[stat] or 0) + value
end

function Stat:RemoveDependent(stat, value)
	if self.dependents and self.dependents[stat] then
		self.dependents[stat] = (self.dependents[stat] or 0) - value
	end
end

function Stat:ApplyModifier(value)
	self.modifier = (self.modifier or 1) * (1 + value)
end

function Stat:RemoveModifier(value)
	self.modifier = (self.modifier or 1) / (1 + value)
end

function Stat:AddValue(value)
	self.value = (self.value or 0) + value
end

function Stat:RemoveValue(value)
	self.value = (self.value or 0) - value
end

StatLogic.Stats = setmetatable({}, {
	__newindex = function(t, name, stat)
		stat.name = name
		rawset(t, name, stat)
	end
})

-- Basic Attributes
StatLogic.Stats.Strength = Stat:new()
StatLogic.Stats.Agility = Stat:new()
StatLogic.Stats.Stamina = Stat:new()
StatLogic.Stats.Intellect = Stat:new()
StatLogic.Stats.Spirit = Stat:new()
StatLogic.Stats.Mastery = Stat:new()
StatLogic.Stats.MasteryEffect = Stat:new({ isPercent = true })
StatLogic.Stats.MasteryRating = Stat:new()

-- Resources
StatLogic.Stats.Health = Stat:new()
StatLogic.Stats.Mana = Stat:new()
StatLogic.Stats.NormalManaRegen = Stat:new({ show = false })
StatLogic.Stats.GenericManaRegen = Stat:new({ show = false })
StatLogic.Stats.ManaRegen = Stat:new()
StatLogic.Stats.HealthRegen = Stat:new()
StatLogic.Stats.ManaRegenNotCasting = Stat:new()
StatLogic.Stats.ManaRegenOutOfCombat = Stat:new()
StatLogic.Stats.HealthRegenOutOfCombat = Stat:new()

-- Generic Stats
StatLogic.Stats.AllStats = Stat:new({ show = false })
StatLogic.Stats.Hit = Stat:new({ show = false })
StatLogic.Stats.HitRating = Stat:new({ show = false })
StatLogic.Stats.Crit = Stat:new({ show = false })
StatLogic.Stats.CritRating = Stat:new({ show = false })
StatLogic.Stats.Haste = Stat:new({ show = false })
StatLogic.Stats.HasteRating = Stat:new({ show = false })
StatLogic.Stats.GenericAttackPower = Stat:new({ show = false })
StatLogic.Stats.FeralAttackPower = Stat:new({ show = false })

-- Physical Stats
StatLogic.Stats.AttackPower = Stat:new()
StatLogic.Stats.IgnoreArmor = Stat:new()
StatLogic.Stats.ArmorPenetration = Stat:new({ isPercent = true })
StatLogic.Stats.ArmorPenetrationRating = Stat:new()

-- Weapon Stats
StatLogic.Stats.MinWeaponDamage = Stat:new()
StatLogic.Stats.MaxWeaponDamage = Stat:new()
StatLogic.Stats.AverageWeaponDamage = Stat:new()
StatLogic.Stats.WeaponDPS = Stat:new()

-- Melee Stats
StatLogic.Stats.MeleeHit = Stat:new({ isPercent = true })
StatLogic.Stats.MeleeHitRating = Stat:new()
StatLogic.Stats.MeleeCrit = Stat:new({ isPercent = true })
StatLogic.Stats.MeleeCritRating = Stat:new()
StatLogic.Stats.MeleeHaste = Stat:new({ isPercent = true })
StatLogic.Stats.MeleeHasteRating = Stat:new()

StatLogic.Stats.WeaponSkill = Stat:new()
StatLogic.Stats.Expertise = Stat:new()
StatLogic.Stats.ExpertiseRating = Stat:new()
StatLogic.Stats.DodgeReduction = Stat:new({ isPercent = true })
StatLogic.Stats.ParryReduction = Stat:new({ isPercent = true })

-- Ranged Stats
StatLogic.Stats.RangedAttackPower = Stat:new()
StatLogic.Stats.RangedHit = Stat:new({ isPercent = true })
StatLogic.Stats.RangedHitRating = Stat:new()
StatLogic.Stats.RangedCrit = Stat:new({ isPercent = true })
StatLogic.Stats.RangedCritRating = Stat:new()
StatLogic.Stats.RangedHaste = Stat:new({ isPercent = true })
StatLogic.Stats.RangedHasteRating = Stat:new()

-- Spell Stats
StatLogic.Stats.SpellPower = Stat:new()
StatLogic.Stats.SpellDamage = Stat:new()
StatLogic.Stats.HealingPower = Stat:new()
StatLogic.Stats.SpellPenetration = Stat:new()

StatLogic.Stats.HolyDamage = Stat:new()
StatLogic.Stats.FireDamage = Stat:new()
StatLogic.Stats.NatureDamage = Stat:new()
StatLogic.Stats.FrostDamage = Stat:new()
StatLogic.Stats.ShadowDamage = Stat:new()
StatLogic.Stats.ArcaneDamage = Stat:new()

StatLogic.Stats.SpellHit = Stat:new({ isPercent = true })
StatLogic.Stats.SpellHitRating = Stat:new()
StatLogic.Stats.SpellCrit = Stat:new({ isPercent = true })
StatLogic.Stats.SpellCritRating = Stat:new()
StatLogic.Stats.SpellHaste = Stat:new({ isPercent = true })
StatLogic.Stats.SpellHasteRating = Stat:new()

-- Tank Stats
StatLogic.Stats.Armor = Stat:new()
StatLogic.Stats.BonusArmor = Stat:new({ show = false })

StatLogic.Stats.Avoidance = Stat:new({ isPercent = true })
StatLogic.Stats.Dodge = Stat:new({ isPercent = true })
StatLogic.Stats.DodgeBeforeDR = Stat:new({ show = false, isPercent = true })
StatLogic.Stats.DodgeRating = Stat:new()
StatLogic.Stats.Parry = Stat:new({ isPercent = true })
StatLogic.Stats.ParryBeforeDR = Stat:new({ show = false, isPercent = true })
StatLogic.Stats.ParryRating = Stat:new()
StatLogic.Stats.BlockChance = Stat:new({ isPercent = true })
StatLogic.Stats.BlockChanceBeforeDR = Stat:new({ show = false, isPercent = true })
StatLogic.Stats.BlockRating = Stat:new()
StatLogic.Stats.BlockValue = Stat:new()
StatLogic.Stats.Miss = Stat:new({ isPercent = true })
StatLogic.Stats.MissBeforeDR = Stat:new({ isPercent = true })

StatLogic.Stats.Defense = Stat:new()
StatLogic.Stats.DefenseRating = Stat:new()
StatLogic.Stats.CritAvoidance = Stat:new({ isPercent = true })

StatLogic.Stats.Resilience = Stat:new({ isPercent = true })
StatLogic.Stats.ResilienceBeforeDR = Stat:new({ isPercent = true })
StatLogic.Stats.ResilienceRating = Stat:new()
StatLogic.Stats.CritDamageReduction = Stat:new({ isPercent = true })
StatLogic.Stats.PvPDamageReduction = Stat:new({ isPercent = true })
StatLogic.Stats.PvPPower = Stat:new({ isPercent = true })
StatLogic.Stats.PvPPowerRating = Stat:new()

StatLogic.Stats.HolyResistance = Stat:new()
StatLogic.Stats.FireResistance = Stat:new()
StatLogic.Stats.NatureResistance = Stat:new()
StatLogic.Stats.FrostResistance = Stat:new()
StatLogic.Stats.ShadowResistance = Stat:new()
StatLogic.Stats.ArcaneResistance = Stat:new()