--[[
Name: RatingBuster esES locale
Revision: $Revision: 73697 $
Translated by:
- carahuevo@Curse
- Zendor@Mandokir
]]

---@class RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esES")
if not L then return end
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "??????",
L["RatingBuster Options"] = "Opciones RatingBuster"
---------------------------
-- Slash Command Options --
---------------------------
-- /rb optionswin
L["Options Window"] = "Ventana opciones"
L["Shows the Options Window"] = "Muestra la ventana de opciones"
-- /rb statmod
L["Enable Stat Mods"] = "Habilitar Stat Mods"
L["Enable support for Stat Mods"] = "Habilita el soporte para Stat Mods"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Habilita evitacion de rendimientos decrecientes"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Rendimientos decrecientes"
-- /rb itemid
L["Show ItemID"] = "Mostrar ItemID"
L["Show the ItemID in tooltips"] = "Mostrar ItemID en los tooltips"
-- /rb itemlevel
L["Show ItemLevel"] = "Mostrar NivelItem"
L["Show the ItemLevel in tooltips"] = "Muestra el NivelItem en los tooltips"
-- /rb usereqlv
L["Use required level"] = "Usar nivel requerido"
L["Calculate using the required level if you are below the required level"] = "Calcular apartir del nivel requerido si estas por debajo"
-- /rb setlevel
L["Set level"] = "Establecer nivel"
L["Set the level used in calculations (0 = your level)"] = "Establece el nivel usado en los caculos (0=tu nivel)"
-- /rb color
L["Change text color"] = "Cambiar color texto"
L["Changes the color of added text"] = "Cambia el color del texto anadido"
L["Change number color"] = true
-- /rb rating
L["Rating"] = "Calificacion"
L["Options for Rating display"] = "Opciones de visualizacion"
-- /rb rating show
L["Show Rating conversions"] = "Mostrar conversion calificacion"
L["Show Rating conversions in tooltips"] = "Mostrar conversion calificacion en tooltips"
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = true
L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
L["Show Physical Hit/Haste"] = true
L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show detailed conversions text"] = "Mostrar texto detallado conversiones"
L["Show detailed text for Resilience and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia"
-- /rb rating def
L["Defense breakdown"] = "Desglose Defensa"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Desglose Habilidad arma"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Desglose Pericia"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convierte Pericia en fallo Esquivar y fallo Parar"

-- /rb stat
--["Stat Breakdown"] = "Estad",
L["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base"
-- /rb stat show
L["Show base stat conversions"] = "Mostrar conversiones estad. base"
L["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip"
-- /rb stat str
L["Strength"] = "Fuerza"
L["Changes the display of Strength"] = "Cambia la visualizacion de Fuerza"

-- /rb stat agi
L["Agility"] = "Agilidad"
L["Changes the display of Agility"] = "Cambia la visualizacion de Agilidad"
-- /rb stat agi crit
L["Show Crit"] = "Mostrar Crit"
L["Show Crit chance from Agility"] = "Muestra la prob. de crítico de Agilidad"
-- /rb stat agi dodge
L["Show Dodge"] = "Mostrar Esquivar"
L["Show Dodge chance from Agility"] = "Muestra la prob. de Esquivar de Agilidad"

-- /rb stat sta
L["Stamina"] = "Aguante"
L["Changes the display of Stamina"] = "Cambia la visualizacion de Aguante"

-- /rb stat int
L["Intellect"] = "Intelecto"
L["Changes the display of Intellect"] = "Cambia la visualizacion de Intelecto"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Mostrar Crit Hech"
L["Show Spell Crit chance from Intellect"] = "Muestra la prob. de Crit. de Hechizo de Intelecto"

-- /rb stat spi
L["Spirit"] = "Espíritu"
L["Changes the display of Spirit"] = "Cambia la visualizacion de Espíritu"

L["Armor"] = true
L["Changes the display of Armor"] = true
L["Attack Power"] = true
L["Changes the display of Attack Power"] = true

-- /rb sum
L["Stat Summary"] = "Resumen Estad"
L["Options for stat summary"] = "Opciones de Resumen Estad."
-- /rb sum show
L["Show stat summary"] = "Mostrar Resumen Estad"
L["Show stat summary in tooltips"] = "Muestra el Resumen de Estad. en los tooltips"
-- /rb sum ignore
L["Ignore settings"] = "Ignorar opciones"
L["Ignore stuff when calculating the stat summary"] = "Ignorar los datos cuando se calcule el resumen de estad."
-- /rb sum ignore unused
L["Ignore unused item types"] = "Ignorar tipos de item no usados"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Muestra el resumen de estad. solo para los items de mayor nivel de armadura que puedes usar con calidad poco comun en adelante"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Ignorar items equipados"
L["Hide stat summary for equipped items"] = "Ocultar resumen estad. para los items equipados"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Ignorar encantamientos"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorar encantamientos en items cuando  se calcule el resumen de estad."
-- /rb sum ignore gem
L["Ignore gems"] = "Ignorar gemas"
L["Ignore gems on items when calculating the stat summary"] = "Ignorar gemas en items cuando  se calcule el resumen de estad."
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
-- /rb sum diffstyle
L["Display style for diff value"] = "Mostrar estilo para el valor de diferencia"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Mostrar diferencia valores en el tooltip principal o solo en los de comparacion"
L["Hide Blizzard Item Comparisons"] = true
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = true
-- /rb sum space
L["Add empty line"] = "Anadir linea vacia"
L["Add a empty line before or after stat summary"] = "Anade una linea vacia antes o despues del resumen"
-- /rb sum space before
L["Add before summary"] = "Anadir antes del resumen"
L["Add a empty line before stat summary"] = "Anade una linea vacia antes del resumen"
-- /rb sum space after
L["Add after summary"] = "Anadir despues del resumen"
L["Add a empty line after stat summary"] = "Anade una linea vacia despues del resumen"
-- /rb sum icon
L["Show icon"] = "Mostrar icono"
L["Show the sigma icon before summary listing"] = "Muestra el icono de sumatorio antes del listado resumen"
-- /rb sum title
L["Show title text"] = "Mostrar texto titulo"
L["Show the title text before summary listing"] = "Muestra el titulo antes del listado resumen"
-- /rb sum showzerostat
L["Show zero value stats"] = "Mostrar estad. valor cero"
L["Show zero value stats in summary for consistancy"] = "Muestra las estad. de valor cero por consistencia"
-- /rb sum calcsum
L["Calculate stat sum"] = "Calcula suma de estad."
L["Calculate the total stats for the item"] = "Calcula el total de las estad. para el item"
-- /rb sum calcdiff
L["Calculate stat diff"] = "Calcular dif. estad."
L["Calculate the stat difference for the item and equipped items"] = "Calcula la diferencia para el item y los items equipados"
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "Ordenar estad. alfabeticamente"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "Ordena alfabeticamente el resumen, deshabilita para ordenar de acuerdo a la estad. (basica, fisica, hechizo, tanque)"
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "Incluir prob. de bloqueo en resumen de Eludir"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "Incluye prob. de bloqueo en resumen de Eludir, Deshabilita para solo esquivar, parar y fallar"
-- /rb sum basic
L["Stat - Basic"] = "Estad. - Basica"
L["Choose basic stats for summary"] = "Escoge las estad. basicas para el resumen"
-- /rb sum physical
L["Stat - Physical"] = "Estad. - Fisico"
L["Choose physical damage stats for summary"] = "Escoge las estad. de daño fisico para el resumen"
-- /rb sum spell
L["Stat - Spell"] = "Estad. - Fisico"
L["Choose spell damage and healing stats for summary"] = "Escoge las estad. de daño de hechizo y sanacion para el resumen"
-- /rb sum tank
L["Stat - Tank"] = "Estad. - Tanque"
L["Choose tank stats for summary"] = "Escoge las estad. de tanque para el resumen"
-- /rb sum stat hp
L["Sum Health"] = "Suma salud"
L["Health <- Health Stamina"] = "Salud <- Salud, Aguante"
-- /rb sum stat mp
L["Sum Mana"] = "Suma Mana"
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelecto"
-- /rb sum stat ap
L["Sum Attack Power"] = "Res. Poder Ataque"
L["Attack Power <- Attack Power Strength, Agility"] = "Poder Ataque <- Poder Ataque, Fuerza, Agilidad"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "Res. P.Ataque Distancia"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "P.Ataque Distancia <- P.Ataque Distancia, Intelecto, P.Ataque, Fuerza, Agilidad"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Res. Daño Hech."
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Daño Hech. <- Daño Hech., Intelecto, Espíritu, Aguante"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Res. Daño Hech. Sagrado"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Daño Hech. Sagrado <- Daño Hech. Sagrado, Daño Hech., Intelecto, Espíritu"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Res. Daño Hech. Arcano"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Res. Daño Hech. Fuego"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto, Aguante"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Res. Daño Hech. Naturaleza"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Daño Hech. Naturaleza <- Daño Hech. Naturaleza, Daño Hech., Intelecto"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Res. Daño Hech. Frio"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Daño Hech. Frio <- Daño Hech. Frio, Daño Hech., Intelecto"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Res. Daño Hech. Sombras"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Daño Hech. Sombras <- Daño Hech. Sombras, Daño Hech., Intelecto, Espíritu, Aguante"
-- /rb sum stat heal
L["Sum Healing"] = "Res. Sanacion"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Sanacion <- Sanacion, Intelecto, Espíritu, Agilidad, Fuerza"
-- /rb sum stat hit
L["Sum Hit Chance"] = "Res. prob. Golpe"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "prob. Golpe <- Índice Golpe, Índice pericia"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Res. prob. Golpe Hech."
L["Spell Hit Chance <- Spell Hit Rating"] = "prob. Golpe Hech. <- Índice Golpe Hech."
-- /rb sum stat crit
L["Sum Crit Chance"] = "prob. Critico"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "prob. Critico <- Índice Critico, Agilidad, índice de pericia"
-- /rb sum stat haste
L["Sum Haste"] = "Res. Velocidad"
L["Haste <- Haste Rating"] = "Velocidad <- Índice Velocidad"
L["Sum Ranged Hit Chance"] = "Res. Prob. Golpe a Distancia"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = true
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "Res. Indice Golpe a Distancia"
L["Ranged Hit Rating Summary"] = true
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "Res. Prob. Critico a Distancia"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = true
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = true
L["Ranged Crit Rating Summary"] = true
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = true
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = true
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = true
L["Ranged Haste Rating Summary"] = true

-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "Res. prob. Critico Hech."
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "prob. Critico Hech. <- Índice Critico Hech., Intelecto"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "Res. velocidad Hech."
L["Spell Haste <- Spell Haste Rating"] = "Velocidad Hech. <- Índice Velocidad Hech."
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Res. Regen. mana"
L["Mana Regen <- Mana Regen Spirit"] = "Regen. mana <- Regen. mana, Espíritu"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Res. Regen. mana mientras no se lanza"
L["Mana Regen while not casting <- Spirit"] = "Regen. mana mientras no se lanza <- Espíritu"
-- /rb sum stat hp5
L["Sum Health Regen"] = "Res. Regen. salud"
L["Health Regen <- Health Regen"] = "Regen. salud <- Regen. salud"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Res. Regen. salud fuera de combate"
L["Health Regen when out of combat <- Spirit"] = "Regen. salud fuera de combate <- Espíritu"
-- /rb sum stat armor
L["Sum Armor"] = "Res. Armadura"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Armadura <- Armadura de items, Armadura de bonus, Agilidad, Intelecto"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Res. Valor Bloqueo"
L["Block Value <- Block Value Strength"] = "Valor Bloqueo <- Valor Bloqueo, Fuerza"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Res. prob. Esquivar"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Prob. Esquivar <- Índice Esquivar, Agilidad, índice defensa"
-- /rb sum stat parry
L["Sum Parry Chance"] = "Res. prob. Parar"
L["Parry Chance <- Parry Rating Defense Rating"] = "Prob. Parar <- Índice Parar, índice defensa"
-- /rb sum stat block
L["Sum Block Chance"] = "Res. prob Bloqueo"
L["Block Chance <- Block Rating Defense Rating"] = "Prob. Bloqueo <- Índice Bloqueo, índice defensa"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Res. Elusion golpe"
L["Hit Avoidance <- Defense Rating"] = "Elusion golpe <- índice defensa"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "Res. Elusion Critico"
L["Crit Avoidance <- Defense Rating Resilience"] = "Elusion Critico <- índice defensa, Temple"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Res. fallo Esquivar"
L["Dodge Neglect <- Expertise Weapon Skill Rating"] = "Fallo Esquivar <- Pericia, Índice habilidad arma" -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Res. fallo Parar"
L["Parry Neglect <- Expertise Weapon Skill Rating"] = "Fallo Parar <- Pericia, Índice habilidad arma" -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Res. fallo Bloquear"
L["Block Neglect <- Weapon Skill Rating"] = "Fallo Bloquear <- Índice habilidad arma"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Res. Resist. Arcana"
L["Arcane Resistance Summary"] = "Resumen Resistencia Arcana"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Res. Resist. Fuego"
L["Fire Resistance Summary"] = "Resumen Resistencia Fuego"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Res. Resist. Naturaleza"
L["Nature Resistance Summary"] = "Resumen Resistencia Naturaleza"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "Res. Resist. Frio"
L["Frost Resistance Summary"] = "Resumen Resistencia Frio"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Res. Resist. Sombras"
L["Shadow Resistance Summary"] = "Resumen Resistencia Sombras"
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = true
L["Weapon DPS Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = "Res. Penetracion"
L["Spell Penetration Summary"] = "Resumen Penetracion Hechizos"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "Res. Ignorar armadura"
L["Ignore Armor Summary"] = "Resumen de Ignorar Armadura"
L["Sum Armor Penetration"] = "Res. Penetracion Armadura"
L["Armor Penetration Summary"] = "Resumen de Penetracion Armadura"
L["Sum Armor Penetration Rating"] = "Res. Indice Penetracion Armadura"
L["Armor Penetration Rating Summary"] = "Resumen Indice Penetracion de Armadura"
-- /rb sum statcomp str
L["Sum Strength"] = "Res. Fuerza"
L["Strength Summary"] = "Resumen Fuerza"
-- /rb sum statcomp agi
L["Sum Agility"] = "Res. Agilidad"
L["Agility Summary"] = "Resumen Agilidad"
-- /rb sum statcomp sta
L["Sum Stamina"] = "Res. Aguante"
L["Stamina Summary"] = "Resumen Aguante"
-- /rb sum statcomp int
L["Sum Intellect"] = "Res. Intelecto"
L["Intellect Summary"] = "Resumen Intelecto"
-- /rb sum statcomp spi
L["Sum Spirit"] = "Res. Espíritu"
L["Spirit Summary"] = "Resumen Espíritu"
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "Res. Índice Golpe"
L["Hit Rating Summary"] = "Resumen Índice Golpe"
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "Res. Índice Critico"
L["Crit Rating Summary"] = "Resumen Índice Critico"
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "Res. Índice Velocidad"
L["Haste Rating Summary"] = "Resumen Índice Velocidad"
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "Res. Golpe Hech."
L["Spell Hit Rating Summary"] = "Resumen Golpe Hech."
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "Res. Índice Critico Hech."
L["Spell Crit Rating Summary"] = "Resumen Índice Critico Hech."
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "Res. Índice Velocidad Hech."
L["Spell Haste Rating Summary"] = "Resumen Índice Velocidad Hech."
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "Res. Índice Esquivar"
L["Dodge Rating Summary"] = "Resumen Índice Esquivar"
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "Res. Índice Parar"
L["Parry Rating Summary"] = "Resumen Índice Parar"
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "Res. Índice Bloquear"
L["Block Rating Summary"] = "Resumen Índice Bloquear"
-- /rb sum statcomp res
L["Sum Resilience"] = "Res. Temple"
L["Resilience Summary"] = "Resumen Temple"
-- /rb sum statcomp def
L["Sum Defense"] = "Res. Defensa"
L["Defense <- Defense Rating"] = "Defensa <- índice defensa"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Res. Habilidad Arma"
L["Weapon Skill <- Weapon Skill Rating"] = "Habilidad Arma <- Índice Habilidad Arma"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "Res. Pericia"
L["Expertise <- Expertise Rating"] = "Pericia <- Índice Pericia"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "Res. Elusion"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Elusion <- Esquivar, Parar, FalloEnemigo, Bloqueo(Opcional)"

-- /rb sum gem
--["Gems"] = true,
--["Auto fill empty gem slots"] = true,
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
--["ItemID or Link of the gem you would like to auto fill"] = true,
--["<ItemID|Link>"] = true,
--["%s is now set to %s"] = true,
--["Queried server for Gem: %s. Try again in 5 secs."] = true,
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Nivel de objeto "
L["ItemID: "] = "ItemID: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = true
L["$class Self Buffs"] = true -- $class will be replaced with localized player class
L["Raid Buffs"] = true

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
	{pattern = " en (%d+) p", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "otorga.-(%d+) p", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "aumenta.-(%d+) p", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [????????] +6?????5??
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}
L["separators"] = {
	"/", " y ", ",", "%f[p%.]%. ", " durante ", "&", "\n"
}
--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = SPELL_STAT1_NAME:lower(), id = StatLogic.Stats.Strength}, -- Strength
	{pattern = SPELL_STAT2_NAME:lower(), id = StatLogic.Stats.Agility}, -- Agility
	{pattern = SPELL_STAT3_NAME:lower(), id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = SPELL_STAT4_NAME:lower(), id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = SPELL_STAT5_NAME:lower(), id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "índice de defensa", id = StatLogic.Stats.DefenseRating},
	{pattern = "índice de esquivar", id = StatLogic.Stats.DodgeRating},
	{pattern = "índice de bloqueo", id = StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "índice de parada", id = StatLogic.Stats.ParryRating},

	{pattern = "índice de golpe crítico con hechizos", id = StatLogic.Stats.SpellCritRating},
	{pattern = "índice de golpe crítico a distancia", id = StatLogic.Stats.RangedCritRating},
	{pattern = "índice de golpe crítico cuerpo a cuerpo", id = StatLogic.Stats.MeleeCritRating},
	{pattern = "índice de golpe crítico", id = StatLogic.Stats.CritRating},

	{pattern = "índice de golpe con hechizo", id = StatLogic.Stats.SpellHitRating},
	{pattern = "índice de golpe a distancia", id = StatLogic.Stats.RangedHitRating},
	{pattern = "índice de golpe cuerpo a cuerpo", id = StatLogic.Stats.MeleeHitRating},
	{pattern = "índice de golpe", id = StatLogic.Stats.HitRating},

	{pattern = "índice de temple", id = StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{pattern = "índice de celeridad con hechizos", id = StatLogic.Stats.SpellHasteRating},
	{pattern = "índice de celeridad a distancia", id = StatLogic.Stats.RangedHasteRating},
	{pattern = "índice de celeridad con cuerpo a cuerpo", id = StatLogic.Stats.MeleeHasteRating},
	{pattern = "índice de celeridad", id = StatLogic.Stats.HasteRating},
	{pattern = "Aumenta el índice de velocidad de lanzamiento de ataques y de ataque de los miembros del grupo cercanos", id = StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{pattern = "índice de pericia", id = StatLogic.Stats.ExpertiseRating},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.Stats.AllStats},

	{pattern = "índice de penetración de armadura", id = StatLogic.Stats.ArmorPenetrationRating},
	{pattern = ARMOR:lower(), id = ARMOR},
	{pattern = "poder de ataque", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% Crit"
L["$value% Spell Crit"] = "$value% Crit hechizos"
L["$value% Dodge"] = "$value% Esquivar"
L["$value HP"] = "$value Vida"
L["$value MP"] = "$value Mana"
L["$value AP"] = "$value P.At"
L["$value RAP"] = "$value P.At Dist"
L["$value Spell Dmg"] = "$value Daño"
L["$value Heal"] = "$value Sanacion"
L["$value Armor"] = "$value Armadura"
L["$value Block"] = "$value Bloqueo"
L["$value MP5"] = "$value Mana/5sec"
L["$value MP5(NC)"] = "$value Mana/5sec(SL)"
L["$value HP5"] = "$value Vida/5sec"
L["$value HP5(NC)"] = "$value Vida/5sec(NC)"
L["$value to be Dodged/Parried"] = "$value Esquivado/Parado"
L["$value to be Crit"] = "$value recibir Crit"
L["$value Crit Dmg Taken"] = "$value Daño crit recib"
L["$value DOT Dmg Taken"] = "$value Daño por tiempo recib"
L["$value Dmg Taken"] = "$value Daño recib"
L["$value% Parry"] = "$value Parada"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value Hech."

L["EMPTY_SOCKET_RED"] = EMPTY_SOCKET_RED -- EMPTY_SOCKET_RED = "Red Socket";
L["EMPTY_SOCKET_YELLOW"] = EMPTY_SOCKET_YELLOW -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
L["EMPTY_SOCKET_BLUE"] = EMPTY_SOCKET_BLUE -- EMPTY_SOCKET_BLUE = "Blue Socket";
L["EMPTY_SOCKET_META"] = EMPTY_SOCKET_META -- EMPTY_SOCKET_META = "Meta Socket";

L[StatLogic.Stats.HealingPower] = STAT_SPELLHEALING
L[StatLogic.Stats.ManaRegen] = "Regen.Mana"
L[StatLogic.Stats.ManaRegenNotCasting] = "Regen.Mana (No se lanza)"
L[StatLogic.Stats.HealthRegen] = "Regen.Salud"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Regen.Salud (Out of Combat)"
L["StatModOptionName"] = "%s %s"

L[StatLogic.Stats.IgnoreArmor] = "Ignore Armor"
L[StatLogic.Stats.WeaponDamageAverage] = "Melee Weapon "..DAMAGE -- DAMAGE = "Damage"

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

L[StatLogic.Stats.BlockValue] = "Block Value"

L[StatLogic.Stats.AttackPower] = ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.RangedAttackPower] = RANGED_ATTACK_POWER
L[StatLogic.Stats.FeralAttackPower] = "Feral "..ATTACK_POWER_TOOLTIP

L[StatLogic.Stats.HealingPower] = "Healing"

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
L[StatLogic.Stats.WeaponDPS] = "Damage Per Second"

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
L[StatLogic.Stats.MeleeHasteRating] = "Haste "..RATING --
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING
L[StatLogic.Stats.SpellHasteRating] = PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING
L[StatLogic.Stats.ExpertiseRating] = "Pericia".." "..RATING
L[StatLogic.Stats.ArmorPenetrationRating] = "Penetración de Armadura".." "..RATING
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
L[StatLogic.Stats.CritDamageReduction] = "Crit Damage Reduction(%)"
L[StatLogic.Stats.Defense] = DEFENSE
L[StatLogic.Stats.Dodge] = DODGE.."(%)"
L[StatLogic.Stats.Parry] = PARRY.."(%)"
L[StatLogic.Stats.BlockChance] = BLOCK.."(%)"
L[StatLogic.Stats.Avoidance] = "Avoidance(%)"
L[StatLogic.Stats.MeleeHit] = "Prob. de Golpe(%)"
L[StatLogic.Stats.RangedHit] = PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)"
L[StatLogic.Stats.SpellHit] = PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)"
L[StatLogic.Stats.Miss] = "Hit Avoidance(%)"
L[StatLogic.Stats.MeleeCrit] = MELEE_CRIT_CHANCE.."(%)" -- MELEE_CRIT_CHANCE = "Crit Chance"
L[StatLogic.Stats.RangedCrit] = PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.SpellCrit] = PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.CritAvoidance] = "Crit Avoidance(%)"
L[StatLogic.Stats.MeleeHaste] = "Haste(%)" --
L[StatLogic.Stats.RangedHaste] = PLAYERSTAT_RANGED_COMBAT.." Haste(%)"
L[StatLogic.Stats.SpellHaste] = PLAYERSTAT_SPELL_COMBAT.." Haste(%)"
L[StatLogic.Stats.Expertise] = "Pericia"
L[StatLogic.Stats.ArmorPenetration] = "Penetr. Armadura(%)"
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
-- Expertise -> Dodge Neglect, Parry Neglect
L[StatLogic.Stats.DodgeReduction] = DODGE.." Neglect(%)"
L[StatLogic.Stats.ParryReduction] = PARRY.." Neglect(%)"
-- Misc Stats
L[StatLogic.Stats.WeaponSkill] = "Weapon "..SKILL