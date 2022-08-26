-- zhTW localization by CuteMiyu, Ryuji
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "zhTW")
if not L then return end

L["tonumber"] = tonumber
--["Dual Wield"] = "雙武器",
-------------------
-- Exclude Table --
-------------------
-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
L["ExcludeLen"] = 3 -- using string.utf8len
L["Exclude"] = {
	[""] = true,
	[" \n"] = true,
	[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
	[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
	[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
	[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
	[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
	--[EMPTY_SOCKET_BLUE] = true, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	--[EMPTY_SOCKET_META] = true, -- EMPTY_SOCKET_META = "Meta Socket";
	--[EMPTY_SOCKET_RED] = true, -- EMPTY_SOCKET_RED = "Red Socket";
	--[EMPTY_SOCKET_YELLOW] = true, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever

	--["Disen"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
	--["Durat"] = true, -- ITEM_DURATION_DAYS = "Duration: %d days";
	--["<Made"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"; -- %s is the creator of the item
	--["Coold"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Cooldown remaining: %d day";
	["裝備單一限定"] = true, -- Unique-Equipped
	[ITEM_UNIQUE] = true, -- ITEM_UNIQUE = "Unique";
	["唯一("] = true, -- ITEM_UNIQUE_MULTIPLE = "Unique (%d)";
	["需要等"] = true, -- Requires Level xx
	["\n需要"] = true, -- Requires Level xx
	["需要 "] = true, -- Requires Level xx
	["需要騎"] = true, -- Requires Level xx
	["職業:"] = true, -- Classes: xx
	["種族:"] = true, -- Races: xx (vendor mounts)
	["使用:"] = true, -- Use:
	["擊中時"] = true, -- Chance On Hit:
	["需要鑄"] = true,
	["需要影"] = true,
	["需要月"] = true,
	["需要魔"] = true,
	-- Set Bonuses
	-- ITEM_SET_BONUS = "Set: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["套裝:"] = true,
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
--[[
textTable = {
"+6法術傷害及+5法術命中等級",
"+3  耐力, +4 致命一擊等級",
"++26 治療法術 & 降低2% 威脅值",
"+3 耐力/+4 致命一擊等級",
"插槽加成:每5秒+2法力",
"裝備： 使所有法術和魔法效果所造成的傷害和治療效果提高最多150點。",
"裝備： 使半徑30碼範圍內所有小隊成員的法術致命一擊等級提高28點。",
"裝備： 使30碼範圍內的所有隊友提高所有法術和魔法效果所造成的傷害和治療效果，最多33點。",
"裝備： 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果提高最多62點。",
"裝備： 使你的法術傷害提高最多120點，以及你的治療效果最多300點。",
"裝備： 使周圍半徑30碼範圍內的隊友每5秒恢復11點法力。",
"裝備： 使法術所造成的治療效果提高最多300點。",
"裝備： 在獵豹、熊、巨熊和梟獸形態下的攻擊強度提高420點。",
-- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
-- "+26 Attack Power and +14 Critical Strike Rating": Swift Windfire Diamond ID:28556
"+26治療和+9法術傷害及降低2%威脅值", --: Bracing Earthstorm Diamond ID:25897
-- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
----
-- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
-- "Healing +11 and 2 mana per 5 sec.": Royal Tanzanite ID: 30603
}
--]]
-----------------------
-- Whole Text Lookup --
-----------------------
-- Mainly used for enchants that doesn't have numbers in the text
L["WholeTextLookup"] = {
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["初級巫師之油"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, --
	["次級巫師之油"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, --
	["巫師之油"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, --
	["卓越巫師之油"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, --
	["超強巫師之油"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, --
	["受祝福的巫師之油"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["初級法力之油"] = {["MANA_REG"] = 4}, --
	["次級法力之油"] = {["MANA_REG"] = 8}, --
	["卓越法力之油"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, --
	["超強法力之油"] = {["MANA_REG"] = 14}, --

	["恆金漁線釣魚"] = {["FISHING"] = 5}, --
	["兇蠻"] = {["AP"] = 70}, --
	["活力"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, --
	["靈魂冰霜"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["烈日火焰"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50}, --

	["秘銀馬刺"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["坐騎移動速度略微提升"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["裝備：略微提高移動速度。"] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["略微提高移動速度"] = {["RUN_SPEED"] = 8}, --
	["略微提高奔跑速度"] = {["RUN_SPEED"] = 8}, --
	["移動速度略微提升"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
	["初級速度"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed
	["穩固"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954 

	["狡詐"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["威脅值降低2%"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
	["裝備: 使你可以在水下呼吸。"] = false, -- [Band of Icy Depths] ID: 21526
	["使你可以在水下呼吸"] = false, --
	["裝備: 免疫繳械。"] = false, -- [Stronghold Gauntlets] ID: 12639
	["免疫繳械"] = false, --
	["十字軍"] = false, -- Enchant Crusader
	["生命偷取"] = false, -- Enchant Crusader
}
----------------------------
-- Single Plus Stat Check --
----------------------------
-- depending on locale, it may be
-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
-- +19 耐力 = "^%+(%d+) (.-)$"
--["SinglePlusStatCheck"] = "^%+(%d+) ([%a ]+%a)$",
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- stat1, value, stat2 = strfind
-- stat = stat1..stat2
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
--裝備: 提高法術命中等級28點
--裝備: 使所有法術和魔法效果所造成的傷害和治療效果提高最多50點。
--"裝備： (.-)提高(最多)?(%d+)(點)?(.-)。$",
-- 用\230?\156?\128?\229?\164?\154?(%d+)\233?\187?\158?並不安全
L["SingleEquipStatCheck"] = "裝備: (.-)(%d+)點(.-)。$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+)格擋$"] = "BLOCK_VALUE",
	["^(%d+)點護甲$"] = "ARMOR",
	["強化護甲 %+(%d+)"] = "ARMOR_BONUS",
	["^%+?%d+ %- (%d+).-傷害$"] = "MAX_DAMAGE",
	["^%(每秒傷害([%d%.]+)%)$"] = "DPS",
	-- Exclude
	["^(%d+)格.-包"] = false, -- # of slots and bag type
	["^(%d+)格.-袋"] = false, -- # of slots and bag type
	["^(%d+)格容器"] = false, -- # of slots and bag type
	["^.+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	["機率"] = false, --[挑戰印記] ID:27924
	["有機會"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128
	["有可能"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["命中時"] = false, -- [黑色摧毀者手套] ID:22194
	["被擊中之後"] = false, -- [Essence of the Pure Flame] ID: 18815
	["在你殺死一個敵人"] = false, -- [注入精華的蘑菇] ID:28109
	["每當你的"] = false, -- [電光相容器] ID: 28785
	["被擊中時"] = false, -- 
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "裝備: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "插槽加成:" -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "。"
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"。", -- "裝備： 對不死生物的攻擊強度提高$s1點。同時也可為銀色黎明收集天譴石。": 黎明聖印
}
L["DeepScanWordSeparators"] = {
	"及", "和", "並", "，" -- [發光的暗影卓奈石] ID:25894 "+24攻擊強度及略微提高奔跑速度", [刺客的火焰蛋白石] ID:30565 "+6致命一擊等級及+5閃躲等級"
}
-- all lower case
L["DualStatPatterns"] = {
	["^%+(%d+)治療和%+(%d+)法術傷害$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^%+(%d+)治療和%+(%d+)法術傷害及"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^使法術和魔法效果所造成的治療效果提高最多(%d+)點，法術傷害提高最多(%d+)點$"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-)提高最多([%d%.]+)點(.-)$", -- 
	"^(.-)提高最多([%d%.]+)(.-)$", -- 
	"^(.-)，最多([%d%.]+)點(.-)$", -- 
	"^(.-)，最多([%d%.]+)(.-)$", -- 
	"^(.-)最多([%d%.]+)點(.-)$", -- 
	"^(.-)最多([%d%.]+)(.-)$", -- 
	"^(.-)提高([%d%.]+)點(.-)$", -- 
	"^(.-)提高([%d%.]+)(.-)$", -- 
	"^(.-)([%d%.]+)點(.-)$", -- 
	"^(.-) ?([%+%-][%d%.]+) ?點(.-)$", -- 
	"^(.-) ?([%+%-][%d%.]+) ?(.-)$", -- 
	"^(.-) ?([%d%.]+) ?點(.-)$", -- 
	"^(.-) ?([%d%.]+) ?(.-)$", -- 
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	--["%昏迷抗性"] = {},
	["你的攻擊無視目標點護甲值"] = {"IGNORE_ARMOR"},
	["使你的有效潛行等級提高"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["潛行"] = {"STEALTH_LEVEL"}, -- Cloak Enchant
	["武器傷害"] = {"MELEE_DMG"}, -- Enchant
	["使坐騎速度提高%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["所有屬性"] = {"STR", "AGI", "STA", "INT", "SPI",},
	["力量"] = {"STR",},
	["敏捷"] = {"AGI",},
	["耐力"] = {"STA",},
	["智力"] = {"INT",},
	["精神"] = {"SPI",},

	["秘法抗性"] = {"ARCANE_RES",},
	["火焰抗性"] = {"FIRE_RES",},
	["自然抗性"] = {"NATURE_RES",},
	["冰霜抗性"] = {"FROST_RES",},
	["暗影抗性"] = {"SHADOW_RES",},
	["陰影抗性"] = {"SHADOW_RES",}, -- Demons Blood ID: 10779
	["所有抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["全部抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["抵抗全部"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["點所有魔法抗性"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",}, -- [鋸齒黑曜石之盾] ID:22198

	["釣魚"] = {"FISHING",}, -- Fishing enchant ID:846
	["釣魚技能"] = {"FISHING",}, -- Fishing lure
	["使釣魚技能"] = {"FISHING",}, -- Equip: Increased Fishing +20.
	["採礦"] = {"MINING",}, -- Mining enchant ID:844
	["草藥學"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["剝皮"] = {"SKINNING",}, -- Skinning enchant ID:865

	["護甲"] = {"ARMOR_BONUS",},
	["護甲值"] = {"ARMOR_BONUS",},
	["強化護甲"] = {"ARMOR_BONUS",},
	["防禦"] = {"DEFENSE",},
	["增加防禦"] = {"DEFENSE",},
	["格擋"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["格擋值"] = {"BLOCK_VALUE",}, -- +22 Block Value
	["提高格擋值"] = {"BLOCK_VALUE",},
	["使你盾牌的格擋值"] = {"BLOCK_VALUE",},

	["生命力"] = {"HEALTH",},
	["法力"] = {"MANA",},

	["攻擊強度"] = {"AP",},
	["使攻擊強度"] = {"AP",},
	["提高攻擊強度"] = {"AP",},
	["對不死生物的攻擊強度"] = {"AP_UNDEAD",}, -- [黎明聖印] ID:13209 -- [弒妖裹腕] ID:23093
	["對不死生物和惡魔的攻擊強度"] = {"AP_UNDEAD", "AP_DEMON",}, -- [勇士徽章] ID:23206
	["對惡魔的攻擊強度"] = {"AP_DEMON",},
	["在獵豹、熊、巨熊和梟獸形態下的攻擊強度"] = {"FERAL_AP",}, -- Atiesh ID:22632
	["在獵豹、熊、巨熊還有梟獸形態下的攻擊強度"] = {"FERAL_AP",}, -- 
	["遠程攻擊強度"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["每5秒恢復生命力"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["一般的生命力恢復速度"] = {"HEALTH_REG",}, -- [Demons Blood] ID: 10779

	["每5秒法力"] = {"MANA_REG",}, --
	["每5秒恢復法力"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["每五秒恢復法力"] = {"MANA_REG",}, -- 長者之XXX
	["法力恢復"] = {"MANA_REG",}, --
	["使周圍半徑30碼範圍內的隊友每5秒恢復法力"] = {"MANA_REG",}, --

	["法術穿透"] = {"SPELLPEN",},
	["法術穿透力"] = {"SPELLPEN",},
	["使你的法術穿透力"] = {"SPELLPEN",},

	["法術傷害和治療"] = {"SPELL_DMG", "HEAL",},
	["治療和法術傷害"] = {"SPELL_DMG", "HEAL",},
	["法術傷害"] = {"SPELL_DMG", "HEAL",},
	["使法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"},
	["使所有法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"},
	["使所有法術和魔法效果所造成的傷害和治療效果提高最多"] = {"SPELL_DMG", "HEAL"},
	["使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的傷害和治療效果"] = {"SPELL_DMG", "HEAL"}, -- Atiesh, ID: 22630
	--StatLogic:GetSum("22630")
	--SetTip("22630")
	-- Atiesh ID:22630, 22631, 22632, 22589
	--裝備: 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的傷害和治療效果提高最多33點。 -- 22630 -- 2.1.0
	--裝備: 使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果提高最多62點。 -- 22631
	--裝備: 使半徑30碼範圍內所有小隊成員的法術致命一擊等級提高28點。 -- 22589
	--裝備: 使周圍半徑30碼範圍內的隊友每5秒恢復11點法力。
	["使你的法術傷害"] = {"SPELL_DMG",}, -- Atiesh ID:22631
	["傷害"] = {"SPELL_DMG",},
	["法術能量"] = {"SPELL_DMG", "HEAL" },
	["神聖傷害"] = {"HOLY_SPELL_DMG",},
	["秘法傷害"] = {"ARCANE_SPELL_DMG",},
	["火焰傷害"] = {"FIRE_SPELL_DMG",},
	["自然傷害"] = {"NATURE_SPELL_DMG",},
	["冰霜傷害"] = {"FROST_SPELL_DMG",},
	["暗影傷害"] = {"SHADOW_SPELL_DMG",},
	["神聖法術傷害"] = {"HOLY_SPELL_DMG",},
	["秘法法術傷害"] = {"ARCANE_SPELL_DMG",},
	["火焰法術傷害"] = {"FIRE_SPELL_DMG",},
	["自然法術傷害"] = {"NATURE_SPELL_DMG",},
	["冰霜法術傷害"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["暗影法術傷害"] = {"SHADOW_SPELL_DMG",},
	["使秘法法術和效果所造成的傷害"] = {"ARCANE_SPELL_DMG",},
	["使火焰法術和效果所造成的傷害"] = {"FIRE_SPELL_DMG",},
	["使冰霜法術和效果所造成的傷害"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["使神聖法術和效果所造成的傷害"] = {"HOLY_SPELL_DMG",},
	["使自然法術和效果所造成的傷害"] = {"NATURE_SPELL_DMG",},
	["使暗影法術和效果所造成的傷害"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871

	-- [Robe of Undead Cleansing] ID:23085
	["使魔法和法術效果對不死生物造成的傷害"] = {"SPELL_DMG_UNDEAD",}, -- [黎明符文] ID:19812
	["提高所有法術和效果對不死生物所造成的傷害"] = {"SPELL_DMG_UNDEAD",}, -- [淨妖長袍] ID:23085
	["提高法術和魔法效果對不死生物和惡魔所造成的傷害"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON",}, -- [勇士徽章] ID:23207

	["你的治療效果"] = {"HEAL",}, -- Atiesh ID:22631
	["治療法術"] = {"HEAL",}, -- +35 Healing Glove Enchant
	["治療效果"] = {"HEAL",}, -- [聖使祝福手套] Socket Bonus
	["治療"] = {"HEAL",},
	["神聖效果"] = {"HEAL",},-- Enchant Ring - Healing Power
	["使法術所造成的治療效果"] = {"HEAL",},
	["使法術和魔法效果所造成的治療效果"] = {"HEAL",},
	["使周圍半徑30碼範圍內隊友的所有法術和魔法效果所造成的治療效果"] = {"HEAL",}, -- Atiesh, ID: 22631

	["每秒傷害"] = {"DPS",},
	["每秒傷害提高"] = {"DPS",}, -- [Thorium Shells] ID: 15997

	["防禦等級"] = {"DEFENSE_RATING",},
	["提高防禦等級"] = {"DEFENSE_RATING",},
	["提高你的防禦等級"] = {"DEFENSE_RATING",},
	["使防禦等級"] = {"DEFENSE_RATING",},
	["使你的防禦等級"] = {"DEFENSE_RATING",},
	["閃躲等級"] = {"DODGE_RATING",},
	["提高閃躲等級"] = {"DODGE_RATING",},
	["提高你的閃躲等級"] = {"DODGE_RATING",},
	["使閃躲等級"] = {"DODGE_RATING",},
	["使你的閃躲等級"] = {"DODGE_RATING",},
	["招架等級"] = {"PARRY_RATING",},
	["提高招架等級"] = {"PARRY_RATING",},
	["提高你的招架等級"] = {"PARRY_RATING",},
	["使招架等級"] = {"PARRY_RATING",},
	["使你的招架等級"] = {"PARRY_RATING",},
	["格擋機率等級"] = {"BLOCK_RATING",},
	["提高格擋機率等級"] = {"BLOCK_RATING",},
	["提高你的格擋機率等級"] = {"BLOCK_RATING",},
	["使格擋機率等級"] = {"BLOCK_RATING",},
	["使你的格擋機率等級"] = {"BLOCK_RATING",},
	["格擋等級"] = {"BLOCK_RATING",},
	["提高格擋等級"] = {"BLOCK_RATING",},
	["提高你的格擋等級"] = {"BLOCK_RATING",},
	["使格擋等級"] = {"BLOCK_RATING",},
	["使你的格擋等級"] = {"BLOCK_RATING",},
	["盾牌格擋等級"] = {"BLOCK_RATING",},
	["提高盾牌格擋等級"] = {"BLOCK_RATING",},
	["提高你的盾牌格擋等級"] = {"BLOCK_RATING",},
	["使盾牌格擋等級"] = {"BLOCK_RATING",},
	["使你的盾牌格擋等級"] = {"BLOCK_RATING",},

	["命中等級"] = {"HIT_RATING",},
	["提高命中等級"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_RATING
	["提高近戰命中等級"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
	["使你的命中等級"] = {"HIT_RATING",},
	["法術命中等級"] = {"SPELL_HIT_RATING",},
	["提高法術命中等級"] = {"SPELL_HIT_RATING",}, -- ITEM_MOD_HIT_SPELL_RATING
	["使你的法術命中等級"] = {"SPELL_HIT_RATING",},
	["遠程命中等級"] = {"RANGED_HIT_RATING",},
	["提高遠距命中等級"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
	["使你的遠程命中等級"] = {"RANGED_HIT_RATING",},

	["致命一擊"] = {"CRIT_RATING",}, -- ID:31868
	["致命一擊等級"] = {"CRIT_RATING",},
	["提高致命一擊等級"] = {"CRIT_RATING",},
	["使你的致命一擊等級"] = {"CRIT_RATING",},
	["近戰致命一擊等級"] = {"MELEE_CRIT_RATING",},
	["提高近戰致命一擊等級"] = {"MELEE_CRIT_RATING",}, -- [屠殺者腰帶] ID:21639
	["使你的近戰致命一擊等級"] = {"MELEE_CRIT_RATING",},
	["法術致命一擊等級"] = {"SPELL_CRIT_RATING",},
	["提高法術致命一擊等級"] = {"SPELL_CRIT_RATING",}, -- [伊利達瑞的復仇] ID:28040
	["使你的法術致命一擊等級"] = {"SPELL_CRIT_RATING",},
	["使半徑30碼範圍內所有小隊成員的法術致命一擊等級"] = {"SPELL_CRIT_RATING",}, -- Atiesh, ID: 22589
	["遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},
	["提高遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},
	["使你的遠程致命一擊等級"] = {"RANGED_CRIT_RATING",},

	["韌性"] = {"RESILIENCE_RATING",},
	["韌性等級"] = {"RESILIENCE_RATING",},
	["使你的韌性等級"] = {"RESILIENCE_RATING",},

	["加速等級"] = {"HASTE_RATING"}, -- Enchant Gloves
	["攻擊速度"] = {"HASTE_RATING"},
	["攻擊速度等級"] = {"HASTE_RATING"},
	["提高加速等級"] = {"HASTE_RATING"},
	["提高近戰加速等級"] = {"MELEE_HASTE_RATING"},
	["法術加速等級"] = {"SPELL_HASTE_RATING"},
	["提高法術加速等級"] = {"SPELL_HASTE_RATING"},
	["遠程攻擊加速等級"] = {"RANGED_HASTE_RATING"},
	["提高遠程攻擊加速等級"] = {"RANGED_HASTE_RATING"},

	["使匕首技能等級"] = {"DAGGER_WEAPON_RATING"},
	["匕首武器技能等級"] = {"DAGGER_WEAPON_RATING"},
	["使劍類技能等級"] = {"SWORD_WEAPON_RATING"},
	["劍類武器技能等級"] = {"SWORD_WEAPON_RATING"},
	["使單手劍技能等級"] = {"SWORD_WEAPON_RATING"},
	["單手劍武器技能等級"] = {"SWORD_WEAPON_RATING"},
	["使雙手劍技能等級"] = {"2H_SWORD_WEAPON_RATING"},
	["雙手劍武器技能等級"] = {"2H_SWORD_WEAPON_RATING"},
	["使斧類技能等級"] = {"AXE_WEAPON_RATING"},
	["斧類武器技能等級"] = {"AXE_WEAPON_RATING"},
	["使單手斧技能等級"] = {"AXE_WEAPON_RATING"},
	["單手斧武器技能等級"] = {"AXE_WEAPON_RATING"},
	["使雙手斧技能等級"] = {"2H_AXE_WEAPON_RATING"},
	["雙手斧武器技能等級"] = {"2H_AXE_WEAPON_RATING"},
	["使錘類技能等級"] = {"MACE_WEAPON_RATING"},
	["錘類武器技能等級"] = {"MACE_WEAPON_RATING"},
	["使單手錘技能等級"] = {"MACE_WEAPON_RATING"},
	["單手錘武器技能等級"] = {"MACE_WEAPON_RATING"},
	["使雙手錘技能等級"] = {"2H_MACE_WEAPON_RATING"},
	["雙手錘武器技能等級"] = {"2H_MACE_WEAPON_RATING"},
	["使槍械技能等級"] = {"GUN_WEAPON_RATING"},
	["槍械武器技能等級"] = {"GUN_WEAPON_RATING"},
	["使弩技能等級"] = {"CROSSBOW_WEAPON_RATING"},
	["弩武器技能等級"] = {"CROSSBOW_WEAPON_RATING"},
	["使弓箭技能等級"] = {"BOW_WEAPON_RATING"},
	["弓箭武器技能等級"] = {"BOW_WEAPON_RATING"},
	["使野性戰鬥技巧等級"] = {"FERAL_WEAPON_RATING"},
	["野性戰鬥技巧等級"] = {"FERAL_WEAPON_RATING"},
	["使拳套技能等級"] = {"FIST_WEAPON_RATING"},
	["拳套武器技能等級"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533

	["使你的熟練等級提高"] = {"EXPERTISE_RATING"},
	["精准等级"] = {"EXPERTISE_RATING",},
	["提高精准等级"] = {"EXPERTISE_RATING",},
	["精准等级提高"] = {"EXPERTISE_RATING",},
	["护甲穿透等级"] = {"ARMOR_PENETRATION_RATING"},
	["护甲穿透等级提高"] = {"ARMOR_PENETRATION_RATING"},

	-- Exclude
	["秒"] = false,
	--["to"] = false,
	["格容器"] = false,
	["格箭袋"] = false,
	["格彈藥袋"] = false,
	["遠程攻擊速度%"] = false, -- AV quiver
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "zhTW")
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

	["IGNORE_ARMOR"] = {"無視護甲", "無視護甲"},
	["THREAT_MOD"] = {"威脅(%)", "威脅(%)"},
	["STEALTH_LEVEL"] = {"偷竊等級", "偷竊"},
	["MELEE_DMG"] = {"近戰傷害", "近戰"}, -- DAMAGE = "Damage"
	["MOUNT_SPEED"] = {"騎乘速度(%)", "騎速(%)"},
	["RUN_SPEED"] = {"奔跑速度(%)", "跑速(%)"},

	["STR"] = {SPELL_STAT1_NAME, "力量"},
	["AGI"] = {SPELL_STAT2_NAME, "敏捷"},
	["STA"] = {SPELL_STAT3_NAME, "耐力"},
	["INT"] = {SPELL_STAT4_NAME, "智力"},
	["SPI"] = {SPELL_STAT5_NAME, "精神"},
	["ARMOR"] = {ARMOR, ARMOR},
	["ARMOR_BONUS"] = {"裝甲加成", "裝甲加成"},

	["FIRE_RES"] = {RESISTANCE2_NAME, "火抗"},
	["NATURE_RES"] = {RESISTANCE3_NAME, "自抗"},
	["FROST_RES"] = {RESISTANCE4_NAME, "冰抗"},
	["SHADOW_RES"] = {RESISTANCE5_NAME, "暗抗"},
	["ARCANE_RES"] = {RESISTANCE6_NAME, "秘抗"},

	["FISHING"] = {"釣魚", "釣魚"},
	["MINING"] = {"採礦", "採礦"},
	["HERBALISM"] = {"草藥", "草藥"},
	["SKINNING"] = {"剝皮", "剝皮"},

	["BLOCK_VALUE"] = {"格擋值", "格擋值"},

	["AP"] = {ATTACK_POWER_TOOLTIP, "攻擊強度"},
	["RANGED_AP"] = {RANGED_ATTACK_POWER, "遠攻強度"},
	["FERAL_AP"] = {"野性攻擊強度", "野性強度"},
	["AP_UNDEAD"] = {"攻擊強度(不死)", "攻擊強度(不死)"},
	["AP_DEMON"] = {"攻擊強度(惡魔)", "攻擊強度(惡魔)"},

	["HEAL"] = {"法術治療", "治療"},

	["SPELL_DMG"] = {"法術傷害", "法傷"},
	["SPELL_DMG_UNDEAD"] = {"法術傷害(不死)", "法傷(不死)"},
	["SPELL_DMG_DEMON"] = {"法術傷害(惡魔)", "法傷(惡魔)"},
	["HOLY_SPELL_DMG"] = {"神聖法術傷害", "神聖法傷"},
	["FIRE_SPELL_DMG"] = {"火焰法術傷害", "火焰法傷"},
	["NATURE_SPELL_DMG"] = {"自然法術傷害", "自然法傷"},
	["FROST_SPELL_DMG"] = {"冰霜法術傷害", "冰霜法傷"},
	["SHADOW_SPELL_DMG"] = {"暗影法術傷害", "暗影法傷"},
	["ARCANE_SPELL_DMG"] = {"秘法法術傷害", "秘法法傷"},

	["SPELLPEN"] = {"法術穿透", SPELL_PENETRATION},

	["HEALTH"] = {HEALTH, HP},
	["MANA"] = {MANA, MP},
	["HEALTH_REG"] = {"生命恢復", "HP5"},
	["MANA_REG"] = {"法力恢復", "MP5"},

	["MAX_DAMAGE"] = {"最大傷害", "大傷"},
	["DPS"] = {"每秒傷害", "DPS"},

	["DEFENSE_RATING"] = {COMBAT_RATING_NAME2, COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
	["DODGE_RATING"] = {COMBAT_RATING_NAME3, COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
	["PARRY_RATING"] = {COMBAT_RATING_NAME4, COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
	["BLOCK_RATING"] = {COMBAT_RATING_NAME5, COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
	["MELEE_HIT_RATING"] = {COMBAT_RATING_NAME6, COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
	["RANGED_HIT_RATING"] = {"遠程命中等級", "遠程命中等級"}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
	["SPELL_HIT_RATING"] = {"法術命中等級", "法術命中等級"}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
	["MELEE_CRIT_RATING"] = {COMBAT_RATING_NAME9, COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
	["RANGED_CRIT_RATING"] = {"遠程致命等級", "遠程致命等級"},
	["SPELL_CRIT_RATING"] = {"法術致命等級", "法術致命等級"},
	["RESILIENCE_RATING"] = {COMBAT_RATING_NAME15, COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
	["MELEE_HASTE_RATING"] = {"攻擊加速等級", "攻擊加速等級"}, --
	["RANGED_HASTE_RATING"] = {"遠程加速等級", "遠程加速等級"},
	["SPELL_HASTE_RATING"] = {"法術加速等級", "法術加速等級"},
	["DAGGER_WEAPON_RATING"] = {"匕首技能等級", "匕首等級"}, -- SKILL = "Skill"
	["SWORD_WEAPON_RATING"] = {"劍技能等級", "劍等級"},
	["2H_SWORD_WEAPON_RATING"] = {"雙手劍技能等級", "雙手劍等級"},
	["AXE_WEAPON_RATING"] = {"斧技能等級", "斧等級"},
	["2H_AXE_WEAPON_RATING"] = {"雙手斧技能等級", "雙手斧等級"},
	["MACE_WEAPON_RATING"] = {"鎚技能等級", "鎚等級"},
	["2H_MACE_WEAPON_RATING"] = {"雙手鎚技能等級", "雙手鎚等級"},
	["GUN_WEAPON_RATING"] = {"槍械技能等級", "槍械等級"},
	["CROSSBOW_WEAPON_RATING"] = {"弩技能等級", "弩等級"},
	["BOW_WEAPON_RATING"] = {"弓技能等級", "弓等級"},
	["FERAL_WEAPON_RATING"] = {"野性技能等級", "野性等級"},
	["FIST_WEAPON_RATING"] = {"徒手技能等級", "徒手等級"},
	["STAFF_WEAPON_RATING"] = {"法杖技能等級", "法杖等級"}, -- Leggings of the Fang ID:10410
	["EXPERTISE_RATING"] = {"熟練等級", "熟練等級"},
	["ARMOR_PENETRATION_RATING"] = {"護甲穿透等級", "護甲穿透等級"},

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {"一般回血", "一般回血"},
	["MANA_REG_NOT_CASTING"] = {"一般回魔", "一般回魔"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"致命減傷(%)", "致命減傷(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {"遠程致命減傷(%)", "遠程致命減傷(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {"法術致命減傷(%)", "法術致命減傷(%)"},
	["DEFENSE"] = {DEFENSE, DEFENSE},
	["DODGE"] = {DODGE.."(%)", DODGE.."(%)"},
	["PARRY"] = {PARRY.."(%)", PARRY.."(%)"},
	["BLOCK"] = {BLOCK.."(%)", BLOCK.."(%)"},
	["MELEE_HIT"] = {"命中(%)", "命中(%)"},
	["RANGED_HIT"] = {"遠程命中(%)", "遠程命中(%)"},
	["SPELL_HIT"] = {"法術命中(%)", "法術命中(%)"},
	["MELEE_HIT_AVOID"] = {"迴避命中(%)", "迴避命中(%)"},
	["MELEE_CRIT"] = {"致命(%)", "致命(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
	["RANGED_CRIT"] = {"遠程致命(%)", "遠程致命(%)"},
	["SPELL_CRIT"] = {"法術致命(%)", "法術致命(%)"},
	["MELEE_CRIT_AVOID"] = {"迴避致命(%)", "迴避致命(%)"},
	["MELEE_HASTE"] = {"攻擊加速(%)", "攻擊加速(%)"}, --
	["RANGED_HASTE"] = {"遠程加速(%)", "遠程加速(%)"},
	["SPELL_HASTE"] = {"法術加速(%)", "法術加速(%)"},
	["DAGGER_WEAPON"] = {"匕首技能", "匕首"}, -- SKILL = "Skill"
	["SWORD_WEAPON"] = {"劍技能", "劍"},
	["2H_SWORD_WEAPON"] = {"雙手劍技能", "雙手劍"},
	["AXE_WEAPON"] = {"斧技能", "斧"},
	["2H_AXE_WEAPON"] = {"雙手斧技能", "雙手斧"},
	["MACE_WEAPON"] = {"鎚技能", "鎚"},
	["2H_MACE_WEAPON"] = {"雙手鎚技能", "雙手鎚"},
	["GUN_WEAPON"] = {"槍械技能", "槍械"},
	["CROSSBOW_WEAPON"] = {"弩技能", "弩"},
	["BOW_WEAPON"] = {"弓技能", "弓"},
	["FERAL_WEAPON"] = {"野性技能", "野性"},
	["FIST_WEAPON"] = {"徒手技能", "徒手"},
	["STAFF_WEAPON"] = {"法杖技能", "法杖"}, -- Leggings of the Fang ID:10410
	["EXPERTISE"] = {"熟練", "熟練"},
	["ARMOR_PENETRATION"] = {"護甲穿透(%)", "護甲穿透(%)"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	-- Expertise -> Dodge Neglect, Parry Neglect
	["DODGE_NEGLECT"] = {"防止被閃躲(%)", "防止被閃躲(%)"},
	["PARRY_NEGLECT"] = {"防止被招架(%)", "防止被招架(%)"},
	["BLOCK_NEGLECT"] = {"防止被格擋(%)", "防止被格擋(%)"},

	---------------------------------------------------------------------------
	-- Talants
	["MELEE_CRIT_DMG"] = {"致命一擊(%)", "致命(%)"},
	["RANGED_CRIT_DMG"] = {"遠程致命一擊(%)", "遠程致命(%)"},
	["SPELL_CRIT_DMG"] = {"法術致命一擊(%)", "法術致命(%)"},

	---------------------------------------------------------------------------
	-- Spell Stats
	-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
	-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
	-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
	-- Use strsplit("@", text) to seperate the spell name and statid
	["THREAT"] = {"威脅", "威脅"},
	["CAST_TIME"] = {"施法時間", "施法時間"},
	["MANA_COST"] = {"法力成本", "法力成本"},
	["RAGE_COST"] = {"怒氣成本", "怒氣成本"},
	["ENERGY_COST"] = {"能量成本", "能量成本"},
	["COOLDOWN"] = {"技能冷卻", "技能冷卻"},

	---------------------------------------------------------------------------
	-- Stats Mods
	["MOD_STR"] = {"修正力量(%)", "修正力量(%)"},
	["MOD_AGI"] = {"修正敏捷(%)", "修正敏捷(%)"},
	["MOD_STA"] = {"修正耐力(%)", "修正耐力(%)"},
	["MOD_INT"] = {"修正智力(%)", "修正智力(%)"},
	["MOD_SPI"] = {"修正精神(%)", "修正精神(%)"},
	["MOD_HEALTH"] = {"修正生命(%)", "修正生命(%)"},
	["MOD_MANA"] = {"修正法力(%)", "修正法力(%)"},
	["MOD_ARMOR"] = {"修正裝甲(%)", "修正裝甲(%)"},
	["MOD_BLOCK_VALUE"] = {"修正格擋值(%)", "修正格擋值(%)"},
	["MOD_DMG"] = {"修正傷害(%)", "修正傷害(%)"},
	["MOD_DMG_TAKEN"] = {"修正受傷害(%)", "修正受傷害(%)"},
	["MOD_CRIT_DAMAGE"] = {"修正致命(%)", "修正致命(%)"},
	["MOD_CRIT_DAMAGE_TAKEN"] = {"修正受致命(%)", "修正受致命(%)"},
	["MOD_THREAT"] = {"修正威脅(%)", "修正威脅(%)"},
	["MOD_AP"] = {"修正攻擊強度(%)", "修正攻擊強度(%)"},
	["MOD_RANGED_AP"] = {"修正遠程攻擊強度(%)", "修正遠攻強度(%)"},
	["MOD_SPELL_DMG"] = {"修正法術傷害(%)", "修正法傷(%)"},
	["MOD_HEALING"] = {"修正法術治療(%)", "修正治療(%)"},
	["MOD_CAST_TIME"] = {"修正施法時間(%)", "修正施法時間(%)"},
	["MOD_MANA_COST"] = {"修正法力成本(%)", "修正法力成本(%)"},
	["MOD_RAGE_COST"] = {"修正怒氣成本(%)", "修正怒氣成本(%)"},
	["MOD_ENERGY_COST"] = {"修正能量成本(%)", "修正能量成本(%)"},
	["MOD_COOLDOWN"] = {"修正技能冷卻(%)", "修正技能冷卻(%)"},

	---------------------------------------------------------------------------
	-- Misc Stats
	["WEAPON_RATING"] = {"武器技能等級", "武器技能等級"},
	["WEAPON_SKILL"] = {"武器技能", "武器技能"},
	["MAINHAND_WEAPON_RATING"] = {"主手武器技能等級", "主手武器技能等級"},
	["OFFHAND_WEAPON_RATING"] = {"副手武器技能等級", "副手武器技能等級"},
	["RANGED_WEAPON_RATING"] = {"遠程武器技能等級", "遠程武器技能等級"},
}

