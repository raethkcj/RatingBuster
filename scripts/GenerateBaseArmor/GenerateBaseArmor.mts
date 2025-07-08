#!/usr/bin/env -S node --import=tsx

import { writeFileSync } from 'node:fs'
import { DuckDBInstance } from '@duckdb/node-api'

// Subset of InventoryTypes that can contain a mix of Armor and Bonus Armor
// https://warcraft.wiki.gg/wiki/Enum.InventoryType
enum InventoryType {
	Head = 1,
	Shoulder = 3,
	Chest = 5,
	Waist = 6,
	Legs = 7,
	Feet = 8,
	Wrist = 9,
	Hands = 10,
	Shield = 14,
	Cloak = 16,
	Robe = 20,
}
const inventoryTypes = Object.values(InventoryType).filter(v => Number.isInteger(v))

// https://warcraft.wiki.gg/wiki/InventorySlotID
enum InventorySlot {
	None = 0,
	HEADSLOT = 1,
	SHOULDERSLOT = 3,
	CHESTSLOT = 5,
	WAISTSLOT = 6,
	LEGSSLOT = 7,
	FEETSLOT = 8,
	WRISTSLOT = 9,
	HANDSSLOT = 10,
	SECONDARYHANDSLOT = 17,
	BACKSLOT = 15,
}

const InventoryTypeSlots: Record<InventoryType, InventorySlot> = {
	[InventoryType.Head]: InventorySlot.HEADSLOT,
	[InventoryType.Shoulder]: InventorySlot.SHOULDERSLOT,
	[InventoryType.Chest]: InventorySlot.CHESTSLOT,
	[InventoryType.Waist]: InventorySlot.WAISTSLOT,
	[InventoryType.Legs]: InventorySlot.LEGSSLOT,
	[InventoryType.Feet]: InventorySlot.FEETSLOT,
	[InventoryType.Wrist]: InventorySlot.WRISTSLOT,
	[InventoryType.Hands]: InventorySlot.HANDSSLOT,
	[InventoryType.Shield]: InventorySlot.SECONDARYHANDSLOT,
	[InventoryType.Cloak]: InventorySlot.BACKSLOT,
	[InventoryType.Robe]: InventorySlot.CHESTSLOT,
}

// https://warcraft.wiki.gg/wiki/Enum.ItemQuality
enum ItemQuality {
	"Enum.ItemQuality.Poor" = 0,
	"Enum.ItemQuality.Standard or Enum.ItemQuality.Common" = 1, // in-game doesn't match wiki
	"Enum.ItemQuality.Good or Enum.ItemQuality.Uncommon" = 2,   // in-game doesn't match wiki
	"Enum.ItemQuality.Rare" = 3,
	"Enum.ItemQuality.Epic" = 4,
	"Enum.ItemQuality.Legendary" = 5,
	"Enum.ItemQuality.Artifact" = 6,
	"Enum.ItemQuality.Heirloom" = 7,
	"Enum.ItemQuality.WoWToken" = 8,
}

// https://warcraft.wiki.gg/wiki/ItemType#4:_Armor
enum ItemArmorSubclass {
	"Enum.ItemArmorSubclass.Cloth" = 1,
	"Enum.ItemArmorSubclass.Leather" = 2,
	"Enum.ItemArmorSubclass.Mail" = 3,
	"Enum.ItemArmorSubclass.Plate" = 4,
	"Enum.ItemArmorSubclass.Shield" = 6,
}

type Item = {
	ID: number
	OverallQualityID: ItemQuality
	InventoryType: InventoryType
	Resistances_0: number
	ItemLevel: number
	SubclassID: ItemArmorSubclass
	ShieldArmor: number
	SubclassArmorTotal: number
	ArmorLocationModifier: number
	ArmorQualityModifier: number

	ComputedArmor: number
}

const ItemStatBonusArmor = 50

// Expects the DB2 tables in FROM and JOIN clauses to be in CSV format in the same directory.
// Fetch from Wago or use a DB2 to CSV tool.
// For older versions of the game, ItemArmor* and ArmorLocation can be ignored and ItemSparse.Resistances_0 can be used directly.
const query = `
SET VARIABLE types = ['INTEGER', 'DOUBLE', 'VARCHAR'];
SELECT
	ItemSparse.ID, ItemSparse.OverallQualityID, ItemSparse.InventoryType, ItemSparse.Resistances_0, ItemSparse.ItemLevel,
	Item.SubclassID,
	[
		ItemArmorTotal.Cloth,
		ItemArmorTotal.Leather,
		ItemArmorTotal.Mail,
		ItemArmorTotal.Plate
	][Item.SubclassID] AS SubclassArmorTotal,
	[
		ArmorLocation.Clothmodifier,
		ArmorLocation.Leathermodifier,
		ArmorLocation.Chainmodifier,
		ArmorLocation.Platemodifier
	][Item.SubclassID] AS ArmorLocationModifier,
	[
		ItemArmorQuality.Qualitymod_0,
		ItemArmorQuality.Qualitymod_1,
		ItemArmorQuality.Qualitymod_2,
		ItemArmorQuality.Qualitymod_3,
		ItemArmorQuality.Qualitymod_4,
		ItemArmorQuality.Qualitymod_5,
		ItemArmorQuality.Qualitymod_6
	][ItemSparse.OverallQualityID + 1] AS ArmorQualityModifier,
	[
		ItemArmorShield.Quality_0,
		ItemArmorShield.Quality_1,
		ItemArmorShield.Quality_2,
		ItemArmorShield.Quality_3,
		ItemArmorShield.Quality_4,
		ItemArmorShield.Quality_5,
		ItemArmorShield.Quality_6
	][ItemSparse.OverallQualityID + 1] AS ShieldArmor
FROM read_csv('ItemSparse.csv', auto_type_candidates = getvariable(types)) ItemSparse
JOIN read_csv('Item.csv', auto_type_candidates = getvariable(types)) Item on Item.ID = ItemSparse.ID
JOIN read_csv('ItemArmorTotal.csv', auto_type_candidates = getvariable(types)) ItemArmorTotal on ItemArmorTotal.ID = ItemSparse.ItemLevel
JOIN read_csv('ArmorLocation.csv', auto_type_candidates = getvariable(types)) ArmorLocation on ArmorLocation.ID = ItemSparse.InventoryType
JOIN read_csv('ItemArmorQuality.csv', auto_type_candidates = getvariable(types)) ItemArmorQuality on ItemArmorQuality.ID = ItemSparse.ItemLevel
JOIN read_csv('ItemArmorShield.csv', auto_type_candidates = getvariable(types)) ItemArmorShield on ItemArmorShield.ID = ItemSparse.ItemLevel
WHERE ItemSparse.InventoryType IN [${inventoryTypes}]
AND (
	ItemSparse.QualityModifier > 0
	OR ${ItemStatBonusArmor} IN [
		ItemSparse.StatModifier_bonusStat_0,
		ItemSparse.StatModifier_bonusStat_1,
		ItemSparse.StatModifier_bonusStat_2,
		ItemSparse.StatModifier_bonusStat_3,
		ItemSparse.StatModifier_bonusStat_4,
		ItemSparse.StatModifier_bonusStat_5,
		ItemSparse.StatModifier_bonusStat_6,
		ItemSparse.StatModifier_bonusStat_7,
		ItemSparse.StatModifier_bonusStat_8,
		ItemSparse.StatModifier_bonusStat_9,
	]
)
`

const instance = await DuckDBInstance.create()
const connection = await instance.connect()
const reader = await connection.runAndReadAll(query)
const items = reader.getRowObjects() as Item[]

const baseArmor = {}
for(const item of Object.values(items)) {
	const quality = ItemQuality[item.OverallQualityID]
	const slot = InventorySlot[InventoryTypeSlots[item.InventoryType]]
	const subclass = ItemArmorSubclass[item.SubclassID]
	const armor = item.InventoryType === InventoryType.Shield
		? item.ShieldArmor
		: Math.round(item.SubclassArmorTotal * item.ArmorLocationModifier * item.ArmorQualityModifier)

	if (armor !== 0) {
		const slots = baseArmor[quality] ||= {}
		const subclasses = slots[slot] ||= {}
		const itemLevels = subclasses[subclass] ||= {}
		itemLevels[item.ItemLevel] = armor
		if (item.InventoryType > 10) {
			item.ComputedArmor = armor
			console.dir(item)
		}
	}
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

const filename = `BaseArmor.lua`
writeFileSync(filename, data)
console.log(`Wrote ${filename}`)
