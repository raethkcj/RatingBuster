-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "esMX" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["ley de la naturaleza"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 55, }
W["estadísticas de vida"] = {[StatLogic.Stats.AllStats] = 4, [StatLogic.Stats.NatureResistance] = 15, }
W["vitalidad"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["pies de plomo"] = {[StatLogic.Stats.HitRating] = 10, }
W["salvajismo"] = {[StatLogic.Stats.GenericAttackPower] = 70, }
W["fuego solar"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["escarcha de alma"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }
W["runa de la gárgola piel de piedra"] = {[StatLogic.Stats.Defense] = 25, }
W["runa del caparazón nerubiano"] = {[StatLogic.Stats.Defense] = 13, }

local L = addon.StatIDLookup
L["armadura reforzada %s"] = {StatLogic.Stats.BonusArmor, }
L["%s todas las resistencias"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["aumenta la sanación %s"] = {StatLogic.Stats.HealingPower, }
L["%s daño con hechizos arcano"] = {StatLogic.Stats.ArcaneDamage, }
L["%s daño con hechizos de las sombras"] = {StatLogic.Stats.ShadowDamage, }
L["%s daño con hechizos de fuego"] = {StatLogic.Stats.FireDamage, }
L["%s daño con hechizos sagrado"] = {StatLogic.Stats.HolyDamage, }
L["%s daño con hechizos de escarcha"] = {StatLogic.Stats.FrostDamage, }
L["%s daño con hechizos de naturaleza"] = {StatLogic.Stats.NatureDamage, }
L["%s de hechizos de sanación"] = {StatLogic.Stats.HealingPower, }
L["daño con hechizos %s"] = {StatLogic.Stats.SpellDamage, }
L["sanación y daño con hechizos %s"] = {StatLogic.Stats.SpellDamage, }
L["regeneración de maná: %s cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["defensa %s/aguante %s /valor de bloqueo %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.BlockValue, }
L["defensa %s/aguante %s /hechizos de sanación %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["poder de ataque %s/esquivar %s%"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Dodge, }
L["poder de ataque a distancia %s/aguante %s/golpe %s%"] = {StatLogic.Stats.RangedAttackPower, StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["sanación y daño con hechizos %s/intelecto %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Intellect, }
L["sanación y daño con hechizos %s/golpe con hechizos %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["sanación y daño con hechizos %s/aguante %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Stamina, }
L["regeneración de maná %s/aguante %s/hechizos de sanación %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["intelecto %s/aguante %s/hechizos de sanación %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["daño con hechizos y sanación %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["daño y hechizos de sanación %s"] = {StatLogic.Stats.SpellDamage, }
L["daño de las sombras %s"] = {StatLogic.Stats.ShadowDamage, }
L["daño de escarcha %s"] = {StatLogic.Stats.FrostDamage, }
L["daño de fuego %s"] = {StatLogic.Stats.FireDamage, }
L["aguante %s/intelecto %s/hechizos de sanación %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.HealingPower, }
L["aguante %s/golpe %s%/sanación y daño con hechizos %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["aguante %s/fuerza %s/agilidad %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Agility, }
L["aguante %s/fuerza %s/defensa %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Defense, }
L["aguante %s/agilidad %s/golpe %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["aguante %s/defensa %s/sanación y daño con hechizos %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["aguante %s/fuerza %s/sanación y daño con hechizos %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["aguante %s/intelecto %s/sanación y daño con hechizos %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["aguante %s/agilidad %s/defensa %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Defense, }
L["aguante %s/defensa %s/probabilidad de bloqueo %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockChance, }
L["aguante %s/golpe %s%/defensa %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, StatLogic.Stats.Defense, }
L["aguante %s/defensa %s/valor de bloqueo %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockValue, }
L["aguante %s/agilidad %s/fuerza %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Strength, }
L["daño sagrado %s"] = {StatLogic.Stats.HolyDamage, }
L["daño arcano %s"] = {StatLogic.Stats.ArcaneDamage, }
L["reforzado (%s armadura)"] = {StatLogic.Stats.BonusArmor, }
L["%s índice de bloqueo con escudo"] = {StatLogic.Stats.BlockRating, }
L["golpe crítico %s%"] = {StatLogic.Stats.CritRating, }
L["%s resistencia a todo"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["%s índice de golpe crítico con hechizos"] = {StatLogic.Stats.SpellCritRating, }
L["%s índice de golpe con hechizos"] = {StatLogic.Stats.SpellHitRating, }
L["%s maná recuperado cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["%s daño arcano"] = {StatLogic.Stats.ArcaneDamage, }
L["%s daño de fuego"] = {StatLogic.Stats.FireDamage, }
L["%s daño de naturaleza"] = {StatLogic.Stats.NatureDamage, }
L["%s daño de escarcha"] = {StatLogic.Stats.FrostDamage, }
L["%s daño de las sombras"] = {StatLogic.Stats.ShadowDamage, }
L["%s daño con arma"] = {StatLogic.Stats.AverageWeaponDamage, }
L["velocidad mín. y %s agilidad"] = {StatLogic.Stats.Agility, }
L["velocidad mín. y %s aguante"] = {StatLogic.Stats.Stamina, }
L["%s resist. a las sombras"] = {StatLogic.Stats.ShadowResistance, }
L["%s resist. al fuego"] = {StatLogic.Stats.FireResistance, }
L["%s resist. a la escarcha"] = {StatLogic.Stats.FrostResistance, }
L["%s resist. a la naturaleza"] = {StatLogic.Stats.NatureResistance, }
L["%s resist. arcana"] = {StatLogic.Stats.ArcaneResistance, }
L["%s maná cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["%s índice de celeridad con hechizos"] = {StatLogic.Stats.SpellHasteRating, }
L["%s índice de golpe a distancia"] = {StatLogic.Stats.RangedHitRating, }
L["%s poder con hechizos y %s índice de golpe"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s poder con hechizos %s aguante y %s maná cada %s segundos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, StatLogic.Stats.ManaRegen, false, }
L["%s índice de golpe y %s índice de golpe crítico"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating, }
L["%s poder con hechizos arcanos y de fuego"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["%s poder con hechizos de escarcha y de las sombras"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["%s fuerza"] = {StatLogic.Stats.Strength, }
L["%s agilidad"] = {StatLogic.Stats.Agility, }
L["%s aguante"] = {StatLogic.Stats.Stamina, }
L["%s poder con hechizos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s intelecto"] = {StatLogic.Stats.Intellect, }
L["%s índice de golpe crítico"] = {StatLogic.Stats.CritRating, }
L["%s índice de defensa"] = {StatLogic.Stats.DefenseRating, }
L["%s índice de golpe"] = {StatLogic.Stats.HitRating, }
L["%s espíritu"] = {StatLogic.Stats.Spirit, }
L["%s fuerza si tienes equipadas %s gemas azules"] = {StatLogic.Stats.Strength, false, }
L["%s poder con hechizos y %s intelecto"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["%s índice de defensa y %s aguante"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["%s intelecto y %s maná cada %s s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s poder con hechizos y %s aguante"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["%s poder con hechizos y %s maná cada %s s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ManaRegen, false, }
L["%s agilidad y %s aguante"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["%s fuerza y %s aguante"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["%s poder de ataque"] = {StatLogic.Stats.AttackPower, }
L["%s índice de esquivar"] = {StatLogic.Stats.DodgeRating, }
L["%s índice de golpe crítico y %s fuerza"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s índice de parada"] = {StatLogic.Stats.ParryRating, }
L["%s índice de golpe y %s agilidad"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s índice de golpes y %s agilidad"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s índice de golpe crítico y %s aguante"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s índice de temple"] = {StatLogic.Stats.ResilienceRating, }
L["%s índice de golpe crítico y %s poder con hechizos"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s índice de golpe crítico y %s penetración de hechizos"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["%s índice de golpe crítico y %s% refracción de hechizos"] = {StatLogic.Stats.CritRating, false, }
L["%s poder de ataque y aumento mín. de velocidad de carrera"] = {StatLogic.Stats.AttackPower, }
L["%s índice de golpe crítico y reduce la duración de efectos de frenado y raíces en un %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s aguante y reducción de duración de aturdir un %s%"] = {StatLogic.Stats.Stamina, false, }
L["%s poder con hechizos y %s% amenaza reducida"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s índice de defensa y prob. de restaurar la salud con golpe"] = {StatLogic.Stats.DefenseRating, }
L["%s intelecto y prob. de restaurar maná al lanzar hechizo"] = {StatLogic.Stats.Intellect, }
L["%s aguante, %s índice de golpe crítico"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["%s aguante y %s índice de golpe crítico"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s fuerza y %s índice de golpe crítico"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s poder de ataque, %s índice de golpe crítico"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s poder con hechizos y aumento mín. de velocidad de carrera"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s índice de golpe crítico y %s maná cada %s s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s poder de ataque %s índice de golpes"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s índice de defensa y %s índice de esquivar"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s agilidad y %s índice de golpe"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s índice de parar y %s índice de defensa"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ParryRating, }
L["%s fuerza y %s índice de golpe"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s índice de esquivar y %s aguante"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s índice de golpe y %s poder con hechizos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s índice de golpe crítico y %s índice de esquivar"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["%s índice de parada y %s aguante"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["%s espíritu y %s poder con hechizos"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s poder con hechizos y %s penetración del hechizo"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder de ataque %s aguante"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.Stamina, }
L["%s índice de esquivar y %s índice de golpe"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["%s poder con hechizos y %s índice de temple"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["%s poder de ataque y %s índice de golpe crítico"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s intelecto y %s aguante"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s agilidad y %s índice de defensa"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["%s intelecto y %s espíritu"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["%s fuerza y %s índice de defensa"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["%s aguante y %s índice de defensa"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DefenseRating, }
L["%s poder de ataque y %s índice de temple"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ResilienceRating, }
L["%s aguante y %s índice de temple"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["%s poder con hechizos y %s índice de golpe crítico"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s índice de defensa y %s maná cada %s s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ManaRegen, false, }
L["%s poder con hechizos y %s espíritu"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s índice de esquivar y %s índice de temple"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["%s poder con hechizos y %s maná cada %s segundos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ManaRegen, false, }
L["%s fuerza y %s índice de temple"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["%s índice de golpe y %s aguante"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["%s índice de golpe y %s maná cada %s s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s índice de parada y %s índice de temple"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["%s poder de ataque y %s aguante"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.Stamina, }
L["%s poder de ataque y %s maná cada %s s"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ManaRegen, false, }
L["%s índice de golpe crítico y %s poder de ataque"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s índice esquivar"] = {StatLogic.Stats.DodgeRating, }
L["%s poder de ataque y %s maná cada %s segundos"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ManaRegen, false, }
L["%s agilidad y %s% de daño crítico aumentado"] = {StatLogic.Stats.Agility, false, }
L["%s poder de ataque y %s% resistencia al aturdimiento"] = {StatLogic.Stats.AttackPower, false, }
L["%s poder con hechizos y %s% resistencia al aturdimiento"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s índice de temple y %s aguante"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["%s aguante y aumento mínimo de velocidad"] = {StatLogic.Stats.Stamina, }
L["%s salud y maná cada %s s"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen, }, false, }
L["%s índice de golpe crítico y %s% daño crítico aumentado"] = {StatLogic.Stats.CritRating, false, }
L["%s índice de celeridad"] = {StatLogic.Stats.HasteRating, }
L["%s índice de celeridad y %s poder con hechizos"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s índice de celeridad y %s aguante"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["%s índice de defensa y %s% valor de bloqueo de escudo"] = {StatLogic.Stats.DefenseRating, false, }
L["%s poder con hechizos y %s% intelecto"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder con hechizos, %s índice de golpe crítico"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s índice de penetración de armadura"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s índice de pericia"] = {StatLogic.Stats.ExpertiseRating, }
L["%s índice de penetración de armadura y %s aguante"] = {false, StatLogic.Stats.Stamina, }
L["%s índice de pericia y %s aguante"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["%s agilidad y %s maná cada %s segundos"] = {StatLogic.Stats.Agility, StatLogic.Stats.ManaRegen, false, }
L["%s fuerza y %s índice de celeridad"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s agilidad y %s índice de golpe crítico"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agilidad y %s índice de temple"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["%s agilidad y %s índice de celeridad"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s poder con hechizos y %s índice de celeridad"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["%s índice de esquivar y %s índice de defensa"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["%s índice de parada y %s índice de defensa"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["%s índice de pericia y %s índice de golpe"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["%s índice de pericia y %s índice de defensa"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["%s poder de ataque y %s índice de golpe"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s poder de ataque y %s índice de celeridad"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HasteRating, }
L["%s índice de golpe crítico y %s espíritu"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["%s índice de golpe y %s espíritu"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["%s índice de temple y %s espíritu"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s índice de celeridad y %s espíritu"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["%s intelecto y %s maná cada %s segundos"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s índice de golpe crítico y %s maná cada %s segundos"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s índice de golpe y %s maná cada %s segundos"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s índice de temple y %s maná cada %s segundos"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.ManaRegen, false, }
L["%s índice de celeridad y %s maná cada %s segundos"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.ManaRegen, false, }
L["%s índice de golpe y %s penetración del hechizo"] = {StatLogic.Stats.HitRating, false, }
L["%s índice de celeridad y %s penetración de hechizos"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.SpellPenetration, }
L["%s maná cada %s segundos"] = {StatLogic.Stats.ManaRegen, false, }
L["%s índice penetración de armadura"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s índice esquivar y %s aguante"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s índice esquivar y %s índice de defensa"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["test %s intellect and %s mana every %s seconds"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s índice de celeridad a distancia"] = {StatLogic.Stats.RangedHasteRating, }
L["%s golpe crítico a distancia"] = {StatLogic.Stats.RangedCritRating, }
L["%s índice de golpe crítico y %s% de daño crítico aumentado"] = {StatLogic.Stats.CritRating, false, }
L["%s índice de golpe crítico y %s% reflejo de hechizos"] = {StatLogic.Stats.CritRating, false, }
L["%s índice de golpe crítico y reducción de duración de efectos de frenado y raíces %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s maná cada %s segundos y %s% más de efecto de sanación crítica"] = {StatLogic.Stats.ManaRegen, false, false, }
L["%s aguante y daño con hechizos recibido reducido un %s%"] = {StatLogic.Stats.Stamina, false, }
L["%s poder con hechizos y reducción de duración de silencio un %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s índice de golpe crítico y reducción de duración de miedo un %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s aguante y aumenta %s% de valor de armadura de objetos"] = {StatLogic.Stats.Stamina, false, }
L["%s poder de ataque y reducción de duración de aturdir un %s%"] = {StatLogic.Stats.AttackPower, false, }
L["%s poder con hechizos y reducción de duración de aturdir un %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder de ataque y a veces sana con tus golpes críticos"] = {StatLogic.Stats.AttackPower, }
L["%s índice de golpe crítico y %s% maná"] = {StatLogic.Stats.CritRating, false, }
L["%s índice de golpe crítico y reducción de duración de efectos de frenado y raíces un %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s penetración de hechizos"] = {StatLogic.Stats.SpellPenetration, }
L["%s índice de celeridad y %s intelecto"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s intelecto y %s índice de celeridad"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s índice de golpe crítico y %s intelecto"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intelecto y %s índice de golpe crítico"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s índice de golpe crítico y aumento mín. de velocidad de carrera"] = {StatLogic.Stats.CritRating, }
L["%s intelecto y %s% amenaza reducida"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de esquivar y prob. de restaurar la salud con golpe"] = {StatLogic.Stats.DodgeRating, }
L["%s intelecto y aumento mín. de velocidad de carrera"] = {StatLogic.Stats.Intellect, }
L["%s índice de parada y %s índice de esquivar"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["%s intelecto y %s índice de golpe"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s espíritu y %s intelecto"] = {StatLogic.Stats.Spirit, StatLogic.Stats.Intellect, }
L["%s intelecto y %s penetración de hechizos"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["%s intelecto y %s índice de temple"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s agilidad y %s índice de esquivar"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["%s fuerza y %s índice de esquivar"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["%s aguante y %s índice de esquivar"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DodgeRating, }
L["%s índice de golpe y %s índice de esquivar"] = {StatLogic.Stats.HitRating, StatLogic.Stats.DodgeRating, }
L["%s índice de golpe y %s índice de celeridad"] = {StatLogic.Stats.HitRating, StatLogic.Stats.HasteRating, }
L["%s índice de golpe crítico y %s agilidad"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agilidad y %s% de efecto crítico aumentado"] = {StatLogic.Stats.Agility, false, }
L["%s índice de golpe crítico y %s% resistencia al aturdimiento"] = {StatLogic.Stats.CritRating, false, }
L["%s intelecto y %s% resistencia al aturdimiento"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de golpe crítico y %s% efecto crítico aumentado"] = {StatLogic.Stats.CritRating, false, }
L["%s índice de esquivar y %s% valor de bloqueo de escudo"] = {StatLogic.Stats.DodgeRating, false, }
L["%s intelecto y %s% de maná máximo"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de esquivar y %s índice de parada"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ParryRating, }
L["%s índice de pericia y %s índice de esquivar"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["%s espíritu y + %s índice de temple"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s intelecto %s índice de golpe crítico"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intelecto %s índice de golpe"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s intelecto %s índice de temple"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s intelecto %s índice de celeridad"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s índice de golpe crítico y %s% de efecto crítico aumentado"] = {StatLogic.Stats.CritRating, false, }
L["%s espíritu y %s% efecto crítico aumentada"] = {StatLogic.Stats.Spirit, false, }
L["%s intelecto y reducción de duración de silencio un %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de golpe crítico y reducción de duración de aturdir un %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s intelecto y reducción de duración de aturdir un %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de celeridad y a veces sana con tus golpes críticos"] = {StatLogic.Stats.HasteRating, }
L["%s intelecto y + %s aguante"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s intelecto y + %s índice de golpe crítico"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intelecto y + %s índice de golpe"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s intelecto y + %s índice de temple"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s intelecto y + %s índice de celeridad"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s aguante y %s agilidad"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, }
L["%s índice de maestría y %s espíritu"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["%s índice de maestría y %s índice de golpe"] = {StatLogic.Stats.HitRating, StatLogic.Stats.MasteryRating, }
L["%s índice de maestría"] = {StatLogic.Stats.MasteryRating, }
L["%s índice de parada y %s índice de golpe"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["%s fuerza y %s índice de maestría"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["%s agilidad y %s índice de maestría"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["%s índice de parada y %s índice de maestría"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["%s intelecto y %s índice de maestría"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["%s índice de pericia y %s índice de maestría"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["%s índice de golpe crítico y %s índice de golpe"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["%s índice de celeridad y %s índice de golpe"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["%s índice de maestría y %s aguante"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Stamina, }
L["%s índice de maestría y aumento mín. de velocidad de carrera"] = {StatLogic.Stats.MasteryRating, }
L["%s aguante y %s% valor de bloqueo de escudo"] = {StatLogic.Stats.Stamina, false, }
L["%s espíritu y %s% de efecto crítico aumentado"] = {StatLogic.Stats.Spirit, false, }
L["%s intelecto y reduce la duración de silencio en un %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s índice de temple y %s penetración de hechizos"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.SpellPenetration, }
L["%s fuerza y %s% de efecto crítico aumentado"] = {StatLogic.Stats.Strength, false, }
L["%s intelecto y %s% de efecto crítico aumentado"] = {StatLogic.Stats.Intellect, false, }
L["%s espíritu y %s índice de golpe crítico"] = {StatLogic.Stats.Spirit, StatLogic.Stats.CritRating, }
L["%s índice de golpe y %s índice de maestría"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.HitRating, }
L["%s penetración de hechizos y %s índice de maestría"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.SpellPenetration, }
L["%s espíritu y %s índice de maestría"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Spirit, }
L["%s índice de golpe y %s índice de temple"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ResilienceRating, }
L["%s penetración de hechizos y %s índice temple"] = {StatLogic.Stats.SpellPenetration, StatLogic.Stats.ResilienceRating, }
L["%s espíritu y %s índice de temple"] = {StatLogic.Stats.Spirit, StatLogic.Stats.ResilienceRating, }
L["%s índice de golpe crítico y %s penetracion de hechizos"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["%s índice de pericia y %s índice de golpe crítico"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.CritRating, }
L["%s índice de pericia y %s índice de celeridad"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HasteRating, }
L["%s índice de pericia y %s índice de temple"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.ResilienceRating, }
L["restaura %s p. de salud cada %s s"] = {StatLogic.Stats.HealthRegen, false, }
L["espadas aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["espadas de dos manos aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["mazas aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["mazas de dos manos aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["dagas aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["arcos aumentados %s p"] = {StatLogic.Stats.WeaponSkill, }
L["armas de fuego aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["hachas aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["hachas de dos manos aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["mejora un %s% tu probabilidad de conseguir un golpe crítico"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos de fuego"] = {StatLogic.Stats.FireDamage, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos de naturaleza"] = {StatLogic.Stats.NatureDamage, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos de escarcha"] = {StatLogic.Stats.FrostDamage, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos de las sombras"] = {StatLogic.Stats.ShadowDamage, }
L["aumenta %s p. la defensa, %s p. la resistencia a las sombras y %s p. tu regeneración de salud normal"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos arcanos"] = {StatLogic.Stats.ArcaneDamage, }
L["aumenta un %s% tu probabilidad de parar un ataque"] = {StatLogic.Stats.Parry, }
L["aumenta un %s% tu probabilidad de esquivar un ataque"] = {StatLogic.Stats.Dodge, }
L["mejora tu probabilidad de golpear un %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["mejora tu probabilidad de asestar un golpe crítico con hechizos un %s%"] = {StatLogic.Stats.SpellCritRating, }
L["bastones aumentados %s"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta hasta %s p. el daño que infligen los hechizos y efectos sagrados"] = {StatLogic.Stats.HolyDamage, }
L["ballestas aumentadas %s p"] = {StatLogic.Stats.WeaponSkill, }
L["mejora un %s% tu probabilidad de golpear con hechizos"] = {StatLogic.Stats.SpellHitRating, }
L["armas de puño aumentadas %s"] = {StatLogic.Stats.WeaponSkill, }
L["las resistencias mágicas de los objetivos de tus hechizos se reducen %s p"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta un %s% la probabilidad de golpe crítico con hechizos de todos los miembros del grupo en un radio de %s m"] = {StatLogic.Stats.SpellCrit, false, }
L["aumenta hasta %s p. el daño y la sanación realizados con hechizos y efectos mágicos sobre los miembros de grupo en un radio de %s m"] = {StatLogic.Stats.SpellDamage, false, }
L["aumenta hasta %s p. la sanación realizada con hechizos y efectos mágicos sobre los miembros de grupo en un radio de %s m"] = {StatLogic.Stats.HealingPower, false, }
L["restaura %s p. de maná cada %s s a todos los miembros del grupo en un radio de %s m"] = {StatLogic.Stats.ManaRegen, false, false, }
L["aumenta hasta %s p. tu daño con hechizos y hasta %s p. tu sanación"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["mejora un %s% tu probabilidad de golpear con todos tus hechizos y ataques"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["mejora un %s% tu probabilidad de obtener un golpe crítico con todos tus hechizos y ataques"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["reduce un %s% la probabilidad de que esquiven o paren tus ataques"] = {{StatLogic.Stats.DodgeReduction, StatLogic.Stats.ParryReduction, }, }
L["aumenta un %s% tu velocidad de ataque"] = {{StatLogic.Stats.MeleeHaste, StatLogic.Stats.RangedHaste, }, }
L["aumenta %s p. el índice de defensa"] = {StatLogic.Stats.Defense, }
L["aumenta un %s% tu probabilidad de bloquear ataques con un escudo"] = {StatLogic.Stats.BlockChance, }
L["aumenta hasta %s p. el daño y la sanación de los hechizos y efectos mágicos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["aumenta hasta %s p. la sanación de los hechizos y efectos"] = {StatLogic.Stats.HealingPower, }
L["%s p. de poder de ataque solo en las formas felina, de oso y de oso temible"] = {StatLogic.Stats.FeralAttackPower, }
L["aumenta tu índice de golpe crítico %s p"] = {StatLogic.Stats.CritRating, }
L["aumenta hasta %s p. la sanación realizada y hasta %s p. todo el daño infligido con todos los hechizos y efectos mágicos"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["aumenta tu índice de golpe crítico a distancia %s p"] = {StatLogic.Stats.RangedCritRating, }
L["aumenta el índice de defensa %s p., la resistencia a las sombras %s p. y la regeneración de salud normal en %s p"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta tu índice de bloqueo %s p"] = {StatLogic.Stats.BlockRating, }
L["aumenta tu índice de golpe %s p"] = {StatLogic.Stats.HitRating, }
L["aumenta tu índice de golpe a distancia %s p"] = {StatLogic.Stats.RangedHitRating, }
L["aumenta la penetración de tus hechizos %s p"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta el índice de golpe crítico con hechizos de todos los miembros del grupo en un radio de %s m en %s p"] = {false, StatLogic.Stats.SpellCritRating, }
L["aumenta el daño infligido por hechizos y efectos sagrados hasta en %s p"] = {StatLogic.Stats.HolyDamage, }
L["tus ataques ignoran %s p. de la armadura de tu oponente"] = {StatLogic.Stats.IgnoreArmor, }
L["aumenta el índice de penetración de armadura %s p"] = {StatLogic.Stats.ArmorPenetrationRating, }
