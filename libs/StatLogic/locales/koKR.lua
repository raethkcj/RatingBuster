-- koKR localization by fenlis
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "koKR")
if not L then return end

L["tonumber"] = tonumber
------------------
-- Fast Exclude --
------------------
-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
L["ExcludeLen"] = 3
L["Exclude"] = {
	[""] = true,
	[" \n"] = true,
	[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "착용 시 귀속"; -- Item will be bound when equipped
	[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "획득 시 귀속"; -- Item wil be bound when picked up
	[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "사용 시 귀속"; -- Item will be bound when used
	[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "퀘스트 아이템"; -- Item is a quest item (same logic as ON_PICKUP)
	[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "귀속 아이템"; -- Item is Soulbound
	--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "푸른색 보석 홈";
	--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "얼개 보석 홈";
	--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "붉은색 보석 홈";
	--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "노란색 보석 홈";
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "퀘스트 시작 아이템"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "그 아이템은 버릴 수 없습니다."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "창조된 아이템"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "마력 추출 불가"; -- Items which cannot be disenchanted ever
	["마력 "] = true, -- ITEM_DISENCHANT_ANY_SKILL = "마력 추출 가능"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "마력 추출 요구 사항: %s (%d)"; -- Minimum enchanting skill needed to disenchant
	["지속시"] = true, -- ITEM_DURATION_DAYS = "지속시간: %d일";
	["<제작"] = true, -- ITEM_CREATED_BY = "|cff00ff00<제작자: %s>|r"; -- %s is the creator of the item
	["재사용"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "재사용 대기시간: %d일";
	["고유 "] = true, -- Unique (20)
	["최소 "] = true, -- Requires Level xx
	["\n최소"] = true, -- Requires Level xx
	["직업:"] = true, -- Classes: xx
	["종족:"] = true, -- Races: xx (vendor mounts)
	["사용 "] = true, -- Use:
	["발동 "] = true, -- Chance On Hit:
	-- Set Bonuses
	-- ITEM_SET_BONUS = "세트 효과: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) 세트 효과: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["세트 "] = true,
	["(2)"] = true,
	["(3)"] = true,
	["(4)"] = true,
	["(5)"] = true,
	["(6)"] = true,
	["(7)"] = true,
	["(8)"] = true,
	-- Equip type
	[GetItemClassInfo(Enum.ItemClass.Projectile)] = true, -- Ice Threaded Arrow ID:19316
	[INVTYPE_AMMO] = true,
	[INVTYPE_HEAD] = true,
	[INVTYPE_NECK] = true,
	[INVTYPE_SHOULDER] = true,
	[INVTYPE_BODY] = true,
	[INVTYPE_CHEST] = true,
	[INVTYPE_ROBE] = true,
	[INVTYPE_WAIST] = true,
	[INVTYPE_LEGS] = true,
	[INVTYPE_FEET] = true,
	[INVTYPE_WRIST] = true,
	[INVTYPE_HAND] = true,
	[INVTYPE_FINGER] = true,
	[INVTYPE_TRINKET] = true,
	[INVTYPE_CLOAK] = true,
	[INVTYPE_WEAPON] = true,
	[INVTYPE_SHIELD] = true,
	[INVTYPE_2HWEAPON] = true,
	[INVTYPE_WEAPONMAINHAND] = true,
	[INVTYPE_WEAPONOFFHAND] = true,
	[INVTYPE_HOLDABLE] = true,
	[INVTYPE_RANGED] = true,
	[GetItemSubClassInfo(Enum.ItemClass.Weapon, Enum.ItemWeaponSubclass.Thrown)] = true,
	[INVTYPE_RELIC] = true,
	[INVTYPE_TABARD] = true,
	[INVTYPE_BAG] = true,
}
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
-- http://wow.allakhazam.com/db/enchant.html?slot=0&locale=enUS
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["최하급 마술사 오일"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["하급 마술사 오일"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["마술사 오일"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["반짝이는 마술사 오일"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
	["상급 마술사 오일"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
	["신성한 마술사 오일"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["최하급 마나 오일"] = {["MANA_REG"] = 4}, -- ID: 20745
	["하급 마나 오일"] = {["MANA_REG"] = 8}, -- ID: 20747
	["반짝이는 마나 오일"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["상급 마나 오일"] = {["MANA_REG"] = 14}, -- ID: 22521

	["에터니움 낚시줄"] = {["FISHING"] = 5}, --
	["전투력"] = {["AP"] = 70}, -- 전투력
	["활력"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality "Vitality" http://wow.allakhazam.com/db/spell.html?wspell=27948
	["냉기의 영혼"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["태양의 불꽃"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["미스릴 박차"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["최하급 탈것 속도 증가"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["착용 효과: 이동 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["이동 속도가 약간 증가합니다."] = {["RUN_SPEED"] = 8}, --
	["하급 이동 속도 증가"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["하급 이동 속도"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["침착함"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["위협 수준 감소"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["위협 수준 +2%"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
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
-- stat1, value, stat2 = strfind
-- stat = stat1..stat2
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^착용 효과: (.-) (%d+)만큼(.-)$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+)의 피해 방어$"] = "BLOCK_VALUE",
	["^방어도 (%d+)$"] = "ARMOR",
	["방어도 보강 %(%+(%d+)%)"] = "ARMOR_BONUS",
	["매 5초마다 (%d+)의 생명력이 회복됩니다.$"] = "HEALTH_REG",
	["매 5초마다 (%d+)의 마나가 회복됩니다.$"] = "MANA_REG",
	["^.-공격력 %+?%d+ %- (%d+)$"] = "MAX_DAMAGE",
	["^%(초당 공격력 ([%d%.]+)%)$"] = "DPS",
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
	["% 위협"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["은신 효과가 증가합니다"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["무기 공격력"] = {"MELEE_DMG"}, -- Enchant
	["탈것의 속도가%만큼 증가합니다"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["모든 능력치"] = {"STR", "AGI", "STA", "INT", "SPI",},
	["힘"] = {"STR",},
	["민첩성"] = {"AGI",},
	["체력"] = {"STA",},
	["지능"] = {"INT",},
	["정신력"] = {"SPI",},

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
	["암흑 저항력"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
	["모든 저항력"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["모든 저항"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	["낚시"] = {"FISHING",}, -- Fishing enchant ID:846
	["낚시 숙련도"] = {"FISHING",}, -- Fishing lure
	["낚시 숙련도가 증가합니다"] = {"FISHING",}, -- Equip: Increased Fishing +20.
	["채광"] = {"MINING",}, -- Mining enchant ID:844
	["약초 채집"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["무두질"] = {"SKINNING",}, -- Skinning enchant ID:865

	["방어도"] = {"ARMOR_BONUS",},
	["방어 숙련"] = {"DEFENSE",},
	["방어 숙련 증가"] = {"DEFENSE",},
	["피해 방어"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["피해 방어량"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["방패의 피해 방어량이 증가합니다"] = {"BLOCK_VALUE",},

	["생명력"] = {"HEALTH",},
	["HP"] = {"HEALTH",},
	["마나"] = {"MANA",},

	["전투력"] = {"AP",},
	["전투력이 증가합니다"] = {"AP",},
	["언데드 공격 시 전투력"] = {"AP_UNDEAD",},
	-- [Wristwraps of Undead Slaying] ID:23093
	["언데드 공격 시 전투력이 증가합니다"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["언데드와 전투 시 전투력이 증가합니다. 또한 은빛여명회의 대리인으로서 스컬지석을 모을 수 있습니다"] = {"AP_UNDEAD",},
	["악마에 대한 전투력이 증가합니다"] = {"AP_DEMON",},
	["언데드 및 악마에 대한 전투력이 증가합니다"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
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
	["마나 회복량"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
	["매 초마다 (.+)의 마나"] = {"MANA_REG",},
	["mana per"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
	["Mana every"] = {"MANA_REG",},
	["mana every"] = {"MANA_REG",},
	["매 5초마다 (.+)의 마나"] = {"MANA_REG",}, -- [Royal Nightseye] ID: 24057
	["Mana every 5 Sec"] = {"MANA_REG",}, --
	["5초당 마나 회복량"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
	["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["Restoresmana per 5 sec"] = {"MANA_REG",}, -- [Resurgence Rod] ID:17743
	["Mana restored per 5 seconds"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
	["Mana Regenper 5 sec"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
	["Mana per 5 Sec"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913

	["주문 관통력"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
	["주문 관통력이 증가합니다"] = {"SPELLPEN",},

	["치유량 및 주문 공격력"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
	["치유 및 주문 공격력"] = {"SPELL_DMG", "HEAL",},
	["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",},
	["주문 공격력"] = {"SPELL_DMG", "HEAL",},
	["모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과의 공격력과 치유량이 증가합니다"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["주문 공격력 및 치유량"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
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

	-- [Robe of Undead Cleansing] ID:23085
	["언데드에 대한 효과나 주문에 의한 피해가 증가합니다"] = {"SPELL_DMG_UNDEAD"},
	["언데드와 전투 시 모든 주문 및 효과에 의한 피해량이 증가합니다. 또한 은빛여명회의 대리인으로서 스컬지석을 모을 수 있습니다"] = {"SPELL_DMG_UNDEAD"},
	["언데드 및 악마에 대한 주문 및 효과에 의한 공격력이 증가합니다"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

	["주문 치유량"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
	["치유량 증가"] = {"HEAL",},
	["치유량"] = {"HEAL",},
	["healing Spells"] = {"HEAL",},
	["주문 공격력"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	["모든 주문 및 효과에 의한 치유량이"] = {"HEAL",}, -- 2.3.0
	["공격력이 증가합니다"] = {"SPELL_DMG",}, -- 2.3.0
	["모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",},
	["주위 30미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 증가합니다"] = {"HEAL",}, -- Atiesh
	["your healing"] = {"HEAL",}, -- Atiesh

	["초당 공격력"] = {"DPS",},
	["초당의 피해 추가"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["방어 숙련도"] = {"DEFENSE_RATING",},
	["방어 숙련도가 증가합니다"] = {"DEFENSE_RATING",},
	["회피 숙련도"] = {"DODGE_RATING",},
	["회피 숙련도가 증가합니다."] = {"DODGE_RATING",},
	["무기 막기 숙련도"] = {"PARRY_RATING",},
	["무기 막기 숙련도가 증가합니다"] = {"PARRY_RATING",},
	["방패 막기 숙련도"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["방패 막기 숙련도"] = {"BLOCK_RATING",},
	["방패 막기 숙련도가 증가합니다"] = {"BLOCK_RATING",},
	["방패 막기 숙련도가 증가합니다"] = {"BLOCK_RATING",},

	["적중도"] = {"HIT_RATING",},
	["적중도가 증가합니다"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_RATING
	["근접 적중도가 증가합니다"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
	["주문 적중"] = {"SPELL_HIT_RATING",}, -- Presence of Sight +18 Healing and Spell Damage/+8 Spell Hit http://wow.allakhazam.com/db/spell.html?wspell=24164
	["주문 적중도"] = {"SPELL_HIT_RATING",},
	["주문의 적중도"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
	["주문 적중도가 증가합니다"] = {"SPELL_HIT_RATING",},
	["원거리 적중도"] = {"RANGED_HIT_RATING",},
	["원거리 적중도가 증가합니다"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING

	["치명타 적중도"] = {"CRIT_RATING",},
	["치명타 적중도가 증가합니다"] = {"CRIT_RATING",},
	["근접 치명타 적중도가 증가합니다"] = {"MELEE_CRIT_RATING",},
	["주문 극대화 적중도"] = {"SPELL_CRIT_RATING",},
	["주문의 극대화 적중도"] = {"SPELL_CRIT_RATING",},
	["주문의 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
	["주위 30미터 반경에 있는 모든 파티원의 주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
	["주문 극대화 적중도가 증가합니다"] = {"SPELL_CRIT_RATING",},
	["원거리 치명타 적중도가 증가합니다"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

	["탄력도"] = {"RESILIENCE_RATING",},
	["탄력도"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
	["탄력도가 증가합니다"] = {"RESILIENCE_RATING",},

	["공격 가속도"] = {"HASTE_RATING"},
	["공격 가속도가 증가합니다"] = {"HASTE_RATING"},
	["주문 시전 가속도"] = {"SPELL_HASTE_RATING"},
	["원거리 공격 가속도"] = {"RANGED_HASTE_RATING"},
	["근접 공격 가속도가 증가합니다"] = {"MELEE_HASTE_RATING"},
	["주문 시전 가속도가 증가합니다"] = {"SPELL_HASTE_RATING"},
	["원거리 공격 가속도가 증가합니다"] = {"RANGED_HASTE_RATING"},

	["단검류 숙련도가 증가합니다"] = {"DAGGER_WEAPON_RATING"},
	["한손 도검류 숙련도가 증가합니다"] = {"SWORD_WEAPON_RATING"},
	["양손 도검류 숙련도가 증가합니다"] = {"2H_SWORD_WEAPON_RATING"},
	["한손 도끼류 숙련도가 증가합니다"] = {"AXE_WEAPON_RATING"},
	["양손 도끼류 숙련도가 증가합니다"] = {"2H_AXE_WEAPON_RATING"},
	["Increases two-handed axes skill rating"] = {"2H_AXE_WEAPON_RATING"},
	["한손 둔기류 숙련도가 증가합니다"] = {"MACE_WEAPON_RATING"},
	["양손 둔기류 숙련도가 증가합니다"] = {"2H_MACE_WEAPON_RATING"},
	["총기류 숙련도가 증가합니다"] = {"GUN_WEAPON_RATING"},
	["석궁류 숙련도가 증가합니다"] = {"CROSSBOW_WEAPON_RATING"},
	["활류 숙련도가 증가합니다"] = {"BOW_WEAPON_RATING"},
	["야생 전투 숙련도가 증가합니다"] = {"FERAL_WEAPON_RATING"},
	["장착 무기류 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
	["맨손 전투 숙련도가 증가합니다"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
	["지팡이류 숙련도가 증가합니다."] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410

	["숙련"] = {"EXPERTISE_RATING"}, -- gems
	["숙련도가 증가합니다"] = {"EXPERTISE_RATING"},
	["방어구 관통력"] = {"ARMOR_PENETRATION_RATING"}, -- gems
	["방어구 관통력이 증가합니다"] = {"ARMOR_PENETRATION_RATING"},

	-- Exclude
	["초"] = false,
	["to"] = false,
	["칸 가방"] = false,
	["칸 화살통"] = false,
	["칸 탄환 주머니"] = false,
	["원거리 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
	["원거리 무기 공격 속도가%만큼 증가합니다"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "koKR")
----------------
-- Stat Names --
----------------
-- Please localize these strings too, global strings were used in the enUS locale just to have minimum
-- localization effect when a locale is not available for that language, you don't have to use global
-- strings in your localization.
D["StatIDToName"] = {
	--[StatID] = {FullName, ShortName},
	---------------------------------------------------------------------------
	-- Tier1 Stats - Stats parsed directly off items
	["EMPTY_SOCKET_RED"] = {EMPTY_SOCKET_RED, EMPTY_SOCKET_RED}, -- EMPTY_SOCKET_RED = "Red Socket";
	["EMPTY_SOCKET_YELLOW"] = {EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_YELLOW}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	["EMPTY_SOCKET_BLUE"] = {EMPTY_SOCKET_BLUE, EMPTY_SOCKET_BLUE}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	["EMPTY_SOCKET_META"] = {EMPTY_SOCKET_META, EMPTY_SOCKET_META}, -- EMPTY_SOCKET_META = "Meta Socket";

	["IGNORE_ARMOR"] = {"방어도 무시", "Ignore Armor"},
	["THREAT_MOD"] = {"위협(%)", "Threat(%)"},
	["STEALTH_LEVEL"] = {"은신 등급", "Stealth"},
	["MELEE_DMG"] = {"근접 무기 "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
	["MOUNT_SPEED"] = {"탈것 속도(%)", "Mount Spd(%)"},
	["RUN_SPEED"] = {"이동 속도(%)", "Run Spd(%)"},

	["STR"] = {SPELL_STAT1_NAME, "Str"},
	["AGI"] = {SPELL_STAT2_NAME, "Agi"},
	["STA"] = {SPELL_STAT3_NAME, "Sta"},
	["INT"] = {SPELL_STAT4_NAME, "Int"},
	["SPI"] = {SPELL_STAT5_NAME, "Spi"},
	["ARMOR"] = {ARMOR, ARMOR},
	["ARMOR_BONUS"] = {"효과에 의한"..ARMOR, ARMOR.."(Bonus)"},

	["FIRE_RES"] = {RESISTANCE2_NAME, "FR"},
	["NATURE_RES"] = {RESISTANCE3_NAME, "NR"},
	["FROST_RES"] = {RESISTANCE4_NAME, "FrR"},
	["SHADOW_RES"] = {RESISTANCE5_NAME, "SR"},
	["ARCANE_RES"] = {RESISTANCE6_NAME, "AR"},

	["FISHING"] = {"낚시", "Fishing"},
	["MINING"] = {"채광", "Mining"},
	["HERBALISM"] = {"약초채집", "Herbalism"},
	["SKINNING"] = {"무두질", "Skinning"},

	["BLOCK_VALUE"] = {"피해 방어량", "Block Value"},

	["AP"] = {"전투력", "AP"},
	["RANGED_AP"] = {RANGED_ATTACK_POWER, "RAP"},
	["FERAL_AP"] = {"야생 전투력", "Feral AP"},
	["AP_UNDEAD"] = {"전투력 (언데드)", "AP(Undead)"},
	["AP_DEMON"] = {"전투력 (악마)", "AP(Demon)"},

	["HEAL"] = {"치유량", "Heal"},

	["SPELL_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE, PLAYERSTAT_SPELL_COMBAT.." Dmg"},
	["SPELL_DMG_UNDEAD"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (언데드)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
	["SPELL_DMG_DEMON"] = {PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.." (악마)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
	["HOLY_SPELL_DMG"] = {SPELL_SCHOOL1_CAP.." "..DAMAGE, SPELL_SCHOOL1_CAP.." Dmg"},
	["FIRE_SPELL_DMG"] = {SPELL_SCHOOL2_CAP.." "..DAMAGE, SPELL_SCHOOL2_CAP.." Dmg"},
	["NATURE_SPELL_DMG"] = {SPELL_SCHOOL3_CAP.." "..DAMAGE, SPELL_SCHOOL3_CAP.." Dmg"},
	["FROST_SPELL_DMG"] = {SPELL_SCHOOL4_CAP.." "..DAMAGE, SPELL_SCHOOL4_CAP.." Dmg"},
	["SHADOW_SPELL_DMG"] = {SPELL_SCHOOL5_CAP.." "..DAMAGE, SPELL_SCHOOL5_CAP.." Dmg"},
	["ARCANE_SPELL_DMG"] = {SPELL_SCHOOL6_CAP.." "..DAMAGE, SPELL_SCHOOL6_CAP.." Dmg"},

	["SPELLPEN"] = {PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION, SPELL_PENETRATION},

	["HEALTH"] = {HEALTH, HP},
	["MANA"] = {MANA, MP},
	["HEALTH_REG"] = {HEALTH.." 재생", "HP5"},
	["MANA_REG"] = {MANA.." 재생", "MP5"},

	["MAX_DAMAGE"] = {"최대 공격력", "Max Dmg"},
	["DPS"] = {"초당 공격력", "DPS"},

	["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
	["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
	["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
	["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
	["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
	["RANGED_HIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
	["SPELL_HIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
	["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
	["RANGED_CRIT_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
	["SPELL_CRIT_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9, PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
	["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
	["MELEE_HASTE_RATING"] = {"가속도 "..RATING, "Haste "..RATING}, --
	["RANGED_HASTE_RATING"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도 "..RATING, PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
	["SPELL_HASTE_RATING"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도 "..RATING, PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
	["DAGGER_WEAPON_RATING"] = {"단검류 "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
	["SWORD_WEAPON_RATING"] = {"도검류 "..SKILL.." "..RATING, "Sword "..RATING},
	["2H_SWORD_WEAPON_RATING"] = {"양손 도검류 "..SKILL.." "..RATING, "2H Sword "..RATING},
	["AXE_WEAPON_RATING"] = {"도끼류 "..SKILL.." "..RATING, "Axe "..RATING},
	["2H_AXE_WEAPON_RATING"] = {"양손 도끼류 "..SKILL.." "..RATING, "2H Axe "..RATING},
	["MACE_WEAPON_RATING"] = {"둔기류 "..SKILL.." "..RATING, "Mace "..RATING},
	["2H_MACE_WEAPON_RATING"] = {"양손 둔기류 "..SKILL.." "..RATING, "2H Mace "..RATING},
	["GUN_WEAPON_RATING"] = {"총기류 "..SKILL.." "..RATING, "Gun "..RATING},
	["CROSSBOW_WEAPON_RATING"] = {"석궁류 "..SKILL.." "..RATING, "Crossbow "..RATING},
	["BOW_WEAPON_RATING"] = {"활류 "..SKILL.." "..RATING, "Bow "..RATING},
	["FERAL_WEAPON_RATING"] = {"야생 "..SKILL.." "..RATING, "Feral "..RATING},
	["FIST_WEAPON_RATING"] = {"장착 무기류 "..SKILL.." "..RATING, "Unarmed "..RATING},
	["STAFF_WEAPON_RATING"] = {"지팡이류 "..SKILL.." "..RATING, "Staff "..RATING}, -- Leggings of the Fang ID:10410
	["EXPERTISE_RATING"] = {"숙련 ".." "..RATING, "Expertise".." "..RATING},
	["ARMOR_PENETRATION_RATING"] = {"방어구 관통력", "방어구 관통력"},

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {HEALTH.." 재생 (비전투)", "HP5(OC)"},
	["MANA_REG_NOT_CASTING"] = {MANA.." 재생 (미시전)", "MP5(NC)"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"치명타 피해 감소(%)", "Crit Dmg Reduc(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 피해 감소(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
	["DEFENSE"] = {DEFENSE, "Def"},
	["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
	["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
	["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
	["AVOIDANCE"] = {"공격 회피(%)", "Avoidance(%)"},
	["MELEE_HIT"] = {"적중률(%)", "Hit(%)"},
	["RANGED_HIT"] = {PLAYERSTAT_RANGED_COMBAT.." 적중률(%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
	["SPELL_HIT"] = {PLAYERSTAT_SPELL_COMBAT.." 적중률(%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
	["MELEE_HIT_AVOID"] = {"근접 공격 회피(%)", "Hit Avd(%)"},
	["MELEE_CRIT"] = {MELEE_CRIT_CHANCE.."(%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
	["RANGED_CRIT"] = {PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
	["SPELL_CRIT"] = {PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
	["MELEE_CRIT_AVOID"] = {"근접 치명타 공격 회피(%)", "Crit Avd(%)"},
	["MELEE_HASTE"] = {"가속도(%)", "Haste(%)"}, --
	["RANGED_HASTE"] = {PLAYERSTAT_RANGED_COMBAT.." 가속도(%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
	["SPELL_HASTE"] = {PLAYERSTAT_SPELL_COMBAT.." 가속도(%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
	["DAGGER_WEAPON"] = {"단검류 "..SKILL, "Dagger"}, -- SKILL = "Skill"
	["SWORD_WEAPON"] = {"도검류 "..SKILL, "Sword"},
	["2H_SWORD_WEAPON"] = {"양손 도검류 "..SKILL, "2H Sword"},
	["AXE_WEAPON"] = {"도끼류 "..SKILL, "Axe"},
	["2H_AXE_WEAPON"] = {"양손 도끼류 "..SKILL, "2H Axe"},
	["MACE_WEAPON"] = {"둔기류 "..SKILL, "Mace"},
	["2H_MACE_WEAPON"] = {"양손 둔기류 "..SKILL, "2H Mace"},
	["GUN_WEAPON"] = {"총기류 "..SKILL, "Gun"},
	["CROSSBOW_WEAPON"] = {"석궁류 "..SKILL, "Crossbow"},
	["BOW_WEAPON"] = {"활류 "..SKILL, "Bow"},
	["FERAL_WEAPON"] = {"야생 "..SKILL, "Feral"},
	["FIST_WEAPON"] = {"장착 무기류 "..SKILL, "Unarmed"},
	["STAFF_WEAPON"] = {"지팡이류 "..SKILL, "Staff"}, -- Leggings of the Fang ID:10410
	["EXPERTISE"] = {"숙련 ", "Expertise"},
	["ARMOR_PENETRATION"] = {"방어구 관통(%)", "방어구 관통(%)"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	-- Expertise -> Dodge Neglect, Parry Neglect
	["DODGE_NEGLECT"] = {DODGE.." 무시(%)", DODGE.." Neglect(%)"},
	["PARRY_NEGLECT"] = {PARRY.." 무시(%)", PARRY.." Neglect(%)"},
	["BLOCK_NEGLECT"] = {BLOCK.." 무시(%)", BLOCK.." Neglect(%)"},

	---------------------------------------------------------------------------
	-- Talants
	["MELEE_CRIT_DMG"] = {"치명타 공격력(%)", "Crit Dmg(%)"},
	["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." 치명타 공격력(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
	["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." 치명타 공격력(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

	---------------------------------------------------------------------------
	-- Spell Stats
	-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
	-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
	-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
	-- Use strsplit("@", text) to seperate the spell name and statid
	["THREAT"] = {"위협", "Threat"},
	["CAST_TIME"] = {"시전 시간", "Cast Time"},
	["MANA_COST"] = {"마나 소모량", "Mana Cost"},
	["RAGE_COST"] = {"분노 소모량", "Rage Cost"},
	["ENERGY_COST"] = {"기력 소모량", "Energy Cost"},
	["COOLDOWN"] = {"재사용 대기 시간", "CD"},

	---------------------------------------------------------------------------
	-- Stats Mods
	["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
	["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
	["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
	["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
	["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
	["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
	["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
	["MOD_ARMOR"] = {"Mod 아이템에 의한 "..ARMOR.."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
	["MOD_BLOCK_VALUE"] = {"Mod 피해 방어량".."(%)", "Mod Block Value".."(%)"},
	["MOD_DMG"] = {"Mod 피해".."(%)", "Mod Dmg".."(%)"},
	["MOD_DMG_TAKEN"] = {"Mod 피해량".."(%)", "Mod Dmg Taken".."(%)"},
	["MOD_CRIT_DAMAGE"] = {"Mod 치명타 피해".."(%)", "Mod Crit Dmg".."(%)"},
	["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod 치명타 피해량".."(%)", "Mod Crit Dmg Taken".."(%)"},
	["MOD_THREAT"] = {"Mod 위협".."(%)", "Mod Threat".."(%)"},
	["MOD_AP"] = {"Mod ".."전투력".."(%)", "Mod AP".."(%)"},
	["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." ".."전투력".."(%)", "Mod RAP".."(%)"},
	["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
	["MOD_HEALING"] = {"Mod 치유량".."(%)", "Mod Heal".."(%)"},
	["MOD_CAST_TIME"] = {"Mod 시전 시간".."(%)", "Mod Cast Time".."(%)"},
	["MOD_MANA_COST"] = {"Mod 마나 소모량".."(%)", "Mod Mana Cost".."(%)"},
	["MOD_RAGE_COST"] = {"Mod 분노 소모량".."(%)", "Mod Rage Cost".."(%)"},
	["MOD_ENERGY_COST"] = {"Mod 기력 소모량".."(%)", "Mod Energy Cost".."(%)"},
	["MOD_COOLDOWN"] = {"Mod 재사용 대기 시간".."(%)", "Mod CD".."(%)"},

	---------------------------------------------------------------------------
	-- Misc Stats
	["WEAPON_RATING"] = {"무기 "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
	["WEAPON_SKILL"] = {"무기 "..SKILL, "Weapon"..SKILL},
	["MAINHAND_WEAPON_RATING"] = {"주 장비 "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
	["OFFHAND_WEAPON_RATING"] = {"보조 장비 "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
	["RANGED_WEAPON_RATING"] = {"원거리 무기 "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
}

