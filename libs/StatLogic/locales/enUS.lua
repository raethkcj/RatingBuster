local addonName, addon = ...
if GetLocale() ~= "enUS" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["Savagery"] = {[StatLogic.Stats.AttackPower] = 70} -- enchant 2667 TBC
W["Vitality"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4} -- enchant 2656 TBC
W["Soulfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54} -- enchant 2672 TBC
W["Sunfire"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50} -- enchant 2671 TBC
W["Surefooted"] = {[StatLogic.Stats.HitRating] = 10} -- enchant 2658 WholeText TBC

local L = addon.StatIDLookup
L["minor speed and %s agility"] = {StatLogic.Stats.Agility} -- enchant 2939 TBC
L["minor speed and %s stamina"] = {StatLogic.Stats.Stamina} -- enchant 2940 TBC
L["%s stamina and minor speed increase"] = {StatLogic.Stats.Stamina} -- enchant 3232 Wrath
L["%s shadow and frost spell power"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage}} -- enchant 2672 Wrath
L["%s arcane and fire spell power"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage}} -- enchant 2671 Wrath
L["%s health and mana every %s sec"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen}, false} -- enchant 2656 Wrath
L["%s hit rating and %s critical strike rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating} -- enchant 2658 Wrath
L["your attacks ignore %s of your opponent's armor"] = {StatLogic.Stats.IgnoreArmor} -- spell 43901 TBC
L["%s weapon damage"] = {StatLogic.Stats.AverageWeaponDamage} -- enchant 2929 TBC

L["%s arcane resist"] = {StatLogic.Stats.ArcaneResistance,} -- enchant 2989 TBC
L["%s fire resist"] = {StatLogic.Stats.FireResistance,} -- enchant 2985 TBC
L["%s nature resist"] = {StatLogic.Stats.NatureResistance,} -- enchant 2988 TBC
L["%s frost resist"] = {StatLogic.Stats.FrostResistance,} -- enchant 2987 TBC
L["%s shadow resist"] = {StatLogic.Stats.ShadowResistance,} -- enchant 2984 TBC
L["%s all resistances"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,} -- enchant 28 Vanilla
L["%s resist all"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,} -- enchant 2663 TBC

L["reinforced armor %s"] = {StatLogic.Stats.BonusArmor} -- enchant 15 Vanilla
L["reinforced (%s armor)"] = {StatLogic.Stats.BonusArmor} -- enchant 15 TBC
L["increased defense %s"] = {StatLogic.Stats.Defense,} -- spell 13387 Vanilla

L["%s attack power in cat, bear, and dire bear forms only"] = {StatLogic.Stats.FeralAttackPower} -- spell 24697 Vanilla

L["increases defense by %s, shadow resistance by %s and your normal health regeneration by %s."] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen,} -- spell 12956 Vanilla
L["increases defense rating by %s, shadow resistance by %s and your normal health regeneration by %s."] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen,} -- spell 12956 TBC
L["restores %s health every %s sec"] = {StatLogic.Stats.HealthRegen, false} -- spell 5707 Vanilla
L["mana regen %s/stamina %s/healing spells %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower} -- enchant 2590 Vanilla
L["%s mana regen/%s stamina/%s healing spells"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower} -- enchant 2590 TBC
L["%s spell power %s stamina and %s mana every %s seconds"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, StatLogic.Stats.Stamina, StatLogic.Stats.ManaRegen, false} -- enchant 2590 Wrath
L["%s mana every %s sec"] = {StatLogic.Stats.ManaRegen, false} -- enchant 3150 TBC
L["%s mana restored per %s seconds"] = {StatLogic.Stats.ManaRegen, false} -- enchant 2794 TBC
L["mana regen %s per %s sec"] = {StatLogic.Stats.ManaRegen, false} -- enchant 2565 Vanilla
L["restores %s mana per %s seconds to all party members within %s yards"] = {StatLogic.Stats.ManaRegen, false, false} -- spell 28145 Vanilla

L["increases your spell penetration by %s"] = {StatLogic.Stats.SpellPenetration} -- spell 25975 TBC
L["decreases the magical resistances of your spell targets by %s"] = {StatLogic.Stats.SpellPenetration} -- spell 25975 Vanilla

L["healing and spell damage %s"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- enchant 2544 Vanilla
L["%s damage and healing spells"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- enchant 2607 Vanilla
L["%s spell damage and healing"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- enchant 2605 Vanilla
L["spell damage %s"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- enchant 2504 Vanilla
L["increases damage and healing done by magical spells and effects by up to %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}} -- spell 14799 Vanilla
L["increases damage and healing done by magical spells and effects of all party members within %s yards by up to %s"] = {false, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}} -- spell 28143 Vanilla
L["increases your spell damage by up to %s and your healing by up to %s"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower} -- spell 28155 Vanilla

L["fire damage %s"] = {StatLogic.Stats.FireDamage,} -- enchant 2616 Vanilla
L["frost damage %s"] = {StatLogic.Stats.FrostDamage,} -- enchant 2615 Vanilla
L["shadow damage %s"] = {StatLogic.Stats.ShadowDamage,} -- enchant 2614 Vanilla

L["%s fire damage"] = {StatLogic.Stats.FireDamage,} -- enchant 2808 TBC
L["%s nature damage"] = {StatLogic.Stats.NatureDamage,} -- enchant 2809 TBC
L["%s frost damage"] = {StatLogic.Stats.FrostDamage,} -- enchant 2810 TBC
L["%s shadow damage"] = {StatLogic.Stats.ShadowDamage,} -- enchant 2811 TBC
L["%s arcane damage"] = {StatLogic.Stats.ArcaneDamage,} -- enchant 2807 TBC

L["%s holy spell damage"] = {StatLogic.Stats.HolyDamage,} -- enchant 2193 Vanilla
L["%s fire spell damage"] = {StatLogic.Stats.FireDamage,} -- enchant 2155 Vanilla
L["%s nature spell damage"] = {StatLogic.Stats.NatureDamage,} -- enchant 2269 Vanilla
L["%s frost spell damage"] = {StatLogic.Stats.FrostDamage,} -- enchant 2231 Vanilla
L["%s shadow spell damage"] = {StatLogic.Stats.ShadowDamage,} -- enchant 2117 Vanilla
L["%s arcane spell damage"] = {StatLogic.Stats.ArcaneDamage,} -- enchant 2079 Vanilla

L["increases damage done by holy spells and effects by up to %s"] = {StatLogic.Stats.HolyDamage,} -- spell 21499 Vanilla
L["increases damage done by fire spells and effects by up to %s"] = {StatLogic.Stats.FireDamage,} -- spell 7683 Vanilla
L["increases damage done by nature spells and effects by up to %s"] = {StatLogic.Stats.NatureDamage,} -- spell 7690 Vanilla
L["increases damage done by frost spells and effects by up to %s"] = {StatLogic.Stats.FrostDamage,} -- spell 7697 Vanilla
L["increases damage done by shadow spells and effects by up to %s"] = {StatLogic.Stats.ShadowDamage,} -- spell 7704 Vanilla
L["increases damage done by arcane spells and effects by up to %s"] = {StatLogic.Stats.ArcaneDamage,} -- spell 13590 Vanilla
L["increases the damage done by holy spells and effects by up to %s"] = {StatLogic.Stats.HolyDamage,} -- spell 37139 TBC

L["%s healing spells"] = {StatLogic.Stats.HealingPower,} -- enchant 2307 Vanilla
L["increases healing %s"] = {StatLogic.Stats.HealingPower,} -- enchant 206 Vanilla
L["%s healing spells and %s damage spells"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage,} -- enchant 2343 TBC
L["increases healing done by up to %s and damage done by up to %s for all magical spells and effects"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage} -- spell 7675 TBC
L["increases healing done by spells and effects by up to %s"] = {StatLogic.Stats.HealingPower,} -- spell 18032 Vanilla
L["increases healing done by magical spells and effects of all party members within %s yards by up to %s"] = {false, StatLogic.Stats.HealingPower,} -- spell 28144 Vanilla

L["increases your chance to dodge an attack by %s%"] = {StatLogic.Stats.Dodge,} -- spell 13669 Vanilla
L["increases your chance to parry an attack by %s%"] = {StatLogic.Stats.Parry,} -- spell 13665 Vanilla
L["%s shield block rating"] = {StatLogic.Stats.BlockRating,} -- enchant 763 TBC
L["increases your block rating by %s"] = {StatLogic.Stats.BlockRating,} -- spell 13674 TBC
L["increases your chance to block attacks with a shield by %s%"] = {StatLogic.Stats.BlockChance,} -- spell 13675 Vanilla

L["improves your chance to hit by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit}} -- spell 15464 Vanilla
L["improves your chance to hit with spells and with melee and ranged attacks by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit}} -- spell 432639 Vanilla
L["increases your hit rating by %s"] = {StatLogic.Stats.HitRating,} -- spell 15464 TBC
L["healing and spell damage %s/spell hit %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage}, StatLogic.Stats.SpellHit} -- enchant 2588 Vanilla
L["%s healing and spell damage/%s spell hit"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage}, StatLogic.Stats.SpellHitRating} -- enchant 2588 TBC
L["%s spell power and %s hit rating"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage}, StatLogic.Stats.HitRating} -- enchant 2588 TBC
L["improves your chance to hit with spells by %s%"] = {StatLogic.Stats.SpellHit} -- spell 23727 Vanilla
L["%s spell hit rating"] = {StatLogic.Stats.SpellHitRating,} -- enchant 2767 TBC
L["increases your spell hit rating by %s"] = {StatLogic.Stats.SpellHitRating,} -- spell 23727 TBC
L["%s ranged hit rating"] = {StatLogic.Stats.RangedHitRating,} -- enchant 2523 Wrath
L["increases your ranged hit rating by %s"] = {StatLogic.Stats.RangedHitRating,} -- spell 22780 TBC

L["improves your chance to get a critical strike by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit}} -- spell 7597 Vanilla
L["improves your chance to get a critical strike with melee and ranged attacks and with spells by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit}} -- spell 436239 Vanilla
L["%s critical rating"] = {StatLogic.Stats.CritRating,} -- enchant 2506 TBC
L["increases your critical strike rating by %s"] = {StatLogic.Stats.CritRating,} -- spell 7597 TBC
L["improves your chance to get a critical strike with spells by %s%"] = {StatLogic.Stats.SpellCrit} -- spell 18382 Vanilla
L["%s spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,} -- enchant 2771 TBC
L["%s spell critical rating"] = {StatLogic.Stats.SpellCritRating,} -- enchant 2695 TBC
L["increases your spell critical strike rating by %s"] = {StatLogic.Stats.SpellCritRating,} -- spell 18382 TBC
L["increases the spell critical chance of all party members within %s yards by %s%"] = {false, StatLogic.Stats.SpellCrit} -- spell 28142 Vanilla
L["increases the spell critical strike rating of all party members within %s yards by %s"] = {false, StatLogic.Stats.SpellCritRating,} -- spell 28142 TBC
L["increases your ranged critical strike rating by %s"] = {StatLogic.Stats.RangedCritRating,} -- spell 9132 TBC
L["%s ranged critical strike"] = {StatLogic.Stats.RangedCritRating,} -- enchant 3608 Wrath

L["%s ranged haste rating"] = {StatLogic.Stats.RangedHasteRating} -- enchant 3607 Wrath
L["%s spell haste rating"] = {StatLogic.Stats.SpellHasteRating} -- enchant 3270 TBC

L["increases armor penetration rating by %s"] = {StatLogic.Stats.ArmorPenetrationRating} -- spell 42095 Wrath