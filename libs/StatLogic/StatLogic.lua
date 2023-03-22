local addonName, addonTable = ...

--[[
Name: StatLogic-1.0
Description: A Library for stat conversion, calculation and summarization.
Revision: $Revision: 78899 $
Author: Whitetooth
Email: hotdogee [at] gmail [dot] com
LastUpdate: $Date: 2008-07-22 14:29:37 +0800 (星期二, 22 七月 2008) $
Website:
Documentation:
SVN: $URL: http://svn.wowace.com/wowace/trunk/StatLogicLib/StatLogic-1.0/StatLogic-1.0.lua $
Dependencies: LibStub, AceLocale-3.0, UTF8
License: LGPL v2.1
Features:
	StatConversion -
		Ratings -> Effect
		Str -> AP, Block
		Agi -> Crit, Dodge, AP, RAP, Armor
		Sta -> Health, SpellDmg(Talant)
		Int -> Mana, SpellCrit
		Spi -> MP5, HP5
		and more!
	StatMods - Get stat mods from talants and buffs for every class
	BaseStats - for all classes and levels
	ItemStatParser - Fast multi level indexing algorithm instead of calling strfind for every stat
]]

-- This library is still in early development, please consider not using this library until the documentation is writen on wowace.
-- Unless you don't mind putting up with breaking changes that may or may not happen during early development.

local MAJOR_VERSION = addonName
local MINOR_VERSION = tonumber(("$Revision: 78899 $"):sub(12, -3))

---------------
-- Libraries --
---------------
-- Pattern matching
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
-- Display text
local D = LibStub("AceLocale-3.0"):GetLocale(addonName.."D")


-------------------
-- Set Debugging --
-------------------
local DEBUG = false
function CmdHandler()
	DEBUG = not DEBUG
end
SlashCmdList["STATLOGICDEBUG"] = CmdHandler
SLASH_STATLOGICDEBUG1 = "/sldebug";

-- Uncomment below to log out log out every missing translation for each locale
-- L:EnableDebugging()
-- D:EnableDebugging()

-- Add all lower case strings to ["StatIDLookup"]
local strutf8lower = string.utf8lower
if type(L) == "table" and type(L["StatIDLookup"]) == "table" then
	local temp = {}
	for k, v in pairs(L["StatIDLookup"]) do
		temp[strutf8lower(k)] = v
	end
	for k, v in pairs(temp) do
		L["StatIDLookup"][k] = v
	end
end

--L:Debug()

--------------------
-- Initialization --
--------------------
---@class StatLogic
local StatLogic = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)

function StatLogic:argCheck(argument, number, ...)
	local arg = {...}
	local validTypeString = table.concat(arg, ", ")
	local t = type(argument)
	assert(
		arg[1] == t or
		arg[2] == t or
		arg[3] == t or
		arg[4] == t or
		arg[5] == t,
		"Bad argument #"..tostring(number).." ("..validTypeString.." expected, got "..t..")"
	)
end

-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection

--------------
-- Activate --
--------------
local tip, tipMiner

tip = CreateFrame("GameTooltip", "StatLogicTooltip", nil, "GameTooltipTemplate")
StatLogic.tip = tip
tip:SetOwner(UIParent, "ANCHOR_NONE")
for i = 1, 30 do
	tip[i] = _G["StatLogicTooltipTextLeft"..i]
	if not tip[i] then
		tip[i] = tip:CreateFontString()
		tip:AddFontStrings(tip[i], tip:CreateFontString())
	end
end

-- Create a custom tooltip for data mining
tipMiner = CreateFrame("GameTooltip", "StatLogicMinerTooltip", nil, "GameTooltipTemplate")
StatLogic.tipMiner = tipMiner
tipMiner:SetOwner(UIParent, "ANCHOR_NONE")
for i = 1, 30 do
	tipMiner[i] = _G["StatLogicMinerTooltipTextLeft"..i]
	if not tipMiner[i] then
		tipMiner[i] = tipMiner:CreateFontString()
		tipMiner:AddFontStrings(tipMiner[i], tipMiner:CreateFontString())
	end
end

local mt = getmetatable(tip)
local tipExtension = {
	__index = function(tooltip, i)
		if type(i) ~= "number" then
			return mt.__index[i]
		else
			local textLeft = _G[tooltip:GetName().."TextLeft"..i]
			tooltip[i] = textLeft
			return textLeft
		end
	end
}
setmetatable(tip, tipExtension)
setmetatable(tipMiner, tipExtension)

---------------------
-- Local Variables --
---------------------
-- Player info
addonTable.class = select(2, UnitClass("player"))
addonTable.playerRace = select(2, UnitRace("player"))

do
	local ClassNameToID = {}

	for i = 1, GetNumClasses(), 1 do
		local _, classFile = GetClassInfo(i)
		if classFile then
			ClassNameToID[classFile] = i
			ClassNameToID[i] = classFile
		end
	end

	function StatLogic:GetClassIdOrName(class)
		return ClassNameToID[class]
	end
end

function StatLogic:ValidateClass(class)
	if type(class) == "number" and StatLogic:GetClassIdOrName(class) then
		-- if class is a class id, convert to class string
		class = StatLogic:GetClassIdOrName(class)
	elseif type(class) ~= "string" or not StatLogic:GetClassIdOrName(class) then
		-- if class is not a string, or doesn't correspond to a class id, default to player class
		class = addonTable.class
	end
	return class
end

-- Localize globals
local _G = getfenv(0)
local strfind = strfind
local strsub = strsub
local strupper = strupper
local strutf8lower = string.utf8lower
local strmatch = strmatch
local strtrim = strtrim
local strsplit = strsplit
local strjoin = strjoin
local gmatch = gmatch
local gsub = gsub
local strutf8sub = string.utf8sub
local pairs = pairs
local ipairs = ipairs
local type = type
local tonumber = L.tonumber
local loadstring = loadstring
local GetInventoryItemLink = GetInventoryItemLink
local unpack = unpack
local IsUsableSpell = IsUsableSpell
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetTalentInfo = GetTalentInfo

---------------
-- Lua Tools --
---------------
-- metatable for stat tables
local statTableMetatable = {
	__index = function()
		return 0
	end,
	__add = function(op1, op2)
		if type(op2) == "table" then
			for k, v in pairs(op2) do
				if type(v) == "number" then
					op1[k] = (op1[k] or 0) + v
					if op1[k] == 0 then
						op1[k] = nil
					end
				end
			end
		end
		return op1
	end,
	__sub = function(op1, op2)
		if type(op2) == "table" then
			for k, v in pairs(op2) do
				if type(v) == "number" then
					op1[k] = (op1[k] or 0) - v
					if op1[k] == 0 then
						op1[k] = nil
					end
				elseif k == "itemType" then
					local i = 1
					while rawget(op1, "diffItemType"..i) do
						i = i + 1
					end
					op1["diffItemType"..i] = op2.itemType
				end
			end
		end
		return op1
	end,
}

-- Table pool borrowed from Tablet-2.0 (ckknight) --
local pool = {}

-- Delete table and return to pool
local function del(t)
	if t then
		for k in pairs(t) do
			t[k] = nil
		end
		setmetatable(t, nil)
		pool[t] = true
	end
end

-- Copy table
local function copy(parent)
	local t = next(pool) or {}
	pool[t] = nil
	if parent then
		for k,v in pairs(parent) do
			t[k] = v
		end
		setmetatable(t, getmetatable(parent))
	end
	return t
end

-- New table
local function new(...)
	local t = next(pool) or {}
	pool[t] = nil

	for i = 1, select('#', ...), 2 do
		local k = select(i, ...)
		if k then
			t[k] = select(i+1, ...)
		else
			break
		end
	end
	return t
end

-- New stat table
local function newStatTable(...)
	local t = next(pool) or {}
	pool[t] = nil
	setmetatable(t, statTableMetatable)

	for i = 1, select('#', ...), 2 do
		local k = select(i, ...)
		if k then
			t[k] = select(i+1, ...)
		else
			break
		end
	end
	return t
end

StatLogic.StatTable = {}
StatLogic.StatTable.new = newStatTable
StatLogic.StatTable.del = del
StatLogic.StatTable.copy = copy

-- End of Table pool --

-- deletes the contents of a table, then returns itself
local function clearTable(t)
	if t then
		for k in pairs(t) do
			if type(t[k]) == "table" then
				del(t[k]) -- child tables get put into the pool
			else
				t[k] = nil
			end
		end
		setmetatable(t, nil)
	end
	return t
end

-- copyTable
local function copyTable(to, from)
	if not clearTable(to) then
		to = new()
	end
	for k,v in pairs(from) do
		if type(k) == "table" then
			k = copyTable(new(), k)
		end
		if type(v) == "table" then
			v = copyTable(new(), v)
		end
		to[k] = v
	end
	setmetatable(to, getmetatable(from))
	return to
end


local function log(...)
	if DEBUG == true then
		print(...)
	end
end

-- SetTip("item:3185:0:0:0:0:0:1957")
function SetTip(item)
	local _, link = GetItemInfo(item)
	ItemRefTooltip:ClearLines()
	ItemRefTooltip:SetHyperlink(link)
	ItemRefTooltip:Show()
end

----------------
-- Stat Tools --
----------------
local function StripGlobalStrings(text)
	-- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
	text = gsub(text, "%%%%", "%%") -- "%%" -> "%"
	text = gsub(text, " ?%%%d?%.?%d?%$?[cdsgf]", "") -- delete "%d", "%s", "%c", "%g", "%2$d", "%.2f" and a space in front of it if found
	-- So StripGlobalStrings(ITEM_SOCKET_BONUS) = "Socket Bonus:"
	return text
end

function StatLogic:GetStatNameFromID(stat)
	local name = D[stat]
	if not name then return end
	return unpack(name)
end

StatLogic.ExtraHasteClasses = {}

do
	local GenericStats = {
		"CR_HIT",
		"CR_CRIT",
		"CR_HASTE",
		"ALL_STATS",
	}
	
	StatLogic.GenericStats = {}
	for i,v in ipairs(GenericStats) do
		StatLogic.GenericStats[v] = -i
	end
end

StatLogic.GenericStatMap = {
	[StatLogic.GenericStats.ALL_STATS] = {
		SPELL_STAT1_NAME, -- Strength
		SPELL_STAT2_NAME, -- Agility
		SPELL_STAT3_NAME, -- Stamina
		SPELL_STAT4_NAME, -- Intellect
		SPELL_STAT5_NAME, -- Spirit
	}
}

if not CR_WEAPON_SKILL then CR_WEAPON_SKILL = 1 end;
if not CR_DEFENSE_SKILL then CR_DEFENSE_SKILL = 2 end;
if not CR_DODGE then CR_DODGE = 3 end;
if not CR_PARRY then CR_PARRY = 4 end;
if not CR_BLOCK then CR_BLOCK = 5 end;
if not CR_HIT_MELEE then CR_HIT_MELEE = 6 end;
if not CR_HIT_RANGED then CR_HIT_RANGED = 7 end;
if not CR_HIT_SPELL then CR_HIT_SPELL = 8 end;
if not CR_CRIT_MELEE then CR_CRIT_MELEE = 9 end;
if not CR_CRIT_RANGED then CR_CRIT_RANGED = 10 end;
if not CR_CRIT_SPELL then CR_CRIT_SPELL = 11 end;
if not CR_HIT_TAKEN_MELEE then CR_HIT_TAKEN_MELEE = 12 end;
if not CR_HIT_TAKEN_RANGED then CR_HIT_TAKEN_RANGED = 13 end;
if not CR_HIT_TAKEN_SPELL then CR_HIT_TAKEN_SPELL = 14 end;
if not CR_CRIT_TAKEN_MELEE then CR_CRIT_TAKEN_MELEE = 15 end;
if not CR_CRIT_TAKEN_RANGED then CR_CRIT_TAKEN_RANGED = 16 end;
if not CR_CRIT_TAKEN_SPELL then CR_CRIT_TAKEN_SPELL = 17 end;
if not CR_HASTE_MELEE then CR_HASTE_MELEE = 18 end;
if not CR_HASTE_RANGED then CR_HASTE_RANGED = 19 end;
if not CR_HASTE_SPELL then CR_HASTE_SPELL = 20 end;
if not CR_WEAPON_SKILL_MAINHAND then CR_WEAPON_SKILL_MAINHAND = 21 end;
if not CR_WEAPON_SKILL_OFFHAND then CR_WEAPON_SKILL_OFFHAND = 22 end;
if not CR_WEAPON_SKILL_RANGED then CR_WEAPON_SKILL_RANGED = 23 end;
if not CR_EXPERTISE then CR_EXPERTISE = 24 end;
if not CR_ARMOR_PENETRATION then CR_ARMOR_PENETRATION = 25 end;

local RatingNameToID = {
	[StatLogic.GenericStats.CR_HIT] = "HIT_RATING",
	[StatLogic.GenericStats.CR_CRIT] = "CRIT_RATING",
	[StatLogic.GenericStats.CR_HASTE] = "HASTE_RATING",
	[CR_WEAPON_SKILL] = "WEAPON_RATING",
	[CR_DEFENSE_SKILL] = "DEFENSE_RATING",
	[CR_DODGE] = "DODGE_RATING",
	[CR_PARRY] = "PARRY_RATING",
	[CR_BLOCK] = "BLOCK_RATING",
	[CR_HIT_MELEE] = "MELEE_HIT_RATING",
	[CR_HIT_RANGED] = "RANGED_HIT_RATING",
	[CR_HIT_SPELL] = "SPELL_HIT_RATING",
	[CR_CRIT_MELEE] = "MELEE_CRIT_RATING",
	[CR_CRIT_RANGED] = "RANGED_CRIT_RATING",
	[CR_CRIT_SPELL] = "SPELL_CRIT_RATING",
	[CR_HIT_TAKEN_MELEE] = "MELEE_HIT_AVOID_RATING",
	[CR_HIT_TAKEN_RANGED] = "RANGED_HIT_AVOID_RATING",
	[CR_HIT_TAKEN_SPELL] = "SPELL_HIT_AVOID_RATING",
	[CR_CRIT_TAKEN_MELEE] = "MELEE_CRIT_AVOID_RATING",
	[CR_CRIT_TAKEN_RANGED] = "RANGED_CRIT_AVOID_RATING",
	[CR_CRIT_TAKEN_SPELL] = "SPELL_CRIT_AVOID_RATING",
	[CR_HASTE_MELEE] = "MELEE_HASTE_RATING",
	[CR_HASTE_RANGED] = "RANGED_HASTE_RATING",
	[CR_HASTE_SPELL] = "SPELL_HASTE_RATING",
	[CR_WEAPON_SKILL_MAINHAND] = "MAINHAND_WEAPON_RATING",
	[CR_WEAPON_SKILL_OFFHAND] = "OFFHAND_WEAPON_RATING",
	[CR_WEAPON_SKILL_RANGED] = "RANGED_WEAPON_RATING",
	[CR_EXPERTISE] = "EXPERTISE_RATING",
	[CR_ARMOR_PENETRATION] = "ARMOR_PENETRATION_RATING",
	["HIT_RATING"] = StatLogic.GenericStats.CR_HIT,
	["CRIT_RATING"] = StatLogic.GenericStats.CR_CRIT,
	["HASTE_RATING"] = StatLogic.GenericStats.CR_HASTE,
	["DEFENSE_RATING"] = CR_DEFENSE_SKILL,
	["DODGE_RATING"] = CR_DODGE,
	["PARRY_RATING"] = CR_PARRY,
	["BLOCK_RATING"] = CR_BLOCK,
	["MELEE_HIT_RATING"] = CR_HIT_MELEE,
	["RANGED_HIT_RATING"] = CR_HIT_RANGED,
	["SPELL_HIT_RATING"] = CR_HIT_SPELL,
	["MELEE_CRIT_RATING"] = CR_CRIT_MELEE,
	["RANGED_CRIT_RATING"] = CR_CRIT_RANGED,
	["SPELL_CRIT_RATING"] = CR_CRIT_SPELL,
	["MELEE_HIT_AVOID_RATING"] = CR_HIT_TAKEN_MELEE,
	["RANGED_HIT_AVOID_RATING"] = CR_HIT_TAKEN_RANGED,
	["SPELL_HIT_AVOID_RATING"] = CR_HIT_TAKEN_SPELL,
	["MELEE_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_MELEE,
	["RANGED_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_RANGED,
	["SPELL_CRIT_AVOID_RATING"] = CR_CRIT_TAKEN_SPELL,
	["RESILIENCE_RATING"] = CR_CRIT_TAKEN_MELEE,
	["MELEE_HASTE_RATING"] = CR_HASTE_MELEE,
	["RANGED_HASTE_RATING"] = CR_HASTE_RANGED,
	["SPELL_HASTE_RATING"] = CR_HASTE_SPELL,
	["DAGGER_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["SWORD_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_SWORD_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["AXE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_AXE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["MACE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["2H_MACE_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["GUN_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["CROSSBOW_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["BOW_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["FERAL_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["FIST_WEAPON_RATING"] = CR_WEAPON_SKILL,
	["WEAPON_RATING"] = CR_WEAPON_SKILL,
	["MAINHAND_WEAPON_RATING"] = CR_WEAPON_SKILL_MAINHAND,
	["OFFHAND_WEAPON_RATING"] = CR_WEAPON_SKILL_OFFHAND,
	["RANGED_WEAPON_RATING"] = CR_WEAPON_SKILL_RANGED,
	["EXPERTISE_RATING"] = CR_EXPERTISE,
	["ARMOR_PENETRATION_RATING"] = CR_ARMOR_PENETRATION,
}

function StatLogic:GetRatingIdOrName(rating)
	return RatingNameToID[rating]
end

local RatingIDToConvertedStat = {
	"WEAPON_SKILL",
	"DEFENSE",
	"DODGE",
	"PARRY",
	"BLOCK",
	"MELEE_HIT",
	"RANGED_HIT",
	"SPELL_HIT",
	"MELEE_CRIT",
	"RANGED_CRIT",
	"SPELL_CRIT",
	"MELEE_HIT_AVOID",
	"RANGED_HIT_AVOID",
	"SPELL_HIT_AVOID",
	"MELEE_CRIT_AVOID",
	"RANGED_CRIT_AVOID",
	"SPELL_CRIT_AVOID",
	"MELEE_HASTE",
	"RANGED_HASTE",
	"SPELL_HASTE",
	"WEAPON_SKILL",
	"WEAPON_SKILL",
	"WEAPON_SKILL",
	"EXPERTISE",
	"ARMOR_PENETRATION",
}

local function GetPlayerBuffRank(buff)
	local rank = GetSpellSubtext(buff)
	if rank then
		return tonumber(strmatch(rank, "(%d+)")) or 1
	end
end

local function GetTotalDefense(unit)
	local base, modifier = UnitDefense(unit);
	return base + modifier
end


--============--
-- Base Stats --
--============--
--[[
local RaceClassStatBase = {
	-- The Human Spirit - Increase Spirit by 5%
	Human = { --{20, 20, 20, 20, 21}
		WARRIOR = { --{3, 0, 2, 0, 0}
			{23, 20, 22, 20, 22}
		},
		PALADIN = { --{2, 0, 2, 0, 1}
			{22, 20, 22, 20, 23}
		},
		ROGUE = { --{1, 3, 1, 0, 0}
			{21, 23, 21, 20, 22}
		},
		PRIEST = { --{0, 0, 0, 2, 3}
			{20, 20, 20, 22, 25}
		},
		MAGE = { --{0, 0, 0, 3, 2}
			{20, 20, 20, 23, 24}
		},
		WARLOCK = { --{0, 0, 1, 2, 2}
			{20, 20, 21, 22, 24}
		},
	},
	Dwarf = { --{22, 16, 23, 19, 19}
		WARRIOR = {
			{25, 16, 25, 19, 19}
		},
		PALADIN = {
			{24, 16, 25, 19, 20}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{22, 19, 24, 19, 20}
		},
		ROGUE = {
			{23, 19, 24, 19, 19}
		},
		PRIEST = {
			{22, 16, 23, 21, 22}
		},
	},
	NightElf = { --{17, 25, 19, 20, 20}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{20, 25, 21, 20, 20}
		},
		HUNTER = {
			{17, 28, 20, 20, 21}
		},
		ROGUE = {
			{18, 28, 20, 20, 20}
		},
		PRIEST = {
			{17, 25, 19, 22, 23}
		},
		DRUID = { --{1, 0, 0, 2, 2}
			{18, 25, 19, 22, 22}
		},
	},
	-- Expansive Mind - Increase Intelligence by 5%
	Gnome = { --{15, 23, 19, 24, 20}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{18, 23, 21, 24, 20}
		},
		ROGUE = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
	Draenei = { --{21, 17, 19, 21, 22}
		WARRIOR = { --{3, 0, 2, 0, 0}
			{24, 17, 21, 21, 22}
		},
		PALADIN = { --{2, 0, 2, 0, 1}
			{23, 17, 21, 21, 23}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{21, 20, 20, 21, 23}
		},
		PRIEST = { --{0, 0, 0, 2, 3}
			{21, 17, 19, 23, 25}
		},
		SHAMAN = { --{1, 0, 1, 1, 2}
			{26, 15, 23, 16, 24}
		},
		MAGE = { --{0, 0, 0, 3, 2}
			{21, 17, 19, 24, 24}
		},
	},
	Orc = { --{23, 17, 22, 17, 23}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{26, 17, 24, 17, 23}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{23, 20, 23, 17, 24}
		},
		ROGUE = { --{1, 3, 1, 0, 0}
			{, , , , }
		},
		SHAMAN = { --{1, 0, 1, 1, 2}
			{24, 17, 23, 18, 25}
		},
		WARLOCK = { --{0, 0, 1, 2, 2}
			{, , , , }
		},
	},
	Scourge = { --{19, 18, 21, 18, 25}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{22, 18, 23, 18, 25}
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
	Tauren = { --{25, 15, 22, 15, 22}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{28, 15, 24, 15, 22}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{, , , , }
		},
		SHAMAN = {
			{, , , , }
		},
		DRUID = { --{1, 0, 0, 2, 2}
			{26, 15, 22, 17, 24}
		},
	},
	Troll = { --{21, 22, 21, 16, 21}
		WARRIOR = {--{3, 0, 2, 0, 0}
			{24, 22, 23, 16, 21}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{, , , , }
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		SHAMAN = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
	},
	BloodElf = { --{17, 22, 18, 24, 19}
		PALADIN = {--{2, 0, 2, 0, 1}
			{24, 16, 25, 19, 20}
		},
		HUNTER = { --{0, 3, 1, 0, 1}
			{21, 25, 22, 16, 22}
		},
		ROGUE = {
			{, , , , }
		},
		PRIEST = {
			{, , , , }
		},
		MAGE = {
			{, , , , }
		},
		WARLOCK = {
			{, , , , }
		},
	},
}
--]]
local RaceBaseStat = {
	["Human"] = {20, 20, 20, 20, 21},
	["Dwarf"] = {22, 16, 23, 19, 19},
	["NightElf"] = {17, 25, 19, 20, 20},
	["Gnome"] = {15, 23, 19, 24, 20},
	["Draenei"] = {21, 17, 19, 21, 22},
	["Orc"] = {23, 17, 22, 17, 23},
	["Scourge"] = {19, 18, 21, 18, 25},
	["Tauren"] = {25, 15, 22, 15, 22},
	["Troll"] = {21, 22, 21, 16, 21},
	["BloodElf"] = {17, 22, 18, 24, 19},
}
local ClassBonusStat = {
	["DRUID"] = {1, 0, 0, 2, 2},
	["HUNTER"] = {0, 3, 1, 0, 1},
	["MAGE"] = {0, 0, 0, 3, 2},
	["PALADIN"] = {2, 0, 2, 0, 1},
	["PRIEST"] = {0, 0, 0, 2, 3},
	["ROGUE"] = {1, 3, 1, 0, 0},
	["SHAMAN"] = {1, 0, 1, 1, 2},
	["WARLOCK"] = {0, 0, 1, 2, 2},
	["WARRIOR"] = {3, 0, 2, 0, 0},
}
local ClassBaseHealth = {
	["DRUID"] = 54,
	["HUNTER"] = 46,
	["MAGE"] = 52,
	["PALADIN"] = 38,
	["PRIEST"] = 52,
	["ROGUE"] = 45,
	["SHAMAN"] = 47,
	["WARLOCK"] = 43,
	["WARRIOR"] = 40,
}
local ClassBaseMana = {
	["DRUID"] = 70,
	["HUNTER"] = 85,
	["MAGE"] = 120,
	["PALADIN"] = 80,
	["PRIEST"] = 130,
	["ROGUE"] = 0,
	["SHAMAN"] = 75,
	["WARLOCK"] = 110,
	["WARRIOR"] = 0,
}
--http://wowvault.ign.com/View.php?view=Stats.List&category_select_id=9

--==================================--
-- Stat Mods from Talants and Buffs --
--==================================--
--[[ Aura mods from Thottbot
Apply Aura: Mod Total Stat % (All stats)
Apply Aura: Mod Total Stat % (Strength)
Apply Aura: Mod Total Stat % (Agility)
Apply Aura: Mod Total Stat % (Stamina)
Apply Aura: Mod Total Stat % (Intellect)
Apply Aura: Mod Total Stat % (Spirit)
Apply Aura: Mod Max Health %
Apply Aura: Reduces Attacker Chance to Hit with Melee
Apply Aura: Reduces Attacker Chance to Hit with Ranged
Apply Aura: Reduces Attacker Chance to Hit with Spells (Spells)
Apply Aura: Reduces Attacker Chance to Crit with Melee
Apply Aura: Reduces Attacker Chance to Crit with Ranged
Apply Aura: Reduces Attacker Critical Hit Damage with Melee by %
Apply Aura: Reduces Attacker Critical Hit Damage with Ranged by %
Apply Aura: Mod Dmg % (Spells)
Apply Aura: Mod Dmg % Taken (Fire, Frost)
Apply Aura: Mod Dmg % Taken (Spells)
Apply Aura: Mod Dmg % Taken (All)
Apply Aura: Mod Dmg % Taken (Physical)
Apply Aura: Mod Base Resistance % (Physical)
Apply Aura: Mod Block Percent
Apply Aura: Mod Parry Percent
Apply Aura: Mod Dodge Percent
Apply Aura: Mod Shield Block %
Apply Aura: Mod Detect
Apply Aura: Mod Skill Talent (Defense)
--]]
--[[ StatModAuras, mods not in use are commented out for now
"MOD_STR",
"MOD_AGI",
"MOD_STA",
"MOD_INT",
"MOD_SPI",
"MOD_HEALTH",
"MOD_MANA",
"MOD_ARMOR",
"MOD_BLOCK_VALUE",
--"MOD_DMG", school,
"MOD_DMG_TAKEN", school,
--"MOD_CRIT_DAMAGE", school,
"MOD_CRIT_DAMAGE_TAKEN", school,
--"MOD_THREAT", school,

"ADD_DODGE",
--"ADD_PARRY",
--"ADD_BLOCK",
--"ADD_STEALTH_DETECT",
--"ADD_STEALTH",
--"ADD_DEFENSE",
--"ADD_THREAT", school,
"ADD_HIT_TAKEN", school,
"ADD_CRIT_TAKEN", school,

--Talents
"ADD_SPELL_DMG_MOD_INT"
"ADD_HEALING_MOD_INT"
"ADD_MANA_REG_MOD_INT"
"ADD_RANGED_AP_MOD_INT"
"ADD_ARMOR_MOD_INT"
"ADD_SPELL_DMG_MOD_STA"
"ADD_SPELL_DMG_MOD_SPI"
"ADD_SPELL_DMG_MOD_AP" -- Shaman Mental Quickness
"ADD_HEALING_MOD_SPI"
"ADD_HEALING_MOD_STR"
"ADD_HEALING_MOD_AP" -- Shaman Mental Quickness
"ADD_MANA_REG_MOD_NORMAL_MANA_REG"
"MOD_AP"
"MOD_RANGED_AP"
"MOD_SPELL_DMG"
"MOD_HEALING"

--"ADD_CAST_TIME"
--"MOD_CAST_TIME"
--"ADD_MANA_COST"
--"MOD_MANA_COST"
--"ADD_RAGE_COST"
--"MOD_RAGE_COST"
--"ADD_ENERGY_COST"
--"MOD_ENERGY_COST"
--"ADD_COOLDOWN"
--"MOD_COOLDOWN"
--]]

StatLogic.StatModInfo = {
	------------------------------------------------------------------------------
	-- initialValue: sets the initial value for the stat mod
	-- if initialValue == 0, inter-mod operations are done with addition,
	-- if initialValue == 1, inter-mod operations are done with multiplication,
	------------------------------------------------------------------------------
	-- finalAdjust: added to the final result before returning,
	-- so we can adjust the return value to be used in addition or multiplication
	-- for addition: initialValue + finalAdjust = 0
	-- for multiplication: initialValue + finalAdjust = 1
	------------------------------------------------------------------------------
	-- school: school arg is required for these mods
	------------------------------------------------------------------------------
	["ADD_CRIT_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 0,
		school = true,
	},
	["ADD_DODGE"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_AP_MOD_FAP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HIT_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 0,
		school = true,
	},
	["ADD_PET_INT_MOD_INT"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["ADD_PET_STA_MOD_STA"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_AGI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_ARMOR"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_BLOCK_VALUE"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_CRIT_DAMAGE"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_CRIT_DAMAGE_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_FAP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_HEALING"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_HEALTH"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_MANA"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_RANGED_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPELL_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_STR"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
}

-- StatMods used by RatingBuster to dynamically add options for stat breakdowns
local addedInfoMods = {
	{
		add = "AP",
		mod = "ARMOR",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "AP",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "AP",
		mod = "SPELL_DMG",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "AP",
		mod = "STA",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "ARMOR",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "HEALING",
		mod = "AGI",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "HEALING",
		mod = "AP",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "HEALING",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "HEALING",
		mod = "SPI",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "HEALING",
		mod = "STR",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "MANA_REG",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "MANA_REG",
		mod = "MANA",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "MANA_REG",
		mod = "NORMAL_MANA_REG",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "PARRY_RATING",
		mod = "STR",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "RANGED_AP",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_CRIT_RATING",
		mod = "SPI",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "AP",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "PET_INT",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "PET_STA",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "SPI",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "STA",
		initialValue = 0,
		finalAdjust = 0,
	},
	{
		add = "SPELL_DMG",
		mod = "STR",
		initialValue = 0,
		finalAdjust = 0,
	},
}

for _, statMod in ipairs(addedInfoMods) do
	local name = string.format("ADD_%s_MOD_%s", statMod.add, statMod.mod)
	StatLogic.StatModInfo[name] = statMod
end

--------------------
-- Unit Aura Cache --
--------------------

do
	-- Aura Cache is a cache of our actual auras, wiped on UNIT_AURA
	-- and not populated until we try to access it. This is for
	-- performance during combat, when many auras will be updating,
	-- but the user is unlikely to be checking item tooltips.
	local aura_cache = {}

	local needs_update = true
	local f = CreateFrame("Frame")
	f:RegisterUnitEvent("UNIT_AURA", "player")
	f:SetScript("OnEvent", function()
		wipe(aura_cache)
		needs_update = true
	end)

	-- AuraInfo is a layer on top of aura_cache to hold Always Buffed settings.
	local always_buffed_aura_info = {}
	function StatLogic:SetupAuraInfo(always_buffed)
		for _, modList in pairs(StatLogic.StatModTable) do
			for _, mods in pairs(modList) do
				for _, mod in ipairs(mods) do
					if mod.buff then -- if we got a buff
						local aura = {}
						if not mod.tab and mod.rank then -- not a talent, so the rank is the buff rank
							aura.rank = #(mod.rank)
						end
						aura.stacks = mod.buffStack or 1
						always_buffed_aura_info[GetSpellInfo(mod.buff)] = aura
					end
				end
			end
		end

		StatLogic.AuraInfo = setmetatable({}, {
			__index = function(_, buff)
				if always_buffed[buff] then
					return always_buffed_aura_info[buff]
				else
					if needs_update then
						local i = 1
						repeat
							local aura = {}
							local name
							name, _, aura.stacks, _, _, _, _, _, _, aura.spellId = UnitBuff("player", i)
							if name then
								aura_cache[name] = aura
							end
							i = i+1
						until not name
						needs_update = false
					end
					return aura_cache[buff]
				end
			end
		})
	end
end

--------------------
-- Item Set Cache --
--------------------

-- Maps SetID to number of equipped pieces
local equipped_sets = setmetatable({}, {
	__index = function(t, set)
		local equipped = 0

		for i = 1, INVSLOT_LAST_EQUIPPED do
			local itemID = GetInventoryItemID("player", i)
			if itemID and select(16, GetItemInfo(itemID)) == set then
				equipped = equipped + 1
			end
		end

		t[set] = equipped
		return equipped
	end
})

--------------------
-- Meta Gem Cache --
--------------------

local equipped_meta_gem

do
	local update_meta_gem = function()
		local link = GetInventoryItemLink("player", 1)
		local str = link and select(4, strsplit(":", link))
		equipped_meta_gem = str and tonumber(str) or 0
	end

	local f = CreateFrame("Frame")
	f:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		wipe(equipped_sets)
		update_meta_gem()

		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent(event)
		end
	end)
end

addonTable.StatModValidators = {
	-- Conditions have no events, so any mods using them will not be cached.
	-- Ideally they will be removed entirely.
	condition = {
		validate = function(case)
			return loadstring("return "..case.condition)()
		end,
	},
	buff = {
		validate = function(case)
			return StatLogic.AuraInfo[GetSpellInfo(case.buff)]
		end,
		events = {
			["UNIT_AURA"] = "player",
		},
	},
	stance = {
		validate = function(case)
			local form = GetShapeshiftForm()
			if form and form > 0 then
				return GetFileIDFromPath(case.stance) == GetShapeshiftFormInfo(form)
			else
				return false
			end
		end,
		events = {
			["UPDATE_SHAPESHIFT_FORM"] = true,
		},
	},
	set = {
		validate = function(case)
			return equipped_sets[case.set] and equipped_sets[case.set] >= case.pieces
		end,
		events = {
			["UNIT_INVENTORY_CHANGED"] = "player",
		},
	},
	meta = {
		validate = function(case)
			return case.meta == equipped_meta_gem
		end,
		events = {
			["UNIT_INVENTORY_CHANGED"] = "player",
		},
	},
	enchant = {
		validate = function(case)
			local slotLink = case.slot and GetInventoryItemLink("player", case.slot)
			local pattern = "item:%d+:" .. case.enchant
			return slotLink and slotLink:find(pattern)
		end,
		events = {
			["UNIT_INVENTORY_CHANGED"] = "player",
		},
	},
}

-- Cache the results of GetStatMod, and build a table that
-- maps events defined on Validators to the StatMods that depend on them.
local StatModCache = {}
addonTable.StatModCacheInvalidators = {}

-- Talents are not a Validator, but we still
-- need to invalidate cache when they change
addonTable.StatModCacheInvalidators["CHARACTER_POINTS_CHANGED"] = {}

function StatLogic:InvalidateEvent(event, unit)
	local key = event
	if type(unit) == "string" then
		key = event .. unit
	end
	local stats = addonTable.StatModCacheInvalidators[key]
	if stats then
		for _, stat in pairs(stats) do
			StatModCache[stat] = nil
		end
	end
end

addonTable.RegisterValidatorEvents = function()
	local f = CreateFrame("Frame")
	for _, validator in pairs(addonTable.StatModValidators) do
		if validator.events then
			for event, unit in pairs(validator.events) do
				if type(unit) == "string" then
					f:RegisterUnitEvent(event, unit)
				else
					f:RegisterEvent(event)
				end
			end
		end
	end

	for event, _ in pairs(addonTable.StatModCacheInvalidators) do
		f:RegisterEvent(event)
	end

	f:SetScript("OnEvent", function(self, event, unit)
		StatLogic:InvalidateEvent(event, unit)
	end)
end

local function ValidateStatMod(stat, school, case)
	if school and not case[school] then return false, false end
	local shouldCache = true
	for validatorType in pairs(case) do
		local validator = addonTable.StatModValidators[validatorType]
		if validator then
			if validator.events then
				for event, unit in pairs(validator.events) do
					local key = event
					if type(unit) == "string" then
						key = event .. unit
					end
					addonTable.StatModCacheInvalidators[key] = addonTable.StatModCacheInvalidators[key] or {}
					table.insert(addonTable.StatModCacheInvalidators[key], stat)
				end
			else
				shouldCache = false
			end

			if not validator.validate(case) then
				return false, shouldCache
			end
		end
	end
	return true, shouldCache
end

-- As of Classic Patch 3.4.0, GetTalentInfo indices no longer correlate
-- to their positions in the tree. Building a talent cache ordered by
-- tier then column allows us to replicate the previous behavior,
-- and keep StatModTables human-readable.
local orderedTalentCache = {}
function StatLogic:GetOrderedTalentInfo(tab, num)
	return GetTalentInfo(tab, orderedTalentCache[tab][num])
end

local talentCacheExists = false
function StatLogic:TalentCacheExists()
	return talentCacheExists
end

do
	local function GenerateOrderedTalents()
		local temp = {}
		local numTabs = GetNumTalentTabs()
		for tab = 1, numTabs do
			temp[tab] = {}
			local products = {}
			for i = 1,GetNumTalents(tab) do
				local _, _, tier, column = GetTalentInfo(tab,i)
				local product = (tier - 1) * 4 + column
				temp[tab][product] = i
				table.insert(products, product)
			end

			table.sort(products)

			orderedTalentCache[tab] = {}
			local j = 1
			for _, product in ipairs(products) do
				orderedTalentCache[tab][j] = temp[tab][product]
				j = j + 1
			end
		end
		talentCacheExists = orderedTalentCache[numTabs] and #orderedTalentCache[numTabs] > 0
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("SPELLS_CHANGED")
	f:SetScript("OnEvent", function(self)
		GenerateOrderedTalents()
		if not talentCacheExists then
			-- Talents are not guaranteed to exist on SPELLS_CHANGED,
			-- and there is no definite event for when they will exist.
			-- Recheck every 1 second after SPELLS_CHANGED until they exist.
			local ticker
			ticker = C_Timer.NewTicker(1, function()
				GenerateOrderedTalents()
				if talentCacheExists then
					ticker:Cancel()
				end
			end)
		end
		self:UnregisterEvent("SPELLS_CHANGED")
	end)
end

local GetStatModValue = function(stat, school, mod, case, initialValue)
	local valid, shouldCache = ValidateStatMod(stat, school, case)
	if not valid then
		return mod, shouldCache
	end

	local value
	if case.tab and case.num then
		-- Talent Rank
		local r = select(5, StatLogic:GetOrderedTalentInfo(case.tab, case.num))
		if case.rank then
			value = case.rank[r]
		elseif r > 0 then
			value = case.value
		end
		table.insert(addonTable.StatModCacheInvalidators["CHARACTER_POINTS_CHANGED"], stat)
	elseif case.buff and case.rank then
		local r = GetPlayerBuffRank(case.buff)
		value = case.rank[r]
	elseif case.value then
		value = case.value
	end

	if value then
		if initialValue == 0 then
			mod = mod + value
		else
			mod = mod * (value + 1)
		end
	end

	return mod, shouldCache
end

function StatLogic:GetStatMod(stat, school)
	local mod = StatModCache[stat]

	local shouldCache = true
	if not mod then
		local statModInfo = StatLogic.StatModInfo[stat]
		mod = statModInfo.initialValue
		-- if school is required for this statMod but not given
		if statModInfo.school and not school then return mod end
		for _, categoryTable in pairs(StatLogic.StatModTable) do
			if categoryTable[stat] then
				for _, case in ipairs(categoryTable[stat]) do
					local shouldCacheCase
					mod, shouldCacheCase = GetStatModValue(stat, school, mod, case, statModInfo.initialValue)
					if not shouldCacheCase then
						-- If *any* cases should not be cached, don't cache this mod
						shouldCache = false
					end
				end
			end
		end

		mod = mod + statModInfo.finalAdjust
		if shouldCache then
			StatModCache[stat] = mod
		end
	end

	return mod, shouldCache
end


--=================--
-- Stat Conversion --
--=================--
function StatLogic:GetReductionFromArmor(armor, attackerLevel)
	self:argCheck(armor, 2, "nil", "number")
	self:argCheck(attackerLevel, 3, "nil", "number")
	if not armor then
		armor = select(2, UnitArmor("player"))
	end

	if not attackerLevel then
		attackerLevel = UnitLevel("player")
	end

	local levelModifier = attackerLevel
	if ( levelModifier > 59 ) then
		levelModifier = levelModifier + (4.5 * (levelModifier - 59))
	end
	local temp = armor / (85 * levelModifier + 400)
	local armorReduction = temp / (1 + temp)
	-- caps at 75%
	if armorReduction > 0.75 then
		armorReduction = 0.75
	end
	if armorReduction < 0 then
		armorReduction = 0
	end
	return armorReduction
end

function StatLogic:GetEffectFromDefense(defense, attackerLevel)
	self:argCheck(defense, 2, "nil", "number")
	self:argCheck(attackerLevel, 3, "nil", "number")
	if not defense then
		local base, add = UnitDefense("player")
		defense = base + add
	end
	if not attackerLevel then
		attackerLevel = UnitLevel("player")
	end
	return (defense - attackerLevel * 5) * 0.04
end

function StatLogic:RatingExists(id)
	return not not addonTable.RatingBase[id]
end

--[[---------------------------------
{	:GetEffectFromRating(rating, id, [level])
-------------------------------------
-- Description
	Calculates the stat effects from ratings for any level.
-- Args
	rating
			number - rating value
	id
			number - rating id as defined in PaperDollFrame.lua
	[level] - (defaults: PlayerClass)
			number - player level
-- Returns
	effect
		number - effect value
	effect name
		string - name of converted effect, ex: "DODGE", "PARRY"
-- Remarks
-- Examples
	StatLogic:GetEffectFromRating(10, CR_DODGE)
	StatLogic:GetEffectFromRating(10, CR_DODGE, 70)
}
-----------------------------------]]

--2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players
--   will now convert these ratings into their corresponding defensive
--   stats at the same rate as level 34 players.
--   Dodge and Resilience were not mentioned, but were nerfed as well
local Level34Ratings = {
	[CR_DEFENSE_SKILL] = true,
	[CR_DODGE] = true,
	[CR_PARRY] = true,
	[CR_BLOCK] = true,
	[CR_CRIT_TAKEN_MELEE] = true,
	[CR_CRIT_TAKEN_RANGED] = true,
	[CR_CRIT_TAKEN_SPELL] = true,
}

local CR_MAX = 0
addonTable.SetCRMax = function()
	for _ in pairs(addonTable.RatingBase) do
		CR_MAX = CR_MAX + 1
	end
end

function StatLogic:GetEffectFromRating(rating, id, level)
	-- if id is stringID then convert to numberID
	if type(id) == "string" and RatingNameToID[id] then
		id = RatingNameToID[id]
	end
	-- check for invalid input
	if type(rating) ~= "number" or id < 1 or id > CR_MAX then return 0 end
	-- defaults to player level if not given
	level = level or UnitLevel("player")
	if level < 34 and Level34Ratings[id] then
		level = 34
	end
	if level >= 70 then
		return rating/addonTable.RatingBase[id]/((82/52)*(131/63)^((level-70)/10)), RatingIDToConvertedStat[id]
	elseif level >= 60 then
		return rating/addonTable.RatingBase[id]*((-3/82)*level+(131/41)), RatingIDToConvertedStat[id]
	elseif level >= 10 then
		return rating/addonTable.RatingBase[id]/((1/52)*level-(8/52)), RatingIDToConvertedStat[id]
	else
		return rating/addonTable.RatingBase[id]/((1/52)*10-(8/52)), RatingIDToConvertedStat[id]
	end
end


--[[---------------------------------
{	:GetAPPerStr([class])
-------------------------------------
-- Description
	Gets the attack power per strength for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power per strength
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per strength.
-- Examples
	StatLogic:GetAPPerStr()
	StatLogic:GetAPPerStr("WARRIOR")
}
-----------------------------------]]

function StatLogic:GetAPPerStr(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetAPPerStr, got "..type(class))
	class = self:ValidateClass(class)
	return addonTable.APPerStr[class], "AP"
end


--[[---------------------------------
:GetAPFromStr(str, [class])
-------------------------------------
Description:
	Calculates the attack power from strength for any class.
Arguments:
	str
			number - strength
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
Returns:
	[ap]
		number - attack power
	[statid]
		string - "AP"
Remarks:
	Player level does not effect block value per strength.
Examples:
	StatLogic:GetAPFromStr(1) -- GetAPPerStr
	StatLogic:GetAPFromStr(10)
	StatLogic:GetAPFromStr(10, "WARRIOR")
-----------------------------------]]
function StatLogic:GetAPFromStr(str, class)
	assert(type(str)=="number", "Expected number as arg #1 to GetAPFromStr, got "..type(str))
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #2 to GetAPFromStr, got "..type(class))
	class = self:ValidateClass(class)
	-- Calculate
	return str * addonTable.APPerStr[class], "AP"
end


--[[---------------------------------
{	:GetBlockValuePerStr([class])
-------------------------------------
-- Description
	Gets the block value per strength for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[blockValue]
		number - block value per strength
	[statid]
		string - "BLOCK_VALUE"
-- Remarks
	Player level does not effect block value per strength.
-- Examples
	StatLogic:GetBlockValuePerStr()
	StatLogic:GetBlockValuePerStr("WARRIOR")
}
-----------------------------------]]

local BlockClasses = {
	["WARRIOR"] = true,
	["PALADIN"] = true,
	["SHAMAN"] = true,
}

function StatLogic:GetBlockValuePerStr(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetBlockValuePerStr, got "..type(class))
	class = self:ValidateClass(class)
	local blockValue = BlockClasses[class] and BLOCK_PER_STRENGTH or 0
	return blockValue, "BLOCK_VALUE"
end


--[[---------------------------------
{	:GetBlockValueFromStr(str, [class])
-------------------------------------
-- Description
	Calculates the block value from strength for any class.
-- Args
	str
			number - strength
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[blockValue]
		number - block value
	[statid]
		string - "BLOCK_VALUE"
-- Remarks
	Player level does not effect block value per strength.
-- Examples
	StatLogic:GetBlockValueFromStr(1) -- GetBlockValuePerStr
	StatLogic:GetBlockValueFromStr(10)
	StatLogic:GetBlockValueFromStr(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetBlockValueFromStr(str, class)
	assert(type(str)=="number", "Expected number as arg #1 to GetBlockValueFromStr, got "..type(str))
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #2 to GetBlockValueFromStr, got "..type(class))
	class = self:ValidateClass(class)
	local blockValue = BlockClasses[class] and BLOCK_PER_STRENGTH or 0
	-- Calculate
	return str * blockValue, "BLOCK_VALUE"
end


--[[---------------------------------
{	:GetAPPerAgi([class])
-------------------------------------
-- Description
	Gets the attack power per agility for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power per agility
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per agility.
	Support for Cat Form.
-- Examples
	StatLogic:GetAPPerAgi()
	StatLogic:GetAPPerAgi("ROGUE")
}
-----------------------------------]]

function StatLogic:GetAPPerAgi(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetAPPerAgi, got "..type(class))
	class = self:ValidateClass(class)
	-- Check druid cat form
	if class == "DRUID" and (GetShapeshiftFormID() == CAT_FORM) then		-- ["Cat Form"]
		return 1, "AP"
	end
	return addonTable.APPerAgi[class], "AP"
end


--[[---------------------------------
{	:GetAPFromAgi(agi, [class])
-------------------------------------
-- Description
	Calculates the attack power from agility for any class.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[ap]
		number - attack power
	[statid]
		string - "AP"
-- Remarks
	Player level does not effect attack power per agility.
-- Examples
	StatLogic:GetAPFromAgi(1) -- GetAPPerAgi
	StatLogic:GetAPFromAgi(10)
	StatLogic:GetAPFromAgi(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetAPFromAgi(agi, class)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	class = self:ValidateClass(class)
	-- Calculate
	return agi * addonTable.APPerAgi[class], "AP"
end


--[[---------------------------------
{	:GetRAPPerAgi([class])
-------------------------------------
-- Description
	Gets the ranged attack power per agility for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[rap]
		number - ranged attack power per agility
	[statid]
		string - "RANGED_AP"
-- Remarks
	Player level does not effect ranged attack power per agility.
-- Examples
	StatLogic:GetRAPPerAgi()
	StatLogic:GetRAPPerAgi("HUNTER")
}
-----------------------------------]]

function StatLogic:GetRAPPerAgi(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	class = self:ValidateClass(class)
	return addonTable.RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
{	:GetRAPFromAgi(agi, [class])
-------------------------------------
-- Description
	Calculates the ranged attack power from agility for any class.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[rap]
		number - ranged attack power
	[statid]
		string - "RANGED_AP"
-- Remarks
	Player level does not effect ranged attack power per agility.
-- Examples
	StatLogic:GetRAPFromAgi(1) -- GetRAPPerAgi
	StatLogic:GetRAPFromAgi(10)
	StatLogic:GetRAPFromAgi(10, "WARRIOR")
}
-----------------------------------]]

function StatLogic:GetRAPFromAgi(agi, class)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	class = self:ValidateClass(class)
	-- Calculate
	return agi * addonTable.RAPPerAgi[class], "RANGED_AP"
end


--[[---------------------------------
{	:GetBaseDodge([class])
-------------------------------------
-- Description
	Gets the base dodge percentage for any class.
-- Args
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[dodge]
		number - base dodge percentage
	[statid]
		string - "DODGE"
-- Remarks
-- Examples
	StatLogic:GetBaseDodge()
	StatLogic:GetBaseDodge("WARRIOR")
}
-----------------------------------]]

function StatLogic:GetBaseDodge(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	class = self:ValidateClass(class)
	return addonTable.BaseDodge[class], "DODGE"
end


--[[---------------------------------
{	:GetDodgePerAgi()
-------------------------------------
-- Description
	Calculates the dodge percentage per agility for your current class and level.
-- Args
-- Returns
	[dodge]
		number - dodge percentage per agility
	[statid]
		string - "DODGE"
-- Remarks
	Only works for your currect class and current level, does not support class and level args.
-- Examples
	StatLogic:GetDodgePerAgi()
}
-----------------------------------]]

function StatLogic:GetDodgePerAgi()
	local _, agility = UnitStat("player", 2)
	-- dodgeFromAgi is %
	local dodgeFromAgi = GetDodgeChance() - self:GetStatMod("ADD_DODGE") - self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, UnitLevel("player")) - self:GetEffectFromDefense(GetTotalDefense("player"), UnitLevel("player"))
	return (dodgeFromAgi - addonTable.BaseDodge[addonTable.class]) / agility, "DODGE"
end


--[[---------------------------------
{	:GetDodgeFromAgi(agi)
-------------------------------------
-- Description
	Calculates the dodge chance from agility for your current class and level.
-- Args
	agi
			number - agility
-- Returns
	[dodge]
		number - dodge percentage
	[statid]
		string - "DODGE"
-- Remarks
	Only works for your currect class and current level, does not support class and level args.
-- Examples
	StatLogic:GetDodgeFromAgi(1) -- GetDodgePerAgi
	StatLogic:GetDodgeFromAgi(10)
}
-----------------------------------]]

function StatLogic:GetDodgeFromAgi(agi)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	-- Calculate
	return agi * self:GetDodgePerAgi(), "DODGE"
end


--[[---------------------------------
{	:GetCritFromAgi(agi, [class], [level])
-------------------------------------
-- Description
	Calculates the melee/ranged crit chance from agility for any class or level.
-- Args
	agi
			number - agility
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[crit]
		number - melee/ranged crit percentage
	[statid]
		string - "MELEE_CRIT"
-- Remarks
-- Examples
	StatLogic:GetCritFromAgi(1) -- GetCritPerAgi
	StatLogic:GetCritFromAgi(10)
	StatLogic:GetCritFromAgi(10, "WARRIOR")
	StatLogic:GetCritFromAgi(10, nil, 70)
	StatLogic:GetCritFromAgi(10, "WARRIOR", 70)
}
-----------------------------------]]

function StatLogic:GetCritFromAgi(agi, class, level)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	class = self:ValidateClass(class)
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > GetMaxPlayerLevel() then
		level = UnitLevel("player")
	end
	-- Calculate
	return agi * addonTable.CritPerAgi[class][level], "MELEE_CRIT"
end


--[[---------------------------------
{	:GetSpellCritFromInt(int, [class], [level])
-------------------------------------
-- Description
	Calculates the spell crit chance from intellect for any class or level.
-- Args
	int
			number - intellect
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[spellcrit]
		number - spell crit percentage
	[statid]
		string - "SPELL_CRIT"
-- Remarks
-- Examples
	StatLogic:GetSpellCritFromInt(1) -- GetSpellCritPerInt
	StatLogic:GetSpellCritFromInt(10)
	StatLogic:GetSpellCritFromInt(10, "MAGE")
	StatLogic:GetSpellCritFromInt(10, nil, 70)
	StatLogic:GetSpellCritFromInt(10, "MAGE", 70)
}
-----------------------------------]]

function StatLogic:GetSpellCritFromInt(int, class, level)
	-- argCheck for invalid input
	self:argCheck(int, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	class = self:ValidateClass(class)
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > GetMaxPlayerLevel() then
		level = UnitLevel("player")
	end
	-- Calculate
	return int * addonTable.SpellCritPerInt[class][level], "SPELL_CRIT"
end

--[[---------------------------------
{	:GetHealthRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the health regen per 5 seconds when out of combat from spirit for any class.
-- Args
	spi
			number - spirit
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[hp5oc]
		number - health regen per 5 seconds when out of combat
	[statid]
		string - "HEALTH_REG_OUT_OF_COMBAT"
-- Remarks
	Player level does not effect health regen per spirit.
-- Examples
	StatLogic:GetHealthRegenFromSpi(1) -- GetHealthRegenPerSpi
	StatLogic:GetHealthRegenFromSpi(10)
	StatLogic:GetHealthRegenFromSpi(10, "MAGE")
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local HealthRegenPerSpi = {
	["WARRIOR"] = 0.5,
	["PALADIN"] = 0.125,
	["HUNTER"] = 0.125,
	["ROGUE"] = 0.333333,
	["PRIEST"] = 0.041667,
	["DEATHKNIGHT"] = 0.5,
	["SHAMAN"] = 0.071429,
	["MAGE"] = 0.041667,
	["WARLOCK"] = 0.045455,
	["DRUID"] = 0.0625,
}

function StatLogic:GetHealthRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	class = self:ValidateClass(class)
	-- Calculate
	return spi * HealthRegenPerSpi[class] * 5, "HEALTH_REG_OUT_OF_COMBAT"
end


----------
-- Gems --
----------

function StatLogic:RemoveEnchant(link)
	return link:gsub("(item:%d+):%d+","%1:0")
end

function StatLogic:RemoveGem(link)
	return link:gsub("(item:%d+:%d*):%d*:%d*:%d*:%d*","%1:0:0:0:0")
end

--[[---------------------------------
{	:BuildGemmedTooltip(item, red, yellow, blue, meta)
-------------------------------------
-- Description
	Returns a modified link with all empty sockets replaced with the specified gems,
	sockets already gemmed will remain.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	red
		string or number - gemID to replace a red socket
	yellow
		string or number - gemID to replace a yellow socket
	blue
		string or number - gemID to replace a blue socket
	meta
		string or number - gemID to replace a meta socket
-- Returns
	link
		string - modified item link
-- Remarks
-- Examples
	StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119)
	SetTip("item:28619")
	SetTip(StatLogic:BuildGemmedTooltip(28619, 3119, 3119, 3119, 3119))
}
-----------------------------------]]
local EmptySocketLookup = {
	[EMPTY_SOCKET_RED] = 0, -- EMPTY_SOCKET_RED = "Red Socket";
	[EMPTY_SOCKET_YELLOW] = 0, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
	[EMPTY_SOCKET_BLUE] = 0, -- EMPTY_SOCKET_BLUE = "Blue Socket";
	[EMPTY_SOCKET_META] = 0, -- EMPTY_SOCKET_META = "Meta Socket";
}
function StatLogic:BuildGemmedTooltip(item, red, yellow, blue, meta)
	local _
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return item end
	else
		return item
	end
	-- Check if item is in local cache
	local name, link = GetItemInfo(item)
	if not name then return item end

	-- Check gemID
	if not red or not tonumber(red) then red = 0 end
	if not yellow or not tonumber(yellow) then yellow = 0 end
	if not blue or not tonumber(blue) then blue = 0 end
	if not meta or not tonumber(meta) then meta = 0 end
	if red == 0 and yellow == 0 and blue == 0 and meta == 0 then return link end -- nothing to modify

	-- Check if any gems are already socketed
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	if (jewelId1 and jewelId1 ~= "" and jewelId1 ~= "0")
		or (jewelId2 and jewelId2 ~= "" and jewelId2 ~= "0")
		or (jewelId3 and jewelId3 ~= "" and jewelId3 ~= "0")
		or (jewelId4 and jewelId4 ~= "" and jewelId4 ~= "0")
	then
		return link
	end

	-- Fill EmptySocketLookup
	EmptySocketLookup[EMPTY_SOCKET_RED] = red
	EmptySocketLookup[EMPTY_SOCKET_YELLOW] = yellow
	EmptySocketLookup[EMPTY_SOCKET_BLUE] = blue
	EmptySocketLookup[EMPTY_SOCKET_META] = meta

	-- Build socket list
	local socketList = {}
	-- Start parsing
	tip:ClearLines() -- this is required or SetX won't work the second time its called
	tip:SetHyperlink(link)
	for i = 2, tip:NumLines() do
		local text = tip[i]:GetText()
		-- Trim spaces
		text = strtrim(text)
		-- Strip color codes
		if strsub(text, -2) == "|r" then
			text = strsub(text, 1, -3)
		end
		if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
			text = strsub(text, 11)
		end
		local socketFound = EmptySocketLookup[text]
		if socketFound then
			socketList[#socketList+1] = socketFound
		end
	end
	-- If there are no sockets
	if #socketList == 0 then return link end
	-- link breakdown
	if socketList[1]  then jewelId1 = socketList[1] end
	if socketList[2]  then jewelId2 = socketList[2] end
	if socketList[3]  then jewelId3 = socketList[3] end
	if socketList[4]  then jewelId4 = socketList[4] end
	return strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId)
end

--[[---------------------------------
{	:GetGemID(item)
-------------------------------------
-- Description
	Returns the gemID and gemText of a gem for use in links
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
-- Returns
	gemID
		number - gemID
	gemText
		string - text when socketed in an item
-- Remarks
-- Examples
	StatLogic:GetGemID(28363)
}
-----------------------------------]]
-- SetTip("item:3185:0:2946")
function StatLogic:GetGemID(item)
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	local itemID = item
	if type(item) == "string" then
		local temp = item:match("item:(%d+)")
		if temp then
			itemID = temp
		end
		itemID = tonumber(itemID)
	end

	-- Check if item is in local cache
	local name, link = GetItemInfo(item)
	if not name then
		if tonumber(itemID) then
			-- Query server for item
			tipMiner:SetHyperlink("item:"..itemID);
		end
		return
	end
	itemID = link:match("item:(%d+)")

	if not GetItemInfo(6948) then -- Hearthstone
		-- Query server for Hearthstone
		tipMiner:SetHyperlink("item:"..itemID);
		return
	end

	-- Scan tooltip for gem text
	local gemScanLink = "item:6948:0:%d:0:0:0:0:0"
	local itemLink = gemScanLink:format(itemID)
	local _, gem1Link = GetItemGem(itemLink, 1)
	if gem1Link then
		tipMiner:ClearLines() -- this is required or SetX won't work the second time its called
		tipMiner:SetHyperlink(itemLink);
		return itemID, StatLogicMinerTooltipTextLeft4:GetText()
	end
end

local function ConvertGenericRatings(table)
	for generic, ratings in pairs(StatLogic.GenericStatMap) do
		local genericName = StatLogic:GetRatingIdOrName(generic)
		if genericName and table[genericName] then
			for _, rating in ipairs(ratings) do
				local ratingName = StatLogic:GetRatingIdOrName(rating)
				table[ratingName] = table[genericName]
			end
			table[genericName] = nil
		end
	end
end

-- ================== --
-- Stat Summarization --
-- ================== --
--[[---------------------------------
{	:GetSum(item, [statTable])
-------------------------------------
-- Description
	Calculates the sum of all stats for a specified item.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[statTable]
			table - the sum of stat values are writen to this table if provided
-- Returns
	[sum]
		table - {
			["itemType"] = itemType,
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
-- Remarks
-- Examples
	StatLogic:GetSum(21417) -- [Ring of Unspoken Names]
	StatLogic:GetSum("item:28040:2717")
	StatLogic:GetSum("item:19019:117") -- TF
	StatLogic:GetSum("item:3185:0:0:0:0:0:1957") -- Acrobatic Staff of Frozen Wrath ID:3185:0:0:0:0:0:1957
	StatLogic:GetSum(24396)
	SetTip("item:3185:0:0:0:0:0:1957")
	-- [Deadly Fire Opal] ID:30582 - Attack Power +8 and Critical Rating +5
	-- [Gnomeregan Auto-Blocker 600] ID:29387
	StatLogic:GetSum("item:30538:3011:2739:2739:2739:0") -- [Midnight Legguards] with enchant and gems
	StatLogic:GetSum("item:30538:3011:2739:2739:2739:0") -- [Midnight Legguards] with enchant and gems
}
-----------------------------------]]

do
	local statTable, currentColor

	local function AddStat(id, value, debugText)
		if id == "ARMOR" then
			local base, bonus = StatLogic:GetArmorDistribution(statTable.link, value, currentColor)
			value = base
			local bonusID = "ARMOR_BONUS"
			statTable[bonusID] = (statTable[bonusID] or 0) + bonus
			debugText = debugText..", ".."|cffffff59"..tostring(bonusID).."="..tostring(bonus)
		end
		statTable[id] = (statTable[id] or 0) + tonumber(value)
		return debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
	end

	local function ParseIDTable(idTable, text, value, scanner)
		local found = false
		if idTable == false then
			found = true
			log("|cffadadad  ".. scanner .. " Exclude: "..text)
		elseif idTable then
			found = true
			local debugText = "|cffff5959  ".. scanner .. ": |cffffc259"..text
			if value then
				for _, id in ipairs(idTable) do
					debugText = AddStat(id, value, debugText)
				end
			else
				-- WholeTextLookup
				for id, presetValue in pairs(idTable) do
					debugText = AddStat(id, presetValue, debugText)
				end
			end
			log(debugText)
		end
		return found
	end

	function StatLogic:GetSum(item, oldStatTable)
		local _
		-- Check item
		if (type(item) == "string") or (type(item) == "number") then
		elseif type(item) == "table" and type(item.GetItem) == "function" then
			-- Get the link
			_, item = item:GetItem()
			if type(item) ~= "string" then return end
		else
			return
		end
		-- Check if item is in local cache
		local name, link, _, _, _, _, _, _, itemType = GetItemInfo(item)
		if not name then return end

		-- Clear table values
		clearTable(oldStatTable)
		-- Initialize statTable
		statTable = oldStatTable or new()
		setmetatable(statTable, statTableMetatable)

		tip:ClearLines() -- this is required or SetX won't work the second time its called
		tip:SetHyperlink(link)

		local numLines = tip:NumLines()

		-- Get data from cache if available
		if cache[link] and cache[link].numLines == numLines then
			copyTable(statTable, cache[link])
			return statTable
		end

		-- Set metadata
		statTable.itemType = itemType
		statTable.link = link
		statTable.numLines = numLines

		-- Don't scan Relics because they don't have general stats
		if itemType == "INVTYPE_RELIC" then
			cache[link] = copy(statTable)
			return statTable
		end

		-- Start parsing
		log(link)
		for i = 2, tip:NumLines() do
			local text = tip[i]:GetText()

			-- Trim spaces
			text = strtrim(text)
			-- Strip color codes
			if strsub(text, -2) == "|r" then
				text = strsub(text, 1, -3)
			end
			if strfind(strsub(text, 1, 10), "|c%x%x%x%x%x%x%x%x") then
				text = strsub(text, 11)
			end

			currentColor = CreateColor(tip[i]:GetTextColor())
			local _, g, b = currentColor:GetRGB()
			-----------------------
			-- Whole Text Lookup --
			-----------------------
			-- Mainly used for enchants or stuff without numbers:
			-- "Mithril Spurs"
			local found
			local idTable = L.WholeTextLookup[text]
			found = ParseIDTable(idTable, text, false, "WholeText")

			-- Fast Exclude --
			-- Exclude obvious strings that do not need to be checked, also exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
			if not (found or L.Exclude[text] or L.Exclude[strutf8sub(text, 1, L.ExcludeLen)] or strsub(text, 1, 1) == '"' or g < 0.8 or (b < 0.99 and b > 0.1)) then
				--log(text.." = ")
				-- Strip enchant time
				-- ITEM_ENCHANT_TIME_LEFT_DAYS = "%s (%d day)";
				-- ITEM_ENCHANT_TIME_LEFT_DAYS_P1 = "%s (%d days)";
				-- ITEM_ENCHANT_TIME_LEFT_HOURS = "%s (%d hour)";
				-- ITEM_ENCHANT_TIME_LEFT_HOURS_P1 = "%s (%d hrs)";
				-- ITEM_ENCHANT_TIME_LEFT_MIN = "%s (%d min)"; -- Enchantment name, followed by the time left in minutes
				-- ITEM_ENCHANT_TIME_LEFT_SEC = "%s (%d sec)"; -- Enchantment name, followed by the time left in seconds
				--[[ Seems temp enchants such as mana oil can't be seen from item links, so commented out
				if strfind(text, "%)") then
				log("test")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_DAYS, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_DAYS_P1, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_HOURS, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_HOURS_P1, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_MIN, "%%s ", ""), "%%", "%%%%"), "")
				text = gsub(text, gsub(gsub(ITEM_ENCHANT_TIME_LEFT_SEC, "%%s ", ""), "%%", "%%%%"), "")
				end
				--]]
				----------------------------
				-- Single Plus Stat Check --
				----------------------------
				-- depending on locale, L.SinglePlusStatCheck may be
				-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
				-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
				-- +19 耐力 = "^%+(%d+) (.-)$"
				if not found then
					local _, _, value, statText = strfind(strutf8lower(text), L.SinglePlusStatCheck)
					if value then
						if tonumber(statText) then
							value, statText = statText, value
						end
						idTable = L.StatIDLookup[statText]
						found = ParseIDTable(idTable, text, value, "SinglePlus")
					end
				end
				-----------------------------
				-- Single Equip Stat Check --
				-----------------------------
				-- depending on locale, L.SingleEquipStatCheck may be
				-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
				if not found then
					local _, _, statText1, value, statText2 = strfind(text, L.SingleEquipStatCheck)
					if value then
						local statText = statText1..statText2
						idTable = L.StatIDLookup[strutf8lower(statText)]
						found = ParseIDTable(idTable, text, value, "SingleEquip")
					end
				end
				-- PreScan for special cases, that will fit wrongly into DeepScan
				-- PreScan also has exclude patterns
				if not found then
					for pattern, id in pairs(L.PreScanPatterns) do
						local value
						found, _, value = strfind(text, pattern)
						if found then
							ParseIDTable(id and {id}, text, value, "PreScan")
							break
						end
					end
				end

				--------------
				-- DeepScan --
				--------------
				--[[
				-- Strip trailing "."
				["."] = ".",
				["DeepScanSeparators"] = {
				"/", -- "+10 Defense Rating/+10 Stamina/+15 Block Value": ZG Enchant
				" & ", -- "+26 Healing Spells & 2% Reduced Threat": Bracing Earthstorm Diamond ID:25897
				", ", -- "+6 Spell Damage, +5 Spell Crit Rating": Potent Ornate Topaz ID: 28123
				"%. ", -- "Equip: Increases attack power by 81 when fighting Undead. It also allows the acquisition of Scourgestones on behalf of the Argent Dawn.": Seal of the Dawn
				},
				["DeepScanWordSeparators"] = {
				" and ", -- "Critical Rating +6 and Dodge Rating +5": Assassin's Fire Opal ID:30565
				},
				["DeepScanPatterns"] = {
				"^(.-) by u?p? ?t?o? ?(%d+) ?(.-)$", -- "xxx by up to 22 xxx" (scan first)
				"^(.-) ?%+(%d+) ?(.-)$", -- "xxx xxx +22" or "+22 xxx xxx" or "xxx +22 xxx" (scan 2ed)
				"^(.-) ?([%d%.]+) ?(.-)$", -- 22.22 xxx xxx (scan last)
				},
				--]]
				if not found then
					-- Strip leading "Equip: ", "Socket Bonus: "
					local sanitizedText = gsub(text, ITEM_SPELL_TRIGGER_ONEQUIP, "") -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
					sanitizedText = gsub(sanitizedText, StripGlobalStrings(ITEM_SOCKET_BONUS), "") -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
					-- Trim spaces
					sanitizedText = strtrim(sanitizedText)
					-- Strip trailing "."
					if strutf8sub(sanitizedText, -1) == L["."] then
						sanitizedText = strutf8sub(sanitizedText, 1, -2)
					end
					-- Split the string into phrases between puncuation
					-- Replace separators with @
					for _, sep in ipairs(L.DeepScanSeparators) do
						local repl = "@"
						if type(sep) == "table" then
							repl = sep.repl
							sep = sep.pattern
						end
						if strfind(sanitizedText, sep) then
							log(repl)
							sanitizedText = gsub(sanitizedText, sep, repl)
						end
					end
					-- Split text using @
					local phrases = {strsplit("@", sanitizedText)}
					for j, phrase in ipairs(phrases) do
						-- Trim spaces
						phrase = strtrim(phrase)
						-- Strip trailing "."
						if strutf8sub(phrase, -1) == L["."] then
							phrase = strutf8sub(phrase, 1, -2)
						end
						log("|cff008080".."S"..j..": ".."'"..phrase.."'")
						-- Whole Text Lookup
						local foundWholeText = false
						idTable = L.WholeTextLookup[phrase]
						found = ParseIDTable(idTable, phrase, false, "DeepScan WholeText")
						foundWholeText = found

						-- Scan DualStatPatterns
						if not foundWholeText then
							for pattern, dualStat in pairs(L.DualStatPatterns) do
								local lowered = strutf8lower(phrase)
								local _, dEnd, value1, value2 = strfind(lowered, pattern)
								value1 = value1 and tonumber(value1)
								value2 = value2 and tonumber(value2)
								if value1 and value2 then
									foundWholeText = true
									found = true
									local debugText = "|cffff5959".."  DeepScan DualStat: ".."|cffffc259"..phrase
									for _, id in ipairs(dualStat[1]) do
										--log("  '"..value.."', '"..id.."'")
										-- sum stat
										statTable[id] = (statTable[id] or 0) + tonumber(value1)
										debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
									end
									for _, id in ipairs(dualStat[2]) do
										--log("  '"..value.."', '"..id.."'")
										-- sum stat
										statTable[id] = (statTable[id] or 0) + tonumber(value2)
										debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
									end
									log(debugText)
									if dEnd ~= string.len(lowered) then
										foundWholeText = false
										phrase = string.sub(phrase, dEnd + 1)
									end
									break
								end
							end
						end
						local foundDeepScan1 = false
						if not foundWholeText then
							local lowered = strutf8lower(phrase)
							-- Pattern scan
							for _, pattern in ipairs(L.DeepScanPatterns) do -- try all patterns in order
								local _, _, statText1, value, statText2 = strfind(lowered, pattern)
								if value then
									local statText = statText1..statText2
									idTable = L.StatIDLookup[statText]
									found = ParseIDTable(idTable, phrase, value, "DeepScan")
									foundDeepScan1 = found
									if found then
										break
									end
								end
							end
						end
						-- If still not found, use the word separators to split the phrase
						if not foundWholeText and not foundDeepScan1 then
							-- Replace separators with @
							for _, sep in ipairs(L.DeepScanWordSeparators) do
								if strfind(phrase, sep) then
									phrase = gsub(phrase, sep, "@")
								end
							end
							-- Split phrase using @
							local words = {strsplit("@", phrase)}
							for k, word in ipairs(words) do
								-- Trim spaces
								word = strtrim(word)
								-- Strip trailing "."
								if strutf8sub(word, -1) == L["."] then
									word = strutf8sub(word, 1, -2)
								end
								log("|cff008080".."S"..k.."-"..k..": ".."'"..word.."'")
								-- Whole Text Lookup
								foundWholeText = false
								idTable = L.WholeTextLookup[word]
								found = ParseIDTable(idTable, word, false, "DeepScan2 WholeText")
								foundWholeText = found

								-- Scan DualStatPatterns
								if not foundWholeText then
									for pattern, dualStat in pairs(L.DualStatPatterns) do
										local lowered = strutf8lower(word)
										local _, _, value1, value2 = strfind(lowered, pattern)
										if value1 and value2 then
											foundWholeText = true
											found = true
											local debugText = "|cffff5959".."  DeepScan2 DualStat: ".."|cffffc259"..word
											for _, id in ipairs(dualStat[1]) do
												--log("  '"..value.."', '"..id.."'")
												-- sum stat
												statTable[id] = (statTable[id] or 0) + tonumber(value1)
												debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
											end
											for _, id in ipairs(dualStat[2]) do
												--log("  '"..value.."', '"..id.."'")
												-- sum stat
												statTable[id] = (statTable[id] or 0) + tonumber(value2)
												debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
											end
											log(debugText)
											break
										end
									end
								end
								local foundDeepScan2 = false
								if not foundWholeText then
									local lowered = strutf8lower(word)
									-- Pattern scan
									for _, pattern in ipairs(L.DeepScanPatterns) do
										local _, _, statText1, value, statText2 = strfind(lowered, pattern)
										if value then
											local statText = statText1..statText2
											idTable = L.StatIDLookup[statText]
											found = ParseIDTable(idTable, word, value, "DeepScan2")
											foundDeepScan2 = found
											if found then
												break
											else
												-- pattern match but not found in L.StatIDLookup, keep looking
												log("  DeepScan2 Lookup Fail: |cffffd4d4'"..statText.."'|r, pattern = |cff72ff59'"..pattern.."'")
											end
										end
									end -- for
								end
								if not foundWholeText and not foundDeepScan2 then
									log("  DeepScan2 Fail: |cffff0000'"..word.."'")
								end
							end
						end -- if not foundWholeText and not foundDeepScan1 then
					end
				end

				if not found then
					log("  No Match: |cffff0000'"..text.."'")
					if DEBUG and RatingBuster then
						RatingBuster.db.profile.test = text
					end
				end
			else
				--log("Excluded: "..text)
			end
		end

		-- Tooltip scanning done, do post processing
		ConvertGenericRatings(statTable)

		cache[link] = copy(statTable)
		return statTable
	end
end

local colorPrecision = 0.0001
function StatLogic.AreColorsEqual(a, b)
	return math.abs(a.r - b.r) < colorPrecision
	  and math.abs(a.g - b.g) < colorPrecision
	  and math.abs(a.b - b.b) < colorPrecision
end

local BONUS_ARMOR_COLOR = CreateColorFromHexString(GREENCOLORCODE:sub(3))
function StatLogic:GetArmorDistribution(item, value, color)
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then -- common case first
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		local _
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	-- Check if item is in local cache
	local name, _, itemQuality, itemLevel, _, _, _, _, itemEquipLoc, _, _, _, armorSubclass = GetItemInfo(item)

	local armor = value
	local bonus_armor = 0
	if name then
		if addonTable.bonusArmorItemEquipLoc and addonTable.bonusArmorItemEquipLoc[itemEquipLoc] then
			armor = 0
			bonus_armor = value
		elseif StatLogic.AreColorsEqual(color, BONUS_ARMOR_COLOR) and addonTable.baseArmorTable then
			local qualityTable = addonTable.baseArmorTable[itemQuality]
			local itemEquipLocTable = qualityTable and qualityTable[_G[itemEquipLoc]]
			local armorSubclassTable = itemEquipLocTable and itemEquipLocTable[armorSubclass]

			armor = armorSubclassTable and armorSubclassTable[itemLevel] or armor
			bonus_armor = value - armor
		end
	end

	return armor, bonus_armor
end

--[[---------------------------------
{	:GetDiffID(item, [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta])
-------------------------------------
-- Description
	Returns a unique identification string of the diff calculation,
	the identification string is made up of links concatenated together, can be used for cache indexing
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[ignoreEnchant]
			boolean - ignore enchants when calculating the id
	[ignoreGem]
			boolean - ignore gems when calculating the id
	[red]
		string or number - gemID to replace a red socket
	[yellow]
		string or number - gemID to replace a yellow socket
	[blue]
		string or number - gemID to replace a blue socket
	[meta]
		string or number - gemID to replace a meta socket
-- Returns
	[id]
		string - a unique identification string of the diff calculation
	[link]
		string - link of main item
	[linkDiff1]
		string - link of compare item 1
	[linkDiff2]
		string - link of compare item 2
-- Remarks
-- Examples
	StatLogic:GetDiffID(21417) -- Ring of Unspoken Names
	StatLogic:GetDiffID("item:18832:2564:0:0:0:0:0:0", true, true) -- Brutality Blade with +15 agi enchant
	http://www.wowwiki.com/EnchantId
}
-----------------------------------]]

local getSlotID = {
	INVTYPE_AMMO           = 0,
	INVTYPE_GUNPROJECTILE  = 0,
	INVTYPE_BOWPROJECTILE  = 0,
	INVTYPE_HEAD           = 1,
	INVTYPE_NECK           = 2,
	INVTYPE_SHOULDER       = 3,
	INVTYPE_BODY           = 4,
	INVTYPE_CHEST          = 5,
	INVTYPE_ROBE           = 5,
	INVTYPE_WAIST          = 6,
	INVTYPE_LEGS           = 7,
	INVTYPE_FEET           = 8,
	INVTYPE_WRIST          = 9,
	INVTYPE_HAND           = 10,
	INVTYPE_FINGER         = {11,12},
	INVTYPE_TRINKET        = {13,14},
	INVTYPE_CLOAK          = 15,
	INVTYPE_WEAPON         = {16,17},
	INVTYPE_2HWEAPON       = 16+17,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND  = 17,
	INVTYPE_SHIELD         = 17,
	INVTYPE_HOLDABLE       = 17,
	INVTYPE_RANGED         = 18,
	INVTYPE_RANGEDRIGHT    = 18,
	INVTYPE_RELIC          = 18,
	INVTYPE_GUN            = 18,
	INVTYPE_CROSSBOW       = 18,
	INVTYPE_WAND           = 18,
	INVTYPE_THROWN         = 18,
	INVTYPE_TABARD         = 19,
}

local function HasTitansGrip()
	return addonTable.class == "WARRIOR" and IsPlayerSpell(46917)
end

function StatLogic:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	local name, itemType, link, linkDiff1, linkDiff2
	-- Check item
	if (type(item) == "string") or (type(item) == "number") then
	elseif type(item) == "table" and type(item.GetItem) == "function" then
		-- Get the link
		_, item = item:GetItem()
		if type(item) ~= "string" then return end
	else
		return
	end
	-- Check if item is in local cache
	name, link, _, _, _, _, _, _, itemType = GetItemInfo(item)
	if not name then return end
	-- Get equip location slot id for use in GetInventoryItemLink
	local slotID = getSlotID[itemType]
	-- Don't do bags
	if not slotID then return end

	-- 1h weapon, check if player can dual wield, check for 2h equipped
	if itemType == "INVTYPE_WEAPON" then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		-- If player can Dual Wield, calculate offhand difference
		if IsUsableSpell(GetSpellInfo(674)) then		-- ["Dual Wield"]
			local _, _, _, _, _, _, _, _, eqItemType = GetItemInfo(linkDiff1)
			-- If 2h is equipped, copy diff1 to diff2
			if eqItemType == "INVTYPE_2HWEAPON" and not HasTitansGrip() then
				linkDiff2 = linkDiff1
			else
				linkDiff2 = GetInventoryItemLink("player", 17) or "NOITEM"
			end
		end
	-- Ring or trinket
	elseif type(slotID) == "table" then
		-- Get slot link
		linkDiff1 = GetInventoryItemLink("player", slotID[1]) or "NOITEM"
		linkDiff2 = GetInventoryItemLink("player", slotID[2]) or "NOITEM"
	-- 2h weapon, so we calculate the difference with equipped main hand and off hand
	elseif itemType == "INVTYPE_2HWEAPON" then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		linkDiff2= GetInventoryItemLink("player", 17) or "NOITEM"
	-- Off hand slot, check if we have 2h equipped
	elseif slotID == 17 then
		linkDiff1 = GetInventoryItemLink("player", 16) or "NOITEM"
		-- If 2h is equipped
		local _, _, _, _, _, _, _, _, eqItemType = GetItemInfo(linkDiff1)
		if eqItemType ~= "INVTYPE_2HWEAPON" then
			linkDiff1 = GetInventoryItemLink("player", 17) or "NOITEM"
		end
	-- Single slot item
	else
		linkDiff1 = GetInventoryItemLink("player", slotID) or "NOITEM"
	end

	-- Ignore Enchants
	if ignoreEnchant then
		link = self:RemoveEnchant(link)
		linkDiff1 = self:RemoveEnchant(linkDiff1)
		if linkDiff2 then
			linkDiff2 = self:RemoveEnchant(linkDiff2)
		end
	end

	-- Ignore Gems
	if ignoreGem then
		link = self:RemoveGem(link)
		linkDiff1 = self:RemoveGem(linkDiff1)
		if linkDiff2 then
			linkDiff2 = self:RemoveGem(linkDiff2)
		end
	else
		link = self:BuildGemmedTooltip(link, red, yellow, blue, meta)
		linkDiff1 = self:BuildGemmedTooltip(linkDiff1, red, yellow, blue, meta)
		if linkDiff2 then
			linkDiff2 = self:BuildGemmedTooltip(linkDiff2, red, yellow, blue, meta)
		end
	end

	-- Build ID string
	local id = link..linkDiff1
	if linkDiff2 then
		id = id..linkDiff2
	end

	return id, link, linkDiff1, linkDiff2
end


--[[---------------------------------
{	:GetDiff(item, [diff1], [diff2], [ignoreEnchant], [ignoreGem], [red], [yellow], [blue], [meta])
-------------------------------------
-- Description
	Calculates the stat diffrence from the specified item and your currently equipped items.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[diff1]
			table - stat difference of item and equipped item 1 are writen to this table if provided
	[diff2]
			table - stat difference of item and equipped item 2 are writen to this table if provided
	[ignoreEnchant]
			boolean - ignore enchants when calculating stat diffrences
	[ignoreGem]
			boolean - ignore gems when calculating stat diffrences
	[red]
		string or number - gemID to replace a red socket
	[yellow]
		string or number - gemID to replace a yellow socket
	[blue]
		string or number - gemID to replace a blue socket
	[meta]
		string or number - gemID to replace a meta socket
-- Returns
	[diff1]
		table - {
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
	[diff2]
		table - {
			["STAT_ID1"] = value,
			["STAT_ID2"] = value,
		}
-- Remarks
-- Examples
	StatLogic:GetDiff(21417, {}) -- Ring of Unspoken Names
	StatLogic:GetDiff(21452) -- Staff of the Ruins
}
-----------------------------------]]

-- TODO 2.1.0: Use SetHyperlinkCompareItem in StatLogic:GetDiff
function StatLogic:GetDiff(item, diff1, diff2, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	-- Get DiffID
	local id, link, linkDiff1, linkDiff2 = self:GetDiffID(item, ignoreEnchant, ignoreGem, red, yellow, blue, meta)
	if not id then return end

	-- Clear Tables
	clearTable(diff1)
	clearTable(diff2)

	-- Get diff data from cache if available
	if cache[id..1] then
		copyTable(diff1, cache[id..1])
		if cache[id..2] then
			copyTable(diff2, cache[id..2])
		end
		return diff1, diff2
	end

	-- Get item sum, results are written into diff1 table
	local itemSum = self:GetSum(link)
	if not itemSum then return end
	local itemType = itemSum.itemType

	if itemType == "INVTYPE_2HWEAPON" and not HasTitansGrip() then
		local equippedSum1, equippedSum2
		-- Get main hand item sum
		if linkDiff1 == "NOITEM" then
			equippedSum1 = newStatTable()
		else
			equippedSum1 = self:GetSum(linkDiff1)
		end
		-- Get off hand item sum
		if linkDiff2 == "NOITEM" then
			equippedSum2 = newStatTable()
		else
			equippedSum2 = self:GetSum(linkDiff2)
		end
		-- Calculate diff
		diff1 = copyTable(diff1, itemSum) - equippedSum1 - equippedSum2
		-- Return table to pool
		del(equippedSum1)
		del(equippedSum2)
	else
		local equippedSum
		-- Get equipped item 1 sum
		if linkDiff1 == "NOITEM" then
			equippedSum = newStatTable()
		else
			equippedSum = self:GetSum(linkDiff1)
		end
		-- Calculate item 1 diff
		diff1 = copyTable(diff1, itemSum) - equippedSum
		-- Clean up
		del(equippedSum)
		equippedSum = nil
		-- Check if item has a second equip slot
		if linkDiff2 then -- If so
			-- Get equipped item 2 sum
			if linkDiff2 == "NOITEM" then
				equippedSum = newStatTable()
			else
				equippedSum = self:GetSum(linkDiff2)
			end
			-- Calculate item 2 diff
			diff2 = copyTable(diff2, itemSum) - equippedSum
			-- Clean up
			del(equippedSum)
		end
	end
	-- Return itemSum table to pool
	del(itemSum)
	-- Write cache
	copyTable(cache[id..1], diff1)
	if diff2 then
		copyTable(cache[id..2], diff2)
	end
	-- return tables
	return diff1, diff2
end


-----------
-- DEBUG --
-----------
-- StatLogic:Bench(1000)
---------
-- self:GetSum(link, table)
-- 1000 times: 0.82 sec without cache
-- 1000 times: 0.04 sec with cache
---------
-- ItemBonusLib:ScanItemLink(link)
-- 1000 times: 1.58 sec
---------
function StatLogic:Bench(k)
	local t1 = GetTime()
	local link = GetInventoryItemLink("player", 12)
	--local GetItemInfo = _G["GetItemInfo"]
	for i = 1, k, 1 do
		---------------------------------------------------------------------------
		--self:SplitDoJoin("+24 Agility/+4 Stamina, +4 Dodge and +4 Spell Crit/+5 Spirit", {"/", " and ", ","})
		---------------------------------------------------------------------------
		--self:GetSum(link)
		--ItemBonusLib:ScanItemLink(link)
		---------------------------------------------------------------------------
		--ItemRefTooltip:SetScript("OnTooltipSetItem", function(frame, ...) RatingBuster:Print("OnTooltipSetItem") end)
		---------------------------------------------------------------------------
		GetItemInfo(link)
	end
	return GetTime() - t1
end


function StatLogic:PatternTest()
	local patternTable = {
		"(%a[%a ]+%a) ?%d* ?%a* by u?p? ?t?o? ?(%d+) ?a?n?d? ?", -- xxx xxx by 22 (scan first)
		"(%a[%a ]+) %+(%d+) ?a?n?d? ?", -- xxx xxx +22 (scan 2ed)
		"(%d+) ([%a ]+) ?a?n?d? ?", -- 22 xxx xxx (scan last)
	}
	local textTable = {
		"Spell Damage +6 and Spell Hit Rating +5",
		"+3 Stamina, +4 Critical Strike Rating",
		"+26 Healing Spells & 2% Reduced Threat",
		"+3 Stamina/+4 Critical Strike Rating",
		"Socket Bonus: 2 mana per 5 sec.",
		"Equip: Increases damage and healing done by magical spells and effects by up to 150.",
		"Equip: Increases the spell critical strike rating of all party members within 30 yards by 28.",
		"Equip: Increases damage and healing done by magical spells and effects of all party members within 30 yards by up to 33.",
		"Equip: Increases healing done by magical spells and effects of all party members within 30 yards by up to 62.",
		"Equip: Increases your spell damage by up to 120 and your healing by up to 300.",
		"Equip: Restores 11 mana per 5 seconds to all party members within 30 yards.",
		"Equip: Increases healing done by spells and effects by up to 300.",
		"Equip: Increases attack power by 420 in Cat, Bear, Dire Bear, and Moonkin forms only.",
	}
	for _, text in ipairs(textTable) do
		DEFAULT_CHAT_FRAME:AddMessage(text.." = ")
		for _, pattern in ipairs(patternTable) do
			local found
			for k, v in gmatch(text, pattern) do
				found = true
				DEFAULT_CHAT_FRAME:AddMessage("  '"..k.."', '"..v.."'")
			end
			if found then
				DEFAULT_CHAT_FRAME:AddMessage("  using: "..pattern)
				DEFAULT_CHAT_FRAME:AddMessage("----------------------------")
				break
			end
		end
	end
end

----------------------
-- Register Library --
----------------------

----------------------
-- API doc template --
----------------------
--[[---------------------------------
{	:GetDiff(item, [table1], [table2])
-------------------------------------
-- Description
	Calculates the stat diffrence from item and equipped items
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[table1]
			table - stat difference of item and equipped item 1 are writen to this table if provided
	[table2]
			table - stat difference of item and equipped item 2 are writen to this table if provided
-- Remarks
-- Examples
	StatLogic:GetDiff(21417, {}) -- Ring of Unspoken Names
	StatLogic:GetDiff(21452) -- Staff of the Ruins
}
-----------------------------------]]
