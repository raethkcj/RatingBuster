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

local MAJOR_VERSION = "StatLogic-1.0"
local MINOR_VERSION = tonumber(("$Revision: 78899 $"):sub(12, -3))

---------------
-- Libraries --
---------------
-- Pattern matching
local L = LibStub("AceLocale-3.0"):GetLocale("StatLogic")
-- Display text
local D = LibStub("AceLocale-3.0"):GetLocale("StatLogic".."D")


-------------------
-- Set Debugging --
-------------------
local DEBUG = false
function CmdHandler()
	DEBUG = not DEBUG
end
SlashCmdList["STATLOGICDEBUG"] = CmdHandler
SLASH_STATLOGICDEBUG1 = "/sldebug";

-- Uncomment below to print out print out every missing translation for each locale
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


---------------------
-- Local Variables --
---------------------
-- Player info
local _, playerClass = UnitClass("player")
local _, playerRace = UnitRace("player")

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
local GetLocale = GetLocale
local IsUsableSpell = IsUsableSpell
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetShapeShiftFormID = GetShapeShiftFormID
local GetTalentInfo = GetTalentInfo
wowBuildNo = select(2, GetBuildInfo()) -- need a global for loadstring
local wowBuildNo = wowBuildNo

-- Cached GetItemInfo
local GetItemInfoCached = setmetatable({}, { __index = function(self, n)
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture = GetItemInfo(n)
		if itemName then
				-- store in cache only if it exists in the local cache
				self[n] = {itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture}
				return self[n] -- return result
		end
end })
local GetItemInfo = function(item)
	local info = GetItemInfoCached[item]
	if info then
		return unpack(info)
	end
end


---------------
-- Lua Tools --
---------------
-- metatable for stat tables
local statTableMetatable = {
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
					while op1["diffItemType"..i] do
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

local function delMulti(t)
	if t then
		for k in pairs(t) do
			if type(t[k]) == "table" then
				del(t[k])
			else
				t[k] = nil
			end
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


local function print(text)
	if DEBUG == true then
		DEFAULT_CHAT_FRAME:AddMessage(text)
	end
end

-- SetTip("item:3185:0:0:0:0:0:1957")
function SetTip(item)
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
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

local ClassNameToID = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"DRUID",
	["WARRIOR"] = 1,
	["PALADIN"] = 2,
	["HUNTER"] = 3,
	["ROGUE"] = 4,
	["PRIEST"] = 5,
	["SHAMAN"] = 6,
	["MAGE"] = 7,
	["WARLOCK"] = 8,
	["DRUID"] = 9,
}

function StatLogic:GetClassIDFromName(class)
	return ClassNameToID[class]
end

function StatLogic:GetStatNameFromID(stat)
	local name = D.StatIDToName[stat]
	if not name then return end
	return unpack(name)
end

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

local RatingNameToID = {
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
}

function StatLogic:GetRatingIDFromName(rating)
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
}

local function GetStanceIcon()
	local currentStance = GetShapeshiftForm()
	if currentStance ~= 0 then
		return GetShapeshiftFormInfo(currentStance)
	end
end

local function GetPlayerBuffRank(buff)
	local spellID = select(10, AuraUtil.FindAuraByName(buff, "player"))
	local rank = GetSpellSubtext(spellID)
	if spellID then
		return rank and strmatch(rank, "(%d+)") or 1
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

local StatModInfo = {
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
	["ADD_HIT_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 0,
		school = true,
	},
	["ADD_DODGE"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_MANA_REG_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_RANGED_AP_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_ARMOR_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_DMG_MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_STR"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_AGI"] = { -- Nurturing Instinct
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_HEALING_MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["MOD_CRIT_DAMAGE_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG_TAKEN"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_CRIT_DAMAGE"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
		school = true,
	},
	["MOD_ARMOR"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_HEALTH"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_MANA"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_STR"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_AGI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPI"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_BLOCK_VALUE"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_RANGED_AP"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_SPELL_DMG"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
	["MOD_HEALING"] = {
		initialValue = 0,
		finalAdjust = 1,
	},
}

------------------
-- StatModTable --
------------------
local StatModTable = {
	["DRUID"] = {
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Lunar Guidance (Rank 3) - 1,12
		--        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.08, 0.16, 0.25,
				},
			},
		},
		-- Druid: Nurturing Instinct (Rank 2) - 2,14
		--        Increases your healing spells by up to 25%/50% of your Strength.
		-- 2.4.0 Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
		["ADD_HEALING_MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.5, 1,
				},
			},
		},
		-- Druid: Intensity (Rank 3) - 3,6
		--        Allows 5%/10%/15% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.05, 0.10, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 3,
				["num"] = 6,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Druid: Dreamstate (Rank 3) - 1,17
		--        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 17,
				["rank"] = {
					0.04, 0.07, 0.10,
				},
			},
		},
		-- Druid: Feral Swiftness (Rank 2) - 2,6
		--        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[2] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[3] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					2, 4,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Druid: Natural Perfection (Rank 3) - 3,18
		--        Your critical strike chance with all spells is increased by 3% and melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Druid: Balance of Power (Rank 2) - 1,16
		--        Increases your chance to hit with all spells and reduces the chance you'll be hit by spells by 2%/4%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Druid: Thick Hide (Rank 3) - 2,5
		--        Increases your Armor contribution from items by 4%/7%/10%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Moonkin Form - Buff
		--        While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					1.04, 1.07, 1.1,
				},
			},
			[2] = {
				["rank"] = {
					2.8,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[3] = {
				["rank"] = {
					5,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[4] = {
				["rank"] = {
					5,
				},
				["buff"] = GetSpellInfo(24858),		-- ["Moonkin Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - Stance (use stance because bear and dire bear increases are the same)
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STA"] = { -- Heart of the Wild: +4%/8%/12%/16%/20% stamina in bear / dire bear
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[2] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
			[3] = { -- Survival of the Fittest: +1%/2%/3% all stats
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
			[4] = { -- Bear Form / Dire Bear Form: +25% stamina
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(32357),		-- ["Bear Form"],
			},
			[5] = { -- Bear Form / Dire Bear Form: +25% stamina
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(9634),		-- ["Dire Bear Form"],
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- 2.3.0 This talent no longer provides 4/8/12/16/20% bonus Strength in Cat Form. Instead it provides 2/4/6/8/10% bonus attack power.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["buff"] = GetSpellInfo(32356),		-- ["Cat Form"],
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Heart of the Wild (Rank 5) - 2,15
		--        Increases your Intellect by 4%/8%/12%/16%/20%. In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and while in Cat Form your Strength is increased by 4%/8%/12%/16%/20%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.04, 0.08, 0.12, 0.16, 0.2,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
		-- Druid: Living Spirit (Rank 3) - 3,16
		--        Increases your total Spirit by 5%/10%/15%.
		-- Druid: Survival of the Fittest (Rank 3) - 2,16
		--        Increases all attributes by 1%/2%/3% and reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
		["MOD_SPI"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.01, 0.02, 0.03,
				},
			},
		},
	},
	["HUNTER"] = {
		-- Hunter: Aspect of the Viper - Buff
		--         The hunter takes on the aspects of a viper, regenerating mana equal to 25% of his Intellect every 5 sec.
		-- TODO: Gronnstalker's Armor, (2) Set: Increases the mana you gain from your Aspect of the Viper by an additional 5% of your Intellect.
		-- 2.2.0: Aspect of the Viper: This ability has received a slight redesign. The
		-- amount of mana regained will increase as the Hunters percentage of 
		-- mana remaining decreases. At about 60% mana, it is equivalent to the
		-- previous version of Aspect of the Viper. Below that margin, it is 
		-- better (up to twice as much mana as the old version); while above 
		-- that margin, it will be less effective. The mana regained never drops
		-- below 10% of intellect every 5 sec. or goes above 50% of intellect 
		-- every 5 sec. 
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["rank"] = {
					0.25,
				},
				["buff"] = GetSpellInfo(34074),			-- ["Aspect of the Viper"],
			},
		},
		-- Hunter: Careful Aim (Rank 3) - 2,16
		--         Increases your ranged attack power by an amount equal to 15%/30%/45% of your total Intellect.
		["ADD_RANGED_AP_MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.15, 0.30, 0.45,
				},
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 3,14
		--         Reduces all damage taken by 2%/4%.
		-- 2.1.0 "Survival Instincts" now also increase attack power by 2/4%.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04,
				}
			},
		},
		-- Hunter: Master Marksman (Rank 5) - 2,19
		--         Increases your ranged attack power by 2%/4%/6%/8%/10%.
		["MOD_RANGED_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Hunter: Catlike Reflexes (Rank 3) - 1,19
		--         Increases your chance to dodge by 1%/2%/3% and your pet's chance to dodge by an additional 3%/6%/9%.
		-- Hunter: Aspect of the Monkey - Buff
		--         The hunter takes on the aspects of a monkey, increasing chance to dodge by 8%. Only one Aspect can be active at a time.
		-- Hunter: Improved Aspect of the Monkey (Rank 3) - 1,4
		--         Increases the Dodge bonus of your Aspect of the Monkey by 2%/4%/6%.
		-- Hunter: Deterrence - Buff
		--         Dodge and Parry chance increased by 25%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					1, 2, 3,
				},
			},
			[2] = {
				["rank"] = {
					8,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 4,
				["rank"] = {
					2, 4, 6,
				},
				["buff"] = GetSpellInfo(13163),		-- ["Aspect of the Monkey"],
			},
			[4] = {
				["rank"] = {
					25,
				},
				["buff"] = GetSpellInfo(31567),		-- ["Deterrence"],
			},
		},
		-- Hunter: Survival Instincts (Rank 2) - 1,14
		--         Reduces all damage taken by 2%/4%.

		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Hunter: Thick Hide (Rank 3) - 1,5
		--         Increases the armor rating of your pets by 20% and your armor contribution from items by 4%/7%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 5,
				["rank"] = {
					1.04, 1.07, 1.1,
				},
			},
		},
		-- Hunter: Survivalist (Rank 5) - 3,9
		--         Increases total health by 2%/4%/6%/8%/10%.
		-- Hunter: Endurance Training (Rank 5) - 1,2
		--         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
		["MOD_HEALTH"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					1.01, 1.02, 1.03, 1.04, 1.05,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		-- Hunter: Lightning Reflexes (Rank 5) - 3,18
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.01, 0.02,
				},
			},
			[2] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.03, 0.06,
				},
			},
		},
	},
	["MAGE"] = {
		-- Mage: Arcane Fortitude - 1,9
		--       Increases your armor by an amount equal to 50% of your Intellect.
		-- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
		["ADD_ARMOR_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					1,
				},
			},
		},
		-- Mage: Arcane Meditation (Rank 3) - 1,12
		--       Allows 5%/10%/15% of your Mana regeneration to continue while casting.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 1,
				["num"] = 12,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Mage: Mind Mastery (Rank 5) - 1,22
		--       Increases spell damage by up to 5%/10%/15%/20%/25% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 22,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
		-- Mage: Arctic Winds (Rank 5) - 3,20
		--       Reduces the chance melee and ranged attacks will hit you by 1%/2%/3%/4%/5%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Mage: Prismatic Cloak (Rank 2) - 1,16
		--       Reduces all damage taken by 2%/4%.
		-- Mage: Playing with Fire (Rank 3) - 2,13
		--       Increases all spell damage caused by 1%/2%/3% and all spell damage taken by 1%/2%/3%.
		-- Mage: Frozen Core (Rank 3) - 3,14
		--       Reduces the damage taken by Frost and Fire effects by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			[2] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
			[3] = {
				["FIRE"] = true,
				["FROST"] = true,
				["tab"] = 3,
				["num"] = 14,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Mage: Arcane Mind (Rank 5) - 1,15
		--       Increases your total Intellect by 3%/6%/9%/12%/15%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
	},
	["PALADIN"] = {
		-- Paladin: Pursuit of Justice (Rank 2) - 3,9
		--          Reduces the chance you'll be hit by spells by 1%/2%/3% and increases movement and mounted movement speed by 5%/10%/15%. This does not stack with other movement speed increasing effects.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 9,
				["rank"] = {
					-0.05, -0.1, -0.15,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Holy Guidance (Rank 5) - 1,19
		--          Increases your spell damage and healing by 7%/14%/21%/28%/35% of your total Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					0.07, 0.14, 0.21, 0.28, 0.35,
				},
			},
		},
		-- Paladin: Divine Purpose (Rank 3) - 3,20
		--          Melee and ranged critical strikes against you cause 4%/7%/10% less damage.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 20,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Paladin: Blessed Life (Rank 3) - 1,18
		--          All attacks against you have a 4%/7%/10% chance to cause half damage.
		-- Paladin: Ardent Defender (Rank 5) - 2,19
		--          When you have less than 20% health, all damage taken is reduced by 6%/12%/18%/24%/30%.
		-- Paladin: Spell Warding (Rank 2) - 2,13
		--          All spell damage taken is reduced by 2%/4%.
		-- Paladin: Improved Righteous Fury (Rank 3) - 2,7
		--          While Righteous Fury is active, all damage taken is reduced by 2%/4%/6% and increases the amount of threat generated by your Righteous Fury spell by 16%/33%/50%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.035, -0.05,
				},
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 19,
				["rank"] = {
					-0.06, -0.12, -0.18, -0.24, -0.3,
				},
				["condition"] = "(UnitHealth('player') / UnitHealthMax('player')) < 0.35",
			},
			[3] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			[4] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 7,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
				["buff"] = GetSpellInfo(25781),		-- ["Righteous Fury"],
			},
		},
		-- Paladin: Toughness (Rank 5) - 2,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 5,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Paladin: Divine Strength (Rank 5) - 1,1
		--          Increases your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 1,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Sacred Duty (Rank 2) - 2,16
		--          Increases your total Stamina by 3%/6%, reduces the cooldown of your Divine Shield spell by 60 sec and reduces the attack speed penalty by 100%.
		-- Paladin: Combat Expertise (Rank 5) - 2,21
		--          Increases your expertise by 1/2/3/4/5 and total Stamina by 2%/4%/6%/8%/10%. -- 2.3.0
		["MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 16,
				["rank"] = {
					0.03, 0.06
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Paladin: Divine Intellect (Rank 5) - 1,2
		--          Increases your total Intellect by 2%/4%/6%/8%/10%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 2,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Paladin: Shield Specialization (Rank 3) - 2,8
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		["MOD_BLOCK_VALUE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 8,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	},
	["PRIEST"] = {
		-- Priest: Meditation (Rank 3) - 1,9
		--         Allows 5%/10%/15% of your Mana regeneration to continue while casting.
		-- 2.3.0 increased to 10/20/30% mana regeneration.
		["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.05, 0.1, 0.15,
				},
				["condition"] = "wowBuildNo < '7382'",
			},
			[2] = {
				["tab"] = 1,
				["num"] = 9,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
				["condition"] = "wowBuildNo >= '7382'",
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_SPELL_DMG_MOD_SPI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: Spiritual Guidance (Rank 5) - 2,14
		--         Increases spell damage and healing by up to 5%/10%/15%/20%/25% of your total Spirit.
		-- Priest: Improved Divine Spirit (Rank 2) - 1,15 - Buff
		--         Your Divine Spirit and Prayer of Spirit spells also increase the target's spell damage and healing by an amount equal to 5%/10% of their total Spirit.
		["ADD_HEALING_MOD_SPI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 14,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
			[2] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(39234),		-- ["Divine Spirit"],
			},
			[3] = {
				["tab"] = 1,
				["num"] = 15,
				["rank"] = {
					0.05, 0.1,
				},
				["buff"] = GetSpellInfo(32999),		-- ["Prayer of Spirit"],
			},
		},
		-- Priest: OLD: Elune's Grace (Rank 6) - Buff, NE priest only
		--         OLD: Ranged damage taken reduced by 167 and chance to dodge increased by 10%.
		-- 2.3.0 Elune's Grace (Night Elf) effect changed to reduce chance to be hit by melee and ranged attacks by 20% for 15 seconds. There is now only 1 rank of the spell.
		-- Priest: Elune's Grace (Rank 1) - Buff, NE priest only
		--         Reduces the chance you'll be hit by melee and ranged attacks by 20% for 15 sec.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["rank"] = {
					20,
				},
				["buff"] = GetSpellInfo(2651),		-- ["Elune's Grace"],
			},
		},
		-- Priest: Shadow Resilience (Rank 2) - 3,16
		--         Reduces the chance you'll be critically hit by all spells by 2%/4%.
		["MOD_CRIT_DAMAGE_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Priest: Spell Warding (Rank 5) - 2,4
		--         Reduces all spell damage taken by 2%/4%/6%/8%/10%.
		-- Priest: OLD: Pain Suppression - Buff
		--         OLD: Reduces all damage taken by 60% for 8 sec.
		-- 2.1.0 "Pain Suppression" now reduces damage taken by 65% and increases resistance to Dispel mechanics by 65% for the duration.
		-- 2.3.0 Pain Suppression (Discipline Talent) is now usable on friendly targets, instantly reduces the target's threat by 5%, reduces damage taken by 40% and its cooldown has been reduced to 2 minutes.
		-- Priest: 2.3.0: Pain Suppression - Buff
		--         2.3.0: Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 4,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.4,
				},
				["buff"] = GetSpellInfo(33206),		-- ["Pain Suppression"],
			},
		},
		-- Priest: Mental Strength (Rank 5) - 1,13
		--         IIncreases your maximum Mana by 2%/4%/6%/8%/10%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 13,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		["MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		-- Priest: Spirit of Redemption - 2,13
		--         Increases total Spirit by 5% and upon death, the priest becomes the Spirit of Redemption for 15 sec.
		["MOD_SPI"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
			[2] = {
				["tab"] = 2,
				["num"] = 13,
				["rank"] = {
					0.05,
				},
			},
		},
	},
	["ROGUE"] = {
		-- Rogue: Deadliness (Rank 5) - 3,17
		--        Increases your attack power by 2%/4%/6%/8%/10%.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 17,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Rogue: Lightning Reflexes (Rank 5) - 2,3
		--        Increases your Dodge chance by 1%/2%/3%/4%/5%.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		-- Rogue: Ghostly Strike - Buff
		--        Dodge chance increased by 15%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
			[2] = {
				["rank"] = {
					50, 50,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
			[3] = {
				["rank"] = {
					15,
				},
				["buff"] = GetSpellInfo(31022),		-- ["Ghostly Strike"],
			},
		},
		-- Rogue: Sleight of Hand (Rank 2) - 3,3
		--        Reduces the chance you are critically hit by melee and ranged attacks by 2% and increases the threat reduction of your Feint ability by 20%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 3,
				["num"] = 3,
				["rank"] = {
					-0.02, -0.04,
				},
			},
		},
		-- Rogue: Heightened Senses (Rank 2) - 3,12
		--        Increases your Stealth detection and reduces the chance you are hit by spells and ranged attacks by 2%/4%.
		-- Rogue: Cloak of Shadows - buff
		--        Instantly removes all existing harmful spell effects and increases your chance to resist all spells by 90% for 5 sec. Does not remove effects that prevent you from using Cloak of Shadows.
		-- Rogue: Evasion (Rank 1/2) - Buff
		--        Dodge chance increased by 50%/50% and chance ranged attacks hit you reduced by 0%/25%.
		["ADD_HIT_TAKEN"] = {
			[1] = {
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 12,
				["rank"] = {
					-0.02, -0.04,
				},
			},
			[2] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.9,
				},
				["buff"] = GetSpellInfo(39666),		-- ["Cloak of Shadows"],
			},
			[3] = {
				["RANGED"] = true,
				["rank"] = {
					0, -0.25,
				},
				["buff"] = GetSpellInfo(26669),		-- ["Evasion"],
			},
		},
		-- Rogue: Deadened Nerves (Rank 5) - 1,19
		--        Decreases all physical damage taken by 1%/2%/3%/4%/5%
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 19,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		-- Rogue: Sinister Calling (Rank 5) - 3,21
		--        Increases your total Agility by 3%/6%/9%/12%/15%.
		["MOD_AGI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.01, 0.02,
				},
			},
			[2] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04,
				},
			},
		},
	},
	["SHAMAN"] = {
		-- Shaman: Shamanistic Rage - Buff
		--         Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 15% of your attack power. Lasts 30 sec.
		-- 2.3.0 Shamanistic Rage (Enhancement) now also reduces all damage taken by 30% for the duration.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.3,
				},
				["buff"] = GetSpellInfo(30823),		-- ["Shamanistic Rage"],
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_SPELL_DMG_MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Mental Quickness (Rank 3) - 2,15
		--         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
		["ADD_HEALING_MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 15,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Unrelenting Storm (Rank 5) - 1,14
		--         Regenerate mana equal to 2%/4%/6%/8%/10% of your Intellect every 5 sec, even while casting.
		["ADD_MANA_REG_MOD_INT"] = {
			[1] = {
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Nature's Blessing (Rank 3) - 3,18
		--         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
		["ADD_HEALING_MOD_INT"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
		-- Shaman: Anticipation (Rank 5) - 2,9
		--         Increases your chance to dodge by an additional 1%/2%/3%/4%/5%.
		["ADD_DODGE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1, 2, 3, 4, 5,
				},
			},
		},
		-- Shaman: Elemental Shields (Rank 3) - 1,18
		--         Reduces the chance you will be critically hit by melee and ranged attacks by 2%/4%/6%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 1,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Shaman: Elemental Warding (Rank 3) - 1,4
		--         Reduces damage taken from Fire, Frost and Nature effects by 4%/7%/10%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["tab"] = 1,
				["num"] = 14,
				["rank"] = {
					-0.04, -0.07, -0.1,
				},
			},
		},
		-- Shaman: Toughness (Rank 5) - 2,11
		--         Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 11,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Shaman: Ancestral Knowledge (Rank 5) - 2,1
		--         Increases your maximum Mana by 1%/2%/3%/4%/5%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 1,
				["rank"] = {
					1.01, 1.02, 1.03, 1.04, 1.05,
				},
			},
		},
		-- Shaman: Shield Specialization 5/5 - 2,2
		--         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
		["MOD_BLOCK_VALUE"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 2,
				["rank"] = {
					0.05, 0.1, 0.15, 0.2, 0.25,
				},
			},
		},
	},
	["WARLOCK"] = {
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
		["ADD_SPELL_DMG_MOD_INT"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Knowledge (Rank 3) - 2,20 - UnitExists("pet")
		--          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
		-- WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3;
		-- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
		["ADD_SPELL_DMG_MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.012, 0.024, 0.036,
				},
				["condition"] = "UnitExists('pet')",
			},
		},
		-- Warlock: Demonic Resilience (Rank 3) - 2,18
		--          Reduces the chance you'll be critically hit by melee and spells by 1%/2%/3% and reduces all damage your summoned demon takes by 15%.
		["ADD_CRIT_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 2,
				["num"] = 18,
				["rank"] = {
					-0.01, -0.02, -0.03,
				},
			},
		},
		-- Warlock: Master Demonologist (Rank 5) - 2,17
		--          Voidwalker - Reduces physical damage taken by 2%/4%/6%/8%/10%.
		-- Warlock: Soul Link (Rank 1) - 2,19
		--          When active, 20% of all damage taken by the caster is taken by your Imp, Voidwalker, Succubus, Felhunter or Felguard demon instead. In addition, both the demon and master will inflict 5% more damage. Lasts as long as the demon is active.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["tab"] = 2,
				["num"] = 17,
				["rank"] = {
					-0.02, -0.04, -0.06, -0.08, -0.1,
				},
				["condition"] = "IsUsableSpell('"..(GetSpellInfo(11775)).."')" --"UnitCreatureFamily('pet') == '"..L["Voidwalker"].."'",	-- ["Torment"]
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.2,
				},
				["buff"] = GetSpellInfo(25228),		-- ["Soul Link"],
			},
		},
		-- Warlock: Fel Stamina (Rank 3) - 2,9
		--          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
		["MOD_HEALTH"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 9,
				["rank"] = {
					1.01, 1.02, 1.03,
				},
			},
		},
		-- Warlock: Fel Intellect (Rank 3) - 2,6
		--          Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum mana by 1%/2%/3%.
		["MOD_MANA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 6,
				["rank"] = {
					1.01, 1.02, 1.03,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					0.03, 0.06, 0.09, 0.12, 0.15,
				},
			},
		},
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		["MOD_SPI"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 3,
				["rank"] = {
					-0.01, -0.02, -0.03, -0.04, -0.05,
				},
			},
		},
	},
	["WARRIOR"] = {
		-- Warrior: Improved Berserker Stance (Rank 5) - 2,20 - Stance
		--          Increases attack power by 2%/4%/6%/8%/10% while in Berserker Stance.
		["MOD_AP"] = {
			[1] = {
				["tab"] = 2,
				["num"] = 20,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
		},
		-- Warrior: Shield Wall - Buff
		--          Reduces the Physical and magical damage taken by the caster by 75% for 10 sec.
		-- Warrior: Defensive Stance - stance
		--          A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases threat generated.
		-- Warrior: Berserker Stance - stance
		--          An aggressive stance. Critical hit chance is increased by 3% and all damage taken is increased by 10%.
		-- Warrior: Death Wish - Buff
		--          When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%. Lasts 30 sec.
		-- Warrior: Recklessness - Buff
		--          The warrior will cause critical hits with most attacks and will be immune to Fear effects for the next 15 sec, but all damage taken is increased by 20%.
		-- Warrior: Improved Defensive Stance (Rank 3) - 3,18
				--          Reduces all spell damage taken while in Defensive Stance by 2%/4%/6%.
		["MOD_DMG_TAKEN"] = {
			[1] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.75,
				},
				["buff"] = GetSpellInfo(41196),		-- ["Shield Wall"],
			},
			[2] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					-0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			},
			[3] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.1,
				},
				["stance"] = "Interface\\Icons\\Ability_Racial_Avatar",
			},
			[4] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.05,
				},
				["buff"] = GetSpellInfo(12292),		-- ["Death Wish"],
			},
			[5] = {
				["MELEE"] = true,
				["RANGED"] = true,
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(13847),		-- ["Recklessness"],
			},
			[6] = {
				["HOLY"] = true,
				["FIRE"] = true,
				["NATURE"] = true,
				["FROST"] = true,
				["SHADOW"] = true,
				["ARCANE"] = true,
				["tab"] = 3,
				["num"] = 18,
				["rank"] = {
					-0.02, -0.04, -0.06,
				},
			},
		},
		-- Warrior: Toughness (Rank 5) - 3,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		["MOD_ARMOR"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 5,
				["rank"] = {
					1.02, 1.04, 1.06, 1.08, 1.1,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STA"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.01, 0.02, 0.03, 0.04, 0.05,
				},
			},
		},
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		["MOD_STR"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 21,
				["rank"] = {
					0.02, 0.04, 0.06, 0.08, 0.1,
				},
			},
		},
		-- Warrior: Shield Mastery (Rank 3) - 3,16
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		["MOD_BLOCK_VALUE"] = {
			[1] = {
				["tab"] = 3,
				["num"] = 16,
				["rank"] = {
					0.1, 0.2, 0.3,
				},
			},
		},
	},
	["ALL"] = {
		-- Priest: Power Infusion - Buff
		--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
		["MOD_SPELL_DMG"] = {
			[1] = {
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(37274),		-- ["Power Infusion"],
			},
		},
		-- Priest: Power Infusion - Buff
		--         Infuses the target with power, increasing their spell damage and healing by 20%. Lasts 15 sec.
		["MOD_HEALING"] = {
			[1] = {
				["rank"] = {
					0.2,
				},
				["buff"] = GetSpellInfo(37274),		-- ["Power Infusion"],
			},
		},
		-- Night Elf : Quickness - Racial
		--             Dodge chance increased by 1%.
		["ADD_DODGE"] = {
			[1] = {
				["rank"] = {
					1,
				},
				["race"] = "NightElf",
			},
		},
		-- Paladin: Lay on Hands (Rank 1/2) - Buff
		--          Armor increased by 15%/30%.
		-- Priest: Inspiration (Rank 1/2/3) - Buff
		--         Increases armor by 8%/16%/25%.
		-- Shaman: Ancestral Fortitude (Rank 1/2/3) - Buff
		--         Increases your armor value by 8%/16%/25%.
		["MOD_ARMOR"] = {
			[1] = {
				["rank"] = {
					1.15, 1.30,
				},
				["buff"] = GetSpellInfo(27154),		-- ["Lay on Hands"],
			},
			[2] = {
				["rank"] = {
					1.08, 1.16, 1.25,
				},
				["buff"] = GetSpellInfo(15363),		-- ["Inspiration"],
			},
			[3] = {
				["rank"] = {
					1.08, 1.16, 1.25,
				},
				["buff"] = GetSpellInfo(16237),		-- ["Ancestral Fortitude"],
			},
		},
		-- Tauren: Endurance - Racial
		--         Total Health increased by 5%.
		["MOD_HEALTH"] = {
			[1] = {
				["rank"] = {
					1.05,
				},
				["race"] = "Tauren",
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_STR"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_AGI"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		["MOD_STA"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Gnome: Expansive Mind - Racial
		--        Increase Intelligence by 5%.
		["MOD_INT"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
			[3] = {
				["rank"] = {
					0.05,
				},
				["race"] = "Gnome",
			},
		},
		-- Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Greater Blessing of Kings - Buff
		-- Increases stats by 10%.
		-- Human: The Human Spirit - Racial
		--        Increase Spirit by 10%.
		["MOD_SPI"] = {
			[1] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(20217),		-- ["Blessing of Kings"],
			},
			[2] = {
				["rank"] = {
					0.1,
				},
				["buff"] = GetSpellInfo(25898),		-- ["Greater Blessing of Kings"],
			},
			[3] = {
				["rank"] = {
					0.1,
				},
				["race"] = "Human",
			},
		},
	},
}

function StatLogic:GetStatMod(stat, school)
	local statModInfo = StatModInfo[stat]
	local mod = statModInfo.initialValue
	-- if school is required for this statMod but not given
	if statModInfo.school and not school then return mod end
	-- Class specific mods
	if type(StatModTable[playerClass][stat]) == "table" then
		for _, case in ipairs(StatModTable[playerClass][stat]) do
			local ok = true
			if school and not case[school] then ok = nil end
			if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
			if ok and case.buff and not AuraUtil.FindAuraByName(case.buff, "player") then ok = nil end
			if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
			if ok then
				local r, _
				-- if talant field
				if case.tab and case.num then
					_, _, _, _, r = GetTalentInfo(case.tab, case.num)
				-- no talant but buff is given
				elseif case.buff then
					r = GetPlayerBuffRank(case.buff)
				-- no talant but all other given conditions are statisfied
				elseif case.condition or case.stance then
					r = 1
				end
				if r and r ~= 0 and case.rank[r] then
					if statModInfo.initialValue == 0 then
						mod = mod + case.rank[r]
					else
						mod = mod * case.rank[r]
					end
				end
			end
		end
	end
	-- Non class specific mods
	if type(StatModTable["ALL"][stat]) == "table" then
		for _, case in ipairs(StatModTable["ALL"][stat]) do
			local ok = true
			if school and not case[school] then ok = nil end
			if ok and case.condition and not loadstring("return "..case.condition)() then ok = nil end
			if ok and case.buff and not AuraUtil.FindAuraByName(case.buff, "player") then ok = nil end
			if ok and case.stance and case.stance ~= GetStanceIcon() then ok = nil end
			if ok and case.race and case.race ~= playerRace then ok = nil end
			if ok then
				local r
				-- there are no talants in non class specific mods
				-- check buff
				if case.buff then
					r = GetPlayerBuffRank(case.buff)
				-- no talant but all other given conditions are statisfied
				elseif case.condition or case.stance or case.race then
					r = 1
				end
				if r and r ~= 0 and case.rank[r] then
					if statModInfo.initialValue == 0 then
						mod = mod + case.rank[r]
					else
						mod = mod * case.rank[r]
					end
				end
			end
		end
	end

	return mod + statModInfo.finalAdjust
end


--=================--
-- Stat Conversion --
--=================--
function StatLogic:GetReductionFromArmor(armor, attackerLevel)
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
	return (defense - attackerLevel * 5) * 0.04
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

--[[ Rating ID as definded in PaperDollFrame.lua
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
--]]

-- Level 60 rating base
local RatingBase = {
	[CR_WEAPON_SKILL] = 2.5,
	[CR_DEFENSE_SKILL] = 1.5,
	[CR_DODGE] = 12,
	[CR_PARRY] = 15,
	[CR_BLOCK] = 5,
	[CR_HIT_MELEE] = 10,
	[CR_HIT_RANGED] = 10,
	[CR_HIT_SPELL] = 8,
	[CR_CRIT_MELEE] = 14,
	[CR_CRIT_RANGED] = 14,
	[CR_CRIT_SPELL] = 14,
	[CR_HIT_TAKEN_MELEE] = 10, -- hit avoidance
	[CR_HIT_TAKEN_RANGED] = 10,
	[CR_HIT_TAKEN_SPELL] = 8,
	[CR_CRIT_TAKEN_MELEE] = 25, -- resilience
	[CR_CRIT_TAKEN_RANGED] = 25,
	[CR_CRIT_TAKEN_SPELL] = 25,
	[CR_HASTE_MELEE] = 10, -- changed in 2.2
	[CR_HASTE_RANGED] = 10, -- changed in 2.2
	[CR_HASTE_SPELL] = 10, -- changed in 2.2
	[CR_WEAPON_SKILL_MAINHAND] = 2.5,
	[CR_WEAPON_SKILL_OFFHAND] = 2.5,
	[CR_WEAPON_SKILL_RANGED] = 2.5,
	[CR_EXPERTISE] = 2.5,
}

-- Formula reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
--  Parry Rating, Defense Rating, and Block Rating: Low-level players 
--   will now convert these ratings into their corresponding defensive 
--   stats at the same rate as level 34 players.
function StatLogic:GetEffectFromRating(rating, id, level)
	-- if id is stringID then convert to numberID
	if type(id) == "string" and RatingNameToID[id] then
		id = RatingNameToID[id]
	end
	-- check for invalid input
	if type(rating) ~= "number" or id < 1 or id > 24 then return 0 end
	-- defaults to player level if not given
	level = level or UnitLevel("player")
	--2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players 
	--   will now convert these ratings into their corresponding defensive 
	--   stats at the same rate as level 34 players.
	if (id == CR_DEFENSE_SKILL or id == CR_PARRY or id == CR_BLOCK) and level < 34 then
		level = 34
	end
	if level >= 60 then
		return rating/RatingBase[id]*((-3/82)*level+(131/41)), RatingIDToConvertedStat[id]
	elseif level >= 10 then
		return rating/RatingBase[id]/((1/52)*level-(8/52)), RatingIDToConvertedStat[id]
	else
		return rating/RatingBase[id]/((1/52)*10-(8/52)), RatingIDToConvertedStat[id]
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

local APPerStr = {
	2, 2, 1, 1, 1, 2, 1, 1, 2,
	--["WARRIOR"] = 2,
	--["PALADIN"] = 2,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 1,
	--["SHAMAN"] = 2,
	--["MAGE"] = 1,
	--["WARLOCK"] = 1,
	--["DRUID"] = 2,
}

function StatLogic:GetAPPerStr(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetAPPerStr, got "..type(class))
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return APPerStr[class], "AP"
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
	assert(type(str)=="number", "Expected number as arg #1 to GetAPFromStr, got "..type(class))
	assert(type(str)=="string", "Expected string as arg #2 to GetAPFromStr, got "..type(class))
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return str * APPerStr[class], "AP"
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

local BlockValuePerStr = {
	0.05, 0.05, 0, 0, 0, 0.05, 0, 0, 0,
	--["WARRIOR"] = 0.05,
	--["PALADIN"] = 0.05,
	--["HUNTER"] = 0,
	--["ROGUE"] = 0,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0.05,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetBlockValuePerStr(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetBlockValuePerStr, got "..type(class))
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return BlockValuePerStr[class], "BLOCK_VALUE"
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
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return str * BlockValuePerStr[class], "BLOCK_VALUE"
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

local APPerAgi = {
	0, 0, 1, 1, 0, 0, 0, 0, 0,
	--["WARRIOR"] = 0,
	--["PALADIN"] = 0,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetAPPerAgi(class)
	assert(type(class)=="string" or type(class)=="number", "Expected string or number as arg #1 to GetAPPerAgi, got "..type(class))
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Check druid cat form
	if (class == 9) and (GetShapeshiftFormID() == CAT_FORM) then		-- ["Cat Form"]
		return 1
	end
	return APPerAgi[class], "AP"
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
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return agi * APPerAgi[class], "AP"
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

local RAPPerAgi = {
	1, 0, 1, 1, 0, 0, 0, 0, 0,
	--["WARRIOR"] = 1,
	--["PALADIN"] = 0,
	--["HUNTER"] = 1,
	--["ROGUE"] = 1,
	--["PRIEST"] = 0,
	--["SHAMAN"] = 0,
	--["MAGE"] = 0,
	--["WARLOCK"] = 0,
	--["DRUID"] = 0,
}

function StatLogic:GetRAPPerAgi(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return RAPPerAgi[class], "RANGED_AP"
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
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return agi * RAPPerAgi[class], "RANGED_AP"
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

-- Numbers derived by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local BaseDodge = {
	0.7580, 0.6520, -5.4500, -0.5900, 3.1830, 1.6750, 3.4575, 2.0350, -1.8720,
	--["WARRIOR"] = 0.7580,
	--["PALADIN"] = 0.6520,
	--["HUNTER"] = -5.4500,
	--["ROGUE"] = -0.5900,
	--["PRIEST"] = 3.1830,
	--["SHAMAN"] = 1.6750,
	--["MAGE"] = 3.4575,
	--["WARLOCK"] = 2.0350,
	--["DRUID"] = -1.8720,
}

function StatLogic:GetBaseDodge(class)
	-- argCheck for invalid input
	self:argCheck(class, 2, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	return BaseDodge[class], "DODGE"
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
	local class = ClassNameToID[playerClass]
	-- dodgeFromAgi is %
	local dodgeFromAgi = GetDodgeChance() - self:GetStatMod("ADD_DODGE") - self:GetEffectFromRating(GetCombatRating(CR_DODGE), CR_DODGE, UnitLevel("player")) - self:GetEffectFromDefense(GetTotalDefense("player"), UnitLevel("player"))
	return (dodgeFromAgi - BaseDodge[class]) / agility, "DODGE"
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

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local CritPerAgi = {
	 [1] = {0.2500, 0.2174, 0.2840, 0.4476, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
	 [2] = {0.2381, 0.2070, 0.2834, 0.4290, 0.0909, 0.1663, 0.0771, 0.1500, 0.2020, },
	 [3] = {0.2381, 0.2070, 0.2711, 0.4118, 0.0909, 0.1583, 0.0771, 0.1429, 0.1923, },
	 [4] = {0.2273, 0.1976, 0.2530, 0.3813, 0.0865, 0.1583, 0.0735, 0.1429, 0.1923, },
	 [5] = {0.2174, 0.1976, 0.2430, 0.3677, 0.0865, 0.1511, 0.0735, 0.1429, 0.1836, },
	 [6] = {0.2083, 0.1890, 0.2337, 0.3550, 0.0865, 0.1511, 0.0735, 0.1364, 0.1836, },
	 [7] = {0.2083, 0.1890, 0.2251, 0.3321, 0.0865, 0.1511, 0.0735, 0.1364, 0.1756, },
	 [8] = {0.2000, 0.1812, 0.2171, 0.3217, 0.0826, 0.1446, 0.0735, 0.1364, 0.1756, },
	 [9] = {0.1923, 0.1812, 0.2051, 0.3120, 0.0826, 0.1446, 0.0735, 0.1304, 0.1683, },
	[10] = {0.1923, 0.1739, 0.1984, 0.2941, 0.0826, 0.1385, 0.0701, 0.1304, 0.1553, },
	[11] = {0.1852, 0.1739, 0.1848, 0.2640, 0.0826, 0.1385, 0.0701, 0.1250, 0.1496, },
	[12] = {0.1786, 0.1672, 0.1670, 0.2394, 0.0790, 0.1330, 0.0701, 0.1250, 0.1496, },
	[13] = {0.1667, 0.1553, 0.1547, 0.2145, 0.0790, 0.1330, 0.0701, 0.1250, 0.1443, },
	[14] = {0.1613, 0.1553, 0.1441, 0.1980, 0.0790, 0.1279, 0.0701, 0.1200, 0.1443, },
	[15] = {0.1563, 0.1449, 0.1330, 0.1775, 0.0790, 0.1231, 0.0671, 0.1154, 0.1346, },
	[16] = {0.1515, 0.1449, 0.1267, 0.1660, 0.0757, 0.1188, 0.0671, 0.1111, 0.1346, },
	[17] = {0.1471, 0.1403, 0.1194, 0.1560, 0.0757, 0.1188, 0.0671, 0.1111, 0.1303, },
	[18] = {0.1389, 0.1318, 0.1117, 0.1450, 0.0757, 0.1147, 0.0671, 0.1111, 0.1262, },
	[19] = {0.1351, 0.1318, 0.1060, 0.1355, 0.0727, 0.1147, 0.0671, 0.1071, 0.1262, },
	[20] = {0.1282, 0.1242, 0.0998, 0.1271, 0.0727, 0.1073, 0.0643, 0.1034, 0.1122, },
	[21] = {0.1282, 0.1208, 0.0962, 0.1197, 0.0727, 0.1073, 0.0643, 0.1000, 0.1122, },
	[22] = {0.1250, 0.1208, 0.0910, 0.1144, 0.0727, 0.1039, 0.0643, 0.1000, 0.1092, },
	[23] = {0.1190, 0.1144, 0.0872, 0.1084, 0.0699, 0.1039, 0.0643, 0.0968, 0.1063, },
	[24] = {0.1163, 0.1115, 0.0829, 0.1040, 0.0699, 0.1008, 0.0617, 0.0968, 0.1063, },
	[25] = {0.1111, 0.1087, 0.0797, 0.0980, 0.0699, 0.0978, 0.0617, 0.0909, 0.1010, },
	[26] = {0.1087, 0.1060, 0.0767, 0.0936, 0.0673, 0.0950, 0.0617, 0.0909, 0.1010, },
	[27] = {0.1064, 0.1035, 0.0734, 0.0903, 0.0673, 0.0950, 0.0617, 0.0909, 0.0985, },
	[28] = {0.1020, 0.1011, 0.0709, 0.0865, 0.0673, 0.0924, 0.0617, 0.0882, 0.0962, },
	[29] = {0.1000, 0.0988, 0.0680, 0.0830, 0.0649, 0.0924, 0.0593, 0.0882, 0.0962, },
	[30] = {0.0962, 0.0945, 0.0654, 0.0792, 0.0649, 0.0875, 0.0593, 0.0833, 0.0878, },
	[31] = {0.0943, 0.0925, 0.0637, 0.0768, 0.0649, 0.0875, 0.0593, 0.0833, 0.0859, },
	[32] = {0.0926, 0.0925, 0.0614, 0.0741, 0.0627, 0.0853, 0.0593, 0.0811, 0.0859, },
	[33] = {0.0893, 0.0887, 0.0592, 0.0715, 0.0627, 0.0831, 0.0571, 0.0811, 0.0841, },
	[34] = {0.0877, 0.0870, 0.0575, 0.0691, 0.0627, 0.0831, 0.0571, 0.0789, 0.0824, },
	[35] = {0.0847, 0.0836, 0.0556, 0.0664, 0.0606, 0.0792, 0.0571, 0.0769, 0.0808, },
	[36] = {0.0833, 0.0820, 0.0541, 0.0643, 0.0606, 0.0773, 0.0551, 0.0750, 0.0792, },
	[37] = {0.0820, 0.0820, 0.0524, 0.0628, 0.0606, 0.0773, 0.0551, 0.0732, 0.0777, },
	[38] = {0.0794, 0.0791, 0.0508, 0.0609, 0.0586, 0.0756, 0.0551, 0.0732, 0.0777, },
	[39] = {0.0781, 0.0776, 0.0493, 0.0592, 0.0586, 0.0756, 0.0551, 0.0714, 0.0762, },
	[40] = {0.0758, 0.0750, 0.0481, 0.0572, 0.0586, 0.0723, 0.0532, 0.0698, 0.0709, },
	[41] = {0.0735, 0.0737, 0.0470, 0.0556, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
	[42] = {0.0725, 0.0737, 0.0457, 0.0542, 0.0568, 0.0707, 0.0532, 0.0682, 0.0696, },
	[43] = {0.0704, 0.0713, 0.0444, 0.0528, 0.0551, 0.0693, 0.0532, 0.0667, 0.0685, },
	[44] = {0.0694, 0.0701, 0.0433, 0.0512, 0.0551, 0.0679, 0.0514, 0.0667, 0.0673, },
	[45] = {0.0676, 0.0679, 0.0421, 0.0497, 0.0551, 0.0665, 0.0514, 0.0638, 0.0651, },
	[46] = {0.0667, 0.0669, 0.0413, 0.0486, 0.0534, 0.0652, 0.0514, 0.0625, 0.0641, },
	[47] = {0.0649, 0.0659, 0.0402, 0.0474, 0.0534, 0.0639, 0.0498, 0.0625, 0.0641, },
	[48] = {0.0633, 0.0639, 0.0391, 0.0464, 0.0519, 0.0627, 0.0498, 0.0612, 0.0631, },
	[49] = {0.0625, 0.0630, 0.0382, 0.0454, 0.0519, 0.0627, 0.0498, 0.0600, 0.0621, },
	[50] = {0.0610, 0.0612, 0.0373, 0.0440, 0.0519, 0.0605, 0.0482, 0.0588, 0.0585, },
	[51] = {0.0595, 0.0604, 0.0366, 0.0431, 0.0505, 0.0594, 0.0482, 0.0577, 0.0577, },
	[52] = {0.0588, 0.0596, 0.0358, 0.0422, 0.0505, 0.0583, 0.0482, 0.0577, 0.0569, },
	[53] = {0.0575, 0.0580, 0.0350, 0.0412, 0.0491, 0.0583, 0.0467, 0.0566, 0.0561, },
	[54] = {0.0562, 0.0572, 0.0341, 0.0404, 0.0491, 0.0573, 0.0467, 0.0556, 0.0561, },
	[55] = {0.0549, 0.0557, 0.0334, 0.0394, 0.0478, 0.0554, 0.0467, 0.0545, 0.0546, },
	[56] = {0.0543, 0.0550, 0.0328, 0.0386, 0.0478, 0.0545, 0.0454, 0.0536, 0.0539, },
	[57] = {0.0532, 0.0544, 0.0321, 0.0378, 0.0466, 0.0536, 0.0454, 0.0526, 0.0531, },
	[58] = {0.0521, 0.0530, 0.0314, 0.0370, 0.0466, 0.0536, 0.0454, 0.0517, 0.0525, },
	[59] = {0.0510, 0.0524, 0.0307, 0.0364, 0.0454, 0.0528, 0.0441, 0.0517, 0.0518, },
	[60] = {0.0500, 0.0512, 0.0301, 0.0355, 0.0454, 0.0512, 0.0441, 0.0500, 0.0493, },
	[61] = {0.0469, 0.0491, 0.0297, 0.0334, 0.0443, 0.0496, 0.0435, 0.0484, 0.0478, },
	[62] = {0.0442, 0.0483, 0.0290, 0.0322, 0.0444, 0.0486, 0.0432, 0.0481, 0.0472, },
	[63] = {0.0418, 0.0472, 0.0284, 0.0307, 0.0441, 0.0470, 0.0424, 0.0470, 0.0456, },
	[64] = {0.0397, 0.0456, 0.0279, 0.0296, 0.0433, 0.0456, 0.0423, 0.0455, 0.0447, },
	[65] = {0.0377, 0.0446, 0.0273, 0.0286, 0.0426, 0.0449, 0.0422, 0.0448, 0.0438, },
	[66] = {0.0360, 0.0437, 0.0270, 0.0276, 0.0419, 0.0437, 0.0411, 0.0435, 0.0430, },
	[67] = {0.0344, 0.0425, 0.0264, 0.0268, 0.0414, 0.0427, 0.0412, 0.0436, 0.0424, },
	[68] = {0.0329, 0.0416, 0.0259, 0.0262, 0.0412, 0.0417, 0.0408, 0.0424, 0.0412, },
	[69] = {0.0315, 0.0408, 0.0254, 0.0256, 0.0410, 0.0408, 0.0404, 0.0414, 0.0406, },
	[70] = {0.0303, 0.0400, 0.0250, 0.0250, 0.0400, 0.0400, 0.0400, 0.0405, 0.0400, },
	[71] = {0.0297, 0.0393, 0.0246, 0.0244, 0.0390, 0.0392, 0.0396, 0.0396, 0.0394, },
	[72] = {0.0292, 0.0385, 0.0242, 0.0238, 0.0381, 0.0384, 0.0393, 0.0387, 0.0388, },
	[73] = {0.0287, 0.0378, 0.0238, 0.0233, 0.0372, 0.0377, 0.0389, 0.0379, 0.0383, },
}

function StatLogic:GetCritFromAgi(agi, class, level)
	-- argCheck for invalid input
	self:argCheck(agi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 73 then
		level = UnitLevel("player")
	end
	-- Calculate
	return agi * CritPerAgi[level][class], "MELEE_CRIT"
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

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local SpellCritPerInt = {
	 [1] = {0.0000, 0.0832, 0.0699, 0.0000, 0.1710, 0.1333, 0.1637, 0.1500, 0.1431, },
	 [2] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1636, 0.1272, 0.1574, 0.1435, 0.1369, },
	 [3] = {0.0000, 0.0793, 0.0666, 0.0000, 0.1568, 0.1217, 0.1516, 0.1375, 0.1312, },
	 [4] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1505, 0.1217, 0.1411, 0.1320, 0.1259, },
	 [5] = {0.0000, 0.0757, 0.0635, 0.0000, 0.1394, 0.1166, 0.1364, 0.1269, 0.1211, },
	 [6] = {0.0000, 0.0724, 0.0608, 0.0000, 0.1344, 0.1120, 0.1320, 0.1222, 0.1166, },
	 [7] = {0.0000, 0.0694, 0.0608, 0.0000, 0.1297, 0.1077, 0.1279, 0.1179, 0.1124, },
	 [8] = {0.0000, 0.0694, 0.0583, 0.0000, 0.1254, 0.1037, 0.1240, 0.1138, 0.1124, },
	 [9] = {0.0000, 0.0666, 0.0583, 0.0000, 0.1214, 0.1000, 0.1169, 0.1100, 0.1086, },
	[10] = {0.0000, 0.0666, 0.0559, 0.0000, 0.1140, 0.1000, 0.1137, 0.1065, 0.0984, },
	[11] = {0.0000, 0.0640, 0.0559, 0.0000, 0.1045, 0.0933, 0.1049, 0.0971, 0.0926, },
	[12] = {0.0000, 0.0616, 0.0538, 0.0000, 0.0941, 0.0875, 0.0930, 0.0892, 0.0851, },
	[13] = {0.0000, 0.0594, 0.0499, 0.0000, 0.0875, 0.0800, 0.0871, 0.0825, 0.0807, },
	[14] = {0.0000, 0.0574, 0.0499, 0.0000, 0.0784, 0.0756, 0.0731, 0.0767, 0.0750, },
	[15] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0724, 0.0700, 0.0671, 0.0717, 0.0684, },
	[16] = {0.0000, 0.0537, 0.0466, 0.0000, 0.0684, 0.0666, 0.0639, 0.0688, 0.0656, },
	[17] = {0.0000, 0.0520, 0.0451, 0.0000, 0.0627, 0.0636, 0.0602, 0.0635, 0.0617, },
	[18] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0597, 0.0596, 0.0568, 0.0600, 0.0594, },
	[19] = {0.0000, 0.0490, 0.0424, 0.0000, 0.0562, 0.0571, 0.0538, 0.0569, 0.0562, },
	[20] = {0.0000, 0.0462, 0.0399, 0.0000, 0.0523, 0.0538, 0.0505, 0.0541, 0.0516, },
	[21] = {0.0000, 0.0450, 0.0388, 0.0000, 0.0502, 0.0518, 0.0487, 0.0516, 0.0500, },
	[22] = {0.0000, 0.0438, 0.0388, 0.0000, 0.0470, 0.0500, 0.0460, 0.0493, 0.0477, },
	[23] = {0.0000, 0.0427, 0.0368, 0.0000, 0.0453, 0.0474, 0.0445, 0.0471, 0.0463, },
	[24] = {0.0000, 0.0416, 0.0358, 0.0000, 0.0428, 0.0459, 0.0422, 0.0446, 0.0437, },
	[25] = {0.0000, 0.0396, 0.0350, 0.0000, 0.0409, 0.0437, 0.0405, 0.0429, 0.0420, },
	[26] = {0.0000, 0.0387, 0.0341, 0.0000, 0.0392, 0.0424, 0.0390, 0.0418, 0.0409, },
	[27] = {0.0000, 0.0387, 0.0333, 0.0000, 0.0376, 0.0412, 0.0372, 0.0398, 0.0394, },
	[28] = {0.0000, 0.0370, 0.0325, 0.0000, 0.0362, 0.0394, 0.0338, 0.0384, 0.0384, },
	[29] = {0.0000, 0.0362, 0.0318, 0.0000, 0.0348, 0.0383, 0.0325, 0.0367, 0.0366, },
	[30] = {0.0000, 0.0347, 0.0304, 0.0000, 0.0333, 0.0368, 0.0312, 0.0355, 0.0346, },
	[31] = {0.0000, 0.0340, 0.0297, 0.0000, 0.0322, 0.0354, 0.0305, 0.0347, 0.0339, },
	[32] = {0.0000, 0.0333, 0.0297, 0.0000, 0.0311, 0.0346, 0.0294, 0.0333, 0.0325, },
	[33] = {0.0000, 0.0326, 0.0285, 0.0000, 0.0301, 0.0333, 0.0286, 0.0324, 0.0318, },
	[34] = {0.0000, 0.0320, 0.0280, 0.0000, 0.0289, 0.0325, 0.0278, 0.0311, 0.0309, },
	[35] = {0.0000, 0.0308, 0.0269, 0.0000, 0.0281, 0.0314, 0.0269, 0.0303, 0.0297, },
	[36] = {0.0000, 0.0303, 0.0264, 0.0000, 0.0273, 0.0304, 0.0262, 0.0295, 0.0292, },
	[37] = {0.0000, 0.0297, 0.0264, 0.0000, 0.0263, 0.0298, 0.0254, 0.0284, 0.0284, },
	[38] = {0.0000, 0.0287, 0.0254, 0.0000, 0.0256, 0.0289, 0.0248, 0.0277, 0.0276, },
	[39] = {0.0000, 0.0282, 0.0250, 0.0000, 0.0249, 0.0283, 0.0241, 0.0268, 0.0269, },
	[40] = {0.0000, 0.0273, 0.0241, 0.0000, 0.0241, 0.0272, 0.0235, 0.0262, 0.0256, },
	[41] = {0.0000, 0.0268, 0.0237, 0.0000, 0.0235, 0.0267, 0.0230, 0.0256, 0.0252, },
	[42] = {0.0000, 0.0264, 0.0237, 0.0000, 0.0228, 0.0262, 0.0215, 0.0248, 0.0244, },
	[43] = {0.0000, 0.0256, 0.0229, 0.0000, 0.0223, 0.0254, 0.0211, 0.0243, 0.0240, },
	[44] = {0.0000, 0.0256, 0.0225, 0.0000, 0.0216, 0.0248, 0.0206, 0.0236, 0.0233, },
	[45] = {0.0000, 0.0248, 0.0218, 0.0000, 0.0210, 0.0241, 0.0201, 0.0229, 0.0228, },
	[46] = {0.0000, 0.0245, 0.0215, 0.0000, 0.0206, 0.0235, 0.0197, 0.0224, 0.0223, },
	[47] = {0.0000, 0.0238, 0.0212, 0.0000, 0.0200, 0.0231, 0.0192, 0.0220, 0.0219, },
	[48] = {0.0000, 0.0231, 0.0206, 0.0000, 0.0196, 0.0226, 0.0188, 0.0214, 0.0214, },
	[49] = {0.0000, 0.0228, 0.0203, 0.0000, 0.0191, 0.0220, 0.0184, 0.0209, 0.0209, },
	[50] = {0.0000, 0.0222, 0.0197, 0.0000, 0.0186, 0.0215, 0.0179, 0.0204, 0.0202, },
	[51] = {0.0000, 0.0219, 0.0194, 0.0000, 0.0183, 0.0210, 0.0176, 0.0200, 0.0198, },
	[52] = {0.0000, 0.0216, 0.0192, 0.0000, 0.0178, 0.0207, 0.0173, 0.0195, 0.0193, },
	[53] = {0.0000, 0.0211, 0.0186, 0.0000, 0.0175, 0.0201, 0.0170, 0.0191, 0.0191, },
	[54] = {0.0000, 0.0208, 0.0184, 0.0000, 0.0171, 0.0199, 0.0166, 0.0186, 0.0186, },
	[55] = {0.0000, 0.0203, 0.0179, 0.0000, 0.0166, 0.0193, 0.0162, 0.0182, 0.0182, },
	[56] = {0.0000, 0.0201, 0.0177, 0.0000, 0.0164, 0.0190, 0.0154, 0.0179, 0.0179, },
	[57] = {0.0000, 0.0198, 0.0175, 0.0000, 0.0160, 0.0187, 0.0151, 0.0176, 0.0176, },
	[58] = {0.0000, 0.0191, 0.0170, 0.0000, 0.0157, 0.0182, 0.0149, 0.0172, 0.0173, },
	[59] = {0.0000, 0.0189, 0.0168, 0.0000, 0.0154, 0.0179, 0.0146, 0.0168, 0.0169, },
	[60] = {0.0000, 0.0185, 0.0164, 0.0000, 0.0151, 0.0175, 0.0143, 0.0165, 0.0164, },
	[61] = {0.0000, 0.0157, 0.0157, 0.0000, 0.0148, 0.0164, 0.0143, 0.0159, 0.0162, },
	[62] = {0.0000, 0.0153, 0.0154, 0.0000, 0.0145, 0.0159, 0.0143, 0.0154, 0.0157, },
	[63] = {0.0000, 0.0148, 0.0150, 0.0000, 0.0143, 0.0152, 0.0143, 0.0148, 0.0150, },
	[64] = {0.0000, 0.0143, 0.0144, 0.0000, 0.0139, 0.0147, 0.0142, 0.0143, 0.0146, },
	[65] = {0.0000, 0.0140, 0.0141, 0.0000, 0.0137, 0.0142, 0.0142, 0.0138, 0.0142, },
	[66] = {0.0000, 0.0136, 0.0137, 0.0000, 0.0134, 0.0138, 0.0138, 0.0135, 0.0137, },
	[67] = {0.0000, 0.0133, 0.0133, 0.0000, 0.0132, 0.0134, 0.0133, 0.0130, 0.0133, },
	[68] = {0.0000, 0.0131, 0.0130, 0.0000, 0.0130, 0.0131, 0.0131, 0.0127, 0.0131, },
	[69] = {0.0000, 0.0128, 0.0128, 0.0000, 0.0127, 0.0128, 0.0128, 0.0125, 0.0128, },
	[70] = {0.0000, 0.0125, 0.0125, 0.0000, 0.0125, 0.0125, 0.0125, 0.0122, 0.0125, },
	[71] = {0.0000, 0.0122, 0.0123, 0.0000, 0.0123, 0.0122, 0.0122, 0.0119, 0.0122, },
	[72] = {0.0000, 0.0120, 0.0120, 0.0000, 0.0121, 0.0120, 0.0119, 0.0116, 0.0120, },
	[73] = {0.0000, 0.0118, 0.0118, 0.0000, 0.0119, 0.0117, 0.0117, 0.0114, 0.0118, },
}

function StatLogic:GetSpellCritFromInt(int, class, level)
	-- argCheck for invalid input
	self:argCheck(int, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	self:argCheck(level, 4, "nil", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 73 then
		level = UnitLevel("player")
	end
	-- Calculate
	return int * SpellCritPerInt[level][class], "SPELL_CRIT"
end


--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit for any class.
-- Args
	spi
			number - spirit
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[mp5nc]
		number - mana regen per 5 seconds when out of combat
	[statid]
		string - "MANA_REG_NOT_CASTING"
-- Remarks
	Player level does not effect mana regen per spirit.
-- Examples
	StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	StatLogic:GetNormalManaRegenFromSpi(10)
	StatLogic:GetNormalManaRegenFromSpi(10, "MAGE")
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local NormalManaRegenPerSpi = {
	0, 0.1, 0.1, 0, 0.125, 0.1, 0.125, 0.1, 0.1125,
	--["WARRIOR"] = 0,
	--["PALADIN"] = 0.1,
	--["HUNTER"] = 0.1,
	--["ROGUE"] = 0,
	--["PRIEST"] = 0.125,
	--["SHAMAN"] = 0.1,
	--["MAGE"] = 0.125,
	--["WARLOCK"] = 0.1,
	--["DRUID"] = 0.1125,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return spi * NormalManaRegenPerSpi[class] * 5, "MANA_REG_NOT_CASTING"
end

-- New mana regen from spirit code for 2.4
local BaseManaRegenPerSpi
if wowBuildNo >= '7897' then
	--[[---------------------------------
	{	:GetNormalManaRegenFromSpi(spi, [int], [level])
	-------------------------------------
	-- Description
		Calculates the mana regen per 5 seconds while NOT casting from spirit.
	-- Args
		spi
				number - spirit
		[int] - (defaults: PlayerInt)
				number - intellect
		[level] - (defaults: PlayerLevel)
				number - player level used for calculation
	-- Returns
		[mp5nc]
			number - mana regen per 5 seconds when out of combat
		[statid]
			string - "MANA_REG_NOT_CASTING"
	-- Remarks
		Player class is no longer a parameter
		ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
	-- Examples
		StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
		StatLogic:GetNormalManaRegenFromSpi(10, 15)
		StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
	}
	-----------------------------------]]

	-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
	local BaseManaRegenPerSpi = {
		[1] = 0.034965,
		[2] = 0.034191,
		[3] = 0.033465,
		[4] = 0.032526,
		[5] = 0.031661,
		[6] = 0.031076,
		[7] = 0.030523,
		[8] = 0.029994,
		[9] = 0.029307,
		[10] = 0.028661,
		[11] = 0.027584,
		[12] = 0.026215,
		[13] = 0.025381,
		[14] = 0.0243,
		[15] = 0.023345,
		[16] = 0.022748,
		[17] = 0.021958,
		[18] = 0.021386,
		[19] = 0.02079,
		[20] = 0.020121,
		[21] = 0.019733,
		[22] = 0.019155,
		[23] = 0.018819,
		[24] = 0.018316,
		[25] = 0.017936,
		[26] = 0.017576,
		[27] = 0.017201,
		[28] = 0.016919,
		[29] = 0.016581,
		[30] = 0.016233,
		[31] = 0.015994,
		[32] = 0.015707,
		[33] = 0.015464,
		[34] = 0.015204,
		[35] = 0.014956,
		[36] = 0.014744,
		[37] = 0.014495,
		[38] = 0.014302,
		[39] = 0.014094,
		[40] = 0.013895,
		[41] = 0.013724,
		[42] = 0.013522,
		[43] = 0.013363,
		[44] = 0.013175,
		[45] = 0.012996,
		[46] = 0.012853,
		[47] = 0.012687,
		[48] = 0.012539,
		[49] = 0.012384,
		[50] = 0.012233,
		[51] = 0.012113,
		[52] = 0.011973,
		[53] = 0.011859,
		[54] = 0.011714,
		[55] = 0.011575,
		[56] = 0.011473,
		[57] = 0.011342,
		[58] = 0.011245,
		[59] = 0.01111,
		[60] = 0.010999,
		[61] = 0.0107,
		[62] = 0.010522,
		[63] = 0.01029,
		[64] = 0.010119,
		[65] = 0.009968,
		[66] = 0.009808,
		[67] = 0.009651,
		[68] = 0.009553,
		[69] = 0.009445,
		[70] = 0.009327,
	}

	function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
		-- argCheck for invalid input
		self:argCheck(spi, 2, "number")
		self:argCheck(int, 3, "nil", "number")
		self:argCheck(level, 4, "nil", "number")
		
		-- if level is invalid input, default to player level
		if type(level) ~= "number" or level < 1 or level > 70 then
			level = UnitLevel("player")
		end
		
		-- if int is invalid input, default to player int
		if type(int) ~= "number" then
			local _
			_, int = UnitStat("player",4)
		end
		-- Calculate
		return (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REG_NOT_CASTING"
	end
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
	0.5, 0.125, 0.125, 0.333333, 0.041667, 0.071429, 0.041667, 0.045455, 0.0625,
	--["WARRIOR"] = 0.5,
	--["PALADIN"] = 0.125,
	--["HUNTER"] = 0.125,
	--["ROGUE"] = 0.333333,
	--["PRIEST"] = 0.041667,
	--["SHAMAN"] = 0.071429,
	--["MAGE"] = 0.041667,
	--["WARLOCK"] = 0.045455,
	--["DRUID"] = 0.0625,
}

function StatLogic:GetHealthRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return spi * HealthRegenPerSpi[class] * 5, "HEALTH_REG_OUT_OF_COMBAT"
end


----------
-- Gems --
----------

function StatLogic:RemoveEnchant(link)
	-- check link
	if not strfind(link, "item:%d*:%d*:%d*:%d*:%d*:%d*:%-?%d*:%-?%d*") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, 0, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId)
end

function StatLogic:RemoveGem(link)
	-- check link
	if not strfind(link, "item:%d*:%d*:%d*:%d*:%d*:%d*:%-?%d*:%-?%d*") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, enchantId, 0, 0, 0, 0, suffixId, uniqueId)
end

function StatLogic:RemoveEnchantGem(link)
	-- check link
	if not strfind(link, "item:%d*:%d*:%d*:%d*:%d*:%d*:%-?%d*:%-?%d*") then
		return link
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, 0, 0, 0, 0, 0, suffixId, uniqueId)
end

function StatLogic:ModEnchantGem(link, enc, gem1, gem2, gem3, gem4)
	-- check link
	if not strfind(link, "item:%d+") then
		return
	end
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	return strjoin(":", linkType, itemId, enc or enchantId or 0, gem1 or jewelId1 or 0, gem2 or jewelId2 or 0, gem3 or jewelId3 or 0, gem4 or jewelId4 or 0, suffixId or 0, uniqueId or 0)
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
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	if not name then return item end
	
	-- Check gemID
	if not red or not tonumber(red) then red = 0 end
	if not yellow or not tonumber(yellow) then yellow = 0 end
	if not blue or not tonumber(blue) then blue = 0 end
	if not meta or not tonumber(meta) then meta = 0 end
	if red == 0 and yellow == 0 and blue == 0 and meta == 0 then return link end -- nothing to modify
	-- Fill EmptySocketLookup
	EmptySocketLookup[EMPTY_SOCKET_RED] = red
	EmptySocketLookup[EMPTY_SOCKET_YELLOW] = yellow
	EmptySocketLookup[EMPTY_SOCKET_BLUE] = blue
	EmptySocketLookup[EMPTY_SOCKET_META] = meta
	
	-- Build socket list
	local socketList = {}
	-- Get a link without any socketed gems
	local cleanLink = link:match("(item:%d+)")
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
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", link)
	if socketList[1] and (not jewelId1 or jewelId1 == "0" or jewelId1 == "") then jewelId1 = socketList[1] end
	if socketList[2] and (not jewelId2 or jewelId2 == "0" or jewelId2 == "") then jewelId2 = socketList[2] end
	if socketList[3] and (not jewelId3 or jewelId3 == "0" or jewelId3 == "") then jewelId3 = socketList[3] end
	if socketList[4] and (not jewelId4 or jewelId4 == "0" or jewelId4 == "") then jewelId4 = socketList[4] end
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
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
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


-- ================== --
-- Stat Summarization --
-- ================== --
--[[---------------------------------
{	:GetSum(item, [table])
-------------------------------------
-- Description
	Calculates the sum of all stats for a specified item.
-- Args
	item
			string - link or name of target item
	 or number - itemID of target item
	 or table - tooltip of target item
	[table]
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
function StatLogic:GetSum(item, table)
	-- Locale check
	--if not D:HasLocale(GetLocale()) then return end
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
	local name, link, _, _, reqLv, _, _, _, itemType = GetItemInfo(item)
	if not name then return end

	-- Clear table values
	clearTable(table)
	-- Initialize table
	table = table or new()
	setmetatable(table, statTableMetatable)

	-- Get data from cache if available
	if cache[link] then
		copyTable(table, cache[link])
		return table
	end

	-- Set metadata
	table.itemType = itemType
	table.link = link

	-- Don't scan Relics because they don't have general stats
	if itemType == "INVTYPE_RELIC" then
		cache[link] = copy(table)
		return table
	end

	-- Start parsing
	tip:ClearLines() -- this is required or SetX won't work the second time its called
	tip:SetHyperlink(link)
	print(link)
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

		local _, g, b = tip[i]:GetTextColor()
		-----------------------
		-- Whole Text Lookup --
		-----------------------
		-- Mainly used for enchants or stuff without numbers:
		-- "Mithril Spurs"
		local found
		local idTable = L.WholeTextLookup[text]
		if idTable == false then
			found = true
			print("|cffadadad".."  WholeText Exclude: "..text)
		elseif idTable then
			found = true
			for id, value in pairs(L.WholeTextLookup[text]) do
				-- sum stat
				table[id] = (table[id] or 0) + value
				print("|cffff5959".."  WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
			end
		end
		-- Fast Exclude --
		-- Exclude obvious strings that do not need to be checked, also exclude lines that are not white and green and normal (normal for Frozen Wrath bonus)
		if not (found or L.Exclude[text] or L.Exclude[strutf8sub(text, 1, L.ExcludeLen)] or strsub(text, 1, 1) == '"' or g < 0.8 or (b < 0.99 and b > 0.1)) then
			--print(text.." = ")
			-- Strip enchant time
			-- ITEM_ENCHANT_TIME_LEFT_DAYS = "%s (%d day)";
			-- ITEM_ENCHANT_TIME_LEFT_DAYS_P1 = "%s (%d days)";
			-- ITEM_ENCHANT_TIME_LEFT_HOURS = "%s (%d hour)";
			-- ITEM_ENCHANT_TIME_LEFT_HOURS_P1 = "%s (%d hrs)";
			-- ITEM_ENCHANT_TIME_LEFT_MIN = "%s (%d min)"; -- Enchantment name, followed by the time left in minutes
			-- ITEM_ENCHANT_TIME_LEFT_SEC = "%s (%d sec)"; -- Enchantment name, followed by the time left in seconds
			--[[ Seems temp enchants such as mana oil can't be seen from item links, so commented out
			if strfind(text, "%)") then
				print("test")
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
					local idTable = L.StatIDLookup[statText]
					if idTable == false then
						found = true
						print("|cffadadad".."  SinglePlus Exclude: "..text)
					elseif idTable then
						found = true
						local debugText = "|cffff5959".."  SinglePlus: ".."|cffffc259"..text
						for _, id in ipairs(idTable) do
							--print("  '"..value.."', '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
						end
						print(debugText)
					else
						-- pattern match but not found in L.StatIDLookup, keep looking
					end
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
					local idTable = L.StatIDLookup[strutf8lower(statText)]
					if idTable == false then
						found = true
						print("|cffadadad".."  SingleEquip Exclude: "..text)
					elseif idTable then
						found = true
						local debugText = "|cffff5959".."  SingleEquip: ".."|cffffc259"..text
						for _, id in ipairs(idTable) do
							--print("  '"..value.."', '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
						end
						print(debugText)
					else
						-- pattern match but not found in L.StatIDLookup, keep looking
					end
				end
			end
			-- PreScan for special cases, that will fit wrongly into DeepScan
			-- PreScan also has exclude patterns
			if not found then
				for pattern, id in pairs(L.PreScanPatterns) do
					local value
					found, _, value = strfind(text, pattern)
					if found then
						--found = true
						if id ~= false then
							local debugText = "|cffff5959".."  PreScan: ".."|cffffc259"..text
							--print("  '"..value.."' = '"..id.."'")
							-- sum stat
							table[id] = (table[id] or 0) + tonumber(value)
							debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
							print(debugText)
						else
							print("|cffadadad".."  PreScan Exclude: "..text)
						end
						break
					end
				end
				if found then

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
				-- Get a local copy
				local text = text
				-- Strip leading "Equip: ", "Socket Bonus: "
				text = gsub(text, ITEM_SPELL_TRIGGER_ONEQUIP, "") -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
				text = gsub(text, StripGlobalStrings(ITEM_SOCKET_BONUS), "") -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
				-- Trim spaces
				text = strtrim(text)
				-- Strip trailing "."
				if strutf8sub(text, -1) == L["."] then
					text = strutf8sub(text, 1, -2)
				end
				-- Replace separators with @
				for _, sep in ipairs(L.DeepScanSeparators) do
					if strfind(text, sep) then
						text = gsub(text, sep, "@")
					end
				end
				-- Split text using @
				text = {strsplit("@", text)}
				for i, text in ipairs(text) do
					-- Trim spaces
					text = strtrim(text)
					-- Strip trailing "."
					if strutf8sub(text, -1) == L["."] then
						text = strutf8sub(text, 1, -2)
					end
					print("|cff008080".."S"..i..": ".."'"..text.."'")
					-- Whole Text Lookup
					local foundWholeText = false
					local idTable = L.WholeTextLookup[text]
					if idTable == false then
						foundWholeText = true
						found = true
						print("|cffadadad".."  DeepScan WholeText Exclude: "..text)
					elseif idTable then
						foundWholeText = true
						found = true
						for id, value in pairs(L.WholeTextLookup[text]) do
							-- sum stat
							table[id] = (table[id] or 0) + value
							print("|cffff5959".."  DeepScan WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
						end
					else
						-- pattern match but not found in L.WholeTextLookup, keep looking
					end
					-- Scan DualStatPatterns
					if not foundWholeText then
						for pattern, dualStat in pairs(L.DualStatPatterns) do
							local lowered = strutf8lower(text)
							local _, dEnd, value1, value2 = strfind(lowered, pattern)
							if value1 and value2 then
								foundWholeText = true
								found = true
								local debugText = "|cffff5959".."  DeepScan DualStat: ".."|cffffc259"..text
								for _, id in ipairs(dualStat[1]) do
									--print("  '"..value.."', '"..id.."'")
									-- sum stat
									table[id] = (table[id] or 0) + tonumber(value1)
									debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
								end
								for _, id in ipairs(dualStat[2]) do
									--print("  '"..value.."', '"..id.."'")
									-- sum stat
									table[id] = (table[id] or 0) + tonumber(value2)
									debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
								end
								print(debugText)
								if dEnd ~= string.len(lowered) then
									foundWholeText = false
									text = string.sub(text, dEnd + 1)
								end
								break
							end
						end
					end
					local foundDeepScan1 = false
					if not foundWholeText then
						local lowered = strutf8lower(text)
						-- Pattern scan
						for _, pattern in ipairs(L.DeepScanPatterns) do -- try all patterns in order
							local _, _, statText1, value, statText2 = strfind(lowered, pattern)
							if value then
								local statText = statText1..statText2
								local idTable = L.StatIDLookup[statText]
								if idTable == false then
									foundDeepScan1 = true
									found = true
									print("|cffadadad".."  DeepScan Exclude: "..text)
									break -- break out of pattern loop and go to the next separated text
								elseif idTable then
									foundDeepScan1 = true
									found = true
									local debugText = "|cffff5959".."  DeepScan: ".."|cffffc259"..text
									for _, id in ipairs(idTable) do
										--print("  '"..value.."', '"..id.."'")
										-- sum stat
										table[id] = (table[id] or 0) + tonumber(value)
										debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
									end
									print(debugText)
									break -- break out of pattern loop and go to the next separated text
								else
									-- Not matching pattern
								end
							end
						end
					end
					-- If still not found, use the word separators to split the text
					if not foundWholeText and not foundDeepScan1 then
						-- Replace separators with @
						for _, sep in ipairs(L.DeepScanWordSeparators) do
							if strfind(text, sep) then
								text = gsub(text, sep, "@")
							end
						end
						-- Split text using @
						text = {strsplit("@", text)}
						for j, text in ipairs(text) do
							-- Trim spaces
							text = strtrim(text)
							-- Strip trailing "."
							if strutf8sub(text, -1) == L["."] then
								text = strutf8sub(text, 1, -2)
							end
							print("|cff008080".."S"..i.."-"..j..": ".."'"..text.."'")
							-- Whole Text Lookup
							local foundWholeText = false
							local idTable = L.WholeTextLookup[text]
							if idTable == false then
								foundWholeText = true
								found = true
								print("|cffadadad".."  DeepScan2 WholeText Exclude: "..text)
							elseif idTable then
								foundWholeText = true
								found = true
								for id, value in pairs(L.WholeTextLookup[text]) do
									-- sum stat
									table[id] = (table[id] or 0) + value
									print("|cffff5959".."  DeepScan2 WholeText: ".."|cffffc259"..text..", ".."|cffffff59"..tostring(id).."="..tostring(value))
								end
							else
								-- pattern match but not found in L.WholeTextLookup, keep looking
							end
							-- Scan DualStatPatterns
							if not foundWholeText then
								for pattern, dualStat in pairs(L.DualStatPatterns) do
									local lowered = strutf8lower(text)
									local _, _, value1, value2 = strfind(lowered, pattern)
									if value1 and value2 then
										foundWholeText = true
										found = true
										local debugText = "|cffff5959".."  DeepScan2 DualStat: ".."|cffffc259"..text
										for _, id in ipairs(dualStat[1]) do
											--print("  '"..value.."', '"..id.."'")
											-- sum stat
											table[id] = (table[id] or 0) + tonumber(value1)
											debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value1)
										end
										for _, id in ipairs(dualStat[2]) do
											--print("  '"..value.."', '"..id.."'")
											-- sum stat
											table[id] = (table[id] or 0) + tonumber(value2)
											debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value2)
										end
										print(debugText)
										break
									end
								end
							end
							local foundDeepScan2 = false
							if not foundWholeText then
								local lowered = strutf8lower(text)
								-- Pattern scan
								for _, pattern in ipairs(L.DeepScanPatterns) do
									local _, _, statText1, value, statText2 = strfind(lowered, pattern)
									if value then
										local statText = statText1..statText2
										local idTable = L.StatIDLookup[statText]
										if idTable == false then
											foundDeepScan2 = true
											found = true
											print("|cffadadad".."  DeepScan2 Exclude: "..text)
											break
										elseif idTable then
											foundDeepScan2 = true
											found = true
											local debugText = "|cffff5959".."  DeepScan2: ".."|cffffc259"..text
											for _, id in ipairs(idTable) do
												--print("  '"..value.."', '"..id.."'")
												-- sum stat
												table[id] = (table[id] or 0) + tonumber(value)
												debugText = debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
											end
											print(debugText)
											break
										else
											-- pattern match but not found in L.StatIDLookup, keep looking
											print("  DeepScan2 Lookup Fail: |cffffd4d4'"..statText.."'|r, pattern = |cff72ff59'"..pattern.."'")
										end
									end
								end -- for
							end
							if not foundWholeText and not foundDeepScan2 then
								print("  DeepScan2 Fail: |cffff0000'"..text.."'")
							end
						end
					end -- if not foundWholeText and not foundDeepScan1 then
				end
			end

			if not found then
				print("  No Match: |cffff0000'"..text.."'")
				if DEBUG and RatingBuster then
					RatingBuster.db.profile.test = text
				end
			end
		else
			--print("Excluded: "..text)
		end
	end
	cache[link] = copy(table)
	return table
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
			if eqItemType == "INVTYPE_2HWEAPON" then
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
	-- Locale check
	--if not D:HasLocale(GetLocale()) then return end

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
	itemSum = self:GetSum(link)
	if not itemSum then return end
	local itemType = itemSum.itemType

	if itemType == "INVTYPE_2HWEAPON" then
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
	local table = {}
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
	patternTable = {
		"(%a[%a ]+%a) ?%d* ?%a* by u?p? ?t?o? ?(%d+) ?a?n?d? ?", -- xxx xxx by 22 (scan first)
		"(%a[%a ]+) %+(%d+) ?a?n?d? ?", -- xxx xxx +22 (scan 2ed)
		"(%d+) ([%a ]+) ?a?n?d? ?", -- 22 xxx xxx (scan last)
	}
	textTable = {
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
