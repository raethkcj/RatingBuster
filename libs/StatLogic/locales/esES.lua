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
	["Salvajismo"] = {[StatLogic.Stats.AttackPower] = 70}, --
	["vitalidad"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4}, -- Enchant Boots - Vitality spell: 27948
	["escarcha de alma"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54}, --
	["fuego solar"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50}, --
	["Pies de plomo"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" spell: 27954
}
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = StatLogic.Stats.FeralAttackPower,
	["^(%d+) bloqueo$"] = StatLogic.Stats.BlockValue,
	["^(%d+) armadura$"] = StatLogic.Stats.Armor,
	["Reforzado %(%+(%d+)  armadura%)"] = StatLogic.Stats.BonusArmor,
	["regen. de maná (%d+) p. cada 5 s%.$"] = StatLogic.Stats.ManaRegen,
	["Restaura (%d+) p. de maná cada 5 s%.?$"]= StatLogic.Stats.ManaRegen,
	["Restaura (%d+) p. de maná cada 5 s de todos los miembros del grupo que estén a 30 m%.?$"]= StatLogic.Stats.ManaRegen,
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	-- Procs
	["Da la posibilidad"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["A veces"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Aa]l recibir un golpe en combate"] = false, -- [Essence of the Pure Flame] ID: 18815
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Tus ataques ignorande la armadura de tu oponente"] = {StatLogic.Stats.IgnoreArmor}, -- StatLogic:GetSum("item:33733")
	["Daño de arma"] = {StatLogic.Stats.AverageWeaponDamage}, -- Enchant

	["Todas las Estadísticas."] = {StatLogic.Stats.AllStats,},
	["Fuerza"] = {StatLogic.Stats.Strength,},
	["Agilidad"] = {StatLogic.Stats.Agility,},
	["Aguante"] = {StatLogic.Stats.Stamina,},
	["Intelecto"] = {StatLogic.Stats.Intellect,},
	["Espíritu"] = {StatLogic.Stats.Spirit,},

	["Resistencia a lo Arcano"] = {StatLogic.Stats.ArcaneResistance,},
	["Resistencia al Fuego"] = {StatLogic.Stats.FireResistance,},
	["Resistencia a la Naturaleza"] = {StatLogic.Stats.NatureResistance,},
	["Resistencia a la Escarcha"] = {StatLogic.Stats.FrostResistance,},
	["Resistencia a las Sombras"] = {StatLogic.Stats.ShadowResistance,},
	["resist. Arcana"] = {StatLogic.Stats.ArcaneResistance,}, -- Arcane Armor Kit +8 Arcane Resist
	["resist. al Fuego"] = {StatLogic.Stats.FireResistance,}, -- Flame Armor Kit +8 Fire Resist
	["resist. a la Naturaleza"] = {StatLogic.Stats.NatureResistance,}, -- Frost Armor Kit +8 Frost Resist
	["resist. a la Escarcha"] = {StatLogic.Stats.FrostResistance,}, -- Nature Armor Kit +8 Nature Resist
	["resist. a las Sombras"] = {StatLogic.Stats.ShadowResistance,}, -- Shadow Armor Kit +8 Shadow Resist
	["resistencia a las Sombras"] = {StatLogic.Stats.ShadowResistance,}, -- Demons Blood ID: 10779
	["todas las resistencias"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["resistencia a todo"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},

	["Armadura"] = {StatLogic.Stats.BonusArmor,},
	["Defensa"] = {StatLogic.Stats.Defense,},
	["Defensa aumentada"] = {StatLogic.Stats.Defense,},
	["Bloqueo"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Valor de bloqueo"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Valor de bloqueo de escudo"] = {StatLogic.Stats.BlockValue,}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
	["Aumenta el valor de bloqueo de tu escudo"] = {StatLogic.Stats.BlockValue,},

	["Salud"] = {StatLogic.Stats.Health,},
	["PS"] = {StatLogic.Stats.Health,},
	["Mana"] = {StatLogic.Stats.Mana,},

	["Poder de ataque"] = {StatLogic.Stats.AttackPower,},
	["Aumenta el poder de ataque"] = {StatLogic.Stats.AttackPower,},
	["Poder de ataque bajo formas felinas"] = {StatLogic.Stats.FeralAttackPower,},
	["Aumenta enel poder de ataque bajo formas felinas"] = {StatLogic.Stats.FeralAttackPower,},
	["Poder de ataque a distancia"] = {StatLogic.Stats.RangedAttackPower,},
	["Aumenta enel poder de ataque a distancia"] = {StatLogic.Stats.RangedAttackPower,}, -- [High Warlord's Crossbow] ID: 18837

	["Salud cada"] = {StatLogic.Stats.HealthRegen,},
	["salud cada"] = {StatLogic.Stats.HealthRegen,}, -- Frostwolf Insignia Rank 6 ID:17909
	["la regeneración de salud normal"] = {StatLogic.Stats.HealthRegen,}, -- Demons Blood ID: 10779
	["Restaurade salud cada 5 s."] = {StatLogic.Stats.HealthRegen,}, -- [Onyxia Blood Talisman] ID: 18406
	["de Maná cada"] = {StatLogic.Stats.ManaRegen,}, -- Resurgence Rod ID:17743 Most common
	["regen. de maná"] = {StatLogic.Stats.ManaRegen,}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells spell: 24167
	["de maná cada"] = {StatLogic.Stats.ManaRegen,},
	["de Maná cada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Nightseye] ID: 24057
	["de maná cada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." spell: 33991
	["Mana per 5 Seconds"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Tanzanite] ID: 30603
	["Restaurade maná cada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- [Resurgence Rod] ID:17743
	["maná recuperado cada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- Magister's Armor Kit +3 Mana restored per 5 seconds spell: 32399
	["regen. de manácada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." spell: 23801
	["maná cada 5 s"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." spell: 27913

	["penetración del hechizo"] = {StatLogic.Stats.SpellPenetration,}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" spell: 34003
	["Aumenta la penetración de tus hechizos"] = {StatLogic.Stats.SpellPenetration,},

	["sanación y daño con hechizos"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
	["Daño y hechizo de sanación"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Daño con hechizos y sanación"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, --StatLogic:GetSum("item:22630")
	["Daño con hechizos"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Aumenta el daño y la sanación de los hechizos mágicos y los efectos hasta"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["Aumenta hasta el daño y la sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m."] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Atiesh
	["Daño"] = {StatLogic.Stats.SpellDamage,},
	["Aumenta el daño con hechizos"] = {StatLogic.Stats.SpellDamage,}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Poder con hechizos"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Aumenta el poder con hechizos"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Daño Sagrado"] = {StatLogic.Stats.HolyDamage,},
	["Daño Arcano"] = {StatLogic.Stats.ArcaneDamage,},
	["Daño de Fuego"] = {StatLogic.Stats.FireDamage,},
	["Daño de Naturaleza"] = {StatLogic.Stats.NatureDamage,},
	["Daño de Escarcha"] = {StatLogic.Stats.FrostDamage,},
	["Daño de Sombras"] = {StatLogic.Stats.ShadowDamage,},
	["Daño con Hechizos Sagrado"] = {StatLogic.Stats.HolyDamage,},
	["Daño con Hechizos Arcano"] = {StatLogic.Stats.ArcaneDamage,},
	["Daño con Hechizos de Fuego"] = {StatLogic.Stats.FireDamage,},
	["Daño con Hechizos de Naturaleza"] = {StatLogic.Stats.NatureDamage,},
	["Daño con Hechizos de Escarcha"] = {StatLogic.Stats.FrostDamage,}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Daño con Hechizos de las Sombras"] = {StatLogic.Stats.ShadowDamage,},
	["Aumenta el daño causado por los hechizos de las Sombras y los efectos hasta"] = {StatLogic.Stats.ShadowDamage,}, -- Frozen Shadoweave Vest ID:21871
	["Aumenta el daño causado por los hechizos de Escarcha y los efectos hasta"] = {StatLogic.Stats.FrostDamage,}, -- Frozen Shadoweave Vest ID:21871
	["Aumenta el daño causado por los hechizos Sagrados y los efectos hasta"] = {StatLogic.Stats.HolyDamage,},
	["Aumenta el daño causado por los hechizos Arcanos y los efectos hasta"] = {StatLogic.Stats.ArcaneDamage,},
	["Aumenta el daño causado por los hechizos de Fuego y los efectos hasta"] = {StatLogic.Stats.FireDamage,},
	["Aumenta el daño causado por los hechizos de Naturaleza y los efectos hasta"] = {StatLogic.Stats.NatureDamage,},
	["Aumenta el daño infligido por hechizos y efectos Sagrados"] = {StatLogic.Stats.HolyDamage,}, -- Drape of the Righteous ID:30642
	["Aumenta el daño infligido por hechizos y efectos Arcanos"] = {StatLogic.Stats.ArcaneDamage,}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Fuego"] = {StatLogic.Stats.FireDamage,}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Escarcha"] = {StatLogic.Stats.FrostDamage,}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de Naturaleza"] = {StatLogic.Stats.NatureDamage,}, -- Added just in case
	["Aumenta el daño infligido por hechizos y efectos de las Sombras"] = {StatLogic.Stats.ShadowDamage,}, -- Added just in case

	["hechizos de sanación"] = {StatLogic.Stats.HealingPower,}, -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
	["aumentar la sanación"] = {StatLogic.Stats.HealingPower,},
	["Sanación"] = {StatLogic.Stats.HealingPower,}, -- StatLogic:GetSum("item:23344:206")
	["Hechizos de sanación"] = {StatLogic.Stats.HealingPower,}, -- [Royal Nightseye] ID: 24057
	["Aumenta la sanación que haces"] = {StatLogic.Stats.HealingPower,}, -- 2.3.0
	["daño que infligescon todos los hechizos mágicos"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0
	["Aumenta la sanación que hacescon todos los hechizos mágicos y efectos."] = {StatLogic.Stats.HealingPower,},
	["Aumentala sanación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de 30 m"] = {StatLogic.Stats.HealingPower,}, -- Atiesh
	--["your healing"] = {StatLogic.Stats.HealingPower,}, -- Atiesh

	["daño por segundo"] = {StatLogic.Stats.WeaponDPS,},
	["Añadedaño por segundo"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15977

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

	["Mejora tu probabilidad de alcanzar el objetivo%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit},
	["Aumenta% tu probabilidad de golpear con hechizos, ataques cuerpo a cuerpo y ataques a distancia."] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit},
	["índice de golpe"] = {StatLogic.Stats.HitRating,},
	["Aumenta tu índice de golpe"] = {StatLogic.Stats.HitRating,},
	["Mejora el índice de golpe"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["Mejora el índice de golpe cuerpo a cuerpo"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["golpe con hechizo"] = {StatLogic.Stats.SpellHitRating,}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit spell: 24164
	["Mejora tu probabilidad de alcanzar el objetivo con hechizos%"] = {StatLogic.Stats.SpellHit},
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
}