--[[
Name: RatingBuster frFR locale (incomplete)
Revision: $Revision: 73696 $
Translated by: Tixu@Curse, Silaor, renchap

--]]

local _, addon = ...

---@type RatingBusterLocale
local L = LibStub("AceLocale-3.0"):NewLocale("RatingBuster", "frFR")
if not L then return end
local StatLogic = LibStub("StatLogic")
L["RatingBuster Options"] = "RatingBuster Options"
---------------------------
-- Slash Command Options --
---------------------------
-- /rb help
L["Help"] = "Help"
L["Show this help message"] = "Show this help message"
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
L["Enable integration with Blizzard Reforging UI"] = "Enable integration with Blizzard Reforging UI"
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
L["Convert Weapon Skill into Crit, Hit, Dodge Reduction, Parry Reduction and Block Reduction"] = "Convertis le score de compétence d'arme en coups critiques, toucher, diminution d'esquive, diminution de parade et diminution de blocage."
-- /rb rating exp -- 2.3.0
L["Expertise breakdown"] = "Expertise détaillée"
L["Convert Expertise into Dodge Reduction and Parry Reduction"] = "Convertis le score d'expertise en pourcentage de diminution d'esquive et diminution de parade."

-- /rb stat
L["Stat Breakdown"] = "Détail des caractéristiques"
L["Changes the display of base stats"] = "Sélectionne les différents bonus liés aux caractéristiques principales à inclure dans les info-bulles des objets."
-- /rb stat show
L["Show base stat conversions"] = "Aperçu détaillé"
L["Show base stat conversions in tooltips"] = "Ajoute un aperçu détaillé des différents bonus liés aux caractéristiques principales dans les info-bulles des objets.\n\nCette case est requise pour l'affichage des différents bonus liés à l'Agilité, l'Endurance, l'Esprit, la Force et l'Intelligence."
-- Hack to keep French articles correct with/without vowels.
-- Blizzard provides an escape sequence for d'/de but not l'/la
-- Doesn't support masculine/plural, but as of now it doesn't need to.
---@class ArticleString : string
L["Changes the display of %s"] = {
	translation = "Sélectionne les différents bonus liés à %s%s.",
	vowels = {
		["a"] = true,
		["e"] = true,
		["i"] = true,
		["o"] = true,
		["u"] = true,
	},
	format = function(self, stat)
		local article = "la "
		local char = stat:utf8sub(1, 1):utf8lower()
		if self.vowels[char] then
			article = "l'"
		end
		return self.translation:format(article, stat)
	end
}
---------------------------------------------------------------------------
-- /rb sum
L["Stat Summary"] = "Résumé Stats"
L["Options for stat summary"] = "Un résumé des différents bonus apportés par les statistiques peut être inclu dans les info-bulles des objets."
L["Sum %s"] = "%s"
-- /rb sum show
L["Show stat summary"] = "Afficher le résumé"
L["Show stat summary in tooltips"] = "Ajoute un résumé de tous les bonus provenant des différentes statistiques dans les info-bulles des objets."
-- /rb sum ignore
L["Ignore settings"] = "Valeurs à ignorer"
L["Ignore stuff when calculating the stat summary"] = "Sélectionne les valeurs à ignorer lors des calculs du résumé."
-- /rb sum ignore unused
L["Ignore unused item types"] = "Objets non utilisables"
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
L["Ignore extra sockets"] = "Ignore extra sockets"
L["Ignore sockets from professions or consumable items when calculating the stat summary"] = "Ignore sockets from professions or consumable items when calculating the stat summary"
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
L["Health <- Health, Stamina"] = "Inclure les Points de vie conférés par : Points de vie + Endurance."
-- /rb sum stat mp
L["Mana <- Mana, Intellect"] = "Inclure les Points de mana conférés par : Points de mana + Intelligence."
-- /rb sum stat ap
L["Attack Power <- Attack Power, Strength, Agility"] = "Inclure la Puissance d'attaque conférée par : Puissance d'attaque + Force + Agilité."
-- /rb sum stat rap
L["Ranged Attack Power <- Ranged Attack Power, Intellect, Attack Power, Strength, Agility"] = "Inclure la Puissance d'attaque à distance conférée par : Puissance d'attaque à distance + Intelligence + Puissance d'attaque + Force + Agilité."
-- /rb sum stat dmg
L["Spell Damage <- Spell Damage, Intellect, Spirit, Stamina"] = "Inclure les Dégâts des sorts conférés par : Dégâts des sorts + Intelligence + Esprit + Endurance."
-- /rb sum stat dmgholy
L["Holy Spell Damage <- Holy Spell Damage, Spell Damage, Intellect, Spirit"] = "Inclure les Dégâts du Sacré conférés par : Dégâts du Sacré + Dégâts des sorts + Intelligence + Esprit."
-- /rb sum stat dmgarcane
L["Arcane Spell Damage <- Arcane Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts des Arcanes conférés par : Dégâts des Arcanes + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgfire
L["Fire Spell Damage <- Fire Spell Damage, Spell Damage, Intellect, Stamina"] = "Inclure les Dégâts de Feu conférés par : Dégâts de Feu + Dégâts des sorts + Intelligence + Endurance."
-- /rb sum stat dmgnature
L["Nature Spell Damage <- Nature Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts de Nature conférés par : Dégâts de Nature + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgfrost
L["Frost Spell Damage <- Frost Spell Damage, Spell Damage, Intellect"] = "Inclure les Dégâts de Givre conférés par : Dégâts de Givre + Dégâts des sorts + Intelligence."
-- /rb sum stat dmgshadow
L["Shadow Spell Damage <- Shadow Spell Damage, Spell Damage, Intellect, Spirit, Stamina"] = "Inclure les Dégâts d'Ombre conférés par : Dégâts d'Ombre + Dégâts des sorts + Intelligence + Esprit + Endurance."
-- /rb sum stat heal
L["Healing <- Healing, Intellect, Spirit, Agility, Strength"] = "Inclure la Puissance des soins conférée par : Puissance des soins + Intelligence + Esprit + Agilité + Force."
-- /rb sum stat hit
L["Hit Chance <- Hit Rating, Weapon Skill Rating"] = "Inclure le pourcentage de Toucher conféré par : Score de toucher + Compétence d'arme."
-- /rb sum stat crit
L["Crit Chance <- Crit Rating, Agility, Weapon Skill Rating"] = "Inclure le pourcentage de Coups critiques conféré par : Score de coup critique + Agilité + Compétence d'arme."
-- /rb sum stat haste
L["Haste <- Haste Rating"] = "Inclure le pourcentage de Hâte conféré par : le Score de hâte."
L["Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"] = "Ranged Hit Chance <- Hit Rating, Weapon Skill Rating, Ranged Hit Rating"
-- /rb sum physical rangedcrit
L["Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"] = "Ranged Crit Chance <- Crit Rating, Agility, Weapon Skill Rating, Ranged Crit Rating"
-- /rb sum physical rangedhaste
L["Ranged Haste <- Haste Rating, Ranged Haste Rating"] = "Ranged Haste <- Haste Rating, Ranged Haste Rating"
-- /rb sum stat critspell
L["Spell Crit Chance <- Spell Crit Rating, Intellect"] = "Inclure le pourcentage de Coups critiques des sorts conféré par : Score de coup critique des sorts + Intelligence."
-- /rb sum stat hitspell
L["Spell Hit Chance <- Spell Hit Rating"] = "Inclure le pourcentage de Toucher des Sorts conféré par le Score de toucher des sorts."
-- /rb sum stat hastespell
L["Spell Haste <- Spell Haste Rating"] = "Inclure le pourcentage de Hâte des sorts conféré par le Score de hâte des sorts."
-- /rb sum stat mp5
L["Mana Regen <- Mana Regen, Spirit"] = "Inclure la Régén. mana pendant l'incantation des sorts conférée par : Régén. mana + Esprit."
-- /rb sum stat mp5nc
L["Mana Regen while not casting <- Spirit"] = "Inclure la Régén. mana hors incantation conférée par l'Esprit."
-- /rb sum stat hp5
L["Health Regen <- Health Regen"] = "Inclure la Régén. vie en combat conférée par la Régén. vie."
-- /rb sum stat hp5oc
L["Health Regen when out of combat <- Spirit"] = "Inclure la Régén. vie hors combat conférée par l'Esprit."
-- /rb sum stat armor
L["Armor <- Armor from items, Armor from bonuses, Agility, Intellect"] = "Inclure l'Armure conférée par : Armure des objets + Armure bonus + Agilité + Intelligence."
-- /rb sum stat blockvalue
L["Block Value <- Block Value, Strength"] = "Inclure la Valeur de blocage conférée par : Valeur de blocage + Force."
-- /rb sum stat dodge
L["Dodge Chance <- Dodge Rating, Agility, Defense Rating"] = "Inclure l'Esquive conférée par : Score d'esquive + Agilité + Score de défense."
-- /rb sum stat parry
L["Parry Chance <- Parry Rating, Defense Rating"] = "Inclure la Parade conférée par : Score de parade + Score de défense."
-- /rb sum stat block
L["Block Chance <- Block Rating, Defense Rating"] = "Inclure les Chances de bloquer conférées par : Score de blocage + Score de défense."
-- /rb sum stat avoidhit
L["Hit Avoidance <- Defense Rating"] = "Inclure le pourcentage d'Évitement des coups conféré par le Score de défense."
-- /rb sum stat avoidcrit
L["Crit Avoidance <- Defense Rating, Resilience"] = "Inclure le pourcentage d'Évitement des Coups critiques conféré par : Score de défense + Résilience."
-- /rb sum stat Reductiondodge
L["Dodge Reduction <- Expertise, Weapon Skill Rating"] = "Inclure le pourcentage de Diminution d'esquive conféré par : Expertise + Compétence d'arme."
-- /rb sum stat Reductionparry
L["Parry Reduction <- Expertise, Weapon Skill Rating"] = "Inclure le pourcentage de Diminution de parade conféré par : Expertise + Compétence d'arme."

-- /rb sum statcomp def
L["Defense <- Defense Rating"] = "Inclure la valeur de Défense conférée par le Score de défense."
-- /rb sum statcomp wpn
L["Weapon Skill <- Weapon Skill Rating"] = "Inclure la Compétence d'arme conférée par le Score de compétence d'arme."
-- /rb sum statcomp exp -- 2.3.0
L["Expertise <- Expertise Rating"] = "Inclure la valeur d'Expertise conférée par le Score d'expertise."
-- /rb sum statcomp avoid
L["Avoidance <- Dodge, Parry, MobMiss, Block(Optional)"] = "Inclure l'Évitement conféré par : Esquive + Parade + Raté + Blocage(optionnel)."
-- /rb sum gem
L["Gems"] = "Gemmes"
L["Auto fill empty gem slots"] = "Simuler le sertissage de gemmes."
L["ItemID or Link of the gem you would like to auto fill"] = "ID ou lien (maj+clic) de la gemme que vous voulez simuler."
--["<ItemID|Link>"] = true,
L["%s is now set to %s"] = "%s simulera désormais %s."
L["Queried server for Gem: %s. Try again in 5 secs."] = "Requête serveur pour : %s. Rééssayez dans 5 secondes."

----------------------
-- Item Level and ID --
-----------------------
L["ItemLevel: "] = "Niveau Objet : "
L["ItemID: "] = "ID Objet : "

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
	{pattern = " de (%d+)%f[^%d%%]", addInfo = "AfterNumber",},
	{pattern = "([%+%-]%d+)%f[^%d%%]", addInfo = "AfterStat",},
	{pattern = "augmente.-(%d+)", addInfo = "AfterNumber",}, -- for "grant you xx stat" type pattern, ex: Quel'Serrar, Assassination Armor set
	{pattern = "ajoute (%d+) (à|au))", addInfo = "AfterNumber",}, -- for "add xx stat" type pattern, ex: Adamantite Sharpening Stone
	-- Added [^%%] so that it doesn't match strings like "Increases healing by up to 10% of your total Intellect." [Whitemend Pants] ID: 24261
	-- Added [^|] so that it doesn't match enchant strings (JewelTips)
	{pattern = "(%d+)([^%d%%|]+)", addInfo = "AfterStat",}, -- [發光的暗影卓奈石] +6法術傷害及5耐力
}
-- Exclusions are used to ignore instances of separators that should not get separated
L["exclusions"] = {
}
L["separators"] = {
	"/", " et ", ",", "%. ", " pour ", "&", " : ", "\n"
}
--[[
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
--]]
L["statList"] = {
	{SPELL_STAT1_NAME:lower(), StatLogic.Stats.Strength}, -- Strength
	{SPELL_STAT2_NAME:lower(), StatLogic.Stats.Agility}, -- Agility
	{SPELL_STAT3_NAME:lower(), StatLogic.Stats.Stamina}, -- Stamina
	{SPELL_STAT4_NAME:lower(), StatLogic.Stats.Intellect}, -- Intellect
	{SPELL_STAT5_NAME:lower(), StatLogic.Stats.Spirit}, -- Spirit
	{"score de défense", StatLogic.Stats.DefenseRating},
	{"score d’esquive", StatLogic.Stats.DodgeRating},
	{"score d'esquive", StatLogic.Stats.DodgeRating},
	{"score de blocage", StatLogic.Stats.BlockRating}, --Ench. de bouclier (Blocage inférieur)
	{"score de Maîtrise du blocage", StatLogic.Stats.BlockRating}, --Ench. de bouclier (Maîtrise du blocage)
	{"score de parade", StatLogic.Stats.ParryRating},

	{"score de critique des sorts", StatLogic.Stats.SpellCritRating},
	{"score de coup critique des sorts", StatLogic.Stats.SpellCritRating},
	{"score de toucher critique des sorts", StatLogic.Stats.SpellCritRating},
	{"score de critique à distance", StatLogic.Stats.RangedCritRating},
	{"score de coup critique à distance", StatLogic.Stats.RangedCritRating},
	{"score de toucher critique à distance", StatLogic.Stats.RangedCritRating},
	{"score de critique", StatLogic.Stats.CritRating}, --ex : https://fr.tbc.wowhead.com/item=30565/opale-de-feu-dassassin
	{"score de coup critique", StatLogic.Stats.CritRating},
	{"score de toucher critique", StatLogic.Stats.CritRating},

	{"score de toucher des sorts", StatLogic.Stats.SpellHitRating},
	{"score de toucher à distance", StatLogic.Stats.RangedHitRating},
	{"score de toucher", StatLogic.Stats.HitRating},

	{"résilience", StatLogic.Stats.ResilienceRating}, -- resilience is implicitly a rating

	{"score de hâte des sorts", StatLogic.Stats.SpellHasteRating},
	{"score de hâte à distance", StatLogic.Stats.RangedHasteRating},
	{"score de hâte", StatLogic.Stats.HasteRating},
	{"score de hâte en mêlée", StatLogic.Stats.MeleeHasteRating}, -- [Tambours de Bataille] "score de hâte en mêlée, à distance et avec les sorts" complete drums line
	{"score d’expertise", StatLogic.Stats.ExpertiseRating},
	{"score d'expertise", StatLogic.Stats.ExpertiseRating},

	{SPELL_STATALL:lower(), StatLogic.Stats.AllStats},

	{"pénétration d'armure", StatLogic.Stats.ArmorPenetrationRating},
	{"maîtrise", StatLogic.Stats.MasteryRating},
	{ARMOR:lower(), StatLogic.Stats.Armor},
	{"puissance d'attaque", StatLogic.Stats.AttackPower},
}
-------------------------
-- Added info patterns --
-------------------------
-- $value will be replaced with the number
-- EX: "$value Crit" -> "+1.34% Crit"
-- EX: "Crit $value" -> "Crit +1.34%"
L["$value Crit"] = "$value CC"
L["$value Spell Crit"] = "$value CC sorts"
L["$value Dodge"] = "$value esquive"
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
L["$value HP5(NC)"] = "$value Hp5 (hors combat)"
L["$value to be Dodged/Parried"] = "$value esquivé/paré"
L["$value to be Crit"] = "$value recevoir CC"
L["$value Crit Dmg Taken"] = "$value dégâts CC"
L["$value DOT Dmg Taken"] = "$value dégâts DoT"
L["$value PvP Damage Taken"] = "$value PvP Damage Taken"
L["$value Parry"] = "$value parer"
-- for hit rating showing both physical and spell conversions
-- (+1.21%, S+0.98%)
-- (+1.21%, +0.98% S)
L["$value Spell"] = "$value Sort"
L["$value Spell Hit"] = "$value toucher sorts"

L[StatLogic.Stats.ManaRegen] = "Régén. mana (incantation)"
L[StatLogic.Stats.ManaRegenNotCasting] = "Régén. mana (hors incantation)"
L[StatLogic.Stats.ManaRegenOutOfCombat] = "Régén. mana (hors combat)"
if addon.tocversion > 40000 then
	L[StatLogic.Stats.ManaRegenNotCasting] =  L[StatLogic.Stats.ManaRegenOutOfCombat]
end
L[StatLogic.Stats.HealthRegen] = "Régén. vie (combat)"
L[StatLogic.Stats.HealthRegenOutOfCombat] = "Régén. vie (hors combat)"
L["Show %s"] = "%s"

L[StatLogic.Stats.IgnoreArmor] = "Armure ignorée"
L[StatLogic.Stats.AverageWeaponDamage] = "Dégâts de l'arme"

L[StatLogic.Stats.Strength] = "Force"
L[StatLogic.Stats.Agility] = "Agilité"
L[StatLogic.Stats.Stamina] = "Endurance"
L[StatLogic.Stats.Intellect] = "Intelligence"
L[StatLogic.Stats.Spirit] = "Esprit"
L[StatLogic.Stats.Armor] = "Armure"

L[StatLogic.Stats.FireResistance] = "Résistance au Feu"
L[StatLogic.Stats.NatureResistance] = "Résistance à la Nature"
L[StatLogic.Stats.FrostResistance] = "Résistance au Givre"
L[StatLogic.Stats.ShadowResistance] = "Résistance à l'Ombre"
L[StatLogic.Stats.ArcaneResistance] = "Résistance aux Arcanes"

L[StatLogic.Stats.BlockValue] = "Valeur de blocage"

L[StatLogic.Stats.AttackPower] = "Puissance d'attaque"
L[StatLogic.Stats.RangedAttackPower] = "Puissance d'attaque à distance"
L[StatLogic.Stats.FeralAttackPower] = "Puissance d'attaque Farouche"

L[StatLogic.Stats.HealingPower] = "Puissance des soins"

L[StatLogic.Stats.SpellPower] = STAT_SPELLPOWER
L[StatLogic.Stats.SpellDamage] = "Dégâts des sorts"
L[StatLogic.Stats.HolyDamage] = "Dégâts des sorts du Sacré"
L[StatLogic.Stats.FireDamage] = "Dégâts des sorts de Feu"
L[StatLogic.Stats.NatureDamage] = "Dégâts des sorts de Nature"
L[StatLogic.Stats.FrostDamage] = "Dégâts des sorts de Givre"
L[StatLogic.Stats.ShadowDamage] = "Dégâts des sorts d'Ombre"
L[StatLogic.Stats.ArcaneDamage] = "Dégâts des sorts des Arcanes"

L[StatLogic.Stats.SpellPenetration] = "Pénétration des sorts"

L[StatLogic.Stats.Health] = "Points de vie"
L[StatLogic.Stats.Mana] = "Points de mana"

L[StatLogic.Stats.WeaponDPS] = "Dégâts par seconde"

L[StatLogic.Stats.DefenseRating] = "Score de défense"
L[StatLogic.Stats.DodgeRating] = "Score d'esquive"
L[StatLogic.Stats.ParryRating] = "Score de parade"
L[StatLogic.Stats.BlockRating] = "Score de blocage"
L[StatLogic.Stats.MeleeHitRating] = "Score de toucher"
L[StatLogic.Stats.RangedHitRating] = "Score de toucher à distance"
L[StatLogic.Stats.SpellHitRating] = "Score de toucher des sorts"
L[StatLogic.Stats.MeleeCritRating] = "Score de coup critique"
L[StatLogic.Stats.RangedCritRating] = "Score de coup critique à distance"
L[StatLogic.Stats.SpellCritRating] = "Score de coup critique des sorts"
L[StatLogic.Stats.ResilienceRating] = "Score de résilience"
L[StatLogic.Stats.MeleeHasteRating] = "Score de hâte"
L[StatLogic.Stats.RangedHasteRating] = "Score de hâte à distance"
L[StatLogic.Stats.SpellHasteRating] = "Score de hâte des sorts"
L[StatLogic.Stats.ExpertiseRating] = "Score d'Expertise"
L[StatLogic.Stats.ArmorPenetrationRating] = "Score de pénétration d'armure"
L[StatLogic.Stats.MasteryRating] = "Score de maîtrise"
L[StatLogic.Stats.CritDamageReduction] = "Diminution des dégâts des coups critiques en mêlée"
L[StatLogic.Stats.Defense] = "Défense"
L[StatLogic.Stats.Dodge] = "Esquive"
L[StatLogic.Stats.Parry] = "Parade"
L[StatLogic.Stats.BlockChance] = "Chances de bloquer"
L[StatLogic.Stats.Avoidance] = "Évitement"
L[StatLogic.Stats.MeleeHit] = "Toucher"
L[StatLogic.Stats.RangedHit] = "Toucher à distance"
L[StatLogic.Stats.SpellHit] = "Toucher des sorts"
L[StatLogic.Stats.Miss] = "Évitement des coups"
L[StatLogic.Stats.MeleeCrit] = "Coups critiques"
L[StatLogic.Stats.RangedCrit] = "Critiques à distance"
L[StatLogic.Stats.SpellCrit] = "Critiques des sorts"
L[StatLogic.Stats.CritAvoidance] = "Évitement des coups critiques"
L[StatLogic.Stats.MeleeHaste] = "Hâte"
L[StatLogic.Stats.RangedHaste] = "Hâte à distance"
L[StatLogic.Stats.SpellHaste] = "Hâte des sorts"
L[StatLogic.Stats.Expertise] = "Expertise"
L[StatLogic.Stats.ArmorPenetration] = "Pénétration d'armure"
L[StatLogic.Stats.Mastery] = STAT_MASTERY
L[StatLogic.Stats.MasteryEffect] = SPELL_LASTING_EFFECT:format(STAT_MASTERY)
L[StatLogic.Stats.DodgeReduction] = "Diminution d'Esquive"
L[StatLogic.Stats.ParryReduction] = "Diminution de Parade"
L[StatLogic.Stats.WeaponSkill] = "Compétence d'arme"