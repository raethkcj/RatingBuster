-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "deDE" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["naturgesetz"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 55, }
W["lebendige werte"] = {[StatLogic.Stats.AllStats] = 4, [StatLogic.Stats.NatureResistance] = 15, }
W["vitalität"] = {[StatLogic.Stats.GenericManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["sicherer stand"] = {[StatLogic.Stats.HitRating] = 10, }
W["unbändigkeit"] = {[StatLogic.Stats.GenericAttackPower] = 70, }
W["sonnenfeuer"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["seelenfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }
W["rune des steinhautgargoyles"] = {[StatLogic.Stats.Defense] = 25, }
W["rune der nerubischen panzerung"] = {[StatLogic.Stats.Defense] = 13, }

local L = addon.StatIDLookup
L["verstärkte rüstung %s"] = {StatLogic.Stats.BonusArmor, }
L["alle widerstandsarten %s"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["erhöht heiligeffekte %s"] = {StatLogic.Stats.HealingPower, }
L["%s arkanzauberschaden"] = {StatLogic.Stats.ArcaneDamage, }
L["%s schattenzauberschaden"] = {StatLogic.Stats.ShadowDamage, }
L["%s feuerzauberschaden"] = {StatLogic.Stats.FireDamage, }
L["%s heiligzauberschaden"] = {StatLogic.Stats.HolyDamage, }
L["%s frostzauberschaden"] = {StatLogic.Stats.FrostDamage, }
L["%s naturzauberschaden"] = {StatLogic.Stats.NatureDamage, }
L["%s heilzauber"] = {StatLogic.Stats.HealingPower, }
L["%s zauberschaden"] = {StatLogic.Stats.SpellDamage, }
L["heilung und zauberschaden %s"] = {StatLogic.Stats.SpellDamage, }
L["manaregeneration %s per %s sek"] = {StatLogic.Stats.GenericManaRegen, false, }
L["verteidigung %s/ausdauer %s/blockwert %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.BlockValue, }
L["verteidigung %s/ausdauer %s/heilzauber %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["angriffskraft %s/ausweichen %s%"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Dodge, }
L["distanzangriffskraft %s/ausdauer %s/trefferchance %s%"] = {StatLogic.Stats.RangedAttackPower, StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["heilung und zauberschaden %s/intelligenz %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Intellect, }
L["heilung und zauberschaden %s/zaubertrefferchance %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["heilung und zauberschaden %s/ausdauer %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Stamina, }
L["manaregeneration %s/ausdauer %s/heilzauber %s"] = {StatLogic.Stats.GenericManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["intelligenz %s/ausdauer %s/heilzauber %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s zauberschaden und heilung"] = {StatLogic.Stats.SpellDamage, }
L["%s schadenszauber und heilzauber"] = {StatLogic.Stats.SpellDamage, }
L["schattenschaden %s"] = {StatLogic.Stats.ShadowDamage, }
L["frostschaden %s"] = {StatLogic.Stats.FrostDamage, }
L["feuerschaden %s"] = {StatLogic.Stats.FireDamage, }
L["ausdauer %s/intelligenz %s/heilzauber %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.HealingPower, }
L["ausdauer %s/treffer %s%/heilung und zauberschaden %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["ausdauer %s/stärke %s/beweglichkeit %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Agility, }
L["ausdauer %s/stärke %s/verteidigung %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Defense, }
L["ausdauer %s/beweglichkeit %s/treffer %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["ausdauer %s/verteidigung %s/heilung und zauberschaden %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["ausdauer %s/stärke %s/heilung und zauberschaden %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["ausdauer %s/intelligenz %s/heilung und zauberschaden %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["ausdauer %s/beweglichkeit %s/verteidigung %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Defense, }
L["ausdauer %s/verteidigung %s/blockchance %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockChance, }
L["ausdauer %s/treffer %s%/verteidigung %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, StatLogic.Stats.Defense, }
L["ausdauer %s/verteidigung %s/blockwert %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockValue, }
L["ausdauer %s/beweglichkeit %s/stärke %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Strength, }
L["heiligschaden %s"] = {StatLogic.Stats.HolyDamage, }
L["arkanschaden %s"] = {StatLogic.Stats.ArcaneDamage, }
L["zauberschaden und heilung %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["verstärkt (%s rüstung)"] = {StatLogic.Stats.BonusArmor, }
L["%s blockwertung"] = {StatLogic.Stats.BlockRating, }
L["%s heilzauber und %s schadenszauber"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["%s kritische trefferwertung"] = {StatLogic.Stats.CritRating, }
L["%s heilung und zauberschaden / %s zaubertreffer"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["%s manaregeneration / %s ausdauer / %s heilzauber"] = {StatLogic.Stats.GenericManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s alle widerstandsarten"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["%s kritische zaubertrefferwertung"] = {StatLogic.Stats.SpellCritRating, }
L["%s zaubertrefferwertung"] = {StatLogic.Stats.SpellHitRating, }
L["%s arkanschaden"] = {StatLogic.Stats.ArcaneDamage, }
L["%s feuerschaden"] = {StatLogic.Stats.FireDamage, }
L["%s naturschaden"] = {StatLogic.Stats.NatureDamage, }
L["%s frostschaden"] = {StatLogic.Stats.FrostDamage, }
L["%s schattenschaden"] = {StatLogic.Stats.ShadowDamage, }
L["%s waffenschaden"] = {StatLogic.Stats.AverageWeaponDamage, }
L["schwaches tempo und beweglichkeit %s"] = {StatLogic.Stats.Agility, }
L["schwaches tempo und %s ausdauer"] = {StatLogic.Stats.Stamina, }
L["%s schattenwiderstand"] = {StatLogic.Stats.ShadowResistance, }
L["%s feuerwiderstand"] = {StatLogic.Stats.FireResistance, }
L["%s frostwiderstand"] = {StatLogic.Stats.FrostResistance, }
L["%s naturwiderstand"] = {StatLogic.Stats.NatureResistance, }
L["%s arkanwiderstand"] = {StatLogic.Stats.ArcaneResistance, }
L["alle %s sek. %s mana"] = {false, StatLogic.Stats.GenericManaRegen, }
L["%s zaubertempowertung"] = {StatLogic.Stats.SpellHasteRating, }
L["%s stärke"] = {StatLogic.Stats.Strength, }
L["%s distanztrefferwertung"] = {StatLogic.Stats.RangedHitRating, }
L["%s zaubermacht und %s trefferwertung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s zaubermacht, %s ausdauer und alle %s sek. %s mana"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, false, false, }
L["%s trefferwertung und %s kritische trefferwertung"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["%s arkan- und feuerzaubermacht"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["%s schatten- und frostzaubermacht"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["%s beweglichkeit"] = {StatLogic.Stats.Agility, }
L["%s ausdauer"] = {StatLogic.Stats.Stamina, }
L["%s zaubermacht"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s intelligenz"] = {StatLogic.Stats.Intellect, }
L["%s verteidigungswertung"] = {StatLogic.Stats.DefenseRating, }
L["%s trefferwertung"] = {StatLogic.Stats.HitRating, }
L["%s willenskraft"] = {StatLogic.Stats.Spirit, }
L["%s stärke wenn %s blaue edelsteine angelegt"] = {StatLogic.Stats.Strength, false, }
L["%s zaubermacht und %s intelligenz"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["%s verteidigungswertung und %s ausdauer"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["%s intelligenz und alle %s sek. %s mana"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.GenericManaRegen, }
L["%s zaubermacht und %s ausdauer"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["%s zaubermacht und alle %s sek. %s mana"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, StatLogic.Stats.GenericManaRegen, }
L["%s beweglichkeit und %s ausdauer"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["%s stärke und %s ausdauer"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["%s angriffskraft"] = {StatLogic.Stats.GenericAttackPower, }
L["%s ausweichwertung"] = {StatLogic.Stats.DodgeRating, }
L["%s kritische trefferwertung und %s stärke"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s parierwertung"] = {StatLogic.Stats.ParryRating, }
L["%s trefferwertung und %s beweglichkeit"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s kritische trefferwertung und %s ausdauer"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s abhärtungswertung"] = {StatLogic.Stats.ResilienceRating, }
L["%s kritische trefferwertung und %s zaubermacht"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s kritische trefferwertung und %s zauberdurchschlagskraft"] = {StatLogic.Stats.CritRating, false, }
L["%s kritische trefferwertung und %s% zauberreflexion"] = {StatLogic.Stats.CritRating, false, }
L["%s angriffskraft und geringe bewegungstempoerhöhung"] = {StatLogic.Stats.GenericAttackPower, }
L["%s kritische trefferwertung und um %s% verringerte dauer von bewegungseinschränkung"] = {StatLogic.Stats.CritRating, false, }
L["%s ausdauer und betäubungsdauer um %s% verringert"] = {StatLogic.Stats.Stamina, false, }
L["%s zaubermacht und um %s% verringerte bedrohung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s verteidigungswertung und chance, bei treffer gesundheit wiederherstellen"] = {StatLogic.Stats.DefenseRating, }
L["%s intelligenz und chance, beim zauberwirken mana wiederherzustellen"] = {StatLogic.Stats.Intellect, }
L["%s ausdauer, %s kritische trefferwertung"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["%s stärke, %s kritische trefferwertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s zaubermacht und %s kritische trefferwertung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s ausdauer und %s kritische trefferwertung"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s angriffskraft, %s kritische trefferwertung"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.CritRating, }
L["%s zaubermacht und geringe bewegungstempoerhöhung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s kritische trefferwertung und alle %s sek. %s mana"] = {StatLogic.Stats.CritRating, false, StatLogic.Stats.GenericManaRegen, }
L["%s angriffskraft und %s trefferwertung"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.HitRating, }
L["%s verteidigungswertung und %s ausweichwertung"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s beweglichkeit und %s trefferwertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s parierwertung und %s verteidigungswertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["%s stärke und %s trefferwertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s ausweichwertung und %s ausdauer"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s kritische trefferwertung und %s ausweichwertung"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["%s parierwertung und %s ausdauer"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["%s willenskraft und %s zaubermacht"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s zaubermacht und %s zauberdurchschlagskraft"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s angriffskraft und %s ausdauer"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Stamina, }
L["%s ausweichwertung und %s trefferwertung"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["%s zaubermacht und %s abhärtungswertung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["%s angriffskraft und %s kritische trefferwertung"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.CritRating, }
L["%s intelligenz und %s ausdauer"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s stärke und %s kritische trefferwertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s beweglichkeit und %s verteidigungswertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["%s intelligenz und %s willenskraft"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["%s stärke und %s verteidigungswertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["%s ausdauer und %s verteidigungswertung"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DefenseRating, }
L["%s angriffskraft und %s abhärtungswertung"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.ResilienceRating, }
L["%s ausdauer und %s abhärtungswertung"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["%s verteidigungswertung und alle %s sek. %s mana"] = {StatLogic.Stats.DefenseRating, false, StatLogic.Stats.GenericManaRegen, }
L["%s zaubermacht und %s willenskraft"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s ausweichwertung und %s abhärtungswertung"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["%s stärke und %s abhärtungswertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["%s trefferwertung und %s ausdauer"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["%s trefferwertung und alle %s sek. %s mana"] = {StatLogic.Stats.HitRating, false, StatLogic.Stats.GenericManaRegen, }
L["%s parierwertung und %s abhärtungswertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["%s angriffskraft und alle %s sek. %s mana"] = {StatLogic.Stats.GenericAttackPower, false, StatLogic.Stats.GenericManaRegen, }
L["%s trefferwertung und %s zaubermacht"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s kritische trefferwertung und %s angriffskraft"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.CritRating, }
L["%s beweglichkeit und um %s% erhöhter kritischer schaden"] = {StatLogic.Stats.Agility, false, }
L["%s angriffskraft und %s% betäubungswiderstand"] = {StatLogic.Stats.GenericAttackPower, false, }
L["%s zaubermacht und %s% betäubungswiderstand"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s abhärtungswertung und %s ausdauer"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["%s ausdauer und schwache temposteigerung"] = {StatLogic.Stats.Stamina, }
L["alle %s sek. %s gesundheit und mana"] = {false, {StatLogic.Stats.HealthRegen, StatLogic.Stats.GenericManaRegen, }, }
L["%s kritische trefferwertung und um %s% erhöhter kritischer schaden"] = {StatLogic.Stats.CritRating, false, }
L["%s tempowertung"] = {StatLogic.Stats.HasteRating, }
L["%s tempowertung und %s zaubermacht"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s tempowertung und %s ausdauer"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["%s verteidigungswertung und %s% schildblockwert"] = {StatLogic.Stats.DefenseRating, false, }
L["%s zaubermacht und %s% intelligenz"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s rüstungsdurchschlagwertung"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating, }
L["%s rüstungsdurchschlagwertung und %s ausdauer"] = {false, StatLogic.Stats.Stamina, }
L["%s waffenkundewertung und %s ausdauer"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["%s beweglichkeit und alle %s sek. %s mana"] = {StatLogic.Stats.Agility, false, StatLogic.Stats.GenericManaRegen, }
L["%s zaubermacht und %s zauberdurchschlag"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s stärke und %s tempowertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s beweglichkeit und %s kritische trefferwertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s beweglichkeit und %s abhärtungswertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["%s beweglichkeit und %s tempowertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s zaubermacht und %s tempowertung"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["%s ausweichwertung und %s verteidigungswertung"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["%s waffenkundewertung und %s trefferwertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["%s waffenkundewertung und %s verteidigungswertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["%s angriffskraft und %s tempowertung"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.HasteRating, }
L["%s kritische trefferwertung und %s willenskraft"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["%s trefferwertung und %s willenskraft"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["%s abhärtungswertung und %s willenskraft"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s tempowertung und %s willenskraft"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["%s abhärtungswertung und alle %s sek. %s mana"] = {StatLogic.Stats.ResilienceRating, false, StatLogic.Stats.GenericManaRegen, }
L["%s tempowertung und alle %s sek. %s mana"] = {StatLogic.Stats.HasteRating, false, StatLogic.Stats.GenericManaRegen, }
L["%s kritische trefferwertung und %s zauberdurchschlag"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["%s trefferwertung und %s zauberdurchschlag"] = {StatLogic.Stats.HitRating, false, }
L["%s tempowertung und %s zauberdurchschlag"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.SpellPenetration, }
L["test: %s intelligenz und alle %s sek. %s mana"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.GenericManaRegen, }
L["%s distanztempowertung"] = {StatLogic.Stats.RangedHasteRating, }
L["%s kritische distanztrefferwertung"] = {StatLogic.Stats.RangedCritRating, }
L["%s intelligenz und chance, beim zauberwirken mana zu regenerieren"] = {StatLogic.Stats.Intellect, }
L["%s% erhöhte kritische heileffekte und alle %s sek. %s mana"] = {StatLogic.Stats.GenericManaRegen, false, false, }
L["%s ausdauer und erlittener zauberschaden um %s% verringert"] = {StatLogic.Stats.Stamina, false, }
L["%s zaubermacht und um %s% verkürzte dauer von stilleeffekten"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s kritische trefferwertung und um %s% verkürzte dauer von furchteffekten"] = {StatLogic.Stats.CritRating, false, }
L["%s ausdauer und durch gegenstände erzielte rüstung um %s% erhöht"] = {StatLogic.Stats.Stamina, false, }
L["%s angriffskraft und %s% verkürzte dauer von betäubungseffekten"] = {StatLogic.Stats.GenericAttackPower, false, }
L["%s zaubermacht und um %s% verkürzte dauer von betäubungseffekten"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s angriffskraft und heilt manchmal bei erzielten kritischen treffern"] = {StatLogic.Stats.GenericAttackPower, }
L["%s kritische trefferwertung und %s% mana"] = {StatLogic.Stats.CritRating, false, }
L["%s ausdauer und um %s% verkürzte dauer von betäubungseffekten"] = {StatLogic.Stats.Stamina, false, }
L["%s angriffskraft und um %s% verkürzte dauer von betäubungseffekten"] = {StatLogic.Stats.GenericAttackPower, false, }
L["%s zauberdurchschlag"] = {StatLogic.Stats.SpellPenetration, }
L["%s tempowertung und %s intelligenz"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s intelligenz und %s tempowertung"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["%s kritische trefferwertung und %s intelligenz"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s intelligenz und %s kritische trefferwertung"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["%s kritische trefferwertung und geringe bewegungstempoerhöhung"] = {StatLogic.Stats.CritRating, }
L["%s intelligenz und um %s% verringerte bedrohung"] = {StatLogic.Stats.Intellect, false, }
L["%s ausweichwertung und chance, bei treffer gesundheit wiederherzustellen"] = {StatLogic.Stats.DodgeRating, }
L["%s intelligenz und geringe bewegungstempoerhöhung"] = {StatLogic.Stats.Intellect, }
L["%s ausweichwertung und %s parierwertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["%s intelligenz und %s trefferwertung"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s willenskraft und %s intelligenz"] = {StatLogic.Stats.Spirit, StatLogic.Stats.Intellect, }
L["%s intelligenz und %s zauberdurchschlag"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["%s intelligenz und %s abhärtungswertung"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["%s ausweichwertung und %s beweglichkeit"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["%s ausweichwertung und %s stärke"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["%s trefferwertung und %s ausweichwertung"] = {StatLogic.Stats.HitRating, StatLogic.Stats.DodgeRating, }
L["%s trefferwertung und %s tempowertung"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["%s kritische trefferwertung und %s beweglichkeit"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s beweglichkeit und um %s% erhöhter kritischer effekt"] = {StatLogic.Stats.Agility, false, }
L["%s kritische trefferwertung und %s% betäubungswiderstand"] = {StatLogic.Stats.CritRating, false, }
L["%s intelligenz und %s% betäubungswiderstand"] = {StatLogic.Stats.Intellect, false, }
L["%s kritische trefferwertung und um %s% erhöhter kritischer effekt"] = {StatLogic.Stats.CritRating, false, }
L["%s ausweichwertung und %s% schildblockwert"] = {StatLogic.Stats.DodgeRating, false, }
L["%s intelligenz und %s% maximales mana"] = {StatLogic.Stats.Intellect, false, }
L["%s ausweichwertung und %s waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["%s stärke und %s ausweichwertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["%s willenskraft und %s abhärtungswertung"] = {StatLogic.Stats.Spirit, StatLogic.Stats.ResilienceRating, }
L["%s willenskraft und um %s% erhöhter kritischer effekt"] = {StatLogic.Stats.Spirit, false, }
L["%s intelligenz und um %s% verkürzte dauer von stilleeffekten"] = {StatLogic.Stats.Intellect, false, }
L["%s kritische trefferwertung und um %s% verkürzte dauer von betäubungseffekten"] = {StatLogic.Stats.CritRating, false, }
L["%s intelligenz und um %s% verkürzte dauer von betäubungseffekten"] = {StatLogic.Stats.Intellect, false, }
L["%s tempowertung und heilt manchmal bei erzielten kritischen treffern"] = {StatLogic.Stats.HasteRating, }
L["%s ausdauer und %s beweglichkeit"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, }
L["%s meisterschaftswertung und %s willenskraft"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s trefferwertung"] = {StatLogic.Stats.HitRating, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung"] = {StatLogic.Stats.MasteryRating, }
L["%s trefferwertung und %s stärke"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s trefferwertung und %s parierwertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["%s trefferwertung und %s intelligenz"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["%s waffenkundewertung und %s ausweichwertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["%s tempowertung und %s stärke"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s tempowertung und %s beweglichkeit"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s meisterschaftswertung und %s stärke"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s beweglichkeit"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s parierwertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s intelligenz"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s waffenkundewertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["%s meisterschaftswertung und %s ausdauer"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Stamina, }
L["%s parierwertung und %s meisterschaftswertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["%s beweglichkeit und %s ausweichwertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["%s meisterschaftswertung und geringe lauftempoerhöhung"] = {StatLogic.Stats.MasteryRating, }
L["%s ausdauer und %s% schildblockwert"] = {StatLogic.Stats.Stamina, false, }
L["%s ausdauer und um %s% erhöhter rüstungswert durch gegenstände"] = {StatLogic.Stats.Stamina, false, }
L["%s ausdauer und um %s% verringerter zauberschaden"] = {StatLogic.Stats.Stamina, false, }
L["%s ausdauer und um %s% verringerte betäubungsdauer"] = {StatLogic.Stats.Stamina, false, }
L["%s intelligenz und um %s% verringerte dauer von stilleeffekten"] = {StatLogic.Stats.Intellect, false, }
L["%s abhärtungswertung und %s zauberdurchschlag"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.SpellPenetration, }
L["%s stärke und um %s% erhöhter kritischer effekt"] = {StatLogic.Stats.Strength, false, }
L["%s intelligenz und um %s% erhöhter kritischer effekt"] = {StatLogic.Stats.Intellect, false, }
L["%s willenskraft und %s kritische trefferwertung"] = {StatLogic.Stats.Spirit, StatLogic.Stats.CritRating, }
L["%s kritische trefferwertung und %s trefferwertung"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["%s tempowertung und %s trefferwertung"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["%s trefferwertung und %s meisterschaftswertung"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.HitRating, }
L["%s zauberdurchschlag und %s meisterschaftswertung"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.SpellPenetration, }
L["%s willenskraft und %s meisterschaftswertung"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Spirit, }
L["%s trefferwertung und %s abhärtungswertung"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ResilienceRating, }
L["%s zauberdurchschlag und %s abhärtungswertung"] = {StatLogic.Stats.SpellPenetration, StatLogic.Stats.ResilienceRating, }
L["%s waffenkundewertung und %s kritische trefferwertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.CritRating, }
L["%s parierwertung und %s ausweichwertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["%s waffenkundewertung und %s tempowertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HasteRating, }
L["%s beweglichkeit und %s meisterschaftswertung"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["%s waffenkundewertung und %s meisterschaftswertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["%s intelligenz und %s meisterschaftswertung"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["%s stärke und %s meisterschaftswertung"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["%s waffenkundewertung und %s abhärtungswertung"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.ResilienceRating, }
L["%s parierwertung und %s trefferwertung"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["stellt alle %s sek. %s punkt(e) gesundheit wieder her"] = {false, StatLogic.Stats.HealthRegen, }
L["schwerter %s"] = {StatLogic.Stats.WeaponSkill, }
L["zweihandschwerter %s"] = {StatLogic.Stats.WeaponSkill, }
L["streitkolben %s"] = {StatLogic.Stats.WeaponSkill, }
L["zweihandstreitkolben %s"] = {StatLogic.Stats.WeaponSkill, }
L["dolche %s"] = {StatLogic.Stats.WeaponSkill, }
L["bogen %s"] = {StatLogic.Stats.WeaponSkill, }
L["schusswaffen %s"] = {StatLogic.Stats.WeaponSkill, }
L["äxte %s"] = {StatLogic.Stats.WeaponSkill, }
L["zweihandäxte %s"] = {StatLogic.Stats.WeaponSkill, }
L["erhöht eure chance, einen kritischen treffer zu erzielen, um %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["erhöht durch feuerzauber und feuereffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.FireDamage, }
L["erhöht durch naturzauber und natureffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.NatureDamage, }
L["erhöht durch frostzauber und frosteffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.FrostDamage, }
L["erhöht durch schattenzauber und schatteneffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.ShadowDamage, }
L["verbessert verteidigung um %s, schattenwiderstand um %s sowie gesundheitsregeneration um %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["erhöht durch arkanzauber und arkaneffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.ArcaneDamage, }
L["erhöht eure chance, einen angriff zu parieren, um %s%"] = {StatLogic.Stats.Parry, }
L["erhöht eure chance, einem angriff auszuweichen, um %s%"] = {StatLogic.Stats.Dodge, }
L["verbessert eure trefferchance um %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["erhöht eure chance, einen kritischen treffer durch zauber zu erzielen, um %s%"] = {StatLogic.Stats.SpellCrit, }
L["stäbe %s"] = {StatLogic.Stats.WeaponSkill, }
L["erhöht durch heiligzauber und heiligeffekte zugefügten schaden um bis zu %s"] = {StatLogic.Stats.HolyDamage, }
L["armbrüste %s"] = {StatLogic.Stats.WeaponSkill, }
L["erhöht eure chance mit zaubern zu treffen um %s%"] = {StatLogic.Stats.SpellHit, }
L["faustwaffen %s"] = {StatLogic.Stats.WeaponSkill, }
L["reduziert die magiewiderstände der ziele eurer zauber um %s"] = {StatLogic.Stats.SpellPenetration, }
L["erhöht die chance aller gruppenmitglieder, die sich im umkreis von %s befinden, auf einen kritischen treffer mit zaubern um %s%"] = {false, StatLogic.Stats.SpellCrit, }
L["erhöht durch zauber und magische effekte zugefügten schaden und heilung aller gruppenmitglieder, die sich im umkreis von %s befinden, um bis zu %s"] = {false, StatLogic.Stats.SpellDamage, }
L["erhöht durch zauber und magische effekte verursachte heilung aller gruppenmitglieder, die sich im umkreis von %s befinden, um bis zu %s"] = {false, StatLogic.Stats.HealingPower, }
L["stellt alle %s sek. %s punkt(e) mana bei allen gruppenmitgliedern, die sich im umkreis von %s befinden, wieder her"] = {false, StatLogic.Stats.GenericManaRegen, false, }
L["erhöht euren zauberschaden um bis zu %s und eure heilung um bis zu %s"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["erhöht eure trefferchance mit allen angriffen und zaubern um %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["erhöht eure kritische trefferchance aller eurer angriffe und zauber um %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["verringert die chance, dass eure angriffe pariert werden oder ihnen ausgewichen wird, um %s%"] = {{StatLogic.Stats.DodgeReduction, StatLogic.Stats.ParryReduction, }, }
L["erhöht eurer angriffstempo um %s%"] = {{StatLogic.Stats.MeleeHaste, StatLogic.Stats.RangedHaste, }, }
L["erhöht durch zauber und magische effekte verursachten schaden und hervorgerufene heilung aller gruppenmitglieder innerhalb von %s metern um bis zu %s. dieser spezifische effekt ist nicht über mehrere quellen stapelbar"] = {false, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["erhöht für alle gruppenmitglieder innerhalb von %s metern durch sämtliche zauber und magische effekte hervorgerufene heilung um bis zu %s gesundheit und den verursachten schaden um bis zu %s. dieser spezifische effekt ist nicht über mehrere quellen stapelbar"] = {false, StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["erhöht das zaubertempo aller gruppenmitglieder innerhalb von %s metern um %s%. dieser spezifische effekt ist nicht über mehrere quellen stapelbar"] = {false, StatLogic.Stats.SpellHaste, }
L["erhöht die kritische zaubertrefferchance aller gruppenmitglieder innerhalb von %s metern um %s%. dieser spezifische effekt ist nicht über mehrere quellen stapelbar"] = {false, StatLogic.Stats.SpellCrit, }
L["erhöht das zaubertempo eurer nicht kanalisierten zauber um %s%"] = {StatLogic.Stats.SpellHaste, }
L["verteidigung %s"] = {StatLogic.Stats.Defense, }
L["erhöht eure chance, angriffe mit einem schild zu blocken, um %s%"] = {StatLogic.Stats.BlockChance, }
L["erhöht durch zauber und magische effekte zugefügten schaden und heilung um bis zu %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["erhöht durch zauber und effekte verursachte heilung um bis zu %s"] = {StatLogic.Stats.HealingPower, }
L["%s angriffskraft in katzengestalt, bärengestalt oder terrorbärengestalt"] = {StatLogic.Stats.FeralAttackPower, }
L["erhöht durch sämtliche zauber und magische effekte hervorgerufene heilung um bis zu %s gesundheit und den verursachten schaden um bis zu %s"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["erhöht eure kritische trefferwertung um %s"] = {StatLogic.Stats.CritRating, }
L["erhöht durch sämtliche zauber und magische effekte verursachte heilung um bis zu %s und den verursachten schaden um bis zu %s"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["erhöht eure kritische distanztrefferwertung um %s"] = {StatLogic.Stats.RangedCritRating, }
L["verbessert verteidigungswertung um %s, schattenwiderstand um %s sowie eure normale gesundheitsregeneration um %s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["erhöht eure blockwertung um %s"] = {StatLogic.Stats.BlockRating, }
L["erhöht eure trefferwertung um %s"] = {StatLogic.Stats.HitRating, }
L["erhöht eure kritische zaubertrefferwertung um %s"] = {StatLogic.Stats.SpellCritRating, }
L["erhöht eure distanztrefferwertung um %s"] = {StatLogic.Stats.RangedHitRating, }
L["erhöht eure zaubertrefferwertung um %s"] = {StatLogic.Stats.SpellHitRating, }
L["erhöht eure zauberdurchschlagskraft um %s"] = {StatLogic.Stats.SpellPenetration, }
L["erhöht die kritische zaubertrefferwertung aller gruppenmitglieder innerhalb von %s metern um %s"] = {false, StatLogic.Stats.SpellCritRating, }
L["eure angriffe ignorieren %s rüstung eures gegners"] = {StatLogic.Stats.IgnoreArmor, }
L["erhöht die rüstungsdurchschlagwertung um %s"] = {StatLogic.Stats.ArmorPenetrationRating, }
