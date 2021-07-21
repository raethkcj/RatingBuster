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
L["Enable support for Stat Mods"] = "Activer le support pour Stat Mods"
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
-- /rb color pick
L["Pick color"] = "Choix de la couleur"
L["Pick a color"] = "Choisissez une couleur"
-- /rb color enable
L["Enable color"] = "Activer la couleur"
L["Enable colored text"] = "Active le texte coloré"
-- /rb rating
L["Rating"] = "Détail des scores"
L["Options for Rating display"] = "Sélectionne les différents bonus liés aux scores à inclure dans les info-bulles des objets."
-- /rb rating show
L["Show Rating conversions"] = "Aperçu conversion"
L["Show Rating conversions in tooltips"] = "Ajoute la conversion des valeurs des différents scores dans les info-bulles des objets.\n\nCette case est requise pour l'affichage des scores détaillés."
-- /rb rating detail
L["Show detailed conversions text"] = "Textes plus détaillés" 
L["Show detailed text for Resiliance and Expertise conversions"] = "Rend la conversion des score de résilience et d'expertise plus précise.\n\nLa résilience indiquera le pourcentage d'évitement des coups critiques, réduction des dégâts critiques et réduction des dégâts périodiques.\n\nL'expertise indiquera le pourcentage de réduction du risque d'être esquivé et paré."
-- /rb rating def
L["Defense breakdown"] = "Défense détaillée"
L["Convert Defense into Crit Avoidance, Hit Avoidance, Dodge, Parry and Block"] = "Convertis le score de défense en pourcentage de chance d'esquive, parade, blocage, évitement des coups et évitement des coups critiques."
-- /rb rating wpn
L["Weapon Skill breakdown"] = "Comp. d'arme détaillée"
L["Convert Weapon Skill into Crit, Hit, Dodge Neglect, Parry Neglect and Block Neglect"] = "Convertis le score de compétence d'arme en pourcentage de coups critiques, toucher, réduction d'esquive, réduction de parade et réduction de blocage."
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Expertise détaillée"
L["Convert Expertise into Dodge Neglect and Parry Neglect"] = "Convertis le score d'expertise en un pourcentage de réduction d'esquive et de parade."

-- /rb stat
L["Stat Breakdown"] = "Détail des caractéristiques"
L["Changes the display of base stats"] = "Sélectionne les différents bonus liés aux caractéristiques principales à inclure dans les info-bulles des objets."
-- /rb stat show
L["Show base stat conversions"] = "Aperçu détaillé"
L["Show base stat conversions in tooltips"] = "Ajoute un aperçu détaillé des différents bonus liés aux caractéristiques principales dans les info-bulles des objets.\n\nCette case est requise pour l'affichage des différents bonus liés à l'agilité, l'endurance, l'esprit, la force et l'intelligence."
-- /rb stat str
L["Strength"] = "Force"
L["Changes the display of Strength"] = "Sélectionne les différents bonus liés à la Force."
-- /rb stat str ap
L["Show Attack Power"] = "Puisance d'attaque"
L["Show Attack Power from Strength"] = "Affiche la Puissance d'attaque apportée par la Force."
-- /rb stat str block
L["Show Block Value"] = "Valeur de blocage"
L["Show Block Value from Strength"] = "Affiche la Valeur de blocage apportée par la Force."
-- /rb stat str dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Strength"] = "Affiche les Dégâts des sorts apportée par la Force."
-- /rb stat str heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Strength"] = "Affiche la Puissance des soins apportée par la Force."

-- /rb stat Agilité
L["Agility"] = "Agilité"
L["Changes the display of Agility"] = "Sélectionne les différents bonus liés à l'Agilité."
-- /rb stat Agilité crit
L["Show Crit"] = "Critique (%)"
L["Show Crit chance from Agility"] = "Affiche le pourcentage de Coups critiques apporté par l'Agilité."
-- /rb stat Agilité dodge
L["Show Dodge"] = "Esquive (%)"
L["Show Dodge chance from Agility"] = "Affiche le poucentage d'Esquive apporté par l'Agilité."
-- /rb stat Agilité ap
L["Show Attack Power"] = "Puissance d'attaque"
L["Show Attack Power from Agility"] = "Affiche la Puissance d'attaque apportée par l'Agilité."
-- /rb stat Agilité rap
L["Show Ranged Attack Power"] = "PA à distance"
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
L["Show Spell Damage from Stamina"] = "Affiche les Dégâts des sorts apportée par l'Endurance."

-- /rb stat int
L["Intellect"] = "Intelligence"
L["Changes the display of Intellect"] = "Sélectionne les différents bonus liés à l'Intelligence."
-- /rb stat int spellcrit
L["Show Spell Crit"] = "Critique des sorts (%)"
L["Show Spell Crit chance from Intellect"] = "Affiche le pourcentage de Coups critiques des sorts apporté par l'Intelligence."
-- /rb stat int mp
L["Show Mana"] = "Points de mana"
L["Show Mana from Intellect"] = "Affiche les points de mana apportés par l'Intelligence."
-- /rb stat int dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Intellect"] = "Affiche les Dégâts des sorts apportée par l'Intelligence."
-- /rb stat int heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Intellect"] = "Affiche la Puissance des soins apportée par l'Intelligence."
-- /rb stat int mp5
L["Show Mana Regen"] = "Mp5 (incantation)"
L["Show Mana Regen while casting from Intellect"] = "Affiche la Régénération de mana pendant l'incantation des sorts apportée par l'Intelligence."
-- /rb stat int mp5nc
L["Show Mana Regen while NOT casting"] = "Affiche la Régénération de mana hors incantation."
L["Show Mana Regen while NOT casting from Intellect"] = "Affiche la Régénération de mana hors incantation apportée par l'Intelligence."
-- /rb stat int rap
L["Show Ranged Attack Power"] = "PA à distance"
L["Show Ranged Attack Power from Intellect"] = "Affiche la Puissance d'attaque à distance apportée par l'Intelligence."
-- /rb stat int armor
L["Show Armor"] = "Armure"
L["Show Armor from Intellect"] = "Affiche l'Armure apportée par l'Intelligence."

-- /rb stat spi
L["Spirit"] = "Esprit"
L["Changes the display of Spirit"] = "Sélectionne les différents bonus liés à l'Esprit."
-- /rb stat spi mp5
L["Show Mana Regen"] = "Mp5 (incantation)"
L["Show Mana Regen while casting from Spirit"] = "Affiche la Régénération de mana pendant l'incantation des sorts apportée par l'Esprit."
-- /rb stat spi mp5nc
L["Show Mana Regen while NOT casting"] = "Mp5 (repos)"
L["Show Mana Regen while NOT casting from Spirit"] = "Affiche la Régénération de mana au hors incantation apportée par l'Esprit."
-- /rb stat spi hp5
L["Show Health Regen"] = "Hp5 (repos)"
L["Show Health Regen from Spirit"] = "Affiche la Régénération de santé hors combat apportée par l'Esprit."
-- /rb stat spi dmg
L["Show Spell Damage"] = "Dégâts des sorts"
L["Show Spell Damage from Spirit"] = "Affiche les Dégâts des sorts apportée par l'Esprit."
-- /rb stat spi heal
L["Show Healing"] = "Puissance des soins"
L["Show Healing from Spirit"] = "Affiche la Puissance des soins apportée par l'Esprit."

-- /rb sum
L["Stat Summary"] = "Résumé des Stats"
L["Options for stat summary"] = "Le résumé des différents bonus cumulés apportés par les statistiques peut être inclu dans les info-bulles des objets."
-- /rb sum show
L["Show stat summary"] = "Afficher le résumé"
L["Show stat summary in tooltips"] = "Ajoute le résumé de tous les bonus provenant des différentes statistiques dans les info-bulles des objets."
-- /rb sum ignore
L["Ignore settings"] = "Valeurs à ignorer"
L["Ignore stuff when calculating the stat summary"] = "Sélectionne les valeurs à ignorer lors des calculs du résumé."
-- /rb sum ignore unused
L["Ignore unused items types"] = "Types d'objets non utilisables"
L["Show stat summary only for highest level armor type and items you can use with uncommon quality and up"] = "N'affiche le résumé que sur les types d'armes et d'armures que votre classe peut utiliser et pour les équipements de qualité au moins Inhabituelle."
-- /rb sum ignore equipped
L["Ignore equipped items"] = "Objets équipés"
L["Hide stat summary for equipped items"] = "Ne pas afficher le résumé pour les objets équipés."
-- /rb sum ignore enchant
L["Ignore enchants"] = "Enchantements"
L["Ignore enchants on items when calculating the stat summary"] = "Ignorer les bonus d'enchantement lors des calculs du résumé."
-- /rb sum ignore gem
L["Ignore gems"] = "Gemmes"
L["Ignore gems on items when calculating the stat summary"] = "Ignorer les bonus des gemmes lors des calculs du résumé."
-- /rb sum diffstyle
L["Display style for diff value"] = "Mode d'affichage du comparatif"
L["Display diff values in the main tooltip or only in compare tooltips"] = "Détermine si le comparatif s'ajoute à l'info-bulle principale ou à l'info-bulle de la pièce comparée."
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
L["Show title text"] = "AJouter le titre"
L["Show the title text before summary listing"] = "Ajoute le titre avant le résumé."
-- /rb sum showzerostat
L["Show zero value stats"] = "Ajouter les stats nulles"
L["Show zero value stats in summary for consistancy"] = "Ajoute les stats nulles/absentes au résumé pour plus de cohérence."
-- /rb sum calcsum
L["Calculate stat sum"] = "Afficher les totaux"
L["Calculate the total stats for the item"] = "Calcule et affiche le montant final de chaque statistique présente sur les objets."
-- /rb sum calcdiff
L["Calculate stat diff"] = "Comparaison"
L["Calculate the stat difference for the item and equipped items"] = "Ajoute une comparaison entre les statistiques des objets et celles de l'équipement actuel."
-- /rb sum sort
L["Sort StatSummary alphabetically"] = "Ordre alphabétique"
L["Enable to sort StatSummary alphabetically, disable to sort according to stat type(basic, physical, spell, tank)"] = "Tri les statistiques par ordre alphabétique, plutôt que par ordre fixe (Basiques, Magiques, Physiques, Tank)."
-- /rb sum avoidhasblock
L["Include block chance in Avoidance summary"] = "Blocage dans Évitement"
L["Enable to include block chance in Avoidance summary, Disable for only dodge, parry, miss"] = "Inclue les chances de blocage au résumé Évitement, en plus de l'esquive, de la parade et du raté.\n\nUtile pour les spécialisations tank disposant d'un bouclier."
-- /rb sum basic
L["Stat - Basic"] = "Stats - Basiques"
L["Choose basic stats for summary"] = "Sélectionne les différentes caractéristiques basiques à prendre en compte lors des calculs du résumé."
-- /rb sum physical
L["Stat - Physical"] = "Stats - Physiques"
L["Choose physical damage stats for summary"] = "Sélectionne les différentes caractéristiques de combat physique à prendre en compte lors des calculs du résumé."
-- /rb sum spell
L["Stat - Spell"] = "Stats - Magiques"
L["Choose spell damage and healing stats for summary"] = "Sélectionne les différentes caractéristiques de combat magique à prendre en compte lors des calculs du résumé."
-- /rb sum tank
L["Stat - Tank"] = "Stats - Tank"
L["Choose tank stats for summary"] = "Sélectionne les différentes caractéristiques défensives à prendre en compte lors des calculs du résumé."
-- /rb sum stat hp
L["Sum Health"] = "Vie"
L["Health <- Health, Stamina"] = "Total Vie = Vie + Endurance"
-- /rb sum stat mp
L["Sum Mana"] = "Mana"
L["Mana <- Mana, Intellect"] = "Total Mana = Mana + Intelligence"
-- /rb sum stat ap
L["Sum Attack Power"] = "Puissance d'attaque"
L["Attack Power <- Attack Power, Strength, Agility"] = "Total Puissance d'attaque = Puissance d'attaque + Force + Agilité"
-- /rb sum stat rap
L["Sum Ranged Attack Power"] = "PA à distance"
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Total Puissance d'attaque à distance = Puissance d'attaque à distance + Intelligence + Puissance d'attaque + Force + Agilité"
-- /rb sum stat fap
L["Sum Feral Attack Power"] = "PA farouche"
L["Feral Attack Power <- Feral Attack Power, Attack Power, Strength, Agility"] = "Total Puissance d'attaque farouche = Puissance d'attaque farouche + Puissance d'attaque + Force + Agilité"
-- /rb sum stat dmg
L["Sum Spell Damage"] = "Dégâts des sorts"
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Total Dégâts des sorts = Dégâts des sorts + Intelligence + Esprit + Endurance"
-- /rb sum stat dmgholy
L["Sum Holy Spell Damage"] = "Dégâts : sacré"
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Total Dégâts : sacré = Dégâts : sacré + Dégâts des sorts + Intelligence + Esprit"
-- /rb sum stat dmgarcane
L["Sum Arcane Spell Damage"] = "Dégâts : arcanes"
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Total Dégâts : arcanes = Dégâts : arcanes + Dégâts des sorts + Intelligence"
-- /rb sum stat dmgfire
L["Sum Fire Spell Damage"] = "Dégâts : feu"
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Total Dégâts : feu = Dégâts : feu + Dégâts des sorts + Intelligence + Endurance"
-- /rb sum stat dmgnature
L["Sum Nature Spell Damage"] = "Dégâts : nature"
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Total Dégâts : nature = Dégâts : nature + Dégâts des sorts + Intelligence"
-- /rb sum stat dmgfrost
L["Sum Frost Spell Damage"] = "Dégâts : givre"
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Total Dégâts : givre = Dégâts : givre + Dégâts des sorts + Intelligence"
-- /rb sum stat dmgshadow
L["Sum Shadow Spell Damage"] = "Dégâts : ombre"
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Total Dégâts : Ombre = Dégâts : Ombre + Dégâts des sorts + Intelligence + Esprit + Endurance"
-- /rb sum stat heal
L["Sum Healing"] = "Puissance des soins"
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Total Puissance des soins = Puissance des soins + Intelligence + Esprit + Agilité + Force"
-- /rb sum stat hit
L["Sum Hit Chance"] = "Toucher"
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Total Toucher = Score de toucher + Compétence d'arme"
-- /rb sum stat crit
L["Sum Crit Chance"] = "Critique"
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Total Coups critiques = Score de critique + Agilité + Compétence d'arme"
-- /rb sum stat haste
L["Sum Haste"] = "Hâte"
L["Haste <- Haste Rating"] = "Total Hâte = Score de hâte"
-- /rb sum stat critspell
L["Sum Spell Crit Chance"] = "Critique des sorts"
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Total Coups critiques des sorts = Score de critique des sorts + Intelligence"
-- /rb sum stat hitspell
L["Sum Spell Hit Chance"] = "Toucher des sorts"
L["Spell Hit Chance <- Spell Hit Rating"] = "Total Toucher des Sorts = Score de toucher des sorts"
-- /rb sum stat hastespell
L["Sum Spell Haste"] = "Hâte des sorts"
L["Spell Haste <- Spell Haste Rating"] = "Total Hâte des sorts = Score de hâte des sorts"
-- /rb sum stat mp5
L["Sum Mana Regen"] = "Mp5"
L["Mana Regen <- Mana Regen, Spirit"] = "Total Régénération de mana = Régénération de mana + Esprit"
-- /rb sum stat mp5nc
L["Sum Mana Regen while not casting"] = "Mp5 (repos)"
L["Mana Regen while not casting <- Spirit"] = "Total Régénération de mana hors incantation = Esprit"
-- /rb sum stat hp5
L["Sum Health Regen"] = "Hp5"
L["Health Regen <- Health Regen"] = "Total Régénération de santé = Régénération de santé"
-- /rb sum stat hp5oc
L["Sum Health Regen when out of combat"] = "Hp5 (repos)"
L["Health Regen when out of combat <- Spirit"] = "Total Régénération de santé hors combat = Régénération de santé + Esprit"
-- /rb sum stat armor
L["Sum Armor"] = "Armure"
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Total Armure = Armure des objets + Armure bonus + Agilité + Intelligence"
-- /rb sum stat blockvalue
L["Sum Block Value"] = "Valeur de blocage"
L["Block Value <- Block Value, Strength"] = "Total Valeur de blocage = Valeur de blocage + Force"
-- /rb sum stat dodge
L["Sum Dodge Chance"] = "Esquive"
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Total Esquive = Score d'esquive + Agilité + Score de défense"
-- /rb sum stat parry
L["Sum Parry Chance"] = "Parade"
L["Parry Chance <- Parry Rating, Defense Rating"] = "Total Parade = Score de parade + Score de défense"
-- /rb sum stat block
L["Sum Block Chance"] = "Chance de blocage"
L["Block Chance <- Block Rating, Defense Rating"] = "Total Chance de blocage = Score de blocage + Score de défense"
-- /rb sum stat avoidhit
L["Sum Hit Avoidance"] = "Évitement des coups"
L["Hit Avoidance <- Defense Rating"] = "Total Évitement des coups = Score de défense"
-- /rb sum stat avoidcrit
L["Sum Crit Avoidance"] = "Évitement CC"
L["Crit Avoidance <- Defense Rating, Resilience"] = "Total Évitement des Coups critiques = Score de défense + Résilience"
-- /rb sum stat neglectdodge
L["Sum Dodge Neglect"] = "Réduction Esquive"
L["Dodge Neglect <- Expertise, Weapon Skill Rating"] = "Total Réduction d'esquive = Expertise + Compétence d'arme"
-- /rb sum stat neglectparry
L["Sum Parry Neglect"] = "Réduction Parade"
L["Parry Neglect <- Expertise, Weapon Skill Rating"] = "Total Réduction de parade = Expertise + Compétence d'arme"
-- /rb sum stat neglectblock
L["Sum Block Neglect"] = "Réduction Blocage"
L["Block Neglect <- Weapon Skill Rating"] = "Total Réduction de blocage = Compétence d'arme"
-- /rb sum stat resarcane
L["Sum Arcane Resistance"] = "Résistance : arcanes"
L["Arcane Resistance Summary"] = "Inclure la Résistance aux arcanes."
-- /rb sum stat resfire
L["Sum Fire Resistance"] = "Résistance : feu"
L["Fire Resistance Summary"] = "Inclure la Résistance au feu."
-- /rb sum stat resnature
L["Sum Nature Resistance"] = "Résistance : nature"
L["Nature Resistance Summary"] = "Inclure la Résistance à la nature."
-- /rb sum stat resfrost
L["Sum Frost Resistance"] = "Résistance : givre"
L["Frost Resistance Summary"] = "Inclure la Résistance au givre."
-- /rb sum stat resshadow
L["Sum Shadow Resistance"] = "Résistance : ombre"
L["Shadow Resistance Summary"] = "Inclure la Résistance à l'ombre."
-- /rb sum stat maxdamage
L["Sum Weapon Max Damage"] = "Dégâts des armes"
L["Weapon Max Damage Summary"] = "Inclure les dégâts des armes."
-- /rb sum stat pen
L["Sum Penetration"] = "Pénétration des sorts"
L["Spell Penetration Summary"] = "Inclure la Pénétration des sorts."
-- /rb sum stat ignorearmor
L["Sum Ignore Armor"] = "Pénétration d'armure"
L["Ignore Armor Summary"] = "Inclure la Pénétration d'armure."
-- /rb sum stat weapondps
--["Sum Weapon DPS"] = true,
--["Weapon DPS Summary"] = true,
-- /rb sum statcomp str
L["Sum Strength"] = "Force"
L["Strength Summary"] = "Inclure la  Force."
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
L["Crit Rating Summary"] = "Inclure le Score de critique."
-- /rb sum statcomp hasterating
L["Sum Haste Rating"] = "Score de hâte"
L["Haste Rating Summary"] = "Inclure le Score de hâte."
-- /rb sum statcomp hitspellrating
L["Sum Spell Hit Rating"] = "Score de toucher des sorts"
L["Spell Hit Rating Summary"] = "Inclure le Score de toucher des sorts."
-- /rb sum statcomp critspellrating
L["Sum Spell Crit Rating"] = "Score de critique des sorts"
L["Spell Crit Rating Summary"] = "Inclure le Score de critique des sorts."
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
L["Defense <- Defense Rating"] = "Défense = Score de défense"
-- /rb sum statcomp wpn
L["Sum Weapon Skill"] = "Compétence d'arme"
L["Weapon Skill <- Weapon Skill Rating"] = "Compétence d'arme = Score de compétence d'arme"
-- /rb sum statcomp exp -- 2.3.0
L["Sum Expertise"] = "Expertise"
L["Expertise <- Expertise Rating"] = "Total Expertise = Score d'expertise"
-- /rb sum statcomp tp
L["Sum TankPoints"] = "TankPoints"
L["TankPoints <- Health, Total Reduction"] = "TankPoints = Vie + Réduction totale"
-- /rb sum statcomp tr
L["Sum Total Reduction"] = "Réduction complète"
L["Total Reduction <- Armor, Dodge, Parry, Block, Block Value, Defense, Resilience, MobMiss, MobCrit, MobCrush, DamageTakenMods"] = "Total Réduction complète = Armure + Equive + Parade + Blocage + Valeur de blocage + Défense + Résilience + MobMiss, MobCrit, MobCrush, DamageTakenMods"
-- /rb sum statcomp avoid
L["Sum Avoidance"] = "Évitement"
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Total Évitement = Esquive + Parade + Raté + Blocage(optionnel)"
-- /rb sum gem
L["Gems"] = "Gemmes"
L["Auto fill empty gem slots"] = "Remplir automatiquement les châsses."
-- /rb sum gem red
L["Red Socket"] = EMPTY_SOCKET_RED
L["ItemID or Link of the gem you would like to auto fill"] = "ID ou lien (maj+clic) de la gemme que vous voudriez utliser."
--["<ItemID|Link>"] = true,
L["%s is now set to %s"] = "%s supposera désormais %s."
L["Queried server for Gem: %s. Try again in 5 secs."] = "Requête serveur pour : %s. Rééssayez dans 5 secondes."
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
	{pattern = " de (%d+)", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)", addInfo = "AfterStat",},
	{pattern = "augmente.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "ajoute (%d+) (à|au))", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
L["separators"] = {
	"/", " et ", ",", "%. ", " pour ", "&", " : "
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
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
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
	{pattern = "score de critique", id = CR_CRIT_MELEE}, --ex : https://fr.tbc.wowhead.com/item=30565/opale-de-feu-dassassin
	{pattern = "score de coup critique", id = CR_CRIT_MELEE},
	{pattern = "score de toucher critique", id = CR_CRIT_MELEE},

	{pattern = "score de toucher des sorts", id = CR_HIT_SPELL},
	{pattern = "score de toucher à distance", id = CR_HIT_RANGED},
	{pattern = "score de toucher", id = CR_HIT_MELEE},
	
	{pattern = "résilience", id = CR_CRIT_TAKEN_MELEE}, -- resilience is implicitly a rating

	{pattern = "score de hâte des sorts", id = CR_HASTE_SPELL},
	{pattern = "score de hâte à distance", id = CR_HASTE_RANGED},
	{pattern = "score de hâte", id = CR_HASTE_MELEE},
	{pattern = "score de hâte en mêlée", id = CR_HASTE_MELEE}, -- [Tambours de Bataille] doesn't work
	--{pattern = "score de hâte en mêlée, à distance et avec les sorts", id = CR_HASTE_SPELL}, --complete line for drums buff, doesn't work
	{pattern = "score d’expertise", id = CR_EXPERTISE},
	{pattern = "score d'expertise", id = CR_EXPERTISE},
	{pattern = "score d'évitement des coups", id = CR_HIT_TAKEN_MELEE},

	--[[
	{pattern = "score de la compétence dagues", id = CR_WEAPON_SKILL}, {pattern = "Dagues augmentées", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence epées", id = CR_WEAPON_SKILL}, {pattern = "Epées augmentées", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence epées à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence haches", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence arcs", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence arbalètes", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence fusils", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence combat farouche", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence masses", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence armes d'hast", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence bâton", id = CR_WEAPON_SKILL},	
	{pattern = "score de la compétence haches à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence masses à deux mains", id = CR_WEAPON_SKILL},
	{pattern = "score de la compétence armes de pugilat", id = CR_WEAPON_SKILL},
	--]]
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
L["$value MP"] = "$value PM"
L["$value AP"] = "$value PA"
L["$value RAP"] = "$value PA dist."
L["$value Dmg"] = "$value dégâts"
L["$value Heal"] = "$value soins"
L["$value Armor"] = "$value armure"
L["$value Block"] = "$value blocage"
L["$value MP5"] = "$value Mp5"
L["$value MP5(NC)"] = "$value Mp5(repos)"
L["$value HP5"] = "$value Hp5"
L["$value to be Dodged/Parried"] = "$value esquivé/paré"
L["$value to be Crit"] = "$value recevoir CC"
L["$value Crit Dmg Taken"] = "$value dégâts CC"
L["$value DOT Dmg Taken"] = "$value dégâts DoT"

------------------
-- Stat Summary --
------------------
L["Stat Summary"] = "Résumé Stats"
