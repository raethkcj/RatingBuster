-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "enUS" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["law of nature"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 55, }
W["living stats"] = {[StatLogic.Stats.AllStats] = 4, [StatLogic.Stats.NatureResistance] = 15, }
W["vitality"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["surefooted"] = {[StatLogic.Stats.HitRating] = 10, }
W["savagery"] = {[StatLogic.Stats.GenericAttackPower] = 70, }
W["sunfire"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["soulfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }
W["rune of the stoneskin gargoyle"] = {[StatLogic.Stats.Defense] = 25, }
W["rune of the nerubian carapace"] = {[StatLogic.Stats.Defense] = 13, }

local L = addon.StatIDLookup
L["reinforced armor %s"] = {StatLogic.Stats.BonusArmor, }
L["%s all resistances"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["increases healing %s"] = {StatLogic.Stats.HealingPower, }
L["%s arcane spell damage"] = {StatLogic.Stats.ArcaneDamage, }
L["%s shadow spell damage"] = {StatLogic.Stats.ShadowDamage, }
L["%s fire spell damage"] = {StatLogic.Stats.FireDamage, }
L["%s holy spell damage"] = {StatLogic.Stats.HolyDamage, }
L["%s frost spell damage"] = {StatLogic.Stats.FrostDamage, }
L["%s nature spell damage"] = {StatLogic.Stats.NatureDamage, }
L["%s healing spells"] = {StatLogic.Stats.HealingPower, }
L["spell damage %s"] = {StatLogic.Stats.SpellDamage, }
L["healing and spell damage %s"] = {StatLogic.Stats.SpellDamage, }
L["mana regen %s per %s sec"] = {StatLogic.Stats.ManaRegen, false, }
L["defense %s/stamina %s/block value %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.BlockValue, }
L["defense %s/stamina %s/healing spells %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["attack power %s/dodge %s%"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Dodge, }
L["ranged attack power %s/stamina %s/hit %s%"] = {StatLogic.Stats.RangedAttackPower, StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["healing and spell damage %s/intellect %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Intellect, }
L["healing and spell damage %s/spell hit %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["healing and spell damage %s/stamina %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Stamina, }
L["mana regen %s/stamina %s/healing spells %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["intellect %s/stamina %s/healing spells %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, StatLogic.Stats.Healing, }
L["%s spell damage and healing"] = {StatLogic.Stats.SpellDamage, }
L["%s damage and healing spells"] = {StatLogic.Stats.SpellDamage, }
L["shadow damage %s"] = {StatLogic.Stats.ShadowDamage, }
L["frost damage %s"] = {StatLogic.Stats.FrostDamage, }
L["fire damage %s"] = {StatLogic.Stats.FireDamage, }
L["stamina %s/intellect %s/healing spells %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.HealingPower, }
L["stamina %s/hit %s%/healing and spell damage %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["stamina %s/strength %s/agility %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Agility, }
L["stamina %s/strength %s/defense %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Defense, }
L["stamina %s/agility %s/hit %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["stamina %s/defense %s/healing and spell damage %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["stamina %s/strength %s/healing and spell damage %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["stamina %s/intellect %s/healing and spell damage %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["stamina %s/agility %s/defense %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Defense, }
L["stamina %s/defense %s/block chance %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockChance, }
L["stamina %s/hit %s%/defense %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, StatLogic.Stats.Defense, }
L["stamina %s/defense %s/block value %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockValue, }
L["stamina %s/agility %s/strength %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Strength, }
L["holy damage %s"] = {StatLogic.Stats.HolyDamage, }
L["arcane damage %s"] = {StatLogic.Stats.ArcaneDamage, }
L["spell damage and healing %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["reinforced (%s armor)"] = {StatLogic.Stats.BonusArmor, }
L["%s shield block rating"] = {StatLogic.Stats.BlockRating, }
L["%s healing spells and %s damage spells"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["%s critical rating"] = {StatLogic.Stats.CritRating, }
L["%s healing and spell damage/%s spell hit"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["%s mana regen/%s stamina/%s healing spells"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s resist all"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["%s spell critical rating"] = {StatLogic.Stats.SpellCritRating, }
L["%s spell hit rating"] = {StatLogic.Stats.SpellHitRating, }
L["%s spell critical strike rating"] = {StatLogic.Stats.SpellCritRating, }
L["%s mana restored per %s seconds"] = {StatLogic.Stats.ManaRegen, false, }
L["%s arcane damage"] = {StatLogic.Stats.ArcaneDamage, }
L["%s fire damage"] = {StatLogic.Stats.FireDamage, }
L["%s nature damage"] = {StatLogic.Stats.NatureDamage, }
L["%s frost damage"] = {StatLogic.Stats.FrostDamage, }
L["%s shadow damage"] = {StatLogic.Stats.ShadowDamage, }
L["%s weapon damage"] = {StatLogic.Stats.AverageWeaponDamage, }
L["minor speed and %s agility"] = {StatLogic.Stats.Agility, }
L["minor speed and %s stamina"] = {StatLogic.Stats.Stamina, }
L["%s shadow resist"] = {StatLogic.Stats.ShadowResistance, }
L["%s fire resist"] = {StatLogic.Stats.FireResistance, }
L["%s frost resist"] = {StatLogic.Stats.FrostResistance, }
L["%s nature resist"] = {StatLogic.Stats.NatureResistance, }
L["%s arcane resist"] = {StatLogic.Stats.ArcaneResistance, }
L["%s mana every %s sec"] = {StatLogic.Stats.ManaRegen, false, }
L["%s spell haste rating"] = {StatLogic.Stats.SpellHasteRating, }
L["%s ranged hit rating"] = {StatLogic.Stats.RangedHitRating, }
L["%s spell power and %s hit rating"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s spell power %s stamina and %s mana every %s seconds"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, StatLogic.Stats.ManaRegen, false, }
L["%s hit rating and %s critical strike rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating, }
L["%s arcane and fire spell power"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["%s shadow and frost spell power"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["%s strength"] = {StatLogic.Stats.Strength, }
L["%s agility"] = {StatLogic.Stats.Agility, }
L["%s stamina"] = {StatLogic.Stats.Stamina, }
L["%s spell power"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s intellect"] = {StatLogic.Stats.Intellect, }
L["%s critical strike rating"] = {StatLogic.Stats.CritRating, }
L["%s defense rating"] = {StatLogic.Stats.DefenseRating, }
L["%s hit rating"] = {StatLogic.Stats.HitRating, }
L["%s spirit"] = {StatLogic.Stats.Spirit, }
L["%s mana every %s seconds"] = {StatLogic.Stats.ManaRegen, false, }
L["%s strength if %s blue gems equipped"] = {StatLogic.Stats.Strength, false, }
L["%s spell power and %s intellect"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["%s defense rating and %s stamina"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["%s intellect and %s mana every %s sec"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Intellect, false, }
L["%s spell power and %s stamina"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["%s spell power and %s mana every %s seconds"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ManaRegen, false, }
L["%s agility and %s stamina"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["%s strength and %s stamina"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["%s attack power"] = {StatLogic.Stats.AttackPower, }
L["%s dodge rating"] = {StatLogic.Stats.DodgeRating, }
L["%s intellect and %s mana every %s seconds"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s critical strike rating and %s strength"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s parry rating"] = {StatLogic.Stats.ParryRating, }
L["%s hit rating and %s agility"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s critical strike rating and %s stamina"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s resilience rating"] = {StatLogic.Stats.ResilienceRating, }
L["%s critical strike rating and %s spell power"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s critical strike rating and %s spell penetration"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["%s critical strike rating and %s% spell reflect"] = {StatLogic.Stats.CritRating, false, }
L["%s attack power and minor run speed increase"] = {StatLogic.Stats.AttackPower, }
L["%s critical strike rating and reduces snare/root duration by %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s stamina and stun duration reduced by %s%"] = {StatLogic.Stats.Stamina, false, }
L["%s spell power and %s% reduced threat"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s defense rating and chance to restore health on hit"] = {StatLogic.Stats.DefenseRating, }
L["%s intellect and chance to restore mana on spellcast"] = {StatLogic.Stats.Intellect, }
L["%s stamina, %s crit rating"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["%s stamina and %s critical strike rating"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s strength, %s crit rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s attack power, %s critical strike rating"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s spell power and minor run speed increase"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s critical strike rating and %s mana per %s sec"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s attack power and %s hit rating"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s defense rating and %s dodge rating"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s agility and %s hit rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s parry rating and %s defense rating"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["%s strength and %s hit rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s dodge rating and %s stamina"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s hit rating and %s spell power"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s critical strike rating and %s dodge rating"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["%s parry rating and %s stamina"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["%s spirit and %s spell power"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s spell power and %s spell penetration"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s attack power and %s stamina"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.Stamina, }
L["%s dodge rating and %s hit rating"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["%s spell power and %s resilience rating"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["%s attack power and %s critical strike rating"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s intellect and %s stamina"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s strength and %s critical strike rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s agility and %s defense rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["%s intellect and %s spirit"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["%s strength and %s defense rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["%s intellect and %s mana per %s sec"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s stamina and %s defense rating"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DefenseRating, }
L["%s attack power and %s resilience rating"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ResilienceRating, }
L["%s stamina and %s resilience rating"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["%s spell power and %s critical strike rating"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s defense rating and %s mana per %s sec"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ManaRegen, false, }
L["%s spell power and %s spirit"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s dodge rating and %s resilience rating"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["%s spell power and %s mana per %s sec"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ManaRegen, false, }
L["%s strength and %s resilience rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["%s hit rating and %s stamina"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["%s hit rating and %s mana per %s sec"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s parry rating and %s resilience rating"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["%s attack power & %s mana per %s seconds"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ManaRegen, false, }
L["%s attack power and %s mana every %s seconds"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ManaRegen, false, }
L["%s critical strike rating and %s attack power"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s agility and %s% increased critical damage"] = {StatLogic.Stats.Agility, false, }
L["%s attack power and %s% stun resistance"] = {StatLogic.Stats.AttackPower, false, }
L["%s spell power and %s% stun resistance"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s resilience rating and %s stamina"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["%s stamina and minor speed increase"] = {StatLogic.Stats.Stamina, }
L["%s health and mana every %s sec"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen, }, false, }
L["%s critical strike rating and %s% increased critical damage"] = {StatLogic.Stats.CritRating, false, }
L["%s haste rating"] = {StatLogic.Stats.HasteRating, }
L["%s haste rating and %s spell power"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s haste rating and %s stamina"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["%s defense rating and %s% shield block value"] = {StatLogic.Stats.DefenseRating, false, }
L["%s spell power and %s% intellect"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s expertise rating"] = {StatLogic.Stats.ExpertiseRating, }
L["%s armor penetration rating and %s stamina"] = {false, StatLogic.Stats.Stamina, }
L["%s expertise rating and %s stamina"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["%s agility and %s mana every %s seconds"] = {StatLogic.Stats.Agility, StatLogic.Stats.ManaRegen, false, }
L["%s strength and %s haste rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s agility and %s critical strike rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agility and %s resilience rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["%s agility and %s haste rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s spell power and %s haste rating"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["%s dodge rating and %s defense rating"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["%s expertise rating and %s hit rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["%s expertise rating and %s defense rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["%s attack power and %s haste rating"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HasteRating, }
L["%s critical strike rating and %s spirit"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["%s hit rating and %s spirit"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["%s resilience rating and %s spirit"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s haste rating and %s spirit"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["%s critical strike rating and %s mana every %s seconds"] = {StatLogic.Stats.CritRating, StatLogic.Stats.ManaRegen, false, }
L["%s hit rating and %s mana every %s seconds"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ManaRegen, false, }
L["%s resilience rating and %s mana every %s seconds"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.ManaRegen, false, }
L["%s haste rating and %s mana every %s seconds"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.ManaRegen, false, }
L["%s hit rating and %s spell penetration"] = {StatLogic.Stats.HitRating, false, }
L["%s haste rating and %s spell penetration"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.SpellPenetration, }
L["test %s intellect and %s mana every %s seconds"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ManaRegen, false, }
L["%s ranged haste rating"] = {StatLogic.Stats.RangedHasteRating, }
L["%s ranged critical strike"] = {StatLogic.Stats.RangedCritRating, }
L["%s mana every %s seconds and %s% increased critical healing effect"] = {StatLogic.Stats.ManaRegen, false, false, }
L["%s stamina and reduce spell damage taken by %s%"] = {StatLogic.Stats.Stamina, false, }
L["%s spell power and silence duration reduced by %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s critical strike rating and fear duration reduced by %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s stamina and %s% increased armor value from items"] = {StatLogic.Stats.Stamina, false, }
L["%s attack power and stun duration reduced by %s%"] = {StatLogic.Stats.AttackPower, false, }
L["%s spell power and stun duration reduced by %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s attack power and sometimes heal on your crits"] = {StatLogic.Stats.AttackPower, }
L["%s critical strike rating and %s% mana"] = {StatLogic.Stats.CritRating, false, }
L["%s spell penetration"] = {StatLogic.Stats.SpellPenetration, }
L["%s haste rating and %s intellect"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s intellect and %s haste rating"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s critical strike rating and %s intellect"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intellect and %s critical strike rating"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s critical strike rating and minor run speed increase"] = {StatLogic.Stats.CritRating, }
L["%s intellect and %s% reduced threat"] = {StatLogic.Stats.Intellect, false, }
L["%s dodge rating and chance to restore health on hit"] = {StatLogic.Stats.DodgeRating, }
L["%s intellect and minor run speed increase"] = {StatLogic.Stats.Intellect, }
L["%s parry rating and %s dodge rating"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["%s intellect and %s hit rating"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s spirit and %s intellect"] = {StatLogic.Stats.Spirit, StatLogic.Stats.Intellect, }
L["%s intellect and %s spell penetration"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["%s intellect and %s resilience rating"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s agility and %s dodge rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["%s strength and %s dodge rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["%s stamina and %s dodge rating"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DodgeRating, }
L["%s hit rating and %s dodge rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.DodgeRating, }
L["%s hit rating and %s haste rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.HasteRating, }
L["%s critical strike rating and %s agility"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s agility and %s% increased critical effect"] = {StatLogic.Stats.Agility, false, }
L["%s critical strike rating and %s% stun resistance"] = {StatLogic.Stats.CritRating, false, }
L["%s intellect and %s% stun resistance"] = {StatLogic.Stats.Intellect, false, }
L["%s critical strike rating and %s% increased critical effect"] = {StatLogic.Stats.CritRating, false, }
L["%s dodge rating and %s% shield block value"] = {StatLogic.Stats.DodgeRating, false, }
L["%s intellect and %s% maximum mana"] = {StatLogic.Stats.Intellect, false, }
L["%s dodge rating and %s parry rating"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ParryRating, }
L["%s expertise rating and %s dodge rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["%s spirit and %s resilience rating"] = {StatLogic.Stats.Spirit, StatLogic.Stats.ResilienceRating, }
L["%s spirit and %s% increased critical effect"] = {StatLogic.Stats.Spirit, false, }
L["%s intellect and silence duration reduced by %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s critical strike rating and stun duration reduced by %s%"] = {StatLogic.Stats.CritRating, false, }
L["%s intellect and stun duration reduced by %s%"] = {StatLogic.Stats.Intellect, false, }
L["%s haste rating and sometimes heal on your crits"] = {StatLogic.Stats.HasteRating, }
L["%s stamina and %s agility"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, }
L["%s mastery rating and %s spirit"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["%s mastery rating and %s hit rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.MasteryRating, }
L["%s mastery rating"] = {StatLogic.Stats.MasteryRating, }
L["%s parry rating and %s hit rating"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["%s strength and %s mastery rating"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["%s agility and %s mastery rating"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["%s parry rating and %s mastery rating"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["%s intellect and %s mastery rating"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["%s expertise rating and %s mastery rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["%s critical strike rating and %s hit rating"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["%s haste rating and %s hit rating"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["%s mastery rating and %s stamina"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Stamina, }
L["%s mastery rating and minor run speed increase"] = {StatLogic.Stats.MasteryRating, }
L["%s stamina and %s% shield block value"] = {StatLogic.Stats.Stamina, false, }
L["%s resilience rating and %s spell penetration"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.SpellPenetration, }
L["%s strength and %s% increased critical effect"] = {StatLogic.Stats.Strength, false, }
L["%s intellect and %s% increased critical effect"] = {StatLogic.Stats.Intellect, false, }
L["%s spirit and %s critical strike rating"] = {StatLogic.Stats.Spirit, StatLogic.Stats.CritRating, }
L["%s hit rating and %s mastery rating"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.HitRating, }
L["%s spell penetration and %s mastery rating"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.SpellPenetration, }
L["%s spirit and %s mastery rating"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Spirit, }
L["%s hit rating and %s resilience rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ResilienceRating, }
L["%s spell penetration and %s resilience rating"] = {StatLogic.Stats.SpellPenetration, StatLogic.Stats.ResilienceRating, }
L["%s expertise rating and %s critical strike rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.CritRating, }
L["%s expertise rating and %s haste rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HasteRating, }
L["%s expertise rating and %s resilience rating"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.ResilienceRating, }
L["increased axes %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased two-handed axes %s"] = {StatLogic.Stats.WeaponSkill, }
L["restores %s health every %s sec"] = {StatLogic.Stats.HealthRegen, false, }
L["increased swords %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased two-handed swords %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased maces %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased two-handed maces %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased daggers %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased bows %s"] = {StatLogic.Stats.WeaponSkill, }
L["increased guns %s"] = {StatLogic.Stats.WeaponSkill, }
L["improves your chance to get a critical strike by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["increases damage done by fire spells and effects by up to %s"] = {StatLogic.Stats.FireDamage, }
L["increases damage done by nature spells and effects by up to %s"] = {StatLogic.Stats.NatureDamage, }
L["increases damage done by frost spells and effects by up to %s"] = {StatLogic.Stats.FrostDamage, }
L["increases damage done by shadow spells and effects by up to %s"] = {StatLogic.Stats.ShadowDamage, }
L["increases defense by %s, shadow resistance by %s and your normal health regeneration by %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["increases damage done by arcane spells and effects by up to %s"] = {StatLogic.Stats.ArcaneDamage, }
L["increases your chance to parry an attack by %s%"] = {StatLogic.Stats.Parry, }
L["increases your chance to dodge an attack by %s%"] = {StatLogic.Stats.Dodge, }
L["improves your chance to hit by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["improves your chance to get a critical strike with spells by %s%"] = {StatLogic.Stats.SpellCrit, }
L["increased staves %s"] = {StatLogic.Stats.WeaponSkill, }
L["increases damage done by holy spells and effects by up to %s"] = {StatLogic.Stats.HolyDamage, }
L["increased crossbows %s"] = {StatLogic.Stats.WeaponSkill, }
L["improves your chance to hit with spells by %s%"] = {StatLogic.Stats.SpellHit, }
L["increased fist weapons %s"] = {StatLogic.Stats.WeaponSkill, }
L["decreases the magical resistances of your spell targets by %s"] = {StatLogic.Stats.SpellPenetration, }
L["increases the spell critical chance of all party members within %s yards by %s%"] = {false, StatLogic.Stats.SpellCrit, }
L["increases damage and healing done by magical spells and effects of all party members within %s yards by up to %s"] = {false, StatLogic.Stats.SpellDamage, }
L["increases healing done by magical spells and effects of all party members within %s yards by up to %s"] = {false, StatLogic.Stats.HealingPower, }
L["restores %s mana per %s seconds to all party members within %s yards"] = {StatLogic.Stats.ManaRegen, false, false, }
L["increases your spell damage by up to %s and your healing by up to %s"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["improves your chance to hit with all spells and attacks by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["improves your chance to get a critical strike with all spells and attacks by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["reduces the chance for your attacks to be dodged or parried by %s%"] = {{StatLogic.Stats.DodgeReduction, StatLogic.Stats.ParryReduction, }, }
L["increases your attack speed by %s%"] = {{StatLogic.Stats.MeleeHaste, StatLogic.Stats.RangedHaste, }, }
L["increased defense %s"] = {StatLogic.Stats.Defense, }
L["increases your chance to block attacks with a shield by %s%"] = {StatLogic.Stats.BlockChance, }
L["increases damage and healing done by magical spells and effects by up to %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["increases healing done by spells and effects by up to %s"] = {StatLogic.Stats.HealingPower, }
L["%s attack power in cat, bear, and dire bear forms only"] = {StatLogic.Stats.FeralAttackPower, }
L["increases your critical strike rating by %s"] = {StatLogic.Stats.CritRating, }
L["increases healing done by up to %s and damage done by up to %s for all magical spells and effects"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["increases your ranged critical strike rating by %s"] = {StatLogic.Stats.RangedCritRating, }
L["increases defense rating by %s, shadow resistance by %s and your normal health regeneration by %s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["increases your block rating by %s"] = {StatLogic.Stats.BlockRating, }
L["increases your hit rating by %s"] = {StatLogic.Stats.HitRating, }
L["increases your spell critical strike rating by %s"] = {StatLogic.Stats.SpellCritRating, }
L["increases your ranged hit rating by %s"] = {StatLogic.Stats.RangedHitRating, }
L["increases your spell hit rating by %s"] = {StatLogic.Stats.SpellHitRating, }
L["increases your spell penetration by %s"] = {StatLogic.Stats.SpellPenetration, }
L["increases the spell critical strike rating of all party members within %s yards by %s"] = {false, StatLogic.Stats.SpellCritRating, }
L["increases the damage done by holy spells and effects by up to %s"] = {StatLogic.Stats.HolyDamage, }
L["your attacks ignore %s of your opponent's armor"] = {StatLogic.Stats.IgnoreArmor, }
L["increases armor penetration rating by %s"] = {StatLogic.Stats.ArmorPenetrationRating, }
