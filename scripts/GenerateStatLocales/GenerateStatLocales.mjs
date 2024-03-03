#!/usr/bin/env node

import * as https from 'node:https'
import { parse } from 'csv-parse'
import * as fs from 'node:fs'
import { assert } from 'node:console'

const versions = fetch("https://wago.tools/api/builds").then(response => response.json())

async function getLatestVersion(majorVersion) {
	let product = "wow_classic_ptr"
	if(majorVersion === "1") {
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
