--[[
Name: RatingBuster esES locale
Translated by:
- carahuevo@Curse
- Zendor@Mandokir
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "esES")
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
L["Help"] = "Help"
L["Show this help message"] = "Show this help message"
L["Options Window"] = "Ventana opciones"
L["Shows the Options Window"] = "Muestra la ventana de opciones"
L["Enable Stat Mods"] = "Habilitar Stat Mods"
L["Enable support for Stat Mods"] = "Habilita el soporte para Stat Mods"
L["Enable Avoidance Diminishing Returns"] = "Habilita evitacion de rendimientos decrecientes"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Rendimientos decrecientes"
L["Show ItemID"] = "Mostrar ItemID"
L["Show the ItemID in tooltips"] = "Mostrar ItemID en los tooltips"
L["Show ItemLevel"] = "Mostrar NivelItem"
L["Show the ItemLevel in tooltips"] = "Muestra el NivelItem en los tooltips"
L["Use required level"] = "Usar nivel requerido"
L["Calculate using the required level if you are below the required level"] = "Calcular apartir del nivel requerido si estas por debajo"
L["Set level"] = "Establecer nivel"
L["Set the level used in calculations (0 = your level)"] = "Establece el nivel usado en los caculos (0=tu nivel)"
L["Change text color"] = "Cambiar color texto"
L["Changes the color of added text"] = "Cambia el color del texto anadido"
L["Change number color"] = "Change number color"
L["Rating"] = "Calificacion"
L["Options for Rating display"] = "Opciones de visualizacion"
L["Show Rating conversions"] = "Mostrar conversion calificacion"
L["Show Rating conversions in tooltips"] = "Mostrar conversion calificacion en tooltips"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
L["Show Spell Hit/Haste"] = "Show Spell Hit/Haste"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Show Spell Hit/Haste from Hit/Haste Rating"
L["Show Physical Hit/Haste"] = "Show Physical Hit/Haste"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Show Physical Hit/Haste from Hit/Haste Rating"
L["Show detailed conversions text"] = "Mostrar texto detallado conversiones"
L["Show detailed text for Resilience and Expertise conversions"] = "Mostrar texto detallado de conversiones de Temple y Pericia"
L["Defense breakdown"] = "Desglose Defensa"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Convierte Defensa en evitar Critico, evitar Golpe, Esquivar, Parar y Bloquear"
L["Weapon Skill breakdown"] = "Desglose Habilidad arma"
L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "Convierta Habilidad arma en Critico, Golpe, falla Esquivar, y fallo Bloquear"
L["Expertise breakdown"] = "Desglose Pericia"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Convierte Pericia en fallo Esquivar y fallo Parar"

L["Stat Breakdown"] = "Estad"
L["Changes the display of base stats"] = "Cambia la visualizacion de las estad. base"
L["Show base stat conversions"] = "Mostrar conversiones estad. base"
L["Show base stat conversions in tooltips"] = "Muestra las conversiones de estad. base en los tooltip"
L["Changes the display of %s"] = "Cambia la visualizacion de %s"

L["Stat Summary"] = "Resumen Estad"
L["Options for stat summary"] = "Opciones de Resumen Estad."
L["Sum %s"] = "Res. %s"
L["Show stat summary"] = "Mostrar Resumen Estad"
L["Show stat summary in tooltips"] = "Muestra el Resumen de Estad. en los tooltips"
L["Ignore settings"] = "Ignorar opciones"
L["Ignore stuff when calculating the stat summary"] = "Ignorar los datos cuando se calcule el resumen de estad."
L["Ignore unused item types"] = "Ignorar tipos de item no usados"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Muestra el resumen de estad. solo para los items de mayor nivel de armadura que puedes usar con calidad poco comun en adelante"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
L["Ignore equipped items"] = "Ignorar items equipados"
L["Hide stat summary for equipped items"] = "Ocultar resumen estad. para los items equipados"
L["Ignore enchants"] = "Ignorar encantamientos"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorar encantamientos en items cuando  se calcule el resumen de estad."
L["Ignore gems"] = "Ignorar gemas"
L["Ignore gems on items when calculating the stat summary"] = "Ignorar gemas en items cuando  se calcule el resumen de estad."
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
L["Display style for diff value"] = "Mostrar estilo para el valor de diferencia"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Mostrar diferencia valores en el tooltip principal o solo en los de comparacion"
L["Hide Blizzard Item Comparisons"] = "Hide Blizzard Item Comparisons"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Disable Blizzard stat change summary when using the built-in comparison tooltip"
L["Add empty line"] = "Anadir linea vacia"
L["Add a empty line before or after stat summary"] = "Anade una linea vacia antes o despues del resumen"
L["Add before summary"] = "Anadir antes del resumen"
L["Add a empty line before stat summary"] = "Anade una linea vacia antes del resumen"
L["Add after summary"] = "Anadir despues del resumen"
L["Add a empty line after stat summary"] = "Anade una linea vacia despues del resumen"
L["Show icon"] = "Mostrar icono"
L["Show the sigma icon before stat summary"] = "Muestra el icono de sumatorio antes del listado resumen"
L["Show title text"] = "Mostrar texto titulo"
L["Show the title text before stat summary"] = "Muestra el titulo antes del listado resumen"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
L["Show zero value stats"] = "Mostrar estad. valor cero"
L["Show zero value stats in summary for consistancy"] = "Muestra las estad. de valor cero por consistencia"
L["Calculate stat sum"] = "Calcula suma de estad."
L["Calculate the total stats for the item"] = "Calcula el total de las estad. para el item"
L["Calculate stat diff"] = "Calcular dif. estad."
L["Calculate the stat difference for the item and equipped items"] = "Calcula la diferencia para el item y los items equipados"
L["Sort StatSummary alphabetically"] = "Ordenar estad. alfabeticamente"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "Ordena alfabeticamente el resumen, deshabilita para ordenar de acuerdo a la estad. (basica, fisica, hechizo, tanque)"
L["Include block chance in Avoidance summary"] = "Incluir prob. de bloqueo en resumen de Eludir"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "Incluye prob. de bloqueo en resumen de Eludir, Deshabilita para solo esquivar, parar y fallar"
L["Stat - Basic"] = "Estad. - Basica"
L["Choose basic stats for summary"] = "Escoge las estad. basicas para el resumen"
L["Stat - Physical"] = "Estad. - Fisico"
L["Choose physical damage stats for summary"] = "Escoge las estad. de daño fisico para el resumen"
L["Ranged"] = "Ranged"
L["Weapon"] = "Weapon"
L["Stat - Spell"] = "Estad. - Fisico"
L["Choose spell damage and healing stats for summary"] = "Escoge las estad. de daño de hechizo y sanacion para el resumen"
L["Stat - Tank"] = "Estad. - Tanque"
L["Choose tank stats for summary"] = "Escoge las estad. de tanque para el resumen"
L["Health <- Health Stamina"] = "Salud <- Salud, Aguante"
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intelecto"
L["Attack Power <- Attack Power Strength, Agility"] = "Poder Ataque <- Poder Ataque, Fuerza, Agilidad"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "P.Ataque Distancia <- P.Ataque Distancia, Intelecto, P.Ataque, Fuerza, Agilidad"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Daño Hech. <- Daño Hech., Intelecto, Espíritu, Aguante"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "Daño Hech. Sagrado <- Daño Hech. Sagrado, Daño Hech., Intelecto, Espíritu"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "Daño Hech. Arcano <- Daño Hech. Arcano, Daño Hech., Intelecto, Aguante"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "Daño Hech. Naturaleza <- Daño Hech. Naturaleza, Daño Hech., Intelecto"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "Daño Hech. Frio <- Daño Hech. Frio, Daño Hech., Intelecto"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "Daño Hech. Sombras <- Daño Hech. Sombras, Daño Hech., Intelecto, Espíritu, Aguante"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Sanacion <- Sanacion, Intelecto, Espíritu, Agilidad, Fuerza"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "prob. Golpe <- Índice Golpe, Índice pericia"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "prob. Critico <- Índice Critico, Agilidad, índice de pericia"
L["Haste <- Haste Rating"] = "Velocidad <- Índice Velocidad"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Ranged Haste <- Haste Rating, Ranged Haste Rating"
L["Spell Hit Chance <- Spell Hit Rating"] = "prob. Golpe Hech. <- Índice Golpe Hech."
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "prob. Critico Hech. <- Índice Critico Hech., Intelecto"
L["Spell Haste <- Spell Haste Rating"] = "Velocidad Hech. <- Índice Velocidad Hech."
L["Mana Regen <- Mana Regen Spirit"] = "Regen. mana <- Regen. mana, Espíritu"
L["Mana Regen while not casting <- Spirit"] = "Regen. mana mientras no se lanza <- Espíritu"
L["Health Regen <- Health Regen"] = "Regen. salud <- Regen. salud"
L["Health Regen when out of combat <- Spirit"] = "Regen. salud fuera de combate <- Espíritu"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Armadura <- Armadura de items, Armadura de bonus, Agilidad, Intelecto"
L["Block Value <- Block Value Strength"] = "Valor Bloqueo <- Valor Bloqueo, Fuerza"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Prob. Esquivar <- Índice Esquivar, Agilidad, índice defensa"
L["Parry Chance <- Parry Rating Defense Rating"] = "Prob. Parar <- Índice Parar, índice defensa"
L["Block Chance <- Block Rating Defense Rating"] = "Prob. Bloqueo <- Índice Bloqueo, índice defensa"
L["Hit Avoidance <- Defense Rating"] = "Elusion golpe <- índice defensa"
L["Crit Avoidance <- Defense Rating Resilience"] = "Elusion Critico <- índice defensa, Temple"
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "Fallo Esquivar <- Pericia, Índice habilidad arma" -- 2.3.0
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "Fallo Parar <- Pericia, Índice habilidad arma" -- 2.3.0
L["Defense <- Defense Rating"] = "Defensa <- índice defensa"
L["Weapon Skill <- Weapon Skill Rating"] = "Habilidad Arma <- Índice Habilidad Arma"
L["Expertise <- Expertise Rating"] = "Pericia <- Índice Pericia"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "Elusion <- Esquivar, Parar, FalloEnemigo, Bloqueo(Opcional)"
L["Gems"] = "Gems"
L["Auto fill empty gem slots"] = "Auto fill empty gem slots"
L["ItemID or Link of the gem you would like to auto fill"] = "ItemID or Link of the gem you would like to auto fill"
L["<ItemID|Link>"] = "<ItemID|Link>"
L["%s is now set to %s"] = "%s is now set to %s"
L["Queried server for Gem: %s. Try again in 5 secs."] = "Queried server for Gem: %s. Try again in 5 secs."

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
	[StatLogic.Stats.DefenseRating] = { "índice de defensa" },
	[StatLogic.Stats.Defense] = { DEFENSE:lower() },
	[StatLogic.Stats.DodgeRating] = { "índice de esquivar", "esquivar" },
	[StatLogic.Stats.BlockRating] = { "índice de bloqueo", "bloquear" },
	[StatLogic.Stats.ParryRating] = { "índice de parada", "parar" },

	[StatLogic.Stats.SpellPower] = { "poder con hechizos" },
	[StatLogic.Stats.GenericAttackPower] = { "poder de ataque" },

	[StatLogic.Stats.MeleeCritRating] = { "índice de golpe crítico cuerpo a cuerpo", "índice de golpe crítico", "golpe crítico" },
	[StatLogic.Stats.RangedCritRating] = { "índice de golpe crítico a distancia" },
	[StatLogic.Stats.SpellCritRating] = { "índice de golpe crítico con hechizos" },
	[StatLogic.Stats.CritRating] = { "índice de golpe crítico", "golpe crítico" },

	[StatLogic.Stats.MeleeHitRating] = { "índice de golpe cuerpo a cuerpo", "índice de golpe", "golpe" },
	[StatLogic.Stats.RangedHitRating] = { "índice de golpe a distancia" },
	[StatLogic.Stats.SpellHitRating] = { "índice de golpe con hechizo" },
	[StatLogic.Stats.HitRating] = { "índice de golpe", "golpe" },

	[StatLogic.Stats.ResilienceRating] = { "índice de temple", "temple jcj" },
	[StatLogic.Stats.PvpPowerRating] = { ITEM_MOD_PVP_POWER_SHORT:lower() },

	[StatLogic.Stats.MeleeHasteRating] = { "índice de celeridad con cuerpo a cuerpo", "índice de velocidad de lanzamiento de ataques", "celeridad" },
	[StatLogic.Stats.RangedHasteRating] = { "índice de celeridad a distancia" },
	[StatLogic.Stats.SpellHasteRating] = { "índice de celeridad con hechizos" },
	[StatLogic.Stats.HasteRating] = { "índice de velocidad de lanzamiento de ataques", "celeridad" },

	[StatLogic.Stats.ExpertiseRating] = { "índice de pericia", "pericia" },

	[StatLogic.Stats.AllStats] = { SPELL_STATALL:lower() },

	[StatLogic.Stats.ArmorPenetrationRating] = { "índice de penetración de armadura" },
	[StatLogic.Stats.MasteryRating] = { "maestría" },
	[StatLogic.Stats.Armor] = { ARMOR:lower() },
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["numberSuffix"] = " p%."
L["Show %s"] = SHOW.." %s"
L["Show Modified %s"] = "Show Modified %s"
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

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

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
L[StatLogic.Stats.BonusArmor] = "Armadura"

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
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "Daño recib"

L[StatLogic.Stats.FireResistance] = "Resist. Fuego"
L[StatLogic.Stats.NatureResistance] = "Resist. Naturaleza"
L[StatLogic.Stats.FrostResistance] = "Resist. Frio"
L[StatLogic.Stats.ShadowResistance] = "Resist. Sombras"
L[StatLogic.Stats.ArcaneResistance] = "Resist. Arcana"