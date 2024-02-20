-- frFR localization by Tixu
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "frFR")
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
------------------
-- Prefix Exclude --
------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
L["PrefixExcludeLength"] = 5 -- using string.utf8len
L["PrefixExclude"] = {}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	["Huile de sorcier mineure"] = {[StatLogic.Stats.SpellDamage] = 8, [StatLogic.Stats.HealingPower] = 8}, -- ID: 20744
	["Huile de sorcier inférieure"] = {[StatLogic.Stats.SpellDamage] = 16, [StatLogic.Stats.HealingPower] = 16}, -- ID: 20746
	["Huile de sorcier"] = {[StatLogic.Stats.SpellDamage] = 24, [StatLogic.Stats.HealingPower] = 24}, -- ID: 20750
	["Huile de sorcier brillante"] = {[StatLogic.Stats.SpellDamage] = 36, [StatLogic.Stats.HealingPower] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["Huile de sorcier excellente"] = {[StatLogic.Stats.SpellDamage] = 42, [StatLogic.Stats.HealingPower] = 42}, -- ID: 22522

	["Huile de mana mineure"] = {[StatLogic.Stats.ManaRegen] = 4}, -- ID: 20745
	["Huile de mana inférieure"] = {[StatLogic.Stats.ManaRegen] = 8}, -- ID: 20747
	["Huile de mana brillante"] = {[StatLogic.Stats.ManaRegen] = 12, [StatLogic.Stats.HealingPower] = 25}, -- ID: 20748
	["Huile de mana excellente"] = {[StatLogic.Stats.ManaRegen] = 14}, -- ID: 22521

	["Sauvagerie"] = {[StatLogic.Stats.AttackPower] = 70}, -- ID: 27971
	["Vitalité"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4}, -- ID: 46492
	["Âme de givre"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54}, -- ID: 27982
	["Feu solaire"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50}, -- ID: 27981

	["Équipé\194\160: La vitesse de course augmente légèrement."] = false, -- [Grèves des Hautes-terres en plaques] -- ID: 20048
	["La vitesse de course augmente légèrement"] = false,
	["Augmentation mineure de vitesse"] = false, -- Ench. de bottes (Vitesse mineure) ID: 13890
	["Vitesse mineure"] = false, -- Ench. de bottes (Rapidité du félin) "Vitesse mineure et +6 à l'Agilité" -- ID: 34007 -- & Ench. de bottes (Vitesse du sanglier) "Vitesse mineure et +9 à l'Endurance" -- ID: 34008
	["Pied sûr"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Ench. de bottes (Pied sûr) -- ID: 27954

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
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = StatLogic.Stats.FeralAttackPower,
	["Bloquer.- (%d+)"] = StatLogic.Stats.BlockValue,
	["Armure.- (%d+)"] = StatLogic.Stats.Armor,
	["Renforcé %(%+(%d+) Armure%)"] = StatLogic.Stats.BonusArmor,
	["^Équipé\194\160: Rend (%d+) points de vie toutes les 5 seco?n?d?e?s?%.?$"]= StatLogic.Stats.HealthRegen,
	["^Équipé\194\160: Rend (%d+) points de mana toutes les 5 seco?n?d?e?s?%.?$"]= StatLogic.Stats.ManaRegen,
	--["Lunette %(%+(%d+) points? de dégâts?%)"] = StatLogic.Stats.RangedAttackPower,
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9) -- anciennement : ["^.- %(%d+/%d+%)$"] = false, -- Set Name (0/9)
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
	["les soins %+(%d+) et les dégâts %+ (%d+)$"] = {{StatLogic.Stats.HealingPower}, {StatLogic.Stats.SpellDamage},},
	["les soins %+(%d+) les dégâts %+ (%d+)"] = {{StatLogic.Stats.HealingPower}, {StatLogic.Stats.SpellDamage},},
	["soins prodigués d'un maximum de (%d+) et les dégâts d'un maximum de (%d+)"] = {{StatLogic.Stats.HealingPower}, {StatLogic.Stats.SpellDamage},},
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
	["Vos attaques ignorentpoints de l'armure de votre adversaire"] = {StatLogic.Stats.IgnoreArmor}, -- StatLogic:GetSum("item:33733")
	["aux dégâts de l'arme"] = {StatLogic.Stats.AverageWeaponDamage},

	--dégats melee
	["aux dégâts des armes"] = {StatLogic.Stats.AverageWeaponDamage},
	["aux dégâts en mêlée"] = {StatLogic.Stats.AverageWeaponDamage},
	["dégâts de l'arme"] = {StatLogic.Stats.AverageWeaponDamage},

	["à toutes les caractéristiques"] = {StatLogic.Stats.AllStats,},
	["Force"] = {StatLogic.Stats.Strength},
	["à la Force"] = {StatLogic.Stats.Strength},
	["Agilité"] = {StatLogic.Stats.Agility},
	["à l'Agilité"] = {StatLogic.Stats.Agility},
	["Endurance"] = {StatLogic.Stats.Stamina},
	["en endurance"] = {StatLogic.Stats.Stamina},
	["à l'Endurance"] = {StatLogic.Stats.Stamina},
	["Intelligence"] = {StatLogic.Stats.Intellect},
	["à l'Intelligence"] = {StatLogic.Stats.Intellect},
	["Esprit"] = {StatLogic.Stats.Spirit},
	["à l'Esprit"] = {StatLogic.Stats.Spirit},

	["à la résistance Arcanes"] = {StatLogic.Stats.ArcaneResistance},
	["à la résistance aux Arcanes"] = {StatLogic.Stats.ArcaneResistance},

	["à la résistance Feu"] = {StatLogic.Stats.FireResistance},
	["à la résistance au Feu"] = {StatLogic.Stats.FireResistance},

	["à la résistance Givre"] = {StatLogic.Stats.FrostResistance},
	["à la résistance au Givre"] = {StatLogic.Stats.FrostResistance},

	["à la résistance Nature"] = {StatLogic.Stats.NatureResistance},
	["à la résistance à la Nature"] = {StatLogic.Stats.NatureResistance},

	["à la résistance Ombre"] = {StatLogic.Stats.ShadowResistance},
	["à la résistance à l'Ombre"] = {StatLogic.Stats.ShadowResistance},

	["à toutes les résistances"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance},

	["Pêche"] = false, -- Ench. de gants (Pêche) ID:13620
	["Appât de pêche"] = false, -- Appats
	["Équipé\194\160: Pêche augmentée"] = false, -- Effet canne à pêche
	["Minage"] = false,
	["Herboristerie"] = false, -- Ench. de gants (Herboristerie) ID:13617
	["Dépeçage"] = false, -- Ench. de gants (Dépeçage) ID:13698

	["Armure"] = {StatLogic.Stats.BonusArmor},
	["Défense"] = {StatLogic.Stats.Defense},
	--["Increased Defense"] = {StatLogic.Stats.Defense},
	["Valeur de blocage"] = {StatLogic.Stats.BlockValue},
	["à la valeur de blocage"] = {StatLogic.Stats.BlockValue},
	["à la valeur de blocage au bouclier"] = {StatLogic.Stats.BlockValue}, -- "+10% à la valeur de blocage au bouclier" [Diamant tonneterre éternel] ID: 35501
	["la valeur de blocage de votre bouclier"] = {StatLogic.Stats.BlockValue},

	["Points de vie"] = {StatLogic.Stats.Health},
	["aux points de vie"] = {StatLogic.Stats.Health},
	["Points de mana"] = {StatLogic.Stats.Mana},

	["puissance d'attaque"] = {StatLogic.Stats.AttackPower},
	["la puissance d'attaque"] = {StatLogic.Stats.AttackPower},
	["à la puissance d'attaque"] = {StatLogic.Stats.AttackPower},
	["à la puissance d'attaque pour les formes de félin"] = {StatLogic.Stats.FeralAttackPower}, -- version pre-TBC
	["la puissance d'attaque pour les formes de félin"] = {StatLogic.Stats.FeralAttackPower}, -- version TBC+
	["à la puissance des attaques à distance."] = {StatLogic.Stats.RangedAttackPower}, -- [Arbalète de grand seigneur de guerre] ID: 18837 -- version pre-TBC
	["la puissance des attaques à distance"] = {StatLogic.Stats.RangedAttackPower}, -- [Arbalète de grand seigneur de guerre] ID: 18837 -- version TBC+

	["points de mana toutes les 5 secondes"] = {StatLogic.Stats.ManaRegen},
	["point de mana toutes les 5 secondes"] = {StatLogic.Stats.ManaRegen},
	["points de mana toutes les 5 sec"] = {StatLogic.Stats.ManaRegen},
	["point de mana toutes les 5 sec"] = {StatLogic.Stats.ManaRegen},
	["points de mana rendus toutes les 5 secondes"] = {StatLogic.Stats.ManaRegen}, -- [Renfort d'armure de magistère] ID: 32399
	["mana toutes les 5 secondes"] = {StatLogic.Stats.ManaRegen},
	["régén. de mana"] = {StatLogic.Stats.ManaRegen},

	["points de vie toutes les 5 secondes"] = {StatLogic.Stats.HealthRegen},
	["point de vie toutes les 5 secondes"] = {StatLogic.Stats.HealthRegen},
	["points de vie toutes les 5 sec"] = {StatLogic.Stats.HealthRegen},
	["point de vie toutes les 5 sec"] = {StatLogic.Stats.HealthRegen},
	["votre régénération des points de vie normale"] = {StatLogic.Stats.HealthRegen}, -- [Sang de démon] ID: 10779

	["à la pénétration des sorts"] = {StatLogic.Stats.SpellPenetration}, -- Ench. de cape (Pénétration des sorts) "+20 à la pénétration des sorts" ID: 34003
	["la pénétration de vos sorts"] = {StatLogic.Stats.SpellPenetration},

	["aux soins et aux dégâts des sorts"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Arcanum de focalisation "+8 aux soins et aux dégâts des sorts" ID: 22844
	["aux soins et dégâts des sorts"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Etreinte vigilante du vaudouisan "+13 aux soins et dégâts des sorts/+15 Intelligence" ID: 24163
	["aux dégâts des sorts et aux soins"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["aux dégâts des sorts"] = {StatLogic.Stats.SpellDamage},
	["aux sorts de soins"] = {StatLogic.Stats.HealingPower},
	["aux soins"] = {StatLogic.Stats.HealingPower},
	["à la puissance des sorts"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["la puissance des sorts"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["augmente la puissance des sorts"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["les dégâts et les soins produits par les sorts et effets magiques"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["les soins prodigués par les sorts et effets d’un maximum"] = {StatLogic.Stats.HealingPower},
	["les soins prodigués par les sorts et effets"] = {StatLogic.Stats.HealingPower},
	["dégâts des sorts"] = {StatLogic.Stats.SpellDamage},
	["soins"] = {StatLogic.Stats.HealingPower},

	["les dégâts infligés par les sorts et effets du Sacré"]={StatLogic.Stats.HolyDamage},
	["aux dégâts des sorts du Sacré"]={StatLogic.Stats.HolyDamage},
	["aux dégâts du Sacré"]={StatLogic.Stats.HolyDamage},

	["les dégâts infligés par les sorts et effets des Arcanes"]={StatLogic.Stats.ArcaneDamage},
	["aux dégâts des sorts d'Arcanes"]={StatLogic.Stats.ArcaneDamage},
	["aux dégâts d'Arcanes"]={StatLogic.Stats.ArcaneDamage},

	["les dégâts infligés par les sorts et effets de Feu"]={StatLogic.Stats.FireDamage},
	["aux dégâts des sorts de Feu"]={StatLogic.Stats.FireDamage},
	["aux dégâts de Feu"]={StatLogic.Stats.FireDamage},

	["les dégâts infligés par les sorts et effets de Givre"]={StatLogic.Stats.FrostDamage},
	["aux dégâts des sorts de Givre"]={StatLogic.Stats.FrostDamage},
	["aux dégâts de Givre"]={StatLogic.Stats.FrostDamage},

	["les dégâts infligés par les sorts et effets de Nature"]={StatLogic.Stats.NatureDamage},
	["aux dégâts des sorts de Nature"]={StatLogic.Stats.NatureDamage},
	["aux dégâts de Nature"]={StatLogic.Stats.NatureDamage},

	["les dégâts infligés par les sorts et effets d'Ombre"]={StatLogic.Stats.ShadowDamage},
	["aux dégâts des sorts d'Ombre"]={StatLogic.Stats.ShadowDamage},
	["aux dégâts d'Ombre"]={StatLogic.Stats.ShadowDamage},

	--ToDo
	--["Increases healing done by magical spells and effects of all party members within 30 yards"] = {StatLogic.Stats.HealingPower}, -- Atiesh
	--["your healing"] = {StatLogic.Stats.HealingPower}, -- Atiesh

	["dégâts par seconde"] = {StatLogic.Stats.WeaponDPS},
	["Ajoutedégâts par seconde"] = {StatLogic.Stats.WeaponDPS}, -- [Obus en thorium] ID: 15997

	["score de défense"] = {StatLogic.Stats.DefenseRating},
	["au score de défense"] = {StatLogic.Stats.DefenseRating},
	["le score de défense"] = {StatLogic.Stats.DefenseRating},
	["votre score de défense"] = {StatLogic.Stats.DefenseRating},

	["score d'esquive"] = {StatLogic.Stats.DodgeRating},
	["le score d'esquive"] = {StatLogic.Stats.DodgeRating},
	["au score d'esquive"] = {StatLogic.Stats.DodgeRating},
	["votre score d'esquive"] = {StatLogic.Stats.DodgeRating},
	["score d’esquive"] = {StatLogic.Stats.DodgeRating},
	["le score d’esquive"] = {StatLogic.Stats.DodgeRating},
	["au score d’esquive"] = {StatLogic.Stats.DodgeRating},
	["votre score d’esquive"] = {StatLogic.Stats.DodgeRating},

	["score de parade"] = {StatLogic.Stats.ParryRating},
	["au score de parade"] = {StatLogic.Stats.ParryRating},
	["le score de parade"] = {StatLogic.Stats.ParryRating},
	["votre score de parade"] = {StatLogic.Stats.ParryRating},

	["score de blocage"] = {StatLogic.Stats.BlockRating},
	["le score de blocage"] = {StatLogic.Stats.BlockRating},
	["votre score de blocage"] = {StatLogic.Stats.BlockRating},
	["au score de blocage"] = {StatLogic.Stats.BlockRating}, -- Ench. de bouclier (Blocage inférieur) "+10 au score de blocage" -- ID: 13689

	["vos chances de toucher%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit},
	["les chances de toucher avec les sorts et les attaques en mêlée et à distance%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit},
	["score de toucher"] = {StatLogic.Stats.HitRating},
	["le score de toucher"] = {StatLogic.Stats.HitRating},
	["votre score de toucher"] = {StatLogic.Stats.HitRating},
	["au score de toucher"] = {StatLogic.Stats.HitRating},

	["score de coup critique"] = {StatLogic.Stats.CritRating},
	["score de critique"] = {StatLogic.Stats.CritRating},
	["au score de coup critique"] = {StatLogic.Stats.CritRating},
	["au score de critique"] = {StatLogic.Stats.CritRating},
	["le score de coup critique"] = {StatLogic.Stats.CritRating},
	["votre score de coup critique"] = {StatLogic.Stats.CritRating},
	["le score de coup critique en mêlée"] = {StatLogic.Stats.MeleeCritRating}, -- [Cape des ténèbres] "Augmente de 24 le score de coup critique en mêlée." ID: 33122

	["score de résilience"] = {StatLogic.Stats.ResilienceRating},
	["le score de résilience"] = {StatLogic.Stats.ResilienceRating},
	["au score de résilience"] = {StatLogic.Stats.ResilienceRating},
	["votre score de résilience"] = {StatLogic.Stats.ResilienceRating},
	["à la résilience"] = {StatLogic.Stats.ResilienceRating},

	["le score de toucher des sorts"] = {StatLogic.Stats.SpellHitRating},
	["score de toucher des sorts"] = {StatLogic.Stats.SpellHitRating},
	["au score de toucher des sorts"] = {StatLogic.Stats.SpellHitRating},
	["votre score de toucher des sorts"] = {StatLogic.Stats.SpellHitRating},

	["le score de coup critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["score de coup critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["score de critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["au score de coup critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["au score de critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["votre score de coup critique des sorts"] = {StatLogic.Stats.SpellCritRating},
	["au score de coup critique de sorts"] = {StatLogic.Stats.SpellCritRating},
	["aux score de coup critique des sorts"] = {StatLogic.Stats.SpellCritRating},--blizzard! faute d'orthographe!!

	--ToDo
	--["Ranged Hit Rating"] = {StatLogic.Stats.RangedHitRating},
	--["Improves ranged hit rating"] = {StatLogic.Stats.RangedHitRating}, -- ITEM_MOD_HIT_RANGED_RATING
	--["Increases your ranged hit rating"] = {StatLogic.Stats.RangedHitRating},
	["votre score de coup critique à distance"] = {StatLogic.Stats.RangedCritRating}, -- [Gants de fléchier] ID:7348

	["le score de hâte"] = {StatLogic.Stats.HasteRating},
	["score de hâte"] = {StatLogic.Stats.HasteRating},
	["au score de hâte"] = {StatLogic.Stats.HasteRating},

	["le score de hâte des sorts"] = {StatLogic.Stats.SpellHasteRating},
	["score de hâte des sorts"] = {StatLogic.Stats.SpellHasteRating},
	["au score de hâte des sorts"] = {StatLogic.Stats.SpellHasteRating},

	["le score de hâte à distance"] = {StatLogic.Stats.RangedHasteRating},
	["score de hâte à distance"] = {StatLogic.Stats.RangedHasteRating},
	["au score de hâte à distance"] = {StatLogic.Stats.RangedHasteRating},

	["le score d’expertise"] = {StatLogic.Stats.ExpertiseRating},
	["score d’expertise"] = {StatLogic.Stats.ExpertiseRating},
	["score de pénétration d'armure"] = {StatLogic.Stats.ArmorPenetrationRating},
	["le score de pénétration d'armure"] = {StatLogic.Stats.ArmorPenetrationRating},
	["votre score de pénétration d'armure"] = {StatLogic.Stats.ArmorPenetrationRating},
	["la pénétration d'armure"] = {StatLogic.Stats.ArmorPenetrationRating},

	--ToDo
	-- Exclude
	--["sec"] = false,
	--["to"] = false,
	--["Slot Bag"] = false,
	--["Slot Quiver"] = false,
	--["Slot Ammo Pouch"] = false,
	--["Augmente la vitesse des attaques à distance"] = false, -- AV quiver
}