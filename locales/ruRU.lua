--[[
Name: RatingBuster ruRU locale
Revision: $Revision: 343 $
Translated by:
- Orsana \ StingerSoft \ Swix
]]

---@class RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "ruRU")
if not L then return end
local StatLogic = LibStub("StatLogic")
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
-- /rb statmod
L["Enable Stat Mods"] = "Включить модуль статистики"
L["Enable support for Stat Mods"] = "Включает поддержку модуля статистики"
-- /rb subtract_equip
--L["Enable Subtract Equipped Stats"] = ""
--L["Enable for more accurate calculation of Mana Regen from Intellect and Spirit, and diminishing stats like Dodge, Parry, Resilience"] = ""
-- /rb usereqlv
L["Use required level"] = "Рассчет для мин. уровня"
L["Calculate using the required level if you are below the required level"] = "Рассчитывать статы исходя из минимально необходимого для надевания предмета уровня, если вы ниже этого уровня"
-- /rb level
L["Set level"] = "Задать уровень"
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
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Включить убывания уклонений от удара"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Значения уклонения, парирования, уклонений от удара при расчетах будет использоваться формула убывания (deminishing return) уклонений от удара по вашим текущим данным"
-- /rb itemid
L["Show ItemID"] = "ID предмета"
L["Show the ItemID in tooltips"] = "Показывать ID предмета в описании"
-- /rb itemlevel
L["Show ItemLevel"] = "Уровень предмета"
L["Show the ItemLevel in tooltips"] = "Показывать уровень предмета в описании"
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
L["Show detailed conversions text"] = "Детальная конвертация рейтингов"
L["Show detailed text for Resilience and Expertise conversions"] = "Показывать детальную конвертацию рейтингов мастерства и устойчивости"
-- /rb rating exp
L["Expertise breakdown"] = "Разбивать уровень мастерства"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Разбивать уровень мастерства на игнорирование уклонения и парирования"
L["from"] = "от"
L["HEALING"] = "Исцеление"
L["AP"] = "Сила атаки"
L["RANGED_AP"] = "Сила атаки дальнего боя"
L["ARMOR"] = "Броня"
L["SPELL_DMG"] = "Сила заклинаний"
L["SPELL_CRIT"] = "Вер. крит. удара заклинаниями"
L["STR"] = "Сила"
L["AGI"] = "Ловкость"
L["STA"] = "Выносливость"
L["INT"] = "Интеллект"
L["SPI"] = "Дух"
L["PARRY"] = "Парирование"
L["MANA_REG"] = "Восполнение маны"
L["NORMAL_MANA_REG"] = "Восполнения маны (пока не применяете заклинания)"
L["HEALTH_REG"] = "Восстановление здоровья"
L["NORMAL_HEALTH_REG"] = "Восполнение здаровья (вне боя)"
L["PET_STA"] = "Выносливость питомца" -- Pet Stamina
L["PET_INT"] = "Интеллект питомца" -- Pet Intellect
L.statModOptionName = function(show, add)
	return ("%s %s "):format(show, add)
end
L.statModOptionDesc = function(show, add, from, mod)
	return ("%s %s %s %s "):format(show, add, from, mod)
end

---------------------------------------------------------------------------
-- /rb rating color
L["Change text color"] = "Изменить цвет текста"
L["Changes the color of added text"] = "Изменить цвет добавляемого текста"
L["Change number color"] = "Изменить цвет значений"
---------------------------------------------------------------------------
-- /rb stat
L["Stat Breakdown"] = "Конвертация статов"
L["Changes the display of base stats"] = "Показывать расчет базовых характеристик"
-- /rb stat show
L["Show base stat conversions"] = "Базовые характеристики"
L["Select when to show base stat conversions in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать изменение базовых статов в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
---------------------------------------------------------------------------
-- /rb stat str
L["Strength"] = "Сила"
L["Changes the display of Strength"] = "Изменить отображение силы"
-- /rb stat str ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Strength"] = "Показывать расчет силы атаки от силы"
-- /rb stat str block
L["Show Block Value"] = "Блокирование"
L["Show Block Value from Strength"] = "Показывать расчет показателя блокирования от силы"
-- /rb stat str dmg
L["Show Spell Damage"] = "Сила заклинаний"
L["Show Spell Damage from Strength"] = "Показывать расчет силы заклинаний от силы"
-- /rb stat str heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Strength"] = "Показывать расчет исцеления от силы"
-- /rb stat str parryrating
L["Show Parry Rating"] = "Рейтинг парирования"
L["Show Parry Rating from Strength"] = "Показывать расчет рейтинга парирования от силы"
-- /rb stat str parry
L["Show Parry"] = "Парирование"
L["Show Parry from Strength"] = "Показывать расчет парирования от силы"
---------------------------------------------------------------------------
-- /rb stat agi
L["Agility"] = "Ловкость"
L["Changes the display of Agility"] = "Изменить отображение ловкости"
-- /rb stat agi crit
L["Show Crit"] = "Крит. удар"
L["Show Crit chance from Agility"] = "Показывать расчет вероятности крит. удара от ловкости"
-- /rb stat agi dodge
L["Show Dodge"] = "Уклонение"
L["Show Dodge chance from Agility"] = "Показывать расчет вероятности уклонения от ловкости"
-- /rb stat agi ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Agility"] = "Показывать расчет силы атаки от ловкости"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Сила атаки дальнего боя"
L["Show Ranged Attack Power from Agility"] = "Показывать расчет силы атаки дальнего боя от ловкости"
-- /rb stat agi dmg
L["Show Spell Damage"] = "Сила заклинаний"
L["Show Spell Damage from Agility"] = "Показывать расчет силы заклинаний от ловкости"
-- /rb stat agi heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Agility"] = "Показывать расчет исцеления от ловкости"
---------------------------------------------------------------------------
-- /rb stat sta
L["Stamina"] = "Выносливость"
L["Changes the display of Stamina"] = "Изменить отображение выносливости"
-- /rb stat sta hp
L["Show Health"] = "Здоровье"
L["Show Health from Stamina"] = "Показывать расчет здоровья от выносливости"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Сила заклинаний"
L["Show Spell Damage from Stamina"] = "Показывать расчет силы заклинаний от выносливости"
-- /rb stat sta heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Stamina"] = "Показывать расчет исцеления от выносливости"
-- /rb stat sta ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Stamina"] = "Показывать расчет силы атаки от выносливости"
---------------------------------------------------------------------------
-- /rb stat int
L["Intellect"] = "Интеллект"
L["Changes the display of Intellect"] = "Изменить отображение интеллекта"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Крит. удар от заклинаний"
L["Show Spell Crit chance from Intellect"] = "Показывать расчет вероятности крит. удара заклинаниями от интеллекта"
-- /rb stat int mp
L["Show Mana"] = "Мана"
L["Show Mana from Intellect"] = "Показывать расчет маны от интеллекта"
-- /rb stat int dmg
L["Show Spell Damage"] = "Сила заклинаний"
L["Show Spell Damage from Intellect"] = "Показывать расчет силы заклинаний от интеллекта"
-- /rb stat int heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Intellect"] = "Показывать расчет исцеления от интеллекта"
-- /rb stat int mp5
L["Show Mana Regen"] = "Восполнение маны в бою"
L["Show Mana Regen while casting from Intellect"] = "Показывать расчет восполнения маны от интеллекта (в бою)"
-- /rb stat int mp5oc
L["Show Normal Mana Regen"] = "Восполнения маны вне боя"
L["Show Mana Regen while NOT casting from Intellect"] = "Показывать расчет восполнения маны от интеллекта (вне боя)"
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Сила атаки дальнего боя"
L["Show Ranged Attack Power from Intellect"] = "Показывать расчет силы атаки дальнего боя от интеллекта"
-- /rb stat int ap
L["Show Attack Power"] = "Силы атаки"
L["Show Attack Power from Intellect"] = "Показывать расчет силы атаки от интеллекта"
---------------------------------------------------------------------------
-- /rb stat spi
L["Spirit"] = "Дух"
L["Changes the display of Spirit"] = "Изменить отображение духа"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Восполнение маны в бою"
L["Show Mana Regen while casting from Spirit"] = "Показывать расчет восполнения маны от духа (в бою)"
-- /rb stat spi mp5oc
L["Show Mana Regen while NOT casting"] = "Восполнения маны вне боя"
L["Show Mana Regen while NOT casting from Spirit"] = "Показывать расчет восполнения маны от духа (вне боя)"
-- /rb stat spi hp5
L["Show Health Regen (Out of Combat)"] = "Восполнение здаровья вне боя"
L["Show Health Regen (Out of Combat) from Spirit"] = "Показывать расчет восполнения здоровья от духа (вне боя)"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Сила заклинаний"
L["Show Spell Damage from Spirit"] = "Показывать расчет силы заклинаний от духа"
-- /rb stat spi heal
L["Show Healing"] = "Исцеление"
L["Show Healing from Spirit"] = "Показывать расчет исцеления от духа"
-- /rb stat spi spellcrit
L["Show Spell Crit"] = "Крит. удар заклинаниями"
L["Show Spell Crit chance from Spirit"] = "Показывать расчет вероятности критического удара заклинаниями от духа"
-- /rb stat spi spellhitrating
L["Show Spell Hit Rating"] = "Рейтинг меткости заклинаний"
L["Show Spell Hit Rating from Spirit"] = "Показывать расчет рейтинга меткости заклинаний от духа"
-- /rb stat spi spellhit
L["Show Spell Hit"] = "Меткость заклинаний"
L["Show Spell Hit from Spirit"] = "Показывать расчет меткости заклинаний от духа"
---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "Броня"
L["Changes the display of Armor"] = "Показывать расчет брони"
L["Attack Power"] = "Attack Power"
L["Changes the display of Attack Power"] = "Changes the display of Attack Power"
-- /rb stat armor ap
L["Show Attack Power"] = "Сила атаки"
L["Show Attack Power from Armor"] = "Показывать расчет силы атаки от брони"
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Настройки итогов"
L["Options for stat summary"] = "Итоги по статам"
-- /rb sum show
L["Show Stat Summary"] = "Показывать суммарные изменения"
L["Select when to show stat summary in tooltips. Modifier keys needs to be pressed before showing the tooltips."] = "Выберите когда показывать суммарные изменения в подсказке. Модификатор клавиш должен быть нажатым перед показом подсказки."
-- /rb sum ignore
L["Ignore settings"] = "Настройки игнорирования"
L["Ignore stuff when calculating the stat summary"] = "Настройка игнорирования при расчете итога"
-- /rb sum ignore unused
L["Ignore unused item types"] = "Игнорирование неподходящих предметов"
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
L["Ignore equipped items"] = "Не показывать для надетых вещей"
L["Hide stat summary for equipped items"] = "Не показывать для надетых вещей"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Игнорировать чары"
L["Ignore enchants on items when calculating the stat summary"] = "Игнорировать чары при расчете итога"
-- /rb sum ignore gem
L["Ignore gems"] = "Игнорировать самоцветы"
L["Ignore gems on items when calculating the stat summary"] = "Игнорировать самоцветы при расчете итога"
L["Ignore extra sockets"] = true
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = true
-- /rb sum diffstyle
L["Display Style For Diff Value"] = "Стиль отображения отличия значений"
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
L["Include Block Chance In Avoidance Summary"] = "Включать вероятность блока в итоге избежаний"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Включать вероятность блока в итоге избежаний, отключение только для уклона, парирования, промоха"
---------------------------------------------------------------------------
-- /rb sum basic
L["Stat - Basic"] = "Статы - базовые"
L["Choose basic stats for summary"] = "Выбор базовых статов для подсчета"
-- /rb sum basic hp
L["Sum Health"] = "Здоровье"
L["Health <- Health, Stamina"] = "Здоровье, выносливость -> Здоровье"
-- /rb sum basic mp
L["Sum Mana"] = "Мана"
L["Mana <- Mana, Intellect"] = "Мана, интеллект -> Мана"
-- /rb sum basic mp5
L["Sum Combat Mana Regen"] = "Восст. маны в бою"
L["Combat Mana Regen <- Mana Regen, Spirit"] = "Восстановление маны, дух -> Восстановление маны в бою"
-- /rb sum basic mp5oc
L["Sum Normal Mana Regen"] = "Восст. маны вне боя"
L["Normal Mana Regen <- Spirit"] = "Дух -> Сумма восстановления маны вне боя"
-- /rb sum basic hp5
L["Sum Combat Health Regen"] = "Восст. здоровья в бою"
L["Combat Health Regen <- Health Regen"] = "Восстановление здоровья -> Восстановление здоровья в бою"
-- /rb sum basic hp5oc
L["Sum Normal Health Regen"] = "Восст. здоровья вне боя"
L["Normal Health Regen <- Spirit"] = "Дух -> Сумма восстановления здоровья вне боя"
-- /rb sum basic str
L["Sum Strength"] = "Сила"
L["Strength Summary"] = "Суммировать силу"
-- /rb sum basic agi
L["Sum Agility"] = "Ловкость"
L["Agility Summary"] = "Суммировать ловкость"
-- /rb sum basic sta
L["Sum Stamina"] = "Выносливость"
L["Stamina Summary"] = "Суммировать выносливость"
-- /rb sum basic int
L["Sum Intellect"] = "Интеллект"
L["Intellect Summary"] = "Суммировать интеллект"
-- /rb sum basic spi
L["Sum Spirit"] = "Дух"
L["Spirit Summary"] = "Суммировать дух"
-- /rb sum basic mastery
L["Sum Mastery"] = "Искусность"
L["Mastery Summary"] = "Суммировать искусность"
-- /rb sum basic masteryrating
L["Sum Mastery Rating"] = "Рейтинг искусности"
L["Mastery Rating Summary"] = "Суммировать рейтинг искусности"
---------------------------------------------------------------------------
-- /rb sum physical
L["Stat - Physical"] = "Статы - физические"
L["Choose physical damage stats for summary"] = "Выбор статов физического урона для подсчета"
-- /rb sum physical ap
L["Sum Attack Power"] = "Сила атаки"
L["Attack Power <- Attack Power, Strength, Agility"] = "Сила атаки, сила, ловкость -> Сила атаки"
-- /rb sum physical rap
L["Sum Ranged Attack Power"] = "Сила атаки дальнего боя"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Сила атаки дальнего боя, интеллект, сила атаки, сила, ловкость -> Сила атаки дальнего боя"
-- /rb sum physical hit
L["Sum Hit Chance"] = "Вероятность попадания"
L["Hit Chance <- Hit Rating"] = "Рейтинг меткости -> Вероятность поподания"
-- /rb sum physical hitrating
L["Sum Hit Rating"] = "Рейтинг меткости"
L["Hit Rating Summary"] = "Суммировать рейтинг меткости"
-- /rb sum physical crit
L["Sum Crit Chance"] = "Вероятность крит. удара"
L["Crit Chance <- Crit Rating, Agility"] = "Рейтинг крит. удара, ловкость -> Вероятность крит. удара"
-- /rb sum physical critrating
L["Sum Crit Rating"] = "Рейтинг крит. удара"
L["Crit Rating Summary"] = "Суммировать рейтинг крит. удара"
-- /rb sum physical haste
L["Sum Haste"] = "Скорость"
L["Haste <- Haste Rating"] = "Рейтинг скорости -> Скорость"
-- /rb sum physical hasterating
L["Sum Haste Rating"] = "Сумма рейтинга скорости"
L["Haste Rating Summary"] = "Суммировать рейтинг скорости"
-- /rb sum physical rangedhit
L["Sum Ranged Hit Chance"] = "Вероятность поподания в дальнем бою"
L["Ranged Hit Chance <- Hit Rating, Ranged Hit Rating"] = "Рейтинг меткости, рейтинг меткости дальнего боя -> Вероятность поподания в дальнем бою"
-- /rb sum physical rangedhitrating
L["Sum Ranged Hit Rating"] = "Рейтинга меткости дальнего боя"
L["Ranged Hit Rating Summary"] = "Суммировать рейтинг меткости дальнего боя"
-- /rb sum physical rangedcrit
L["Sum Ranged Crit Chance"] = "Вероятность крит. удара в дальнем бою"
L["Ranged Crit Chance <- Crit Rating, Agility, Ranged Crit Rating"] = "Рейтинг крита, ловкость, рейтинг крит. удара дальнего боя -> Вероятность крит. удара в дальнем бою"
-- /rb sum physical rangedcritrating
L["Sum Ranged Crit Rating"] = "Рейтинг крит. удара дальнего боя"
L["Ranged Crit Rating Summary"] = "Суммировать рейтинг критического удара в дальнем бою"
-- /rb sum physical rangedhaste
L["Sum Ranged Haste"] = "Скорость дальнего боя"
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Рейтинг скорости, рейтинг скорости дальнего боя -> Скорость дальнего боя"
-- /rb sum physical rangedhasterating
L["Sum Ranged Haste Rating"] = "Рейтинг скорости дальнего боя"
L["Ranged Haste Rating Summary"] = "Суммировать рейтинг скорости дальнего боя"
L["Sum Ignore Armor"] = "Игнорирование брони"
L["Ignore Armor Summary"] = "Суммировать игнорирование брони"
L["Sum Armor Penetration"] = "Пробивание брони"
L["Armor Penetration Summary"] = "Суммировать пробивание брони"
L["Sum Armor Penetration Rating"] = "Рейтинг пробивания брони"
L["Armor Penetration Rating Summary"] = "Суммировать рейтинг пробивания брони"
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = "Сумма УВС оружия"
L["Weapon DPS Summary"] = "Суммировать урон в секунду от оружия"
-- /rb sum physical wpn
L["Sum Weapon Skill"] = "Оружейный навык"
L["Weapon Skill <- Weapon Skill Rating"] = "Рейтинг владения оружием -> Оружейный навык"
-- /rb sum physical exp
L["Sum Expertise"] = "Мастерство"
L["Expertise <- Expertise Rating"] = "Рейтинг мастерства -> Мастерство"
-- /rb sum physical exprating
L["Sum Expertise Rating"] = "Рейтинг мастерства"
L["Expertise Rating Summary"] = "Суммировать рейтинг мастерства"
---------------------------------------------------------------------------
-- /rb sum spell
L["Stat - Spell"] = "Статы - заклинания"
L["Choose spell damage and healing stats for summary"] = "Выбор магических статов для подсчета"
-- /rb sum spell power
L["Sum Spell Power"] = "Сила заклинаний"
L["Spell Power <- Spell Power, Intellect, Agility, Strength"] = "Сила заклинаний, интеллект, ловкость, сила -> Сила заклинаний"
-- /rb sum spell dmg
L["Sum Spell Damage"] = "Сила заклинаний" -- Changed from Damage to Power
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Сила заклинаний, интеллект, дух, выносливость -> Сила заклинаний" -- Changed from Damage to Power
-- /rb sum spell dmgholy
L["Sum Holy Spell Damage"] = "Урон от светлой магии"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Урон от светлой магии, сила заклинаний, интеллект, дух -> Урон от светлой магии"
-- /rb sum spell dmgarcane
L["Sum Arcane Spell Damage"] = "Урон от тайной магии"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Урон от тайной магии, сила заклинаний, интеллект -> Урон от тайной магии"
-- /rb sum spell dmgfire
L["Sum Fire Spell Damage"] = "Урон от огня"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Урон от огня, сила заклинаний, интеллект, выносливость -> Урон от огня"
-- /rb sum spell dmgnature
L["Sum Nature Spell Damage"] = "Урон от сил природы"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Урон от сил природы, сила заклинаний, интеллект -> Урон от сил природы"
-- /rb sum spell dmgfrost
L["Sum Frost Spell Damage"] = "Урон от магии льда"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Урон от магии льда, сила заклинаний, интеллект -> Урон от магии льда"
-- /rb sum spell dmgshadow
L["Sum Shadow Spell Damage"] = "Урон от темной магии"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Урон от темной магии, сила заклинаний, интеллект, дух, выносливость -> Урон от темной магии"
-- /rb sum spell heal
L["Sum Healing"] = "Исцеление"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Исцеление, интеллект, дух, ловкость, сила -> Исцеление"
-- /rb sum spell crit
L["Sum Spell Crit Chance"] = "Вероятность крит. удара заклинаниями"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Рейтинг крит. удара заклинаниями, интеллект -> Вероятность крит. удара заклинаниями"
-- /rb sum spell hit
L["Sum Spell Hit Chance"] = "Вероятность поподания заклинаниями"
L["Spell Hit Chance <- Spell Hit Rating"] = "Рейтинг меткости заклинаний -> Вероятность поподания заклинаниями"
-- /rb sum spell haste
L["Sum Spell Haste"] = "Скорость заклинаний"
L["Spell Haste <- Spell Haste Rating"] = "Рейтинг скорости заклинаний -> Скорость заклинаний"
-- /rb sum spell pen
L["Sum Penetration"] = "Проникающая способность"
L["Spell Penetration Summary"] = "Суммировать проникающую способность заклинаний"
-- /rb sum spell hitrating
L["Sum Spell Hit Rating"] = "Рейтинг меткости заклинаний"
L["Spell Hit Rating Summary"] = "Суммировать рейтинг меткости заклинаний"
-- /rb sum spell critrating
L["Sum Spell Crit Rating"] = "Рейтинг крит. удара заклинаниями"
L["Spell Crit Rating Summary"] = "Суммировать рейтинг крит. удара заклинаниями"
-- /rb sum spell hasterating
L["Sum Spell Haste Rating"] = "Рейтинг скорости заклинаний"
L["Spell Haste Rating Summary"] = "Суммировать рейтинг скорости заклинаний"
---------------------------------------------------------------------------
-- /rb sum tank
L["Stat - Tank"] = "Статы - танк"
L["Choose tank stats for summary"] = "Выбор танковских статов для подсчета"
-- /rb sum tank armor
L["Sum Armor"] = "Броня"
L["Armor <- Armor from items and bonuses"] = "Броня с одежды и бонусов -> Броня"
-- /rb sum tank dodge
L["Sum Dodge Chance"] = "Вероятность уклонения"
L["Dodge Chance <- Dodge Rating, Agility"] = "Рейтинг уклонения, ловкость -> Вероятность уклонения"
-- /rb sum tank parry
L["Sum Parry Chance"] = "Вероятность парирования"
L["Parry Chance <- Parry Rating"] = "Рейтинг парирования -> Вероятность парирования"
-- /rb sum tank block
L["Sum Block Chance"] = "Вероятность блокирования"
L["Block Chance <- Block Rating"] = "Рейтинг блокирования -> Вероятность блокирования"
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
	{pattern = " на (%d+)%f[^%d%%]", addInfo = "AfterNumber", space = " ", },
	{pattern = "([%+%-]%d+)%f[^%d%%] к", addInfo = "AfterStat",},
	{pattern = " увеличена на (%d+)", addInfo = "AfterNumber", space = " ", },
	{pattern = "(%d+) к ", addInfo = "AfterNumber", space = " ", }, -- тест
	{pattern = "увеличение (%d+)", addInfo = "AfterNumber", space = " ", }, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "дополнительно (%d+)", addInfo = "AfterNumber", space = " ", }, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)%f[^%d%%|]", addInfo = "AfterNumber", space = " ", }, -- [發光的暗影卓奈石] +6法術傷害及5耐力
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
CR_RESILIENCE_CRIT_TAKEN = 15;
CR_RESILIENCE_PLAYER_DAMAGE_TAKEN = 16;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_EXPERTISE = 24;
CR_ARMOR_PENETRATION = 25;
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
	{pattern = "ослабление брони противника", id = nil}, -- Annihilator

	{pattern = "сила атаки", id = ATTACK_POWER},
	{pattern = "силу атаки", id = ATTACK_POWER},
	{pattern = "силы атаки", id = ATTACK_POWER},
	{pattern = "силы вашей атаки", id = ATTACK_POWER},
	{pattern = "к силе атаки", id = ATTACK_POWER},

	-- Resistance and Spell Damage aren't used for breakdowns,
	-- but are needed to prevent false matches of other stats
	{pattern = "силам природы", id = NATURE_RES},
	{pattern = "сила заклинаний", id = SPELL_DMG},
	{pattern = "сила ваших заклинаний", id = SPELL_DMG},
	{pattern = "силу заклинаний", id = SPELL_DMG},
	{pattern = "силы заклинаний", id = SPELL_DMG},
	{pattern = "к силе заклинаний", id = SPELL_DMG},

	{pattern = "рейтинг пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "рейтингу пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "рейтинга пробивания брони", id = CR_ARMOR_PENETRATION},
	{pattern = "эффективность брони противника", id = CR_ARMOR_PENETRATION},
	{pattern = "броня", id = ARMOR},
	{pattern = "брони", id = ARMOR},
	{pattern = "броню", id = ARMOR},
	{pattern = "броне", id = ARMOR},
	{pattern = "сила", id = StatLogic.Stats.Strength}, -- Strength
	{pattern = "силу", id = StatLogic.Stats.Strength}, -- Strength
	{pattern = "силе", id = StatLogic.Stats.Strength}, -- Strength
	{pattern = "силы", id = StatLogic.Stats.Strength}, -- Strength
	{pattern = "ловкость", id = StatLogic.Stats.Agility}, -- Agility
	{pattern = "ловкости", id = StatLogic.Stats.Agility}, -- Agility
	{pattern = "выносливость", id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = "выносливости", id = StatLogic.Stats.Stamina}, -- Stamina
	{pattern = "интеллекту", id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = "интеллект", id = StatLogic.Stats.Intellect}, -- Intellect
	{pattern = "духу", id = StatLogic.Stats.Spirit}, -- Spirit
	{pattern = "дух", id = StatLogic.Stats.Spirit}, -- Spirit

	{pattern = "рейтинг защиты", id = CR_DEFENSE_SKILL},
	{pattern = "рейтингу защиты", id = CR_DEFENSE_SKILL},
	{pattern = "рейтинга защиты", id = CR_DEFENSE_SKILL},
	{pattern = "к защите", id = CR_DEFENSE_SKILL},
	{pattern = "рейтинг уклонения", id = CR_DODGE},
	{pattern = "рейтингу уклонения", id = CR_DODGE},
	{pattern = "рейтинга уклонения", id = CR_DODGE},
	{pattern = "эффективность уклонения", id = CR_DODGE},
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
	{pattern = "к критическому удару в дальнем бою", id = CR_CRIT_RANGED}, -- [Heartseeker Scope]
	{pattern = "рейтинг критического удара", id = StatLogic.GenericStats.CR_CRIT},
	{pattern = "к рейтингу критического эффекта", id = StatLogic.GenericStats.CR_CRIT},
	{pattern = "рейтингу критического удара", id = StatLogic.GenericStats.CR_CRIT},
	{pattern = "рейтинга критического удара", id = StatLogic.GenericStats.CR_CRIT},
	{pattern = "рейтинг крит. удара оруж. ближнего боя", id = CR_CRIT_MELEE},

	{pattern = "рейтинг меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтингу меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтинга меткости %(заклинания%)", id = CR_HIT_SPELL},
	{pattern = "рейтинга меткости заклинаний", id = CR_HIT_SPELL},
	{pattern = "рейтингу меткости заклинаний", id = CR_HIT_SPELL},
	{pattern = "Рейтинг меткости (оруж. дальн. боя)", id = CR_HIT_RANGED},
	{pattern = "рейтинга нанесения удара ближнего боя", id = CR_HIT_MELEE},
	{pattern = "рейтинг меткости", id = StatLogic.GenericStats.CR_HIT},
	{pattern = "рейтинга меткости", id = StatLogic.GenericStats.CR_HIT},
	{pattern = "рейтингу меткости", id = StatLogic.GenericStats.CR_HIT},

	{pattern = "рейтинг устойчивости", id = CR_RESILIENCE_CRIT_TAKEN}, -- resilience is implicitly a rating
	{pattern = "рейтингу устойчивости", id = CR_RESILIENCE_CRIT_TAKEN},
	{pattern = "рейтинга устойчивости", id = CR_RESILIENCE_CRIT_TAKEN},

	{pattern = "рейтинг скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "рейтингу скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "рейтинга скорости %(заклинания%)", id = CR_HASTE_SPELL},
	{pattern = "скорости наложения заклинаний", id = CR_HASTE_SPELL},
	{pattern = "скорость наложения заклинаний", id = CR_HASTE_SPELL},
	{pattern = "рейтинг скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтингу скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтинга скорости дальнего боя", id = CR_HASTE_RANGED},
	{pattern = "рейтинг скорости", id = StatLogic.GenericStats.CR_HASTE},
	{pattern = "рейтингу скорости", id = StatLogic.GenericStats.CR_HASTE},
	{pattern = "рейтинга скорости", id = StatLogic.GenericStats.CR_HASTE},

	{pattern = "рейтинг мастерства", id = CR_EXPERTISE},
	{pattern = "рейтингу мастерства", id = CR_EXPERTISE},
	{pattern = "рейтинга мастерства", id = CR_EXPERTISE},
	{pattern = "уровень мастерства", id = CR_EXPERTISE},

	{pattern = SPELL_STATALL:lower(), id = StatLogic.GenericStats.ALL_STATS},

	{pattern = "рейтинг искусности", id = CR_MASTERY},
	{pattern = "рейтингу искусности", id = CR_MASTERY},
	{pattern = "рейтинга искусности", id = CR_MASTERY},
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
L["$value Dmg Taken"] = true
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value для заклинаний"

L["EMPTY_SOCKET_RED"] =  EMPTY_SOCKET_RED        -- EMPTY_SOCKET_RED = "Red Socket";
L["EMPTY_SOCKET_YELLOW"] =  EMPTY_SOCKET_YELLOW -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
L["EMPTY_SOCKET_BLUE"] =  EMPTY_SOCKET_BLUE     -- EMPTY_SOCKET_BLUE = "Blue Socket";
L["EMPTY_SOCKET_META"] =  EMPTY_SOCKET_META     -- EMPTY_SOCKET_META = "Meta Socket";
L["IGNORE_ARMOR"] =  "Ignore Armor"
L["THREAT_MOD"] =  "Threat(%)"
L["STEALTH_LEVEL"] =  "Stealth Level"
L["MELEE_DMG"] =  "Melee Weapon " .. DAMAGE -- DAMAGE = "Damage"
L["MOUNT_SPEED"] =  "Mount Speed(%)"
L["RUN_SPEED"] =  "Run Speed(%)"
L[StatLogic.Stats.Strength] =  "Сила"
L[StatLogic.Stats.Agility] =  "Ловкость"
L[StatLogic.Stats.Stamina] =  "Выносливость"
L[StatLogic.Stats.Intellect] =  "Интеллект"
L[StatLogic.Stats.Spirit] =  "Дух"
L["ARMOR"] =  "Броня"
L["ARMOR_BONUS"] =  ARMOR .. " from bonus"
L["FIRE_RES"] =  "Сопротивление огню"
L["NATURE_RES"] =  "Сопротивление силам природы"
L["FROST_RES"] =  "Сопротивление магии льда"
L["SHADOW_RES"] =  "Сопротивление темной магии"
L["ARCANE_RES"] =  "Сопротивление тайной магии"
L["FISHING"] =  "Рыбная ловля"
L["MINING"] =  "Горное дело"
L["HERBALISM"] =  "Травничество"
L["SKINNING"] =  "Снятие шкур"
L["BLOCK_VALUE"] =  "Показатель блокирования"
L["AP"] =  "Сила атаки"
L["RANGED_AP"] =  "Сила атаки дальнего боя"
L["FERAL_AP"] =  "Сила атаки в облике зверя"
L["AP_UNDEAD"] =  "Сила атаки (против нежити)"
L["AP_DEMON"] =  "Сила атаки (против демонов)"
L["HEAL"] =  "Исцеление"
L["SPELL_DMG"] =  "Сила заклинаний"
L["SPELL_DMG_UNDEAD"] = { "Сила заклинаний (против нежити)",
	PLAYERSTAT_SPELL_COMBAT .. " Dmg" .. "(Undead)" }
L["SPELL_DMG_DEMON"] = { "Сила заклинаний (против демонов)",
	PLAYERSTAT_SPELL_COMBAT .. " Dmg" .. "(Demon)" }
L["HOLY_SPELL_DMG"] =  "Сила заклинаний (светлая магия)"
L["FIRE_SPELL_DMG"] =  "Сила заклинаний (огонь)"
L["NATURE_SPELL_DMG"] =  "Сила заклинаний (природа)"
L["FROST_SPELL_DMG"] =  "Сила заклинаний (лед)"
L["SHADOW_SPELL_DMG"] =  "Сила заклинаний (темная магия)"
L["ARCANE_SPELL_DMG"] =  "Сила заклинаний (тайная магия)"
L["SPELLPEN"] =  "Проникающая способность заклинаний"
L["HEALTH"] =  "Здоровье"
L["MANA"] =  "Мана"
L["HEALTH_REG"] =  "Восстановление здоровья раз в 5 сек."
L["MANA_REG"] =  "Восстановление маны раз в 5 сек."
L["AVERAGE_DAMAGE"] =  "Average Damage"
L["DPS"] =  "Урон в секунду"
L["DEFENSE_RATING"] =  "Рейтинг защиты"     -- COMBAT_RATING_NAME2 = "Defense Rating"
L["DODGE_RATING"] =  "Рейтинг уклонения"    -- COMBAT_RATING_NAME3 = "Dodge Rating"
L["PARRY_RATING"] =  "Рейтинг парирования"  -- COMBAT_RATING_NAME4 = "Parry Rating"
L["BLOCK_RATING"] =  "Рейтинг блокирования" -- COMBAT_RATING_NAME5 = "Block Rating"
L["MELEE_HIT_RATING"] =  "Рейтинг меткости" -- COMBAT_RATING_NAME6 = "Hit Rating"
L["RANGED_HIT_RATING"] =  "Рейтинг меткости" -- PLAYERSTAT_RANGED_COMBAT = "Ranged"
L["SPELL_HIT_RATING"] =  "Рейтинг меткости" -- PLAYERSTAT_SPELL_COMBAT = "Spell"
L["MELEE_CRIT_RATING"] =  "Рейтинг крит. удара"           -- COMBAT_RATING_NAME9 = "Crit Rating"
L["RANGED_CRIT_RATING"] =  "Рейтинг крит. удара"
L["SPELL_CRIT_RATING"] =  "Рейтинг крит. удара"
L["RESILIENCE_RATING"] =  "Рейтинг устойчивости" -- COMBAT_RATING_NAME15 = "Resilience"
L["MELEE_HASTE_RATING"] =  "Рейтинг скорости" --
L["RANGED_HASTE_RATING"] =  "Рейтинг скорости"
L["SPELL_HASTE_RATING"] =  "Рейтинг скорости"
L["EXPERTISE_RATING"] = "Рейтинг мастерства"
L["ARMOR_PENETRATION_RATING"] = RATING .. " пробиванию брони"
-- Tier2 Stats - Stats that only show up when broken down from a Tier1 stat
-- Str -> AP, Block Value
-- Agi -> AP, Crit, Dodge
-- Sta -> Health
-- Int -> Mana, Spell Crit
-- Spi -> mp5nc, hp5oc
-- Ratings -> Effect
L["HEALTH_REG_OUT_OF_COMBAT"] = "Восстановление здоровья раз в 5 сек. (вне боя)"
L["MANA_REG_NOT_CASTING"] = "Восстановление маны раз в 5 сек. (вне каста)"
L["MELEE_CRIT_DMG_REDUCTION"] = "Понижение входящего урона от крит. ударов (%)"
L["RANGED_CRIT_DMG_REDUCTION"] = "Понижение входящего урона от крит. ударов (%)"
L["SPELL_CRIT_DMG_REDUCTION"] = "Понижение входящего урона от крит. ударов (%)"
L[StatLogic.Stats.Defense] = "Защита"
L[StatLogic.Stats.Dodge] = "Уклонение (%)"
L[StatLogic.Stats.Parry] = "Парирование (%)"
L[StatLogic.Stats.BlockChance] = "Блокирование (%)"
L["AVOIDANCE"] = "Избегание атак (%)"
L["MELEE_HIT"] = "Меткость (%)"
L["RANGED_HIT"] = "Меткость (%)"
L["SPELL_HIT"] = "Меткость (%)"
L[StatLogic.Stats.Miss] = "Hit Avoidance(%)"
L[StatLogic.Stats.MeleeCrit] = "Вероятность крит. удара (%)" -- MELEE_CRIT_CHANCE = "Crit Chance"
L[StatLogic.Stats.RangedCrit] = "Вероятность крит. удара (%)"
L[StatLogic.Stats.SpellCrit] = "Вероятность крит. удара (%)"
L["MELEE_CRIT_AVOID"] = "Crit Avoidance(%)"
L["MELEE_HASTE"] = "Скорость (%)" --
L["RANGED_HASTE"] = "Скорость (%)"
L["SPELL_HASTE"] = "Скорость (%)"
L["DAGGER_WEAPON"] = "Dagger "..SKILL -- SKILL = "Skill"
L["SWORD_WEAPON"] = "Sword "..SKILL
L["2H_SWORD_WEAPON"] = "Two-Handed Sword "..SKILL
L["AXE_WEAPON"] = "Axe "..SKILL
L["2H_AXE_WEAPON"] = "Two-Handed Axe "..SKILL
L["MACE_WEAPON"] = "Mace "..SKILL
L["2H_MACE_WEAPON"] = "Two-Handed Mace "..SKILL
L["GUN_WEAPON"] = "Gun "..SKILL
L["CROSSBOW_WEAPON"] = "Crossbow "..SKILL
L["BOW_WEAPON"] = "Bow "..SKILL
L["FERAL_WEAPON"] = "Feral "..SKILL
L["FIST_WEAPON"] = "Unarmed "..SKILL
L["STAFF_WEAPON"] = "Staff "..SKILL -- Leggings of the Fang ID:10410
L["EXPERTISE"] = "Мастерство"
L["ARMOR_PENETRATION"] = "Пробивание брони (%)"
-- Tier3 Stats - Stats that only show up when broken down from a Tier2 stat
-- Defense -> Crit Avoidance, Hit Avoidance, Dodge, Parry, Block
-- Weapon Skill -> Crit, Hit, Dodge Neglect, Parry Neglect, Block Neglect
-- Expertise -> Dodge Neglect, Parry Neglect
L["DODGE_NEGLECT"] = "Снижение вер. противника уклониться (%)"
L["PARRY_NEGLECT"] = "Снижение вер. противника парировать (%)"
L["BLOCK_NEGLECT"] = "Снижение вер. противника блокировать (%)"
-- Talents
L["MELEE_CRIT_DMG"] = "Crit Damage(%)"
L["RANGED_CRIT_DMG"] = PLAYERSTAT_RANGED_COMBAT.." Crit Damage(%)"
L["SPELL_CRIT_DMG"] = PLAYERSTAT_SPELL_COMBAT.." Crit Damage(%)"
-- Spell Stats
-- These values can be prefixed with a @ and spell name, using reverse translation to english from Babble-Spell-2.2
-- Ex: "Heroic Strike@RAGE_COST" for Heroic Strike rage cost
-- Ex: "Heroic Strike@THREAT" for Heroic Strike threat value
-- Use strsplit("@", text) to seperate the spell name and statid
L["THREAT"] = "Threat"
L["CAST_TIME"] = "Casting Time"
L["MANA_COST"] = "Mana Cost"
L["RAGE_COST"] = "Rage Cost"
L["ENERGY_COST"] = "Energy Cost"
L["COOLDOWN"] = "Cooldown"
-- Stats Mods
L["MOD_STR"] = "Mod "..SPELL_STAT1_NAME.."(%)"
L["MOD_AGI"] = "Mod "..SPELL_STAT2_NAME.."(%)"
L["MOD_STA"] = "Mod "..SPELL_STAT3_NAME.."(%)"
L["MOD_INT"] = "Mod "..SPELL_STAT4_NAME.."(%)"
L["MOD_SPI"] = "Mod "..SPELL_STAT5_NAME.."(%)"
L["MOD_HEALTH"] = "Mod "..HEALTH.."(%)"
L["MOD_MANA"] = "Mod "..MANA.."(%)"
L["MOD_ARMOR"] = "Mod "..ARMOR.."from Items".."(%)"
L["MOD_BLOCK_VALUE"] = "Mod Block Value".."(%)"
L["MOD_AP"] = "Mod "..ATTACK_POWER_TOOLTIP.."(%)"
L["MOD_RANGED_AP"] = "Mod "..PLAYERSTAT_RANGED_COMBAT.." "..ATTACK_POWER_TOOLTIP.."(%)"
L["MOD_SPELL_DMG"] = "Mod "..PLAYERSTAT_SPELL_COMBAT.." "..DAMAGE.."(%)"
L["MOD_HEALING"] = "Mod Healing".."(%)"
L["MOD_CAST_TIME"] = "Mod Casting Time".."(%)"
L["MOD_MANA_COST"] = "Mod Mana Cost".."(%)"
L["MOD_RAGE_COST"] = "Mod Rage Cost".."(%)"
L["MOD_ENERGY_COST"] = "Mod Energy Cost".."(%)"
L["MOD_COOLDOWN"] = "Mod Cooldown".."(%)"
-- Misc Stats
L["WEAPON_SKILL"] = "Weapon "..SKILL

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Итого:"
