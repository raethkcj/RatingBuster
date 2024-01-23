--[[
Name: RatingBuster ruRU locale
Revision: $Revision: 343 $
Translated by:
- Orsana \ StingerSoft \ Swix
]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "ruRU")
if not L then return end
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
L["Show the sigma icon before summary listing"] = "Показать знак суммы перед итогом"
-- /rb sum title
L["Show title text"] = "Показать заголовок"
L["Show the title text before summary listing"] = "Показать заголовок до списка итога"
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
-- The first pass searches for the rating number, the patterns are read from L["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from L["statList"] here,
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
	{pattern = " на (%d+)%f[^%d%%]", addInfo = "AfterNumber"},
	{pattern = "([%+%-]%d+)%f[^%d%%] к", addInfo = "AfterStat",},
	{pattern = " увеличена на (%d+)", addInfo = "AfterNumber"},
	{pattern = "(%d+) к ", addInfo = "AfterNumber"}, -- тест
	{pattern = "увеличение (%d+)", addInfo = "AfterNumber"}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "дополнительно (%d+)", addInfo = "AfterNumber"}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)%f[^%d%%|]", addInfo = "AfterNumber"}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}
L["separators"] = {
	"/", " и ", ",", "%. ", " для ", "&", ": %f[^%d]", "\n",
	-- Fix for [Mirror of Truth]
	-- Equip: Chance on melee and ranged critical strike to increase your attack power by 1000 for 10 secs.
	-- 1000 was falsely detected detected as ranged critical strike
	"повысить вашу",
}
--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
-- для русской локализации надо указывать все используемые склонения рейтингов (рейтинг, рейтинга,
	-- рейтингу) т.к. иначе распознавание не работает.
--

L["statList"] = {
	{"ослабление брони противника", false}, -- Annihilator

	{"сила атаки", StatLogic.Stats.AttackPower},
	{"силу атаки", StatLogic.Stats.AttackPower},
	{"силы атаки", StatLogic.Stats.AttackPower},
	{"силы вашей атаки", StatLogic.Stats.AttackPower},
	{"к силе атаки", StatLogic.Stats.AttackPower},

	-- Resistance and Spell Damage aren't used for breakdowns,
	-- but are needed to prevent false matches of other stats
	{"силам природы", NATURE_RES},
	{"сила заклинаний", SPELL_DMG},
	{"сила ваших заклинаний", SPELL_DMG},
	{"силу заклинаний", SPELL_DMG},
	{"силы заклинаний", SPELL_DMG},
	{"к силе заклинаний", SPELL_DMG},

	{"рейтинг пробивания брони", StatLogic.Stats.ArmorPenetrationRating},
	{"рейтингу пробивания брони", StatLogic.Stats.ArmorPenetrationRating},
	{"рейтинга пробивания брони", StatLogic.Stats.ArmorPenetrationRating},
	{"эффективность брони противника", StatLogic.Stats.ArmorPenetrationRating},
	{"броня", StatLogic.Stats.Armor},
	{"брони", StatLogic.Stats.Armor},
	{"броню", StatLogic.Stats.Armor},
	{"броне", StatLogic.Stats.Armor},
	{"сила", StatLogic.Stats.Strength}, -- Strength
	{"силу", StatLogic.Stats.Strength}, -- Strength
	{"силе", StatLogic.Stats.Strength}, -- Strength
	{"силы", StatLogic.Stats.Strength}, -- Strength
	{"ловкость", StatLogic.Stats.Agility}, -- Agility
	{"ловкости", StatLogic.Stats.Agility}, -- Agility
	{"выносливость", StatLogic.Stats.Stamina}, -- Stamina
	{"выносливости", StatLogic.Stats.Stamina}, -- Stamina
	{"интеллекту", StatLogic.Stats.Intellect}, -- Intellect
	{"интеллект", StatLogic.Stats.Intellect}, -- Intellect
	{"духу", StatLogic.Stats.Spirit}, -- Spirit
	{"дух", StatLogic.Stats.Spirit}, -- Spirit

	{"рейтинг защиты", StatLogic.Stats.DefenseRating},
	{"рейтингу защиты", StatLogic.Stats.DefenseRating},
	{"рейтинга защиты", StatLogic.Stats.DefenseRating},
	{"к защите", StatLogic.Stats.DefenseRating},
	{"рейтинг уклонения", StatLogic.Stats.DodgeRating},
	{"рейтингу уклонения", StatLogic.Stats.DodgeRating},
	{"рейтинга уклонения", StatLogic.Stats.DodgeRating},
	{"эффективность уклонения", StatLogic.Stats.DodgeRating},
	{"рейтинг блокирования щитом", StatLogic.Stats.BlockRating}, -- block enchant: "+10 Shield Block Rating"
	{"рейтинга блокирования щитом", StatLogic.Stats.BlockRating},
	{"рейтингу блокирования щитом", StatLogic.Stats.BlockRating},
	{"увеличение рейтинга блокирования щита на", StatLogic.Stats.BlockRating},
	{"рейтинг блока", StatLogic.Stats.BlockRating},
	{"рейтинга блока", StatLogic.Stats.BlockRating},
	{"рейтингу блока", StatLogic.Stats.BlockRating},
	{"рейтинг парирования", StatLogic.Stats.ParryRating},
	{"рейтинга парирования", StatLogic.Stats.ParryRating},
	{"рейтингу парирования", StatLogic.Stats.ParryRating},

	{"рейтинг критического удара %(заклинания%)", StatLogic.Stats.SpellCritRating},
	{"рейтингу критического удара %(заклинания%)", StatLogic.Stats.SpellCritRating},
	{"рейтинга критического удара %(заклинания%)", StatLogic.Stats.SpellCritRating},
	{"рейтинга критического удара заклинаниями", StatLogic.Stats.SpellCritRating},
	{"рейтингу критического удара заклинаниями", StatLogic.Stats.SpellCritRating},
	{"рейтинг критического удара заклинаниями", StatLogic.Stats.SpellCritRating},
	{"критический удар %(заклинания%)", StatLogic.Stats.SpellCritRating},
	{"меткость %(заклинания%)", StatLogic.Stats.SpellHitRating},
	{"к критическому удару в дальнем бою", StatLogic.Stats.RangedCritRating}, -- [Heartseeker Scope]
	{"рейтинг критического удара", StatLogic.Stats.CritRating},
	{"к рейтингу критического эффекта", StatLogic.Stats.CritRating},
	{"рейтингу критического удара", StatLogic.Stats.CritRating},
	{"рейтинга критического удара", StatLogic.Stats.CritRating},
	{"рейтинг крит. удара оруж. ближнего боя", StatLogic.Stats.MeleeCritRating},

	{"рейтинг меткости %(заклинания%)", StatLogic.Stats.SpellHitRating},
	{"рейтингу меткости %(заклинания%)", StatLogic.Stats.SpellHitRating},
	{"рейтинга меткости %(заклинания%)", StatLogic.Stats.SpellHitRating},
	{"рейтинга меткости заклинаний", StatLogic.Stats.SpellHitRating},
	{"рейтингу меткости заклинаний", StatLogic.Stats.SpellHitRating},
	{"Рейтинг меткости (оруж. дальн. боя)", StatLogic.Stats.RangedHitRating},
	{"рейтинга нанесения удара ближнего боя", StatLogic.Stats.MeleeHitRating},
	{"рейтинг меткости", StatLogic.Stats.HitRating},
	{"рейтинга меткости", StatLogic.Stats.HitRating},
	{"рейтингу меткости", StatLogic.Stats.HitRating},

	{"рейтинг устойчивости", StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating
	{"рейтингу устойчивости", StatLogic.Stats.ResilienceRating},
	{"рейтинга устойчивости", StatLogic.Stats.ResilienceRating},

	{"рейтинг скорости %(заклинания%)", StatLogic.Stats.SpellHasteRating},
	{"рейтингу скорости %(заклинания%)", StatLogic.Stats.SpellHasteRating},
	{"рейтинга скорости %(заклинания%)", StatLogic.Stats.SpellHasteRating},
	{"скорости наложения заклинаний", StatLogic.Stats.SpellHasteRating},
	{"скорость наложения заклинаний", StatLogic.Stats.SpellHasteRating},
	{"рейтинг скорости дальнего боя", StatLogic.Stats.RangedHasteRating},
	{"рейтингу скорости дальнего боя", StatLogic.Stats.RangedHasteRating},
	{"рейтинга скорости дальнего боя", StatLogic.Stats.RangedHasteRating},
	{"рейтинг скорости", StatLogic.Stats.HasteRating},
	{"рейтингу скорости", StatLogic.Stats.HasteRating},
	{"рейтинга скорости", StatLogic.Stats.HasteRating},

	{"мастерства", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"искусност", StatLogic.Stats.MasteryRating},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% к крит. удару"
L["$value% Spell Crit"] = "$value% к крит. удару"
L["$value% Dodge"] = "$value% к уклонению"
L["$value% Parry"] = "$value% к парированию"
L["$value HP"] = "$value к здоровью"
L["$value MP"] = "$value к мане"
L["$value AP"] = "$value к силе атаки"
L["$value RAP"] = "к силе атаки дальнего боя"
L["$value Spell Dmg"] = "$value к силе заклинаний"
L["$value Heal"] = "$value к силе заклинаний"
L["$value Armor"] = "$value к броне"
L["$value Block"] = "$value к показателю блокирования" -- Block value
L["$value MP5"] = "$value маны раз в 5 сек."
L["$value MP5(OC)"] = "$value маны раз в 5 сек. (вне боя)"
L["$value MP5(NC)"] = "$value маны раз в 5 сек. (вне каста)"
L["$value HP5"] = "$value здоровья раз в 5 сек."
L["$value HP5(NC)"] = "$value ХП5 (вне боя)"
L["$value to be Dodged/Parried"] = "$value уклонения/парирования" -- Target's dodges/parrys against your attacks
L["$value to be Crit"] = "$value% к получению крит. удара" -- Your chance to get critical hit from target
L["$value Crit Dmg Taken"] = "$value к получению крит. урона"
L["$value DOT Dmg Taken"] = "$value к получению урона от ДоТ"
L["$value PvP Damage Taken"] = "$value PvP Damage Taken"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value для заклинаний"
L["$value Spell Hit"] = "$value метк. закл."

L[StatLogic.Stats.ManaRegen] = "Восполнение маны"
L[StatLogic.Stats.ManaRegenNotCasting] = "Восполнения маны (пока не применяете заклинания)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = "Восполнения маны (вне боя)"
if addon.tocversion > 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] =  L[StatLogic.Stats.ManaRegenOutOfCombat]
end
L[StatLogic.Stats.HealthRegen] = "Восстановление здоровья"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Восполнение здаровья (вне боя)"
L["Show %s"] = SHOW.." %s"

L[StatLogic.Stats.IgnoreArmor] = "Игнорирование брони"

L[StatLogic.Stats.Strength] = "Сила"
L[StatLogic.Stats.Agility] = "Ловкость"
L[StatLogic.Stats.Stamina] = "Выносливость"
L[StatLogic.Stats.Intellect] = "Интеллект"
L[StatLogic.Stats.Spirit] = "Дух"
L[StatLogic.Stats.Armor] = "Броня"

L[StatLogic.Stats.FireResistance] = "Сопротивление огню"
L[StatLogic.Stats.NatureResistance] = "Сопротивление силам природы"
L[StatLogic.Stats.FrostResistance] = "Сопротивление магии льда"
L[StatLogic.Stats.ShadowResistance] = "Сопротивление темной магии"
L[StatLogic.Stats.ArcaneResistance] = "Сопротивление тайной магии"

L[StatLogic.Stats.BlockValue] = "Показатель блокирования"

L[StatLogic.Stats.AttackPower] = "Сила атаки"
L[StatLogic.Stats.RangedAttackPower] = "Сила атаки дальнего боя"
L[StatLogic.Stats.FeralAttackPower] = "Сила атаки в облике зверя"

L[StatLogic.Stats.HealingPower] = "Исцеление"

L[StatLogic.Stats.SpellPower] = "Сила заклинаний"
L[StatLogic.Stats.SpellDamage] = "Сила заклинаний" -- Changed from Damage to Power
L[StatLogic.Stats.HolyDamage] = "Урон от светлой магии"
L[StatLogic.Stats.FireDamage] = "Урон от огня"
L[StatLogic.Stats.NatureDamage] = "Урон от сил природы"
L[StatLogic.Stats.FrostDamage] = "Урон от магии льда"
L[StatLogic.Stats.ShadowDamage] = "Урон от темной магии"
L[StatLogic.Stats.ArcaneDamage] = "Урон от тайной магии"

L[StatLogic.Stats.SpellPenetration] = "Проникающая способность"

L[StatLogic.Stats.Health] = "Здоровье"
L[StatLogic.Stats.Mana] = "Мана"

L[StatLogic.Stats.AverageWeaponDamage] = "Average Damage"
L[StatLogic.Stats.WeaponDPS] = "Урон в секунду"

L[StatLogic.Stats.DefenseRating] = "Рейтинг защиты"
L[StatLogic.Stats.DodgeRating] = "Рейтинг уклонения"
L[StatLogic.Stats.ParryRating] = "Рейтинг парирования"
L[StatLogic.Stats.BlockRating] = "Рейтинг блокирования"
L[StatLogic.Stats.MeleeHitRating] = "Рейтинг меткости"
L[StatLogic.Stats.RangedHitRating] = "Рейтинга меткости дальнего боя"
L[StatLogic.Stats.SpellHitRating] = "Рейтинг меткости заклинаний"
L[StatLogic.Stats.MeleeCritRating] = "Рейтинг крит. удара"
L[StatLogic.Stats.RangedCritRating] = "Рейтинг крит. удара дальнего боя"
L[StatLogic.Stats.SpellCritRating] = "Рейтинг крит. удара заклинаниями"
L[StatLogic.Stats.ResilienceRating] = "устойчивости"
L[StatLogic.Stats.MeleeHasteRating] = "Рейтинг скорости"
L[StatLogic.Stats.RangedHasteRating] = "Рейтинг скорости дальнего боя"
L[StatLogic.Stats.SpellHasteRating] = "Рейтинг скорости заклинаний"
L[StatLogic.Stats.ExpertiseRating] = "Рейтинг мастерства"
L[StatLogic.Stats.ArmorPenetrationRating] = "Рейтинг пробивания брони"
L[StatLogic.Stats.MasteryRating] = "Рейтинг искусности"
L[StatLogic.Stats.CritDamageReduction] = "Понижение входящего урона от крит. ударов"
L[StatLogic.Stats.Defense] = "Защита"
L[StatLogic.Stats.Dodge] = "Вероятность уклонения"
L[StatLogic.Stats.Parry] = "Вероятность парирования"
L[StatLogic.Stats.BlockChance] = "Вероятность блокирования"
L[StatLogic.Stats.Avoidance] = "уклонения от удара"
L[StatLogic.Stats.MeleeHit] = "Вероятность попадания"
L[StatLogic.Stats.RangedHit] = "Вероятность поподания в дальнем бою"
L[StatLogic.Stats.SpellHit] = "Вероятность поподания заклинаниями"
L[StatLogic.Stats.Miss] = "Hit Avoidance"
L[StatLogic.Stats.MeleeCrit] = "Вероятность крит. удара"
L[StatLogic.Stats.RangedCrit] = "Вероятность крит. удара в дальнем бою"
L[StatLogic.Stats.SpellCrit] = "Вероятность крит. удара заклинаниями"
L[StatLogic.Stats.CritAvoidance] = "Crit Avoidance"
L[StatLogic.Stats.MeleeHaste] = "Скорость"
L[StatLogic.Stats.RangedHaste] = "Скорость дальнего боя"
L[StatLogic.Stats.SpellHaste] = "Скорость заклинаний"
L[StatLogic.Stats.Expertise] = "Мастерство"
L[StatLogic.Stats.ArmorPenetration] = "Пробивание брони"
L[StatLogic.Stats.Mastery] = "Искусность"
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format("Искусность")
L[StatLogic.Stats.DodgeReduction] = "игнорирования уклонения"
L[StatLogic.Stats.ParryReduction] = "игнорирования парирования"
L[StatLogic.Stats.WeaponSkill] = "Оружейный навык"