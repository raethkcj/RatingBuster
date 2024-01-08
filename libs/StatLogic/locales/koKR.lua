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
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["최하급 마술사 오일"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["하급 마술사 오일"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["마술사 오일"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["반짝이는 마술사 오일"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["상급 마술사 오일"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522

	["최하급 마나 오일"] = {["MANA_REG"] = 4}, -- ID: 20745
	["하급 마나 오일"] = {["MANA_REG"] = 8}, -- ID: 20747
	["반짝이는 마나 오일"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["상급 마나 오일"] = {["MANA_REG"] = 14}, -- ID: 22521

	["전투력"] = {["AP"] = 70}, -- 전투력
	["활력"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality "Vitality" spell: 27948
	["냉기의 영혼"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["태양의 불꽃"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

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
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	["^(%d+)의 피해 방어$"] = "BLOCK_VALUE",
	["^방어도 (%d+)$"] = "ARMOR",
	["방어도 보강 %(%+(%d+)%)"] = "ARMOR_BONUS",
	["매 5초마다 (%d+)의 생명력이 회복됩니다.$"] = "HEALTH_REG",
	["매 5초마다 (%d+)의 마나가 회복됩니다.$"] = "MANA_REG",
	-- Exclude
	["^(%d+)칸"] = false, -- Set Name (0/9)
	["^[%D ]+ %((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
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
	["^%+(%d+) 치유량 %+(%d+) 주문 공격력$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^모든 주문 및 효과에 의한 치유량이 최대 (%d+)만큼, 공격력이 최대 (%d+)만큼 증가합니다$"] = {{"HEAL",}, {"SPELL_DMG",},},
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
	["공격 시 적의 방어도를 무시합니다"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733")
	["무기 공격력"] = {"MELEE_DMG"}, -- Enchant

	["모든 능력치"] = {StatLogic.Stats.AllStats,},
	["힘"] = {StatLogic.Stats.Strength,},
	["민첩성"] = {StatLogic.Stats.Agility,},
	["체력"] = {StatLogic.Stats.Stamina,},
	["지능"] = {StatLogic.Stats.Intellect,},
	["정신력"] = {StatLogic.Stats.Spirit,},

	["비전 저항력"] = {"ARCANE_RES",},
	["화염 저항력"] = {"FIRE_RES",},
	["자연 저항력"] = {"NATURE_RES",},
	["냉기 저항력"] = {"FROST_RES",},
	["암흑 저항력"] = {"SHADOW_RES",},
	["비전 저항"] = {"ARCANE_RES",}, -- Arcane Armor Kit +8 Arcane Resist
	["화염 저항"] = {"FIRE_RES",}, -- Flame Armor Kit +8 Fire Resist
	["자연 저항"] = {"NATURE_RES",}, -- Frost Armor Kit +8 Frost Resist
	["냉기 저항"] = {"FROST_RES",}, -- Nature Armor Kit +8 Nature Resist
	["암흑 저항"] = {"SHADOW_RES",}, -- Shadow Armor Kit +8 Shadow Resist
	["모든 저항력"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["모든 저항"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	["낚시"] = false, -- Fishing enchant ID:846
	["낚시 숙련도"] = false, -- Fishing lure
	["낚시 숙련도가 증가합니다"] = false, -- Equip: Increased Fishing +20.
	["채광"] = false, -- Mining enchant ID:844
	["약초 채집"] = false, -- Heabalism enchant ID:845
	["무두질"] = false, -- Skinning enchant ID:865

	["방어도"] = {"ARMOR_BONUS",},
	["방어 숙련"] = {StatLogic.Stats.Defense,},
	["방어 숙련 증가"] = {StatLogic.Stats.Defense,},
	["피해 방어"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["피해 방어량"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["방패의 피해 방어량이 증가합니다"] = {"BLOCK_VALUE",},

	["생명력"] = {"HEALTH",},
	["HP"] = {"HEALTH",},
	["마나"] = {"MANA",},

	["전투력"] = {"AP",},
	["전투력이 증가합니다"] = {"AP",},
	["달빛야수 변신 상태일 때 전투력"] = {"FERAL_AP",},
	["달빛야수 변신 상태일 때 전투력이 증가합니다"] = {"FERAL_AP",},
	["원거리 전투력"] = {"RANGED_AP",},
	["원거리 전투력이 증가합니다"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["생명력 회복량"] = {"MANA_REG",},
	["매 초마다 (.+)의 생명력"] = {"HEALTH_REG",},
	["health per"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
	["Health every"] = {"MANA_REG",},
	["health every"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["your normal health regeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
	["매 5초마다 (.+)의 생명력"] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
	["Restoreshealth every 5 sec"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["마나 회복량"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells spell: 24167
	["매 초마다 (.+)의 마나"] = {"MANA_REG",},
	["mana per"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
	["Mana every"] = {"MANA_REG",},
	["mana every"] = {"MANA_REG",},
	["매 5초마다 (.+)의 마나"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
	["Mana every 5 Sec"] = {"MANA_REG",}, --
	["5초당 마나 회복량"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." spell: 33991
	["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["Restoresmana per 5 sec"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
	["Mana restored per 5 seconds"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds spell: 32399
	["Mana Regenper 5 sec"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." spell: 23801
	["Mana per 5 Sec"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." spell: 27913

	["주문 관통력"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" spell: 34003
	["주문 관통력이 증가합니다"] = {"SPELLPEN",},

	["치유량 및 주문 공격력"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage spell: 22844
	["치유 및 주문 공격력"] = {"SPELL_DMG", "HEAL",},
	["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["주문 공격력"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["공격력"] = {"SPELL_DMG",},
	["주문 공격력이 증가합니다"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
	["주문 위력"] = {"SPELL_DMG", "HEAL",},
	["주문력이 증가합니다"] = {"SPELL_DMG", "HEAL",}, -- WotLK
	["신성 피해"] = {"HOLY_SPELL_DMG",},
	["비전 피해"] = {"ARCANE_SPELL_DMG",},
	["화염 피해"] = {"FIRE_SPELL_DMG",},
	["자연 피해"] = {"NATURE_SPELL_DMG",},
	["냉기 피해"] = {"FROST_SPELL_DMG",},
	["암흑 피해"] = {"SHADOW_SPELL_DMG",},
	["신성 주문 공격력"] = {"HOLY_SPELL_DMG",},
	["비전 주문 공격력"] = {"ARCANE_SPELL_DMG",},
	["화염 주문 공격력"] = {"FIRE_SPELL_DMG",},
	["자연 주문 공격력"] = {"NATURE_SPELL_DMG",},
	["냉기 주문 공격력"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["암흑 주문 공격력"] = {"SHADOW_SPELL_DMG",},
	["암흑 계열의 주문과 효과의 공격력이 증가합니다"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["냉기 계열의 주문과 효과의 공격력이 증가합니다"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["신성 계열의 주문과 효과의 공격력이 증가합니다"] = {"HOLY_SPELL_DMG",},
	["비전 계열의 주문과 효과의 공격력이 증가합니다"] = {"ARCANE_SPELL_DMG",},
	["화염 계열의 주문과 효과의 공격력이 증가합니다"] = {"FIRE_SPELL_DMG",},
	["자연 계열의 주문과 효과의 공격력이 증가합니다"] = {"NATURE_SPELL_DMG",},
	["Increases the damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
	["Increases the damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Added just in case

	["주문 치유량"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" spell: 33999
	["치유량 증가"] = {"HEAL",},
	["치유량"] = {"HEAL",},
	["healing Spells"] = {"HEAL",},
	["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	["모든 주문 및 효과에 의한 치유량이"] = {"HEAL",}, -- 2.3.0
	["공격력이 증가합니다"] = {"SPELL_DMG",}, -- 2.3.0
	["모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",}, -- Atiesh
	["your healing"] = {"HEAL",}, -- Atiesh

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

	["Improves your chance to hit%"] = {"MELEE_HIT", "RANGED_HIT"},
	["Improves your chance to hit with spells and with melee and ranged attacks%"] = {"MELEE_HIT", "RANGED_HIT", "SPELL_HIT"},
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