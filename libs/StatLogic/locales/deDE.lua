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
	["Wildheit"] = {[StatLogic.Stats.AttackPower] = 70}, --
	["Unbändigkeit"] = {[StatLogic.Stats.AttackPower] = 70}, --

	["Schwaches Zauberöl"] = {[StatLogic.Stats.SpellDamage] = 8, [StatLogic.Stats.HealingPower] = 8}, --
	["Geringes Zauberöl"] = {[StatLogic.Stats.SpellDamage] = 16, [StatLogic.Stats.HealingPower] = 16}, --
	["Zauberöl"] = {[StatLogic.Stats.SpellDamage] = 24, [StatLogic.Stats.HealingPower] = 24}, --
	["Überragendes Zauberöl"] = {[StatLogic.Stats.SpellDamage] = 42, [StatLogic.Stats.HealingPower] = 42}, --
	["Hervorragendes Zauberöl"] = {[StatLogic.Stats.SpellDamage] = 36, [StatLogic.Stats.HealingPower] = 36, [StatLogic.Stats.SpellCritRating] = 14}, --

	["Schwaches Manaöl"] = {[StatLogic.Stats.ManaRegen] = 4}, --
	["Geringes Manaöl"] = {[StatLogic.Stats.ManaRegen] = 8}, --
	["Überragendes Manaöl"] = {[StatLogic.Stats.ManaRegen] = 14}, --
	["Hervorragendes Manaöl"] = {[StatLogic.Stats.ManaRegen] = 12, [StatLogic.Stats.HealingPower] = 25}, --

	["Vitalität"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4}, --
	["Seelenfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54}, --
	["Sonnenfeuer"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50}, --

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
	--["^Equip: Increases attack power by (%d+) in Cat"] = StatLogic.Stats.FeralAttackPower,
	["^(%d+) Block$"] = StatLogic.Stats.BlockValue,
	["^(%d+) Rüstung$"] = StatLogic.Stats.Armor,
	["Verstärkte %(%+(%d+) Rüstung%)"] = StatLogic.Stats.BonusArmor,
	["Mana Regeneration (%d+) alle 5 Sek%.$"] = StatLogic.Stats.ManaRegen,
	-- These fail DeepScan in deDE because of the commas
	["Anlegen: Erhöht Eure Chance, einen kritischen Treffer durch Zauber zu erzielen, um (%d)%%%."] = StatLogic.Stats.SpellCrit,
	["Anlegen: Erhöht Eure Chance, einen kritischen Treffer zu erzielen, um (%d)%%%."] = {StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit},
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
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
	["^%+(%d+) heilzauber %+(%d+) schadenszauber$"] = {{StatLogic.Stats.HealingPower,}, {StatLogic.Stats.SpellDamage,},},
	["^%+(%d+) heilung %+(%d+) zauberschaden$"] = {{StatLogic.Stats.HealingPower,}, {StatLogic.Stats.SpellDamage,},},
	["^erhöht durch sämtliche zauber und magische effekte verursachte heilung um bis zu (%d+) und den verursachten schaden um bis zu (%d+)$"] = {{StatLogic.Stats.HealingPower,}, {StatLogic.Stats.SpellDamage,},},
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
	["Eure Angriffe ignorierenRüstung eures Gegners"] = {StatLogic.Stats.IgnoreArmor}, -- StatLogic:GetSum("item:33733")
	["Waffenschaden"] = {StatLogic.Stats.AverageWeaponDamage}, -- Enchant

	["Alle Werte"] = {StatLogic.Stats.AllStats,},
	["Stärke"] = {StatLogic.Stats.Strength,},
	["Beweglichkeit"] = {StatLogic.Stats.Agility,},
	["Ausdauer"] = {StatLogic.Stats.Stamina,},
	["Intelligenz"] = {StatLogic.Stats.Intellect,},
	["Willenskraft"] = {StatLogic.Stats.Spirit,},

	["Arkanwiderstand"] = {StatLogic.Stats.ArcaneResistance,},
	["Feuerwiderstand"] = {StatLogic.Stats.FireResistance,},
	["Naturwiderstand"] = {StatLogic.Stats.NatureResistance,},
	["Frostwiderstand"] = {StatLogic.Stats.FrostResistance,},
	["Schattenwiderstand"] = {StatLogic.Stats.ShadowResistance,}, -- Demons Blood ID: 10779
	["Alle Widerstände"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["Alle Widerstandsarten"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},

	["Angeln"] = false, -- Fishing enchant ID:846
	["Angelfertigkeit"] = false, -- Fishing lure
	["Bergbau"] = false, -- Mining enchant ID:844
	["Kräuterkunde"] = false, -- Heabalism enchant ID:845
	["Kürschnerei"] = false, -- Skinning enchant ID:865

	["Rüstung"] = {StatLogic.Stats.BonusArmor,},
	["Verteidigung"] = {StatLogic.Stats.Defense,},
	["Blocken"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Blockwert"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Erhöht den Blockwert Eures Schildes"] = {StatLogic.Stats.BlockValue,},

	["Gesundheit"] = {StatLogic.Stats.Health,},
	["HP"] = {StatLogic.Stats.Health,},
	["Mana"] = {StatLogic.Stats.Mana,},

	["Angriffskraft"] = {StatLogic.Stats.AttackPower,},
	["Erhöht Angriffskraft"] = {StatLogic.Stats.AttackPower,},
	["Erhöht die Angriffskraft"] = {StatLogic.Stats.AttackPower,},
	["Angriffskraft in Katzengestalt"] = {StatLogic.Stats.FeralAttackPower,},
	["Erhöht die Angriffskraft in Katzengestalt"] = {StatLogic.Stats.FeralAttackPower,},
	["Distanzangriffskraft"] = {StatLogic.Stats.RangedAttackPower,},
	["Erhöht die Distanzangriffskraft"] = {StatLogic.Stats.RangedAttackPower,}, -- [High Warlord's Crossbow] ID: 18837

	["Gesundheit wieder her"] = {StatLogic.Stats.HealthRegen,}, -- Frostwolf Insignia Rank 6 ID:17909
	["Gesundheitsregeneration"] = {StatLogic.Stats.HealthRegen,}, -- Demons Blood ID: 10779

	["Mana wieder her"] = {StatLogic.Stats.ManaRegen,},
	["Mana alle 5 Sek"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Nightseye] ID: 24057
	["Mana alle 5 Sekunden"] = {StatLogic.Stats.ManaRegen,},
	["alle 5 Sek.Mana"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["Mana bei allen Gruppenmitgliedern, die sich im Umkreis von 30 befinden, wieder her"] = {StatLogic.Stats.ManaRegen,}, -- Atiesh
	["Manaregeneration"] = {StatLogic.Stats.ManaRegen,},
	["alle Mana"] = {StatLogic.Stats.ManaRegen,},
	["stellt alle Mana wieder her"] = {StatLogic.Stats.ManaRegen,},

	["Zauberdurchschlagskraft"] = {StatLogic.Stats.SpellPenetration,},
	["Erhöht Eure Zauberdurchschlagskraft"] = {StatLogic.Stats.SpellPenetration,},
	["Schaden und Heilung"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Damage and Healing Spells"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Zauberschaden und Heilung"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, --StatLogic:GetSum("item:22630")
	["Zauberschaden"] = {StatLogic.Stats.SpellDamage,},
	["Zauberkraft"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Erhöht durch Zauber und magische Effekte verursachten Schaden und Heilung"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["Erhöht durch Zauber und magische Effekte zugefügten Schaden und Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Atiesh
	["Schaden"] = {StatLogic.Stats.SpellDamage,},
	["Erhöht Euren Zauberschaden"] = {StatLogic.Stats.SpellDamage,}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Schadenszauber"] = {StatLogic.Stats.SpellDamage},
	["Zaubermacht"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Erhöht die Zaubermacht"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- WotLK
	["Erhöht Zaubermacht"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- WotLK
	["Heiligschaden"] = {StatLogic.Stats.HolyDamage,},
	["Arkanschaden"] = {StatLogic.Stats.ArcaneDamage,},
	["Feuerschaden"] = {StatLogic.Stats.FireDamage,},
	["Naturschaden"] = {StatLogic.Stats.NatureDamage,},
	["Frostschaden"] = {StatLogic.Stats.FrostDamage,},
	["Schattenschaden"] = {StatLogic.Stats.ShadowDamage,},
	["Heiligzauberschaden"] = {StatLogic.Stats.HolyDamage,},
	["Arkanzauberschaden"] = {StatLogic.Stats.ArcaneDamage,},
	["Feuerzauberschaden"] = {StatLogic.Stats.FireDamage,},
	["Naturzauberschaden"] = {StatLogic.Stats.NatureDamage,},
	["Frostzauberschaden"] = {StatLogic.Stats.FrostDamage,}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Schattenzauberschaden"] = {StatLogic.Stats.ShadowDamage,},
	["Erhöht durch Arkanzauber und Arkaneffekte zugefügten Schaden"] = {StatLogic.Stats.ArcaneDamage,},
	["Erhöht durch Feuerzauber und Feuereffekte zugefügten Schaden"] = {StatLogic.Stats.FireDamage,},
	["Erhöht durch Frostzauber und Frosteffekte zugefügten Schaden"] = {StatLogic.Stats.FrostDamage,}, -- Frozen Shadoweave Vest ID:21871
	["Erhöht durch Heiligzauber und Heiligeffekte zugefügten Schaden"] = {StatLogic.Stats.HolyDamage,},
	["Erhöht durch Naturzauber und Natureffekte zugefügten Schaden"] = {StatLogic.Stats.NatureDamage,},
	["Erhöht durch Schattenzauber und Schatteneffekte zugefügten Schaden"] = {StatLogic.Stats.ShadowDamage,}, -- Frozen Shadoweave Vest ID:21871

	["Erhöht Heilung"] = {StatLogic.Stats.HealingPower,},
	["Heilung"] = {StatLogic.Stats.HealingPower,},
	["Heilzauber"] = {StatLogic.Stats.HealingPower,}, -- [Royal Nightseye] ID: 24057

	["Erhöht durch Zauber und Effekte verursachte Heilung"] = {StatLogic.Stats.HealingPower,},
	["Erhöht durch Zauber und magische Effekte zugefügte Heilung aller Gruppenmitglieder, die sich im Umkreis von 30 befinden,"] = {StatLogic.Stats.HealingPower,}, -- Atiesh
	--					["your healing"] = {StatLogic.Stats.HealingPower,}, -- Atiesh

	["Schaden pro Sekunde"] = {StatLogic.Stats.WeaponDPS,},
	["zusätzlichen Schaden pro Sekunde"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15997 "Verursacht 17.5 zusätzlichen Schaden pro Sekunde."
	["Verursacht zusätzlichen Schaden pro Sekunde"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15997

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

	["verbessert eure trefferchance%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit,},
	["Erhöht Eure Trefferchance mit Zaubern sowie Nahkampf- und Distanzangriffen%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit},
	["erhöht eure chance mit zaubern zu treffen%"] = {StatLogic.Stats.SpellHit,},
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