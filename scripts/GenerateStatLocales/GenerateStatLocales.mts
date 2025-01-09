#!/usr/bin/env node

import { parse } from 'csv-parse'
import { createReadStream, existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import path from 'node:path'
import { finished } from 'node:stream/promises'

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
const itemStatType = {
	0: 'Mana',
	1: 'Health',
	3: 'Agility',
	4: 'Strength',
	5: 'Intellect',
	6: 'Spirit',
	7: 'Stamina',
	12: 'DefenseRating',
	13: 'DodgeRating',
	14: 'ParryRating',
	15: 'BlockRating',
	16: 'MeleeHitRating',
	17: 'RangedHitRating',
	18: 'SpellHitRating',
	19: 'MeleeCritRating',
	20: 'RangedCritRating',
	21: 'SpellCritRating',
	28: 'MeleeHasteRating',
	29: 'RangedHasteRating',
	30: 'SpellHasteRating',
	31: 'HitRating',
	32: 'CritRating',
	35: 'ResilienceRating',
	36: 'HasteRating',
	37: 'ExpertiseRating',
	38: 'GenericAttackPower',
	39: 'RangedAttackPower',
	40: 'Versatility',
	41: 'HealingPower',
	42: 'SpellDamage',
	43: 'GenericManaRegen',
	44: 'ArmorPenetrationRating',
	45: ['SpellDamage', 'HealingPower'], // SpellPower
	47: 'SpellPenetration',
	49: 'MasteryRating',
}

enum PrimaryStat {
	AllStats = -1,
	Strength,
	Agility,
	Stamina,
	Intellect,
	Spirit,
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
	PROC_TRIGGER_SPELL = 42, // Self Join?
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
	MOD_SPELL_CRIT_CHANCE_School = 552, // School
	MOD_SHIELD_BLOCKVALUE = 564,
	MOD_COMBAT_RESULT_CHANCE = 593,
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

enum CombatRating {
	CR_AMPLIFY = 0x00000001,
	CR_DEFENSE_SKILL = 0x00000002,
	CR_DODGE = 0x00000004,
	CR_PARRY = 0x00000008,
	CR_BLOCK = 0x00000010,
	CR_HIT_MELEE = 0x00000020,
	CR_HIT_RANGED = 0x00000040,
	CR_HIT_SPELL = 0x00000080,
	CR_CRIT_MELEE = 0x00000100,
	CR_CRIT_RANGED = 0x00000200,
	CR_CRIT_SPELL = 0x00000400,
	CR_CORRUPTION = 0x00000800,
	CR_CORRUPTION_RESISTANCE = 0x00001000,
	CR_SPEED = 0x00002000,
	CR_RESILIENCE_CRIT_TAKEN = 0x00004000,
	CR_RESILIENCE_PLAYER_DAMAGE = 0x00008000,
	CR_LIFESTEAL = 0x00010000,
	CR_HASTE_MELEE = 0x00020000,
	CR_HASTE_RANGED = 0x00040000,
	CR_HASTE_SPELL = 0x00080000,
	CR_AVOIDANCE = 0x00100000,
	CR_STURDINESS = 0x00200000,
	CR_UNUSED_7 = 0x00400000,
	CR_EXPERTISE = 0x00800000,
	CR_ARMOR_PENETRATION = 0x01000000,
	CR_MASTERY = 0x02000000,
	CR_PVP_POWER = 0x04000000,
	CR_CLEAVE = 0x08000000,
	CR_VERSATILITY_DAMAGE_DONE = 0x10000000,
	CR_VERSATILITY_HEALING_DONE = 0x20000000,
	CR_VERSATILITY_DAMAGE_TAKEN = 0x40000000,
	CR_UNUSED_12 = 0x80000000,
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

mkdirSync(new URL(databaseDirName, base), { recursive: true })
mkdirSync(new URL(localeDirName, base), { recursive: true })
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
