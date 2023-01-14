# RatingBuster

![RatingBuster](https://user-images.githubusercontent.com/7716908/186707338-2bcf29cc-0529-4be9-9a4b-d29b621580fa.png)

RatingBuster converts combat ratings in your tooltips into percentages, so that you have more meaningful information when comparing different items.

The design aim of RatingBuster is to provide detailed, meaningful and customizable information about items so you can easily decide for yourself which item is better.

![image](https://user-images.githubusercontent.com/7716908/118906904-3ff4e380-b8e4-11eb-8fb5-a0b090d9e9c2.png)

Originally written by Whitetooth (https://github.com/hotdogee)

## Installation:
Available for download at:

[WoWInterface](https://www.wowinterface.com/downloads/info26235-RatingBusterClassic.html#info) | [Wago Addons](https://addons.wago.io/addons/ratingbuster) | [WowUp](https://wowup.io/addons/54151) | [GitHub Releases](https://github.com/raethkcj/RatingBuster/releases/latest)

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

Type `/rb` or `/ratingbuster` to open the options menu GUI, or add a slash command:

- `help` - Show help message
- `enableStatMods` - Enable support for Stat Mods
- `showItemID` - Show the ItemID in tooltips
- `showItemLevel` - Show the ItemLevel in tooltips
- `useRequiredLevel` - Calculate using the required level if you are below the required level
- `customLevel` - Set the level used in calculations (0 = your level)
- `rating` - Options for Rating display
	- `showRatings` - Show Rating conversions in tooltips
	- `detailedConversionText` - Show detailed text for Resilience and Expertise conversions
	- `defBreakDown` - Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block
	- `wpnBreakDown` - Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect
	- `expBreakDown` - Convert Expertise into Dodge Neglect and Parry Neglect
	- `color` - Changes the color of added text
		- `pick` - Pick a color
		- `enableTextColor` - Enable colored text
- `stat` - Changes the display of base stats
	- `showStats` - Show base stat conversions in tooltips
	- `str` - Changes the display of Strength
		- `showAPFromStr` - Show Attack Power from Strength
		- `showBlockValueFromStr` - Show Block Value from Strength
- `agi` - Changes the display of Agility
	- `showCritFromAgi` - Show Crit chance from Agility
	- `showDodgeFromAgi` - Show Dodge chance from Agility
	- `showAPFromAgi` - Show Attack Power from Agility
	- `showRAPFromAgi` - Show Ranged Attack Power from Agility
	- `showArmorFromAgi` - Show Armor from Agility
- `sta` - Changes the display of Stamina
	- `showHealthFromSta` - Show Health from Stamina
- `int` - Changes the display of Intellect
	- `showSpellCritFromInt` - Show Spell Crit chance from Intellect
	- `showManaFromInt` - Show Mana from Intellect
	- `showMP5FromInt` - Show Mana Regen while casting from Intellect
	- `showMP5NCFromInt` - Show Mana Regen while NOT casting from Intellect
- `spi` - Changes the display of Spirit
	- `showMP5NCFromSpi` - Show Mana Regen while NOT casting from Spirit
	- `showHP5FromSpi` - Show Health Regen from Spirit
- `sum` - Options for stat summary
	- `showSum` - Show stat summary in tooltips
	- `ignore` - Ignore stuff when calculating the stat summary
		- `sumIgnoreUnused` - Show stat summary only for highest level armor type and items you can use with uncommon quality and up
		- `sumIgnoreEquipped` - Hide stat summary for equipped items
		- `sumIgnoreEnchant` - Ignore enchants on items when calculating the stat summary
		- `sumIgnoreGems` - Ignore gems on items when calculating the stat summary
- `sumDiffStyle` - Display diff values in the main tooltip or only in compare tooltips
	values"comp", "main"}
- `space` - Add a empty line before or after stat summary
	- `sumBlankLine` - Add a empty line before stat summary
	- `sumBlankLineAfter` - Add a empty line after stat summary
- `sumShowIcon` - Show the sigma icon before summary listing
- `sumShowTitle` - Show the title text before summary listing
- `showZeroValueStat` - Show zero value stats in summary for consistancy
- `calcSum` - Calculate the total stats for the item
- `calcDiff` - Calculate the stat difference for the item and equipped items
- `sumSortAlpha` - Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)
- `sumAvoidWithBlock` - Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss
- `basic` - Choose basic stats for summary
	- `sumHP` - Health <- Health, Stamina
	- `sumMP` - Mana <- Mana, Intellect
	- `sumMP5` - Mana Regen <- Mana Regen, Spirit
	- `sumMP5NC` - Mana Regen while not casting <- Spirit
	- `sumHP5` - Health Regen <- Health Regen
	- `sumHP5OC` - Health Regen when out of combat <- Spirit
	- `sumStr` - Strength Summary
	- `sumAgi` - Agility Summary
	- `sumSta` - Stamina Summary
	- `sumInt` - Intellect Summary
	- `sumSpi` - Spirit Summary
- `physical` - Choose physical damage stats for summary
	- `sumAP` - Attack Power <- Attack Power, Strength, Agility
	- `sumRAP` - Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility
	- `sumFAP` - Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility
	- `sumHit` - Hit Chance <- Hit Rating, Weapon Skill Rating
	- `sumHitRating` - Hit Rating Summary
	- `sumCrit` - Crit Chance <- Crit Rating, Agility, Weapon Skill Rating
	- `sumCritRating` - Crit Rating Summary
	- `sumHaste` - Haste <- Haste Rating
	- `sumHasteRating` - Haste Rating Summary
	- `sumDodgeNeglect` - Dodge Neglect <- Expertise, Weapon Skill Rating
	- `sumParryNeglect` - Parry Neglect <- Expertise, Weapon Skill Rating
	- `sumBlockNeglect` - Block Neglect <- Weapon Skill Rating
	- `sumWeaponSkill` - Weapon Skill <- Weapon Skill Rating
	- `sumExpertise` - Expertise <- Expertise Rating
	- `sumWeaponMaxDamage` - Weapon Max Damage Summary
		- `weapondps` - Weapon DPS Summary
		- `sumIgnoreArmor` - Ignore Armor Summary
- `spell` - Choose spell damage and healing stats for summary
	- `sumSpellDmg` - Spell Damage <- Spell Damage, Intellect, Spirit, Stamina
	- `sumHolyDmg` - Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit
	- `sumArcaneDmg` - Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect
	- `sumFireDmg` - Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina
	- `sumNatureDmg` - Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect
	- `sumFrostDmg` - Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect
	- `sumShadowDmg` - Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina
	- `sumHealing` - Healing <- Healing, Intellect, Spirit, Agility, Strength
	- `sumSpellHit` - Spell Hit Chance <- Spell Hit Rating
	- `sumSpellHitRating` - Spell Hit Rating Summary
	- `sumSpellCrit` - Spell Crit Chance <- Spell Crit Rating, Intellect
	- `sumSpellCritRating` - Spell Crit Rating Summary
	- `sumSpellHaste` - Spell Haste <- Spell Haste Rating
	- `sumSpellHasteRating` - Spell Haste Rating Summary
	- `sumPenetration` - Spell Penetration Summary
- `tank` - Choose tank stats for summary
	- `sumArmor` - Armor <- Armor from items, Armor from bonuses, Agility, Intellect
	- `sumDefense` - Defense <- Defense Rating
	- `sumDodge` - Dodge Chance <- Dodge Rating, Agility, Defense Rating
	- `sumDodgeRating` - Dodge Rating Summary
	- `sumParry` - Parry Chance <- Parry Rating, Defense Rating
	- `sumParryRating` - Parry Rating Summary
	- `sumBlock` - Block Chance <- Block Rating, Defense Rating
	- `sumBlockRating` - Block Rating Summary
	- `sumBlockValue` - Block Value <- Block Value, Strength
	- `sumHitAvoid` - Hit Avoidance <- Defense Rating
	- `sumCritAvoid` - Crit Avoidance <- Defense Rating, Resilience
	- `sumResilience` - Resilience Summary
	- `sumArcaneResist` - Arcane Resistance Summary
	- `sumFireResist` - Fire Resistance Summary
	- `sumNatureResist` - Nature Resistance Summary
	- `sumFrostResist` - Frost Resistance Summary
	- `sumShadowResist` - Shadow Resistance Summary
	- `sumAvoidance` - Avoidance <- Dodge, Parry, MobMiss, Block(Optional)
- `gem` - Auto fill empty gem slots
	- `sumGemRed` - ItemID or Link of the gem you would like to auto fill
	- `sumGemYellow` - ItemID or Link of the gem you would like to auto fill
	- `sumGemBlue` - ItemID or Link of the gem you would like to auto fill
	- `sumGemMeta` - ItemID or Link of the gem you would like to auto fill
