--ruRU localization by YujiTFD, thehallowedfire
---@class StatLogicLocale
local L = LibStub("AceLocale-3.0"):NewLocale("StatLogic", "ruRU")
if not L then return end
local StatLogic = LibStub("StatLogic")

L["tonumber"] = tonumber
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
	[EMPTY_SOCKET_RED] = {["EMPTY_SOCKET_RED"] = 1}, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = {["EMPTY_SOCKET_YELLOW"] = 1}, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = {["EMPTY_SOCKET_BLUE"] = 1}, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = {["EMPTY_SOCKET_META"] = 1}, -- EMPTY_SOCKET_META = "Meta Socket";

	["Слабое волшебное масло"] = {["SPELL_DMG"] = 8, ["HEAL"] = 8}, -- ID: 20744
	["Простое волшебное масло"] = {["SPELL_DMG"] = 16, ["HEAL"] = 16}, -- ID: 20746
	["Волшебное масло"] = {["SPELL_DMG"] = 24, ["HEAL"] = 24}, -- ID: 20750
	["Блестящее волшебное масло"] = {["SPELL_DMG"] = 36, ["HEAL"] = 36, [StatLogic.Stats.SpellCritRating] = 14}, -- ID: 20749
	["Превосходное волшебное масло"] = {["SPELL_DMG"] = 42, ["HEAL"] = 42}, -- ID: 22522

	["Слабое масло маны"] = {["MANA_REG"] = 4}, -- ID: 20745
	["Простое масло маны"] = {["MANA_REG"] = 8}, -- ID: 20747
	["Блестящее масло маны"] = {["MANA_REG"] = 12, ["HEAL"] = 25}, -- ID: 20748
	["Превосходное масло маны"] = {["MANA_REG"] = 14}, -- ID: 22521

	["Жестокость"] = {["AP"] = 70}, --
	["Живучесть I"] = {["MANA_REG"] = 4, ["HEALTH_REG"] = 4}, -- Enchant Boots - Vitality http://wow.allakhazam.com/db/spell.html?wspell=27948
	["Ледяная душа"] = {["SHADOW_SPELL_DMG"] = 54, ["FROST_SPELL_DMG"] = 54}, --
	["Солнечный огонь"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},
	["+50 к силе заклинаний огня и тайной магии"] = {["ARCANE_SPELL_DMG"] = 50, ["FIRE_SPELL_DMG"] = 50},

	["Небольшое ускорениеускорение бега"] = false, --
	["Небольшое увеличение скорости"] = false, -- Enchant Boots - Minor Speed "Minor Speed Increase" http://wow.allakhazam.com/db/spell.html?wspell=13890
	["Небольшое увеличение скорости и +6 к ловкости"] = {["RUN_SPEED"] = 8, [StatLogic.Stats.Agility] = 6}, -- Enchant Boots - Cat's Swiftness "Minor Speed and +6 Agility" http://wow.allakhazam.com/db/spell.html?wspell=34007
	["Небольшое увеличение скорости и +9 к выносливости"] = {["RUN_SPEED"] = 8, [StatLogic.Stats.Stamina] = 9}, -- Enchant Boots - Boar's Speed "Minor Speed and +9 Stamina"
	["Верный шаг"] = {[StatLogic.Stats.MeleeHitRating] = 10}, -- Enchant Boots - Surefooted "Surefooted" http://wow.allakhazam.com/db/spell.html?wspell=27954

	["Надето: Позволяет дышать под водой."] = false, -- [Band of Icy Depths] ID: 21526
	["Позволяет дышать под водой"] = false, --
	--	["Equip: Immune to Disarm."] = false, -- [Stronghold Gauntlets] ID: 12639 -- Fixed for TBC Classic 2.5.1: no longer immune.
	["Надето: Сокращает время разоружения на 50%."] = false, -- [Stronghold Gauntlets] ID: 12639
	["Сокращает время разоружения на 50%"] = false, --
	["Рыцарь"] = false, -- Enchant Crusader
	["Вампиризм"] = false,
	["Мангуст"] = false, -- Enchant Mongoose
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
-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
L["SingleEquipStatCheck"] = "^Надето: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.?$"
-------------
-- PreScan --
-------------
-- Special cases that need to be dealt with before deep scan
L["PreScanPatterns"] = {
	--["^Equip: Increases attack power by (%d+) in Cat"] = "FERAL_AP",
	["^(%d+) Block$"] = "BLOCK_VALUE",
	["^Броня: (%d+)$"] = "ARMOR",
	["Reinforced %(%+(%d+) Armor%)"] = "ARMOR_BONUS",
	["Восполнение (%d+) ед. маны за 5 сек%.$"] = "MANA_REG",
	["Восполняет (%d+) ед%. здоровья каждые 5 секунд%."] = "HEALTH_REG",
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
	["Weapon Damage"] = {"MELEE_DMG"}, -- Enchant

	["ко всем характеристикам"] = {StatLogic.Stats.AllStats,},
	["к силе"] = {StatLogic.Stats.Strength,},
	["силу цели"] = {StatLogic.Stats.Strength,},
	["к ловкости"] = {StatLogic.Stats.Agility,},
	["к выносливости"] = {StatLogic.Stats.Stamina,},
	["к интеллекту"] = {StatLogic.Stats.Intellect,},
	["к духу"] = {StatLogic.Stats.Spirit,},

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

	["к рыбной ловле"] = false, -- Fishing enchant ID:846
	["рыбная ловля"] = false, -- Equip: Increased Fishing +20. (it actually looks like: Увеличение навыка "Рыбная ловля" на +20)
	["к навыку рыбной ловли"] = false,
	["навык рыбной ловли увеличивается на"] = false,
	["к горному делу"] = false, -- Mining enchant ID:844
	["к травничеству"] = false, -- Heabalism enchant ID:845
	["к снятию шкур"] = false, -- Skinning enchant ID:865

	["броня"] = {"ARMOR_BONUS",},
	["к броне"] = {"ARMOR_BONUS",},
	["защита"] = {StatLogic.Stats.Defense,},
	["Increased Defense"] = {StatLogic.Stats.Defense,},
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
	["увеличивает силу атаки нав облике кошки, медведя, лютого медведя и лунного совуха"] = {"FERAL_AP",},
	["увеличивает силу атаки нав облике кошки"] = {"FERAL_AP",},
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
	["Spell Damage and Healing"] = {"SPELL_DMG", "HEAL",}, --StatLogic:GetSum("item:22630")
	["Spell Damage"] = {"SPELL_DMG", "HEAL",},
	["Increases damage and healing done by magical spells and effects"] = {"SPELL_DMG", "HEAL"},
	["повышает рейтинг критичекого поражения заклинаний всех участников группы в радиусе 30 м. на"] = {"SPELL_DMG", "HEAL"}, -- Atiesh
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

	["Healing Spells"] = {"HEAL",}, -- Enchant Gloves - Major Healing "+35 Healing Spells" http://wow.allakhazam.com/db/spell.html?wspell=33999
	["Increases Healing"] = {"HEAL",},
	["Healing"] = {"HEAL",}, -- StatLogic:GetSum("item:23344:206")
	["healing Spells"] = {"HEAL",},
	["Damage Spells"] = {"SPELL_DMG",}, -- 2.3.0 StatLogic:GetSum("item:23344:2343")
	["Increases healing done"] = {"HEAL",}, -- 2.3.0
	["damage donefor all magical spells"] = {"SPELL_DMG",}, -- 2.3.0
	["Increases healing done by spells and effects"] = {"HEAL",},
	["Increases healing done by magical spells and effects of all party members within 30 yards"] = {"HEAL",}, -- Atiesh
	["your healing"] = {"HEAL",}, -- Atiesh

	["damage per second"] = {"DPS",},
	["Addsdamage per second"] = {"DPS",}, -- [Thorium Shells] ID: 15977

	["Defense Rating"] = {StatLogic.Stats.DefenseRating,},
	["повышает рейтинг защиты на"] = {StatLogic.Stats.DefenseRating,},
	["Dodge Rating"] = {StatLogic.Stats.DodgeRating,},
	["к рейтингу уклонения"] = {StatLogic.Stats.DodgeRating,},
	["увеличивает рейтинг уклонения"] = {StatLogic.Stats.DodgeRating,},
	["увеличивает рейтинг уклонения на"] = {StatLogic.Stats.DodgeRating,},
	["повышает рейтинг уклонения на"] = {StatLogic.Stats.DodgeRating,},
	["Parry Rating"] = {StatLogic.Stats.ParryRating,},
	["повышает рейтинг парирования на"] = {StatLogic.Stats.ParryRating,},
	["Shield Block Rating"] = {StatLogic.Stats.BlockRating,}, -- Enchant Shield - Lesser Block +10 Shield Block Rating http://wow.allakhazam.com/db/spell.html?wspell=13689
	["Block Rating"] = {StatLogic.Stats.BlockRating,},
	["увеличение рейтинга блока наед"] = {StatLogic.Stats.BlockRating,},
	["увеличивает рейтинг блокирования щитом на"] = {StatLogic.Stats.BlockRating,},

	["Improves your chance to hit%"] = {"MELEE_HIT"},
	["Hit Rating"] = {StatLogic.Stats.MeleeHitRating,},
	["повышает меткость"] = {StatLogic.Stats.HitRating,}, -- ITEM_MOD_HIT_RATING
	["меткость в ближнем бою"] = {StatLogic.Stats.MeleeHitRating,}, -- ITEM_MOD_HIT_MELEE_RATING
	["повышает рейтинг меткости"] = {StatLogic.Stats.HitRating,},
	["к рейтингу меткости"] = {StatLogic.Stats.HitRating,},
	["Improves your chance to hit with spells%"] = {"SPELL_HIT"},
	["Spell Hit Rating"] = {StatLogic.Stats.SpellHitRating,},
	["повышает рейтинг меткости на"] = {StatLogic.Stats.HitRating,},
	["Increases your spell hit rating"] = {StatLogic.Stats.SpellHitRating,},
	["Ranged Hit Rating"] = {StatLogic.Stats.RangedHitRating,},
	["Improves ranged hit rating"] = {StatLogic.Stats.RangedHitRating,}, -- ITEM_MOD_HIT_RANGED_RATING
	["Increases your ranged hit rating"] = {StatLogic.Stats.RangedHitRating,},

	["Improves your chance to get a critical strike by%"] = {StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit},
	["Crit Rating"] = {StatLogic.Stats.CritRating,},
	["Critical Rating"] = {StatLogic.Stats.CritRating,},
	["рейтинг критического удара"] = {StatLogic.Stats.CritRating,},
	["Increases your critical hit rating"] = {StatLogic.Stats.CritRating,},
	["Increases your critical strike rating"] = {StatLogic.Stats.CritRating,},
	["повышает рейтинг критического удара на"] = {StatLogic.Stats.CritRating,},
	["Improves melee critical strike rating"] = {StatLogic.Stats.MeleeCritRating,}, -- [Cloak of Darkness] ID:33122
	["Improves your chance to get a critical strike with spells%"] = {StatLogic.Stats.SpellCrit},
	["Spell Critical Strike Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Critical Rating"] = {StatLogic.Stats.SpellCritRating,},
	["Spell Crit Rating"] = {StatLogic.Stats.SpellCritRating,},
	["к рейтингу критического удара"] = {StatLogic.Stats.SpellCritRating,}, -- TBC Chaotic Skyfire Diamond
	["Increases your spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases the spell critical strike rating of all party members within 30 yards"] = {StatLogic.Stats.SpellCritRating,},
	["Improves spell critical strike rating"] = {StatLogic.Stats.SpellCritRating,},
	["Increases your ranged critical strike rating"] = {StatLogic.Stats.RangedCritRating,}, -- Fletcher's Gloves ID:7348

	["устойчивость"] = {StatLogic.Stats.ResilienceRating,},
	["рейтинг устойчивости"] = {StatLogic.Stats.ResilienceRating,}, -- Enchant Chest - Major Resilience "+15 Resilience Rating" http://wow.allakhazam.com/db/spell.html?wspell=33992
	["повышает рейтинг устойчивости на"] = {StatLogic.Stats.ResilienceRating,},
	["к рейтингу устойчивости"] = {StatLogic.Stats.ResilienceRating,},

	["Haste Rating"] = {StatLogic.Stats.HasteRating},
	["к рейтингу скорости"] = {StatLogic.Stats.HasteRating}, -- (added this line)
	["Ranged Haste Rating"] = {StatLogic.Stats.HasteRating},
	["повышает рейтинг скорости боя на"] = {StatLogic.Stats.HasteRating},
	["Spell Haste Rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves melee haste rating"] = {StatLogic.Stats.MeleeHasteRating},
	["Improves spell haste rating"] = {StatLogic.Stats.SpellHasteRating},
	["Improves ranged haste rating"] = {StatLogic.Stats.RangedHasteRating},

	["рейтинг мастерства"] = {StatLogic.Stats.ExpertiseRating},
	["к рейтингу мастерства"] = {StatLogic.Stats.ExpertiseRating},
	["повышает рейтинг мастерства на"] = {StatLogic.Stats.ExpertiseRating},
	["Повышает рейтинг пробивания брони на"] = {StatLogic.Stats.ArmorPenetrationRating},
	["увеличивает рейтинг пробивания брони на"] = {StatLogic.Stats.ArmorPenetrationRating},
	["снижает эффективность брони противника против ваших атак на"] = {StatLogic.Stats.ArmorPenetrationRating},

	-- Exclude
	["sec"] = false,
	["to"] = false,
	["Slot Bag"] = false,
	["Slot Quiver"] = false,
	["Slot Ammo Pouch"] = false,
	["Increases ranged attack speed"] = false, -- AV quiver
	["на 3% увеличенный критический урон"] = false, -- Chaotic Skyflare Diamond second effect
}