-- frFR localization by Tixu
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "frFR")
if not L then return end

L["tonumber"] = function(s)
	local n = tonumber(s)
	if n then
		return n
	else
		return tonumber((gsub(s, ",", "%.")))
	end
end
------------------
-- Fast Exclude --
------------------
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
	--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "Meta Socket";
	--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "Red Socket";
	--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
	--["Disen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	--["Durat"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
	["Temps"] = true, -- temps de recharge...
	["<Arti"] = true, -- artisan
	["Uniqu"] = true, -- Unique (20)
	["Nivea"] = true, -- Niveau
	["\nNive"] = true, -- Niveau
	["Class"] = true, -- Classes: xx
	["Races"] = true, -- Races: xx (vendor mounts)
	["Utili"] = true, -- Utiliser:
	["Chanc"] = true, -- Chance de toucher:
	["Requi"] = true, -- Requiert
	["\nRequ"] = true,-- Requiert
	["Néces"] = true,--nécessite plus de gemmes...
	-- Set Bonuses
	["Ensem"] = true,--ensemble
	["(2) E"] = true,
	["(2) E"] = true,
	["(3) E"] = true,
	["(4) E"] = true,
	["(5) E"] = true,
	["(6) E"] = true,
	["(7) E"] = true,
	["(8) E"] = true,
	-- Equip type
	["Proje"] = true, -- Ice Threaded Arrow ID:19316
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
	[INVTYPE_THROWN] = true,
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

	--ToDo
	["Huile de sorcier mineure"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
	["Huile de sorcier inférieure"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
	["Huile de sorcier"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
	["Huile de sorcier brillante"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
	["Huile de sorcier excellente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
	["Huile de sorcier bénite"] = {["SPELL_DMG_UNDEAD"] = 60}, --

	["Huile de mana mineure"] = {["MANA_REG"] = 4}, --
	["Huile de mana inférieure"] = {["MANA_REG"] = 8}, --
	["Huile de mana brillante"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --
	["Huile de mana excellente"] = {["MANA_REG"] = 14}, --

	["Eternium Line"] = {["FISHING"] = 5}, --
	["Feu solaire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --
	["Augmentation mineure de la vitesse de la monture"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["Pied sûr"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Equip: Allows underwater breathing."] = false, -- [Band of Icy Depths] ID: 21526
	["Allows underwater breathing"] = false, --
	["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Immune to Disarm"] = false, --
	["Lifestealing"] = false, -- Enchant Crusader

	--translated
	["Eperons en mithril"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["Équipé\194\160: La vitesse de course augmente légèrement."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["La vitesse de course augmente légèrement"] = {["RUN_SPEED"] = 8}, --
	["Augmentation mineure de vitesse"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["Vitalité"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
	["Âme de givre"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["Sauvagerie"] = {["AP"] = 70}, --
	["Vitesse mineure"] = {["RUN_SPEED"] = 8},
	["Vitesse mineure et +9 en Endurance"] = {["RUN_SPEED"] = 8, ["STA"] = 9},--enchant

	["Croisé"] = false, -- Enchant Crusader
	["Mangouste"] = false, -- Enchant Mangouste
	["Arme impie"] = false,
	["Équipé : Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, --cape Onyxia
}
----------------------------
-- Single Plus Stat Check --
----------------------------
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
L["SingleEquipStatCheck"] = "^Équipé\194\160: Augmente (.-) ?de (%d+) ?a?u? ?m?a?x?i?m?u?m? ?(.-)%.?$"

-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	["Bloquer.- (%d+)"] = "BLOCK_VALUE",
	["Armure.- (%d+)"] = "ARMOR",
	["^Équipé\194\160: Rend (%d+) points de vie toutes les 5 seco?n?d?e?s?%.?$"]= "HEAL_REG",
	["^Équipé\194\160: Rend (%d+) points de mana toutes les 5 seco?n?d?e?s?%.?$"]= "MANA_REG",
	["Renforcé %(%+(%d+) Armure%)"]= "ARMOR_BONUS",
	["Lunette %(%+(%d+) points? de dégâts?%)"]="RANGED_AP",
	["^Dégâts : %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
	["^%(([%d%,]+) dégâts par seconde%)$"] = "DPS",

	-- Exclude
	["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	--["Confère une chance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["Rend parfois"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["Vous gagnez une"] = false, -- condensateur de foudre
	["Dégâts:"] = false, -- ligne de degats des armes
	["Votre technique"] = false,
	["^%+?%d+ %- %d+ points de dégâts %(.-%)$"]= false, -- ligne de degats des baguettes/ +degats (Thunderfury)
	["Permettent au porteur"] = false, -- Casques Ombrelunes
	["^.- %(%d+%) requis"] = false, --metier requis pour porter ou utiliser
	["^.- ?[Vv]?o?u?s? [Cc]onfèren?t? .-"] = false, --proc
	["^.- ?l?e?s? ?[Cc]hances .-"] = false, --proc
	["^.- par votre sort .-"] = false, --augmentation de capacité de sort
	["^.- la portée de .-"] = false, --augmentation de capacité de sort
	["^.- la durée de .-"] = false, --augmentation de capacité de sort
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "Équipé\194\160: " --\194\160= espace insécable
L["Socket Bonus: "] = "Bonus de sertissage\194\160: "
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Mort-vivant. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
}
L["DeepScanWordSeparators"] = {
	" et ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
-- all lower case
L["DualStatPatterns"] = {
	["les soins %+(%d+) et les dégâts %+ (%d+)$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["les soins %+(%d+) les dégâts %+ (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
	["soins prodigués d'un maximum de (%d+) et les dégâts d'un maximum de (%d+)"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-) ?([%+%-]%d+) ?(.-)%.?$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
	"^(.-) ?([%d%,]+) ?(.-)%.?$", -- 22.22 xxx xxx (scan last)
	"^.-: (.-)([%+%-]%d+) ?(.-)%.?$", --Bonus de sertissage : +3 xxx
	"^(.-) augmentée?s? de (%d+) ?(.-)%%?%.?$",--sometimes this pattern is needed but not often.
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["votre niveau de camouflage actuel"] = {"STEALTH_LEVEL"},

	--dégats melee
	["aux dégâts des armes"] = {"MELEE_DMG"},
	["aux dégâts de l'arme"] = {"MELEE_DMG"},
	["aux dégâts en mêlée"] = {"MELEE_DMG"},
	["dégâts de l'arme"] = {"MELEE_DMG"},

	--vitesse de course
	["vitesse de monture"]= {"MOUNT_SPEED"},

	--caracteristiques
	["à toutes les caractéristiques"] = {"STR", "AGI", "STA", "INT", "SPI",},
	["force"] = {"STR",},
	["agilité"] = {"AGI",},
	["endurance"] = {"STA",},
	["en endurance"] = {"STA",},
	["intelligence"] = {"INT",},
	["esprit"] = {"SPI",},

	--résistances
	["à la résistance arcanes"] = {"ARCANE_RES",},
	["à la résistance aux arcanes"] = {"ARCANE_RES",},

	["à la résistance feu"] = {"FIRE_RES",},
	["à la résistance au feu"] = {"FIRE_RES",},

	["à la résistance nature"] = {"NATURE_RES",},
	["à la résistance à la nature"] = {"NATURE_RES",},

	["à la résistance givre"] = {"FROST_RES",},
	["à la résistance au givre"] = {"FROST_RES",},

	["à la résistance ombre"] = {"SHADOW_RES",},
	["à la résistance à l'ombre"] = {"SHADOW_RES",},

	["à toutes les résistances"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	--artisanat
	["pêche"] = {"FISHING",},
	["minage"] = {"MINING",},
	["herboristerie"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["dépeçage"] = {"SKINNING",}, -- Skinning enchant ID:865

	--
	["armure"] = {"ARMOR_BONUS",},

	["défense"] = {"DEFENSE",},

	["valeur de blocage"] = {"BLOCK_VALUE",},
	["à la valeur de blocage"] = {"BLOCK_VALUE",},
	["la valeur de blocage de votre bouclier"] = {"BLOCK_VALUE",},

	["points de vie"] = {"HEALTH",},
	["aux points de vie"] = {"HEALTH",},
	["points de mana"] = {"MANA",},

	["la puissance d'attaque"] = {"AP",},
	["à la puissance d'attaque"] = {"AP",},
	["puissance d'attaque"] = {"AP",},



	--ToDo
	["Augmente dela puissance d'attaque lorsque vous combattez des morts-vivants"] = {"AP_UNDEAD",},
	--["Increases attack powerwhen fighting Mort-vivant"] = {"AP_UNDEAD",},
	--["Increases attack powerwhen fighting Mort-vivant.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"AP_UNDEAD",},
	--["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",},
	--["Attack Power in Cat, Bear, and Dire Bear forms only"] = {"FERAL_AP",},
	--["Increases attack powerin Cat, Bear, Dire Bear, and Moonkin forms only"] = {"FERAL_AP",},


	--ranged AP
	["la puissance des attaques à distance"] = {"RANGED_AP",},
	--Feral
	["la puissance d'attaque pour les formes de félin, d'ours, d'ours redoutable et de sélénien uniquement"] = {"FERAL_AP",},

	--regen
	["points de mana toutes les 5 secondes"] = {"MANA_REG",},
	["point de mana toutes les 5 secondes"] = {"MANA_REG",},
	["points de vie toutes les 5 secondes"] = {"HEALTH_REG",},
	["point de vie toutes les 5 secondes"] = {"HEALTH_REG",},
	["points de mana toutes les 5 sec"] = {"MANA_REG",},
	["points de vie toutes les 5 sec"] = {"HEALTH_REG",},
	["point de mana toutes les 5 sec"] = {"MANA_REG",},
	["point de vie toutes les 5 sec"] = {"HEALTH_REG",},
	["mana toutes les 5 secondes"] = {"MANA_REG",},
	["régén. de mana"] = {"MANA_REG",},


	--pénétration des sorts
	["la pénétration de vos sorts"] = {"SPELLPEN",},
	["à la pénétration des sorts"] = {"SPELLPEN",},
	--Puissance soins et sorts
	["à la puissance des sorts"] = {"SPELL_DMG",},
	["les soins prodigués par les sorts et effets"] = {"HEAL",},
	["les dégâts et les soins produits par les sorts et effets magiques"] = {"SPELL_DMG", "HEAL"},
	["aux dégâts des sorts et aux soins"] = {"SPELL_DMG", "HEAL"},
	["aux dégâts des sorts"] = {"SPELL_DMG",},
	["dégâts des sorts"] = {"SPELL_DMG",},
	["aux sorts de soins"] = {"HEAL",},
	["aux soins"] = {"HEAL",},
	["aux soins et dégâts des sorts"] = {"HEAL", "SPELL_DMG"}, --shaman ZG enchant
	["soins"] = {"HEAL",},
	["les soins prodigués par les sorts et effets d’un maximum"] = {"HEAL",},

	--ToDo
	["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques d'un maximum de"] = {"SPELL_DMG_UNDEAD"},

	["les dégâts infligés par les sorts et effets d'ombre"]={"SHADOW_SPELL_DMG",},
	["aux dégâts des sorts d'ombre"]={"SHADOW_SPELL_DMG",},
	["aux dégâts d'ombre"]={"SHADOW_SPELL_DMG",},

	["les dégâts infligés par les sorts et effets de givre"]={"FROST_SPELL_DMG",},
	["aux dégâts des sorts de givre"]={"FROST_SPELL_DMG",},
	["aux dégâts de givre"]={"FROST_SPELL_DMG",},

	["les dégâts infligés par les sorts et effets de feu"]={"FIRE_SPELL_DMG",},
	["aux dégâts des sorts de feu"]={"FIRE_SPELL_DMG",},
	["aux dégâts de feu"]={"FIRE_SPELL_DMG",},

	["les dégâts infligés par les sorts et effets de nature"]={"NATURE_SPELL_DMG",},
	["aux dégâts des sorts de nature"]={"NATURE_SPELL_DMG",},
	["aux dégâts de nature"]={"NATURE_SPELL_DMG",},

	["les dégâts infligés par les sorts et effets des arcanes"]={"ARCANE_SPELL_DMG",},
	["aux dégâts des sorts d'arcanes"]={"ARCANE_SPELL_DMG",},
	["aux dégâts d'arcanes"]={"ARCANE_SPELL_DMG",},

	["les dégâts infligés par les sorts et effets du sacré"]={"HOLY_SPELL_DMG",},
	["aux dégâts des sorts du sacré"]={"HOLY_SPELL_DMG",},
	["aux dégâts du sacré"]={"HOLY_SPELL_DMG",},

	--ToDo
	--["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
	--["Increases Healing"] = {"HEAL",},
	--["Healing"] = {"HEAL",},
	--["healing Spells"] = {"HEAL",},
	--["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	--["Increases healing done by spells and effects"] = {"HEAL",},
	--["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
	--["your healing"] = {"HEAL",}, -- Atiesh

	["dégâts par seconde"] = {"DPS",},
	--["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["score de défense"] = {"DEFENSE_RATING",},
	["au score de défense"] = {"DEFENSE_RATING",},
	["le score de défense"] = {"DEFENSE_RATING",},
	["votre score de défense"] = {"DEFENSE_RATING",},

	["score d'esquive"] = {"DODGE_RATING",},
	["le score d'esquive"] = {"DODGE_RATING",},
	["au score d'esquive"] = {"DODGE_RATING",},
	["votre score d'esquive"] = {"DODGE_RATING",},

	["score de parade"] = {"PARRY_RATING",},
	["au score de parade"] = {"PARRY_RATING",},
	["le score de parade"] = {"PARRY_RATING",},
	["votre score de parade"] = {"PARRY_RATING",},

	["score de blocage"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["le score de blocage"] = {"BLOCK_RATING",},
	["votre score de blocage"] = {"BLOCK_RATING",},
	["au score de blocage"] = {"BLOCK_RATING",},

	["score de toucher"] = {"MELEE_HIT_RATING",},
	["le score de toucher"] = {"MELEE_HIT_RATING",},
	["votre score de toucher"] = {"MELEE_HIT_RATING",},
	["au score de toucher"] = {"MELEE_HIT_RATING",},

	["score de coup critique"] = {"MELEE_CRIT_RATING",},
	["score de critique"] = {"MELEE_CRIT_RATING",},
	["le score de coup critique"] = {"MELEE_CRIT_RATING",},
	["votre score de coup critique"] = {"MELEE_CRIT_RATING",},
	["au score de coup critique"] = {"MELEE_CRIT_RATING",},
	["au score de critique"] = {"MELEE_CRIT_RATING",},

	["score de résilience"] = {"RESILIENCE_RATING",},
	["le score de résilience"] = {"RESILIENCE_RATING",},
	["au score de résilience"] = {"RESILIENCE_RATING",},
	["votre score de résilience"] = {"RESILIENCE_RATING",},
	["à la résilience"] = {"RESILIENCE_RATING",},

	["le score de toucher des sorts"] = {"SPELL_HIT_RATING",},
	["score de toucher des sorts"] = {"SPELL_HIT_RATING",},
	["au score de toucher des sorts"] = {"SPELL_HIT_RATING",},
	["votre score de toucher des sorts"] = {"SPELL_HIT_RATING",},


	["le score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
	["score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
	["score de critique des sorts"] = {"SPELL_CRIT_RATING",},
	["au score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
	["au score de critique des sorts"] = {"SPELL_CRIT_RATING",},
	["votre score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},
	["au score de coup critique de sorts"] = {"SPELL_CRIT_RATING",},
	["aux score de coup critique des sorts"] = {"SPELL_CRIT_RATING",},--blizzard! faute d'orthographe!!

	--ToDo
	--["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
	--["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
	--["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},
	["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

	["score de hâte"] = {"MELEE_HASTE_RATING"},
	["score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
	["le score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
	["score de hâte à distance"] = {"RANGED_HASTE_RATING"},
	--["Improves haste rating"] = {"MELEE_HASTE_RATING"},
	--["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
	--["Improves ranged haste rating"] = {"SPELL_HASTE_RATING"},
	--["Improves spell haste rating"] = {"RANGED_HASTE_RATING"},

	["le score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
	["score de la compétence dagues"] = {"DAGGER_WEAPON_RATING"},
	["le score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
	["score de la compétence epées"] = {"SWORD_WEAPON_RATING"},
	["le score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
	["score de la compétence epées à deux mains"] = {"2H_SWORD_WEAPON_RATING"},
	["le score de la compétence masses"]= {"MACE_WEAPON_RATING"},
	["score de la compétence masses"]= {"MACE_WEAPON_RATING"},
	["le score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
	["score de la compétence masses à deux mains"]= {"2H_MACE_WEAPON_RATING"},
	["le score de la compétence haches"] = {"AXE_WEAPON_RATING"},
	["score de la compétence haches"] = {"AXE_WEAPON_RATING"},
	["le score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},
	["score de la compétence haches à deux mains"] = {"2H_AXE_WEAPON_RATING"},

	["le score de la compétence armes de pugilat"] = {"FIST_WEAPON_RATING"},
	["le score de compétence combat farouche"] = {"FERAL_WEAPON_RATING"},
	["le score de la compétence mains nues"] = {"FIST_WEAPON_RATING"},
	["le score d’expertise"] = {"EXPERTISE_RATING"},

	--ToDo
	-- Exclude
	--["sec"] = false,
	--["to"] = false,
	--["Slot Bag"] = false,
	--["Slot Quiver"] = false,
	--["Slot Ammo Pouch"] = false,
	--["Increases ranged attack speed"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "frFR")
--ToDo
----------------
-- Stat Names --
----------------
-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
-- localization effect when a locale is not available for that language, you don't have to use global
-- strings in your localization.
D["StatIDToName"] = {
	--[StatID] = {FullName, ShortName},
	---------------------------------------------------------------------------
	-- Tier1 Stats - Stats parsed directly off items
	["EMPTY_SOCKET_RED"] = {"Châsse rouge", "Châsse rouge"},
	["EMPTY_SOCKET_YELLOW"] = {"Châsse jaune", "Châsse jaune"},
	["EMPTY_SOCKET_BLUE"] = {"Châsse bleue", "Châsse bleue"},
	["EMPTY_SOCKET_META"] = {"Méta-châsse", "Méta-châsse"},

	["IGNORE_ARMOR"] = {"Armure ignorée", "Armure ignorée"},
	["STEALTH_LEVEL"] = {"Niveau de camouflage", "Camouflage"},
	["MELEE_DMG"] = {"Dégâts de l'arme", "Dégâts Arme"},
	["MOUNT_SPEED"] = {"Vitesse de monte (%)", "Vit. de monte (%)"},
	["RUN_SPEED"] = {"Vitesse (%)","Vit. (%)"},

	["STR"] = {"Force", "For"},
	["AGI"] = {"Agilité", "Agi"},
	["STA"] = {"Endurance", "End"},
	["INT"] = {"Intelligence", "Int"},
	["SPI"] = {"Esprit", "Esp"},
	["ARMOR"] = {"Armure", "Armure"},
	["ARMOR_BONUS"] = {"Armure bonus", "Armure bonus"},

	["FIRE_RES"] = {"Résistance au Feu", "RF"},
	["NATURE_RES"] = {"Résistance à la Nature", "RN"},
	["FROST_RES"] = {"Résistance au Givre", "RG"},
	["SHADOW_RES"] = {"Résistance à l'Ombre", "RO"},
	["ARCANE_RES"] = {"Résistance aux Arcanes", "RA"},

	["FISHING"] = {"Pêche", "Pêche"},
	["MINING"] = {"Minage", "Minage"},
	["HERBALISM"] = {"Herboristerie", "Herboristerie"},
	["SKINNING"] = {"Dépeçage", "Dépeçage"},

	["BLOCK_VALUE"] = {"Valeur de blocage", "Valeur de blocage"},

	["AP"] = {"Puissance d'attaque", "PA"},
	["RANGED_AP"] = {"Puissance d'attaque à distance", "PA Dist."},
	["FERAL_AP"] = {"Puissance d'attaque Farouche", "PA Farouche"},
	["AP_UNDEAD"] = {"Puissance d'attaque (Mort-vivant)", "PA (Mort-vivant)"},
	["AP_DEMON"] = {"Puissance d'attaque (Démon)", "PA (Démon)"},

	["HEAL"] = {"Puissance des soins", "Soins"},

	["SPELL_DMG"] = {"Dégâts des sorts", "Dégâts"},
	["SPELL_DMG_UNDEAD"] = {"Dégâts des sorts (Mort-vivant)", "Dégâts (Mort-vivant)"},
	["SPELL_DMG_DEMON"] = {"Dégâts des sorts (Démon)", "Dégâts (Démon)"},
	["HOLY_SPELL_DMG"] = {"Dégâts des sorts du Sacré","Dégâts Sacré"},
	["FIRE_SPELL_DMG"] = {"Dégâts des sorts de Feu","Dégâts Feu"},
	["NATURE_SPELL_DMG"] = {"Dégâts des sorts de Nature","Dégâts Nature"},
	["FROST_SPELL_DMG"] = {"Dégâts des sorts de Givre","Dégâts Givre"},
	["SHADOW_SPELL_DMG"] = {"Dégâts des sorts d'Ombre","Dégâts Ombre"},
	["ARCANE_SPELL_DMG"] = {"Dégâts des sorts des Arcanes","Dégâts Arcanes"},

	["SPELLPEN"] = {"Pénétration des sorts", "Pénétration"},

	["HEALTH"] = {"Points de vie", "PV"},
	["MANA"] = {"Points de mana", "Mana"},
	["HEALTH_REG"] = {"Régén. vie", "Hp5"},
	["MANA_REG"] = {"Régén. mana", "Mp5"},

	["MAX_DAMAGE"] = {"Dégâts maximum", "Dégâts Max"},
	["DPS"] = {"Dégâts par seconde", "DPS"},

	["DEFENSE_RATING"] = {"Score de défense", "Défense"},
	["DODGE_RATING"] = {"Score d'esquive", "Esquive"},
	["PARRY_RATING"] = {"Score de parade", "Parade"},
	["BLOCK_RATING"] = {"Score de blocage", "Blocage"},
	["MELEE_HIT_RATING"] = {"Score de toucher en mêlée", "Toucher (mêlée)"},
	["RANGED_HIT_RATING"] = {"Score de toucher à distance", "Toucher (dist.)"},
	["SPELL_HIT_RATING"] = {"Score de toucher des sorts", "Toucher (sorts)"},
	["MELEE_HIT_AVOID_RATING"] = {"Score d'évitement des coups en mêlée", "Évi. des coups (mêlée)"},
	["RANGED_HIT_AVOID_RATING"] = {"Score d'évitement des coups à distance", "Évi. des coups (dist.)"},
	["SPELL_HIT_AVOID_RATING"] = {"Score d'évitement des coups des sorts", "Évi. des coups (sorts)"},
	["MELEE_CRIT_RATING"] = {"Score de coup critique en mêlée", "Crit. (mêlée)"},
	["RANGED_CRIT_RATING"] = {"Score de coup critique à distance", "Crit. (dist.)"},
	["SPELL_CRIT_RATING"] = {"Score de coup critique des sorts", "Crit. (sorts)"},
	["MELEE_CRIT_AVOID_RATING"] = {"Score d'évitement des critiques en mêlée", "Évi. des crit. (mêlée)"},
	["RANGED_CRIT_AVOID_RATING"] = {"Score d'évitement des critiques à distance", "Évi. des crit. (dist.)"},
	["SPELL_CRIT_AVOID_RATING"] = {"Score d'évitement des critiques des sorts", "Évi. des crit. (sorts)"},
	["RESILIENCE_RATING"] = {"Score de résilience", "Résilience"},
	["MELEE_HASTE_RATING"] = {"Score de hâte en mêlée", "Hâte (mêlée)"},
	["RANGED_HASTE_RATING"] = {"Score de hâte à distance", "Hâte (dist.)"},
	["SPELL_HASTE_RATING"] = {"Score de hâte des sorts","Hâte (sorts)"},
	["DAGGER_WEAPON_RATING"] = {"Compétence en Dagues", "Dagues"},
	["SWORD_WEAPON_RATING"] = {"Compétence en Epées à une main", "Epées à une main"},
	["2H_SWORD_WEAPON_RATING"] = {"Compétence en Epées à deux mains", "Epées à deux mains"},
	["AXE_WEAPON_RATING"] = {"Compétence en Haches à une main", "Haches à une main"},
	["2H_AXE_WEAPON_RATING"] = {"Compétence en Haches à deux mains", "Haches à deux mains"},
	["MACE_WEAPON_RATING"] = {"Compétence en Masses à une main", "Masses à une main"},
	["2H_MACE_WEAPON_RATING"] = {"Compétence en Masses à deux mains", "Masses à deux mains"},
	["GUN_WEAPON_RATING"] = {"Compétence en Armes à feu", "Armes à feu"}, --may become Fusils at some point in later expansions
	["CROSSBOW_WEAPON_RATING"] = {"Compétence en Arbalètes", "Arbalètes"},
	["BOW_WEAPON_RATING"] = {"Compétence en Arcs", "Arcs"},
	["FERAL_WEAPON_RATING"] = {"Compétence en Combat farouche", "Combat farouche"}, --found Changeforme too
	["FIST_WEAPON_RATING"] = {"Compétence en Armes de pugilat", "Armes de pugilat"}, --fist weapon =/= unarmed
	--["UNARMED_WEAPON_RATING"] = {"Compétence en Mains nues", "Mains nues"},
	--["POLEARMS_WEAPON_RATING"] = {"Compétence en Armes d'hast", "Armes d'hast"}, --may be useless but better have it than not

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {"Régén. vie (hors combat)", "HP5(HC)"},
	["MANA_REG_NOT_CASTING"] = {"Régén. mana (hors incantation)", "MP5(HI)"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques en mêlée (%)", "Dim. dégâts crit. (mêlée)(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques à distance (%)", "Dim. dégâts crit. (dist.)(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques des sorts (%)", "Dim. dégâts crit. (sorts)(%)"},
	["DEFENSE"] = {"Défense", "Défense"},
	["DODGE"] = {"Esquive (%)", "Esquive (%)"},
	["PARRY"] = {"Parade (%)", "Parade (%)"},
	["BLOCK"] = {"Blocage (%)", "Blocage (%)"},
	["MELEE_HIT"] = {"Toucher en mêlée (%)", "Toucher (mêlée)(%)"},
	["RANGED_HIT"] = {"Toucher à distance (%)", " Toucher (dist.)(%)"},
	["SPELL_HIT"] = {"Toucher des sorts (%)", "Toucher (sorts)(%)"},
	["MELEE_HIT_AVOID"] = {"Score d'évitement des coups en mêlée (%)", "Évi. des coups (mêlée)(%)"},
	["RANGED_HIT_AVOID"] = {"Score d'évitement des coups à distance (%)","Évi. des coups (dist.)(%)"},
	["SPELL_HIT_AVOID"] = {"Score d'évitement des coups des sorts (%)","Évi. des coups (sorts)(%)"},
	["MELEE_CRIT"] = {"Critiques en mêlée (%)", "Crit. (mêlée)(%)"},
	["RANGED_CRIT"] = {"Critiques à distance (%)", "Crit. (dist.)(%)"},
	["SPELL_CRIT"] = {"Critiques des sorts (%)", "Crit. (sorts)(%)"},
	["MELEE_CRIT_AVOID"] = {"Évitement des critiques en mêlée", "Évi. des crit. (mêlée)(%)"},
	["RANGED_CRIT_AVOID"] = {"Évitement des critiques à distance", "Évi. des crit. (dist.)(%)"},
	["SPELL_CRIT_AVOID"] = {"Évitement des critiques des sorts", "Évi. des crit. (sorts)(%)"},
	["MELEE_HASTE"] = {"Hâte en mêlée (%)", "Hâte (mêlée)(%)"}, --
	["RANGED_HASTE"] = {"Hâte à distance (%)", "Hâte (dist.)(%)"},
	["SPELL_HASTE"] = {"Hâte des sorts (%)", " Hâte (sorts)(%)"},
	["DAGGER_WEAPON"] = {"Compétence en Dagues", "Dagues"},
	["SWORD_WEAPON"] = {"Compétence en Epées à une main", "Epées à une main"},
	["2H_SWORD_WEAPON"] = {"Compétence en Epées à deux mains", "Epées à deux mains"},
	["AXE_WEAPON"] = {"Compétence en Haches à une main", "Haches à une main"},
	["2H_AXE_WEAPON"] = {"Compétence en Haches à deux mains", "Haches à deux mains"},
	["MACE_WEAPON"] = {"Compétence en Masses à une main", "Masses à une main"},
	["2H_MACE_WEAPON"] = {"Compétence en Masses à deux mains", "Masses à deux mains"},
	["GUN_WEAPON"] = {"Compétence en Armes à feu", "Armes à feu"},
	["CROSSBOW_WEAPON"] = {"Compétence en Arbalètes", "Arbalètes"},
	["BOW_WEAPON"] = {"Compétence en Arcs", "Arcs"},
	["FERAL_WEAPON"] = {"Compétence en Combat farouche", "Combat farouche"},
	["FIST_WEAPON"] = {"Compétence en Armes de pugilat", "Armes de pugilat"},
	--["UNARMED_WEAPON"] = {"Compétence en Mains nues", "Mains nues"},
	--["POLEARMS_WEAPON"] = {"Compétence en Armes d'hast", "Armes d'hast"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	["DODGE_NEGLECT"] = {"Diminution d'Esquive (%)", "Diminution d'Esquive (%)"},
	["PARRY_NEGLECT"] = {"Diminution de Parade (%)", "Diminution de Parade (%)"},
	["BLOCK_NEGLECT"] = {"Diminution de Blocage (%)", "Diminution de Blocage (%)"},

	---------------------------------------------------------------------------
	-- Talants
	["MELEE_CRIT_DMG"] = {"Dégâts des critiques en mêlée(%)", "Dégâts crit. (mêlée)(%)"},
	["RANGED_CRIT_DMG"] = {"Dégâts des critiques à distance(%)", "Dégâts crit. (distance)(%)"},
	["SPELL_CRIT_DMG"] = {"Dégâts des critiques des sorts(%)", "Dégâts crit. (sorts)(%)"},

	---------------------------------------------------------------------------
	-- Spell Stats
	-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
	-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
	-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
	-- Use strsplit("@", text) to seperate the spell name and statid
	["THREAT"] = {"Menace", "Menace"},
	["CAST_TIME"] = {"Temps d'incantation", "Temps d'incantation"},
	["MANA_COST"] = {"Coût en mana", "Coût Mana"},
	["RAGE_COST"] = {"Coût en rage", "Coût Rage"},
	["ENERGY_COST"] = {"Coût en énergie", "Coût Énergie"},
	["COOLDOWN"] = {"Temps de recharge", "CD"},

	---------------------------------------------------------------------------
	-- Stats Mods
	["MOD_STR"] = {"Mod Force (%)", "Mod For (%)"},
	["MOD_AGI"] = {"Mod Agilité (%)", "Mod Agi (%)"},
	["MOD_STA"] = {"Mod Endurance (%)", "Mod End (%)"},
	["MOD_INT"] = {"Mod Intelligence (%)", "Mod Int (%)"},
	["MOD_SPI"] = {"Mod Esprit (%)", "Mod Esp (%)"},
	["MOD_HEALTH"] = {"Mod Points de vie (%)", "Mod PV (%)"},
	["MOD_MANA"] = {"Mod Points de mana (%)", "Mod PM (%)"},
	["MOD_ARMOR"] = {"Mod Armure des objets (%)", "Mod Armure (objets)(%)"},
	["MOD_BLOCK_VALUE"] = {"Mod Valeur de blocage (%)", "Mod Valeur de blocage (%)"},
	["MOD_DMG"] = {"Mod Damage (%)", "Mod Dmg (%)"},
	["MOD_DMG_TAKEN"] = {"Mod Dégâts subis (%)", "Mod Dégâts subis (%)"},
	["MOD_CRIT_DAMAGE"] = {"Mod Dégâts critiques (%)", "Mod Dégâts crit. (%)"},
	["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Dégâts critiques subis (%)", "Mod Dégâts crit. subis (%)"},
	["MOD_THREAT"] = {"Mod Menace (%)", "Mod Menace (%)"},
	["MOD_AP"] = {"Mod Puissance d'attaque (%)", "Mod PA (%)"},
	["MOD_RANGED_AP"] = {"Mod Puissance d'attaque à distance (%)", "Mod PA (dist.) (%)"},
	["MOD_SPELL_DMG"] = {"Mod Dégâts des sorts (%)", "Mod Dégâts des sorts (%)"},
	["MOD_HEALING"] = {"Mod Soins (%)", "Mod Soins (%)"},
	["MOD_CAST_TIME"] = {"Mod Temps d'incantation (%)", "Mod Temps d'incantation (%)"},
	["MOD_MANA_COST"] = {"Mod Coût en mana (%)", "Mod Coût Mana (%)"},
	["MOD_RAGE_COST"] = {"Mod Coût en rage (%)", "Mod Coût Rage (%)"},
	["MOD_ENERGY_COST"] = {"Mod Coût en énergie (%)", "Mod Coût Énergie (%)"},
	["MOD_COOLDOWN"] = {"Mod Temps de recharge (%)", "Mod CD (%)"},

	---------------------------------------------------------------------------
	-- Misc Stats
	["WEAPON_RATING"] = {"Compétence d'arme", "Comp. d'arme"},
	["WEAPON_SKILL"] = {"Compétence d'arme", "Comp. d'arme"},
	["MAINHAND_WEAPON_RATING"] = {"Compétence d'arme en main droite", "Comp. d'arme main droite"},
	["OFFHAND_WEAPON_RATING"] = {"Compétence d'arme en main gauche", "Comp. d'arme main gauche"},
	["RANGED_WEAPON_RATING"] = {"Compétence d'arme à distance", "Comp. d'arme à distance"},
}
