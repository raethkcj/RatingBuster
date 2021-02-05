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
L:RegisterTranslations("frFR", function() return {
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /rb statmod
	["Enable Stat Mods"] = "Activer les Stat Mods",
	["Enable support for Stat Mods"] = "Activer le support pour Stat Mods",
	-- /rb itemid
	["Show ItemID"] = "Voire l'ID de l'objet",
	["Show the ItemID in tooltips"] = "Montrer l'ID d'un objet dans l'infobulle",
	-- /rb itemlevel
	["Show ItemLevel"] = "Voire le niveau de l'objet",
	["Show the ItemLevel in tooltips"] = "Montre le niveau de l'objet dans l'infobulle",
	-- /rb usereqlv
	["Use required level"] = "Utiliser le niveau requis",
	["Calculate using the required level if you are below the required level"] = "Effectue les calculs en utilisant le niveau requis par l'objet si il n'est pas atteint",
	-- /rb setlevel
	["Set level"] = "Définir le niveau",
	["Set the level used in calculations (0 = your level)"] = "Définit le niveau utilisé dans les calculs (0 = votre niveau)",
	-- /rb color
	["Change text color"] = "Changer la couleur du texte",
	["Changes the color of added text"] = "Change la couleur du texte ajouté",
	-- /rb color pick
	["Pick color"] = "Choix de la couleur",
	["Pick a color"] = "Choisissez une couleur",
	-- /rb color enable
	["Enable color"] = "Activer la couleur",
	["Enable colored text"] = "Active le texte coloré",
	-- /rb rating
	["Rating"] = "Score",
	["Options for Rating display"] = "Options pour l'affichage des scores",
	-- /rb rating show
	["Show Rating conversions"] = "Montrer la conversion des scores",
	["Show Rating conversions in tooltips"] = "Montre dans l'infobulle les gains apportés par le score",
	-- /rb rating def
	["Defense breakdown"] = "Détailler la défense",
	["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Convertit le score de défense en Défense Crit, Défense Coup, Esquive, Parade et Bloquage",
	-- /rb rating wpn
	["Weapon Skill breakdown"] = "Détailler la compétence d'arme",
	["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convertit la compétence d'arme en Critique, Toucher, Ignorer Esquive, Ignorer Parade, Ignorer Bloquage",
	
	-- /rb stat
	--["Stat Breakdown"] = "Carac",
	["Changes the display of base stats"] = "Change l'affichage des caractéristiques de base",
	-- /rb stat show
	["Show base stat conversions"] = "Montrer les conversions pour les caracs",
	["Show base stat conversions in tooltips"] = "Montre dans l'infobulle les caracs converties",
	-- /rb stat str
	["Strength"] = "Force",
	["Changes the display of Strength"] = "Change l'affichage de la Force",
	-- /rb stat str ap
	["Show Attack Power"] = "Montrer la PA",
	["Show Attack Power from Strength"] = "Montre la Puissance d'Attaque apporté par la Force",
	-- /rb stat str block
	["Show Block Value"] = "Montrer le Bloquage",
	["Show Block Value from Strength"] = "Montre le Bloquage apporté par la Force",
	-- /rb stat str dmg
	["Show Spell Damage"] = "Montrer les Dégats des Sorts",
	["Show Spell Damage from Strength"] = "Montre le Bonus de Dégats des Sorts apporté par la Force",
	-- /rb stat str heal
	["Show Healing"] = "Montrer les Soins",
	["Show Healing from Strength"] = "Montre le Bonus aux Soins apportés par la Force",
	
	-- /rb stat agi
	["Agility"] = "Agilité",
	["Changes the display of Agility"] = "Change l'affichage de l'Agilité",
	-- /rb stat agi crit
	["Show Crit"] = "Montrer le %Crit",
	["Show Crit chance from Agility"] = "Montre le pourcentage de critique apporté par l'Agilité",
	-- /rb stat agi dodge
	["Show Dodge"] = "Montrer l'Esquive",
	["Show Dodge chance from Agility"] = "Montre les chances d'Esquive apportées par l'Agilité",
	-- /rb stat agi ap
	["Show Attack Power"] = "Montrer la PA",
	["Show Attack Power from Agility"] = "Montre la Puissance d'Attaque apporté par l'Agilité",
	-- /rb stat agi rap
	["Show Ranged Attack Power"] = "Montrer la PA à Distance",
	["Show Ranged Attack Power from Agility"] = "Montre la Puissance d'Attaque à Distance apporté par l'Agilité",
	-- /rb stat agi armor
	["Show Armor"] = "Montrer l'Armure",
	["Show Armor from Agility"] = "Montre l'Armure apportée par l'Agilité",
	-- /rb stat agi heal
	["Show Healing"] = "Montrer les Soins",
	["Show Healing from Agility"] = "Montre le bonus aux Soins apporté par l'Agilité",
	
	-- /rb stat sta
	["Stamina"] = "Endurance",
	["Changes the display of Stamina"] = "Change l'affichage de l'Endurance",
	-- /rb stat sta hp
	["Show Health"] = "Montrer les PV",
	["Show Health from Stamina"] = "Montre les Points de Vie apportés par l'Endurance",
	-- /rb stat sta dmg
	["Show Spell Damage"] = "Montrer les Dégats des Sorts",
	["Show Spell Damage from Stamina"] = "Montre le bonus de Dégats des Sorts apporté par l'Endurance",
	
	-- /rb stat int
	["Intellect"] = "Intelligence",
	["Changes the display of Intellect"] = "Change l'affichage de l'Intelligence",
	-- /rb stat int spellcrit
	["Show Spell Crit"] = "Montrer le %Crit des Sorts",
	["Show Spell Crit chance from Intellect"] = "Montre le Pourcentage de Critique des Sorts apporté par l'Intelligence",
	-- /rb stat int mp
	["Show Mana"] = "Montrer les PM",
	["Show Mana from Intellect"] = "Montre les Points de Mana apportés par l'Intelligence",
	-- /rb stat int dmg
	["Show Spell Damage"] = "Montrer les Dégats des Sorts",
	["Show Spell Damage from Intellect"] = "Montre le Bonus de Dégats des Sorts apporté par l'Intelligence",
	-- /rb stat int heal
	["Show Healing"] = "Montrer les Soins",
	["Show Healing from Intellect"] = "Montre le Bonus aux Soins apportés par l'Intelligence",
	-- /rb stat int mp5
	["Show Mana Regen"] = "Montrer la Regen Mana",
	["Show Mana Regen while casting from Intellect"] = "Montre la Régénération de Mana pendant incantation apportée par l'Intelligence",
	-- /rb stat int mp5nc
	--["Show Mana Regen while NOT casting"] = true,
	--["Show Mana Regen while NOT casting from Intellect"] = true,
	-- /rb stat int rap
	["Show Ranged Attack Power"] = "Montre la PA à Distance",
	["Show Ranged Attack Power from Intellect"] = "Montre la Puissance d'Attaque à Distance apportée par l'Intelligence",
	-- /rb stat int armor
	["Show Armor"] = "Montrer l'Armure",
	["Show Armor from Intellect"] = "Montre l'Armure apportée par l'Intelligence",
	
	-- /rb stat spi
	["Spirit"] = "Esprit",
	["Changes the display of Spirit"] = "Change l'affichage de l'Esprit",
	-- /rb stat spi mp5
	["Show Mana Regen"] = "Montrer la Regen Mana",
	["Show Mana Regen while casting from Spirit"] = "Montre la Régénération de Mana pendant incantation apportée par l'Esprit",
	-- /rb stat spi mp5nc
	["Show Mana Regen while NOT casting"] = "Montrer la Regen Mana (HI)",
	["Show Mana Regen while NOT casting from Spirit"] = "Montre la Régénération de Mana HORS INCANTATION apportée par l'Epsrit",
	-- /rb stat spi hp5
	["Show Health Regen"] = "Montrer la Regen PV",
	["Show Health Regen from Spirit"] = "Montre la Régénération des Points de Vie apportée par l'Esprit",
	-- /rb stat spi dmg
	["Show Spell Damage"] = "Montrer les Dégats des Sorts",
	["Show Spell Damage from Spirit"] = "Montre le Bonus aux Soins apportés par l'Esprit",
	-- /rb stat spi heal
	["Show Healing"] = "Montrer les Soins",
	["Show Healing from Spirit"] = "Montre le Bonus aux Soins apportés par l'Esprit",
	
	-- /rb sum
	["Stat Summary"] = "Résumé des Stats",
	["Options for stat summary"] = "Options pour le Résumé",
	-- /rb sum show
	["Show stat summary"] = "Montrer le Résumé",
	["Show stat summary in tooltips"] = "Montre le Résumé des Statistiques de combat dans l'infobulle",
	-- /rb sum ignore
	["Ignore settings"] = "Paramètres à ignorer",
	["Ignore stuff when calculating the stat summary"] = "Choisir quoi ignorer lors du calcul du résumé de stats",
	-- /rb sum ignore unused
	["Ignore unused items types"] = "Ignorer les types d'objets non utilisés",
	["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Montre les statistiques uniquement pour les plus hauts rangs d'armure et pour des objets de qualité au moins Inhabituel",
	-- /rb sum ignore equipped
	["Ignore equipped items"] = "Ignorer les objets équipés",
	["Hide stat summary for equipped items"] = "Cache le résumé pour les objets équipés",
	-- /rb sum ignore enchant
	["Ignore enchants"] = "Ignorer les Enchantements",
	["Ignore enchants on items when calculating the stat summary"] = "Ignore les bonus d'Enchantement lors du calcul du résumé",
	-- /rb sum ignore gem
	["Ignore gems"] = "Ignorer les Gemmes",
	["Ignore gems on items when calculating the stat summary"] = "Ignore les bonus des Gemmes lors du calcul du résumé",
	-- /rb sum diffstyle
	["Display style for diff value"] = "Style d'affichage du résumé",
	["Display diff values in the main tooltip or only in compare tooltips"] = "Afficher les différences dans l'infobulle principale ou dans l'infobulle de comparaison",
	--[[TODO
	-- /rb sum space
	["Add empty line"] = true,
	["Add a empty line before or after stat summary"] = true,
	-- /rb sum space before
	["Add before summary"] = true,
	["Add a empty line before stat summary"] = true,
	-- /rb sum space after
	["Add after summary"] = true,
	["Add a empty line after stat summary"] = true,
	-- /rb sum icon
	["Show icon"] = true,
	["Show the sigma icon before summary listing"] = true,
	-- /rb sum title
	["Show title text"] = true,
	["Show the title text before summary listing"] = true,
	--]]
	-- /rb sum showzerostat
	["Show zero value stats"] = "Montrer les stats nulles",
	["Show zero value stats in summary for consistancy"] = "Montre les stats nulles pour plus de cohérence",
	-- /rb sum calcsum
	["Calculate stat sum"] = "Calculer les cumuls",
	["Calculate the total stats for the item"] = "Fait un cumul des stats pour l'objet",
	-- /rb sum calcdiff
	["Calculate stat diff"] = "Calculer les différences",
	["Calculate the stat difference for the item and equipped items"] = "Fait le calcul des différences avec l'objet équipé",
	-- /rb sum stat
	--["Stat - Base"] = "Stat Base",
	--["Choose base stats for summary"] = "Choisir les Stats de base pour le Résumé",
	-- /rb sum stat hp
	["Sum Health"] = "Cumul Vie",
	["Health <- Health, Stamina"] = "Vie <- Vie, Endu",
	-- /rb sum stat mp
	["Sum Mana"] = "Cumul Mana",
	["Mana <- Mana, Intellect"] = "Mana <- Mana, Intel",
	-- /rb sum stat ap
	["Sum Attack Power"] = "Cumul PA",
	["Attack Power <- Attack Power, Strength, Agility"] = "PA <- PA, Force, Agi",
	-- /rb sum stat rap
	["Sum Ranged Attack Power"] = "Cumul PA Dist",
	["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "PA Dist <- PA Dist, Intel, PA, Force, Agi",
	-- /rb sum stat fap
	["Sum Feral Attack Power"] = "Cumul PA Farouche",
	["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "PA Farouche <- PA Farouche, PA, Force, Agi",
	-- /rb sum stat dmg
	["Sum Spell Damage"] = "Cumul Dégats des Sorts",
	["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Dégats des Sorts <- Dégats des Sorts, Intel, Esprit, Endu",
	-- /rb sum stat dmgholy
	["Sum Holy Spell Damage"] = "Cumul DS Sacré",
	["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "DS Sacré <- DS Sacré, DS, Intel, Esprit",
	-- /rb sum stat dmgarcane
	["Sum Arcane Spell Damage"] = "Cumul DS Arcane",
	["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "DS Arcane <- DS Arcane, DS, Intel",
	-- /rb sum stat dmgfire
	["Sum Fire Spell Damage"] = "Cumul DS Feu",
	["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "DS Feu <- DS Feu, DS, Intel, Endu",
	-- /rb sum stat dmgnature
	["Sum Nature Spell Damage"] = "Cumul DS Nature",
	["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "DS Nature <- DS Nature, DS, Intel",
	-- /rb sum stat dmgfrost
	["Sum Frost Spell Damage"] = "Cumul DS Givre",
	["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "DS Givre <- DS Givre, DS, Intel",
	-- /rb sum stat dmgshadow
	["Sum Shadow Spell Damage"] = "Cumul DS Ombre",
	["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "DS Ombre <- DS Ombre, DS, Intel, Esprit, Endu",
	-- /rb sum stat heal
	["Sum Healing"] = "Cumul Soins",
	["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Soins <- Soins, Intel, Esprit, Agi, Force",
	-- /rb sum stat hit
	["Sum Hit Chance"] = "Cumul Toucher",
	["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Toucher <- Toucher, Score Arme",
	-- /rb sum stat hitspell
	["Sum Spell Hit Chance"] = "Cumul Toucher des Sorts",
	["Spell Hit Chance <- Spell Hit Rating"] = "Toucher des Sorts <- Toucher des Sorts",
	-- /rb sum stat crit
	["Sum Crit Chance"] = "Cumul Crit",
	["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Crit <- %Crit, Agi, Comp Arme",
	-- /rb sum stat critspell
	["Sum Spell Crit Chance"] = "Cumul Crit Sorts",
	["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Crit Sorts <- %Crit Sorts, Intel",
	-- /rb sum stat mp5
	["Sum Mana Regen"] = "Cumul Regen Mana",
	["Mana Regen <- Mana Regen, Spirit"] = "Regen Mana <- Regen Mana, Esprit",
	-- /rb sum stat mp5nc
	["Sum Mana Regen while not casting"] = "Cumul Regen Mana HI",
	["Mana Regen while not casting <- Spirit"] = "Regen Mana HI <- Esprit",
	-- /rb sum stat hp5
	["Sum Health Regen"] = "Cumul Regen Vie",
	["Health Regen <- Health Regen"] = "Regen Vie <- Regen Vie",
	-- /rb sum stat hp5oc
	["Sum Health Regen when out of combat"] = "Cumul Regen Vie HC",
	["Health Regen when out of combat <- Spirit"] = "Regen Vie HC <- Esprit",
	-- /rb sum stat armor
	["Sum Armor"] = "Cumul Armure",
	["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Armure <- Armure Objets, Armure Bonus, Agi, Intel",
	-- /rb sum stat blockvalue
	["Sum Block Value"] = "Cumul Dégats Bloqués",
	["Block Value <- Block Value, Strength"] = "Dégats Bloqués <- Dégats Bloqués, Force",
	-- /rb sum stat dodge
	["Sum Dodge Chance"] = "Cumul Esquive",
	["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Esquive <- Score Esquive, Agi, Score Def",
	-- /rb sum stat parry
	["Sum Parry Chance"] = "Cumul Parade",
	["Parry Chance <- Parry Rating, Defense Rating"] = "Parade <- Score Parade, Score Def",
	-- /rb sum stat block
	["Sum Block Chance"] = "Cumul Bloquage",
	["Block Chance <- Block Rating, Defense Rating"] = "Bloquage <- Score Bloquage, Score Def",
	-- /rb sum stat avoidhit
	["Sum Hit Avoidance"] = "Cumul Raté",
	["Hit Avoidance <- Defense Rating"] = "Raté <- Score Def",
	-- /rb sum stat avoidcrit
	["Sum Crit Avoidance"] = "Cumul Def Crit",
	["Crit Avoidance <- Defense Rating, Resilience"] = "Def Crit <- Score Def, Resilience",
	-- /rb sum stat neglectdodge
	["Sum Dodge Neglect"] = "Cumul Ignore Esquive",
	--["Dodge Neglect <- Weapon Skill Rating"] = "Ignore Esquive <- Score Arme",
	-- /rb sum stat neglectparry
	["Sum Parry Neglect"] = "Cumul Ignore Parade",
	--["Parry Neglect <- Weapon Skill Rating"] = "Ignore Parade <- Score Arme",
	-- /rb sum stat neglectblock
	["Sum Block Neglect"] = "Cumul Ignore Bloquage",
	["Block Neglect <- Weapon Skill Rating"] = "Ignore Bloquage <- Score Arme",
	-- /rb sum stat resarcane
	["Sum Arcane Resistance"] = "Cumul RA",
	["Arcane Resistance Summary"] = "Résumé de la RA",
	-- /rb sum stat resfire
	["Sum Fire Resistance"] = "Cumul RF",
	["Fire Resistance Summary"] = "Résumé de la Rf",
	-- /rb sum stat resnature
	["Sum Nature Resistance"] = "Cumul RN",
	["Nature Resistance Summary"] = "Résumé de la RN",
	-- /rb sum stat resfrost
	["Sum Frost Resistance"] = "Cumul RG",
	["Frost Resistance Summary"] = "Résumé de la RG",
	-- /rb sum stat resshadow
	["Sum Shadow Resistance"] = "Cumul RO",
	["Shadow Resistance Summary"] = "Résumé de la RO",
	-- /rb sum stat maxdamage
	["Sum Weapon Max Damage"] = "Cumul Dommage Arme Max",
	["Weapon Max Damage Summary"] = "Résumé du Dommage ax de l'Arme",
	-- /rb sum stat weapondps
	--["Sum Weapon DPS"] = true,
	--["Weapon DPS Summary"] = true,
	-- /rb sum statcomp
	--["Stat - Composite"] = "Stats - Composées",
	--["Choose composite stats for summary"] = "Choisir les Stats composées du résumé",
	-- /rb sum statcomp str
	["Sum Strength"] = "Cumul Force",
	["Strength Summary"] = "Résumé de la Force",
	-- /rb sum statcomp agi
	["Sum Agility"] = "Cumul Agi",
	["Agility Summary"] = "Résumé de l'Agilité",
	-- /rb sum statcomp sta
	["Sum Stamina"] = "Cumul Endu",
	["Stamina Summary"] = "Résumé de l'Endurance",
	-- /rb sum statcomp int
	["Sum Intellect"] = "Cumul Int",
	["Intellect Summary"] = "Résumé de l'Intelligence",
	-- /rb sum statcomp spi
	["Sum Spirit"] = "Cumul Esprit",
	["Spirit Summary"] = "Résumé de l'Esprit",
	-- /rb sum statcomp def
	["Sum Defense"] = "Cumul Def",
	["Defense <- Defense Rating"] = "Def <- Score def",
	-- /rb sum statcomp wpn
	["Sum Weapon Skill"] = "Cumul Comp Arme",
	["Weapon Skill <- Weapon Skill Rating"] = "Comp Arme <- Score Arme",
	
	-- /rb sum gem
	--["Gems"] = true,
	--["Auto fill empty gem slots"] = true,
	-- /rb sum gem red
	["Red Socket"] = EMPTY_SOCKET_RED,
	--["ItemID or Link of the gem you would like to auto fill"] = true,
	--["<ItemID|Link>"] = true,
	--["%s is now set to %s"] = true,
	--["Queried server for Gem: %s. Try again in 5 secs."] = true,
	-- /rb sum gem yellow
	["Yellow Socket"] = EMPTY_SOCKET_YELLOW,
	-- /rb sum gem blue
	["Blue Socket"] = EMPTY_SOCKET_BLUE,
	-- /rb sum gem meta
	["Meta Socket"] = EMPTY_SOCKET_META,

	----------------------
	-- Item Level and ID --
	-----------------------
	["ItemLevel: "] = "Niveau Objet : ",
	["ItemID: "] = "ID Objet : ",
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
	["$value% Crit"] = "$value% Crit",
	["$value% Spell Crit"] = "$value% Crit Sorts",
	["$value% Dodge"] = "$value% Esquive",
	["$value HP"] = "$value PV",
	["$value MP"] = "$value PM",
	["$value AP"] = "$value PA",
	["$value RAP"] = "$value PA Dist",
	["$value Dmg"] = "$value Dégats",
	["$value Heal"] = "$value Soins",
	["$value Armor"] = "$value Armure",
	["$value Block"] = "$value Blocage",
	["$value MP5"] = "$value Mana/5sec",
	["$value MP5(NC)"] = "$value Mana/5sec(HI)",
	["$value HP5"] = "$value Vie/5sec",
	
	------------------
	-- Stat Summary --
	------------------
	["Stat Summary"] = "Résumé Stats",
} end)