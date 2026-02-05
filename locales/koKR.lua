--[[
Name: RatingBuster koKR locale
Translated by:
- kcgcom
- fenlis (jungseop.park@gmail.com)
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "koKR")
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
L["RatingBuster Options"] = "RatingBuster 설정"
---------------------------
-- Slash Command Options --
---------------------------
L["Help"] = "Help"
L["Show this help message"] = "Show this help message"
L["Options Window"] = "설정창"
L["Shows the Options Window"] = "설정창을 표시합니다."
L["Enable Stat Mods"] = "능력치 애드온 사용"
L["Enable support for Stat Mods"] = "능력치 애드온 지원을 사용합니다."
L["Enable Avoidance Diminishing Returns"] = "방어행동 점감 효과 사용"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "회피, 무기 막기, 빗맞힘 수치를 현재 능력치에서 점감 효과를 적용하여 계산합니다."
L["Show ItemID"] = "아이템 ID 표시"
L["Show the ItemID in tooltips"] = "툴팁에 아이템 ID를 표시합니다."
L["Show ItemLevel"] = "아이템 레벨 표시"
L["Show the ItemLevel in tooltips"] = "툴팁에 아이템 레벨을 표시합니다."
L["Use required level"] = "최소 요구 레벨 사용"
L["Calculate using the required level if you are below the required level"] = "레벨이 낮아 사용하지 못하는 경우 최소 요구 레벨에 따라 계산합니다."
L["Set level"] = "레벨 설정"
L["Set the level used in calculations (0 = your level)"] = "계산에 적용할 레벨을 설정합니다. (0 = 자신 레벨)"
L["Change text color"] = "글자 색상 변경"
L["Changes the color of added text"] = "추가된 글자의 색상을 변경합니다."
L["Change number color"] = "Change number color"
L["Rating"] = "평점"
L["Options for Rating display"] = "평점 표시에 대한 설정입니다."
L["Show Rating conversions"] = "평점 변화 표시"
L["Show Rating conversions in tooltips"] = "툴팁에 평점 변화를 표시합니다."
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
L["Show Spell Hit/Haste"] = "주문 적중/가속 표시"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "주문의 적중/가속을 표시합니다."
L["Show Physical Hit/Haste"] = "물리 적중/가속 표시"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "물리 적중/가속을 표시합니다."
L["Show detailed conversions text"] = "세부적인 평점 변화 표시"
L["Show detailed text for Resilience and Expertise conversions"] = "탄력도와 숙련의 세부적인 평점 변화 표시를 사용합니다."
L["Defense breakdown"] = "방어 숙련 세분화"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "치명타 공격 회피, 공격 회피, 회피, 무기 막기, 방패 막기 등으로 방어 숙련을 세분화합니다."
L["Weapon Skill breakdown"] = "무기 숙련 세분화"
L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "치명타, 공격, 회피 무시, 무기 막기 무시, 방패 막기 무시 등으로 무기 숙련를 세분화합니다."
L["Expertise breakdown"] = "숙련 세분화"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "회피 무시와 무기막기 무시 등으로 숙련을 세분화 합니다."

L["Stat Breakdown"] = "능력치"
L["Changes the display of base stats"] = "기본 능력치 표시방법을 변경합니다."
L["Show base stat conversions"] = "기본 능력치 변화 표시"
L["Show base stat conversions in tooltips"] = "툴팁에 기본 능력치의 변화를 표시합니다."
L["Changes the display of %s"] = "%s 표시방법을 변경합니다."

L["Stat Summary"] = "능력치 요약"
L["Options for stat summary"] = "능력치 요약에 대한 설정입니다."
L["Sum %s"] = "%s"
L["Show stat summary"] = "능력치 요약 표시"
L["Show stat summary in tooltips"] = "툴팁에 능력치 요약을 표시합니다."
L["Ignore settings"] = "제외 설정"
L["Ignore stuff when calculating the stat summary"] = "능력치 요약 계산에 포함되지 않습니다."
L["Ignore unused item types"] = "쓸모없는 아이템 제외"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Show stat summary only for highest level armor type and items you can use with uncommon quality and up"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
L["Ignore equipped items"] = "착용 아이템 제외"
L["Hide stat summary for equipped items"] = "착용하고 있는 아이템에 대한 능력치 요약은 표시하지 않습니다."
L["Ignore enchants"] = "마법부여 제외"
L["Ignore enchants on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 마법부여를 포함하지 않습니다."
L["Ignore gems"] = "보석 제외"
L["Ignore gems on items when calculating the stat summary"] = "능력치 요약 계산에 아이템의 보석을 포함하지 않습니다."
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
L["Display style for diff value"] = "차이값 표시 형식"
L["Display diff values in the main tooltip or only in compare tooltips"] = "주요 툴팁 이나 비교 툴팁에만 차이값을 표시합니다."
L["Hide Blizzard Item Comparisons"] = "기본 아이템 비교 숨김"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "툴팁에 블리자드의 기본 아이템 비교를 숨깁니다."
L["Add empty line"] = "구분선 추가"
L["Add a empty line before or after stat summary"] = "능력치 요약 앞 혹은 뒤에 구분선을 추가합니다."
L["Add before summary"] = "요약 앞에 추가"
L["Add a empty line before stat summary"] = "능력치 요약의 앞에 구분선을 추가합니다."
L["Add after summary"] = "요약 뒤에 추가"
L["Add a empty line after stat summary"] = "능력치 요약의 뒤에 구분선을 추가합니다."
L["Show icon"] = "아이콘 표시"
L["Show the sigma icon before stat summary"] = "요약 목록 앞에 시그마 아이콘을 표시합니다."
L["Show title text"] = "제목 표시"
L["Show the title text before stat summary"] = "요약 목록 앞에 제목을 표시합니다."
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
L["Show zero value stats"] = "제로 능력치 표시"
L["Show zero value stats in summary for consistancy"] = "구성에 대한 요약에 제로 능력치를 표시합니다."
L["Calculate stat sum"] = "능력치 합계 계산"
L["Calculate the total stats for the item"] = "아이템에 대한 총 능력치를 계산합니다."
L["Calculate stat diff"] = "능력치 차이 계산"
L["Calculate the stat difference for the item and equipped items"] = "아이템과 착용한 아이템과의 능력치 차이를 계산합니다."
L["Sort StatSummary alphabetically"] = "능력치 요약 정렬"
L["Enable to sort StatSummary alphabetically disable to sort according to stat type(basic, physical, spell, tank)"] = "능력치 요약을 알파벳순으로 정렬합니다, 능력치별로 정렬하려면 비활성화하세요.(기본, 물리적, 주문, 탱크)"
L["Include block chance in Avoidance summary"] = "회피 요약에 방어율 포함"
L["Enable to include block chance in Avoidance summary Disable for only dodge, parry, miss"] = "회피 요약에 방어율을 포함시킵니다. 회피, 무기 막기, 빗맞힘만 사용하려면 비활성화하세요."
L["Stat - Basic"] = "능력치 - 기본"
L["Choose basic stats for summary"] = "기본 능력치를 선택합니다."
L["Stat - Physical"] = "능력치 - 물리적"
L["Choose physical damage stats for summary"] = "물리적 공격력 능력치를 선택합니다."
L["Ranged"] = "Ranged"
L["Weapon"] = "Weapon"
L["Stat - Spell"] = "능력치 - 주문"
L["Choose spell damage and healing stats for summary"] = "주문 공격려과 치유량을 선택합니다."
L["Stat - Tank"] = "능력치 - 탱크"
L["Choose tank stats for summary"] = "탱크 능력치를 선택합니다."
L["Health <- Health Stamina"] = "생명력 <- 생명력, 체력"
L["Mana <- Mana Intellect"] = "마나 < 마나, 지능"
L["Attack Power <- Attack Power Strength, Agility"] = "전투력 <- 전투력, 힘, 민첩성"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "원거리 전투력 <- 원거리 전투력, 지능, 전투력, 힘, 민첩성"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "주문 공격력 <- 주문 공격력, 지능, 정신력, 체력"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "신성 주문 공격력 <- 신성 주문 공격력, 주문 공격력, 지능, 정신력"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "비전 주문 공격력 <- 비전 주문 공격력, 주문 공격력, 지능"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "화염 주문 공격력 <- 화염 주문 공격력, 주문 공격력, 지능, 체력"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "자연 주문 공격력 <- 자연 주문 공격력, 주문 공격력, 지능"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "냉기 주문 공격력 <- 냉기 주문 공격력, 주문 공격력, 지능"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "암흑 주문 공격력 <- 암흑 주문 공격력, 주문 공격력, 지능, 정신력, 체력"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "치유량 <- 치유량, 지능, 정신력, 민첩, 힘"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "적중률 <- 적중도, 무기 숙력도"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도"
L["Haste <- Haste Rating"] = "공격 가속 <- 공격 가속도"
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "원거리 적중률 <- 적중도, 무기 숙련도, 원거리 적중도"
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "원거리 치명타율 <- 치명타 적중도, 민첩성, 무기 숙련도, 치명타 적중도"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "원거리 공격 가속율 <- 공격 가속도, 원거리 가속율"
L["Spell Hit Chance <- Spell Hit Rating"] = "주문 적중율 <- 주문 적중도"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "주문 극대화율 <- 주문 극대화 적중도, 지능"
L["Spell Haste <- Spell Haste Rating"] = "주문 가속 <- 주문 가속도"
L["Mana Regen <- Mana Regen Spirit"] = "마나 재생 <- 마나 재생, 정신력"
L["Mana Regen while not casting <- Spirit"] = "미시전 시 마나 재생 <- 정신력"
L["Health Regen <- Health Regen"] = "생명력 재생 <- 생명력 재생"
L["Health Regen when out of combat <- Spirit"] = "비전투중 생명력 재생 <- 정신력"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "방어도 <- 아이템의 방어도, 효과의 방어도, 민첩성, 지능"
L["Block Value <- Block Value Strength"] = "피해 방어량 <- 피해 방어량, 힘"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "회피율 <- 회피 숙련도, 민첩성, 방어 숙련도"
L["Parry Chance <- Parry Rating Defense Rating"] = "무기 막기 확률 <- 무기 막기 숙련도, 방어 숙련도"
L["Block Chance <- Block Rating Defense Rating"] = "방패 막기 확률 <- 방패 막기 숙련도, 방어 숙련도"
L["Hit Avoidance <- Defense Rating"] = "공격 회피 <- 방어 숙련도"
L["Crit Avoidance <- Defense Rating Resilience"] = "치명타 공격 회피 <- 방어 숙련도, 탄력도"
L["Dodge Reduction <- Expertise Weapon Skill Rating"] = "회피 무시 <- 숙련도, 무기 숙련도" -- 2.3.0
L["Parry Reduction <- Expertise Weapon Skill Rating"] = "무기 막기 무시 <- 숙련도, 무기 숙련도" -- 2.3.0
L["Defense <- Defense Rating"] = "방어 숙련 <- 방어 숙련도"
L["Weapon Skill <- Weapon Skill Rating"] = "무기 숙련 <- 무기 숙련도"
L["Expertise <- Expertise Rating"] = "숙련 <- 숙련도"
L["Avoidance <- Dodge Parry, MobMiss, Block(Optional)"] = "회피량 <- 회피, 무기 막기, 몹빗맞힘, 방어(선택적)"
L["Gems"] = "보석"
L["Auto fill empty gem slots"] = "빈 보석 슬롯을 자동으로 채웁니다."
L["ItemID or Link of the gem you would like to auto fill"] = "당신이 좋아하는 보석의 아이템ID & 링크로 자동으로 채웁니다."
L["<ItemID|Link>"] = "<아이템ID|링크>"
L["%s is now set to %s"] = "현재 %s에 %s 설정"
L["Queried server for Gem: %s. Try again in 5 secs."] = "서버에서 알수없는 보석: %s. 5초뒤 다시하세요."

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "아이템레벨: "
L["ItemID: "] = "아이템ID: "

-------------------
-- Always Buffed --
-------------------
L["Enables RatingBuster to calculate selected buff effects even if you don't really have them"] = "Enables RatingBuster to calculate selected buff effects even if you don't really have them"
L["$class Self Buffs"] = "$class Self Buffs" -- $class will be replaced with localized player class
L["Raid Buffs"] = "Raid Buffs"
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

-- These patterns are used to reposition stat breakdowns.
-- They are not mandatory; if not present for a given stat,
-- the breakdown will simply appear after the number.
-- They will only ever position the breakdown further after the number; not before it.
-- E.g. default positioning:
--   "Strength +5 (10 AP)"
--   "+5 (10 AP) Strength"
-- If "strength" is added in statPatterns:
--   "Strength +5 (10 AP)"
--   "+5 Strength (10 AP)"
-- The strings are lowerecased and passed into string.find,
-- so you should escape the magic characters ^$()%.[]*+-? with a %
-- Use /rb debug to help with debugging stat patterns
L["statPatterns"] = {
	[StatLogic.Stats.Strength] = { SPELL_STAT1_NAME:lower() },
	[StatLogic.Stats.Agility] = { SPELL_STAT2_NAME:lower() },
	[StatLogic.Stats.Stamina] = { SPELL_STAT3_NAME:lower() },
	[StatLogic.Stats.Intellect] = { SPELL_STAT4_NAME:lower() },
	[StatLogic.Stats.Spirit] = { SPELL_STAT5_NAME:lower() },
	[StatLogic.Stats.DefenseRating] = { "방어 숙련도" },
	[StatLogic.Stats.Defense] = { DEFENSE:lower() },
	[StatLogic.Stats.DodgeRating] = { "회피 숙련도", "회피" },
	[StatLogic.Stats.BlockRating] = { "방패 막기 숙련도", "방패 막기" },
	[StatLogic.Stats.ParryRating] = { "무기 막기 숙련도", "무기 막기" },

	[StatLogic.Stats.SpellPower] = { "주문력" },
	[StatLogic.Stats.GenericAttackPower] = { "전투력이" },

	[StatLogic.Stats.MeleeCritRating] = { "근접 치명타 적중도", "치명타 적중도", "치명타 및 극대화" },
	[StatLogic.Stats.RangedCritRating] = { "원거리 치명타 적중도" },
	[StatLogic.Stats.SpellCritRating] = { "주문 극대화 적중도", "주문의 극대화 적중도" },
	[StatLogic.Stats.CritRating] = { "치명타 적중도", "치명타 및 극대화" },

	[StatLogic.Stats.MeleeHitRating] = { "적중도", "적중" },
	[StatLogic.Stats.RangedHitRating] = { "원거리 적중도" },
	[StatLogic.Stats.SpellHitRating] = { "주문 적중도" },
	[StatLogic.Stats.HitRating] = { "적중도", "적중" },

	[StatLogic.Stats.ResilienceRating] = { "탄력도", "탄력" },
	[StatLogic.Stats.PvpPowerRating] = { ITEM_MOD_PVP_POWER_SHORT:lower() },

	[StatLogic.Stats.MeleeHasteRating] = { "공격 가속도", "가속", "가속도" },
	[StatLogic.Stats.RangedHasteRating] = { "원거리 공격 가속도" },
	[StatLogic.Stats.SpellHasteRating] = { "주문 시전 가속도" },
	[StatLogic.Stats.HasteRating] = { "공격 가속도", "가속", "가속도" },

	[StatLogic.Stats.ExpertiseRating] = { "숙련도", "숙련" },

	[StatLogic.Stats.AllStats] = { SPELL_STATALL:lower() },

	[StatLogic.Stats.ArmorPenetrationRating] = { "방어구 관통력" },	--armor penetration rating
	[StatLogic.Stats.MasteryRating] = { "특화" },
	[StatLogic.Stats.Armor] = { ARMOR:lower() },
}
-------------------------
-- Added info patterns --
-------------------------
-- Controls the order of values and stats in stat breakdowns
-- "%s %s"     -> "+1.34% Crit"
-- "%2$s $1$s" -> "Crit +1.34%"
L["StatBreakdownOrder"] = "%s %s"
L["numberSuffix"] = "만큼 증가합니다"
L["Show %s"] = "%s "..SHOW
L["Show Modified %s"] = "Show Modified %s"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["Spell"] = "주문"

-- Basic Attributes
L[StatLogic.Stats.Strength] = "힘"
L[StatLogic.Stats.Agility] = "민첩성"
L[StatLogic.Stats.Stamina] = "체력"
L[StatLogic.Stats.Intellect] = "지능"
L[StatLogic.Stats.Spirit] = "정신력"
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.MasteryRating] = STAT_MASTERY.." "..RATING

-- Resources
L[StatLogic.Stats.Health] = "생명력"
S[StatLogic.Stats.Health] = "생명력"
L[StatLogic.Stats.Mana] = "마나"
S[StatLogic.Stats.Mana] = "마나"
L[StatLogic.Stats.ManaRegen] = "마나 회복량"
S[StatLogic.Stats.ManaRegen] = "MP5"

local ManaRegenOutOfCombat = "마나 회복량 (비전투)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "마나 회복량 (시전하지)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "MP5(NC)"

L[StatLogic.Stats.HealthRegen] = "생명력 재생"
S[StatLogic.Stats.HealthRegen] = "HP5"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "생명력 재생 (비전투)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "HP5(NC)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "전투력"
S[StatLogic.Stats.AttackPower] = "전투력"
L[StatLogic.Stats.FeralAttackPower] = "야생 전투력"
L[StatLogic.Stats.IgnoreArmor] = "방어도 무시"
L[StatLogic.Stats.ArmorPenetration] = "방어도 관통력 합계"
L[StatLogic.Stats.ArmorPenetrationRating] = "방어도 관통도 합계"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "근접 무기 "..DAMAGE -- DAMAGE = "Damage"
L[StatLogic.Stats.WeaponDPS] = "초당 공격력"

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "적중률"
L[StatLogic.Stats.MeleeHitRating] = "적중도"
L[StatLogic.Stats.MeleeCrit] = "치명타율"
S[StatLogic.Stats.MeleeCrit] = "치명타"
L[StatLogic.Stats.MeleeCritRating] = "치명타율"
L[StatLogic.Stats.MeleeHaste] = "공격 가속"
L[StatLogic.Stats.MeleeHasteRating] = "공격 가속도"

L[StatLogic.Stats.WeaponSkill] = "무기 숙련"
L[StatLogic.Stats.Expertise] = "숙련"
L[StatLogic.Stats.ExpertiseRating] = "숙련 ".." "..RATING
L[StatLogic.Stats.DodgeReduction] = "회피 무시"
S[StatLogic.Stats.DodgeReduction] = "이후 회피 감소 감소"
L[StatLogic.Stats.ParryReduction] = PARRY.." 무시"
S[StatLogic.Stats.ParryReduction] = "이후 무기막기 감소"

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "원거리 전투력"
S[StatLogic.Stats.RangedAttackPower] = "원거리 전투력"
L[StatLogic.Stats.RangedHit] = "원거리 적중률 합계"
L[StatLogic.Stats.RangedHitRating] = "원거리 적중도 합계"
L[StatLogic.Stats.RangedCrit] = "원거리 치명타율 합계"
L[StatLogic.Stats.RangedCritRating] = "원거리 치명타 적중도 합계"
L[StatLogic.Stats.RangedHaste] = "원거리 공격 가속율 합계"
L[StatLogic.Stats.RangedHasteRating] = "원거리 공격 가속도 합계"

-- Spell Stats
L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "주문 공격력"
S[StatLogic.Stats.SpellDamage] = "공격력"
L[StatLogic.Stats.HealingPower] = "치유량"
S[StatLogic.Stats.HealingPower] = "치유량"
L[StatLogic.Stats.SpellPenetration] = "관통력"

L[StatLogic.Stats.HolyDamage] = "신성 주문 공격력"
L[StatLogic.Stats.FireDamage] = "화염 주문 공격력"
L[StatLogic.Stats.NatureDamage] = "자연 주문 공격력"
L[StatLogic.Stats.FrostDamage] = "냉기 주문 공격력"
L[StatLogic.Stats.ShadowDamage] = "암흑 주문 공격력"
L[StatLogic.Stats.ArcaneDamage] = "비전 주문 공격력"

L[StatLogic.Stats.SpellHit] = "주문 적중율"
S[StatLogic.Stats.SpellHit] = "주문 적중"
L[StatLogic.Stats.SpellHitRating] = "주문 적중도"
L[StatLogic.Stats.SpellCrit] = "주문 극대화율"
S[StatLogic.Stats.SpellCrit] = "극대화"
L[StatLogic.Stats.SpellCritRating] = "주문 극대화율"
L[StatLogic.Stats.SpellHaste] = "주문 가속"
L[StatLogic.Stats.SpellHasteRating] = "주문 가속도"

-- Tank Stats
L[StatLogic.Stats.Armor] = "방어도"
L[StatLogic.Stats.BonusArmor] = "방어도"

L[StatLogic.Stats.Avoidance] = "회피량"
L[StatLogic.Stats.Dodge] = "회피율"
S[StatLogic.Stats.Dodge] = "회피"
L[StatLogic.Stats.DodgeRating] = "회피율"
L[StatLogic.Stats.Parry] = "무기 막기 확률"
S[StatLogic.Stats.Parry] = "무막"
L[StatLogic.Stats.ParryRating] = "무기 막기율"
L[StatLogic.Stats.BlockChance] = "방패 막기 확률"
L[StatLogic.Stats.BlockRating] = "방어율"
L[StatLogic.Stats.BlockValue] = "피해 방어량"
S[StatLogic.Stats.BlockValue] = "방어"
L[StatLogic.Stats.Miss] = "공격 회피"

L[StatLogic.Stats.Defense] = "방어 숙련"
L[StatLogic.Stats.DefenseRating] = COMBAT_RATING_NAME2.." "..RATING COMBAT_RATING_NAME2 = "Defense Rating"
L[StatLogic.Stats.CritAvoidance] = "치명타 공격 회피"
S[StatLogic.Stats.CritAvoidance] = "이후 치명타"

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "탄력도"
L[StatLogic.Stats.CritDamageReduction] = "치명타 피해 감소"
S[StatLogic.Stats.CritDamageReduction] = "가질 치명타 데미지"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Taken"

L[StatLogic.Stats.FireResistance] = "화염 저항력"
L[StatLogic.Stats.NatureResistance] = "자연 저항력"
L[StatLogic.Stats.FrostResistance] = "냉기 저항력"
L[StatLogic.Stats.ShadowResistance] = "암흑 저항력"
L[StatLogic.Stats.ArcaneResistance] = "비전 저항력"