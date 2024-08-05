--[[
Name: RatingBuster deDE locale
Revision: $Revision: 75639 $
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
-- /rb optionswin
L["Options Window"] = "Optionsfenster"
L["Shows the Options Window"] = "Zeigt das Optionsfenster"
-- /rb statmod
L["Enable Stat Mods"] = "Aktiviere Stat Mods"
L["Enable support for Stat Mods"] = "Aktiviert die Unterstützung von Stat Mods"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Aktiviere Diminishing Returns für Vermeidung"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Ausweichen, Parieren und Treffervermeidung wird über die Diminishing Returns (Abnehmende Wirkung) Formel berechnet"
-- /rb itemid
L["Show ItemID"] = "Zeige ItemID"
L["Show the ItemID in tooltips"] = "Zeigt ItemID im Tooltip"
-- /rb itemlevel
L["Show ItemLevel"] = "Zeige ItemLevel"
L["Show the ItemLevel in tooltips"] = "Zeigt ItemLevel im Tooltip"
-- /rb usereqlv
L["Use required level"] = "Nutze benötigten Level"
L["Calculate using the required level if you are below the required level"] = "Berechne auf Basis des Benötigten Levels falls du unter diesem bist"
-- /rb setlevel
L["Set level"] = "Setze Level"
L["Set the level used in calculations (0 = your level)"] = "Legt den Level der zur Berechnung Benutzt wird fest (0 = dein Level)"
-- /rb color
L["Change text color"] = "Ändere Textfarbe"
L["Changes the color of added text"] = "Ändert die Textfarbe des hinzugefügten Textes"
L["Change number color"] = "Change number color"
-- /rb rating
L["Rating"] = "Bewertung"
L["Options for Rating display"] = "Optionen für die Bewertungsanzeige"
-- /rb rating show
L["Show Rating conversions"] = "Zeige Bewertungsumrechnung"
L["Show Rating conversions in tooltips"] = "Zeige Bewertungsumrechnung im Tooltip"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = "Zeige Zaubertempo/-trefferchance"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Zeige Zaubertempo/-trefferchance von Tempo-/Trefferwertung"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "Zeige physisches Tempo/Trefferchance"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Zeige physisches Tempo/Trefferchance von Tempo-/Trefferwertung"
-- /rb rating detail
L["Show detailed conversions text"] = "Zeige detaillierten Umrechnungtext"
L["Show detailed text for Resilience and Expertise conversions"] = "Zeige detaillierten Text für Abhärtungs- und Waffenkundumrechnung"
-- /rb rating def
L["Defense breakdown"] = "Verteidigungsanalyse"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Wandle Verteidigung in Vermeidung von (kritischen) Treffern, Ausweichen, Parieren und Blocken um"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Waffenfertigkeitswertungsanalyse"
L["Convert Weapon Skill into Crit Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "Wandle Waffenfertigkeitswertung in (kritische) Treffer, Ausweich-, Parier-, und Blockmissachtung um"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Waffenkundeanalyse"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Wandle Waffenkunde in Ausweich- und Pariermissachtung um"

-- /rb stat
--["Stat Breakdown"] = "Werte",
L["Changes the display of base stats"] = "Zeigt die Basiswerte an"
-- /rb stat show
L["Show base stat conversions"] = "Zeige Basiswertumwandlung"
L["Show base stat conversions in tooltips"] = "Zeige Basiswertumwandlung im Tooltip"
L["Changes the display of %s"] = "Ändert die Anzeige von %s"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Werteübersicht"
L["Options for stat summary"] = "Optionen für die Werteübersicht"
L["Sum %s"] = "%s zusammenrechnen"
-- /rb sum show
L["Show stat summary"] = "Zeige Werteübersicht"
L["Show stat summary in tooltips"] = "Zeige Werteübersicht im Tooltip"
-- /rb sum ignore
L["Ignore settings"] = "Ignorierungseinstellungen"
L["Ignore stuff when calculating the stat summary"] = "Ignoriere Werte bei der Berechnung der Werteübersicht"
-- /rb sum ignore unused
L["Ignore unused item types"] = "Ignoriere Ungenutzte Itemtypen"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Zeige Werteübersicht nur für den Höchstleveligen Itemtyp und benutzbare Items mit der Qualität \"Selten\" oder höher"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Ignoriere Angelegte Items"
L["Hide stat summary for equipped items"] = "Verstecke Werteübersicht für Angelegte Items"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Ignoriere Verzauberungen"
L["Ignore enchants on items when calculating the stat summary"] = "Ignoriere Itemverzauberungen für die Berechnung der Werteübersicht"
-- /rb sum ignore gem
L["Ignore gems"] = "Ignoriere Edelsteine"
L["Ignore gems on items when calculating the stat summary"] = "Ignoriere Edelsteine auf gesockelten Items für die Berechnung der Werteübersicht"
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
-- /rb sum diffstyle
L["Display style for diff value"] = "Anzeigestil für veränderte Werte"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Zeige veränderte Werte im Hauptooltip oder nur in Vergleichstooltips"
L["Hide Blizzard Item Comparisons"] = "Verstecke Blizzard Gegenstandsvergleich"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Deaktiviert den Gegenstandsvergleich von Blizzard, wenn der eingebaute Vergleichstooltip verwendet wird"
-- /rb sum space
L["Add empty line"] = "Füge leere Zeile hinzu"
L["Add a empty line before or after stat summary"] = "Füge eine leere Zeile vor oder nach der Werteübersicht hinzu"
-- /rb sum space before
L["Add before summary"] = "Vor Berechnung hinzufügen"
L["Add a empty line before stat summary"] = "Füge eine leere Zeile vor der Werteübersicht hinzu"
-- /rb sum space after
L["Add after summary"] = "Nach Berechnung hinzufügen"
L["Add a empty line after stat summary"] = "Füge eine leere Zeile nach der Werteübersicht hinzu"
-- /rb sum icon
L["Show icon"] = "Zeige Symbol"
L["Show the sigma icon before summary listing"] = "Zeige das Sigma Symbol vor der Übersichtsliste an"
-- /rb sum title
L["Show title text"] = "Zeige Titeltext"
L["Show the title text before stat summary"] = "Zeige Titeltext vor der Übersichtsliste an"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
-- /rb sum showzerostat
L["Show zero value stats"] = "Zeige Nullwerte"
L["Show zero value stats in summary for consistancy"] = "Zeige zur Konsistenz die Nullwerte in der Übersicht an"
-- /rb sum calcsum
L["Calculate stat sum"] = "Berechne Wertesummen"
L["Calculate the total stats for the item"] = "Berechne die Gesamtwerte der Items"
-- /rb sum calcdiff
L["Calculate stat diff"] = "Berechne Wertedifferenz"
L["Calculate the stat difference for the item and equipped items"] = "Berechne Wertedifferenz für das Item und angelegte Items"
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "Sortiere Werteübersicht Alphabetisch"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "Sortiere Werteübersicht alphabetisch, deaktivieren um nach Wertetyp zu sortieren (Basis, Physisch, Zauber, Tank)"
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "Zeige Blockchance in Vermeidungsübersicht"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "Zeige Blockchance in Vermeidungsübersicht, deaktivieren um nur Ausweichen, Parieren und Verfehlen zu zeigen"
-- /rb sum basic
L["Stat - Basic"] = "Werte - Basis"
L["Choose basic stats for summary"] = "Wähle Basiswerte für die Übersicht"
-- /rb sum physical
L["Stat - Physical"] = "Werte - Physisch"
L["Choose physical damage stats for summary"] = "Wähle Physische Schadenswerte für die Übersicht"
-- /rb sum spell
L["Stat - Spell"] = "Werte - Zauber"
L["Choose spell damage and healing stats for summary"] = "Wähle Zauberschaden und Heilungswerte für die Übersicht"
-- /rb sum tank
L["Stat - Tank"] = "Werte - Tank"
L["Choose tank stats for summary"] = "Zeige Tankwerte für die Übersicht"
-- /rb sum stat hp
L["Health <- Health Stamina"] = "Leben <- Leben, Ausdauer"
-- /rb sum stat mp
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelligenz"
-- /rb sum stat ap
L["Attack Power <- Attack Power Strength, Agility"] = "Angriffskraft <- Angriffskraft, Stärke, Beweglichkeit"
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "Distanzangriffskraft <- Distanzangriffskraft, Intelligenz, Angriffskraft, Stärke, Beweglichkeit"
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Zauberschaden <- Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Heiligzauberschaden <- Heiligzauberschaden, Zauberschaden, Intelligenz, Willenskraft"
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Arkanzauberschaden <- Arkanzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Feuerzauberschaden <- Feuerzauberschaden, Zauberschaden, Intelligenz, Ausdauer"
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Naturzauberschaden <- Naturzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Frostzauberschaden <- Frostzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Schattenzauberschaden <- Schattenzauberschaden, Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
-- /rb sum stat heal
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Heilung <- Heilung, Intelligenz, Willenskraft, Beweglichkeit, Sträke"
-- /rb sum stat hit
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Trefferchance <- Trefferwertung, Waffenfertigkeitswertung"
-- /rb sum stat crit
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "kritische Trefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung"
-- /rb sum stat haste
L["Haste <- Haste Rating"] = "Tempo <- Tempowertung"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Distanztrefferchance <- Trefferwertung, Waffenfertigkeitswertung, Distanztrefferwertung"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Kritische Distanztrefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung, kritische Distanztrefferwertung"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Distanztempo <- Tempowertung, Distanztempowertung"

-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "kritische Zaubertrefferchance <- kritische Zaubertrefferwertung, Intelligenz"
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = "Zaubertrefferchance <- Zaubertrefferwertung"
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = "Zaubertempo <- Zaubertempowertung"
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen Spirit"] = "Manaregeneration <- Manaregeneration, Willenskraft"
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = "Manaregeneration (nicht Zaubernd) <- Manaregeneration (nicht Zaubernd) Willenskraft"
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = "Lebensregeneration <- Lebensregeneration"
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = "Lebensregeneration außerhalb des Kampfes Willenskraft"
-- /rb sum stat armor
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Rüstung <- Rüstung von Items, Rüstung von Boni, Beweglichkeit, Intelligenz"
-- /rb sum stat blockvalue
L["Block Value <- Block Value Strength"] = "Blockwert <- Blockwert, Stärke"
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Ausweichchance <- Ausweichwertung, Beweglichkeit, Verteidigungswertung"
-- /rb sum stat parry
L["Parry Chance <- Parry Rating Defense Rating"] = "Parierchance <- Parierwertung, Verteidigungswertung"
-- /rb sum stat block
L["Block Chance <- Block Rating Defense Rating"] = " Blockchance <- Blockwertung, Verteidigungswertung"
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = "Treffervermeidung <- Verteidigungswertung"
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating Resilience"] = "kritische Treffervermeidung <- Verteidigungswertung, Abhärtungswertung"
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "Ausweichmissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "Pariermissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = "Verteidigung <- Verteidigungswertung"
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = "Waffenfertigkeit <- Waffenfertigkeitswertung"
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = "Waffenkunde <- Waffenkundewertung"
-- /rb sum statcomp avoid
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Vermeidung <- Ausweichen, Parieren, MobMiss, Block(Optional)"

-- /rb sum gem
L["Gems"] = "Edelsteine"
L["Auto fill empty gem slots"] = "Leere Edelsteinplätze automatisch füllen"
L["ItemID or Link of the gem you would like to auto fill"] = "ItemID oder Link des einzusetzenden Edelsteins"
--["<ItemID|Link>"] = true,
L["%s is now set to %s"] = "%s ist nun auf %s gesetzt"
L["Queried server for Gem: %s. Try again in 5 secs."] = "Frage den Server nach Edelstein: %s. Versuchs in 5 Sekunden nochmal"

-----------------------
-- Item Level and ID --
-----------------------
--	["ItemLevel: "] = true,
--	["ItemID: "] = true,

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

-----------------------
-- Matching Patterns --
-----------------------
-- Items to check --
--------------------
-- [Potent Ornate Topaz]
-- +6 Spell Damage, +5 Spell Crit Rating
--------------------
-- ZG enchant
-- +10 Defense Rating/+10 Stamina/+15 Block Value
--------------------
-- [Glinting Flam Spessarite]
-- +3 Hit Rating and +3 Agility
--------------------
-- ItemID: 22589
-- [Atiesh, Greatstaff of the Guardian] warlock version
-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
--------------------
-- [Brilliant Wizard Oil]
-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes.
----------------------------------------------------------------------------------------------------
-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
--
-- The first pass searches for the rating number, the patterns are read from ["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from ["statList"] here,
-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike",
-- this way "spell critical strike" does get matched by "critical strike".
-- Strings need to be in lower case letters, because string.lower is called on lookup
--
-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file,
-- but will need to go in game and find out what needs to be put in here.
-- For example, in english I found 3 different strings that maps to StatLogic.Stats.MeleeCritRating: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents StatLogic.Stats.MeleeCritRating, and so on.
-- In other languages there may be 5 different strings that should all map to StatLogic.Stats.MeleeCritRating.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	" um " .. addon.numberPattern,
	addon.numberPattern,
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
	["Sek."] = "SECOND"
}
L["separators"] = {
	"/", " und ", ",", "%. ", " für ", "&", ":", "\n"
}
--[[
SPELL_STAT1_NAME = "Stärke"
SPELL_STAT2_NAME = "Beweglichkeit"
SPELL_STAT3_NAME = "Ausdauer"
SPELL_STAT4_NAME = "Intelligenz"
SPELL_STAT5_NAME = "Willenskraft"
--]]
L["statList"] = {
	{SPELL_STAT1_NAME:lower(), StatLogic.Stats.Strength},
	{SPELL_STAT2_NAME:lower(), StatLogic.Stats.Agility},
	{SPELL_STAT3_NAME:lower(), StatLogic.Stats.Stamina},
	{SPELL_STAT4_NAME:lower(), StatLogic.Stats.Intellect},
	{SPELL_STAT5_NAME:lower(), StatLogic.Stats.Spirit},
	{"verteidigungswertung", StatLogic.Stats.DefenseRating},
	{DEFENSE:lower(), StatLogic.Stats.Defense},
	{"ausweichwertung", StatLogic.Stats.DodgeRating},
	{"blockwertung", StatLogic.Stats.BlockRating},
	{"parierwertung", StatLogic.Stats.ParryRating},

	{"kritische zaubertrefferwertung", StatLogic.Stats.SpellCritRating},
	{"kritische distanztrefferwertung", StatLogic.Stats.RangedCritRating},
	{"kritische trefferwertung", StatLogic.Stats.CritRating},

	{"zaubertrefferwertung", StatLogic.Stats.SpellHitRating},
	{"trefferwertung", StatLogic.Stats.RangedHitRating},
	{"trefferwertung", StatLogic.Stats.HitRating},

	{"abhärtungswertung", StatLogic.Stats.ResilienceRating},

	{"zaubertempowertung", StatLogic.Stats.SpellHasteRating},
	{"distanztempowertung", StatLogic.Stats.RangedHasteRating},
	{"angriffstempowertung", StatLogic.Stats.HasteRating},
	{"nahkampftempowertung", StatLogic.Stats.MeleeHasteRating},
	{"tempowertung", StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{"waffenkundewertung", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"rüstungsdurchschlagwertung", StatLogic.Stats.ArmorPenetrationRating},
	{"rüstungsdurchschlag", StatLogic.Stats.ArmorPenetrationRating},
	{"meisterschaft", StatLogic.Stats.MasteryRating},
	{ARMOR:lower(), StatLogic.Stats.Armor},
	{"angriffskraft", StatLogic.Stats.AttackPower},
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["Show %s"] = SHOW.." %s"
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
S[StatLogic.Stats.Armor] = "Rüstung"

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
L[StatLogic.Stats.PvPDamageReduction] = "erlitter Schaden im PVP"

L[StatLogic.Stats.FireResistance] = "Feuerwiderstand"
L[StatLogic.Stats.NatureResistance] = "Naturwiderstand"
L[StatLogic.Stats.FrostResistance] = "Frostwiderstand"
L[StatLogic.Stats.ShadowResistance] = "Schattenwiderstand"
L[StatLogic.Stats.ArcaneResistance] = "Arkanwiderstand"