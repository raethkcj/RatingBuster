---@class StatLogicLocale
---@field PrefixExclude table
---@field WholeTextLookup table
---@field PreScanPatterns table
---@field StatIDLookup table
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "enUS", true)
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = tonumber
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
	["Savagery"] = {[StatLogic.Stats.AttackPower] = 70}, --
	["Vitality"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4}, -- Enchant Boots - Vitality spell: 27948
	["Soulfrost"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54},
	["+54 Shadow and Frost Spell Power"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54},
	["Sunfire"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50},
	["+50 Arcane and Fire Spell Power"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50},
	["Surefooted"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" spell: 27954
}
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = StatLogic.Stats.FeralAttackPower,
	["^(%d+) Block$"] = StatLogic.Stats.BlockValue,
	["^(%d+) Armor$"] = StatLogic.Stats.Armor,
	["Reinforced %(%+(%d+) Armor%)"] = StatLogic.Stats.BonusArmor,
	["Mana Regen (%d+) per 5 sec%.$"] = StatLogic.Stats.ManaRegen,
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^[%a '%-]+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	-- Procs
	--["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
	["[Ss]ometimes"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Ww]hen struck in combat"] = false, -- [Essence of the Pure Flame] ID: 18815
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Your attacks ignoreof your opponent's armor"] = {StatLogic.Stats.IgnoreArmor}, -- StatLogic:GetSum("item:33733")
	["Weapon Damage"] = {StatLogic.Stats.AverageWeaponDamage}, -- Enchant

	["All Stats"] = {StatLogic.Stats.AllStats,},
	["Strength"] = {StatLogic.Stats.Strength,},
	["Agility"] = {StatLogic.Stats.Agility,},
	["Stamina"] = {StatLogic.Stats.Stamina,},
	["Intellect"] = {StatLogic.Stats.Intellect,},
	["Spirit"] = {StatLogic.Stats.Spirit,},

	["Arcane Resistance"] = {StatLogic.Stats.ArcaneResistance,},
	["Fire Resistance"] = {StatLogic.Stats.FireResistance,},
	["Nature Resistance"] = {StatLogic.Stats.NatureResistance,},
	["Frost Resistance"] = {StatLogic.Stats.FrostResistance,},
	["Shadow Resistance"] = {StatLogic.Stats.ShadowResistance,},
	["Arcane Resist"] = {StatLogic.Stats.ArcaneResistance,}, -- Arcane Armor Kit +8 Arcane Resist
	["Fire Resist"] = {StatLogic.Stats.FireResistance,}, -- Flame Armor Kit +8 Fire Resist
	["Nature Resist"] = {StatLogic.Stats.NatureResistance,}, -- Frost Armor Kit +8 Frost Resist
	["Frost Resist"] = {StatLogic.Stats.FrostResistance,}, -- Nature Armor Kit +8 Nature Resist
	["Shadow Resist"] = {StatLogic.Stats.ShadowResistance,}, -- Shadow Armor Kit +8 Shadow Resist
	["All Resistances"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["Resist All"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},

	["Armor"] = {StatLogic.Stats.BonusArmor,},
	["reinforced armor %s"] = {StatLogic.Stats.BonusArmor}, -- enchant: 15
	["Defense"] = {StatLogic.Stats.Defense,},
	["increased defense %s"] = {StatLogic.Stats.Defense,}, -- spell: 13387
	["Block"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Block Value"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["Shield Block Value"] = {StatLogic.Stats.BlockValue,}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
	["Increases the block value of your shield"] = {StatLogic.Stats.BlockValue,},

	["Health"] = {StatLogic.Stats.Health,},
	["HP"] = {StatLogic.Stats.Health,},
	["Mana"] = {StatLogic.Stats.Mana,},

	["Attack Power"] = {StatLogic.Stats.AttackPower,},
	["Increases attack power"] = {StatLogic.Stats.AttackPower,},
	["Increases attack powerin Cat"] = {StatLogic.Stats.FeralAttackPower,},
	["%s attack power in cat, bear, and dire bear forms only"] = {StatLogic.Stats.FeralAttackPower}, --spell: 24697
	["Ranged Attack Power"] = {StatLogic.Stats.RangedAttackPower,},
	["Increases ranged attack power"] = {StatLogic.Stats.RangedAttackPower,}, -- [High Warlord's Crossbow] ID: 18837

	["Health Regen"] = {StatLogic.Stats.ManaRegen,},
	["health per"] = {StatLogic.Stats.HealthRegen,}, -- Frostwolf Insignia Rank 6 ID:17909
	["health every"] = {StatLogic.Stats.HealthRegen,}, -- [Resurgence Rod] ID:17743
	["your normal health regeneration"] = {StatLogic.Stats.HealthRegen,}, -- Demons Blood ID: 10779
	["Restoreshealth per 5 sec"] = {StatLogic.Stats.HealthRegen,}, -- [Onyxia Blood Talisman] ID: 18406
	["Restoreshealth every 5 sec"] = {StatLogic.Stats.HealthRegen,}, -- [Resurgence Rod] ID:17743
	["Mana Regen"] = {StatLogic.Stats.ManaRegen,}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells spell: 24167
	["mana per"] = {StatLogic.Stats.ManaRegen,}, -- Resurgence Rod ID:17743 Most common
	["mana every"] = {StatLogic.Stats.ManaRegen,},
	["Mana every 5 seconds"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Nightseye] ID: 24057
	["mana every 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." spell: 33991
	["Mana per 5 Seconds"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["mana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Tanzanite] ID: 30603
	["Restoresmana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Resurgence Rod] ID:17743
	["Mana restored per 5 seconds"] = {StatLogic.Stats.ManaRegen,}, -- Magister's Armor Kit +3 Mana restored per 5 seconds spell: 32399
	["Mana Regenper 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." spell: 23801

	["Spell Penetration"] = {StatLogic.Stats.SpellPenetration,}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" spell: 34003
	["Increases your spell penetration"] = {StatLogic.Stats.SpellPenetration,},
	["decreases the magical resistances of your spell targets by %s"] = {StatLogic.Stats.SpellPenetration}, -- spell: 25975

	["Healing and Spell Damage"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
	["Damage and Healing Spells"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Spell Damage and Healing"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, --StatLogic:GetSum("item:22630")
	["Spell Damage"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["increases damage and healing done by magical spells and effects by up to %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}}, -- spell: 14799
	["Increases damage and healing done by magical spells and effects of all party members within 30 yards"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Atiesh
	["Damage"] = {StatLogic.Stats.SpellDamage,},
	["Increases your spell damage"] = {StatLogic.Stats.SpellDamage,}, -- Atiesh ID:22630, 22631, 22632, 22589
	["Spell Power"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["Increases spell power"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- WotLK
	["Holy Damage"] = {StatLogic.Stats.HolyDamage,},
	["Arcane Damage"] = {StatLogic.Stats.ArcaneDamage,},
	["Fire Damage"] = {StatLogic.Stats.FireDamage,},
	["Nature Damage"] = {StatLogic.Stats.NatureDamage,},
	["Frost Damage"] = {StatLogic.Stats.FrostDamage,},
	["Shadow Damage"] = {StatLogic.Stats.ShadowDamage,},
	["Holy Spell Damage"] = {StatLogic.Stats.HolyDamage,},
	["Arcane Spell Damage"] = {StatLogic.Stats.ArcaneDamage,},
	["Fire Spell Damage"] = {StatLogic.Stats.FireDamage,},
	["Nature Spell Damage"] = {StatLogic.Stats.NatureDamage,},
	["Frost Spell Damage"] = {StatLogic.Stats.FrostDamage,}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Shadow Spell Damage"] = {StatLogic.Stats.ShadowDamage,},
	["Increases damage done by Shadow spells and effects"] = {StatLogic.Stats.ShadowDamage,}, -- Frozen Shadoweave Vest ID:21871
	["Increases damage done by Frost spells and effects"] = {StatLogic.Stats.FrostDamage,}, -- Frozen Shadoweave Vest ID:21871
	["Increases damage done by Holy spells and effects"] = {StatLogic.Stats.HolyDamage,},
	["Increases damage done by Arcane spells and effects"] = {StatLogic.Stats.ArcaneDamage,},
	["Increases damage done by Fire spells and effects"] = {StatLogic.Stats.FireDamage,},
	["Increases damage done by Nature spells and effects"] = {StatLogic.Stats.NatureDamage,},
	["Increases the damage done by Holy spells and effects"] = {StatLogic.Stats.HolyDamage,}, -- Drape of the Righteous ID:30642
	["Increases the damage done by Arcane spells and effects"] = {StatLogic.Stats.ArcaneDamage,}, -- Added just in case
	["Increases the damage done by Fire spells and effects"] = {StatLogic.Stats.FireDamage,}, -- Added just in case
	["Increases the damage done by Frost spells and effects"] = {StatLogic.Stats.FrostDamage,}, -- Added just in case
	["Increases the damage done by Nature spells and effects"] = {StatLogic.Stats.NatureDamage,}, -- Added just in case
	["Increases the damage done by Shadow spells and effects"] = {StatLogic.Stats.ShadowDamage,}, -- Added just in case

	["Healing Spells"] = {StatLogic.Stats.HealingPower,}, -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
	["Increases Healing"] = {StatLogic.Stats.HealingPower,},
	["Healing"] = {StatLogic.Stats.HealingPower,}, -- StatLogic:GetSum("item:23344:206")
	["Damage Spells"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Increases healing done"] = {StatLogic.Stats.HealingPower,}, -- 2.3.0
	["damage donefor all magical spells"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0
	["increases healing done by spells and effects by up to %s"] = {StatLogic.Stats.HealingPower,}, -- spell: 18032
	["Increases healing done by magical spells and effects of all party members within 30 yards"] = {StatLogic.Stats.HealingPower,}, -- Atiesh
	["your healing"] = {StatLogic.Stats.HealingPower,}, -- Atiesh

	["damage per second"] = {StatLogic.Stats.WeaponDPS,},
	["Addsdamage per second"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15977

	["Defense Rating"] = {StatLogic.Stats.DefenseRating,},
	["Increases defense rating"] = {StatLogic.Stats.DefenseRating,},
	["Dodge Rating"] = {StatLogic.Stats.DodgeRating,},
	["Increases your dodge rating"] = {StatLogic.Stats.DodgeRating,},
	["increases your chance to dodge an attack by %s%"] = {StatLogic.Stats.Dodge,}, -- spell: 13669
	["Parry Rating"] = {StatLogic.Stats.ParryRating,},
	["Increases your parry rating"] = {StatLogic.Stats.ParryRating,},
	["increases your chance to parry an attack by %s%"] = {StatLogic.Stats.Parry,}, -- spell: 13665
	["Shield Block Rating"] = {StatLogic.Stats.BlockRating,}, -- Enchant Shield - Lesser Block +10 Shield Block Rating spell: 13689
	["Block Rating"] = {StatLogic.Stats.BlockRating,},
	["Increases your block rating"] = {StatLogic.Stats.BlockRating,},
	["Increases your shield block rating"] = {StatLogic.Stats.BlockRating,},
	["increases your chance to block attacks with a shield by %s%"] = {StatLogic.Stats.BlockChance,}, -- spell: 13675

	["improves your chance to hit by %s%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit}, -- spell: 15464
	["improves your chance to hit with spells and with melee and ranged attacks by %s%"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit}}, -- spell: 432639
	["Hit Rating"] = {StatLogic.Stats.HitRating,},
	["Improves hit rating"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["Increases your hit rating"] = {StatLogic.Stats.HitRating,},
	["Improves melee hit rating"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["Spell Hit"] = {StatLogic.Stats.SpellHitRating,}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit spell: 24164
	["improves your chance to hit with spells by %s%"] = {StatLogic.Stats.SpellHit}, -- spell: 23727
	["Spell Hit Rating"] = {StatLogic.Stats.SpellHitRating,},
	["Improves spell hit rating"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["Increases your spell hit rating"] = {StatLogic.Stats.SpellHitRating,},
	["Ranged Hit Rating"] = {StatLogic.Stats.RangedHitRating,},
	["Improves ranged hit rating"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["Increases your ranged hit rating"] = {StatLogic.Stats.RangedHitRating,},

	["improves your chance to get a critical strike by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit}},
	["improves your chance to get a critical strike with melee and ranged attacks and with spells by %s%"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit}}, -- spell: 436239
	["Crit Rating"] = {StatLogic.Stats.CritRating,},
	["Critical Rating"] = {StatLogic.Stats.CritRating,},
	["Critical Strike Rating"] = {StatLogic.Stats.CritRating,},
	["Increases your critical hit rating"] = {StatLogic.Stats.CritRating,},
	["Increases your critical strike rating"] = {StatLogic.Stats.CritRating,},
	["Improves critical strike rating"] = {StatLogic.Stats.CritRating,},
	["Improves melee critical strike rating"] = {StatLogic.Stats.MeleeCritRating,}, -- [Cloak of Darkness] ID:33122
	["improves your chance to get a critical strike with spells by %s%"] = {StatLogic.Stats.SpellCrit}, -- spell: 18382
	["Spell Critical Strike Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Crit Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical"] = {StatLogic.Stats.SpellCritRating,},
	["Increases your spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases the spell critical strike rating of all party members within 30 yards"] = {StatLogic.Stats.SpellCritRating,},
	["Improves spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases your ranged critical strike rating"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348
	["ranged critical strike"] = {StatLogic.Stats.RangedCritRating,},

	["Resilience"] = {StatLogic.Stats.ResilienceRating,},
	["Resilience Rating"] = {StatLogic.Stats.ResilienceRating,}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" spell: 33992
	["Improves your resilience rating"] = {StatLogic.Stats.ResilienceRating,},

	["Haste Rating"] = {StatLogic.Stats.HasteRating},
	["Ranged Haste Rating"] = {StatLogic.Stats.RangedHasteRating},
	["Improves haste rating"] = {StatLogic.Stats.HasteRating},
	["Spell Haste Rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves melee haste rating"] = {StatLogic.Stats.MeleeHasteRating},
	["Improves spell haste rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves ranged haste rating"] = {StatLogic.Stats.RangedHasteRating},

	["expertise rating"] = {StatLogic.Stats.ExpertiseRating}, -- gems
	["Increases your expertise rating"] = {StatLogic.Stats.ExpertiseRating},
	["armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating}, -- gems
	["Increases armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating},
	["Increases your armor penetration rating"] = {StatLogic.Stats.ArmorPenetrationRating}, -- Anarchy ID:39420
	["increases your armor penetration"] = {StatLogic.Stats.ArmorPenetrationRating}, -- Ring of Foul Mojo ID:43178
}