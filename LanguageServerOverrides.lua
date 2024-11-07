---@meta

---@class ClassicGameTooltip : GameTooltip
local ClassicGameTooltip = {}

---@return integer
function ClassicGameTooltip:NumLines() end

---@return Frame?
function ClassicGameTooltip:GetOwner() end

---@param school 1|2|3|4|5|6|7
---@return number
function GetSpellCritChance(school) end