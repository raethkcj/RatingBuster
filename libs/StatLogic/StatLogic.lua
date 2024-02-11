local addonName, addon = ...

---@class StatLogic
local StatLogic = LibStub(addonName)

---------------
-- Libraries --
---------------
-- Pattern matching
---@type StatLogicLocale
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

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
if type(L) == "table" and type(L["StatIDLookup"]) == "table" then
	local temp = {}
	for k, v in pairs(L["StatIDLookup"]) do
		temp[k:utf8lower()] = v
	end
	for k, v in pairs(temp) do
		L["StatIDLookup"][k] = v
	end
end

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

-- Tooltip with syntactic sugar
---@class StatLogicTooltip : GameTooltip
local tip = CreateFrame("GameTooltip", "StatLogicTooltip", nil, "GameTooltipTemplate") --[[@as GameTooltip]]
tip:SetOwner(WorldFrame, "ANCHOR_NONE")

do
	local leftText = tip:GetName() .. "TextLeft"
	local rightText = tip:GetName() .. "TextRight"
	local mt = {
		__index = function(t, i)
			local fontString = _G[t.side .. i]
			t[i] = fontString
			return fontString
		end
	}
	tip.sides = {
		left = setmetatable({ side = leftText }, mt),
		right = setmetatable({ side = rightText }, mt)
	}

	for i = 1, 30 do
		tip.sides.left[i] = _G[leftText .. i]
		tip.sides.right[i] = _G[rightText .. i]
		if not tip.sides.left[i] then
			tip.sides.left[i] = tip:CreateFontString()
			tip.sides.right[i] = tip:CreateFontString()
			tip:AddFontStrings(tip.sides.left[i], tip.sides.right[i])
		end
	end
end

---------------------
-- Local Variables --
---------------------
-- Player info
addon.class = select(2, UnitClass("player"))
addon.playerRace = select(2, UnitRace("player"))

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

-- Localize globals
local _G = getfenv(0)
local pairs = pairs
local ipairs = ipairs
local type = type
local tonumber = L.tonumber
local GetInventoryItemLink = GetInventoryItemLink
local IsUsableSpell = IsUsableSpell
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetTalentInfo = GetTalentInfo
local tocversion = select(4, GetBuildInfo())

---------------
-- Lua Tools --
---------------
-- metatable for stat tables
local statTableMetatable = {
	__index = function()
		return 0
	end,
	__newindex = function(t, k, v)
		-- Reject setting anything to 0
		if v ~= 0 then
			rawset(t, k, v)
		end
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
				elseif k == "inventoryType" then
					local i = 1
					while rawget(op1, "diffInventoryType"..i) do
						i = i + 1
					end
					op1["diffInventoryType"..i] = op2.inventoryType
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

---@class StatTable
---@field link string
---@field numLines number
---@field inventoryType string
---@field [Stat] number

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
	text = text:gsub("%%%%", "%%") -- "%%" -> "%"
	text = text:gsub(" ?%%%d?%.?%d?%$?[cdsgf]", "") -- delete "%d", "%s", "%c", "%g", "%2$d", "%.2f" and a space in front of it if found
	-- So StripGlobalStrings(ITEM_SOCKET_BONUS) = "Socket Bonus:"
	return text
end

StatLogic.ExtraHasteClasses = {}

StatLogic.GenericStatMap = {
	[StatLogic.Stats.AllStats] = {
		StatLogic.Stats.Strength,
		StatLogic.Stats.Agility,
		StatLogic.Stats.Stamina,
		StatLogic.Stats.Intellect,
		StatLogic.Stats.Spirit,
	}
}

local function GetPlayerBuffRank(buff)
	local rank = GetSpellSubtext(buff)
	if rank then
		return tonumber(rank:match("(%d+)")) or 1
	end
end

local function GetTotalDefense(unit)
	local base, modifier = UnitDefense(unit);
	return base + modifier
end

local function GetTotalWeaponSkill(unit)
	if addon.class == "DRUID" and (
		StatLogic:GetAuraInfo(GetSpellInfo(768), true)
		or StatLogic:GetAuraInfo(GetSpellInfo(5487), true)
		or StatLogic:GetAuraInfo(GetSpellInfo(9634), true)
	) then
		return UnitLevel("player") * 5
	else
		local base, modifier = UnitAttackBothHands(unit);
		return base + modifier
	end
end

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
	-- ADD_MELEE_CRIT, _SPELL_CRIT, and _DODGE modifiers are used to reverse engineer conversion rates of AGI and INT,
	-- but only before max level. When adding them to StatModTables, there's no need to be exhaustive;
	-- only add mods that would reasonably be active while leveling, which are primarily talents.
	-- The crit conversions are also only necessary in Vanilla, while Dodge is necessary in every expansion.
	-- Spell crit modifiers are only required if they mod school 1 (physical)
	-- That means spells with EffectAura 57, and, separately, EffectAura 71 whose final digit of EffectMiscValue_0 is an odd number
	["ADD_MELEE_CRIT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_DODGE"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_SPELL_CRIT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_AP_MOD_FERAL_AP"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_BLOCK_CHANCE_MOD_MASTERY_EFFECT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_PET_INT_MOD_INT"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_PET_STA_MOD_STA"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MIN"] = {
		initialValue = 0,
		finalAdjust = 0,
	},
	["ADD_WEAPON_DAMAGE_AVERAGE_MOD_WEAPON_DAMAGE_MAX"] = {
		initialValue = 0,
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
	["MOD_FERAL_AP"] = {
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
	["MOD_NORMAL_HEALTH_REG"] = {
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
	["MOD_NORMAL_MANA_REG"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_PET_INT"] = {
		initialValue = 1,
		finalAdjust = 0,
	},
	["MOD_PET_STA"] = {
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
		mod = "AGI",
	},
	{
		add = "AP",
		mod = "STR",
	},
	{
		add = "NORMAL_HEALTH_REG",
		mod = "SPI",
	},
	{
		add = "NORMAL_MANA_REG",
		mod = "INT",
	},
	{
		add = "NORMAL_MANA_REG",
		mod = "SPI",
	},
	{
		add = "AP",
		mod = "ARMOR",
	},
	{
		add = "AP",
		mod = "INT",
	},
	{
		add = "AP",
		mod = "STA",
	},
	{
		add = "BLOCK_VALUE",
		mod = "STR",
	},
	{
		add = "BONUS_ARMOR",
		mod = "AGI",
	},
	{
		add = "BONUS_ARMOR",
		mod = "INT",
	},
	{
		add = "HEALING",
		mod = "AGI",
	},
	{
		add = "HEALING",
		mod = "AP",
	},
	{
		add = "HEALING",
		mod = "INT",
	},
	{
		add = "HEALING",
		mod = "MANA",
	},
	{
		add = "HEALING",
		mod = "SPI",
	},
	{
		add = "HEALING",
		mod = "STR",
	},
	{
		add = "HEALTH",
		mod = "STA",
	},
	{
		add = "HEALTH_REG",
		mod = "NORMAL_HEALTH_REG",
	},
	{
		add = "MANA",
		mod = "INT",
	},
	{
		add = "MANA_REG",
		mod = "INT",
	},
	{
		add = "MANA_REG",
		mod = "MANA",
	},
	{
		add = "MANA_REG",
		mod = "NORMAL_MANA_REG",
	},
	{
		add = "MASTERY_EFFECT",
		mod = "MASTERY",
	},
	{
		add = "PARRY_RATING",
		mod = "STR",
	},
	{
		add = "RANGED_AP",
		mod = "AGI",
	},
	{
		add = "RANGED_AP",
		mod = "INT",
	},
	{
		add = "SPELL_CRIT_RATING",
		mod = "SPI",
	},
	{
		add = "SPELL_HIT_RATING",
		mod = "SPI",
	},
	{
		add = "SPELL_DMG",
		mod = "AP",
	},
	{
		add = "SPELL_DMG",
		mod = "INT",
	},
	{
		add = "SPELL_DMG",
		mod = "MANA",
	},
	{
		add = "SPELL_DMG",
		mod = "PET_INT",
	},
	{
		add = "SPELL_DMG",
		mod = "PET_STA",
	},
	{
		add = "SPELL_DMG",
		mod = "SPI",
	},
	{
		add = "SPELL_DMG",
		mod = "STA",
	},
	{
		add = "SPELL_DMG",
		mod = "STR",
	},
	{
		add = "DODGE_REDUCTION",
		mod = "EXPERTISE",
	},
	{
		add = "PARRY_REDUCTION",
		mod = "EXPERTISE",
	},
	{
		add = "BLOCK_CHANCE",
		mod = "DEFENSE",
	},
	{
		add = "CRIT_AVOIDANCE",
		mod = "DEFENSE",
	},
	{
		add = "DODGE",
		mod = "DEFENSE",
	},
	{
		add = "MISS",
		mod = "DEFENSE",
	},
	{
		add = "PARRY",
		mod = "DEFENSE",
	},
	{
		add = "CRIT_AVOIDANCE",
		mod = "RESILIENCE",

	},
	{
		add = "CRIT_DAMAGE_REDUCTION",
		mod = "RESILIENCE",

	},
	{
		add = "PVP_DAMAGE_REDUCTION",
		mod = "RESILIENCE",

	},
}

for _, statMod in ipairs(addedInfoMods) do
	local name = ("ADD_%s_MOD_%s"):format(statMod.add, statMod.mod)
	statMod.initialValue = 0
	statMod.finalAdjust = 0
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
	-- Auras whose StatMod requires scanning the tooltip to get a dynamic value
	local tooltip_auras = {}

	local needs_update = true
	local f = CreateFrame("Frame")
	f:RegisterUnitEvent("UNIT_AURA", "player")
	f:SetScript("OnEvent", function()
		wipe(aura_cache)
		needs_update = true
	end)

	-- AuraInfo is a layer on top of aura_cache to hold Always Buffed settings.
	local always_buffed_aura_info = {}
	function StatLogic:SetupAuraInfo(always_buffed_db)
		self.always_buffed_db = always_buffed_db
		for _, modList in pairs(StatLogic.StatModTable) do
			for _, mods in pairs(modList) do
				for _, mod in ipairs(mods) do
					if mod.aura then -- if we got a buff
						local aura = {}
						if not mod.tab and mod.rank then -- not a talent, so the rank is the buff rank
							aura.rank = #(mod.rank)
						end
						local name = GetSpellInfo(mod.aura)
						if name then
							always_buffed_aura_info[name] = aura
							if mod.tooltip then
								tooltip_auras[name] = true
							end
						end
					end
				end
			end
		end
	end

	function StatLogic:GetAuraInfo(buff, ignoreAlwaysBuffed)
		if not ignoreAlwaysBuffed and self.always_buffed_db[buff] then
			return always_buffed_aura_info[buff]
		else
			if needs_update then
				local i = 1
				repeat
					local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
					if name then
						aura_cache[name] = { spellId = spellId }
						if tooltip_auras[name] then
							tip:SetUnitBuff("player", i)
							local numString = tip.sides.left[2]:GetText():match("%d+")
							local value = numString and tonumber(numString) or 0
							aura_cache[name].tooltip = value
						end
					end
					i = i+1
				until not name
				i = 1
				repeat
					local name, _, _, _, _, _, _, _, _, spellId = UnitDebuff("player", i)
					if name then
						aura_cache[name] = { spellId = spellId }
					end
					i = i+1
				until not name
				needs_update = false
			end
			return aura_cache[buff]
		end
	end
end

-----------------------------
-- StatModValidator Caches --
-----------------------------

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

local equipped_meta_gem
local armor_spec_active = false

do
	local update_meta_gem = function()
		local link = GetInventoryItemLink("player", 1)
		local str = link and select(4, (":"):split(link))
		equipped_meta_gem = str and tonumber(str) or 0
	end

	local class_armor_specs = {
		WARRIOR = Enum.ItemArmorSubclass.Plate,
		PALADIN = Enum.ItemArmorSubclass.Plate,
		DEATHKNIGHT = Enum.ItemArmorSubclass.Plate,
		HUNTER = Enum.ItemArmorSubclass.Mail,
		SHAMAN = Enum.ItemArmorSubclass.Mail,
		ROGUE = Enum.ItemArmorSubclass.Leather,
		DRUID = Enum.ItemArmorSubclass.Leather,
	}

	local armor_spec_slots = {
		[INVSLOT_HEAD] = true,
		[INVSLOT_SHOULDER] = true,
		[INVSLOT_CHEST] = true,
		[INVSLOT_WRIST] = true,
		[INVSLOT_HAND] = true,
		[INVSLOT_WAIST] = true,
		[INVSLOT_LEGS] = true,
		[INVSLOT_FEET] = true,
	}

	-- bit.bor of all lshifted armor_spec_slots: 0b1111110101
	local armor_bits = 1013

	local function update_armor_slot(slot)
		-- Set slot's bit to 0 if correct, else 1
		local item = GetInventoryItemID("player", slot)
		if item and select(7, GetItemInfoInstant(item)) == class_armor_specs[addon.class] then
			armor_bits = bit.band(armor_bits, bit.bnot(bit.lshift(1, slot - 1)))
		else
			armor_bits = bit.bor(armor_bits, bit.lshift(1, slot - 1))
		end
		armor_spec_active = armor_bits == 0
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event, slot)
		-- Item Sets
		wipe(equipped_sets)

		-- Meta Gem
		if not slot or slot == INVSLOT_HEAD then
			update_meta_gem()
		end

		-- Armor Specialization
		if tocversion >= 40000 and class_armor_specs[addon.class] then
			if event == "PLAYER_ENTERING_WORLD" or not slot then
				for inv_slot in pairs(armor_spec_slots) do
					update_armor_slot(inv_slot)
				end
			elseif armor_spec_slots[slot] then
				update_armor_slot(slot)
			end
		end

		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent(event)
		end
	end)
end

-- Ignore Stat Mods that are only used for reverse-engineering agi/int conversion rates
StatLogic.StatModIgnoresAlwaysBuffed = {
	["ADD_DODGE"] = true,
	["ADD_MELEE_CRIT"] = true,
	["ADD_SPELL_CRIT"] = true,
}

---@class StatModValidator
---@field validate? function
---@field events table<WowEvent, UnitToken | true>

---@type { [string]: StatModValidator }
addon.StatModValidators = {
	armorspec = {
		validate = function(case)
			if armor_spec_active then
				-- TODO: May be replaced by GetSpecialization, check on Cata Beta launch
				return case.armorspec[GetPrimaryTalentTree() or 0]
			end
		end,
		events = {
			["UNIT_INVENTORY_CHANGED"] = "player",
			["PLAYER_TALENT_UPDATE"] = true,
		},
	},
	aura = {
		validate = function(case, stat)
			return StatLogic:GetAuraInfo(GetSpellInfo(case.aura), StatLogic.StatModIgnoresAlwaysBuffed[stat])
		end,
		events = {
			["UNIT_AURA"] = "player",
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
	glyph = {
		validate = function(case)
			return IsPlayerSpell(case.glyph)
		end,
		events = {
			["GLYPH_ADDED"] = true,
			["GLYPH_REMOVED"] = true,
		}
	},
	known = {
		validate = function(case)
			return FindSpellBookSlotBySpellID(case.known)
		end,
		events = {
			["SPELLS_CHANGED"] = true,
		},
	},
	level = {
		events = {
			["PLAYER_LEVEL_UP"] = true,
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
	pet = {
		validate = function()
			return UnitExists("pet")
		end,
		events = {
			["UNIT_PET"] = "player",
		},
	},
	regen = {
		events = {
			["UNIT_STATS"] = "player",
			["PLAYER_LEVEL_UP"] = true,
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
	tab = {
		events = {
			["CHARACTER_POINTS_CHANGED"] = true,
			["PLAYER_TALENT_UPDATE"] = true,
		},
	},
	weapon = {
		validate = function(case)
			local weapon = GetInventoryItemID("player", 16)
			if weapon then
				local subclassID = select(7, GetItemInfoInstant(weapon))
				return subclassID and case.weapon[subclassID]
			end
		end,
		events = {
			["UNIT_INVENTORY_CHANGED"] = "player",
		}
	},
}

-- Cache the results of GetStatMod, and build a table that
-- maps events defined on Validators to the StatMods that depend on them.
local StatModCache = {}
addon.StatModCacheInvalidators = {}

function StatLogic:InvalidateEvent(event, unit)
	local key = event
	if type(unit) == "string" then
		key = event .. unit
	end
	local stats = addon.StatModCacheInvalidators[key]
	if stats then
		for _, stat in pairs(stats) do
			StatModCache[stat] = nil
		end
	end
end

do
	local f = CreateFrame("Frame")
	for _, validator in pairs(addon.StatModValidators) do
		for event, unit in pairs(validator.events) do
			if C_EventUtils.IsEventValid(event) then
				if type(unit) == "string" then
					f:RegisterUnitEvent(event, unit)
				else
					f:RegisterEvent(event)
				end
			end
		end
	end

	f:SetScript("OnEvent", function(_, event, unit)
		StatLogic:InvalidateEvent(event, unit)
	end)
end

local function ValidateStatMod(stat, case)
	for validatorType in pairs(case) do
		local validator = addon.StatModValidators[validatorType]
		if validator then
			if validator.events then
				for event, unit in pairs(validator.events) do
					local key = event
					if type(unit) == "string" then
						key = event .. unit
					end
					addon.StatModCacheInvalidators[key] = addon.StatModCacheInvalidators[key] or {}
					table.insert(addon.StatModCacheInvalidators[key], stat)
				end
			end

			if validator.validate and not validator.validate(case, stat) then
				return false
			end
		end
	end
	return true
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

do
	addon.BuffGroup = {
		AllStats = 1,
		AttackPower = 2,
		SpellPower = 3,
		Armor = 4,
		Feral = 5,
	}
	local BuffGroupCache = {}

	local function ApplyMod(mod, value, initialValue)
		if initialValue == 0 then
			mod = mod + value
		else
			mod = mod * (value + 1)
		end
		return mod
	end

	local function RemoveMod(mod, value, initialValue)
		if initialValue == 0 then
			mod = mod - value
		else
			mod = mod / (value + 1)
		end
		return mod
	end

	local GetStatModValue = function(stat, mod, case, initialValue)
		local valid = ValidateStatMod(stat, case)
		if not valid then
			return mod
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
		elseif case.aura and case.rank then
			local aura = StatLogic:GetAuraInfo(GetSpellInfo(case.aura))
			local rank = aura.rank or GetPlayerBuffRank(aura.spellId)
			value = case.rank[rank]
		elseif case.regen then
			value = case.regen()
		elseif case.value then
			value = case.value
		elseif case.level then
			value = case.level[UnitLevel("player")]
		elseif case.tooltip then
			local aura = StatLogic:GetAuraInfo(GetSpellInfo(case.aura))
			value = aura.tooltip
		end

		if value then
			if case.group then
				local oldValue = BuffGroupCache[case.group]
				if oldValue and value > oldValue then
					mod = RemoveMod(mod, oldValue, initialValue)
				end
				if not oldValue or value > oldValue then
					mod = ApplyMod(mod, value, initialValue)
					BuffGroupCache[case.group] = value
				end
			else
				mod = ApplyMod(mod, value, initialValue)
			end
		end

		return mod
	end

	function StatLogic:GetStatMod(stat)
		local mod = StatModCache[stat]

		if not mod then
			wipe(BuffGroupCache)
			local statModInfo = StatLogic.StatModInfo[stat]
			mod = statModInfo.initialValue
			for _, categoryTable in pairs(StatLogic.StatModTable) do
				if categoryTable[stat] then
					for _, case in ipairs(categoryTable[stat]) do
						mod = GetStatModValue(stat, mod, case, statModInfo.initialValue)
					end
				end
			end

			mod = mod + statModInfo.finalAdjust
			StatModCache[stat] = mod
		end

		return mod
	end
end

--=================--
-- Stat Conversion --
--=================--
do
	local trackedTotalStats = {
		[StatLogic.Stats.Dodge] = true,
		[StatLogic.Stats.MeleeCrit] = true,
	}

	local totalEquippedStatCache = setmetatable({}, {
		__index = function(t, stat)
			if tocversion >= 20000 or not trackedTotalStats[stat] then return 0 end

			for trackedStat in pairs(trackedTotalStats) do
				t[trackedStat] = 0
			end

			for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
				local link = GetInventoryItemLink("player", i)
				local sum = StatLogic:GetSum(link)
				if sum then
					-- Sum all tracked stats, not just the current one we're querying
					for trackedStat in pairs(trackedTotalStats) do
						local amount = sum[trackedStat] or 0
						t[trackedStat] = rawget(t, trackedStat) + amount
					end
				end
			end

			return rawget(t, stat)
		end
	})

	if tocversion < 20000 then
		local f = CreateFrame("Frame")
		f:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
		f:SetScript("OnEvent", function()
			wipe(totalEquippedStatCache)
		end)
	end

	function StatLogic:GetTotalEquippedStat(stat)
		return totalEquippedStatCache[stat]
	end
end

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

if not DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE then DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE = 0.04 end
function StatLogic:GetEffectFromDefense(defense, attackerLevel)
	self:argCheck(defense, 2, "nil", "number")
	self:argCheck(attackerLevel, 3, "nil", "number")
	defense = defense or GetTotalDefense("player")
	if not attackerLevel then
		attackerLevel = UnitLevel("player")
	end
	return (defense - attackerLevel * 5) * DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE
end

function StatLogic:GetCritChanceFromWeaponSkill(skill, targetLevel)
	self:argCheck(skill, 2, "nil", "number")
	self:argCheck(targetLevel, 3, "nil", "number")
	skill = skill or GetTotalWeaponSkill("player")
	if not targetLevel then
		targetLevel = UnitLevel("player")
	end
	return (skill - targetLevel * 5) * 0.04
end

function StatLogic:RatingExists(id)
	return not not StatLogic.RatingBase[id]
end

addon.zero = setmetatable({}, {
	__index = function()
		return 0
	end
})
addon.zero.__index = addon.zero

--2.4.3  Parry Rating, Defense Rating, and Block Rating: Low-level players
--   will now convert these ratings into their corresponding defensive
--   stats at the same rate as level 34 players.
--   Dodge and Resilience were not mentioned, but were nerfed as well
local Level34Ratings = {
	[StatLogic.Stats.DefenseRating] = true,
	[StatLogic.Stats.DodgeRating] = true,
	[StatLogic.Stats.ParryRating] = true,
	[StatLogic.Stats.BlockRating] = true,
	[StatLogic.Stats.ResilienceRating] = true,
}

---@param rating number
---@param stat Stat A Stat representing a Rating in RatingBase
---@param level? number
---@return number effect
function StatLogic:GetEffectFromRating(rating, stat, level)
	-- check for invalid input
	if type(rating) ~= "number" or not StatLogic.RatingBase[stat] then return 0 end
	-- defaults to player level if not given
	level = level or UnitLevel("player")
	if level < 34 and Level34Ratings[stat] then
		level = 34
	end
	if level >= 80 then
		local H = 15.2545
		if stat == StatLogic.Stats.ResilienceRating then
			H = 9.18109
		end
		return rating/StatLogic.RatingBase[stat]/((5371/1638)*H^((level-80)/10))
	elseif level >= 70 then
		return rating/StatLogic.RatingBase[stat]/((82/52)*(131/63)^((level-70)/10))
	elseif level >= 60 then
		return rating/StatLogic.RatingBase[stat]*((-3/82)*level+(131/41))
	elseif level >= 10 then
		return rating/StatLogic.RatingBase[stat]/((1/52)*level-(8/52))
	else
		return rating/StatLogic.RatingBase[stat]/((1/52)*10-(8/52))
	end
end

if not CR_DODGE then CR_DODGE = 3 end;

-- Calculates the dodge percentage per agility for your current class and level.
-- Only works for your currect class and current level, does not support class and level args.
---@return number dodge Dodge percentage per agility
function StatLogic:GetDodgePerAgi()
	local level = UnitLevel("player")
	local class = addon.class
	if addon.DodgePerAgi[class][level] then
		return addon.DodgePerAgi[class][level]
	end
	local _, agility = UnitStat("player", 2)
	-- dodgeFromAgi is %
	local dodgeFromAgi = GetDodgeChance()
		- self:GetStatMod("ADD_DODGE")
		- self:GetEffectFromRating(GetCombatRating(CR_DODGE), StatLogic.Stats.DodgeRating, UnitLevel("player"))
		- self:GetEffectFromDefense(GetTotalDefense("player"), UnitLevel("player"))
		- self:GetTotalEquippedStat(StatLogic.Stats.Dodge)
	return dodgeFromAgi / agility
end

function StatLogic:GetCritPerAgi()
	local level = UnitLevel("player")
	local class = addon.class

	if addon.CritPerAgi[class][level] then
		return addon.CritPerAgi[class][level]
	else
		local _, agility = UnitStat("player", 2)
		local critFromAgi = GetCritChance()
			- self:GetStatMod("ADD_MELEE_CRIT")
			- self:GetCritChanceFromWeaponSkill()
			- self:GetTotalEquippedStat(StatLogic.Stats.MeleeCrit)
		return critFromAgi / agility
	end
end

function StatLogic:GetSpellCritPerInt()
	local level = UnitLevel("player")
	local class = addon.class

	if addon.SpellCritPerInt[class][level] then
		return addon.SpellCritPerInt[class][level]
	else
		local _, intellect = UnitStat("player", 4)
		local critFromInt = GetSpellCritChance(1)
			- self:GetStatMod("ADD_SPELL_CRIT")
		return critFromInt / intellect
	end
end

----------------------------------
-- Stat Summary Ignore Settings --
----------------------------------

function StatLogic:RemoveEnchant(link)
	return link:gsub("(item:%d+):%d+","%1:0")
end

function StatLogic:RemoveGem(link)
	return link:gsub("(item:%d+:%d*):%d*:%d*:%d*:%d*","%1:0:0:0:0")
end

do
	local extraSocketInvTypes = {
		["INVTYPE_WAIST"] = true,
		["INVTYPE_WRIST"] = true,
		["INVTYPE_HAND"] = true,
	}

	-- Reusable stat table that defaults to 0 for socket counts
	local statTable = setmetatable({}, {
		__index = function()
			return 0
		end
	})

	function StatLogic:RemoveExtraSockets(link)
		-- Only check belt, bracer and gloves
		local itemEquipLoc = select(4, GetItemInfoInstant(link))
		if not extraSocketInvTypes[itemEquipLoc] then return link end

		-- Count item's actual sockets
		wipe(statTable)
		GetItemStats(link, statTable)
		local numSockets = statTable["EMPTY_SOCKET_RED"] + statTable["EMPTY_SOCKET_YELLOW"] + statTable["EMPTY_SOCKET_BLUE"]

		-- Remove any gemID beyond numSockets
		local i = 0
		return (link:gsub(":[^:]*", function(match)
			i = i + 1
			if i > 2 + numSockets then
				return ":"
			else
				return match
			end
		end, 6))
	end

	local EmptySocketLookup = {
		[EMPTY_SOCKET_RED] = 0, -- EMPTY_SOCKET_RED = "Red Socket";
		[EMPTY_SOCKET_YELLOW] = 0, -- EMPTY_SOCKET_YELLOW = "Yellow Socket";
		[EMPTY_SOCKET_BLUE] = 0, -- EMPTY_SOCKET_BLUE = "Blue Socket";
		[EMPTY_SOCKET_META] = 0, -- EMPTY_SOCKET_META = "Meta Socket";
	}
	-- Returns a modified link with all empty sockets replaced with the specified gems,
	-- sockets already gemmed will remain.
	---@param link string itemLink
	---@param red? string|number gemID to replace a red socket
	---@param yellow? string|number gemID to replace a yellow socket
	---@param blue? string|number gemID to replace a blue socket
	---@param meta? string|number gemID to replace a meta socket
	---@return string link Modified item link
	function StatLogic:BuildGemmedTooltip(link, red, yellow, blue, meta)
		-- Check item
		if (type(link) ~= "string") then
			return link
		end

		wipe(statTable)
		GetItemStats(link, statTable)
		local numSockets = statTable["EMPTY_SOCKET_META"] + statTable["EMPTY_SOCKET_RED"] + statTable["EMPTY_SOCKET_YELLOW"] + statTable["EMPTY_SOCKET_BLUE"]
		if numSockets == 0 then return link end

		-- Check gemID
		red = red and tonumber(red) or 0
		yellow = yellow and tonumber(yellow) or 0
		blue = blue and tonumber(blue) or 0
		meta = meta and tonumber(meta) or 0
		if red == 0 and yellow == 0 and blue == 0 and meta == 0 then return link end -- nothing to modify

		-- Fill EmptySocketLookup
		EmptySocketLookup[EMPTY_SOCKET_RED] = red
		EmptySocketLookup[EMPTY_SOCKET_YELLOW] = yellow
		EmptySocketLookup[EMPTY_SOCKET_BLUE] = blue
		EmptySocketLookup[EMPTY_SOCKET_META] = meta

		-- Build socket list
		local arguments = {"%1"}
		-- Start parsing
		tip:ClearLines()
		tip:SetHyperlink(link)
		for i = 2, tip:NumLines() do
			local text = tip.sides.left[i]:GetText()
			local socketFound = EmptySocketLookup[text]
			arguments[#arguments+1] = socketFound
		end
		-- If there are no sockets
		if #arguments == 1 then
			return link
		else
			for i = #arguments + 1, 5 do
				arguments[i] = ""
			end
			local repl = table.concat(arguments, ":")
			-- This will not replace anything if *any* of the four gem sockets is filled
			return (link:gsub("(item:%d+:%d*):0?:0?:0?:0?", repl))
		end
	end
end

---@param item string|number itemLink or itemID of a gem
---@return number? gemID
---@return string? gemText
function StatLogic:GetGemID(item)
	-- Check item
	if (type(item) ~= "string") and (type(item) ~= "number") then
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
			tip:SetHyperlink("item:"..itemID);
		end
		return
	end
	itemID = link:match("item:(%d+)")

	if not GetItemInfo(6948) then -- Hearthstone
		-- Query server for Hearthstone
		tip:SetHyperlink("item:"..itemID);
		return
	end

	-- Scan tooltip for gem text
	local gemScanLink = "item:6948:0:%d:0:0:0:0:0"
	local itemLink = gemScanLink:format(itemID)
	local _, gem1Link = GetItemGem(itemLink, 1)
	if gem1Link then
		tip:ClearLines() -- this is required or SetX won't work the second time its called
		tip:SetHyperlink(itemLink);
		return itemID, StatLogicTooltipTextLeft4:GetText()
	end
end

local function ConvertGenericStats(table)
	for generic, ratings in pairs(StatLogic.GenericStatMap) do
		if table[generic] then
			for _, rating in ipairs(ratings) do
				table[rating] = table[rating] + table[generic]
			end
			table[generic] = nil
		end
	end
end

-- ================== --
-- Stat Summarization --
-- ================== --
do
	local statTable, currentColor

	local function AddStat(id, value, debugText)
		if id == StatLogic.Stats.Armor then
			local base, bonus = StatLogic:GetArmorDistribution(statTable.link, value, currentColor)
			value = base
			local bonusID = StatLogic.Stats.BonusArmor
			statTable[bonusID] = (statTable[bonusID] or 0) + bonus
			debugText = debugText..", ".."|cffffff59"..tostring(bonusID).."="..tostring(bonus)
		end
		statTable[id] = (statTable[id] or 0) + tonumber(value)
		return debugText..", ".."|cffffff59"..tostring(id).."="..tostring(value)
	end

	local function ParseMatch(idTable, text, value, scanner)
		local found = false
		if idTable == false then
			found = true
			if text ~= "" then
				log("|cffadadad  ".. scanner .. " Exclude: "..text)
			end
		elseif idTable then
			found = true
			local debugText = "|cffff5959  ".. scanner .. ": |cffffc259"..text
			if value then
				if #idTable > 0 then
					for _, id in ipairs(idTable) do
						debugText = AddStat(id, value, debugText)
					end
				else
					debugText = AddStat(idTable, value, debugText)
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

	-- Calculates the sum of all stats for a specified item.
	---@param item? string itemLink of target item
	---@param oldStatTable? StatTable The sum of stat values are writen to this table if provided
	---@return StatTable? sum
	function StatLogic:GetSum(item, oldStatTable)
		-- Check item
		if type(item) ~= "string" then
			return
		end
		-- Check if item is in local cache
		local name, link, _, _, _, _, _, _, inventoryType, _, _, itemClass, itemSubclass = GetItemInfo(item)
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
		statTable.inventoryType = inventoryType
		statTable.link = link
		statTable.numLines = numLines

		if itemClass == Enum.ItemClass.Weapon then
			statTable[StatLogic.Stats.WeaponSubclass] = itemSubclass
		end

		-- Start parsing
		log(link)
		for i = 2, tip:NumLines() do
			for _, side in pairs(tip.sides) do
				local fontString = side[i]
				local text = fontString:GetText()
				local found = not text or text == ""

				if not found then
					-- Trim spaces and limit to one line
					text = text:trim()
					text = text:gsub("\n.*", "")
					-- Strip color codes
					text = text:gsub("^|c%x%x%x%x%x%x%x%x", "")
					text = text:gsub("|r$", "")

					currentColor = CreateColor(fontString:GetTextColor())

					-----------------------
					-- Whole Text Lookup --
					-----------------------
					-- Mainly used for enchants or stuff without numbers:
					local idTable = L.WholeTextLookup[text]
					found = ParseMatch(idTable, text, false, "WholeText")
				end

				-------------------------
				-- Substitution Lookup --
				-------------------------
				local statText
				if not found then
					-- Strip leading "Equip: ", "Socket Bonus: ", trailing "."
					local sanitizedText = text:gsub(ITEM_SPELL_TRIGGER_ONEQUIP, "")
					sanitizedText = sanitizedText:gsub("%.$", "")
					sanitizedText = sanitizedText:gsub(StripGlobalStrings(ITEM_SOCKET_BONUS), "")
					sanitizedText = sanitizedText:utf8lower()
					local values = {}
					local count
					statText, count = sanitizedText:gsub("[+-]?[%d%.]+%f[%D]", function(match)
						local value = tonumber(match)
						if value then
							values[#values + 1] = value
							return "%s"
						end
					end)
					if count > 0 then
						statText = statText:trim()
						local stats = L.StatIDLookup[statText]
						if stats then
							for j, value in ipairs(values) do
								found = ParseMatch(stats[j], text, value, "Substitution")
							end
						end
					else
						found = ParseMatch(false, text, false, "Substitution")
					end
				end

				--------------------
				-- Prefix Exclude --
				--------------------
				-- Exclude strings with prefixes that do not need to be checked,
				if not found then
					if L.PrefixExclude[text:utf8sub(1, L.PrefixExcludeLength)] or text:sub(1, 1) == '"' then
						found = ParseMatch(false, text, nil, "Prefix")
					end
				end

				-------------------
				-- Color Exclude --
				-------------------
				-- Exclude lines that are not white, green, or "normal" (normal for Frozen Wrath etc.)
				if not found then
					local _, g, b = currentColor:GetRGB()
					if g < 0.8 or (b < 0.99 and b > 0.1) then
						found = ParseMatch(false, text, nil, "Color")
					end
				end

				-- For debugging Substitution with /sldebug, for now we want to be quiet about Prefix/Color Excludes
				if not found then
					log("|cffff5959  Substitution Missed: |r|cnLIGHTBLUE_FONT_COLOR:" .. statText)
				end

				----------------------------
				-- Single Plus Stat Check --
				----------------------------
				-- depending on locale, L.SinglePlusStatCheck may be
				-- +19 Stamina = "^%+(%d+) ([%a ]+%a)$"
				-- Stamina +19 = "^([%a ]+%a) %+(%d+)$"
				-- +19 耐力 = "^%+(%d+) (.-)$"
				if not found then
					local _, _, value, statText = text:utf8lower():find(L.SinglePlusStatCheck)
					if value then
						if tonumber(statText) then
							value, statText = statText, value
						end
						local idTable = L.StatIDLookup[statText]
						found = ParseMatch(idTable, text, value, "SinglePlus")
					end
				end

				-----------------------------
				-- Single Equip Stat Check --
				-----------------------------
				-- depending on locale, L.SingleEquipStatCheck may be
				-- "^Equip: (.-) by u?p? ?t?o? ?(%d+) ?(.-)%.$"
				if not found then
					local _, _, statText1, value, statText2 = text:find(L.SingleEquipStatCheck)
					if value then
						local statText = statText1..statText2
						local idTable = L.StatIDLookup[statText:utf8lower()]
						found = ParseMatch(idTable, text, value, "SingleEquip")
					end
				end

				-- PreScan for special cases, that will fit wrongly into DeepScan
				-- PreScan also has exclude patterns
				if not found then
					for pattern, id in pairs(L.PreScanPatterns) do
						local value
						found, _, value = text:find(pattern)
						if found then
							ParseMatch(id and not id[1] and {id} or id, text, value, "PreScan")
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
					local sanitizedText = text:gsub(ITEM_SPELL_TRIGGER_ONEQUIP, "") -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:";
					sanitizedText = sanitizedText:gsub(StripGlobalStrings(ITEM_SOCKET_BONUS), "") -- ITEM_SOCKET_BONUS = "Socket Bonus: %s"; -- Tooltip tag for socketed item matched socket bonuses
					-- Trim spaces
					sanitizedText = sanitizedText:trim()
					-- Strip trailing "."
					if sanitizedText:utf8sub(-1) == L["."] then
						sanitizedText = sanitizedText:utf8sub(1, -2)
					end
					-- Split the string into phrases between puncuation
					-- Replace separators with @
					for _, sep in ipairs(L.DeepScanSeparators) do
						local repl = "@"
						if type(sep) == "table" then
							repl = sep.repl
							sep = sep.pattern
						end
						if sanitizedText:find(sep) then
							log(repl)
							sanitizedText = sanitizedText:gsub(sep, repl)
						end
					end
					-- Split text using @
					local phrases = strsplittable("@", sanitizedText)
					for j, phrase in ipairs(phrases) do
						-- Trim spaces
						phrase = phrase:trim()
						-- Strip trailing "."
						if phrase:utf8sub(-1) == L["."] then
							phrase = phrase:utf8sub(1, -2)
						end
						log("|cff008080".."S"..j..": ".."'"..phrase.."'")
						-- Whole Text Lookup
						local foundWholeText = false
						local idTable = L.WholeTextLookup[phrase]
						found = ParseMatch(idTable, phrase, false, "DeepScan WholeText")
						foundWholeText = found

						-- Scan DualStatPatterns
						if not foundWholeText then
							for pattern, dualStat in pairs(L.DualStatPatterns) do
								local lowered = phrase:utf8lower()
								local _, dEnd, value1, value2 = lowered:find(pattern)
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
									if dEnd ~= #lowered then
										foundWholeText = false
										phrase = phrase:sub(dEnd + 1)
									end
									break
								end
							end
						end
						local foundDeepScan1 = false
						if not foundWholeText then
							local lowered = phrase:utf8lower()
							-- Pattern scan
							for _, pattern in ipairs(L.DeepScanPatterns) do -- try all patterns in order
								local _, _, statText1, value, statText2 = lowered:find(pattern)
								if value then
									local statText = statText1..statText2
									local idTable = L.StatIDLookup[statText]
									found = ParseMatch(idTable, phrase, value, "DeepScan")
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
								if phrase:find(sep) then
									phrase = phrase:gsub(sep, "@")
								end
							end
							-- Split phrase using @
							local words = strsplittable("@", phrase)
							for k, word in ipairs(words) do
								-- Trim spaces
								word = word:trim()
								-- Strip trailing "."
								if word:utf8sub(-1) == L["."] then
									word = word:utf8sub(1, -2)
								end
								log("|cff008080".."S"..k.."-"..k..": ".."'"..word.."'")
								-- Whole Text Lookup
								foundWholeText = false
								local idTable = L.WholeTextLookup[word]
								found = ParseMatch(idTable, word, false, "DeepScan2 WholeText")
								foundWholeText = found

								-- Scan DualStatPatterns
								if not foundWholeText then
									for pattern, dualStat in pairs(L.DualStatPatterns) do
										local lowered = word:utf8lower()
										local _, _, value1, value2 = lowered:find(pattern)
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
									local lowered = word:utf8lower()
									-- Pattern scan
									for _, pattern in ipairs(L.DeepScanPatterns) do
										local _, _, statText1, value, statText2 = lowered:find(pattern)
										if value then
											local statText = statText1..statText2
											local idTable = L.StatIDLookup[statText]
											found = ParseMatch(idTable, word, value, "DeepScan2")
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
				end
			end
		end

		-- Tooltip scanning done, do post processing
		ConvertGenericStats(statTable)

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
		if addon.bonusArmorItemEquipLoc and addon.bonusArmorItemEquipLoc[itemEquipLoc] then
			armor = 0
			bonus_armor = value
		elseif StatLogic.AreColorsEqual(color, BONUS_ARMOR_COLOR) and addon.baseArmorTable then
			local qualityTable = addon.baseArmorTable[itemQuality]
			local itemEquipLocTable = qualityTable and qualityTable[_G[itemEquipLoc]]
			local armorSubclassTable = itemEquipLocTable and itemEquipLocTable[armorSubclass]

			armor = armorSubclassTable and armorSubclassTable[itemLevel] or armor
			bonus_armor = value - armor
		end
	end

	return armor, bonus_armor
end

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
	return addon.class == "WARRIOR" and IsPlayerSpell(46917)
end


-- Returns a unique identification string of the diff calculation,
-- the identification string is made up of links concatenated together, can be used for cache indexing
---@param item string|GameTooltip itemLink or tooltip of target item
---@param ignoreEnchant? boolean
---@param ignoreGems? boolean
---@param ignoreExtraSockets? boolean
---@param red? string|number gemID to replace a red socket
---@param yellow? string|number gemID to replace a yellow socket
---@param blue? string|number gemID to replace a blue socket
---@param meta? string|number gemID to replace a meta socket
---@return string? id A unique identification string of the diff calculation
---@return string? link Link of main item
---@return string? linkDiff1 Link of compare item 1
---@return string? linkDiff2 Link of compare item 2
function StatLogic:GetDiffID(item, ignoreEnchant, ignoreGems, ignoreExtraSockets, red, yellow, blue, meta)
	local name, inventoryType, link, linkDiff1, linkDiff2, _
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
	name, link, _, _, _, _, _, _, inventoryType = GetItemInfo(item)
	if not name then return end
	-- Get equip location slot id for use in GetInventoryItemLink
	local slotID = getSlotID[inventoryType]
	-- Don't do bags
	if not slotID then return end

	-- 1h weapon, check if player can dual wield, check for 2h equipped
	if inventoryType == "INVTYPE_WEAPON" then
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
	elseif inventoryType == "INVTYPE_2HWEAPON" then
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

	-- Ignore Extra Sockets (unneccessary work if we're removing all gems afterwards)
	if ignoreExtraSockets and not ignoreGems then
		link = self:RemoveExtraSockets(link)
		linkDiff1 = self:RemoveExtraSockets(linkDiff1)
		if linkDiff2 then
			linkDiff2 = self:RemoveExtraSockets(linkDiff2)
		end
	end

	-- Ignore Gems
	if ignoreGems then
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

-- Calculates the stat diffrence from the specified item and your currently equipped items.
---@param item string|GameTooltip itemLink or tooltip of target item
---@param diff1? StatTable Stat difference of item and equipped item 1 are writen to this table if provided
---@param diff2? StatTable Stat difference of item and equipped item 2 are writen to this table if provided
---@param ignoreEnchant? boolean
---@param ignoreGems? boolean
---@param ignoreExtraSockets? boolean
---@param red? string|number gemID to replace a red socket
---@param yellow? string|number gemID to replace a yellow socket
---@param blue? string|number gemID to replace a blue socket
---@param meta? string|number gemID to replace a meta socket
---@return StatTable? diff1
---@return StatTable? diff2
function StatLogic:GetDiff(item, diff1, diff2, ignoreEnchant, ignoreGems, ignoreExtraSockets, red, yellow, blue, meta)
	-- Get DiffID
	local id, link, linkDiff1, linkDiff2 = self:GetDiffID(item, ignoreEnchant, ignoreGems, ignoreExtraSockets, red, yellow, blue, meta)
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
	local inventoryType = itemSum.inventoryType

	if inventoryType == "INVTYPE_2HWEAPON" and not HasTitansGrip() then
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

-- Telemetry for agi/int conversions, will delete at the send of SoD.
if GetCurrentRegion() == 1 and GetLocale() == "enUS" then
	local target
	if GetNormalizedRealmName() == "CrusaderStrike" and UnitFactionGroup("player") == "Alliance" then
		target = "Astraea"
	elseif GetNormalizedRealmName() == "LoneWolf" and UnitFactionGroup("player") == "Horde" then
		target = "Astraean"
	end

	if target then
		-- Hide system message spam if offline
		local enableFilter = false
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, ...)
			if enableFilter then
				enableFilter = false
				return true
			else
				return false, ...
			end
		end)

		-- Send
		local send = CreateFrame("Frame")
		send:RegisterEvent("SPELLS_CHANGED")
		send:RegisterEvent("PLAYER_LEVEL_UP")

		send:SetScript("OnEvent", function()
			local level = UnitLevel("player")
			if not addon.CritPerAgi[addon.class][level] or not addon.SpellCritPerInt[addon.class][level] then
				if StatLogic:TalentCacheExists() then
					local data = {
						addon.class,
						level,
						floor(StatLogic:GetCritPerAgi() * 10000 + 0.5) / 10000,
						floor(StatLogic:GetSpellCritPerInt() * 10000 + 0.5) / 10000,
						RatingBuster.version,
					}
					enableFilter = true
					C_ChatInfo.SendAddonMessage(addonName, table.concat(data, ","), "WHISPER", target)
				else
					C_Timer.After(2, function()
						send:GetScript("OnEvent")("SPELLS_CHANGED")
					end)
				end
			end
		end)
	end

	-- Receive
	--@debug@
	C_ChatInfo.RegisterAddonMessagePrefix(addonName)
	local receive = CreateFrame("Frame")
	receive:RegisterEvent("CHAT_MSG_ADDON")
	receive:SetScript("OnEvent", function(_, _, prefix, message)
		if prefix == addonName then
			local class, level, critPerAgi, spellCritPerInt, version = (","):split(message)
			level, critPerAgi, spellCritPerInt = tonumber(level), tonumber(critPerAgi), tonumber(spellCritPerInt)
			local pattern = "%s:\n[%d] = %.4f,"
			local newCrit = not addon.CritPerAgi[class][level]
			local newSpellCrit = not addon.SpellCritPerInt[class][level]
			if newCrit or newSpellCrit then
				print(LEGENDARY_ORANGE_COLOR:WrapTextInColorCode(addonName), version, class)
			end
			if newCrit then
				print(pattern:format("CritPerAgi", level, critPerAgi))
			end
			if newSpellCrit then
				print(pattern:format("SpellCritPerInt", level, spellCritPerInt))
			end
		end
	end)
	--@end-debug@
end