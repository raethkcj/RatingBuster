local addonName, addon = ...

---@class StatLogic
local StatLogic = LibStub(addonName)

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

-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection

-------------------
-- Set Debugging --
-------------------
local DEBUG = false
function StatLogic:ToggleDebugging()
	DEBUG = not DEBUG
	wipe(cache)
end

---@enum (key) log_level
local log_level_colors = {
	["Success"] = {GREEN_FONT_COLOR, DIM_GREEN_FONT_COLOR},
	["Fail"] = {RED_FONT_COLOR, DULL_RED_FONT_COLOR},
	["Exclude"] = {GRAY_FONT_COLOR, LIGHTGRAY_FONT_COLOR},
}
setmetatable(log_level_colors, {
	__index = function()
		return {ORANGE_FONT_COLOR, NORMAL_FONT_COLOR}
	end
})

---@param output string|table
---@param log_level? log_level
---@param prefix? string
local function log(output, log_level, prefix)
	if DEBUG and output ~= "" then
		local prefix_color, text_color = unpack(log_level_colors[log_level])
		local text = type(output) == "table" and ("    " .. table.concat(output, ", ")) or output
		if prefix then
			print(prefix_color:WrapTextInColorCode("  " .. prefix), text_color:WrapTextInColorCode("\"" .. text .. "\""))
		else
			print(text_color:WrapTextInColorCode(text))
		end
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
	-- That means spells with EffectAura 57 or 290, and, separately, EffectAura 71 or 552 whose final digit of EffectMiscValue_0 is an odd number
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
						if mod.stack then
							aura.stacks = mod.max_stacks
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
					local name, _, stacks, _, _, _, _, _, _, spellId = UnitBuff("player", i)
					if name then
						aura_cache[name] = {
							spellId = spellId,
							stacks = stacks,
						}
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
					local name, _, stacks, _, _, _, _, _, _, spellId = UnitDebuff("player", i)
					if name then
						aura_cache[name] = {
							spellId = spellId,
							stacks = stacks,
						}
					end
					i = i+1
				until not name
				needs_update = false
			end
			return aura_cache[buff]
		end
	end
end

-- Maps weapon subclasses to stat, value tuples
addon.WeaponRacials = {}

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
		validate = function(case, statModName)
			return StatLogic:GetAuraInfo(GetSpellInfo(case.aura), StatLogic.StatModIgnoresAlwaysBuffed[statModName])
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
	mastery = {
		validate = function(case)
			local spec = GetPrimaryTalentTree()
			if spec then
				local mastery1, mastery2 = GetTalentTreeMasterySpells(spec)
				return case.mastery == mastery1 or case.mastery == mastery2
			end
		end,
		events = {
			["PLAYER_TALENT_UPDATE"] = true,
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

local function ValidateStatMod(statModName, case)
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
					table.insert(addon.StatModCacheInvalidators[key], statModName)
				end
			end

			if validator.validate and not validator.validate(case, statModName) then
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

	local function ApplyMod(currentValue, newValue, initialValue)
		if initialValue == 0 then
			currentValue = currentValue + newValue
		else
			currentValue = currentValue * (newValue + 1)
		end
		return currentValue
	end

	local function RemoveMod(currentValue, newValue, initialValue)
		if initialValue == 0 then
			currentValue = currentValue - newValue
		else
			currentValue = currentValue / (newValue + 1)
		end
		return currentValue
	end

	local GetStatModValue = function(statModName, currentValue, case, initialValue)
		if not ValidateStatMod(statModName, case) then
			return currentValue
		end

		local newValue
		if case.tab and case.num then
			-- Talent Rank
			local r = select(5, StatLogic:GetOrderedTalentInfo(case.tab, case.num))
			if case.rank then
				newValue = case.rank[r]
			elseif r > 0 then
				newValue = case.value
			end
		elseif case.aura and case.rank then
			local aura = StatLogic:GetAuraInfo(GetSpellInfo(case.aura))
			local rank = aura.rank or GetPlayerBuffRank(aura.spellId)
			newValue = case.rank[rank]
		elseif case.aura and case.stack then
			local aura = StatLogic:GetAuraInfo(GetSpellInfo(case.aura))
			newValue = case.stack * aura.stacks
		elseif case.regen then
			newValue = case.regen()
		elseif case.value then
			newValue = case.value
		elseif case.level then
			newValue = case.level[UnitLevel("player")]
		elseif case.tooltip then
			local aura = StatLogic:GetAuraInfo(GetSpellInfo(case.aura))
			newValue = aura.tooltip
		end

		if newValue then
			if case.group then
				local oldValue = BuffGroupCache[case.group]
				if oldValue and newValue > oldValue then
					currentValue = RemoveMod(currentValue, oldValue, initialValue)
				end
				if not oldValue or newValue > oldValue then
					currentValue = ApplyMod(currentValue, newValue, initialValue)
					BuffGroupCache[case.group] = newValue
				end
			else
				currentValue = ApplyMod(currentValue, newValue, initialValue)
			end
		end

		return currentValue
	end

	function StatLogic:GetStatMod(statModName)
		local value = StatModCache[statModName]

		if not value then
			wipe(BuffGroupCache)
			local statModInfo = StatLogic.StatModInfo[statModName]
			value = statModInfo.initialValue
			for _, categoryTable in pairs(StatLogic.StatModTable) do
				if categoryTable[statModName] then
					for _, case in ipairs(categoryTable[statModName]) do
						value = GetStatModValue(statModName, value, case, statModInfo.initialValue)
					end
				end
			end

			value = value + statModInfo.finalAdjust
			StatModCache[statModName] = value
		end

		return value
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

	local function AddStat(id, value, currentStats)
		if id == StatLogic.Stats.Armor then
			local base, bonus = StatLogic:GetArmorDistribution(statTable.link, value, currentColor)
			value = base
			AddStat(StatLogic.Stats.BonusArmor, bonus, currentStats)
		end
		statTable[id] = (statTable[id] or 0) + tonumber(value)
		table.insert(currentStats, tostring(id) .. "=" .. tostring(value))
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
			local racial = addon.WeaponRacials[itemSubclass]
			if racial then
				local stat, value = unpack(racial)
				statTable[stat] = value
			end
		end

		log(link)
		for i = 2, tip:NumLines() do
			for _, side in pairs(tip.sides) do
				local fontString = side[i]
				local text = fontString:GetText()
				local found = not text or text == ""

				if not found then
					-- Strip color codes
					text = text:gsub("^|c%x%x%x%x%x%x%x%x", "")
					text = text:gsub("|r$", "")
				end
				local rawText = text

				-----------------------
				-- Whole Text Lookup --
				-----------------------
				-- Strings without numbers; mainly used for enchants or easy exclusions
				if not found then
					-- Limit to one line
					text = text:gsub("\n.*", "")
					-- Strip leading "Equip: ", "Socket Bonus: ", trailing ".", and lowercase
					text = text:gsub(ITEM_SPELL_TRIGGER_ONEQUIP, "")
					text = text:gsub(ITEM_SOCKET_BONUS:format(""), "")
					text = text:trim()
					text = text:gsub("%.$", "")
					text = text:utf8lower()

					currentColor = CreateColor(fontString:GetTextColor())

					local idTable = addon.WholeTextLookup[text]
					if idTable ~= nil then
						found = true
						if idTable then
							log(rawText, "Success", "WholeText")
							local currentStats = {}
							for id, value in pairs(idTable) do
								AddStat(id, value, currentStats)
							end
							log(currentStats)
						else
							log(rawText, "Exclude", "WholeText")
						end
					end
				end

				-------------------------
				-- Substitution Lookup --
				-------------------------
				if not found then
					-- Replace numbers with %s
					local values = {}
					local statText, count = text:gsub("[+-]?[%d%.]+%f[%D]", function(match)
						local value = tonumber(match)
						if value then
							values[#values + 1] = value
							return "%s"
						end
					end)
					if count > 0 then
						statText = statText:trim()
						-- Lookup exact sanitized string in StatIDLookup
						local stats = addon.StatIDLookup[statText]
						if stats then
							found = true
							log(rawText, "Success", "Substitution")
							local currentStats = {}
							for j, value in ipairs(values) do
								local idTable = stats[j]
								if type(idTable) == "table" and #idTable > 0 then
									for _, id in ipairs(idTable) do
										if id then
											AddStat(id, value, currentStats)
										end
									end
								elseif idTable then
									AddStat(idTable, value, currentStats)
								end
							end
							log(currentStats)
						end
					else
						-- Contained no numbers, so we can exclude it
						found = true
						log(rawText, "Exclude", "Substitution")
					end
				end

				-- Reduce noise while debugging missing patterns
				if DEBUG then
					-- Exclude strings by 3-5 character prefixes
					if not found then
						if addon.PrefixExclude[rawText:utf8sub(1, addon.PrefixExcludeLength)] or rawText:sub(1, 1) == '"' then
							found = true
							log(rawText, "Exclude", "Prefix")
						end
					end

					-- Exclude lines that are not white, green, or "normal" (normal for Frozen Wrath etc.)
					if not found then
						local _, g, b = currentColor:GetRGB()
						if g < 0.8 or (b < 0.99 and b > 0.1) then
							found = true
							log(rawText, "Exclude", "Color")
						end
					end

					-- Iterates a few obvious patterns, matching the whole string
					if not found then
						for pattern in pairs(addon.PreScanPatterns) do
							if rawText:find(pattern) then
								found = true
								log(rawText, "Exclude", "PreScan")
								break
							end
						end
					end

					-- If the string contains a number and was not excluded,
					-- it might be a missing stat we want to add.
					if not found then
						log(rawText, "Fail", "Missed")
					end
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

			-- If found, subtract. Else, assume it's all bonus armor.
			armor = armorSubclassTable and armorSubclassTable[itemLevel] or 0
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
if GetCurrentRegion() == 1 or GetCurrentRegion() == 72 and GetLocale() == "enUS" then
	local commsVersion = 1
	local prefix = addonName .. commsVersion
	local codec = LibStub("LibDeflate"):CreateCodec("\000", "\255", "")

	local function InitializeComms()
		local target
		if GetNormalizedRealmName() == "CrusaderStrike" and UnitFactionGroup("player") == "Alliance" then
			target = "Astraea"
		elseif GetNormalizedRealmName() == "LoneWolf" and UnitFactionGroup("player") == "Horde" then
			target = "Astraean"
		elseif GetNormalizedRealmName() == "Whitemane" and UnitFactionGroup("player") == "Horde" and tocversion >= 30000 then
			target = "Pinstripe"
		elseif GetNormalizedRealmName() == "Whitemane" and UnitFactionGroup("player") == "Alliance" and tocversion >= 30000 then
			target = "Astriea"
		elseif GetNormalizedRealmName() == "ClassicEraPTR" and UnitFactionGroup("player") == "Horde" then
			target = "Rbshaman"
		end

		if target then
			-- Hide system message spam if offline
			local filter = ERR_CHAT_PLAYER_NOT_FOUND_S:format(target)
			local failure = false
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_, _, message, ...)
				if message == filter then
					failure = true
					return true
				else
					return false, message, ...
				end
			end)

			local sending = false
			local function cleanUp(delay)
				-- Wait to see if whispers failed to send
				C_Timer.After(2, function()
					if not failure then
						for expansion in pairs(RatingBuster.conversion_data.global) do
							RatingBuster.conversion_data.global[expansion] = nil
						end
					end
					sending = false
				end)
			end

			-- Send
			local function SendStoredData()
				if failure or sending or UnitName("player") == target then return end
				local data = RatingBuster.conversion_data.global
				local send = false
				for i = 0, 4 do
					if data[i] then
						send = true
						break
					end
				end
				if send then
					sending = true
					local serialized = LibStub("LibSerialize"):Serialize(data)
					local encoded = codec:Encode(serialized)
					LibStub("AceComm-3.0"):SendCommMessage(prefix, encoded, "WHISPER", target, "BULK", cleanUp, true)
				end
			end

			-- Store
			local store = CreateFrame("Frame")
			store:RegisterEvent("PLAYER_LEVEL_UP")

			store:SetScript("OnEvent", function()
				if StatLogic:TalentCacheExists() and RatingBuster.conversion_data then
					local level = UnitLevel("player")
					local expansion = RatingBuster.conversion_data.global[LE_EXPANSION_LEVEL_CURRENT]
					local rounding = 10 ^ 4
					if tocversion >= 40000 then
						rounding = 10 ^ 8
					end
					if not addon.CritPerAgi[addon.class][level] then
						local critPerAgi = floor(StatLogic:GetCritPerAgi() * rounding + 0.5) / rounding
						expansion.CritPerAgi[addon.class][level] = critPerAgi
					end
					if not addon.DodgePerAgi[addon.class][level] then
						local dodgePerAgi = floor(StatLogic:GetDodgePerAgi() * rounding + 0.5) / rounding
						expansion.DodgePerAgi[addon.class][level] = dodgePerAgi
					end
					if not addon.SpellCritPerInt[addon.class][level] then
						local spellCritPerInt = floor(StatLogic:GetSpellCritPerInt() * rounding + 0.5) / rounding
						expansion.SpellCritPerInt[addon.class][level] = spellCritPerInt
					end
					SendStoredData()
				else
					C_Timer.After(2, function()
						store:GetScript("OnEvent")("PLAYER_LEVEL_UP")
					end)
				end
			end)
			store:GetScript("OnEvent")("PLAYER_LEVEL_UP")
		end
	end

	EventRegistry:RegisterFrameEventAndCallback("PLAYER_LOGIN", function(handle)
		-- Annoying workaround for stats from ItemEffects
		-- not existing the first time you see an item's tooltip
		C_Timer.After(0, function()
			for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
				local link = GetInventoryItemLink("player", i)
				if link then
					StatLogic:GetSum(link)
				end
			end
			C_Timer.After(0, InitializeComms)
		end)

		EventRegistry:UnregisterFrameEvent("PLAYER_LOGIN", handle)
	end)

	-- Receive
	--@debug@
	local receive = {}
	function receive:OnCommReceived(_, message)
		local decoded = codec:Decode(message)
		if not decoded then return end
		local success, data = LibStub("LibSerialize"):Deserialize(decoded)
		if not success then return end
		local count = 0
		for expansion, conversions in pairs(data) do
			for conversion, classes in pairs(conversions) do
				for class, levels in pairs(classes) do
					for level, value in pairs(levels) do
						local current = addon[conversion][class][level]
						if expansion ~= LE_EXPANSION_LEVEL_CURRENT or not current then
							local valid = true
							for i = level - 1, 1, -1 do
								local lesserValue = addon[conversion][class][i]
								if lesserValue then
									if value > lesserValue then
										valid = false
									end
									break
								end
							end
							if valid then
								local old = RatingBuster.conversion_data.global[expansion][conversion][class][level]
								if old and value ~= old then
									print(("[%d][%s][%s][%d] from %.4f to %.4f"):format(expansion, conversion, class, level, old, value))
								end
								RatingBuster.conversion_data.global[expansion][conversion][class][level] = value
								if not old then
									count = count + 1
								end
							end
						end
					end
				end
			end
		end
		if count > 0 then
			print("StatLogic: Received", count, "new conversions!")
		end
	end
	LibStub("AceComm-3.0").RegisterComm(receive, prefix)
	--@end-debug@
end