-- deDE localization by Gailly, Dleh
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "deDE")
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = function(s)
	local n = tonumber(s)
	if n then
		return n
	else
		return tonumber((s:gsub(",", "%.")))
	end
end
-------------------
-- Fast Exclude --
-------------------
-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
L["ExcludeLen"] = 5 -- using string.utf8len
L["Exclude"] = {
	[""] = true,
	[" \n"] = true,
	[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
	[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
	[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
	[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
	[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
	["Entza"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
	["Dauer"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
	["<Herg"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
	["Verbl"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
	["Einzi"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
	["Benöt"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
	["\nBenö"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
	["Klasse"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
	["Völke"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
	["Benut"] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
	["Treff"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
	-- Set Bonuses
	-- ITEM_SET_BONUS = "Set: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["Set: "] = true,
	["(2) S"] = true,
	["(3) S"] = true,
	["(4) S"] = true,
	["(5) S"] = true,
	["(6) S"] = true,
	["(7) S"] = true,
	["(8) S"] = true,
	-- Equip type
	[GetItemClassInfo(Enum.ItemClass.Projectile)] = true, -- Ice Threaded Arrow ID:19316
	[INVTYPE_AMMO] = true,
	[INVTYPE_HEAD] = true,
	[INVTYPE_NECK] = true,
	[INVTYPE_SHOULDER] = true,
	[INVTYPE_BODY] = true,
	[INVTYPE_CHEST] = true,
	[INVTYPE_ROBE] = true,
	[INVTYPE_WAIST] = true,
	[INVTYPE_LEGS] = true,
	[INVTYPE_FEET] = true,
	[INVTYPE_WRIST] = true,
	[INVTYPE_HAND] = true,
	[INVTYPE_FINGER] = true,
	[INVTYPE_TRINKET] = true,
	[INVTYPE_CLOAK] = true,
	[INVTYPE_WEAPON] = true,
	[INVTYPE_SHIELD] = true,
	[INVTYPE_2HWEAPON] = true,
	[INVTYPE_WEAPONMAINHAND] = true,
	[INVTYPE_WEAPONOFFHAND] = true,
	[INVTYPE_HOLDABLE] = true,
	[INVTYPE_RANGED] = true,
	[GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown)] = true,
	[INVTYPE_RELIC] = true,
	[INVTYPE_TABARD] = true,
	[INVTYPE_BAG] = true,
}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["Wildheit"] = {["AP"] = 70}, --
	["Unbändigkeit"] = {["AP"] = 70}, --

	["Schwaches Zauberöl"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
	["Geringes Zauberöl"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
	["Zauberöl"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
	["Überragendes Zauberöl"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
	["Hervorragendes Zauberöl"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
	["Gesegnetes Zauberöl"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["Schwaches Manaöl"] = {["MANA_REG"] = 4}, --
	["Geringes Manaöl"] = {["MANA_REG"] = 8}, --
	["Überragendes Manaöl"] = {["MANA_REG"] = 14}, --
	["Hervorragendes Manaöl"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --


	["Eterniumangelschnur"] = {["FISHING"] = 5}, --
	["Vitalität"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
	["Seelenfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["Sonnenfeuer"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["Mithrilsporen"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["Schwache Reittierttempo-Strigerung"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["Anlegen: Lauftempo ein wenig erhöht."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["Lauftempo ein wenig erhöht"] = {["RUN_SPEED"] = 8}, --
	["Schwache Temposteigerung"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
	["Schwaches Tempo"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["Sicherer Stand"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Feingefühl"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["2% verringerte Bedrohung"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
	["Anlegen: Ermöglicht Unterwasseratmung."] = false, -- [Band of Icy Depths] ID: 21526
	["Ermöglicht Unterwasseratmung"] = false, --
	["Anlegen: Immun gegen Entwaffnen."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Immun gegen Entwaffnen"] = false, --
	["Kreuzfahrer"] = false, -- Enchant Crusader
	["Lebensdiebstahl"] = false, -- Enchant Crusader
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
-- +19 ?? = "^%+(%d+) (.-)$"
--["SinglePlusStatCheck"] = "^%+(%d+) ([%a ]+%a)$",
L["SinglePlusStatCheck"] = "^%+(%d+) (.-)$"
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) (.-)%.?$"
-- Stamina +19 = "^(.-) %+(%d+)%.?$"
-- +19 耐力 = "^%+(%d+) (.-)%.?$"
-- +19 Ausdauer = "^%+(%d+) (.-)%.?$" (deDE :))
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
L["SingleEquipStatCheck"] = "^Anlegen: (.-) um b?i?s? ?z?u? ?(%d+) ?(.-)%.$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+) Block$"] = "BLOCK_VALUE",
	["^(%d+) Rüstung$"] = "ARMOR",
	["Verstärkte %(%+(%d+) Rüstung%)"] = "ARMOR_BUFF",
	["Mana Regeneration (%d+) alle 5 Sek%.$"] = "MANA_REG",
	-- These fail DeepScan in deDE because of the commas
	["Anlegen: Erhöht Eure Chance, einen kritischen Treffer durch Zauber zu erzielen, um (%d)%%%."] = StatLogic.Stats.SpellCrit,
	["Anlegen: Erhöht Eure Chance, einen kritischen Treffer zu erzielen, um (%d)%%%."] = "CRIT",
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	["[Cc]hance bei"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["eine Chance"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Ff]ügt dem Angreifer"] = false, -- [Essence of the Pure Flame] ID: 18815
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "Anlegen: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "Sockelbonus: " -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	{
		pattern = "([^ ][^S][^e][^k])(%.) ",  -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
		-- Importent for deDE to not separate "alle 5 Sek. 2 Mana"
		repl = function(prefix, sep)
			return prefix .. "@"
		end
	}
}
L["DeepScanWordSeparators"] = {
	" und ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
-- all lower case
L["DualStatPatterns"] = {
	["^%+(%d+) heilzauber %+(%d+) schadenszauber$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^%+(%d+) heilung %+(%d+) zauberschaden$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^erhöht durch sämtliche zauber und magische effekte verursachte heilung um bis zu (%d+) und den verursachten schaden um bis zu (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-) um b?i?s? ?z?u? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-)5 [Ss]ek%. (%d+) (.-)$",  -- "xxx 5 Sek. 8 xxx" (scan 2nd)
	"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 3rd)
	"^(.-) ?([%d%,]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Eure Angriffe ignorierenRüstung eures Gegners"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["% Bedrohung"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["Erhöht Eure effektive Verstohlenheitsstufe"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["Waffenschaden"] = {"MELEE_DMG"}, -- Enchant
	["Erhöht das Reittiertempo%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["Alle Werte"] = {StatLogic.Stats.Strength, StatLogic.Stats.Agility, StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.Spirit,},
	["Stärke"] = {StatLogic.Stats.Strength,},
	["Beweglichkeit"] = {StatLogic.Stats.Agility,},
	["Ausdauer"] = {StatLogic.Stats.Stamina,},
	["Intelligenz"] = {StatLogic.Stats.Intellect,},
	["Willenskraft"] = {StatLogic.Stats.Spirit,},

	["Arkanwiderstand"] = {"ARCANE_RES",},
	["Feuerwiderstand"] = {"FIRE_RES",},
	["Naturwiderstand"] = {"NATURE_RES",},
	["Frostwiderstand"] = {"FROST_RES",},
	["Schattenwiderstand"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
	["Alle Widerstände"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["Alle Widerstandsarten"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	["Angeln"] = {"FISHING",}, -- Fishing enchant ID:846
	["Angelfertigkeit"] = {"FISHING",}, -- Fishing lure
	["Bergbau"] = {"MINING",}, -- Mining enchant ID:844
	["Kräuterkunde"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["Kürschnerei"] = {"SKINNING",}, -- Skinning enchant ID:865

	["Rüstung"] = {"ARMOR_BONUS",},
	["Verteidigung"] = {StatLogic.Stats.Defense,},
	["Blocken"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Blockwert"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Erhöht den Blockwert Eures Schildes"] = {"BLOCK_VALUE",},

	["Gesundheit"] = {"HEALTH",},
	["HP"] = {"HEALTH",},
	["Mana"] = {"MANA",},

	["Angriffskraft"] = {"AP",},
	["Erhöht Angriffskraft"] = {"AP",},
	["Erhöht die Angriffskraft"] = {"AP",},
	["Erhöht die Angriffskraft im Kampf gegen Untote"] = {"AP_UNDEAD",}, -- [Wristwraps of Undead Slaying] ID:23093
	["Erhöht die Angriffskraft gegen Untote"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["Erhöht die Angriffskraft im Kampf gegen Untote. Ermöglicht das Einsammeln von Geißelsteinen im Namen der Argentumdämmerung"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["Erhöht die Angriffskraft im Kampf gegen Dämonen"] = {"AP_DEMON",}, -- [Mark of the Champion] ID:23206
	["Angriffskraft in Katzengestalt"] = {"FERAL_AP",},
	["Erhöht die Angriffskraft in Katzengestalt"] = {"FERAL_AP",},
	["Distanzangriffskraft"] = {"RANGED_AP",},
	["Erhöht die Distanzangriffskraft"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["Gesundheit wieder her"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
	["Gesundheitsregeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779

	["Mana wieder her"] = {"MANA_REG",},
	["Mana alle 5 Sek"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
	["Mana alle 5 Sekunden"] = {"MANA_REG",},
	["alle 5 Sek.Mana"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana bei allen Gruppenmitgliedern, die sich im Umkreis von 30 befinden, wieder her"] = {"MANA_REG",}, -- Atiesh
	["Manaregeneration"] = {"MANA_REG",},
	["alle Mana"] = {"MANA_REG",},
	["stellt alle Mana wieder her"] = {"MANA_REG",},

	["Zauberdurchschlagskraft"] = {"SPELLPEN",},
	["Erhöht Eure Zauberdurchschlagskraft"] = {"SPELLPEN",},
	["Schaden und Heilung"] = {"SPELL_DMG", "HEAL",},
	["Damage and Healing Spells"] = {"SPELL_DMG", "HEAL",},
	["Zauberschaden und Heilung"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["Zauberschaden"] = {"SPELL_DMG",},
	["Zauberkraft"] = {"SPELL_DMG", "HEAL",},
	["Erhöht durch Zauber und magische Effekte verursachten Schaden und Heilung"] = {"SPELL_DMG", "HEAL"},
	["Erhöht durch Zauber und magische Effekte zugefügten Schaden und Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["Schaden"] = {"SPELL_DMG",},
	["Erhöht Euren Zauberschaden"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Schadenszauber"] = {"SPELL_DMG"},
	["Zaubermacht"] = {"SPELL_DMG", "HEAL",},
	["Erhöht die Zaubermacht"] = {"SPELL_DMG", "HEAL",}, -- WotLK
	["Erhöht Zaubermacht"] = {"SPELL_DMG", "HEAL",}, -- WotLK
	["Heiligschaden"] = {"HOLY_SPELL_DMG",},
	["Arkanschaden"] = {"ARCANE_SPELL_DMG",},
	["Feuerschaden"] = {"FIRE_SPELL_DMG",},
	["Naturschaden"] = {"NATURE_SPELL_DMG",},
	["Frostschaden"] = {"FROST_SPELL_DMG",},
	["Schattenschaden"] = {"SHADOW_SPELL_DMG",},
	["Heiligzauberschaden"] = {"HOLY_SPELL_DMG",},
	["Arkanzauberschaden"] = {"ARCANE_SPELL_DMG",},
	["Feuerzauberschaden"] = {"FIRE_SPELL_DMG",},
	["Naturzauberschaden"] = {"NATURE_SPELL_DMG",},
	["Frostzauberschaden"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Schattenzauberschaden"] = {"SHADOW_SPELL_DMG",},
	["Erhöht durch Arkanzauber und Arkaneffekte zugefügten Schaden"] = {"ARCANE_SPELL_DMG",},
	["Erhöht durch Feuerzauber und Feuereffekte zugefügten Schaden"] = {"FIRE_SPELL_DMG",},
	["Erhöht durch Frostzauber und Frosteffekte zugefügten Schaden"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["Erhöht durch Heiligzauber und Heiligeffekte zugefügten Schaden"] = {"HOLY_SPELL_DMG",},
	["Erhöht durch Naturzauber und Natureffekte zugefügten Schaden"] = {"NATURE_SPELL_DMG",},
	["Erhöht durch Schattenzauber und Schatteneffekte zugefügten Schaden"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871

	["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote"] = {"SPELL_DMG_UNDEAD"}, -- [Robe of Undead Cleansing] ID:23085
	["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote um bis zu 48. Ermöglicht das Einsammeln von Geißelsteinen im Namen der Argentumdämmerung."] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
	["Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote und Dämonen"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

	["Erhöht Heilung"] = {"HEAL",},
	["Heilung"] = {"HEAL",},
	["Heilzauber"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057

	["Erhöht durch Zauber und Effekte verursachte Heilung"] = {"HEAL",},
	["Erhöht durch Zauber und magische Effekte zugefügte Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {"HEAL",}, -- Atiesh
	--					["your healing"] = {"HEAL",}, -- Atiesh

	["Schaden pro Sekunde"] = {"DPS",},
	["zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997 "Verursacht 17.5 zusätzlichen Schaden pro Sekunde."
	["Verursacht zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997

	["Verteidigungswertung"] = {"DEFENSE_RATING",},
	["Erhöht Verteidigungswertung"] = {"DEFENSE_RATING",},
	["Erhöht die Verteidigungswertung"] = {"DEFENSE_RATING",},
	["Ausweichwertung"] = {"DODGE_RATING",},
	["Erhöht Eure Ausweichwertung"] = {"DODGE_RATING",},
	["Parierwertung"] = {"PARRY_RATING",},
	["Erhöht Eure Parierwertung"] = {"PARRY_RATING",},
	["Blockwertung"] = {"BLOCK_RATING",},
	["Erhöht Eure Blockwertung"] = {"BLOCK_RATING",},
	["Erhöt den Blockwet Eures Schildes"] = {"BLOCK_RATING",},

	["verbessert eure trefferchance%"] = {"MELEE_HIT", "RANGED_HIT",},
	["erhöht eure chance mit zaubern zu treffen%"] = {"SPELL_HIT",},
	["Trefferwertung"] = {"HIT_RATING",},
	["Erhöht Trefferwertung"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_RATING
	["Erhöht Eure Trefferwertung"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
	["Erhöht die Trefferwertung"] = {"HIT_RATING",},
	["Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
	["Erhöht Zaubertrefferwertung"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
	["Erhöht Eure Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
	["Erhöht die Zaubertrefferwertung"] = {"SPELL_HIT_RATING",},
	["Distanztrefferwertung"] = {"RANGED_HIT_RATING",},
	["Erhöht Distanztrefferwertung"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
	["Erhöht Eure Distanztrefferwertung"] = {"RANGED_HIT_RATING",},

	["kritische Trefferwertung"] = {"CRIT_RATING",},
	["Erhöht kritische Trefferwertung"] = {"CRIT_RATING",},
	["Erhöht Eure kritische Trefferwertung"] = {"CRIT_RATING",},
	["Erhöht die kritische Trefferwertung"] = {"CRIT_RATING",},
	["kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
	["Erhöht kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
	["Erhöht Eure kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
	["Erhöht die kritische Zaubertrefferwertung"] = {"SPELL_CRIT_RATING",},
	["Erhöht die kritische Zaubertrefferwertung aller Gruppenmitglieder innerhalb von 30 Metern"] = {"SPELL_CRIT_RATING",},
	["Erhöht Eure kritische Distanztrefferwertung"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

	["Abhärtung"] = {"RESILIENCE_RATING",},
	["Abhärtungswertung"] = {"RESILIENCE_RATING",},
	["Erhöht Eure Abhärtungswertung"] = {"RESILIENCE_RATING",},

	["Erhöht Tempowertung"] = {"HASTE_RATING"}, -- [Pfeilabwehrender Brustschutz] ID:33328
	["Erhöht die Tempowertung"] = {"HASTE_RATING"},
	["Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
	["Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
	["Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
	["Erhöht Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
	["Erhöht Eure Angriffstempowertung"] = {"MELEE_HASTE_RATING"},
	["Erhöht Eure Distanzangriffstempowertung"] = {"RANGED_HASTE_RATING"},
	["Erhöht Zaubertempowertung"] = {"SPELL_HASTE_RATING"},
	["Erhöht die Zaubertempowertung"] = {"SPELL_HASTE_RATING"},


	["Waffenkundewertung"] = {"EXPERTISE_RATING"}, -- gem
	["Erhöht die Waffenkundewertung"] = {"EXPERTISE_RATING"},
	["Erhöht Eure Waffenkundewertung"] = {"EXPERTISE_RATING"},
	["Rüstungsdurchschlagwertung"] = {"ARMOR_PENETRATION_RATING"}, -- gem
	["Erhöht den Rüstungsdurchschlagwert um"] = {"ARMOR_PENETRATION_RATING"},
	["Erhöht die Rüstungsdurchschlagwertung um"] = {"ARMOR_PENETRATION_RATING"},
	["Erhöht Eure Rüstungsdurchschlagwertung um"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178
	["erhöht den rüstungsdurchschlag"] = {"ARMOR_PENETRATION_RATING"},

	-- Exclude
	["Sek"] = false,
	["bis"] = false,
	["Platz Tasche"] = false,
	["Platz Köcher"] = false,
	["Platz Munitionsbeutel"] = false,
	["Erhöht das Distanzangriffstempo"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "deDE")
----------------
-- Stat Names --
----------------
-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
-- localization effect when a locale is not available for that language, you don't have to use global
-- strings in your localization.

-- NOTE I left many of the english terms because german players tend to use them and germans are much tooo long
--[StatID] = {FullName, ShortName}
---------------------------------------------------------------------------
-- Tier1 Stats - Stats parsed directly off items
D["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED} -- EMPTY_SOCKET_RED = "Red Socket";
D["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW} -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
D["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE} -- EMPTY_SOCKET_BLUE = "Blue Socket";
D["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META} -- EMPTY_SOCKET_META = "Meta Socket";

D["IGNORE_ARMOR"] = {"Rüstung ignorieren", "Rüstung igno."}
D["STEALTH_LEVEL"] = {"Verstohlenheitslevel", "Verstohlenheit"}
D["MELEE_DMG"] = {"Waffenschaden", "Waffenschaden"} -- DAMAGE = "Damage"
D["MOUNT_SPEED"] = {"Reitgeschwindigkeit(%)", "Reitgeschw.(%)"}
D["RUN_SPEED"] = {"Laufgeschwindigkeit(%)", "Laufgeschw.(%)"}

D[StatLogic.Stats.Strength] = {SPELL_STAT1_NAME, "Stärke"}
D[StatLogic.Stats.Agility] = {SPELL_STAT2_NAME, "Bewegl"}
D[StatLogic.Stats.Stamina] = {SPELL_STAT3_NAME, "Ausdauer"}
D[StatLogic.Stats.Intellect] = {SPELL_STAT4_NAME, StatLogic.Stats.Intellect}
D[StatLogic.Stats.Spirit] = {SPELL_STAT5_NAME, "Wille"}
D["ARMOR"] = {ARMOR, ARMOR}
D["ARMOR_BONUS"] = {ARMOR.." von Bonus", ARMOR.."(Bonus)"}

D["FIRE_RES"] = {RESISTANCE2_NAME, "FW"}
D["NATURE_RES"] = {RESISTANCE3_NAME, "NW"}
D["FROST_RES"] = {RESISTANCE4_NAME, "FrW"}
D["SHADOW_RES"] = {RESISTANCE5_NAME, "SW"}
D["ARCANE_RES"] = {RESISTANCE6_NAME, "AW"}

D["FISHING"] = {"Angeln", "Angeln"}
D["MINING"] = {"Bergbau", "Bergbau"}
D["HERBALISM"] = {"Kräuterkunde", "Kräutern"}
D["SKINNING"] = {"Kürschnerei", "Küschnern"}

D["BLOCK_VALUE"] = {"Blockwert", "Blockwert"}

D["AP"] = {ATTACK_POWER_TOOLTIP, "AP"}
D["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"}
D["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"}
D["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Untot)", "AP(Untot)"}
D["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Dämon)", "AP(Dämon)"}

D["HEAL"] = {"Heilung", "Heilung"}

D["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Schaden"}
D["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Untot)", PLAYERSTAT_SPELL_COMBAT.." Schaden".."(Untot)"}
D["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Dämon)", PLAYERSTAT_SPELL_COMBAT.." Schaden".."(Dämon)"}
D["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Schaden"}
D["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Schaden"}
D["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Schaden"}
D["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Schaden"}
D["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Schaden"}
D["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.."Schaden"}

D["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION}

D["HEALTH"] = {HEALTH, HP}
D["MANA"] = {MANA, MP}
D["HEALTH_REG"] = {HEALTH.." Regeneration", "HP5"}
D["MANA_REG"] = {MANA.." Regeneration", "MP5"}

D["AVERAGE_DAMAGE"] = {"Average Damage", "Avg Dmg"}
D["DPS"] = {"Schaden pro Sekunde", "DPS"}

D["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2} -- COMBAT_RATING_NAME2 = "Defense Rating"
D["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3} -- COMBAT_RATING_NAME3 = "Dodge Rating"
D["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4} -- COMBAT_RATING_NAME4 = "Parry Rating"
D["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5} -- COMBAT_RATING_NAME5 = "Block Rating"
D["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6} -- COMBAT_RATING_NAME6 = "Hit Rating"
D["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6} -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
D["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6} -- PLAYERSTAT_SPELL_COMBAT = "Spell"
D["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9} -- COMBAT_RATING_NAME9 = "Crit Rating"
D["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9}
D["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9}
D["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15} -- COMBAT_RATING_NAME15 = "Resilience"
D["MELEE_HASTE_RATING"] = {"Hast "..RATING, "Hast  "..RATING} --
D["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Hast  "..RATING, PLAYERSTAT_RANGED_COMBAT.." Hast  "..RATING}
D["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Hast  "..RATING, PLAYERSTAT_SPELL_COMBAT.." Hast  "..RATING}
D["EXPERTISE_RATING"] = {"Waffenkundewertung", "Waffenkundewertung"}
D["ARMOR_PENETRATION_RATING"] = {"Rüstungsdurchschlag".." "..RATING, "ArP".." "..RATING}
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
D["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." Regeneration (Nicht im Kampf)", "HP5(OC)"}
D["MANA_REG_NOT_CASTING"] = {MANA.." Regeneration (Nicht zaubernd)", "MP5(NC)"}
D["MELEE_CRIT_DMG_REDUCTION"] = {"Krit Schadenverminderung (%)", "Krit Schaden Verm(%)"}
D["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Krit Schadenverminderung(%)", PLAYERSTAT_RANGED_COMBAT.." Krit Schaden Verm(%)"}
D["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Krit Schadenverminderung(%)", PLAYERSTAT_SPELL_COMBAT.." Krit Schaden Verm(%)"}
D[StatLogic.Stats.Defense] = {DEFENSE, "Def"}
D[StatLogic.Stats.Dodge] = {DODGE.."(%)", DODGE.."(%)"}
D[StatLogic.Stats.Parry] = {PARRY.."(%)", PARRY.."(%)"}
D[StatLogic.Stats.BlockChance] = {BLOCK.."(%)", BLOCK.."(%)"}
D["AVOIDANCE"] = {"Vermeidung(%)", "Vermeidung(%)"}
D["MELEE_HIT"] = {"Trefferchance(%)", "Treffer(%)"}
D["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Trefferchance(%)", PLAYERSTAT_RANGED_COMBAT.." Treffer(%)"}
D["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Trefferchance(%)", PLAYERSTAT_SPELL_COMBAT.." Treffer(%)"}
D[StatLogic.Stats.Miss] = {"Treffer Vermeidung(%)", "Treffer Vermeid(%)"}
D[StatLogic.Stats.MeleeCrit] = {MELEE_CRIT_CHANCE.."(%)", "Krit(%)"} -- MELEE_CRIT_CHANCE = "Crit Chance"
D[StatLogic.Stats.RangedCrit] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Krit(%)"}
D[StatLogic.Stats.SpellCrit] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Krit(%)"}
D["MELEE_CRIT_AVOID"] = {"Kritvermeidung(%)", "Kritvermeidung(%)"}
D["MELEE_HASTE"] = {"Hast(%)", "Hast(%)"} --
D["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Hast(%)", PLAYERSTAT_RANGED_COMBAT.." Hast(%)"}
D["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Hast(%)", PLAYERSTAT_SPELL_COMBAT.." Hast(%)"}
D["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"} -- SKILL = "Skill"
D["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"}
D["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"}
D["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"}
D["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"}
D["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"}
D["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"}
D["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"}
D["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"}
D["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"}
D["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"}
D["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"}
D["EXPERTISE"] = {"Waffenkunde", "Waffenkunde"}
D["ARMOR_PENETRATION"] = {"Rüstungsdurchschlag(%)", "ArP(%)"}
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
D["DODGE_NEGLECT"] = {DODGE.." Verhinderung(%)", DODGE.." Verhinderung(%)"}
D["PARRY_NEGLECT"] = {PARRY.." Verhinderung(%)", PARRY.." Verhinderung(%)"}
D["BLOCK_NEGLECT"] = {BLOCK.." Verhinderung(%)", BLOCK.." Verhinderung(%)"}
-- Talents
D["MELEE_CRIT_DMG"] = {"Krit Schaden(%)", "Crit Schaden(%)"}
D["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)", PLAYERSTAT_RANGED_COMBAT.." Krit Schaden(%)"}
D["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)", PLAYERSTAT_SPELL_COMBAT.." Krit Schaden(%)"}
-- Spell Stats
-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
-- Use strsplit("@", text) to seperate the spell name and statid
D["THREAT"] = {"Bedrohung", "Bedrohung"}
D["CAST_TIME"] = {"Zauberzeit", "Zauberzeit"}
D["MANA_COST"] = {"Manakosten", "Mana"}
D["RAGE_COST"] = {"Wutkosten", "Wut"}
D["ENERGY_COST"] = {"Energiekosten", "Energie"}
D["COOLDOWN"] = {"Abklingzeit", "CD"}
-- Stats Mods
D["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"}
D["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"}
D["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"}
D["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"}
D["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"}
D["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"}
D["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"}
D["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"}
D["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"}
D["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"}
D["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"}
D["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"}
D["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"}
D["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"}
D["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"}
D["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"}
D["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"}
D["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"}
D["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"}
D["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"}
D["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"}
D["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"}
D["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"}
-- Misc Stats
D["WEAPON_SKILL"] = {"Waffe "..SKILL, "Waffe"..SKILL}