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

/**
 *
 * @param {string} pattern
 * @param {string[]} stats
 * @returns
 */
const insertFives = function(pattern, stats) {
	pattern = pattern.replace(/%c/g, "")
	let temp = {}
	let indices = []

	// Gather the indices of the real stats
	let i = 0
	let j = 1
	do {
		i = pattern.indexOf("%s", i + 1)
		if (i) {
			temp[i] = stats[j]
			indices.push(i)
			j = j + 1
		}
	} while (i >= 0)

	// Gather the indices of each 5
	i = 0
	do {
		// TODO This is still Lua syntax
		const five = /%f[%+%-%d]5%f[^%+%-%d]/
		five.exec(pattern)
		i = five.lastIndex
		if (i > 0) {
			temp[i] = false
			indices.push(i)
		}
	} while (i > 0)

	// TODO This is still Lua syntax
	pattern = pattern.replace("%f[%+%-%d]5%f[^%+%-%d]", "%%s")

	// Insert a false in the stat table for each 5, in order
	indices.sort()
	const newStats = []
	for (const index of indices) {
		newStats.push(temp[index])
	}

	return newStats
}

function testRegenStrings() {
	const regenTest = {
		"+7 Haste Rating and +4 Mana every 5 seconds": ["HasteRating", "ManaRegen"],
		"+7 Tempowertung und alle 5 Sek. 4 Mana": ["HasteRating", "ManaRegen"],
	}

	for (const [pattern, stats] of Object.entries(regenTest)) {
		console.log(pattern, insertFives(pattern, stats))
	}
}

const scanners = {
	"StatIDLookup": function(text, stats) {
		const newStats = []
		let matchedStatCount = 0
		// Matches an optional leading + or -, plus one of:
		//   Replacement token:
		//     Leading $
		//     One of: s: spell, a: aura range, t: time interval, i: unknown integer
		//     Optional integer indicating SpellEffect Index
		//   Literal number:
		//     Digits 0-9 or decimal point ".", ends in digit
		const pattern = text.replace(/[+-]?(\$(?<tokenType>[sati])(?<tokenIndex>\d?)|[\d\.]+(?<=\d))/g, function(match, _1, _2, _3, offset, string, groups) {
			switch (groups.tokenType) {
				case "s":
					// In theory, $s2 could come before $s1. However, this is not
					// the case in any strings we use in any locale (for now :)).
					// TODO: Hande ManaRegen fives
					newStats.push(stats[matchedStatCount])
					matchedStatCount++
					break
				case "a":
				case "t":
					newStats.push(false)
					break
				default:
					// tokenType i or plain number
					newStats.push(stats[matchedStatCount])
					matchedStatCount++
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
const statLocaleData = JSON.parse(readFileSync(new URL("StatLocaleData.json", base), "utf-8"))
const databaseDirName = "DB2"

async function fetchDatabase(db) {
	db.fileName = `${db.name}_${db.version}_${db.locale}.csv`
	db.path = new URL(path.join(databaseDirName, db.fileName), base)
	if (!existsSync(db.path)) {
		console.log(`Fetching ${db.fileName}.`)
		const build = await getLatestVersion(db.version)
		const response = await fetch(`https://wago.tools/db2/${db.name}/csv?build=${build}&locale=${db.locale}`)
		const text = await response.text()
		writeFileSync(db.path, text)
		console.log(`Fetched ${db.fileName}.`)
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
    38: 'AttackPower',
    39: 'RangedAttackPower',
    40: 'Versatility',
    41: 'HealingPower',
    42: 'SpellDamage',
    43: 'ManaRegen',
    44: 'ArmorPenetrationRating',
    45: 'SpellPower',
    47: 'SpellPenetration',
    49: 'MasteryRating',
}

function getGemStats(row) {
	const stats = []
	let foundStat = false
	for (let i = 0; i < 3; i++) {
		const effectType = row[`Effect_${i}`]
		if (effectType === "5") {
			// Stat
			const effectStat = row[`EffectArg_${i}`]
			const effectValue = row[`EffectPointsMin_${i}`]
			const stat = itemStatType[effectStat]
			if (stat === "ManaRegen" && effectValue === 5) {
				// Impossible to distinguish stat vs interval in a string like "5 mana per 5"
				return false
			} else {
				foundStat = true
				stats.push(stat)
			}
		} else if(effectType > "0") {
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
	await fetchDatabase(db)

	const parser = createReadStream(db.path).pipe(parse({
		columns: true
	}))

	const results = {}
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
			text = generateLua(text, `${key}["${k}"]`, v)
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
			text = generateLua(text, newKey, v)
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
	const localeResults = []
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
