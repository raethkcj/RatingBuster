--[[
Name: LibBabble-Inventory-3.0
Revision: $Rev: 78482 $
Author(s): ckknight (ckknight@gmail.com), Daviesh (oma_daviesh@hotmail.com)
Documentation: http://www.wowace.com/wiki/LibBabble-Inventory-3.0
SVN: http://svn.wowace.com/wowace/trunk/LibBabble-Inventory-3.0
Dependencies: None
License: MIT
]]

local MAJOR_VERSION = "LibBabble-Inventory-3.0"
local MINOR_VERSION = "$Revision: 78482 $"

-- #AUTODOC_NAMESPACE prototype

local GAME_LOCALE = GetLocale()
do
	-- LibBabble-Core-3.0 is hereby placed in the Public Domain
	-- Credits: ckknight
	local LIBBABBLE_MAJOR, LIBBABBLE_MINOR = "LibBabble-3.0", 2

	local LibBabble = LibStub:NewLibrary(LIBBABBLE_MAJOR, LIBBABBLE_MINOR)
	if LibBabble then
		local data = LibBabble.data or {}
		for k,v in pairs(LibBabble) do
			LibBabble[k] = nil
		end
		LibBabble.data = data

		local tablesToDB = {}
		for namespace, db in pairs(data) do
			for k,v in pairs(db) do
				tablesToDB[v] = db
			end
		end

		local function warn(message)
			local _, ret = pcall(error, message, 3)
			geterrorhandler()(ret)
		end

		local lookup_mt = { __index = function(self, key)
			local db = tablesToDB[self]
			local current_key = db.current[key]
			if current_key then
				self[key] = current_key
				return current_key
			end
			local base_key = db.base[key]
			local real_MAJOR_VERSION
			for k,v in pairs(data) do
				if v == db then
					real_MAJOR_VERSION = k
					break
				end
			end
			if not real_MAJOR_VERSION then
				real_MAJOR_VERSION = LIBBABBLE_MAJOR
			end
			if base_key then
				warn(("%s: Translation %q not found for locale %q"):format(real_MAJOR_VERSION, key, GAME_LOCALE))
				rawset(self, key, base_key)
				return base_key
			end
			warn(("%s: Translation %q not found."):format(real_MAJOR_VERSION, key))
			rawset(self, key, key)
			return key
		end }

		local function initLookup(module, lookup)
			local db = tablesToDB[module]
			for k in pairs(lookup) do
				lookup[k] = nil
			end
			setmetatable(lookup, lookup_mt)
			tablesToDB[lookup] = db
			db.lookup = lookup
			return lookup
		end

		local function initReverse(module, reverse)
			local db = tablesToDB[module]
			for k in pairs(reverse) do
				reverse[k] = nil
			end
			for k,v in pairs(db.current) do
				reverse[v] = k
			end
			tablesToDB[reverse] = db
			db.reverse = reverse
			db.reverseIterators = nil
			return reverse
		end

		local prototype = {}
		local prototype_mt = {__index = prototype}

		--[[---------------------------------------------------------------------------
		Notes:
			* If you try to access a nonexistent key, it will warn but allow the code to pass through.
		Returns:
			A lookup table for english to localized words.
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			local BL = B:GetLookupTable()
			assert(BL["Some english word"] == "Some localized word")
			DoSomething(BL["Some english word that doesn't exist"]) -- warning!
		-----------------------------------------------------------------------------]]
		function prototype:GetLookupTable()
			local db = tablesToDB[self]

			local lookup = db.lookup
			if lookup then
				return lookup
			end
			return initLookup(self, {})
		end
		--[[---------------------------------------------------------------------------
		Notes:
			* If you try to access a nonexistent key, it will return nil.
		Returns:
			A lookup table for english to localized words.
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			local B_has = B:GetUnstrictLookupTable()
			assert(B_has["Some english word"] == "Some localized word")
			assert(B_has["Some english word that doesn't exist"] == nil)
		-----------------------------------------------------------------------------]]
		function prototype:GetUnstrictLookupTable()
			local db = tablesToDB[self]

			return db.current
		end
		--[[---------------------------------------------------------------------------
		Notes:
			* If you try to access a nonexistent key, it will return nil.
			* This is useful for checking if the base (English) table has a key, even if the localized one does not have it registered.
		Returns:
			A lookup table for english to localized words.
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			local B_hasBase = B:GetBaseLookupTable()
			assert(B_hasBase["Some english word"] == "Some english word")
			assert(B_hasBase["Some english word that doesn't exist"] == nil)
		-----------------------------------------------------------------------------]]
		function prototype:GetBaseLookupTable()
			local db = tablesToDB[self]

			return db.base
		end
		--[[---------------------------------------------------------------------------
		Notes:
			* If you try to access a nonexistent key, it will return nil.
			* This will return only one English word that it maps to, if there are more than one to check, see :GetReverseIterator("word")
		Returns:
			A lookup table for localized to english words.
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			local BR = B:GetReverseLookupTable()
			assert(BR["Some localized word"] == "Some english word")
			assert(BR["Some localized word that doesn't exist"] == nil)
		-----------------------------------------------------------------------------]]
		function prototype:GetReverseLookupTable()
			local db = tablesToDB[self]

			local reverse = db.reverse
			if reverse then
				return reverse
			end
			return initReverse(self, {})
		end
		local blank = {}
		local weakVal = {__mode='v'}
		--[[---------------------------------------------------------------------------
		Arguments:
			string - the localized word to chek for.
		Returns:
			An iterator to traverse all English words that map to the given key
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			for word in B:GetReverseIterator("Some localized word") do
				DoSomething(word)
			end
		-----------------------------------------------------------------------------]]
		function prototype:GetReverseIterator(key)
			local db = tablesToDB[self]
			local reverseIterators = db.reverseIterators
			if not reverseIterators then
				reverseIterators = setmetatable({}, weakVal)
				db.reverseIterators = reverseIterators
			elseif reverseIterators[key] then
				return pairs(reverseIterators[key])
			end
			local t
			for k,v in pairs(db.current) do
				if v == key then
					if not t then
						t = {}
					end
					t[k] = true
				end
			end
			reverseIterators[key] = t or blank
			return pairs(reverseIterators[key])
		end
		--[[---------------------------------------------------------------------------
		Returns:
			An iterator to traverse all translations English to localized.
		Example:
			local B = LibStub("LibBabble-Module-3.0") -- where Module is what you want.
			for english, localized in B:Iterate() do
				DoSomething(english, localized)
			end
		-----------------------------------------------------------------------------]]
		function prototype:Iterate()
			local db = tablesToDB[self]

			return pairs(db.current)
		end

		-- #NODOC
		-- modules need to call this to set the base table
		function prototype:SetBaseTranslations(base)
			local db = tablesToDB[self]
			local oldBase = db.base
			if oldBase then
				for k in pairs(oldBase) do
					oldBase[k] = nil
				end
				for k, v in pairs(base) do
					oldBase[k] = v
				end
				base = oldBase
			else
				db.base = base
			end
			for k,v in pairs(base) do
				if v == true then
					base[k] = k
				end
			end
		end

		local function init(module)
			local db = tablesToDB[module]
			if db.lookup then
				initLookup(module, db.lookup)
			end
			if db.reverse then
				initReverse(module, db.reverse)
			end
			db.reverseIterators = nil
		end

		-- #NODOC
		-- modules need to call this to set the current table. if current is true, use the base table.
		function prototype:SetCurrentTranslations(current)
			local db = tablesToDB[self]
			if current == true then
				db.current = db.base
			else
				local oldCurrent = db.current
				if oldCurrent then
					for k in pairs(oldCurrent) do
						oldCurrent[k] = nil
					end
					for k, v in pairs(current) do
						oldCurrent[k] = v
					end
					current = oldCurrent
				else
					db.current = current
				end
			end
			init(self)
		end

		for namespace, db in pairs(data) do
			setmetatable(db.module, prototype_mt)
			init(db.module)
		end

		-- #NODOC
		-- modules need to call this to create a new namespace.
		function LibBabble:New(namespace, minor)
			local module, oldminor = LibStub:NewLibrary(namespace, minor)
			if not module then
				return
			end

			if not oldminor then
				local db = {
					module = module,
				}
				data[namespace] = db
				tablesToDB[module] = db
			else
				for k,v in pairs(module) do
					module[k] = nil
				end
			end

			setmetatable(module, prototype_mt)

			return module
		end
	end
end

local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
if not lib then
	return
end

lib:SetBaseTranslations {
	["Armor"] = true,
	["Weapon"] = true,

	--Armor Types
	["Cloth"] = true,
	["Leather"] = true,
	["Mail"] = true,
	["Plate"] = true,

	--Armor Slots
	["Head"] = true,
	["Neck"] = true,
	["Shoulder"] = true,
	["Back"] = true,
	["Chest"] = true,
	["Shirt"] = true,
	["Tabard"] = true,
	["Wrist"] = true,
	["Hands"] = true,
	["Waist"] = true,
	["Legs"] = true,
	["Feet"] = true,
	["Ring"] = true,
	["Trinket"] = true,
	["Held in Off-Hand"] = true,
	["Relic"] = true,
	["Libram"] = true,
	["Totem"] = true,
	["Idol"] = true,

	-- Armor Sub Types
	["Librams"] = true,  -- GetItemInfo() returns this as an ItemSubType.
	["Idols"] = true,  -- GetItemInfo() returns this as an ItemSubType.
	["Totems"] = true,  -- GetItemInfo() returns this as an ItemSubType.
	["Shields"] = true, -- GetItemInfo() returns this as an ItemSubType.

	--Weapons
	["Axe"] = true,
	["Bow"] = true,
	["Crossbow"] = true,
	["Dagger"] = true,
	["Fist Weapon"] = true,
	["Gun"] = true,
	["Mace"] = true,
	["Polearm"] = true,
	["Shield"] = true,
	["Staff"] = true,
	["Sword"] = true,
	["Thrown"] = true,
	["Wand"] = true,

	--Weapon Types
	["One-Hand"] = true,
	["Two-Hand"] = true,
	["Main Hand"] = true,
	["Off Hand"] = true,
	["Ranged"] = true,

	--Weapon sub-types
	["Bows"] = true,
	["Crossbows"] = true,
	["Daggers"] = true,
	["Guns"] = true,
	["Fishing Pole"] = true,
	["Fishing Poles"] = true, -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
	["Fist Weapons"] = true,
	["Miscellaneous"] = true,
	["One-Handed Axes"] = true,
	["One-Handed Maces"] = true,
	["One-Handed Swords"] = true,
	["Polearms"] = true,
	["Staves"] = true,
	["Thrown"] = true,
	["Two-Handed Axes"] = true,
	["Two-Handed Maces"] = true,
	["Two-Handed Swords"] = true,
	["Wands"] = true,

	--Consumable
	["Consumable"] = true,
	["Drink"] = true,
	["Food"] = true,
	["Food & Drink"] = true, -- New 2.3
	["Potion"] = true, -- New 2.3
	["Elixir"] = true, -- New 2.3
	["Flask"] = true, -- New 2.3
	["Bandage"] = true, -- New 2.3
	["Item Enhancement"] = true, -- New 2.3
	["Scroll"] = true, -- New 2.3
	["Other"] = true,  -- New 2.3

	--Container
	["Container"] = true,
	["Bag"] = true,
	["Enchanting Bag"] = true,
	["Engineering Bag"] = true,
	["Gem Bag"] = true,
	["Herb Bag"] = true,
	["Mining Bag"] = true,
	["Soul Bag"] = true,
	["Leatherworking Bag"] = true, -- New 2.3

	--Gem
	["Gem"] = true,
	["Blue"] = true,
	["Green"] = true,
	["Orange"] = true,
	["Meta"] = true,
	["Prismatic"] = true,
	["Purple"] = true,
	["Red"] = true,
	["Simple"] = true,
	["Yellow"] = true,

	--Key
	["Key"] = true,

	--Reagent
	["Reagent"] = true,

	--Recipe
	["Recipe"] = true,
	["Alchemy"] = true,
	["Blacksmithing"] = true,
	["Book"] = true,
	["Cooking"] = true,
	["Enchanting"] = true,
	["Engineering"] = true,
	["First Aid"] = true,
	["Leatherworking"] = true,
	["Tailoring"] = true,
	["Jewelcrafting"] = true,
	["Fishing"] = true,

	--Projectile
	["Projectile"] = true,
	["Arrow"] = true,
	["Bullet"] = true,

	--Quest
	["Quest"] = true,

	--Quiver
	["Quiver"] = true,
	["Ammo Pouch"] = true,

	--Trade Goods
	["Trade Goods"] = true,
	["Devices"] = true,
	["Explosives"] = true,
	["Parts"] = true,
	["Elemental"] = true, -- New 2.3
	["Metal & Stone"] = true, -- New 2.3
	["Meat"] = true, -- New 2.3
	["Herb"] = true, -- New 2.3
	-- Cloth already defined
	-- Leather already defined
	-- Enchanting already defined
	-- Jewelcrafting already defined
	["Materials"] = true, -- New 2.4.2
	-- Other already defined

	--Miscellaneous
	["Junk"] = true,
	["Pet"] = true, -- New 2.3
	["Holiday"] = true, -- New 2.3
	-- Reagent already defined
	["Mount"] = true, -- New 2.4.2
	-- Other already defined
}

if GAME_LOCALE == "enUS" then
	lib:SetCurrentTranslations(true)
elseif GAME_LOCALE == "deDE" then
	lib:SetCurrentTranslations {
		["Armor"] = "Rüstung",
		["Weapon"] = "Waffe",

		--Armor Types
		["Cloth"] = "Stoff",
		["Leather"] = "Leder",
		["Mail"] = "Schwere Rüstung",
		["Plate"] = "Platte",

		--Armor Slots
		["Head"] = "Kopf",
		["Neck"] = "Hals",
		["Shoulder"] = "Schulter",
		["Back"] = "Rücken",
		["Chest"] = "Brust",
		["Shirt"] = "Hemd",
		["Tabard"] = "Wappenrock",
		["Wrist"] = "Handgelenke",
		["Hands"] = "Hände",
		["Waist"] = "Taille",
		["Legs"] = "Beine",
		["Feet"] = "Füße",
		["Ring"] = "Finger",
		["Trinket"] = "Schmuck",
		["Held in Off-Hand"] = "In Schildhand geführt",
		["Relic"] = "Relikt",
		["Libram"] = "Buchband",
		["Totem"] = "Totem",
		["Idol"] = "Götze",

		-- Armor Sub Types
		["Librams"] = "Buchbände",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "Götzen",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "Totems",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "Schilde", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "Axt",
		["Bow"] = "Bogen",
		["Crossbow"] = "Armbrust",
		["Dagger"] = "Dolch",
		["Fist Weapon"] = "Faustwaffe",
		["Gun"] = "Schusswaffe",
		["Mace"] = "Streitkolben",
		["Polearm"] = "Stangenwaffe",
		["Shield"] = "Schild",
		["Staff"] = "Stab",
		["Sword"] = "Schwert",
		["Thrown"] = "Wurfwaffe",
		["Wand"] = "Zauberstab",

		--Weapon Types
		["One-Hand"] = "Einhändig",
		["Two-Hand"] = "Zweihändig",
		["Main Hand"] = "Waffenhand",
		["Off Hand"] = "Schildhand",
		["Ranged"] = "Distanz",

		--Weapon sub-types
		["Bows"] = "Bögen",
		["Crossbows"] = "Armbrüste",
		["Daggers"] = "Dolche",
		["Guns"] = "Schusswaffen",
		["Fishing Pole"] = "Angelrute",
		["Fishing Poles"] = "Angelruten", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "Faustwaffen",
		["Miscellaneous"] = "Verschiedenes",
		["One-Handed Axes"] = "Einhandäxte",
		["One-Handed Maces"] = "Einhandstreitkolben",
		["One-Handed Swords"] = "Einhandschwerter",
		["Polearms"] = "Stangenwaffen",
		["Staves"] = "Stäbe",
		["Thrown"] = "Wurfwaffen",
		["Two-Handed Axes"] = "Zweihandäxte",
		["Two-Handed Maces"] = "Zweihandstreitkolben",
		["Two-Handed Swords"] = "Zweihandschwerter",
		["Wands"] = "Zauberstäbe",

		--Consumable
		["Consumable"] = "Verbrauchbar",
		["Drink"] = "Getränk",
		["Food"] = "Essen",
		["Food & Drink"] = "Essen & Trinken", -- New 2.3
		["Potion"] = "Trank", -- New 2.3
		["Elixir"] = "Elixier", -- New 2.3
		["Flask"] = "Fläschchen", -- New 2.3
		["Bandage"] = "Verband", -- New 2.3
		["Item Enhancement"] = "Gegenstandsverbesserung", -- New 2.3
		["Scroll"] = "Rolle", -- New 2.3
		["Other"] = "Sonstige",  -- New 2.3

		--Container
		["Container"] = "Behälter",
		["Bag"] = "Behälter",
		["Enchanting Bag"] = "Verzauberertasche",
		["Engineering Bag"] = "Ingenieurstasche",
		["Gem Bag"] = "Edelsteintasche",
		["Herb Bag"] = "Kräutertasche",
		["Mining Bag"] = "Bergbautasche",
		["Soul Bag"] = "Seelentasche",
		["Leatherworking Bag"] = "Lederertasche", -- New 2.3

		--Gem
		["Gem"] = "Edelstein",
		["Blue"] = "Blau",
		["Green"] = "Grün",
		["Orange"] = "Orange",
		["Meta"] = "Meta",
		["Prismatic"] = "Prismatisch",
		["Purple"] = "Violett",
		["Red"] = "Rot",
		["Simple"] = "Einfach",
		["Yellow"] = "Gelb",

		--Key
		["Key"] = "Schlüssel",

		--Reagent
		["Reagent"] = "Reagenz",

		--Recipe
		["Recipe"] = "Rezept",
		["Alchemy"] = "Alchimie",
		["Blacksmithing"] = "Schmiedekunst",
		["Book"] = "Buch",
		["Cooking"] = "Kochkunst",
		["Enchanting"] = "Verzauberkunst",
		["Engineering"] = "Ingenieurskunst",
		["First Aid"] = "Erste Hilfe",
		["Leatherworking"] = "Lederverarbeitung",
		["Tailoring"] = "Schneiderei",
		["Jewelcrafting"] = "Juwelenschleifen",
		["Fishing"] = "Angeln",

		--Projectile
		["Projectile"] = "Projektil",
		["Arrow"] = "Pfeil",
		["Bullet"] = "Kugel",

		--Quest
		["Quest"] = "Quest",

		--Quiver
		["Quiver"] = "Köcher",
		["Ammo Pouch"] = "Munitionsbeutel",

		--Trade Goods
		["Trade Goods"] = "Handwerkswaren",
		["Devices"] = "Geräte",
		["Explosives"] = "Sprengstoff",
		["Parts"] = "Teile",
		["Elemental"] = "Elementar", -- New 2.3
		["Metal & Stone"] = "Metall & Stein", -- New 2.3
		["Meat"] = "Fleisch", -- New 2.3
		["Herb"] = "Kräuter", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		["Materials"] = "Materialien", -- New 2.4.2
		-- Other already defined

		--Miscellaneous
		["Junk"] = "Plunder",
		["Pet"] = "Begleiter", -- New 2.3
		["Holiday"] = "Festtag", -- New 2.3
		-- Reagent already defined
		["Mount"] = "Reittier", -- New 2.4.2
		-- Other already defined
	}
elseif GAME_LOCALE == "frFR" then
	lib:SetCurrentTranslations {
		["Armor"] = "Armure",
		["Weapon"] = "Arme",

		--Armor Types
		["Cloth"] = "Tissu",
		["Leather"] = "Cuir",
		["Mail"] = "Mailles",
		["Plate"] = "Plaques",

		--Armor Slots
		["Head"] = "T\195\170te",
		["Neck"] = "Cou",
		["Shoulder"] = "Epaule",
		["Back"] = "Dos",
		["Chest"] = "Torse",
		["Shirt"] = "Chemise",
		["Tabard"] = "Tabard",
		["Wrist"] = "Poignets",
		["Hands"] = "Mains",
		["Waist"] = "Taille",
		["Legs"] = "Jambes",
		["Feet"] = "Pieds",
		["Ring"] = "Anneau",
		["Trinket"] = "Bijou",
		["Held in Off-Hand"] = "Tenu(e) en main gauche",
		["Relic"] = "Relique",
		["Libram"] = "Libram",
		["Totem"] = "Totem",
		["Idol"] = "Idole",

		-- Armor Sub Types
		["Librams"] = "Librams",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "Idoles",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "Totems",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "Boucliers", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "Hache",
		["Bow"] = "Arc",
		["Crossbow"] = "Arbal\195\168te",
		["Dagger"] = "Dague",
		["Fist Weapon"] = "Arme de pugilat",
		["Gun"] = "Arme \195\160 feu",
		["Mace"] = "Masse",
		["Polearm"] = "Arme d'hast",
		["Shield"] = "Bouclier",
		["Staff"] = "B\195\162ton",
		["Sword"] = "Ep\195\169e",
		["Thrown"] = "Armes de jet",
		["Wand"] = "Baguette",

		--Weapon Types
		["One-Hand"] = "A une main",
		["Two-Hand"] = "Deux mains",
		["Main Hand"] = "Main droite",
		["Off Hand"] = "Main gauche",
		--["Ranged"] = true,		-- translation required

		--Weapon sub-types
		["Bows"] = "Arcs",
		["Crossbows"] = "Arbalètes",
		["Daggers"] = "Dagues",
		["Guns"] = "Fusils",
		["Fishing Pole"] = "Canne à pêche",
		["Fishing Poles"] = "Cannes à pêche", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "Armes de pugilat",
		["Miscellaneous"] = "Divers",
		["One-Handed Axes"] = "Haches à une main",
		["One-Handed Maces"] = "Masses à une main",
		["One-Handed Swords"] = "Epées à une main",
		["Polearms"] = "Armes d'hast",
		["Staves"] = "Bâtons",
		["Thrown"] = "Armes de jets",
		["Two-Handed Axes"] =  "Haches à deux mains",
		["Two-Handed Maces"] = "Masses à deux mains",
		["Two-Handed Swords"] = "Epées à deux mains",
		["Wands"] = "Baguettes",

		--Consumable
		["Consumable"] = "Consommable",
		["Drink"] = "Breuvage",
		["Food"] = "Ration",
		["Food & Drink"] = "Nourriture & boissons", -- New 2.3
		["Potion"] = "Potion", -- New 2.3
		["Elixir"] = "Élixir", -- New 2.3
		["Flask"] = "Flacon", -- New 2.3
		["Bandage"] = "Bandage", -- New 2.3
		["Item Enhancement"] = "Amélioration d'objet", -- New 2.3
		["Scroll"] = "Parchemin", -- New 2.3
		["Other"] = "Autre",  -- New 2.3

		--Container
		-- ["Container"] = true,			-- translation required
		["Bag"] = "Sac",
		["Enchanting Bag"] = "Sac d'enchantement",
		["Engineering Bag"] = "Sac d'ingéniérie",
		["Gem Bag"] = "Sac de gemmes",
		["Herb Bag"] = "Sac d'herbes",
		["Mining Bag"] = "Sac de mineur",
		["Soul Bag"] = "Sac d'âme",
		["Leatherworking Bag"] = "Sac de travailleur du cuir",

		--Gem
		["Gem"] = "Gemme",
		["Blue"] = "Bleu",
		["Green"] = "Verte",
		["Orange"] = "Orange",
		["Meta"] = "Méta",
		["Prismatic"] = "Prismatique",
		["Purple"] = "Violette",
		["Red"] = "Rouge",
		["Simple"] = "Simple",
		["Yellow"] = "Jaune",

		--Key
		["Key"] = "Cl\195\169",

		--Reagent
		--["Reagent"] = true,		-- translation required

		--Recipe
		["Recipe"] = "Recette",
		["Alchemy"] = "Alchimie",
		["Blacksmithing"] = "Forge",
		["Book"] = "Livre",
		["Cooking"] = "Cuisine",
		["Enchanting"] = "Enchantement",
		["Engineering"] = "Ingénierie",
		["First Aid"] = "Secourisme",
		["Leatherworking"] = "Travail du cuir",
		["Tailoring"] = "Couture",
		["Jewelcrafting"] = "Joaillerie",
		["Fishing"] = "Pêche",

		--Projectile
		-- ["Projectile"] = true,			-- translation required
		["Arrow"] = "Fl\195\168che",
		["Bullet"] = "Balle",

		--Quest
		-- ["Quest"] = true,			-- translation required

		--Quiver
		["Quiver"] = "Carquois",
		["Ammo Pouch"] = "Giberne",

		--Trade Goods
		["Trade Goods"] = "Artisanat",
		["Devices"] = "Élémentaire",
		["Explosives"] = "Explosifs",
		["Parts"] = "Eléments",
		["Elemental"] = "Élémentaire", -- New 2.3
		["Metal & Stone"] = "Métal & pierre", -- New 2.3
		["Meat"] = "Viande", -- New 2.3
		["Herb"] = "Herbes", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		-- Other already defined

		--Miscellaneous
		-- ["Junk"] = true,					-- translation required
		 ["Pet"] = "Familier", -- New 2.3			-- translation required
		-- ["Holiday"] = true, -- New 2.3		-- translation required
		-- Reagent already defined
		-- Other already defined
	}
elseif GAME_LOCALE == "zhTW" then
	lib:SetCurrentTranslations {
		["Armor"] = "護甲",
		["Weapon"] = "武器",

		--Armor Types
		["Cloth"] = "布甲",
		["Leather"] = "皮甲",
		["Mail"] = "鎖甲",
		["Plate"] = "鎧甲",

		--Armor Slots
		["Head"] = "頭部",
		["Neck"] = "頸部",
		["Shoulder"] = "肩部",
		["Back"] = "背部",
		["Chest"] = "胸部",
		["Shirt"] = "襯衣",
		["Tabard"] = "公會徽章",
		["Wrist"] = "手腕",
		["Hands"] = "手",
		["Waist"] = "腰部",
		["Legs"] = "腿部",
		["Feet"] = "腳",
		["Ring"] = "手指",
		["Trinket"] = "飾品",
		["Held in Off-Hand"] = "副手物品",
		["Relic"] = "聖物",
		["Libram"] = "聖契",
		["Totem"] = "圖騰",
		["Idol"] = "塑像",

		-- Armor Sub Types
		["Librams"] = "聖契",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "塑像",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "圖騰",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "盾牌", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "斧",
		["Bow"] = "弓",
		["Crossbow"] = "弩",
		["Dagger"] = "匕首",
		["Fist Weapon"] = "拳套",
		["Gun"] = "槍械",
		["Mace"] = "錘",
		["Polearm"] = "長柄武器",
		["Shield"] = "盾牌",
		["Staff"] = "法杖",
		["Sword"] = "劍",
		["Thrown"] = "投擲武器",
		["Wand"] = "魔杖",

		--Weapon Types
		["One-Hand"] = "單手",
		["Two-Hand"] = "雙手",
		["Main Hand"] = "主手",
		["Off Hand"] = "副手",
		["Ranged"] = "遠程",

		--Weapon sub-types
		["Bows"] = "弓",
		["Crossbows"] = "弩",
		["Daggers"] = "匕首",
		["Guns"] = "槍械",
		["Fishing Pole"] = "魚竿",
		["Fishing Poles"] = "魚竿", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "拳套",
		["Miscellaneous"] = "其他",
		["One-Handed Axes"] = "單手斧",
		["One-Handed Maces"] = "單手錘",
		["One-Handed Swords"] = "單手劍",
		["Polearms"] = "長柄武器",
		["Staves"] = "法杖",
		["Thrown"] = "投擲武器",
		["Two-Handed Axes"] = "雙手斧",
		["Two-Handed Maces"] = "雙手錘",
		["Two-Handed Swords"] = "雙手劍",
		["Wands"] = "魔杖",

		--Consumable
		["Consumable"] = "消耗品",
		["Drink"] = "飲料",
		["Food"] = "食物",
		["Food & Drink"] = "食物和飲料", -- New 2.3
		["Potion"] = "藥水", -- New 2.3
		["Elixir"] = "藥劑", -- New 2.3
		["Flask"] = "精煉藥劑", -- New 2.3
		["Bandage"] = "繃帶", -- New 2.3
		["Item Enhancement"] = "物品強化", -- New 2.3
		["Scroll"] = "卷軸", -- New 2.3
		["Other"] = "其他",  -- New 2.3

		["Container"] = "容器",
		["Bag"] = "容器",
		["Enchanting Bag"] = "附魔包",
		["Engineering Bag"] = "工程包",
		["Gem Bag"] = "寶石背包",
		["Herb Bag"] = "草藥包",
		["Mining Bag"] = "礦石包",
		["Soul Bag"] = "靈魂裂片包",
		["Leatherworking Bag"] = "製皮包", -- New 2.3

		--Gem
		["Gem"] = "寶石",
		["Blue"] = "藍色",
		["Green"] = "綠色",
		["Orange"] = "橘色",
		["Meta"] = "變換",
		["Prismatic"] = "稜彩",
		["Purple"] = "紫色",
		["Red"] = "紅色",
		["Simple"] = "簡單",
		["Yellow"] = "黃色",

		--Key
		["Key"] = "鑰匙",

		--Reagent
		["Reagent"] = "施法材料",

		--Recipe
		["Recipe"] = "配方",
		["Alchemy"] = "鍊金術",
		["Blacksmithing"] = "鍛造",
		["Book"] = "書籍",
		["Cooking"] = "烹飪",
		["Enchanting"] = "附魔",
		["Engineering"] = "工程學",
		["First Aid"] = "急救",
		["Leatherworking"] = "製皮",
		["Tailoring"] = "裁縫",
		["Jewelcrafting"] = "珠寶設計",
		["Fishing"] = "釣魚",

		--Projectile
		["Projectile"] = "彈藥",
		["Arrow"] = "箭",
		["Bullet"] = "子彈",

		--Quest
		["Quest"] = "任務",

		--Quiver
		["Quiver"] = "箭袋",
		["Ammo Pouch"] = "彈藥袋",

		--Trade Goods
		["Trade Goods"] = "商品",
		["Devices"] = "裝置",
		["Explosives"] = "爆裂物",
		["Parts"] = "零件",
		["Elemental"] = "元素材料", -- New 2.3
		["Metal & Stone"] = "金屬和石頭", -- New 2.3
		["Meat"] = "肉類", -- New 2.3
		["Herb"] = "草藥", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		-- Other already defined


		--Miscellaneous
		["Junk"] = "垃圾",
		["Pet"] = "寵物", -- New 2.3
		["Holiday"] = "節慶用品", -- New 2.3
		-- Reagent already defined
		["Mount"] = "坐騎", -- New 2.4.2
		-- Other already defined
	}
elseif GAME_LOCALE == "zhCN" then
	lib:SetCurrentTranslations {
		["Armor"] = "护甲",
		["Weapon"] = "武器",

		--Armor Types
		["Cloth"] = "布甲",
		["Leather"] = "皮甲",
		["Mail"] = "锁甲",
		["Plate"] = "板甲",

		--Armor Slots
		["Head"] = "头部",
		["Neck"] = "颈部",
		["Shoulder"] = "肩部",
		["Back"] = "背部",
		["Chest"] = "胸部",
		["Shirt"] = "衬衫",
		["Tabard"] = "徽章",
		["Wrist"] = "手腕",
		["Hands"] = "手",
		["Waist"] = "腰部",
		["Legs"] = "腿部",
		["Feet"] = "脚",
		["Ring"] = "手指",
		["Trinket"] = "饰品",
		["Held in Off-Hand"] = "副手物品",
		["Relic"] = "圣物",
		["Libram"] = "圣契",
		["Totem"] = "图腾",
		["Idol"] = "神像",

		-- Armor Sub Types
		["Librams"] = "圣契",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "神像",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "图腾",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "盾牌", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "斧",
		["Bow"] = "弓",
		["Crossbow"] = "弩",
		["Dagger"] = "匕首",
		["Fist Weapon"] = "拳套",
		["Gun"] = "枪械",
		["Mace"] = "锤",
		["Polearm"] = "长柄武器",
		["Shield"] = "盾牌",
		["Staff"] = "法杖",
		["Sword"] = "剑",
		["Thrown"] = "投掷武器",
		["Wand"] = "魔杖",

		--Weapon Types
		["One-Hand"] = "单手",
		["Two-Hand"] = "双手",
		["Main Hand"] = "主手",
		["Off Hand"] = "副手",
		["Ranged"] = "远程",

		--Weapon sub-types
		["Bows"] = "弓",
		["Crossbows"] = "弩",
		["Daggers"] = "匕首",
		["Guns"] = "枪械",
		["Fishing Pole"] = "鱼竿",
		["Fishing Poles"] = "鱼竿", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "拳套",
		["Miscellaneous"] = "其他",
		["One-Handed Axes"] = "单手斧",
		["One-Handed Maces"] = "单手锤",
		["One-Handed Swords"] = "单手剑",
		["Polearms"] = "长柄武器",
		["Staves"] = "法杖",
		["Thrown"] = "投掷武器",
		["Two-Handed Axes"] = "双手斧",
		["Two-Handed Maces"] = "双手锤",
		["Two-Handed Swords"] = "双手剑",
		["Wands"] = "魔杖",

		--Consumable
		["Consumable"] = "消耗品",
		["Drink"] = "饮料",
		["Food"] = "食物",
		["Food & Drink"] = "食物和饮料", -- New 2.3
		["Potion"] = "药水", -- New 2.3
		["Elixir"] = "药剂", -- New 2.3
		["Flask"] = "合剂", -- New 2.3
		["Bandage"] = "绷带", -- New 2.3
		["Item Enhancement"] = "物品强化", -- New 2.3
		["Scroll"] = "卷轴", -- New 2.3
		["Other"] = "其它",  -- New 2.3

		--Container
		["Container"] = "容器",
		["Bag"] = "容器",
		["Enchanting Bag"] = "附魔材料袋",
		["Engineering Bag"] = "工程学材料袋",
		["Gem Bag"] = "宝石袋",
		["Herb Bag"] = "草药袋",
		["Mining Bag"] = "矿石袋",
		["Soul Bag"] = "灵魂袋",
		["Leatherworking Bag"] = "制皮材料袋", -- New 2.3

		--Gem
		["Gem"] = "宝石",
		["Blue"] = "蓝色",
		["Green"] = "绿色",
		["Orange"] = "橙色",
		["Meta"] = "多彩",
		["Prismatic"] = "棱彩",
		["Purple"] = "紫色",
		["Red"] = "红色",
		["Simple"] = "简易",
		["Yellow"] = "黄色",

		--Key
		["Key"] = "钥匙",

		--Reagent
		["Reagent"] = "材料",

		--Recipe
		["Recipe"] = "配方",
		["Alchemy"] = "炼金术",
		["Blacksmithing"] = "锻造",
		["Book"] = "书籍",
		["Cooking"] = "烹饪",
		["Enchanting"] = "附魔",
		["Engineering"] = "工程学",
		["First Aid"] = "急救",
		["Leatherworking"] = "制皮",
		["Tailoring"] = "裁缝",
		["Jewelcrafting"] = "珠宝加工",
		["Fishing"] = "钓鱼",

		--Projectile
		["Projectile"] = "弹药",
		["Arrow"] = "箭",
		["Bullet"] = "子弹",

		--Quest
		["Quest"] = "任务",

		--Quiver
		["Quiver"] = "箭袋",
		["Ammo Pouch"] = "弹药袋",

		--Trade Goods
		["Trade Goods"] = "商品",
		["Devices"] = "装置",
		["Explosives"] = "爆炸物",
		["Parts"] = "零件",
		["Elemental"] = "元素", -- New 2.3
		["Metal & Stone"] = "金属和矿石", -- New 2.3
		["Meat"] = "肉类", -- New 2.3
		["Herb"] = "草药", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		["Materials"] = "原料", -- New 2.4.2
		-- Other already defined


		--Miscellaneous
		["Junk"] = "垃圾",
		["Pet"] = "宠物", -- New 2.3
		["Holiday"] = "节日", -- New 2.3
		-- Reagent already defined
		["Mount"] = "坐骑", -- New 2.4.2
		-- Other already defined
	}
elseif GAME_LOCALE == "koKR" then
	lib:SetCurrentTranslations {
		["Armor"] = "방어구",
		["Weapon"] = "무기",

		--Armor Types
		["Cloth"] = "천",
		["Leather"] = "가죽",
		["Mail"] = "사슬",
		["Plate"] = "판금",

		--Armor Slots
		["Head"] = "머리",
		["Neck"] = "목",
		["Shoulder"] = "어깨",
		["Back"] = "등",
		["Chest"] = "가슴",
		["Shirt"] = "속옷",
		["Tabard"] = "휘장",
		["Wrist"] = "손목",
		["Hands"] = "손",
		["Waist"] = "허리",
		["Legs"] = "다리",
		["Feet"] = "발",
		["Ring"] = "손가락",
		["Trinket"] = "장신구",
		["Held in Off-Hand"] = "보조장비",
		["Relic"] = "유물",
		["Libram"] = "성서",
		["Totem"] = "토템",
		["Idol"] = "우상",

		-- Armor Sub Types
		["Librams"] = "성서",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "우상",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "토템",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "방패", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "도끼",
		["Bow"] = "활",
		["Crossbow"] = "석궁",
		["Dagger"] = "단검",
		["Fist Weapon"] = "장착 무기",
		["Gun"] = "총기",
		["Mace"] = "둔기",
		["Polearm"] = "장창",
		["Shield"] = "방패",
		["Staff"] = "지팡이",
		["Sword"] = "도검",
		["Thrown"] = "투척 무기",
		["Wand"] = "마법봉",

		--Weapon Types
		["One-Hand"] = "한손",
		["Two-Hand"] = "양손",
		["Main Hand"] = "주장비",
		["Off Hand"] = "보조장비",
		["Ranged"] = "원거리 장비",

		--Weapon sub-types
		["Bows"] = "활류",
		["Crossbows"] = "석궁류",
		["Daggers"] = "단검류",
		["Guns"] = "총기류",
		["Fishing Pole"] = "낚싯대",
		["Fishing Poles"] = "낚싯대", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "장착 무기류",
		["Miscellaneous"] = "기타",
		["One-Handed Axes"] = "한손 도끼류",
		["One-Handed Maces"] = "한손 둔기류",
		["One-Handed Swords"] = "한손 도검류",
		["Polearms"] = "장창류",
		["Staves"] = "지팡이류",
		["Thrown"] = "투척 무기류",
		["Two-Handed Axes"] = "양손 도끼류",
		["Two-Handed Maces"] = "양손 둔기류",
		["Two-Handed Swords"] = "양손 도검류",
		["Wands"] = "마법봉류",

		--Consumable
		["Consumable"] = "소비용품",
		["Drink"] = "음료",
		["Food"] = "음식",
		["Food & Drink"] = "음식과 음료", -- New 2.3
		["Potion"] = "물약", -- New 2.3
		["Elixir"] = "비약", -- New 2.3
		["Flask"] = "영약", -- New 2.3
		["Bandage"] = "붕대", -- New 2.3
		["Item Enhancement"] = "아이템 강화", -- New 2.3
		["Scroll"] = "두루마리", -- New 2.3
		["Other"] = "기타",  -- New 2.3

		--Container
		["Container"] = "보관함",
		["Bag"] = "가방",
		["Enchanting Bag"] = "마법부여 가방",
		["Engineering Bag"] = "기계공학 가방",
		["Gem Bag"] = "보석 가방",
		["Herb Bag"] = "약초 가방",
		["Mining Bag"] = "채광 가방",
		["Soul Bag"] = "영혼의 가방",
		["Leatherworking Bag"] = "가죽세공 가방", -- New 2.3

		--Gem
		["Gem"] = "보석",
		["Blue"] = "푸른색",
		["Green"] = "녹색",
		["Orange"] = "주황색 (노란+붉은)",
		["Meta"] = "얼개",
		["Prismatic"] = "다색",
		["Purple"] = "보라색 (붉은+푸른)",
		["Red"] = "붉은색",
		["Simple"] = "일반",
		["Yellow"] = "노란색 (노란+푸른)",

		--Key
		["Key"] = "열쇠",

		--Reagent
		["Reagent"] = "재료",

		--Recipe
		["Recipe"] = "제조법",
		["Alchemy"] = "연금술",
		["Blacksmithing"] = "대장기술",
		["Book"] = "책",
		["Cooking"] = "요리",
		["Enchanting"] = "마법부여",
		["Engineering"] = "기계공학",
		["First Aid"] = "응급치료",
		["Leatherworking"] = "가죽세공",
		["Tailoring"] = "재봉술",
		["Jewelcrafting"] = "보석세공",
		["Fishing"] = "낚시",

		--Projectile
		["Projectile"] = "투사체",
		["Arrow"] = "화살",
		["Bullet"] = "탄환",

		--Quest
		["Quest"] = "퀘스트",

		--Quiver
		["Quiver"] = "화살통",
		["Ammo Pouch"] = "탄약 주머니",

		--Trade Goods
		["Trade Goods"] = "직업용품",
		["Devices"] = "기계 장치",
		["Explosives"] = "폭발물",
		["Parts"] = "부품",
		["Elemental"] = "원소", -- New 2.3
		["Metal & Stone"] = "광물", -- New 2.3
		["Meat"] = "고기", -- New 2.3
		["Herb"] = "약초", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		["Materials"] = "재료", -- New 2.4.2
		-- Other already defined

		--Miscellaneous
		["Junk"] = "잡동사니",
		["Pet"] = "애완동물", -- New 2.3
		["Holiday"] = "축제용품", -- New 2.3
		-- Reagent already defined
		["Mount"] = "탈것", -- New 2.4.2
		-- Other already defined
	}
elseif GAME_LOCALE == "esES" then
	lib:SetCurrentTranslations {

		["Armor"] = "Armadura",
		["Weapon"] = "Arma",

		--Armor Types
		["Cloth"] = "Tela",
		["Leather"] = "Cuero",
		["Mail"] = "Malla",
		["Plate"] = "Placas",

		--Armor Slots
		["Head"] = "Cabeza",
		["Neck"] = "Cuello",
		["Shoulder"] = "Hombro",
		["Back"] = "Espalda",
		["Chest"] = "Pecho",
		["Shirt"] = "Camisa",
		["Tabard"] = "Tabardo",
		["Wrist"] = "Muñeca",
		["Hands"] = "Manos",
		["Waist"] = "Cintura",
		["Legs"] = "Piernas",
		["Feet"] = "Pies",
		["Ring"] = "Dedo",
		["Trinket"] = "Alhaja",
		["Held in Off-Hand"] = "Sostener con la mano izquierda",
		["Relic"] = "Reliquia",
		["Libram"] = "Tratado",
		["Totem"] = "Tótem",
		["Idol"] = "Ídolo",

		-- Armor Sub Types
		["Librams"] = "Tratados",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "Ídolos",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "Tótems",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "Escudos", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "Hacha",
		["Bow"] = "Arco",
		["Crossbow"] = "Ballesta",
		["Dagger"] = "Daga",
		["Fist Weapon"] = "Arma de puño",
		["Gun"] = "Arma de fuego",
		["Mace"] = "Maza",
		["Polearm"] = "Arma de asta",
		["Shield"] = "Escudo",
		["Staff"] = "Bastón",
		["Sword"] = "Espada",
		["Thrown"] = "Arma arrojadiza",
		["Wand"] = "Varita",

		--Weapon Types
		["One-Hand"] = "Una mano",
		["Two-Hand"] = "Dos manos",
		["Main Hand"] = "Mano derecha",
		["Off Hand"] = "Mano izquierda",
		["Ranged"] = "Distancia",

		--Weapon sub-types
		["Bows"] = "Arcos",
		["Crossbows"] = "Ballestas",
		["Daggers"] = "Dagas",
		["Guns"] = "Armas de fuego",
		["Fishing Pole"] = "Caña de pescar",
		["Fishing Poles"] = "Cañas de pescar", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "Armas de puño",
		["Miscellaneous"] = "Miscelánea",
		["One-Handed Axes"] = "Hachas de una mano",
		["One-Handed Maces"] = "Mazas de una mano",
		["One-Handed Swords"] = "Espadas de una mano",
		["Polearms"] = "Armas de asta",
		["Staves"] = "Bastones",
		["Thrown"] = "Armas arrojadizas",
		["Two-Handed Axes"] = "Hachas de dos manos",
		["Two-Handed Maces"] = "Mazas de dos manos",
		["Two-Handed Swords"] = "Espadas de dos manos",
		["Wands"] = "Varitas",

		--Consumable
		["Consumable"] = "Consumible",
		["Drink"] = "Bebida",
		["Food"] = "Comida",
		["Food & Drink"] = "Comida y Bebida", -- New 2.3
		["Potion"] = "Poción", -- New 2.3
		["Elixir"] = "Elixir", -- New 2.3
		["Flask"] = "Matraz", -- New 2.3
		["Bandage"] = "Venda", -- New 2.3
		["Item Enhancement"] = "Mejora de Objeto", -- New 2.3
		["Scroll"] = "Pergamino", -- New 2.3
		["Other"] = "Otro",  -- New 2.3

		--Container
		["Container"] = "Contenedor",
		["Bag"] = "Bolsa",
		["Enchanting Bag"] = "Bolsa de Encantamientos",
		["Engineering Bag"] = "Bolsa de Ingeniería",
		["Gem Bag"] = "Bolsa de Gemas",
		["Herb Bag"] = "Bolsa de Hierbas",
		["Mining Bag"] = "Bolsa de Minería",
		["Soul Bag"] = "Bolsa de Almas",
		["Leatherworking Bag"] = "Bolsa de Peletería", -- New 2.3

		--Gem
		["Gem"] = "Gema",
		["Blue"] = "Azul",
		["Green"] = "Verde",
		["Orange"] = "Naranja",
		["Meta"] = "Meta",
		["Prismatic"] = "Prismático",
		["Purple"] = "Púrpura",
		["Red"] = "Rojo",
		["Simple"] = "Simple",
		["Yellow"] = "Amarillo",

		--Key
		["Key"] = "Llave",

		--Reagent
		["Reagent"] = "Reactivo",

		--Recipe
		["Recipe"] = "Receta",
		["Alchemy"] = "Alquimia",
		["Blacksmithing"] = "Herrería",
		["Book"] = "Libro",
		["Cooking"] = "Cocina",
		["Enchanting"] = "Encantamiento",
		["Engineering"] = "Ingeniería",
		["First Aid"] = "Primeros Auxilios",
		["Leatherworking"] = "Peletería",
		["Tailoring"] = "Sastrería",
		["Jewelcrafting"] = "Joyería",
		["Fishing"] = "Pesca",

		--Projectile
		["Projectile"] = "Projectil",
		["Arrow"] = "Flecha",
		["Bullet"] = "Bala",

		--Quest
		["Quest"] = "Misión",

		--Quiver
		["Quiver"] = "Carcaj",
		["Ammo Pouch"] = "Bolsa de munición",

		--Trade Goods
		["Trade Goods"] = "Comercio de Mercancías",
		["Devices"] = "Dispositivos",
		["Explosives"] = "Explosivos",
		["Parts"] = "Piezas",
		["Elemental"] = "Elemental", -- New 2.3
		["Metal & Stone"] = "Metal y Piedra", -- New 2.3
		["Meat"] = "Carne", -- New 2.3
		["Herb"] = "Hierba", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		["Materials"] = "Materiales", -- New 2.4.2
		-- Other already defined

		--Miscellaneous
		["Junk"] = "Trastos",
		["Pet"] = "Mascota", -- New 2.3
		["Holiday"] = "Fiesta", -- New 2.3
		-- Reagent already defined
		["Mount"] = "Montura", -- New 2.4.2
		-- Other already defined
	}
elseif GAME_LOCALE == "ruRU" then
	lib:SetCurrentTranslations {
		["Armor"] = "Доспехи",
		["Weapon"] = "Оружие",

		--Armor Types
		["Cloth"] = "Ткань",
		["Leather"] = "Кожа",
		["Mail"] = "Кольчуга",
		["Plate"] = "Латы",

		--Armor Slots
		["Head"] = "Голова",
		["Neck"] = "Шея",
		["Shoulder"] = "Плечо",
		["Back"] = "Спина",
		["Chest"] = "Грудь",
		["Shirt"] = "Рубаха",
		["Tabard"] = "Тапперт",
		["Wrist"] = "Запястья",
		["Hands"] = "Кисти рук",
		["Waist"] = "Пояс",
		["Legs"] = "Ноги",
		["Feet"] = "Ступни",
		["Ring"] = "Палец",
		["Trinket"] = "Аксессуар",
		["Held in Off-Hand"] = "Левая рука",
		["Relic"] = "Реликвия",
		["Libram"] = "Манускрипт",
		["Totem"] = "Тотем",
		["Idol"] = "Идол",

		-- Armor Sub Types
		["Librams"] = "Манускрипты",  -- GetItemInfo() returns this as an ItemSubType.
		["Idols"] = "Идолы",  -- GetItemInfo() returns this as an ItemSubType.
		["Totems"] = "Тотемы",  -- GetItemInfo() returns this as an ItemSubType.
		["Shields"] = "Щиты", -- GetItemInfo() returns this as an ItemSubType.

		--Weapons
		["Axe"] = "Топор",
		["Bow"] = "Лук",
		["Crossbow"] = "Арбалет",
		["Dagger"] = "Кинжал",
		["Fist Weapon"] = "Кистевое",
		["Gun"] = "Огнестрельное",
		["Mace"] = "Ударное",
		["Polearm"] = "Древковое",
		["Shield"] = "Щит",
		["Staff"] = "Посох",
		["Sword"] = "Меч",
		["Thrown"] = "Метательное",
		["Wand"] = "Жезл",

		--Weapon Types
		["One-Hand"] = "Одноручное",
		["Two-Hand"] = "Двуручное",
		["Main Hand"] = "Правая рука",
		["Off Hand"] = "Левая рука",
		["Ranged"] = "Для оружия дальнего боя",

		--Weapon sub-types
		["Bows"] = "Луки",
		["Crossbows"] = "Арбалеты",
		["Daggers"] = "Кинжалы",
		["Guns"] = "Огнестрельное",
		["Fishing Pole"] = "Удочка",
		["Fishing Poles"] = "Удочки", -- GetItemInfo() returns this as an ItemSubType. (2.3 changed from singular to plural)
		["Fist Weapons"] = "Кистевое",
		["Miscellaneous"] = "Разное",
		["One-Handed Axes"] = "Одноручные топоры",
		["One-Handed Maces"] = "Одноручное ударное",
		["One-Handed Swords"] = "Одноручные мечи",
		["Polearms"] = "Древковое",
		["Staves"] = "Посохи",
		["Thrown"] = "Метательное",
		["Two-Handed Axes"] = "Двуручные топоры",
		["Two-Handed Maces"] = "Двуручное ударное",
		["Two-Handed Swords"] = "Двуручные мечи",
		["Wands"] = "Жезлы",

		--Consumable
		["Consumable"] = "Потребляемые",
		["Drink"] = "Питье",
		["Food"] = "Еда",
		["Food & Drink"] = "Еда и напитки", -- New 2.3
		["Potion"] = "Зелье", -- New 2.3
		["Elixir"] = "Эликсир", -- New 2.3
		["Flask"] = "Фляга", -- New 2.3
		["Bandage"] = "Бинты", -- New 2.3
		["Item Enhancement"] = "Улучшение", -- New 2.3
		["Scroll"] = "Свиток", -- New 2.3
		["Other"] = "Другое",  -- New 2.3

		--Container
		["Container"] = "Сумки",
		["Bag"] = "Сумка",
		["Enchanting Bag"] = "Сумка заклинателя",
		["Engineering Bag"] = "Сумка механика",
		["Gem Bag"] = "Сумка ювелира",
		["Herb Bag"] = "Сумка травника",
		["Mining Bag"] = "Шахтерская сумка",
		["Soul Bag"] = "Сумка душ",
		["Leatherworking Bag"] = "Сумка кожевника", -- New 2.3

		--Gem
		["Gem"] = "Самоцветы",
		["Blue"] = "Синий",
		["Green"] = "Зеленый",
		["Orange"] = "Оранжевый",
		["Meta"] = "Особый",
		["Prismatic"] = "Радужный",
		["Purple"] = "Фиолетовый",
		["Red"] = "Красный",
		["Simple"] = "Простой",
		["Yellow"] = "Желтый",

		--Key
		["Key"] = "Ключ",

		--Reagent
		["Reagent"] = "Реагент",

		--Recipe
		["Recipe"] = "Рецепты",
		["Alchemy"] = "Алхимия",
		["Blacksmithing"] = "Кузнечное дело",
		["Book"] = "Книга",
		["Cooking"] = "Кулинария",
		["Enchanting"] = "Наложение чар",
		["Engineering"] = "Механика",
		["First Aid"] = "Первая помощь",
		["Leatherworking"] = "Кожевенное дело",
		["Tailoring"] = "Портняжное дело",
		["Jewelcrafting"] = "Ювелирное дело",
		["Fishing"] = "Рыбная ловля",

		--Projectile
		["Projectile"] = "Боеприпасы",
		["Arrow"] = "Стрела",
		["Bullet"] = "Пуля",

		--Quest
		["Quest"] = "Задания",

		--Quiver
		["Quiver"] = "Колчан",
		["Ammo Pouch"] = "Подсумок",

		--Trade Goods
		["Trade Goods"] = "Ремесла",
		["Devices"] = "Устройства",
		["Explosives"] = "Взрывчатка",
		["Parts"] = "Детали",
		["Elemental"] = "Стихии", -- New 2.3
		["Metal & Stone"] = "Металл и камень", -- New 2.3
		["Meat"] = "Мясо", -- New 2.3
		["Herb"] = "Трава", -- New 2.3
		-- Cloth already defined
		-- Leather already defined
		-- Enchanting already defined
		-- Jewelcrafting already defined
		["Materials"] = "Материалы", -- New 2.4.2
		-- Other already defined

		--Miscellaneous
		["Junk"] = "Мусор",
		["Pet"] = "Питомец", -- New 2.3
		["Holiday"] = "Праздник", -- New 2.3
		-- Reagent already defined
		["Mount"] = "Mount", -- New 2.4.2
		-- Other already defined
	}
else
	error(("%s: Locale %q not supported"):format(MAJOR_VERSION, GAME_LOCALE))
end
