--[[
Name: RatingBuster frFR locale (incomplete)
Revision: $Revision: 73696 $
Translated by: Tixu@Curse, Silaor, renchap

--]]

local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "frFR")
if not L then return end
L["RatingBuster Options"] = true
---------------------------
-- Slash Command Options --
---------------------------
-- /rb help
L["Help"] = true
L["Show this help message"] = true
-- /rb win
L["Options Window"] = "Fenêtre des options"
L["Shows the Options Window"] = "Affiche la fenêtre des options"
-- /rb statmod
L["Enable Stat Mods"] = "Activer les Stat Mods"
L["Enable support for Stat Mods"] = "Active le support pour Stat Mods"
-- /rb avoidancedr
L["Enable Avoidance Diminishing Returns"] = "Rendements décroissants de l'Évitement"
L["Dodge, Parry, Miss Avoidance values will be calculated using the avoidance deminishing return formula with your current stats"] = "Les valeurs d'Évitement; Esquive, Parade, Raté, seront calculées en utilisant la formule de rendements décroissants d'Évitement avec vos stats actuelles."
-- /rb itemid
L["Show ItemID"] = "ID des objets"
L["Show the ItemID in tooltips"] = "Affiche l'ID des objets dans les info-bulles."
-- /rb itemlevel
L["Show ItemLevel"] = "Niveau des objets"
L["Show the ItemLevel in tooltips"] = "Affiche le niveau d'objet dans les info-bulles"
-- /rb usereqlv
L["Use required level"] = "Utiliser le niveau requis"
L["Calculate using the required level if you are below the required level"] = "Effectue les calculs en utilisant le niveau requis par l'objet si il n'est pas atteint."
-- /rb setlevel
L["Set level"] = "Définir le niveau"
L["Set the level used in calculations (0 = your level)"] = "Définis le niveau utilisé dans les calculs (0 = votre niveau)"
-- /rb color
L["Change text color"] = "Couleur du texte"
L["Changes the color of added text"] = "Change la couleur du texte ajouté."
L["Change number color"] = "Couleur des chiffres"
-- /rb rating
L["Rating"] = "Détail des scores"
L["Options for Rating display"] = "Sélectionne les différents bonus liés aux scores à inclure dans les info-bulles des objets."
-- /rb rating show
L["Show Rating conversions"] = "Aperçu pourcentage"
L["Show Rating conversions in tooltips"] = "Ajoute la conversion en pourcentage des différents scores dans les info-bulles des objets.\n\nCette case est requise pour l'affichage des scores détaillés."
-- TODO
-- /rb rating spell
L["Show Spell Hit/Haste"] = "Toucher/Hâte des sorts"
L["Show Spell Hit/Haste from Hit/Haste Rating"] = "Affiche le Toucher/Hâte des sorts provenant des scores de Toucher/Hâte."
-- /rb rating physical
L["Show Physical Hit/Haste"] = "Toucher/Hâte de mêlée"
L["Show Physical Hit/Haste from Hit/Haste Rating"] = "Affiche le Toucher/Hâte de mêlée provenant des scores de Toucher/Hâte."
-- /rb rating detail
L["Show detailed conversions text"] = "Textes plus détaillés" 
L["Show detailed text for Resilience and Expertise conversions"] = "Rend la conversion des scores de résilience et d'expertise plus précise.\n\nLa résilience indiquera l'évitement des coups critiques, la diminution des dégâts critiques et la diminution des dégâts périodiques.\n\nL'expertise indiquera la diminution du risque que vos attaques soient esquivées et parées."
-- /rb rating def
L["Defense breakdown"] = "Défense détaillée"
L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Convertis le score de défense en esquive, parade, blocage, évitement des coups et évitement des coups critiques."
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Comp. d'arme détaillée"
L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convertis le score de compétence d'arme en coups critiques, toucher, diminution d'esquive, diminution de parade et diminution de blocage."
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Expertise détaillée"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convertis le score d'expertise en pourcentage de diminution d'esquive et diminution de parade."
L["from"] = "par"
L["HEALING"] = STAT_SPELLHEALING
L["AP"] = ATTACK_POWER_TOOLTIP
L["RANGED_AP"] = RANGED_ATTACK_POWER
L["ARMOR"] = ARMOR
L["SPELL_DMG"] = STAT_SPELLDAMAGE
L["SPELL_CRIT"] = PLAYERSTAT_SPELL_COMBAT .. " " .. SPELL_CRIT_CHANCE
L["STR"] = SPELL_STAT1_NAME
L["AGI"] = SPELL_STAT2_NAME
L["STA"] = SPELL_STAT3_NAME
L["INT"] = SPELL_STAT4_NAME
L["SPI"] = SPELL_STAT5_NAME
L["PARRY"] = PARRY
L["MANA_REG"] = "Régén. mana (incantation)"
L["NORMAL_MANA_REG"] = SPELL_STAT4_NAME .. " & " .. SPELL_STAT5_NAME -- Intellect & Spirit
L["PET_STA"] = PET .. SPELL_STAT3_NAME -- Pet Stamina
L["PET_INT"] = PET .. SPELL_STAT4_NAME -- Pet Intellect
L.statModOptionName = function(show, add)
	return string.format("%s %s ", show, add)
end
L.statModOptionDesc = function(show, add, from, mod)
	return string.format("%s %s %s %s ", show, add, from, mod)
end

-- /rb stat
L["Stat Breakdown"] = "Détail des caractéristiques"
L["Changes the display of base stats"] = "Sélectionne les différents bonus liés aux caractéristiques principales à inclure dans les info-bulles des objets."
-- /rb stat show
L["Show base stat conversions"] = "Aperçu détaillé"
L["Show base stat conversions in tooltips"] = "Ajoute un aperçu détaillé des différents bonus liés aux caractéristiques principales dans les info-bulles des objets.\n\nCette case est requise pour l'affichage des différents bonus liés à l'Agilité, l'Endurance, l'Esprit, la Force et l'Intelligence."
-- /rb stat str
L["Strength"] = "Force"
L["Changes the display of Strength"] = "Sélectionne les différents bonus liés à la Force."
-- /rb stat str ap
L["Show Attack Power"] = "Puissance d'attaque"
L["Show Attack Power from Strength"] = "Affiche la Puissance d'attaque apportée par la Force."
-- /rb stat str block
L["Show Block Value"] = "Valeur de blocage"
L["Show Block Value from Strength"] = "Affiche la Valeur de blocage apportée par la Force."
-- /rb stat str dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Strength"] = "Affiche les Dégâts des sorts apportés par la Force."
-- /rb stat str heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Strength"] = "Affiche la Puissance des soins apportée par la Force."

-- /rb stat Agilité
L["Agility"] = "Agilité"
L["Changes the display of Agility"] = "Sélectionne les différents bonus liés à l'Agilité."
-- /rb stat Agilité crit
L["Show Crit"] = "Coups critiques"
L["Show Crit chance from Agility"] = "Affiche le pourcentage de Coups critiques apporté par l'Agilité."
-- /rb stat Agilité dodge
L["Show Dodge"] = "Esquive"
L["Show Dodge chance from Agility"] = "Affiche le poucentage d'Esquive apporté par l'Agilité."
-- /rb stat Agilité ap
L["Show Attack Power"] = "Puissance d'attaque"
L["Show Attack Power from Agility"] = "Affiche la Puissance d'attaque apportée par l'Agilité."
-- /rb stat Agilité rap
L["Show Ranged Attack Power"] = "Puis. d'att. à distance"
L["Show Ranged Attack Power from Agility"] = "Affiche la Puissance d'attaque à distance apportée par l'Agilité."
-- /rb stat Agilité armor
L["Show Armor"] = "Armure"
L["Show Armor from Agility"] = "Affiche l'Armure apportée par l'Agilité."
-- /rb stat Agilité heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Agility"] = "Affiche la Puissance des soins apportée par l'Agilité."

-- /rb stat sta
L["Stamina"] = "Endurance"
L["Changes the display of Stamina"] = "Sélectionne les différents bonus liés à l'Endurance."
-- /rb stat sta hp
L["Show Health"] = "Points de vie"
L["Show Health from Stamina"] = "Affiche les points de vie liés à l'Endurance."
-- /rb stat sta dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Stamina"] = "Affiche les Dégâts des sorts apportés par l'Endurance."

-- /rb stat int
L["Intellect"] = "Intelligence"
L["Changes the display of Intellect"] = "Sélectionne les différents bonus liés à l'Intelligence."
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Critiques des sorts"
L["Show Spell Crit chance from Intellect"] = "Affiche le pourcentage de Coups critiques des sorts apporté par l'Intelligence."
-- /rb stat int mp
L["Show Mana"] = "Points de mana"
L["Show Mana from Intellect"] = "Affiche les points de mana apportés par l'Intelligence."
-- /rb stat int dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Intellect"] = "Affiche les Dégâts des sorts apportés par l'Intelligence."
-- /rb stat int heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Intellect"] = "Affiche la Puissance des soins apportée par l'Intelligence."
-- /rb stat int mp5
L["Show Mana Regen"] = "Régén. mana (incantation)"
L["Show Mana Regen while casting from Intellect"] = "Affiche la Régén. mana pendant l'incantation des sorts apportée par l'Intelligence."
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "Affiche la Régén. mana hors incantation."
L["Show Mana Regen while NOT casting from Intellect"] = "Affiche la Régén. mana hors incantation apportée par l'Intelligence."
-- /rb stat int rap
L["Show Ranged Attack Power"] = "Puis. d'att. à distance"
L["Show Ranged Attack Power from Intellect"] = "Affiche la Puissance d'attaque à distance apportée par l'Intelligence."
-- /rb stat int armor
L["Show Armor"] = "Armure"
L["Show Armor from Intellect"] = "Affiche l'Armure apportée par l'Intelligence."

-- /rb stat spi
L["Spirit"] = "Esprit"
L["Changes the display of Spirit"] = "Sélectionne les différents bonus liés à l'Esprit."
-- /rb stat spi mp5
L["Show Mana Regen"] = "Régén. mana (incantation)"
L["Show Mana Regen while casting from Spirit"] = "Affiche la Régén. mana pendant l'incantation des sorts apportés par l'Esprit."
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Régén. mana"
L["Show Mana Regen while NOT casting from Spirit"] = "Affiche la Régén. mana hors incantation apportée par l'Esprit."
-- /rb stat spi hp5
L["Show Health Regen"] = "Régén. vie (hors combat)"
L["Show Health Regen from Spirit"] = "Affiche la Régén. vie hors combat apportée par l'Esprit."
-- /rb stat spi dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Spirit"] = "Affiche les Dégâts des sorts apportés par l'Esprit."
-- /rb stat spi heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Spirit"] = "Affiche la Puissance des soins apportée par l'Esprit."

---------------------------------------------------------------------------
-- /rb stat armor
L["Armor"] = "Armure"
L["Changes the display of Armor"] = "Sélectionne les différents bonus liés à l'Armure."
L["Attack Power"] = "Puissance d'attaque"
L["Changes the display of Attack Power"] = "Sélectionne les différents bonus liés à la Puissance d'attaque."
-- /rb stat armor ap
L["Show Attack Power"] = "Puissance d'attaque"
L["Show Attack Power from Armor"] = "Affiche la Puissance d'attaque apportée par l'Armure."
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Résumé des Stats"
L["Options for stat summary"] = "Un résumé des différents bonus apportés par les statistiques peut être inclu dans les info-bulles des objets."
-- /rb sum show
L["Show stat summary"] = "Afficher le résumé"
L["Show stat summary in tooltips"] = "Ajoute un résumé de tous les bonus provenant des différentes statistiques dans les info-bulles des objets."
-- /rb sum ignore
L["Ignore settings"] = "Valeurs à ignorer"
L["Ignore stuff when calculating the stat summary"] = "Sélectionne les valeurs à ignorer lors des calculs du résumé."
-- /rb sum ignore unused
L["Ignore unused items types"] = "Objets non utilisables"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "Ne pas afficher le résumé pour les objets que votre classe ne peut pas utiliser et pour les équipements de qualité inférieure à Inhabituelle."
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Objets équipés"
L["Hide stat summary for equipped items"] = "Ne pas afficher le résumé pour les objets équipés."
-- /rb sum ignore enchant
L["Ignore enchants"] = "Enchantements"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorer les enchantements lors des calculs du résumé."
-- /rb sum ignore gem
L["Ignore gems"] = "Gemmes"
L["Ignore gems on items when calculating the stat summary"] = "Ignorer les gemmes lors des calculs du résumé."
-- /rb sum diffstyle
L["Display style for diff value"] = "Mode d'affichage du comparatif"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Détermine si le comparatif s'ajoute à l'info-bulle principale ou à l'info-bulle de la pièce comparée."
L["Hide Blizzard Item Comparisons"] = "Masquer la comparaison d'objet de Blizzard"
L["Disable Blizzard stat change summary when using the built-in comparison tooltip"] = "Désactive le comparateur de statistiques de Blizzard dans les info-bulles de comparaison des équipements."
-- /rb sum space
L["Add empty line"] = "Ajouter une ligne vide"
L["Add a empty line before or after stat summary"] = "Ajoute une ligne vide avant et/ou après le résumé."
-- /rb sum space before
L["Add before summary"] = "Avant le résumé"
L["Add a empty line before stat summary"] = "Ajoute une ligne vide avant le résumé des statistiques."
-- /rb sum space after
L["Add after summary"] = "Après le résumé"
L["Add a empty line after stat summary"] = "Ajoute une ligne vide après le résumé des statistiques."
-- /rb sum icon
L["Show icon"] = "Ajouter l'icône"
L["Show the sigma icon before summary listing"] = "Affiche l'icône sigma avant le résumé."
-- /rb sum title
L["Show title text"] = "Ajouter le titre"
L["Show the title text before summary listing"] = "Ajoute le titre avant le résumé."
-- /rb sum showzerostat
L["Show zero value stats"] = "Ajouter les stats nulles"
L["Show zero value stats in summary for consistancy"] = "Ajoute les stats nulles/absentes de l'objet au résumé."
-- /rb sum calcsum
L["Calculate stat sum"] = "Afficher les totaux"
L["Calculate the total stats for the item"] = "Calcule et affiche le montant cumulé de chaque statistique présente sur les objets."
-- /rb sum calcdiff
L["Calculate stat diff"] = "Comparaison"
L["Calculate the stat difference for the item and equipped items"] = "Ajoute une comparaison entre les statistiques des objets et celles de l'équipement actuel."
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "Ordre alphabétique"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Tri les statistiques par ordre alphabétique, plutôt que par ordre fixe (Basiques, Magiques, Physiques, Tank)."
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "Blocage dans Évitement"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Inclue les chances de blocage au total d'Évitement, en plus de l'esquive, de la parade et du raté.\n\nUtile pour les tanks qui utilisent un bouclier."
-- /rb sum basic
L["Stat - Basic"] = "Stats - Basiques"
L["Choose basic stats for summary"] = "Sélectionne les différentes caractéristiques basiques à inclure au résumé."
-- /rb sum physical
L["Stat - Physical"] = "Stats - Physiques"
L["Choose physical damage stats for summary"] = "Sélectionne les différentes caractéristiques de combat physique à inclure au résumé."
-- /rb sum spell
L["Stat - Spell"] = "Stats - Magiques"
L["Choose spell damage and healing stats for summary"] = "Sélectionne les différentes caractéristiques de combat magique à inclure au résumé."
-- /rb sum tank
L["Stat - Tank"] = "Stats - Tank"
L["Choose tank stats for summary"] = "Sélectionne les différentes caractéristiques défensives à inclure au résumé."
-- /rb sum stat hp
L["Sum Health"] = "Points de vie"
L["Health <- Health, Stamina"] = "Inclure les Points de vie conférés par : Points de vie + Endurance."
-- /rb sum stat mp
L["Sum Mana"] = "Points de mana"
L["Mana <- Mana, Intellect"] = "Inclure les Points de mana conférés par : Points de mana + Intelligence."
-- /rb sum stat ap
L["Sum Attack Power"] = "Puissance d'attaque"
L["Attack Power <- Attack Power, Strength, Agility"] = "Inclure la Puissance d'attaque conférée par : Puissance d'attaque + Force + Agilité."
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "Puis. d'att. à distance"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Inclure la Puissance d'attaque à distance conférée par : Puissance d'attaque à distance + Intelligence + Puissance d'attaque + Force + Agilité."
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Dégâts des sorts"
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Inclure les Dégâts des sorts conférés par : Dégâts des sorts + Intelligence + Esprit + Endurance."
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Dégâts : Sacré"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Inclure les Dégâts du Sacré conférés par : Dégâts du Sacré + Dégâts des sorts + Intelligence + Esprit."
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Dégâts : Arcanes"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts des Arcanes conférés par : Dégâts des Arcanes + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Dégâts : Feu"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Inclure les Dégâts de Feu conférés par : Dégâts de Feu + Dégâts des sorts + Intelligence + Endurance."
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Dégâts : Nature"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts de Nature conférés par : Dégâts de Nature + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Dégâts : Givre"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts de Givre conférés par : Dégâts de Givre + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Dégâts : Ombre"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Inclure les Dégâts d'Ombre conférés par : Dégâts d'Ombre + Dégâts des sorts + Intelligence + Esprit + Endurance."
-- /rb sum stat heal
L["Sum Healing"] = "Puissance des soins"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Inclure la Puissance des soins conférée par : Puissance des soins + Intelligence + Esprit + Agilité + Force."
-- /rb sum stat hit
L["Sum Hit Chance"] = "Toucher"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Inclure le pourcentage de Toucher conféré par : Score de toucher + Compétence d'arme."
-- /rb sum stat crit
L["Sum Crit Chance"] = "Coups critiques"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Inclure le pourcentage de Coups critiques conféré par : Score de coup critique + Agilité + Compétence d'arme."
-- /rb sum stat haste
L["Sum Haste"] = "Hâte"
L["Haste <- Haste Rating"] = "Inclure le pourcentage de Hâte conféré par : le Score de hâte."
-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "Critiques des sorts"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Inclure le pourcentage de Coups critiques des sorts conféré par : Score de coup critique des sorts + Intelligence."
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Toucher des sorts"
L["Spell Hit Chance <- Spell Hit Rating"] = "Inclure le pourcentage de Toucher des Sorts conféré par le Score de toucher des sorts."
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "Hâte des sorts"
L["Spell Haste <- Spell Haste Rating"] = "Inclure le pourcentage de Hâte des sorts conféré par le Score de hâte des sorts."
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Régén. mana (incantation)"
L["Mana Regen <- Mana Regen, Spirit"] = "Inclure la Régén. mana pendant l'incantation des sorts conférée par : Régén. mana + Esprit."
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Régén. mana (hors incantation)"
L["Mana Regen while not casting <- Spirit"] = "Inclure la Régén. mana hors incantation conférée par l'Esprit."
-- /rb sum stat hp5
L["Sum Health Regen"] = "Régén. vie (combat)"
L["Health Regen <- Health Regen"] = "Inclure la Régén. vie en combat conférée par la Régén. vie."
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Régén. vie (hors combat)"
L["Health Regen when out of combat <- Spirit"] = "Inclure la Régén. vie hors combat conférée par l'Esprit."
-- /rb sum stat armor
L["Sum Armor"] = "Armure"
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Inclure l'Armure conférée par : Armure des objets + Armure bonus + Agilité + Intelligence."
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Valeur de blocage"
L["Block Value <- Block Value, Strength"] = "Inclure la Valeur de blocage conférée par : Valeur de blocage + Force."
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Esquive"
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Inclure l'Esquive conférée par : Score d'esquive + Agilité + Score de défense."
-- /rb sum stat parry
L["Sum Parry Chance"] = "Parade"
L["Parry Chance <- Parry Rating, Defense Rating"] = "Inclure la Parade conférée par : Score de parade + Score de défense."
-- /rb sum stat block
L["Sum Block Chance"] = "Chances de bloquer"
L["Block Chance <- Block Rating, Defense Rating"] = "Inclure les Chances de bloquer conférées par : Score de blocage + Score de défense."
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Évitement des coups"
L["Hit Avoidance <- Defense Rating"] = "Inclure le pourcentage d'Évitement des coups conféré par le Score de défense."
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "Évitement CC"
L["Crit Avoidance <- Defense Rating, Resilience"] = "Inclure le pourcentage d'Évitement des Coups critiques conféré par : Score de défense + Résilience."
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Diminution Esquive"
L["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Inclure le pourcentage de Diminution d'esquive conféré par : Expertise + Compétence d'arme."
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Diminution Parade"
L["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Inclure le pourcentage de Diminution de parade conféré par : Expertise + Compétence d'arme."
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Diminution Blocage"
L["Block Neglect <- Weapon Skill Rating"] = "Inclure le pourcentage de Diminution de blocage conféré par la Compétence d'arme."
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Résistance : Arcanes"
L["Arcane Resistance Summary"] = "Inclure la Résistance aux Arcanes."
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Résistance : Feu"
L["Fire Resistance Summary"] = "Inclure la Résistance au Feu."
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Résistance : Nature"
L["Nature Resistance Summary"] = "Inclure la Résistance à la Nature."
-- /rb sum stat resfrost
L["Sum Frost Resistance"] =  "Résistance : Givre"
L["Frost Resistance Summary"] = "Inclure la Résistance au Givre."
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Résistance : Ombre"
L["Shadow Resistance Summary"] = "Inclure la Résistance à l'Ombre."
L["Sum Weapon Average Damage"] = true
L["Weapon Average Damage Summary"] = true
L["Sum Weapon DPS"] = true
L["Weapon DPS Summary"] = true
-- /rb sum stat pen
L["Sum Penetration"] = "Pénétration des sorts"
L["Spell Penetration Summary"] = "Inclure la Pénétration des sorts."
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "Pénétration d'armure"
L["Ignore Armor Summary"] = "Inclure la Pénétration d'armure."
-- TODO
L["Sum Armor Penetration"] = "Pénétration d'armure"
L["Armor Penetration Summary"] = "Inclure la Pénétration d'armure."
L["Sum Armor Penetration Rating"] = "Score de pénétration d'armure"
L["Armor Penetration Rating Summary"] = "Inclure le score de Pénétration d'armure."
-- /rb sum statcomp str
L["Sum Strength"] = "Force"
L["Strength Summary"] = "Inclure la Force."
-- /rb sum statcomp Agilité
L["Sum Agility"] = "Agilité"
L["Agility Summary"] = "Inclure l'Agilité."
-- /rb sum statcomp sta
L["Sum Stamina"] = "Endurance"
L["Stamina Summary"] = "Inclure l'Endurance."
-- /rb sum statcomp int
L["Sum Intellect"] = "Intelligence"
L["Intellect Summary"] = "Inclure l'Intelligence."
-- /rb sum statcomp spi
L["Sum Spirit"] = "Esprit"
L["Spirit Summary"] = "Inclure l'Esprit."
-- /rb sum statcomp hitrating
L["Sum Hit Rating"] = "Score de toucher"
L["Hit Rating Summary"] = "Inclure le Score de toucher."
-- /rb sum statcomp critrating
L["Sum Crit Rating"] = "Score de critique"
L["Crit Rating Summary"] = "Inclure le Score de coup critique."
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "Score de hâte"
L["Haste Rating Summary"] = "Inclure le Score de hâte."
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "Score de toucher des sorts"
L["Spell Hit Rating Summary"] = "Inclure le Score de toucher des sorts."
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "Score de critique des sorts"
L["Spell Crit Rating Summary"] = "Inclure le Score de coup critique des sorts."
-- /rb sum statcomp hastespellrating
L["Sum Spell Haste Rating"] = "Score de hâte des sorts"
L["Spell Haste Rating Summary"] = "Inclure le Score de hâte des sorts."
-- /rb sum statcomp dodgerating
L["Sum Dodge Rating"] = "Score d'esquive"
L["Dodge Rating Summary"] = "Inclure le Score d'esquive."
-- /rb sum statcomp parryrating
L["Sum Parry Rating"] = "Score de parade"
L["Parry Rating Summary"] = "Inclure le Score de parade."
-- /rb sum statcomp blockrating
L["Sum Block Rating"] = "Score de blocage"
L["Block Rating Summary"] = "Inclure le Score de blocage."
-- /rb sum statcomp res
L["Sum Resilience"] = "Score de résilience"
L["Resilience Summary"] = "Inclure le Score de résilience."
-- /rb sum statcomp def
L["Sum Defense"] = "Défense"
L["Defense <- Defense Rating"] = "Inclure la valeur de Défense conférée par le Score de défense."
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Compétence d'arme"
L["Weapon Skill <- Weapon Skill Rating"] = "Inclure la Compétence d'arme conférée par le Score de compétence d'arme."
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "Expertise"
L["Expertise <- Expertise Rating"] = "Inclure la valeur d'Expertise conférée par le Score d'expertise."
-- /rb sum statcomp tp
L["Sum TankPoints"] = "TankPoints"
L["TankPoints <- Health, Total Reduction"] = "TankPoints = Points de vie + diminution totale"
-- /rb sum statcomp tr
L["Sum Total Reduction"] = "Diminution complète"
L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Inclure la diminution complète conférée par : Armure + Equive + Parade + Blocage + Valeur de blocage + Défense + Résilience + MobMiss + MobCrit + MobCrush + DamageTakenMods."
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "Évitement"
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Inclure l'Évitement conféré par : Esquive + Parade + Raté + Blocage(optionnel)."
-- /rb sum gem
L["Gems"] = "Gemmes"
L["Auto fill empty gem slots"] = "Simuler le sertissage de gemmes."
-- /rb sum gem red
L["Red Socket"] = "Châsse rouge"
L["ItemID or Link of the gem you would like to auto fill"] = "ID ou lien (maj+clic) de la gemme que vous voulez simuler."
--["<ItemID|Link>"] = true,
L["%s is now set to %s"] = "%s simulera désormais %s."
L["Queried server for Gem: %s. Try again in 5 secs."] = "Requête serveur pour : %s. Rééssayez dans 5 secondes."
-- /rb sum gem yellow
L["Yellow Socket"] = "Châsse jaune"
-- /rb sum gem blue
L["Blue Socket"] = "Châsse bleue"
-- /rb sum gem meta
L["Meta Socket"] = "Méta-châsse"

----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Niveau Objet : "
L["ItemID: "] = "ID Objet : "

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
-- The first pass searches for the rating number, the patterns are read from ["numberPatterns"] here,
-- " by (%d+)" will match strings like: "Increases defense rating by 16."
-- "%+(%d+)" will match strings like: "+10 Defense Rating"
-- You can add additional patterns if needed, its not limited to 2 patterns.
-- The separators are a table of strings used to break up a line into multiple lines what will be parsed seperately.
-- For example "+3 Hit Rating, +5 Spell Crit Rating" will be split into "+3 Hit Rating" and " +5 Spell Crit Rating"
--
-- The second pass searches for the rating name, the names are read from ["statList"] here,
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
	{pattern = " de (%d+)%f[^%d%%]", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)%f[^%d%%]", addInfo = "AfterStat",},
	{pattern = "augmente.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "ajoute (%d+) (à|au))", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " et ", ",", "%. ", " pour ", "&", " : ", "\n"
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
L["statList"] = {
	{pattern = string.lower(SPELL_STAT1_NAME), id = SPELL_STAT1_NAME}, -- Strength
	{pattern = string.lower(SPELL_STAT2_NAME), id = SPELL_STAT2_NAME}, -- Agility
	{pattern = string.lower(SPELL_STAT3_NAME), id = SPELL_STAT3_NAME}, -- Stamina
	{pattern = string.lower(SPELL_STAT4_NAME), id = SPELL_STAT4_NAME}, -- Intellect
	{pattern = string.lower(SPELL_STAT5_NAME), id = SPELL_STAT5_NAME}, -- Spirit
	{pattern = "score de défense", id = CR_DEFENSE_SKILL},
	{pattern = "score d’esquive", id = CR_DODGE},
	{pattern = "score d'esquive", id = CR_DODGE},
	{pattern = "score de blocage", id = CR_BLOCK}, --Ench. de bouclier (Blocage inférieur)
	{pattern = "score de Maîtrise du blocage", id = CR_BLOCK}, --Ench. de bouclier (Maîtrise du blocage)
	{pattern = "score de parade", id = CR_PARRY},

	{pattern = "score de critique des sorts", id = CR_CRIT_SPELL},
	{pattern = "score de coup critique des sorts", id = CR_CRIT_SPELL},
	{pattern = "score de toucher critique des sorts", id = CR_CRIT_SPELL},
	{pattern = "score de critique à distance", id = CR_CRIT_RANGED},
	{pattern = "score de coup critique à distance", id = CR_CRIT_RANGED},
	{pattern = "score de toucher critique à distance", id = CR_CRIT_RANGED},
	{pattern = "score de critique", id = CR_CRIT}, --ex : https://fr.tbc.wowhead.com/item=30565/opale-de-feu-dassassin
	{pattern = "score de coup critique", id = CR_CRIT},
	{pattern = "score de toucher critique", id = CR_CRIT},

	{pattern = "score de toucher des sorts", id = CR_HIT_SPELL},
	{pattern = "score de toucher à distance", id = CR_HIT_RANGED},
	{pattern = "score de toucher", id = CR_HIT},

	{pattern = "résilience", id = CR_RESILIENCE_CRIT_TAKEN}, -- resilience is implicitly a rating

	{pattern = "score de hâte des sorts", id = CR_HASTE_SPELL},
	{pattern = "score de hâte à distance", id = CR_HASTE_RANGED},
	{pattern = "score de hâte", id = CR_HASTE},
	{pattern = "score de hâte en mêlée", id = CR_HASTE_MELEE}, -- [Tambours de Bataille] "score de hâte en mêlée, à distance et avec les sorts" complete drums line
	{pattern = "score d’expertise", id = CR_EXPERTISE},
	{pattern = "score d'expertise", id = CR_EXPERTISE},

	{pattern = "pénétration d'armure", id = CR_ARMOR_PENETRATION},
	{pattern = string.lower(ARMOR), id = ARMOR},
	{pattern = "puissance d'attaque", id = ATTACK_POWER},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value% Crit" -> "+1.34% Crit"
-- EX: "Crit $value%" -> "Crit +1.34%"
L["$value% Crit"] = "$value% CC"
L["$value% Spell Crit"] = "$value% CC sorts"
L["$value% Dodge"] = "$value% esquive"
L["$value HP"] = "$value PV"
L["$value MP"] = "$value Mana"
L["$value AP"] = "$value PA"
L["$value RAP"] = "$value PA dist."
L["$value Spell Dmg"] = "$value dégâts"
L["$value Heal"] = "$value soins"
L["$value Armor"] = "$value armure"
L["$value Block"] = "$value blocage"
L["$value MP5"] = "$value Mp5 (incantation)"
L["$value MP5(NC)"] = "$value Mp5"
L["$value HP5"] = "$value HP5"
L["$value to be Dodged/Parried"] = "$value esquivé/paré"
L["$value to be Crit"] = "$value recevoir CC"
L["$value Crit Dmg Taken"] = "$value dégâts CC"
L["$value DOT Dmg Taken"] = "$value dégâts DoT"
L["$value Dmg Taken"] = true
L["$value% Parry"] = "$value% parer"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value% Sort"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Résumé Stats"
