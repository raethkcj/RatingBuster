#!/usr/bin/env -S node --import=tsx

import { existsSync, mkdirSync, writeFileSync } from 'node:fs'
import path from 'node:path'

import { DuckDBInstance } from '@duckdb/node-api'

enum Expansion {
	Vanilla = 1,
	TBC,
	Wrath,
	Cata,
	MoP
}

{
	type ProductBuilds = { [product: string]: { version: string }[] }
	let productBuilds: Promise<ProductBuilds>
	async function fetchProductBuilds() {
		if (!productBuilds) {
			productBuilds = fetch("https://wago.tools/api/builds").then(response => response.json()) as Promise<ProductBuilds>
		}

		return productBuilds
	}

	const publicProducts = new Set<string> ([
		"wow_classic",
		"wow_classic_ptr",
		"wow_classic_era",
		"wow_classic_era_ptr",
		"wow_classic_beta",
	])

	class Version {
		constructor(
			public version = "",
			public expansion = "",
			public major = "",
			public minor = "",
			public buildNumber = "",
		) {}

		gte(other: Version): boolean {
			return this.expansion >= other.expansion
				&& this.major >= other.major
				&& this.minor >= other.minor
				&& this.buildNumber >= other.buildNumber
		}
	}

	var getLatestVersion = async function(expansion: Expansion) {
		const productBuilds = await fetchProductBuilds()
		let max = new Version()
		for (const product of publicProducts) {
			const builds = productBuilds[product]
			const build = builds.find(b => b.version.startsWith(`${expansion}.`))
			const version = build?.version
			if (version) {
				const current = new Version(version, ...version.split("."))
				if (current.gte(max)) {
					max = current
				}
			}
		}
		if (max.version != "") {
			console.log(`Found version ${max.version} for expansion ${Expansion[expansion]}`)
			return max.version
		} else {
			throw new Error(`Couldn't find any public build for expansion ${Expansion[expansion]}`)
		}
	}
}

class StatEntry {
	entries: (StatValue[] | false)[] = []
	isWholeText = false
	ignoreSum = false

	constructor(public id: number, public isEnchant: boolean) {}

	equals(other: StatEntry): boolean {
		if (this.entries.length != other.entries.length) {
			return false
		} else if (this.isWholeText != other.isWholeText) {
			return false
		}

		for (const [i, entry] of Object.entries(this.entries)) {
			const otherEntry: (StatValue[] | false) = other.entries[i]
			if (typeof entry != typeof otherEntry) {
				return false
			} else if (entry === false && otherEntry === false) {
				continue
			} else if ((entry as StatValue[]).length != (otherEntry as StatValue[]).length) {
				return false
			}

			// We know both entries are StatValue[] of same length, even though TypeScript doesn't
			for (const [j, sv] of Object.entries(entry as StatValue[])) {
				const otherSV = (otherEntry as StatValue[])[j] as StatValue
				if (this.isWholeText && sv.value != otherSV.value) {
					// WholeTextLookup requires matching values
					return false
				} else if (sv.stat != otherSV.stat) {
					// StatIDLookup only requires matching stats
					return false
				}
			}
		}

		return true
	}
}

function mapTextToStatEntry(text: string, statEffects: StatValue[][] | undefined, id: number, spellStatEffects: Map<number, StatValue[][]>, isEnchant: boolean): [string, StatEntry] {
	text = text.replace(/[\s.]+$/, "").replaceAll(/[\r\n]+/gm, "\\n").replaceAll(/"/gm, "\\\"").toLowerCase()

	const remainingEffects: StatValue[][] = statEffects ? [...statEffects] : []

	const statEntry = new StatEntry(id, isEnchant)
	const entries = statEntry.entries
	let matches = 0
	// Only used for auto-incrementing enchant indentifier $i
	let i = 0
	// Matches an optional leading + or -, plus one of:
	//   Interpolated math expression ${...}
	//   Replacement token:
	//     Leading $
	//     Optional divisor /25;
	//     Optional spellID override
	//     An identifier from: https://wowdev.wiki/Spells#Known_identifiers
	//     Optional integer indicating SpellEffect Index
	//   Literal number:
	//     Digits 0-9 or decimal point ".", ends in digit
	const pattern = text.replace(/[+-]?(?:\$(?:(\{.*?\})|(?:[/*]\d+;)?(\d*)([befkopqtwx](?=\d)|[acdg-jlmnrsuvyz])(\d?))|([\d\.]+(?<=\d)))/g, function(_match, expression: string, alternateSpellID: string, identifier: string, identifierIndex: string, plainNumber: string, _offset: number, input: string) {
		if (expression || plainNumber) {
			// We can't directly identify which effectIndex this number is, so save it for later
			entries.push([new StatValue('Placeholder', parseInt(plainNumber) || 0)])
		} else {
			// These are mostly Spell identifiers: https://wowdev.wiki/Spells#Known_identifiers
			// SpellItemEnchantment uses a partially separate set of identifiers
			// $i is the only one that needs to be handled for now, maps to effects in order:
			// https://wago.tools/db2/SpellItemEnchantment?build=4.4.2.60192&filter[ID]=2906|2807
			switch (identifier) {
				case "k":
				case "m":
				case "o":
				case "s":
				case "w":
					// Since we only parse effects with a range of 0 or 1,
					// we can treat min, max and spread identically
					let newStatEffects: StatValue[][] | undefined = undefined
					if (alternateSpellID) {
						const alternateStatEffects = spellStatEffects.get(parseInt(alternateSpellID))
						if (alternateStatEffects) {
							newStatEffects = alternateStatEffects
						} else {
							entries.push(false)
							break
						}
					} else if (statEffects) {
						newStatEffects = statEffects
					}

					const effectIndex = identifierIndex ? parseInt(identifierIndex) - 1 : 0
					const statValues = newStatEffects ? newStatEffects[effectIndex] : undefined
					if (statValues) {
						entries.push([...statValues])
						if (!alternateSpellID) {
							delete remainingEffects[effectIndex]
						}
					} else {
						entries.push(false)
					}
					break
				case "i":
					if (isEnchant) {
						const statValues = statEffects ? statEffects[i] : undefined
						if (statValues) {
							entries.push([...statValues])
							delete remainingEffects[i]
						} else {
							entries.push(false)
						}
						i++
					} else {
						entries.push(false)
					}
					break
				case "d":
					entries.push(false)
					return "%s sec"
				case "a":
				case "c":
				case "h":
				case "n":
				case "r":
				case "t":
				case "u":
				case "x":
					// Confirmed non-stats
					entries.push(false)
					break
				case "g":
				case "l":
					console.warn(`Unhandled conditional identifier ${identifier} in '${input}'`)
					entries.push(false)
					break
				case undefined:
					console.error(`Undefined identifier, expression, and number in '${input}'`)
					break
				default:
					console.warn(`Unhandled identifier ${identifier} in '${input}'`)
					entries.push(false)
					break
			}
		}
		matches++
		return "%s"
	})

	// If the spell had more effects than could be matched by identifiers,
	// attempt to map the remaining effects to already-assigned
	// StatEntries with the same value, including Placeholders
	for (const [i, effect] of remainingEffects.entries()) {
		if (effect) {
			for (const statValue of effect) {
				const entry = entries.find((e, j) => {
					return e && e.find(sv => {
						return (
							!statValue.isOverride
							&& sv.value === statValue.value
							&& (
								!isEnchant
								|| e[0].stat === 'Placeholder'
								|| effect.length > 1
								|| statGroups.get(sv.stat)?.has(statValue.stat)
							)
						) || statValue.isOverride && i === j
					}) && !e.find(sv => {
						return sv.stat === statValue.stat
					})
				})
				if (entry) {
					if (entry[0].stat === 'Placeholder') {
						entry[0] = statValue
					} else {
						entry.push(statValue)
					}
				}
			}
		}
	}

	// Map any remaining Placeholders to false (meaning the number does not represent a stat)
	for (const [i, entry] of Object.entries(entries)) {
		if (entry) {
			const plainNumberIndex = entry.findIndex(sv => sv.stat === 'Placeholder')
			if (plainNumberIndex >= 0) {
				if (entry.length > 1) {
					console.warn("Unexpected Placeholder in multi-stat StatEntry")
				} else {
					entries[i] = false
				}
			}
		}
	}

	// We didn't match any numbers, so mark it as whole text and assign *all* the stats
	if (pattern === text && matches === 0) {
		statEntry.isWholeText = true
		statEntry.entries = statEffects ? [statEffects.flat().filter(sv => sv.value !== 0)] : []
	}

	return [pattern, statEntry]
}

const base = import.meta.url
import statLocaleData from './StatLocaleData.json' with { type: "json" }
const databaseDirName = "DB2"

class DatabaseTable {
	path: string

	private constructor(
		public name: string,
		public expansion: Expansion,
		public locale: string,
		public fileName: string,
	) {
		this.path = path.join(DatabaseTable.directory, fileName)
	}

	static directory = "./DB2"
	static cache = new Map<string, Promise<DatabaseTable>>()

	static async get(name: string, expansion: Expansion, locale: string): Promise<DatabaseTable> {
		const fileName = `${name}_${expansion}_${locale}.csv`
		if (!this.cache.get(fileName)) {
			this.cache.set(fileName, new Promise<DatabaseTable>(async resolve => {
				const table = new DatabaseTable(name, expansion, locale, fileName)
				if (existsSync(table.path)) {
					console.log(`Found ${fileName}, skipping fetch.`)
				} else {
					console.log(`Fetching ${fileName}.`)
					const build = await getLatestVersion(expansion)
					const fetchUrl = `https://wago.tools/db2/${name}/csv?build=${build}&locale=${locale}`
					const response = await fetch(fetchUrl)
					if (response.ok) {
						const text = await response.text()
						writeFileSync(table.path, text)
						console.log(`Fetched ${fileName}.`)
					} else {
						throw new Error(`Failed to fetch ${table.path}: ${response.status} ${response.statusText}`)
					}
				}
				resolve(table)
			}))
		}

		return this.cache.get(fileName)!
	}
}

const instance = await DuckDBInstance.create()
const connection = await instance.connect()

// From wow.tools' enums.js, also obtainable at wowdev.wiki
enum ItemStat {
	Mana = 0,
	Health = 1,
	Agility = 3,
	Strength = 4,
	Intellect = 5,
	Spirit = 6,
	Stamina = 7,
	DefenseRating = 12,
	DodgeRating = 13,
	ParryRating = 14,
	BlockRating = 15,
	MeleeHitRating = 16,
	RangedHitRating = 17,
	SpellHitRating = 18,
	MeleeCritRating = 19,
	RangedCritRating = 20,
	SpellCritRating = 21,
	MeleeHasteRating = 28,
	RangedHasteRating = 29,
	SpellHasteRating = 30,
	HitRating = 31,
	CritRating = 32,
	ResilienceRating = 35,
	HasteRating = 36,
	ExpertiseRating = 37,
	GenericAttackPower = 38,
	RangedAttackPower = 39,
	Versatility = 40,
	HealingPower = 41,
	SpellDamage = 42,
	GenericManaRegen = 43,
	ArmorPenetrationRating = 44,
	SpellPower = 45,
	HealthRegen = 46,
	SpellPenetration = 47,
	MasteryRating = 49,
	BonusArmor = 50,
	FireResistance = 51,
	FrostResistance = 52,
	HolyResistance = 53,
	ShadowResistance = 54,
	NatureResistance = 55,
	ArcaneResistance = 56,
    PvpPowerRating = 57,
    // AmplifyRating = 58,
    // MultistrikeRating = 59,
    // ReadinessRating = 60,
    // SpeedRating = 61,
    // LifestealRating = 62,
    // AvoidanceRating = 63,
    // SturdinessRating = 64,
}

const statSets = [
	new Set([
		"MeleeHitRating",
		"RangedHitRating",
		"SpellHitRating",
	]),
	new Set([
		"MeleeCritRating",
		"RangedCritRating",
		"SpellCritRating",
	]),
	new Set([
		"MeleeHasteRating",
		"RangedHasteRating",
		"SpellHasteRating",
	]),
	new Set([
		"GenericManaRegen",
		"HealthRegen",
	]),
]

const statGroups = new Map<string, Set<string>>()
for (const set of statSets) {
	for (const stat of set) {
		statGroups.set(stat, set)
	}
}

enum EffectAura {
	PERIODIC_HEAL = 8,
	MOD_DAMAGE_DONE = 13, // School
	MOD_RESISTANCE = 22, // School
	MOD_STAT = 29, // PrimaryStats
	MOD_SKILL = 30, // SkillLine
	MOD_INCREASE_HEALTH = 34,
	MOD_INCREASE_POWER = 35,
	MOD_PARRY_PERCENT = 47,
	MOD_DODGE_PERCENT = 49,
	MOD_BLOCK_PERCENT = 51,
	MOD_WEAPON_CRIT_PERCENT = 52,
	MOD_HIT_CHANCE = 54,
	MOD_SPELL_HIT_CHANCE = 55,
	MOD_SPELL_CRIT_CHANCE = 57,
	MOD_CASTING_SPEED_NOT_STACK = 65,
	MOD_POWER_REGEN = 85, // MP5 when MiscValue0 = 0
	MOD_ATTACK_POWER = 99,
	MOD_TARGET_RESISTANCE = 123, // School
	MOD_RANGED_ATTACK_POWER = 124,
	MOD_HEALING_DONE = 135,
	MOD_MELEE_HASTE = 138,
	MOD_RANGED_HASTE = 140,
	MOD_HEALTH_REGEN_IN_COMBAT = 161,
	MOD_RATING = 189, // CombatRating
	MOD_SPELL_CRIT_CHANCE_SCHOOL = 552, // School
	MOD_SHIELD_BLOCKVALUE = 564,
	MOD_COMBAT_RESULT_CHANCE = 593,
}
const effectAuraValues = Object.values(EffectAura).slice(Object.values(EffectAura).length / 2)

const NegativeEffectAuras = new Set<EffectAura> ([
	EffectAura.MOD_COMBAT_RESULT_CHANCE,
	EffectAura.MOD_TARGET_RESISTANCE,
])

enum ProcEffectAura {
	PERIODIC_TRIGGER_SPELL = 23,
	PROC_TRIGGER_SPELL = 42,
	ADD_TARGET_TRIGGER = 109,
	PERIODIC_TRIGGER_SPELL_WITH_VALUE = 227,
	PROC_TRIGGER_SPELL_WITH_VALUE = 231,
}
const procAuraValues = Object.values(ProcEffectAura).slice(Object.values(ProcEffectAura).length / 2)

function GetPlainStat(...stat: string[]): () => string[] {
	return () => stat
}

enum School {
	Physical = 0x01,
	Holy = 0x02,
	Fire = 0x04,
	Nature = 0x08,
	Frost = 0x10,
	Shadow = 0x20,
	Arcane = 0x40,

	All = 0x7C,
}

function GetSchoolStat(statSuffix: string, physicalOverride: string, allSchoolsOverride?: string) {
	return (schools: number): string[] => {
		if (allSchoolsOverride && schools >= School.All) {
			return [allSchoolsOverride]
		} else {
			const stats: string[] = []
			for (const [key, value] of Object.entries(School)) {
				const school = Number(value)
				if ((schools & school) > 0 && school < School.All) {
					if (school === School.Physical) {
						stats.push(physicalOverride)
					} else if (statSuffix != "Resistance" || school != School.Holy) {
						stats.push(key + statSuffix)
					}
				}
			}
			return stats
		}
	}
}

enum PrimaryStat {
	AllStats = -1,
	Strength,
	Agility,
	Stamina,
	Intellect,
	Spirit,
}

function GetPrimaryStat() {
	return (primaryStatID: number): string[] => {
		const primaryStat = PrimaryStat[primaryStatID]
		return primaryStat ? [primaryStat] : []
	}
}

enum CombatRating {
	// CR_AMPLIFY = 0x00000001,
	DefenseRating = 0x00000002,
	DodgeRating = 0x00000004,
	ParryRating = 0x00000008,
	BlockRating = 0x00000010,
	MeleeHitRating = 0x00000020,
	RangedHitRating = 0x00000040,
	SpellHitRating = 0x00000080,
	MeleeCritRating = 0x00000100,
	RangedCritRating = 0x00000200,
	SpellCritRating = 0x00000400,
	// CR_CORRUPTION = 0x00000800,
	// CR_CORRUPTION_RESISTANCE = 0x00001000,
	// CR_SPEED = 0x00002000,
	ResilienceRating = 0x00004000,
	// CR_RESILIENCE_PLAYER_DAMAGE = 0x00008000,
	// CR_LIFESTEAL = 0x00010000,
	MeleeHasteRating = 0x00020000,
	RangedHasteRating = 0x00040000,
	SpellHasteRating = 0x00080000,
	// CR_AVOIDANCE = 0x00100000,
	// CR_STURDINESS = 0x00200000,
	// CR_UNUSED_7 = 0x00400000,
	ExpertiseRating = 0x00800000,
	ArmorPenetrationRating = 0x01000000,
	MasteryRating = 0x02000000,
	// CR_PVP_POWER = 0x04000000,
	// CR_CLEAVE = 0x08000000,
	// CR_VERSATILITY_DAMAGE_DONE = 0x10000000,
	// CR_VERSATILITY_HEALING_DONE = 0x20000000,
	// CR_VERSATILITY_DAMAGE_TAKEN = 0x40000000,
	// CR_UNUSED_12 = 0x80000000,
}

function GetCombatRatingStat() {
	return (ratings: number): string[] => {
		const stats: string[] = []
		for (const [key, value] of Object.entries(CombatRating)) {
			const rating = Number(value)
			if ((ratings & rating) > 0) {
				stats.push(key)
			}
		}
		return stats
	}
}

// We map all of Sword, Mace, etc. to generic WeaponSkill
const SkillLine = {
	95: 'Defense',
	43: 'WeaponSkill',
	44: 'WeaponSkill',
	45: 'WeaponSkill',
	46: 'WeaponSkill',
	54: 'WeaponSkill',
	55: 'WeaponSkill',
	136: 'WeaponSkill',
	160: 'WeaponSkill',
	162: 'WeaponSkill',
	172: 'WeaponSkill',
	173: 'WeaponSkill',
	176: 'WeaponSkill',
	226: 'WeaponSkill',
	228: 'WeaponSkill',
	229: 'WeaponSkill',
	473: 'WeaponSkill',
}

function GetSkillLineStat() {
	return (skillLineID: number): string[] => {
		const skillLine = SkillLine[skillLineID]
		return skillLine ? [skillLine] : []
	}
}

enum PowerType {
	Mana = 0,
}

function GetPowerTypeStat(statPrefix: string, statSuffix: string) {
	return (powerTypeID: number): string[] => {
		const powerType = PowerType[powerTypeID]
		return powerType ? [statPrefix + powerType + statSuffix] : []
	}
}

enum CombatResultType {
	Dodge = 2,
	Parry = 4,
}

function GetCombatResultStat(statSuffix: string) {
	return (combatResultTypeID: number): string[] => {
		const combatResultType = CombatResultType[combatResultTypeID]
		return combatResultType ? [combatResultType + statSuffix] : []
	}
}

const effectAuraStats: Record<EffectAura, (miscValue: number) => string[]> = {
	[EffectAura.PERIODIC_HEAL]: GetPlainStat("HealthRegen"),
	[EffectAura.MOD_DAMAGE_DONE]: GetSchoolStat("Damage", "AverageWeaponDamage", "SpellDamage"),
	[EffectAura.MOD_RESISTANCE]: GetSchoolStat("Resistance", "Armor"),
	[EffectAura.MOD_STAT]: GetPrimaryStat(),
	[EffectAura.MOD_SKILL]: GetSkillLineStat(),
	[EffectAura.MOD_INCREASE_HEALTH]: GetPlainStat("Health"),
	[EffectAura.MOD_INCREASE_POWER]: GetPowerTypeStat("", ""),
	[EffectAura.MOD_PARRY_PERCENT]: GetPlainStat("Parry"),
	[EffectAura.MOD_DODGE_PERCENT]: GetPlainStat("Dodge"),
	[EffectAura.MOD_BLOCK_PERCENT]: GetPlainStat("BlockChance"),
	[EffectAura.MOD_WEAPON_CRIT_PERCENT]: GetPlainStat("MeleeCrit", "RangedCrit"),
	[EffectAura.MOD_HIT_CHANCE]: GetPlainStat("MeleeHit", "RangedHit"),
	[EffectAura.MOD_SPELL_HIT_CHANCE]: GetPlainStat("SpellHit"),
	[EffectAura.MOD_SPELL_CRIT_CHANCE]: GetPlainStat("SpellCrit"),
	[EffectAura.MOD_CASTING_SPEED_NOT_STACK]: GetPlainStat("SpellHaste"),
	[EffectAura.MOD_POWER_REGEN]: GetPowerTypeStat("Generic", "Regen"),
	[EffectAura.MOD_ATTACK_POWER]: GetPlainStat("AttackPower"),
	[EffectAura.MOD_TARGET_RESISTANCE]: GetSchoolStat("Penetration", "ArmorPenetration", "SpellPenetration"),
	[EffectAura.MOD_RANGED_ATTACK_POWER]: GetPlainStat("RangedAttackPower"),
	[EffectAura.MOD_HEALING_DONE]: GetPlainStat("HealingPower"),
	[EffectAura.MOD_MELEE_HASTE]: GetPlainStat("MeleeHaste"),
	[EffectAura.MOD_RANGED_HASTE]: GetPlainStat("RangedHaste"),
	[EffectAura.MOD_HEALTH_REGEN_IN_COMBAT]: GetPlainStat("HealthRegen"),
	[EffectAura.MOD_RATING]: GetCombatRatingStat(),
	[EffectAura.MOD_SPELL_CRIT_CHANCE_SCHOOL]: GetPlainStat("SpellCrit"), // Technically school-specific, but very rare/impossible on items
	[EffectAura.MOD_SHIELD_BLOCKVALUE]: GetPlainStat("BlockValue"),
	[EffectAura.MOD_COMBAT_RESULT_CHANCE]: GetCombatResultStat("Reduction"),
}

enum EnchantEffect {
	Proc = 1,
	Damage,
	Buff,
	Resistance,
	Stat,
}

enum Resistance {
	BonusArmor = 0,
	HolyResistance,
	FireResistance,
	NatureResistance,
	FrostResistance,
	ShadowResistance,
	ArcaneResistance,
}

function getEnchantStats(enchant: StatEnchant, spellStatEffects: Map<number, StatValue[][]>): StatValue[][] {
	const stats: StatValue[][] = []
	for(const [index, effectvalues] of enchant.Effects.items.entries()) {
		const [effect, effectArg, pointsMin] = effectvalues.items
		switch(effect) {
			case EnchantEffect.Damage:
				stats[index] = [new StatValue("AverageWeaponDamage", pointsMin)]
				break
			case EnchantEffect.Buff:
				const buffStats = spellStatEffects.get(effectArg)?.flat()
				if (buffStats) {
					stats[index] = buffStats

					// Attack Power from enchants shouldn't be multiplied by WOTLK Druid's Predatory Instincts
					let apOverride: StatValue | undefined
					if (apOverride = buffStats.find(sv => sv.stat === "GenericAttackPower")) {
						apOverride.stat = "AttackPower"
						buffStats.push(new StatValue("RangedAttackPower", apOverride.value))
					}
				}
				break
			case EnchantEffect.Resistance:
				const resistance = Resistance[effectArg]
				if (resistance) stats[index] = [new StatValue(resistance, pointsMin)]
				break
			case EnchantEffect.Stat:
				const itemStat = ItemStat[effectArg]
				if (itemStat) stats[index] = [new StatValue(itemStat, pointsMin)]
				break
		}
	}
	return stats
}

const localeDirName = "locales"

const locales = [
	"enUS",
	"koKR",
	"frFR",
	"deDE",
	"zhCN",
	"esES",
	"zhTW",
	"esMX",
	"ruRU",
	"ptBR",
	"itIT",
] as const
type Locale = typeof locales[number]

type SpellEffect = {
	SpellID: number,
	EffectIndex: number,
	EffectAura: EffectAura,
	EffectBasePoints: number,
	EffectDieSides: number,
	EffectMiscValue_0: number,
	ProcSpellID: number,
}

async function queryStatSpellEffects(expansion: Expansion) {
	const spellEffect = await DatabaseTable.get("SpellEffect", expansion, "enUS")

	const query = `
		SELECT StatSpell.SpellID, StatSpell.EffectIndex, StatSpell.EffectAura, StatSpell.EffectBasePoints, StatSpell.EffectDieSides, StatSpell.EffectMiscValue_0, ProcSpell.SpellID AS ProcSpellID
		FROM read_csv('${spellEffect.path}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR']) StatSpell
		LEFT JOIN read_csv('${spellEffect.path}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR']) ProcSpell
		ON ProcSpell.EffectTriggerSpell = StatSpell.SpellID
		AND ProcSpell.EffectAura in (${procAuraValues})
		WHERE StatSpell.EffectAura in (${effectAuraValues})
		AND (StatSpell.EffectAuraPeriod = 5000 OR StatSpell.EffectAura != '${EffectAura.PERIODIC_HEAL}')
		AND (StatSpell.EffectMiscValue_0 = '${PowerType.Mana}' OR StatSpell.EffectAura != '${EffectAura.MOD_POWER_REGEN}')
		ORDER BY StatSpell.SpellID, ProcSpell.SpellID, StatSpell.EffectIndex
	`

	const reader = await connection.runAndReadAll(query)
	return reader.getRowObjects() as SpellEffect[]
}

type SpellDescription = {
	ID: number,
	Description_lang: string
}

async function queryStatSpellDescriptions(expansion: Expansion, locale: string, spellIDs: number[]): Promise<SpellDescription[]> {
	const spell = await DatabaseTable.get("Spell", expansion, locale)

	const query = `
		SELECT ID, Description_lang
		FROM read_csv('${spell.path}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR'])
		WHERE ID in (${spellIDs}) AND Description_lang NOT NULL
	`

	const reader = await connection.runAndReadAll(query)
	return reader.getRowObjects() as SpellDescription[]
}

// Parses conditional expressions in spell descriptions of the form
// "prefix $condition1[branch1]condition2[branch2][branch3] suffix"
// into all possible "prefix branchN suffix" forms, discarding the conditions.
// Similarly parses gender and plural conditional tokens:
// $ghis:her;
// $lломоть:ломтя:ломтей;
// Returns a flat array of all possible branches, including solely the original string if applicable.
function traverseDescriptionBranches(description: string): string[] {
	const branches = [description]
	const conditionPattern = /(?<!\()\$((?<expression>\?.*?\[)|(?<token>[gl]))/gi
	// Using g and y flags, in combination with setting lastIndex to conditionPattern's,
	// allows us to match expression/token bodies that immediately follow the opening condition
	const expressionPattern = /([^\]]*?)\](?:(?<continue>\?.*?\[|\[)|)/gys
	const tokenPattern = /([^:;]*?)(?:(?<continue>:)|;)/gy
	let i = 0
	while (i < branches.length) {
		const branch = branches[i]
		conditionPattern.lastIndex = 0
		const conditionMatch = conditionPattern.exec(branch)
		if (conditionMatch) {
			const branchPattern = conditionMatch.groups!.expression ? expressionPattern : tokenPattern
			branchPattern.lastIndex = conditionPattern.lastIndex

			let lastIndex = 0
			const branchTexts: string[] = []
			let branchMatch: RegExpExecArray | null
			do {
				branchMatch = branchPattern.exec(branch)
				if (branchMatch) {
					branchTexts.push(branchMatch[1])
					lastIndex = branchPattern.lastIndex
				}
			} while (branchMatch?.groups?.continue !== undefined)

			const prefix = branch.substring(0, conditionMatch.index)
			const suffix = branch.substring(lastIndex)

			let first = true
			for(const branchText of branchTexts) {
				const newBranch = prefix.concat(branchText, suffix)
				if (first) {
					branches[i] = newBranch
					first = false
				} else {
					branches.push(newBranch)
				}
			}
		} else {
			i++
		}
	}
	return branches
}

type StatEnchant = {
	ID: number
	Name_lang: string
	Effects: {
		items: {
			items: [effect: EnchantEffect, effectArg: number, pointsMin: number]
		}[]
	}

	stats: string[][]
}

async function queryStatEnchants(expansion: Expansion, locale: string, spellIDs: number[], overrideEnchantIDs: number[]): Promise<StatEnchant[]> {
	const spellItemEnchantment = await DatabaseTable.get("SpellItemEnchantment", expansion, locale)

	const query = `
		SELECT ID, Name_lang, [
			array_value(Effect_0, EffectArg_0, EffectPointsMin_0),
			array_value(Effect_1, EffectArg_1, EffectPointsMin_1),
			array_value(Effect_2, EffectArg_2, EffectPointsMin_2),
		] As Effects
		FROM read_csv('${spellItemEnchantment.path}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR'])
		WHERE
			ID IN (${overrideEnchantIDs.length > 0 ? overrideEnchantIDs : 'null'})
			OR Effect_0 = '${EnchantEffect.Buff}' AND EffectArg_0 IN (${spellIDs})
			OR Effect_1 = '${EnchantEffect.Buff}' AND EffectArg_1 IN (${spellIDs})
			OR Effect_2 = '${EnchantEffect.Buff}' AND EffectArg_2 IN (${spellIDs})
			OR Effect_0 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})
			OR Effect_1 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})
			OR Effect_2 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})

	`

	const reader = await connection.runAndReadAll(query)
	return reader.getRowObjects() as unknown as StatEnchant[]
}

class StatValue {
	constructor(public stat: string, public value: number, public isOverride: boolean = false) {}
}

function enumerateStatAndProcSpells(spellEffects: SpellEffect[]): [Map<number, StatValue[][]>, Map<number, number>] {
	const spellStatEffects = new Map<number, StatValue[][]>()
	const procSpells = new Map<number, number>()
	for (const effect of spellEffects) {
		const statEffects = spellStatEffects.get(effect.SpellID) || []

		if (!statEffects[effect.EffectIndex] && effect.EffectDieSides <= 1) {
			const effectAuraFunc = effectAuraStats[effect.EffectAura]
			const stats = effectAuraFunc ? effectAuraFunc(effect.EffectMiscValue_0) : null
			if (stats && stats.length > 0) {
				let value = effect.EffectBasePoints + effect.EffectDieSides

				if (NegativeEffectAuras.has(effect.EffectAura)) {
					value *= -1
				}

				let apOverride: number | undefined
				if (effect.EffectAura === EffectAura.MOD_ATTACK_POWER) {
					apOverride = statEffects.findIndex((se) => se?.find(sv => sv.stat === "RangedAttackPower"))
				} else if (effect.EffectAura === EffectAura.MOD_RANGED_ATTACK_POWER) {
					apOverride = statEffects.findIndex((se) => se?.find(sv => sv.stat === "AttackPower"))
				}

				if (apOverride != null && apOverride >= 0) {
					// If a spell provides both melee and ranged AP, combine them into GenericAttackPower.
					// This is necessary for WOTLK Druid's Predatory Strikes talent.
					statEffects[apOverride][0] = new StatValue("GenericAttackPower", value)
				} else {
					// May leave empty indices if a spell has non-stat effects prior to a stat effect
					statEffects[effect.EffectIndex] = stats.map((s) => new StatValue(s, value))
				}

				if (effect.ProcSpellID) {
					procSpells.set(effect.ProcSpellID, effect.SpellID)
				}
			}
		}

		if (statEffects.length > 0) {
			spellStatEffects.set(effect.SpellID, statEffects)
		}
	}

	return [spellStatEffects, procSpells]
}

function overrideSpells(spellStatEffects: Map<number, StatValue[][]>, spellDescIDs: Set<number>, expansion: Expansion) {
	for (const [sOverrideSpellID, overrideStatEffects] of Object.entries(statLocaleData["Spell"][expansion])) {
		const overrideSpellID = parseInt(sOverrideSpellID)
		spellDescIDs.add(overrideSpellID)
		const overrideStatValues = overrideStatEffects.map((effect) => {
			return effect.map(stat => new StatValue(stat, 0, true))
		})
		spellStatEffects.set(overrideSpellID, overrideStatValues)
	}
}

function getOverrideEnchants(expansion: Expansion): [number[], Map<number, StatValue[][]>] {
	const overrideEnchantIDs: number[] = []
	const overrideEnchantStatEffects = new Map<number, StatValue[][]>()

	for (const [sOverrideEnchantID, overrideStatEffects] of Object.entries(statLocaleData["SpellItemEnchantment"][expansion])) {
		overrideEnchantIDs.push(parseInt(sOverrideEnchantID))
		const overrideStatValues = overrideStatEffects.map((effect: string[]|{[stat: string]: number}) => {
			if (Array.isArray(effect)) {
				return effect.map(stat => new StatValue(stat, 0, true))
			} else {
				return Object.entries(effect).map(([s, v]) => new StatValue(s, v, true))
			}
		})
		overrideEnchantStatEffects.set(parseInt(sOverrideEnchantID), overrideStatValues)
	}

	return [overrideEnchantIDs, overrideEnchantStatEffects]
}

const localeBlacklist = new Map<Locale, Set<string>>()
for (const locale of locales) {
	localeBlacklist.set(locale, new Set())
}

function insertEntry(statMap: Map<string, StatEntry>, text: string, statEntry: StatEntry, locale: Locale) {
	if (!statEntry.entries.find(e => e && e.length > 0)) return
	const blacklist = localeBlacklist.get(locale)!
	const existingEntry = statMap.get(text)
	if (existingEntry) {
		// Blizzard's tables contain a lot of inconsistent data,
		// so we apply several heuristics to choose the most accurate mappings

		// Prefer StatIDLookup over WholeTextLookup
		if (!statEntry.isWholeText && existingEntry.isWholeText) {
			statMap.set(text, statEntry)
			return
		} else if (statEntry.isWholeText && !existingEntry.isWholeText) {
			return
		}

		// Prefer more stat matches over fewer matches
		const existingMatchCount = existingEntry.entries.reduce((acc, entry) => entry ? acc += entry.length : acc, 0)
		const newMatchCount = statEntry.entries.reduce((acc, entry) => entry ? acc += entry.length : acc, 0)

		if (newMatchCount > existingMatchCount) {
			statMap.set(text, statEntry)
		} else if (newMatchCount === existingMatchCount && !existingEntry.equals(statEntry)) {
			if (existingEntry.isWholeText && statEntry.isWholeText) {
				// We can never accurately match this text, blacklist it
				blacklist.add(text)
				statMap.delete(text)
			}
		}
	} else if (!blacklist.has(text) || !statEntry.isWholeText) {
		// Entries can override the blacklist if they are not WholeTextLookup
		statMap.set(text, statEntry)
	}
}

async function getLocaleStatMap(
	expansion: Expansion,
	locale: Locale,
	spellStatEffects: Map<number, StatValue[][]>,
	statSpellIDs: number[],
	procSpells: Map<number, number>,
	spellDescIDs: Set<number>,
	overrideEnchantIDs: number[],
	overrideEnchantStatEffects: Map<number, StatValue[][]>
) {
	const statMap = new Map<string, StatEntry>()

	const spellDescriptions = await queryStatSpellDescriptions(expansion, locale, Array.from(spellDescIDs))
	for (const spellDescription of spellDescriptions) {
		let staticEffects = spellStatEffects.get(spellDescription.ID)
		let procEffects = spellStatEffects.get(procSpells.get(spellDescription.ID)!)
		if (staticEffects || procEffects) {
			const branches = traverseDescriptionBranches(spellDescription.Description_lang)
			for (const branch of branches) {
				const [pattern, statEntry] = mapTextToStatEntry(branch, staticEffects, spellDescription.ID, spellStatEffects, false)
				if (staticEffects || !statEntry.isWholeText) {
					statEntry.ignoreSum = !staticEffects
					insertEntry(statMap, pattern, statEntry, locale)
				}
			}
		}
	}

	const statEnchants = await queryStatEnchants(expansion, locale, statSpellIDs, overrideEnchantIDs)
	console.log(`${statEnchants.length} statEnchants`)
	for (const statEnchant of statEnchants) {
		let stats = overrideEnchantStatEffects.get(statEnchant.ID)
		if (!stats) {
			stats = getEnchantStats(statEnchant, spellStatEffects)
		}
		const [pattern, statEntry] = mapTextToStatEntry(statEnchant.Name_lang, stats, statEnchant.ID, spellStatEffects, true)
		insertEntry(statMap, pattern, statEntry, locale)
	}

	return statMap
}

async function combineResults(results: Promise<Map<string, StatEntry>>[], locale: Locale) {
	const result = await Promise.all(results)
	return result.reduce((acc, curr) => {
		for (const [text, newEntry] of curr) {
			insertEntry(acc, text, newEntry, locale)
		}
		return acc
	})
}

function writeLocale(locale: Locale, statEntries: Map<string, StatEntry>) {
	let text = "-- THIS FILE IS AUTOGENERATED. Add new entries by editing & running GenerateStatLocales.mts or StatLocaleData.json instead.\n"
	text += "local addonName, addon = ...\n"
	text += `if GetLocale() ~= "${locale}" then return end\n`
	text += "local StatLogic = LibStub(addonName)\n"
	text += "local Stats = StatLogic.Stats\n\n"
	text += "local W = addon.WholeTextLookup\n"
	text += statEntries.entries().filter(([_, entry]) => entry.isWholeText).reduce((acc, curr) => acc + entryToString(curr), "")
	text += "\nlocal L = addon.StatIDLookup\n"
	text += statEntries.entries().filter(([_, entry]) => !entry.isWholeText).reduce((acc, curr) => acc + entryToString(curr), "")

	const fileName = `${locale}.lua`
	const filePath = new URL(path.join(localeDirName, fileName), base)
	writeFileSync(filePath, text)
	console.log(`Wrote ${fileName}`)
}

function entryToString([text, entry]: [string, StatEntry]) {
	const stats = entry.entries.reduce((accEntries, currEntry) => {
		let entryText: string
		if (currEntry) {
			entryText = currEntry.reduce((accValues, currValue) => {
				let valueText: string
				if (entry.isWholeText) {
					valueText = `[Stats.${currValue.stat}] = ${currValue.value}, `
				} else {
					valueText = `Stats.${currValue.stat}, `
				}
				return `${accValues}${valueText}`
			}, "")
		} else {
			entryText = "false, "
		}
		if (currEntry && !entry.isWholeText) {
			return accEntries + "{ " + entryText + "}, "
		} else {
			return accEntries + entryText
		}
	}, "")
	return `${entry.isWholeText ? "W" : "L"}["${text}"] = { ${stats}${entry.ignoreSum ? "ignoreSum = true " : ""}} -- ${entry.isEnchant ? "e" : "s"}${entry.id}\n`
}

mkdirSync(new URL(databaseDirName, base), { recursive: true })
mkdirSync(new URL(localeDirName, base), { recursive: true })

const localeResults = new Map<Locale, Promise<Map<string, StatEntry>>[]>()

for (const [_, expansion] of Object.entries(Expansion)) {
	if (typeof(expansion) != "number") { continue }

	// For spells with EffectAura+MiscValue0 combos that map to stats, fetch:
	//   a) Spell description for that spell
	//   b) Spell descriptions for any proc trigger auras that proc that spell
	//   c) Enchant names for enchants with that spell as an aura
	//   d) Enchant names for enchants with any of the proc trigger auras as an aura
	let spellEffects: SpellEffect[]
	try {
		spellEffects = await queryStatSpellEffects(expansion)
	} catch(e: unknown) {
		console.error((e as Error).message)
		continue
	}
	console.log(`${spellEffects.length} effects`)

	const [spellStatEffects, procSpells] = enumerateStatAndProcSpells(spellEffects)

	console.log(`${spellStatEffects.size} statSpells`)

	const statSpellIDs = Array.from(spellStatEffects.keys())
	const spellDescIDs = new Set(statSpellIDs)
	procSpells.forEach((_s, p) => spellDescIDs.add(p))

	overrideSpells(spellStatEffects, spellDescIDs, expansion)
	console.log(`${spellDescIDs.size} spellDescIDs`)

	const [overrideEnchantIDs, overrideEnchantStatEffects] = getOverrideEnchants(expansion)

	for (const locale of locales) {
		const localeStatMap = getLocaleStatMap(expansion, locale, spellStatEffects, statSpellIDs, procSpells, spellDescIDs, overrideEnchantIDs, overrideEnchantStatEffects)
		const localeResult = localeResults.get(locale) || []
		localeResult.push(localeStatMap)
		localeResults.set(locale, localeResult)
	}
}

for (const locale of locales) {
	combineResults(localeResults.get(locale)!, locale).then(results => writeLocale(locale, results))
}
