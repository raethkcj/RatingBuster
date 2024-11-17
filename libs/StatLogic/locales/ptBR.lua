-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "ptBR" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["lei da natureza"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 55, }
W["vitalidade"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["firmeza"] = {[StatLogic.Stats.HitRating] = 10, }
W["selvageria"] = {[StatLogic.Stats.GenericAttackPower] = 70, }
W["fogo solar"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["congelar alma"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }
W["runa da gárgula litopele"] = {[StatLogic.Stats.Defense] = 25, }
W["runa da carapaça nerubiana"] = {[StatLogic.Stats.Defense] = 13, }

local L = addon.StatIDLookup
L["armadura reforçada %s"] = {StatLogic.Stats.BonusArmor, }
L["%s todas as resistências"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["cura %s"] = {StatLogic.Stats.HealingPower, }
L["%s dano mágico arcano"] = {StatLogic.Stats.ArcaneDamage, }
L["%s dano mágico de sombra"] = {StatLogic.Stats.ShadowDamage, }
L["%s dano mágico de fogo"] = {StatLogic.Stats.FireDamage, }
L["%s dano mágico sagrado"] = {StatLogic.Stats.HolyDamage, }
L["%s dano mágico de gelo"] = {StatLogic.Stats.FrostDamage, }
L["%s dano mágico de natureza"] = {StatLogic.Stats.NatureDamage, }
L["%s feitiços de cura"] = {StatLogic.Stats.HealingPower, }
L["dano mágico %s"] = {StatLogic.Stats.SpellDamage, }
L["cura e dano mágico %s"] = {StatLogic.Stats.SpellDamage, }
L["%s mana a cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["defesa %s/vigor %s/valor de bloqueio %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.BlockValue, }
L["defesa %s/vigor %s/feitiços de cura %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["poder de ataque %s/esquiva %s%"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Dodge, }
L["poder de ataque de longo alcance %s/vigor %s/acerto %s%"] = {StatLogic.Stats.RangedAttackPower, StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["cura e dano mágico %s/intelecto %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Intellect, }
L["cura e dano mágico %s/acerto com feitiços %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["cura e dano mágico %s/vigor %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Stamina, }
L["regeneração de mana %s/vigor %s/feitiços de cura %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["intelecto %s/vigor %s/feitiços de cura %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["feitiços de cura e de dano %s"] = {StatLogic.Stats.SpellDamage, }
L["dano de sombra %s"] = {StatLogic.Stats.ShadowDamage, }
L["dano de gelo %s"] = {StatLogic.Stats.FrostDamage, }
L["dano de fogo %s"] = {StatLogic.Stats.FireDamage, }
L["%s de vigor/%s de intelecto/%s de feitiços de cura"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.HealingPower, }
L["%s de vigor/%s% de acerto/%s de cura e dano mágico"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["%s de vigor/%s de força/agilidade %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Agility, }
L["%s de vigor/%s de força/%s de defesa"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Defense, }
L["%s de vigor/%s de agilidade/%s% de acerto"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["%s de vigor/%s de defesa/%s de cura e dano mágico"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["%s de vigor/%s de força/%s de cura e dano mágico"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["%s de vigor/%s de intelecto/%s de cura e dano mágico"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["%s de vigor/%s de agilidade/%s de defesa"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Defense, }
L["%s de vigor/%s de defesa/%s% de chance de bloquear"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockChance, }
L["%s de vigor/%s% de acerto/%s de defesa"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, StatLogic.Stats.Defense, }
L["%s de vigor/%s de defesa/%s de valor de bloqueio"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockValue, }
L["%s de vigor/%s de agilidade/%s de força"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Strength, }
L["reforçada (%s armadura)"] = {StatLogic.Stats.BonusArmor, }
L["%s taxa de bloqueio com escudo"] = {StatLogic.Stats.BlockRating, }
L["%s feitiços de cura e %s feitiços de dano"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["%s taxa de acerto crítico"] = {StatLogic.Stats.CritRating, }
L["%s cura e dano mágico e %s acerto de feitiço"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["%s regeneração de mana/%s vigor/%s feitiços de cura"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s taxa de acerto crítico de feitiço"] = {StatLogic.Stats.SpellCritRating, }
L["%s taxa de acerto de feitiço"] = {StatLogic.Stats.SpellHitRating, }
L["%s mana restaurado a cada %s s"] = {StatLogic.Stats.ManaRegen, false, }
L["%s dano arcano"] = {StatLogic.Stats.ArcaneDamage, }
L["%s dano de fogo"] = {StatLogic.Stats.FireDamage, }
L["%s dano de natureza"] = {StatLogic.Stats.NatureDamage, }
L["%s dano de gelo"] = {StatLogic.Stats.FrostDamage, }
L["%s dano de sombra"] = {StatLogic.Stats.ShadowDamage, }
L["%s dano da arma"] = {StatLogic.Stats.AverageWeaponDamage, }
L["menor de velocidade e %s agilidade"] = {StatLogic.Stats.Agility, }
L["menor de velocidade e %s vigor"] = {StatLogic.Stats.Stamina, }
L["%s resistência à sombra"] = {StatLogic.Stats.ShadowResistance, }
L["%s resistência ao fogo"] = {StatLogic.Stats.FireResistance, }
L["%s resistência ao gelo"] = {StatLogic.Stats.FrostResistance, }
L["%s resistência à natureza"] = {StatLogic.Stats.NatureResistance, }
L["%s resistência ao arcano"] = {StatLogic.Stats.ArcaneResistance, }
L["%s taxa de aceleração de feitiço"] = {StatLogic.Stats.SpellHasteRating, }
L["%s taxa de acerto de longo alcance"] = {StatLogic.Stats.RangedHitRating, }
L["%s poder mágico e %s taxa de acerto"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s poder mágico, %s vigor e %s mana a cada %s s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de acerto e %s taxa de acerto crítico"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating, }
L["%s dano mágico de fogo e arcano"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["%s poder mágico de gelo e sombra"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["%s força"] = {StatLogic.Stats.Strength, }
L["%s agilidade"] = {StatLogic.Stats.Agility, }
L["%s vigor"] = {StatLogic.Stats.Stamina, }
L["%s poder mágico"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s intelecto"] = {StatLogic.Stats.Intellect, }
L["%s taxa de defesa"] = {StatLogic.Stats.DefenseRating, }
L["%s taxa de acerto"] = {StatLogic.Stats.HitRating, }
L["%s espírito"] = {StatLogic.Stats.Spirit, }
L["%s força se tiver %s gemas azuis equipadas"] = {StatLogic.Stats.Strength, false, }
L["%s poder mágico e %s intelecto"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["%s taxa de defesa e %s vigor"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["%s intelecto e %s mana a cada %s s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s poder mágico e %s vigor"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["%s poder mágico e %s mana a cada %s s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ManaRegen, false, }
L["%s agilidade e %s vigor"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["%s força e %s vigor"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["%s poder de ataque"] = {StatLogic.Stats.AttackPower, }
L["%s taxa de esquiva"] = {StatLogic.Stats.DodgeRating, }
L["%s taxa de acerto crítico e %s força"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s taxa de aparo"] = {StatLogic.Stats.ParryRating, }
L["%s taxa de acerto e %s agilidade"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s taxa de acerto crítico e %s vigor"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s taxa de resiliência"] = {StatLogic.Stats.ResilienceRating, }
L["%s taxa de acerto crítico e %s poder mágico"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s taxa de acerto crítico e %s penetração de feitiço"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["%s taxa de acerto crítico e %s% reflexo mágico"] = {StatLogic.Stats.CritRating, false, }
L["%s poder de ataque e pequeno aumento na velocidade de movimento"] = {StatLogic.Stats.AttackPower, }
L["%s taxa de acerto crítico e reduz em %s% a duração de lerdeza/enraizamento"] = {StatLogic.Stats.CritRating, false, }
L["%s vigor e duração de atordoamento reduzida em %s%"] = {StatLogic.Stats.Stamina, false, }
L["%s poder mágico e ameaça reduzida em %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s vigor e %s taxa de acerto crítico"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["%s taxa de defesa e chance de restaurar vida ao acertar"] = {StatLogic.Stats.DefenseRating, }
L["%s intelecto e chance de restaurar mana ao lançar um feitiço"] = {StatLogic.Stats.Intellect, }
L["%s força, %s taxa de acerto crítico"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s poder de ataque e %s taxa de acerto crítico"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s poder mágico e pequeno aumento na velocidade de movimento"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s taxa de acerto crítico e %s mana a cada %ss"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s poder de ataque e %s taxa de acerto"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s taxa de defesa e %s taxa de esquiva"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s agilidade e %s taxa de acerto"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s taxa de aparo e %s taxa de defesa"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["%s força e %s taxa de acerto"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s taxa de acerto crítico e %s mana a cada %s s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de esquiva e %s vigor"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s taxa de acerto e %s poder mágico"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s taxa de acerto crítico e %s taxa de esquiva"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["%s taxa de aparo e %s vigor"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["%s espírito e %s poder mágico"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s poder mágico e %s penetração de feitiço"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder de ataque e %s vigor"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.Stamina, }
L["%s taxa de esquiva e %s taxa de acerto"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["%s poder mágico e %s taxa de resiliência"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["%s intelecto e %s vigor"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s força e %s taxa de acerto crítico"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s agilidade e %s taxa de defesa"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["%s intelecto e %s espírito"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["%s força e %s taxa de defesa"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["%s vigor e %s taxa de defesa"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DefenseRating, }
L["%s poder de ataque e %s taxa de resiliência"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ResilienceRating, }
L["%s vigor e %s taxa de resiliência"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["%s poder mágico e %s taxa de acerto crítico"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s taxa de defesa e %s mana a cada %s s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ManaRegen, false, }
L["%s poder mágico e %s espírito"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s taxa de esquiva e %s taxa de resiliência"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["%s força e %s taxa de resiliência"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["%s taxa de acerto e %s vigor"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["%s taxa de acerto e %s de mana a cada %s s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de aparo e %s taxa de resiliência"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["%s poder de ataque e %s mana a cada %s s"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de acerto crítico e %s poder de ataque"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s agilidade e %s% aumento no dano crítico"] = {StatLogic.Stats.Agility, false, }
L["%s poder de ataque e %s% resistência a atordoamento"] = {StatLogic.Stats.AttackPower, false, }
L["%s poder mágico e %s% resistência a atordoamento"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s mana a cada %s segundos"] = {StatLogic.Stats.ManaRegen, false, }
L["%s taxa de resiliência e %s vigor"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["%s vigor e pequeno aumento de velocidade"] = {StatLogic.Stats.Stamina, }
L["%s vida e mana a cada %s s"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen, }, false, }
L["%s taxa de acerto crítico e %s% aumento no dano crítico"] = {StatLogic.Stats.CritRating, false, }
L["%s taxa de aceleração"] = {StatLogic.Stats.HasteRating, }
L["%s taxa de aceleração e %s poder mágico"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s taxa de aceleração e %s vigor"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["%s taxa de defesa e %s% valor de bloqueio com escudo"] = {StatLogic.Stats.DefenseRating, false, }
L["%s poder mágico e %s% intelecto"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder mágico e %s de espírito"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s critical strike rating"] = {StatLogic.Stats.CritRating, }
L["%s taxa de penetração em armadura"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s taxa de aptidão"] = {StatLogic.Stats.ExpertiseRating, }
L["%s taxa de penetração em armadura e %s vigor"] = {false, StatLogic.Stats.Stamina, }
L["%s taxa de aptidão e %s vigor"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["%s agilidade e %s mana a cada %s s"] = {StatLogic.Stats.Agility, StatLogic.Stats.ManaRegen, false, }
L["%s força e %s taxa de aceleração"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s agilidade e %s taxa de acerto crítico"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agilidade e %s taxa de resiliência"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["%s agilidade e %s taxa de aceleração"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s poder mágico e %s taxa de aceleração"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["%s taxa de esquiva e %s taxa de defesa"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["%s taxa de aptidão e %s taxa de acerto"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["%s taxa de aptidão e %s taxa de defesa"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["%s poder de ataque e %s taxa de aceleração"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HasteRating, }
L["%s taxa de acerto crítico e %s espírito"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["%s taxa de acerto e %s espírito"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["%s taxa de resiliência e %s espírito"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s taxa de aceleração e %s espírito"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["%s taxa de acerto e %s mana a cada %s s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de resiliência e %s mana a cada %s s"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de aceleração e %s mana a cada %s s"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de acerto e %s penetração de feitiço"] = {StatLogic.Stats.HitRating, false, }
L["%s taxa de aceleração e %s penetração de feitiço"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.SpellPenetration, }
L["teste de %s intelecto e %s pontos de mana a cada %s segundos"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s taxa de aceleração de longo alcance"] = {StatLogic.Stats.RangedHasteRating, }
L["%s acerto crítico de longo alcance"] = {StatLogic.Stats.RangedCritRating, }
L["%s taxa de acerto crítico e dano crítico aumentado em %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s intelecto e chance de restaurar pontos de mana ao lançar um feitiço"] = {StatLogic.Stats.Intellect, }
L["%s mana a cada %s s e efeito de cura crítica aumentado em %s%"] = {StatLogic.Stats.ManaRegen, false, false, }
L["%s vigor e %s% redução do dano mágico recebido"] = {StatLogic.Stats.Stamina, false, }
L["%s poder mágico e duração de silêncio reduzida em %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s taxa de acerto crítico e duração de medo reduzida em %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s vigor e aumento de %s% no valor de armadura proveniente dos itens"] = {StatLogic.Stats.Stamina, false, }
L["%s poder de ataque e duração de atordoamento reduzida em %s%"] = {StatLogic.Stats.AttackPower, false, }
L["%s poder mágico e duração de atordoamento reduzida em %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s poder de ataque e críticos às vezes curam"] = {StatLogic.Stats.AttackPower, }
L["%s taxa de acerto crítico e %s% mana"] = {StatLogic.Stats.CritRating, false, }
L["%s penetração de feitiço"] = {StatLogic.Stats.SpellPenetration, }
L["%s taxa de aceleração e %s intelecto"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s intelecto e %s taxa de aceleração"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s taxa de acerto crítico e %s intelecto"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intelecto e %s taxa de acerto crítico"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s taxa de acerto crítico e pequeno aumento na velocidade de corrida"] = {StatLogic.Stats.CritRating, }
L["%s intelecto e %s% ameaça reduzida"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de esquiva e chance de restaurar pontos vida ao acertar"] = {StatLogic.Stats.DodgeRating, }
L["%s agility"] = {StatLogic.Stats.Agility, }
L["%s intelecto e pequeno aumento na velocidade de corrida"] = {StatLogic.Stats.Intellect, }
L["%s taxa de aparo e %s taxa de esquiva"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["%s intelecto e %s taxa de acerto"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s espírito e %s intelecto"] = {StatLogic.Stats.Spirit, StatLogic.Stats.Intellect, }
L["%s intelecto and %s penetração de feitiço"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["%s intelecto e %s taxa de resiliência"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s agilidade e %s taxa de esquiva"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["%s força e %s taxa de esquiva"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["%s vigor e %s taxa de esquiva"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DodgeRating, }
L["%s taxa de acerto e %s taxa de esquiva"] = {StatLogic.Stats.HitRating, StatLogic.Stats.DodgeRating, }
L["%s taxa de acerto e %s taxa de aceleração"] = {StatLogic.Stats.HitRating, StatLogic.Stats.HasteRating, }
L["%s taxa de acerto crítico e %s agilidade"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agilidade e aumento de %s% no efeito crítico"] = {StatLogic.Stats.Agility, false, }
L["%s taxa de acerto crítico e %s% de resistência contra atordoamento"] = {StatLogic.Stats.CritRating, false, }
L["%s intelecto e %s% de resistência ao atordoamento"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de acerto crítico e aumento de %s% no efeito crítico"] = {StatLogic.Stats.CritRating, false, }
L["%s taxa de esquiva e %s% do valor de bloqueio com escudo"] = {StatLogic.Stats.DodgeRating, false, }
L["%s intelecto e %s% do total de mana"] = {StatLogic.Stats.Intellect, false, }
L["%s intelecto e %s penetração de feitiço"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["%s taxa de esquiva e %s taxa de aparo"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ParryRating, }
L["%s taxa de aptidão e %s taxa de esquiva"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["%s espírito e %s taxa de resiliência"] = {StatLogic.Stats.Spirit, StatLogic.Stats.ResilienceRating, }
L["%s intelecto e %s% do total de pontos de mana"] = {StatLogic.Stats.Intellect, false, }
L["%s intelecto e %s% de ameaça reduzida"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de esquiva e %s% no valor de bloqueio com escudo"] = {StatLogic.Stats.DodgeRating, false, }
L["%s espírito e aumento de %s% no efeito crítico"] = {StatLogic.Stats.Spirit, false, }
L["%s intelecto e duração de silêncio reduzida em %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de acerto crítico e duração de atordoamento reduzida em %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s intelecto e duração de atordoamento reduzida em %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de aceleração e chance de se curar ao obter acertos críticos"] = {StatLogic.Stats.HasteRating, }
L["%s vigor e %s agilidade"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, }
L["%s taxa de maestria e %s espírito"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["%s taxa de maestria e %s taxa de acerto"] = {StatLogic.Stats.HitRating, StatLogic.Stats.MasteryRating, }
L["%s taxa de maestria"] = {StatLogic.Stats.MasteryRating, }
L["%s taxa de aparo e %s taxa de acerto"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["%s força e %s taxa de maestria"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["%s agilidade e %s taxa de maestria"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["%s taxa de aparo e %s taxa de maestria"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["%s intelecto e %s taxa de maestria"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["%s taxa de aptidão e %s taxa de maestria"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["%s taxa de acerto crítico e %s taxa de acerto"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["%s taxa de aceleração e %s taxa de acerto"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["%s taxa de maestria e %s vigor"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Stamina, }
L["%s taxa de maestria e pequeno aumento na velocidade de corrida"] = {StatLogic.Stats.MasteryRating, }
L["%s taxa de acerto crítico e %s% de aumento de efeito crítico"] = {StatLogic.Stats.CritRating, false, }
L["%s vigor e %s% valor de bloqueio com escudo"] = {StatLogic.Stats.Stamina, false, }
L["%s vigor e redução de %s% do dano mágico recebido"] = {StatLogic.Stats.Stamina, false, }
L["%s intelecto e %s% total de mana"] = {StatLogic.Stats.Intellect, false, }
L["%s taxa de acerto crítico e %s% de reflexo mágico"] = {StatLogic.Stats.CritRating, false, }
L["%s taxa de resiliência e %s penetração de feitiços"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.SpellPenetration, }
L["%s força e aumento de %s% no efeito crítico"] = {StatLogic.Stats.Strength, false, }
L["%s intelecto e aumento de %s% no efeito crítico"] = {StatLogic.Stats.Intellect, false, }
L["%s espírito e %s taxa de acerto crítico"] = {StatLogic.Stats.Spirit, StatLogic.Stats.CritRating, }
L["%s taxa de acerto e %s taxa de maestria"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.HitRating, }
L["%s penetração de feitiço e %s taxa de maestria"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.SpellPenetration, }
L["%s espírito e %s taxa de maestria"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Spirit, }
L["%s taxa de acerto e %s taxa de resiliência"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ResilienceRating, }
L["%s penetração de feitiço e %s taxa de resiliência"] = {StatLogic.Stats.SpellPenetration, StatLogic.Stats.ResilienceRating, }
L["%s taxa de aptidão e %s taxa de acerto crítico"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.CritRating, }
L["%s taxa de aptidão e %s taxa de aceleração"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HasteRating, }
L["%s taxa de aptidão e %s taxa de resiliência"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.ResilienceRating, }
L["restaura %s pontos de vida a cada %s s"] = {StatLogic.Stats.HealthRegen, false, }
L["aumenta em %s a perícia em espadas"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em espadas de duas mãos"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em maças"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em maças de duas mãos"] = {StatLogic.Stats.WeaponSkill, }
L["perícia em adaga aumentada em %s"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em arcos"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em armas de fogo"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em machados"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s a perícia em machados de duas mãos"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s% a chance de realizar acertos críticos"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["aumenta em até %s o dano causado por feitiços e efeitos de fogo"] = {StatLogic.Stats.FireDamage, }
L["aumenta em até %s o dano causado por feitiços e efeitos de natureza"] = {StatLogic.Stats.NatureDamage, }
L["aumenta em até %s o dano causado por feitiços e efeitos de gelo"] = {StatLogic.Stats.FrostDamage, }
L["aumenta em até %s o dano causado por feitiços e efeitos de sombra"] = {StatLogic.Stats.ShadowDamage, }
L["aumenta em %s a defesa, em %s a resistência à sombra e em %s a sua regeneração normal de vida"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta em até %s o dano causado por feitiços e efeitos arcanos"] = {StatLogic.Stats.ArcaneDamage, }
L["aumenta em %s% a sua chance de aparar ataques"] = {StatLogic.Stats.Parry, }
L["aumenta em %s% a chance de esquivar-se de ataques"] = {StatLogic.Stats.Dodge, }
L["aumenta em %s% a chance de acerto"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["aumenta em %s% a chance de realizar acertos críticos com feitiços"] = {StatLogic.Stats.SpellCrit, }
L["aumenta em %s a perícia em cajados"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em até %s o dano causado por feitiços e efeitos sagrados"] = {StatLogic.Stats.HolyDamage, }
L["aumenta em %s a perícia com bestas"] = {StatLogic.Stats.WeaponSkill, }
L["aumenta em %s% sua chance de acertar com feitiços"] = {StatLogic.Stats.SpellHit, }
L["aumenta em %s a perícia em armas de punho"] = {StatLogic.Stats.WeaponSkill, }
L["reduz em %s as resistências mágicas dos alvos dos seus feitiços"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta em %s% a chance de acerto crítico de feitiços de todos os integrantes do grupo em um raio de %s m"] = {StatLogic.Stats.SpellCrit, false, }
L["aumenta em até %s o dano causado e a cura realizada por feitiços e efeitos mágicos de todos os integrantes do grupo em um raio de %s m"] = {StatLogic.Stats.SpellDamage, false, }
L["aumenta em até %s a cura realizada por feitiços e efeitos mágicos de todos os integrantes do grupo em um raio de %s m"] = {StatLogic.Stats.HealingPower, false, }
L["restaura %s de mana a cada %s s de todos os integrantes do grupo em um raio de %s m"] = {StatLogic.Stats.ManaRegen, false, false, }
L["aumenta em até %s o seu dano mágico e em até %s a sua cura"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["melhora em %s% sua chance de acerto com todos os feitiços e ataques"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["aumenta em %s% sua chance de obter acerto crítico com todos os feitiços e ataques"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["reduz em %s% a chance de os seus ataques serem esquivados ou aparados"] = {{StatLogic.Stats.DodgeReduction, StatLogic.Stats.ParryReduction, }, }
L["aumenta em %s% a sua velocidade de ataque"] = {{StatLogic.Stats.MeleeHaste, StatLogic.Stats.RangedHaste, }, }
L["defesa aumentada em %s"] = {StatLogic.Stats.Defense, }
L["aumenta em %s% a chance de bloquear ataques com o escudo"] = {StatLogic.Stats.BlockChance, }
L["aumenta em até %s o dano causado e a cura realizada por feitiços e efeitos mágicos"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["aumenta em até %s a cura realizada por feitiços e efeitos mágicos"] = {StatLogic.Stats.HealingPower, }
L["%s de poder de ataque sob forma de felino, urso e urso hediondo"] = {StatLogic.Stats.FeralAttackPower, }
L["aumenta em %s a taxa de acerto crítico"] = {StatLogic.Stats.CritRating, }
L["aumenta em %s a cura realizada e em até %s o dano causado por todos os feitiços e efeitos mágicos"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["aumenta em %s a taxa de acerto crítico de longo alcance"] = {StatLogic.Stats.RangedCritRating, }
L["aumenta em %s a taxa de defesa, em %s a resistência à sombra e em %s a sua regeneração normal de vida"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["aumenta em %s a sua taxa de bloqueio"] = {StatLogic.Stats.BlockRating, }
L["aumenta em %s a sua taxa de acerto"] = {StatLogic.Stats.HitRating, }
L["aumenta em %s a taxa de acerto crítico de seus feitiços"] = {StatLogic.Stats.SpellCritRating, }
L["aumenta em %s a sua taxa de acerto de longo alcance"] = {StatLogic.Stats.RangedHitRating, }
L["aumenta em %s sua taxa de acerto de feitiços"] = {StatLogic.Stats.SpellHitRating, }
L["aumenta em %s sua penetração de feitiços"] = {StatLogic.Stats.SpellPenetration, }
L["aumenta em %s a taxa de acerto crítico de feitiços de todos os integrantes do grupo em um raio de %s m"] = {StatLogic.Stats.SpellCritRating, false, }
L["seus ataques ignoram %s da armadura do adversário"] = {StatLogic.Stats.IgnoreArmor, }
L["aumenta em %s a taxa de penetração em armadura"] = {StatLogic.Stats.ArmorPenetrationRating, }
