local addon = {}

local StatLogic = {
	Stats = {
		Stamina = setmetatable({}, {
			__tostring = function()
				return "Stamina"
			end,
		}),
		Intellect = setmetatable({}, {
			__tostring = function()
				return "Intellect"
			end,
		}),
	},
	SocketColor = {},
}

local function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

getmetatable("").__index.trim = trim

local proxies = {}
local statPatternMeta = {
	__newindex = function(t, k, v)
		if k then
			if not proxies[t] then
				proxies[t] = {}
			end
			-- Prefer non-reductions over reductions for colliding string keys
			if not proxies[t][k] or not v.reduction then
				-- Force keys to be UTF8-lowercase
				proxies[t][k:lower()] = v
			end
		end
	end,
	__index = function(t, k)
		if proxies[t] then
			return proxies[t][k]
		end
	end
}

local lowerMeta = {
	__newindex = function(t, k, v)
		rawset(t, k:lower(), v)
	end,
}

-----------------------
-- Whole Text Lookup --
-----------------------
-- Strings without numbers; mainly used for enchants or easy exclusions
---@type { [string]: WholeTextEntry }
addon.WholeTextLookup = setmetatable({}, statPatternMeta)

local function setPrefixPatterns(input, output)
	for _, pattern in ipairs(input) do
		output["^" .. pattern .. " *"] = true
	end
end

---@type table<string, true>
addon.TrimmedPrefixes = {}

local trimmedPrefixes = {
	"Equip: ",
	" +",
}

setPrefixPatterns(trimmedPrefixes, addon.TrimmedPrefixes)

---@type table<string, true>
addon.SocketBonusPrefixes = {}

local socketBonusPrefixes = {
	("Socket Bonus: "):format("")
}

setPrefixPatterns(socketBonusPrefixes, addon.SocketBonusPrefixes)

-- Patterns that should be matched for breakdowns, but ignord for summaries
---@type table<string, true>
addon.IgnoreSum = setmetatable({}, lowerMeta)

addon.OnUseCooldown = "NOOP"

addon.ReforgeSuffix = "NOOP"

addon.StatIDLookup = setmetatable({
	["stamina %s"] = { { StatLogic.Stats.Stamina } },
	["your attacks have a chance to grant %s intellect for %s sec.  (%s% chance, %s sec cooldown)"] = { { StatLogic.Stats.Intellect, }, false, false, false, ignoreSum = true } -- s146047
}, statPatternMeta)

local DEBUG = true

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

---@param output string
---@param log_level? log_level
---@param prefix? string
local function log(output, log_level, prefix)
	if DEBUG and output ~= "" then
		local text = output
		if prefix then
			print("  " .. prefix, "\"" .. text .. "\"")
		else
			print(text)
		end
	end
end

local EmptySocketColors = {
	["Meta Socket"]      = StatLogic.SocketColor.Meta,
	["Red Socket"]       = StatLogic.SocketColor.Red,
	["Yellow Socket"]    = StatLogic.SocketColor.Yellow,
	["Blue Socket"]      = StatLogic.SocketColor.Blue,
	["Cogwheel Socket"]  = StatLogic.SocketColor.Cogwheel,
	["Prismatic Socket"] = StatLogic.SocketColor.Prismatic,
}

do
	local large_sep = (","):gsub("[-.]", "%%%1")
	local dec_sep = ("."):gsub("[-.]", "%%%1")
	local numberPattern = "([+-]?[%d." .. large_sep .. dec_sep .. "]+%f[%D])()"

	local function addOffset(positions, offsets, position, offset)
		if not offsets[position] then
			table.insert(positions, position)
			table.sort(positions)
		end

		print(string.format("addOffset position: %d offset: %d", position, offset))

		local previousOffset = 0
		for i, pos in ipairs(positions) do
			print(string.format("addOffset loop i: %d pos: %d", i, pos))
			if pos <= position then
				previousOffset = offsets[pos] or previousOffset
				if pos == position then
					offsets[pos] = previousOffset + offset
				end
				-- previousOffset = offsets[pos] or 0
			else
				local newPosition = pos - offset
				local newOffset = offsets[pos] + offset
				positions[i] = newPosition
				print(string.format("Updated pos from %d to %d with offset %d", pos, positions[i], offsets[pos] + offset))

				offsets[pos] = nil
				offsets[newPosition] = newOffset
			end
		end

		table.sort(positions)
		print("offsets[" .. position .. "]=" .. offsets[position], offset)
	end

	local function getOffset(positions, offsets, position)
		local offset = 0
		for _, pos in ipairs(positions) do
			if position >= pos then
				offset = offsets[pos]
			else
				break
			end
		end
		return offset
	end

	---@param statGroups StatGroupValues
	---@param statGroup StatGroup
	---@param value integer
	---@param itemLink string
	---@param color ColorMixin
	local function AddStat(statGroups, statGroup, value, itemLink, color, position)
		table.insert(statGroups, {
			statGroup = statGroup,
			value = value,
			position = position
		})
	end

	-- Removes each of the prefixes from text, and returns the modified text and the total number of removed characters
	---@param text string
	---@param prefixes table<string, true>
	---@return string
	---@return integer
	local function trimPrefixes(text, prefixes)
		for prefix in pairs(prefixes) do
			local _, length = text:find(prefix)
			if length then
				text = text:sub(length + 1)
				return text, length
			end
		end
		return text, 0
	end

	---@param statGroupValues StatGroupValues
	local function logStatGroups(statGroupValues)
		if not DEBUG then return end
		local outputText = {}
		for _, statGroupValue in ipairs(statGroupValues) do
			local statGroupText
			if statGroupValue.statGroup then
				local statText = {}
				for _, stat in ipairs(statGroupValue.statGroup) do
					table.insert(statText, tostring(stat))
				end
				statGroupText = table.concat(statText, ",")
			else
				statGroupText = tostring(statGroupValue.statGroup)
			end
			table.insert(outputText, statGroupText .. "=" .. tostring(statGroupValue.value))
		end
		if statGroupValues.ignoreSum then
			table.insert(outputText, "ignoreSum=true")
		end
		local output = "    " .. table.concat(outputText, ", ")
		log(output)
	end

	--- Given a line of text and its color from a tooltip, returns the stat values it represents,
	--- grouped and ordered by the literal digits in the text that they belong to
	---@param text string
	---@param itemLink string
	---@param color ColorMixin
	---@return StatGroupValues
	function StatLogic:GetStatGroupValues(text, itemLink, color)
		---@type StatGroupValues
		local statGroups = { ignoreSum = false }
		local found = not text or text == ""
		local length = 0

		---@type { [integer]: integer }
		local positions = {}
		---@type { [integer]: integer }
		local offsets = {}

		if not found then
			-- Strip color codes
			print(text)
			text = text:gsub("()|c%x%x%x%x%x%x%x%x", function(position)
				addOffset(positions, offsets, position, 10)
				return ""
			end)
			print(text)
			text = text:gsub("()|r", function(position)
				addOffset(positions, offsets, position, 2)
				return ""
			end)
			print(text)

			-- Strip textures
			text = text:gsub("()(|T.-|t)", function(position, texture)
				addOffset(positions, offsets, position, #texture)
				return ""
			end)
			print(text)
		end
		local rawText = text
		statGroups.socketColor = EmptySocketColors[text]

		-----------------------
		-- Whole Text Lookup --
		-----------------------
		-- Strings without numbers; mainly used for enchants or easy exclusions
		if not found then
			-- Strip leading "Equip: ", trailing ".", and lowercase
			text, length = trimPrefixes(text, addon.TrimmedPrefixes)
			addOffset(positions, offsets, 1, length)
			-- Strip leading "Socket Bonus: "
			text, length = trimPrefixes(text, addon.SocketBonusPrefixes)
			addOffset(positions, offsets, 1, length)
			if length > 0 then
				statGroups.isSocketBonus = true
			end
			text = text:trim()
			text = text:gsub("%.$", "")
			text = text:lower()

			---@type WholeTextEntry
			local statList = addon.WholeTextLookup[text]
			if statList ~= nil then
				found = true
				if statList then
					log(rawText, "Success", "WholeText")
					for stat, value in pairs(statList) do
						AddStat(statGroups, { stat }, value, itemLink, color)
					end
					logStatGroups(statGroups)
				else
					log(rawText, "Exclude", "WholeText")
				end
			end
		end

		-------------------------
		-- Substitution Lookup --
		-------------------------
		local statText = ""
		if not found then
			text, length = trimPrefixes(text, addon.IgnoreSum)
			addOffset(positions, offsets, 1, length)
			if length > 0 then
				text = text:gsub(addon.OnUseCooldown, ""):trim():gsub("%.$", "")
				statGroups.ignoreSum = true
			else
				text = text:gsub(addon.ReforgeSuffix, "")
			end

			-- Replace numbers with %s
			local valuePositions = {}
			local count = 0
			statText, count = text:gsub(numberPattern, function(match, position)
				match = match:gsub(large_sep, ""):gsub(dec_sep, ".")
				local value = tonumber(match)
				if value then
					local offset = getOffset(positions, offsets, position)
					print(string.format("pos %d + offset %d = %d", position, offset, position - 1 + offset))
					valuePositions[#valuePositions + 1] = { value, position - 1 + offset }
					return "%s"
				end
			end)
			if count > 0 then
				statText = statText:trim()
				-- Lookup exact sanitized string in StatIDLookup
				---@type SubstitutionEntry
				local statList = addon.StatIDLookup[statText]
				if statList then
					found = true
					log(rawText, "Success", "Substitution")
					for i, valuePosition in ipairs(valuePositions) do
						local statGroup = statList[i]
						local value, position = table.unpack(valuePosition)
						if statList.reduction then
							value = value * -1
						end
						print(position, value)
						AddStat(statGroups, statGroup, value, itemLink, color, position)
					end
					if statList.ignoreSum then
						statGroups.ignoreSum = true
					end
					logStatGroups(statGroups)
				end
			else
				-- Contained no numbers, so we can exclude it
				found = true
				log(rawText, "Exclude", "Substitution")
			end
		end

		-- Reduce noise while debugging missing patterns
		if DEBUG then
			-- If the string contains a number and was not excluded,
			-- it might be a missing stat we want to add.
			if not found then
				log(rawText, "Fail", "Missed")
				log(statText, "Fail", "Missed")
			end
		end

		return statGroups
	end
end

-- Correct positions:
-- 97
-- 116
-- 126
-- 139
local test1 = "|TInterface\\Tooltips\\ReforgeGreenArrow:0:|t Your attacks have a chance to grant |cff8ab9f113,274 Intellect|r for 20 sec.  (15% chance, 115 sec cooldown)"
local statGroupValues = StatLogic:GetStatGroupValues(test1, "", {})
for _, sgv in ipairs(statGroupValues) do
	print(sgv.value, sgv.position, test1:sub(sgv.position))
end

local test2 = "stamina 17"
local statGroupValues = StatLogic:GetStatGroupValues(test2, "", {})
for _, sgv in ipairs(statGroupValues) do
	print(sgv.value, sgv.position, test2:sub(sgv.position))
end