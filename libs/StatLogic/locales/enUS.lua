local addonName, addon = ...
if GetLocale() ~= "enUS" then return end
local StatLogic = LibStub(addonName)

--[[
-- Item Stat Scanning Procedure
-- Trim spaces using text:trim()
-- Strip color codes
-- 1. Whole Text Lookup - Mainly used for enchants or stuff without numbers
--    Whole strings are indexed in L.WholeTextLookup
--    Exclude a string by matching the whole string
-- 2. Substitution Lookup
--    Strip Equip:, Socket Bonus:, trailing .
--    Lowercase string using UTF8
--    Replace numbers with %s
--    Lookup exact sanitized string in StatIDLookup
-- 2. Prefix Exclude - Exclude obvious lines that do not need to be checked
--    Exclude a string by looking at the first X chars, these strings are indexed in L.PrefixExclude.
--    Exclude lines starting with '"'. (Flavor text)
-- 3. Color Exclude
--    Exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
-- 4. Pre Scan - Short list of patterns that will be checked before going into Deep Scan.
--]]
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
local W = addon.WholeTextLookup
W["Savagery"] = {[StatLogic.Stats.AttackPower] = 70} -- enchant 2667 TBC
W["Vitality"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4} -- enchant 2656 TBC
W["Soulfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54} -- enchant 2672 TBC
W["Sunfire"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50} -- enchant 2671 TBC
W["Surefooted"] = {[StatLogic.Stats.HitRating] = 10} -- enchant 2658 WholeText TBC

-----------------------
-- Stat Lookup Table --
-----------------------
local L = addon.StatIDLookup
L["minor speed and %s agility"] = {StatLogic.Stats.Agility} -- enchant 2939 TBC
L["minor speed and %s stamina"] = {StatLogic.Stats.Stamina} -- enchant 2940 TBC
L["%s shadow and frost spell power"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage}} -- enchant 2672 Wrath
L["%s arcane and fire spell power"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage}} -- enchant 2671 Wrath
L["%s health and mana every %s sec"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen}, false} -- enchant 2656 Wrath
L["%s hit rating and %s critical strike rating"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating} -- enchant 2658 Wrath
L["your attacks ignore %s of your opponent's armor"] = {StatLogic.Stats.IgnoreArmor} -- spell 43901 TBC
L["%s weapon damage"] = {StatLogic.Stats.AverageWeaponDamage} -- enchant 2929 TBC, spell 25901 Vanilla

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

L["increases your spell penetration by %s"] = {StatLogic.Stats.SpellPenetration} -- spell 25975 TBC
L["decreases the magical resistances of your spell targets by %s"] = {StatLogic.Stats.SpellPenetration} -- spell 25975 Vanilla

L["Healing and Spell Damage"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
L["Damage and Healing Spells"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}
L["Spell Damage and Healing"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} --StatLogic:GetSum("item:22630")
L["Spell Damage"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}
L["increases damage and healing done by magical spells and effects by up to %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}} -- spell: 14799
L["Increases damage and healing done by magical spells and effects of all party members within 30 yards"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower} -- Atiesh
L["Damage"] = {StatLogic.Stats.SpellDamage,}
L["Increases your spell damage"] = {StatLogic.Stats.SpellDamage,} -- Atiesh ID:22630, 22631, 22632, 22589
L["Spell Power"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}
L["Increases spell power"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,} -- WotLK
L["Holy Damage"] = {StatLogic.Stats.HolyDamage,}
L["Arcane Damage"] = {StatLogic.Stats.ArcaneDamage,}
L["Fire Damage"] = {StatLogic.Stats.FireDamage,}
L["Nature Damage"] = {StatLogic.Stats.NatureDamage,}
L["Frost Damage"] = {StatLogic.Stats.FrostDamage,}
L["Shadow Damage"] = {StatLogic.Stats.ShadowDamage,}
L["Holy Spell Damage"] = {StatLogic.Stats.HolyDamage,}
L["Arcane Spell Damage"] = {StatLogic.Stats.ArcaneDamage,}
L["Fire Spell Damage"] = {StatLogic.Stats.FireDamage,}
L["Nature Spell Damage"] = {StatLogic.Stats.NatureDamage,}
L["Frost Spell Damage"] = {StatLogic.Stats.FrostDamage,} -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
L["Shadow Spell Damage"] = {StatLogic.Stats.ShadowDamage,}
L["Increases damage done by Shadow spells and effects"] = {StatLogic.Stats.ShadowDamage,} -- Frozen Shadoweave Vest ID:21871
L["Increases damage done by Frost spells and effects"] = {StatLogic.Stats.FrostDamage,} -- Frozen Shadoweave Vest ID:21871
L["Increases damage done by Holy spells and effects"] = {StatLogic.Stats.HolyDamage,}
L["Increases damage done by Arcane spells and effects"] = {StatLogic.Stats.ArcaneDamage,}
L["Increases damage done by Fire spells and effects"] = {StatLogic.Stats.FireDamage,}
L["Increases damage done by Nature spells and effects"] = {StatLogic.Stats.NatureDamage,}
L["Increases the damage done by Holy spells and effects"] = {StatLogic.Stats.HolyDamage,} -- Drape of the Righteous ID:30642
L["Increases the damage done by Arcane spells and effects"] = {StatLogic.Stats.ArcaneDamage,} -- Added just in case
L["Increases the damage done by Fire spells and effects"] = {StatLogic.Stats.FireDamage,} -- Added just in case
L["Increases the damage done by Frost spells and effects"] = {StatLogic.Stats.FrostDamage,} -- Added just in case
L["Increases the damage done by Nature spells and effects"] = {StatLogic.Stats.NatureDamage,} -- Added just in case
L["Increases the damage done by Shadow spells and effects"] = {StatLogic.Stats.ShadowDamage,} -- Added just in case

L["Healing Spells"] = {StatLogic.Stats.HealingPower,} -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
L["Increases Healing"] = {StatLogic.Stats.HealingPower,}
L["Healing"] = {StatLogic.Stats.HealingPower,} -- StatLogic:GetSum("item:23344:206")
L["Damage Spells"] = {StatLogic.Stats.SpellDamage,} -- 2.3.0 StatLogic:GetSum("item:23344:2343")
L["Increases healing done"] = {StatLogic.Stats.HealingPower,} -- 2.3.0
L["damage donefor all magical spells"] = {StatLogic.Stats.SpellDamage,} -- 2.3.0
L["increases healing done by spells and effects by up to %s"] = {StatLogic.Stats.HealingPower,} -- spell: 18032
L["Increases healing done by magical spells and effects of all party members within 30 yards"] = {StatLogic.Stats.HealingPower,} -- Atiesh
L["your healing"] = {StatLogic.Stats.HealingPower,} -- Atiesh

L["damage per second"] = {StatLogic.Stats.WeaponDPS,}
L["Addsdamage per second"] = {StatLogic.Stats.WeaponDPS,} -- [Thorium Shells] ID: 15977

L["increases your chance to dodge an attack by %s%"] = {StatLogic.Stats.Dodge,} -- spell: 13669
L["increases your chance to parry an attack by %s%"] = {StatLogic.Stats.Parry,} -- spell: 13665
L["Shield Block Rating"] = {StatLogic.Stats.BlockRating,} -- Enchant Shield - Lesser Block +10 Shield Block Rating spell: 13689
L["Increases your block rating"] = {StatLogic.Stats.BlockRating,}
L["increases your chance to block attacks with a shield by %s%"] = {StatLogic.Stats.BlockChance,} -- spell: 13675

L["improves your chance to hit by %s%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit} -- spell: 15464
L["improves your chance to hit with spells and with melee and ranged attacks by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit}} -- spell: 432639
L["Improves hit rating"] = {StatLogic.Stats.HitRating,} -- ITEM_MOD_HIT_RATING
L["Increases your hit rating"] = {StatLogic.Stats.HitRating,}
L["Spell Hit"] = {StatLogic.Stats.SpellHitRating,} -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit spell: 24164
L["improves your chance to hit with spells by %s%"] = {StatLogic.Stats.SpellHit} -- spell: 23727
L["Spell Hit Rating"] = {StatLogic.Stats.SpellHitRating,}
L["Increases your spell hit rating"] = {StatLogic.Stats.SpellHitRating,}
L["Ranged Hit Rating"] = {StatLogic.Stats.RangedHitRating,}
L["Increases your ranged hit rating"] = {StatLogic.Stats.RangedHitRating,}

L["improves your chance to get a critical strike by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit}}
L["improves your chance to get a critical strike with melee and ranged attacks and with spells by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit}} -- spell: 436239
L["Crit Rating"] = {StatLogic.Stats.CritRating,}
L["Critical Rating"] = {StatLogic.Stats.CritRating,}
L["Critical Strike Rating"] = {StatLogic.Stats.CritRating,}
L["Increases your critical hit rating"] = {StatLogic.Stats.CritRating,}
L["Increases your critical strike rating"] = {StatLogic.Stats.CritRating,}
L["improves your chance to get a critical strike with spells by %s%"] = {StatLogic.Stats.SpellCrit} -- spell: 18382
L["Spell Critical Strike Rating"] = {StatLogic.Stats.SpellCritRating,}
L["Spell Critical Rating"] = {StatLogic.Stats.SpellCritRating,}
L["Spell Crit Rating"] = {StatLogic.Stats.SpellCritRating,}
L["Spell Critical"] = {StatLogic.Stats.SpellCritRating,}
L["Increases your spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,}
L["Increases the spell critical strike rating of all party members within 30 yards"] = {StatLogic.Stats.SpellCritRating,}
L["Increases your ranged critical strike rating"] = {StatLogic.Stats.RangedCritRating,} -- Fletcher's Gloves ID:7348
L["ranged critical strike"] = {StatLogic.Stats.RangedCritRating,}

L["Resilience"] = {StatLogic.Stats.ResilienceRating,}
L["Resilience Rating"] = {StatLogic.Stats.ResilienceRating,} -- Enchant Chest - Major Resilience "+15 Resilience Rating" spell: 33992
L["Improves your resilience rating"] = {StatLogic.Stats.ResilienceRating,}

L["Haste Rating"] = {StatLogic.Stats.HasteRating}
L["Ranged Haste Rating"] = {StatLogic.Stats.RangedHasteRating}
L["Improves haste rating"] = {StatLogic.Stats.HasteRating}
L["Spell Haste Rating"] = {StatLogic.Stats.SpellHasteRating}
L["Improves melee haste rating"] = {StatLogic.Stats.MeleeHasteRating}
L["Improves spell haste rating"] = {StatLogic.Stats.SpellHasteRating}
L["Improves ranged haste rating"] = {StatLogic.Stats.RangedHasteRating}

L["expertise rating"] = {StatLogic.Stats.ExpertiseRating} -- gems
L["Increases your expertise rating"] = {StatLogic.Stats.ExpertiseRating}
L["armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating} -- gems
L["Increases armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating}
L["Increases your armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating} -- Anarchy ID:39420
L["increases your armor penetration"] = {StatLogic.Stats.ArmorPenetrationRating} -- Ring of Foul Mojo ID:43178