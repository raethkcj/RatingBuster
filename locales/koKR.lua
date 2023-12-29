--[[
Name: RatingBuster koKR locale
Revision: $Revision: 73696 $
Translated by:
- kcgcom, fenlis (jungseop.park@gmail.com)
]]

---@class RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "koKR")
if not L then return end
local StatLogic = LibStub("StatLogic")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L["RatingBuster Options"] = "RatingBuster 설정"
---------------------------
-- Slash Command Options --
---------------------------
-- /rb win
L["Options Window"] = "설정창"
L["Shows the Options Window"] = "설정창을 표시합니다."
-- /rb statmod
L["Enable Stat Mods"] = "능력치 애드온 사용"
L["Enable support for Stat Mods"] = "능력치 애드온 지원을 사용합니다."
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "방어행동 점감 효과 사용"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "회피, 무기 막기, 빗맞힘 수치를 현재 능력치에서 점감 효과를 적용하여 계산합니다."
-- /rb itemid
L["Show ItemID"] = "아이템 ID 표시"
L["Show the ItemID in tooltips"] = "툴팁에 아이템 ID를 표시합니다."
-- /rb itemlevel
L["Show ItemLevel"] = "아이템 레벨 표시"
L["Show the ItemLevel in tooltips"] = "툴팁에 아이템 레벨을 표시합니다."
-- /rb usereqlv
L["Use required level"] = "최소 요구 레벨 사용"
L["Calculate using the required level if you are below the required level"] = "레벨이 낮아 사용하지 못하는 경우 최소 요구 레벨에 따라 계산합니다."
-- /rb setlevel
L["Set level"] = "레벨 설정"
L["Set the level used in calculations (0 = your level)"] = "계산에 적용할 레벨을 설정합니다. (0 = 자신 레벨)"
-- /rb color
L["Change text color"] = "글자 색상 변경"
L["Changes the color of added text"] = "추가된 글자의 색상을 변경합니다."
L["Change number color"] = true
-- /rb rating
L["Rating"] = "평점"
L["Options for Rating display"] = "평점 표시에 대한 설정입니다."
-- /rb rating show
L["Show Rating conversions"] = "평점 변화 표시"
L["Show Rating conversions in tooltips"] = "툴팁에 평점 변화를 표시합니다."
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = true
L["Show Spell Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating physical
L["Show Physical Hit/Haste"] = true
L["Show Physical Hit/Haste from Hit/Haste Rating"] = true
-- /rb rating detail
L["Show detailed conversions text"] = "세부적인 평점 변화 표시"
L["Show detailed text for Resilience and Expertise conversions"] = "탄력도와 숙련의 세부적인 평점 변화 표시를 사용합니다."
-- /rb rating def
L["Defense breakdown"] = "방어 숙련 세분화"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "치명타 공격 회피, 공격 회피, 회피, 무기 막기, 방패 막기 등으로 방어 숙련을 세분화합니다."
-- /rb rating wpn
L["Weapon Skill breakdown"] = "무기 숙련 세분화"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "치명타, 공격, 회피 무시, 무기 막기 무시, 방패 막기 무시 등으로 무기 숙련를 세분화합니다."
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "숙련 세분화"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "회피 무시와 무기막기 무시 등으로 숙련을 세분화 합니다."

-- /rb stat
--["Stat Breakdown"] = "능력치",
L["Changes the display of base stats"] = "기본 능력치 표시방법을 변경합니다."
-- /rb stat show
L["Show base stat conversions"] = "기본 능력치 변화 표시"
L["Show base stat conversions in tooltips"] = "툴팁에 기본 능력치의 변화를 표시합니다."
-- /rb stat str
L["Strength"] = "힘"
L["Changes the display of Strength"] = "힘에 대한 표시방법을 변경합니다."

-- /rb stat agi
L["Agility"] = "민첩성"
L["Changes the display of Agility"] = "민첩성 표시방법을 변경합니다."
-- /rb stat agi crit
L["Show Crit"] = "치명타 표시"
L["Show Crit chance from Agility"] = "민첩성에 의한 치명타 표시"
-- /rb stat agi dodge
L["Show Dodge"] = "회피 표시"
L["Show Dodge chance from Agility"] = "민첩에 의한 회피율을 표시합니다."

-- /rb stat sta
L["Stamina"] = "체력"
L["Changes the display of Stamina"] = "체력의 표시방법을 변경합니다."

-- /rb stat int
L["Intellect"] = "지능"
L["Changes the display of Intellect"] = "지능 표시방법을 변경합니다."
-- /rb stat int spellcrit
L["Show Spell Crit"] = "주문 극대화 표시"
L["Show Spell Crit chance from Intellect"] = "지능에 의한 주문 극대화율 표시"

-- /rb stat spi
L["Spirit"] = "정신력"
L["Changes the display of Spirit"] = "정신력의 표시방법을 변경합니다."

L["Armor"] = "Armor"
L["Changes the display of Armor"] = "Changes the display of Armor"
L["Attack Power"] = "Attack Power"
L["Changes the display of Attack Power"] = "Changes the display of Attack Power"

-- /rb sum
L["Stat Summary"] = "능력치 요약"
L["Options for stat summary"] = "능력치 요약에 대한 설정입니다."
-- /rb sum show
L["Show stat summary"] = "능력치 요약 표시"
L["Show stat summary in tooltips"] = "툴팁에 능력치 요약을 표시합니다."
-- /rb sum ignore
L["Ignore settings"] = "제외 설정"
L["Ignore stuff when calculating the stat summary"] = "능력치 요약 계산에 포함되지 않습니다."
-- /rb sum ignore unused
L["Ignore unused item types"] = "쓸모없는 아이템 제외"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Show stat summary only for highest level armor type and items you can use with uncommon quality and up"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "착용 아이템 제외"
L["Hide stat summary for equipped items"] = "착용하고 있는 아이템에 대한 능력치 요약은 표시하지 않습니다."
-- /rb sum ignore enchant
L["Ignore enchants"] = "마법부여 제외"
L["Ignore enchants on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 마법부여를 포함하지 않습니다."
-- /rb sum ignore gem
L["Ignore gems"] = "보석 제외"
L["Ignore gems on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 보석을 포함하지 않습니다."
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
-- /rb sum diffstyle
L["Display style for diff value"] = "차이값 표시 형식"
L["Display diff values in the main tooltip or only in compare tooltips"] = "주요 툴팁 이나 비교 툴팁에만 차이값을 표시합니다."
L["Hide Blizzard Item Comparisons"] = "기본 아이템 비교 숨김"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "툴팁에 블리자드의 기본 아이템 비교를 숨깁니다."
-- /rb sum space
L["Add empty line"] = "구분선 추가"
L["Add a empty line before or after stat summary"] = "능력치 요약 앞 혹은 뒤에 구분선을 추가합니다."
-- /rb sum space before
L["Add before summary"] = "요약 앞에 추가"
L["Add a empty line before stat summary"] = "능력치 요약의 앞에 구분선을 추가합니다."
-- /rb sum space after
L["Add after summary"] = "요약 뒤에 추가"
L["Add a empty line after stat summary"] = "능력치 요약의 뒤에 구분선을 추가합니다."
-- /rb sum icon
L["Show icon"] = "아이콘 표시"
L["Show the sigma icon before summary listing"] = "요약 목록 앞에 시그마 아이콘을 표시합니다."
-- /rb sum title
L["Show title text"] = "제목 표시"
L["Show the title text before summary listing"] = "요약 목록 앞에 제목을 표시합니다."
-- /rb sum showzerostat
L["Show zero value stats"] = "제로 능력치 표시"
L["Show zero value stats in summary for consistancy"] = "구성에 대한 요약에 제로 능력치를 표시합니다."
-- /rb sum calcsum
L["Calculate stat sum"] = "능력치 합계 계산"
L["Calculate the total stats for the item"] = "아이템에 대한 총 능력치를 계산합니다."
-- /rb sum calcdiff
L["Calculate stat diff"] = "능력치 차이 계산"
L["Calculate the stat difference for the item and equipped items"] = "아이템과 착용한 아이템과의 능력치 차이를 계산합니다."
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "능력치 요약 정렬"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "능력치 요약을 알파벳순으로 정렬합니다, 능력치별로 정렬하려면 비활성화하세요.(기본, 물리적, 주문, 탱크)"
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "회피 요약에 방어율 포함"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "회피 요약에 방어율을 포함시킵니다. 회피, 무기 막기, 빗맞힘만 사용하려면 비활성화하세요."
-- /rb sum basic
L["Stat - Basic"] = "능력치 - 기본"
L["Choose basic stats for summary"] = "기본 능력치를 선택합니다."
-- /rb sum physical
L["Stat - Physical"] = "능력치 - 물리적"
L["Choose physical damage stats for summary"] = "물리적 공격력 능력치를 선택합니다."
-- /rb sum spell
L["Stat - Spell"] = "능력치 - 주문"
L["Choose spell damage and healing stats for summary"] = "주문 공격려과 치유량을 선택합니다."
-- /rb sum tank
L["Stat - Tank"] = "능력치 - 탱크"
L["Choose tank stats for summary"] = "탱크 능력치를 선택합니다."
-- /rb sum stat hp
L["Sum Health"] = "생명력"
L["Health <- Health Stamina"] = "생명력 <- 생명력, 체력"
-- /rb sum stat mp
L["Sum Mana"] = "마나"
L["Mana <- Mana Intellect"] = "마나 < 마나, 지능"
-- /rb sum stat ap
L["Sum Attack Power"] = "전투력"
L["Attack Power <- Attack Power Strength, Agility"] = "전투력 <- 전투력, 힘, 민첩성"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "원거리 전투력"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "원거리 전투력 <- 원거리 전투력, 지능, 전투력, 힘, 민첩성"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "주문 공격력"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "주문 공격력 <- 주문 공격력, 지능, 정신력, 체력"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "신성 주문 공격력"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "신성 주문 공격력 <- 신성 주문 공격력, 주문 공격력, 지능, 정신력"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "비전 주문 공격력"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "비전 주문 공격력 <- 비전 주문 공격력, 주문 공격력, 지능"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "화염 주문 공격력"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "화염 주문 공격력 <- 화염 주문 공격력, 주문 공격력, 지능, 체력"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "자연 주문 공격력"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "자연 주문 공격력 <- 자연 주문 공격력, 주문 공격력, 지능"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "냉기 주문 공격력"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "냉기 주문 공격력 <- 냉기 주문 공격력, 주문 공격력, 지능"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "암흑 주문 공격력"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "암흑 주문 공격력 <- 암흑 주문 공격력, 주문 공격력, 지능, 정신력, 체력"
-- /rb sum stat heal
L["Sum Healing"] = "치유량"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "치유량 <- 치유량, 지능, 정신력, 민첩, 힘"
-- /rb sum stat hit
L["Sum Hit Chance"] = "적중률"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "적중률 <- 적중도, 무기 숙력도"
-- /rb sum stat crit
L["Sum Crit Chance"] = "치명타율"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도"
-- /rb sum stat haste
L["Sum Haste"] = "공격 가속"
L["Haste <- Haste Rating"] = "공격 가속 <- 공격 가속도"
L["Sum Ranged Hit Chance"] = "원거리 적중률 합계"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "원거리 적중률 <- 적중도, 무기 숙련도, 원거리 적중도"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "원거리 적중도 합계"
L["Ranged Hit Rating Summary"] = "원거리 적중도 요약"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "원거리 치명타율 합계"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "원거리 치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도, 치명타 적중도"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "원거리 치명타 적중도 합계"
L["Ranged Crit Rating Summary"] = "원거리 치명타 적중도 요약"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "원거리 공격 가속율 합계"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "원거리 공격 가속율 <- 공격 가속도, 원거리 가속율"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "원거리 공격 가속도 합계"
L["Ranged Haste Rating Summary"] = "원거리 공격 가속도 요약"

-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "주문 극대화율"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "주문 극대화율 <- 주문 극대화 적중도, 지능"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "주문 적중율"
L["Spell Hit Chance <- Spell Hit Rating"] = "주문 적중율 <- 주문 적중도"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "주문 가속"
L["Spell Haste <- Spell Haste Rating"] = "주문 가속 <- 주문 가속도"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "마나 재생"
L["Mana Regen <- Mana Regen Spirit"] = "마나 재생 <- 마나 재생, 정신력"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "미시전 시 마나 재생"
L["Mana Regen while not casting <- Spirit"] = "미시전 시 마나 재생 <- 정신력"
-- /rb sum stat hp5
L["Sum Health Regen"] = "생명력 재생"
L["Health Regen <- Health Regen"] = "생명력 재생 <- 생명력 재생"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "비전투중 생명력 재생"
L["Health Regen when out of combat <- Spirit"] = "비전투중 생명력 재생 <- 정신력"
-- /rb sum stat armor
L["Sum Armor"] = "방어도"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "방어도 <- 아이템의 방어도, 효과의 방어도, 민첩성, 지능"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "피해 방어량"
L["Block Value <- Block Value Strength"] = "피해 방어량 <- 피해 방어량, 힘"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "회피율"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "회피율 <- 회피 숙련도, 민첩성, 방어 숙련도"
-- /rb sum stat parry
L["Sum Parry Chance"] = "무기 막기 확률"
L["Parry Chance <- Parry Rating Defense Rating"] = "무기 막기 확률 <- 무기 막기 숙련도, 방어 숙련도"
-- /rb sum stat block
L["Sum Block Chance"] = "방패 막기 확률"
L["Block Chance <- Block Rating Defense Rating"] = "방패 막기 확률 <- 방패 막기 숙련도, 방어 숙련도"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "공격 회피"
L["Hit Avoidance <- Defense Rating"] = "공격 회피 <- 방어 숙련도"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "치명타 공격 회피"
L["Crit Avoidance <- Defense Rating Resilience"] = "치명타 공격 회피 <- 방어 숙련도, 탄력도"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "회피 무시"
L["Dodge Neglect <- Expertise Weapon Skill Rating"] = "회피 무시 <- 숙련도, 무기 숙련도" -- 2.3.0
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "무기 막기 무시"
L["Parry Neglect <- Expertise Weapon Skill Rating"] = "무기 막기 무시 <- 숙련도, 무기 숙련도" -- 2.3.0
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "방패 막기 무시"
L["Block Neglect <- Weapon Skill Rating"] = "방패 막기 무시 <- 무기 숙련도"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "비전 저항력"
L["Arcane Resistance Summary"] = "비전 저항력 요약"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "화염 저항력"
L["Fire Resistance Summary"] = "화염 저항력 요약"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "자연 저항력"
L["Nature Resistance Summary"] = "자연 저항력 요약"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "냉기 저항력"
L["Frost Resistance Summary"] = "냉기 저항력 요약"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "암흑 저항력"
L["Shadow Resistance Summary"] = "암흑 저항력 요약"
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = true
L["Weapon DPS Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = "관통력"
L["Spell Penetration Summary"] = "주문 관통력 요약"
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "방어도 무시"
L["Ignore Armor Summary"] = "방어도 무시 요약"
L["Sum Armor Penetration"] = "방어도 관통력 합계"
L["Armor Penetration Summary"] = "방어도 관통력 요약"
L["Sum Armor Penetration Rating"] = "방어도 관통도 합계"
L["Armor Penetration Rating Summary"] = "방어도 관통도 요약"
-- /rb sum statcomp str
L["Sum Strength"] = "힘"
L["Strength Summary"] = "힘 요약"
-- /rb sum statcomp agi
L["Sum Agility"] = "민첩성"
L["Agility Summary"] = "민첩성 요약"
-- /rb sum statcomp sta
L["Sum Stamina"] = "체력"
L["Stamina Summary"] = "체력 요약"
-- /rb sum statcomp int
L["Sum Intellect"] = "지능"
L["Intellect Summary"] = "지능 요약"
-- /rb sum statcomp spi
L["Sum Spirit"] = "정신력"
L["Spirit Summary"] = "정신력 요약"
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "적중도"
L["Hit Rating Summary"] = "적중도 요약"
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "치명타율"
L["Crit Rating Summary"] = "치명타율 요약"
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "공격 가속도"
L["Haste Rating Summary"] = "공격 가속도 요약"
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "주문 적중도"
L["Spell Hit Rating Summary"] = "주문 적중도 요약"
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "주문 극대화율"
L["Spell Crit Rating Summary"] = "주문 극대화율 요약"
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "주문 가속도"
L["Spell Haste Rating Summary"] = "주문 가속도 요약"
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "회피율"
L["Dodge Rating Summary"] = "회피율 요약"
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "무기 막기율"
L["Parry Rating Summary"] = "무기 막기율 요약"
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "방어율"
L["Block Rating Summary"] = "방어율 요약"
-- /rb sum statcomp res
L["Sum Resilience"] = "탄력도"
L["Resilience Summary"] = "탄력도 요약"
-- /rb sum statcomp def
L["Sum Defense"] = "방어 숙련"
L["Defense <- Defense Rating"] = "방어 숙련 <- 방어 숙련도"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "무기 숙련"
L["Weapon Skill <- Weapon Skill Rating"] = "무기 숙련 <- 무기 숙련도"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "숙련"
L["Expertise <- Expertise Rating"] = "숙련 <- 숙련도"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "회피량"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "회피량 <- 회피, 무기 막기, 몹빗맞힘, 방어(선택적)"

-- /rb sum gem
L["Gems"] = "보석"
L["Auto fill empty gem slots"] = "빈 보석 슬롯을 자동으로 채웁니다."
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "당신이 좋아하는 보석의 아이템ID & 링크로 자동으로 채웁니다."
L["<ItemID|Link>"] = "<아이템ID|링크>"
L["%s is now set to %s"] = "현재 %s에 %s 설정"
L["Queried server for Gem: %s. Try again in 5 secs."] = "서버에서 알수없는 보석: %s. 5초뒤 다시하세요."
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "아이템레벨: "
L["ItemID: "] = "아이템ID: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = true
L["$class Self Buffs"] = true -- $class will be replaced with localized player class
L["Raid Buffs"] = true

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
	{pattern = "(%d+)만큼 증가합니다.", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterNumber",},
	--		{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	--		{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}
L["separators"] = {
	"/", " and ", ",", "%. ", " for ", "&", ":", "\n"
}
--[[
SPELL_STAT1_NAME = "힘"
SPELL_STAT2_NAME = "민첩성"
SPELL_STAT3_NAME = "체력"
SPELL_STAT4_NAME = "지능"
SPELL_STAT5_NAME = "정신력"
--]]
L["statList"] = {
	{pattern = SPELL_STAT1_NAME:lower(), id = StatLogic.Stats.Strength}, -- Strength
	{pattern = SPELL_STAT2_NAME:lower(), id = StatLogic.Stats.Agility}, -- Agility
	{pattern = SPELL_STAT3_NAME:lower(), id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = SPELL_STAT4_NAME:lower(), id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = SPELL_STAT5_NAME:lower(), id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "방어 숙련도", id = StatLogic.Stats.DefenseRating},
	{pattern = "회피 숙련도", id = StatLogic.Stats.DodgeRating},
	{pattern = "방패 막기 숙련도", id = StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "무기 막기 숙련도", id = StatLogic.Stats.ParryRating},

	{pattern = "주문 극대화 적중도", id = StatLogic.Stats.SpellCritRating},
	{pattern = "주문의 극대화 적중도", id = StatLogic.Stats.SpellCritRating},
	{pattern = "원거리 치명타 적중도", id = StatLogic.Stats.RangedCritRating},
	{pattern = "치명타 적중도", id = StatLogic.Stats.CritRating},
	{pattern = "근접 치명타 적중도", id = StatLogic.Stats.MeleeCritRating},

	--		{pattern = "주문의 적중도", id = StatLogic.Stats.SpellHitRating},
	{pattern = "주문 적중도", id = StatLogic.Stats.SpellHitRating},
	{pattern = "원거리 적중도", id = StatLogic.Stats.RangedHitRating},
	{pattern = "적중도", id = StatLogic.Stats.HitRating},

	{pattern = "탄력도", id = StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{pattern = "주문 시전 가속도", id = StatLogic.Stats.SpellHasteRating},
	{pattern = "원거리 공격 가속도", id = StatLogic.Stats.RangedHasteRating},
	{pattern = "공격 가속도", id = StatLogic.Stats.HasteRating},
	{pattern = "가속도", id = StatLogic.Stats.HasteRating}, -- [Drums of Battle]

	{pattern = "숙련도", id = StatLogic.Stats.ExpertiseRating},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.Stats.AllStats},

	{pattern = "방어구 관통력", id = StatLogic.Stats.ArmorPenetrationRating},	--armor penetration rating
	{pattern = ARMOR:lower(), id = ARMOR},
	{pattern = "전투력이", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "치명타 $value%"
L["$value% Spell Crit"] = "극대화 $value%"
L["$value% Dodge"] = "회피 $value%"
L["$value HP"] = "생명력 $value"
L["$value MP"] = "마나 $value"
L["$value AP"] = "전투력 $value"
L["$value RAP"] = "원거리 전투력 $value"
L["$value Spell Dmg"] = "공격력 $value"
L["$value Heal"] = "치유량 $value"
L["$value Armor"] = "방어도 $value"
L["$value Block"] = "방어 $value"
L["$value MP5"] = "$value MP5"
L["$value MP5(NC)"] = "$value MP5(NC)"
L["$value HP5"] = "$value HP5"
L["$value HP5(NC)"] = true
L["$value to be Dodged/Parried"] = "이후 회피 감소/무기막기 감소 $value"
L["$value to be Crit"] = "이후 치명타 $value"
L["$value Crit Dmg Taken"] = "가질 치명타 데미지 $value"
L["$value DOT Dmg Taken"] = "가질 DOT 데미지 $value"
L["$value Dmg Taken"] = true
L["$value% Parry"] = "무막 $value%"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "주문 $value"

L["EMPTY_SOCKET_RED"] = EMPTY_SOCKET_RED -- EMPTY_SOCKET_RED = "Red Socket";
L["EMPTY_SOCKET_YELLOW"] = EMPTY_SOCKET_YELLOW -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
L["EMPTY_SOCKET_BLUE"] = EMPTY_SOCKET_BLUE -- EMPTY_SOCKET_BLUE = "Blue Socket";
L["EMPTY_SOCKET_META"] = EMPTY_SOCKET_META -- EMPTY_SOCKET_META = "Meta Socket";

L["HEALING"] = STAT_SPELLHEALING
L["SPELL_CRIT"] = PLAYERSTAT_SPELL_COMBAT .. " " .. SPELL_CRIT_CHANCE
L["STR"] = SPELL_STAT1_NAME
L["AGI"] = SPELL_STAT2_NAME
L["STA"] = SPELL_STAT3_NAME
L["INT"] = SPELL_STAT4_NAME
L["SPI"] = SPELL_STAT5_NAME
L["PARRY"] = PARRY
L["MANA_REG"] = "마나 회복량"
L["NORMAL_MANA_REG"] = "마나 회복량 (시전하지)"
L["HEALTH_REG"] = "생명력 재생"
L["NORMAL_HEALTH_REG"] = "생명력 재생 (비전투)"
L["PET_STA"] = PET .. SPELL_STAT3_NAME -- Pet Stamina
L["PET_INT"] = PET .. SPELL_STAT4_NAME -- Pet Intellect
L["StatModOptionName"] = "%2$s %1$s"

L["IGNORE_ARMOR"] = "방어도 무시"
L["MELEE_DMG"] = "근접 무기 "..DAMAGE -- DAMAGE = "Damage"

L[StatLogic.Stats.Strength] = SPELL_STAT1_NAME
L[StatLogic.Stats.Agility] = SPELL_STAT2_NAME
L[StatLogic.Stats.Stamina] = SPELL_STAT3_NAME
L[StatLogic.Stats.Intellect] = SPELL_STAT4_NAME
L[StatLogic.Stats.Spirit] = SPELL_STAT5_NAME
L["ARMOR"] = ARMOR

L["FIRE_RES"] = RESISTANCE2_NAME
L["NATURE_RES"] = RESISTANCE3_NAME
L["FROST_RES"] = RESISTANCE4_NAME
L["SHADOW_RES"] = RESISTANCE5_NAME
L["ARCANE_RES"] = RESISTANCE6_NAME

L["BLOCK_VALUE"] = "피해 방어량"

L["AP"] = "전투력"
L["RANGED_AP"] = RANGED_ATTACK_POWER
L["FERAL_AP"] = "야생 전투력"

L["HEAL"] = "치유량"

L["SPELL_DMG"] = STAT_SPELLDAMAGE
L["HOLY_SPELL_DMG"] = SPELL_SCHOOL1_CAP.." "..DAMAGE
L["FIRE_SPELL_DMG"] = SPELL_SCHOOL2_CAP.." "..DAMAGE
L["NATURE_SPELL_DMG"] = SPELL_SCHOOL3_CAP.." "..DAMAGE
L["FROST_SPELL_DMG"] = SPELL_SCHOOL4_CAP.." "..DAMAGE
L["SHADOW_SPELL_DMG"] = SPELL_SCHOOL5_CAP.." "..DAMAGE
L["ARCANE_SPELL_DMG"] = SPELL_SCHOOL6_CAP.." "..DAMAGE

L["SPELLPEN"] = PLAYERSTAT_SPELL_COMBAT.." "..SPELL_PENETRATION

L["HEALTH"] = HEALTH
L["MANA"] = MANA

L["AVERAGE_DAMAGE"] = "Average Damage"
L["DPS"] = "초당 공격력"

L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2 -- COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.DodgeRating] = COMBAT_RATING_NAME3 -- COMBAT_RATING_NAME3 = "Dodge Rating"
L[StatLogic.Stats.ParryRating] = COMBAT_RATING_NAME4 -- COMBAT_RATING_NAME4 = "Parry Rating"
L[StatLogic.Stats.BlockRating] = COMBAT_RATING_NAME5 -- COMBAT_RATING_NAME5 = "Block Rating"
L[StatLogic.Stats.MeleeHitRating] = COMBAT_RATING_NAME6 -- COMBAT_RATING_NAME6 = "Hit Rating"
L[StatLogic.Stats.RangedHitRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
L[StatLogic.Stats.SpellHitRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME6 -- PLAYERSTAT_SPELL_COMBAT = "Spell"
L[StatLogic.Stats.MeleeCritRating] = COMBAT_RATING_NAME9 -- COMBAT_RATING_NAME9 = "Crit Rating"
L[StatLogic.Stats.RangedCritRating] = PLAYERSTAT_RANGED_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.SpellCritRating] = PLAYERSTAT_SPELL_COMBAT.." "..COMBAT_RATING_NAME9
L[StatLogic.Stats.ResilienceRating] = COMBAT_RATING_NAME15 -- COMBAT_RATING_NAME15 = "Resilience"
L[StatLogic.Stats.MeleeHasteRating] = "가속도 "..RATING --
L[StatLogic.Stats.RangedHasteRating] = PLAYERSTAT_RANGED_COMBAT.." 가속도 "..RATING
L[StatLogic.Stats.SpellHasteRating] = PLAYERSTAT_SPELL_COMBAT.." 가속도 "..RATING
L[StatLogic.Stats.ExpertiseRating] = "숙련 ".." "..RATING
L[StatLogic.Stats.ArmorPenetrationRating] = "방어구 관통력"
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
L["MELEE_CRIT_DMG_REDUCTION"] = "치명타 피해 감소(%)"
L[StatLogic.Stats.Defense] = DEFENSE
L[StatLogic.Stats.Dodge] = DODGE.."(%)"
L[StatLogic.Stats.Parry] = PARRY.."(%)"
L[StatLogic.Stats.BlockChance] = BLOCK.."(%)"
L["AVOIDANCE"] = "공격 회피(%)"
L["MELEE_HIT"] = "적중률(%)"
L["RANGED_HIT"] = PLAYERSTAT_RANGED_COMBAT.." 적중률(%)"
L["SPELL_HIT"] = PLAYERSTAT_SPELL_COMBAT.." 적중률(%)"
L[StatLogic.Stats.Miss] = "근접 공격 회피(%)"
L[StatLogic.Stats.MeleeCrit] = MELEE_CRIT_CHANCE.."(%)" -- MELEE_CRIT_CHANCE = "Crit Chance"
L[StatLogic.Stats.RangedCrit] = PLAYERSTAT_RANGED_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L[StatLogic.Stats.SpellCrit] = PLAYERSTAT_SPELL_COMBAT.." "..MELEE_CRIT_CHANCE.."(%)"
L["MELEE_CRIT_AVOID"] = "근접 치명타 공격 회피(%)"
L["MELEE_HASTE"] = "가속도(%)" --
L["RANGED_HASTE"] = PLAYERSTAT_RANGED_COMBAT.." 가속도(%)"
L["SPELL_HASTE"] = PLAYERSTAT_SPELL_COMBAT.." 가속도(%)"
L["EXPERTISE"] = "숙련 "
L["ARMOR_PENETRATION"] = "방어구 관통(%)"
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
-- Expertise -> Dodge Neglect, Parry Neglect
L["DODGE_NEGLECT"] = DODGE.." 무시(%)"
L["PARRY_NEGLECT"] = PARRY.." 무시(%)"
L["BLOCK_NEGLECT"] = BLOCK.." 무시(%)"
-- Misc Stats
L["WEAPON_SKILL"] = "무기 "..SKILL