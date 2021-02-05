--[[
Name: RatingBuster koKR locale
Revision: $Revision: 73696 $
Translated by: 
- kcgcom, fenlis (jungseop.park@gmail.com)
]]

local L = AceLibrary("AceLocale-3.0"):new("RatingBuster")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("koKR", function() return {
	["RatingBuster Options"] = "RatingBuster 설정",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb win
	["Options Window"] = "설정창",
	["Shows the Options Window"] = "설정창을 표시합니다.",
	-- /rb statmod
	["Enable Stat Mods"] = "능력치 애드온 사용",
	["Enable support for Stat Mods"] = "능력치 애드온 지원을 사용합니다.",
	-- /rb itemid
	["Show ItemID"] = "아이템 ID 표시",
	["Show the ItemID in tooltips"] = "툴팁에 아이템 ID를 표시합니다.",
	-- /rb itemlevel
	["Show ItemLevel"] = "아이템 레벨 표시",
	["Show the ItemLevel in tooltips"] = "툴팁에 아이템 레벨을 표시합니다.",
	-- /rb usereqlv
	["Use required level"] = "최소 요구 레벨 사용",
	["Calculate using the required level if you are below the required level"] = "레벨이 낮아 사용하지 못하는 경우 최소 요구 레벨에 따라 계산합니다.",
	-- /rb setlevel
	["Set level"] = "레벨 설정",
	["Set the level used in calculations (0 = your level)"] = "계산에 적용할 레벨을 설정합니다. (0 = 자신 레벨)",
	-- /rb color
	["Change text color"] = "글자 색상 변경",
	["Changes the color of added text"] = "추가된 글자의 색상을 변경합니다.",
	-- /rb color pick
	["Pick color"] = "색상 선택",
	["Pick a color"] = "색상을 선택합니다.",
	-- /rb color enable
	["Enable color"] = "색상 사용",
	["Enable colored text"] = "글자에 색상을 사용합니다.",
	-- /rb rating
	["Rating"] = "평점",
	["Options for Rating display"] = "평점 표시에 대한 설정입니다.",
	-- /rb rating show
	["Show Rating conversions"] = "평점 변화 표시",
	["Show Rating conversions in tooltips"] = "툴팁에 평점 변화를 표시합니다.",
	-- /rb rating detail
	["Show detailed conversions text"] = "세부적인 평점 변화 표시",
	["Show detailed text for Resiliance and Expertise conversions"] = "탄력도와 숙련의 세부적인 평점 변화 표시를 사용합니다.",
	-- /rb rating def
	["Defense breakdown"] = "방어 숙련 세분화",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "치명타 공격 회피, 공격 회피, 회피, 무기 막기, 방패 막기 등으로 방어 숙련을 세분화합니다.",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "무기 숙련 세분화",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "치명타, 공격, 회피 무시, 무기 막기 무시, 방패 막기 무시 등으로 무기 숙련를 세분화합니다.",
	-- /rb rating exp -- 2.3.0
	["Expertise breakdown"] = "숙련 세분화",
	["Convert Expertise into Dodge Neglect and Parry Neglect"] = "회피 무시와 무기막기 무시 등으로 숙련을 세분화 합니다.",
	
	-- /rb stat
	--["Stat Breakdown"] = "능력치",
	["Changes the display of base stats"] = "기본 능력치 표시방법을 변경합니다.",
	-- /rb stat show
	["Show base stat conversions"] = "기본 능력치 변화 표시",
	["Show base stat conversions in tooltips"] = "툴팁에 기본 능력치의 변화를 표시합니다.",
	-- /rb stat str
	["Strength"] = "힘",
	["Changes the display of Strength"] = "힘에 대한 표시방법을 변경합니다.",
	-- /rb stat str ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Strength"] = "힘에 의한 전투력을 표시합니다.",
	-- /rb stat str block
	["Show Block Value"] = "피해 방어량 표시",
	["Show Block Value from Strength"] = "힘에 의한 피해 방어량을 표시합니다.",
	-- /rb stat str dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	--["Show Spell Damage from Strength"] = "지능에 의한 주문 공격력을 표시합니다.",
	-- /rb stat str heal
	["Show Healing"] = "치유량 표시",
	--["Show Healing from Strength"] = "지능에 의한 치유량을 표시합니다.",
	
	-- /rb stat agi
	["Agility"] = "민첩성",
	["Changes the display of Agility"] = "민첩성 표시방법을 변경합니다.",
	-- /rb stat agi crit
	["Show Crit"] = "치명타 표시",
	["Show Crit chance from Agility"] = "민첩성에 의한 치명타 표시",
	-- /rb stat agi dodge
	["Show Dodge"] = "회피 표시",
	["Show Dodge chance from Agility"] = "민첩에 의한 회피율을 표시합니다.",
	-- /rb stat agi ap
	["Show Attack Power"] = "전투력 표시",
	["Show Attack Power from Agility"] = "민첩에 의한 전투력을 표시합니다.",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "원거리 전투력 표시",
	["Show Ranged Attack Power from Agility"] = "민첩에 의한 원거리 전투력을 표시합니다.",
	-- /rb stat agi armor
	["Show Armor"] = "방어도 표시",
	["Show Armor from Agility"] = "민첩에 의한 방어도를 표시합니다.",
	-- /rb stat agi heal
	["Show Healing"] = "치유량 표시",
	--["Show Healing from Agility"] = "힘에 의한 치유량을 표시합니다.",
	
	-- /rb stat sta
	["Stamina"] = "체력",
	["Changes the display of Stamina"] = "체력의 표시방법을 변경합니다.",
	-- /rb stat sta hp
	["Show Health"] = "생명력 표시",
	["Show Health from Stamina"] = "체력에 의한 생명력을 표시합니다.",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Stamina"] = "체력에 의한 주문 공격력을 표시합니다.",
	
	-- /rb stat int
	["Intellect"] = "지능",
	["Changes the display of Intellect"] = "지능 표시방법을 변경합니다.",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "주문 극대화 표시",
	["Show Spell Crit chance from Intellect"] = "지능에 의한 주문 극대화율 표시",
	-- /rb stat int mp
	["Show Mana"] = "마나 표시",
	["Show Mana from Intellect"] = "지능에 의한 마나량을 표시합니다.",
	-- /rb stat int dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Intellect"] = "지능에 의한 주문 공격력을 표시합니다.",
	-- /rb stat int heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Intellect"] = "지능에 의한 치유량을 표시합니다.",
	-- /rb stat int mp5
	["Show Mana Regen"] = "마나 재생 표시",
	["Show Mana Regen while casting from Intellect"] = "지능에 의해 시전 시 마나 재생량을 표시합니다.",
	-- /rb stat int mp5nc
	["Show Mana Regen while NOT casting"] = "평상시 마나 재생 표시",
	["Show Mana Regen while NOT casting from Intellect"] = "지능에 의한 평상시 마나 재생량을 표시합니다.",
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "원거리 전투력 표시",
	["Show Ranged Attack Power from Intellect"] = "지능에 의한 원거리 전투력을 표시합니다.",
	-- /rb stat int armor
	["Show Armor"] = "방어도 표시",
	["Show Armor from Intellect"] = "지능에 의한 방어도를 표시합니다.",
	
	-- /rb stat spi
	["Spirit"] = "정신력",
	["Changes the display of Spirit"] = "정신력의 표시방법을 변경합니다.",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "마나 재생 표시",
	["Show Mana Regen while casting from Spirit"] = "정신력에 의해 시전 시 마나 재생량을 표시합니다.",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "평상시 마나 재생 표시",
	["Show Mana Regen while NOT casting from Spirit"] = "정신력에 의한 평상시 마나 재생량을 표시합니다.",
	-- /rb stat spi hp5
	["Show Health Regen"] = "생명력 재생 표시",
	["Show Health Regen from Spirit"] = "정신력에 의한 생명력 재생량을 표시합니다.",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "주문 공격력 표시",
	["Show Spell Damage from Spirit"] = "정신력에 의한 주문 공격력을 표시합니다.",
	-- /rb stat spi heal
	["Show Healing"] = "치유량 표시",
	["Show Healing from Spirit"] = "정신력에 의한 치유량을 표시합니다.",
	
	-- /rb sum
	["Stat Summary"] = "능력치 요약",
	["Options for stat summary"] = "능력치 요약에 대한 설정입니다.",
	-- /rb sum show
	["Show stat summary"] = "능력치 요약 표시",
	["Show stat summary in tooltips"] = "툴팁에 능력치 요약을 표시합니다.",
	-- /rb sum ignore
	["Ignore settings"] = "제외 설정",
	["Ignore stuff when calculating the stat summary"] = "능력치 요약 계산에 포함되지 않습니다.",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "쓸모없는 아이템 제외",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Show stat summary only for highest level armor type and items you can use with uncommon quality and up",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "착용 아이템 제외",
	["Hide stat summary for equipped items"] = "착용하고 있는 아이템에 대한 능력치 요약은 표시하지 않습니다.",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "마법부여 제외",
	["Ignore enchants on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 마법부여를 포함하지 않습니다.",
	-- /rb sum ignore gem
	["Ignore gems"] = "보석 제외",
	["Ignore gems on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 보석을 포함하지 않습니다.",
	-- /rb sum diffstyle
	["Display style for diff value"] = "차이값 표시 형식",
	["Display diff values in the main tooltip or only in compare tooltips"] = "주요 툴팁 이나 비교 툴팁에만 차이값을 표시합니다.",
	-- /rb sum space
	["Add empty line"] = "구분선 추가",
	["Add a empty line before or after stat summary"] = "능력치 요약 앞 혹은 뒤에 구분선을 추가합니다.",
	-- /rb sum space before
	["Add before summary"] = "요약 앞에 추가",
	["Add a empty line before stat summary"] = "능력치 요약의 앞에 구분선을 추가합니다.",
	-- /rb sum space after
	["Add after summary"] = "요약 뒤에 추가",
	["Add a empty line after stat summary"] = "능력치 요약의 뒤에 구분선을 추가합니다.",
	-- /rb sum icon
	["Show icon"] = "아이콘 표시",
	["Show the sigma icon before summary listing"] = "요약 목록 앞에 시그마 아이콘을 표시합니다.",
	-- /rb sum title
	["Show title text"] = "제목 표시",
	["Show the title text before summary listing"] = "요약 목록 앞에 제목을 표시합니다.",
	-- /rb sum showzerostat
	["Show zero value stats"] = "제로 능력치 표시",
	["Show zero value stats in summary for consistancy"] = "구성에 대한 요약에 제로 능력치를 표시합니다.",
	-- /rb sum calcsum
	["Calculate stat sum"] = "능력치 합계 계산",
	["Calculate the total stats for the item"] = "아이템에 대한 총 능력치를 계산합니다.",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "능력치 차이 계산",
	["Calculate the stat difference for the item and equipped items"] = "아이템과 착용한 아이템과의 능력치 차이를 계산합니다.",
	-- /rb sum sort
	["Sort StatSummary alphabetically"] = "능력치 요약 정렬",
	["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "능력치 요약을 알파벳순으로 정렬합니다, 능력치별로 정렬하려면 비활성화하세요.(기본, 물리적, 주문, 탱크)",
	-- /rb sum avoidhasblock
	["Include block chance in Avoidance summary"] = "회피 요약에 방어율 포함",
	["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "회피 요약에 방어율을 포함시킵니다. 회피, 무기 막기, 빗맞힘만 사용하려면 비활성화하세요.",
	-- /rb sum basic
	["Stat - Basic"] = "능력치 - 기본",
	["Choose basic stats for summary"] = "기본 능력치를 선택합니다.",
	-- /rb sum physical
	["Stat - Physical"] = "능력치 - 물리적",
	["Choose physical damage stats for summary"] = "물리적 공격력 능력치를 선택합니다.",
	-- /rb sum spell
	["Stat - Spell"] = "능력치 - 주문",
	["Choose spell damage and healing stats for summary"] = "주문 공격려과 치유량을 선택합니다.",
	-- /rb sum tank
	["Stat - Tank"] = "능력치 - 탱크",
	["Choose tank stats for summary"] = "탱크 능력치를 선택합니다.",
	-- /rb sum stat hp
	["Sum Health"] = "생명력",
	["Health <- Health, Stamina"] = "생명력 <- 생명력, 체력",
	-- /rb sum stat mp
	["Sum Mana"] = "마나",
	["Mana <- Mana, Intellect"] = "마나 < 마나, 지능",
	-- /rb sum stat ap
	["Sum Attack Power"] = "전투력",
	["Attack Power <- Attack Power, Strength, Agility"] = "전투력 <- 전투력, 힘, 민첩성",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "원거리 전투력",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "원거리 전투력 <- 원거리 전투력, 지능, 전투력, 힘, 민첩성",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "야생 전투력",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "야생 전투력 <- 야생 전투력, 전투력, 힘, 민첩성",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "주문 공격력",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "주문 공격력 <- 주문 공격력, 지능, 정신력, 체력",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "신성 주문 공격력",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "신성 주문 공격력 <- 신성 주문 공격력, 주문 공격력, 지능, 정신력",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "비전 주문 공격력",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "비전 주문 공격력 <- 비전 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "화염 주문 공격력",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "화염 주문 공격력 <- 화염 주문 공격력, 주문 공격력, 지능, 체력",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "자연 주문 공격력",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "자연 주문 공격력 <- 자연 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "냉기 주문 공격력",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "냉기 주문 공격력 <- 냉기 주문 공격력, 주문 공격력, 지능",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "암흑 주문 공격력",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "암흑 주문 공격력 <- 암흑 주문 공격력, 주문 공격력, 지능, 정신력, 체력",
	-- /rb sum stat heal
	["Sum Healing"] = "치유량",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "치유량 <- 치유량, 지능, 정신력, 민첩, 힘",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "적중률",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "적중률 <- 적중도, 무기 숙력도",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "치명타율",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도",
	-- /rb sum stat haste
	["Sum Haste"] = "공격 가속",
	["Haste <- Haste Rating"] = "공격 가속 <- 공격 가속도",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "주문 극대화율",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "주문 극대화율 <- 주문 극대화 적중도, 지능",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "주문 적중율",
	["Spell Hit Chance <- Spell Hit Rating"] = "주문 적중율 <- 주문 적중도",
	-- /rb sum stat hastespell
	["Sum Spell Haste"] = "주문 가속",
	["Spell Haste <- Spell Haste Rating"] = "주문 가속 <- 주문 가속도",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "마나 재생",
	["Mana Regen <- Mana Regen, Spirit"] = "마나 재생 <- 마나 재생, 정신력",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "미시전 시 마나 재생",
	["Mana Regen while not casting <- Spirit"] = "미시전 시 마나 재생 <- 정신력",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "생명력 재생",
	["Health Regen <- Health Regen"] = "생명력 재생 <- 생명력 재생",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "비전투중 생명력 재생",
	["Health Regen when out of combat <- Spirit"] = "비전투중 생명력 재생 <- 정신력",
	-- /rb sum stat armor
	["Sum Armor"] = "방어도",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "방어도 <- 아이템의 방어도, 효과의 방어도, 민첩성, 지능",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "피해 방어량",
	["Block Value <- Block Value, Strength"] = "피해 방어량 <- 피해 방어량, 힘",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "회피율",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "회피율 <- 회피 숙련도, 민첩성, 방어 숙련도",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "무기 막기 확률",
	["Parry Chance <- Parry Rating, Defense Rating"] = "무기 막기 확률 <- 무기 막기 숙련도, 방어 숙련도",
	-- /rb sum stat block
	["Sum Block Chance"] = "방패 막기 확률",
	["Block Chance <- Block Rating, Defense Rating"] = "방패 막기 확률 <- 방패 막기 숙련도, 방어 숙련도",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "공격 회피",
	["Hit Avoidance <- Defense Rating"] = "공격 회피 <- 방어 숙련도",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "치명타 공격 회피",
	["Crit Avoidance <- Defense Rating, Resilience"] = "치명타 공격 회피 <- 방어 숙련도, 탄력도",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "회피 무시",
	["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "회피 무시 <- 숙련도, 무기 숙련도", -- 2.3.0
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "무기 막기 무시",
	["Parry Neglect <- Expertise, Weapon Skill Rating"] = "무기 막기 무시 <- 숙련도, 무기 숙련도", -- 2.3.0
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "방패 막기 무시",
	["Block Neglect <- Weapon Skill Rating"] = "방패 막기 무시 <- 무기 숙련도",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "비전 저항력",
	["Arcane Resistance Summary"] = "비전 저항력 요약",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "화염 저항력",
	["Fire Resistance Summary"] = "화염 저항력 요약",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "자연 저항력",
	["Nature Resistance Summary"] = "자연 저항력 요약",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "냉기 저항력",
	["Frost Resistance Summary"] = "냉기 저항력 요약",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "암흑 저항력",
	["Shadow Resistance Summary"] = "암흑 저항력 요약",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "무기 최대 공격력",
	["Weapon Max Damage Summary"] = "무기 최대 공격력 요약",
	-- /rb sum stat pen
	["Sum Penetration"] = "관통력",
	["Spell Penetration Summary"] = "주문 관통력 요약",
	-- /rb sum stat ignorearmor
	["Sum Ignore Armor"] = "방어도 무시",
	["Ignore Armor Summary"] = "방어도 무시 요약",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp str
	["Sum Strength"] = "힘",
	["Strength Summary"] = "힘 요약",
	-- /rb sum statcomp agi
	["Sum Agility"] = "민첩성",
	["Agility Summary"] = "민첩성 요약",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "체력",
	["Stamina Summary"] = "체력 요약",
	-- /rb sum statcomp int
	["Sum Intellect"] = "지능",
	["Intellect Summary"] = "지능 요약",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "정신력",
	["Spirit Summary"] = "정신력 요약",
	-- /rb sum statcomp hitrating
	["Sum Hit Rating"] = "적중도",
	["Hit Rating Summary"] = "적중도 요약",
	-- /rb sum statcomp critrating
	["Sum Crit Rating"] = "치명타율",
	["Crit Rating Summary"] = "치명타율 요약",
	-- /rb sum statcomp hasterating
	["Sum Haste Rating"] = "공격 가속도",
	["Haste Rating Summary"] = "공격 가속도 요약",
	-- /rb sum statcomp hitspellrating
	["Sum Spell Hit Rating"] = "주문 적중도",
	["Spell Hit Rating Summary"] = "주문 적중도 요약",
	-- /rb sum statcomp critspellrating
	["Sum Spell Crit Rating"] = "주문 극대화율",
	["Spell Crit Rating Summary"] = "주문 극대화율 요약",
	-- /rb sum statcomp hastespellrating
	["Sum Spell Haste Rating"] = "주문 가속도",
	["Spell Haste Rating Summary"] = "주문 가속도 요약",
	-- /rb sum statcomp dodgerating
	["Sum Dodge Rating"] = "회피율",
	["Dodge Rating Summary"] = "회피율 요약",
	-- /rb sum statcomp parryrating
	["Sum Parry Rating"] = "무기 막기율",
	["Parry Rating Summary"] = "무기 막기율 요약",
	-- /rb sum statcomp blockrating
	["Sum Block Rating"] = "방어율",
	["Block Rating Summary"] = "방어율 요약",
	-- /rb sum statcomp res
	["Sum Resilience"] = "탄력도",
	["Resilience Summary"] = "탄력도 요약",
	-- /rb sum statcomp def
	["Sum Defense"] = "방어 숙련",
	["Defense <- Defense Rating"] = "방어 숙련 <- 방어 숙련도",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "무기 숙련",
	["Weapon Skill <- Weapon Skill Rating"] = "무기 숙련 <- 무기 숙련도",
	-- /rb sum statcomp exp -- 2.3.0
	["Sum Expertise"] = "숙련",
	["Expertise <- Expertise Rating"] = "숙련 <- 숙련도",
	-- /rb sum statcomp tp
	["Sum TankPoints"] = "탱킹점수",
	["TankPoints <- Health, Total Reduction"] = "탱커점수 <- 체력, 총 감소량",
	-- /rb sum statcomp tr
	["Sum Total Reduction"] = "총 감소량",
	["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "총 감소량 <- 방어도, 회피, 무기 막기, 방어, 피해 방어량, 방어, 탄력도, 몹회피, 몹치명타, 몹강타, 적용전 데미지",
	-- /rb sum statcomp avoid
	["Sum Avoidance"] = "회피량",
	["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "회피량 <- 회피, 무기 막기, 몹빗맞힘, 방어(선택적)",
	
	-- /rb sum gem
	["Gems"] = "보석",
	["Auto fill empty gem slots"] = "빈 보석 슬롯을 자동으로 채웁니다.",
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	["ItemID or Link of the gem you would like to auto fill"] = "당신이 좋아하는 보석의 아이템ID & 링크로 자동으로 채웁니다.",
	["<ItemID|Link>"] = "<아이템ID|링크>",
	["%s is now set to %s"] = "현재 %s에 %s 설정",
	["Queried server for Gem: %s. Try again in 5 secs."] = "서버에서 알수없는 보석: %s. 5초뒤 다시하세요.",
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,
	
	-----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "아이템레벨: ",
	["ItemID: "] = "아이템ID: ",
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
		{pattern = "(%d+)만큼 증가합니다.", addInfo = "AfterNumber",},
		{pattern = "([%+%-]%d+)", addInfo = "AfterNumber",},
--		{pattern = "grant.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
--		{pattern = "add.-(%d+)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
		{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
	},
	["separators"] = {
		"/", " and ", ",", "%. ", " for ", "&", ":"
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
	SPELL_STAT1_NAME = "힘"
	SPELL_STAT2_NAME = "민첩성"
	SPELL_STAT3_NAME = "체력"
	SPELL_STAT4_NAME = "지능"
	SPELL_STAT5_NAME = "정신력"
	--]]
	["statList"] = {
		{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
		{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
		{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
		{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
		{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
		{pattern = "방어 숙련도", id = CR_DEFENSE_SKILL},
		{pattern = "회피 숙련도", id = CR_DODGE},
		{pattern = "방패 막기 숙련도", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
		{pattern = "무기 막기 숙련도", id = CR_PARRY},
	
		{pattern = "주문 극대화 적중도", id = CR_CRIT_SPELL},
		{pattern = "주문의 극대화 적중도", id = CR_CRIT_SPELL},
--		{pattern = "spell critical rating", id = CR_CRIT_SPELL},
--		{pattern = "spell crit rating", id = CR_CRIT_SPELL},
		{pattern = "원거리 치명타 적중도", id = CR_CRIT_RANGED},
--		{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
--		{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
		{pattern = "치명타 적중도", id = CR_CRIT_MELEE},
		{pattern = "근접 치명타 적중도", id = CR_CRIT_MELEE},
--		{pattern = "crit rating", id = CR_CRIT_MELEE},
		
--		{pattern = "주문의 적중도", id = CR_HIT_SPELL},
		{pattern = "주문 적중도", id = CR_HIT_SPELL},
		{pattern = "원거리 적중도", id = CR_HIT_RANGED},
		{pattern = "적중도", id = CR_HIT_MELEE},
		
		{pattern = "탄력도", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating
		
		{pattern = "주문 시전 가속도", id = CR_HASTE_SPELL},
		{pattern = "원거리 공격 가속도", id = CR_HASTE_RANGED},
		{pattern = "공격 가속도", id = CR_HASTE_MELEE},
		{pattern = "가속도", id = CR_HASTE_MELEE}, -- [Drums of Battle]
		
		{pattern = "무기 숙련도", id = CR_WEAPON_SKILL},
		{pattern = "숙련도", id = CR_EXPERTISE},
		
		{pattern = "근접 공격 회피", id = CR_HIT_TAKEN_MELEE},
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
	["$value% Crit"] = "치명타 $value%",
	["$value% Spell Crit"] = "극대화 $value%",
	["$value% Dodge"] = "회피 $value%",
	["$value HP"] = "생명력 $value",
	["$value MP"] = "마나 $value",
	["$value AP"] = "전투력 $value",
	["$value RAP"] = "원거리 전투력 $value",
	["$value Dmg"] = "공격력 $value",
	["$value Heal"] = "치유량 $value",
	["$value Armor"] = "방어도 $value",
	["$value Block"] = "방어 $value",
	["$value MP5"] = "$value MP5",
	["$value MP5(NC)"] = "$value MP5(NC)",
	["$value HP5"] = "$value HP5",
	["$value to be Dodged/Parried"] = "이후 회피 감소/무기막기 감소 $value",
	["$value to be Crit"] = "이후 치명타 $value",
	["$value Crit Dmg Taken"] = "가질 치명타 데미지 $value",
	["$value DOT Dmg Taken"] = "가질 DOT 데미지 $value",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "능력치 요약",
} end)