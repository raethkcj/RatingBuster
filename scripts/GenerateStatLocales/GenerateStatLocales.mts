#!/usr/bin/env -S node --import=tsx

import { parse } from 'csv-parse'
import { createReadStream, existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import path from 'node:path'
import { finished } from 'node:stream/promises'

import { DuckDBInstance, DuckDBValue } from '@duckdb/node-api'

{
	let versions
	async function fetchBuilds() {
		return versions ||= fetch("https://wago.tools/api/builds").then(response => response.json())
	}

	var getLatestVersion = async function(majorVersion) {
		let product = "wow_classic_ptr"
		if (majorVersion === "1") {
			product = "wow_classic_era_ptr"
		} else if(majorVersion === "4") {
			product = "wow_classic_beta"
		}
		const builds = await fetchBuilds()
		return builds[product].find(build => {
			return build.version.match(new RegExp(`^${majorVersion}\\b`))
		}).version
	}
}

function isManaRegen(stat) {
	return stat === "GenericManaRegen" || stat && stat.includes && stat.includes("GenericManaRegen")
}

const scanners = {
	"StatIDLookup": function(text, stats) {
		const newStats: Array<string|false> = []
		let matchedStatCount = 0
		let checkForManaRegen = false
		// Matches an optional leading + or -, plus one of:
		//   Replacement token:
		//     Leading $
		//     One of: s: spell, a: aura range, t: time interval, i: unknown integer
		//     Optional integer indicating SpellEffect Index
		//   Literal number:
		//     Digits 0-9 or decimal point ".", ends in digit
		const pattern = text.replace(/[+-]?(\$(?<tokenType>[sati])(?<tokenIndex>\d?)|[\d\.]+(?<=\d))/g, function(match, _1, _2, _3, offset, string, groups) {
			let stat
			switch (groups.tokenType) {
				case "s":
					// In theory, $s2 could come before $s1. However, this is not
					// the case in any strings we use in any locale (for now :)).
					// TODO: Hande GenericManaRegen fives
					stat = stats[matchedStatCount]
					if (isManaRegen(stat)) {
						checkForManaRegen = true
					}
					newStats.push(stat)
					matchedStatCount++
					break
				case "a":
				case "t":
					newStats.push(false)
					break
				default:
					// tokenType i or plain number
					stat = matchedStatCount < stats.length ? stats[matchedStatCount] : false
					if ((isManaRegen(stat) || checkForManaRegen) && match === "5") {
						newStats.push(false)
						checkForManaRegen = false
					} else {
						if(isManaRegen(stat)) {
							checkForManaRegen = true
						}
						newStats.push(stat)
						matchedStatCount++
					}
			}
			return "%s"
		})
		return [pattern, matchedStatCount > 0 ? newStats : false]
	},
	"WholeTextLookup": function(text, stats) {
		return [text, stats]
	}
}

// TODO: map ${...} to the same logic as "plain" integers (undefined identifiers)
function mapTextToStats(text: string, stats: StatValue[][], scanner?: string) {
	text = text.replace(/[\s.]+$/, "").toLowerCase()
	scanner ||= text.search(/\d/) > 0 ? "StatIDLookup" : "WholeText"

	const newStats: Array<string | false> = []
	let matchedStatCount = 0
	let checkForManaRegen = false
	// Matches an optional leading + or -, plus one of:
	//   Replacement token:
	//     Leading $
	//     Optional spellID override
	//     An identifier from: https://wowdev.wiki/Spells#Known_identifiers
	//     Optional integer indicating SpellEffect Index
	//   Literal number:
	//     Digits 0-9 or decimal point ".", ends in digit
	const pattern = text.replace(/[+-]?(\$(?<spellID>\d*)(?<identifier>[a-z])(?<identifierIndex>\d?)|[\d\.]+(?<=\d))/g, function(match, _1, _2, _3, _4, offset, string, groups) {
		let stat
		// TODO These identifiers are only valid for Spell.db2.
		// SpellItemEnchantment uses an entirely separate set,
		// e.g. https://wago.tools/db2/SpellItemEnchantment?filter[Name_lang]=%24f
		switch (groups.identifier) {
			case "m":
			case "o": // TODO since this should be HP5, multiply by 5000 / EffectAuraPeriod
			case "s":
			case "w":
				// Since we only parse effects with a range of 0 or 1,
				// we can treat min, max and spread identically
				stat = stats[groups.identifierIndex]
				if (isManaRegen(stat)) {
					checkForManaRegen = true
				}
				newStats.push(stat)
				matchedStatCount++
				break
			case undefined:
				stat = matchedStatCount < stats.length ? stats[matchedStatCount] : false
				if ((isManaRegen(stat) || checkForManaRegen) && match === "5") {
					newStats.push(false)
					checkForManaRegen = false
				} else {
					if(isManaRegen(stat)) {
						checkForManaRegen = true
					}
					newStats.push(stat)
					matchedStatCount++
				}
				break
			case "a":
			case "c":
			case "d":
			case "h":
			case "i":
			case "n":
			case "t":
			case "u":
			case "x":
				// Confirmed non-stats
				newStats.push(false)
				break
			case "g":
			case "l":
				console.log(`Unhandled conditional identifier ${groups.identifier} in '${string}'`)
				newStats.push(false)
				break
			default:
				console.log(`Unhandled identifier ${groups.identifier} in '${string}'`)
				newStats.push(false)
				break
		}
		return "%s"
	})
	return [pattern, matchedStatCount > 0 ? newStats : false]
}

const base = import.meta.url
import statLocaleData from './StatLocaleData.json'
const databaseDirName = "DB2"

async function fetchDatabase(db) {
	db.fileName = `${db.name}_${db.version}_${db.locale}.csv`
	db.path = new URL(path.join(databaseDirName, db.fileName), base)
	if (!existsSync(db.path)) {
		console.log(`Fetching ${db.fileName}.`)
		const build = await getLatestVersion(db.version)
		const url = `https://wago.tools/db2/${db.name}/csv?build=${build}&locale=${db.locale}`
		const response = await fetch(url)
		if (response.ok) {
			const text = await response.text()
			writeFileSync(db.path, text)
			console.log(`Fetched ${db.fileName}.`)
		} else {
			throw new Error(`Failed to fetch ${url}: ${response.status} ${response.statusText}`)
		}
		return
	} else {
		console.log(`Found ${db.fileName}, skipping fetch.`)
		return
	}
}

// From wow.tools' enums.js, also obtainable at wowdev.wiki
enum itemStatType {
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
	SpellPenetration = 47,
	MasteryRating = 49,
}

enum EnchantmentEffect {
	Proc = 1,
	Damage,
	Buff,
	Armor,
	Stat,
}

enum EffectAura {
	PERIODIC_HEAL = 8,
	MOD_DAMAGE_DONE = 13, // School
	MOD_RESISTANCE = 22, // School
	MOD_STAT = 29, // PrimaryStats
	MOD_SKILL = 30, // SkillLine
	MOD_PARRY_PERCENT = 47,
	MOD_DODGE_PERCENT = 49,
	MOD_BLOCK_PERCENT = 51,
	MOD_WEAPON_CRIT_PERCENT = 52,
	MOD_HIT_CHANCE = 54,
	MOD_SPELL_HIT_CHANCE = 55,
	MOD_SPELL_CRIT_CHANCE = 57,
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

// EffectAura.PROC_TRIGGER_SPELL
const procTriggerSpell = 42

function getGemStats(row) {
	const stats: Array<string|false> = []
	let foundStat = false
	for (let i = 0; i < 3; i++) {
		const enchantmentEffect = row[`Effect_${i}`]
		if (enchantmentEffect === EnchantmentEffect.Stat) {
			const effectStat = row[`EffectArg_${i}`]
			const effectValue = row[`EffectPointsMin_${i}`]
			const stat = itemStatType[effectStat]
			if (stat === "GenericManaRegen" && effectValue === 5) {
				// Impossible to distinguish stat vs interval in a string like "5 mana per 5"
				return false
			} else {
				foundStat = true
				stats.push(stat)
			}
		} else if(enchantmentEffect > "0") {
			stats.push(false)
		}
	}
	return foundStat ? stats : false
}

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

	All = 0x7E,
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
					} else {
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

function GetPowerTypeStat(statSuffix: string) {
	return (powerTypeID: number): string[] => {
		const powerType = PowerType[powerTypeID]
		return powerType ? [powerType + statSuffix] : []
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
	[EffectAura.MOD_DAMAGE_DONE]: GetSchoolStat("Damage", "WeaponDamage", "SpellDamage"),
	[EffectAura.MOD_RESISTANCE]: GetSchoolStat("Resistance", "Armor"),
	[EffectAura.MOD_STAT]: GetPrimaryStat(),
	[EffectAura.MOD_SKILL]: GetSkillLineStat(),
	[EffectAura.MOD_PARRY_PERCENT]: GetPlainStat("Parry"),
	[EffectAura.MOD_DODGE_PERCENT]: GetPlainStat("Dodge"),
	[EffectAura.MOD_BLOCK_PERCENT]: GetPlainStat("BlockChance"),
	[EffectAura.MOD_WEAPON_CRIT_PERCENT]: GetPlainStat("MeleeCrit", "RangedCrit"),
	[EffectAura.MOD_HIT_CHANCE]: GetPlainStat("MeleeHit", "RangedHit"),
	[EffectAura.MOD_SPELL_HIT_CHANCE]: GetPlainStat("SpellHit"),
	[EffectAura.MOD_SPELL_CRIT_CHANCE]: GetPlainStat("SpellCrit"),
	[EffectAura.MOD_POWER_REGEN]: GetPowerTypeStat("Regen"),
	[EffectAura.MOD_ATTACK_POWER]: GetPlainStat("AttackPower"),
	[EffectAura.MOD_TARGET_RESISTANCE]: GetSchoolStat("Resistance", "Armor"),
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
	Armor = 0,
	HolyResistance,
	FireResistance,
	NatureResistance,
	FrostResistance,
	ShadowResistance,
	ArcaneResistance,
}

function getEnchantStats(enchant: StatEnchant): StatValue[][] {
	const stats: StatValue[][] = []
	for(const [index, [effect, effectArg, pointsMin]] of enchant.effects.entries()) {
		switch(effect) {
			case EnchantEffect.Damage:
				stats[index] = [new StatValue("AverageWeaponDamage", pointsMin)]
				break
			case EnchantEffect.Buff:
				const buffStats = statSpells.get(effectArg)?.stats.flat()
				if (buffStats) stats[index] = buffStats
				break
			case EnchantEffect.Resistance:
				const resistance = Resistance[effectArg]
				if (resistance) stats[index] = [new StatValue(resistance, pointsMin)]
				break
			case EnchantEffect.Stat:
				const itemStat = itemStatType[effectArg]
				if (itemStat) stats[index] = [new StatValue(itemStat, pointsMin)]
				break
		}
	}
	return stats
}

const textColumns = {
	"SpellItemEnchantment": "Name_lang",
	"Spell": "Description_lang"
}

async function processDatabase(db) {
	const results = {}
	try {
		await fetchDatabase(db)
	} catch(error) {
		console.error(error)
		return results
	}

	const parser = createReadStream(db.path).pipe(parse({
		columns: true
	}))

	const textColumn = textColumns[db.name]
	parser.on('readable', () => {
		let row
		while ((row = parser.read()) !== null) {
			let scanner, stats
			const data = db.indices[row.ID]
			if (data) {
				[scanner, stats] = data
			} else if (db.name === "SpellItemEnchantment" && row.GemItemID && row.GemItemID > 0) {
				scanner = "StatIDLookup"
				stats = getGemStats(row)
			}

			if (scanner && stats) {
				results[scanner] ||= {}
				const text = row[textColumn].replace(/[\s.]+$/, "").toLowerCase()
				const [pattern, newStats] = scanners[scanner](text, stats)
				if (pattern && newStats) {
					results[scanner][pattern] = newStats
				}
			}
		}
	})

	await finished(parser)
	console.log(`Parsed ${db.fileName}.`)
	return results
}

async function combineResults(results) {
	const result = await Promise.all(results)
	return result.reduce((acc, curr) => {
		for (const scanner of Object.keys(scanners)) {
			if (!acc[scanner] && !curr[scanner]) {
				continue
			} else if (!acc[scanner] || !curr[scanner]) {
				acc[scanner] ||= curr[scanner]
			} else {
				acc[scanner] = Object.assign(acc[scanner], curr[scanner])
			}
		}
		return acc
	})
}

// This could be cleaner/more abstract but it works for now
function generateLua(text, key, value, first) {
	if (first) {
		for(const [k, v] of Object.entries(value)) {
			text = generateLua(text, `${key}["${k}"]`, v, false)
			text += "\n"
		}
		return text
	}

	if (key) {
		text += `${key} = `
	}

	if (typeof(value) === "object") {
		text += "{"
		for(const [k, v] of Object.entries(value)) {
			const newKey = Array.isArray(value) ? false : `[StatLogic.Stats.${k}]`
			text = generateLua(text, newKey, v, false)
			text += ", "
		}
		text += "}"
	} else {
		text += `${(key || !value) ? "" : "StatLogic.Stats."}${value}`
	}

	return text
}

const localeDirName = "locales"

async function writeLocale(locale, results) {
	let text = "-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.\n"
	text += "local addonName, addon = ...\n"
	text += `if GetLocale() ~= "${locale}" then return end\n`
	text += "local StatLogic = LibStub(addonName)\n\n"
	text += "local W = addon.WholeTextLookup\n"
	text = generateLua(text, "W", results.WholeTextLookup, true)
	text += "\nlocal L = addon.StatIDLookup\n"
	text = generateLua(text, "L", results.StatIDLookup, true)

	const fileName = `${locale}.lua`
	const filePath = new URL(path.join(localeDirName, fileName), base)
	writeFileSync(filePath, text)
	console.log(`Wrote ${fileName}`)
}

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
]

const instance = await DuckDBInstance.create()
const connection = await instance.connect()

async function getTypedResults<T>(query: string, type: { new(...args: any[]): T }): Promise<T[]> {
	const results: T[] = []
	const result = await connection.run(query)
	let chunk = await result.fetchChunk()
	while(chunk && chunk.rowCount > 0) {
		for (const row of chunk.getRows()) {
			results.push(new type(...row))
		}
		chunk = await result.fetchChunk()
	}

	return results
}

class SpellEffect {
	constructor(
		public spellID: number,
		public effectIndex: number,
		public effectAura: EffectAura,
		public effectBasePoints: number,
		public effectDieSides: number,
		public effectMiscValue0: number,
		public procSpellID: number,
	) {}
}

async function fetchStatSpellEffects() {
	const spellEffect = "DB2/SpellEffect_1_enUS.csv"

	const query = `
		SELECT StatSpell.SpellID, StatSpell.EffectIndex, StatSpell.EffectAura, StatSpell.EffectBasePoints, StatSpell.EffectDieSides, StatSpell.EffectMiscValue_0, ProcSpell.SpellID
		FROM read_csv('${spellEffect}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR']) StatSpell
		LEFT JOIN '${spellEffect}' ProcSpell ON ProcSpell.EffectTriggerSpell = StatSpell.SpellID
		WHERE StatSpell.EffectAura in (${effectAuraValues})
		ORDER BY StatSpell.SpellID, ProcSpell.SpellID, StatSpell.EffectIndex
	`

	return await getTypedResults<SpellEffect>(query, SpellEffect)
}

class SpellDescription {
	constructor(
		public id: number,
		public description: string
	) {}
}

async function fetchStatSpellDescriptions(spellIDs: number[]): Promise<SpellDescription[]> {
	const spell = "DB2/Spell_1_enUS.csv"

	const query = `
		SELECT ID, Description_lang
		FROM read_csv('${spell}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR'])
		WHERE ID in (${spellIDs}) AND Description_lang NOT NULL
	`

	return await getTypedResults<SpellDescription>(query, SpellDescription)
}

// Parses spell descriptions of the form "prefix $condition1[branch1]condition2[branch2][branch3] suffix"
// into all possible "prefix branchN suffix" forms, discarding the conditions.
// Returns a flat array of all possible branches, including solely the original string if applicable.
async function traverseDescriptionBranches(description: string): Promise<string[]> {
	const branches = [description]
	const conditionPattern = /\$\?/g
	const branchPattern = /[$\w|& ]*?\[([^[\]]*)\]\??/gyd
	let i = 0
	while (i < branches.length) {
		const branch = branches[i]
		conditionPattern.lastIndex = 0
		const conditionMatch = conditionPattern.exec(branch)
		if (conditionMatch) {
			branchPattern.lastIndex = conditionPattern.lastIndex
			let lastIndex = 0
			const branchTexts: string[] = []
			for(const branchMatch of branch.matchAll(branchPattern)) {
				if (branchMatch.indices) {
					branchTexts.push(branchMatch[1])
					lastIndex = branchMatch.indices[0][1]
				}
			}

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

class StatEnchant {
	stats: string[][] = []
	effects: [effect: EnchantEffect, effectArg: number, pointsMin: number][]

	constructor(
		public id: number,
		public name: string,
		effect0: EnchantEffect,
		effectArg0: number,
		pointsMin0: number,
		effect1: EnchantEffect,
		effectArg1: number,
		pointsMin1: number,
		effect2: EnchantEffect,
		effectArg2: number,
		pointsMin2: number,
	) {
		this.effects = [[effect0, effectArg0, pointsMin0], [effect1, effectArg1, pointsMin1], [effect2, effectArg2, pointsMin2]]
	}
}

async function fetchStatEnchants(spellIDs: number[]): Promise<StatEnchant[]> {
	const spellItemEnchantment = "DB2/SpellItemEnchantment_1_enUS.csv"

	const query = `
		SELECT ID, Name_lang, Effect_0, EffectArg_0, EffectPointsMin_0, Effect_1, EffectArg_1, EffectPointsMin_1, Effect_2, EffectArg_2, EffectPointsMin_2
		FROM read_csv('${spellItemEnchantment}', auto_type_candidates = ['INTEGER', 'DOUBLE', 'VARCHAR'])
		WHERE
			Effect_0 = '${EnchantEffect.Buff}' AND EffectArg_0 IN (${spellIDs})
			OR Effect_1 = '${EnchantEffect.Buff}' AND EffectArg_1 IN (${spellIDs})
			OR Effect_2 = '${EnchantEffect.Buff}' AND EffectArg_2 IN (${spellIDs})
			OR Effect_0 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})
			OR Effect_1 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})
			OR Effect_2 IN (${EnchantEffect.Damage}, ${EnchantEffect.Resistance}, ${EnchantEffect.Stat})

	`

	return await getTypedResults(query, StatEnchant)
}

function processStaticLocaleData() {
	for (const locale of locales) {
		const localeResults: Promise<any>[] = []
		for (const [name, versions] of Object.entries(statLocaleData)) {
			for (const [version, indices] of Object.entries(versions)) {
				localeResults.push(processDatabase({
					name: name,
					version: version,
					locale: locale,
					indices: indices
				}))
			}
		}
		combineResults(localeResults).then(results => writeLocale(locale, results))
	}
}

mkdirSync(new URL(databaseDirName, base), { recursive: true })
mkdirSync(new URL(localeDirName, base), { recursive: true })
// processStaticLocaleData()

class StatValue {
	constructor(public stat: string, public value: number) {}
}

class StatSpell {
	stats: StatValue[][] = []
	descriptions: string[] = []
}

// For spells with EffectAura+MiscValue0 combos that map to stats, fetch:
//   a) Spell description for that spell
//   b) Spell descriptions for any proc trigger auras that proc that spell
//   c) Enchant names for enchants with that spell as an aura
//   d) Enchant names for enchants with any of the proc trigger auras as an aura
const spellEffects = await fetchStatSpellEffects()
console.log(`${spellEffects.length} effects`)

const statSpells = new Map<number, StatSpell>()
const statSpellIDSet = new Set<number>()
const procSpellIDSet = new Set<number>()
for (const effect of spellEffects) {
	const spell = statSpells.get(effect.spellID) || new StatSpell()

	if (!spell.stats[effect.effectIndex] && effect.effectDieSides <= 1) {
		const effectAuraFunc = effectAuraStats[effect.effectAura]
		const stats = effectAuraFunc ? effectAuraFunc(effect.effectMiscValue0) : null
		if (stats && stats.length > 0) {
			const value = effect.effectBasePoints + effect.effectDieSides

			// May leave empty indices if a spell has non-stat effects prior to a stat effect
			spell.stats[effect.effectIndex] = stats.map((s) => new StatValue(s, value))

			statSpellIDSet.add(effect.spellID)
			if (effect.procSpellID) {
				procSpellIDSet.add(effect.procSpellID)
			}
		}
	}

	if (spell.stats.length > 0) {
		statSpells.set(effect.spellID, spell)
	}
}

console.log(`${statSpells.size} statSpells`)

const statSpellIDs = Array.from(statSpells.keys())
const statAndProcSpellIDs = statSpellIDs.concat(Array.from(procSpellIDSet.keys()))
console.log(`${statAndProcSpellIDs.length} spellDescIDs`)

const spellDescriptions = await fetchStatSpellDescriptions(statAndProcSpellIDs)
for (const spellDescription of spellDescriptions) {
	const spell = statSpells.get(spellDescription.id)
	if (spell) {
		const branches = await traverseDescriptionBranches(spellDescription.description)
		for (const branch of branches) {
			await mapTextToStats(branch, spell.stats)
		}
	}
}

const statEnchants = await fetchStatEnchants(statSpellIDs)
console.log(`${statEnchants.length} statEnchants`)
for (const statEnchant of statEnchants) {
	const stats = getEnchantStats(statEnchant)
}
