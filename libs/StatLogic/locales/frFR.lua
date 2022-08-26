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
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
	["Désen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
	["Durée"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
	["<Arti"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
	["Tps"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
	["Uniqu"] = true, -- Unique (20) -- ITEM_UNIQUE = "Unique"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)"; -- Item is unique
	["Nivea"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
	["\nNive"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Requires %s (%d)"; -- Required skill rank to use the item
	["Class"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Classes: %s"; -- Lists the classes allowed to use this item
	["Races"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Races: %s"; -- Lists the races allowed to use this item
	["Utili"] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Use:";
	["Chanc"] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
	-- Set Bonuses
	-- ITEM_SET_BONUS = "Set: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["Ensem"] = true,--ensemble
	["(2) E"] = true,
	["(3) E"] = true,
	["(4) E"] = true,
	["(5) E"] = true,
	["(6) E"] = true,
	["(7) E"] = true,
	["(8) E"] = true,
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

	["Huile de sorcier mineure"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["Huile de sorcier inférieure"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["Huile de sorcier"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["Huile de sorcier brillante"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
	["Huile de sorcier excellente"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
	["Huile de sorcier bénite"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["Huile de mana mineure"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Huile de mana inférieure"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Huile de mana brillante"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Huile de mana excellente"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Ligne en éternium"] = {["FISHING"] = 5}, -- Ligne de pêche en éternium -- ID: 24302
	["Ligne en vrai-argent"] = {["FISHING"] = 3}, --Ligne de pêche en vrai-argent -- ID: 45697
	["Sauvagerie"] = {["AP"] = 70}, -- ID: 27971
	["Vitalité"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- ID: 46492
	["Âme de givre"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, -- ID: 27982
	["Feu solaire"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, -- ID: 27981

	["Eperons en mithril"] = {["MOUNT_SPEED"] = 4}, -- ID: 9783 -- description pre-TBC
	["Augmentation mineure de la vitesse de la monture"] = {["MOUNT_SPEED"] = 2}, -- Ench. de gants (Equitation) -- ID: 13947 -- description pre-TBC
	["Équipé\194\160: La vitesse de course augmente légèrement."] = {["RUN_SPEED"] = 8}, -- [Grèves des Hautes-terres en plaques] -- ID: 20048
	["La vitesse de course augmente légèrement"] = {["RUN_SPEED"] = 8},
	["Augmentation mineure de vitesse"] = {["RUN_SPEED"] = 8}, -- Ench. de bottes (Vitesse mineure) ID: 13890
	["Vitesse mineure"] = {["RUN_SPEED"] = 8}, -- Ench. de bottes (Rapidité du félin) "Vitesse mineure et +6 à l'Agilité" -- ID: 34007 -- & Ench. de bottes (Vitesse du sanglier) "Vitesse mineure et +9 à l'Endurance" -- ID: 34008
	["légère augmentation de la vitesse de course"] = {["RUN_SPEED"] = 8}, -- [Diamant brûlétoile de rapidité] -- ID: 28557
	["Pied sûr"] = {["MELEE_HIT_RATING"] = 10}, -- Ench. de bottes (Pied sûr) -- ID: 27954

	["Discrétion"] = {["THREAT_MOD"] = -2}, -- Ench. de cape (Discrétion) -- ID: 25084
	["2% de réduction de la menace"] = {["THREAT_MOD"] = -2}, -- [Diamant tonneterre tonifiant] -- ID: 25897
	["Équipé\194\160: Permet de respirer sous l'eau."] = false, -- [Bague des profondeurs glacées] -- ID: 21526 -- & [Hydrocanne] -- ID: 9452
	["Permet de respirer sous l'eau"] = false, --
	["Équipé\194\160: Immunisé au désarmement."] = false, -- [Gantelets de la forteresse] -- ID: 12639 -- version pre-TBC
	["Immunisé au désarmement"] = false,
	["Équipé\194\160: Réduit les dégâts dus aux chutes."] = false, -- [Drapé de chauve-souris du crépuscule] -- ID: 19982
	["Réduit les dégâts dus aux chutes"] = false,
	["Équipé\194\160: Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false, -- [Cape en écailles d'Onyxia] -- ID: 15138
	["Evite à son porteur d'être entièrement englobé dans la Flamme d'ombre."] = false,

	["Croisé"] = false, -- Ench. d'arme (Croisé) -- ID: 20034
	["Vampirique"] = false, -- Ench. d'arme (Vol de vie) -- ID: 20032
	["Arme impie"] = false, -- Ench. d'arme (Arme impie) -- ID: 20033
	["Mangouste"] = false, -- Ench. d'arme (Mangouste) -- ID: 27984
	["Bourreau"] = false, -- Ench. d'arme (Exécutrice) -- ID: 42974
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) (.-)%.?$"
-- Stamina +19 = "^(.-) %+(%d+)%.?$"
-- +19 耐力 = "^%+(%d+) (.-)%.?$"
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- stat1, value, stat2 = strfind
-- stat = stat1..stat2
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^Équipé\194\160: Augmente (.-) ?de (%d+) ?a?u? ?m?a?x?i?m?u?m? ?(.-)%.?$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["Bloquer.- (%d+)"] = "BLOCK_VALUE",
	["Armure.- (%d+)"] = "ARMOR",
	["Renforcé %(%+(%d+) Armure%)"] = "ARMOR_BONUS",
	["^Équipé\194\160: Rend (%d+) points de vie toutes les 5 seco?n?d?e?s?%.?$"]= "HEAL_REG",
	["^Équipé\194\160: Rend (%d+) points de mana toutes les 5 seco?n?d?e?s?%.?$"]= "MANA_REG",
	["^Dégâts : %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
	["^%(([%d%,]+) dégâts par seconde%)$"] = "DPS",
	--["Lunette %(%+(%d+) points? de dégâts?%)"] = "RANGED_AP",
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9) -- anciennement : ["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	--["[Cc]hance"] = false, -- [Marque de défiance] ID:27924 -- [Bâton des prophètes qiraji] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond] 
	["[Rr]end parfois"] = false, -- [Carte de Sombrelune : Héroïsme] ID:19287
	["[Ll]orsque vous êtes touché en combat"] = false, -- [Essence of the Pure Flame] ID: 18815
	--["[Cc]onfère une chance"] = false, -- [Marque de défiance] ID:27924
	--["[Qq]uand vos sorts offensifs atteignent une cible"] = false, -- [Bâton des prophètes qiraji] ID:21128
	["Vous gagnez une"] = false, -- [Le condensateur de foudre] ID: 28785
	["Dégâts:"] = false, -- ligne de degats des armes
	["Votre technique"] = false,
	["^%+?%d+ %- %d+ points de dégâts %(.-%)$"]= false, -- ligne de degats des baguettes/ +degats (Thunderfury)
	["Permettent au porteur"] = false, -- Casques Ombrelunes -- inccorect sur TBCClassic ?
	["Le porteur peut voir le monde"]  = false,
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
	"/", -- "+10 Score de défense/+10 Endurance/+15 Valeur de blocage": Ench. d'épaules de Zul Gurub
	" & ", -- "+12 au score de défense & +10% à la valeur de blocage au bouclier": [Diamant tonneterre éternel] ID:35501
	", ", -- "+6 aux dégâts des sorts, +5 au score de critique des sorts": [Topaze ornée toute-puissante] ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Mort-vivant. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
}
L["DeepScanWordSeparators"] = {
	" et ", -- "+ 6 au score de critique et +5 au score d'esquive": [Opale de feu d'assassin] ID:30565
}
L["DualStatPatterns"] = {
	-- all lower case
	["les soins %+(%d+) et les dégâts %+ (%d+)$"] = {{"HEAL"}, {"SPELL_DMG"},},
	["les soins %+(%d+) les dégâts %+ (%d+)"] = {{"HEAL"}, {"SPELL_DMG"},},
	["soins prodigués d'un maximum de (%d+) et les dégâts d'un maximum de (%d+)"] = {{"HEAL"}, {"SPELL_DMG"},},
}
L["DeepScanPatterns"] = {
	"^(.-) de ?(%d+) ?a?u? ?m?a?x?i?m?u?m? ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-) ?([%+%-]%d+) ?(.-)%.?$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
	"^(.-) ?([%d%,]+) ?(.-)%.?$", -- 22.22 xxx xxx (scan last)
	"^.-: (.-)([%+%-]%d+) ?(.-)%.?$", --Bonus de sertissage : +3 xxx
	"^(.-) augmentée?s? de (%d+) ?(.-)%%?%.?$",--sometimes this pattern is needed but not often.
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Vos attaques ignorentpoints de l'armure de votre adversaire"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["% à la menace"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["votre niveau de camouflage actuel"] = {"STEALTH_LEVEL"},
	["aux dégâts de l'arme"] = {"MELEE_DMG"},
	["à la vitesse de la monture"] = {"MOUNT_SPEED"},

	--dégats melee
	["aux dégâts des armes"] = {"MELEE_DMG"},
	["aux dégâts en mêlée"] = {"MELEE_DMG"},
	["dégâts de l'arme"] = {"MELEE_DMG"},

	["à toutes les caractéristiques"] = {"STR", "AGI", "STA", "INT", "SPI"},
	["Force"] = {"STR"},
	["Agilité"] = {"AGI"},
	["Endurance"] = {"STA"},
	["en endurance"] = {"STA"},
	["Intelligence"] = {"INT"},
	["Esprit"] = {"SPI"},

	["à la résistance Arcanes"] = {"ARCANE_RES"},
	["à la résistance aux Arcanes"] = {"ARCANE_RES"},

	["à la résistance Feu"] = {"FIRE_RES"},
	["à la résistance au Feu"] = {"FIRE_RES"},

	["à la résistance Givre"] = {"FROST_RES"},	
	["à la résistance au Givre"] = {"FROST_RES"},

	["à la résistance Nature"] = {"NATURE_RES"},
	["à la résistance à la Nature"] = {"NATURE_RES"},

	["à la résistance Ombre"] = {"SHADOW_RES"},
	["à la résistance à l'Ombre"] = {"SHADOW_RES"},

	["à toutes les résistances"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES"},

	["Pêche"] = {"FISHING"}, -- Ench. de gants (Pêche) ID:13620
	["Appât de pêche"] = {"FISHING"}, -- Appats
	["Équipé\194\160: Pêche augmentée"] = {"FISHING"}, -- Effet canne à pêche
	["Minage"] = {"MINING"},
	["Herboristerie"] = {"HERBALISM"}, -- Ench. de gants (Herboristerie) ID:13617
	["Dépeçage"] = {"SKINNING"}, -- Ench. de gants (Dépeçage) ID:13698

	["Armure"] = {"ARMOR_BONUS"},
	["Défense"] = {"DEFENSE"},
	--["Increased Defense"] = {"DEFENSE"},	
	["Valeur de blocage"] = {"BLOCK_VALUE"},
	["à la valeur de blocage"] = {"BLOCK_VALUE"},
	["à la valeur de blocage au bouclier"] = {"BLOCK_VALUE"}, -- "+10% à la valeur de blocage au bouclier" [Diamant tonneterre éternel] ID: 35501
	["la valeur de blocage de votre bouclier"] = {"BLOCK_VALUE"},

	["Points de vie"] = {"HEALTH"},
	["aux points de vie"] = {"HEALTH"},
	["Points de mana"] = {"MANA"},

	["puissance d'attaque"] = {"AP"},
	["la puissance d'attaque"] = {"AP"},
	["à la puissance d'attaque"] = {"AP"},
	["la puissance d'attaque lorsque vous combattez les morts-vivants"] = {"AP_UNDEAD"}, -- [Bandelettes de tueur de mort-vivant] ID:23093
	["la puissance d'attaque lorsque vous combattez des morts-vivants"] = {"AP_UNDEAD"}, -- [Sceau de l'Aube] ID:13209
	["la puissance d'attaque lorsque vous combattez des morts-vivants. Permet aussi l'acquisition de Pierres du Fléau pour l'Aube d'argent."] = {"AP_UNDEAD"}, -- [Sceau de l'Aube] ID:13209
	["la puissance d'attaque lorsque vous combattez les démons"] = {"AP_DEMON"},
	["la puissance d'attaque lorsque vous combattez des morts-vivants et des démons"] = {"AP_UNDEAD", "AP_DEMON"}, -- [Marque du champion] ID:23206
	["à la puissance d'attaque pour les formes de félin"] = {"FERAL_AP"}, -- version pre-TBC
	["la puissance d'attaque pour les formes de félin"] = {"FERAL_AP"}, -- version TBC+
	["à la puissance des attaques à distance."] = {"RANGED_AP"}, -- [Arbalète de grand seigneur de guerre] ID: 18837 -- version pre-TBC
	["la puissance des attaques à distance"] = {"RANGED_AP"}, -- [Arbalète de grand seigneur de guerre] ID: 18837 -- version TBC+

	["points de mana toutes les 5 secondes"] = {"MANA_REG"},
	["point de mana toutes les 5 secondes"] = {"MANA_REG"},
	["points de mana toutes les 5 sec"] = {"MANA_REG"},
	["point de mana toutes les 5 sec"] = {"MANA_REG"},
	["points de mana rendus toutes les 5 secondes"] = {"MANA_REG"}, -- [Renfort d'armure de magistère] ID: 32399
	["mana toutes les 5 secondes"] = {"MANA_REG"},
	["régén. de mana"] = {"MANA_REG"},
	
	["points de vie toutes les 5 secondes"] = {"HEALTH_REG"},
	["point de vie toutes les 5 secondes"] = {"HEALTH_REG"},
	["points de vie toutes les 5 sec"] = {"HEALTH_REG"},
	["point de vie toutes les 5 sec"] = {"HEALTH_REG"},
	["votre régénération des points de vie normale"] = {"HEALTH_REG"}, -- [Sang de démon] ID: 10779

	["à la pénétration des sorts"] = {"SPELLPEN"}, -- Ench. de cape (Pénétration des sorts) "+20 à la pénétration des sorts" ID: 34003
	["la pénétration de vos sorts"] = {"SPELLPEN"},

	["aux soins et aux dégâts des sorts"] = {"SPELL_DMG", "HEAL"}, -- Arcanum de focalisation "+8 aux soins et aux dégâts des sorts" ID: 22844
	["aux soins et dégâts des sorts"] = {"SPELL_DMG", "HEAL"}, -- Etreinte vigilante du vaudouisan "+13 aux soins et dégâts des sorts/+15 Intelligence" ID: 24163
	["aux dégâts des sorts et aux soins"] = {"SPELL_DMG", "HEAL"},
	["aux dégâts des sorts"] = {"SPELL_DMG"},
	["aux sorts de soins"] = {"HEAL"},
	["aux soins"] = {"HEAL"},
	["à la puissance des sorts"] = {"SPELL_DMG", "HEAL",},
	["augmente la puissance des sorts"] = {"SPELL_DMG", "HEAL",},
	["les dégâts et les soins produits par les sorts et effets magiques"] = {"SPELL_DMG", "HEAL"},
	["les soins prodigués par les sorts et effets d’un maximum"] = {"HEAL"},
	["les soins prodigués par les sorts et effets"] = {"HEAL"},
	["dégâts des sorts"] = {"SPELL_DMG"},
	["soins"] = {"HEAL"},

	["les dégâts infligés par les sorts et effets du Sacré"]={"HOLY_SPELL_DMG"},
	["aux dégâts des sorts du Sacré"]={"HOLY_SPELL_DMG"},
	["aux dégâts du Sacré"]={"HOLY_SPELL_DMG"},

	["les dégâts infligés par les sorts et effets des Arcanes"]={"ARCANE_SPELL_DMG"},
	["aux dégâts des sorts d'Arcanes"]={"ARCANE_SPELL_DMG"},
	["aux dégâts d'Arcanes"]={"ARCANE_SPELL_DMG"},

	["les dégâts infligés par les sorts et effets de Feu"]={"FIRE_SPELL_DMG"},
	["aux dégâts des sorts de Feu"]={"FIRE_SPELL_DMG"},
	["aux dégâts de Feu"]={"FIRE_SPELL_DMG"},

	["les dégâts infligés par les sorts et effets de Givre"]={"FROST_SPELL_DMG"},
	["aux dégâts des sorts de Givre"]={"FROST_SPELL_DMG"},
	["aux dégâts de Givre"]={"FROST_SPELL_DMG"},

	["les dégâts infligés par les sorts et effets de Nature"]={"NATURE_SPELL_DMG"},
	["aux dégâts des sorts de Nature"]={"NATURE_SPELL_DMG"},
	["aux dégâts de Nature"]={"NATURE_SPELL_DMG"},

	["les dégâts infligés par les sorts et effets d'Ombre"]={"SHADOW_SPELL_DMG"},
	["aux dégâts des sorts d'Ombre"]={"SHADOW_SPELL_DMG"},
	["aux dégâts d'Ombre"]={"SHADOW_SPELL_DMG"},

	["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques"] = {"SPELL_DMG_UNDEAD"}, -- [Robe de purification des morts-vivants] ID:23085
	["Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques. Permet aussi l'acquisition de Pierres du Fléau pour le compte de l'Aube d'argent"] = {"SPELL_DMG_UNDEAD"}, -- [Rune de l'Aube] ID:19812
	["Augmente les dégâts infligés aux morts-vivants et aux démons par les sorts et effets magiques"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Marque du champion] ID:23207

	--ToDo
	--["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL"}, -- Atiesh
	--["your healing"] = {"HEAL"}, -- Atiesh

	["dégâts par seconde"] = {"DPS"},
	["Ajoutedégâts par seconde"] = {"DPS"}, -- [Obus en thorium] ID: 15997

	["score de défense"] = {"DEFENSE_RATING"},
	["au score de défense"] = {"DEFENSE_RATING"},
	["le score de défense"] = {"DEFENSE_RATING"},
	["votre score de défense"] = {"DEFENSE_RATING"},

	["score d'esquive"] = {"DODGE_RATING"},
	["le score d'esquive"] = {"DODGE_RATING"},
	["au score d'esquive"] = {"DODGE_RATING"},
	["votre score d'esquive"] = {"DODGE_RATING"},
	["score d’esquive"] = {"DODGE_RATING"},
	["le score d’esquive"] = {"DODGE_RATING"},
	["au score d’esquive"] = {"DODGE_RATING"},
	["votre score d’esquive"] = {"DODGE_RATING"},

	["score de parade"] = {"PARRY_RATING"},
	["au score de parade"] = {"PARRY_RATING"},
	["le score de parade"] = {"PARRY_RATING"},
	["votre score de parade"] = {"PARRY_RATING"},

	["score de blocage"] = {"BLOCK_RATING"},
	["le score de blocage"] = {"BLOCK_RATING"},
	["votre score de blocage"] = {"BLOCK_RATING"},
	["au score de blocage"] = {"BLOCK_RATING"}, -- Ench. de bouclier (Blocage inférieur) "+10 au score de blocage" -- ID: 13689

	["score de toucher"] = {"HIT_RATING"},
	["le score de toucher"] = {"HIT_RATING"},
	["votre score de toucher"] = {"HIT_RATING"},
	["au score de toucher"] = {"HIT_RATING"},

	["score de coup critique"] = {"CRIT_RATING"},
	["score de critique"] = {"CRIT_RATING"},
	["au score de coup critique"] = {"CRIT_RATING"},
	["au score de critique"] = {"CRIT_RATING"},
	["le score de coup critique"] = {"CRIT_RATING"},
	["votre score de coup critique"] = {"CRIT_RATING"},
	["le score de coup critique en mêlée"] = {"MELEE_CRIT_RATING"}, -- [Cape des ténèbres] "Augmente de 24 le score de coup critique en mêlée." ID: 33122

	["score de résilience"] = {"RESILIENCE_RATING"},
	["le score de résilience"] = {"RESILIENCE_RATING"},
	["au score de résilience"] = {"RESILIENCE_RATING"},
	["votre score de résilience"] = {"RESILIENCE_RATING"},
	["à la résilience"] = {"RESILIENCE_RATING"},

	["le score de toucher des sorts"] = {"SPELL_HIT_RATING"},
	["score de toucher des sorts"] = {"SPELL_HIT_RATING"},
	["au score de toucher des sorts"] = {"SPELL_HIT_RATING"},
	["votre score de toucher des sorts"] = {"SPELL_HIT_RATING"},

	["le score de coup critique des sorts"] = {"SPELL_CRIT_RATING"},
	["score de coup critique des sorts"] = {"SPELL_CRIT_RATING"},
	["score de critique des sorts"] = {"SPELL_CRIT_RATING"},
	["au score de coup critique des sorts"] = {"SPELL_CRIT_RATING"},
	["au score de critique des sorts"] = {"SPELL_CRIT_RATING"},
	["votre score de coup critique des sorts"] = {"SPELL_CRIT_RATING"},
	["au score de coup critique de sorts"] = {"SPELL_CRIT_RATING"},
	["aux score de coup critique des sorts"] = {"SPELL_CRIT_RATING"},--blizzard! faute d'orthographe!!

	--ToDo
	--["Ranged Hit Rating"] = {"RANGED_HIT_RATING"},
	--["Improves ranged hit rating"] = {"RANGED_HIT_RATING"}, -- ITEM_MOD_HIT_RANGED_RATING
	--["Increases your ranged hit rating"] = {"RANGED_HIT_RATING"},
	["votre score de coup critique à distance"] = {"RANGED_CRIT_RATING"}, -- [Gants de fléchier] ID:7348

	["le score de hâte"] = {"HASTE_RATING"},
	["score de hâte"] = {"HASTE_RATING"},
	["au score de hâte"] = {"HASTE_RATING"},

	["le score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
	["score de hâte des sorts"] = {"SPELL_HASTE_RATING"},
	["au score de hâte des sorts"] = {"SPELL_HASTE_RATING"},

	["le score de hâte à distance"] = {"RANGED_HASTE_RATING"},
	["score de hâte à distance"] = {"RANGED_HASTE_RATING"},
	["au score de hâte à distance"] = {"RANGED_HASTE_RATING"},

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
	["score d’expertise"] = {"EXPERTISE_RATING"},
	["score de pénétration d'armure"] = {"ARMOR_PENETRATION_RATING"},
	["le score de pénétration d'armure"] = {"ARMOR_PENETRATION_RATING"},
	["votre score de pénétration d'armure"] = {"ARMOR_PENETRATION_RATING"},

	--ToDo
	-- Exclude
	--["sec"] = false,
	--["to"] = false,
	--["Slot Bag"] = false,
	--["Slot Quiver"] = false,
	--["Slot Ammo Pouch"] = false,
	--["Augmente la vitesse des attaques à distance"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "frFR")
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
	["THREAT_MOD"] = {"Menace (%)", "Menace (%)"},
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
	["HOLY_SPELL_DMG"] = {"Dégâts des sorts du Sacré", "Dégâts Sacré"},
	["FIRE_SPELL_DMG"] = {"Dégâts des sorts de Feu", "Dégâts Feu"},
	["NATURE_SPELL_DMG"] = {"Dégâts des sorts de Nature", "Dégâts Nature"},
	["FROST_SPELL_DMG"] = {"Dégâts des sorts de Givre", "Dégâts Givre"},
	["SHADOW_SPELL_DMG"] = {"Dégâts des sorts d'Ombre", "Dégâts Ombre"},
	["ARCANE_SPELL_DMG"] = {"Dégâts des sorts des Arcanes", "Dégâts Arcanes"},

	["SPELLPEN"] = {"Pénétration des sorts", "Pénétration"},

	["HEALTH"] = {"Points de vie", "PV"},
	["MANA"] = {"Points de mana", "Mana"},
	["HEALTH_REG"] = {"Régén. vie (combat)", "Régén. vie (combat)"},
	["MANA_REG"] = {"Régén. mana (incantation)", "Régén. mana (incantation)"},

	["MAX_DAMAGE"] = {"Dégâts maximum", "Dégâts Max"},
	["DPS"] = {"Dégâts par seconde", "DPS"},

	["DEFENSE_RATING"] = {"Score de défense", "Défense"},
	["DODGE_RATING"] = {"Score d'esquive", "Esquive"},
	["PARRY_RATING"] = {"Score de parade", "Parade"},
	["BLOCK_RATING"] = {"Score de blocage", "Blocage"},
	["MELEE_HIT_RATING"] = {"Score de toucher", "Score de toucher"},
	["RANGED_HIT_RATING"] = {"Score de toucher à distance", "Score de toucher à distance"},
	["SPELL_HIT_RATING"] = {"Score de toucher des sorts", "Score de toucher des sorts"},
	["MELEE_CRIT_RATING"] = {"Score de coup critique", "Score de coup critique"},
	["RANGED_CRIT_RATING"] = {"Score de coup critique à distance", "Score de coup critique à distance"},
	["SPELL_CRIT_RATING"] = {"Score de coup critique des sorts", "Score de coup critique des sorts"},
	["RESILIENCE_RATING"] = {"Score de résilience", "Résilience"},
	["MELEE_HASTE_RATING"] = {"Score de hâte", "Hâte"},
	["RANGED_HASTE_RATING"] = {"Score de hâte à distance", "Score de hâte à distance"},
	["SPELL_HASTE_RATING"] = {"Score de hâte des sorts","Score de hâte des sorts"},
	["DAGGER_WEAPON_RATING"] = {"Compétence en Dagues", "Dagues"},
	["SWORD_WEAPON_RATING"] = {"Compétence en Epées à une main", "Epées à une main"},
	["2H_SWORD_WEAPON_RATING"] = {"Compétence en Epées à deux mains", "Epées à deux mains"},
	["AXE_WEAPON_RATING"] = {"Compétence en Haches à une main", "Haches à une main"},
	["2H_AXE_WEAPON_RATING"] = {"Compétence en Haches à deux mains", "Haches à deux mains"},
	["MACE_WEAPON_RATING"] = {"Compétence en Masses à une main", "Masses à une main"},
	["2H_MACE_WEAPON_RATING"] = {"Compétence en Masses à deux mains", "Masses à deux mains"},
	["GUN_WEAPON_RATING"] = {"Compétence en Armes à feu", "Armes à feu"},
	["CROSSBOW_WEAPON_RATING"] = {"Compétence en Arbalètes", "Arbalètes"},
	["BOW_WEAPON_RATING"] = {"Compétence en Arcs", "Arcs"},
	["FERAL_WEAPON_RATING"] = {"Compétence en Combat farouche", "Combat farouche"},
	["FIST_WEAPON_RATING"] = {"Compétence en Armes de pugilat", "Armes de pugilat"}, 
	["STAFF_WEAPON_RATING"] = {"Compétence en Bâtons", "Bâtons"}, -- [Jambières du Croc] ID:10410
	["EXPERTISE_RATING"] = {"Score d'Expertise", "Score d'Expertise"},
	["ARMOR_PENETRATION_RATING"] = {"Pénétration d'armure".." "..RATING, "ArP".." "..RATING},

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {"Régén. vie (hors combat)", "Régén. vie (hors combat)"},
	["MANA_REG_NOT_CASTING"] = {"Régén. mana (hors incantation)", "Régén. mana (hors incantation)"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques en mêlée (%)", "Dim. dégâts crit. (mêlée)(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques à distance (%)", "Dim. dégâts crit. (dist.)(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {"Diminution des dégâts des coups critiques des sorts (%)", "Dim. dégâts crit. (sorts)(%)"},
	["DEFENSE"] = {"Défense", "Défense"},
	["DODGE"] = {"Esquive (%)", "Esquive (%)"},
	["PARRY"] = {"Parade (%)", "Parade (%)"},
	["BLOCK"] = {"Blocage (%)", "Blocage (%)"},
	["AVOIDANCE"] = {"Évitement (%)", "Évitement (%)"},
	["MELEE_HIT"] = {"Toucher (%)", "Toucher(%)"},
	["RANGED_HIT"] = {"Toucher à distance (%)", " Toucher (dist.)(%)"},
	["SPELL_HIT"] = {"Toucher des sorts (%)", "Toucher (sorts)(%)"},
	["MELEE_HIT_AVOID"] = {"Score d'évitement des coups en mêlée (%)", "Évi. des coups (mêlée)(%)"},
	["MELEE_CRIT"] = {"Critiques (%)", "Crit.(%)"},
	["RANGED_CRIT"] = {"Critiques à distance (%)", "Crit. (dist.)(%)"},
	["SPELL_CRIT"] = {"Critiques des sorts (%)", "Crit. (sorts)(%)"},
	["MELEE_CRIT_AVOID"] = {"Évitement des critiques en mêlée", "Évi. des crit. (mêlée)(%)"},
	["MELEE_HASTE"] = {"Hâte (%)", "Hâte(%)"}, --
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
	["STAFF_WEAPON"] = {"Compétence en Bâtons", "Bâtons"}, -- [Jambières du Croc] ID:10410
	["EXPERTISE"] = {"Expertise", "Expertise"},
	["ARMOR_PENETRATION"] = {"Pénétration d'armure(%)", "PenAr(%)"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	-- Expertise -> Dodge Neglect, Parry Neglect
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
