-- esES localization by Zendor@Mandokir
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "esES")
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = function(s)
	local n = tonumber(s)
	if n then
		return n
	else
		return tonumber((s:gsub(",", "%.")))
	end
end
-------------------
-- Prefix Exclude --
-------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
L["PrefixExcludeLength"] = 5 -- using string.utf8len
L["PrefixExclude"] = {}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["Aceite de zahorí menor"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["Aceite de zahorí inferior"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["Aceite de zahorí"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["Aceite de zahorí luminoso"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["Aceite de zahorí excelente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522

	["Aceite de maná menor"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Aceite de maná inferior"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Aceite de maná luminoso"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Aceite de maná excelente"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Salvajismo"] = {["AP"] = 70}, --
	["vitalidad"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality spell: 27948
	["escarcha de alma"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["fuego solar"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["Velocidad de carrera aumentada ligeramente"] = false, --
	["Aumento mínimo de velocidad"] = false, -- Enchant Boots - Minor Speed "Minor Speed Increase" spell: 13890
	["velocidad mín."] = false, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" spell: 34007
	["Pies de plomo"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" spell: 27954

	["Equipar: Permite respirar bajo el agua."] = false, -- [Band of Icy Depths] ID: 21526
	["Permite respirar bajo el agua"] = false, --
	["Equipar: Inmune a la desactivación."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Inmune a la desactivación"] = false, --
	["Cruzado"] = false, -- Enchant Crusader
	["Robo de vida"] = false, -- Enchant Crusader
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
-- +19 ?? = "^%+(%d+) (.-)$"
--["SinglePlusStatCheck"] = "^%+(%d+) ([%a ]+%a)$",
L["SinglePlusStatCheck"] = "^%+(%d+) (.-)$"
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) (.-)%.?$"
-- Stamina +19 = "^(.-) %+(%d+)%.?$"
-- +19 耐力 = "^%+(%d+) (.-)%.?$"
-- +19 Ausdauer = "^%+(%d+) (.-)%.?$" (deDE :))
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
L["SingleEquipStatCheck"] = "^" .. ITEM_SPELL_TRIGGER_ONEQUIP .. " (.-) ?e?n? ?u?n? ?(%d+) ?p?(.-)$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	["^(%d+) bloqueo$"] = "BLOCK_VALUE",
	["^(%d+) armadura$"] = "ARMOR",
	["Reforzado %(%+(%d+)  armadura%)"] = "ARMOR_BUFF",
	["regen. de maná (%d+) p. cada 5 s%.$"] = "MANA_REG",
	["Restaura (%d+) p. de maná cada 5 s%.?$"]= "MANA_REG",
	["Restaura (%d+) p. de maná cada 5 s de todos los miembros del grupo que estén a 30 m%.?$"]= "MANA_REG",
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	["Da la posibilidad"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["A veces"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Aa]l recibir un golpe en combate"] = false, -- [Essence of the Pure Flame] ID: 18815
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "Equipar: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "Bono de ranura: " -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" y ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
}
L["DeepScanWordSeparators"] = {
	" y ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
-- all lower case
L["DualStatPatterns"] = {
	["^%+(%d+) sanación y %+(%d+) daño con hechizos$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^%+(%d+) sanación %+(%d+) daño con hechizos$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["Aumenta la sanación que haces hasta (%d+) y el daño que infliges hasta (%d+) con todos los hechizos mágicos y efectos.$"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-) ?hasta ?e?n? ?(%d+) ?p?.?(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-)5 [Ss]eg%. (%d+) (.-)$",  -- "xxx 5 Sek. 8 xxx" (scan 2nd)
	"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 3rd)
	"^(.-) ?([%d%,]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Tus ataques ignorande la armadura de tu oponente"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["Daño de arma"] = {"MELEE_DMG"}, -- Enchant

	["Todas las Estadísticas."] = {StatLogic.Stats.AllStats,},
	["Fuerza"] = {StatLogic.Stats.Strength,},
	["Agilidad"] = {StatLogic.Stats.Agility,},
	["Aguante"] = {StatLogic.Stats.Stamina,},
	["Intelecto"] = {StatLogic.Stats.Intellect,},
	["Espíritu"] = {StatLogic.Stats.Spirit,},

	["Resistencia a lo Arcano"] = {"ARCANE_RES",},
	["Resistencia al Fuego"] = {"FIRE_RES",},
	["Resistencia a la Naturaleza"] = {"NATURE_RES",},
	["Resistencia a la Escarcha"] = {"FROST_RES",},
	["Resistencia a las Sombras"] = {"SHADOW_RES",},
	["resist. Arcana"] = {"ARCANE_RES",}, -- Arcane Armor Kit +8 Arcane Resist
	["resist. al Fuego"] = {"FIRE_RES",}, -- Flame Armor Kit +8 Fire Resist
	["resist. a la Naturaleza"] = {"NATURE_RES",}, -- Frost Armor Kit +8 Frost Resist
	["resist. a la Escarcha"] = {"FROST_RES",}, -- Nature Armor Kit +8 Nature Resist
	["resist. a las Sombras"] = {"SHADOW_RES",}, -- Shadow Armor Kit +8 Shadow Resist
	["resistencia a las Sombras"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
	["todas las resistencias"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["resistencia a todo"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	["Pesca"] = false, -- Fishing enchant ID:846
	["Habilidad en pesca"] = false, -- Fishing lure
	["Pesca aumentada"] = false, -- Equip: Increased Fishing +20.
	["minería"] = false, -- Mining enchant ID:844
	["herboristería"] = false, -- Heabalism enchant ID:845
	["desuello"] = false, -- Skinning enchant ID:865

	["Armadura"] = {"ARMOR_BONUS",},
	["Defensa"] = {StatLogic.Stats.Defense,},
	["Defensa aumentada"] = {StatLogic.Stats.Defense,},
	["Bloqueo"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Valor de bloqueo"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Valor de bloqueo de escudo"] = {"BLOCK_VALUE",}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
	["Aumenta el valor de bloqueo de tu escudo"] = {"BLOCK_VALUE",},

	["Salud"] = {"HEALTH",},
	["PS"] = {"HEALTH",},
	["Mana"] = {"MANA",},

	["Poder de ataque"] = {"AP",},
	["Aumenta el poder de ataque"] = {"AP",},
	["Poder de ataque bajo formas felinas"] = {"FERAL_AP",},
	["Aumenta enel poder de ataque bajo formas felinas"] = {"FERAL_AP",},
	["Poder de ataque a distancia"] = {"RANGED_AP",},
	["Aumenta enel poder de ataque a distancia"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["Salud cada"] = {"HEALTH_REG",},
	["salud cada"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
	["la regeneración de salud normal"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
	["Restaurade salud cada 5 s."] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
	["de Maná cada"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
	["regen. de maná"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells spell: 24167
	["de maná cada"] = {"MANA_REG",},
	["de Maná cada 5 s"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
	["de maná cada 5 s"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." spell: 33991
	["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["Restaurade maná cada 5 s"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
	["maná recuperado cada 5 s"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds spell: 32399
	["regen. de manácada 5 s"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." spell: 23801
	["maná cada 5 s"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." spell: 27913

	["penetración del hechizo"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" spell: 34003
	["Aumenta la penetración de tus hechizos"] = {"SPELLPEN",},

	["sanación y daño con hechizos"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
	["Daño y hechizo de sanación"] = {"SPELL_DMG", "HEAL",},
	["Daño con hechizos y sanación"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["Daño con hechizos"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Aumenta el daño y la sanación de los hechizos mágicos y los efectos hasta"] = {"SPELL_DMG", "HEAL"},
	["Aumenta hasta el daño y la sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m."] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["Daño"] = {"SPELL_DMG",},
	["Aumenta el daño con hechizos"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Poder con hechizos"] = {"SPELL_DMG", "HEAL",},
	["Aumenta el poder con hechizos"] = {"SPELL_DMG", "HEAL",},
	["Daño Sagrado"] = {"HOLY_SPELL_DMG",},
	["Daño Arcano"] = {"ARCANE_SPELL_DMG",},
	["Daño de Fuego"] = {"FIRE_SPELL_DMG",},
	["Daño de Naturaleza"] = {"NATURE_SPELL_DMG",},
	["Daño de Escarcha"] = {"FROST_SPELL_DMG",},
	["Daño de Sombras"] = {"SHADOW_SPELL_DMG",},
	["Daño con Hechizos Sagrado"] = {"HOLY_SPELL_DMG",},
	["Daño con Hechizos Arcano"] = {"ARCANE_SPELL_DMG",},
	["Daño con Hechizos de Fuego"] = {"FIRE_SPELL_DMG",},
	["Daño con Hechizos de Naturaleza"] = {"NATURE_SPELL_DMG",},
	["Daño con Hechizos de Escarcha"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Daño con Hechizos de las Sombras"] = {"SHADOW_SPELL_DMG",},
	["Aumenta el daño causado por los hechizos de las Sombras y los efectos hasta"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["Aumenta el daño causado por los hechizos de Escarcha y los efectos hasta"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["Aumenta el daño causado por los hechizos Sagrados y los efectos hasta"] = {"HOLY_SPELL_DMG",},
	["Aumenta el daño causado por los hechizos Arcanos y los efectos hasta"] = {"ARCANE_SPELL_DMG",},
	["Aumenta el daño causado por los hechizos de Fuego y los efectos hasta"] = {"FIRE_SPELL_DMG",},
	["Aumenta el daño causado por los hechizos de Naturaleza y los efectos hasta"] = {"NATURE_SPELL_DMG",},
	["Aumenta el daño infligido por hechizos y efectos Sagrados"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
	["Aumenta el daño infligido por hechizos y efectos Arcanos"] = {"ARCANE_SPELL_DMG",}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Fuego"] = {"FIRE_SPELL_DMG",}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Escarcha"] = {"FROST_SPELL_DMG",}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Naturaleza"] = {"NATURE_SPELL_DMG",}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de las Sombras"] = {"SHADOW_SPELL_DMG",}, -- Added just in case

	["hechizos de sanación"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
	["aumentar la sanación"] = {"HEAL",},
	["Sanación"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
	["Hechizos de sanación"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	["Aumenta la sanación que haces"] = {"HEAL",}, -- 2.3.0
	["daño que infligescon todos los hechizos mágicos"] = {"SPELL_DMG",}, -- 2.3.0
	["Aumenta la sanación que hacescon todos los hechizos mágicos y efectos."] = {"HEAL",},
	["Aumentala sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m"] = {"HEAL",}, -- Atiesh
	--["your healing"] = {"HEAL",}, -- Atiesh

	["daño por segundo"] = {"DPS",},
	["Añadedaño por segundo"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["índice de defensa"] = {StatLogic.Stats.DefenseRating,},
	["Aumenta el índice de defensa"] = {StatLogic.Stats.DefenseRating,},
	["índice de esquivar"] = {StatLogic.Stats.DodgeRating,},
	["Aumenta tu índice de esquivar"] = {StatLogic.Stats.DodgeRating,},
	["índice de parada"] = {StatLogic.Stats.ParryRating,},
	["Aumenta tu índice de parada"] = {StatLogic.Stats.ParryRating,},
	["índice de bloqueo con escudo"] = {StatLogic.Stats.BlockRating,}, -- Enchant Shield - Lesser Block +10 Shield Block Rating spell: 13689
	["índice de bloqueo"] = {StatLogic.Stats.BlockRating,},
	["Aumenta tu índice de bloqueo"] = {StatLogic.Stats.BlockRating,},
	["Aumenta tu índice de bloqueo con escudo"] = {StatLogic.Stats.BlockRating,},

	["Mejora tu probabilidad de alcanzar el objetivo%"] = {"MELEE_HIT", "RANGED_HIT"},
	["Aumenta% tu probabilidad de golpear con hechizos, ataques cuerpo a cuerpo y ataques a distancia."] = {"MELEE_HIT", "RANGED_HIT", "SPELL_HIT"},
	["índice de golpe"] = {StatLogic.Stats.HitRating,},
	["Aumenta tu índice de golpe"] = {StatLogic.Stats.HitRating,},
	["Mejora el índice de golpe"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["Mejora el índice de golpe cuerpo a cuerpo"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["golpe con hechizo"] = {StatLogic.Stats.SpellHitRating,}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit spell: 24164
	["Mejora tu probabilidad de alcanzar el objetivo con hechizos%"] = {"SPELL_HIT"},
	["índice de golpe con hechizos"] = {StatLogic.Stats.SpellHitRating,},
	["Mejora el índice de golpe con hechizos"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["Aumenta tu índice de golpe con hechizos"] = {StatLogic.Stats.SpellHitRating,},
	["Índice de golpe a distancia"] = {StatLogic.Stats.RangedHitRating,},
	["Mejora el índice de golpe a distancia"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["Aumneta tu índice de golpe a distancia"] = {StatLogic.Stats.RangedHitRating,},

	["Mejora tu probabilidad de conseguir un golpe crítico en%"] = {StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit},
	["índice de golpe crítico"] = {StatLogic.Stats.CritRating,},
	["Aumenta tu índice de golpe crítico"] = {StatLogic.Stats.CritRating,},
	["Mejora el índice de golpe crítico"] = {StatLogic.Stats.CritRating,},
	["Mejora el índice de golpe crítico cuerpo a cuerpo"] = {StatLogic.Stats.MeleeCritRating,}, -- [Cloak of Darkness] ID:33122
	["Mejora tu probabilidad de conseguir un golpe crítico en % con los hechizos"] = {StatLogic.Stats.SpellCrit},
	["índice de golpe crítico con hechizos"] = {StatLogic.Stats.SpellCritRating,},
	["Índice de golpe crítico con hechizos"] = {StatLogic.Stats.SpellCritRating,},
	--["Spell Critical Rating"] = {StatLogic.Stats.SpellCritRating,},
	--["Spell Crit Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Aumenta tu índice de golpe crítico con hechizos"] = {StatLogic.Stats.SpellCritRating,},
	["Aumenta el índice de golpe crítico con hechizos de todos los miembros del grupo a 30 m."] = {StatLogic.Stats.SpellCritRating,},
	["Aumenta tu índice de golpe crítico a distancia"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348

	["temple"] = {StatLogic.Stats.ResilienceRating,},
	["índice de temple"] = {StatLogic.Stats.ResilienceRating,}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" spell: 33992
	["Mejora tu índice de temple"] = {StatLogic.Stats.ResilienceRating,},

	["índice de celeridad"] = {StatLogic.Stats.MeleeHasteRating},
	["Mejora el índice de celeridad"] = {StatLogic.Stats.HasteRating},
	["Aumenta el índice de celeridad"] = {StatLogic.Stats.HasteRating},
	["Aumenta tu índice de celeridad"] = {StatLogic.Stats.HasteRating},
	["índice de celeridad con cuerpo a cuerpo"] = {StatLogic.Stats.MeleeHasteRating},
	["índice de celeridad con hechizos"] = {StatLogic.Stats.SpellHasteRating},
	["índice de celeridad a distancia"] = {StatLogic.Stats.RangedHasteRating},
	["Aumenta el índice de celeridad cuerpo a cuerpo"] = {StatLogic.Stats.MeleeHasteRating},
	["Aumenta tu índice de celeridad cuerpo a cuerpo"] = {StatLogic.Stats.MeleeHasteRating},
	["Mejora el índice de celeridad con hechizos"] = {StatLogic.Stats.SpellHasteRating},
	["Aumenta tu índice de celeridad de hechizo"] = {StatLogic.Stats.SpellHasteRating},
	--["Improves ranged haste rating"] = {StatLogic.Stats.RangedHasteRating},

	["Aumenta tu índice de pericia"] = {StatLogic.Stats.ExpertiseRating},
	["tu índice de pericia"] = {StatLogic.Stats.ExpertiseRating},
	["el índice de pericia"] = {StatLogic.Stats.ExpertiseRating},
	["índice de penetración de armadura"] = {StatLogic.Stats.ArmorPenetrationRating}, -- gems
	["Aumenta tu índice de penetración de armadurap"] = {StatLogic.Stats.ArmorPenetrationRating}, -- ID:43178

		-- Exclude
	["seg"] = false,
	["para"] = false,
	["casillas"] = false,
	["Carcaj"] = false,
	["Aumenta la velocidad de ataque"] = false, -- AV quiver
}