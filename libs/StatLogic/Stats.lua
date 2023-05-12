local addonName = ...

---@class StatLogic
local StatLogic = LibStub(addonName)

---@class Stat
local Stat = {
	-- Should the stat be shown in summaries, or when broken down from a parent Stat
	---@type boolean
	show = true,
}

---@param stat table?
---@return Stat
function Stat:new(stat)
	stat = stat or {}
	stat = setmetatable(stat, self)
	self.__index = self

	return stat
end

---@type { [string]: Stat }
StatLogic.Stats = {
	-- Basic Attributes
	Strength = Stat:new(),
	Agility = Stat:new(),
	Stamina = Stat:new(),
	Intellect = Stat:new(),
	Spirit = Stat:new(),
	AllStats = Stat:new({ show = false }),

	-- Resources
	Health = Stat:new(),
	Mana = Stat:new(),
	ManaRegen = Stat:new(),
	HealthRegen = Stat:new(),
	ManaRegenWhileCasting = Stat:new(),
	HealthRegenInCombat = Stat:new(),

	-- Generic Offensive Stats
	HitRating = Stat:new({ show = false }),
	CritRating = Stat:new({ show = false }),
	HasteRating = Stat:new({ show = false }),

	-- Physical Stats
	AttackPower = Stat:new(),
	IgnoreArmor = Stat:new(),
	ArmorPenetration = Stat:new(),
	ArmorPenetrationRating = Stat:new(),

	-- Weapon Stats
	WeaponDamageMin = Stat:new(),
	WeaponDamageMax = Stat:new(),
	WeaponDPS = Stat:new(),

	-- Melee Stats
	MeleeHit = Stat:new(),
	MeleeHitRating = Stat:new(),
	MeleeCrit = Stat:new(),
	MeleeCritRating = Stat:new(),
	MeleeHaste = Stat:new(),
	MeleeHasteRating = Stat:new(),

	DodgeReduction = Stat:new(),
	ParryReduction = Stat:new(),
	WeaponSkill = Stat:new(),
	Expertise = Stat:new(),
	ExpertiseRating = Stat:new(),

	-- Ranged Stats
	RangedAttackPower = Stat:new(),
	RangedHit = Stat:new(),
	RangedHitRating = Stat:new(),
	RangedCrit = Stat:new(),
	RangedCritRating = Stat:new(),
	RangedHaste = Stat:new(),
	RangedHasteRating = Stat:new(),

	-- Spell Stats
	SpellDamage = Stat:new(),
	HealingPower = Stat:new(),
	SpellPenetration = Stat:new(),

	HolyDamage = Stat:new(),
	FireDamage = Stat:new(),
	NatureDamage = Stat:new(),
	FrostDamage = Stat:new(),
	ShadowDamage = Stat:new(),
	ArcaneDamage = Stat:new(),

	SpellHit = Stat:new(),
	SpellHitRating = Stat:new(),
	SpellCrit = Stat:new(),
	SpellCritRating = Stat:new(),
	SpellHaste = Stat:new(),
	SpellHasteRating = Stat:new(),

	-- Tank Stats
	Armor = Stat:new(),
	BonusArmor = Stat:new({ show = false }),

	Dodge = Stat:new(),
	DodgeBeforeDR = Stat:new({ show = false }),
	DodgeRating = Stat:new(),
	Parry = Stat:new(),
	ParryBeforeDR = Stat:new({ show = false }),
	ParryRating = Stat:new(),
	BlockChance = Stat:new(),
	BlockRating = Stat:new(),
	BlockValue = Stat:new(),
	Miss = Stat:new(),

	Defense = Stat:new(),
	DefenseRating = Stat:new(),
	CritChanceReduction = Stat:new(),
	CritDamageReduction = Stat:new(),
	DOTDamageReduction = Stat:new(),
	DamageReduction = Stat:new(),
	Resilience = Stat:new(),

	HolyResistance = Stat:new(),
	FireResistance = Stat:new(),
	NatureResistance = Stat:new(),
	FrostResistance = Stat:new(),
	ShadowResistance = Stat:new(),
	ArcaneResistance = Stat:new(),
}