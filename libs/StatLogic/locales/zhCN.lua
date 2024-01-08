-- zhCN localization by iceburn
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "zhCN")
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = tonumber
------------------
-- Prefix Exclude --
------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
L["PrefixExcludeLength"] = 3 -- using string.utf8len
L["PrefixExclude"] = {}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["野性"] = {["AP"] = 70}, --

	["初级巫师之油"] = {[StatLogic.Stats.SpellDamage] = 8, [StatLogic.Stats.HealingPower] = 8}, --
	["次级巫师之油"] = {[StatLogic.Stats.SpellDamage] = 16, [StatLogic.Stats.HealingPower] = 16}, --
	["巫师之油"] = {[StatLogic.Stats.SpellDamage] = 24, [StatLogic.Stats.HealingPower] = 24}, --
	["卓越巫师之油"] = {[StatLogic.Stats.SpellDamage] = 36, [StatLogic.Stats.HealingPower] = 36, [StatLogic.Stats.SpellCritRating] = 14}, --

	["超强法力之油"] = {["MANA_REG"] = 14}, --
	["初级法力之油"] = {["MANA_REG"] = 4}, --
	["次级法力之油"] = {["MANA_REG"] = 8}, --
	["卓越法力之油"] = {["MANA_REG"] = 12, [StatLogic.Stats.HealingPower] = 25}, --
	["超强巫师之油"] = {[StatLogic.Stats.SpellDamage] = 42, [StatLogic.Stats.HealingPower] = 42}, --

	["活力"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
	["魂霜"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54}, --
	["阳炎"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50}, --
	["+40 法术伤害"] = {[StatLogic.Stats.SpellDamage] = 40, [StatLogic.Stats.HealingPower] = 40}, --
	["+30 法术伤害"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 30}, --

	["移动速度略微提升"] = false, -- Enchant Boots - Minor Speed
	["略微提高奔跑速度"] = false, --
	["初级速度"] = false, -- Enchant Boots - Minor Speed
	["稳固"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted"

	["装备： 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
	["使你可以在水下呼吸"] = false, --
	["装备： 免疫缴械。"] = false, -- [Stronghold Gauntlets] ID: 12639
	["免疫缴械"] = false, --
	["十字军"] = false, -- Enchant Crusader
	["生命偷取"] = false, -- Enchant Crusader
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
-- +19 耐力 = "^%+(%d+) (.-)$"
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
--装备: 增加法术命中等级 11点。
--装备: 提高所有法术和魔法效果所造成的伤害和治疗效果，最多46点。
--"装备： (.-)提高(最多)?(%d+)(点)?(.-)。$",
L["SingleEquipStatCheck"] = "^" .. ITEM_SPELL_TRIGGER_ONEQUIP .. " (.-)(%d+)\231?\130?\185?(.-)。$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before base scan
L["PreScanPatterns"] = {
	["^装备: 猫形态下的攻击强度增加(%d+)"] = "FERAL_AP",
	["^(%d+)格挡$"] = "BLOCK_VALUE",
	["^(%d+)点护甲$"] = StatLogic.Stats.Armor,
	["强化护甲 %+(%d+)"] = StatLogic.Stats.BonusArmor,
	["护甲值提高(%d+)点"] = StatLogic.Stats.BonusArmor,
	["每5秒恢复(%d+)点法力值。$"] = "MANA_REG",
	["每5秒恢复(%d+)点生命值。$"] = "HEALTH_REG",
	["每5秒回复(%d+)点法力值。$"] = "MANA_REG",
	["每5秒回复(%d+)点法力值$"] = "MANA_REG",
	["每5秒回复(%d+)点生命值。$"] = "HEALTH_REG",
	-- Exclude
	["^(%d+)格.-包"] = false, -- # of slots and bag type
	["^(%d+)格.-袋"] = false, -- # of slots and bag type
	["^(%d+)格容器"] = false, -- # of slots and bag type
	["^.+（(%d+)/%d+）$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	["几率"] = false, --[挑战印记] ID:27924
	["机率"] = false,
	["有一定几率"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["有可能"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["命中时"] = false, -- [黑色摧毁者手套] ID:22194
	["被击中之后"] = false, -- [Essence of the Pure Flame] ID: 18815
	["在杀死一个敌人"] = false, -- [注入精华的蘑菇] ID:28109
	["每当你的"] = false, -- [电光相容器] ID: 28785
	["被击中时"] = false, --
	["你每施放一次法术，此增益的效果就降低17点伤害和34点治疗效果"] = false, --赞达拉英雄护符 ID:19950
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "装备: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "镶孔奖励: " -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "。"
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"、", -- 防御者雕文
	"。",
}
L["DeepScanWordSeparators"] = {
	"及", "和", "并", "，","以及", "持续 "-- [发光的暗影卓奈石] ID:25894 "+24 攻击强度及略微提高奔跑速度", [刺客的火焰蛋白石] ID:30565 "爆击等级 +6 及躲闪等级 +5"
}
L["DeepScanPatterns"] = {
	"^(.-)提高最多([%d%.]+)点(.-)$", --
	"^(.-)提高最多([%d%.]+)(.-)$", --
	"^(.-)，最多([%d%.]+)点(.-)$", --
	"^(.-)，最多([%d%.]+)(.-)$", --
	"^(.-)最多([%d%.]+)点(.-)$", --
	"^(.-)最多([%d%.]+)(.-)$", --
	"^(.-)提高([%d%.]+)点(.-)$", --
	"^(.-)提高([%d%.]+)(.-)$", --
	"^(.-)([%d%.]+)点(.-)$", --
	"^(.-) ?([%+%-][%d%.]+) ?点(.-)$", --
	"^(.-) ?([%+%-][%d%.]+) ?(.-)$", --
	"^(.-) ?([%d%.]+) ?点(.-)$", --
	"^(.-) ?([%d%.]+) ?(.-)$", --
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["你的攻击无视目标的点护甲值"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["武器伤害"] = {"MELEE_DMG"}, -- Enchant
	["近战伤害"] = {"MELEE_DMG"}, -- Enchant

	["所有属性"] = {StatLogic.Stats.AllStats,},
	["力量"] = {StatLogic.Stats.Strength,},
	["敏捷"] = {StatLogic.Stats.Agility,},
	["耐力"] = {StatLogic.Stats.Stamina,},
	["智力"] = {StatLogic.Stats.Intellect,},
	["精神"] = {StatLogic.Stats.Spirit,},

	["奥术抗性"] = {StatLogic.Stats.ArcaneResistance,},
	["火焰抗性"] = {StatLogic.Stats.FireResistance,},
	["自然抗性"] = {StatLogic.Stats.NatureResistance,},
	["冰霜抗性"] = {StatLogic.Stats.FrostResistance,},
	["暗影抗性"] = {StatLogic.Stats.ShadowResistance,},
	["阴影抗性"] = {StatLogic.Stats.ShadowResistance,}, -- Demons Blood ID: 10779
	["所有抗性"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["全部抗性"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["抵抗全部"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["点所有魔法抗性"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,}, -- [锯齿黑曜石之盾] ID:22198

	["钓鱼"] = false, -- Fishing enchant ID:846
	["钓鱼技能"] = false, -- Fishing lure
	["使钓鱼技能"] = false, -- Equip: Increased Fishing +20.
	["采矿"] = false, -- Mining enchant ID:844
	["草药学"] = false, -- Heabalism enchant ID:845
	["剥皮"] = false, -- Skinning enchant ID:865

	["护甲"] = {StatLogic.Stats.BonusArmor,},
	["护甲值"] = {StatLogic.Stats.BonusArmor,},
	["强化护甲"] = {StatLogic.Stats.BonusArmor,},
	["护甲值提高(%d+)点"] = {StatLogic.Stats.BonusArmor,},
	["防御"] = {StatLogic.Stats.Defense,},
	["增加防御"] = {StatLogic.Stats.Defense,},
	["格挡值"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["使你的盾牌格挡值"] = {"BLOCK_VALUE",},

	["生命值"] = {"HEALTH",},
	["法力值"] = {"MANA",},

	["攻击强度"] = {"AP",},
	["攻击强度提高"] = {"AP",},
	["提高攻击强度"] = {"AP",},
	["在猎豹、熊、巨熊和枭兽形态下的攻击强度"] = {"FERAL_AP",}, -- Atiesh ID:22632
	["使你的近战和远程攻击强度"] = {"AP"},
	["远程攻击强度"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["每5秒恢复(%d+)点生命值"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["每5秒回复(%d+)点生命值"] = {"HEALTH_REG",},
	["生命值恢复速度"] = {"HEALTH_REG",}, -- [Demons Blood] ID: 10779

	["每5秒法力"] = {"MANA_REG",}, --
	["每5秒恢复法力"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["每5秒恢复(%d+)点法力值"] = {"MANA_REG",},
	["每5秒回复(%d+)点法力值"] = {"MANA_REG",},
	["每5秒法力回复"] = {"MANA_REG",},
	["法力恢复"] = {"MANA_REG",},
	["法力回复"] = {"MANA_REG",},
	["使周围半径30码范围内的所有小队成员每5秒恢复(%d+)点法力值"] = {"MANA_REG",}, --

	["法术穿透"] = {"SPELLPEN",},
	["法术穿透力"] = {"SPELLPEN",},
	["使你的法术穿透提高"] = {"SPELLPEN",},

	["法术伤害和治疗"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["法术治疗和伤害"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["治疗和法术伤害"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["法术伤害"] = {StatLogic.Stats.SpellDamage,},
	["提高法术和魔法效果所造成的伤害和治疗效果"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["法术强度"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["使周围半径30码范围内的所有小队成员的法术和魔法效果所造成的伤害和治疗效果"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Atiesh, ID: 22630
	["提高所有法术和魔法效果所造成的伤害和治疗效果"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},		--StatLogic:GetSum("22630")
	["提高所有法术和魔法效果所造成的伤害和治疗效果，最多"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	--SetTip("22630")
	-- Atiesh ID:22630, 22631, 22632, 22589
	--装备: 使周围半径30码范围内队友的所有法术和魔法效果所造成的伤害和治疗效果提高最多33点。 -- 22630 -- 2.1.0
	--装备: 使周围半径30码范围内队友的所有法术和魔法效果所造成的治疗效果提高最多62点。 -- 22631
	--装备: 使半径30码范围内所有小队成员的法术爆击等级提高28点。 -- 22589
	--装备: 使周围半径30码范围内的队友每5秒恢复11点法力。
	["使你的法术伤害"] = {StatLogic.Stats.SpellDamage,}, -- Atiesh ID:22631
	["伤害"] = {StatLogic.Stats.SpellDamage,},
	["法术能量"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["神圣伤害"] = {StatLogic.Stats.HolyDamage,},
	["奥术伤害"] = {StatLogic.Stats.ArcaneDamage,},
	["火焰伤害"] = {StatLogic.Stats.FireDamage,},
	["自然伤害"] = {StatLogic.Stats.NatureDamage,},
	["冰霜伤害"] = {StatLogic.Stats.FrostDamage,},
	["暗影伤害"] = {StatLogic.Stats.ShadowDamage,},
	["神圣法术伤害"] = {StatLogic.Stats.HolyDamage,},
	["奥术法术伤害"] = {StatLogic.Stats.ArcaneDamage,},
	["火焰法术伤害"] = {StatLogic.Stats.FireDamage,},
	["自然法术伤害"] = {StatLogic.Stats.NatureDamage,},
	["冰霜法术伤害"] = {StatLogic.Stats.FrostDamage,}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["暗影法术伤害"] = {StatLogic.Stats.ShadowDamage,},
	["提高奥术法术和效果所造成的伤害"] = {StatLogic.Stats.ArcaneDamage,},
	["提高火焰法术和效果所造成的伤害"] = {StatLogic.Stats.FireDamage,},
	["提高冰霜法术和效果所造成的伤害"] = {StatLogic.Stats.FrostDamage,}, -- Frozen Shadoweave Vest ID:21871
	["提高神圣法术和效果所造成的伤害"] = {StatLogic.Stats.HolyDamage,},
	["提高自然法术和效果所造成的伤害"] = {StatLogic.Stats.NatureDamage,},
	["提高暗影法术和效果所造成的伤害"] = {StatLogic.Stats.ShadowDamage,}, -- Frozen Shadoweave Vest ID:21871

	["使法术治疗"] = {StatLogic.Stats.HealingPower,},
	["你的治疗效果"] = {StatLogic.Stats.HealingPower,}, -- Atiesh ID:22631
	["治疗法术"] = {StatLogic.Stats.HealingPower,}, -- +35 Healing Glove Enchant
	["治疗效果"] = {StatLogic.Stats.HealingPower,}, -- [圣使祝福手套] Socket Bonus
	["治疗"] = {StatLogic.Stats.HealingPower,},
	["法术治疗"] = {StatLogic.Stats.HealingPower,},
	["神圣效果"] = {StatLogic.Stats.HealingPower,},-- Enchant Ring - Healing Power
	["提高法术所造成的治疗效果"] = {StatLogic.Stats.HealingPower,},
	["提高所有法术和魔法效果所造成的治疗效果"] = {StatLogic.Stats.HealingPower,},
	["使周围半径30码范围内的所有小队成员的法术和魔法效果所造成的治疗效果"] = {StatLogic.Stats.HealingPower,}, -- Atiesh, ID: 22631

	["每秒伤害"] = {StatLogic.Stats.WeaponDPS,},
	["每秒伤害提高"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15997

	["防御等级"] = {StatLogic.Stats.DefenseRating,},
	["防御等级提高"] = {StatLogic.Stats.DefenseRating,},
	["提高你的防御等级"] = {StatLogic.Stats.DefenseRating,},
	["使防御等级"] = {StatLogic.Stats.DefenseRating,},
	["使你的防御等级"] = {StatLogic.Stats.DefenseRating,},

	["躲闪等级"] = {StatLogic.Stats.DodgeRating,},
	["提高躲闪等级"] = {StatLogic.Stats.DodgeRating,},
	["躲闪等级提高"] = {StatLogic.Stats.DodgeRating,},
	["躲闪等级提高(%d+)"] = {StatLogic.Stats.DodgeRating,},
	["提高你的躲闪等级"] = {StatLogic.Stats.DodgeRating,},
	["使躲闪等级"] = {StatLogic.Stats.DodgeRating,},
	["使你的躲闪等级"] = {StatLogic.Stats.DodgeRating,},

	["招架等级"] = {StatLogic.Stats.ParryRating,},
	["提高招架等级"] = {StatLogic.Stats.ParryRating,},
	["提高你的招架等级"] = {StatLogic.Stats.ParryRating,},
	["使招架等级"] = {StatLogic.Stats.ParryRating,},
	["使你的招架等级"] = {StatLogic.Stats.ParryRating,},

	["盾挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高盾挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高你的盾挡等级"] = {StatLogic.Stats.BlockRating,},
	["使盾挡等级"] = {StatLogic.Stats.BlockRating,},
	["使你的盾挡等级"] = {StatLogic.Stats.BlockRating,},

	["格挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高格挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高你的格挡等级"] = {StatLogic.Stats.BlockRating,},
	["使格挡等级"] = {StatLogic.Stats.BlockRating,},
	["使你的格挡等级"] = {StatLogic.Stats.BlockRating,},

	["盾牌格挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高盾牌格挡等级"] = {StatLogic.Stats.BlockRating,},
	["提高你的盾牌格挡等级"] = {StatLogic.Stats.BlockRating,},
	["使盾牌格挡等级"] = {StatLogic.Stats.BlockRating,},
	["使你的盾牌格挡等级"] = {StatLogic.Stats.BlockRating,},

	["使你击中目标的几率提高%"] = {"MELEE_HIT", "RANGED_HIT"},
	["使你的法术、近战和远程攻击的命中几率提高"] = {"MELEE_HIT", "RANGED_HIT", "SPELL_HIT"},
	["命中等级"] = {StatLogic.Stats.HitRating,},
	["提高命中等级"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["使你的命中等级"] = {StatLogic.Stats.HitRating,},
	["提高近战命中等级"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING

	["法术命中等级"] = {StatLogic.Stats.SpellHitRating,},
	["提高法术命中等级"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["使你的法术命中等级"] = {StatLogic.Stats.SpellHitRating,},

	["远程命中等级"] = {StatLogic.Stats.RangedHitRating,},
	["提高远程命中等级"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["使你的远程命中等级"] = {StatLogic.Stats.RangedHitRating,},

	["爆击等级"] = {StatLogic.Stats.CritRating,},
	["提高爆击等级"] = {StatLogic.Stats.CritRating,},
	["使你的爆击等级"] = {StatLogic.Stats.CritRating,},

	["近战爆击等级"] = {StatLogic.Stats.MeleeCritRating,},
	["提高近战爆击等级"] = {StatLogic.Stats.MeleeCritRating,}, -- [屠杀者腰带] ID:21639
	["使你的近战爆击等级"] = {StatLogic.Stats.MeleeCritRating,},

	["法术爆击等级"] = {StatLogic.Stats.SpellCritRating,},
	["法术爆击"] = {StatLogic.Stats.SpellCritRating,},
	["提高法术爆击等级"] = {StatLogic.Stats.SpellCritRating,}, -- [伊利达瑞的复仇] ID:28040
	["使你的法术爆击等级"] = {StatLogic.Stats.SpellCritRating,},
	["使周围半径30码范围内的所有小队成员的法术爆击等级"] = {StatLogic.Stats.SpellCritRating,}, -- Atiesh, ID: 22589

	["远程爆击等级"] = {StatLogic.Stats.RangedCritRating,},
	["提高远程爆击等级"] = {StatLogic.Stats.RangedCritRating,},
	["使你的远程爆击等级"] = {StatLogic.Stats.RangedCritRating,},

	["韧性"] = {StatLogic.Stats.ResilienceRating,},
	["韧性等级"] = {StatLogic.Stats.ResilienceRating,},
	["使你的韧性等级"] = {StatLogic.Stats.ResilienceRating,},

	["急速等级"] = {StatLogic.Stats.HasteRating}, -- Enchant Gloves
	["攻击速度"] = {StatLogic.Stats.HasteRating},
	["提高急速等级"] = {StatLogic.Stats.HasteRating},
	["法术急速等级"] = {StatLogic.Stats.SpellHasteRating},
	["远程急速等级"] = {StatLogic.Stats.RangedHasteRating},
	["提高近战急速等级"] = {StatLogic.Stats.MeleeHasteRating},
	["提高法术急速等级"] = {StatLogic.Stats.SpellHasteRating},
	["提高远程急速等级"] = {StatLogic.Stats.RangedHasteRating},

	["熟練等級"] = {StatLogic.Stats.ExpertiseRating},
	["使你的精准等级提高"] = {StatLogic.Stats.ExpertiseRating},
	["提高精准等级"] = {StatLogic.Stats.ExpertiseRating,},
	["精准等级提高"] = {StatLogic.Stats.ExpertiseRating,},
	["护甲穿透等级"] = {StatLogic.Stats.ArmorPenetrationRating},
	["护甲穿透等级提高"] = {StatLogic.Stats.ArmorPenetrationRating},

	-- Exclude
	["秒"] = false,
	["到"] = false,
	["格容器"] = false,
	["格箭袋"] = false,
	["格弹药袋"] = false,
	["远程攻击速度%"] = false, -- AV quiver
}