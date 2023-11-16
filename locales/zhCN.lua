--[[
Name: RatingBuster zhCN locale
Revision: $Revision: 73696 $
Translated by:
- iceburn
]]

---@class RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "zhCN")
if not L then return end
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
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
L["Change number color"] = true
-- /rb rating
L["Rating"] = "属性等级"
L["Options for Rating display"] = "设定属性等级显示"
-- /rb rating show
L["Show Rating conversions"] = "显示属性等级转换"
L["Show Rating conversions in tooltips"] = "在提示框架中显示属性等级转换结果"
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
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "加武器技能分为爆击、击中、防止被躲闪、防止被招架和防止被格挡"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "精准效能"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "转换精准等级为忽略躲闪和忽略招架"
L["from"] = "给的"
L["HEALING"] = STAT_SPELLHEALING
L["AP"] = ATTACK_POWER_TOOLTIP
L["RANGED_AP"] = RANGED_ATTACK_POWER
L["ARMOR"] = ARMOR
L["SPELL_DMG"] = STAT_SPELLDAMAGE
L["SPELL_CRIT"] = PLAYERSTAT_SPELL_COMBAT .. " " .. SPELL_CRIT_CHANCE
L["STR"] = SPELL_STAT1_NAME
L["AGI"] = SPELL_STAT2_NAME
L["STA"] = SPELL_STAT3_NAME
L["INT"] = SPELL_STAT4_NAME
L["SPI"] = SPELL_STAT5_NAME
L["PARRY"] = PARRY
L["MANA_REG"] = "施法回魔"
L["NORMAL_MANA_REG"] = SPELL_STAT4_NAME .. " & " .. SPELL_STAT5_NAME -- Intellect & Spirit
L["PET_STA"] = PET .. SPELL_STAT3_NAME -- Pet Stamina
L["PET_INT"] = PET .. SPELL_STAT4_NAME -- Pet Intellect
L.statModOptionName = function(show, add)
	return ("%s %s "):format(show, add)
end
L.statModOptionDesc = function(show, add, from, mod)
	return ("%s %s %s %s "):format(show, mod, from, add)
end

-- /rb stat
L["Stat Breakdown"] = "基本属性解析"
L["Changes the display of base stats"] = "设定基本属性的解析显示"
-- /rb stat show
L["Show base stat conversions"] = "显示基本属性解析"
L["Show base stat conversions in tooltips"] = "在物品提示中显示基本属性解析"
-- /rb stat str
L["Strength"] = "力量"
L["Changes the display of Strength"] = "自订力量解析项目"
-- /rb stat str ap
L["Show Attack Power"] = "显示近战攻击强度"
L["Show Attack Power from Strength"] = "显示力量给的近战攻击强度"
-- /rb stat str block
L["Show Block Value"] = "显示格档值"
L["Show Block Value from Strength"] = "显示力量给的格档值"
-- /rb stat str dmg
L["Show Spell Damage"] = "显示法伤"
L["Show Spell Damage from Strength"] = "显示力量给的法术伤害加成"
-- /rb stat str heal
L["Show Healing"] = "显示治疗"
L["Show Healing from Strength"] = "显示力量给的治疗加成"

-- /rb stat agi
L["Agility"] = "敏捷"
L["Changes the display of Agility"] = "自订敏捷解析项目"
-- /rb stat agi crit
L["Show Crit"] = "显示物理爆击"
L["Show Crit chance from Agility"] = "显示敏捷给的物理爆击几率"
-- /rb stat agi dodge
L["Show Dodge"] = "显示躲闪"
L["Show Dodge chance from Agility"] = "显示敏捷给的躲闪几率"
-- /rb stat agi ap
L["Show Attack Power"] = "显示近战攻击强度"
L["Show Attack Power from Agility"] = "显示敏捷给的近战攻击强度"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "显示远程攻击强度"
L["Show Ranged Attack Power from Agility"] = "显示敏捷给的远程攻击强度"
-- /rb stat agi armor
L["Show Armor"] = "显示护甲值"
L["Show Armor from Agility"] = "显示敏捷给的护甲值"
-- /rb stat agi heal
L["Show Healing"] = "显示治疗"
L["Show Healing from Agility"] = "显示敏捷给的治疗加成"

-- /rb stat sta
L["Stamina"] = "耐力"
L["Changes the display of Stamina"] = "自订耐力解析项目"
-- /rb stat sta hp
L["Show Health"] = "显示生命值"
L["Show Health from Stamina"] = "显示耐力给的生命值"
-- /rb stat sta dmg
L["Show Spell Damage"] = "显示法伤"
L["Show Spell Damage from Stamina"] = "显示耐力给的法术伤害加成"

-- /rb stat int
L["Intellect"] = "智力"
L["Changes the display of Intellect"] = "自订智力解析项目"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "显示法术爆击"
L["Show Spell Crit chance from Intellect"] = "显示智力给的法术爆击几率"
-- /rb stat int mp
L["Show Mana"] = "显示法力值"
L["Show Mana from Intellect"] = "显示智力给的法力值"
-- /rb stat int dmg
L["Show Spell Damage"] = "显示法伤"
L["Show Spell Damage from Intellect"] = "显示智力给的法术伤害加成"
-- /rb stat int heal
L["Show Healing"] = "显示治疗"
L["Show Healing from Intellect"] = "显示智力给的治疗加成"
-- /rb stat int mp5
L["Show Mana Regen"] = "显示施法回魔"
L["Show Mana Regen while casting from Intellect"] = "显示智力给的施法中法力恢复量"
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "显示5秒外回魔"
L["Show Mana Regen while NOT casting from Intellect"] = "显示在非施法状态下的法力恢复量"
-- /rb stat int rap
L["Show Ranged Attack Power"] = "显示远程攻击强度"
L["Show Ranged Attack Power from Intellect"] = "显示智力给的远程攻击强度"
-- /rb stat int armor
L["Show Armor"] = "显示护甲值"
L["Show Armor from Intellect"] = "显示智力给的护甲值"

-- /rb stat spi
L["Spirit"] = "精神"
L["Changes the display of Spirit"] = "自订精神解析项目"
-- /rb stat spi mp5
L["Show Mana Regen"] = "显示施法回魔"
L["Show Mana Regen while casting from Spirit"] = "显示在施法状态时，精神给的法力恢复量"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "显示正常回魔"
L["Show Mana Regen while NOT casting from Spirit"] = "显示在未施法状态时，精神给的法力恢复量"
-- /rb stat spi hp5
L["Show Health Regen"] = "显示回血"
L["Show Health Regen from Spirit"] = "显示精神给的正常回血"
-- /rb stat spi dmg
L["Show Spell Damage"] = "显示法伤"
L["Show Spell Damage from Spirit"] = "显示精神给的法术伤害加成"
-- /rb stat spi heal
L["Show Healing"] = "显示治疗"
L["Show Healing from Spirit"] = "显示精神给的治疗加成"

L["Armor"] = "Armor"
L["Changes the display of Armor"] = "Changes the display of Armor"
L["Attack Power"] = "Attack Power"
L["Changes the display of Attack Power"] = "Changes the display of Attack Power"

-- /rb sum
L["Stat Summary"] = "属性统计"
L["Options for stat summary"] = "自订属性选项"
-- /rb sum show
L["Show stat summary"] = "显示属性统计"
L["Show stat summary in tooltips"] = "在物品提示中显示属性统计"
-- /rb sum ignore
L["Ignore settings"] = "忽略设定"
L["Ignore stuff when calculating the stat summary"] = "设定在统计总合时所要忽略的事项"
-- /rb sum ignore unused
L["Ignore unused item types"] = "忽略不可能使用的物品"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "只显示在你会使用的物品上"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "忽略已装备的物品"
L["Hide stat summary for equipped items"] = "隐藏已装备的物品的统计总合"
-- /rb sum ignore enchant
L["Ignore enchants"] = "忽略附魔"
L["Ignore enchants on items when calculating the stat summary"] = "计算时忽略物品上的附魔效果"
-- /rb sum ignore gem
L["Ignore gems"] = "忽略宝石"
L["Ignore gems on items when calculating the stat summary"] = "计算时忽略物品上的宝石效果"
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
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
L["Show the sigma icon before summary listing"] = "在属性统计前显示图示"
-- /rb sum title
L["Show title text"] = "显示标题"
L["Show the title text before summary listing"] = "在属性统计前显示标题文字"
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
L["Sum Health"] = "统计生命值"
L["Health <- Health Stamina"] = "生命值 ← 生命值、耐力"
-- /rb sum stat mp
L["Sum Mana"] = "统计法力值"
L["Mana <- Mana Intellect"] = "法力值 ← 法力值、智力"
-- /rb sum stat ap
L["Sum Attack Power"] = "统计近战攻击强度"
L["Attack Power <- Attack Power Strength, Agility"] = "近战攻击强度 ← 攻击强度、力量、敏捷"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "统计远程攻击强度"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "远程攻击强度 ← 远程攻击强度、智力、攻击强度、力量、敏捷"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "统计法术伤害"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "法术伤害 ← 法术伤害、智力、精神、耐力"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "统计神圣法术伤害"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "神圣法术伤害 ← 神圣法术伤害、法术伤害、智力、精神"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "统计奥术法术伤害"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "奥术法术伤害 ← 奥术法术伤害、法术伤害、智力"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "统计火焰法术伤害"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "火焰法术伤害 ← 火焰法术伤害、法术伤害、智力、耐力"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "统计自然法术伤害"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "自然法术伤害 ← 自然法术伤害、法术伤害、智力"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "统计冰霜法术伤害"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "冰霜法术伤害 ← 冰霜法术伤害、法术伤害、智力"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "统计暗影法术伤害"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "暗影法术伤害 ← 暗影法术伤害、法术伤害、智力、精神、耐力"
-- /rb sum stat heal
L["Sum Healing"] = "统计治疗"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "治疗 ← 治疗、智力、精神、敏捷、力量"
-- /rb sum stat hit
L["Sum Hit Chance"] = "统计物理命中几率"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "物理命中几率 ← 命中等级、武器技能等级"
-- /rb sum stat crit
L["Sum Crit Chance"] = "统计物理爆击几率"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "物理爆击几率 ← 爆击等级、敏捷、武器技能等级"
-- /rb sum stat haste
L["Sum Haste"] = "统计急速"
L["Haste <- Haste Rating"] = "急速 ← 急速等级"
L["Sum Ranged Hit Chance"] = "统计远程命中几率"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "远程米中几率 ← 命中等级、武器技能等级、远程命中等级"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "统计远程命中等级"
L["Ranged Hit Rating Summary"] = "统计远程命中等级"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "统计远爆击几率"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "远程爆击几率 ← 爆击等级、敏捷、武器技能等级、远程爆击等级"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "统计远程爆击等级"
L["Ranged Crit Rating Summary"] = "统计远程爆击等级"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "统计远程急速"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "远程急速 ← 急速等级、远程急速等级"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "统计远程急速等级"
L["Ranged Haste Rating Summary"] = "统计远程急速等级"

-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "统计法术爆击几率"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "法术爆击几率 ← 法术爆击等级、智力"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "统计法术命中几率"
L["Spell Hit Chance <- Spell Hit Rating"] = "法术命中几率 ← 法术命中等级"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "统计法术急速"
L["Spell Haste <- Spell Haste Rating"] = "法术急速 ← 法术急速等级"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "统计法力恢复"
L["Mana Regen <- Mana Regen Spirit"] = "法力恢复 ← 法力恢复、精神"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "统计法力恢复(未施法时)"
L["Mana Regen while not casting <- Spirit"] = "法力恢复(未施法时) ← 精神"
-- /rb sum stat hp5
L["Sum Health Regen"] = "统计生命恢复"
L["Health Regen <- Health Regen"] = "生命恢复 ← 生命恢复"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "统计生命恢复(未战斗时)"
L["Health Regen when out of combat <- Spirit"] = "生命恢复(未战斗时) ← 精神"
-- /rb sum stat armor
L["Sum Armor"] = "统计护甲值"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "护甲值 ← 物品护甲、护甲加成、敏捷、智力"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "统计格挡值"
L["Block Value <- Block Value Strength"] = "格挡值 ← 格挡值、力量"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "统计躲闪几率"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "躲闪几率 ← 躲闪等级、敏捷、防御等级"
-- /rb sum stat parry
L["Sum Parry Chance"] = "统计招架几率"
L["Parry Chance <- Parry Rating Defense Rating"] = "招架几率 ← 招架等级、防御等级"
-- /rb sum stat block
L["Sum Block Chance"] = "统计格挡几率"
L["Block Chance <- Block Rating Defense Rating"] = "格挡几率 ← 格挡等级、防御等级"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "统计物理命中躲闪"
L["Hit Avoidance <- Defense Rating"] = "物理命中躲闪 ← 防御等级"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "统计物理爆击躲闪"
L["Crit Avoidance <- Defense Rating Resilience"] = "物理爆击躲闪 ← 防御等级、韧性"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "统计防止被躲闪"
L["Dodge Neglect <- Expertise Weapon Skill Rating"] = "防止被躲闪 ← 精准等级、武器技能等级" -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "统计防止被招架"
L["Parry Neglect <- Expertise Weapon Skill Rating"] = "防止被招架 ← 精准等级、武器技能等级" -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "统计防止被格挡"
L["Block Neglect <- Weapon Skill Rating"] = "防止被格挡 ← 武器技能等级"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "统计奥术抗性"
L["Arcane Resistance Summary"] = "统计奥术抗性"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "统计火焰抗性"
L["Fire Resistance Summary"] = "统计火焰抗性"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "统计自然抗性"
L["Nature Resistance Summary"] = "统计自然抗性"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "统计冰霜抗性"
L["Frost Resistance Summary"] = "统计冰霜抗性"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "统计暗影抗性"
L["Shadow Resistance Summary"] = "统计暗影抗性"
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = "统计武器DPS"
L["Weapon DPS Summary"] = "武器DPS统计"
-- /rb sum stat pen
L["Sum Penetration"] = "统计穿透"
L["Spell Penetration Summary"] = "统计法术穿透"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "统计忽略护甲"
L["Ignore Armor Summary"] = "统计忽略护甲效果"
L["Sum Armor Penetration"] = "统计护甲穿透"
L["Armor Penetration Summary"] = "统计无视护甲穿透"
L["Sum Armor Penetration Rating"] = "统计无视护甲穿透等级"
L["Armor Penetration Rating Summary"] = "统计无视护甲穿透等级"
-- /rb sum statcomp str
L["Sum Strength"] = "统计力量"
L["Strength Summary"] = "统计力量"
-- /rb sum statcomp agi
L["Sum Agility"] = "统计敏捷"
L["Agility Summary"] = "统计敏捷"
-- /rb sum statcomp sta
L["Sum Stamina"] = "统计耐力"
L["Stamina Summary"] = "统计耐力"
-- /rb sum statcomp int
L["Sum Intellect"] = "统计智力"
L["Intellect Summary"] = "统计智力"
-- /rb sum statcomp spi
L["Sum Spirit"] = "统计精神"
L["Spirit Summary"] = "统计精神"
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "统计命中等级"
L["Hit Rating Summary"] = "统计命中等级"
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "统计爆击等级"
L["Crit Rating Summary"] = "统计爆击等级"
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "统计急速等级"
L["Haste Rating Summary"] = "统计急速等级"
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "统计法术命中等级"
L["Spell Hit Rating Summary"] = "统计法术命中等级"
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "统计法术爆击等级"
L["Spell Crit Rating Summary"] = "统计法术爆击等级"
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "统计法术急速等级"
L["Spell Haste Rating Summary"] = "统计法术急速等级"
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "统计躲闪等级"
L["Dodge Rating Summary"] = "统计躲闪等级"
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "统计招架等级"
L["Parry Rating Summary"] = "统计招架等级"
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "统计格挡等级"
L["Block Rating Summary"] = "统计格挡等级"
-- /rb sum statcomp res
L["Sum Resilience"] = "统计韧性"
L["Resilience Summary"] = "统计韧性等级"
-- /rb sum statcomp def
L["Sum Defense"] = "统计防御"
L["Defense <- Defense Rating"] = "防御 ← 防御等级"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "统计武器技能"
L["Weapon Skill <- Weapon Skill Rating"] = "武器技能 ← 武器技能等级"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "统计精准"
L["Expertise <- Expertise Rating"] = "精准 ← 精准等级"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "统计躲避"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "躲避 ← 躲闪, 招架, 怪物未命中, 格挡(可选)"
-- /rb sum gem
L["Gems"] = "宝石"
L["Auto fill empty gem slots"] = "自动填充空宝石位"
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "你想要填充该空格位的物品ID或者链接"
L["<ItemID|Link>"] = "<物品ID|链接>"
L["%s is now set to %s"] = "%s现在被放置于%s"
L["Queried server for Gem: %s. Try again in 5 secs."] = "对服务器查询宝石: %s。将会在5秒后重试。"
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

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
-- For example, in english I found 3 different strings that maps to CR_CRIT_MELEE: "critical strike", "critical hit" and "crit".
-- You will need to find out every string that represents CR_CRIT_MELEE, and so on.
-- In other languages there may be 5 different strings that should all map to CR_CRIT_MELEE.
-- so please check in game that you have all strings, and not translate directly off this table.
--
-- Tip1: When doing localizations, I recommend you set debugging to true in RatingBuster.lua
-- Find RatingBuster:SetDebugging(false) and change it to RatingBuster:SetDebugging(true)
-- or you can type /rb debug to enable it in game
--
-- Tip2: The strings are passed into string.find, so you should escape the magic characters ^$()%.[]*+-? with a %
L["numberPatterns"] = {
	{pattern = "(%d+)。", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "佩戴者.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "提高.-(%d+)", addInfo = "AfterNumber",},
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [发光的暗影卓奈石] +6法术伤害及5耐力
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}
L["separators"] = {
	"/", "和", ",", "。", " 持续 ", "&", "及", "并", "，","、", "\n"
}
--[[ Rating ID
CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_RESILIENCE_CRIT_TAKEN = 15;
CR_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_EXPERTISE = 24;
CR_ARMOR_PENETRATION = 25;
--
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{pattern = SPELL_STAT1_NAME:lower(), id = StatLogic.Stats.Strength}, -- Strength
	{pattern = SPELL_STAT2_NAME:lower(), id = StatLogic.Stats.Agility}, -- Agility
	{pattern = SPELL_STAT3_NAME:lower(), id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = SPELL_STAT4_NAME:lower(), id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = SPELL_STAT5_NAME:lower(), id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "防御等级", id = CR_DEFENSE_SKILL},
	{pattern = "躲闪等级", id = CR_DODGE},
	{pattern = "格挡等级", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "招架等级", id = CR_PARRY},

	{pattern = "法术爆击等级", id = CR_CRIT_SPELL},
	{pattern = "法术爆击命中等级", id = CR_CRIT_SPELL},
	{pattern = "法术爆击等级", id = CR_CRIT_SPELL},
	{pattern = "远程爆击等级", id = CR_CRIT_RANGED},
	{pattern = "远程爆击命中等级", id = CR_CRIT_RANGED},
	{pattern = "远程爆击等级", id = CR_CRIT_RANGED},
	{pattern = "近战爆击等级", id = CR_CRIT_MELEE},
	{pattern = "爆击等级", id = StatLogic.GenericStats.CR_CRIT},

	{pattern = "法术命中等级", id = CR_HIT_SPELL},
	{pattern = "远程命中等级", id = CR_HIT_RANGED},
	{pattern = "命中等级", id = StatLogic.GenericStats.CR_HIT},

	{pattern = "韧性等级", id = CR_RESILIENCE_CRIT_TAKEN}, -- resilience is implicitly a rating

	{pattern = "法术急速等级", id = CR_HASTE_SPELL},
	{pattern = "远程急速等级", id = CR_HASTE_RANGED},
	{pattern = "急速等级", id = StatLogic.GenericStats.CR_HASTE},
	{pattern = "加速等级", id = StatLogic.GenericStats.CR_HASTE}, -- [Drums of Battle]

	{pattern = "精准等级", id = CR_EXPERTISE},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.GenericStats.ALL_STATS},

	{pattern = "护甲穿透等级", id = CR_ARMOR_PENETRATION},
	{pattern = ARMOR:lower(), id = ARMOR},
	{pattern = "攻击强度", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% 爆击"
L["$value% Spell Crit"] = "$value% 法爆"
L["$value% Dodge"] = "$value% 躲闪"
L["$value HP"] = "$value 生命"
L["$value MP"] = "$value 法力"
L["$value AP"] = "$value 攻击强度"
L["$value RAP"] = "$value 远攻强度"
L["$value Spell Dmg"] = "$value 法伤"
L["$value Heal"] = "$value 治疗"
L["$value Armor"] = "$value 护甲"
L["$value Block"] = "$value 格挡值"
L["$value MP5"] = "$value 施法回魔"
L["$value MP5(NC)"] = "$value 精神回魔"
L["$value HP5"] = "$value 回血"
L["$value to be Dodged/Parried"] = "$value 被躲闪/被招架"
L["$value to be Crit"] = "$value 被致命一击"
L["$value Crit Dmg Taken"] = "$value 致命一击伤害减免"
L["$value DOT Dmg Taken"] = "$value 持续伤害减免"
L["$value Dmg Taken"] = true
L["$value% Parry"] = "$value% 招架"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value 法术"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "属性统计"