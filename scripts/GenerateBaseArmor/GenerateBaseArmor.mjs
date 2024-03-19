#!/usr/bin/env node

import { argv } from 'node:process'
import * as https from 'node:https'
import { parse } from 'csv-parse'
import * as fs from 'node:fs'

let branch = argv[2]
if(!branch) {
	branch = "wow_classic_ptr"
	console.log(`Branch not specified, using ${branch}`)
}

// InventoryTypes that can contain a mix of Armor and Bonus Armor
// https://warcraft.wiki.gg/wiki/Enum.InventoryType
const InventoryTypeSlots = {
	1: "HEADSLOT",
	3: "SHOULDERSLOT",
	5: "CHESTSLOT",
	6: "WAISTSLOT",
	7: "LEGSSLOT",
	8: "FEETSLOT",
	9: "WRISTSLOT",
	10: "HANDSSLOT",
	14: "SECONDARYHANDSLOT",
	16: "BACKSLOT",
	20: "CHESTSLOT",
}

// https://warcraft.wiki.gg/wiki/Enum.ItemQuality
const ItemQualities = {
	0: "Enum.ItemQuality.Poor",
	1: "Enum.ItemQuality.Standard", // in-game doesn't match wiki
	2: "Enum.ItemQuality.Good",     // in-game doesn't match wiki
	3: "Enum.ItemQuality.Rare",
	4: "Enum.ItemQuality.Epic",
	5: "Enum.ItemQuality.Legendary",
	6: "Enum.ItemQuality.Artifact",
	7: "Enum.ItemQuality.Heirloom",
	8: "Enum.ItemQuality.WoWToken",
}

const statFields = []
for (let i = 1; i < 10; i++) {
	statFields.push(`StatModifier_bonusStat_${i}`)
}

function hasBonusArmor(item) {
	// Quality Modifier is used in Vanilla-Wrath
	// bonusStat = 50 is used beginning in Cata
	return item.QualityModifier > 0 || statFields.some(f => item[f] === "50")
}

const items = {}
await new Promise((resolve) => {
	const csvStream = parse({
		columns: true,
	}).on('readable', () => {
		let item;
		while ((item = csvStream.read()) !== null) {
			if(hasBonusArmor(item)) {
				items[item.ID] = {
					Quality: ItemQualities[item.OverallQualityID],
					Slot: InventoryTypeSlots[item.InventoryType],
					Armor: item.Resistances_0,
					ItemLevel: item.ItemLevel
				}
			}
		}
	}).on('end', resolve)

	const filter = Object.keys(InventoryTypeSlots).join("|")
	const url = `https://wago.tools/db2/ItemSparse/csv?branch=${branch}&filter[InventoryType]=${filter}&sort[QualityModifier]=desc`
	https.get(url, (res) => {
		res.pipe(csvStream)
	})
})

console.log("Parsed ItemSparse.db2")

// https://warcraft.wiki.gg/wiki/ItemType#4:_Armor
const ItemArmorSubclasses = {
	1: "Enum.ItemArmorSubclass.Cloth",
	2: "Enum.ItemArmorSubclass.Leather",
	3: "Enum.ItemArmorSubclass.Mail",
	4: "Enum.ItemArmorSubclass.Plate",
	6: "Enum.ItemArmorSubclass.Shield",
}

await new Promise((resolve) => {
	const csvStream = parse({
		columns: true
	}).on('readable', () => {
		let item;
		while ((item = csvStream.read()) !== null) {
			if(items[item.ID]) {
				const subclass = ItemArmorSubclasses[item.SubclassID]
				if(subclass) {
					items[item.ID].SubclassID = subclass
				} else {
					delete items[item.ID]
				}
			}
		}
	}).on('end', resolve)

	const filter = Object.keys(items).join("|")
	const url = `https://wago.tools/db2/Item/csv?branch=${branch}&filter[ID]=${filter}`
	https.get(url, (res) => {
		res.pipe(csvStream)
	})
})

console.log("Parsed Item.db2")

const baseArmor = {}
for(const item of Object.values(items)) {
	let quality = baseArmor[item.Quality] ||= {}
	let slot = quality[item.Slot] ||= {}
	let subclass = slot[item.SubclassID] ||= {}
	subclass[item.ItemLevel] = item.Armor
}

let data = "addon.baseArmorTable = {\n"
const indent = "\t"
const generateLua = function(obj, level) {
	level ||= 1
	for(const [key, value] of Object.entries(obj)) {
		if(typeof(value) === "object") {
			data = data.concat(indent.repeat(level), "[", key, "] = {\n")
			generateLua(value, level + 1)
			data = data.concat(indent.repeat(level), "},\n")
		} else {
			data = data.concat(indent.repeat(level), "[", key, "] = ", value, ",\n")
		}
	}
}
generateLua(baseArmor)
data = data + "}\n"

const filename = `Bonus_Armor_${branch}.lua`
fs.writeFileSync(filename, data)
console.log(`Wrote ${filename}`)
