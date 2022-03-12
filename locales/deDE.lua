--[[
Name: RatingBuster deDE locale
Revision: $Revision: 75639 $
Translated by:
- Kuja
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "deDE")
if not L then return end
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
-- /rb color pick
L["Pick color"] = "Wähle Farbe"
L["Pick a color"] = "Wähle eine Farbe"
-- /rb color enable
L["Enable color"] = "Farbe aktivieren"
L["Enable colored text"] = "Aktiviert gefärbten Text"
-- /rb rating
L["Rating"] = "Bewertung"
L["Options for Rating display"] = "Optionen für die Bewertungsanzeige"
-- /rb rating show
L["Show Rating conversions"] = "Zeige Bewertungsumrechnung"
L["Show Rating conversions in tooltips"] = "Zeige Bewertungsumrechnung im Tooltip"
-- /rb rating detail
L["Show detailed conversions text"] = "Zeige detaillierten Umrechnungtext"
L["Show detailed text for Resiliance and Expertise conversions"] = "Zeige detaillierten Text für Abhärtungs- und Waffenkundumrechnung"
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
-- /rb stat str ap
L["Show Attack Power"] = "Zeige Angriffskraft"
L["Show Attack Power from Strength"] = "Zeige Angriffskraft resultierend aus Stärke"
-- /rb stat str block
L["Show Block Value"] = "Zeige Blockwert"
L["Show Block Value from Strength"] = "Zeige Blockwert resultierend aus Stärke"
-- /rb stat str dmg
L["Show Spell Damage"] = "Zeige Zauberschaden"
L["Show Spell Damage from Strength"] = "Zeige Zauberschaden resultierend aus Stärke"
-- /rb stat str heal
L["Show Healing"] = "Zeige Heilung"
L["Show Healing from Strength"] = "Zeige Heilung resultierend aus Stärke"

-- /rb stat agi
L["Agility"] = "Beweglichkeit"
L["Changes the display of Agility"] = "Zeigt Beweglichkeit an"
-- /rb stat agi crit
L["Show Crit"] = "Zeige Krit."
L["Show Crit chance from Agility"] = "Zeige Chance auf kritische Treffer resultierend aus Beweglichkeit"
-- /rb stat agi dodge
L["Show Dodge"] = "Zeige Ausweichen"
L["Show Dodge chance from Agility"] = "Zeige Ausweichchance resultierend aus Beweglichkeit"
-- /rb stat agi ap
L["Show Attack Power"] = "Zeige Angriffskraft"
L["Show Attack Power from Agility"] = "Zeige Angriffskraft resultierend aus Beweglichkeit"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Zeige Distanzangriffskraft (RAP)"
L["Show Ranged Attack Power from Agility"] = "Zeige Distanzangriffskraft resultierend aus Beweglichkeit"
-- /rb stat agi armor
L["Show Armor"] = "Zeige Rüstung"
L["Show Armor from Agility"] = "Zeige Rüstung resultierend aus Beweglichkeit"
-- /rb stat agi heal
L["Show Healing"] = "Zeige Heilung"
L["Show Healing from Agility"] = "Zeige Heilung resultierend aus Beweglichkeit"

-- /rb stat sta
L["Stamina"] = "Ausdauer"
L["Changes the display of Stamina"] = "Zeige Ausdauer an"
-- /rb stat sta hp
L["Show Health"] = "Zeige Leben"
L["Show Health from Stamina"] = "Zeige Leben resultierend aus Ausdauer"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Zeige Zauberschaden"
L["Show Spell Damage from Stamina"] = "Zeige Zauberschaden resultierend aus Ausdauer"

-- /rb stat int
L["Intellect"] = "Intelligenz"
L["Changes the display of Intellect"] = "Zeige Intelligenz an"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Zeige Zauberkrit."
L["Show Spell Crit chance from Intellect"] = "Zeige Chance auf kritische Zaubertreffer resultierend aus Intelligent"
-- /rb stat int mp
L["Show Mana"] = "Zeige Mana"
L["Show Mana from Intellect"] = "Zeige Mana resultierend aus Intelligenz"
-- /rb stat int dmg
L["Show Spell Damage"] = "Zeige Zauberschaden"
L["Show Spell Damage from Intellect"] = "Zeige Zauberschaden resultierend aus Intelligenz"
-- /rb stat int heal
L["Show Healing"] = "Zeige Heilung"
L["Show Healing from Intellect"] = "Zeige Heilung resultierend aus Intelligenz"
-- /rb stat int mp5
L["Show Mana Regen"] = "Zeige Manaregeneration"
L["Show Mana Regen while casting from Intellect"] = "Zeige Manaregeneration beim Zaubern resultierend aus Intelligenz"
-- /rb stat int mp5nc
--["Show Mana Regen while NOT casting"] = true,
--["Show Mana Regen while NOT casting from Intellect"] = true,
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Zeige Distanzangriffskraft (RAP)"
L["Show Ranged Attack Power from Intellect"] = "Zeige Distanzangriffskraft resultierend aus Intelligenz"
-- /rb stat int armor
L["Show Armor"] = "Zeige Rüstung"
L["Show Armor from Intellect"] = "Zeige Rüstung resultierend aus Intelligenz"

-- /rb stat spi
L["Spirit"] = "Willenskraft"
L["Changes the display of Spirit"] = "Zeige Willenskraft an"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Zeige Manaregeneration"
L["Show Mana Regen while casting from Spirit"] = "Zeige Manaregeneration während des Zauberns resultierend aus Willenskraft"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Zeige Manaregeneration (nicht Zaubernd)"
L["Show Mana Regen while NOT casting from Spirit"] = "Zeige Manaregeneration (nicht Zaubernd) resultierend aus Willenskraft"
-- /rb stat spi hp5
L["Show Health Regen"] = "Zeige Lebensregeneration"
L["Show Health Regen from Spirit"] = "Zeige Lebensregeneration resultierend aus Willenskraft"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Zeige Zauberschaden"
L["Show Spell Damage from Spirit"] = "Zeige Zauberschaden resultierend aus Willenskraft"
-- /rb stat spi heal
L["Show Healing"] = "Zeige Heilung"
L["Show Healing from Spirit"] = "Zeige Heilung resultierend aus Willenskraft"

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
L["Ignore unused items types"] = "Ignoriere Ungenutzte Itemtypen"
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
-- /rb sum diffstyle
L["Display style for diff value"] = "Anzeigestil für veränderte Werte"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Zeige veränderte Werte im Hauptooltip oder nur in Vergleichstooltips"
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
-- /rb sum stat fap
L["Sum Feral Attack Power"] = "Feral Angriffskraft zusammenrechnen"
L["Feral Attack Power <- Feral Attack Power Attack Power, Strength, Agility"] = "Feral Angriffskraft <- Feral Angriffskraft, Angriffskraft, Stärke, Beweglichkeit"
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
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = "Waffenmaximalschaden zusammenrechnen"
L["Weapon Max Damage Summary"] = "Waffenmaximalschadensübersicht"
-- /rb sum stat pen
L["Sum Penetration"] = "Durchschlag zusammenrechnen"
L["Spell Penetration Summary"] = "Durchschlagsübersicht"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "Rüstungsmissachtung zusammenrechnen"
L["Ignore Armor Summary"] = "Rüstungsmissachtungsübersicht"
-- /rb sum stat weapondps
--["Sum Weapon DPS"] = true,
--["Weapon DPS Summary"] = true,
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
-- /rb sum statcomp tp
L["Sum TankPoints"] = "TankPoints zusammenrechnen"
L["TankPoints <- Health Total Reduction"] = "TankPoints <- Leben, Gesamtreduzierung"
-- /rb sum statcomp tr
L["Sum Total Reduction"] = "Gesamtreduzierung zusammenrechnen"
L["Total Reduction <- Armor Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Gesamtreduzierung <- Rüstung, Ausweichen, Parieren, Block, Blockwert, Verteidigung, Abhärtung, MobMiss, MobCrit, MobCrush, DamageTakenMods"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "Vermeidung zusammenrechnen"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Vermeidung <- Ausweichen, Parieren, MobMiss, Block(Optional)"

-- /rb sum gem
L["Gems"] = "Edelsteine"
L["Auto fill empty gem slots"] = "Leere Edelsteinplätze automatisch füllen"
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "ItemID oder Link des einzusetzenden Edelsteins"
--["<ItemID|Link>"] = true,
L["%s is now set to %s"] = "%s ist nun auf %s gesetzt"
L["Queried server for Gem: %s. Try again in 5 secs."] = "Frage den Server nach Edelstein: %s. Versuchs in 5 Sekunden nochmal"
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

-----------------------
-- Item Level and ID --
-----------------------
--	["ItemLevel: "] = true,
--	["ItemID: "] = true,
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
-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = " um (%d+)[^%%]?$", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "verleiht.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "(%d+) erhöhen.", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " und ", ",", "%. ", " für ", "&", ":"
}
--[[ Rating ID
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
--
SPELL_STAT1_NAME = "Stärke"
SPELL_STAT2_NAME = "Beweglichkeit"
SPELL_STAT3_NAME = "Ausdauer"
SPELL_STAT4_NAME = "Intelligenz"
SPELL_STAT5_NAME = "Willenskraft"
--]]
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "verteidigungswertung", id = CR_DEFENSE_SKILL},
	{pattern = "ausweichwertung", id = CR_DODGE},
	{pattern = "blockwertung", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "parierwertung", id = CR_PARRY},

	-- Falls jemand ein Item mit den unten auskommentierten Patterns hat, die nicht der Übersetzung entsprechen soll er mir bescheid sagen, ich habe nix gefunden...
	{pattern = "kritische zaubertrefferwertung", id = CR_CRIT_SPELL},
	--		{pattern = "spell critical hit rating", id = CR_CRIT_SPELL},
	--		{pattern = "spell critical rating", id = CR_CRIT_SPELL},
	--		{pattern = "spell crit rating", id = CR_CRIT_SPELL},
	{pattern = "kritische distanztrefferwertung", id = CR_CRIT_RANGED},
	--		{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
	--		{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
	--		{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
	{pattern = "kritische trefferwertung", id = CR_CRIT_MELEE},
	--		{pattern = "critical hit rating", id = CR_CRIT_MELEE},
	--		{pattern = "crit rating", id = CR_CRIT_MELEE},

	{pattern = "zaubertrefferwertung", id = CR_HIT_SPELL},
	{pattern = "trefferwertung", id = CR_HIT_RANGED},
	{pattern = "trefferwertung", id = CR_HIT_MELEE},

	{pattern = "abhärtungswertung", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "zaubertempowertung", id = CR_HASTE_SPELL},
	{pattern = "distanztempowertung", id = CR_HASTE_RANGED},
	{pattern = "angriffstempowertung", id = CR_HASTE_MELEE},
	{pattern = "nahkampftempowertung", id = CR_HASTE_MELEE},
	{pattern = "tempowertung", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	--		{pattern = "skill rating", id = CR_WEAPON_SKILL}, -- seit 2.3.0 entfernt denke ich..
	{pattern = "waffenkundewertung", id = CR_EXPERTISE},

	--		{pattern = "hit avoidance rating", id = CR_HIT_TAKEN_MELEE}, - seit 2.0.10 gibt es kein item mehr damit
	--[[
	{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
	{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
	{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
	{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
	{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
	{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
	{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
	{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
	{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
	{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
	{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
	--]]
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
L["$value to be Dodged/Parried"] = "$value wird Ausgewichen/Pariert"
L["$value to be Crit"] = "$value wird kritisch"
L["$value Crit Dmg Taken"] = "$value erlittener Schaden"
L["$value DOT Dmg Taken"] = "$value erlittener Schaden durch DOTs"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Werteübersicht"
