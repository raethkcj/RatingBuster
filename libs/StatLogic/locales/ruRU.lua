--ruRU localization by YujiTFD, thehallowedfire
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "ruRU")
if not L then return end

L["tonumber"] = tonumber
--[[
-- Item Stat Scanning Procedure
-- Trim spaces using strtrim(text)
-- Strip color codes
-- 1. Fast Exclude - Exclude obvious lines that do not need to be checked
--    Exclude a string by matching the whole string, these strings are indexed in L.Exclude.
--    Exclude a string by looking at the first X chars, these strings are indexed in L.Exclude.
--    Exclude lines starting with '"'. (Flavor text)
--    Exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
-- 2. Whole Text Lookup - Mainly used for enchants or stuff without numbers
--    Whole strings are indexed in L.WholeTextLookup
-- 3. Single Plus Stat Check - "+10 Spirit"
--    String is matched with pattern L.SinglePlusStatCheck, 2 captures are returned.
--    If a match is found, the non-number capture is looked up in L.StatIDLookup.
-- 4. Single Equip Stat Check - "Equip: Increases attack power by 81."
--    String is matched with pattern L.SingleEquipStatCheck, 2 captures are returned.
--    If a match is found, the non-number capture is looked up in L.StatIDLookup.
-- 5. Pre Scan - Short list of patterns that will be checked before going into Deep Scan.
-- 6. Deep Scan - When all the above checks fail, we will use the Deep Scan, this is slow but only about 10% of the lines need it.
--    Strip leading "Equip: ", "Socket Bonus: ".
--    Strip trailing ".".
--    Separate the string using L.DeepScanSeparators.
--    Check if the separated strings are found in L.WholeTextLookup.
--    Try to match each separated string to patterns in L.DeepScanPatterns in order, patterns in L.DeepScanPatterns should have less inclusive patterns listed first and more inclusive patterns listed last.
--    If no match then separae the string using L.DeepScanWordSeparators, then check again.
--]]
------------------
-- Fast Exclude --
------------------
-- By looking at the first ExcludeLen letters of a line we can exclude a lot of lines
L["ExcludeLen"] = 5 -- using string.utf8len
L["Exclude"] = {
	[""] = true,
	[" \n"] = true,
	[ITEM_BIND_ON_EQUIP] = true, -- ITEM_BIND_ON_EQUIP = "Binds when equipped"; -- Item will be bound when equipped
	[ITEM_BIND_ON_PICKUP] = true, -- ITEM_BIND_ON_PICKUP = "Binds when picked up"; -- Item wil be bound when picked up
	[ITEM_BIND_ON_USE] = true, -- ITEM_BIND_ON_USE = "Binds when used"; -- Item will be bound when used
	[ITEM_BIND_QUEST] = true, -- ITEM_BIND_QUEST = "Quest Item"; -- Item is a quest item (same logic as ON_PICKUP)
	[ITEM_SOULBOUND] = true, -- ITEM_SOULBOUND = "Soulbound"; -- Item is Soulbound
	[ITEM_STARTS_QUEST] = true, -- ITEM_STARTS_QUEST = "This Item Begins a Quest"; -- Item is a quest giver
	[ITEM_CANT_BE_DESTROYED] = true, -- ITEM_CANT_BE_DESTROYED = "That item cannot be destroyed."; -- Attempted to destroy a NO_DESTROY item
	[ITEM_CONJURED] = true, -- ITEM_CONJURED = "Conjured Item"; -- Item expires
	[ITEM_DISENCHANT_NOT_DISENCHANTABLE] = true, -- ITEM_DISENCHANT_NOT_DISENCHANTABLE = "Cannot be disenchanted"; -- Items which cannot be disenchanted ever
	["Для ра"] = true, -- ITEM_DISENCHANT_ANY_SKILL = "Disenchantable"; -- Items that can be disenchanted at any skill level
	-- ITEM_DISENCHANT_MIN_SKILL = "Disenchanting requires %s (%d)"; -- Minimum enchanting skill needed to disenchant
	["Durat"] = true, -- ITEM_DURATION_DAYS = "Длительность, дней: %d";
	["<Изго"] = true, -- ITEM_CREATED_BY = "|cff00ff00<Создатель: %s>|r"; -- %s is the creator of the item
	["Восст"] = true, -- ITEM_COOLDOWN_TIME_DAYS = "Откат, дней: %d day";
	["Уника"] = true, -- Unique (20) -- ITEM_UNIQUE = "Уникальная"; -- Item is unique -- ITEM_UNIQUE_MULTIPLE = "Уникальная (%d)"; -- Item is unique
	["Требу"] = true, -- Requires Level xx -- ITEM_MIN_LEVEL = "Требуется уровень %d"; -- Required level to use the item
	["\nТре"] = true, -- Requires Level xx -- ITEM_MIN_SKILL = "Требуется %s (%d)"; -- Required skill rank to use the item
	["Класс"] = true, -- Classes: xx -- ITEM_CLASSES_ALLOWED = "Класс: %s"; -- Lists the classes allowed to use this item
	["Тольк"] = true, -- Only for Horde/Alliance (PvP trinkets)
	["Расы:"] = true, -- Races: xx (vendor mounts) -- ITEM_RACES_ALLOWED = "Раса: %s"; -- Lists the races allowed to use this item
	["Испол"] = true, -- Use: -- ITEM_SPELL_TRIGGER_ONUSE = "Использование:";
	["Шанс "] = true, -- Chance On Hit: -- ITEM_SPELL_TRIGGER_ONPROC = "Шанс при ударе:";
	["Транс"] = true, -- Mount;
	-- Set Bonuses
	-- ITEM_SET_BONUS = "Set: %s";
	-- ITEM_SET_BONUS_GRAY = "(%d) Set: %s";
	-- ITEM_SET_NAME = "%s (%d/%d)"; -- Set name (2/5)
	["Компл"] = true,
	["(2) Н"] = true,
	["(3) Н"] = true,
	["(4) Н"] = true,
	["(5) Н"] = true,
	["(6) Н"] = true,
	["(7) Н"] = true,
	["(8) Н"] = true,
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
--[[DEBUG stuff, no need to translate
textTable = {
"Spell Damage +6 and Spell Hit Rating +5",
"+3 Stamina, +4 Critical Strike Rating",
"+26 Healing Spells & 2% Reduced Threat",
"+3 Stamina/+4 Critical Strike Rating",
"Socket Bonus: 2 mana per 5 sec.",
"Equip: Increases damage and healing done by magical spells and effects by up to 150.",
"Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.",
"Equip: Increases damage and healing done by magical spells and effects of all party members within 30 yards by up to 33.",
"Equip: Increases healing done by magical spells and effects of all party members within 30 yards by up to 62.",
"Equip: Increases your spell damage by up to 120 and your healing by up to 300.",
"Equip: Restores 11 mana per 5 seconds to all party members within 30 yards.",
"Equip: Increases healing done by spells and effects by up to 300.",
"Equip: Increases attack power by 420 in Cat, Bear, Dire Bear, and Moonkin forms only.",
"+10 Defense Rating/+10 Stamina/+15 Block Value", -- ZG Enchant
"+26 Attack Power and +14 Critical Strike Rating", -- Swift Windfire Diamond ID:28556
"+26 Healing Spells & 2% Reduced Threat", -- Bracing Earthstorm Diamond ID:25897
"+6 Spell Damage, +5 Spell Crit Rating", -- Potent Ornate Topaz ID: 28123
----
"Critical Rating +6 and Dodge Rating +5", -- Assassin's Fire Opal ID:30565
"Healing +11 and 2 mana per 5 sec.", -- Royal Tanzanite ID: 30603
}
--]]
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

	["Слабое волшебное масло"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["Простое волшебное масло"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["Волшебное масло"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["Блестящее волшебное масло"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, ["SPELL_CRIT_RATING"] = 14}, -- ID: 20749
	["Превосходное волшебное масло"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522
	["Благословленное волшебное масло"] = {["SPELL_DMG_UNDEAD"] = 60}, -- ID: 23123

	["Слабое масло маны"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Простое масло маны"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Блестящее масло маны"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Превосходное масло маны"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Этерниевая леска"] = {["FISHING"] = 5}, --
	["Жестокость"] = {["AP"] = 70}, --
	["Живучесть I"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
	["Ледяная душа"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["Солнечный огонь"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},
	["+50 к силе заклинаний огня и тайной магии"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},

	["Мифриловые шпоры"] = {["MOUNT_SPEED"] = 4}, -- Mithril Spurs
	["Небольшое ускорение верховой езды"] = {["MOUNT_SPEED"] = 2}, -- Enchant Gloves - Riding Skill
	["Надето: небольшое ускорение бега."] = {["RUN_SPEED"] = 8}, -- [Highlander's Plate Greaves] ID: 20048
	["Небольшое ускорениеускорение бега"] = {["RUN_SPEED"] = 8}, --
	["Небольшое увеличение скорости"] = {["RUN_SPEED"] = 8}, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["Небольшое увеличение скорости и +6 к ловкости"] = {["RUN_SPEED"] = 8, ["AGI"] = 6}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["Небольшое увеличение скорости и +9 к выносливости"] = {["RUN_SPEED"] = 8, ["STA"] = 9}, -- Enchant Boots - Boar's Speed "Minor Speed and +9 Stamina"
	["Верный шаг"] = {["MELEE_HIT_RATING"] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Скрытность"] = {["THREAT_MOD"] = -2}, -- Enchant Cloak - Subtlety
	["На 2% уменьшена угроза"] = {["THREAT_MOD"] = -2}, -- StatLogic:GetSum("item:23344:2832")
	["+2% угрозы"] = {["THREAT_MOD"] = 2}, -- Formula: Enchant Gloves - Threat
	["Надето: Позволяет дышать под водой."] = false, -- [Band of Icy Depths] ID: 21526
	["Позволяет дышать под водой"] = false, --
	--	["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639 -- Fixed for TBC Classic 2.5.1: no longer immune.
	["Надето: Сокращает время разоружения на 50%."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Сокращает время разоружения на 50%"] = false, --
	["Рыцарь"] = false, -- Enchant Crusader
	["Вампиризм"] = false,
	["Мангуст"] = false, -- Enchant Mongoose
	["Если на персонаже: Подчинение владельца воле Испепелителя."] = false, -- Corrupted Ashbringer
	-- Shattered Sun Offensive necks
	["Если на персонаже: Если вас превозносят Провидцы, у ваших атак ближнего и дальнего боя появляется шанс придать вам силу тайной магии, а при превознесении со стороны Алдоров – силу Света."] = false,
	["Если на персонаже: Если вас превозносят Провидцы, у ваших заклинаний появляется шанс придать вам силу тайной магии, а при превознесении со стороны Алдоров – силу Света."] = false,
	["Если на персонаже: Если вас превозносят Провидцы, у ваших целительных заклинаний появляется шанс придать вам силу тайной магии, а при превознесении со стороны Алдоров – силу Света."] = false,
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
L["SinglePlusStatCheck"] = "^([%+%-]%d+) (.-)%.?$"
-----------------------------
-- Single Equip Stat Check --
-----------------------------
-- stat1, value, stat2 = strfind
-- stat = stat1..stat2
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^Надето: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	--["^Equip: Increases attack power by (%d+) when fighting Undead"] = "AP_UNDEAD", -- Seal of the Dawn ID:13029
	["^(%d+) Block$"] = "BLOCK_VALUE",
	["^Броня: (%d+)$"] = "ARMOR",
	["Reinforced %(%+(%d+) Armor%)"] = "ARMOR_BONUS",
	["Восполнение (%d+) ед. маны за 5 сек%.$"] = "MANA_REG",
	["Восполняет (%d+) ед%. здоровья каждые 5 секунд%."] = "HEALTH_REG",
	["^Урон: %+?%d+%-(%d+)$"] = "MAX_DAMAGE",
	["^%d+ %- (%d+) ед%. урона от .-$"] = "MAX_DAMAGE", -- Wands: "123 - 321 ед. урона от светлой магии"
	["^%(([%d%.]+) ед. урона в секунду%)$"] = "DPS",
	-- Exclude
	["^(%d+) Slot"] = false, -- Set Name (0/9)
	["^.+%((%d+)/%d+%)$"] = false, -- Set Name (0/9)
	["|cff808080"] = false, -- Gray text "  |cff808080Requires at least 2 Yellow gems|r\n  |cff808080Requires at least 1 Red gem|r"
	-- Procs
	--["[Cc]hance"] = false, -- [Mark of Defiance] ID:27924 -- [Staff of the Qiraji Prophets] ID:21128 -- Commented out because it was blocking [Insightful Earthstorm Diamond]
	["[Ss]ometimes"] = false, -- [Darkmoon Card: Heroism] ID:19287
	["[Ww]hen struck in combat"] = false, -- [Essence of the Pure Flame] ID: 18815
	["[Вв]озможный эффект"] = false, -- Sulfuras, Hand of Ragnaros
	["[Шш]анс увеличить"] = false, -- Mana-Etched Regalia
	["с вероятностью"] = false,
}
--------------
-- DeepScan --
--------------
-- Strip leading "Equip: ", "Socket Bonus: "
L["Equip: "] = "Если на персонаже: " -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
L["Socket Bonus: "] = "При соответствии цвета: " -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
-- Strip trailing "."
L["."] = "."
L["DeepScanSeparators"] = {
	"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
	" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
	", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
	"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
}
L["DeepScanWordSeparators"] = {
	" и ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
}
L["DualStatPatterns"] = {
	-- all lower case
	["^%+(%d+) healing and %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^%+(%d+) healing %+(%d+) spell damage$"] = {{"HEAL",}, {"SPELL_DMG",},},
	["^increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects$"] = {{"HEAL",}, {"SPELL_DMG",},},
}
L["DeepScanPatterns"] = {
	"^(.-) на ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
	"^(.-) ?([%+%-]%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
	"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
}
-----------------------
-- Stat Lookup Table --
-----------------------
L["StatIDLookup"] = {
	["Эффективность брони противника против ваших атак снижена на"] = {"IGNORE_ARMOR"}, -- StatLogic:GetSum("item:33733") (used tbc text)
	["% Threat"] = {"THREAT_MOD"}, -- StatLogic:GetSum("item:23344:2613")
	["Увеличение уровня эффективного действия незаметности"] = {"STEALTH_LEVEL"}, -- [Nightscape Boots] ID: 8197
	["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant
	["увеличение скорости передвижения верхом на%"] = {"MOUNT_SPEED"}, -- [Highlander's Plate Greaves] ID: 20048

	["ко всем характеристикам"] = {"STR", "AGI", "STA", "INT", "SPI",},
	["к силе"] = {"STR",},
	["силу цели"] = {"STR",},
	["к ловкости"] = {"AGI",},
	["к выносливости"] = {"STA",},
	["к интеллекту"] = {"INT",},
	["к духу"] = {"SPI",},

	["сопротивление тайной магии"] = {"ARCANE_RES",},
	["к сопротивлению тайной магии"] = {"ARCANE_RES",},
	["сопротивление огню"] = {"FIRE_RES",},
	["к сопротивлению огню"] = {"FIRE_RES",},
	["сопротивление силам природы"] = {"NATURE_RES",},
	["к сопротивлению силам природы"] = {"NATURE_RES",},
	["сопротивление магии льда"] = {"FROST_RES",},
	["к сопротивлению магии льда"] = {"FROST_RES",},
	["сопротивление темной магии"] = {"SHADOW_RES",},
	["к сопротивлению темной магии"] = {"SHADOW_RES",},
	["сопротивления темной магии"] = {"SHADOW_RES",},
	["сопротивление всем видам магии"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["ко всем видам сопротивления"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},
	["Resist All"] = {"ARCANE_RES", "FIRE_RES", "FROST_RES", "NATURE_RES", "SHADOW_RES",},

	["к рыбной ловле"] = {"FISHING",}, -- Fishing enchant ID:846
	["рыбная ловля"] = {"FISHING",}, -- Equip: Increased Fishing +20. (it actually looks like: Увеличение навыка "Рыбная ловля" на +20)
	["к навыку рыбной ловли"] = {"FISHING",},
	["навык рыбной ловли увеличивается на"] = {"FISHING",},
	["к горному делу"] = {"MINING",}, -- Mining enchant ID:844
	["к травничеству"] = {"HERBALISM",}, -- Heabalism enchant ID:845
	["к снятию шкур"] = {"SKINNING",}, -- Skinning enchant ID:865

	["броня"] = {"ARMOR_BONUS",},
	["к броне"] = {"ARMOR_BONUS",},
	["защита"] = {"DEFENSE",},
	["Increased Defense"] = {"DEFENSE",},
	["блок"] = {"BLOCK_VALUE",},
	["блокирование:"] = {"BLOCK_VALUE",},
	["к показателю блокирования щита"] = {"BLOCK_VALUE",}, -- +10% Shield Block Value [Eternal Earthstorm Diamond] http://www.wowhead.com/?item=35501
	["увеличивает показатель блокирования вашего щита наед"] = {"BLOCK_VALUE",},

	["здоровье"] = {"HEALTH",},
	["к здоровью"] = {"HEALTH",},
	["HP"] = {"HEALTH",},
	["мана"] = {"MANA",},

	["сила атаки"] = {"AP",},
	["увеличивает силу атаки на"] = {"AP",},
	["повышает силу атаки на"] = {"AP",},
	["силы атаки нав бою с нежитью"] = {"AP_UNDEAD",}, -- Actually looks like "Увеличение силы атаки на 45 ед. в бою с нежитью"
	-- [Wristwraps of Undead Slaying] ID:23093
	["увеличение силы атаки наед. в битве с нежитью"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["увеличение силы атаки наед. в бою с нежитью. Также позволяет собирать камни Плети от имени и по поручению Серебряного Рассвета"] = {"AP_UNDEAD",}, -- [Seal of the Dawn] ID:13209
	["Increases attack powerwhen fighting Demons"] = {"AP_DEMON",}, -- (item example please)
	["увеличение силы атаки наед. в бою с нежитью и демонами"] = {"AP_UNDEAD", "AP_DEMON",}, -- [Mark of the Champion] ID:23206
	["увеличивает силу атаки нав облике кошки, медведя, лютого медведя и лунного совуха"] = {"FERAL_AP",},
	["сила атаки дальнего боя"] = {"RANGED_AP",},
	["увеличивает силу атак дальнего боя"] = {"RANGED_AP",}, -- [High Warlord's Crossbow] ID: 18837

	["Health Regen"] = {"MANA_REG",},
	["Health per"] = {"HEALTH_REG",},
	["health per"] = {"HEALTH_REG",}, -- Frostwolf Insignia Rank 6 ID:17909
	["Health every"] = {"MANA_REG",},
	["health every"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["your normal health regeneration"] = {"HEALTH_REG",}, -- Demons Blood ID: 10779
	["Restoreshealth per 5 sec"] = {"HEALTH_REG",}, -- [Onyxia Blood Talisman] ID: 18406
	["восполняетед. здоровья каждые 5 секунд"] = {"HEALTH_REG",}, -- [Resurgence Rod] ID:17743
	["Mana Regen"] = {"MANA_REG",}, -- Prophetic Aura +4 Mana Regen/+10 Stamina/+24 Healing Spells http://wow.allakhazam.com/db/spell.html?wspell=24167
	["Mana per"] = {"MANA_REG",},
	["mana per"] = {"MANA_REG",}, -- Resurgence Rod ID:17743 Most common
	["Mana every"] = {"MANA_REG",},
	["mana every"] = {"MANA_REG",},
	["Mana every 5 Sec"] = {"MANA_REG",}, --
	["mana every 5 sec"] = {"MANA_REG",}, -- Enchant Chest - Restore Mana Prime "+6 mana every 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=33991
	["Mana per 5 Seconds"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana Per 5 sec"] = {"MANA_REG",}, -- [Royal Shadow Draenite] ID: 23109
	["Mana per 5 sec"] = {"MANA_REG",}, -- [Cyclone Shoulderpads] ID: 29031
	["mana per 5 sec"] = {"MANA_REG",}, -- [Royal Tanzanite] ID: 30603
	["восполнениеед. маны в 5 секунд"] = {"MANA_REG",},
	["восполнениеед. маны за 5 сек."] = {"MANA_REG",},
	["восполнениеед. маны раз в 5 секунд"] = {"MANA_REG",},
	["Mana restored per 5 seconds"] = {"MANA_REG",}, -- Magister's Armor Kit +3 Mana restored per 5 seconds http://wow.allakhazam.com/db/spell.html?wspell=32399
	["Mana Regenper 5 sec"] = {"MANA_REG",}, -- Enchant Bracer - Mana Regeneration "Mana Regen 4 per 5 sec." http://wow.allakhazam.com/db/spell.html?wspell=23801
	["Mana per 5 Sec"] = {"MANA_REG",}, -- Enchant Bracer - Restore Mana Prime "6 Mana per 5 Sec." http://wow.allakhazam.com/db/spell.html?wspell=27913

	["проникающей способности заклинаний"] = {"SPELLPEN",}, -- Enchant Cloak - Spell Penetration "+20 Spell Penetration" http://wow.allakhazam.com/db/spell.html?wspell=34003
	["увеличивает проникающую способность заклинаний на"] = {"SPELLPEN",},

	["Healing and Spell Damage"] = {"SPELL_DMG", "HEAL",}, -- Arcanum of Focus +8 Healing and Spell Damage http://wow.allakhazam.com/db/spell.html?wspell=22844
	["Damage and Healing Spells"] = {"SPELL_DMG", "HEAL",},
	["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",},
	["Spell Damage"] = {"SPELL_DMG", "HEAL",},
	["Increases damage and healing done by magical spells and effects"] = {"SPELL_DMG", "HEAL"},
	["повышает рейтинг критичекого поражения заклинаний всех участников группы в радиусе 30 м. на"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
	["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["Damage"] = {"SPELL_DMG",},
	["Increases your spell damage"] = {"SPELL_DMG",}, -- Atiesh ID:22630, 22631, 22632, 22589
	["к силе заклинаний"] = {"SPELL_DMG", "HEAL",},
	["увеличивает силу заклинаний на"] = {"SPELL_DMG", "HEAL",},
	["Holy Damage"] = {"HOLY_SPELL_DMG",},
	["Arcane Damage"] = {"ARCANE_SPELL_DMG",},
	["Fire Damage"] = {"FIRE_SPELL_DMG",},
	["Nature Damage"] = {"NATURE_SPELL_DMG",},
	["Frost Damage"] = {"FROST_SPELL_DMG",},
	["Shadow Damage"] = {"SHADOW_SPELL_DMG",},
	["Holy Spell Damage"] = {"HOLY_SPELL_DMG",},
	["Arcane Spell Damage"] = {"ARCANE_SPELL_DMG",},
	["Fire Spell Damage"] = {"FIRE_SPELL_DMG",},
	["Nature Spell Damage"] = {"NATURE_SPELL_DMG",},
	["Frost Spell Damage"] = {"FROST_SPELL_DMG",}, -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	["Shadow Spell Damage"] = {"SHADOW_SPELL_DMG",},
	["Increases damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["Increases damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Frozen Shadoweave Vest ID:21871
	["Increases damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",},
	["Increases damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",},
	["Increases damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",},
	["Increases damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",},
	["Increases the damage done by Holy spells and effects"] = {"HOLY_SPELL_DMG",}, -- Drape of the Righteous ID:30642
	["Increases the damage done by Arcane spells and effects"] = {"ARCANE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Fire spells and effects"] = {"FIRE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Frost spells and effects"] = {"FROST_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Nature spells and effects"] = {"NATURE_SPELL_DMG",}, -- Added just in case
	["Increases the damage done by Shadow spells and effects"] = {"SHADOW_SPELL_DMG",}, -- Added just in case

	["увеличивает силу заклинаний, применяемых против нежити, на"] = {"SPELL_DMG_UNDEAD"}, -- [Robe of Undead Cleansing] ID:23085
	["Increases damage done to Undead by magical spells and effects.  It also allows the acquisition of Scourgestones on behalf of the Argent Dawn"] = {"SPELL_DMG_UNDEAD"}, -- [Rune of the Dawn] ID:19812
	["Increases damage done to Undead and Demons by magical spells and effects"] = {"SPELL_DMG_UNDEAD", "SPELL_DMG_DEMON"}, -- [Mark of the Champion] ID:23207

	["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
	["Increases Healing"] = {"HEAL",},
	["Healing"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
	["healing Spells"] = {"HEAL",},
	["Damage Spells"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Healing Spells"] = {"HEAL",}, -- [Royal Nightseye] ID: 24057
	["Increases healing done"] = {"HEAL",}, -- 2.3.0
	["damage donefor all magical spells"] = {"SPELL_DMG",}, -- 2.3.0
	["Increases healing done by spells and effects"] = {"HEAL",},
	["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
	["your healing"] = {"HEAL",}, -- Atiesh

	["damage per second"] = {"DPS",},
	["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["Defense Rating"] = {"DEFENSE_RATING",},
	["повышает рейтинг защиты на"] = {"DEFENSE_RATING",},
	["Dodge Rating"] = {"DODGE_RATING",},
	["к рейтингу уклонения"] = {"DODGE_RATING",},
	["увеличивает рейтинг уклонения"] = {"DODGE_RATING",},
	["увеличивает рейтинг уклонения на"] = {"DODGE_RATING",},
	["повышает рейтинг уклонения на"] = {"DODGE_RATING",},
	["Parry Rating"] = {"PARRY_RATING",},
	["повышает рейтинг парирования на"] = {"PARRY_RATING",},
	["Shield Block Rating"] = {"BLOCK_RATING",}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["Block Rating"] = {"BLOCK_RATING",},
	["увеличение рейтинга блока наед"] = {"BLOCK_RATING",},
	["увеличивает рейтинг блокирования щитом на"] = {"BLOCK_RATING",},

	["Improves your chance to hit%"] = {"MELEE_HIT"},
	["Hit Rating"] = {"MELEE_HIT_RATING",},
	["повышает меткость"] = {"HIT_RATING",}, -- ITEM_MOD_HIT_RATING
	["меткость в ближнем бою"] = {"MELEE_HIT_RATING",}, -- ITEM_MOD_HIT_MELEE_RATING
	["повышает рейтинг меткости"] = {"HIT_RATING",},
	["к рейтингу меткости"] = {"HIT_RATING",},
	["Improves your chance to hit with spells%"] = {"SPELL_HIT"},
	["Spell Hit Rating"] = {"SPELL_HIT_RATING",},
	["повышает рейтинг меткости на"] = {"HIT_RATING",},
	["Increases your spell hit rating"] = {"SPELL_HIT_RATING",},
	["Ranged Hit Rating"] = {"RANGED_HIT_RATING",},
	["Improves ranged hit rating"] = {"RANGED_HIT_RATING",}, -- ITEM_MOD_HIT_RANGED_RATING
	["Increases your ranged hit rating"] = {"RANGED_HIT_RATING",},

	["Improves your chance to get a critical strike by%"] = {"MELEE_CRIT", "RANGED_CRIT"},
	["Crit Rating"] = {"CRIT_RATING",},
	["Critical Rating"] = {"CRIT_RATING",},
	["рейтинг критического удара"] = {"CRIT_RATING",},
	["Increases your critical hit rating"] = {"CRIT_RATING",},
	["Increases your critical strike rating"] = {"CRIT_RATING",},
	["повышает рейтинг критического удара на"] = {"CRIT_RATING",},
	["Improves melee critical strike rating"] = {"MELEE_CRIT_RATING",}, -- [Cloak of Darkness] ID:33122
	["Improves your chance to get a critical strike with spells%"] = {"SPELL_CRIT"},
	["Spell Critical Strike Rating"] = {"SPELL_CRIT_RATING",},
	["Spell Critical strike rating"] = {"SPELL_CRIT_RATING",},
	["Spell Critical Rating"] = {"SPELL_CRIT_RATING",},
	["Spell Crit Rating"] = {"SPELL_CRIT_RATING",},
	["к рейтингу критического удара"] = {"SPELL_CRIT_RATING",}, -- TBC Chaotic Skyfire Diamond
	["Increases your spell critical strike rating"] = {"SPELL_CRIT_RATING",},
	["Increases the spell critical strike rating of all party members within 30 yards"] = {"SPELL_CRIT_RATING",},
	["Improves spell critical strike rating"] = {"SPELL_CRIT_RATING",},
	["Increases your ranged critical strike rating"] = {"RANGED_CRIT_RATING",}, -- Fletcher's Gloves ID:7348

	["устойчивость"] = {"RESILIENCE_RATING",},
	["рейтинг устойчивости"] = {"RESILIENCE_RATING",}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
	["повышает рейтинг устойчивости на"] = {"RESILIENCE_RATING",},
	["к рейтингу устойчивости"] = {"RESILIENCE_RATING",},

	["Haste Rating"] = {"HASTE_RATING"},
	["к рейтингу скорости"] = {"HASTE_RATING"}, -- (added this line)
	["Ranged Haste Rating"] = {"HASTE_RATING"},
	["повышает рейтинг скорости боя на"] = {"HASTE_RATING"},
	["Spell Haste Rating"] = {"SPELL_HASTE_RATING"},
	["Improves melee haste rating"] = {"MELEE_HASTE_RATING"},
	["Improves spell haste rating"] = {"SPELL_HASTE_RATING"},
	["Improves ranged haste rating"] = {"RANGED_HASTE_RATING"},

	["Increases dagger skill rating"] = {"DAGGER_WEAPON_RATING"},
	["Increases sword skill rating"] = {"SWORD_WEAPON_RATING"}, -- [Warblade of the Hakkari] ID:19865
	["Increases Two-Handed Swords skill rating"] = {"2H_SWORD_WEAPON_RATING"},
	["Increases axe skill rating"] = {"AXE_WEAPON_RATING"},
	["Two-Handed Axe Skill Rating"] = {"2H_AXE_WEAPON_RATING"}, -- [Ethereum Nexus-Reaver] ID:30722
	["Increases two-handed axes skill rating"] = {"2H_AXE_WEAPON_RATING"},
	["Increases mace skill rating"] = {"MACE_WEAPON_RATING"},
	["Increases two-handed maces skill rating"] = {"2H_MACE_WEAPON_RATING"},
	["Increases gun skill rating"] = {"GUN_WEAPON_RATING"},
	["Increases Crossbow skill rating"] = {"CROSSBOW_WEAPON_RATING"},
	["Increases Bow skill rating"] = {"BOW_WEAPON_RATING"},
	["Increases feral combat skill rating"] = {"FERAL_WEAPON_RATING"},
	["Increases fist weapons skill rating"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator
	["Increases unarmed skill rating"] = {"FIST_WEAPON_RATING"}, -- Demonblood Eviscerator ID:27533
	["Increases staff skill rating"] = {"STAFF_WEAPON_RATING"}, -- Leggings of the Fang ID:10410

	["рейтинг мастерства"] = {"EXPERTISE_RATING"},
	["к рейтингу мастерства"] = {"EXPERTISE_RATING"},
	["повышает рейтинг мастерства на"] = {"EXPERTISE_RATING"},
	["Повышает рейтинг пробивания брони на"] = {"ARMOR_PENETRATION_RATING"},
	["увеличивает рейтинг пробивания брони на"] = {"ARMOR_PENETRATION_RATING"},
	["снижает эффективность брони противника против ваших атак на"] = {"ARMOR_PENETRATION_RATING"},

	-- Exclude
	["sec"] = false,
	["to"] = false,
	["Slot Bag"] = false,
	["Slot Quiver"] = false,
	["Slot Ammo Pouch"] = false,
	["Increases ranged attack speed"] = false, -- AV quiver
	["на 3% увеличенный критический урон"] = false, -- Chaotic Skyflare Diamond second effect
}

local D = LibStub("AceLocale-3.0"):NewLocale("StatLogicD", "ruRU")
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

	["IGNORE_ARMOR"] = {"Ignore Armor", "Ignore Armor"},
	["THREAT_MOD"] = {"Threat(%)", "Threat(%)"},
	["STEALTH_LEVEL"] = {"Stealth Level", "Stealth"},
	["MELEE_DMG"] = {"Melee Weapon "..DAMAGE, "Wpn Dmg"}, -- DAMAGE = "Damage"
	["MOUNT_SPEED"] = {"Mount Speed(%)", "Mount Spd(%)"},
	["RUN_SPEED"] = {"Run Speed(%)", "Run Spd(%)"},

	["STR"] = {"Сила", "Str"},
	["AGI"] = {"Ловкость", "Agi"},
	["STA"] = {"Выносливость", "Sta"},
	["INT"] = {"Интеллект", "Int"},
	["SPI"] = {"Дух", "Spi"},
	["ARMOR"] = {"Броня", ARMOR},
	["ARMOR_BONUS"] = {ARMOR.." from bonus", ARMOR.."(Bonus)"},

	["FIRE_RES"] = {"Сопротивление огню", "FR"},
	["NATURE_RES"] = {"Сопротивление силам природы", "NR"},
	["FROST_RES"] = {"Сопротивление магии льда", "FrR"},
	["SHADOW_RES"] = {"Сопротивление темной магии", "SR"},
	["ARCANE_RES"] = {"Сопротивление тайной магии", "AR"},

	["FISHING"] = {"Рыбная ловля", "Fishing"},
	["MINING"] = {"Горное дело", "Mining"},
	["HERBALISM"] = {"Травничество", "Herbalism"},
	["SKINNING"] = {"Снятие шкур", "Skinning"},

	["BLOCK_VALUE"] = {"Показатель блокирования", "Block Value"},

	["AP"] = {"Сила атаки", "AP"},
	["RANGED_AP"] = {"Сила атаки дальнего боя", "RAP"},
	["FERAL_AP"] = {"Сила атаки в облике зверя", "Feral AP"},
	["AP_UNDEAD"] = {"Сила атаки (против нежити)", "AP(Undead)"},
	["AP_DEMON"] = {"Сила атаки (против демонов)", "AP(Demon)"},

	["HEAL"] = {"Исцеление", "Heal"},

	["SPELL_DMG"] = {"Сила заклинаний", PLAYERSTAT_SPELL_COMBAT.." Dmg"},
	["SPELL_DMG_UNDEAD"] = {"Сила заклинаний (против нежити)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Undead)"},
	["SPELL_DMG_DEMON"] = {"Сила заклинаний (против демонов)", PLAYERSTAT_SPELL_COMBAT.." Dmg".."(Demon)"},
	["HOLY_SPELL_DMG"] = {"Сила заклинаний (светлая магия)", SPELL_SCHOOL1_CAP.." Dmg"},
	["FIRE_SPELL_DMG"] = {"Сила заклинаний (огонь)", SPELL_SCHOOL2_CAP.." Dmg"},
	["NATURE_SPELL_DMG"] = {"Сила заклинаний (природа)", SPELL_SCHOOL3_CAP.." Dmg"},
	["FROST_SPELL_DMG"] = {"Сила заклинаний (лед)", SPELL_SCHOOL4_CAP.." Dmg"},
	["SHADOW_SPELL_DMG"] = {"Сила заклинаний (темная магия)", SPELL_SCHOOL5_CAP.." Dmg"},
	["ARCANE_SPELL_DMG"] = {"Сила заклинаний (тайная магия)", SPELL_SCHOOL6_CAP.." Dmg"},

	["SPELLPEN"] = {"Проникающая способность заклинаний", SPELL_PENETRATION},

	["HEALTH"] = {"Здоровье", HP},
	["MANA"] = {"Мана", MP},
	["HEALTH_REG"] = {"Восстановление здоровья раз в 5 сек.", "HP5"},
	["MANA_REG"] = {"Восстановление маны раз в 5 сек.", "MP5"},

	["MAX_DAMAGE"] = {"Max Damage", "Max Dmg"},
	["DPS"] = {"Урон в секунду", "DPS"},

	["DEFENSE_RATING"] = {"Рейтинг защиты", COMBAT_RATING_NAME2}, -- COMBAT_RATING_NAME2 = "Defense Rating"
	["DODGE_RATING"] = {"Рейтинг уклонения", COMBAT_RATING_NAME3}, -- COMBAT_RATING_NAME3 = "Dodge Rating"
	["PARRY_RATING"] = {"Рейтинг парирования", COMBAT_RATING_NAME4}, -- COMBAT_RATING_NAME4 = "Parry Rating"
	["BLOCK_RATING"] = {"Рейтинг блокирования", COMBAT_RATING_NAME5}, -- COMBAT_RATING_NAME5 = "Block Rating"
	["MELEE_HIT_RATING"] = {"Рейтинг меткости", COMBAT_RATING_NAME6}, -- COMBAT_RATING_NAME6 = "Hit Rating"
	["RANGED_HIT_RATING"] = {"Рейтинг меткости", PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
	["SPELL_HIT_RATING"] = {"Рейтинг меткости", PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6}, -- PLAYERSTAT_SPELL_COMBAT = "Spell"
	["MELEE_CRIT_RATING"] = {"Рейтинг крит. удара", COMBAT_RATING_NAME9}, -- COMBAT_RATING_NAME9 = "Crit Rating"
	["RANGED_CRIT_RATING"] = {"Рейтинг крит. удара", PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9},
	["SPELL_CRIT_RATING"] = {"Рейтинг крит. удара", PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9},
	["RESILIENCE_RATING"] = {"Рейтинг устойчивости", COMBAT_RATING_NAME15}, -- COMBAT_RATING_NAME15 = "Resilience"
	["MELEE_HASTE_RATING"] = {"Рейтинг скорости", "Haste "..RATING}, --
	["RANGED_HASTE_RATING"] = {"Рейтинг скорости", PLAYERSTAT_RANGED_COMBAT.." Haste "..RATING},
	["SPELL_HASTE_RATING"] = {"Рейтинг скорости", PLAYERSTAT_SPELL_COMBAT.." Haste "..RATING},
	["DAGGER_WEAPON_RATING"] = {"Dagger "..SKILL.." "..RATING, "Dagger "..RATING}, -- SKILL = "Skill"
	["SWORD_WEAPON_RATING"] = {"Sword "..SKILL.." "..RATING, "Sword "..RATING},
	["2H_SWORD_WEAPON_RATING"] = {"Two-Handed Sword "..SKILL.." "..RATING, "2H Sword "..RATING},
	["AXE_WEAPON_RATING"] = {"Axe "..SKILL.." "..RATING, "Axe "..RATING},
	["2H_AXE_WEAPON_RATING"] = {"Two-Handed Axe "..SKILL.." "..RATING, "2H Axe "..RATING},
	["MACE_WEAPON_RATING"] = {"Mace "..SKILL.." "..RATING, "Mace "..RATING},
	["2H_MACE_WEAPON_RATING"] = {"Two-Handed Mace "..SKILL.." "..RATING, "2H Mace "..RATING},
	["GUN_WEAPON_RATING"] = {"Gun "..SKILL.." "..RATING, "Gun "..RATING},
	["CROSSBOW_WEAPON_RATING"] = {"Crossbow "..SKILL.." "..RATING, "Crossbow "..RATING},
	["BOW_WEAPON_RATING"] = {"Bow "..SKILL.." "..RATING, "Bow "..RATING},
	["FERAL_WEAPON_RATING"] = {"Feral "..SKILL.." "..RATING, "Feral "..RATING},
	["FIST_WEAPON_RATING"] = {"Unarmed "..SKILL.." "..RATING, "Unarmed "..RATING},
	["STAFF_WEAPON_RATING"] = {"Staff "..SKILL.." "..RATING, "Staff "..RATING}, -- Leggings of the Fang ID:10410
	["EXPERTISE_RATING"] = {"Рейтинг мастерства", "Expertise".." "..RATING},

	---------------------------------------------------------------------------
	-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
	-- Str -> AP, Block Value
	-- Agi -> AP, Crit, Dodge
	-- Sta -> Health
	-- Int -> Mana, Spell Crit
	-- Spi -> mp5nc, hp5oc
	-- Ratings -> Effect
	["HEALTH_REG_OUT_OF_COMBAT"] = {"Восстановление здоровья раз в 5 сек. (вне боя)", "ХП5 (вне боя)"},
	["MANA_REG_NOT_CASTING"] = {"Восстановление маны раз в 5 сек. (вне каста)", "МП5 (вне каста)"},
	["MELEE_CRIT_DMG_REDUCTION"] = {"Понижение входящего урона от крит. ударов (%)", "Crit Dmg Reduc(%)"},
	["RANGED_CRIT_DMG_REDUCTION"] = {"Понижение входящего урона от крит. ударов (%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg Reduc(%)"},
	["SPELL_CRIT_DMG_REDUCTION"] = {"Понижение входящего урона от крит. ударов (%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg Reduc(%)"},
	["DEFENSE"] = {"Защита", "Def"},
	["DODGE"] = {"Уклонение (%)", DODGE.."(%)"},
	["PARRY"] = {"Парирование (%)", PARRY.."(%)"},
	["BLOCK"] = {"Блокирование (%)", BLOCK.."(%)"},
	["AVOIDANCE"] = {"Избегание атак (%)", "Avoidance(%)"},
	["MELEE_HIT"] = {"Меткость (%)", "Hit(%)"},
	["RANGED_HIT"] = {"Меткость (%)", PLAYERSTAT_RANGED_COMBAT.." Hit(%)"},
	["SPELL_HIT"] = {"Меткость (%)", PLAYERSTAT_SPELL_COMBAT.." Hit(%)"},
	["MELEE_HIT_AVOID"] = {"Hit Avoidance(%)", "Hit Avd(%)"},
	["MELEE_CRIT"] = {"Вероятность крит. удара (%)", "Crit(%)"}, -- MELEE_CRIT_CHANCE = "Crit Chance"
	["RANGED_CRIT"] = {"Вероятность крит. удара (%)", PLAYERSTAT_RANGED_COMBAT.." Crit(%)"},
	["SPELL_CRIT"] = {"Вероятность крит. удара (%)", PLAYERSTAT_SPELL_COMBAT.." Crit(%)"},
	["MELEE_CRIT_AVOID"] = {"Crit Avoidance(%)", "Crit Avd(%)"},
	["MELEE_HASTE"] = {"Скорость (%)", "Haste(%)"}, --
	["RANGED_HASTE"] = {"Скорость (%)", PLAYERSTAT_RANGED_COMBAT.." Haste(%)"},
	["SPELL_HASTE"] = {"Скорость (%)", PLAYERSTAT_SPELL_COMBAT.." Haste(%)"},
	["DAGGER_WEAPON"] = {"Dagger "..SKILL, "Dagger"}, -- SKILL = "Skill"
	["SWORD_WEAPON"] = {"Sword "..SKILL, "Sword"},
	["2H_SWORD_WEAPON"] = {"Two-Handed Sword "..SKILL, "2H Sword"},
	["AXE_WEAPON"] = {"Axe "..SKILL, "Axe"},
	["2H_AXE_WEAPON"] = {"Two-Handed Axe "..SKILL, "2H Axe"},
	["MACE_WEAPON"] = {"Mace "..SKILL, "Mace"},
	["2H_MACE_WEAPON"] = {"Two-Handed Mace "..SKILL, "2H Mace"},
	["GUN_WEAPON"] = {"Gun "..SKILL, "Gun"},
	["CROSSBOW_WEAPON"] = {"Crossbow "..SKILL, "Crossbow"},
	["BOW_WEAPON"] = {"Bow "..SKILL, "Bow"},
	["FERAL_WEAPON"] = {"Feral "..SKILL, "Feral"},
	["FIST_WEAPON"] = {"Unarmed "..SKILL, "Unarmed"},
	["STAFF_WEAPON"] = {"Staff "..SKILL, "Staff"}, -- Leggings of the Fang ID:10410
	--["EXPERTISE"] = {STAT_EXPERTISE, STAT_EXPERTISE},
	["EXPERTISE"] = {"Мастерство", "Expertise"},

	---------------------------------------------------------------------------
	-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
	-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
	-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
	-- Expertise -> Dodge Neglect, Parry Neglect
	["DODGE_NEGLECT"] = {"Снижение вер. противника уклониться (%)", DODGE.." Neglect(%)"},
	["PARRY_NEGLECT"] = {"Снижение вер. противника парировать (%)", PARRY.." Neglect(%)"},
	["BLOCK_NEGLECT"] = {"Снижение вер. противника блокировать (%)", BLOCK.." Neglect(%)"},

	---------------------------------------------------------------------------
	-- Talants
	["MELEE_CRIT_DMG"] = {"Crit Damage(%)", "Crit Dmg(%)"},
	["RANGED_CRIT_DMG"] = {PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)", PLAYERSTAT_RANGED_COMBAT.." Crit Dmg(%)"},
	["SPELL_CRIT_DMG"] = {PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)", PLAYERSTAT_SPELL_COMBAT.." Crit Dmg(%)"},

	---------------------------------------------------------------------------
	-- Spell Stats
	-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
	-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
	-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
	-- Use strsplit("@", text) to seperate the spell name and statid
	["THREAT"] = {"Threat", "Threat"},
	["CAST_TIME"] = {"Casting Time", "Cast Time"},
	["MANA_COST"] = {"Mana Cost", "Mana Cost"},
	["RAGE_COST"] = {"Rage Cost", "Rage Cost"},
	["ENERGY_COST"] = {"Energy Cost", "Energy Cost"},
	["COOLDOWN"] = {"Cooldown", "CD"},

	---------------------------------------------------------------------------
	-- Stats Mods
	["MOD_STR"] = {"Mod "..SPELL_STAT1_NAME.."(%)", "Mod Str(%)"},
	["MOD_AGI"] = {"Mod "..SPELL_STAT2_NAME.."(%)", "Mod Agi(%)"},
	["MOD_STA"] = {"Mod "..SPELL_STAT3_NAME.."(%)", "Mod Sta(%)"},
	["MOD_INT"] = {"Mod "..SPELL_STAT4_NAME.."(%)", "Mod Int(%)"},
	["MOD_SPI"] = {"Mod "..SPELL_STAT5_NAME.."(%)", "Mod Spi(%)"},
	["MOD_HEALTH"] = {"Mod "..HEALTH.."(%)", "Mod "..HP.."(%)"},
	["MOD_MANA"] = {"Mod "..MANA.."(%)", "Mod "..MP.."(%)"},
	["MOD_ARMOR"] = {"Mod "..ARMOR.."from Items".."(%)", "Mod "..ARMOR.."(Items)".."(%)"},
	["MOD_BLOCK_VALUE"] = {"Mod Block Value".."(%)", "Mod Block Value".."(%)"},
	["MOD_DMG"] = {"Mod Damage".."(%)", "Mod Dmg".."(%)"},
	["MOD_DMG_TAKEN"] = {"Mod Damage Taken".."(%)", "Mod Dmg Taken".."(%)"},
	["MOD_CRIT_DAMAGE"] = {"Mod Crit Damage".."(%)", "Mod Crit Dmg".."(%)"},
	["MOD_CRIT_DAMAGE_TAKEN"] = {"Mod Crit Damage Taken".."(%)", "Mod Crit Dmg Taken".."(%)"},
	["MOD_THREAT"] = {"Mod Threat".."(%)", "Mod Threat".."(%)"},
	["MOD_AP"] = {"Mod "..ATTACK_POWER_TOOLTIP.."(%)", "Mod AP".."(%)"},
	["MOD_RANGED_AP"] = {"Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)", "Mod RAP".."(%)"},
	["MOD_SPELL_DMG"] = {"Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)", "Mod "..PLAYERSTAT_SPELL_COMBAT.." Dmg".."(%)"},
	["MOD_HEALING"] = {"Mod Healing".."(%)", "Mod Heal".."(%)"},
	["MOD_CAST_TIME"] = {"Mod Casting Time".."(%)", "Mod Cast Time".."(%)"},
	["MOD_MANA_COST"] = {"Mod Mana Cost".."(%)", "Mod Mana Cost".."(%)"},
	["MOD_RAGE_COST"] = {"Mod Rage Cost".."(%)", "Mod Rage Cost".."(%)"},
	["MOD_ENERGY_COST"] = {"Mod Energy Cost".."(%)", "Mod Energy Cost".."(%)"},
	["MOD_COOLDOWN"] = {"Mod Cooldown".."(%)", "Mod CD".."(%)"},

	---------------------------------------------------------------------------
	-- Misc Stats
	["WEAPON_RATING"] = {"Weapon "..SKILL.." "..RATING, "Weapon"..SKILL.." "..RATING},
	["WEAPON_SKILL"] = {"Weapon "..SKILL, "Weapon"..SKILL},
	["MAINHAND_WEAPON_RATING"] = {"Main Hand Weapon "..SKILL.." "..RATING, "MH Weapon"..SKILL.." "..RATING},
	["OFFHAND_WEAPON_RATING"] = {"Off Hand Weapon "..SKILL.." "..RATING, "OH Weapon"..SKILL.." "..RATING},
	["RANGED_WEAPON_RATING"] = {"Ranged Weapon "..SKILL.." "..RATING, "Ranged Weapon"..SKILL.." "..RATING},
}
