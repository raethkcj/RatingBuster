--[[
Name: RatingBuster ruRU locale
Translated by:
- Orsana
- StingerSoft
- Swix
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "ruRU")
if not L then return end
addon.S = {}
local S = addon.S
local StatLogic = LibStub("StatLogic")
-- This file is coded in UTF-8
----
-- To translate AceLocale strings, replace true with the translation string
-- Before: L["Show Item ID"] = true,
-- After:  L["Show Item ID"] = "Показывать ID",
L["RatingBuster Options"] = "Окно настроек"
L["Enabled"] = "Включён"
L["Suspend/resume this addon"] = "Отключить/Запустить аддон"
---------------------------
-- Slash Command Options --
---------------------------
L["Always"] = "Всегда"
L["ALT Key"] = "Клавиша ALT"
L["CTRL Key"] = "Клавиша CTRL"
L["SHIFT Key"] = "Клавиша SHIFT"
L["Never"] = "Никогда"
L["General Settings"] = "Основные настройки"
L["Profiles"] = "Профили"
-- /rb win
L["Options Window"] = "Окно настроек"
L["Shows the Options Window"] = "Показать окно настроек"
-- /rb statmod
L["Enable Stat Mods"] = "Включить модуль статистики"
L["Enable support for Stat Mods"] = "Включает поддержку модуля статистики"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Включить убывания уклонений от удара"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Значения уклонения, парирования, уклонений от удара при расчетах будет использоваться формула убывания (deminishing return) уклонений от удара по вашим текущим данным"
-- /rb itemid
L["Show ItemID"] = "ID предмета"
L["Show the ItemID in tooltips"] = "Показывать ID предмета в описании"
-- /rb itemlevel
L["Show ItemLevel"] = "Уровень предмета"
L["Show the ItemLevel in tooltips"] = "Показывать уровень предмета в описании"
-- /rb usereqlv
L["Use required level"] = "Рассчет для мин. уровня"
L["Calculate using the required level if you are below the required level"] = "Рассчитывать статы исходя из минимально необходимого для надевания предмета уровня, если вы ниже этого уровня"
-- /rb level
L["Set level"] = "Задать уровень"
L["Set the level used in calculations (0 = your level)"] = "Задать уровень используемый в расчетах (0 - ваш уровень)"
-- /rb color
L["Change text color"] = "Изменить цвет текста"
L["Changes the color of added text"] = "Изменить цвет добавляемого текста"
L["Change number color"] = "Изменить цвет значений"
-- /rb rating
L["Rating"] = "Рейтинги"
L["Options for Rating display"] = "Настройки отображения рейтингов"
-- /rb rating show
L["Show Rating conversions"] = "Конвертация рейтингов"
L["Show Rating conversions in tooltips"] = "Выберите когда показывать конвертацию рейтингов в подсказке"
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
-- /rb rating spell
L["Show Spell Hit/Haste"] = "Меткость/скорость заклинаний"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Показывать меткость/скорость заклинаний из рейтинга меткости/скорость"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "Меткость/скорость физических атак"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Показывать меткость/скорость физических атак из рейтинга меткости"
-- /rb rating detail
L["Show detailed conversions text"] = "Детальная конвертация рейтингов"
L["Show detailed text for Resilience and Expertise conversions"] = "Показывать детальную конвертацию рейтингов мастерства и устойчивости"
-- /rb rating exp
L["Expertise breakdown"] = "Разбивать уровень мастерства"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Разбивать уровень мастерства на игнорирование уклонения и парирования"
---------------------------------------------------------------------------
-- /rb stat
L["Stat Breakdown"] = "Конвертация статов"
L["Changes the display of base stats"] = "Показывать расчет базовых характеристик"
-- /rb stat show
L["Show base stat conversions"] = "Базовые характеристики"
L["Select when to show base stat conversions in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать изменение базовых статов в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
L["Changes the display of %s"] = "Изменить отображение %s"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Итого:"
L["Options for stat summary"] = "Итоги по статам"
L["Sum %s"] = "Сумма %s"
-- /rb sum show
L["Show stat summary"] = "Показывать суммарные изменения"
L["Show stat summary in tooltips"] = "Выберите когда показывать суммарные изменения в подсказке"
-- /rb sum ignore
L["Ignore settings"] = "Настройки игнорирования"
L["Ignore stuff when calculating the stat summary"] = "Настройка игнорирования при расчете итога"
-- /rb sum ignore unused
L["Ignore unused item types"] = "Игнорирование неподходящих предметов"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Скрыть итоги по статам для неподходящих предметов"
L["Ignore non-primary stat"] = "Ignore non-primary stat"
L["Show stat summary only for items with your specialization's primary stat"] = "Show stat summary only for items with your specialization's primary stat"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Не показывать для надетых вещей"
L["Hide stat summary for equipped items"] = "Не показывать для надетых вещей"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Игнорировать чары"
L["Ignore enchants on items when calculating the stat summary"] = "Игнорировать чары при расчете итога"
-- /rb sum ignore gem
L["Ignore gems"] = "Игнорировать самоцветы"
L["Ignore gems on items when calculating the stat summary"] = "Игнорировать самоцветы при расчете итога"
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
-- /rb sum diffstyle
L["Display Style For diff value"] = "Стиль отображения отличия значений"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Отображения различных значений в главной подсказке или только в сравнительных подсказках"
L["Hide Blizzard Item Comparisons"] = "Скрыть сравнение от Blizzard"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Отключить сравнение предметов Blizzard, если используется метод сравнения RatingBuster"
-- /rb sum space
L["Add empty line"] = "Добавить пустую линию"
L["Add a empty line before or after stat summary"] = "Добавить пустую линию перед или после итогов"
-- /rb sum space before
L["Add before summary"] = "Линия до итога"
L["Add a empty line before stat summary"] = "Добавить линию до итога"
-- /rb sum space after
L["Add after summary"] = "Линия после итога"
L["Add a empty line after stat summary"] = "Добавить линию после итога"
-- /rb sum icon
L["Show icon"] = "Показать иконку"
L["Show the sigma icon before stat summary"] = "Показать знак суммы перед итогом"
-- /rb sum title
L["Show title text"] = "Показать заголовок"
L["Show the title text before stat summary"] = "Показать заголовок до списка итога"
L["Show profile name"] = "Show profile name"
L["Show profile name before stat summary"] = "Show profile name before stat summary"
-- /rb sum showzerostat
L["Show zero value stats"] = "Показывать нулевые статы"
L["Show zero value stats in summary for consistancy"] = "Показывать нулевые статы"
-- /rb sum calcsum
L["Calculate stat sum"] = "Рассчитать сумму характеристик"
L["Calculate the total stats for the item"] = "Рассчитать все статы для предмета"
-- /rb sum calcdiff
L["Calculate stat diff"] = "Рассчитывать разницу в статах"
L["Calculate the stat difference for the item and equipped items"] = "Рассчитывать разницу в статах с надетой вещью"
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "Сортировать статы в алфавитном порядке"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Если включено - то по алфавиту, если выключено, то по смыслу (базовые, физические, заклинания, танковые)"
-- /rb sum avoidhasblock
L["Include block chance In Avoidance summary"] = "Включать вероятность блока в итоге избежаний"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Включать вероятность блока в итоге избежаний, отключение только для уклона, парирования, промоха"
---------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "Статы - базовые"
L["Choose basic stats for summary"] = "Выбор базовых статов для подсчета"
-- /rb sum basic hp
L["Health <- Health, Stamina"] = "Здоровье, выносливость -> Здоровье"
-- /rb sum basic mp
L["Mana <- Mana, Intellect"] = "Мана, интеллект -> Мана"
-- /rb sum basic mp5
L["Combat Mana Regen <- Mana Regen, Spirit"] = "Восстановление маны, дух -> Восстановление маны в бою"
-- /rb sum basic mp5oc
L["Normal Mana Regen <- Spirit"] = "Дух -> Сумма восстановления маны вне боя"
-- /rb sum basic hp5
L["Combat Health Regen <- Health Regen"] = "Восстановление здоровья -> Восстановление здоровья в бою"
-- /rb sum basic hp5oc
L["Normal Health Regen <- Spirit"] = "Дух -> Сумма восстановления здоровья вне боя"
-- /rb sum basic mastery
L["Mastery Summary"] = "Суммировать искусность"
-- /rb sum basic masteryrating
---------------------------------------------------------------------------
-- /rb sum physical
L["Stat - Physical"] = "Статы - физические"
L["Choose physical damage stats for summary"] = "Выбор статов физического урона для подсчета"
-- /rb sum physical ap
L["Attack Power <- Attack Power, Strength, Agility"] = "Сила атаки, сила, ловкость -> Сила атаки"
-- /rb sum physical rap
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Сила атаки дальнего боя, интеллект, сила атаки, сила, ловкость -> Сила атаки дальнего боя"
-- /rb sum physical hit
L["Hit Chance <- Hit Rating"] = "Рейтинг меткости -> Вероятность поподания"
-- /rb sum physical crit
L["Crit Chance <- Crit Rating, Agility"] = "Рейтинг крит. удара, ловкость -> Вероятность крит. удара"
-- /rb sum physical haste
L["Haste <- Haste Rating"] = "Рейтинг скорости -> Скорость"
-- /rb sum physical rangedhit
L["Ranged Hit Chance <- Hit Rating, Ranged Hit Rating"] = "Рейтинг меткости, рейтинг меткости дальнего боя -> Вероятность поподания в дальнем бою"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Ranged Crit Rating"] = "Рейтинг крита, ловкость, рейтинг крит. удара дальнего боя -> Вероятность крит. удара в дальнем бою"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Рейтинг скорости, рейтинг скорости дальнего боя -> Скорость дальнего боя"
-- /rb sum physical wpn
L["Weapon Skill <- Weapon Skill Rating"] = "Рейтинг владения оружием -> Оружейный навык"
-- /rb sum physical exp
L["Expertise <- Expertise Rating"] = "Рейтинг мастерства -> Мастерство"
-- /rb sum physical exprating
---------------------------------------------------------------------------
-- /rb sum spell
L["Stat - Spell"] = "Статы - заклинания"
L["Choose spell damage and healing stats for summary"] = "Выбор магических статов для подсчета"
-- /rb sum spell power
L["Spell Power <- Spell Power, Intellect, Agility, Strength"] = "Сила заклинаний, интеллект, ловкость, сила -> Сила заклинаний"
-- /rb sum spell dmg
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Сила заклинаний, интеллект, дух, выносливость -> Сила заклинаний" -- Changed from Damage to Power
-- /rb sum spell dmgholy
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Урон от светлой магии, сила заклинаний, интеллект, дух -> Урон от светлой магии"
-- /rb sum spell dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Урон от тайной магии, сила заклинаний, интеллект -> Урон от тайной магии"
-- /rb sum spell dmgfire
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Урон от огня, сила заклинаний, интеллект, выносливость -> Урон от огня"
-- /rb sum spell dmgnature
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Урон от сил природы, сила заклинаний, интеллект -> Урон от сил природы"
-- /rb sum spell dmgfrost
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Урон от магии льда, сила заклинаний, интеллект -> Урон от магии льда"
-- /rb sum spell dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Урон от темной магии, сила заклинаний, интеллект, дух, выносливость -> Урон от темной магии"
-- /rb sum spell heal
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Исцеление, интеллект, дух, ловкость, сила -> Исцеление"
-- /rb sum spell crit
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Рейтинг крит. удара заклинаниями, интеллект -> Вероятность крит. удара заклинаниями"
-- /rb sum spell hit
L["Spell Hit Chance <- Spell Hit Rating"] = "Рейтинг меткости заклинаний -> Вероятность поподания заклинаниями"
-- /rb sum spell haste
L["Spell Haste <- Spell Haste Rating"] = "Рейтинг скорости заклинаний -> Скорость заклинаний"
-- /rb sum spell hasterating
---------------------------------------------------------------------------
-- /rb sum tank
L["Stat - Tank"] = "Статы - танк"
L["Choose tank stats for summary"] = "Выбор танковских статов для подсчета"
-- /rb sum tank armor
L["Armor <- Armor from items and bonuses"] = "Броня с одежды и бонусов -> Броня"
-- /rb sum tank dodge
L["Dodge Chance <- Dodge Rating, Agility"] = "Рейтинг уклонения, ловкость -> Вероятность уклонения"
-- /rb sum tank parry
L["Parry Chance <- Parry Rating"] = "Рейтинг парирования -> Вероятность парирования"
-- /rb sum tank block
L["Block Chance <- Block Rating"] = "Рейтинг блокирования -> Вероятность блокирования"
-- /rb sum tank Reductiondodge
L["Dodge Reduction <- Expertise"] = "Игнорирование уклонения <- Мастерство"
-- /rb sum tank Reductionparry
L["Parry Reduction <- Expertise"] = "Игнорирование парирования <- Мастерство"
-- /rb sum tank avoid
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Уклонение от удара <- Уклонение, Парирование, ПромахСущества, Блок(дополнительный)"
---------------------------------------------------------------------------
-- /rb sum gemset
L["Gem Set"] = "Набор самоцветов"
L["Select a gem set to configure"] = "Для настройки выберите набор самоцветов"
L["Default Gem Set 1"] = "Набор по умолчанию 1"
L["Default Gem Set 2"] = "Набор по умолчанию 2"
L["Default Gem Set 3"] = "Набор по умолчанию 3"
-- /rb sum gem
L["Auto fill empty gem slots"] = "Автозаполнение пустых слотов"
-- /rb sum gem red
L["ItemID or Link of the gem you would like to auto fill"] = "ID предмета или ссылка на самоцвет, кторым вы хотите автозаполнять слоты"
L["<ItemID|Link>"] = "<ItemID|Link>"
L["|cffffff7f%s|r is now set to |cffffff7f[%s]|r"] = "|cffffff7f%s|r в настоящее время установлена на |cffffff7f[%s]|r"
L["Invalid input: %s. ItemID or ItemLink required."] = "Ошибочный ввод: %s. Требуется ID предмета либо ссылка."
L["Queried server for Gem: %s. Try again in 5 secs."] = "Запрос у сервера самоцвета: %s. Повторная попытка через 5 сек."
-- /rb sum gem2
L["Second set of default gems which can be toggled with a modifier key"] = "Второй набор самоцветов по умолчанию который может быть переключен с помощью клавиш"
L["Can't use the same modifier as Gem Set 3"] = "Нельзя использовать теже клавиши что и у набора самоцветов 3"
-- /rb sum gem2 key
L["Toggle Key"] = "Клавиша переключения"
L["Use this key to toggle alternate gems"] = "Используйте данную клавишу для переключения альтернативных самоцветов"
-- /rb sum gem3
L["Third set of default gems which can be toggled with a modifier key"] = "Третий набор самоцветов по умолчанию который может быть переключен с помощью клавиш"
L["Can't use the same modifier as Gem Set 2"] = "Нельзя использовать теже клавиши что и у набора самоцветов 2"

-----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Уровень предмета: "
L["ItemID: "] = "ID предмета: "

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
	[StatLogic.Stats.GenericAttackPower] = { "сила атаки", "силу атаки", "силы атаки", "силы вашей атаки", "к силе атаки" },

	-- Resistance and Spell Damage aren't used for breakdowns,
	[NATURE_RES] = { "силам природы" },
	[SPELL_DMG] = { "сила заклинаний", "сила ваших заклинаний", "силу заклинаний", "силы заклинаний", "к силе заклинаний" },

	[StatLogic.Stats.ArmorPenetrationRating] = { "рейтинг пробивания брони", "рейтингу пробивания брони", "рейтинга пробивания брони", "эффективность брони противника" },
	[StatLogic.Stats.Armor] = { "броня", "брони", "броню", "броне" },
	[StatLogic.Stats.Strength] = { "сила", "силу", "силе", "силы" },
	[StatLogic.Stats.Agility] = { "ловкость", "ловкости" },
	[StatLogic.Stats.Stamina] = { "выносливость", "выносливости" },
	[StatLogic.Stats.Intellect] = { "интеллекту", "интеллект" },
	[StatLogic.Stats.Spirit] = { "духу", "дух" },

	[StatLogic.Stats.DefenseRating] = { "рейтинг защиты", "рейтингу защиты", "рейтинга защиты", "к защите" },
	[StatLogic.Stats.Defense] = { DEFENSE:lower() },
	[StatLogic.Stats.DodgeRating] = { "рейтинг уклонения", "рейтингу уклонения", "рейтинга уклонения", "эффективность уклонения", "уклонению" },
	[StatLogic.Stats.BlockRating] = { "рейтинг блокирования щитом", "рейтинга блокирования щитом", "рейтингу блокирования щитом", "увеличение рейтинга блокирования щита на", "рейтинг блока", "рейтинга блока", "рейтингу блока", "блокированию" },
	[StatLogic.Stats.ParryRating] = { "рейтинг парирования", "рейтинга парирования", "рейтингу парирования", "парированию" },

	[StatLogic.Stats.SpellPower] = { "к силе заклинаний" },
	[StatLogic.Stats.SpellCritRating] = { "рейтинг критического удара %(заклинания%)", "рейтингу критического удара %(заклинания%)", "рейтинга критического удара %(заклинания%)", "рейтинга критического удара заклинаниями", "рейтингу критического удара заклинаниями", "рейтинг критического удара заклинаниями", "критический удар %(заклинания%)" },
	[StatLogic.Stats.SpellHitRating] = { "меткость %(заклинания%)" },
	[StatLogic.Stats.RangedCritRating] = { "к критическому удару в дальнем бою" },
	[StatLogic.Stats.CritRating] = { "рейтинг критического удара", "к рейтингу критического эффекта", "рейтингу критического удара", "рейтинга критического удара", "к показателю критического удара" },
	[StatLogic.Stats.MeleeCritRating] = { "рейтинг крит. удара оруж. ближнего боя" },

	[StatLogic.Stats.SpellHitRating] = { "рейтинг меткости %(заклинания%)", "рейтингу меткости %(заклинания%)", "рейтинга меткости %(заклинания%)", "рейтинга меткости заклинаний", "рейтингу меткости заклинаний" },
	[StatLogic.Stats.RangedHitRating] = { "Рейтинг меткости (оруж. дальн. боя)" },
	[StatLogic.Stats.MeleeHitRating] = { "рейтинга нанесения удара ближнего боя" },
	[StatLogic.Stats.HitRating] = { "рейтинг меткости", "рейтинга меткости", "рейтингу меткости", "меткости" },

	[StatLogic.Stats.ResilienceRating] = { "рейтинг устойчивости", "рейтингу устойчивости", "рейтинга устойчивости", "устойчивости" },
	[StatLogic.Stats.PvpPowerRating] = { ITEM_MOD_PVP_POWER_SHORT:lower() },

	[StatLogic.Stats.SpellHasteRating] = { "рейтинг скорости %(заклинания%)", "рейтингу скорости %(заклинания%)", "рейтинга скорости %(заклинания%)", "скорости наложения заклинаний", "скорость наложения заклинаний" },
	[StatLogic.Stats.RangedHasteRating] = { "рейтинг скорости дальнего боя", "рейтингу скорости дальнего боя", "рейтинга скорости дальнего боя" },
	[StatLogic.Stats.HasteRating] = { "рейтинг скорости", "рейтингу скорости", "рейтинга скорости", "скорости" },

	[StatLogic.Stats.ExpertiseRating] = { "мастерства", "мастерству" },

	[StatLogic.Stats.AllStats] = { SPELL_STATALL:lower() },

	[StatLogic.Stats.MasteryRating] = { "искусности", "искусность", "искусност" },
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
L["Spell"] = "для заклинаний"

-- Basic Attributes
L[StatLogic.Stats.Strength] = "Сила"
L[StatLogic.Stats.Agility] = "Ловкость"
L[StatLogic.Stats.Stamina] = "Выносливость"
L[StatLogic.Stats.Intellect] = "Интеллект"
L[StatLogic.Stats.Spirit] = "Дух"
L[StatLogic.Stats.Mastery] = "Искусность"
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format("Искусность")
L[StatLogic.Stats.MasteryRating] = "Рейтинг искусности"

-- Resources
L[StatLogic.Stats.Health] = "Здоровье"
S[StatLogic.Stats.Health] = "к здоровью"
L[StatLogic.Stats.Mana] = "Мана"
S[StatLogic.Stats.Mana] = "к мане"
L[StatLogic.Stats.ManaRegen] = "Восполнение маны"
S[StatLogic.Stats.ManaRegen] = "маны раз в 5 сек."

local ManaRegenOutOfCombat = "Восполнения маны (вне боя)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = ManaRegenOutOfCombat
if addon.tocversion < 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] = "Восполнения маны (пока не применяете заклинания)"
else
	L[StatLogic.Stats.ManaRegenNotCasting] = ManaRegenOutOfCombat
end
S[StatLogic.Stats.ManaRegenNotCasting] = "маны раз в 5 сек. (вне каста)"

L[StatLogic.Stats.HealthRegen] = "Восстановление здоровья"
S[StatLogic.Stats.HealthRegen] = "здоровья раз в 5 сек."
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Восполнение здаровья (вне боя)"
S[StatLogic.Stats.HealthRegenOutOfCombat] = "ХП5 (вне боя)"

-- Physical Stats
L[StatLogic.Stats.AttackPower] = "Сила атаки"
S[StatLogic.Stats.AttackPower] = "к силе атаки"
L[StatLogic.Stats.FeralAttackPower] = "Сила атаки в облике зверя"
L[StatLogic.Stats.IgnoreArmor] = "Игнорирование брони"
L[StatLogic.Stats.ArmorPenetration] = "Пробивание брони"
L[StatLogic.Stats.ArmorPenetrationRating] = "Рейтинг пробивания брони"

-- Weapon Stats
L[StatLogic.Stats.AverageWeaponDamage] = "Average Damage"
L[StatLogic.Stats.WeaponDPS] = "Урон в секунду"

L[StatLogic.Stats.Hit] = STAT_HIT_CHANCE
L[StatLogic.Stats.Crit] = MELEE_CRIT_CHANCE
L[StatLogic.Stats.Haste] = STAT_HASTE

L[StatLogic.Stats.HitRating] = ITEM_MOD_HIT_RATING_SHORT
L[StatLogic.Stats.CritRating] = ITEM_MOD_CRIT_RATING_SHORT
L[StatLogic.Stats.HasteRating] = ITEM_MOD_HASTE_RATING_SHORT

-- Melee Stats
L[StatLogic.Stats.MeleeHit] = "Вероятность попадания"
L[StatLogic.Stats.MeleeHitRating] = "Рейтинг меткости"
L[StatLogic.Stats.MeleeCrit] = "Вероятность крит. удара"
S[StatLogic.Stats.MeleeCrit] = "к крит. удару"
L[StatLogic.Stats.MeleeCritRating] = "Рейтинг крит. удара"
L[StatLogic.Stats.MeleeHaste] = "Скорость"
L[StatLogic.Stats.MeleeHasteRating] = "Рейтинг скорости"

L[StatLogic.Stats.WeaponSkill] = "Оружейный навык"
L[StatLogic.Stats.Expertise] = "Мастерство"
L[StatLogic.Stats.ExpertiseRating] = "Рейтинг мастерства"
L[StatLogic.Stats.DodgeReduction] = "игнорирования уклонения"
S[StatLogic.Stats.DodgeReduction] = "уклонения" -- Target's dodges/parrys against your attacks
L[StatLogic.Stats.ParryReduction] = "игнорирования парирования"
S[StatLogic.Stats.ParryReduction] = "парирования" -- Target's dodges/parrys against your attacks

-- Ranged Stats
L[StatLogic.Stats.RangedAttackPower] = "Сила атаки дальнего боя"
S[StatLogic.Stats.RangedAttackPower] = "к силе атаки дальнего боя"
L[StatLogic.Stats.RangedHit] = "Вероятность поподания в дальнем бою"
L[StatLogic.Stats.RangedHitRating] = "Рейтинга меткости дальнего боя"
L[StatLogic.Stats.RangedCrit] = "Вероятность крит. удара в дальнем бою"
L[StatLogic.Stats.RangedCritRating] = "Рейтинг крит. удара дальнего боя"
L[StatLogic.Stats.RangedHaste] = "Скорость дальнего боя"
L[StatLogic.Stats.RangedHasteRating] = "Рейтинг скорости дальнего боя"

-- Spell Stats
L[StatLogic.Stats.SpellPower] = "Сила заклинаний"
S[StatLogic.Stats.SpellPower] = "к силе заклинаний"
L[StatLogic.Stats.SpellDamage] = "Урон от заклинаний"
S[StatLogic.Stats.SpellDamage] = "к урону от заклинаний"
L[StatLogic.Stats.HealingPower] = "Лечение"
S[StatLogic.Stats.HealingPower] = "к лечению"
L[StatLogic.Stats.SpellPenetration] = "Проникающая способность"

L[StatLogic.Stats.HolyDamage] = "Урон от светлой магии"
L[StatLogic.Stats.FireDamage] = "Урон от огня"
L[StatLogic.Stats.NatureDamage] = "Урон от сил природы"
L[StatLogic.Stats.FrostDamage] = "Урон от магии льда"
L[StatLogic.Stats.ShadowDamage] = "Урон от темной магии"
L[StatLogic.Stats.ArcaneDamage] = "Урон от тайной магии"

L[StatLogic.Stats.SpellHit] = "Вероятность поподания заклинаниями"
S[StatLogic.Stats.SpellHit] = "метк. закл."
L[StatLogic.Stats.SpellHitRating] = "Рейтинг меткости заклинаний"
L[StatLogic.Stats.SpellCrit] = "Вероятность крит. удара заклинаниями"
S[StatLogic.Stats.SpellCrit] = "к крит. удару"
L[StatLogic.Stats.SpellCritRating] = "Рейтинг крит. удара заклинаниями"
L[StatLogic.Stats.SpellHaste] = "Скорость заклинаний"
L[StatLogic.Stats.SpellHasteRating] = "Рейтинг скорости заклинаний"

-- Tank Stats
L[StatLogic.Stats.Armor] = "Броня"
L[StatLogic.Stats.BonusArmor] = "Броня"

L[StatLogic.Stats.Avoidance] = "уклонения от удара"
L[StatLogic.Stats.Dodge] = "Вероятность уклонения"
S[StatLogic.Stats.Dodge] = "к уклонению"
L[StatLogic.Stats.DodgeRating] = "Рейтинг уклонения"
L[StatLogic.Stats.Parry] = "Вероятность парирования"
S[StatLogic.Stats.Parry] = "к парированию"
L[StatLogic.Stats.ParryRating] = "Рейтинг парирования"
L[StatLogic.Stats.BlockChance] = "Вероятность блокирования"
L[StatLogic.Stats.BlockRating] = "Рейтинг блокирования"
L[StatLogic.Stats.BlockValue] = "Показатель блокирования"
S[StatLogic.Stats.BlockValue] = "к показателю блокирования" -- Block value
L[StatLogic.Stats.Miss] = "Miss"

L[StatLogic.Stats.Defense] = "Защита"
L[StatLogic.Stats.DefenseRating] = "Рейтинг защиты"
L[StatLogic.Stats.CritAvoidance] = "Crit Avoidance"
S[StatLogic.Stats.CritAvoidance] = "к получению крит. удара" -- Your chance to get critical hit from target

L[StatLogic.Stats.Resilience] = COMBAT_RATING_NAME15
L[StatLogic.Stats.ResilienceRating] = "устойчивости"
L[StatLogic.Stats.CritDamageReduction] = "Понижение входящего урона от крит. ударов"
S[StatLogic.Stats.CritDamageReduction] = "к получению крит. урона"
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Reduction"
L[StatLogic.Stats.PvpPower] = ITEM_MOD_PVP_POWER_SHORT
L[StatLogic.Stats.PvpPowerRating] = ITEM_MOD_PVP_POWER_SHORT .. " " .. RATING
L[StatLogic.Stats.PvPDamageReduction] = "PvP Damage Taken"

L[StatLogic.Stats.FireResistance] = "Сопротивление огню"
L[StatLogic.Stats.NatureResistance] = "Сопротивление силам природы"
L[StatLogic.Stats.FrostResistance] = "Сопротивление магии льда"
L[StatLogic.Stats.ShadowResistance] = "Сопротивление темной магии"
L[StatLogic.Stats.ArcaneResistance] = "Сопротивление тайной магии"