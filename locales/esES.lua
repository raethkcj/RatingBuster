--[[
Name: RatingBuster esES locale
Revision: $Revision: 73697 $
Translated by:
- carahuevo@Curse
- Zendor@Mandokir
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esES")
if not L then return end
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
L["Show detailed text for Resiliance and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia"
-- /rb rating def
L["Defense breakdown"] = "Desglose Defensa"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Desglose Habilidad arma"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Desglose Pericia"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convierte Pericia en fallo Esquivar y fallo Parar"
L["from"] = "de"
L["HEALING"] = STAT_SPELLHEALING
L["AP"] = ATTACK_POWER_TOOLTIP
L["RANGED_AP"] = RANGED_ATTACK_POWER
L["ARMOR"] = ARMOR
L["SPELL_DMG"] = STAT_SPELLDAMAGE
L["SPELL_CRIT"] = PLAYERSTAT_SPELL_COMBAT .. " " .. SPELL_CRIT_CHANCE
L["STR"] = SPELL_STAT1_NAME
L["AGI"] = SPELL_STAT2_NAME
L["STA"] = SPELL_STAT3_NAME
L["INT"] = SPELL_STAT4_NAME
L["SPI"] = SPELL_STAT5_NAME
L["PARRY"] = PARRY
L["MANA_REG"] = "Regen.Mana"
L["NORMAL_MANA_REG"] = SPELL_STAT4_NAME .. " & " .. SPELL_STAT5_NAME -- Intellect & Spirit
L["PET_STA"] = PET .. SPELL_STAT3_NAME -- Pet Stamina
L["PET_INT"] = PET .. SPELL_STAT4_NAME -- Pet Intellect
L.statModOptionName = function(show, add)
	return string.format("%s %s ", show, add)
end
L.statModOptionDesc = function(show, add, from, mod)
	return string.format("%s %s %s %s ", show, add, from, mod)
end

-- /rb stat
--["Stat Breakdown"] = "Estad",
L["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base"
-- /rb stat show
L["Show base stat conversions"] = "Mostrar conversiones estad. base"
L["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip"
-- /rb stat str
L["Strength"] = "Fuerza"
L["Changes the display of Strength"] = "Cambia la visualizacion de Fuerza"
-- /rb stat str ap
L["Show Attack Power"] = "Motrar Poder Ataque"
L["Show Attack Power from Strength"] = "Motrar Poder Ataque de Fuerza"
-- /rb stat str block
L["Show Block Value"] = "Mostrar Valor Bloqueo"
L["Show Block Value from Strength"] = "Muestra el Valor Bloqueo de Fuerza"
-- /rb stat str dmg
L["Show Spell Damage"] = "Mostrar Daño Hech"
L["Show Spell Damage from Strength"] = "Muestra el Daño de Hechizo de Fuerza"
-- /rb stat str heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Strength"] = "Muestra la Sanacion de Fuerza"

-- /rb stat agi
L["Agility"] = "Agilidad"
L["Changes the display of Agility"] = "Cambia la visualizacion de Agilidad"
-- /rb stat agi crit
L["Show Crit"] = "Mostrar Crit"
L["Show Crit chance from Agility"] = "Muestra la prob. de crítico de Agilidad"
-- /rb stat agi dodge
L["Show Dodge"] = "Mostrar Esquivar"
L["Show Dodge chance from Agility"] = "Muestra la prob. de Esquivar de Agilidad"
-- /rb stat agi ap
L["Show Attack Power"] = "Mostrar Poder Ataque"
L["Show Attack Power from Agility"] = "Muestra Poder de Ataque de Agilidad"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist"
L["Show Ranged Attack Power from Agility"] = "Muestra Poder de Ataque a distancia de Agilidad"
-- /rb stat agi armor
L["Show Armor"] = "Mostrar Armadura"
L["Show Armor from Agility"] = "Muestra la Armadura de Agilidad"
-- /rb stat agi heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Agility"] = "Muestra Sanacion de Agilidad"

-- /rb stat sta
L["Stamina"] = "Aguante"
L["Changes the display of Stamina"] = "Cambia la visualizacion de Aguante"
-- /rb stat sta hp
L["Show Health"] = "Mostrar Salud"
L["Show Health from Stamina"] = "Muestra la Salud de Aguante"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Mostrar Daño Hech"
L["Show Spell Damage from Stamina"] = "Muestra el Daño de Hechizo de Aguante"

-- /rb stat int
L["Intellect"] = "Intelecto"
L["Changes the display of Intellect"] = "Cambia la visualizacion de Intelecto"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Mostrar Crit Hech"
L["Show Spell Crit chance from Intellect"] = "Muestra la prob. de Crit. de Hechizo de Intelecto"
-- /rb stat int mp
L["Show Mana"] = "Mostrar Mana"
L["Show Mana from Intellect"] = "Muestra el Mana de Intelecto"
-- /rb stat int dmg
L["Show Spell Damage"] = "Mostrar Daño Hech"
L["Show Spell Damage from Intellect"] = "Muestra el Daño de Hechizo de Intelecto"
-- /rb stat int heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Intellect"] = "Muestra la Sanacion de Intelecto"
-- /rb stat int mp5
L["Show Mana Regen"] = "Mostrar Regen.Mana"
L["Show Mana Regen while casting from Intellect"] = "Muestra la Regen.Mana de Intelecto"
-- /rb stat int mp5nc
--["Show Mana Regen while NOT casting"] = true,
--["Show Mana Regen while NOT casting from Intellect"] = true,
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist"
L["Show Ranged Attack Power from Intellect"] = "Muestra el Poder Ataque Dist de Intelecto"
-- /rb stat int armor
L["Show Armor"] = "Mostrar Armadura"
L["Show Armor from Intellect"] = "Muestra la Armadura de Intelecto"

-- /rb stat spi
L["Spirit"] = "Espíritu"
L["Changes the display of Spirit"] = "Cambia la visualizacion de Espíritu"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Mostrar Regen.Mana"
L["Show Mana Regen while casting from Spirit"] = "Muestra la Regen.Mana de Espíritu"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Mostrar Regen.Mana NO lanzando"
L["Show Mana Regen while NOT casting from Spirit"] = "Muestra la Regen.Mana NO lanzando de Espíritu"
-- /rb stat spi hp5
L["Show Health Regen"] = "Mostrar Regen.Salud"
L["Show Health Regen from Spirit"] = "Muestra la Regen. de Salud de Espíritu"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Mostrar Daño Hech"
L["Show Spell Damage from Spirit"] = "Muestra el Daño de Hechizos de Espíritu"
-- /rb stat spi heal
L["Show Healing"] = "Mostrar Sanacion"
L["Show Healing from Spirit"] = "Muestra la Sanacion de Espíritu"

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
L["Ignore unused items types"] = "Ignorar tipos de item no usados"
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
-- /rb sum statcomp tp
L["Sum TankPoints"] = "Res. Ptos. Tanque"
L["TankPoints <- Health Total Reduction"] = "Ptos. Tanque <- Salud, Total Reduccion"
-- /rb sum statcomp tr
L["Sum Total Reduction"] = "Res. Total Reduccion"
L["Total Reduction <- Armor Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Total Reduccion <- Armadura, Esquivar, Parar, Bloquear, Valor bloqueo, Defensa, Temple, FalloEnemigo, CriticoEnemigo, AplastamientoEnemigo, Modifics.DañoRecibido"
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
	{pattern = " en (%d+) p", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "Otorga.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "aumenta.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [????????] +6?????5??
}
L["separators"] = {
	"/", " y ", ",", "%. ", " durante ", "&"
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
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "índice de defensa", id = CR_DEFENSE_SKILL},
	{pattern = "índice de esquivar", id = CR_DODGE},
	{pattern = "índice de bloqueo", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "índice de parada", id = CR_PARRY},

	{pattern = "índice de golpe crítico con hechizos", id = CR_CRIT_SPELL},
	{pattern = "índice de golpe crítico a distancia", id = CR_CRIT_RANGED},
	{pattern = "índice de golpe crítico cuerpo a cuerpo", id = CR_CRIT_MELEE},
	{pattern = "índice de golpe crítico", id = CR_CRIT},

	{pattern = "índice de golpe con hechizo", id = CR_HIT_SPELL},
	{pattern = "índice de golpe a distancia", id = CR_HIT_RANGED},
	{pattern = "índice de golpe cuerpo a cuerpo", id = CR_HIT_MELEE},
	{pattern = "índice de golpe", id = CR_HIT},

	{pattern = "índice de temple", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "índice de celeridad con hechizos", id = CR_HASTE_SPELL},
	{pattern = "índice de celeridad a distancia", id = CR_HASTE_RANGED},
	{pattern = "índice de celeridad con cuerpo a cuerpo", id = CR_HASTE_MELEE},
	{pattern = "índice de celeridad", id = CR_HASTE},
	{pattern = "Aumenta el índice de velocidad de lanzamiento de ataques y de ataque de los miembros del grupo cercanos", id = CR_HASTE}, -- [Drums of Battle]

	{pattern = "índice de pericia", id = CR_EXPERTISE},

	{pattern = "índice de penetración de armadura", id = CR_ARMOR_PENETRATION},
	{pattern = string.lower(ARMOR), id = ARMOR},
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
L["$value to be Dodged/Parried"] = "$value Esquivado/Parado"
L["$value to be Crit"] = "$value recibir Crit"
L["$value Crit Dmg Taken"] = "$value Daño crit recib"
L["$value DOT Dmg Taken"] = "$value Daño por tiempo recib"
L["$value% Parry"] = "$value Parada"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value Hech."

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Resumen estad."
