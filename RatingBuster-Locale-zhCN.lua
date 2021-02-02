--[[
Name: RatingBuster zhCN locale
Revision: $Revision: 73696 $
Translated by: 
- iceburn
]]

local L = AceLibrary("AceLocale-3.0"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("zhCN", function() return {
	---------------
	-- Waterfall --
	---------------
	["RatingBuster Options"] = "RatingBuster选项",
	["Waterfall-1.0 is required to access the GUI."] = "这个GUI需要Waterfall库",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb optionswin
	["Options Window"] = "选项窗口",
	["Shows the Options Window"] = "打开选项窗口",
	-- /rb statmod
	["Enable Stat Mods"] = "属性加成",
	["Enable support for Stat Mods"] = "启用属性加成计算",
	-- /rb itemid
	["Show ItemID"] = "显示物品编号",
	["Show the ItemID in tooltips"] = "显示物品编号",
	-- /rb itemlevel
	["Show ItemLevel"] = "显示物品等级",
	["Show the ItemLevel in tooltips"] = "显示物品等级",
	-- /rb usereqlv
	["Use required level"] = "使用需要等级",
	["Calculate using the required level if you are below the required level"] = "如果你的等级低于需要等级则用需要等级来换算",
	-- /rb setlevel
	["Set level"] = "设定换算等级",
	["Set the level used in calculations (0 = your level)"] = "设定换算等级 (0 = 你的目前的等级)",
	-- /rb color
	["Change text color"] = "设定文字颜色",
	["Changes the color of added text"] = "设定RB所增加的文字的颜色",
	-- /rb color pick
	["Pick color"] = "挑选颜色",
	["Pick a color"] = "挑选颜色",
	-- /rb color enable
	["Enable color"] = "启用文字颜色",
	["Enable colored text"] = "启用文字颜色",
	-- /rb rating
	["Rating"] = "属性等级",
	["Options for Rating display"] = "设定属性等级显示",
	-- /rb rating show
	["Show Rating conversions"] = "显示属性等级转换",
	["Show Rating conversions in tooltips"] = "在提示框架中显示属性等级转换结果",
	-- /rb rating detail
	["Show detailed conversions text"] = "显示详细转换文本",
	["Show detailed text for Resiliance and Expertise conversions"] = "显示详细的抗性和精准等级转换",
	-- /rb rating def
	["Defense breakdown"] = "分析防御",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "将防御分为避免爆击、避免击中、躲闪、招架和格挡",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "分析武器技能",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "加武器技能分为爆击、击中、防止被躲闪、防止被招架和防止被格挡",
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = "精准效能",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "转换精准等级为忽略躲闪和忽略招架",
	
	-- /rb stat
	["Stat Breakdown"] = "基本属性解析",
	["Changes the display of base stats"] = "设定基本属性的解析显示",
	-- /rb stat show
	["Show base stat conversions"] = "显示基本属性解析",
	["Show base stat conversions in tooltips"] = "在物品提示中显示基本属性解析",
	-- /rb stat str
	["Strength"] = "力量",
	["Changes the display of Strength"] = "自订力量解析项目",
	-- /rb stat str ap
	["Show Attack Power"] = "显示近战攻击强度",
	["Show Attack Power from Strength"] = "显示力量给的近战攻击强度",
	-- /rb stat str block
	["Show Block Value"] = "显示格档值",
	["Show Block Value from Strength"] = "显示力量给的格档值",
	-- /rb stat str dmg
	["Show Spell Damage"] = "显示法伤",
	["Show Spell Damage from Strength"] = "显示力量给的法术伤害加成",
	-- /rb stat str heal
	["Show Healing"] = "显示治疗",
	["Show Healing from Strength"] = "显示力量给的治疗加成",
	
	-- /rb stat agi
	["Agility"] = "敏捷",
	["Changes the display of Agility"] = "自订敏捷解析项目",
	-- /rb stat agi crit
	["Show Crit"] = "显示物理爆击",
	["Show Crit chance from Agility"] = "显示敏捷给的物理爆击几率",
	-- /rb stat agi dodge
	["Show Dodge"] = "显示躲闪",
	["Show Dodge chance from Agility"] = "显示敏捷给的躲闪几率",
	-- /rb stat agi ap
	["Show Attack Power"] = "显示近战攻击强度",
	["Show Attack Power from Agility"] = "显示敏捷给的近战攻击强度",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "显示远程攻击强度",
	["Show Ranged Attack Power from Agility"] = "显示敏捷给的远程攻击强度",
	-- /rb stat agi armor
	["Show Armor"] = "显示护甲值",
	["Show Armor from Agility"] = "显示敏捷给的护甲值",
	-- /rb stat agi heal
	["Show Healing"] = "显示治疗",
	["Show Healing from Agility"] = "显示敏捷给的治疗加成",
	
	-- /rb stat sta
	["Stamina"] = "耐力",
	["Changes the display of Stamina"] = "自订耐力解析项目",
	-- /rb stat sta hp
	["Show Health"] = "显示生命值",
	["Show Health from Stamina"] = "显示耐力给的生命值",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "显示法伤",
	["Show Spell Damage from Stamina"] = "显示耐力给的法术伤害加成",
	
	-- /rb stat int
	["Intellect"] = "智力",
	["Changes the display of Intellect"] = "自订智力解析项目",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "显示法术爆击",
	["Show Spell Crit chance from Intellect"] = "显示智力给的法术爆击几率",
	-- /rb stat int mp
	["Show Mana"] = "显示法力值",
	["Show Mana from Intellect"] = "显示智力给的法力值",
	-- /rb stat int dmg
	["Show Spell Damage"] = "显示法伤",
	["Show Spell Damage from Intellect"] = "显示智力给的法术伤害加成",
	-- /rb stat int heal
	["Show Healing"] = "显示治疗",
	["Show Healing from Intellect"] = "显示智力给的治疗加成",
	-- /rb stat int mp5
	["Show Mana Regen"] = "显示施法回魔",
	["Show Mana Regen while casting from Intellect"] = "显示智力给的施法中法力恢复量",
	-- /rb stat int mp5nc
	["Show Mana Regen while NOT casting"] = "显示5秒外回魔",
	["Show Mana Regen while NOT casting from Intellect"] = "显示在非施法状态下的法力恢复量",
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "显示远程攻击强度",
	["Show Ranged Attack Power from Intellect"] = "显示智力给的远程攻击强度",
	-- /rb stat int armor
	["Show Armor"] = "显示护甲值",
	["Show Armor from Intellect"] = "显示智力给的护甲值",
	
	-- /rb stat spi
	["Spirit"] = "精神",
	["Changes the display of Spirit"] = "自订精神解析项目",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "显示施法回魔",
	["Show Mana Regen while casting from Spirit"] = "显示在施法状态时，精神给的法力恢复量",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "显示正常回魔",
	["Show Mana Regen while NOT casting from Spirit"] = "显示在未施法状态时，精神给的法力恢复量",
	-- /rb stat spi hp5
	["Show Health Regen"] = "显示回血",
	["Show Health Regen from Spirit"] = "显示精神给的正常回血",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "显示法伤",
	["Show Spell Damage from Spirit"] = "显示精神给的法术伤害加成",
	-- /rb stat spi heal
	["Show Healing"] = "显示治疗",
	["Show Healing from Spirit"] = "显示精神给的治疗加成",
	
	-- /rb sum
	["Stat Summary"] = "属性统计",
	["Options for stat summary"] = "自订属性选项",
	-- /rb sum show
	["Show stat summary"] = "显示属性统计",
	["Show stat summary in tooltips"] = "在物品提示中显示属性统计",
	-- /rb sum ignore
	["Ignore settings"] = "忽略设定",
	["Ignore stuff when calculating the stat summary"] = "设定在统计总合时所要忽略的事项",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "忽略不可能使用的物品",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "只显示在你会使用的物品上",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "忽略已装备的物品",
	["Hide stat summary for equipped items"] = "隐藏已装备的物品的统计总合",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "忽略附魔",
	["Ignore enchants on items when calculating the stat summary"] = "计算时忽略物品上的附魔效果",
	-- /rb sum ignore gem
	["Ignore gems"] = "忽略宝石",
	["Ignore gems on items when calculating the stat summary"] = "计算时忽略物品上的宝石效果",
	-- /rb sum diffstyle
	["Display style for diff value"] = "差异值显示方式",
	["Display diff values in the main tooltip or only in compare tooltips"] = "设定在主提示框架或只在比较框架中显示差异值",
	-- /rb sum space
	["Add empty line"] = "加入空白列",
	["Add a empty line before or after stat summary"] = "在物品提示中的属性统计前或后加入空白列",
	-- /rb sum space before
	["Add before summary"] = "加在统计前",
	["Add a empty line before stat summary"] = "在物品提示中的属性统计前加入空白列",
	-- /rb sum space after
	["Add after summary"] = "加在统计后",
	["Add a empty line after stat summary"] = "在物品提示中的属性统计后加入空白列",
	-- /rb sum icon
	["Show icon"] = "显示图示",
	["Show the sigma icon before summary listing"] = "在属性统计前显示图示",
	-- /rb sum title
	["Show title text"] = "显示标题",
	["Show the title text before summary listing"] = "在属性统计前显示标题文字",
	-- /rb sum showzerostat
	["Show zero value stats"] = "显示数值为0的属性",
	["Show zero value stats in summary for consistancy"] = "为了一致性，在统计中显示数值为0的属性",
	-- /rb sum calcsum
	["Calculate stat sum"] = "计算总和统计",
	["Calculate the total stats for the item"] = "计算物品的总和统计",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "计算差异统计",
	["Calculate the stat difference for the item and equipped items"] = "计算物品和已装备物品的统计差异",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "按照字母排序",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "启用以按照字母顺序排列，禁用按照属性类型排列(基础、物理、法术、抵抗……)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "在躲避统计中显示格挡几率",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "启用该选项后将在躲避统计中加入格挡几率，禁用将仅显示躲闪，招架，未击中",
	-- /rb sum basic
	["Stat - Basic"] = "属性 - 基本",
	["Choose basic stats for summary"] = "选择想要统计的基本属性",
	-- /rb sum physical
	["Stat - Physical"] = "属性 - 物理",
	["Choose physical damage stats for summary"] = "选择想要统计的物理攻击属性",
	-- /rb sum spell
	["Stat - Spell"] = "属性 - 法术",
	["Choose spell damage and healing stats for summary"] = "选择想要统计的法术攻击和治疗的属性",
	-- /rb sum tank
	["Stat - Tank"] = "属性 - 抗打击",
	["Choose tank stats for summary"] = "选择你想要统计的抗打击能力的属性",
	-- /rb sum stat hp
	["Sum Health"] = "统计生命值",
	["Health <- Health, Stamina"] = "生命值 ← 生命值、耐力",
	-- /rb sum stat mp
	["Sum Mana"] = "统计法力值",
	["Mana <- Mana, Intellect"] = "法力值 ← 法力值、智力",
	-- /rb sum stat ap
	["Sum Attack Power"] = "统计近战攻击强度",
	["Attack Power <- Attack Power, Strength, Agility"] = "近战攻击强度 ← 攻击强度、力量、敏捷",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "统计远程攻击强度",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "远程攻击强度 ← 远程攻击强度、智力、攻击强度、力量、敏捷",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "统计野性攻击强度",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "野性攻击强度 ← 野性攻击强度、攻击强度、力量、敏捷",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "统计法术伤害",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "法术伤害 ← 法术伤害、智力、精神、耐力",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "统计神圣法术伤害",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "神圣法术伤害 ← 神圣法术伤害、法术伤害、智力、精神",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "统计奥术法术伤害",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "奥术法术伤害 ← 奥术法术伤害、法术伤害、智力",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "统计火焰法术伤害",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "火焰法术伤害 ← 火焰法术伤害、法术伤害、智力、耐力",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "统计自然法术伤害",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "自然法术伤害 ← 自然法术伤害、法术伤害、智力",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "统计冰霜法术伤害",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "冰霜法术伤害 ← 冰霜法术伤害、法术伤害、智力",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "统计暗影法术伤害",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "暗影法术伤害 ← 暗影法术伤害、法术伤害、智力、精神、耐力",
	-- /rb sum stat heal
	["Sum Healing"] = "统计治疗",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "治疗 ← 治疗、智力、精神、敏捷、力量",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "统计物理命中几率",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "物理命中几率 ← 命中等级、武器技能等级",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "统计物理爆击几率",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "物理爆击几率 ← 爆击等级、敏捷、武器技能等级",
	-- /rb sum stat haste
	["Sum Haste"] = "统计急速",
	["Haste <- Haste Rating"] = "急速 ← 急速等级",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "统计法术爆击几率",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "法术爆击几率 ← 法术爆击等级、智力",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "统计法术命中几率",
	["Spell Hit Chance <- Spell Hit Rating"] = "法术命中几率 ← 法术命中等级",
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = "统计法术急速",
	["Spell Haste <- Spell Haste Rating"] = "法术急速 ← 法术急速等级",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "统计法力恢复",
	["Mana Regen <- Mana Regen, Spirit"] = "法力恢复 ← 法力恢复、精神",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "统计法力恢复(未施法时)",
	["Mana Regen while not casting <- Spirit"] = "法力恢复(未施法时) ← 精神",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "统计生命恢复",
	["Health Regen <- Health Regen"] = "生命恢复 ← 生命恢复",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "统计生命恢复(未战斗时)",
	["Health Regen when out of combat <- Spirit"] = "生命恢复(未战斗时) ← 精神",
	-- /rb sum stat armor
	["Sum Armor"] = "统计护甲值",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "护甲值 ← 物品护甲、护甲加成、敏捷、智力",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "统计格挡值",
	["Block Value <- Block Value, Strength"] = "格挡值 ← 格挡值、力量",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "统计躲闪几率",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "躲闪几率 ← 躲闪等级、敏捷、防御等级",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "统计招架几率",
	["Parry Chance <- Parry Rating, Defense Rating"] = "招架几率 ← 招架等级、防御等级",
	-- /rb sum stat block
	["Sum Block Chance"] = "统计格挡几率",
	["Block Chance <- Block Rating, Defense Rating"] = "格挡几率 ← 格挡等级、防御等级",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "统计物理命中躲闪",
	["Hit Avoidance <- Defense Rating"] = "物理命中躲闪 ← 防御等级",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "统计物理爆击躲闪",
	["Crit Avoidance <- Defense Rating, Resilience"] = "物理爆击躲闪 ← 防御等级、韧性",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "统计防止被躲闪",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "防止被躲闪 ← 精准等级、武器技能等级", -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "统计防止被招架",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "防止被招架 ← 精准等级、武器技能等级", -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "统计防止被格挡",
	["Block Neglect <- Weapon Skill Rating"] = "防止被格挡 ← 武器技能等级",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "统计奥术抗性",
	["Arcane Resistance Summary"] = "统计奥术抗性",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "统计火焰抗性",
	["Fire Resistance Summary"] = "统计火焰抗性",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "统计自然抗性",
	["Nature Resistance Summary"] = "统计自然抗性",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "统计冰霜抗性",
	["Frost Resistance Summary"] = "统计冰霜抗性",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "统计暗影抗性",
	["Shadow Resistance Summary"] = "统计暗影抗性",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "统计武器最大伤害",
	["Weapon Max Damage Summary"] = "统计武器最大伤害",
	-- /rb sum stat pen
	["Sum Penetration"] = "统计穿透",
	["Spell Penetration Summary"] = "统计法术穿透",
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = "统计忽略护甲",
	["Ignore Armor Summary"] = "统计忽略护甲效果",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp str
	["Sum Strength"] = "统计力量",
	["Strength Summary"] = "统计力量",
	-- /rb sum statcomp agi
	["Sum Agility"] = "统计敏捷",
	["Agility Summary"] = "统计敏捷",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "统计耐力",
	["Stamina Summary"] = "统计耐力",
	-- /rb sum statcomp int
	["Sum Intellect"] = "统计智力",
	["Intellect Summary"] = "统计智力",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "统计精神",
	["Spirit Summary"] = "统计精神",
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = "统计命中等级",
	["Hit Rating Summary"] = "统计命中等级",
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = "统计爆击等级",
	["Crit Rating Summary"] = "统计爆击等级",
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = "统计急速等级",
	["Haste Rating Summary"] = "统计急速等级",
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = "统计法术命中等级",
	["Spell Hit Rating Summary"] = "统计法术命中等级",
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = "统计法术爆击等级",
	["Spell Crit Rating Summary"] = "统计法术爆击等级",
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = "统计法术急速等级",
	["Spell Haste Rating Summary"] = "统计法术急速等级",
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = "统计躲闪等级",
	["Dodge Rating Summary"] = "统计躲闪等级",
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = "统计招架等级",
	["Parry Rating Summary"] = "统计招架等级",
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = "统计格挡等级",
	["Block Rating Summary"] = "统计格挡等级",
	-- /rb sum statcomp res
	["Sum Resilience"] = "统计韧性",
	["Resilience Summary"] = "统计韧性等级",
	-- /rb sum statcomp def
	["Sum Defense"] = "统计防御",
	["Defense <- Defense Rating"] = "防御 ← 防御等级",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "统计武器技能",
	["Weapon Skill <- Weapon Skill Rating"] = "武器技能 ← 武器技能等级",
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = "统计精准",
	["Expertise <- Expertise Rating"] = "精准 ← 精准等级",
	-- /rb sum statcomp tp
	["Sum TankPoints"] = "统计抗打击能力",
	["TankPoints <- Health, Total Reduction"] = "抗打击能力 ← 生命值, 所有伤害减免",
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = "统计伤害减免",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "所有伤害减免 <- 护甲值, 躲闪, 招架, 格挡, 格挡值, 防御技能, 韧性, 怪物未击中几率, 怪物重击几率, 怪物碾压打击几率, 伤害减免",
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = "统计躲避",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "躲避 ← 躲闪, 招架, 怪物未命中, 格挡(可选)",
	-- /rb sum gem
	["Gems"] = "宝石",
	["Auto fill empty gem slots"] = "自动填充空宝石位",
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = "你想要填充该空格位的物品ID或者链接",
	["<ItemID|Link>"] = "<物品ID|链接>",
	["%s is now set to %s"] = "%s现在被放置于%s",
	["Queried server for Gem: %s. Try again in 5 secs."] = "对服务器查询宝石: %s。将会在5秒后重试。",
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,

	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "物品等级: ",
	["ItemID: "] = "物品编号: ",
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
	["numberPatterns"] = {
		{pattern = "(%d+)。", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
		{pattern = "佩戴者.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
		{pattern = "提高.-(%d+)", addInfo = "AfterNumber",},
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [发光的暗影卓奈石] +6法术伤害及5耐力
	},
	["separators"] = {
		"/", "和", ",", "。", " 持续 ", "&", "及", "并", "，","、",
	},
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
	CR_HIT_TAKEN_MELEE = 12;
	CR_HIT_TAKEN_RANGED = 13;
	CR_HIT_TAKEN_SPELL = 14;
	CR_CRIT_TAKEN_MELEE = 15;
	CR_CRIT_TAKEN_RANGED = 16;
	CR_CRIT_TAKEN_SPELL = 17;
	CR_HASTE_MELEE = 18;
	CR_HASTE_RANGED = 19;
	CR_HASTE_SPELL = 20;
	CR_WEAPON_SKILL_MAINHAND = 21;
	CR_WEAPON_SKILL_OFFHAND = 22;
	CR_WEAPON_SKILL_RANGED = 23;
	CR_EXPERTISE = 24;
	--
	SPELL_STAT1_NAME = "Strength"
	SPELL_STAT2_NAME = "Agility"
	SPELL_STAT3_NAME = "Stamina"
	SPELL_STAT4_NAME = "Intellect"
	SPELL_STAT5_NAME = "Spirit"
	--]]
	["statList"] = {
		{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
		{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
		{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
		{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
		{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
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
		{pattern = "爆击等级", id = CR_CRIT_MELEE},

		{pattern = "法术命中等级", id = CR_HIT_SPELL},
		{pattern = "远程命中等级", id = CR_HIT_RANGED},
		{pattern = "命中等级", id = CR_HIT_MELEE},

		{pattern = "韧性等级", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

		{pattern = "法术急速等级", id = CR_HASTE_SPELL},
		{pattern = "远程急速等级", id = CR_HASTE_RANGED},
		{pattern = "急速等级", id = CR_HASTE_MELEE},
		{pattern = "加速等级", id = CR_HASTE_MELEE}, -- [Drums of Battle]
		
		{pattern = "武器技能等级", id = CR_WEAPON_SKILL},
		{pattern = "精准等级", id = CR_EXPERTISE},
		
		{pattern = "命中躲闪等级", id = CR_HIT_TAKEN_MELEE},
		--[[
		{pattern = "dagger skill rating", id = CR_WEAPON_SKILL},
		{pattern = "sword skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed swords skill rating", id = CR_WEAPON_SKILL},
		{pattern = "axe skill rating", id = CR_WEAPON_SKILL},
		{pattern = "bow skill rating", id = CR_WEAPON_SKILL},
		{pattern = "crossbow skill rating", id = CR_WEAPON_SKILL},
		{pattern = "gun skill rating", id = CR_WEAPON_SKILL},
		{pattern = "feral combat skill rating", id = CR_WEAPON_SKILL},
		{pattern = "mace skill rating", id = CR_WEAPON_SKILL},
		{pattern = "polearm skill rating", id = CR_WEAPON_SKILL},
		{pattern = "staff skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed axes skill rating", id = CR_WEAPON_SKILL},
		{pattern = "two%-handed maces skill rating", id = CR_WEAPON_SKILL},
		{pattern = "fist weapons skill rating", id = CR_WEAPON_SKILL},
		--]]
	},
	-------------------------
	-- Added info patterns --
	-------------------------
	-- $value will be replaced with the number
	-- EX: "$value% Crit" -> "+1.34% Crit"
	-- EX: "Crit $value%" -> "Crit +1.34%"
	["$value% Crit"] = "$value% 爆击",
	["$value% Spell Crit"] = "$value% 法爆",
	["$value% Dodge"] = "$value% 躲闪",
	["$value HP"] = "$value 生命",
	["$value MP"] = "$value 法力",
	["$value AP"] = "$value 攻击强度",
	["$value RAP"] = "$value 远攻强度",
	["$value Dmg"] = "$value 法伤",
	["$value Heal"] = "$value 治疗",
	["$value Armor"] = "$value 护甲",
	["$value Block"] = "$value 格挡值",
	["$value MP5"] = "$value 施法回魔",
	["$value MP5(NC)"] = "$value 精神回魔",
	["$value HP5"] = "$value 回血",
	["$value to be Dodged/Parried"] = "$value 被躲闪/被招架",
	["$value to be Crit"] = "$value 被致命一击",
	["$value Crit Dmg Taken"] = "$value 致命一击伤害减免",
	["$value DOT Dmg Taken"] = "$value 持续伤害减免",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "属性统计",
} end)