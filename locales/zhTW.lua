--[[
Name: RatingBuster zhTW locale
Revision: $Revision: 73696 $
Translated by:
- Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
- CuteMiyu
- 小紫
- mcc
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "zhTW")
if not L then return end
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
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
L["Change number color"] = true
-- /rb rating
L["Rating"] = "屬性等級"
L["Options for Rating display"] = "設定屬性等級顯示"
-- /rb rating show
L["Show Rating conversions"] = "顯示屬性等級轉換"
L["Show Rating conversions in tooltips"] = "在提示框架中顯示屬性等級轉換結果"
-- /rb rating spell
L["Show Spell Hit/Haste"] = "顯示法術命中/加速"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "顯示命中/加速給的法術命中/加速"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "顯示物理命中/加速"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "顯示命中/加速給的物理命中/加速"
-- /rb rating detail
L["Show detailed conversions text"] = "顯示詳細轉換文字"
L["Show detailed text for Resiliance and Expertise conversions"] = "顯示韌性和熟練技能的詳細轉換文字"
-- /rb rating def
L["Defense breakdown"] = "分析防禦"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "將防禦分為避免致命、避免命中、閃躲、招架和格擋"
-- /rb rating wpn
L["Weapon Skill breakdown"] = "分析武器技能"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "將武器技能分為致命、擊中、防止被閃躲、防止被招架和防止被格擋"
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "分析熟練技能"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "將熟練技能分為防止被閃躲、防止被招架"
L["from"] = "給的"
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
	return string.format("%s %s ", show, add)
end
L.statModOptionDesc = function(show, add, from, mod)
	return string.format("%s %s %s %s ", show, mod, from, add)
end

-- /rb stat
L["Stat Breakdown"] = "基本屬性解析"
L["Changes the display of base stats"] = "設定基本屬性的解析顯示"
-- /rb stat show
L["Show base stat conversions"] = "顯示基本屬性解析"
L["Show base stat conversions in tooltips"] = "在物品提示中顯示基本屬性解析"
-- /rb stat str
L["Strength"] = "力量"
L["Changes the display of Strength"] = "自訂力量解析項目"
-- /rb stat str ap
L["Show Attack Power"] = "顯示攻擊強度"
L["Show Attack Power from Strength"] = "顯示力量給的攻擊強度"
-- /rb stat str block
L["Show Block Value"] = "顯示格檔值"
L["Show Block Value from Strength"] = "顯示力量給的格檔值"
-- /rb stat str dmg
L["Show Spell Damage"] = "顯示法傷"
L["Show Spell Damage from Strength"] = "顯示力量給的法術傷害加成"
-- /rb stat str heal
L["Show Healing"] = "顯示治療"
L["Show Healing from Strength"] = "顯示力量給的治療加成"

-- /rb stat agi
L["Agility"] = "敏捷"
L["Changes the display of Agility"] = "自訂敏捷解析項目"
-- /rb stat agi crit
L["Show Crit"] = "顯示致命"
L["Show Crit chance from Agility"] = "顯示敏捷給的致命一擊機率"
-- /rb stat agi dodge
L["Show Dodge"] = "顯示閃躲"
L["Show Dodge chance from Agility"] = "顯示敏捷給的閃躲機率"
-- /rb stat agi ap
L["Show Attack Power"] = "顯示攻擊強度"
L["Show Attack Power from Agility"] = "顯示敏捷給的攻擊強度"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "顯示遠程攻擊強度"
L["Show Ranged Attack Power from Agility"] = "顯示敏捷給的遠程攻擊強度"
-- /rb stat agi armor
L["Show Armor"] = "顯示裝甲值"
L["Show Armor from Agility"] = "顯示敏捷給的裝甲值"
-- /rb stat str heal
L["Show Healing"] = "顯示治療"
L["Show Healing from Agility"] = "顯示敏捷給的治療加成"

-- /rb stat sta
L["Stamina"] = "耐力"
L["Changes the display of Stamina"] = "自訂耐力解析項目"
-- /rb stat sta hp
L["Show Health"] = "顯示生命力"
L["Show Health from Stamina"] = "顯示耐力給的生命力"
-- /rb stat sta dmg
L["Show Spell Damage"] = "顯示法傷"
L["Show Spell Damage from Stamina"] = "顯示耐力給的法術傷害加成"

-- /rb stat int
L["Intellect"] = "智力"
L["Changes the display of Intellect"] = "自訂智力解析項目"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "顯示法術致命"
L["Show Spell Crit chance from Intellect"] = "顯示智力給的法術致命一擊機率"
-- /rb stat int mp
L["Show Mana"] = "顯示法力"
L["Show Mana from Intellect"] = "顯示智力給的法力"
-- /rb stat int dmg
L["Show Spell Damage"] = "顯示法傷"
L["Show Spell Damage from Intellect"] = "顯示智力給的法術傷害加成"
-- /rb stat int heal
L["Show Healing"] = "顯示治療"
L["Show Healing from Intellect"] = "顯示智力給的治療加成"
-- /rb stat int mp5
L["Show Mana Regen"] = "顯示施法回魔"
L["Show Mana Regen while casting from Intellect"] = "顯示智力給的施法中法力恢復量"
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "顯示一般回魔"
L["Show Mana Regen while NOT casting from Intellect"] = "顯示在未施法狀態時，智力給的法力恢復量"
-- /rb stat int rap
L["Show Ranged Attack Power"] = "顯示遠程攻擊強度"
L["Show Ranged Attack Power from Intellect"] = "顯示智力給的遠程攻擊強度"
-- /rb stat int armor
L["Show Armor"] = "顯示裝甲值"
L["Show Armor from Intellect"] = "顯示智力給的裝甲值"

-- /rb stat spi
L["Spirit"] = "精神"
L["Changes the display of Spirit"] = "自訂精神解析項目"
-- /rb stat spi mp5
L["Show Mana Regen"] = "顯示施法回魔"
L["Show Mana Regen while casting from Spirit"] = "顯示在施法狀態時，精神給的法力恢復量"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "顯示一般回魔"
L["Show Mana Regen while NOT casting from Spirit"] = "顯示在未施法狀態時，精神給的法力恢復量"
-- /rb stat spi hp5
L["Show Health Regen"] = "顯示回血"
L["Show Health Regen from Spirit"] = "顯示精神給的戰鬥外回生命力"
-- /rb stat spi dmg
L["Show Spell Damage"] = "顯示法傷"
L["Show Spell Damage from Spirit"] = "顯示精神給的法術傷害加成"
-- /rb stat spi heal
L["Show Healing"] = "顯示治療"
L["Show Healing from Spirit"] = "顯示精神給的治療加成"

L["Armor"] = "Armor"
L["Changes the display of Armor"] = "Changes the display of Armor"
L["Attack Power"] = "Attack Power"
L["Changes the display of Attack Power"] = "Changes the display of Attack Power"

-- /rb sum
L["Stat Summary"] = "屬性統計"
L["Options for stat summary"] = "自訂屬性選項"
-- /rb sum show
L["Show stat summary"] = "顯示屬性統計"
L["Show stat summary in tooltips"] = "在物品提示中顯示屬性統計"
-- /rb sum ignore
L["Ignore settings"] = "忽略設定"
L["Ignore stuff when calculating the stat summary"] = "設定在統計總合時所要忽略的項目"
-- /rb sum ignore unused
L["Ignore unused items types"] = "忽略不可能使用的物品"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "只顯示在你會使用的物品上"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "忽略已裝備的物品"
L["Hide stat summary for equipped items"] = "隱藏已裝備的物品的統計總合"
-- /rb sum ignore enchant
L["Ignore enchants"] = "忽略附魔"
L["Ignore enchants on items when calculating the stat summary"] = "計算時忽略物品上的附魔效果"
-- /rb sum ignore gem
L["Ignore gems"] = "忽略寶石"
L["Ignore gems on items when calculating the stat summary"] = "計算時忽略物品上的寶石效果"
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
L["Show the sigma icon before summary listing"] = "在屬性統計前顯示圖示"
-- /rb sum title
L["Show title text"] = "顯示標題"
L["Show the title text before summary listing"] = "在屬性統計前顯示標題文字"
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
L["Sum Health"] = "統計生命力"
L["Health <- Health Stamina"] = "生命力 ← 生命力、耐力"
-- /rb sum stat mp
L["Sum Mana"] = "統計法力"
L["Mana <- Mana Intellect"] = "法力 ← 法力、智力"
-- /rb sum stat ap
L["Sum Attack Power"] = "統計攻擊強度"
L["Attack Power <- Attack Power Strength, Agility"] = "攻擊強度 ← 攻擊強度、力量、敏捷"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "統計遠程攻擊強度"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "遠程攻擊強度 ← 遠程攻擊強度、智力、攻擊強度、力量、敏捷"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "統計法術傷害"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "法術傷害 ← 法術傷害、智力、精神、耐力"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "統計神聖法術傷害"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "神聖法術傷害 ← 神聖法術傷害、法術傷害、智力、精神"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "統計秘法法術傷害"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "秘法法術傷害 ← 秘法法術傷害、法術傷害、智力"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "統計火焰法術傷害"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "火焰法術傷害 ← 火焰法術傷害、法術傷害、智力、耐力"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "統計自然法術傷害"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "自然法術傷害 ← 自然法術傷害、法術傷害、智力"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "統計冰霜法術傷害"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "冰霜法術傷害 ← 冰霜法術傷害、法術傷害、智力"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "統計暗影法術傷害"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "暗影法術傷害 ← 暗影法術傷害、法術傷害、智力、精神、耐力"
-- /rb sum stat heal
L["Sum Healing"] = "統計治療"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "治療 ← 治療、智力、精神、敏捷、力量"
-- /rb sum stat hit
L["Sum Hit Chance"] = "統計命中機率"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "命中機率 ← 命中等級、武器技能等級"
-- /rb sum stat crit
L["Sum Crit Chance"] = "統計致命一擊機率"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "致命一擊機率 ← 致命一擊等級、敏捷、武器技能等級"
-- /rb sum stat haste
L["Sum Haste"] = "統計加速"
L["Haste <- Haste Rating"] = "加速 ← 加速等級"
-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "統計法術致命一擊機率"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "法術致命一擊機率 ← 法術致命一擊等級、智力"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "統計法術命中機率"
L["Spell Hit Chance <- Spell Hit Rating"] = "法術命中機率 ← 法術命中機率"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "統計法術加速"
L["Spell Haste <- Spell Haste Rating"] = "法術加速 ← 法術加速等級"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "統計法力恢復"
L["Mana Regen <- Mana Regen Spirit"] = "法力恢復 ← 法力恢復、精神"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "統計法力恢復 (未施法時)"
L["Mana Regen while not casting <- Spirit"] = "法力恢復 (未施法時) ← 精神"
-- /rb sum stat hp5
L["Sum Health Regen"] = "統計生命恢復"
L["Health Regen <- Health Regen"] = "生命恢復 ← 生命恢復"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "統計生命恢復 (未戰鬥時)"
L["Health Regen when out of combat <- Spirit"] = "生命恢復 (未戰鬥時) ← 精神"
-- /rb sum stat armor
L["Sum Armor"] = "統計裝甲值"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "裝甲值 ← 物品裝甲、裝甲加成、敏捷、智力"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "統計格擋值"
L["Block Value <- Block Value Strength"] = "格擋值 ← 格擋值、力量"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "統計閃躲機率"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "閃躲機率 ← 閃躲等級、敏捷、防禦等級"
-- /rb sum stat parry
L["Sum Parry Chance"] = "統計招架機率"
L["Parry Chance <- Parry Rating Defense Rating"] = "招架機率 ← 招架等級、防禦等級"
-- /rb sum stat block
L["Sum Block Chance"] = "統計格擋機率"
L["Block Chance <- Block Rating Defense Rating"] = "格擋機率 ← 格擋等級、防禦等級"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "統計迴避命中"
L["Hit Avoidance <- Defense Rating"] = "迴避命中 ← 防禦等級"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "統計迴避致命一擊"
L["Crit Avoidance <- Defense Rating Resilience"] = "迴避致命一擊 ← 防禦等級、韌性"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "統計防止被閃躲"
L["Dodge Neglect <- Expertise Weapon Skill Rating"] = "防止被閃躲 ← 熟練技能、武器技能等級" -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "統計防止被招架"
L["Parry Neglect <- Expertise Weapon Skill Rating"] = "防止被招架 ← 熟練技能、武器技能等級" -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "統計防止被格擋"
L["Block Neglect <- Weapon Skill Rating"] = "防止被格擋 ← 武器技能等級"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "統計秘法抗性"
L["Arcane Resistance Summary"] = "統計秘法抗性"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "統計火焰抗性"
L["Fire Resistance Summary"] = "統計火焰抗性"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "統計自然抗性"
L["Nature Resistance Summary"] = "統計自然抗性"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "統計冰霜抗性"
L["Frost Resistance Summary"] = "統計冰霜抗性"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "統計暗影抗性"
L["Shadow Resistance Summary"] = "統計暗影抗性"
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = "統計武器最大傷害"
L["Weapon Max Damage Summary"] = "統計武器最大傷害"
-- /rb sum stat pen
L["Sum Penetration"] = "統計法術穿透力"
L["Spell Penetration Summary"] = "統計法術穿透力"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "統計無視護甲"
L["Ignore Armor Summary"] = "統計無視護甲"
L["Sum Armor Penetration"] = "統計護甲穿透"
L["Armor Penetration Summary"] = "統計無視護甲穿透"
L["Sum Armor Penetration Rating"] = "統計無視護甲穿透等級"
L["Armor Penetration Rating Summary"] = "統計無視護甲穿透等級"
-- /rb sum stat weapondps
--["Sum Weapon DPS"] = true,
--["Weapon DPS Summary"] = true,
-- /rb sum statcomp str
L["Sum Strength"] = "統計力量"
L["Strength Summary"] = "統計力量"
-- /rb sum statcomp agi
L["Sum Agility"] = "統計敏捷"
L["Agility Summary"] = "統計敏捷"
-- /rb sum statcomp sta
L["Sum Stamina"] = "統計耐力"
L["Stamina Summary"] = "統計耐力"
-- /rb sum statcomp int
L["Sum Intellect"] = "統計智力"
L["Intellect Summary"] = "統計智力"
-- /rb sum statcomp spi
L["Sum Spirit"] = "統計精神"
L["Spirit Summary"] = "統計精神"
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "統計命中等級"
L["Hit Rating Summary"] = "統計命中等級"
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "統計致命等級"
L["Crit Rating Summary"] = "統計致命等級"
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "統計加速等級"
L["Haste Rating Summary"] = "統計加速等級"
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "統計法術命中等級"
L["Spell Hit Rating Summary"] = "統計法術命中等級"
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "統計法術致命等級"
L["Spell Crit Rating Summary"] = "統計法術致命等級"
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "統計法術加速等級"
L["Spell Haste Rating Summary"] = "統計法術加速等級"
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "統計閃躲等級"
L["Dodge Rating Summary"] = "統計閃躲等級"
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "統計招架等級"
L["Parry Rating Summary"] = "統計招架等級"
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "統計格檔等級"
L["Block Rating Summary"] = "統計格檔等級"
-- /rb sum statcomp res
L["Sum Resilience"] = "統計韌性"
L["Resilience Summary"] = "統計韌性"
-- /rb sum statcomp def
L["Sum Defense"] = "統計防禦"
L["Defense <- Defense Rating"] = "防禦 ← 防禦等級"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "統計武器技能"
L["Weapon Skill <- Weapon Skill Rating"] = "武器技能 ← 武器技能等級"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "統計熟練技能"
L["Expertise <- Expertise Rating"] = "熟練技能 ← 熟練等級"
-- /rb sum statcomp tp
L["Sum TankPoints"] = "統計坦克點"
L["TankPoints <- Health Total Reduction"] = "坦克點 ← 生命力、傷害減免總值"
-- /rb sum statcomp tr
L["Sum Total Reduction"] = "統計傷害減免總值"
L["Total Reduction <- Armor Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "傷害減免總值 ← 護甲、閃躲、招架、格擋、格檔值、防禦、韌性、怪物未擊中、怪物致命、怪物輾壓、DamageTakenMods (?)"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "統計傷害迴避"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "傷害迴避 ← 閃躲、招架、怪物未擊中、格擋(選項)"
-- /rb sum gem
L["Gems"] = "預設寶石"
L["Auto fill empty gem slots"] = "空寶石插槽的預設寶石"
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "預設寶石的物品編號或連結"
L["<ItemID|Link>"] = "<物品編號|連結>"
L["%s is now set to %s"] = "%s 現在被設定為 %s"
L["Queried server for Gem: %s. Try again in 5 secs."] = "嘗試查詢編號：%s，請5秒後再試一次。"
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "物品等級: "
L["ItemID: "] = "物品編號: "
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
	{pattern = "提高.-(%d+)", addInfo = "AfterNumber",},
	{pattern = "提升.-(%d+)", addInfo = "AfterNumber",}, -- [奎克米瑞之眼] ID:27683
	{pattern = "(%d+)。", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "佩戴者.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", "和", ",", "。", " 持續 ", "&", "及", "並", "，",
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
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "防禦等級", id = CR_DEFENSE_SKILL},
	{pattern = "閃躲等級", id = CR_DODGE},
	{pattern = "格擋等級", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "招架等級", id = CR_PARRY},

	{pattern = "法術致命一擊等級", id = CR_CRIT_SPELL},
	{pattern = "遠程攻擊致命一擊等級", id = CR_CRIT_RANGED},
	{pattern = "致命一擊等級", id = CR_CRIT},

	{pattern = "法術命中等級", id = CR_HIT_SPELL},
	{pattern = "遠程命中等級", id = CR_HIT_RANGED},
	{pattern = "命中等級", id = CR_HIT},

	{pattern = "韌性", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "法術加速等級", id = CR_HASTE_SPELL},
	{pattern = "遠程攻擊加速等級", id = CR_HASTE_RANGED},
	{pattern = "加速等級", id = CR_HASTE},
	{pattern = "攻擊速度等級", id = CR_HASTE}, -- [Drums of Battle]

	{pattern = "熟練等級", id = CR_EXPERTISE}, -- 2.3

	{pattern = "護甲穿透等級", id = CR_ARMOR_PENETRATION},
	{pattern = string.lower(ARMOR), id = ARMOR},
	{pattern = "攻击强度", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% 致命"
L["$value% Spell Crit"] = "$value% 法術致命"
L["$value% Dodge"] = "$value% 閃躲"
L["$value HP"] = "$value 生命"
L["$value MP"] = "$value 法力"
L["$value AP"] = "$value 強度"
L["$value RAP"] = "$value 遠程強度"
L["$value Spell Dmg"] = "$value 法傷"
L["$value Heal"] = "$value 治療"
L["$value Armor"] = "$value 裝甲"
L["$value Block"] = "$value 格擋值"
L["$value MP5"] = "$value 施法回魔"
L["$value MP5(NC)"] = "$value 一般回魔"
L["$value HP5"] = "$value 回血"
L["$value to be Dodged/Parried"] = "$value 被閃躲/被招架"
L["$value to be Crit"] = "$value 被致命"
L["$value Crit Dmg Taken"] = "$value 致命傷害減免"
L["$value DOT Dmg Taken"] = "$value 持續傷害減免"
L["$value% Parry"] = "$value% 招架"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value 法術"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "屬性統計"