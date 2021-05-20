# RatingBuster

Originally written by Whitetooth (https://github.com/hotdogee)

RatingBuster started out as an addon that converts combat ratings in your tooltips into percentages, so that you have more meaningful information when comparing different items.

The design aim of RatingBuster is to provide detailed, meaningful and customizable information about items so you can easily decide for yourself which item is better.

![image](https://user-images.githubusercontent.com/7716908/118906676-d70d6b80-b8e3-11eb-80fa-001034491a32.png)

## Features

Rating Conversion:
  * Converts combat ratings into percentages.

Stat Breakdown:
  * Breakdown Strength, Agility, Stamina, Intellect and Spirit into base stats.
  * Supports talents, buffs and racials that give you extra bonuses.
  * Ex talent: Lunar Guidance - "Increases your spell damage and healing by 8%/16%/25% of your total Intellect."
  * Ex talent: Heart of the Wild - "Increases your Intellect by 4%/8%/12%/16%/20%. In addition, ......etc"
  * Ex: +13 Intellect (+234 Mana, +0.18% Spell Crit, +3.9 Dmg)

Stat Summary:
  * Summarizes all the stats from the item itself, enchants and gems, converts them to base stats and displays the total value and/or difference from your current equipped item.
  * Ex: Crit Chance - Adds up agility and crit rating from the item, enchant and gem. Converts agility and crit rating to crit chance, and displays the total in a single value.

Item Level and Item ID:
  * Item Level is obtained from the WoW API, not a calculated value.
  * Item ID is useful for advanced users.

Supports talents, buffs and racials that modify your stats for all classes.

Fully customizable, decide what you need to see and what you don't want.


## Auto fill gems in empty sockets
1. You can set the default gems for each type of empty socket using "/rb sum gem <red|yellow|blue|meta> <ItemID|Link>" or using the options window.
2. To specify the gem of your choice, you will need to give RatingBuster the ItemLink or the ItemID of the gem.
3. ItemLink example: type "/rb sum gem blue " (last char is a space) and link the gem (from your bags, AH, ItemSync or whatever), then press <enter>.
4. What if you can't link the gem? Well thats what ItemID is for. Find your gem on http://www.wowhead.com/ and look at the URL,
   for example "http://www.wowhead.com/?item=32193", 32193 is the ItemID for that gem.
   Go back in wow, type "/rb sum gem red 32193" and press <enter>.

Note1: If you have "/rb sum ignore gem" on, the auto fill gems won't work.
Note2: Meta gem conditions and SetBonuses work, so if you don't meet the conditions, StatSummary won't count them.
Note3: RatingBuster will only auto fill empty sockets, if the item already has some gems on it, it will remain.
Note4: Empty sockets filled by RatingBuster will keep the "Empty Socket Icon" so you can still easily tell what color socket it is.
Note5: Gem text filled by RatingBuster will be shown in gray color to differentiate from real gems.


## Supported Addons

EquipCompare, EQCompare, tekKompare.
LinkWrangler, MultiTips, Links.
AtlasLoot, ItemMagic, Sniff.

will work with all bag mods too!


## Options

Type /rb or /ratingbuster

/rb : Display command help
/rb standby : Toggle disable/enable RatingBuster in game, defaults Enable
/rb level (0-73) : Set the level used in calculations, defaults 0 (0 = your level)
/rb itemlevel : Toggle show/hide ItemLevel, defaults Show
/rb itemid : Toggle show/hide ItemID, defaults Hide
/rb usereqlv : Toggle calculate using the required level if you are below the required level, defaults Off
/rb statmod : Toggle support for talent and buff mods, defaults On

/rb rating : Options for Rating Conversion
/rb rating show : Toggle show/hide Rating Conversion in tooltips, defaults Show
/rb rating def : Toggle Defense breakdown, Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block, defaults Off
/rb rating wpn : Toggle Weapon Skill breakdown, Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect, defaults Off
/rb rating color enable : Toggle enable/disable colored text, defaults On
/rb rating color pick : Choose a color for the added text, defaults Light Yellow

/rb stat : Options for Stat Breakdown
/rb stat show : Toggle show/hide Stat Breakdown in tooltips, defaults Show
/rb stat str : Options for Strength breakdown -> AP, Block, Healing(Talent)
/rb stat agi : Options for Agility breakdown -> Crit, Dodge, AP, RAP, Armor
/rb stat sta : Options for Stamina breakdown -> Health, SpellDmg(Talent)
/rb stat int : Options for Intellect breakdown -> Mana, SpellCrit, SpellDmg(Talent), Healing(Talent), MP5(Talent), RAP(Talent), Armor(Talent)
/rb stat spi : Options for Spirit breakdown -> MP5(Talent), MP5NC, HP5, SpellDmg(Talent), Healing(Talent)

/rb sum : Options for Stat Summary
/rb sum show : Toggle show/hide Stat Summary in tooltips, defaults Show
/rb sum ignore unused : Show stat summary only for armor types you will and can use, and on items with uncommon quality and up, defaults On
/rb sum ignore equipped : Hide stat summary for equipped items, defaults Off
/rb sum ignore enchant : Ignore enchants on items when calculating the stat summary, defaults Off
/rb sum ignore gem : Ignore gems on items when calculating the stat summary, defaults Off
/rb sum diffstyle : Display diff values in the main tooltip or only in compare tooltips, defaults Main
/rb sum space : Add a blank line before stat summary for readability, defaults On
/rb sum showzerostat : Show zero value stats in summary for consistency, defaults Off
/rb sum calcsum : Calculate the total stats for the item, defaults On
/rb sum calcdiff : Calculate the stat difference for the item and equipped items, defaults On
/rb sum stat : Choose which base stats you'd like to see in the summary
	- Health - HEALTH, STA
	- Mana - MANA, INT
	- Attack Power - AP, STR, AGI
	- Ranged Attack Power - RANGED_AP, INT, AP, STR, AGI
	- Feral Attack Power - FERAL_AP, AP, STR, AGI (Note: Shows Cat AP when in Cat form, and Bear AP in other forms)
	- Spell Damage - SPELL_DMG, STA, INT, SPI
	- Holy Damage - HOLY_SPELL_DMG, SPELL_DMG, INT, SPI
	- Arcane Damage - ARCANE_SPELL_DMG, SPELL_DMG, INT
	- Fire Damage - FIRE_SPELL_DMG, SPELL_DMG, STA, INT
	- Nature Damage - NATURE_SPELL_DMG, SPELL_DMG, INT
	- Frost Damage - FROST_SPELL_DMG, SPELL_DMG, INT
	- Shadow Damage - SHADOW_SPELL_DMG, SPELL_DMG, STA, INT, SPI
	- Healing - HEAL, STR, INT, SPI
	- Hit Chance - MELEE_HIT_RATING, WEAPON_RATING
	- Crit Chance - MELEE_CRIT_RATING, WEAPON_RATING, AGI
	- Spell Hit Chance - SPELL_HIT_RATING
	- Spell Crit Chance - SPELL_CRIT_RATING, INT
	- Mana Regen - MANA_REG, SPI
	- Health Regen - HEALTH_REG
	- Mana Regen Not Casting - MANA_REG, SPI
	- Health Regen While Casting - HEALTH_REG, SPI
	- Armor - ARMOR, ARMOR_BONUS, AGI, INT
	- Block Value - BLOCK_VALUE, STR
	- Dodge Chance - DODGE_RATING, DEFENSE_RATING, AGI
	- Parry Chance - PARRY_RATING, DEFENSE_RATING
	- Block Chance - BLOCK_RATING, DEFENSE_RATING
	- Hit Avoidance - DEFENSE_RATING, MELEE_HIT_AVOID_RATING
	- Crit Avoidance - DEFENSE_RATING, RESILIENCE_RATING, MELEE_CRIT_AVOID_RATING
	- Dodge Neglect - WEAPON_RATING
	- Parry Neglect - WEAPON_RATING
	- Block Neglect - WEAPON_RATING
	- Arcane Resistance - ARCANE_RES
	- Fire Resistance - FIRE_RES
	- Nature Resistance - NATURE_RES
	- Frost Resistance - FROST_RES
	- Shadow Resistance - SHADOW_RES
	- Weapon Max Damage - MAX_DAMAGE
/rb sum statcomp : Choose which composite stats you'd like to see in the summary
	- Strength - STR
	- Agility - AGI
	- Stamina - STA
	- Intellect - INT
	- Spirit - SPI
	- Defense - DEFENSE_RATING
	- Weapon Skill - WEAPON_RATING
