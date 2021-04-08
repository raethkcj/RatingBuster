--[[
Name: RatingBuster frFR locale (incomplete)
Revision: $Revision: 73696 $
Translated by:
- Tixu@Curse
- Silaor
- renchap
]]
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "frFR")
----
-- This file is coded in UTF-8
-- If you don't have a editor that can save in UTF-8, I recommend Ultraedit
----
---------------------------
-- Slash Command Options --
---------------------------
-- /rb statmod
L["Enable Stat Mods"] = "Activer les Stat Mods"
L["Enable support for Stat Mods"] = "Activer le support pour Stat Mods"
-- /rb itemid
L["Show ItemID"] = "Voire l'ID de l'objet"
L["Show the ItemID in tooltips"] = "Montrer l'ID d'un objet dans l'infobulle"
-- /rb itemlevel
L["Show ItemLevel"] = "Voire le niveau de l'objet"
L["Show the ItemLevel in tooltips"] = "Montre le niveau de l'objet dans l'infobulle"
-- /rb usereqlv
L["Use required level"] = "Utiliser le niveau requis"
L["Calculate using the required level if you are below the required level"] = "Effectue les calculs en utilisant le niveau requis par l'objet si il n'est pas atteint"
-- /rb setlevel
L["Set level"] = "Définir le niveau"
L["Set the level used in calculations (0 = your level)"] = "Définit le niveau utilisé dans les calculs (0 = votre niveau)"
-- /rb color
L["Change text color"] = "Changer la couleur du texte"
L["Changes the color of added text"] = "Change la couleur du texte ajouté"
-- /rb color pick
L["Pick color"] = "Choix de la couleur"
L["Pick a color"] = "Choisissez une couleur"
-- /rb color enable
L["Enable color"] = "Activer la couleur"
L["Enable colored text"] = "Active le texte coloré"
-- /rb rating
L["Rating"] = "Score"
L["Options for Rating display"] = "Options pour l'affichage des scores"
-- /rb rating show
L["Show Rating conversions"] = "Montrer la conversion des scores"
L["Show Rating conversions in tooltips"] = "Montre dans l'infobulle les gains apportés par le score"
-- /rb rating def
L["Defense breakdown"] = "Détailler la défense"
L["Convert Defense into Crit Avoidance Hit Avoidance, Dodge, Parry and Block"] = "Convertit le score de défense en Défense Crit, Défense Coup, Esquive, Parade et Bloquage",
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Détailler la compétence d'arme"
L["Convert Weapon Skill into Crit Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convertit la compétence d'arme en Critique, Toucher, Ignorer Esquive, Ignorer Parade, Ignorer Bloquage",

-- /rb stat
--["Stat Breakdown"] = "Carac",
L["Changes the display of base stats"] = "Change l'affichage des caractéristiques de base"
-- /rb stat show
L["Show base stat conversions"] = "Montrer les conversions pour les caracs"
L["Show base stat conversions in tooltips"] = "Montre dans l'infobulle les caracs converties"
-- /rb stat str
L["Strength"] = "Force"
L["Changes the display of Strength"] = "Change l'affichage de la Force"
-- /rb stat str ap
L["Show Attack Power"] = "Montrer la PA"
L["Show Attack Power from Strength"] = "Montre la Puissance d'Attaque apporté par la Force"
-- /rb stat str block
L["Show Block Value"] = "Montrer le Bloquage"
L["Show Block Value from Strength"] = "Montre le Bloquage apporté par la Force"
-- /rb stat str dmg
L["Show Spell Damage"] = "Montrer les Dégats des Sorts"
L["Show Spell Damage from Strength"] = "Montre le Bonus de Dégats des Sorts apporté par la Force"
-- /rb stat str heal
L["Show Healing"] = "Montrer les Soins"
L["Show Healing from Strength"] = "Montre le Bonus aux Soins apportés par la Force"

-- /rb stat agi
L["Agility"] = "Agilité"
L["Changes the display of Agility"] = "Change l'affichage de l'Agilité"
-- /rb stat agi crit
L["Show Crit"] = "Montrer le %Crit"
L["Show Crit chance from Agility"] = "Montre le pourcentage de critique apporté par l'Agilité"
-- /rb stat agi dodge
L["Show Dodge"] = "Montrer l'Esquive"
L["Show Dodge chance from Agility"] = "Montre les chances d'Esquive apportées par l'Agilité"
-- /rb stat agi ap
L["Show Attack Power"] = "Montrer la PA"
L["Show Attack Power from Agility"] = "Montre la Puissance d'Attaque apporté par l'Agilité"
-- /rb stat agi rap
L["Show Ranged Attack Power"] = "Montrer la PA à Distance"
L["Show Ranged Attack Power from Agility"] = "Montre la Puissance d'Attaque à Distance apporté par l'Agilité"
-- /rb stat agi armor
L["Show Armor"] = "Montrer l'Armure"
L["Show Armor from Agility"] = "Montre l'Armure apportée par l'Agilité"
-- /rb stat agi heal
L["Show Healing"] = "Montrer les Soins"
L["Show Healing from Agility"] = "Montre le bonus aux Soins apporté par l'Agilité"

-- /rb stat sta
L["Stamina"] = "Endurance"
L["Changes the display of Stamina"] = "Change l'affichage de l'Endurance"
-- /rb stat sta hp
L["Show Health"] = "Montrer les PV"
L["Show Health from Stamina"] = "Montre les Points de Vie apportés par l'Endurance"
-- /rb stat sta dmg
L["Show Spell Damage"] = "Montrer les Dégats des Sorts"
L["Show Spell Damage from Stamina"] = "Montre le bonus de Dégats des Sorts apporté par l'Endurance"

-- /rb stat int
L["Intellect"] = "Intelligence"
L["Changes the display of Intellect"] = "Change l'affichage de l'Intelligence"
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Montrer le %Crit des Sorts"
L["Show Spell Crit chance from Intellect"] = "Montre le Pourcentage de Critique des Sorts apporté par l'Intelligence"
-- /rb stat int mp
L["Show Mana"] = "Montrer les PM"
L["Show Mana from Intellect"] = "Montre les Points de Mana apportés par l'Intelligence"
-- /rb stat int dmg
L["Show Spell Damage"] = "Montrer les Dégats des Sorts"
L["Show Spell Damage from Intellect"] = "Montre le Bonus de Dégats des Sorts apporté par l'Intelligence"
-- /rb stat int heal
L["Show Healing"] = "Montrer les Soins"
L["Show Healing from Intellect"] = "Montre le Bonus aux Soins apportés par l'Intelligence"
-- /rb stat int mp5
L["Show Mana Regen"] = "Montrer la Regen Mana"
L["Show Mana Regen while casting from Intellect"] = "Montre la Régénération de Mana pendant incantation apportée par l'Intelligence"
-- /rb stat int mp5nc
--["Show Mana Regen while NOT casting"] = true,
--["Show Mana Regen while NOT casting from Intellect"] = true,
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Montre la PA à Distance"
L["Show Ranged Attack Power from Intellect"] = "Montre la Puissance d'Attaque à Distance apportée par l'Intelligence"
-- /rb stat int armor
L["Show Armor"] = "Montrer l'Armure"
L["Show Armor from Intellect"] = "Montre l'Armure apportée par l'Intelligence"

-- /rb stat spi
L["Spirit"] = "Esprit"
L["Changes the display of Spirit"] = "Change l'affichage de l'Esprit"
-- /rb stat spi mp5
L["Show Mana Regen"] = "Montrer la Regen Mana"
L["Show Mana Regen while casting from Spirit"] = "Montre la Régénération de Mana pendant incantation apportée par l'Esprit"
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Montrer la Regen Mana (HI)"
L["Show Mana Regen while NOT casting from Spirit"] = "Montre la Régénération de Mana HORS INCANTATION apportée par l'Epsrit"
-- /rb stat spi hp5
L["Show Health Regen"] = "Montrer la Regen PV"
L["Show Health Regen from Spirit"] = "Montre la Régénération des Points de Vie apportée par l'Esprit"
-- /rb stat spi dmg
L["Show Spell Damage"] = "Montrer les Dégats des Sorts"
L["Show Spell Damage from Spirit"] = "Montre le Bonus aux Soins apportés par l'Esprit"
-- /rb stat spi heal
L["Show Healing"] = "Montrer les Soins"
L["Show Healing from Spirit"] = "Montre le Bonus aux Soins apportés par l'Esprit"

-- /rb sum
L["Stat Summary"] = "Résumé des Stats"
L["Options for stat summary"] = "Options pour le Résumé"
-- /rb sum show
L["Show stat summary"] = "Montrer le Résumé"
L["Show stat summary in tooltips"] = "Montre le Résumé des Statistiques de combat dans l'infobulle"
-- /rb sum ignore
L["Ignore settings"] = "Paramètres à ignorer"
L["Ignore stuff when calculating the stat summary"] = "Choisir quoi ignorer lors du calcul du résumé de stats"
-- /rb sum ignore unused
L["Ignore unused items types"] = "Ignorer les types d'objets non utilisés"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Montre les statistiques uniquement pour les plus hauts rangs d'armure et pour des objets de qualité au moins Inhabituel"
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Ignorer les objets équipés"
L["Hide stat summary for equipped items"] = "Cache le résumé pour les objets équipés"
-- /rb sum ignore enchant
L["Ignore enchants"] = "Ignorer les Enchantements"
L["Ignore enchants on items when calculating the stat summary"] = "Ignore les bonus d'Enchantement lors du calcul du résumé"
-- /rb sum ignore gem
L["Ignore gems"] = "Ignorer les Gemmes"
L["Ignore gems on items when calculating the stat summary"] = "Ignore les bonus des Gemmes lors du calcul du résumé"
-- /rb sum diffstyle
L["Display style for diff value"] = "Style d'affichage du résumé"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Afficher les différences dans l'infobulle principale ou dans l'infobulle de comparaison"
--[[TODO
-- /rb sum space
L["Add empty line"] = true
L["Add a empty line before or after stat summary"] = true
-- /rb sum space before
L["Add before summary"] = true
L["Add a empty line before stat summary"] = true
-- /rb sum space after
L["Add after summary"] = true
L["Add a empty line after stat summary"] = true
-- /rb sum icon
L["Show icon"] = true
L["Show the sigma icon before summary listing"] = true
-- /rb sum title
L["Show title text"] = true
L["Show the title text before summary listing"] = true
--]]
-- /rb sum showzerostat
L["Show zero value stats"] = "Montrer les stats nulles"
L["Show zero value stats in summary for consistancy"] = "Montre les stats nulles pour plus de cohérence"
-- /rb sum calcsum
L["Calculate stat sum"] = "Calculer les cumuls"
L["Calculate the total stats for the item"] = "Fait un cumul des stats pour l'objet"
-- /rb sum calcdiff
L["Calculate stat diff"] = "Calculer les différences"
L["Calculate the stat difference for the item and equipped items"] = "Fait le calcul des différences avec l'objet équipé"
-- /rb sum stat
--["Stat - Base"] = "Stat Base",
--["Choose base stats for summary"] = "Choisir les Stats de base pour le Résumé",
-- /rb sum stat hp
L["Sum Health"] = "Cumul Vie"
L["Health <- Health Stamina"] = "Vie <- Vie, Endu",
-- /rb sum stat mp
L["Sum Mana"] = "Cumul Mana"
L["Mana <- Mana Intellect"] = "Mana <- Mana, Intel",
-- /rb sum stat ap
L["Sum Attack Power"] = "Cumul PA"
L["Attack Power <- Attack Power Strength, Agility"] = "PA <- PA, Force, Agi",
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "Cumul PA Dist"
L["Ranged Attack Power <- Ranged Attack Power Intellect, Attack Power, Strength, Agility"] = "PA Dist <- PA Dist, Intel, PA, Force, Agi",
-- /rb sum stat fap
L["Sum Feral Attack Power"] = "Cumul PA Farouche"
L["Feral Attack Power <- Feral Attack Power Attack Power, Strength, Agility"] = "PA Farouche <- PA Farouche, PA, Force, Agi",
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Cumul Dégats des Sorts"
L["Spell Damage <- Spell Damage Intellect, Spirit, Stamina"] = "Dégats des Sorts <- Dégats des Sorts, Intel, Esprit, Endu",
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Cumul DS Sacré"
L["Holy Spell Damage <- Holy Spell Damage Spell Damage, Intellect, Spirit"] = "DS Sacré <- DS Sacré, DS, Intel, Esprit",
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Cumul DS Arcane"
L["Arcane Spell Damage <- Arcane Spell Damage Spell Damage, Intellect"] = "DS Arcane <- DS Arcane, DS, Intel",
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Cumul DS Feu"
L["Fire Spell Damage <- Fire Spell Damage Spell Damage, Intellect, Stamina"] = "DS Feu <- DS Feu, DS, Intel, Endu",
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Cumul DS Nature"
L["Nature Spell Damage <- Nature Spell Damage Spell Damage, Intellect"] = "DS Nature <- DS Nature, DS, Intel",
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Cumul DS Givre"
L["Frost Spell Damage <- Frost Spell Damage Spell Damage, Intellect"] = "DS Givre <- DS Givre, DS, Intel",
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Cumul DS Ombre"
L["Shadow Spell Damage <- Shadow Spell Damage Spell Damage, Intellect, Spirit, Stamina"] = "DS Ombre <- DS Ombre, DS, Intel, Esprit, Endu",
-- /rb sum stat heal
L["Sum Healing"] = "Cumul Soins"
L["Healing <- Healing Intellect, Spirit, Agility, Strength"] = "Soins <- Soins, Intel, Esprit, Agi, Force",
-- /rb sum stat hit
L["Sum Hit Chance"] = "Cumul Toucher"
L["Hit Chance <- Hit Rating Weapon Skill Rating"] = "Toucher <- Toucher, Score Arme",
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Cumul Toucher des Sorts"
L["Spell Hit Chance <- Spell Hit Rating"] = "Toucher des Sorts <- Toucher des Sorts"
-- /rb sum stat crit
L["Sum Crit Chance"] = "Cumul Crit"
L["Crit Chance <- Crit Rating Agility, Weapon Skill Rating"] = "Crit <- %Crit, Agi, Comp Arme",
-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "Cumul Crit Sorts"
L["Spell Crit Chance <- Spell Crit Rating Intellect"] = "Crit Sorts <- %Crit Sorts, Intel",
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Cumul Regen Mana"
L["Mana Regen <- Mana Regen Spirit"] = "Regen Mana <- Regen Mana, Esprit",
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Cumul Regen Mana HI"
L["Mana Regen while not casting <- Spirit"] = "Regen Mana HI <- Esprit"
-- /rb sum stat hp5
L["Sum Health Regen"] = "Cumul Regen Vie"
L["Health Regen <- Health Regen"] = "Regen Vie <- Regen Vie"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Cumul Regen Vie HC"
L["Health Regen when out of combat <- Spirit"] = "Regen Vie HC <- Esprit"
-- /rb sum stat armor
L["Sum Armor"] = "Cumul Armure"
L["Armor <- Armor from items Armor from bonuses, Agility, Intellect"] = "Armure <- Armure Objets, Armure Bonus, Agi, Intel",
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Cumul Dégats Bloqués"
L["Block Value <- Block Value Strength"] = "Dégats Bloqués <- Dégats Bloqués, Force",
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Cumul Esquive"
L["Dodge Chance <- Dodge Rating Agility, Defense Rating"] = "Esquive <- Score Esquive, Agi, Score Def",
-- /rb sum stat parry
L["Sum Parry Chance"] = "Cumul Parade"
L["Parry Chance <- Parry Rating Defense Rating"] = "Parade <- Score Parade, Score Def",
-- /rb sum stat block
L["Sum Block Chance"] = "Cumul Bloquage"
L["Block Chance <- Block Rating Defense Rating"] = "Bloquage <- Score Bloquage, Score Def",
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Cumul Raté"
L["Hit Avoidance <- Defense Rating"] = "Raté <- Score Def"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "Cumul Def Crit"
L["Crit Avoidance <- Defense Rating Resilience"] = "Def Crit <- Score Def, Resilience",
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Cumul Ignore Esquive"
--["Dodge Neglect <- Weapon Skill Rating"] = "Ignore Esquive <- Score Arme",
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Cumul Ignore Parade"
--["Parry Neglect <- Weapon Skill Rating"] = "Ignore Parade <- Score Arme",
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Cumul Ignore Bloquage"
L["Block Neglect <- Weapon Skill Rating"] = "Ignore Bloquage <- Score Arme"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Cumul RA"
L["Arcane Resistance Summary"] = "Résumé de la RA"
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Cumul RF"
L["Fire Resistance Summary"] = "Résumé de la Rf"
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Cumul RN"
L["Nature Resistance Summary"] = "Résumé de la RN"
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "Cumul RG"
L["Frost Resistance Summary"] = "Résumé de la RG"
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Cumul RO"
L["Shadow Resistance Summary"] = "Résumé de la RO"
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = "Cumul Dommage Arme Max"
L["Weapon Max Damage Summary"] = "Résumé du Dommage ax de l'Arme"
-- /rb sum stat weapondps
--["Sum Weapon DPS"] = true,
--["Weapon DPS Summary"] = true,
-- /rb sum statcomp
--["Stat - Composite"] = "Stats - Composées",
--["Choose composite stats for summary"] = "Choisir les Stats composées du résumé",
-- /rb sum statcomp str
L["Sum Strength"] = "Cumul Force"
L["Strength Summary"] = "Résumé de la Force"
-- /rb sum statcomp agi
L["Sum Agility"] = "Cumul Agi"
L["Agility Summary"] = "Résumé de l'Agilité"
-- /rb sum statcomp sta
L["Sum Stamina"] = "Cumul Endu"
L["Stamina Summary"] = "Résumé de l'Endurance"
-- /rb sum statcomp int
L["Sum Intellect"] = "Cumul Int"
L["Intellect Summary"] = "Résumé de l'Intelligence"
-- /rb sum statcomp spi
L["Sum Spirit"] = "Cumul Esprit"
L["Spirit Summary"] = "Résumé de l'Esprit"
-- /rb sum statcomp def
L["Sum Defense"] = "Cumul Def"
L["Defense <- Defense Rating"] = "Def <- Score def"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Cumul Comp Arme"
L["Weapon Skill <- Weapon Skill Rating"] = "Comp Arme <- Score Arme"

-- /rb sum gem
--["Gems"] = true,
--["Auto fill empty gem slots"] = true,
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
--["ItemID or Link of the gem you would like to auto fill"] = true,
--["<ItemID|Link>"] = true,
--["%s is now set to %s"] = true,
--["Queried server for Gem: %s. Try again in 5 secs."] = true,
-- /rb sum gem yellow
L["Yellow Socket"] = EMPTY_SOCKET_YELLOW
-- /rb sum gem blue
L["Blue Socket"] = EMPTY_SOCKET_BLUE
-- /rb sum gem meta
L["Meta Socket"] = EMPTY_SOCKET_META

----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Niveau Objet : "
L["ItemID: "] = "ID Objet : "
-----------------------
-- Matching Patterns --
-----------------------
["numberPatterns"] = {
	{pattern = " de (%d+)", addInfo = "AfterNumber",},
	{pattern = "(%d+) \195\160 votre ", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "ajoute (%d+) (à|au)", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
},
["separators"] = {
	"/", " et ", ",", "%. ",
},

["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "score de défense", id = CR_DEFENSE_SKILL},
	{pattern = "score d'esquive", id = CR_DODGE},
	{pattern = "score de blocage", id = CR_BLOCK}, -- block enchant: "+10 Shield Block Rating"
	{pattern = "score de parade", id = CR_PARRY},

	{pattern = "score de critique des sorts", id = CR_CRIT_SPELL},
	{pattern = "score de coup critique à distance", id = CR_CRIT_RANGED},
	{pattern = "score de coup critique", id = CR_CRIT_MELEE},

	{pattern = "score de toucher des sorts", id = CR_HIT_SPELL},
	{pattern = "score de toucher à distance", id = CR_HIT_RANGED},
	{pattern = "score de toucher", id = CR_HIT_MELEE},

	{pattern = "résilience", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating
	{pattern = "score d'évitement des coups", id = CR_HIT_TAKEN_MELEE},

	{pattern = "score de hâte des sorts", id = CR_HASTE_SPELL},
	{pattern = "score de hâte à distance", id = CR_HASTE_RANGED},
	{pattern = "score de hâte", id = CR_HASTE_MELEE},
	{pattern = "scores de vitesse", id = CR_HASTE_MELEE}, -- [Tambours de Bataille]


	{pattern = "score de la compétence dagues", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence epées", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence epées à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence haches", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence haches à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence masses", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence masses à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence armes d'hast", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence arcs", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence fusils", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence arbalètes", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence bâton", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence mains nues", id = CR_WEAPON_SKILL},

	--{pattern = "score de la compétence", id = CR_WEAPON_SKILL},
},
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% Crit"
L["$value% Spell Crit"] = "$value% Crit Sorts"
L["$value% Dodge"] = "$value% Esquive"
L["$value HP"] = "$value PV"
L["$value MP"] = "$value PM"
L["$value AP"] = "$value PA"
L["$value RAP"] = "$value PA Dist"
L["$value Dmg"] = "$value Dégats"
L["$value Heal"] = "$value Soins"
L["$value Armor"] = "$value Armure"
L["$value Block"] = "$value Blocage"
L["$value MP5"] = "$value Mana/5sec"
L["$value MP5(NC)"] = "$value Mana/5sec(HI)"
L["$value HP5"] = "$value Vie/5sec"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Résumé Stats"