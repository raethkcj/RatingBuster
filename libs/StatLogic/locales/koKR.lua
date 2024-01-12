-- koKR localization by fenlis
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "koKR")
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = tonumber
------------------
-- Prefix Exclude --
------------------
-- By looking at the first PrefixExcludeLength letters of a line we can exclude a lot of lines
L["PrefixExcludeLength"] = 3
L["PrefixExclude"] = {}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	["최하급 마술사 오일"] = {[StatLogic.Stats.SpellDamage] = 8, [StatLogic.Stats.HealingPower] = 8}, -- ID: 20744
	["하급 마술사 오일"] = {[StatLogic.Stats.SpellDamage] = 16, [StatLogic.Stats.HealingPower] = 16}, -- ID: 20746
	["마술사 오일"] = {[StatLogic.Stats.SpellDamage] = 24, [StatLogic.Stats.HealingPower] = 24}, -- ID: 20750
	["반짝이는 마술사 오일"] = {[StatLogic.Stats.SpellDamage] = 36, [StatLogic.Stats.HealingPower] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["상급 마술사 오일"] = {[StatLogic.Stats.SpellDamage] = 42, [StatLogic.Stats.HealingPower] = 42}, -- ID: 22522

	["최하급 마나 오일"] = {[StatLogic.Stats.ManaRegen] = 4}, -- ID: 20745
	["하급 마나 오일"] = {[StatLogic.Stats.ManaRegen] = 8}, -- ID: 20747
	["반짝이는 마나 오일"] = {[StatLogic.Stats.ManaRegen] = 12, [StatLogic.Stats.HealingPower] = 25}, -- ID: 20748
	["상급 마나 오일"] = {[StatLogic.Stats.ManaRegen] = 14}, -- ID: 22521

	["전투력"] = {[StatLogic.Stats.AttackPower] = 70}, -- 전투력
	["활력"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4}, -- Enchant Boots - Vitality "Vitality" spell: 27948
	["냉기의 영혼"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54}, --
	["태양의 불꽃"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50}, --

	["이동 속도가 약간 증가합니다."] = false, --
	["하급 이동 속도 증가"] = false, -- Enchant Boots - Minor Speed "Minor Speed Increase" spell: 13890
	["하급 이동 속도"] = false, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" spell: 34007
	["침착함"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" spell: 27954

	["착용 효과: 시전자를 물 속에서 숨쉴 수 있도록 해줍니다."] = false, -- [Band of Icy Depths] ID: 21526
	["시전자를 물 속에서 숨쉴 수 있도록 해줍니다"] = false, --
	["착용 효과: 무장해제에 면역이 됩니다."] = false, -- [Stronghold Gauntlets] ID: 12639
	["무장해제에 면역이 됩니다"] = false, --
	["성전사"] = false, -- Enchant Crusader
	["흡혈"] = false, -- Enchant Crusader
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) (.-)%.?$"
-- Stamina +19 = "^(.-) %+(%d+)%.?$"
-- +19 耐力 = "^%+(%d+) (.-)%.?$"
-- Some have a "." at the end of string like:
-- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec. "
L["SinglePlusStatCheck"] = "^(.-) ([%+%-]%d+)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^" .. ITEM_SPELL_TRIGGER_ONEQUIP .. " (.-) (%d+)만큼(.-)$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = StatLogic.Stats.FeralAttackPower,
	["^(%d+)의 피해 방어$"] = StatLogic.Stats.BlockValue,
	["^방어도 (%d+)$"] = StatLogic.Stats.Armor,
	["방어도 보강 %(%+(%d+)%)"] = StatLogic.Stats.BonusArmor,
	["매 5초마다 (%d+)의 생명력이 회복됩니다.$"] = StatLogic.Stats.HealthRegen,
	["매 5초마다 (%d+)의 마나가 회복됩니다.$"] = StatLogic.Stats.ManaRegen,
	-- Exclude
	["^(%d+)칸"] = false, -- Set Name (0/9)
	["^[%D ]+ %((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	-- Procs
	["발동"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["확률로"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["가격 당했을 때"] = false, -- [Essence of the Pure Flame] ID: 18815
	["성공하면"] = false,
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "착용 효과: "
L["Socket Bonus: "] = "보석 장착 보너스: "
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
	" / ",
}
L["DeepScanWordSeparators"] = {
	-- only put word separators here like "and" in english
	--" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
-- all lower case
L["DualStatPatterns"] = {
	["^%+(%d+) 치유량 %+(%d+) 주문 공격력$"] = {{StatLogic.Stats.HealingPower,}, {StatLogic.Stats.SpellDamage,},},
	["^모든 주문 및 효과에 의한 치유량이 최대 (%d+)만큼, 공격력이 최대 (%d+)만큼 증가합니다$"] = {{StatLogic.Stats.HealingPower,}, {StatLogic.Stats.SpellDamage,},},
}
L["DeepScanPatterns"] = {
	"^(.-) (%d+)만큼(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-) 최대 (%d+)만큼(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
	"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["공격 시 적의 방어도를 무시합니다"] = {StatLogic.Stats.IgnoreArmor}, -- StatLogic:GetSum("item:33733")
	["무기 공격력"] = {StatLogic.Stats.AverageWeaponDamage}, -- Enchant

	["모든 능력치"] = {StatLogic.Stats.AllStats,},
	["힘"] = {StatLogic.Stats.Strength,},
	["민첩성"] = {StatLogic.Stats.Agility,},
	["체력"] = {StatLogic.Stats.Stamina,},
	["지능"] = {StatLogic.Stats.Intellect,},
	["정신력"] = {StatLogic.Stats.Spirit,},

	["비전 저항력"] = {StatLogic.Stats.ArcaneResistance,},
	["화염 저항력"] = {StatLogic.Stats.FireResistance,},
	["자연 저항력"] = {StatLogic.Stats.NatureResistance,},
	["냉기 저항력"] = {StatLogic.Stats.FrostResistance,},
	["암흑 저항력"] = {StatLogic.Stats.ShadowResistance,},
	["비전 저항"] = {StatLogic.Stats.ArcaneResistance,}, -- Arcane Armor Kit +8 Arcane Resist
	["화염 저항"] = {StatLogic.Stats.FireResistance,}, -- Flame Armor Kit +8 Fire Resist
	["자연 저항"] = {StatLogic.Stats.NatureResistance,}, -- Frost Armor Kit +8 Frost Resist
	["냉기 저항"] = {StatLogic.Stats.FrostResistance,}, -- Nature Armor Kit +8 Nature Resist
	["암흑 저항"] = {StatLogic.Stats.ShadowResistance,}, -- Shadow Armor Kit +8 Shadow Resist
	["모든 저항력"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},
	["모든 저항"] = {StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance,},

	["낚시"] = false, -- Fishing enchant ID:846
	["낚시 숙련도"] = false, -- Fishing lure
	["낚시 숙련도가 증가합니다"] = false, -- Equip: Increased Fishing +20.
	["채광"] = false, -- Mining enchant ID:844
	["약초 채집"] = false, -- Heabalism enchant ID:845
	["무두질"] = false, -- Skinning enchant ID:865

	["방어도"] = {StatLogic.Stats.BonusArmor,},
	["방어 숙련"] = {StatLogic.Stats.Defense,},
	["방어 숙련 증가"] = {StatLogic.Stats.Defense,},
	["피해 방어"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["피해 방어량"] = {StatLogic.Stats.BlockValue,}, -- +22 Block Value
	["방패의 피해 방어량이 증가합니다"] = {StatLogic.Stats.BlockValue,},

	["생명력"] = {StatLogic.Stats.Health,},
	["HP"] = {StatLogic.Stats.Health,},
	["마나"] = {StatLogic.Stats.Mana,},

	["전투력"] = {StatLogic.Stats.AttackPower,},
	["전투력이 증가합니다"] = {StatLogic.Stats.AttackPower,},
	["달빛야수 변신 상태일 때 전투력"] = {StatLogic.Stats.FeralAttackPower,},
	["달빛야수 변신 상태일 때 전투력이 증가합니다"] = {StatLogic.Stats.FeralAttackPower,},
	["원거리 전투력"] = {StatLogic.Stats.RangedAttackPower,},
	["원거리 전투력이 증가합니다"] = {StatLogic.Stats.RangedAttackPower,}, -- [High Warlord's Crossbow] ID: 18837

	["생명력 회복량"] = {StatLogic.Stats.ManaRegen,},
	["매 초마다 (.+)의 생명력"] = {StatLogic.Stats.HealthRegen,},
	["health per"] = {StatLogic.Stats.HealthRegen,}, -- Frostwolf Insignia Rank 6 ID:17909
	["Health every"] = {StatLogic.Stats.ManaRegen,},
	["health every"] = {StatLogic.Stats.HealthRegen,}, -- [Resurgence Rod] ID:17743
	["your normal health regeneration"] = {StatLogic.Stats.HealthRegen,}, -- Demons Blood ID: 10779
	["매 5초마다 (.+)의 생명력"] = {StatLogic.Stats.HealthRegen,}, -- [Onyxia Blood Talisman] ID: 18406
	["Restoreshealth every 5 sec"] = {StatLogic.Stats.HealthRegen,}, -- [Resurgence Rod] ID:17743
	["마나 회복량"] = {StatLogic.Stats.ManaRegen,}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells spell: 24167
	["매 초마다 (.+)의 마나"] = {StatLogic.Stats.ManaRegen,},
	["mana per"] = {StatLogic.Stats.ManaRegen,}, -- Resurgence Rod ID:17743 Most common
	["Mana every"] = {StatLogic.Stats.ManaRegen,},
	["mana every"] = {StatLogic.Stats.ManaRegen,},
	["매 5초마다 (.+)의 마나"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Nightseye] ID: 24057
	["Mana every 5 Sec"] = {StatLogic.Stats.ManaRegen,}, --
	["5초당 마나 회복량"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." spell: 33991
	["Mana per 5 Seconds"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Royal Tanzanite] ID: 30603
	["Restoresmana per 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- [Resurgence Rod] ID:17743
	["Mana restored per 5 seconds"] = {StatLogic.Stats.ManaRegen,}, -- Magister's Armor Kit +3 Mana restored per 5 seconds spell: 32399
	["Mana Regenper 5 sec"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." spell: 23801
	["Mana per 5 Sec"] = {StatLogic.Stats.ManaRegen,}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." spell: 27913

	["주문 관통력"] = {StatLogic.Stats.SpellPenetration,}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" spell: 34003
	["주문 관통력이 증가합니다"] = {StatLogic.Stats.SpellPenetration,},

	["치유량 및 주문 공격력"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
	["치유 및 주문 공격력"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["주문 공격력 및 치유량"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, --StatLogic:GetSum("item:22630")
	["주문 공격력"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower}, -- Atiesh
	["공격력"] = {StatLogic.Stats.SpellDamage,},
	["주문 공격력이 증가합니다"] = {StatLogic.Stats.SpellDamage,}, -- Atiesh ID:22630, 22631, 22632, 22589
	["주문 위력"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,},
	["주문력이 증가합니다"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower,}, -- WotLK
	["신성 피해"] = {StatLogic.Stats.HolyDamage,},
	["비전 피해"] = {StatLogic.Stats.ArcaneDamage,},
	["화염 피해"] = {StatLogic.Stats.FireDamage,},
	["자연 피해"] = {StatLogic.Stats.NatureDamage,},
	["냉기 피해"] = {StatLogic.Stats.FrostDamage,},
	["암흑 피해"] = {StatLogic.Stats.ShadowDamage,},
	["신성 주문 공격력"] = {StatLogic.Stats.HolyDamage,},
	["비전 주문 공격력"] = {StatLogic.Stats.ArcaneDamage,},
	["화염 주문 공격력"] = {StatLogic.Stats.FireDamage,},
	["자연 주문 공격력"] = {StatLogic.Stats.NatureDamage,},
	["냉기 주문 공격력"] = {StatLogic.Stats.FrostDamage,}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["암흑 주문 공격력"] = {StatLogic.Stats.ShadowDamage,},
	["암흑 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.ShadowDamage,}, -- Frozen Shadoweave Vest ID:21871
	["냉기 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.FrostDamage,}, -- Frozen Shadoweave Vest ID:21871
	["신성 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.HolyDamage,},
	["비전 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.ArcaneDamage,},
	["화염 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.FireDamage,},
	["자연 계열의 주문과 효과의 공격력이 증가합니다"] = {StatLogic.Stats.NatureDamage,},
	["Increases the damage done by Holy spells and effects"] = {StatLogic.Stats.HolyDamage,}, -- Drape of the Righteous ID:30642
	["Increases the damage done by Arcane spells and effects"] = {StatLogic.Stats.ArcaneDamage,}, -- Added just in case
	["Increases the damage done by Fire spells and effects"] = {StatLogic.Stats.FireDamage,}, -- Added just in case
	["Increases the damage done by Frost spells and effects"] = {StatLogic.Stats.FrostDamage,}, -- Added just in case
	["Increases the damage done by Nature spells and effects"] = {StatLogic.Stats.NatureDamage,}, -- Added just in case
	["Increases the damage done by Shadow spells and effects"] = {StatLogic.Stats.ShadowDamage,}, -- Added just in case

	["주문 치유량"] = {StatLogic.Stats.HealingPower,}, -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
	["치유량 증가"] = {StatLogic.Stats.HealingPower,},
	["치유량"] = {StatLogic.Stats.HealingPower,},
	["healing Spells"] = {StatLogic.Stats.HealingPower,},
	["Healing Spells"] = {StatLogic.Stats.HealingPower,}, -- [Royal Nightseye] ID: 24057
	["모든 주문 및 효과에 의한 치유량이"] = {StatLogic.Stats.HealingPower,}, -- 2.3.0
	["공격력이 증가합니다"] = {StatLogic.Stats.SpellDamage,}, -- 2.3.0
	["모든 주문 및 효과에 의한 치유량이 증가합니다"] = {StatLogic.Stats.HealingPower,},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 증가합니다"] = {StatLogic.Stats.HealingPower,}, -- Atiesh
	["your healing"] = {StatLogic.Stats.HealingPower,}, -- Atiesh

	["초당 공격력"] = {StatLogic.Stats.WeaponDPS,},
	["초당의 피해 추가"] = {StatLogic.Stats.WeaponDPS,}, -- [Thorium Shells] ID: 15977

	["방어 숙련도"] = {StatLogic.Stats.DefenseRating,},
	["방어 숙련도가 증가합니다"] = {StatLogic.Stats.DefenseRating,},
	["회피 숙련도"] = {StatLogic.Stats.DodgeRating,},
	["회피 숙련도가 증가합니다."] = {StatLogic.Stats.DodgeRating,},
	["무기 막기 숙련도"] = {StatLogic.Stats.ParryRating,},
	["무기 막기 숙련도가 증가합니다"] = {StatLogic.Stats.ParryRating,},
	["방패 막기 숙련도"] = {StatLogic.Stats.BlockRating,}, -- Enchant Shield - Lesser Block +10 Shield Block Rating spell: 13689
	["방패 막기 숙련도가 증가합니다"] = {StatLogic.Stats.BlockRating,},

	["Improves your chance to hit%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit},
	["Improves your chance to hit with spells and with melee and ranged attacks%"] = {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit},
	["적중도"] = {StatLogic.Stats.HitRating,},
	["적중도가 증가합니다"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["근접 적중도가 증가합니다"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["주문 적중"] = {StatLogic.Stats.SpellHitRating,}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit spell: 24164
	["주문 적중도"] = {StatLogic.Stats.SpellHitRating,},
	["주문의 적중도"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["주문 적중도가 증가합니다"] = {StatLogic.Stats.SpellHitRating,},
	["원거리 적중도"] = {StatLogic.Stats.RangedHitRating,},
	["원거리 적중도가 증가합니다"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING

	["치명타 적중도"] = {StatLogic.Stats.CritRating,},
	["치명타 적중도가 증가합니다"] = {StatLogic.Stats.CritRating,},
	["근접 치명타 적중도가 증가합니다"] = {StatLogic.Stats.MeleeCritRating,},
	["주문 극대화 적중도"] = {StatLogic.Stats.SpellCritRating,},
	["주문의 극대화 적중도"] = {StatLogic.Stats.SpellCritRating,},
	["주문의 극대화 적중도가 증가합니다"] = {StatLogic.Stats.SpellCritRating,},
	["주위 30미터 반경에 있는 모든 파티원의 주문 극대화 적중도가 증가합니다"] = {StatLogic.Stats.SpellCritRating,},
	["주문 극대화 적중도가 증가합니다"] = {StatLogic.Stats.SpellCritRating,},
	["원거리 치명타 적중도가 증가합니다"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348

	["탄력도"] = {StatLogic.Stats.ResilienceRating,}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" spell: 33992
	["탄력도가 증가합니다"] = {StatLogic.Stats.ResilienceRating,},

	["공격 가속도"] = {StatLogic.Stats.HasteRating},
	["공격 가속도가 증가합니다"] = {StatLogic.Stats.HasteRating},
	["주문 시전 가속도"] = {StatLogic.Stats.SpellHasteRating},
	["원거리 공격 가속도"] = {StatLogic.Stats.RangedHasteRating},
	["근접 공격 가속도가 증가합니다"] = {StatLogic.Stats.MeleeHasteRating},
	["주문 시전 가속도가 증가합니다"] = {StatLogic.Stats.SpellHasteRating},
	["원거리 공격 가속도가 증가합니다"] = {StatLogic.Stats.RangedHasteRating},

	["숙련"] = {StatLogic.Stats.ExpertiseRating}, -- gems
	["숙련도가 증가합니다"] = {StatLogic.Stats.ExpertiseRating},
	["방어구 관통력"] = {StatLogic.Stats.ArmorPenetrationRating}, -- gems
	["방어구 관통력이 증가합니다"] = {StatLogic.Stats.ArmorPenetrationRating},

	-- Exclude
	["초"] = false,
	["to"] = false,
	["칸 가방"] = false,
	["칸 화살통"] = false,
	["칸 탄환 주머니"] = false,
	["원거리 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
	["원거리 무기 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
}