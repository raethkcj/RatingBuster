-- THIS FILE IS AUTOGENERATED. Add new entries to scripts/GenerateStatLocales/StatLocaleData.json instead.
local addonName, addon = ...
if GetLocale() ~= "zhTW" then return end
local StatLogic = LibStub(addonName)

local W = addon.WholeTextLookup
W["活力"] = {[StatLogic.Stats.ManaRegen] = 4, [StatLogic.Stats.HealthRegen] = 4, }
W["穩固"] = {[StatLogic.Stats.HitRating] = 10, }
W["兇蠻"] = {[StatLogic.Stats.AttackPower] = 70, }
W["烈日火焰"] = {[StatLogic.Stats.ArcaneDamage] = 50, [StatLogic.Stats.FireDamage] = 50, }
W["靈魂冰霜"] = {[StatLogic.Stats.ShadowDamage] = 54, [StatLogic.Stats.FrostDamage] = 54, }

local L = addon.StatIDLookup
L["強化護甲 %s"] = {StatLogic.Stats.BonusArmor, }
L["全部抗性 %s"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["提高神聖效果 %s"] = {StatLogic.Stats.HealingPower, }
L["%s 祕法法術傷害"] = {StatLogic.Stats.ArcaneDamage, }
L["%s 暗影法術傷害"] = {StatLogic.Stats.ShadowDamage, }
L["%s 火焰法術傷害"] = {StatLogic.Stats.FireDamage, }
L["%s 神聖法術傷害"] = {StatLogic.Stats.HolyDamage, }
L["%s 冰霜法術傷害"] = {StatLogic.Stats.FrostDamage, }
L["%s 自然法術傷害"] = {StatLogic.Stats.NatureDamage, }
L["%s 治療法術"] = {StatLogic.Stats.HealingPower, }
L["法術傷害 %s"] = {StatLogic.Stats.SpellDamage, }
L["治療和法術傷害 %s"] = {StatLogic.Stats.SpellDamage, }
L["每%s秒恢復%s點法力。"] = {false, StatLogic.Stats.ManaRegen, }
L["治療和法術傷害 %s/法術命中 %s%"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHit, }
L["法力恢復 %s/耐力 %s/治療法術 %s"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s 傷害及治療法術"] = {StatLogic.Stats.SpellDamage, }
L["暗影傷害 %s"] = {StatLogic.Stats.ShadowDamage, }
L["冰霜傷害 %s"] = {StatLogic.Stats.FrostDamage, }
L["火焰傷害 %s"] = {StatLogic.Stats.FireDamage, }
L["%s強化護甲"] = {StatLogic.Stats.BonusArmor, }
L["%s盾牌格擋等級"] = {StatLogic.Stats.BlockRating, }
L["%s治療法術和%s傷害法術"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["%s致命一擊等級"] = {StatLogic.Stats.CritRating, }
L["%s治療和法術傷害/%s法術命中"] = {{StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }, StatLogic.Stats.SpellHitRating, }
L["%s法力恢復/%s耐力/%s治療法術"] = {StatLogic.Stats.ManaRegen, StatLogic.Stats.Stamina, StatLogic.Stats.HealingPower, }
L["%s所有抗性"] = {{StatLogic.Stats.ArcaneResistance, StatLogic.Stats.FireResistance, StatLogic.Stats.FrostResistance, StatLogic.Stats.NatureResistance, StatLogic.Stats.ShadowResistance, }, }
L["%s法術致命一擊等級"] = {StatLogic.Stats.SpellCritRating, }
L["%s法術命中等級"] = {StatLogic.Stats.SpellHitRating, }
L["%s秘法傷害"] = {StatLogic.Stats.ArcaneDamage, }
L["%s火焰傷害"] = {StatLogic.Stats.FireDamage, }
L["%s自然傷害"] = {StatLogic.Stats.NatureDamage, }
L["%s冰霜傷害"] = {StatLogic.Stats.FrostDamage, }
L["%s暗影傷害"] = {StatLogic.Stats.ShadowDamage, }
L["%s點武器傷害"] = {StatLogic.Stats.AverageWeaponDamage, }
L["初級速度和%s敏捷"] = {StatLogic.Stats.Agility, }
L["初級速度和%s耐力"] = {StatLogic.Stats.Stamina, }
L["%s暗影抗性"] = {StatLogic.Stats.ShadowResistance, }
L["%s火焰抗性"] = {StatLogic.Stats.FireResistance, }
L["%s冰霜抗性"] = {StatLogic.Stats.FrostResistance, }
L["%s自然抗性"] = {StatLogic.Stats.NatureResistance, }
L["%s秘法抗性"] = {StatLogic.Stats.ArcaneResistance, }
L["%s法術加速等級"] = {StatLogic.Stats.SpellHasteRating, }
L["每%s秒恢復%s點法力"] = {false, StatLogic.Stats.ManaRegen, }
L["%s遠程命中等級"] = {StatLogic.Stats.RangedHitRating, }
L["%s法術能量和%s命中等級"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s法術能量和%s耐力及每%s秒恢復%s法力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, false, false, }
L["%s命中等級和%s致命一擊等級"] = {StatLogic.Stats.HitRating, StatLogic.Stats.CritRating, }
L["%s秘法和火焰法術能量"] = {{StatLogic.Stats.ArcaneDamage, StatLogic.Stats.FireDamage, }, }
L["%s暗影和冰霜法術能量"] = {{StatLogic.Stats.ShadowDamage, StatLogic.Stats.FrostDamage, }, }
L["%s力量"] = {StatLogic.Stats.Strength, }
L["%s敏捷"] = {StatLogic.Stats.Agility, }
L["%s耐力"] = {StatLogic.Stats.Stamina, }
L["每%s秒恢復%s法力"] = {false, StatLogic.Stats.ManaRegen, }
L["%s法術能量"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s智力"] = {StatLogic.Stats.Intellect, }
L["%s防禦等級"] = {StatLogic.Stats.DefenseRating, }
L["%s命中等級"] = {StatLogic.Stats.HitRating, }
L["%s精神"] = {StatLogic.Stats.Spirit, }
L["%s顆藍色寶石皆裝備上後%s力量"] = {StatLogic.Stats.Strength, false, }
L["%s法術能量和%s智力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Intellect, }
L["%s防禦等級和%s耐力"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.Stamina, }
L["%s智力和每%s秒恢復%s法力"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.ManaRegen, }
L["%s法術能量和%s耐力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Stamina, }
L["%s法術能量和每%s秒恢復%s法力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, StatLogic.Stats.ManaRegen, }
L["%s敏捷和%s耐力"] = {StatLogic.Stats.Agility, StatLogic.Stats.Stamina, }
L["%s力量和%s耐力"] = {StatLogic.Stats.Strength, StatLogic.Stats.Stamina, }
L["%s攻擊強度"] = {StatLogic.Stats.AttackPower, }
L["%s閃躲等級"] = {StatLogic.Stats.DodgeRating, }
L["%s致命一擊等級和%s力量"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s招架等級"] = {StatLogic.Stats.ParryRating, }
L["%s命中等級和%s敏捷"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s致命一擊等級和%s耐力"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Stamina, }
L["%s韌性等級"] = {StatLogic.Stats.ResilienceRating, }
L["%s致命一擊等級和%s法術能量"] = {StatLogic.Stats.CritRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s致命一擊等級和%s法術穿透力"] = {StatLogic.Stats.CritRating, false, }
L["%s致命一擊等級和%s%法術反射"] = {StatLogic.Stats.CritRating, false, }
L["%s攻擊強度和略微提高奔跑速度"] = {StatLogic.Stats.AttackPower, }
L["%s致命一擊等級和縮短%s%緩速及定身持續時間"] = {StatLogic.Stats.CritRating, false, }
L["%s耐力和縮短%s%昏迷持續時間"] = {StatLogic.Stats.Stamina, false, }
L["%s法術能量和降低%s%威脅值"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s防禦等級和擊中時有機率恢愎生命力"] = {StatLogic.Stats.DefenseRating, }
L["%s智力和有機率在施放法術時恢愎法力"] = {StatLogic.Stats.Intellect, }
L["%s耐力和%s致命一擊等級"] = {StatLogic.Stats.Stamina, StatLogic.Stats.CritRating, }
L["%s力量和%s致命一擊等級"] = {StatLogic.Stats.Strength, StatLogic.Stats.CritRating, }
L["%s攻擊強度和%s致命一擊等級"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s法術能量和略微提高奔跑速度"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s致命一擊等級和每%s秒恢復%s法力"] = {StatLogic.Stats.CritRating, false, StatLogic.Stats.ManaRegen, }
L["%s攻擊強度和%s命中等級"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HitRating, }
L["%s防禦等級和%s閃躲等級"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.DodgeRating, }
L["%s敏捷和%s命中等級"] = {StatLogic.Stats.Agility, StatLogic.Stats.HitRating, }
L["%s招架等級和%s防禦等級"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.DefenseRating, }
L["%s力量和%s命中等級"] = {StatLogic.Stats.Strength, StatLogic.Stats.HitRating, }
L["%s閃躲等級和%s耐力"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.Stamina, }
L["%s命中等級和%s法術能量"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HitRating, }
L["%s致命一擊等級和%s閃躲等級"] = {StatLogic.Stats.CritRating, StatLogic.Stats.DodgeRating, }
L["%s招架等級和%s耐力"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.Stamina, }
L["%s精神和%s法術能量"] = {StatLogic.Stats.Spirit, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s法術能量和%s法術穿透力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s攻擊強度和%s耐力"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.Stamina, }
L["%s閃躲等級和%s命中等級"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.HitRating, }
L["%s法術能量和%s韌性等級"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.ResilienceRating, }
L["%s智力和%s耐力"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Stamina, }
L["%s敏捷和%s防禦等級"] = {StatLogic.Stats.Agility, StatLogic.Stats.DefenseRating, }
L["%s智力和%s精神"] = {StatLogic.Stats.Intellect, StatLogic.Stats.Spirit, }
L["%s力量和%s防禦等級"] = {StatLogic.Stats.Strength, StatLogic.Stats.DefenseRating, }
L["%s耐力和%s防禦等級"] = {StatLogic.Stats.Stamina, StatLogic.Stats.DefenseRating, }
L["%s攻擊強度和%s韌性等級"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.ResilienceRating, }
L["%s耐力和%s韌性等級"] = {StatLogic.Stats.Stamina, StatLogic.Stats.ResilienceRating, }
L["%s法術能量和%s致命一擊等級"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.CritRating, }
L["%s防禦等級和每%s秒恢復%s法力"] = {StatLogic.Stats.DefenseRating, false, StatLogic.Stats.ManaRegen, }
L["%s法術能量和%s精神"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.Spirit, }
L["%s閃躲等級和%s韌性等級"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.ResilienceRating, }
L["%s力量和%s韌性等級"] = {StatLogic.Stats.Strength, StatLogic.Stats.ResilienceRating, }
L["%s命中等級和%s耐力"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Stamina, }
L["%s命中等級和每%s秒恢復%s法力"] = {StatLogic.Stats.HitRating, false, StatLogic.Stats.ManaRegen, }
L["%s招架等級和%s韌性等級"] = {StatLogic.Stats.ParryRating, StatLogic.Stats.ResilienceRating, }
L["%s攻擊強度和每%s秒恢復%s法力"] = {StatLogic.Stats.AttackPower, false, StatLogic.Stats.ManaRegen, }
L["%s致命一擊等級和%s攻擊強度"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.CritRating, }
L["%s敏捷和%s%致命一擊傷害"] = {StatLogic.Stats.Agility, false, }
L["%s攻擊強度和%s%昏迷抗性"] = {StatLogic.Stats.AttackPower, false, }
L["%s法術能量和%s%昏迷抗性"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s韌性等級和%s耐力"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Stamina, }
L["%s耐力和移動速度略微提升"] = {StatLogic.Stats.Stamina, }
L["每%s秒恢復%s生命力和法力"] = {false, {StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen, }, }
L["%s致命一擊等級和%s%致命一擊傷害"] = {StatLogic.Stats.CritRating, false, }
L["%s加速等級"] = {StatLogic.Stats.HasteRating, }
L["%s加速等級和%s法術能量"] = {StatLogic.Stats.HasteRating, {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["%s加速等級和%s耐力"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Stamina, }
L["%s防禦等級和%s%盾牌格擋值"] = {StatLogic.Stats.DefenseRating, false, }
L["%s法術能量和%s%智力"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s護甲穿透等級"] = {StatLogic.Stats.ArmorPenetrationRating, }
L["%s熟練等級"] = {StatLogic.Stats.ExpertiseRating, }
L["%s護甲穿透等級和%s耐力"] = {false, StatLogic.Stats.Stamina, }
L["%s熟練等級和%s耐力"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.Stamina, }
L["%s敏捷和每%s秒恢復%s法力"] = {StatLogic.Stats.Agility, false, StatLogic.Stats.ManaRegen, }
L["%s力量和%s加速等級"] = {StatLogic.Stats.Strength, StatLogic.Stats.HasteRating, }
L["%s敏捷和%s致命一擊等級"] = {StatLogic.Stats.Agility, StatLogic.Stats.CritRating, }
L["%s敏捷和%s韌性等級"] = {StatLogic.Stats.Agility, StatLogic.Stats.ResilienceRating, }
L["%s敏捷和%s加速等級"] = {StatLogic.Stats.Agility, StatLogic.Stats.HasteRating, }
L["%s法術能量和%s加速等級"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, StatLogic.Stats.HasteRating, }
L["%s閃躲等級和%s防禦等級"] = {StatLogic.Stats.DodgeRating, StatLogic.Stats.DefenseRating, }
L["%s熟練等級和%s命中等級"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.HitRating, }
L["%s熟練等級和%s防禦等級"] = {StatLogic.Stats.ExpertiseRating, StatLogic.Stats.DefenseRating, }
L["%s攻擊強度和%s加速等級"] = {StatLogic.Stats.AttackPower, StatLogic.Stats.HasteRating, }
L["%s致命一擊等級和%s精神"] = {StatLogic.Stats.CritRating, StatLogic.Stats.Spirit, }
L["%s命中等級和%s精神"] = {StatLogic.Stats.HitRating, StatLogic.Stats.Spirit, }
L["%s韌性等級和%s精神"] = {StatLogic.Stats.ResilienceRating, StatLogic.Stats.Spirit, }
L["%s加速等級和%s精神"] = {StatLogic.Stats.HasteRating, StatLogic.Stats.Spirit, }
L["%s韌性等級和每%s秒恢復%s法力"] = {StatLogic.Stats.ResilienceRating, false, StatLogic.Stats.ManaRegen, }
L["%s加速等級和每%s秒恢復%s法力"] = {StatLogic.Stats.HasteRating, false, StatLogic.Stats.ManaRegen, }
L["%s命中等級和%s法術穿透力"] = {StatLogic.Stats.HitRating, false, }
L["%s加速等級和%s法術穿透力"] = {StatLogic.Stats.HasteRating, false, }
L["測試%s智力和每%s秒恢復%s法力"] = {StatLogic.Stats.Intellect, false, StatLogic.Stats.ManaRegen, }
L["%s遠程加速等級"] = {StatLogic.Stats.RangedHasteRating, }
L["%s遠程致命一擊等級"] = {StatLogic.Stats.RangedCritRating, }
L["每%s秒恢復%s法力和%s%極效治療效果"] = {false, StatLogic.Stats.ManaRegen, false, }
L["%s耐力和減少%s%法術傷害"] = {StatLogic.Stats.Stamina, false, }
L["%s法術能量和縮短%s%沉默持續時間"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s致命一擊等級和縮短%s%恐懼持續時間"] = {StatLogic.Stats.CritRating, false, }
L["%s耐力和提高%s%裝備提供的護甲值"] = {StatLogic.Stats.Stamina, false, }
L["%s攻擊強度和縮短%s%昏迷持續時間"] = {StatLogic.Stats.AttackPower, false, }
L["%s法術能量和縮短%s%昏迷持續時間"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, false, }
L["%s攻擊強度和致命一擊時偶爾恢復生命力"] = {StatLogic.Stats.AttackPower, }
L["%s致命一擊等級和%s%法力"] = {StatLogic.Stats.CritRating, false, }
L["每%s秒恢復%s點生命力。"] = {false, StatLogic.Stats.HealthRegen, }
L["劍類武器技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["雙手劍技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["錘類武器技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["雙手錘技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["匕首技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["弓箭技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["槍械技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["斧類武器傷害提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["雙手斧技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["使你造成致命一擊的機率提高%s%。"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, }, }
L["提高火焰法術和效果所造成的傷害，最多%s點。"] = {StatLogic.Stats.FireDamage, }
L["提高自然法術和效果所造成的傷害，最多%s點。"] = {StatLogic.Stats.NatureDamage, }
L["提高冰霜法術和效果所造成的傷害，最多%s點。"] = {StatLogic.Stats.FrostDamage, }
L["提高暗影法術和效果所造成的傷害，最多%s點。"] = {StatLogic.Stats.ShadowDamage, }
L["防禦力提高%s點，暗影抗性提高%s點，生命力恢復速度提高%s點。"] = {StatLogic.Stats.Defense, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["祕法法術和效果造成的傷害提高最多%s點。"] = {StatLogic.Stats.ArcaneDamage, }
L["使你招架攻擊的機率提高%s%。"] = {StatLogic.Stats.Parry, }
L["使你躲閃攻擊的機率提高%s%。"] = {StatLogic.Stats.Dodge, }
L["使你擊中目標的機率提高%s%。"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, }, }
L["使你的法術造成致命一擊的機率提高%s%。"] = {StatLogic.Stats.SpellCrit, }
L["法杖技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["提高神聖法術和效果所造成的傷害，最多%s點。"] = {StatLogic.Stats.HolyDamage, }
L["弩技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["使你的法術擊中敵人的機率提高%s%。"] = {StatLogic.Stats.SpellHit, }
L["拳套武器技能提高%s點。"] = {StatLogic.Stats.WeaponSkill, }
L["使你法術目標的魔法抗性降低%s點。"] = {StatLogic.Stats.SpellPenetration, }
L["使半徑%s碼範圍內的所有小隊成員法術打出致命一擊的機率提高%s%。"] = {false, StatLogic.Stats.SpellCrit, }
L["使半徑%s碼範圍內的隊友，其法術和魔法效果所造成的傷害與治療效果提高最多%s點。"] = {false, StatLogic.Stats.SpellDamage, }
L["使半徑%s碼範圍內的隊友，其法術和魔法效果所造成的治療效果最多提高%s點。"] = {false, StatLogic.Stats.HealingPower, }
L["使周圍半徑%s碼範圍內的隊友每%s秒恢復%s點法力。"] = {false, false, StatLogic.Stats.ManaRegen, }
L["提高你的法術傷害最多%s點，以及你的治療效果最多%s點。"] = {StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }
L["使你的所有攻擊和法術命中的機率提高%s%。"] = {{StatLogic.Stats.MeleeHit, StatLogic.Stats.RangedHit, StatLogic.Stats.SpellHit, }, }
L["使你的所有攻擊和法術造成致命一擊的機率提高%s%。"] = {{StatLogic.Stats.MeleeCrit, StatLogic.Stats.RangedCrit, StatLogic.Stats.SpellCrit, }, }
L["防禦技能提高%s點。"] = {StatLogic.Stats.Defense, }
L["使你用盾牌格擋攻擊的機率提高%s%。"] = {StatLogic.Stats.BlockChance, }
L["提高法術和魔法效果所造成的傷害和治療效果，最多%s點。"] = {{StatLogic.Stats.SpellDamage, StatLogic.Stats.HealingPower, }, }
L["提高法術和魔法效果所造成的治療效果，最多%s點。"] = {StatLogic.Stats.HealingPower, }
L["在獵豹、熊或巨熊形態下的攻擊強度提高%s點。"] = {StatLogic.Stats.FeralAttackPower, }
L["在獵豹、熊和巨熊形態下的攻擊強度提高%s點。"] = {StatLogic.Stats.FeralAttackPower, }
L["使你的致命一擊等級提高%s點。"] = {StatLogic.Stats.CritRating, }
L["使法術和魔法效果所造成的治療效果提高最多%s點，法術傷害提高最多%s點。"] = {StatLogic.Stats.HealingPower, StatLogic.Stats.SpellDamage, }
L["使你的遠程攻擊致命一擊等級提高%s點。"] = {StatLogic.Stats.RangedCritRating, }
L["使防禦等級提高%s點，暗影抗性提高%s點和一般的生命力恢復速度提高%s點。"] = {StatLogic.Stats.DefenseRating, StatLogic.Stats.ShadowResistance, StatLogic.Stats.HealthRegen, }
L["使你的格擋等級提高%s點。"] = {StatLogic.Stats.BlockRating, }
L["使你的命中等級提高%s點。"] = {StatLogic.Stats.HitRating, }
L["使你的法術致命一擊等級提高%s點。"] = {StatLogic.Stats.SpellCritRating, }
L["使你的遠程命中等級提高%s點"] = {StatLogic.Stats.RangedHitRating, }
L["使你的法術命中等級提高%s點。"] = {StatLogic.Stats.SpellHitRating, }
L["使你的法術穿透力提高%s點。"] = {StatLogic.Stats.SpellPenetration, }
L["使半徑%s碼範圍內所有小隊成員的法術致命一擊等級提高%s點。"] = {false, StatLogic.Stats.SpellCritRating, }
L["使神聖法術和效果所造成的傷害提高最多%s點。"] = {StatLogic.Stats.HolyDamage, }
L["你的攻擊無視目標%s點護甲值。"] = {StatLogic.Stats.IgnoreArmor, }
L["提高%s點護甲穿透等級。"] = {StatLogic.Stats.ArmorPenetrationRating, }
