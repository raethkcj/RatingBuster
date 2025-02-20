-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "koKR" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["자연의 법칙"] = {[StatLogic.Stats.SpellDamage] = 30, [StatLogic.Stats.HealingPower] = 55, }
W["살아있는 능력치"] = {[StatLogic.Stats.AllStats] = 4, [StatLogic.Stats.NatureResistance] = 15, }
W["활력"] = {[StatLogic.Stats.GenericManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["침착함"] = {[StatLogic.Stats.HitRating] = 10, }
W["전투력"] = {[StatLogic.Stats.GenericAttackPower] = 70, }
W["태양의 불꽃"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["냉기의 영혼"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }
W["돌가죽 가고일의 룬"] = {[StatLogic.Stats.Defense] = 25, }
W["네루비안 등껍질의 룬"] = {[StatLogic.Stats.Defense] = 13, }

local L = addon.StatIDLookup
L["방어도 보강 %s"] = {StatLogic.Stats.BonusArmor, }
L["모든 저항력 %s"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["치유 효과 증가 %s"] = {StatLogic.Stats.HealingPower, }
L["비전 주문 공격력 %s"] = {StatLogic.Stats.ArcaneDamage, }
L["암흑 주문 공격력 %s"] = {StatLogic.Stats.ShadowDamage, }
L["화염 주문 공격력 %s"] = {StatLogic.Stats.FireDamage, }
L["신성 주문 공격력 %s"] = {StatLogic.Stats.HolyDamage, }
L["냉기 주문 공격력 %s"] = {StatLogic.Stats.FrostDamage, }
L["자연 주문 공격력 %s"] = {StatLogic.Stats.NatureDamage, }
L["주문 피해 %s"] = {StatLogic.Stats.SpellDamage, }
L["치유 및 주문 공격력 %s"] = {StatLogic.Stats.SpellDamage, }
L["%s초당 마나 회복 %s"] = {false, StatLogic.Stats.GenericManaRegen, }
L["방어 숙련도 %s / 체력 %s / 방패 피해 방어량 %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.BlockValue, }
L["방어 숙련도 %s / 체력 %s / 치유 효과 증가 %s"] = {StatLogic.Stats.Defense, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["전투력 %s / 회피율 %s%"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Dodge, }
L["원거리 전투력 %s / 체력 %s / 적중률 %s%"] = {StatLogic.Stats.RangedAttackPower, StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["치유 및 주문 공격력 %s / 지능 %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Intellect, }
L["치유 및 주문 공격력 %s / 주문 적중률 %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["치유 및 주문 공격력 %s / 체력 %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.Stamina, }
L["마나 회복 %s / 체력 %s / 치유 효과 중가 %s"] = {StatLogic.Stats.GenericManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["지능 %s / 체력 %s / 치유 효과 증가 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["암흑 공격력 %s"] = {StatLogic.Stats.ShadowDamage, }
L["냉기 공격력 %s"] = {StatLogic.Stats.FrostDamage, }
L["화염 공격력 %s"] = {StatLogic.Stats.FireDamage, }
L["체력 %s/지능 %s/치유 주문 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, StatLogic.Stats.HealingPower, }
L["체력 %s/적중 %s%/치유량 및 주문 공격력 %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["체력 %s/힘 %s/민첩성 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Agility, }
L["체력 %s/힘 %s/방어 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, StatLogic.Stats.Defense, }
L["체력 %s/민첩성 %s/적중 %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["체력 %s/방어 %s/치유량 및 주문 공격력 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["체력 %s/힘 %s/치유량 및 주문 공격력 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Strength, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["체력 %s/지능 %s/치유량 및 주문 공격력 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Intellect, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["체력 %s/민첩성 %s/방어 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Defense, }
L["체력 %s/방어 %s/방패 막기 확률 %s%"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockChance, }
L["체력 %s/적중 %s%/방어 %s"] = {StatLogic.Stats.Stamina, {StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, StatLogic.Stats.Defense, }
L["체력 %s/방어 %s/방패 막기 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Defense, StatLogic.Stats.BlockValue, }
L["체력 %s/민첩성 %s/힘 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, StatLogic.Stats.Strength, }
L["신성 공격력 %s"] = {StatLogic.Stats.HolyDamage, }
L["비전 공격력 %s"] = {StatLogic.Stats.ArcaneDamage, }
L["주문 공격력 및 치유량 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["방어도 보강 (방어도 %s)"] = {StatLogic.Stats.BonusArmor, }
L["방패 막기 숙련도 %s"] = {StatLogic.Stats.BlockRating, }
L["주문 치유량 %s / 주문 공격력 %s"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["치명타 적중도 %s"] = {StatLogic.Stats.CritRating, }
L["주문 공격력 및 치유량 %s / 주문 적중도 %s"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["마나 회복량 %s / 체력 %s / 주문 치유량 %s"] = {StatLogic.Stats.GenericManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["주문 극대화 적중도 %s"] = {StatLogic.Stats.SpellCritRating, }
L["주문 적중도 %s"] = {StatLogic.Stats.SpellHitRating, }
L["무기 공격력 %s"] = {StatLogic.Stats.AverageWeaponDamage, }
L["하급 이동 속도 증가 / 민첩성 %s"] = {StatLogic.Stats.Agility, }
L["하급 이동 속도 증가 / 체력 %s"] = {StatLogic.Stats.Stamina, }
L["암흑 저항력 %s"] = {StatLogic.Stats.ShadowResistance, }
L["화염 저항력 %s"] = {StatLogic.Stats.FireResistance, }
L["냉기 저항력 %s"] = {StatLogic.Stats.FrostResistance, }
L["자연 저항력 %s"] = {StatLogic.Stats.NatureResistance, }
L["비전 저항력 %s"] = {StatLogic.Stats.ArcaneResistance, }
L["%s초당 마나 회복량 %s"] = {false, StatLogic.Stats.GenericManaRegen, }
L["주문 시전 가속도 %s"] = {StatLogic.Stats.SpellHasteRating, }
L["체력 %s"] = {StatLogic.Stats.Stamina, }
L["원거리 적중도 %s"] = {StatLogic.Stats.RangedHitRating, }
L["주문력 %s / 적중도 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["주문력 %s / 체력 %s / %s초당 마나 회복량 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, false, StatLogic.Stats.GenericManaRegen, }
L["적중도 %s / 치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating, }
L["비전 및 화염 주문력 %s"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["힘 %s"] = {StatLogic.Stats.Strength, }
L["암흑 및 냉기 주문력 %s"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["민첩성 %s"] = {StatLogic.Stats.Agility, }
L["주문력 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["지능 %s"] = {StatLogic.Stats.Intellect, }
L["치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.CritRating, }
L["방어 숙련도 %s"] = {StatLogic.Stats.Defense, }
L["적중도 %s"] = {StatLogic.Stats.HitRating, }
L["정신력 %s"] = {StatLogic.Stats.Spirit, }
L["푸른 보석 %s개 착용 시 힘 %s"] = {StatLogic.Stats.Strength, false, }
L["주문력 %s / 지능 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["방어 숙련도 %s / 체력 %s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["지능 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.GenericManaRegen, }
L["주문력 %s / 체력 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["주문력 %s / %s초당 마나 회복량 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, StatLogic.Stats.GenericManaRegen, }
L["민첩성 %s / 체력 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["힘 %s / 체력 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["전투력 %s"] = {StatLogic.Stats.GenericAttackPower, }
L["회피 숙련도 %s"] = {StatLogic.Stats.DodgeRating, }
L["치명타 및 주문 극대화 적중도 %s / 힘 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["무기 막기 숙련도 %s"] = {StatLogic.Stats.ParryRating, }
L["적중도 %s / 민첩성 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["치명타 및 주문 극대화 적중도 %s / 체력 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["탄력도 %s"] = {StatLogic.Stats.ResilienceRating, }
L["치명타 및 주문 극대화 적중도 %s / 주문력 %s"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["치명타 및 주문 극대화 적중도 %s / 주문 관통력 %s"] = {StatLogic.Stats.CritRating, false, }
L["치명타 및 주문 극대화 적중도 %s / %s% 확률로 주문 반사"] = {StatLogic.Stats.CritRating, false, }
L["전투력 %s / 최하급 달리기 속도 증가"] = {StatLogic.Stats.GenericAttackPower, }
L["치명타 및 주문 극대화 적중도 %s / 덫, 이동 불가에 대한 저항력 %s%"] = {StatLogic.Stats.CritRating, false, }
L["체력 %s / 기절 지속시간 %s% 감소"] = {StatLogic.Stats.Stamina, false, }
L["주문력 %s / 위협 수준 %s%만큼 감소"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["방어 숙련도 %s / 공격 받을 시 일정 확률로 생명력 회복"] = {StatLogic.Stats.DefenseRating, }
L["지능 %s / 주문 시전 시 일정 확률로 마나 회복"] = {StatLogic.Stats.Intellect, }
L["체력 %s / 치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["힘 %s / 치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["전투력 %s / 치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.CritRating, }
L["주문력 %s / 최하급 달리기 속도 증가"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["치명타 및 주문 극대화 적중도 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.CritRating, false, StatLogic.Stats.GenericManaRegen, }
L["전투력 %s / 적중도 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.HitRating, }
L["방어 숙련도 %s / 회피 숙련도 %s"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["무기 막기 숙련도 %s / 방어 숙련도 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["힘 %s / 적중도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["회피 숙련도 %s / 체력 %s"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["적중도 %s / 주문력 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["치명타 및 주문 극대화 적중도 %s / 회피 숙련도 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["무기 막기 숙련도 %s / 체력 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["정신력 %s / 주문력 %s"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["주문력 %s / 주문 관통력 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["전투력 %s / 체력 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.Stamina, }
L["회피 숙련도 %s / 적중도 %s"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["주문력 %s / 탄력도 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["지능 %s / 체력 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["민첩성 %s / 방어 숙련도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["지능 %s / 정신력 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["힘 %s / 방어 숙련도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["전투력 %s / 탄력도 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.ResilienceRating, }
L["체력 %s / 탄력도 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["주문력 %s / 치명타 및 주문 극대화 적중도 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["방어 숙련도 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.DefenseRating, false, StatLogic.Stats.GenericManaRegen, }
L["주문력 %s / 정신력 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["회피 숙련도 %s / 탄력도 %s"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["힘 %s / 탄력도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["적중도 %s / 체력 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["적중도 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.HitRating, false, StatLogic.Stats.GenericManaRegen, }
L["무기 막기 숙련도 %s / 탄력도 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["전투력 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.GenericAttackPower, false, StatLogic.Stats.GenericManaRegen, }
L["치명타 및 주문 극대화 적중도 %s / 전투력 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.CritRating, }
L["민첩성 %s / 치명타 피해 %s%만큼 증가"] = {StatLogic.Stats.Agility, false, }
L["전투력 %s / 기절에 대한 저항력 %s%"] = {StatLogic.Stats.GenericAttackPower, false, }
L["주문력 %s / 기절에 대한 저항력 %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["탄력도 %s / 체력 %s"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["체력 %s / 최하급 속도 증가"] = {StatLogic.Stats.Stamina, }
L["%s초당 생명력 및 마나 회복량 %s"] = {false, {StatLogic.Stats.HealthRegen, StatLogic.Stats.GenericManaRegen, }, }
L["치명타 및 주문 극대화 적중도 %s / 치명타 피해 %s%만큼 증가"] = {StatLogic.Stats.CritRating, false, }
L["가속도 %s"] = {StatLogic.Stats.HasteRating, }
L["가속도 %s / 주문력 %s"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["가속도 %s / 체력 %s"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["방어 숙련도 %s / 방패 피해 방어량 %s%"] = {StatLogic.Stats.DefenseRating, false, }
L["주문력 %s / 지능 %s%"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["방어구 관통력 %s"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["숙련 %s"] = {StatLogic.Stats.ExpertiseRating, }
L["방어구 관통력 %s / 체력 %s"] = {false, StatLogic.Stats.Stamina, }
L["숙련 %s / 체력 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["민첩성 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.Agility, false, StatLogic.Stats.GenericManaRegen, }
L["민첩성 %s / 적중도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["힘 %s / 가속도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["민첩성 %s / 치명타 및 주문 극대화 적중도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["민첩성 %s / 탄력도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["민첩성 %s / 가속도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["주문력 %s / 가속도 %s"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["회피 숙련도 %s / 방어 숙련도 %s"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["숙련 %s / 적중도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["숙련 %s / 방어 숙련도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["전투력 %s / 가속도 %s"] = {StatLogic.Stats.GenericAttackPower, StatLogic.Stats.HasteRating, }
L["치명타 및 주문 극대화 적중도 %s / 정신력 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["적중도 %s / 정신력 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["탄력도 %s / 정신력 %s"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["가속도 %s / 정신력 %s"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["탄력도 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.ResilienceRating, false, StatLogic.Stats.GenericManaRegen, }
L["가속도 %s / %s초당 마나 회복량 %s"] = {StatLogic.Stats.HasteRating, false, StatLogic.Stats.GenericManaRegen, }
L["적중도 %s / 주문 관통력 %s"] = {StatLogic.Stats.HitRating, false, }
L["가속도 %s / 주문 관통력 %s"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.SpellPenetration, }
L["숙련도 %s"] = {StatLogic.Stats.ExpertiseRating, }
L["방어구 관통력 + %s"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["지능 %s / %s초당 마나 회복량 %s test용"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.GenericManaRegen, }
L["원거리 가속도 %s"] = {StatLogic.Stats.RangedHasteRating, }
L["원거리 치명타 적중도 %s"] = {StatLogic.Stats.RangedCritRating, }
L["%s초당 마나 회복량 %s / 치유 주문 극대화 효과 %s%만큼 증가"] = {false, StatLogic.Stats.GenericManaRegen, false, }
L["체력 %s / 받는 주문 피해 %s%만큼 감소"] = {StatLogic.Stats.Stamina, false, }
L["주문력 %s / 침묵 지속시간 %s%만큼 감소"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["치명타 및 주문 극대화 적중도 %s / 공포 지속시간 %s%만큼 감소"] = {StatLogic.Stats.CritRating, false, }
L["체력 %s / 아이템에 의한 방어도 %s%만큼 증가"] = {StatLogic.Stats.Stamina, false, }
L["전투력 %s / 기절 지속시간 %s%만큼 감소"] = {StatLogic.Stats.GenericAttackPower, false, }
L["주문력 %s / 기절 지속시간 %s%만큼 감소"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["전투력 %s / 치명타 적중 시 일정 확률로 생명력 회복"] = {StatLogic.Stats.GenericAttackPower, }
L["치명타 및 주문 극대화 적중도 %s / 마나 %s%"] = {StatLogic.Stats.CritRating, false, }
L["체력 %s / 기절 지속시간 %s%만큼 감소"] = {StatLogic.Stats.Stamina, false, }
L["주문력 + %s / 침묵 지속시간 %s%만큼 감소"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["주문력 %s /기절 지속시간 %s%만큼 감소"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["치명타 및 극대화도 %s"] = {StatLogic.Stats.CritRating, }
L["주문 관통력 %s"] = {StatLogic.Stats.SpellPenetration, }
L["가속도 %s / 지능 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["지능 %s / 가속도 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HasteRating, }
L["치명타 및 극대화도 %s / 힘 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["치명타 및 극대화도 %s / 체력 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["치명타 및 극대화도 %s / 지능 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["치명타 및 극대화도 %s / 주문 관통력 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.SpellPenetration, }
L["치명타 및 극대화도 %s / %s% 확률로 주문 반사"] = {StatLogic.Stats.CritRating, false, }
L["치명타 및 극대화도 %s / 최하급 달리기 속도 증가"] = {StatLogic.Stats.CritRating, }
L["치명타 및 극대화도 %s / 감속, 이동 불가 지속시간 %s% 감소"] = {StatLogic.Stats.CritRating, false, }
L["지능 %s / 위협 수준 %s%만큼 감소"] = {StatLogic.Stats.Intellect, false, }
L["회피 숙련도 %s / 공격 받을 시 일정 확률로 생명력 회복"] = {StatLogic.Stats.DodgeRating, }
L["체력 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["힘 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["민첩성 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["지능 %s / 최하급 달리기 속도 증가"] = {StatLogic.Stats.Intellect, }
L["치명타 및 극대화도 %s / 정신력 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["무기 막기 숙련도 %s / 회피 숙련도 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DodgeRating, }
L["지능 %s / 적중도 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["정신력 %s / 지능 %s"] = {StatLogic.Stats.Spirit, StatLogic.Stats.Intellect, }
L["지능 %s / 주문 관통력 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.SpellPenetration, }
L["지능 %s / 탄력도 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.ResilienceRating, }
L["민첩성 %s / 회피 숙련도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.DodgeRating, }
L["힘 %s / 회피 숙련도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.DodgeRating, }
L["지능 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.CritRating, }
L["체력 %s / 회피 숙련도 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DodgeRating, }
L["적중도 %s / 회피 숙련도 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.DodgeRating, }
L["적중도 %s / 가속도 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.HasteRating, }
L["적중도 %s / 지능 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.HitRating, }
L["치명타 및 극대화도 %s / 민첩성 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["민첩성 %s / 치명타 및 극대화 효과 %s%"] = {StatLogic.Stats.Agility, false, }
L["치명타 및 극대화도 %s / 기절에 대한 저항력 %s%"] = {StatLogic.Stats.CritRating, false, }
L["지능 %s / 기절에 대한 저항력 %s%"] = {StatLogic.Stats.Intellect, false, }
L["치명타 및 극대화도 %s / 치명타 및 극대화 효과 %s%"] = {StatLogic.Stats.CritRating, false, }
L["회피 숙련도 %s / 방패 피해 방어량 %s%"] = {StatLogic.Stats.DodgeRating, false, }
L["지능 %s / 최대 마나 %s%"] = {StatLogic.Stats.Intellect, false, }
L["숙련도 %s / 체력 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["회피 숙련도 %s / 무기 막기 숙련도 %s"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ParryRating, }
L["숙련도 %s / 적중도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["숙련도 %s / 회피 숙련도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DodgeRating, }
L["정신력 %s / 탄력도 %s"] = {StatLogic.Stats.Spirit, StatLogic.Stats.ResilienceRating, }
L["정신력 %s / 치명타 및 극대화 효과 %s%"] = {StatLogic.Stats.Spirit, false, }
L["지능 %s / 침묵 지속시간 %s%만큼 감소"] = {StatLogic.Stats.Intellect, false, }
L["치명타 및 극대화도 %s / 공포 지속시간 %s%만큼 감소"] = {StatLogic.Stats.CritRating, false, }
L["치명타 및 극대화도 %s / 기절 지속시간 %s%만큼 감소"] = {StatLogic.Stats.CritRating, false, }
L["지능 %s / 기절 지속시간 %s%만큼 감소"] = {StatLogic.Stats.Intellect, false, }
L["가속도 %s / 치명타 적중 시 일정 확률로 생명력 회복"] = {StatLogic.Stats.HasteRating, }
L["치명타 및 극대화도 %s / 마나 %s%"] = {StatLogic.Stats.CritRating, false, }
L["지능 %s /기절 지속시간 %s%만큼 감소"] = {StatLogic.Stats.Intellect, false, }
L["체력 %s / 민첩성 %s"] = {StatLogic.Stats.Stamina, StatLogic.Stats.Agility, }
L["특화도 %s/ 정신력 %s"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["특화도 %s / 적중도 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.MasteryRating, }
L["특화도 %s / 정신력 %s"] = {StatLogic.Stats.Spirit, StatLogic.Stats.MasteryRating, }
L["특화도 %s"] = {StatLogic.Stats.MasteryRating, }
L["무기 막기 숙련도 %s / 적중도 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.HitRating, }
L["힘 %s / 특화도 %s"] = {StatLogic.Stats.Strength, StatLogic.Stats.MasteryRating, }
L["민첩성 %s / 특화도 %s"] = {StatLogic.Stats.Agility, StatLogic.Stats.MasteryRating, }
L["무기 막기 숙련도 %s / 특화도 %s"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.MasteryRating, }
L["지능 %s / 특화도 %s"] = {StatLogic.Stats.Intellect, StatLogic.Stats.MasteryRating, }
L["숙련도 %s / 특화도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.MasteryRating, }
L["치명타 및 극대화도 %s / 적중도 %s"] = {StatLogic.Stats.CritRating, StatLogic.Stats.HitRating, }
L["가속도 %s / 적중도 %s"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.HitRating, }
L["특화도 %s / 체력 %s"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Stamina, }
L["특화도 %s / 최하급 달리기 속도 증가"] = {StatLogic.Stats.MasteryRating, }
L["체력 %s / 방패 피해 방어량 %s%"] = {StatLogic.Stats.Stamina, false, }
L["탄력도 %s / 주문 관통력 %s"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.SpellPenetration, }
L["힘 %s / 치명타 및 극대화 효과 %s%"] = {StatLogic.Stats.Strength, false, }
L["지능 %s / 치명타 및 극대화 효과 %s%"] = {StatLogic.Stats.Intellect, false, }
L["정신력 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.Spirit, StatLogic.Stats.CritRating, }
L["적중도 %s / 특화도 %s"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.HitRating, }
L["주문 관통력 %s / 특화도 %s"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.SpellPenetration, }
L["정신력 %s / 특화도 %s"] = {StatLogic.Stats.MasteryRating, StatLogic.Stats.Spirit, }
L["적중도 %s / 탄력도 %s"] = {StatLogic.Stats.HitRating, StatLogic.Stats.ResilienceRating, }
L["주문 관통력 %s / 탄력도 %s"] = {StatLogic.Stats.SpellPenetration, StatLogic.Stats.ResilienceRating, }
L["숙련도 %s / 치명타 및 극대화도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.CritRating, }
L["숙련도 %s / 가속도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HasteRating, }
L["숙련도 %s / 탄력도 %s"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.ResilienceRating, }
L["매 %s초마다 %s의 생명력이 회복됩니다"] = {false, StatLogic.Stats.HealthRegen, }
L["한손 도검류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["양손 도검류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["한손 둔기류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["양손 둔기류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["단검류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["활류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["총기류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["한손 도끼류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["양손 도끼류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["치명타를 적중시킬 확률이 %s%만큼 증가합니다"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["화염 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.FireDamage, }
L["자연 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.NatureDamage, }
L["냉기 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.FrostDamage, }
L["암흑 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.ShadowDamage, }
L["방어 숙련도가 %s만큼, 암흑 마법 저항력이 %s만큼 증가하고 평상시 생명력 회복 속도가 %s만큼 향상됩니다"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["비전 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.ArcaneDamage, }
L["무기 막기 확률이 %s%만큼 증가합니다"] = {StatLogic.Stats.Parry, }
L["공격을 회피할 확률이 %s%만큼 증가합니다"] = {StatLogic.Stats.Dodge, }
L["무기의 적중률이 %s%만큼 증가합니다"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["주문이 극대화 효과를 낼 확률이 %s%만큼 증가합니다"] = {StatLogic.Stats.SpellCrit, }
L["지팡이류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["신성 계열의 주문과 효과의 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.HolyDamage, }
L["석궁류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["주문의 적중률이 %s%만큼 증가합니다"] = {StatLogic.Stats.SpellHit, }
L["장착 무기류 숙련도 %s"] = {StatLogic.Stats.WeaponSkill, }
L["자신의 주문에 대한 대상의 마법 저항력을 %s만큼 감소시킵니다"] = {StatLogic.Stats.SpellPenetration, }
L["주위 %s미터 반경에 있는 모든 파티원의 주문 극대화 확률이 %s%만큼 증가합니다"] = {false, StatLogic.Stats.SpellCrit, }
L["주위 %s미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 피해와 치유량이 최대 %s만큼 증가합니다"] = {false, StatLogic.Stats.SpellDamage, }
L["주위 %s미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 최대 %s만큼 증가합니다"] = {false, StatLogic.Stats.HealingPower, }
L["주위 %s미터 반경 내에 있는 모든 파티원의 마나가 매 %s초마다 %s만큼 회복됩니다"] = {false, false, StatLogic.Stats.GenericManaRegen, }
L["주문의 공격력이 최대 %s만큼 치유량이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["모든 주문과 공격의 적중률이 %s%만큼 증가합니다"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["모든 주문과 공격의 주문 극대화 확률과 치명타 적중도가 %s%만큼 증가합니다"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["공격이 회피당하거나 무기 막기에 막힐 확률이 %s%만큼 감소합니다"] = {{StatLogic.Stats.DodgeReduction, StatLogic.Stats.ParryReduction, }, }
L["공격 속도가 %s%만큼 증가합니다"] = {{StatLogic.Stats.MeleeHaste, StatLogic.Stats.RangedHaste, }, }
L["주위 %s미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 피해와 치유량이 최대 %s만큼 증가합니다. 이 효과는 다른 여러 장비와 효과에 의해 중첩되지 않습니다"] = {false, {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, }
L["주위 %s미터 반경에 있는 모든 파티원의 모든 주문 및 효과에 의한 치유량이 최대 %s만큼, 공격력이 최대 %s만큼 증가합니다. 이 효과는 다른 여러 장비와 효과에 의해 중첩되지 않습니다"] = {false, StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["주위 %s미터 반경에 있는 모든 파티원의 주문 시전 속도가 %s%만큼 증가합니다. 이 효과는 다른 여러 장비와 효과에 의해 중첩되지 않습니다"] = {false, StatLogic.Stats.SpellHaste, }
L["주위 %s미터 반경에 있는 모든 파티원의 주문 극대화 확률이 %s%만큼 증가합니다. 이 효과는 다른 여러 장비와 효과에 의해 중첩되지 않습니다"] = {false, StatLogic.Stats.SpellCrit, }
L["정신 집중이 아닌 주문의 시전 속도가 %s%만큼 증가합니다"] = {StatLogic.Stats.SpellHaste, }
L["방패로 적의 공격을 방어할 확률이 %s%만큼 증가합니다"] = {StatLogic.Stats.BlockChance, }
L["모든 주문 및 효과에 의한 피해와 치유량이 최대 %s만큼 증가합니다"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["모든 주문 및 효과에 의한 치유량이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.HealingPower, }
L["표범, 광포한 곰, 곰 변신 상태일 때 전투력이 %s만큼 증가합니다"] = {StatLogic.Stats.FeralAttackPower, }
L["표범, 곰, 광포한 곰 변신 상태일 때 전투력이 %s만큼 증가합니다"] = {StatLogic.Stats.FeralAttackPower, }
L["모든 주문 및 효과에 의한 치유량이 최대 %s만큼, 공격력이 최대 %s만큼 증가합니다"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["치명타 적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.CritRating, }
L["원거리 치명타 적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.RangedCritRating, }
L["방패 막기 숙련도가 %s만큼 증가합니다"] = {StatLogic.Stats.BlockRating, }
L["적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.HitRating, }
L["주문의 극대화 적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.SpellCritRating, }
L["원거리 적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.RangedHitRating, }
L["주문 적중도가 %s만큼 증가합니다"] = {StatLogic.Stats.SpellHitRating, }
L["주문 관통력이 %s만큼 증가합니다"] = {StatLogic.Stats.SpellPenetration, }
L["주위 %s미터 반경에 있는 모든 파티원의 주문 극대화 적중도가 %s만큼 증가합니다"] = {false, StatLogic.Stats.SpellCritRating, }
L["공격 시 적의 방어도를 %s만큼 무시합니다"] = {StatLogic.Stats.IgnoreArmor, }
L["방어구 관통력이 %s만큼 증가합니다"] = {StatLogic.Stats.ArmorPenetrationRating, }
