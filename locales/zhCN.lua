--[[
Name: RatingBuster zhCN locale
Revision: $Revision: 73696 $
Translated by:
- iceburn
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "zhCN")
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
L["RatingBuster Options"] = "RatingBuster选项"
---------------------------
-- Slash Command Options --
---------------------------
-- /rb optionswin
L["Options Window"] = "选项窗口"
L["Shows the Options Window"] = "打开选项窗口"
-- /rb statmod
L["Enable Stat Mods"] = "属性加成"
L["Enable support for Stat Mods"] = "启用属性加成计算"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "开启回避递减效应"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "你的闪避、招架、避免命中值会被计算在回避递减效应中"
-- /rb itemid
L["Show ItemID"] = "显示物品编号"
L["Show the ItemID in tooltips"] = "显示物品编号"
-- /rb itemlevel
L["Show ItemLevel"] = "显示物品等级"
L["Show the ItemLevel in tooltips"] = "显示物品等级"
-- /rb usereqlv
L["Use required level"] = "使用需要等级"
L["Calculate using the required level if you are below the required level"] = "如果你的等级低于需要等级则用需要等级来换算"
-- /rb setlevel
L["Set level"] = "设定换算等级"
L["Set the level used in calculations (0 = your level)"] = "设定换算等级 (0 = 你的目前的等级)"
-- /rb color
L["Change text color"] = "设定文字颜色"
L["Changes the color of added text"] = "设定RB所增加的文字的颜色"
L["Change number color"] = "Change number color"
-- /rb rating
L["Rating"] = "属性等级"
L["Options for Rating display"] = "设定属性等级显示"
-- /rb rating show
L["Show Rating conversions"] = "显示属性等级转换"
L["Show Rating conversions in tooltips"] = "在提示框架中显示属性等级转换结果"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
-- /rb rating spell
L["Show Spell Hit/Haste"] = "显示法术命中/急速"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "显示命中/急速等级给的法术命中/急速加成"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "显示物理命中"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "显示命中/急速等级给的物理命中/急速加成"
-- /rb rating detail
L["Show detailed conversions text"] = "显示详细转换文本"
L["Show detailed text for Resilience and Expertise conversions"] = "显示详细的抗性和精准等级转换"
-- /rb rating def
L["Defense breakdown"] = "分析防御"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "将防御分为避免爆击、避免击中、躲闪、招架和格挡"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "分析武器技能"
L["Convert Weapon Skill into Crit Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "加武器技能分为爆击、击中、防止被躲闪、防止被招架和防止被格挡"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "精准效能"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "转换精准等级为忽略躲闪和忽略招架"

-- /rb stat
L["Stat Breakdown"] = "基本属性解析"
L["Changes the display of base stats"] = "设定基本属性的解析显示"
-- /rb stat show
L["Show base stat conversions"] = "显示基本属性解析"
L["Show base stat conversions in tooltips"] = "在物品提示中显示基本属性解析"
L["Changes the display of %s"] = "自订%s解析项目"

-- /rb sum
L["Stat Summary"] = "属性统计"
L["Options for stat summary"] = "自订属性选项"
L["Sum %s"] = "统计%s"
-- /rb sum show
L["Show stat summary"] = "显示属性统计"
L["Show stat summary in tooltips"] = "在物品提示中显示属性统计"
-- /rb sum ignore
L["Ignore settings"] = "忽略设定"
L["Ignore stuff when calculating the stat summary"] = "设定在统计总合时所要忽略的事项"
-- /rb sum ignore unused
L["Ignore unused item types"] = "忽略不可能使用的物品"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "只显示在你会使用的物品上"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "忽略已装备的物品"
L["Hide stat summary for equipped items"] = "隐藏已装备的物品的统计总合"
-- /rb sum ignore enchant
L["Ignore enchants"] = "忽略附魔"
L["Ignore enchants on items when calculating the stat summary"] = "计算时忽略物品上的附魔效果"
-- /rb sum ignore gem
L["Ignore gems"] = "忽略宝石"
L["Ignore gems on items when calculating the stat summary"] = "计算时忽略物品上的宝石效果"
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
-- /rb sum diffstyle
L["Display style for diff value"] = "差异值显示方式"
L["Display diff values in the main tooltip or only in compare tooltips"] = "设定在主提示框架或只在比较框架中显示差异值"
L["Hide Blizzard Item Comparisons"] = "隱藏內建的物品比較"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "觀看內建的已裝備物品提示時不顯示內建的物品比較功能"
-- /rb sum space
L["Add empty line"] = "加入空白列"
L["Add a empty line before or after stat summary"] = "在物品提示中的属性统计前或后加入空白列"
-- /rb sum space before
L["Add before summary"] = "加在统计前"
L["Add a empty line before stat summary"] = "在物品提示中的属性统计前加入空白列"
-- /rb sum space after
L["Add after summary"] = "加在统计后"
L["Add a empty line after stat summary"] = "在物品提示中的属性统计后加入空白列"
-- /rb sum icon
L["Show icon"] = "显示图示"
L["Show the sigma icon before stat summary"] = "在属性统计前显示图示"
-- /rb sum title
L["Show title text"] = "显示标题"
L["Show the title text before stat summary"] = "在属性统计前显示标题文字"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
-- /rb sum showzerostat
L["Show zero value stats"] = "显示数值为0的属性"
L["Show zero value stats in summary for consistancy"] = "为了一致性，在统计中显示数值为0的属性"
-- /rb sum calcsum
L["Calculate stat sum"] = "计算总和统计"
L["Calculate the total stats for the item"] = "计算物品的总和统计"
-- /rb sum calcdiff
L["Calculate stat diff"] = "计算差异统计"
L["Calculate the stat difference for the item and equipped items"] = "计算物品和已装备物品的统计差异"
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "按照字母排序"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "启用以按照字母顺序排列，禁用按照属性类型排列(基础、物理、法术、抵抗……)"
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "在躲避统计中显示格挡几率"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "启用该选项后将在躲避统计中加入格挡几率，禁用将仅显示躲闪，招架，未击中"
-- /rb sum basic
L["Stat - Basic"] = "属性 - 基本"
L["Choose basic stats for summary"] = "选择想要统计的基本属性"
-- /rb sum physical
L["Stat - Physical"] = "属性 - 物理"
L["Choose physical damage stats for summary"] = "选择想要统计的物理攻击属性"
-- /rb sum spell
L["Stat - Spell"] = "属性 - 法术"
L["Choose spell damage and healing stats for summary"] = "选择想要统计的法术攻击和治疗的属性"
-- /rb sum tank
L["Stat - Tank"] = "属性 - 抗打击"
L["Choose tank stats for summary"] = "选择你想要统计的抗打击能力的属性"
-- /rb sum stat hp
L["Health <- Health Stamina"] = "生命值 ← 生命值、耐力"
-- /rb sum stat mp
L["Mana <- Mana Intellect"] = "法力值 ← 法力值、智力"
-- /rb sum stat ap
L["Attack Power <- Attack Power Strength, Agility"] = "近战攻击强度 ← 攻击强度、力量、敏捷"
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "远程攻击强度 ← 远程攻击强度、智力、攻击强度、力量、敏捷"
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "法术伤害 ← 法术伤害、智力、精神、耐力"
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "神圣法术伤害 ← 神圣法术伤害、法术伤害、智力、精神"
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "奥术法术伤害 ← 奥术法术伤害、法术伤害、智力"
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "火焰法术伤害 ← 火焰法术伤害、法术伤害、智力、耐力"
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "自然法术伤害 ← 自然法术伤害、法术伤害、智力"
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "冰霜法术伤害 ← 冰霜法术伤害、法术伤害、智力"
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "暗影法术伤害 ← 暗影法术伤害、法术伤害、智力、精神、耐力"
-- /rb sum stat heal
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "治疗 ← 治疗、智力、精神、敏捷、力量"
-- /rb sum stat hit
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "物理命中几率 ← 命中等级、武器技能等级"
-- /rb sum stat crit
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "物理爆击几率 ← 爆击等级、敏捷、武器技能等级"
-- /rb sum stat haste
L["Haste <- Haste Rating"] = "急速 ← 急速等级"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "远程米中几率 ← 命中等级、武器技能等级、远程命中等级"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "远程爆击几率 ← 爆击等级、敏捷、武器技能等级、远程爆击等级"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "远程急速 ← 急速等级、远程急速等级"

-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "法术爆击几率 ← 法术爆击等级、智力"
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = "法术命中几率 ← 法术命中等级"
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = "法术急速 ← 法术急速等级"
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen Spirit"] = "法力恢复 ← 法力恢复、精神"
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = "法力恢复(未施法时) ← 精神"
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = "生命恢复 ← 生命恢复"
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = "生命恢复(未战斗时) ← 精神"
-- /rb sum stat armor
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "护甲值 ← 物品护甲、护甲加成、敏捷、智力"
-- /rb sum stat blockvalue
L["Block Value <- Block Value Strength"] = "格挡值 ← 格挡值、力量"
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "躲闪几率 ← 躲闪等级、敏捷、防御等级"
-- /rb sum stat parry
L["Parry Chance <- Parry Rating Defense Rating"] = "招架几率 ← 招架等级、防御等级"
-- /rb sum stat block
L["Block Chance <- Block Rating Defense Rating"] = "格挡几率 ← 格挡等级、防御等级"
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = "物理命中躲闪 ← 防御等级"
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating Resilience"] = "物理爆击躲闪 ← 防御等级、韧性"
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "防止被躲闪 ← 精准等级、武器技能等级" -- 2.3.0
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "防止被招架 ← 精准等级、武器技能等级" -- 2.3.0

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = "防御 ← 防御等级"
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = "武器技能 ← 武器技能等级"
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = "精准 ← 精准等级"
-- /rb sum statcomp avoid
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "躲避 ← 躲闪, 招架, 怪物未命中, 格挡(可选)"
-- /rb sum gem
L["Gems"] = "宝石"
L["Auto fill empty gem slots"] = "自动填充空宝石位"
L["ItemID or Link of the gem you would like to auto fill"] = "你想要填充该空格位的物品ID或者链接"
L["<ItemID|Link>"] = "<物品ID|链接>"
L["%s is now set to %s"] = "%s现在被放置于%s"
L["Queried server for Gem: %s. Try again in 5 secs."] = "对服务器查询宝石: %s。将会在5秒后重试。"

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "物品等级: "
L["ItemID: "] = "物品编号: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = "指定常驻buff，就算身上没有buff，RatingBuster也会当成有来计算"
L["$class Self Buffs"] = "$class个人Buff"
L["Raid Buffs"] = "团队Buff"
L["Stat Multiplier"] = "Stat Multiplier"
L["Attack Power Multiplier"] = "Attack Power Multiplier"
L["Reduced Physical Damage Taken"] = "Reduced Physical Damage Taken"

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
L["numberPatterns"] = {
	"提高" .. addon.numberPattern .. "点",
	"提高" .. addon.numberPattern,
	addon.numberPattern .. "点",
	addon.numberPattern,
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}

L["separators"] = {
	"/", "和", ",%f[^%d]", "。", " 持续 ", "&", "及", "并", "，","、", "\n"
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
	{"防御等级", StatLogic.Stats.DefenseRating},
	{DEFENSE:lower(), StatLogic.Stats.Defense},
	{"躲闪等级", StatLogic.Stats.DodgeRating},
	{"躲闪", StatLogic.Stats.DodgeRating},
	{"格挡等级", StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{"格挡", StatLogic.Stats.BlockRating},
	{"招架等级", StatLogic.Stats.ParryRating},
	{"招架", StatLogic.Stats.ParryRating},

	{"法术强度", StatLogic.Stats.SpellPower},
	{"法术爆击等级", StatLogic.Stats.SpellCritRating},
	{"法术爆击命中等级", StatLogic.Stats.SpellCritRating},
	{"法术爆击等级", StatLogic.Stats.SpellCritRating},
	{"远程爆击等级", StatLogic.Stats.RangedCritRating},
	{"远程爆击命中等级", StatLogic.Stats.RangedCritRating},
	{"远程爆击等级", StatLogic.Stats.RangedCritRating},
	{"近战爆击等级", StatLogic.Stats.MeleeCritRating},
	{"爆击等级", StatLogic.Stats.CritRating},
	{"爆击", StatLogic.Stats.CritRating},

	{"法术命中等级", StatLogic.Stats.SpellHitRating},
	{"远程命中等级", StatLogic.Stats.RangedHitRating},
	{"命中等级", StatLogic.Stats.HitRating},
	{"命中", StatLogic.Stats.HitRating},

	{"韧性等级", StatLogic.Stats.ResilienceRating},
	{"韧性", StatLogic.Stats.ResilienceRating},
	{ITEM_MOD_PVP_POWER_SHORT:lower(), StatLogic.Stats.PvpPowerRating},

	{"法术急速等级", StatLogic.Stats.SpellHasteRating},
	{"远程急速等级", StatLogic.Stats.RangedHasteRating},
	{"急速等级", StatLogic.Stats.HasteRating},
	{"急速", StatLogic.Stats.HasteRating},
	{"加速等级", StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{"精准等级", StatLogic.Stats.ExpertiseRating},
	{"精准", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"护甲穿透等级", StatLogic.Stats.ArmorPenetrationRating},
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
L["Spell"] = "法术"

-- Basic Attributes
L[StatLogic.Stats.Strength] = "力量"
L[StatLogic.Stats.Agility] = "敏捷"
L[StatLogic.Stats.Stamina] = "耐力"
L[StatLogic.Stats.Intellect] = "智力"
L[StatLogic.Stats.Spirit] = "精神"
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.MasteryRating] = STAT_MASTERY.." "..RATING

-- Resources
L[StatLogic.Stats.Health] = "生命值"
S[StatLogic.Stats.Health] = "生命"
L[StatLogic.Stats.Mana] = "法力值"
S[StatLogic.Stats.Mana] = "法力"
L[StatLogic.Stats.ManaRegen] = "法力回复"
S[StatLogic.Stats.ManaRegen] = "施法回魔"

local ManaRegenOutOfCombat = "法力回复 (非战斗)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "法力回复 (未施法)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "精神回魔"

L[StatLogic.Stats.HealthRegen] = "生命恢复"
S[StatLogic.Stats.HealthRegen] = "回血"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "生命恢复 (非战斗)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "回血(非战斗)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "近战攻击强度"
S[StatLogic.Stats.AttackPower] = "攻击强度"
L[StatLogic.Stats.FeralAttackPower] = "野性"..ATTACK_POWER_TOOLTIP
L[StatLogic.Stats.IgnoreArmor] = "忽略护甲"
L[StatLogic.Stats.ArmorPenetration] = "护甲穿透"
L[StatLogic.Stats.ArmorPenetrationRating] = "护甲穿透等级"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "近战伤害" -- DAMAGE = "Damage"
L[StatLogic.Stats.WeaponDPS] = "每秒伤害"

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "物理命中几率"
L[StatLogic.Stats.MeleeHitRating] = "命中等级"
L[StatLogic.Stats.MeleeCrit] = "物理爆击几率"
S[StatLogic.Stats.MeleeCrit] = "爆击"
L[StatLogic.Stats.MeleeCritRating] = "爆击等级"
L[StatLogic.Stats.MeleeHaste] = "急速"
L[StatLogic.Stats.MeleeHasteRating] = "急速等级"

L[StatLogic.Stats.WeaponSkill] = "武器技能"
L[StatLogic.Stats.Expertise] = "精准"
L[StatLogic.Stats.ExpertiseRating] = "精准等级"
L[StatLogic.Stats.DodgeReduction] = "防止被躲闪"
S[StatLogic.Stats.DodgeReduction] = "被躲闪"
L[StatLogic.Stats.ParryReduction] = "防止被招架"
S[StatLogic.Stats.ParryReduction] = "被招架"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "远程攻击强度"
S[StatLogic.Stats.RangedAttackPower] = "远攻强度"
L[StatLogic.Stats.RangedHit] = "远程命中几率"
L[StatLogic.Stats.RangedHitRating] = "远程命中等级"
L[StatLogic.Stats.RangedCrit] = "远爆击几率"
L[StatLogic.Stats.RangedCritRating] = "远程爆击等级"
L[StatLogic.Stats.RangedHaste] = "远程急速"
L[StatLogic.Stats.RangedHasteRating] = "远程急速等级"

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "法术伤害"
S[StatLogic.Stats.SpellDamage] = "法伤"
L[StatLogic.Stats.HealingPower] = "治疗"
S[StatLogic.Stats.HealingPower] = "治疗"
L[StatLogic.Stats.SpellPenetration] = "法术穿透"

L[StatLogic.Stats.HolyDamage] = "神圣法术伤害"
L[StatLogic.Stats.FireDamage] = "火焰法术伤害"
L[StatLogic.Stats.NatureDamage] = "自然法术伤害"
L[StatLogic.Stats.FrostDamage] = "冰霜法术伤害"
L[StatLogic.Stats.ShadowDamage] = "暗影法术伤害"
L[StatLogic.Stats.ArcaneDamage] = "奥术法术伤害"

L[StatLogic.Stats.SpellHit] = "法术命中几率"
S[StatLogic.Stats.SpellHit] = "Spell Hit"
L[StatLogic.Stats.SpellHitRating] = "法术命中等级"
L[StatLogic.Stats.SpellCrit] = "法术爆击几率"
S[StatLogic.Stats.SpellCrit] = "法爆"
L[StatLogic.Stats.SpellCritRating] = "法术爆击等级"
L[StatLogic.Stats.SpellHaste] = "法术急速"
L[StatLogic.Stats.SpellHasteRating] = "法术急速等级"

-- Tank Stats
L[StatLogic.Stats.Armor] = "护甲值"
L[StatLogic.Stats.BonusArmor] = "护甲值"

L[StatLogic.Stats.Avoidance] = "躲避"
L[StatLogic.Stats.Dodge] = "躲闪几率"
S[StatLogic.Stats.Dodge] = "躲闪"
L[StatLogic.Stats.DodgeRating] = "躲闪等级"
L[StatLogic.Stats.Parry] = "招架几率"
S[StatLogic.Stats.Parry] = "招架"
L[StatLogic.Stats.ParryRating] = "招架等级"
L[StatLogic.Stats.BlockChance] = "格挡几率"
L[StatLogic.Stats.BlockRating] = "格挡等级"
L[StatLogic.Stats.BlockValue] = "格挡值"
S[StatLogic.Stats.BlockValue] = "格挡值"
L[StatLogic.Stats.Miss] = "物理命中躲闪"

L[StatLogic.Stats.Defense] = "防御"
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = "物理爆击躲闪"
S[StatLogic.Stats.CritAvoidance] = "被致命一击"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "韧性"
L[StatLogic.Stats.CritDamageReduction] = "爆击减伤"
S[StatLogic.Stats.CritDamageReduction] = "致命一击伤害减免"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Taken"

L[StatLogic.Stats.FireResistance] = "火焰抗性"
L[StatLogic.Stats.NatureResistance] = "自然抗性"
L[StatLogic.Stats.FrostResistance] = "冰霜抗性"
L[StatLogic.Stats.ShadowResistance] = "暗影抗性"
L[StatLogic.Stats.ArcaneResistance] = "奥术抗性"