--[[
Name: RatingBuster deDE locale
Revision: $Revision: 75639 $
Translated by:
- Kuja
]]

---@class RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "deDE")
if not L then return end
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
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
L["Change number color"] = true
-- /rb rating
L["Rating"] = "Bewertung"
L["Options for Rating display"] = "Optionen für die Bewertungsanzeige"
-- /rb rating show
L["Show Rating conversions"] = "Zeige Bewertungsumrechnung"
L["Show Rating conversions in tooltips"] = "Zeige Bewertungsumrechnung im Tooltip"
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = true
L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
L["Show Physical Hit/Haste"] = true
L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show detailed conversions text"] = "Zeige detaillierten Umrechnungtext"
L["Show detailed text for Resilience and Expertise conversions"] = "Zeige detaillierten Text für Abhärtungs- und Waffenkundumrechnung"
-- /rb rating def
L["Defense breakdown"] = "Verteidigungsanalyse"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Wandle Verteidigung in Vermeidung von (kritischen) Treffern, Ausweichen, Parieren und Blocken um"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Waffenfertigkeitswertungsanalyse"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Wandle Waffenfertigkeitswertung in (kritische) Treffer, Ausweich-, Parier-, und Blockmissachtung um"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Waffenkundeanalyse"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Wandle Waffenkunde in Ausweich- und Pariermissachtung um"

-- /rb stat
--["Stat Breakdown"] = "Werte",
L["Changes the display of base stats"] = "Zeigt die Basiswerte an"
-- /rb stat show
L["Show base stat conversions"] = "Zeige Basiswertumwandlung"
L["Show base stat conversions in tooltips"] = "Zeige Basiswertumwandlung im Tooltip"
-- /rb stat str
L["Strength"] = "Stärke"
L["Changes the display of Strength"] = "Zeigt Stärke an"

-- /rb stat agi
L["Agility"] = "Beweglichkeit"
L["Changes the display of Agility"] = "Zeigt Beweglichkeit an"
-- /rb stat agi crit
L["Show Crit"] = "Zeige Krit."
L["Show Crit chance from Agility"] = "Zeige Chance auf kritische Treffer resultierend aus Beweglichkeit"
-- /rb stat agi dodge
L["Show Dodge"] = "Zeige Ausweichen"
L["Show Dodge chance from Agility"] = "Zeige Ausweichchance resultierend aus Beweglichkeit"

-- /rb stat sta
L["Stamina"] = "Ausdauer"
L["Changes the display of Stamina"] = "Zeige Ausdauer an"

-- /rb stat int
L["Intellect"] = "Intelligenz"
L["Changes the display of Intellect"] = "Zeige Intelligenz an"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Zeige Zauberkrit."
L["Show Spell Crit chance from Intellect"] = "Zeige Chance auf kritische Zaubertreffer resultierend aus Intelligent"

-- /rb stat spi
L["Spirit"] = "Willenskraft"
L["Changes the display of Spirit"] = "Zeige Willenskraft an"

---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "Rüstung"
L["Changes the display of Armor"] = "Ändert die Anzeige von Rüstung"
L["Attack Power"] = "Angriffskraft"
L["Changes the display of Attack Power"] = "Ändert die Anzeige von Angriffskraft"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Werteübersicht"
L["Options for stat summary"] = "Optionen für die Werteübersicht"
-- /rb sum show
L["Show stat summary"] = "Zeige Werteübersicht"
L["Show stat summary in tooltips"] = "Zeige Werteübersicht im Tooltip"
-- /rb sum ignore
L["Ignore settings"] = "Ignorierungseinstellungen"
L["Ignore stuff when calculating the stat summary"] = "Ignoriere Werte bei der Berechnung der Werteübersicht"
-- /rb sum ignore unused
L["Ignore unused item types"] = "Ignoriere Ungenutzte Itemtypen"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Zeige Werteübersicht nur für den Höchstleveligen Itemtyp und benutzbare Items mit der Qualität \"Selten\" oder höher"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Ignoriere Angelegte Items"
L["Hide stat summary for equipped items"] = "Verstecke Werteübersicht für Angelegte Items"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Ignoriere Verzauberungen"
L["Ignore enchants on items when calculating the stat summary"] = "Ignoriere Itemverzauberungen für die Berechnung der Werteübersicht"
-- /rb sum ignore gem
L["Ignore gems"] = "Ignoriere Edelsteine"
L["Ignore gems on items when calculating the stat summary"] = "Ignoriere Edelsteine auf gesockelten Items für die Berechnung der Werteübersicht"
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
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
L["Show the title text before summary listing"] = "Zeige Titeltext vor der Übersichtsliste an"
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
L["Sum Health"] = "Leben zusammenrechnen"
L["Health <- Health Stamina"] = "Leben <- Leben, Ausdauer"
-- /rb sum stat mp
L["Sum Mana"] = "Mana zusammenrechnen"
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelligenz"
-- /rb sum stat ap
L["Sum Attack Power"] = "Angriffskraft zusammenrechnen"
L["Attack Power <- Attack Power Strength, Agility"] = "Angriffskraft <- Angriffskraft, Stärke, Beweglichkeit"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "Distanzangriffskraft (RAP) zusammenrechnen"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "Distanzangriffskraft <- Distanzangriffskraft, Intelligenz, Angriffskraft, Stärke, Beweglichkeit"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Zauberschaden zusammenrechnen"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Zauberschaden <- Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Heiligzauberschaden zusammenrechnen"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Heiligzauberschaden <- Heiligzauberschaden, Zauberschaden, Intelligenz, Willenskraft"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Arkanzauberschaden zusammenrechnen"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Arkanzauberschaden <- Arkanzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Feuerzauberschaden zusammenrechnen"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Feuerzauberschaden <- Feuerzauberschaden, Zauberschaden, Intelligenz, Ausdauer"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Naturzauberschaden zusammenrechnen"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Naturzauberschaden <- Naturzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Frostzauberschaden zusammenrechnen"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Frostzauberschaden <- Frostzauberschaden, Zauberschaden, Intelligenz"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Schattenzauberschaden zusammenrechnen"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Schattenzauberschaden <- Schattenzauberschaden, Zauberschaden, Intelligenz, Willenskraft, Ausdauer"
-- /rb sum stat heal
L["Sum Healing"] = "Heilung zusammenrechnen"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Heilung <- Heilung, Intelligenz, Willenskraft, Beweglichkeit, Sträke"
-- /rb sum stat hit
L["Sum Hit Chance"] = "Trefferchance zusammenrechnen"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Trefferchance <- Trefferwertung, Waffenfertigkeitswertung"
-- /rb sum stat crit
L["Sum Crit Chance"] = "kritische Trefferchance zusammenrechnen"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "kritische Trefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung"
-- /rb sum stat haste
L["Sum Haste"] = "Tempo zusammenrechnen"
L["Haste <- Haste Rating"] = "Tempo <- Tempowertung"
L["Sum Ranged Hit Chance"] = "Distanztrefferchance zusammenrechnen"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Distanztrefferchance <- Trefferwertung, Waffenfertigkeitswertung, Distanztrefferwertung"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "Distanztrefferwertung zusammenrechnen"
L["Ranged Hit Rating Summary"] = "Distanztrefferwertungsübersicht"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "Kritische Distanztrefferchance zusammenrechnen"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Kritische Distanztrefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung, kritische Distanztrefferwertung"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "Kritische Distanztrefferwertung zusammenrechnen"
L["Ranged Crit Rating Summary"] = "Kritische Distanztrefferwertungsübersicht"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "Distanztempo zusammenrechnen"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Distanztempo <- Tempowertung, Distanztempowertung"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "Distanztempowertung zusammenrechnen"
L["Ranged Haste Rating Summary"] = "Distanztempowertungsübersicht"

-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "kritische Zaubertrefferchance zusammenrechnen"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "kritische Zaubertrefferchance <- kritische Zaubertrefferwertung, Intelligenz"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Zaubertrefferchance zusammenrechnen"
L["Spell Hit Chance <- Spell Hit Rating"] = "Zaubertrefferchance <- Zaubertrefferwertung"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "Zaubertempo zusammenrechnen"
L["Spell Haste <- Spell Haste Rating"] = "Zaubertempo <- Zaubertempowertung"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Manaregeneration zusammenrechnen"
L["Mana Regen <- Mana Regen Spirit"] = "Manaregeneration <- Manaregeneration, Willenskraft"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Manaregeneration zusammenrechnen (nicht Zaubernd)"
L["Mana Regen while not casting <- Spirit"] = "Manaregeneration (nicht Zaubernd) <- Manaregeneration (nicht Zaubernd) Willenskraft"
-- /rb sum stat hp5
L["Sum Health Regen"] = "Lebensregeneration zusammenrechnen"
L["Health Regen <- Health Regen"] = "Lebensregeneration <- Lebensregeneration"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Lebensregeneration außerhalb des Kampfes zusammenrechnen"
L["Health Regen when out of combat <- Spirit"] = "Lebensregeneration außerhalb des Kampfes Willenskraft"
-- /rb sum stat armor
L["Sum Armor"] = "Rüstung zusammenrechnen"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Rüstung <- Rüstung von Items, Rüstung von Boni, Beweglichkeit, Intelligenz"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Blockwert zusammenrechnen"
L["Block Value <- Block Value Strength"] = "Blockwert <- Blockwert, Stärke"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Ausweichchance zusammenrechnen"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Ausweichchance <- Ausweichwertung, Beweglichkeit, Verteidigungswertung"
-- /rb sum stat parry
L["Sum Parry Chance"] = "Parierchance zusammenrechnen"
L["Parry Chance <- Parry Rating Defense Rating"] = "Parierchance <- Parierwertung, Verteidigungswertung"
-- /rb sum stat block
L["Sum Block Chance"] = "Blockchance zusammenrechnen"
L["Block Chance <- Block Rating Defense Rating"] = " Blockchance <- Blockwertung, Verteidigungswertung"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Treffervermeidung zusammenrechnen"
L["Hit Avoidance <- Defense Rating"] = "Treffervermeidung <- Verteidigungswertung"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "kritische Treffervermeidung"
L["Crit Avoidance <- Defense Rating Resilience"] = "kritische Treffervermeidung <- Verteidigungswertung, Abhärtungswertung"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Ausweichmissachtung zusammenrechnen"
L["Dodge Neglect <- Expertise Weapon Skill Rating"] = "Ausweichmissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Pariermissachtung zusammenrechnen"
L["Parry Neglect <- Expertise Weapon Skill Rating"] = "Pariermissachtung <- Waffenkunde, Waffenfertigkeitswertung" -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Blockmissachtung"
L["Block Neglect <- Weapon Skill Rating"] = "Blockmissachtung <- Waffenfertigkeitswertung"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Arkanwiderstand zusammenrechnen"
L["Arcane Resistance Summary"] = "Arkanwiderstandsübersicht"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Feuerwiderstand zusammenrechnen"
L["Fire Resistance Summary"] = "Feuerwiderstandsübersicht"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Naturwiderstand zusammenrechnen"
L["Nature Resistance Summary"] = "Naturwiderstandsübersicht"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "Frostwiderstand zusammenrechnen"
L["Frost Resistance Summary"] = "Frostwiderstandsübersicht"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Schattenwiderstand zusammenrechnen"
L["Shadow Resistance Summary"] = "Schattenwiderstandsübersicht"
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = true
L["Weapon DPS Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = "Durchschlag zusammenrechnen"
L["Spell Penetration Summary"] = "Durchschlagsübersicht"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "Rüstungsmissachtung zusammenrechnen"
L["Ignore Armor Summary"] = "Rüstungsmissachtungsübersicht"
L["Sum Armor Penetration"] = "Rüstungsdurchlag zusammenrechnen"
L["Armor Penetration Summary"] = "Rüstungsdurchlagsübersicht"
L["Sum Armor Penetration Rating"] = "Rüstungsdurchlagwertung zusammenrechnen"
L["Armor Penetration Rating Summary"] = "Rüstungsdurchlagwertungsübersicht"
-- /rb sum statcomp str
L["Sum Strength"] = "Stärke zusammenrechnen"
L["Strength Summary"] = "Stärkeübersicht"
-- /rb sum statcomp agi
L["Sum Agility"] = "Beweglichkeit zusammenrechnen"
L["Agility Summary"] = "Beweglichkeitsübersicht"
-- /rb sum statcomp sta
L["Sum Stamina"] = "Ausdauer zusammenrechnen"
L["Stamina Summary"] = "Ausdauerübersicht"
-- /rb sum statcomp int
L["Sum Intellect"] = "Intelligenz zusammenrechnen"
L["Intellect Summary"] = "Intelligenzübersicht"
-- /rb sum statcomp spi
L["Sum Spirit"] = "Willenskraft zusammenrechnen"
L["Spirit Summary"] = "Willenkraftübersicht"
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "Trefferwertung zusammenrechnen"
L["Hit Rating Summary"] = "Trefferwertungsübersicht"
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "kritische Trefferwertung zusammenrechnen"
L["Crit Rating Summary"] = "kritische Trefferwertungsübersicht"
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "Tempowertung zusammenrechnen"
L["Haste Rating Summary"] = "Tempowertungsübersicht"
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "Zaubertrefferwertung zusammenrechnen"
L["Spell Hit Rating Summary"] = "Zaubertrefferwertungsübersicht"
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "kritische Zaubertrefferwertung zusammenrechnen"
L["Spell Crit Rating Summary"] = "kritische Zaubertrefferwertungsübersicht"
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "Zaubertempowertung zusammenrechnen"
L["Spell Haste Rating Summary"] = "Zaubertempowertungsübersicht"
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "Verteidigungswertung zusammenrechnen"
L["Dodge Rating Summary"] = "Verteidigungswertungsübersicht"
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "Parierwertung zusammenrechnen"
L["Parry Rating Summary"] = "Parierwertungsübersicht"
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "Blockwertung zusammenrechnen"
L["Block Rating Summary"] = "Blockwertungsübersicht"
-- /rb sum statcomp res
L["Sum Resilience"] = "Abhärtung zusammenrechnen"
L["Resilience Summary"] = "Abhärtungsübersicht"
-- /rb sum statcomp def
L["Sum Defense"] = "Verteidigung zusammenrechnen"
L["Defense <- Defense Rating"] = "Verteidigung <- Verteidigungswertung"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Waffenfertigkeit zusammenrechnen"
L["Weapon Skill <- Weapon Skill Rating"] = "Waffenfertigkeit <- Waffenfertigkeitswertung"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "Waffenkunde zusammenrechnen"
L["Expertise <- Expertise Rating"] = "Waffenkunde <- Waffenkundewertung"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "Vermeidung zusammenrechnen"
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
	{pattern = " um (%d+)%f[^%d%%]", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)%f[^%d%%]", addInfo = "AfterStat",},
	{pattern = "verleiht.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "(%d+) erhöhen.", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
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
	{pattern = SPELL_STAT1_NAME:lower(), id = StatLogic.Stats.Strength}, -- Strength
	{pattern = SPELL_STAT2_NAME:lower(), id = StatLogic.Stats.Agility}, -- Agility
	{pattern = SPELL_STAT3_NAME:lower(), id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = SPELL_STAT4_NAME:lower(), id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = SPELL_STAT5_NAME:lower(), id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "verteidigungswertung", id = StatLogic.Stats.DefenseRating},
	{pattern = "ausweichwertung", id = StatLogic.Stats.DodgeRating},
	{pattern = "blockwertung", id = StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "parierwertung", id = StatLogic.Stats.ParryRating},

	{pattern = "kritische zaubertrefferwertung", id = StatLogic.Stats.SpellCritRating},
	{pattern = "kritische distanztrefferwertung", id = StatLogic.Stats.RangedCritRating},
	{pattern = "kritische trefferwertung", id = StatLogic.Stats.CritRating},

	{pattern = "zaubertrefferwertung", id = StatLogic.Stats.SpellHitRating},
	{pattern = "trefferwertung", id = StatLogic.Stats.RangedHitRating},
	{pattern = "trefferwertung", id = StatLogic.Stats.HitRating},

	{pattern = "abhärtungswertung", id = StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{pattern = "zaubertempowertung", id = StatLogic.Stats.SpellHasteRating},
	{pattern = "distanztempowertung", id = StatLogic.Stats.RangedHasteRating},
	{pattern = "angriffstempowertung", id = StatLogic.Stats.HasteRating},
	{pattern = "nahkampftempowertung", id = StatLogic.Stats.MeleeHasteRating},
	{pattern = "tempowertung", id = StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{pattern = "waffenkundewertung", id = StatLogic.Stats.ExpertiseRating},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.Stats.AllStats},

	{pattern = "rüstungsdurchschlagwertung", id = StatLogic.Stats.ArmorPenetrationRating},
	{pattern = "rüstungsdurchschlag", id = StatLogic.Stats.ArmorPenetrationRating},
	{pattern = ARMOR:lower(), id = ARMOR},
	{pattern = "angriffskraft", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% krit."
L["$value% Spell Crit"] = "$value% Zauberkrit."
L["$value% Dodge"] = "$value% Ausweichen"
--	["$value HP"] = true,
--	["$value MP"] = true,
--	["$value AP"] = true,
--	["$value RAP"] = true,
L["$value Spell Dmg"] = "$value Schaden"
L["$value Heal"] = "$value Heilung"
L["$value Armor"] = "$value Rüstung"
L["$value Block"] = "$value Blocken"
--	["$value MP5"] = true,
--	["$value MP5(NC)"] = true,
--	["$value HP5"] = true,
--  L["$value HP5(NC)"] = true
L["$value to be Dodged/Parried"] = "$value wird Ausgewichen/Pariert"
L["$value to be Crit"] = "$value wird kritisch"
L["$value Crit Dmg Taken"] = "$value erlittener Schaden"
L["$value DOT Dmg Taken"] = "$value erlittener Schaden durch DOTs"
L["$value Dmg Taken"] = true
L["$value% Parry"] = "$value% Parieren"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value Zauber"

L[StatLogic.Stats.HealingPower] = STAT_SPELLHEALING
L[StatLogic.Stats.ManaRegen] = "Manaregeneration"
L[StatLogic.Stats.ManaRegenNotCasting] = "Manaregeneration (nicht Zaubernd)"
L[StatLogic.Stats.HealthRegen] = "Gesundheitsregeneration"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Lebensregeneration (Nicht im Kampf)"
L["StatModOptionName"] = "%s %s"

L[StatLogic.Stats.IgnoreArmor] = "Rüstung ignorieren"
L[StatLogic.Stats.WeaponDamageAverage] = "Waffenschaden" -- DAMAGE = "Damage"

L[StatLogic.Stats.Strength] = SPELL_STAT1_NAME
L[StatLogic.Stats.Agility] = SPELL_STAT2_NAME
L[StatLogic.Stats.Stamina] = SPELL_STAT3_NAME
L[StatLogic.Stats.Intellect] = SPELL_STAT4_NAME
L[StatLogic.Stats.Spirit] = SPELL_STAT5_NAME
L[StatLogic.Stats.Armor] = ARMOR

L[StatLogic.Stats.FireResistance] = RESISTANCE2_NAME
L[StatLogic.Stats.NatureResistance] = RESISTANCE3_NAME
L[StatLogic.Stats.FrostResistance] = RESISTANCE4_NAME
L[StatLogic.Stats.ShadowResistance] = RESISTANCE5_NAME
L[StatLogic.Stats.ArcaneResistance] = RESISTANCE6_NAME

L[StatLogic.Stats.BlockValue] = "Blockwert"

L[StatLogic.Stats.AttackPower] = ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.RangedAttackPower] = RANGED_ATTACK_POWER
L[StatLogic.Stats.FeralAttackPower] = "Feral "..ATTACK_POWER_TOOLTIP

L[StatLogic.Stats.HealingPower] = "Heilung"

L[StatLogic.Stats.SpellDamage] = STAT_SPELLDAMAGE
L[StatLogic.Stats.HolyDamage] = SPELL_SCHOOL1_CAP.." "..DAMAGE
L[StatLogic.Stats.FireDamage] = SPELL_SCHOOL2_CAP.." "..DAMAGE
L[StatLogic.Stats.NatureDamage] = SPELL_SCHOOL3_CAP.." "..DAMAGE
L[StatLogic.Stats.FrostDamage] = SPELL_SCHOOL4_CAP.." "..DAMAGE
L[StatLogic.Stats.ShadowDamage] = SPELL_SCHOOL5_CAP.." "..DAMAGE
L[StatLogic.Stats.ArcaneDamage] = SPELL_SCHOOL6_CAP.." "..DAMAGE

L[StatLogic.Stats.SpellPenetration] = PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION

L[StatLogic.Stats.Health] = HEALTH
L[StatLogic.Stats.Mana] = MANA

L[StatLogic.Stats.WeaponDamageAverage] = "Average Damage"
L[StatLogic.Stats.WeaponDPS] = "Schaden pro Sekunde"

L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2 -- COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.DodgeRating] = COMBAT_RATING_NAME3 -- COMBAT_RATING_NAME3 = "Dodge Rating"
L[StatLogic.Stats.ParryRating] = COMBAT_RATING_NAME4 -- COMBAT_RATING_NAME4 = "Parry Rating"
L[StatLogic.Stats.BlockRating] = COMBAT_RATING_NAME5 -- COMBAT_RATING_NAME5 = "Block Rating"
L[StatLogic.Stats.MeleeHitRating] = COMBAT_RATING_NAME6 -- COMBAT_RATING_NAME6 = "Hit Rating"
L[StatLogic.Stats.RangedHitRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
L[StatLogic.Stats.SpellHitRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_SPELL_COMBAT = "Spell"
L[StatLogic.Stats.MeleeCritRating] = COMBAT_RATING_NAME9 -- COMBAT_RATING_NAME9 = "Crit Rating"
L[StatLogic.Stats.RangedCritRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.SpellCritRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.ResilienceRating] = COMBAT_RATING_NAME15 -- COMBAT_RATING_NAME15 = "Resilience"
L[StatLogic.Stats.MeleeHasteRating] = "Hast "..RATING --
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." Hast  "..RATING
L[StatLogic.Stats.SpellHasteRating] = PLAYERSTAT_SPELL_COMBAT.." Hast  "..RATING
L[StatLogic.Stats.ExpertiseRating] = "Waffenkundewertung"
L[StatLogic.Stats.ArmorPenetrationRating] = "Rüstungsdurchschlag".." "..RATING
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
L[StatLogic.Stats.CritDamageReduction] = "Krit Schadenverminderung (%)"
L[StatLogic.Stats.Defense] = DEFENSE
L[StatLogic.Stats.Dodge] = DODGE.."(%)"
L[StatLogic.Stats.Parry] = PARRY.."(%)"
L[StatLogic.Stats.BlockChance] = BLOCK.."(%)"
L[StatLogic.Stats.Avoidance] = "Vermeidung(%)"
L[StatLogic.Stats.MeleeHit] = "Trefferchance(%)"
L[StatLogic.Stats.RangedHit] = PLAYERSTAT_RANGED_COMBAT.." Trefferchance(%)"
L[StatLogic.Stats.SpellHit] = PLAYERSTAT_SPELL_COMBAT.." Trefferchance(%)"
L[StatLogic.Stats.Miss] = "Treffer Vermeidung(%)"
L[StatLogic.Stats.MeleeCrit] = MELEE_CRIT_CHANCE.."(%)" -- MELEE_CRIT_CHANCE = "Crit Chance"
L[StatLogic.Stats.RangedCrit] = PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.SpellCrit] = PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.CritAvoidance] = "Kritvermeidung(%)"
L[StatLogic.Stats.MeleeHaste] = "Hast(%)" --
L[StatLogic.Stats.RangedHaste] = PLAYERSTAT_RANGED_COMBAT.." Hast(%)"
L[StatLogic.Stats.SpellHaste] = PLAYERSTAT_SPELL_COMBAT.." Hast(%)"
L[StatLogic.Stats.Expertise] = "Waffenkunde"
L[StatLogic.Stats.ArmorPenetration] = "Rüstungsdurchschlag(%)"
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
L[StatLogic.Stats.DodgeReduction] = DODGE.." Verhinderung(%)"
L[StatLogic.Stats.ParryReduction] = PARRY.." Verhinderung(%)"
-- Misc Stats
L[StatLogic.Stats.WeaponSkill] = "Waffe "..SKILL