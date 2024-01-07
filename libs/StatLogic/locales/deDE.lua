-- deDE localization by Gailly, Dleh
---@class StatLogicLocale
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
-- Prefix Exclude --
-------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
L["PrefixExcludeLength"] = 5 -- using string.utf8len
L["PrefixExclude"] = {}
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
	["Hervorragendes Zauberöl"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, --

	["Schwaches Manaöl"] = {["MANA_REG"] = 4}, --
	["Geringes Manaöl"] = {["MANA_REG"] = 8}, --
	["Überragendes Manaöl"] = {["MANA_REG"] = 14}, --
	["Hervorragendes Manaöl"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --

	["Vitalität"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
	["Seelenfrost"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["Sonnenfeuer"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["Lauftempo ein wenig erhöht"] = false, --
	["Schwache Temposteigerung"] = false, -- Enchant Boots - Minor Speed
	["Schwaches Tempo"] = false, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" spell: 34007
	["Sicherer Stand"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" spell: 27954

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
L["SingleEquipStatCheck"] = "^" .. ITEM_SPELL_TRIGGER_ONEQUIP .. " (.-) um b?i?s? ?z?u? ?(%d+) ?(.-)%.$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
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
		repl = function(prefix)
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
	["Waffenschaden"] = {"MELEE_DMG"}, -- Enchant

	["Alle Werte"] = {StatLogic.Stats.AllStats,},
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

	["Angeln"] = false, -- Fishing enchant ID:846
	["Angelfertigkeit"] = false, -- Fishing lure
	["Bergbau"] = false, -- Mining enchant ID:844
	["Kräuterkunde"] = false, -- Heabalism enchant ID:845
	["Kürschnerei"] = false, -- Skinning enchant ID:865

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

	["Erhöht Heilung"] = {"HEAL",},
	["Heilung"] = {"HEAL",},
	["Heilzauber"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057

	["Erhöht durch Zauber und Effekte verursachte Heilung"] = {"HEAL",},
	["Erhöht durch Zauber und magische Effekte zugefügte Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {"HEAL",}, -- Atiesh
	--					["your healing"] = {"HEAL",}, -- Atiesh

	["Schaden pro Sekunde"] = {"DPS",},
	["zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997 "Verursacht 17.5 zusätzlichen Schaden pro Sekunde."
	["Verursacht zusätzlichen Schaden pro Sekunde"] = {"DPS",}, -- [Thorium Shells] ID: 15997

	["Verteidigungswertung"] = {StatLogic.Stats.DefenseRating,},
	["Erhöht Verteidigungswertung"] = {StatLogic.Stats.DefenseRating,},
	["Erhöht die Verteidigungswertung"] = {StatLogic.Stats.DefenseRating,},
	["Ausweichwertung"] = {StatLogic.Stats.DodgeRating,},
	["Erhöht Eure Ausweichwertung"] = {StatLogic.Stats.DodgeRating,},
	["Parierwertung"] = {StatLogic.Stats.ParryRating,},
	["Erhöht Eure Parierwertung"] = {StatLogic.Stats.ParryRating,},
	["Blockwertung"] = {StatLogic.Stats.BlockRating,},
	["Erhöht Eure Blockwertung"] = {StatLogic.Stats.BlockRating,},
	["Erhöt den Blockwet Eures Schildes"] = {StatLogic.Stats.BlockRating,},

	["verbessert eure trefferchance%"] = {"MELEE_HIT", "RANGED_HIT",},
	["Erhöht Eure Trefferchance mit Zaubern sowie Nahkampf- und Distanzangriffen%"] = {"MELEE_HIT", "RANGED_HIT", "SPELL_HIT"},
	["erhöht eure chance mit zaubern zu treffen%"] = {"SPELL_HIT",},
	["Trefferwertung"] = {StatLogic.Stats.HitRating,},
	["Erhöht Trefferwertung"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["Erhöht Eure Trefferwertung"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["Erhöht die Trefferwertung"] = {StatLogic.Stats.HitRating,},
	["Zaubertrefferwertung"] = {StatLogic.Stats.SpellHitRating,},
	["Erhöht Zaubertrefferwertung"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["Erhöht Eure Zaubertrefferwertung"] = {StatLogic.Stats.SpellHitRating,},
	["Erhöht die Zaubertrefferwertung"] = {StatLogic.Stats.SpellHitRating,},
	["Distanztrefferwertung"] = {StatLogic.Stats.RangedHitRating,},
	["Erhöht Distanztrefferwertung"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["Erhöht Eure Distanztrefferwertung"] = {StatLogic.Stats.RangedHitRating,},

	["kritische Trefferwertung"] = {StatLogic.Stats.CritRating,},
	["Erhöht kritische Trefferwertung"] = {StatLogic.Stats.CritRating,},
	["Erhöht Eure kritische Trefferwertung"] = {StatLogic.Stats.CritRating,},
	["Erhöht die kritische Trefferwertung"] = {StatLogic.Stats.CritRating,},
	["kritische Zaubertrefferwertung"] = {StatLogic.Stats.SpellCritRating,},
	["Erhöht kritische Zaubertrefferwertung"] = {StatLogic.Stats.SpellCritRating,},
	["Erhöht Eure kritische Zaubertrefferwertung"] = {StatLogic.Stats.SpellCritRating,},
	["Erhöht die kritische Zaubertrefferwertung"] = {StatLogic.Stats.SpellCritRating,},
	["Erhöht die kritische Zaubertrefferwertung aller Gruppenmitglieder innerhalb von 30 Metern"] = {StatLogic.Stats.SpellCritRating,},
	["Erhöht Eure kritische Distanztrefferwertung"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348

	["Abhärtung"] = {StatLogic.Stats.ResilienceRating,},
	["Abhärtungswertung"] = {StatLogic.Stats.ResilienceRating,},
	["Erhöht Eure Abhärtungswertung"] = {StatLogic.Stats.ResilienceRating,},

	["Erhöht Tempowertung"] = {StatLogic.Stats.HasteRating}, -- [Pfeilabwehrender Brustschutz] ID:33328
	["Erhöht die Tempowertung"] = {StatLogic.Stats.HasteRating},
	["Angriffstempowertung"] = {StatLogic.Stats.MeleeHasteRating},
	["Zaubertempowertung"] = {StatLogic.Stats.SpellHasteRating},
	["Distanzangriffstempowertung"] = {StatLogic.Stats.RangedHasteRating},
	["Erhöht Angriffstempowertung"] = {StatLogic.Stats.MeleeHasteRating},
	["Erhöht Eure Angriffstempowertung"] = {StatLogic.Stats.MeleeHasteRating},
	["Erhöht Eure Distanzangriffstempowertung"] = {StatLogic.Stats.RangedHasteRating},
	["Erhöht Zaubertempowertung"] = {StatLogic.Stats.SpellHasteRating},
	["Erhöht die Zaubertempowertung"] = {StatLogic.Stats.SpellHasteRating},

	["Waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating}, -- gem
	["Erhöht die Waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating},
	["Erhöht Eure Waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating},
	["Rüstungsdurchschlagwertung"] = {StatLogic.Stats.ArmorPenetrationRating}, -- gem
	["Erhöht den Rüstungsdurchschlagwert um"] = {StatLogic.Stats.ArmorPenetrationRating},
	["Erhöht die Rüstungsdurchschlagwertung um"] = {StatLogic.Stats.ArmorPenetrationRating},
	["Erhöht Eure Rüstungsdurchschlagwertung um"] = {StatLogic.Stats.ArmorPenetrationRating}, -- ID:43178
	["erhöht den rüstungsdurchschlag"] = {StatLogic.Stats.ArmorPenetrationRating},

	-- Exclude
	["Sek"] = false,
	["bis"] = false,
	["Platz Tasche"] = false,
	["Platz Köcher"] = false,
	["Platz Munitionsbeutel"] = false,
	["Erhöht das Distanzangriffstempo"] = false, -- AV quiver
}