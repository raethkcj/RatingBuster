--[[
Name: RatingBuster esES locale
Revision: $Revision: 73696 $
Translated by: 
- carahuevo@Curse
]]

local L = AceLibrary("AceLocale-2.2"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "??????",
L:RegisterTranslations("esES", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = "Opciones RatingBuster",
	["Waterfall-1.0 is required to access the GUI."] = "Se requiere Waterfall para acceder a la GUI.",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb optionswin
	["Options Window"] = "Ventana opciones",
	["Shows the Options Window"] = "Muestra la ventana de opciones",
	-- /rb statmod
	["Enable Stat Mods"] = "Habilitar Stat Mods",
	["Enable support for Stat Mods"] = "Habilita el soporte para Stat Mods",
	-- /rb itemid
	["Show ItemID"] = "Mostrar ItemID",
	["Show the ItemID in tooltips"] = "Mostrar ItemID en los tooltips",
	-- /rb itemlevel
	["Show ItemLevel"] = "Mostrar NivelItem",
	["Show the ItemLevel in tooltips"] = "Muestra el NivelItem en los tooltips",
	-- /rb usereqlv
	["Use required level"] = "Usar nivel requerido",
	["Calculate using the required level if you are below the required level"] = "Calcular apartir del nivel requerido si estas por debajo" ,
	-- /rb setlevel
	["Set level"] = "Establecer nivel",
	["Set the level used in calculations (0 = your level)"] = "Establece el nivel usado en los caculos (0=tu nivel)",
	-- /rb color
	["Change text color"] = "Cambiar color texto",
	["Changes the color of added text"] = "Cambia el color del texto anadido",
	-- /rb color pick
	["Pick color"] = "Coge color",
	["Pick a color"] = "Coge un color",
	-- /rb color enable
	["Enable color"] = "Habilitar color",
	["Enable colored text"] = "Habilitar texto coloreado",
	-- /rb rating
	["Rating"] = "Calificacion",
	["Options for Rating display"] = "Opciones de visualizacion",
	-- /rb rating show
	["Show Rating conversions"] = "Mostrar conversion calificacion",
	["Show Rating conversions in tooltips"] = "Mostrar conversion calificacion en tooltips",
	-- /rb rating detail
	["Show detailed conversions text"] = "Mostrar texto detallado conversiones",
	["Show detailed text for Resiliance and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia",
	-- /rb rating def
	["Defense breakdown"] = "Desglose Defensa",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "Desglose Habilidad arma",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear",
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = "Desglose Pericia",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convierte Pericia en fallo Esquivar y fallo Parar",
	
	-- /rb stat
	--["Stat Breakdown"] = "Estad",
	["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base",
	-- /rb stat show
	["Show base stat conversions"] = "Mostrar conversiones estad. base",
	["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip",
	-- /rb stat str
	["Strength"] = "Fuerza",
	["Changes the display of Strength"] = "Cambia la visualizacion de Fuerza",
	-- /rb stat str ap
	["Show Attack Power"] = "Motrar Poder Ataque",
	["Show Attack Power from Strength"] = "Motrar Poder Ataque de Fuerza",
	-- /rb stat str block
	["Show Block Value"] = "Mostrar Valor Bloqueo",
	["Show Block Value from Strength"] = "Muestra el Valor Bloqueo de Fuerza",
	-- /rb stat str dmg
	["Show Spell Damage"] = "Mostrar Dano Hech",
	["Show Spell Damage from Strength"] = "Muestra el Dano de Hechizo de Fuerza",
	-- /rb stat str heal
	["Show Healing"] = "Mostrar Sanacion",
	["Show Healing from Strength"] = "Muestra la Sanacion de Fuerza",
	
	-- /rb stat agi
	["Agility"] = "Agilidad",
	["Changes the display of Agility"] = "Cambia la visualizacion de Agilidad",
	-- /rb stat agi crit
	["Show Crit"] = "Mostrar Crit",
	["Show Crit chance from Agility"] = "Muestra la prob. de critico de Agilidad",
	-- /rb stat agi dodge
	["Show Dodge"] = "Mostrar Esquivar",
	["Show Dodge chance from Agility"] = "Muestra la prob. de Esquivar de Agilidad",
	-- /rb stat agi ap
	["Show Attack Power"] = "Mostrar Poder Ataque",
	["Show Attack Power from Agility"] = "Muestra Poder de Ataque de Agilidad",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist",
	["Show Ranged Attack Power from Agility"] = "Muestra Poder de Ataque a distancia de Agilidad",
	-- /rb stat agi armor
	["Show Armor"] = "Mostrar Armadura",
	["Show Armor from Agility"] = "Muestra la Armadura de Agilidad",
	-- /rb stat agi heal
	["Show Healing"] = "Mostrar Sanacion",
	["Show Healing from Agility"] = "Muestra Sanacion de Agilidad",
	
	-- /rb stat sta
	["Stamina"] = "Aguante",
	["Changes the display of Stamina"] = "Cambia la visualizacion de Aguante",
	-- /rb stat sta hp
	["Show Health"] = "Mostrar Salud",
	["Show Health from Stamina"] = "Muestra la Salud de Aguante",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "Mostrar Dano Hech",
	["Show Spell Damage from Stamina"] = "Muestra el Dano de Hechizo de Aguante",
	
	-- /rb stat int
	["Intellect"] = "Intelecto",
	["Changes the display of Intellect"] = "Cambia la visualizacion de Intelecto",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "Mostrar Crit Hech",
	["Show Spell Crit chance from Intellect"] = "Muestra la prob. de Crit. de Hechizo de Intelecto",
	-- /rb stat int mp
	["Show Mana"] = "Mostrar Mana",
	["Show Mana from Intellect"] = "Muestra el Mana de Intelecto",
	-- /rb stat int dmg
	["Show Spell Damage"] = "Mostrar Dano Hech",
	["Show Spell Damage from Intellect"] = "Muestra el Dano de Hechizo de Intelecto",
	-- /rb stat int heal
	["Show Healing"] = "Mostrar Sanacion",
	["Show Healing from Intellect"] = "Muestra la Sanacion de Intelecto",
	-- /rb stat int mp5
	["Show Mana Regen"] = "Mostrar Regen.Mana",
	["Show Mana Regen while casting from Intellect"] = "Muestra la Regen.Mana de Intelecto",
	-- /rb stat int mp5nc
	--["Show Mana Regen while NOT casting"] = true,
	--["Show Mana Regen while NOT casting from Intellect"] = true,
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "Mostrar Poder Ataque Dist",
	["Show Ranged Attack Power from Intellect"] = "Muestra el Poder Ataque Dist de Intelecto",
	-- /rb stat int armor
	["Show Armor"] = "Mostrar Armadura",
	["Show Armor from Intellect"] = "Muestra la Armadura de Intelecto",
	
	-- /rb stat spi
	["Spirit"] = "Espiritu",
	["Changes the display of Spirit"] = "Cambia la visualizacion de Espiritu",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "Mostrar Regen.Mana",
	["Show Mana Regen while casting from Spirit"] = "Muestra la Regen.Mana de Espiritu",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "Mostrar Regen.Mana NO lanzando",
	["Show Mana Regen while NOT casting from Spirit"] = "Muestra la Regen.Mana NO lanzando de Espiritu",
	-- /rb stat spi hp5
	["Show Health Regen"] = "Mostrar Regen.Salud",
	["Show Health Regen from Spirit"] = "Muestra la Regen. de Salud de Espiritu",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "Mostrar Dano Hech",
	["Show Spell Damage from Spirit"] = "Muestra el Dano de Hechizos de Espiritu",
	-- /rb stat spi heal
	["Show Healing"] = "Mostrar Sanacion",
	["Show Healing from Spirit"] = "Muestra la Sanacion de Espiritu",
	
	-- /rb sum
	["Stat Summary"] = "Resumen Estad",
	["Options for stat summary"] = "Opciones de Resumen Estad.",
	-- /rb sum show
	["Show stat summary"] = "Mostrar Resumen Estad",
	["Show stat summary in tooltips"] = "Muestra el Resumen de Estad. en los tooltips",
	-- /rb sum ignore
	["Ignore settings"] = "Ignorar opciones",
	["Ignore stuff when calculating the stat summary"] = "Ignorar los datos cuando se calcule el resumen de estad.",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "Ignorar tipos de item no usados",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Muestra el resumen de estad. solo para los items de mayor nivel de armadura que puedes usar con calidad poco comun en adelante",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "Ignorar items equipados",
	["Hide stat summary for equipped items"] = "Ocultar resumen estad. para los items equipados",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "Ignorar encantamientos",
	["Ignore enchants on items when calculating the stat summary"] = "Ignorar encantamientos en items cuando  se calcule el resumen de estad.",
	-- /rb sum ignore gem
	["Ignore gems"] = "Ignorar gemas",
	["Ignore gems on items when calculating the stat summary"] = "Ignorar gemas en items cuando  se calcule el resumen de estad.",
	-- /rb sum diffstyle
	["Display style for diff value"] = "Mostrar estilo para el valor de diferencia",
	["Display diff values in the main tooltip or only in compare tooltips"] = "Mostrar diferencia valores en el tooltip principal o solo en los de comparacion",
	-- /rb sum space
	["Add empty line"] = "Anadir linea vacia",
	["Add a empty line before or after stat summary"] = "Anade una linea vacia antes o despues del resumen",
	-- /rb sum space before
	["Add before summary"] = "Anadir antes del resumen",
	["Add a empty line before stat summary"] = "Anade una linea vacia antes del resumen",
	-- /rb sum space after
	["Add after summary"] = "Anadir despues del resumen",
	["Add a empty line after stat summary"] = "Anade una linea vacia despues del resumen",
	-- /rb sum icon
	["Show icon"] = "Mostrar icono",
	["Show the sigma icon before summary listing"] = "Muestra el icono de sumatorio antes del listado resumen",
	-- /rb sum title
	["Show title text"] = "Mostrar texto titulo" ,
	["Show the title text before summary listing"] = "Muestra el titulo antes del listado resumen",
	-- /rb sum showzerostat
	["Show zero value stats"] = "Mostrar estad. valor cero",
	["Show zero value stats in summary for consistancy"] = "Muestra las estad. de valor cero por consistencia",
	-- /rb sum calcsum
	["Calculate stat sum"] = "Calcula suma de estad.",
	["Calculate the total stats for the item"] = "Calcula el total de las estad. para el item",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "Calcular dif. estad.",
	["Calculate the stat difference for the item and equipped items"] = "Calcula la diferencia para el item y los items equipados",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "Ordenar estad. alfabeticamente",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Ordena alfabeticamente el resumen, deshabilita para ordenar de acuerdo a la estad. (basica, fisica, hechizo, tanque)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "Incluir prob. de bloqueo en resumen de Eludir",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Incluye prob. de bloqueo en resumen de Eludir, Deshabilita para solo esquivar, parar y fallar",
	-- /rb sum basic
	["Stat - Basic"] = "Estad. - Basica",
	["Choose basic stats for summary"] = "Escoge las estad. basicas para el resumen",
	-- /rb sum physical
	["Stat - Physical"] = "Estad. - Fisico",
	["Choose physical damage stats for summary"] = "Escoge las estad. de dano fisico para el resumen",
	-- /rb sum spell
	["Stat - Spell"] = "Estad. - Fisico",
	["Choose spell damage and healing stats for summary"] = "Escoge las estad. de dano de hechizo y sanacion para el resumen",
	-- /rb sum tank
	["Stat - Tank"] = "Estad. - Tanque",
	["Choose tank stats for summary"] = "Escoge las estad. de tanque para el resumen",
	-- /rb sum stat hp
	["Sum Health"] = "Suma salud",
	["Health <- Health, Stamina"] = "Salud <- Salud, Aguante",
	-- /rb sum stat mp
	["Sum Mana"] = "Suma Mana",
	["Mana <- Mana, Intellect"] = "Mana <- Mana, Intelecto",
	-- /rb sum stat ap
	["Sum Attack Power"] = "Res. Poder Ataque",
	["Attack Power <- Attack Power, Strength, Agility"] = "Poder Ataque <- Poder Ataque, Fuerza, Agilidad",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "Res. P.Ataque Distancia",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "P.Ataque Distancia <- P.Ataque Distancia, Intelecto, P.Ataque, Fuerza, Agilidad",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "Res. P.Ataque feral",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "P.Ataque feral <- P.Ataque feral, P.Ataque, Fuerza, Agilidad",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "Res. Dano Hech.",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Dano Hech. <- Dano Hech., Intelecto, Espiritu, Aguante",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "Res. Dano Hech. Sagrado",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Dano Hech. Sagrado <- Dano Hech. Sagrado, Dano Hech., Intelecto, Espiritu",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "Res. Dano Hech. Arcano",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Arcano <- Dano Hech. Arcano, Dano Hech., Intelecto",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "Res. Dano Hech. Fuego",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Dano Hech. Arcano <- Dano Hech. Arcano, Dano Hech., Intelecto, Aguante",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "Res. Dano Hech. Naturaleza",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Naturaleza <- Dano Hech. Naturaleza, Dano Hech., Intelecto",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "Res. Dano Hech. Frio",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Dano Hech. Frio <- Dano Hech. Frio, Dano Hech., Intelecto",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "Res. Dano Hech. Sombras",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Dano Hech. Sombras <- Dano Hech. Sombras, Dano Hech., Intelecto, Espiritu, Aguante",
	-- /rb sum stat heal
	["Sum Healing"] = "Res. Sanacion",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Sanacion <- Sanacion, Intelecto, Espiritu, Agilidad, Fuerza",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "Res. prob. Golpe",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "prob. Golpe <- Indice Golpe, Indice pericia",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "Res. prob. Golpe Hech.",
	["Spell Hit Chance <- Spell Hit Rating"] = "prob. Golpe Hech. <- Indice Golpe Hech.",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "prob. Critico",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "prob. Critico <- Indice Critico, Agilidad, Indice de pericia",
	-- /rb sum stat haste
	["Sum Haste"] = "Res. Velocidad",
	["Haste <- Haste Rating"] = "Velocidad <- Indice Velocidad",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "Res. prob. Critico Hech.",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "prob. Critico Hech. <- Indice Critico Hech., Intelecto",
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = "Res. velocidad Hech.",
	["Spell Haste <- Spell Haste Rating"] = "Velocidad Hech. <- Indice Velocidad Hech.",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "Res. Regen. mana",
	["Mana Regen <- Mana Regen, Spirit"] = "Regen. mana <- Regen. mana, Espiritu",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "Res. Regen. mana mientras no se lanza",
	["Mana Regen while not casting <- Spirit"] = "Regen. mana mientras no se lanza <- Espiritu",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "Res. Regen. salud",
	["Health Regen <- Health Regen"] = "Regen. salud <- Regen. salud",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "Res. Regen. salud fuera de combate",
	["Health Regen when out of combat <- Spirit"] = "Regen. salud fuera de combate <- Espiritu",
	-- /rb sum stat armor
	["Sum Armor"] = "Res. Armadura",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Armadura <- Armadura de items, Armadura de bonus, Agilidad, Intelecto",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "Res. Valor Bloqueo",
	["Block Value <- Block Value, Strength"] = "Valor Bloqueo <- Valor Bloqueo, Fuerza",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "Res. prob. Esquivar",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Prob. Esquivar <- Indice Esquivar, Agilidad, Indice Defensa",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "Res. prob. Parar",
	["Parry Chance <- Parry Rating, Defense Rating"] = "Prob. Parar <- Indice Parar, Indice Defensa",
	-- /rb sum stat block
	["Sum Block Chance"] = "Res. prob Bloqueo",
	["Block Chance <- Block Rating, Defense Rating"] = "Prob. Bloqueo <- Indice Bloqueo, Indice Defensa",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "Res. Elusion golpe",
	["Hit Avoidance <- Defense Rating"] = "Elusion golpe <- Indice Defensa",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "Res. Elusion Critico",
	["Crit Avoidance <- Defense Rating, Resilience"] = "Elusion Critico <- Indice Defensa, Temple",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "Res. fallo Esquivar",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Fallo Esquivar <- Pericia, Indice habilidad arma", -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "Res. fallo Parar",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Fallo Parar <- Pericia, Indice habilidad arma", -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "Res. fallo Bloquear",
	["Block Neglect <- Weapon Skill Rating"] = "Fallo Bloquear <- Indice habilidad arma",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "Res. Resist. Arcana",
	["Arcane Resistance Summary"] = "Resumen Resistencia Arcana",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "Res. Resist. Fuego",
	["Fire Resistance Summary"] = "Resumen Resistencia Fuego",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "Res. Resist. Naturaleza",
	["Nature Resistance Summary"] = "Resumen Resistencia Naturaleza",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "Res. Resist. Frio",
	["Frost Resistance Summary"] = "Resumen Resistencia Frio",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "Res. Resist. Sombras",
	["Shadow Resistance Summary"] = "Resumen Resistencia Sombras",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "Res. Max Dano Arma",
	["Weapon Max Damage Summary"] = "Resumen de Maximo Dano Arma",
	-- /rb sum stat pen
	["Sum Penetration"] = "Res. Penetracion",
	["Spell Penetration Summary"] = "Resumen Penetracion Hechizos",
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = "Res. Ignorar armadura",
	["Ignore Armor Summary"] = "Resumen de Ignorar Armadura",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp str
	["Sum Strength"] = "Res. Fuerza",
	["Strength Summary"] = "Resumen Fuerza",
	-- /rb sum statcomp agi
	["Sum Agility"] = "Res. Agilidad",
	["Agility Summary"] = "Resumen Agilidad",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "Res. Aguante",
	["Stamina Summary"] = "Resumen Aguante",
	-- /rb sum statcomp int
	["Sum Intellect"] = "Res. Intelecto",
	["Intellect Summary"] = "Resumen Intelecto",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "Res. Espiritu",
	["Spirit Summary"] = "Resumen Espiritu",
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = "Res. Indice Golpe",
	["Hit Rating Summary"] = "Resumen Indice Golpe",
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = "Res. Indice Critico",
	["Crit Rating Summary"] = "Resumen Indice Critico",
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = "Res. Indice Velocidad",
	["Haste Rating Summary"] = "Resumen Indice Velocidad",
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = "Res. Golpe Hech.",
	["Spell Hit Rating Summary"] = "Resumen Golpe Hech.",
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = "Res. Indice Critico Hech.",
	["Spell Crit Rating Summary"] = "Resumen Indice Critico Hech.",
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = "Res. Indice Velocidad Hech.",
	["Spell Haste Rating Summary"] = "Resumen Indice Velocidad Hech.",
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = "Res. Indice Esquivar",
	["Dodge Rating Summary"] = "Resumen Indice Esquivar",
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = "Res. Indice Parar",
	["Parry Rating Summary"] = "Resumen Indice Parar",
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = "Res. Indice Bloquear",
	["Block Rating Summary"] = "Resumen Indice Bloquear",
	-- /rb sum statcomp res
	["Sum Resilience"] = "Res. Temple",
	["Resilience Summary"] = "Resumen Temple",
	-- /rb sum statcomp def
	["Sum Defense"] = "Res. Defensa",
	["Defense <- Defense Rating"] = "Defensa <- Indice Defensa",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "Res. Habilidad Arma",
	["Weapon Skill <- Weapon Skill Rating"] = "Habilidad Arma <- Indice Habilidad Arma",
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = "Res. Pericia",
	["Expertise <- Expertise Rating"] = "Pericia <- Indice Pericia",
	-- /rb sum statcomp tp
	["Sum TankPoints"] = "Res. Ptos. Tanque",
	["TankPoints <- Health, Total Reduction"] = "Ptos. Tanque <- Salud, Total Reduccion",
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = "Res. Total Reduccion",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Total Reduccion <- Armadura, Esquivar, Parar, Bloquear, Valor bloqueo, Defensa, Temple, FalloEnemigo, CriticoEnemigo, AplastamientoEnemigo, Modifics.DanoRecibido",
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = "Res. Elusion",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Elusion <- Esquivar, Parar, FalloEnemigo, Bloqueo(Opcional)",
	
	-- /rb sum gem
	--["Gems"] = true,
	--["Auto fill empty gem slots"] = true,
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	--["ItemID or Link of the gem you would like to auto fill"] = true,
	--["<ItemID|Link>"] = true,
	--["%s is now set to %s"] = true,
	--["Queried server for Gem: %s. Try again in 5 secs."] = true,
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,

	
	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "NivelItem",
	["ItemID: "] = "IDItem",
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
		{pattern = " en (%d+)", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
		{pattern = "Otorga.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		{pattern = "aumenta.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [????????] +6?????5??
	},
	["separators"] = {
		"/", " y ", ",", "%. ", " durante ", "&"
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
	SPELL_STAT1_NAME = "Strength"
	SPELL_STAT2_NAME = "Agility"
	SPELL_STAT3_NAME = "Stamina"
	SPELL_STAT4_NAME = "Intellect"
	SPELL_STAT5_NAME = "Spirit"
	--]]
	["statList"] = {
		{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
		{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
		{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
		{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
		{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
		{pattern = "indice de defensa rating, id = CR_DEFENSE_SKILL"},
		{pattern = "indice de esquivar", id = CR_DODGE},
		{pattern = "indice de bloqueo", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
		{pattern = "indice de parada", id = CR_PARRY},
	
		{pattern = "indice de golpe critico con hechizos", id = CR_CRIT_SPELL},
		{pattern = "indice de golpe critico a distancia", id = CR_CRIT_RANGED},
		{pattern = "indice de golpe critico cuerpo a cuerpo", id = CR_CRIT_MELEE},
		{pattern = "indice de golpe", id = CR_CRIT_MELEE},
		
		{pattern = "indice de golpe con hechizo", id = CR_HIT_SPELL},
		{pattern = "indice de golpe a distancia", id = CR_HIT_RANGED},
		{pattern = "indice de golpe cuerpo a cuerpo", id = CR_HIT_MELEE},
		{pattern = "indice de golpe", id = CR_HIT_MELEE},
		
		{pattern = "indice de temple", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating
		
		{pattern = "indice de celeridad con hechizos", id = CR_HASTE_SPELL},
		{pattern = "indice de celeridad a distancia", id = CR_HASTE_RANGED},
		{pattern = "indice de celeridad con cuerpo a cuerpo", id = CR_HASTE_MELEE},
		{pattern = "indice de celeridad", id = CR_HASTE_MELEE},
		{pattern = "Aumenta el indice de velocidad de lanzamiento de ataques y de ataque de los miembros del grupo cercanos", id = CR_HASTE_MELEE}, -- [Drums of Battle]
		
		{pattern = "indice de habilidad", id = CR_WEAPON_SKILL},
		{pattern = "indice de pericia", id = CR_EXPERTISE},
		
		{pattern = "indice de evasion de golpes cuerpo a cuerpo", id = CR_HIT_TAKEN_MELEE},
		{pattern = "indice de evasion", id = CR_HIT_TAKEN_MELEE},
		--[[
		{pattern = "indice de habilidad con dagas", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con espadas", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con espadas de dos manos", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con hachas", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con arcos", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con ballesta", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con armas de fuego", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad en combate feral", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con mazas", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con armas de asta", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con bastones", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con hachas de dos manos", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad con mazas de dos manos", id = CR_WEAPON_SKILL},
		{pattern = "indice de habilidad sin armas", id = CR_WEAPON_SKILL},
		--]]
	},
	-------------------------
	-- Added info patterns --
	-------------------------
	-- $value will be replaced with the number
	-- EX: "$value% Crit" -> "+1.34% Crit"
	-- EX: "Crit $value%" -> "Crit +1.34%"
	["$value% Crit"] = "$value% Crit",
	["$value% Spell Crit"] = "$value% Crit hechizos",
	["$value% Dodge"] = "$value% Esquivar",
	["$value HP"] = "$value Vida",
	["$value MP"] = "$value Mana",
	["$value AP"] = "$value P.At",
	["$value RAP"] = "$value P.At Dist",
	["$value Dmg"] = "$value Dano",
	["$value Heal"] = "$value Sanacion",
	["$value Armor"] = "$value Armadura",
	["$value Block"] = "$value Bloqueo",
	["$value MP5"] = "$value Mana/5sec",
	["$value MP5(NC)"] = "$value Mana/5sec(SL)",
	["$value HP5"] = "$value Vida/5sec",
	["$value to be Dodged/Parried"] = "$value Esquivado/Parado",
	["$value to be Crit"] = "$value recibir Crit",
	["$value Crit Dmg Taken"] = "$value Dano crit recib",
	["$value DOT Dmg Taken"] = "$value Dano por tiempo recib",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "Resumen estad.",
} end)