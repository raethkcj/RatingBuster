--[[
Name: RatingBuster deDE locale
Revision: $Revision: 75639 $
Translated by: 
- Kuja
]]

local L = AceLibrary("AceLocale-2.2"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("deDE", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = "RatingBuster Optionen",
	["Waterfall-1.0 is required to access the GUI."] = "Waterfall-1.0 wird zum Anzeigen der GUI benötigt",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb optionswin
	["Options Window"] = "Optionsfenster",
	["Shows the Options Window"] = "Zeigt das Optionsfenster",
	-- /rb statmod
	["Enable Stat Mods"] = "Aktiviere Stat Mods",
	["Enable support for Stat Mods"] = "Aktiviert die Unterstützung von Stat Mods",
	-- /rb itemid
	["Show ItemID"] = "Zeige ItemID",
	["Show the ItemID in tooltips"] = "Zeigt ItemID im Tooltip",
	-- /rb itemlevel
	["Show ItemLevel"] = "Zeige ItemLevel",
	["Show the ItemLevel in tooltips"] = "Zeigt ItemLevel im Tooltip",
	-- /rb usereqlv
	["Use required level"] = "Nutze benötigten Level",
	["Calculate using the required level if you are below the required level"] = "Berechne auf Basis des Benötigten Levels falls du unter diesem bist",
	-- /rb setlevel
	["Set level"] = "Setze Level",
	["Set the level used in calculations (0 = your level)"] = "Legt den Level der zur Berechnung Benutzt wird fest (0 = dein Level)",
	-- /rb color
	["Change text color"] = "Ändere Textfarbe",
	["Changes the color of added text"] = "Ändert die Textfarbe des hinzugefügten Textes",
	-- /rb color pick
	["Pick color"] = "Wähle Farbe",
	["Pick a color"] = "Wähle eine Farbe",
	-- /rb color enable
	["Enable color"] = "Farbe aktivieren",
	["Enable colored text"] = "Aktiviert gefärbten Text",
	-- /rb rating
	["Rating"] = "Bewertung",
	["Options for Rating display"] = "Optionen für die Bewertungsanzeige",
	-- /rb rating show
	["Show Rating conversions"] = "Zeige Bewertungsumrechnung",
	["Show Rating conversions in tooltips"] = "Zeige Bewertungsumrechnung im Tooltip",
	-- /rb rating detail
	["Show detailed conversions text"] = "Zeige detaillierten Umrechnungtext",
	["Show detailed text for Resiliance and Expertise conversions"] = "Zeige detaillierten Text für Abhärtungs- und Waffenkundumrechnung",
	-- /rb rating def
	["Defense breakdown"] = "Verteidigungsanalyse",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Wandle Verteidigung in Vermeidung von (kritischen) Treffern, Ausweichen, Parieren und Blocken um",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "Waffenfertigkeitswertungsanalyse",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Wandle Waffenfertigkeitswertung in (kritische) Treffer, Ausweich-, Parier-, und Blockmissachtung um",
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = "Waffenkundeanalyse",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Wandle Waffenkunde in Ausweich- und Pariermissachtung um",
	
	-- /rb stat
	--["Stat Breakdown"] = "Werte",
	["Changes the display of base stats"] = "Zeigt die Basiswerte an",
	-- /rb stat show
	["Show base stat conversions"] = "Zeige Basiswertumwandlung",
	["Show base stat conversions in tooltips"] = "Zeige Basiswertumwandlung im Tooltip",
	-- /rb stat str
	["Strength"] = "Stärke",
	["Changes the display of Strength"] = "Zeigt Stärke an",
	-- /rb stat str ap
	["Show Attack Power"] = "Zeige Angriffskraft",
	["Show Attack Power from Strength"] = "Zeige Angriffskraft, resultierend aus Stärke",
	-- /rb stat str block
	["Show Block Value"] = "Zeige Blockwert",
	["Show Block Value from Strength"] = "Zeige Blockwert, resultierend aus Stärke",
	-- /rb stat str dmg
	["Show Spell Damage"] = "Zeige Zauberschaden",
	["Show Spell Damage from Strength"] = "Zeige Zauberschaden, resultierend aus Stärke",
	-- /rb stat str heal
	["Show Healing"] = "Zeige Heilung",
	["Show Healing from Strength"] = "Zeige Heilung, resultierend aus Stärke",
	
	-- /rb stat agi
	["Agility"] = "Beweglichkeit",
	["Changes the display of Agility"] = "Zeigt Beweglichkeit an",
	-- /rb stat agi crit
	["Show Crit"] = "Zeige Krit.",
	["Show Crit chance from Agility"] = "Zeige Chance auf kritische Treffer, resultierend aus Beweglichkeit",
	-- /rb stat agi dodge
	["Show Dodge"] = "Zeige Ausweichen",
	["Show Dodge chance from Agility"] = "Zeige Ausweichchance, resultierend aus Beweglichkeit",
	-- /rb stat agi ap
	["Show Attack Power"] = "Zeige Angriffskraft",
	["Show Attack Power from Agility"] = "Zeige Angriffskraft, resultierend aus Beweglichkeit",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "Zeige Distanzangriffskraft (RAP)",
	["Show Ranged Attack Power from Agility"] = "Zeige Distanzangriffskraft, resultierend aus Beweglichkeit",
	-- /rb stat agi armor
	["Show Armor"] = "Zeige Rüstung",
	["Show Armor from Agility"] = "Zeige Rüstung, resultierend aus Beweglichkeit",
	-- /rb stat agi heal
	["Show Healing"] = "Zeige Heilung",
	["Show Healing from Agility"] = "Zeige Heilung, resultierend aus Beweglichkeit",
	
	-- /rb stat sta
	["Stamina"] = "Ausdauer",
	["Changes the display of Stamina"] = "Zeige Ausdauer an",
	-- /rb stat sta hp
	["Show Health"] = "Zeige Leben",
	["Show Health from Stamina"] = "Zeige Leben, resultierend aus Ausdauer",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "Zeige Zauberschaden",
	["Show Spell Damage from Stamina"] = "Zeige Zauberschaden, resultierend aus Ausdauer",
	
	-- /rb stat int
	["Intellect"] = "Intelligenz",
	["Changes the display of Intellect"] = "Zeige Intelligenz an",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "Zeige Zauberkrit.",
	["Show Spell Crit chance from Intellect"] = "Zeige Chance auf kritische Zaubertreffer, resultierend aus Intelligent",
	-- /rb stat int mp
	["Show Mana"] = "Zeige Mana",
	["Show Mana from Intellect"] = "Zeige Mana, resultierend aus Intelligenz",
	-- /rb stat int dmg
	["Show Spell Damage"] = "Zeige Zauberschaden",
	["Show Spell Damage from Intellect"] = "Zeige Zauberschaden, resultierend aus Intelligenz",
	-- /rb stat int heal
	["Show Healing"] = "Zeige Heilung",
	["Show Healing from Intellect"] = "Zeige Heilung, resultierend aus Intelligenz",
	-- /rb stat int mp5
	["Show Mana Regen"] = "Zeige Manaregeneration",
	["Show Mana Regen while casting from Intellect"] = "Zeige Manaregeneration beim Zaubern, resultierend aus Intelligenz",
	-- /rb stat int mp5nc
	--["Show Mana Regen while NOT casting"] = true,
	--["Show Mana Regen while NOT casting from Intellect"] = true,
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "Zeige Distanzangriffskraft (RAP)",
	["Show Ranged Attack Power from Intellect"] = "Zeige Distanzangriffskraft, resultierend aus Intelligenz",
	-- /rb stat int armor
	["Show Armor"] = "Zeige Rüstung",
	["Show Armor from Intellect"] = "Zeige Rüstung, resultierend aus Intelligenz",
	
	-- /rb stat spi
	["Spirit"] = "Willenskraft",
	["Changes the display of Spirit"] = "Zeige Willenskraft an",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "Zeige Manaregeneration",
	["Show Mana Regen while casting from Spirit"] = "Zeige Manaregeneration während des Zauberns, resultierend aus Willenskraft",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "Zeige Manaregeneration (nicht Zaubernd)",
	["Show Mana Regen while NOT casting from Spirit"] = "Zeige Manaregeneration (nicht Zaubernd), resultierend aus Willenskraft",
	-- /rb stat spi hp5
	["Show Health Regen"] = "Zeige Lebensregeneration",
	["Show Health Regen from Spirit"] = "Zeige Lebensregeneration, resultierend aus Willenskraft",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "Zeige Zauberschaden",
	["Show Spell Damage from Spirit"] = "Zeige Zauberschaden, resultierend aus Willenskraft",
	-- /rb stat spi heal
	["Show Healing"] = "Zeige Heilung",
	["Show Healing from Spirit"] = "Zeige Heilung, resultierend aus Willenskraft",
	
	-- /rb sum
	["Stat Summary"] = "Werteübersicht",
	["Options for stat summary"] = "Optionen für die Werteübersicht",
	-- /rb sum show
	["Show stat summary"] = "Zeige Werteübersicht",
	["Show stat summary in tooltips"] = "Zeige Werteübersicht im Tooltip",
	-- /rb sum ignore
	["Ignore settings"] = "Ignorierungseinstellungen",
	["Ignore stuff when calculating the stat summary"] = "Ignoriere Werte bei der Berechnung der Werteübersicht",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "Ignoriere Ungenutzte Itemtypen",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Zeige Werteübersicht nur für den Höchstleveligen Itemtyp und benutzbare Items mit der Qualität \"Selten\" oder höher",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "Ignoriere Angelegte Items",
	["Hide stat summary for equipped items"] = "Verstecke Werteübersicht für Angelegte Items",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "Ignoriere Verzauberungen",
	["Ignore enchants on items when calculating the stat summary"] = "Ignoriere Itemverzauberungen für die Berechnung der Werteübersicht",
	-- /rb sum ignore gem
	["Ignore gems"] = "Ignoriere Edelsteine",
	["Ignore gems on items when calculating the stat summary"] = "Ignoriere Edelsteine auf gesockelten Items für die Berechnung der Werteübersicht",
	-- /rb sum diffstyle
	["Display style for diff value"] = "Anzeigestil für veränderte Werte",
	["Display diff values in the main tooltip or only in compare tooltips"] = "Zeige veränderte Werte im Hauptooltip oder nur in Vergleichstooltips",
	-- /rb sum space
	["Add empty line"] = "Füge leere Zeile hinzu",
	["Add a empty line before or after stat summary"] = "Füge eine leere Zeile vor oder nach der Werteübersicht hinzu",
	-- /rb sum space before
	["Add before summary"] = "Vor Berechnung hinzufügen",
	["Add a empty line before stat summary"] = "Füge eine leere Zeile vor der Werteübersicht hinzu",
	-- /rb sum space after
	["Add after summary"] = "Nach Berechnung hinzufügen",
	["Add a empty line after stat summary"] = "Füge eine leere Zeile nach der Werteübersicht hinzu",
	-- /rb sum icon
	["Show icon"] = "Zeige Symbol",
	["Show the sigma icon before summary listing"] = "Zeige das Sigma Symbol vor der Übersichtsliste an",
	-- /rb sum title
	["Show title text"] = "Zeige Titeltext",
	["Show the title text before summary listing"] = "Zeige Titeltext vor der Übersichtsliste an",
	-- /rb sum showzerostat
	["Show zero value stats"] = "Zeige Nullwerte",
	["Show zero value stats in summary for consistancy"] = "Zeige zur Konsistenz die Nullwerte in der Übersicht an",
	-- /rb sum calcsum
	["Calculate stat sum"] = "Berechne Wertesummen",
	["Calculate the total stats for the item"] = "Berechne die Gesamtwerte der Items",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "Berechne Wertedifferenz",
	["Calculate the stat difference for the item and equipped items"] = "Berechne Wertedifferenz für das Item und angelegte Items",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "Sortiere Werteübersicht Alphabetisch",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Sortiere Werteübersicht alphabetisch, deaktivieren um nach Wertetyp zu sortieren (Basis, Physisch, Zauber, Tank)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "Zeige Blockchance in Vermeidungsübersicht",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Zeige Blockchance in Vermeidungsübersicht, deaktivieren um nur Ausweichen, Parieren und Verfehlen zu zeigen",
	-- /rb sum basic
	["Stat - Basic"] = "Werte - Basis",
	["Choose basic stats for summary"] = "Wähle Basiswerte für die Übersicht",
	-- /rb sum physical
	["Stat - Physical"] = "Werte - Physisch",
	["Choose physical damage stats for summary"] = "Wähle Physische Schadenswerte für die Übersicht",
	-- /rb sum spell
	["Stat - Spell"] = "Werte - Zauber",
	["Choose spell damage and healing stats for summary"] = "Wähle Zauberschaden und Heilungswerte für die Übersicht",
	-- /rb sum tank
	["Stat - Tank"] = "Werte - Tank",
	["Choose tank stats for summary"] = "Zeige Tankwerte für die Übersicht",
	-- /rb sum stat hp
	["Sum Health"] = "Leben zusammenrechnen",
	["Health <- Health, Stamina"] = "Leben <- Leben, Ausdauer",
	-- /rb sum stat mp
	["Sum Mana"] = "Mana zusammenrechnen",
	["Mana <- Mana, Intellect"] = "Mana <- Mana, Intelligenz",
	-- /rb sum stat ap
	["Sum Attack Power"] = "Angriffskraft zusammenrechnen",
	["Attack Power <- Attack Power, Strength, Agility"] = "Angriffskraft <- Angriffskraft, Stärke, Beweglichkeit",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "Distanzangriffskraft (RAP) zusammenrechnen",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Distanzangriffskraft <- Distanzangriffskraft, Intelligenz, Angriffskraft, Stärke, Beweglichkeit",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "Feral Angriffskraft zusammenrechnen",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "Feral Angriffskraft <- Feral Angriffskraft, Angriffskraft, Stärke, Beweglichkeit",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "Zauberschaden zusammenrechnen",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Zauberschaden <- Zauberschaden, Intelligenz, Willenskraft, Ausdauer",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "Heiligzauberschaden zusammenrechnen",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Heiligzauberschaden <- Heiligzauberschaden, Zauberschaden, Intelligenz, Willenskraft",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "Arkanzauberschaden zusammenrechnen",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Arkanzauberschaden <- Arkanzauberschaden, Zauberschaden, Intelligenz",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "Feuerzauberschaden zusammenrechnen",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Feuerzauberschaden <- Feuerzauberschaden, Zauberschaden, Intelligenz, Ausdauer",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "Naturzauberschaden zusammenrechnen",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Naturzauberschaden <- Naturzauberschaden, Zauberschaden, Intelligenz",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "Frostzauberschaden zusammenrechnen",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Frostzauberschaden <- Frostzauberschaden, Zauberschaden, Intelligenz",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "Schattenzauberschaden zusammenrechnen",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Schattenzauberschaden <- Schattenzauberschaden, Zauberschaden, Intelligenz, Willenskraft, Ausdauer",
	-- /rb sum stat heal
	["Sum Healing"] = "Heilung zusammenrechnen",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Heilung <- Heilung, Intelligenz, Willenskraft, Beweglichkeit, Sträke",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "Trefferchance zusammenrechnen",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Trefferchance <- Trefferwertung, Waffenfertigkeitswertung",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "kritische Trefferchance zusammenrechnen",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "kritische Trefferchance <- kritische Trefferwertung, Beweglichkeit, Waffenfertigkeitswertung",
	-- /rb sum stat haste
	["Sum Haste"] = "Tempo zusammenrechnen",
	["Haste <- Haste Rating"] = "Tempo <- Tempowertung",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "kritische Zaubertrefferchance zusammenrechnen",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "kritische Zaubertrefferchance <- kritische Zaubertrefferwertung, Intelligenz",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "Zaubertrefferchance zusammenrechnen",
	["Spell Hit Chance <- Spell Hit Rating"] = "Zaubertrefferchance <- Zaubertrefferwertung",
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = "Zaubertempo zusammenrechnen",
	["Spell Haste <- Spell Haste Rating"] = "Zaubertempo <- Zaubertempowertung",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "Manaregeneration zusammenrechnen",
	["Mana Regen <- Mana Regen, Spirit"] = "Manaregeneration <- Manaregeneration, Willenskraft",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "Manaregeneration zusammenrechnen (nicht Zaubernd)",
	["Mana Regen while not casting <- Spirit"] = "Manaregeneration (nicht Zaubernd) <- Manaregeneration (nicht Zaubernd), Willenskraft",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "Lebensregeneration zusammenrechnen",
	["Health Regen <- Health Regen"] = "Lebensregeneration <- Lebensregeneration",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "Lebensregeneration außerhalb des Kampfes zusammenrechnen",
	["Health Regen when out of combat <- Spirit"] = "Lebensregeneration außerhalb des Kampfes, Willenskraft",
	-- /rb sum stat armor
	["Sum Armor"] = "Rüstung zusammenrechnen",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Rüstung <- Rüstung von Items, Rüstung von Boni, Beweglichkeit, Intelligenz",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "Blockwert zusammenrechnen",
	["Block Value <- Block Value, Strength"] = "Blockwert <- Blockwert, Stärke",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "Ausweichchance zusammenrechnen",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Ausweichchance <- Ausweichwertung, Beweglichkeit, Verteidigungswertung",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "Parierchance zusammenrechnen",
	["Parry Chance <- Parry Rating, Defense Rating"] = "Parierchance <- Parierwertung, Verteidigungswertung",
	-- /rb sum stat block
	["Sum Block Chance"] = "Blockchance zusammenrechnen",
	["Block Chance <- Block Rating, Defense Rating"] = " Blockchance <- Blockwertung, Verteidigungswertung",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "Treffervermeidung zusammenrechnen",
	["Hit Avoidance <- Defense Rating"] = "Treffervermeidung <- Verteidigungswertung",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "kritische Treffervermeidung",
	["Crit Avoidance <- Defense Rating, Resilience"] = "kritische Treffervermeidung <- Verteidigungswertung, Abhärtungswertung",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "Ausweichmissachtung zusammenrechnen",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Ausweichmissachtung <- Waffenkunde, Waffenfertigkeitswertung", -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "Pariermissachtung zusammenrechnen",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Pariermissachtung <- Waffenkunde, Waffenfertigkeitswertung", -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "Blockmissachtung",
	["Block Neglect <- Weapon Skill Rating"] = "Blockmissachtung <- Waffenfertigkeitswertung",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "Arkanwiderstand zusammenrechnen",
	["Arcane Resistance Summary"] = "Arkanwiderstandsübersicht",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "Feuerwiderstand zusammenrechnen",
	["Fire Resistance Summary"] = "Feuerwiderstandsübersicht",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "Naturwiderstand zusammenrechnen",
	["Nature Resistance Summary"] = "Naturwiderstandsübersicht",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "Frostwiderstand zusammenrechnen",
	["Frost Resistance Summary"] = "Frostwiderstandsübersicht",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "Schattenwiderstand zusammenrechnen",
	["Shadow Resistance Summary"] = "Schattenwiderstandsübersicht",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "Waffenmaximalschaden zusammenrechnen",
	["Weapon Max Damage Summary"] = "Waffenmaximalschadensübersicht",
	-- /rb sum stat pen
	["Sum Penetration"] = "Durchschlag zusammenrechnen",
	["Spell Penetration Summary"] = "Durchschlagsübersicht",
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = "Rüstungsmissachtung zusammenrechnen",
	["Ignore Armor Summary"] = "Rüstungsmissachtungsübersicht",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp str
	["Sum Strength"] = "Stärke zusammenrechnen",
	["Strength Summary"] = "Stärkeübersicht",
	-- /rb sum statcomp agi
	["Sum Agility"] = "Beweglichkeit zusammenrechnen",
	["Agility Summary"] = "Beweglichkeitsübersicht",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "Ausdauer zusammenrechnen",
	["Stamina Summary"] = "Ausdauerübersicht",
	-- /rb sum statcomp int
	["Sum Intellect"] = "Intelligenz zusammenrechnen",
	["Intellect Summary"] = "Intelligenzübersicht",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "Willenskraft zusammenrechnen",
	["Spirit Summary"] = "Willenkraftübersicht",
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = "Trefferwertung zusammenrechnen",
	["Hit Rating Summary"] = "Trefferwertungsübersicht",
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = "kritische Trefferwertung zusammenrechnen",
	["Crit Rating Summary"] = "kritische Trefferwertungsübersicht",
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = "Tempowertung zusammenrechnen",
	["Haste Rating Summary"] = "Tempowertungsübersicht",
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = "Zaubertrefferwertung zusammenrechnen",
	["Spell Hit Rating Summary"] = "Zaubertrefferwertungsübersicht",
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = "kritische Zaubertrefferwertung zusammenrechnen",
	["Spell Crit Rating Summary"] = "kritische Zaubertrefferwertungsübersicht",
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = "Zaubertempowertung zusammenrechnen",
	["Spell Haste Rating Summary"] = "Zaubertempowertungsübersicht",
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = "Verteidigungswertung zusammenrechnen",
	["Dodge Rating Summary"] = "Verteidigungswertungsübersicht",
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = "Parierwertung zusammenrechnen",
	["Parry Rating Summary"] = "Parierwertungsübersicht",
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = "Blockwertung zusammenrechnen",
	["Block Rating Summary"] = "Blockwertungsübersicht",
	-- /rb sum statcomp res
	["Sum Resilience"] = "Abhärtung zusammenrechnen",
	["Resilience Summary"] = "Abhärtungsübersicht",
	-- /rb sum statcomp def
	["Sum Defense"] = "Verteidigung zusammenrechnen",
	["Defense <- Defense Rating"] = "Verteidigung <- Verteidigungswertung",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "Waffenfertigkeit zusammenrechnen",
	["Weapon Skill <- Weapon Skill Rating"] = "Waffenfertigkeit <- Waffenfertigkeitswertung",
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = "Waffenkunde zusammenrechnen",
	["Expertise <- Expertise Rating"] = "Waffenkunde <- Waffenkundewertung",
	-- /rb sum statcomp tp
	["Sum TankPoints"] = "TankPoints zusammenrechnen",
	["TankPoints <- Health, Total Reduction"] = "TankPoints <- Leben, Gesamtreduzierung",
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = "Gesamtreduzierung zusammenrechnen",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Gesamtreduzierung <- Rüstung, Ausweichen, Parieren, Block, Blockwert, Verteidigung, Abhärtung, MobMiss, MobCrit, MobCrush, DamageTakenMods",
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = "Vermeidung zusammenrechnen",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Vermeidung <- Ausweichen, Parieren, MobMiss, Block(Optional)",
	
	-- /rb sum gem
	["Gems"] = "Edelsteine",
	["Auto fill empty gem slots"] = "Leere Edelsteinplätze automatisch füllen",
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = "ItemID oder Link des einzusetzenden Edelsteins",
	--["<ItemID|Link>"] = true,
	["%s is now set to %s"] = "%s ist nun auf %s gesetzt",
	["Queried server for Gem: %s. Try again in 5 secs."] = "Frage den Server nach Edelstein: %s. Versuchs in 5 Sekunden nochmal",
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,
	
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
	["numberPatterns"] = {
		{pattern = " um (%d+)", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
		{pattern = "verleiht.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		{pattern = "(%d+) erhöhen.", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	},
	["separators"] = {
		"/", " und ", ",", "%. ", " für ", "&", ":"
	},
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
	["statList"] = {
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
	},
	-------------------------
	-- Added info patterns --
	-------------------------
	-- $value will be replaced with the number
	-- EX: "$value% Crit" -> "+1.34% Crit"
	-- EX: "Crit $value%" -> "Crit +1.34%"
	["$value% Crit"] = "$value% krit.",
	["$value% Spell Crit"] = "$value% Zauberkrit.",
	["$value% Dodge"] = "$value% Ausweichen",
--	["$value HP"] = true,
--	["$value MP"] = true,
--	["$value AP"] = true,
--	["$value RAP"] = true,
	["$value Dmg"] = "$value Schaden",
	["$value Heal"] = "$value Heilung",
	["$value Armor"] = "$value Rüstung",
	["$value Block"] = "$value Blocken",
--	["$value MP5"] = true,
--	["$value MP5(NC)"] = true,
--	["$value HP5"] = true,
	["$value to be Dodged/Parried"] = "$value wird Ausgewichen/Pariert",
	["$value to be Crit"] = "$value wird kritisch",
	["$value Crit Dmg Taken"] = "$value erlittener Schaden",
	["$value DOT Dmg Taken"] = "$value erlittener Schaden durch DOTs",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "Werteübersicht",
} end)
