-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "esES" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["vitalidad"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["pies de plomo"] = {[StatLogic.Stats.HitRating] = 10, }
W["salvajismo"] = {[StatLogic.Stats.AttackPower] = 70, }
W["fuego solar"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["escarcha de alma"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }

local L = addon.StatIDLookup
L["armadura reforzada %s"] = {StatLogic.Stats.BonusArmor, }
L["%s todas las resistencias"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["aumenta curación %s"] = {StatLogic.Stats.HealingPower, }
L["%s de daño de hechizos arcanos"] = {StatLogic.Stats.ArcaneDamage, }
L["%s de daño de hechizos de sombras"] = {StatLogic.Stats.ShadowDamage, }
L["%s de daño de hechizos de fuego"] = {StatLogic.Stats.FireDamage, }
L["%s de daño de hechizos sagrados"] = {StatLogic.Stats.HolyDamage, }
L["%s de daño de hechizos de escarcha"] = {StatLogic.Stats.FrostDamage, }
L["%s de daño de hechizos de naturaleza"] = {StatLogic.Stats.NatureDamage, }
L["%s de hechizos de curación"] = {StatLogic.Stats.HealingPower, }
L["daño de hechizos %s"] = {StatLogic.Stats.SpellDamage, }
L["curación y daño de hechizos %s"] = {StatLogic.Stats.SpellDamage, }
L["%s de regeneración de maná cada %s seg"] = {StatLogic.Stats.ManaRegen, false, }
L["curación y daño de hechizos %s/hechizo impacto %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["regeneración de maná %s/aguante %s/hechizos de curación %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s de daño de hechizos y curación"] = {StatLogic.Stats.SpellDamage, }
L["%s de daño y hechizos de curación"] = {StatLogic.Stats.SpellDamage, }
L["daño de sombras %s"] = {StatLogic.Stats.ShadowDamage, }
L["daño de escarcha %s"] = {StatLogic.Stats.FrostDamage, }
L["daño de fuego %s"] = {StatLogic.Stats.FireDamage, }
L["reforzado (%s armadura)"] = {StatLogic.Stats.BonusArmor, }
L["%s índice de bloqueo con escudo"] = {StatLogic.Stats.BlockRating, }
L["%s hechizos de sanación y %s hechizos de daño"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["%s índice de golpe crítico"] = {StatLogic.Stats.CritRating, }
L["%s sanación y daño con hechizos/%s golpe con hechizo"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["%s regen. de maná/%s aguante/%s hechizos de sanación"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s resistencia a todo"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["%s índice de golpe crítico con hechizos"] = {StatLogic.Stats.SpellCritRating, }
L["%s índice de golpe con hechizos"] = {StatLogic.Stats.SpellHitRating, }
L["%s maná recuperado cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["%s daño arcano"] = {StatLogic.Stats.ArcaneDamage, }
L["%s daño de fuego"] = {StatLogic.Stats.FireDamage, }
L["%s daño de naturaleza"] = {StatLogic.Stats.NatureDamage, }
L["%s daño de escarcha"] = {StatLogic.Stats.FrostDamage, }
L["%s daño de las sombras"] = {StatLogic.Stats.ShadowDamage, }
L["%s daño de arma"] = {StatLogic.Stats.AverageWeaponDamage, }
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
L["%s índice de golpe crítico y %s aguante"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s índice de temple"] = {StatLogic.Stats.ResilienceRating, }
L["%s índice de golpe crítico y %s poder con hechizos"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s índice de golpe crítico y %s penetración del hechizo"] = {StatLogic.Stats.CritRating, false, }
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
L["%s poder de ataque %s índice de golpe"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s índice de defensa y %s índice de esquivar"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s agilidad y %s índice de golpe"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s índice de parada y %s índice de defensa"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
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
L["%s índice de celeridad y %s penetración del hechizo"] = {StatLogic.Stats.HasteRating, false, }
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
L["restaura %s p. de salud cada %s s"] = {StatLogic.Stats.HealthRegen, false, }
L["mejora tu probabilidad de conseguir un golpe crítico en %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["aumenta el daño causado por los hechizos de fuego y los efectos hasta en %s p"] = {StatLogic.Stats.FireDamage, }
L["aumenta el daño causado por los hechizos de naturaleza y los efectos hasta en %s p"] = {StatLogic.Stats.NatureDamage, }
L["aumenta el daño causado por los hechizos de escarcha y los efectos hasta en %s p"] = {StatLogic.Stats.FrostDamage, }
L["aumenta el daño causado por los hechizos de sombras y los efectos hasta en %s p"] = {StatLogic.Stats.ShadowDamage, }
L["aumenta la defensa en %s p., la resistencia a las sombras en %s p. y la regeneración de tu salud normal en %s p"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta el daño causado por los hechizos arcanos y los efectos hasta en %s p"] = {StatLogic.Stats.ArcaneDamage, }
L["aumenta la probabilidad de parar un ataque en un %s%"] = {StatLogic.Stats.Parry, }
L["aumenta la probabilidad de esquivar un ataque en un %s%"] = {StatLogic.Stats.Dodge, }
L["mejora tu probabilidad de alcanzar el objetivo en un %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["mejora tu probabilidad de conseguir un golpe crítico en %s% con los hechizos"] = {StatLogic.Stats.SpellCrit, }
L["aumenta el daño causado por los hechizos sagrados y los efectos hasta en %s p"] = {StatLogic.Stats.HolyDamage, }
L["mejora tu probabilidad de alcanzar el objetivo con hechizos en un %s%"] = {StatLogic.Stats.SpellHit, }
L["reduce las resistencias mágicas de los objetivos de tus hechizos en %s p"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta en un %s% la probabilidad de impacto crítico mediante hechizos de todos los miembros del grupo en un radio de %s metros"] = {StatLogic.Stats.SpellCrit, false, }
L["aumenta hasta en %s p. el daño y la curación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de %s metros"] = {StatLogic.Stats.SpellDamage, false, }
L["aumenta hasta en %s p. la curación de los hechizos mágicos y los efectos para todos los miembros del grupo en un radio de %s metros"] = {StatLogic.Stats.HealingPower, false, }
L["restaura %s p. de maná cada %s segundos de todos los miembros del grupo que estén a %s metros"] = {StatLogic.Stats.ManaRegen, false, false, }
L["aumenta el daño de tus hechizos hasta %s p. y tu curación hasta %s p"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["mejora un %s% tu probabilidad de golpear con todos los hechizos y ataques"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["mejora un %s% tu probabilidad de conseguir un golpe crítico con todos los hechizos y ataques"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["defensa aumentada %s"] = {StatLogic.Stats.Defense, }
L["aumenta la probabilidad de bloquear ataques con un escudo en un %s%"] = {StatLogic.Stats.BlockChance, }
L["aumenta el daño y la curación de los hechizos mágicos y los efectos hasta en %s p"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["aumenta la curación de los hechizos y los efectos hasta en %s p"] = {StatLogic.Stats.HealingPower, }
L["%s p. de poder de ataque solo bajo formas felinas, de oso y de oso nefasto"] = {StatLogic.Stats.FeralAttackPower, }
L["aumenta tu índice de golpe crítico en %s p"] = {StatLogic.Stats.CritRating, }
L["aumenta la sanación que haces hasta %s p. y el daño que infliges hasta %s p. con todos los hechizos mágicos y efectos"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["aumenta tu índice de golpe crítico a distancia en %s p"] = {StatLogic.Stats.RangedCritRating, }
L["aumenta el índice de defensa en %s p., la resistencia a las sombras en %s p. y la regeneración de salud normal en %s p"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta tu índice de bloqueo en %s p"] = {StatLogic.Stats.BlockRating, }
L["aumenta tu índice de golpe en %s p"] = {StatLogic.Stats.HitRating, }
L["aumenta tu índice de golpe crítico con hechizos en %s p"] = {StatLogic.Stats.SpellCritRating, }
L["aumenta tu índice de golpe a distancia en %s p"] = {StatLogic.Stats.RangedHitRating, }
L["aumenta tu índice de golpe con hechizos en %s p"] = {StatLogic.Stats.SpellHitRating, }
L["aumenta la penetración de tus hechizos en %s p"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta el índice de golpe crítico con hechizos de todos los miembros del grupo a %s m. en %s p"] = {false, StatLogic.Stats.SpellCritRating, }
L["aumenta el daño infligido por hechizos y efectos sagrados hasta en %s p"] = {StatLogic.Stats.HolyDamage, }
L["tus ataques ignoran %s p. de la armadura de tu oponente"] = {StatLogic.Stats.IgnoreArmor, }
L["aumenta el índice de penetración de armadura %s p"] = {StatLogic.Stats.ArmorPenetrationRating, }
