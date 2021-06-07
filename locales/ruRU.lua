--[[
Name: RatingBuster ruRU locale
Revision: $Revision: 343 $
Translated by:
- Orsana \ StingerSoft \ Swix
]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "ruRU")
if not L then return end
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend NotePad++ or Ultraedit
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
-- /rb hidebzcomp
L["Hide Blizzard Item Comparisons"] = "Скрыть сравнение от Blizzardа"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Отключить сравнение предметов Blizzard, если используется метод сравнения RatingBusterа"
-- /rb statmod
L["Enable Stat Mods"] = "Включить модуль статистики"
L["Enable support for Stat Mods"] = "Включает поддержку модуля статистики"
-- /rb subtract_equip
--L["Enable Subtract Equipped Stats"] = ""
--L["Enable for more accurate calculation of Mana Regen from Intellect and Spirit, and diminishing stats like Dodge, Parry, Resilience"] = ""
-- /rb usereqlv
L["Use Required Level"] = "Использовать необходимый уровень"
L["Calculate using the required level if you are below the required level"] = "Рассчитывать статы исходя из минимально необходимого для надевания предмета уровня, если вы ниже этого уровня"
-- /rb level
L["Set Level"] = "Задать уровень"
L["Set the level used in calculations (0 = your level)"] = "Задать уровень используемый в расчетах (0 - ваш уровень)"
-- /rb ilvlid
--L["Item Level and ID"] = ""
--L["Settings for Item Level and Item ID"] = ""
-- /rb ilvlid coloritemlevel
--L["Colorize Item Level"] = ""
--L["Customize the color of the Item Level text"] = ""
-- /rb ilvlid itemlevelall
--L["Show Item Level on all items"] = ""
--L["Display the Item Level on all items instead of just on equippable items"] = ""
-- /rb ilvlid itemid
--L["Show Item ID"] = ""
--L["Display the Item ID on all items"] = ""
---------------------------------------------------------------------------
-- /rb rating
L["Rating"] = "Рейтинги"
L["Options for Rating display"] = "Настройки отображения рейтингов"
-- /rb rating show
L["Show Rating Conversions"] = "Конвертация рейтингов"
L["Select when to show rating conversions in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать конвертацию рейтингов в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
-- /rb rating spell
L["Show Spell Hit/Haste"] = "Меткость/скорость заклинаний"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Показывать меткость/скорость заклинаний из рейтинга меткости/скорость"
-- /rb rating physical
L["Show Physical Hit/Haste"] = "Меткость/скорость физических атак"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Показывать меткость/скорость физических атак из рейтинга меткости"
-- /rb rating detail
L["Show Detailed Conversions Text"] = "Детальная конвертация рейтингов"
L["Show detailed text for Resilience and Expertise conversions"] = "Показывать детальную конвертацию рейтингов мастерства и устойчивости"
-- /rb rating exp
L["Expertise Breakdown"] = "Разбивать уровень мастерства"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Разбивать уровень мастерства на игнорирование уклонения и парирования"
---------------------------------------------------------------------------
-- /rb rating color
L["Change Text Color"] = "Изменить цвет текста"
L["Changes the color of added text"] = "Изменить цвет добавляемого текста"
-- /rb rating color pick
L["Pick Color"] = "Выбрать цвет"
L["Pick a color"] = "Выбрать цвет"
-- /rb rating color enable
L["Enable Color"] = "Включить цвет текста"
L["Enable colored text"] = "Включить цвет текста"
---------------------------------------------------------------------------
-- /rb stat
L["Stat Breakdown"] = "Настройки статов"
L["Changes the display of base stats"] = "Показывать изменения базовых статов"
-- /rb stat show
L["Show Base Stat Conversions"] = "Показывать изменение базовых статов"
L["Select when to show base stat conversions in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать изменение базовых статов в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
---------------------------------------------------------------------------
-- /rb stat str
L["Strength"] = "Сила"
L["Changes the display of Strength"] = "Показывать изменение силы"
-- /rb stat str ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Strength"] = "Показывать изменение силы атаки от силы"
-- /rb stat str block
L["Show Block Value"] = "Блокирование"
L["Show Block Value from Strength"] = "Показывать изменение блокирования от силы"
-- /rb stat str dmg
L["Show Spell Damage"] = "Урон от заклинаний"
L["Show Spell Damage from Strength"] = "Показывать изменение урона заклинаниями от силы"
-- /rb stat str heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Strength"] = "Показывать изменение исцеления от силы"
-- /rb stat str parryrating
L["Show Parry Rating"] = "Рейтинг парирования"
L["Show Parry Rating from Strength"] = "Показывать изменение рейтинга парирования от силы"
-- /rb stat str parry
L["Show Parry"] = "Парирование"
L["Show Parry from Strength"] = "Показывать изменения парирования от силы"
---------------------------------------------------------------------------
-- /rb stat agi
L["Agility"] = "Ловкость"
L["Changes the display of Agility"] = "Показывать изменения ловкости"
-- /rb stat agi crit
L["Show Crit"] = "Крит. удар"
L["Show Crit chance from Agility"] = "Показывать изменение крит. удара от ловкости"
-- /rb stat agi dodge
L["Show Dodge"] = "Уклонение"
L["Show Dodge chance from Agility"] = "Показывать изменение уклонения от ловкости"
-- /rb stat agi ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Agility"] = "Показывать изменение силы атаки от ловкости"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Сила атаки дальнего боя"
L["Show Ranged Attack Power from Agility"] = "Показывать изменение силы атаки дальнего боя от ловкости"
-- /rb stat agi dmg
L["Show Spell Damage"] = "Магический урон"
L["Show Spell Damage from Agility"] = "Показывать изменение магического урона от ловкости"
-- /rb stat agi heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Agility"] = "Показывать изменение исцеления от ловкости"
---------------------------------------------------------------------------
-- /rb stat sta
L["Stamina"] = "Выносливость"
L["Changes the display of Stamina"] = "Показывать изменение выносливости"
-- /rb stat sta hp
L["Show Health"] = "Здоровье"
L["Show Health from Stamina"] = "Показывать изменение здоровья от выносливости"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Урон от заклинаний"
L["Show Spell Damage from Stamina"] = "Показывать изменение урона заклинаниями от выносливости"
-- /rb stat sta heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Stamina"] = "Показывать изменение исцеления от выносливости"
-- /rb stat sta ap
L["Show Attack Power"] = "Силы атаки"
L["Show Attack Power from Stamina"] = "Показывать изменение силы атаки от выносливости"
---------------------------------------------------------------------------
-- /rb stat int
L["Intellect"] = "Интеллект"
L["Changes the display of Intellect"] = "Показывать изменение интеллекта"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Крит. удар от заклинаний"
L["Show Spell Crit chance from Intellect"] = "Показывать изменение крит. удара заклинаний от интеллекта"
-- /rb stat int mp
L["Show Mana"] = "Мана"
L["Show Mana from Intellect"] = "Показывать изменение маны от интеллекта"
-- /rb stat int dmg
L["Show Spell Damage"] = "Урон от заклинаний"
L["Show Spell Damage from Intellect"] = "Показывать изменение урона заклинаний от интеллекта"
-- /rb stat int heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Intellect"] = "Показывать изменение исцеления от интеллекта"
-- /rb stat int mp5
L["Show Combat Mana Regen"] = "Восполнение маны в бою"
L["Show Mana Regen while in combat from Intellect"] = "Показывать изменение восполнения маны от интеллекта (в бою)"
-- /rb stat int mp5oc
L["Show Normal Mana Regen"] = "Восполнения маны вне боя"
L["Show Mana Regen while not in combat from Intellect"] = "Показывать изменение восполнения маны от интеллекта (вне боя)"
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Сила атаки дальнего боя"
L["Show Ranged Attack Power from Intellect"] = "Показывать изменение силы атаки дальнего боя от интеллекта"
-- /rb stat int ap
L["Show Attack Power"] = "Силы атаки"
L["Show Attack Power from Intellect"] = "Показывать изменение силы атаки от интеллекта"
---------------------------------------------------------------------------
-- /rb stat spi
L["Spirit"] = "Дух"
L["Changes the display of Spirit"] = "Показывать изменение духа"
-- /rb stat spi mp5
L["Show Combat Mana Regen"] = "Восполнение маны в бою"
L["Show Mana Regen while in combat from Spirit"] = "Показывать изменение восполнения маны от духа (в бою)"
-- /rb stat spi mp5oc
L["Show Normal Mana Regen"] = "Восполнения маны вне боя"
L["Show Mana Regen while not in combat from Spirit"] = "Показывать изменение восполнения маны от духа (вне боя)"
-- /rb stat spi hp5
L["Show Normal Health Regen"] = "Восполнение здаровья вне боя"
L["Show Health Regen while not in combat from Spirit"] = "Показывать изменение восполнения здоровья от духа (вне боя)"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Урон от заклинаний"
L["Show Spell Damage from Spirit"] = "Показывать изменение урона заклинаний от духа"
-- /rb stat spi heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Spirit"] = "Показывать изменение исцеления от духа"
-- /rb stat spi spellcrit
L["Show Spell Crit"] = "Крит. удар заклинаний"
L["Show Spell Crit chance from Spirit"] = "Показывать изменение вероятности критического удара заклинаниями от духа"
-- /rb stat spi spellhitrating
L["Show Spell Hit Rating"] = "Рейтинг меткости заклинания"
L["Show Spell Hit Rating from Spirit"] = "Показывать изменение рейтинга меткости заклинания от духа"
-- /rb stat spi spellhit
L["Show Spell Hit"] = "Меткость заклинания"
L["Show Spell Hit from Spirit"] = "Показывать изменение меткости заклинания от духа"
---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "Броня"
L["Changes the display of Armor"] = "Показывать изменение брони"
-- /rb stat armor ap
L["Show Attack Power"] = "Силы атаки"
L["Show Attack Power from Armor"] = "Показывать изменение силы атаки от брони"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Настройки итогов"
L["Options for stat summary"] = "Итоги по статам"
-- /rb sum show
L["Show Stat Summary"] = "Показывать суммарные изменения"
L["Select when to show stat summary in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать суммарные изменения в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
-- /rb sum ignore
L["Ignore Settings"] = "Настройки игнорирования"
L["Ignore stuff when calculating the stat summary"] = "	Настройка игнорирования при расчете итога"
-- /rb sum ignore unused
L["Ignore Undesirable Items"] = "Игнорирование неподходящих предметов"
L["Hide stat summary for undesirable items"] = "Скрыть итоги по статам для неподходящих предметов"
-- /rb sum ignore quality
L["Minimum Item Quality"] = "Мин. качество предмета"
L["Show stat summary only for selected quality items and up"] = "Показывать итоги по статам только для выбранного качества предметов и выше"
-- /rb sum ignore armor
L["Armor Types"] = "Тип брони"
L["Select armor types you want to ignore"] = "Выберите тип брони, который будет игнорироваться"
-- /rb sum ignore armor cloth
L["Ignore Cloth"] = "Игнорировать ткань"
L["Hide stat summary for all cloth armor"] = "Скрыть итоги по статам для всех доспехов из ткани"
-- /rb sum ignore armor leather
L["Ignore Leather"] = "Игнорированть кожу"
L["Hide stat summary for all leather armor"] = "Скрыть итоги по статам для всех доспехов из кожы"
-- /rb sum ignore armor mail
L["Ignore Mail"] = "Игнорированть кальчугу"
L["Hide stat summary for all mail armor"] = "Скрыть итоги по статам для всех доспехов из кальчуги"
-- /rb sum ignore armor plate
L["Ignore Plate"] = "Игнорированть латы"
L["Hide stat summary for all plate armor"] = "Скрыть итоги по статам для всех доспехов из лат"
-- /rb sum ignore equipped
L["Ignore Equipped Items"] = "Не показывать для надетых вещей"
L["Hide stat summary for equipped items"] = "Не показывать для надетых вещей"
-- /rb sum ignore enchant
L["Ignore Enchants"] = "Игнорировать чары"
L["Ignore enchants on items when calculating the stat summary"] = "Игнорировать чары при расчете итога"
-- /rb sum ignore gem
L["Ignore Gems"] = "Игнорировать самоцветы"
L["Ignore gems on items when calculating the stat summary"] = "Игнорировать самоцветы при расчете итога"
-- /rb sum ignore prismaticSocket
L["Ignore Prismatic Sockets"] = "Игнорировать радужные гнёзда"
L["Ignore gems in prismatic sockets when calculating the stat summary"] = "Игнорировать гнезда для радужного самоцвета при расчете итога"
-- /rb sum diffstyle
L["Display Style For Diff Value"] = "Стиль отображения отличия значений"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Отображения различных значений в главной подсказке или только в сравнительных подсказках"
-- /rb sum space
L["Add Empty Line"] = "Добавить пустую линию"
L["Add a empty line before or after stat summary"] = "Добавить пустую линию перед или после итогов"
-- /rb sum space before
L["Add Before Summary"] = "Добавить линию до итога"
L["Add a empty line before stat summary"] = "Добавить линию до итога"
-- /rb sum space after
L["Add After Summary"] = "Добавить линию после итога"
L["Add a empty line after stat summary"] = "Добавить линию после итога"
-- /rb sum icon
L["Show Icon"] = "Добавить иконку"
L["Show the sigma icon before summary listing"] = "Добавит иконку до списка итога"
-- /rb sum title
L["Show Title Text"] = "Показывать заголовок"
L["Show the title text before summary listing"] = "Показывать заголовок до списка итога"
-- /rb sum showzerostat
L["Show Zero Value Stats"] = "Показывать нулевые статы"
L["Show zero value stats in summary for consistancy"] = "Показывать нулевые статы"
-- /rb sum calcsum
L["Calculate Stat Sum"] = "Рассчитать сумму стат"
L["Calculate the total stats for the item"] = "Рассчитать все статы для предмета"
-- /rb sum calcdiff
L["Calculate Stat Diff"] = "Рассчитывать разницу в статах"
L["Calculate the stat difference for the item and equipped items"] = "Рассчитывать разницу в статах с надетой вещью"
-- /rb sum sort
L["Sort StatSummary Alphabetically"] = "Сортировать статы в алфавитном порядке"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Если включено - то по алфавиту, если выключено, то по смыслу (базовые, физические, заклинания, танковые)"
-- /rb sum avoidhasblock
L["Include Block Chance In Avoidance Summary"] = "Включать вероятность блока в итоге избежаний"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Включать вероятность блока в итоге избежаний, отключение только для уклона, парирования, промоха"
---------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "Статы - базовые"
L["Choose basic stats for summary"] = "Выбор базовых статов для подсчета"
-- /rb sum basic hp
L["Sum Health"] = "Сумма здоровья"
L["Health <- Health, Stamina"] = "Здоровье <- Здоровье, Выносливость"
-- /rb sum basic mp
L["Sum Mana"] = "Сумма маны"
L["Mana <- Mana, Intellect"] = "Мана <- Мана, Интеллект"
-- /rb sum basic mp5
L["Sum Combat Mana Regen"] = "Сумма восст. маны в бою"
L["Combat Mana Regen <- Mana Regen, Spirit"] = "Восстановление маны в бою <- Восстановления маны, Дух"
-- /rb sum basic mp5oc
L["Sum Normal Mana Regen"] = "Сумма восст. маны вне боя"
L["Normal Mana Regen <- Spirit"] = "Сумма восстановления маны вне боя <- Дух"
-- /rb sum basic hp5
L["Sum Combat Health Regen"] = "Сумма восст. здоровья в бою"
L["Combat Health Regen <- Health Regen"] = "Восстановление здоровья в бою <- Восстановление здоровья"
-- /rb sum basic hp5oc
L["Sum Normal Health Regen"] = "Сумма восст. здоровья вне боя"
L["Normal Health Regen <- Spirit"] = "Сумма восстановления здоровья вне боя <- Дух"
-- /rb sum basic str
L["Sum Strength"] = "Сумма силы"
L["Strength Summary"] = "Суммировать силу"
-- /rb sum basic agi
L["Sum Agility"] = "Сумма ловкости"
L["Agility Summary"] = "Суммировать ловкость"
-- /rb sum basic sta
L["Sum Stamina"] = "Сумма выносливости"
L["Stamina Summary"] = "Суммировать выносливость"
-- /rb sum basic int
L["Sum Intellect"] = "Сумма интеллекта"
L["Intellect Summary"] = "Суммировать интеллект"
-- /rb sum basic spi
L["Sum Spirit"] = "Сумма духа"
L["Spirit Summary"] = "Суммировать дух"
-- /rb sum basic mastery
L["Sum Mastery"] = "Сумма искусности"
L["Mastery Summary"] = "Суммировать искусность"
-- /rb sum basic masteryrating
L["Sum Mastery Rating"] = "Сумма рейтинга искусности"
L["Mastery Rating Summary"] = "Суммировать рейтинг искусности"
---------------------------------------------------------------------------
-- /rb sum physical
L["Stat - Physical"] = "Статы - физические"
L["Choose physical damage stats for summary"] = "Выбор статов физического урона для подсчета"
-- /rb sum physical ap
L["Sum Attack Power"] = "Сумма силы атаки"
L["Attack Power <- Attack Power, Strength, Agility"] = "Сила атаки <- Сила атаки, Сила, Ловкость"
-- /rb sum physical rap
L["Sum Ranged Attack Power"] = "Сумма силы атаки дальнего боя"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Сила атаки дальнего боя <- Сила атаки дальнего боя, Интеллект, Сила атаки, Сила, Ловкость"
-- /rb sum physical fap
L["Sum Feral Attack Power"] = "Сумма силы атаки в облике зверя"
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "Силы атаки в облике зверя <- Сила атаки в облике зверя, Сила атаки, Сила, Ловкость"
-- /rb sum physical hit
L["Sum Hit Chance"] = "Сумма вероятности поподания"
L["Hit Chance <- Hit Rating"] = "Вероятности поподания <- Рейтинг меткости"
-- /rb sum physical hitrating
L["Sum Hit Rating"] = "Сумма рейтинга меткости"
L["Hit Rating Summary"] = "Суммировать рейтинг меткости"
-- /rb sum physical crit
L["Sum Crit Chance"] = "Сумма вероятности крит удара"
L["Crit Chance <- Crit Rating, Agility"] = "Вероятности крит удара <- Рейтинг крит удара, Ловкость"
-- /rb sum physical critrating
L["Sum Crit Rating"] = "Сумма рейтинга крита"
L["Crit Rating Summary"] = "Суммировать рейтинг крит удара"
-- /rb sum physical haste
L["Sum Haste"] = "Сумма скорости"
L["Haste <- Haste Rating"] = "Скорость <- Рейтинг скорости"
-- /rb sum physical hasterating
L["Sum Haste Rating"] = "Сумма рейтинга скорости"
L["Haste Rating Summary"] = "Суммировать рейтинг скорости"
-- /rb sum physical rangedhit
L["Sum Ranged Hit Chance"] = "Сумма вероятности поподания в дальнем бою"
L["Ranged Hit Chance <- Hit Rating, Ranged Hit Rating"] = "Вероятность поподания в дальнем бою <- Рейтинг меткости, Рейтинг меткости дальнего боя"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "Сумма рейтинга меткости дальнего боя"
L["Ranged Hit Rating Summary"] = "Суммировать рейтинг меткости дальнего боя"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "Сумма вероятности крита в дальнем бою"
L["Ranged Crit Chance <- Crit Rating, Agility, Ranged Crit Rating"] = "Вероятность крита в дальнем бою <- Рейтинг крита, Ловкость, Рейтинга крит удара дальнего боя"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "Сумма рейтинга крит удара дальнего боя"
L["Ranged Crit Rating Summary"] = "Суммировать рейтинг критического удара в дальнем бою"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "Сумма скорости дальнего боя"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Скорости дальнего боя <- Рейтинг скорости, Рейтинг скорости дальнего боя"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "Сумма рейтинга скорости дальнего боя"
L["Ranged Haste Rating Summary"] = "Суммировать рейтинг скорости дальнего боя"
-- /rb sum physical maxdamage
L["Sum Weapon Max Damage"] = "Сумма макс урона оружия"
L["Weapon Max Damage Summary"] = "Суммировать макс урон уружия"
-- /rb sum physical weapondps
--L["Sum Weapon DPS"] = "Сумма УВС оружия"
--L["Weapon DPS Summary"] = "Суммировать урон в секунду от оружия"
-- /rb sum physical wpn
L["Sum Weapon Skill"] = "Сумма оружейного навык"
L["Weapon Skill <- Weapon Skill Rating"] = "Оружейный навык <- Рейтинг владения оружием"
-- /rb sum physical exp
L["Sum Expertise"] = "Сумма мастерства"
L["Expertise <- Expertise Rating"] = "Мастерство <- рейтинг мастерства"
-- /rb sum physical exprating
L["Sum Expertise Rating"] = "Сумма рейтинга мастерства"
L["Expertise Rating Summary"] = "Суммировать рейтинг мастерства"
---------------------------------------------------------------------------
-- /rb sum spell
L["Stat - Spell"] = "Статы - заклинания"
L["Choose spell damage and healing stats for summary"] = "Выбор статов исцеления и урона заклинаниями для посчета"
-- /rb sum spell power
L["Sum Spell Power"] = "Сумма силы заклинаний"
L["Spell Power <- Spell Power, Intellect, Agility, Strength"] = "Сила заклинаний <- Силы заклинаний, Интеллект, Ловкость, Сила"
-- /rb sum spell dmg
L["Sum Spell Damage"] = "Сумма урона заклинаниями"
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Урон заклинаниями <- Урон заклинаниями, Интеллект, Дух, Выносливость"
-- /rb sum spell dmgholy
L["Sum Holy Spell Damage"] = "Сумма урона светлой магией"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Урон светлой магии <- Урон светлой магией, Урон заклинаниями, Интеллект, Дух"
-- /rb sum spell dmgarcane
L["Sum Arcane Spell Damage"] = "Сумма урона тайной магией"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Урон тайной магией <- Урон тайной магией, Урон заклинаниями, Интеллект"
-- /rb sum spell dmgfire
L["Sum Fire Spell Damage"] = "Сумма урона магией огня"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Урон магией огня <- Урон магией огня, Урон заклинаниями, Интеллект, Выносливость"
-- /rb sum spell dmgnature
L["Sum Nature Spell Damage"] = "Сумма урона силами природы"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Урон силами природы <- Урон силами природы, Урон заклинаниями, Интеллект"
-- /rb sum spell dmgfrost
L["Sum Frost Spell Damage"] = "Сумма урона магией льда"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Урон магией льда <- Урон магией льда, Урон заклинаниями, Интеллект"
-- /rb sum spell dmgshadow
L["Sum Shadow Spell Damage"] = "Сумма урона темной магией"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Урон темной магией <- Урон темной магией, Урон заклинаниями, Интеллект, Дух, Выносливость"
-- /rb sum spell heal
L["Sum Healing"] = "Сумма исцеления"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Исцеление <- Исцеление, Интеллект, Дух, Ловкость, Сила"
-- /rb sum spell crit
L["Sum Spell Crit Chance"] = "Сумма вероятности крита заклинания"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Вероятность крита заклинания <- Рейтинг крита удара заклинаниями, Интеллект"
-- /rb sum spell hit
L["Sum Spell Hit Chance"] = "Сумма вероятности поподания заклинаний"
L["Spell Hit Chance <- Spell Hit Rating"] = "Вероятность поподания заклинаний <- Рйтинг меткости заклинаний"
-- /rb sum spell haste
L["Sum Spell Haste"] = "Сумма скорости заклинаний"
L["Spell Haste <- Spell Haste Rating"] = "Скорость заклинаний <- Рейтинг скорости заклинаний"
-- /rb sum spell pen
L["Sum Penetration"] = "Сумма проникающей способности"
L["Spell Penetration Summary"] = "Суммировать проникающую способность заклинаний"
-- /rb sum spell hitrating
L["Sum Spell Hit Rating"] = "Сумма рейтинга меткости заклинаний"
L["Spell Hit Rating Summary"] = "Суммировать рейтинг меткости заклинаний"
-- /rb sum spell critrating
L["Sum Spell Crit Rating"] = "Сумма рейтинга крит удара заклинаниями"
L["Spell Crit Rating Summary"] = "Суммировать рейтинг крит удара заклинаниями"
-- /rb sum spell hasterating
L["Sum Spell Haste Rating"] = "Сумма рейтинга скорости заклинаний"
L["Spell Haste Rating Summary"] = "Суммировать рейтинг скорости заклинаний"
---------------------------------------------------------------------------
-- /rb sum tank
L["Stat - Tank"] = "Статы - танкования"
L["Choose tank stats for summary"] = "Выбор статов танкования для подсчета"
-- /rb sum tank armor
L["Sum Armor"] = "Сумма брони"
L["Armor <- Armor from items and bonuses"] = "Броня <- Броня с одежды и бонусов"
-- /rb sum tank dodge
L["Sum Dodge Chance"] = "Сумма вероятности уклонения"
L["Dodge Chance <- Dodge Rating, Agility"] = "Вероятность уклонения <- рейтинг уклонения, ловкость"
-- /rb sum tank parry
L["Sum Parry Chance"] = "Сумма вероятности парирования"
L["Parry Chance <- Parry Rating"] = "Вероятность парирования <- рейтинг парирования"
-- /rb sum tank block
L["Sum Block Chance"] = "Сумма вероятности блокирования"
L["Block Chance <- Block Rating"] = "Вероятность блокирования <- рейтинг блокирования"
-- /rb sum tank neglectdodge
L["Sum Dodge Neglect"] = "Сумма игнорирования уклонения"
L["Dodge Neglect <- Expertise"] = "Игнорирование уклонения <- Мастерство"
-- /rb sum tank neglectparry
L["Sum Parry Neglect"] = "Сумма игнорирования парирования"
L["Parry Neglect <- Expertise"] = "Игнорирование парирования <- Мастерство"
-- /rb sum tank resarcane
L["Sum Arcane Resistance"] = "Сумма защиты от тайной магии"
L["Arcane Resistance Summary"] = "Суммировать сопротивление тайной магии"
-- /rb sum tank resfire
L["Sum Fire Resistance"] = "Сумма защиты от огня"
L["Fire Resistance Summary"] = "Суммировать сопротивление огню"
-- /rb sum tank resnature
L["Sum Nature Resistance"] = "Сумма защиты от магии природы"
L["Nature Resistance Summary"] = "Суммировать сопротивление силам природы"
-- /rb sum tank resfrost
L["Sum Frost Resistance"] = "Сумма защиты от магии льда"
L["Frost Resistance Summary"] = "Суммировать сопротивление магии льда"
-- /rb sum tank resshadow
L["Sum Shadow Resistance"] = "Сумма защиты от темной магии"
L["Shadow Resistance Summary"] = "Суммировать сопротивление темной магии"
-- /rb sum tank dodgerating
L["Sum Dodge Rating"] = "Сумма рейтинга уклонения"
L["Dodge Rating Summary"] = "Суммировать рейтинг уклонения"
-- /rb sum tank parryrating
L["Sum Parry Rating"] = "Сумма рейтинга парирования"
L["Parry Rating Summary"] = "Суммировать рейтинг парирования"
-- /rb sum tank blockrating
L["Sum Block Rating"] = "Сумма рейтинга блока"
L["Block Rating Summary"] = "Суммировать рейтинг блока"
-- /rb sum tank res
L["Sum Resilience"] = "Сумма устойчивости"
L["Resilience Summary"] = "Суммировать устойчивость"
-- /rb sum tank tp
L["Sum TankPoints"] = "Самма TankPoints"
L["TankPoints <- Health, Total Reduction"] ="TankPoints <- Здоровье, Общее Cнижение"
-- /rb sum tank tr
L["Sum Total Reduction"] = "Самма общего снижения"
L["Total Reduction <- Armor, Dodge, Parry, Block, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Общее снижение <- Броня, Уклонение, Парирование, Блок, ПромахСущества, КритСущества, MobCrush, DamageTakenMods"
-- /rb sum tank avoid
L["Sum Avoidance"] = "Сумма уклонения от удара"
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
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "ID предмета или ссылка на самоцвет, кторым вы хотите автозаполнять слоты"
L["<ItemID|Link>"] = "<ItemID|Link>"
L["|cffffff7f%s|r is now set to |cffffff7f[%s]|r"] = "|cffffff7f%s|r в настоящее время установлена на |cffffff7f[%s]|r"
L["Invalid input: %s. ItemID or ItemLink required."] = "Ошибочный ввод: %s. Требуется ID предмета либо ссылка."
L["Queried server for Gem: %s. Try again in 5 secs."] = "Запрос у сервера самоцвета: %s. Повторная попытка через 5 сек."
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META
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
	{pattern = " на (%d+)", addInfo = "AfterNumber", space = " ", },
	{pattern = "([%+%-]%d+)", addInfo = "AfterNumber", space = " ", },
	{pattern = " увеличена на (%d+)", addInfo = "AfterNumber", space = " ", },
	{pattern = "(%d+) к ", addInfo = "AfterNumber", space = " ", }, -- тест
	{pattern = "увеличение (%d+)", addInfo = "AfterNumber", space = " ", }, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "дополнительно (%d+)", addInfo = "AfterNumber", space = " ", }, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "на (%d+)([^%d%%|]+)", addInfo = "AfterNumber", space = " ", }, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " и ", ",", "%. ", " для ", "&", ":",
	-- Fix for [Mirror of Truth]
	-- Equip: Chance on melee and ranged critical strike to increase your attack power by 1000 for 10 secs.
	-- 1000 was falsely detected detected as ranged critical strike
	"повысить вашу",
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
COMBAT_RATING_RESILIENCE_CRIT_TAKEN = 15;
COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
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
-- для русской локализации надо указывать все используемые склонения рейтингов (рейтинг, рейтинга,
	-- рейтингу) т.к. иначе распознавание не работает.
--

L["statList"] = {
	{pattern = string.lower("Силе атаки"), id = SPELL_STAT1115_NAME}, --чтобы Сила атаки и сила заклинаний не распознавалась как Сила
	{pattern = string.lower("Сила атаки"), id = SPELL_STAT1115_NAME}, -- строки SPELL_STAT1115_NAME должны быть впереди
	{pattern = string.lower("Силу атаки"), id = SPELL_STAT1115_NAME},
	{pattern = string.lower("Сила заклинаний"), id = SPELL_STAT1115_NAME},
	{pattern = string.lower("Силу заклинаний"), id = SPELL_STAT1115_NAME},
	{pattern = string.lower("Силе заклинаний"), id = SPELL_STAT1115_NAME}, -- конец левых строчек

	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower("Силе"), id = SPELL_STAT1_NAME},
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower("Ловкости"), id = SPELL_STAT2_NAME},
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower("Выносливости"), id = SPELL_STAT3_NAME},
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower("Интеллекту"), id = SPELL_STAT4_NAME},
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = string.lower("Духу"), id = SPELL_STAT5_NAME},

	{pattern = "рейтинг защиты", id = CR_DEFENSE_SKILL},
	{pattern = "рейтингу защиты", id = CR_DEFENSE_SKILL},
	{pattern = "рейтинга защиты", id = CR_DEFENSE_SKILL},
	{pattern = "рейтинг уклонения", id = CR_DODGE},
	{pattern = "рейтингу уклонения", id = CR_DODGE},
	{pattern = "рейтинга уклонения", id = CR_DODGE},
	{pattern = "рейтинг блокирования щитом", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "рейтинга блокирования щитом", id = CR_BLOCK},
	{pattern = "рейтингу блокирования щитом", id = CR_BLOCK},
	{pattern = "увеличение рейтинга блокирования щита на", id = CR_BLOCK},
	{pattern = "рейтинг блока", id = CR_BLOCK},
	{pattern = "рейтинга блока", id = CR_BLOCK},
	{pattern = "рейтингу блока", id = CR_BLOCK},
	{pattern = "рейтинг парирования", id = CR_PARRY},
	{pattern = "рейтинга парирования", id = CR_PARRY},
	{pattern = "рейтингу парирования", id = CR_PARRY},

	{pattern = "рейтинг критического удара %(заклинания%)", id = CR_CRIT_SPELL},
	{pattern = "рейтингу критического удара %(заклинания%)", id = CR_CRIT_SPELL},
	{pattern = "рейтинга критического удара %(заклинания%)", id = CR_CRIT_SPELL},
	{pattern = "рейтинга критического удара заклинаниями", id = CR_CRIT_SPELL},
	{pattern = "рейтингу критического удара заклинаниями", id = CR_CRIT_SPELL},
	{pattern = "рейтинг критического удара заклинаниями", id = CR_CRIT_SPELL},
	{pattern = "критический удар %(заклинания%)", id = CR_CRIT_SPELL},
	{pattern = "меткость %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "spell critical hit rating", id = CR_CRIT_SPELL},
	{pattern = "spell critical rating", id = CR_CRIT_SPELL},
	{pattern = "spell crit rating", id = CR_CRIT_SPELL},
	{pattern = "ranged critical strike rating", id = CR_CRIT_RANGED},
	{pattern = "к критическому удару в дальнем бою", id = CR_CRIT_RANGED}, -- [Heartseeker Scope]
	{pattern = "ranged critical hit rating", id = CR_CRIT_RANGED},
	{pattern = "ranged critical rating", id = CR_CRIT_RANGED},
	{pattern = "ranged crit rating", id = CR_CRIT_RANGED},
	{pattern = "рейтинг критического удара", id = CR_CRIT_MELEE},
	{pattern = "рейтинг критического эффекта", id = CR_CRIT_MELEE},
	{pattern = "рейтингу критического удара", id = CR_CRIT_MELEE},
	{pattern = "рейтинга критического удара", id = CR_CRIT_MELEE},
	{pattern = "рейтинг крит. удара оруж. ближнего боя", id = CR_CRIT_MELEE},
	{pattern = "critical hit rating", id = CR_CRIT_MELEE},
	{pattern = "critical rating", id = CR_CRIT_MELEE},
	{pattern = "crit rating", id = CR_CRIT_MELEE},

	{pattern = "рейтинг меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтингу меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтинга меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтинга меткости заклинаний", id = CR_HIT_SPELL},
	{pattern = "рейтингу меткости заклинаний", id = CR_HIT_SPELL},
	{pattern = "Рейтинг меткости (оруж. дальн. боя)", id = CR_HIT_RANGED},
	{pattern = "рейтинга нанесения удара ближнего боя", id = CR_HIT_MELEE},
	{pattern = "рейтинг меткости", id = CR_HIT_MELEE},
	{pattern = "рейтинга меткости", id = CR_HIT_MELEE},
	{pattern = "рейтингу меткости", id = CR_HIT_MELEE},

	{pattern = "рейтинг устойчивости", id = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN}, -- resilience is implicitly a rating
	{pattern = "рейтингу устойчивости", id = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN},
	{pattern = "рейтинга устойчивости", id = COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN},

	{pattern = "рейтинг скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "рейтингу скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "рейтинга скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "скорости наложения заклинаний", id = CR_HASTE_SPELL},
	{pattern = "скорость наложения заклинаний", id = CR_HASTE_SPELL},
	{pattern = "рейтинг скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтингу скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтинга скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтинг скорости", id = CR_HASTE_MELEE},
	{pattern = "рейтингу скорости", id = CR_HASTE_MELEE},
	{pattern = "рейтинга скорости", id = CR_HASTE_MELEE},
	{pattern = "speed rating", id = CR_HASTE_MELEE}, -- [Drums of Battle]

	{pattern = "рейтинг владения", id = CR_WEAPON_SKILL},
	{pattern = "рейтингу владения", id = CR_WEAPON_SKILL},
	{pattern = "рейтинга владения", id = CR_WEAPON_SKILL},
	{pattern = "рейтинг мастерства", id = CR_EXPERTISE},
	{pattern = "рейтингу мастерства", id = CR_EXPERTISE},
	{pattern = "рейтинга мастерства", id = CR_EXPERTISE},

	{pattern = "рейтинг уклонения от удара", id = CR_HIT_TAKEN_MELEE},
	{pattern = "Рейтингу уклонения от удара", id = CR_HIT_TAKEN_MELEE},
	{pattern = "рейтинга уклонения от удара", id = CR_HIT_TAKEN_MELEE},
	{pattern = "рейтинг пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "рейтингу пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "рейтинга пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "рейтинг искусности", id = CR_MASTERY},
	{pattern = "рейтингу искусности", id = CR_MASTERY},
	{pattern = "рейтинга искусности", id = CR_MASTERY},
	{pattern = string.lower(ARMOR), id = ARMOR},
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
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% крит"
L["$value% Spell Crit"] = "$value% крит закл"
L["$value% Dodge"] = "$value% уклонение"
L["$value HP"] = "$value Здор"
L["$value MP"] = "$value Мана"
L["$value AP"] = "$value Сила атаки"
L["$value RAP"] = "$value САДБ"
L["$value Dmg"] = "$value урона"
L["$value Heal"] = "$value Исцеления"
L["$value Armor"] = "$value Броня"
L["$value Block"] = "$value% Блок"
L["$value MP5"] = "$value МП5сек"
L["$value MP5(OC)"] = "$value МП 5сек НК"
L["$value HP5"] = "$value Здор 5сек"
L["$value to be Dodged/Parried"] = "$value% уклон/парир"
L["$value to be Crit"] = "$value% крит"
L["$value Crit Dmg Taken"] = "$value крит урон"
L["$value DOT Dmg Taken"] = "$value сила дотов"
L["$value Parry"] = "$value парирование"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value закл."
L["$value Spell Hit"] = "$value метк. закл."

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Итог по статам"