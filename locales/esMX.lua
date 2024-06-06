--[[
Name: RatingBuster esMX locale
Revision: $Revision: 73697 $
Translated by:
- carahuevo@Curse
- Zendor@Mandokir
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esMX")
if not L then return end
addon.S = {}
local S = addon.S
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
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
L["Change number color"] = "Change number color"
-- /rb rating
L["Rating"] = "Calificacion"
L["Options for Rating display"] = "Opciones de visualizacion"
-- /rb rating show
L["Show Rating conversions"] = "Mostrar conversion calificacion"
L["Show Rating conversions in tooltips"] = "Mostrar conversion calificacion en tooltips"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = "Show Spell Hit/Haste"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Show Spell Hit/Haste from Hit/Haste Rating"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "Show Physical Hit/Haste"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Show Physical Hit/Haste from Hit/Haste Rating"
-- /rb rating detail
L["Show detailed conversions text"] = "Mostrar texto detallado conversiones"
L["Show detailed text for Resilience and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia"
-- /rb rating def
L["Defense breakdown"] = "Desglose Defensa"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Desglose Habilidad arma"
L["Convert Weapon Skill into Crit Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Desglose Pericia"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Convierte Pericia en fallo Esquivar y fallo Parar"

-- /rb stat
--["Stat Breakdown"] = "Estad",
L["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base"
-- /rb stat show
L["Show base stat conversions"] = "Mostrar conversiones estad. base"
L["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip"
L["Changes the display of %s"] = "Cambia la visualizacion de %s"

-- /rb sum
L["Stat Summary"] = "Resumen Estad"
L["Options for stat summary"] = "Opciones de Resumen Estad."
L["Sum %s"] = "Res. %s"
-- /rb sum show
L["Show stat summary"] = "Mostrar Resumen Estad"
L["Show stat summary in tooltips"] = "Muestra el Resumen de Estad. en los tooltips"
-- /rb sum ignore
L["Ignore settings"] = "Ignorar opciones"
L["Ignore stuff when calculating the stat summary"] = "Ignorar los datos cuando se calcule el resumen de estad."
-- /rb sum ignore unused
L["Ignore unused item types"] = "Ignorar tipos de item no usados"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Muestra el resumen de estad. solo para los items de mayor nivel de armadura que puedes usar con calidad poco comun en adelante"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Ignorar items equipados"
L["Hide stat summary for equipped items"] = "Ocultar resumen estad. para los items equipados"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Ignorar encantamientos"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorar encantamientos en items cuando  se calcule el resumen de estad."
-- /rb sum ignore gem
L["Ignore gems"] = "Ignorar gemas"
L["Ignore gems on items when calculating the stat summary"] = "Ignorar gemas en items cuando  se calcule el resumen de estad."
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
-- /rb sum diffstyle
L["Display style for diff value"] = "Mostrar estilo para el valor de diferencia"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Mostrar diferencia valores en el tooltip principal o solo en los de comparacion"
L["Hide Blizzard Item Comparisons"] = "Hide Blizzard Item Comparisons"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Disable Blizzard stat change summary when using the built-in comparison tooltip"
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
L["Health <- Health Stamina"] = "Salud <- Salud, Aguante"
-- /rb sum stat mp
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelecto"
-- /rb sum stat ap
L["Attack Power <- Attack Power Strength, Agility"] = "Poder Ataque <- Poder Ataque, Fuerza, Agilidad"
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "P.Ataque Distancia <- P.Ataque Distancia, Intelecto, P.Ataque, Fuerza, Agilidad"
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Daño Hech. <- Daño Hech., Intelecto, Espíritu, Aguante"
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Daño Hech. Sagrado <- Daño Hech. Sagrado, Daño Hech., Intelecto, Espíritu"
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto"
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto, Aguante"
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Daño Hech. Naturaleza <- Daño Hech. Naturaleza, Daño Hech., Intelecto"
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Daño Hech. Frio <- Daño Hech. Frio, Daño Hech., Intelecto"
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Daño Hech. Sombras <- Daño Hech. Sombras, Daño Hech., Intelecto, Espíritu, Aguante"
-- /rb sum stat heal
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Sanacion <- Sanacion, Intelecto, Espíritu, Agilidad, Fuerza"
-- /rb sum stat hit
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "prob. Golpe <- Índice Golpe, Índice pericia"
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = "prob. Golpe Hech. <- Índice Golpe Hech."
-- /rb sum stat crit
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "prob. Critico <- Índice Critico, Agilidad, índice de pericia"
-- /rb sum stat haste
L["Haste <- Haste Rating"] = "Velocidad <- Índice Velocidad"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Ranged Haste <- Haste Rating, Ranged Haste Rating"

-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "prob. Critico Hech. <- Índice Critico Hech., Intelecto"
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = "Velocidad Hech. <- Índice Velocidad Hech."
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen Spirit"] = "Regen. mana <- Regen. mana, Espíritu"
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = "Regen. mana mientras no se lanza <- Espíritu"
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = "Regen. salud <- Regen. salud"
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = "Regen. salud fuera de combate <- Espíritu"
-- /rb sum stat armor
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Armadura <- Armadura de items, Armadura de bonus, Agilidad, Intelecto"
-- /rb sum stat blockvalue
L["Block Value <- Block Value Strength"] = "Valor Bloqueo <- Valor Bloqueo, Fuerza"
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Prob. Esquivar <- Índice Esquivar, Agilidad, índice defensa"
-- /rb sum stat parry
L["Parry Chance <- Parry Rating Defense Rating"] = "Prob. Parar <- Índice Parar, índice defensa"
-- /rb sum stat block
L["Block Chance <- Block Rating Defense Rating"] = "Prob. Bloqueo <- Índice Bloqueo, índice defensa"
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = "Elusion golpe <- índice defensa"
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating Resilience"] = "Elusion Critico <- índice defensa, Temple"
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "Fallo Esquivar <- Pericia, Índice habilidad arma" -- 2.3.0
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "Fallo Parar <- Pericia, Índice habilidad arma" -- 2.3.0

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = "Defensa <- índice defensa"
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = "Habilidad Arma <- Índice Habilidad Arma"
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = "Pericia <- Índice Pericia"
-- /rb sum statcomp avoid
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Elusion <- Esquivar, Parar, FalloEnemigo, Bloqueo(Opcional)"

-- /rb sum gem
--["Gems"] = true,
--["Auto fill empty gem slots"] = true,
--["ItemID or Link of the gem you would like to auto fill"] = true,
--["<ItemID|Link>"] = true,
--["%s is now set to %s"] = true,
--["Queried server for Gem: %s. Try again in 5 secs."] = true,

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Nivel de objeto "
L["ItemID: "] = "ItemID: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = "Enables RatingBuster to calculate selected buff effects even if you don't really have them"
L["$class Self Buffs"] = "$class Self Buffs" -- $class will be replaced with localized player class
L["Raid Buffs"] = "Raid Buffs"
L["Stat Multiplier"] = "Stat Multiplier"
L["Attack Power Multiplier"] = "Attack Power Multiplier"
L["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken"

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
	{SPELL_STAT1_NAME:lower(), StatLogic.Stats.Strength}, -- Strength
	{SPELL_STAT2_NAME:lower(), StatLogic.Stats.Agility}, -- Agility
	{SPELL_STAT3_NAME:lower(), StatLogic.Stats.Stamina}, -- Stamina
	{SPELL_STAT4_NAME:lower(), StatLogic.Stats.Intellect}, -- Intellect
	{SPELL_STAT5_NAME:lower(), StatLogic.Stats.Spirit}, -- Spirit
	{"la defensa", StatLogic.Stats.DefenseRating},
	{DEFENSE:lower(), StatLogic.Stats.Defense},
	{"índice de esquivar", StatLogic.Stats.DodgeRating},
	{"índice de bloqueo", StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{"índice de parada", StatLogic.Stats.ParryRating},

	{"recibir un golpe", false},
	{"golpe crítico con hechizos", StatLogic.Stats.SpellCritRating},
	{"golpe crítico a distancia", StatLogic.Stats.RangedCritRating},
	{"golpe crítico cuerpo a cuerpo", StatLogic.Stats.MeleeCritRating},
	{"golpe crítico", StatLogic.Stats.CritRating},

	{"golpe con hechizo", StatLogic.Stats.SpellHitRating},
	{"golpe a distancia", StatLogic.Stats.RangedHitRating},
	{"golpe cuerpo a cuerpo", StatLogic.Stats.MeleeHitRating},
	{"golpe", StatLogic.Stats.HitRating},

	{"temple", StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{"celeridad con hechizos", StatLogic.Stats.SpellHasteRating},
	{"celeridad a distancia", StatLogic.Stats.RangedHasteRating},
	{"celeridad con cuerpo a cuerpo", StatLogic.Stats.MeleeHasteRating},
	{"celeridad", StatLogic.Stats.HasteRating},
	{"índice de velocidad", StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{"pericia", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"penetración de armadura", StatLogic.Stats.ArmorPenetrationRating},
	{"maestría", StatLogic.Stats.MasteryRating},
	{ARMOR:lower(), StatLogic.Stats.Armor},
	{"poder de ataque", StatLogic.Stats.AttackPower},
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
L["Spell"] = "Hech."

-- Basic Attributes
L[StatLogic.Stats.Strength] = "Fuerza"
L[StatLogic.Stats.Agility] = "Agilidad"
L[StatLogic.Stats.Stamina] = "Aguante"
L[StatLogic.Stats.Intellect] = "Intelecto"
L[StatLogic.Stats.Spirit] = "Espíritu"
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.MasteryRating] = RATING.." "..STAT_MASTERY

-- Resources
L[StatLogic.Stats.Health] = "Salud"
S[StatLogic.Stats.Health] = "Vida"
L[StatLogic.Stats.Mana] = "Mana"
S[StatLogic.Stats.Mana] = "Mana"
L[StatLogic.Stats.ManaRegen] = "Regen.Mana"
S[StatLogic.Stats.ManaRegen] = "Mana/5sec"

local ManaRegenOutOfCombat = "Regen.Mana (Out of Combat)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "Regen.Mana (No se lanza)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "Mana/5sec(SL)"

L[StatLogic.Stats.HealthRegen] = "Regen.Salud"
S[StatLogic.Stats.HealthRegen] = "Vida/5sec"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Regen.Salud (Out of Combat)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "Vida/5sec(NC)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "Poder Ataque"
S[StatLogic.Stats.AttackPower] = "P.At"
L[StatLogic.Stats.FeralAttackPower] = "Feral "..ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.IgnoreArmor] = "Ignorar armadura"
L[StatLogic.Stats.ArmorPenetration] = "Penetracion Armadura"
L[StatLogic.Stats.ArmorPenetrationRating] = "Indice Penetracion Armadura"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "Average Damage"
L[StatLogic.Stats.WeaponDPS] = "Damage Per Second"

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "Prob. Golpe"
L[StatLogic.Stats.MeleeHitRating] = "Índice Golpe"
L[StatLogic.Stats.MeleeCrit] = "prob. Critico"
S[StatLogic.Stats.MeleeCrit] = "Crit"
L[StatLogic.Stats.MeleeCritRating] = "Índice Critico"
L[StatLogic.Stats.MeleeHaste] = "Velocidad"
L[StatLogic.Stats.MeleeHasteRating] = "Índice Velocidad"

L[StatLogic.Stats.WeaponSkill] = "Habilidad Arma"
L[StatLogic.Stats.Expertise] = "Pericia"
L[StatLogic.Stats.ExpertiseRating] = "Pericia".." "..RATING
L[StatLogic.Stats.DodgeReduction] = "Fallo Esquivar"
S[StatLogic.Stats.DodgeReduction] = "Esquivado"
L[StatLogic.Stats.ParryReduction] = "Fallo Parar"
S[StatLogic.Stats.ParryReduction] = "Parado"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "P.Ataque Distancia"
S[StatLogic.Stats.RangedAttackPower] = "P.At Dist"
L[StatLogic.Stats.RangedHit] = "Prob. Golpe a Distancia"
L[StatLogic.Stats.RangedHitRating] = "Indice Golpe a Distancia"
L[StatLogic.Stats.RangedCrit] = "Prob. Critico a Distancia"
L[StatLogic.Stats.RangedCritRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.RangedHaste] = PLAYERSTAT_RANGED_COMBAT.." Haste"
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "Daño Hech."
S[StatLogic.Stats.SpellDamage] = "Daño"
L[StatLogic.Stats.HealingPower] = "Sanacion"
S[StatLogic.Stats.HealingPower] = "Sanacion"
L[StatLogic.Stats.SpellPenetration] = "Penetracion"

L[StatLogic.Stats.HolyDamage] = "Daño Hech. Sagrado"
L[StatLogic.Stats.FireDamage] = "Daño Hech. Fuego"
L[StatLogic.Stats.NatureDamage] = "Daño Hech. Naturaleza"
L[StatLogic.Stats.FrostDamage] = "Daño Hech. Frio"
L[StatLogic.Stats.ShadowDamage] = "Daño Hech. Sombras"
L[StatLogic.Stats.ArcaneDamage] = "Daño Hech. Arcano"

L[StatLogic.Stats.SpellHit] = "Prob. Golpe Hech."
S[StatLogic.Stats.SpellHit] = "Golpe Hech."
L[StatLogic.Stats.SpellHitRating] = "Golpe Hech."
L[StatLogic.Stats.SpellCrit] = "Prob. Critico Hech."
S[StatLogic.Stats.SpellCrit] = "Crit hechizos"
L[StatLogic.Stats.SpellCritRating] = "Índice Critico Hech."
L[StatLogic.Stats.SpellHaste] = "Velocidad Hech."
L[StatLogic.Stats.SpellHasteRating] = "Índice Velocidad Hech."

-- Tank Stats
L[StatLogic.Stats.Armor] = "Armadura"
S[StatLogic.Stats.Armor] = "Armadura"

L[StatLogic.Stats.Avoidance] = "Elusion"
L[StatLogic.Stats.Dodge] = "Prob. Esquivar"
S[StatLogic.Stats.Dodge] = "Esquivar"
L[StatLogic.Stats.DodgeRating] = "Índice Esquivar"
L[StatLogic.Stats.Parry] = "Prob. Parar"
S[StatLogic.Stats.Parry] = "Parada"
L[StatLogic.Stats.ParryRating] = "Índice Parar"
L[StatLogic.Stats.BlockChance] = "Prob Bloqueo"
L[StatLogic.Stats.BlockRating] = "Índice Bloquear"
L[StatLogic.Stats.BlockValue] = "Valor Bloqueo"
S[StatLogic.Stats.BlockValue] = "Bloqueo"
L[StatLogic.Stats.Miss] = "Elusion golpe"

L[StatLogic.Stats.Defense] = "Defensa"
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = "Elusion Critico"
S[StatLogic.Stats.CritAvoidance] = "recibir Crit"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "Temple"
L[StatLogic.Stats.CritDamageReduction] = "Crit Damage Reduction"
S[StatLogic.Stats.CritDamageReduction] = "Daño crit recib"
L[StatLogic.Stats.PvPDamageReduction] = "Daño recib"

L[StatLogic.Stats.FireResistance] = "Resist. Fuego"
L[StatLogic.Stats.NatureResistance] = "Resist. Naturaleza"
L[StatLogic.Stats.FrostResistance] = "Resist. Frio"
L[StatLogic.Stats.ShadowResistance] = "Resist. Sombras"
L[StatLogic.Stats.ArcaneResistance] = "Resist. Arcana"