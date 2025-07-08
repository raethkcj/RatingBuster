--[[
Name: RatingBuster zhTW locale
Revision: $Revision: 73696 $
Translated by:
- Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
- CuteMiyu
- 小紫
- mcc
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "zhTW")
if not L then return end
addon.S = {}
local S = addon.S
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L["RatingBuster Options"] = "屬性轉換選項"
---------------------------
-- Slash Command Options --
---------------------------
-- /rb optionswin
L["Options Window"] = "選項視窗"
L["Shows the Options Window"] = "顯示選項視窗"
-- /rb statmod
L["Enable Stat Mods"] = "屬性加成"
L["Enable support for Stat Mods"] = "啟用屬性加成計算"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "啟用迴避遞減效應"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "你的閃避、招架、避免命中值會被計算在迴避遞減效應中"
-- /rb itemid
L["Show ItemID"] = "顯示物品編號"
L["Show the ItemID in tooltips"] = "顯示物品編號"
-- /rb itemlevel
L["Show ItemLevel"] = "顯示物品等級"
L["Show the ItemLevel in tooltips"] = "顯示物品等級"
-- /rb usereqlv
L["Use required level"] = "使用需要等級"
L["Calculate using the required level if you are below the required level"] = "如果你的等級低於需要等級則用需要等級來換算"
-- /rb setlevel
L["Set level"] = "設定換算等級"
L["Set the level used in calculations (0 = your level)"] = "設定換算等級 (0 = 你的目前的等級)"
-- /rb color
L["Change text color"] = "設定文字顏色"
L["Changes the color of added text"] = "設定 RB 所增加的文字的顏色"
L["Change number color"] = "Change number color"
-- /rb rating
L["Rating"] = "屬性等級"
L["Options for Rating display"] = "設定屬性等級顯示"
-- /rb rating show
L["Show Rating conversions"] = "顯示屬性等級轉換"
L["Show Rating conversions in tooltips"] = "在提示框架中顯示屬性等級轉換結果"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
-- /rb rating spell
L["Show Spell Hit/Haste"] = "顯示法術命中/加速"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "顯示命中/加速給的法術命中/加速"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "顯示物理命中/加速"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "顯示命中/加速給的物理命中/加速"
-- /rb rating detail
L["Show detailed conversions text"] = "顯示詳細轉換文字"
L["Show detailed text for Resilience and Expertise conversions"] = "顯示韌性和熟練技能的詳細轉換文字"
-- /rb rating def
L["Defense breakdown"] = "分析防禦"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "將防禦分為避免致命、避免命中、閃躲、招架和格擋"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "分析武器技能"
L["Convert Weapon Skill into Crit Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "將武器技能分為致命、擊中、防止被閃躲、防止被招架和防止被格擋"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "分析熟練技能"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "將熟練技能分為防止被閃躲、防止被招架"

-- /rb stat
L["Stat Breakdown"] = "基本屬性解析"
L["Changes the display of base stats"] = "設定基本屬性的解析顯示"
-- /rb stat show
L["Show base stat conversions"] = "顯示基本屬性解析"
L["Show base stat conversions in tooltips"] = "在物品提示中顯示基本屬性解析"
L["Changes the display of %s"] = "自訂%s解析項目"

-- /rb sum
L["Stat Summary"] = "屬性統計"
L["Options for stat summary"] = "自訂屬性選項"
L["Sum %s"] = "統計%s"
-- /rb sum show
L["Show stat summary"] = "顯示屬性統計"
L["Show stat summary in tooltips"] = "在物品提示中顯示屬性統計"
-- /rb sum ignore
L["Ignore settings"] = "忽略設定"
L["Ignore stuff when calculating the stat summary"] = "設定在統計總合時所要忽略的項目"
-- /rb sum ignore unused
L["Ignore unused item types"] = "忽略不可能使用的物品"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "只顯示在你會使用的物品上"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "忽略已裝備的物品"
L["Hide stat summary for equipped items"] = "隱藏已裝備的物品的統計總合"
-- /rb sum ignore enchant
L["Ignore enchants"] = "忽略附魔"
L["Ignore enchants on items when calculating the stat summary"] = "計算時忽略物品上的附魔效果"
-- /rb sum ignore gem
L["Ignore gems"] = "忽略寶石"
L["Ignore gems on items when calculating the stat summary"] = "計算時忽略物品上的寶石效果"
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
-- /rb sum diffstyle
L["Display style for diff value"] = "差異值顯示方式"
L["Display diff values in the main tooltip or only in compare tooltips"] = "設定在主提示框架或只在比較框架中顯示差異值"
L["Hide Blizzard Item Comparisons"] = "隱藏內建的物品比較"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "觀看內建的已裝備物品提示時不顯示內建的物品比較功能"
-- /rb sum space
L["Add empty line"] = "加入空白列"
L["Add a empty line before or after stat summary"] = "在物品提示中的屬性統計前或後加入空白列"
-- /rb sum space before
L["Add before summary"] = "加在統計前"
L["Add a empty line before stat summary"] = "在物品提示中的屬性統計前加入空白列"
-- /rb sum space after
L["Add after summary"] = "加在統計後"
L["Add a empty line after stat summary"] = "在物品提示中的屬性統計後加入空白列"
-- /rb sum icon
L["Show icon"] = "顯示圖示"
L["Show the sigma icon before stat summary"] = "在屬性統計前顯示圖示"
-- /rb sum title
L["Show title text"] = "顯示標題"
L["Show the title text before stat summary"] = "在屬性統計前顯示標題文字"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
-- /rb sum showzerostat
L["Show zero value stats"] = "顯示數值為 0 的屬性"
L["Show zero value stats in summary for consistancy"] = "為了一致性，在統計中顯示數值為 0 的屬性"
-- /rb sum calcsum
L["Calculate stat sum"] = "計算統計總合"
L["Calculate the total stats for the item"] = "計算物品的統計總合"
-- /rb sum calcdiff
L["Calculate stat diff"] = "計算統計差異"
L["Calculate the stat difference for the item and equipped items"] = "計算物品和已裝備物品的統計差異"
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "依字幕順序排列屬性統計"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "開啟時依字幕順序排列，關閉時依屬性種類排列(基本、物理、魔法、坦克)"
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "傷害迴避包含格檔率"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "開啟時傷害迴避包含格檔率，關閉時有閃躲、招架、未擊中"
-- /rb sum basic
L["Stat - Basic"] = "統計基本屬性"
L["Choose basic stats for summary"] = "自訂基本屬性統計項目"
-- /rb sum physical
L["Stat - Physical"] = "統計物理屬性"
L["Choose physical damage stats for summary"] = "自訂物理傷害屬性統計項目"
-- /rb sum spell
L["Stat - Spell"] = "統計魔法屬性"
L["Choose spell damage and healing stats for summary"] = "自訂魔法傷害及治療屬性統計項目"
-- /rb sum tank
L["Stat - Tank"] = "統計坦克屬性"
L["Choose tank stats for summary"] = "自訂坦克屬性統計項目"
-- /rb sum stat hp
L["Health <- Health Stamina"] = "生命力 ← 生命力、耐力"
-- /rb sum stat mp
L["Mana <- Mana Intellect"] = "法力 ← 法力、智力"
-- /rb sum stat ap
L["Attack Power <- Attack Power Strength, Agility"] = "攻擊強度 ← 攻擊強度、力量、敏捷"
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "遠程攻擊強度 ← 遠程攻擊強度、智力、攻擊強度、力量、敏捷"
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "法術傷害 ← 法術傷害、智力、精神、耐力"
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "神聖法術傷害 ← 神聖法術傷害、法術傷害、智力、精神"
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "秘法法術傷害 ← 秘法法術傷害、法術傷害、智力"
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "火焰法術傷害 ← 火焰法術傷害、法術傷害、智力、耐力"
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "自然法術傷害 ← 自然法術傷害、法術傷害、智力"
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "冰霜法術傷害 ← 冰霜法術傷害、法術傷害、智力"
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "暗影法術傷害 ← 暗影法術傷害、法術傷害、智力、精神、耐力"
-- /rb sum stat heal
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "治療 ← 治療、智力、精神、敏捷、力量"
-- /rb sum stat hit
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "命中機率 ← 命中等級、武器技能等級"
-- /rb sum stat crit
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "致命一擊機率 ← 致命一擊等級、敏捷、武器技能等級"
-- /rb sum stat haste
L["Haste <- Haste Rating"] = "加速 ← 加速等級"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "遠程命中機率 ← 命中等級、武器技能等級、遠程命中等級"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "遠程致命一擊機率 ← 致命一擊等級、敏捷、武器技能等級、遠程致命一級等級"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "遠程加速 ← 加速等級、遠程加速等級"

-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "法術致命一擊機率 ← 法術致命一擊等級、智力"
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = "法術命中機率 ← 法術命中機率"
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = "法術加速 ← 法術加速等級"
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen Spirit"] = "法力恢復 ← 法力恢復、精神"
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = "法力恢復 (未施法時) ← 精神"
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = "生命恢復 ← 生命恢復"
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = "生命恢復 (未戰鬥時) ← 精神"
-- /rb sum stat armor
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "裝甲值 ← 物品裝甲、裝甲加成、敏捷、智力"
-- /rb sum stat blockvalue
L["Block Value <- Block Value Strength"] = "格擋值 ← 格擋值、力量"
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "閃躲機率 ← 閃躲等級、敏捷、防禦等級"
-- /rb sum stat parry
L["Parry Chance <- Parry Rating Defense Rating"] = "招架機率 ← 招架等級、防禦等級"
-- /rb sum stat block
L["Block Chance <- Block Rating Defense Rating"] = "格擋機率 ← 格擋等級、防禦等級"
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = "迴避命中 ← 防禦等級"
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating Resilience"] = "迴避致命一擊 ← 防禦等級、韌性"
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "防止被閃躲 ← 熟練技能、武器技能等級" -- 2.3.0
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "防止被招架 ← 熟練技能、武器技能等級" -- 2.3.0

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = "防禦 ← 防禦等級"
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = "武器技能 ← 武器技能等級"
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = "熟練技能 ← 熟練等級"
-- /rb sum statcomp avoid
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "傷害迴避 ← 閃躲、招架、怪物未擊中、格擋(選項)"
-- /rb sum gem
L["Gems"] = "預設寶石"
L["Auto fill empty gem slots"] = "空寶石插槽的預設寶石"
-- /rb sum gem red
L["ItemID or Link of the gem you would like to auto fill"] = "預設寶石的物品編號或連結"
L["<ItemID|Link>"] = "<物品編號|連結>"
L["%s is now set to %s"] = "%s 現在被設定為 %s"
L["Queried server for Gem: %s. Try again in 5 secs."] = "嘗試查詢編號：%s，請5秒後再試一次。"

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "物品等級: "
L["ItemID: "] = "物品編號: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = "指定常駐buff，就算身上沒有buff，RatingBuster也會當成有來計算"
L["$class Self Buffs"] = "$class個人Buff"
L["Raid Buffs"] = "團隊Buff"
L["Stat Multiplier"] = "總屬性提高%"
L["Attack Power Multiplier"] = "攻擊強度提高%"
L["Reduced Physical Damage Taken"] = "物理傷害減少%"

L["Swap Profiles"] = "Swap Profiles"
L["Swap Profile Keybinding"] = "Swap Profile Keybinding"
L["Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."] = "Use a keybind to swap between Primary and Secondary Profiles.\n\nIf \"Enable spec profiles\" is enabled, will use the Primary and Secondary Talents profiles, and will preview items with that spec's talents, glyphs, and passives.\n\nYou can re-use an existing keybind! It will only be used for RatingBuster when an item tooltip is shown."
L["Primary Profile"] = "Primary Profile"
L["Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."] = "Select the primary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Primary Talents profile."
L["Secondary Profile"] = "Secondary Profile"
L["Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."] = "Select the secondary profile for use with the swap profile keybind. If spec profiles are enabled, this will instead use the Secondary Talents profile."

-----------------------
-- Matching Patterns --
-----------------------
-- Items to check --
--------------------
-- [Potent Ornate Topaz]
-- +6 Spell Damage, +5 Spell Crit Rating
--------------------
-- ZG enchant
-- +10 Defense Rating/+10 Stamina/+15 Block Value
--------------------
-- [Glinting Flam Spessarite]
-- +3 Hit Rating and +3 Agility
--------------------
-- ItemID: 22589
-- [Atiesh, Greatstaff of the Guardian] warlock version
-- Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.
--------------------
-- [Brilliant Wizard Oil]
-- Use: While applied to target weapon it increases spell damage by up to 36 and increases spell critical strike rating by 14 . Lasts for 30 minutes.
----------------------------------------------------------------------------------------------------
-- I redesigned the tooltip scanner using a more locale friendly, 2 pass matching matching algorithm.
--
-- The first pass searches for the rating number, the patterns are read from ["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from ["statList"] here,
-- It will look through the table in order, so you can put common strings at the begining to speed up the search,
-- and longer strings should be listed first, like "spell critical strike" should be listed before "critical strike",
-- this way "spell critical strike" does get matched by "critical strike".
-- Strings need to be in lower case letters, because string.lower is called on lookup
--
-- IMPORTANT: there may not exist a one-to-one correspondence, meaning you can't just translate this file,
-- but will need to go in game and find out what needs to be put in here.
-- For example, in english I found 3 different strings that maps to StatLogic.Stats.MeleeCritRating: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents StatLogic.Stats.MeleeCritRating, and so on.
-- In other languages there may be 5 different strings that should all map to StatLogic.Stats.MeleeCritRating.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
addon.numberPattern = addon.numberPattern .. "\233?\187?\158?" -- 點
L["numberPatterns"] = {
	"提高" .. addon.numberPattern,
	addon.numberPattern,
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}

L["separators"] = {
	"/", "和", ",%f[^%d]", "。", " 持續 ", "&", "及", "並", "，", "\n"
}

--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{SPELL_STAT1_NAME:lower(), StatLogic.Stats.Strength},
	{SPELL_STAT2_NAME:lower(), StatLogic.Stats.Agility},
	{SPELL_STAT3_NAME:lower(), StatLogic.Stats.Stamina},
	{SPELL_STAT4_NAME:lower(), StatLogic.Stats.Intellect},
	{SPELL_STAT5_NAME:lower(), StatLogic.Stats.Spirit},
	{"防禦等級", StatLogic.Stats.DefenseRating},
	{DEFENSE:lower(), StatLogic.Stats.Defense},
	{"閃躲等級", StatLogic.Stats.DodgeRating},
	{"閃躲", StatLogic.Stats.DodgeRating},
	{"格擋等級", StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{"格擋", StatLogic.Stats.BlockRating},
	{"招架等級", StatLogic.Stats.ParryRating},
	{"招架", StatLogic.Stats.ParryRating},

	{"法術能量", StatLogic.Stats.SpellPower},
	{"法術致命一擊等級", StatLogic.Stats.SpellCritRating},
	{"遠程攻擊致命一擊等級", StatLogic.Stats.RangedCritRating},
	{"致命一擊等級", StatLogic.Stats.CritRating},
	{"致命一擊", StatLogic.Stats.CritRating},

	{"法術命中等級", StatLogic.Stats.SpellHitRating},
	{"遠程命中等級", StatLogic.Stats.RangedHitRating},
	{"命中等級", StatLogic.Stats.HitRating},
	{"命中", StatLogic.Stats.HitRating},

	{"韌性", StatLogic.Stats.ResilienceRating},
	{ITEM_MOD_PVP_POWER_SHORT:lower(), StatLogic.Stats.PvpPowerRating},

	{"法術加速等級", StatLogic.Stats.SpellHasteRating},
	{"遠程攻擊加速等級", StatLogic.Stats.RangedHasteRating},
	{"加速等級", StatLogic.Stats.HasteRating},
	{"加速", StatLogic.Stats.HasteRating},
	{"攻擊速度等級", StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{"熟練等級", StatLogic.Stats.ExpertiseRating},
	{"熟練", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"護甲穿透等級", StatLogic.Stats.ArmorPenetrationRating},
	{"精通", StatLogic.Stats.MasteryRating},
	{ARMOR:lower(), StatLogic.Stats.Armor},
	{"攻击强度", StatLogic.Stats.AttackPower},
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["Show %s"] = SHOW.." %s"
L["Show Modified %s"] = "Show Modified %s"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["Spell"] = "法術"

-- Basic Attributes
L[StatLogic.Stats.Strength] = "力量"
L[StatLogic.Stats.Agility] = "敏捷"
L[StatLogic.Stats.Stamina] = "耐力"
L[StatLogic.Stats.Intellect] = "智力"
L[StatLogic.Stats.Spirit] = "精神"
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.MasteryRating] = STAT_MASTERY.."等級"

-- Resources
L[StatLogic.Stats.Health] = "生命力"
S[StatLogic.Stats.Health] = "生命"
L[StatLogic.Stats.Mana] = "法力"
S[StatLogic.Stats.Mana] = "法力"
L[StatLogic.Stats.ManaRegen] = "法力恢復"
S[StatLogic.Stats.ManaRegen] = "施法回魔"

local ManaRegenOutOfCombat = "法力恢復 (非戰鬥)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "法力恢復 (非施法)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "一般回魔"

L[StatLogic.Stats.HealthRegen] = "生命恢复"
S[StatLogic.Stats.HealthRegen] = "回血"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "生命恢复 (非戰鬥)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "一般回血"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "攻擊強度"
S[StatLogic.Stats.AttackPower] = "強度"
L[StatLogic.Stats.FeralAttackPower] = " 野性攻擊強度"
L[StatLogic.Stats.IgnoreArmor] = "無視護甲"
L[StatLogic.Stats.ArmorPenetration] = "護甲穿透"
L[StatLogic.Stats.ArmorPenetrationRating] = "護甲穿透等級"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "近戰傷害" -- DAMAGE = "Damage"
L[StatLogic.Stats.WeaponDPS] = "每秒傷害"

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "命中機率"
L[StatLogic.Stats.MeleeHitRating] = "命中等級"
L[StatLogic.Stats.MeleeCrit] = "致命一擊機率"
S[StatLogic.Stats.MeleeCrit] = "致命"
L[StatLogic.Stats.MeleeCritRating] = "致命等級"
L[StatLogic.Stats.MeleeHaste] = "加速"
L[StatLogic.Stats.MeleeHasteRating] = "加速等級"

L[StatLogic.Stats.WeaponSkill] = "武器技能"
L[StatLogic.Stats.Expertise] = "熟練"
L[StatLogic.Stats.ExpertiseRating] = "熟練等級"
L[StatLogic.Stats.DodgeReduction] = "防止被閃躲"
S[StatLogic.Stats.DodgeReduction] = "被閃躲"
L[StatLogic.Stats.ParryReduction] = "防止被招架"
S[StatLogic.Stats.ParryReduction] = "被招架"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "遠程攻擊強度"
S[StatLogic.Stats.RangedAttackPower] = "遠程強度"
L[StatLogic.Stats.RangedHit] = "遠程命中機率"
L[StatLogic.Stats.RangedHitRating] = "遠程命中等級"
L[StatLogic.Stats.RangedCrit] = "遠程致命一級機率"
L[StatLogic.Stats.RangedCritRating] = "遠程致命等級"
L[StatLogic.Stats.RangedHaste] = "遠程加速"
L[StatLogic.Stats.RangedHasteRating] = "遠程加速等級"

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "法術傷害"
S[StatLogic.Stats.SpellDamage] = "法傷"
L[StatLogic.Stats.HealingPower] = "治療"
S[StatLogic.Stats.HealingPower] = "治療"
L[StatLogic.Stats.SpellPenetration] = "法術穿透"

L[StatLogic.Stats.HolyDamage] = "神聖法術傷害"
L[StatLogic.Stats.FireDamage] = "火焰法術傷害"
L[StatLogic.Stats.NatureDamage] = "自然法術傷害"
L[StatLogic.Stats.FrostDamage] = "冰霜法術傷害"
L[StatLogic.Stats.ShadowDamage] = "暗影法術傷害"
L[StatLogic.Stats.ArcaneDamage] = "秘法法術傷害"

L[StatLogic.Stats.SpellHit] = "法術命中機率"
S[StatLogic.Stats.SpellHit] = "法術命中"
L[StatLogic.Stats.SpellHitRating] = "法術命中等級"
L[StatLogic.Stats.SpellCrit] = "法術致命一擊機率"
S[StatLogic.Stats.SpellCrit] = "法術致命"
L[StatLogic.Stats.SpellCritRating] = "法術致命等級"
L[StatLogic.Stats.SpellHaste] = "法術加速"
L[StatLogic.Stats.SpellHasteRating] = "法術加速等級"

-- Tank Stats
L[StatLogic.Stats.Armor] = "裝甲值"
S[StatLogic.Stats.Armor] = "裝甲"

L[StatLogic.Stats.Avoidance] = "傷害迴避"
L[StatLogic.Stats.Dodge] = "閃躲機率"
S[StatLogic.Stats.Dodge] = "閃躲"
L[StatLogic.Stats.DodgeRating] = "閃躲等級"
L[StatLogic.Stats.Parry] = "招架機率"
S[StatLogic.Stats.Parry] = "招架"
L[StatLogic.Stats.ParryRating] = "招架等級"
L[StatLogic.Stats.BlockChance] = "格擋機率"
L[StatLogic.Stats.BlockRating] = "格檔等級"
L[StatLogic.Stats.BlockValue] = "格擋值"
S[StatLogic.Stats.BlockValue] = "格擋值"
L[StatLogic.Stats.Miss] = "迴避命中"

L[StatLogic.Stats.Defense] = "防禦"
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = "迴避致命一擊"
S[StatLogic.Stats.CritAvoidance] = "被致命"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "韌性"
L[StatLogic.Stats.CritDamageReduction] = "致命傷害減免"
S[StatLogic.Stats.CritDamageReduction] = "致命減傷"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Taken"

L[StatLogic.Stats.FireResistance] = "火焰抗性"
L[StatLogic.Stats.NatureResistance] = "自然抗性"
L[StatLogic.Stats.FrostResistance] = "冰霜抗性"
L[StatLogic.Stats.ShadowResistance] = "暗影抗性"
L[StatLogic.Stats.ArcaneResistance] = "秘法抗性"