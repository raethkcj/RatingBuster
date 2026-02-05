--[[
Name: RatingBuster deDE locale
Translated by:
- Kuja
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "deDE")
if not L then return end
addon.S = {}
local S = addon.S
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L["RatingBuster Options"] = "RatingBuster Optionen"
---------------------------
-- Slash Command Options --
---------------------------
L["Help"] = "Help"
L["Show this help message"] = "Show this help message"
L["Options Window"] = "Optionsfenster"
L["Shows the Options Window"] = "Zeigt das Optionsfenster"
L["Enable Stat Mods"] = "Aktiviere Stat Mods"
L["Enable support for Stat Mods"] = "Aktiviert die Unterstützung von Stat Mods"
L["Enable Avoidance Diminishing Returns"] = "Aktiviere Diminishing Returns für Vermeidung"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Ausweichen, Parieren und Treffervermeidung wird über die Diminishing Returns (Abnehmende Wirkung) Formel berechnet"
L["Show ItemID"] = "Zeige ItemID"
L["Show the ItemID in tooltips"] = "Zeigt ItemID im Tooltip"
L["Show ItemLevel"] = "Zeige ItemLevel"
L["Show the ItemLevel in tooltips"] = "Zeigt ItemLevel im Tooltip"
L["Use required level"] = "Nutze benötigten Level"
L["Calculate using the required level if you are below the required level"] = "Berechne auf Basis des Benötigten Levels falls du unter diesem bist"
L["Set level"] = "Setze Level"
L["Set the level used in calculations (0 = your level)"] = "Legt den Level der zur Berechnung Benutzt wird fest (0 = dein Level)"
L["Change text color"] = "Ändere Textfarbe"
L["Changes the color of added text"] = "Ändert die Textfarbe des hinzugefügten Textes"
L["Change number color"] = "Change number color"
L["Rating"] = "Bewertung"
L["Options for Rating display"] = "Optionen für die Bewertungsanzeige"
L["Show Rating conversions"] = "Zeige Bewertungsumrechnung"
L["Show Rating conversions in tooltips"] = "Zeige Bewertungsumrechnung im Tooltip"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
L["Show Spell Hit/Haste"] = "Zeige Zaubertempo/-trefferchance"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Zeige Zaubertempo/-trefferchance von Tempo-/Trefferwertung"
L["Show Physical Hit/Haste"] = "Zeige physisches Tempo/Trefferchance"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Zeige physisches Tempo/Trefferchance von Tempo-/Trefferwertung"
L["Show detailed conversions text"] = "Zeige detaillierten Umrechnungtext"
L["Show detailed text for Resilience and Expertise conversions"] = "Zeige detaillierten Text für Abhärtungs- und Waffenkundumrechnung"
L["Defense breakdown"] = "Verteidigungsanalyse"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Wandle Verteidigung in Vermeidung von (kritischen) Treffern, Ausweichen, Parieren und Blocken um"
L["Weapon Skill breakdown"] = "Waffenfertigkeitswertungsanalyse"
L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "Wandle Waffenfertigkeitswertung in (kritische) Treffer, Ausweich-, Parier-, und Blockmissachtung um"
L["Expertise breakdown"] = "Waffenkundeanalyse"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Wandle Waffenkunde in Ausweich- und Pariermissachtung um"

L["Stat Breakdown"] = "Werte"
L["Changes the display of base stats"] = "Zeigt die Basiswerte an"
L["Show base stat conversions"] = "Zeige Basiswertumwandlung"
L["Show base stat conversions in tooltips"] = "Zeige Basiswertumwandlung im Tooltip"
L["Changes the display of %s"] = "Ändert die Anzeige von %s"
---------------------------------------------------------------------------
L["Stat Summary"] = "Werteübersicht"
L["Options for stat summary"] = "Optionen für die Werteübersicht"
L["Sum %s"] = "%s zusammenrechnen"
L["Show stat summary"] = "Zeige Werteübersicht"
L["Show stat summary in tooltips"] = "Zeige Werteübersicht im Tooltip"
L["Ignore settings"] = "Ignorierungseinstellungen"
L["Ignore stuff when calculating the stat summary"] = "Ignoriere Werte bei der Berechnung der Werteübersicht"
L["Ignore unused item types"] = "Ignoriere Ungenutzte Itemtypen"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Zeige Werteübersicht nur für den Höchstleveligen Itemtyp und benutzbare Items mit der Qualität \"Selten\" oder höher"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
L["Ignore equipped items"] = "Ignoriere Angelegte Items"
L["Hide stat summary for equipped items"] = "Verstecke Werteübersicht für Angelegte Items"
L["Ignore enchants"] = "Ignoriere Verzauberungen"
L["Ignore enchants on items when calculating the stat summary"] = "Ignoriere Itemverzauberungen für die Berechnung der Werteübersicht"
L["Ignore gems"] = "Ignoriere Edelsteine"
L["Ignore gems on items when calculating the stat summary"] = "Ignoriere Edelsteine auf gesockelten Items für die Berechnung der Werteübersicht"
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
L["Display style for diff value"] = "Anzeigestil für veränderte Werte"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Zeige veränderte Werte im Hauptooltip oder nur in Vergleichstooltips"
L["Hide Blizzard Item Comparisons"] = "Verstecke Blizzard Gegenstandsvergleich"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Deaktiviert den Gegenstandsvergleich von Blizzard, wenn der eingebaute Vergleichstooltip verwendet wird"
L["Add empty line"] = "Füge leere Zeile hinzu"
L["Add a empty line before or after stat summary"] = "Füge eine leere Zeile vor oder nach der Werteübersicht hinzu"
L["Add before summary"] = "Vor Berechnung hinzufügen"
L["Add a empty line before stat summary"] = "Füge eine leere Zeile vor der Werteübersicht hinzu"
L["Add after summary"] = "Nach Berechnung hinzufügen"
L["Add a empty line after stat summary"] = "Füge eine leere Zeile nach der Werteübersicht hinzu"
L["Show icon"] = "Zeige Symbol"
L["Show the sigma icon before stat summary"] = "Zeige das Sigma Symbol vor der Übersichtsliste an"
L["Show title text"] = "Zeige Titeltext"
L["Show the title text before stat summary"] = "Zeige Titeltext vor der Übersichtsliste an"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
L["Show zero value stats"] = "Zeige Nullwerte"
L["Show zero value stats in summary for consistancy"] = "Zeige zur Konsistenz die Nullwerte in der Übersicht an"
L["Calculate stat sum"] = "Berechne Wertesummen"
L["Calculate the total stats for the item"] = "Berechne die Gesamtwerte der Items"
L["Calculate stat diff"] = "Berechne Wertedifferenz"
L["Calculate the stat difference for the item and equipped items"] = "Berechne Wertedifferenz für das Item und angelegte Items"
L["Sort StatSummary alphabetically"] = "Sortiere Werteübersicht Alphabetisch"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "Sortiere Werteübersicht alphabetisch, deaktivieren um nach Wertetyp zu sortieren (Basis, Physisch, Zauber, Tank)"
L["Include block chance in Avoidance summary"] = "Zeige Blockchance in Vermeidungsübersicht"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "Zeige Blockchance in Vermeidungsübersicht, deaktivieren um nur Ausweichen, Parieren und Verfehlen zu zeigen"
L["Stat - Basic"] = "Werte - Basis"
L["Choose basic stats for summary"] = "Wähle Basiswerte für die Übersicht"
L["Stat - Physical"] = "Werte - Physisch"
L["Choose physical damage stats for summary"] = "Wähle Physische Schadenswerte für die Übersicht"
L["Ranged"] = "Ranged"
L["Weapon"] = "Weapon"
L["Stat - Spell"] = "Werte - Zauber"
L["Choose spell damage and healing stats for summary"] = "Wähle Zauberschaden und Heilungswerte für die Übersicht"
L["Stat - Tank"] = "Werte - Tank"
L["Choose tank stats for summary"] = "Zeige Tankwerte für die Übersicht"
L["Health <- Health Stamina"] = "Leben <- Leben, Ausdauer"
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelligenz"
L["Attack Power <- Attack Power Strength, Agility"] = "Angriffskraft <- Angriffskraft, Stärke, Beweglichkeit"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "Distanzangriffskraft <- Distanzangriffskraft, Intelligenz, Angriffskraft, Stärke, Beweglichkeit"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Zauberschaden <- Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Heiligzauberschaden <- Heiligzauberschaden, Zauberschaden, Intelligenz, Willenskraft"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Arkanzauberschaden <- Arkanzauberschaden, Zauberschaden, Intelligenz"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Feuerzauberschaden <- Feuerzauberschaden, Zauberschaden, Intelligenz, Ausdauer"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Naturzauberschaden <- Naturzauberschaden, Zauberschaden, Intelligenz"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Frostzauberschaden <- Frostzauberschaden, Zauberschaden, Intelligenz"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Schattenzauberschaden <- Schattenzauberschaden, Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Heilung <- Heilung, Intelligenz, Willenskraft, Beweglichkeit, Sträke"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Trefferchance <- Trefferwertung, Waffenfertigkeitswertung"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "kritische Trefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung"
L["Haste <- Haste Rating"] = "Tempo <- Tempowertung"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Distanztrefferchance <- Trefferwertung, Waffenfertigkeitswertung, Distanztrefferwertung"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Kritische Distanztrefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung, kritische Distanztrefferwertung"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Distanztempo <- Tempowertung, Distanztempowertung"
L["Spell Hit Chance <- Spell Hit Rating"] = "Zaubertrefferchance <- Zaubertrefferwertung"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "kritische Zaubertrefferchance <- kritische Zaubertrefferwertung, Intelligenz"
L["Spell Haste <- Spell Haste Rating"] = "Zaubertempo <- Zaubertempowertung"
L["Mana Regen <- Mana Regen Spirit"] = "Manaregeneration <- Manaregeneration, Willenskraft"
L["Mana Regen while not casting <- Spirit"] = "Manaregeneration (nicht Zaubernd) <- Manaregeneration (nicht Zaubernd) Willenskraft"
L["Health Regen <- Health Regen"] = "Lebensregeneration <- Lebensregeneration"
L["Health Regen when out of combat <- Spirit"] = "Lebensregeneration außerhalb des Kampfes Willenskraft"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Rüstung <- Rüstung von Items, Rüstung von Boni, Beweglichkeit, Intelligenz"
L["Block Value <- Block Value Strength"] = "Blockwert <- Blockwert, Stärke"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Ausweichchance <- Ausweichwertung, Beweglichkeit, Verteidigungswertung"
L["Parry Chance <- Parry Rating Defense Rating"] = "Parierchance <- Parierwertung, Verteidigungswertung"
L["Block Chance <- Block Rating Defense Rating"] = " Blockchance <- Blockwertung, Verteidigungswertung"
L["Hit Avoidance <- Defense Rating"] = "Treffervermeidung <- Verteidigungswertung"
L["Crit Avoidance <- Defense Rating Resilience"] = "kritische Treffervermeidung <- Verteidigungswertung, Abhärtungswertung"
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "Ausweichmissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "Pariermissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0
L["Defense <- Defense Rating"] = "Verteidigung <- Verteidigungswertung"
L["Weapon Skill <- Weapon Skill Rating"] = "Waffenfertigkeit <- Waffenfertigkeitswertung"
L["Expertise <- Expertise Rating"] = "Waffenkunde <- Waffenkundewertung"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Vermeidung <- Ausweichen, Parieren, MobMiss, Block(Optional)"
L["Gems"] = "Edelsteine"
L["Auto fill empty gem slots"] = "Leere Edelsteinplätze automatisch füllen"
L["ItemID or Link of the gem you would like to auto fill"] = "ItemID oder Link des einzusetzenden Edelsteins"
L["<ItemID|Link>"] = "<ItemID|Link>"
L["%s is now set to %s"] = "%s ist nun auf %s gesetzt"
L["Queried server for Gem: %s. Try again in 5 secs."] = "Frage den Server nach Edelstein: %s. Versuchs in 5 Sekunden nochmal"

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = true
L["ItemID: "] = true

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = "Erlaubt RatingBuster gewählte Buffs zu berechnen, auch wenn du diese nicht wirklich hast"
L["$class Self Buffs"] = "Eigenbuffs"
L["Raid Buffs"] = "Raidbuffs"
L["Stat Multiplier"] = "Wertemultiplikatoren"
L["Attack Power Multiplier"] = "Angriffskraft-Multiplikatoren"
L["Reduced Physical Damage Taken"] = "Reduzierter erlittener physischer Schaden"

L["Swap Profiles"] = "Swap Profiles"
L["Swap Profile Keybinding"] = "Swap Profile Keybinding"
L["Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."] = "Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."
L["Primary Profile"] = "Primary Profile"
L["Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."] = "Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."
L["Secondary Profile"] = "Secondary Profile"
L["Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."] = "Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."

-- These patterns are used to reposition stat breakdowns.
-- They are not mandatory; if not present for a given stat,
-- the breakdown will simply appear after the number.
-- They will only ever position the breakdown further after the number; not before it.
-- E.g. default positioning:
--   "Strength +5 (10 AP)"
--   "+5 (10 AP) Strength"
-- If "strength" is added in statPatterns:
--   "Strength +5 (10 AP)"
--   "+5 Strength (10 AP)"
-- The strings are lowerecased and passed into string.find,
-- so you should escape the magic characters ^$()%.[]*+-? with a %
-- Use /rb debug to help with debugging stat patterns
L["statPatterns"] = {
	[StatLogic.Stats.Strength] = { SPELL_STAT1_NAME:lower() },
	[StatLogic.Stats.Agility] = { SPELL_STAT2_NAME:lower() },
	[StatLogic.Stats.Stamina] = { SPELL_STAT3_NAME:lower() },
	[StatLogic.Stats.Intellect] = { SPELL_STAT4_NAME:lower() },
	[StatLogic.Stats.Spirit] = { SPELL_STAT5_NAME:lower() },
	[StatLogic.Stats.DefenseRating] = { "verteidigungswertung" },
	[StatLogic.Stats.Defense] = { DEFENSE:lower() },
	[StatLogic.Stats.DodgeRating] = { "ausweichwertung", "ausweichen" },
	[StatLogic.Stats.BlockRating] = { "blockwertung", "blocken" },
	[StatLogic.Stats.ParryRating] = { "parierwertung", "parieren" },

	[StatLogic.Stats.SpellPower] = { "zaubermacht" },
	[StatLogic.Stats.GenericAttackPower] = { "angriffskraft" },

	[StatLogic.Stats.MeleeCritRating] = { "kritische trefferwertung", "kritischer trefferwert" },
	[StatLogic.Stats.RangedCritRating] = { "kritische distanztrefferwertung" },
	[StatLogic.Stats.SpellCritRating] = { "kritische zaubertrefferwertung" },
	[StatLogic.Stats.CritRating] = { "kritische trefferwertung", "kritischer trefferwert" },

	[StatLogic.Stats.MeleeHitRating] = { "trefferwertung", "trefferwert" },
	[StatLogic.Stats.RangedHitRating] = {},
	[StatLogic.Stats.SpellHitRating] = { "zaubertrefferwertung" },
	[StatLogic.Stats.HitRating] = { "trefferwertung", "trefferwert" },

	[StatLogic.Stats.ResilienceRating] = { "abhärtungswertung", "abhärtung" },
	[StatLogic.Stats.PvpPowerRating] = { ITEM_MOD_PVP_POWER_SHORT:lower() },

	[StatLogic.Stats.MeleeHasteRating] = { "angriffstempowertung", "nahkampftempowertung", "tempowertung", "tempo" },
	[StatLogic.Stats.RangedHasteRating] = { "distanztempowertung" },
	[StatLogic.Stats.SpellHasteRating] = { "zaubertempowertung" },
	[StatLogic.Stats.HasteRating] = { "angriffstempowertung", "tempowertung", "tempo" },

	[StatLogic.Stats.ExpertiseRating] = { "waffenkundewertung", "waffenkunde" },

	[StatLogic.Stats.AllStats] = { SPELL_STATALL:lower() },

	[StatLogic.Stats.ArmorPenetrationRating] = { "rüstungsdurchschlagwertung", "rüstungsdurchschlag" },
	[StatLogic.Stats.MasteryRating] = { "meisterschaft" },
	[StatLogic.Stats.Armor] = { ARMOR:lower() },
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["numberSuffix"] = ""
L["Show %s"] = SHOW.." %s"
L["Show Modified %s"] = "Show Modified %s"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["Spell"] = "Zauber"

-- Basic Attributes
L[StatLogic.Stats.Strength] = "Stärke"
L[StatLogic.Stats.Agility] = "Beweglichkeit"
L[StatLogic.Stats.Stamina] = "Ausdauer"
L[StatLogic.Stats.Intellect] = "Intelligenz"
L[StatLogic.Stats.Spirit] = "Willenskraft"
L[StatLogic.Stats.Mastery] = "Meisterschaft"
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format("Meisterschaft")
L[StatLogic.Stats.MasteryRating] = "Meisterschaftswertung"

-- Resources
L[StatLogic.Stats.Health] = "Leben"
S[StatLogic.Stats.Health] = "HP"
L[StatLogic.Stats.Mana] = "Mana"
S[StatLogic.Stats.Mana] = "MP"
L[StatLogic.Stats.ManaRegen] = "Manaregeneration"
S[StatLogic.Stats.ManaRegen] = "MP5"

local ManaRegenOutOfCombat = "Manaregeneration (Nicht im Kampf)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "Manaregeneration (Nicht Zaubernd)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "MP5(NC)"

L[StatLogic.Stats.HealthRegen] = "Lebensregeneration"
S[StatLogic.Stats.HealthRegen] = "HP5"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Lebensregeneration (Nicht im Kampf)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "HP5(NC)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "Angriffskraft"
S[StatLogic.Stats.AttackPower] = "AP"
L[StatLogic.Stats.FeralAttackPower] = "Feral "..ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.IgnoreArmor] = "Rüstung ignorieren"
L[StatLogic.Stats.ArmorPenetration] = "Rüstungsdurchlag"
L[StatLogic.Stats.ArmorPenetrationRating] = "Rüstungsdurchschlagwertung"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "Waffenschaden" -- DAMAGE = "Damage"
L[StatLogic.Stats.WeaponDPS] = "Schaden pro Sekunde"

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "Trefferchance"
L[StatLogic.Stats.MeleeHitRating] = "Trefferwertung"
L[StatLogic.Stats.MeleeCrit] = "kritische Trefferchance"
S[StatLogic.Stats.MeleeCrit] = "krit."
L[StatLogic.Stats.MeleeCritRating] = "kritische Trefferwertung"
L[StatLogic.Stats.MeleeHaste] = "Tempo"
L[StatLogic.Stats.MeleeHasteRating] = "Tempowertung"

L[StatLogic.Stats.WeaponSkill] = "Waffenfertigkeit"
L[StatLogic.Stats.Expertise] = "Waffenkunde"
L[StatLogic.Stats.ExpertiseRating] = "Waffenkundewertung"
L[StatLogic.Stats.DodgeReduction] = "Ausweichverhinderung"
S[StatLogic.Stats.DodgeReduction] = "wird Ausgewichen"
L[StatLogic.Stats.ParryReduction] = "Parierverhinderung"
S[StatLogic.Stats.ParryReduction] = "wird Pariert"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "Distanzangriffskraft (RAP)"
S[StatLogic.Stats.RangedAttackPower] = "RAP"
L[StatLogic.Stats.RangedHit] = "Distanztrefferchance"
L[StatLogic.Stats.RangedHitRating] = "Distanztrefferwertung"
L[StatLogic.Stats.RangedCrit] = "Kritische Distanztrefferchance"
L[StatLogic.Stats.RangedCritRating] = "Kritische Distanztrefferwertung"
L[StatLogic.Stats.RangedHaste] = "Distanztempo"
L[StatLogic.Stats.RangedHasteRating] = "Distanztempowertung"

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "Zauberschaden"
S[StatLogic.Stats.SpellDamage] = "Schaden"
L[StatLogic.Stats.HealingPower] = "Heilung"
S[StatLogic.Stats.HealingPower] = "Heilung"
L[StatLogic.Stats.SpellPenetration] = "Durchschlag"

L[StatLogic.Stats.HolyDamage] = "Heiligzauberschaden"
L[StatLogic.Stats.FireDamage] = "Feuerzauberschaden"
L[StatLogic.Stats.NatureDamage] = "Naturzauberschaden"
L[StatLogic.Stats.FrostDamage] = "Frostzauberschaden"
L[StatLogic.Stats.ShadowDamage] = "Schattenzauberschaden"
L[StatLogic.Stats.ArcaneDamage] = "Arkanzauberschaden"

L[StatLogic.Stats.SpellHit] = "Zaubertrefferchance"
S[StatLogic.Stats.SpellHit] = "Zaubertrefferchance"
L[StatLogic.Stats.SpellHitRating] = "Zaubertrefferwertung"
L[StatLogic.Stats.SpellCrit] = "kritische Zaubertrefferchance"
S[StatLogic.Stats.SpellCrit] = "Zauberkrit."
L[StatLogic.Stats.SpellCritRating] = "kritische Zaubertrefferwertung"
L[StatLogic.Stats.SpellHaste] = "Zaubertempo"
L[StatLogic.Stats.SpellHasteRating] = "Zaubertempowertung"

-- Tank Stats
L[StatLogic.Stats.Armor] = "Rüstung"
L[StatLogic.Stats.BonusArmor] = "Rüstung"

L[StatLogic.Stats.Avoidance] = "Vermeidung"
L[StatLogic.Stats.Dodge] = "Ausweichchance"
S[StatLogic.Stats.Dodge] = "Ausweichen"
L[StatLogic.Stats.DodgeRating] = "Verteidigungswertung"
L[StatLogic.Stats.Parry] = "Parierchance"
S[StatLogic.Stats.Parry] = "Parieren"
L[StatLogic.Stats.ParryRating] = "Parierwertung"
L[StatLogic.Stats.BlockChance] = "Blockchance"
L[StatLogic.Stats.BlockRating] = "Blockwertung"
L[StatLogic.Stats.BlockValue] = "Blockwert"
S[StatLogic.Stats.BlockValue] = "Blocken"
L[StatLogic.Stats.Miss] = "Treffervermeidung"

L[StatLogic.Stats.Defense] = "Verteidigung"
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = "kritische Treffervermeidung"
S[StatLogic.Stats.CritAvoidance] = "wird kritisch"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "Abhärtung"
L[StatLogic.Stats.CritDamageReduction] = "Krit Schadenverminderung"
S[StatLogic.Stats.CritDamageReduction] = "erlittener krit. Schaden"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "erlitter Schaden im PVP"

L[StatLogic.Stats.FireResistance] = "Feuerwiderstand"
L[StatLogic.Stats.NatureResistance] = "Naturwiderstand"
L[StatLogic.Stats.FrostResistance] = "Frostwiderstand"
L[StatLogic.Stats.ShadowResistance] = "Schattenwiderstand"
L[StatLogic.Stats.ArcaneResistance] = "Arkanwiderstand"