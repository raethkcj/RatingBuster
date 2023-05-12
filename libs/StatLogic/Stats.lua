local _, addonTable = ...

---@class Stat
local Stat = {
	-- Should the stat be shown in summaries, or when broken down from a parent Stat
	---@type boolean
	show = true,
}

function Stat:new(stat)
	stat = setmetatable(stat, self)
	self.__index = self

	return stat
end

local stats = {
	-- Basic Attributes
	Strength = {},
	Agility = {},
	Stamina = {},
	Intellect = {},
	Spirit = {},
	AllStats = { show = false },

	-- Resources
	Health = {},
	Mana = {},
	ManaRegen = {},
	HealthRegen = {},
	ManaRegenWhileCasting = {},
	HealthRegenInCombat = {},

	-- Generic Offensive Stats
	HitRating = { show = false },
	CritRating = { show = false },
	HasteRating = { show = false },

	-- Physical Stats
	AttackPower = {},
	IgnoreArmor = {},
	ArmorPenetration = {},
	ArmorPenetrationRating = {},

	-- Weapon Stats
	WeaponDamageMin = {},
	WeaponDamageMax = {},
	WeaponDPS = {},

	-- Melee Stats
	MeleeHit = {},
	MeleeHitRating = {},
	MeleeCrit = {},
	MeleeCritRating = {},
	MeleeHaste = {},
	MeleeHasteRating = {},

	DodgeReduction = {},
	ParryReduction = {},
	WeaponSkill = {},
	Expertise = {},
	ExpertiseRating = {},

	-- Ranged Stats
	RangedAttackPower = {},
	RangedHit = {},
	RangedHitRating = {},
	RangedCrit = {},
	RangedCritRating = {},
	RangedHaste = {},
	RangedHasteRating = {},

	-- Spell Stats
	SpellDamage = {},
	HealingPower = {},
	SpellPenetration = {},

	HolyDamage = {},
	FireDamage = {},
	NatureDamage = {},
	FrostDamage = {},
	ShadowDamage = {},
	ArcaneDamage = {},

	SpellHit = {},
	SpellHitRating = {},
	SpellCrit = {},
	SpellCritRating = {},
	SpellHaste = {},
	SpellHasteRating = {},

	-- Tank Stats
	Armor = {},
	BonusArmor = { show = false },

	Dodge = {},
	DodgeBeforeDR = { show = false },
	DodgeRating = {},
	Parry = {},
	ParryBeforeDR = { show = false },
	ParryRating = {},
	BlockChance = {},
	BlockRating = {},
	BlockValue = {},
	Miss = {},

	Defense = {},
	DefenseRating = {},
	CritChanceReduction = {},
	CritDamageReduction = {},
	DOTDamageReduction = {},
	DamageReduction = {},
	Resilience = {},

	HolyResistance = {},
	FireResistance = {},
	NatureResistance = {},
	FrostResistance = {},
	ShadowResistance = {},
	ArcaneResistance = {},
}

---@type { [string]: Stat }
addonTable.Stats = {}
for name, stat in pairs(stats) do
	addonTable.Stats[name] = Stat:new(stat)
end