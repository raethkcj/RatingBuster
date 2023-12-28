-- zhTW localization by CuteMiyu, Ryuji
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "zhTW")
if not L then return end
local StatLogic = LibStub("StatLogic")

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
	["卓越巫師之油"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, --
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
	["穩固"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

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

	["所有屬性"] = {StatLogic.Stats.AllStats,},
	["力量"] = {StatLogic.Stats.Strength,},
	["敏捷"] = {StatLogic.Stats.Agility,},
	["耐力"] = {StatLogic.Stats.Stamina,},
	["智力"] = {StatLogic.Stats.Intellect,},
	["精神"] = {StatLogic.Stats.Spirit,},

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
	["防禦"] = {StatLogic.Stats.Defense,},
	["增加防禦"] = {StatLogic.Stats.Defense,},
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

	["防禦等級"] = {StatLogic.Stats.DefenseRating,},
	["提高防禦等級"] = {StatLogic.Stats.DefenseRating,},
	["提高你的防禦等級"] = {StatLogic.Stats.DefenseRating,},
	["使防禦等級"] = {StatLogic.Stats.DefenseRating,},
	["使你的防禦等級"] = {StatLogic.Stats.DefenseRating,},
	["閃躲等級"] = {StatLogic.Stats.DodgeRating,},
	["提高閃躲等級"] = {StatLogic.Stats.DodgeRating,},
	["提高你的閃躲等級"] = {StatLogic.Stats.DodgeRating,},
	["使閃躲等級"] = {StatLogic.Stats.DodgeRating,},
	["使你的閃躲等級"] = {StatLogic.Stats.DodgeRating,},
	["招架等級"] = {StatLogic.Stats.ParryRating,},
	["提高招架等級"] = {StatLogic.Stats.ParryRating,},
	["提高你的招架等級"] = {StatLogic.Stats.ParryRating,},
	["使招架等級"] = {StatLogic.Stats.ParryRating,},
	["使你的招架等級"] = {StatLogic.Stats.ParryRating,},
	["格擋機率等級"] = {StatLogic.Stats.BlockRating,},
	["提高格擋機率等級"] = {StatLogic.Stats.BlockRating,},
	["提高你的格擋機率等級"] = {StatLogic.Stats.BlockRating,},
	["使格擋機率等級"] = {StatLogic.Stats.BlockRating,},
	["使你的格擋機率等級"] = {StatLogic.Stats.BlockRating,},
	["格擋等級"] = {StatLogic.Stats.BlockRating,},
	["提高格擋等級"] = {StatLogic.Stats.BlockRating,},
	["提高你的格擋等級"] = {StatLogic.Stats.BlockRating,},
	["使格擋等級"] = {StatLogic.Stats.BlockRating,},
	["使你的格擋等級"] = {StatLogic.Stats.BlockRating,},
	["盾牌格擋等級"] = {StatLogic.Stats.BlockRating,},
	["提高盾牌格擋等級"] = {StatLogic.Stats.BlockRating,},
	["提高你的盾牌格擋等級"] = {StatLogic.Stats.BlockRating,},
	["使盾牌格擋等級"] = {StatLogic.Stats.BlockRating,},
	["使你的盾牌格擋等級"] = {StatLogic.Stats.BlockRating,},

	["命中等級"] = {StatLogic.Stats.HitRating,},
	["提高命中等級"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["提高近戰命中等級"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["使你的命中等級"] = {StatLogic.Stats.HitRating,},
	["法術命中等級"] = {StatLogic.Stats.SpellHitRating,},
	["提高法術命中等級"] = {StatLogic.Stats.SpellHitRating,}, -- ITEM_MOD_HIT_SPELL_RATING
	["使你的法術命中等級"] = {StatLogic.Stats.SpellHitRating,},
	["遠程命中等級"] = {StatLogic.Stats.RangedHitRating,},
	["提高遠距命中等級"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["使你的遠程命中等級"] = {StatLogic.Stats.RangedHitRating,},

	["致命一擊"] = {StatLogic.Stats.CritRating,}, -- ID:31868
	["致命一擊等級"] = {StatLogic.Stats.CritRating,},
	["提高致命一擊等級"] = {StatLogic.Stats.CritRating,},
	["使你的致命一擊等級"] = {StatLogic.Stats.CritRating,},
	["近戰致命一擊等級"] = {StatLogic.Stats.MeleeCritRating,},
	["提高近戰致命一擊等級"] = {StatLogic.Stats.MeleeCritRating,}, -- [屠殺者腰帶] ID:21639
	["使你的近戰致命一擊等級"] = {StatLogic.Stats.MeleeCritRating,},
	["法術致命一擊等級"] = {StatLogic.Stats.SpellCritRating,},
	["提高法術致命一擊等級"] = {StatLogic.Stats.SpellCritRating,}, -- [伊利達瑞的復仇] ID:28040
	["使你的法術致命一擊等級"] = {StatLogic.Stats.SpellCritRating,},
	["使半徑30碼範圍內所有小隊成員的法術致命一擊等級"] = {StatLogic.Stats.SpellCritRating,}, -- Atiesh, ID: 22589
	["遠程致命一擊等級"] = {StatLogic.Stats.RangedCritRating,},
	["提高遠程致命一擊等級"] = {StatLogic.Stats.RangedCritRating,},
	["使你的遠程致命一擊等級"] = {StatLogic.Stats.RangedCritRating,},

	["韌性"] = {StatLogic.Stats.ResilienceRating,},
	["韌性等級"] = {StatLogic.Stats.ResilienceRating,},
	["使你的韌性等級"] = {StatLogic.Stats.ResilienceRating,},

	["加速等級"] = {StatLogic.Stats.HasteRating}, -- Enchant Gloves
	["攻擊速度"] = {StatLogic.Stats.HasteRating},
	["攻擊速度等級"] = {StatLogic.Stats.HasteRating},
	["提高加速等級"] = {StatLogic.Stats.HasteRating},
	["提高近戰加速等級"] = {StatLogic.Stats.MeleeHasteRating},
	["法術加速等級"] = {StatLogic.Stats.SpellHasteRating},
	["提高法術加速等級"] = {StatLogic.Stats.SpellHasteRating},
	["遠程攻擊加速等級"] = {StatLogic.Stats.RangedHasteRating},
	["提高遠程攻擊加速等級"] = {StatLogic.Stats.RangedHasteRating},

	["使你的熟練等級提高"] = {StatLogic.Stats.ExpertiseRating},
	["精准等级"] = {StatLogic.Stats.ExpertiseRating,},
	["提高精准等级"] = {StatLogic.Stats.ExpertiseRating,},
	["精准等级提高"] = {StatLogic.Stats.ExpertiseRating,},
	["护甲穿透等级"] = {StatLogic.Stats.ArmorPenetrationRating},
	["护甲穿透等级提高"] = {StatLogic.Stats.ArmorPenetrationRating},

	-- Exclude
	["秒"] = false,
	--["to"] = false,
	["格容器"] = false,
	["格箭袋"] = false,
	["格彈藥袋"] = false,
	["遠程攻擊速度%"] = false, -- AV quiver
}