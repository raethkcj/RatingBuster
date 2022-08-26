-- esES localization by Zendor@Mandokir
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "esES")
if not L then return end

L["tonumber"] = function(s)
	local n = tonumber(s)
	if n then
		return n
	else
		return tonumber((gsub(s, ",", "%.")))
	end
end
-------------------
-- Fast Exclude --
-------------------
-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
L["ExcludeLen"] = 5 -- using string.utf8len
L["Exclude"] = {
	[""] = true,
	[" \n"] = true,
	[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
	[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
	[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
	[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
	[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
	["Desen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
	["Durac"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
	["<Hech"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
	["Tiemp"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
	["Único"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
	["Neces"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
	["\nNece"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
	["Clase"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
	["Razas"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
	["Uso: "] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
	["Proba"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
	-- Set Bonuses
	-- ITEM_SET_BONUS = "Set: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["Conju"] = true,
	["(2) C"] = true,
	["(3) C"] = true,
	["(4) C"] = true,
	["(5) C"] = true,
	["(6) C"] = true,
	["(7) C"] = true,
	["(8) C"] = true,
	-- Equip type
	[GetItemClassInfo(Enum.ItemClass.Projectile)] = true, -- Ice Threaded Arrow ID:19316
	[INVTYPE_AMMO] = true,
	[INVTYPE_HEAD] = true,
	[INVTYPE_NECK] = true,
	[INVTYPE_SHOULDER] = true,
	[INVTYPE_BODY] = true,
	[INVTYPE_CHEST] = true,
	[INVTYPE_ROBE] = true,
	[INVTYPE_WAIST] = true,
	[INVTYPE_LEGS] = true,
	[INVTYPE_FEET] = true,
	[INVTYPE_WRIST] = true,
	[INVTYPE_HAND] = true,
	[INVTYPE_FINGER] = true,
	[INVTYPE_TRINKET] = true,
	[INVTYPE_CLOAK] = true,
	[INVTYPE_WEAPON] = true,
	[INVTYPE_SHIELD] = true,
	[INVTYPE_2HWEAPON] = true,
	[INVTYPE_WEAPONMAINHAND] = true,
	[INVTYPE_WEAPONOFFHAND] = true,
	[INVTYPE_HOLDABLE] = true,
	[INVTYPE_RANGED] = true,
	[GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown)] = true,
	[INVTYPE_RELIC] = true,
	[INVTYPE_TABARD] = true,
	[INVTYPE_BAG] = true,
}
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
	["Aceite de zahorí luminoso"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
	["Aceite de zahorí excelente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
	["Aceite de zahorí bendito"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["Aceite de maná menor"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Aceite de maná inferior"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Aceite de maná luminoso"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Aceite de maná excelente"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Sedal de eternio"] = {["FISHING"] = 5}, --
	["Salvajismo"] = {["AP"] = 70}, --
	["vitalidad"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
	["escarcha de alma"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["fuego solar"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["+4% Mount Speed"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["+2% velocidad de la montura"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["Equipar: Velocidad de carrera aumentada ligeramente."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["Velocidad de carrera aumentada ligeramente"] = {["RUN_SPEED"] = 8}, --
	["Aumento mínimo de velocidad"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["velocidad mín."] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["Pies de plomo"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Sutileza"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["2% amenaza reducida"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
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
-- stat1, value, stat2 = strfind
-- stat = stat1..stat2
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
L["SingleEquipStatCheck"] = "^Equipar: (.-) ?e?n? ?(%d+) ?p?(.-)"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+) bloqueo$"] = "BLOCK_VALUE",
	["^(%d+) armadura$"] = "ARMOR",
	["Reforzado %(%+(%d+)  armadura%)"] = "ARMOR_BUFF",
	["regen. de maná (%d+) p. cada 5 s%.$"] = "MANA_REG",
	["Restaura (%d+) p. de maná cada 5 s%.?$"]= "MANA_REG",
	["Restaura (%d+) p. de maná cada 5 s de todos los miembros del grupo que estén a 30 m%.?$"]= "MANA_REG",
	["^%+?%d+ %- (%d+) .-[Dd]año$"] = "MAX_DAMAGE",
	["^%(([%d%,]+) daño por segundo%)$"] = "DPS",
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
	["% Amenaza"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["Aumenta tu nivel efectivo de sigilo en"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["Daño de arma"] = {"MELEE_DMG"}, -- Enchant
	["Aumenta la velocidad de la montura%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["Todas las Estadísticas."] = {"STR", "AGI", "STA", "INT", "SPI",},
	["Fuerza"] = {"STR",},
	["Agilidad"] = {"AGI",},
	["Aguante"] = {"STA",},
	["Intelecto"] = {"INT",},
	["Espíritu"] = {"SPI",},

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

	["Pesca"] = {"FISHING",}, -- Fishing enchant ID:846
	["Habilidad en pesca"] = {"FISHING",}, -- Fishing lure
	["Pesca aumentada"] = {"FISHING",}, -- Equip: Increased Fishing +20.
	["minería"] = {"MINING",}, -- Mining enchant ID:844
	["herboristería"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["desuello"] = {"SKINNING",}, -- Skinning enchant ID:865

	["Armadura"] = {"ARMOR_BONUS",},
	["Defensa"] = {"DEFENSE",},
	["Defensa aumentada"] = {"DEFENSE",},
	["Bloqueo"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Valor de bloqueo"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["Valor de bloqueo de escudo"] = {"BLOCK_VALUE",}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
	["Aumenta el valor de bloqueo de tu escudo"] = {"BLOCK_VALUE",},

	["Salud"] = {"HEALTH",},
	["PS"] = {"HEALTH",},
	["Mana"] = {"MANA",},

	["Poder de ataque"] = {"AP",},
	["Aumenta el poder de ataque"] = {"AP",},
	["poder de ataque al enfrentarte a no-muertos."] = {"AP_UNDEAD",},
	-- [Wristwraps of Undead Slaying] ID:23093
	["Aumenta enel poder de ataque al enfrentarte a no-muertos"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["Aumenta enel poder de ataque al enfrentarte a no-muertos. También permite conseguir Piedras de la Plaga en nombre de El Alba Argenta"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["Aumenta enel poder de ataque al enfrentarte a demonios"] = {"AP_DEMON",},
	["Aumenta enel poder de ataque al enfrentarte a no-muertos y demonios"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
	["Poder de ataque bajo formas felinas"] = {"FERAL_AP",},
	["Aumenta enel poder de ataque bajo formas felinas"] = {"FERAL_AP",},
	["Poder de ataque a distancia"] = {"RANGED_AP",},
	["Aumenta enel poder de ataque a distancia"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	
	["Salud cada"] = {"HEALTH_REG",},
	["salud cada"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
	["la regeneración de salud normal"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
	["Restaurade salud cada 5 s."] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
	["de Maná cada"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
	["regen. de maná"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
	["de maná cada"] = {"MANA_REG",}, 
	["de Maná cada 5 s"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
	["de maná cada 5 s"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
	["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["Restaurade maná cada 5 s"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
	["maná recuperado cada 5 s"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
	["regen. de manácada 5 s"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
	["maná cada 5 s"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913

	["penetración del hechizo"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
	["Aumenta la penetración de tus hechizos"] = {"SPELLPEN",},

	["sanación y daño con hechizos"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
	["Daño y hechizo de sanación"] = {"SPELL_DMG", "HEAL",},
	["Daño con hechizos y sanación"] = {"SPELL_DMG", "HEAL",},
	["Daño con hechizos"] = {"SPELL_DMG", "HEAL",},
	["Aumenta el daño y la sanación de los hechizos mágicos y los efectos hasta"] = {"SPELL_DMG", "HEAL"},
	["Aumenta hasta el daño y la sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m."] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["Daño con hechizos y sanación"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
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

	["Aumenta el daño infligido a los no-muertos mediante hechizos mágicos y los efectos hasta"] = {"SPELL_DMG_UNDEAD"}, -- [Robe of Undead Cleansing] ID:23085
	["Aumenta el daño infligido a los no-muertos mediante hechizos mágicos y los efectos hasta. También permite conseguir piedras de la Plaga en nombre de El Alba Argenta"] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
	["Aumenta el daño infligido a los no-muertos y demonios mediante hechizos mágicos y los efectos hasta"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

	["hechizos de sanación"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
	["aumentar la sanación"] = {"HEAL",},
	["Sanación"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
	["hechizos de sanación"] = {"HEAL",},
	["Daño con hechizos"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Hechizos de sanación"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	["Aumenta la sanación que haces"] = {"HEAL",}, -- 2.3.0
	["daño que infligescon todos los hechizos mágicos"] = {"SPELL_DMG",}, -- 2.3.0
	["Aumenta la sanación que hacescon todos los hechizos mágicos y efectos."] = {"HEAL",},
	["Aumentala sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m"] = {"HEAL",}, -- Atiesh
	--["your healing"] = {"HEAL",}, -- Atiesh

	["daño por segundo"] = {"DPS",},
	["Añadedaño por segundo"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["índice de defensa"] = {"DEFENSE_RATING",},
	["Aumenta el índice de defensa"] = {"DEFENSE_RATING",},
	["índice de esquivar"] = {"DODGE_RATING",},
	["Aumenta tu índice de esquivar"] = {"DODGE_RATING",},
	["índice de parada"] = {"PARRY_RATING",},
	["Aumenta tu índice de parada"] = {"PARRY_RATING",},
	["índice de bloqueo con escudo"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["índice de bloqueo"] = {"BLOCK_RATING",},
	["Aumenta tu índice de bloqueo"] = {"BLOCK_RATING",},
	["Aumenta tu índice de bloqueo con escudo"] = {"BLOCK_RATING",},

	["Mejora tu probabilidad de alcanzar el objetivo%"] = {"MELEE_HIT", "RANGED_HIT"},
	["índice de golpe"] = {"HIT_RATING",},
	["Aumenta tu índice de golpe"] = {"HIT_RATING",},
	["Mejora el índice de golpe"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_RATING
	["Mejora el índice de golpe cuerpo a cuerpo"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
	["golpe con hechizo"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
	["Mejora tu probabilidad de alcanzar el objetivo con hechizos%"] = {"SPELL_HIT"},
	["índice de golpe con hechizos"] = {"SPELL_HIT_RATING",},
	["Mejora el índice de golpe con hechizos"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
	["Aumenta tu índice de golpe con hechizos"] = {"SPELL_HIT_RATING",},
	["Índice de golpe a distancia"] = {"RANGED_HIT_RATING",},
	["Mejora el índice de golpe a distancia"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
	["Aumneta tu índice de golpe a distancia"] = {"RANGED_HIT_RATING",},

	["Mejora tu probabilidad de conseguir un golpe crítico en%"] = {"MELEE_CRIT", "RANGED_CRIT"},
	["índice de golpe crítico"] = {"CRIT_RATING",},
	["Aumenta tu índice de golpe crítico"] = {"CRIT_RATING",},
	["Mejora el índice de golpe crítico"] = {"CRIT_RATING",},
	["Mejora el índice de golpe crítico cuerpo a cuerpo"] = {"MELEE_CRIT_RATING",}, -- [Cloak of Darkness] ID:33122
	["Mejora tu probabilidad de conseguir un golpe crítico en % con los hechizos"] = {"SPELL_CRIT"},
	["índice de golpe crítico con hechizos"] = {"SPELL_CRIT_RATING",},
	["Índice de golpe crítico con hechizos"] = {"SPELL_CRIT_RATING",},
	--["Spell Critical Rating"] = {"SPELL_CRIT_RATING",},
	--["Spell Crit Rating"] = {"SPELL_CRIT_RATING",},
	["Aumenta tu índice de golpe crítico con hechizos"] = {"SPELL_CRIT_RATING",},
	["Aumenta el índice de golpe crítico con hechizos de todos los miembros del grupo a 30 m."] = {"SPELL_CRIT_RATING",},
	["Mejora el índice de golpe con hechizos"] = {"SPELL_CRIT_RATING",},
	["Aumenta tu índice de golpe crítico a distancia"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

	["temple"] = {"RESILIENCE_RATING",},
	["índice de temple"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
	["Mejora tu índice de temple"] = {"RESILIENCE_RATING",},

	["índice de celeridad"] = {"MELEE_HASTE_RATING"},
	["Mejora el índice de celeridad"] = {"HASTE_RATING"},
	["Aumenta el índice de celeridad"] = {"HASTE_RATING"},
	["Aumenta tu índice de celeridad"] = {"HASTE_RATING"},
	["índice de celeridad con cuerpo a cuerpo"] = {"MELEE_HASTE_RATING"},
	["índice de celeridad con hechizos"] = {"SPELL_HASTE_RATING"},
	["índice de celeridad a distancia"] = {"RANGED_HASTE_RATING"},
	["Aumenta el índice de celeridad cuerpo a cuerpo"] = {"MELEE_HASTE_RATING"},
	["Aumenta tu índice de celeridad cuerpo a cuerpo"] = {"MELEE_HASTE_RATING"},
	["Mejora el índice de celeridad con hechizos"] = {"SPELL_HASTE_RATING"},
	["Aumenta tu índice de celeridad de hechizo"] = {"SPELL_HASTE_RATING"},
	--["Improves ranged haste rating"] = {"RANGED_HASTE_RATING"},

	["Dagas aumentadas"] = {"DAGGER_WEAPON_RATING"},
	["Espadas aumentadas"] = {"SWORD_WEAPON_RATING"}, -- [Warblade of the Hakkari] ID:19865
	["Espadas de dos manos aumentadas"] = {"2H_SWORD_WEAPON_RATING"},
	["Hachas aumentadas"] = {"AXE_WEAPON_RATING"},
	["Hachas de dos manos  aumentadas"] = {"2H_AXE_WEAPON_RATING"}, -- [Ethereum Nexus-Reaver] ID:30722
	["Mazas aumentadas"] = {"MACE_WEAPON_RATING"},
	["Mazas de dos manos aumentadas"] = {"2H_MACE_WEAPON_RATING"},
	["Armas de fuego aumentadas"] = {"GUN_WEAPON_RATING"},
	["Aumenta el índice de habilidad con ballestas"] = {"CROSSBOW_WEAPON_RATING"},
	["Ballestas aumentadas"] = {"CROSSBOW_WEAPON_RATING"},
	["Arcos aumentados"] = {"BOW_WEAPON_RATING"},
	["Combate felino aumentado"] = {"FERAL_WEAPON_RATING"},
	["Armas de puño aumentadas"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
	["Sin armas aumentados"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
	["Maderas curvas aumentadas"] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410

	["Aumenta tu índice de pericia"] = {"EXPERTISE_RATING"},
	["tu índice de pericia"] = {"EXPERTISE_RATING"},
	["el índice de pericia"] = {"EXPERTISE_RATING"},
	["índice de penetración de armadura"] = {"ARMOR_PENETRATION_RATING"}, -- gems
	["Aumenta tu índice de penetración de armadurap"] = {"ARMOR_PENETRATION_RATING"}, -- ID:43178

		-- Exclude
	["seg"] = false,
	["para"] = false,
	["casillas"] = false,
	["Carcaj"] = false,
	["Aumenta la velocidad de ataque"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "esES")
----------------
-- Stat Names --
----------------
-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
-- localization effect when a locale is not available for that language, you don't have to use global
-- strings in your localization.

-- NOTE I left many of the english terms because german players tend to use them and germans are much tooo long
D["StatIDToName"] = {
	--[StatID] = {FullName, ShortName},
	---------------------------------------------------------------------------
	-- Tier1 Stats - Stats parsed directly off items
	["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
	["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";

	["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
	["THREAT_MOD"] = {"Threat(%)", "Threat(%)"},
	["STEALTH_LEVEL"] = {"Stealth Level", "Stealth"},
	["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
	["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
	["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

	["STR"] = {SPELL_STAT1_NAME, "Str"},
	["AGI"] = {SPELL_STAT2_NAME, "Agi"},
	["STA"] = {SPELL_STAT3_NAME, "Sta"},
	["INT"] = {SPELL_STAT4_NAME, "Int"},
	["SPI"] = {SPELL_STAT5_NAME, "Spi"},
	["ARMOR"] = {ARMOR, ARMOR},
	["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

	["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
	["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
	["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
	["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
	["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

	["FISHING"] = {"Fishing", "Fishing"},
	["MINING"] = {"Mining", "Mining"},
	["HERBALISM"] = {"Herbalism", "Herbalism"},
	["SKINNING"] = {"Skinning", "Skinning"},

	["BLOCK_VALUE"] = {"Block Value", "Block Value"},

	["AP"] = {ATTACK_POWER_TOOLTIP, "AP"},
	["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
	["FERAL_AP"] = {"Feral "..ATTACK_POWER_TOOLTIP, "Feral AP"},
	["AP_UNDEAD"] = {ATTACK_POWER_TOOLTIP.." (Undead)", "AP(Undead)"},
	["AP_DEMON"] = {ATTACK_POWER_TOOLTIP.." (Demon)", "AP(Demon)"},

	["HEAL"] = {"Healing", "Heal"},

	["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
	["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Undead)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
	["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (Demon)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
	["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
	["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
	["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
	["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
	["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
	["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

	["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

	["HEALTH"] = {HEALTH, HP},
	["MANA"] = {MANA, MP},
	["HEALTH_REG"] = {HEALTH.." Regen", "HP5"},
	["MANA_REG"] = {MANA.." Regen", "MP5"},

	["MAX_DAMAGE"] = {"Max Damage", "Max Dmg"},
	["DPS"] = {"Damage Per Second", "DPS"},

	["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
	["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
	["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
	["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
	["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
	["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
	["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
	["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
	["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
	["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
	["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
	["MELEE_HASTE_RATING"] = {"Haste "..RATING, "Haste "..RATING}, --
	["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
	["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
	["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
	["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
	["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
	["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
	["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
	["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
	["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
	["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
	["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
	["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
	["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
	["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},
	["STAFF_WEAPON_RATING"] = {"Staff "..SKILL.." "..RATING, "Staff "..RATING}, -- Leggings of the Fang ID:10410
	["EXPERTISE_RATING"] = {"Pericia".." "..RATING, "Pericia".." "..RATING},
	["ARMOR_PENETRATION_RATING"] = {"Penetración de Armadura".." "..RATING, "ArP".." "..RATING},

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." Regen (Out of combat)", "HP5(OC)"},
	["MANA_REG_NOT_CASTING"] = {MANA.." Regen (Not casting)", "MP5(NC)"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"Crit Damage Reduction(%)", "Crit Dmg Reduc(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage Reduction(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
	["DEFENSE"] = {DEFENSE, "Def"},
	["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
	["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
	["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
	["AVOIDANCE"] = {"Avoidance(%)", "Avoidance(%)"},
	["MELEE_HIT"] = {"Prob. de Golpe(%)", "Golpe(%)"},
	["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." Hit Chance(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
	["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." Hit Chance(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
	["MELEE_HIT_AVOID"] = {"Hit Avoidance(%)", "Hit Avd(%)"},
	["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
	["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
	["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
	["MELEE_CRIT_AVOID"] = {"Crit Avoidance(%)", "Crit Avd(%)"},
	["MELEE_HASTE"] = {"Haste(%)", "Haste(%)"}, --
	["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." Haste(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
	["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." Haste(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
	["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
	["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
	["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
	["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
	["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
	["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
	["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
	["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
	["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
	["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
	["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
	["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},
	["STAFF_WEAPON"] = {"Staff "..SKILL, "Staff"}, -- Leggings of the Fang ID:10410
	["EXPERTISE"] = {"Pericia", "Pericia"},
	["ARMOR_PENETRATION"] = {"Penetr. Armadura(%)", "ArP(%)"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	-- Expertise -> Dodge Neglect, Parry Neglect
	["DODGE_NEGLECT"] = {DODGE.." Neglect(%)", DODGE.." Neglect(%)"},
	["PARRY_NEGLECT"] = {PARRY.." Neglect(%)", PARRY.." Neglect(%)"},
	["BLOCK_NEGLECT"] = {BLOCK.." Neglect(%)", BLOCK.." Neglect(%)"},

	---------------------------------------------------------------------------
	-- Talants
	["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
	["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
	["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

	---------------------------------------------------------------------------
	-- Spell Stats
	-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
	-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
	-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
	-- Use strsplit("@", text) to seperate the spell name and statid
	["THREAT"] = {"Threat", "Threat"},
	["CAST_TIME"] = {"Casting Time", "Cast Time"},
	["MANA_COST"] = {"Mana Cost", "Mana Cost"},
	["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
	["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
	["COOLDOWN"] = {"Cooldown", "CD"},

	---------------------------------------------------------------------------
	-- Stats Mods
	["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
	["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
	["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
	["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
	["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
	["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
	["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
	["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
	["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
	["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
	["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
	["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
	["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
	["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
	["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
	["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
	["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
	["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
	["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
	["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
	["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
	["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
	["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

	---------------------------------------------------------------------------
	-- Misc Stats
	["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
	["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
	["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
	["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
	["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
}
