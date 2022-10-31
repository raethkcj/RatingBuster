local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local tinsert = table.insert

local function Escape(text)
   return text:lower():gsub("[().+%-*?%%[^$]", "%%%1"):gsub("%%%%s", "(.+)")
end

L.PreScanPatterns[Escape(DPS_TEMPLATE)] = "DPS"

L.DualStatPatterns[Escape(DAMAGE_TEMPLATE)] = {{"MIN_DAMAGE"}, {"MAX_DAMAGE"}}
