#!/usr/bin/env node

import { parse } from 'csv-parse'
import { createReadStream, existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import path from 'node:path'
import { finished } from 'node:stream/promises'

const versions = fetch("https://wago.tools/api/builds").then(response => response.json())

async function getLatestVersion(majorVersion) {
	let product = "wow_classic_ptr"
	if (majorVersion === "1") {
		product = "wow_classic_era_ptr"
	}
	return versions.then(versionsJSON => {
		return versionsJSON[product].find(build => {
			return build.version.match(new RegExp(`^${majorVersion}\\b`))
		}).version
	})
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
		return [text, stats]
	},
	"WholeTextLookup": function(text, stats) {
		return [text, stats]
	}
}

const base = import.meta.url
const statLocaleData = JSON.parse(readFileSync(new URL("StatLocaleData.json", base), "utf-8"))
const databaseDirName = "DB2"
const localeDirName = "locales"

async function fetchDatabase(db) {
	db.fileName = `${db.name}_${db.version}_${db.locale}.csv`
	db.path = new URL(path.join(databaseDirName, db.fileName), base)
	if (!existsSync(db.path)) {
		console.log(`Fetching ${db.fileName}.`)
		getLatestVersion(db.version).then(build => {
			fetch(`https://wago.tools/db2/${db.name}/csv?build=${build}`).then(response => {
				response.text().then(text => {
					writeFileSync(db.path, text)
					console.log(`Fetched ${db.fileName}.`)
				})
			})
		})
	} else {
		console.log(`Found ${db.fileName}, skipping fetch.`)
	}
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
			const data = db.indices[row.ID]
			if (data) {
				const [scanner, stats] = data
				results[scanner] ||= {}
				const [pattern, newStats] = scanners[scanner](row[textColumn], stats)
				results[scanner][pattern] = newStats
			}
		}
	})

	await finished(parser)
	console.log(`Parsed ${db.fileName}.`)
	return results
}

async function writeLocale(results) {
	Promise.all(results).then(result => {
		console.log(result)
	})
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
	writeLocale(localeResults)
}
